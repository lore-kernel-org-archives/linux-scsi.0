From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 7/8] fscrypt: wire up fscrypt to use
 blk-crypto
Date: Fri, 12 Jul 2019 12:27:42 -0700
Message-ID: <20190712192742.GB701@sol.localdomain>
References: <20190710225609.192252-1-satyat@google.com>
 <20190710225609.192252-8-satyat@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190710225609.192252-8-satyat@google.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Satya Tangirala <satyat@google.com>
Cc: Ladvine D Almeida <ladvine.dalmeida@synopsys.com>, linux-scsi@vger.kernel.org, Parshuram Raju Thombare <pthombar@cadence.com>, Kuohong Wang <kuohong.wang@mediatek.com>, Barani Muthukumaran <bmuthuku@qti.qualcomm.com>, linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Satya,

On Wed, Jul 10, 2019 at 03:56:08PM -0700, Satya Tangirala wrote:
> Introduce fscrypt_set_bio_crypt_ctx for filesystems to call to set up
> encryption contexts in bios, and fscrypt_evict_crypt_key to evict
> the encryption context associated with an inode.
> 
> Inline encryption is controlled by a policy flag in the fscrypt_info
> in the inode, and filesystems may check if an inode should use inline
> encryption by calling fscrypt_inode_is_inline_crypted. Files can be marked
> as inline encrypted from userspace by appropriately modifying the flags
> (OR-ing FS_POLICY_FLAGS_INLINE_ENCRYPTION to it) in the fscrypt_policy
> passed to fscrypt_ioctl_set_policy.
> 
> To test inline encryption with the fscrypt dummy context, add
> ctx.flags |= FS_POLICY_FLAGS_INLINE_ENCRYPTION
> when setting up the dummy context in fs/crypto/keyinfo.c.
> 
> Note that blk-crypto will fall back to software en/decryption in the
> absence of inline crypto hardware, so setting up the ctx.flags in the
> dummy context without inline crypto hardware serves as a test for
> the software fallback in blk-crypto.
> 
> Signed-off-by: Satya Tangirala <satyat@google.com>

Thanks for the new patches.  I implemented a ciphertext verification test for
this new encryption policy flag, using the framework for ciphertext verification
tests I added to xfstests a few months ago.  You can get it from here:
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git/log/?h=inline-encryption
If you build a kvm-xfstests test appliance from that branch, the test can be run
with 'kvm-xfstests -c f2fs generic/700'.

Or better: run 'kvm-xfstests -c ext4,f2fs -g encrypt' to run all fscrypt tests
on ext4 and f2fs, including that one.  I recommend adding that to the testing
you do, if you haven't already.  Note that this is separate from running
xfstests with the "fscrypt dummy context" as you mention in the commit message;
see the new documentation at
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/filesystems/fscrypt.rst#n653

I found a bug.  The test passes when CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y, but
fails when CONFIG_FS_ENCRYPTION_INLINE_CRYPT=n, rather than being skipped.  This
is because the kernel incorrectly ignores the policy flag in the latter case and
produces the wrong ciphertext, rather than rejecting it in
FS_IOC_SET_ENCRYPTION_POLICY.  So that needs to be fixed.

> diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> index 335a362ee446..58a01889fac7 100644
> --- a/fs/crypto/crypto.c
> +++ b/fs/crypto/crypto.c
> @@ -302,6 +302,10 @@ int fscrypt_decrypt_page(const struct inode *inode, struct page *page,
>  	if (!(inode->i_sb->s_cop->flags & FS_CFLG_OWN_PAGES))
>  		BUG_ON(!PageLocked(page));
>  
> +	/* If we have HW encryption, then this page is already decrypted */
> +	if (fscrypt_inode_is_inline_crypted(inode))
> +		return 0;
> +
>  	return fscrypt_do_page_crypto(inode, FS_DECRYPT, lblk_num, page, page,
>  				      len, offs, GFP_NOFS);
>  }

As I mentioned on v2, the purpose of this function is to decrypt the page.  The
filesystem also has to allocate a decryption context and schedule a workqueue
item specifically to call this -- only for it to be a no-op in this new case
this patch adds.  I think the more logical approach would be for the filesystem
to not call this at all if the inode is using inline encryption instead.

> +#ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
> +bool fscrypt_inode_is_inline_crypted(const struct inode *inode)
> +{
> +	struct fscrypt_info *ci;
> +
> +	if (!inode)
> +		return false;
> +	ci = inode->i_crypt_info;
> +
> +	return ci && flags_inline_crypted(ci->ci_flags, inode);
> +}
> +EXPORT_SYMBOL(fscrypt_inode_is_inline_crypted);

What does it mean for the inode to be NULL here?

This also returns false whenever the inode's encryption key hasn't been set up,
even though the inode may use an encryption policy with the inline encryption
optimized flag set.  Why?  Also, because ->i_crypt_info is set locklessly, if
it's being dereferenced conditionally it needs to be loaded with READ_ONCE().

So I'm confused about exactly what this is trying to do, and the lack of a
kerneldoc comment doesn't help :-(

But AFAICS, this is only called if the encryption key is available.
So I think the following would be better:

bool fscrypt_inode_is_inline_crypted(const struct inode *inode)
{
	return flags_inline_crypted(inode->i_crypt_info->ci_flags, inode);
}

... or if it's also expected to handle unencrypted inodes,

bool fscrypt_inode_is_inline_crypted(const struct inode *inode)
{
	return IS_ENCRYPTED(inode) &&
	       flags_inline_crypted(inode->i_crypt_info->ci_flags, inode);
}

The problem with trying to be "safe" and check for NULL ->i_crypt_info is that
the fallback behavior this patch implements is to silently do the encryption
incorrectly.  I don't think that's a good idea.  If someone is incorrectly
calling this on an inode that hasn't had its key loaded yet, I'd much rather be
notified of the bug immediately and fix it.

> +
> +bool fscrypt_needs_fs_layer_crypto(const struct inode *inode)
> +{
> +	return IS_ENCRYPTED(inode) && S_ISREG(inode->i_mode) &&
> +	       !fscrypt_inode_is_inline_crypted(inode);
> +}
> +EXPORT_SYMBOL(fscrypt_needs_fs_layer_crypto);

Can you please add a kerneldoc comment for all new functions in fs/crypto/ that
are exported to filesystems?

> +	/*
> +	 * TODO: expose inline encryption via some toggleable knob
> +	 * instead of as a policy?
> +	 */
> +	if (!inode->i_sb->s_cop->inline_crypt_supp &&
> +	    (policy->flags & FS_POLICY_FLAGS_INLINE_CRYPT))
> +		return -EINVAL;
> +

This TODO doesn't make sense; the policy flag is fine.

I think the name of the flag is still confusing things.  It's not enabling
inline encryption per se (that's an implementation detail), but rather an
on-disk format that's better suited for inline encryption.

How about renaming the flag to FS_POLICY_FLAG_INLINECRYPT_OPTIMIZED, like I
suggested on v2?

- Eric
