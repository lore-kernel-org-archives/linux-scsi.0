From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [LSF/MM TOPIC] Fixing large block devices on 32 bit
Date: Sat, 1 Feb 2014 02:25:47 +0200
Message-ID: <20140201002547.GA3551@node.dhcp.inet.fi>
References: <1391194978.2172.20.camel@dabdike.int.hansenpartnership.com>
 <52EC19E6.9010509@intel.com>
 <1391210864.2172.61.camel@dabdike.int.hansenpartnership.com>
 <52EC3D9F.8040702@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <52EC3D9F.8040702@intel.com>
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave.hansen@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 31, 2014 at 04:19:43PM -0800, Dave Hansen wrote:
> On 01/31/2014 03:27 PM, James Bottomley wrote:
> > On Fri, 2014-01-31 at 13:47 -0800, Dave Hansen wrote:
> >> On 01/31/2014 11:02 AM, James Bottomley wrote:
> >>>      3. Increase pgoff_t and the radix tree indexes to u64 for
> >>>         CONFIG_LBDAF.  This will blow out the size of struct page on 32
> >>>         bits by 4 bytes and may have other knock on effects, but at
> >>>         least it will be transparent.
> >>
> >> I'm not sure how many acrobatics we want to go through for 32-bit, but...
> > 
> > That's partly the question: 32 bits was dying in the x86 space (at least
> > until quark), but it's still predominant in embedded.
> > 
> >> Between page->mapping and page->index, we have 64 bits of space, which
> >> *should* be plenty to uniquely identify a block.  We could easily add a
> >> second-level lookup somewhere so that we store some cookie for the
> >> address_space instead of a direct pointer.  How many devices would need,
> >> practically?  8 bits worth?
> > 
> > That might work.  8 bits would get us up to 4PB, which is looking a bit
> > high for single disk spinning rust.  However, how would the cookie work
> > efficiently? remember we'll be doing this lookup every time we pull a
> > page out of the page cache.  And the problem is that most of our lookups
> > will be on file inodes, which won't be > 16TB, so it's a lot of overhead
> > in the generic machinery for a problem that only occurs on buffer
> > related page cache lookups.
> 
> I think all we have to do is set a low bit in page->mapping

It's already in use to say page->mapping is anon_vma. ;)

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
