From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] mpt3sas: downgrade full copy_from_user to access_ok check
Date: Thu, 21 Sep 2017 04:26:05 +0100
Message-ID: <20170921032604.GF32076@ZenIV.linux.org.uk>
References: <1505877071-76996-1-git-send-email-mengxu.gatech@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1505877071-76996-1-git-send-email-mengxu.gatech@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Meng Xu <mengxu.gatech@gmail.com>
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, meng.xu@gatech.edu, sanidhya@gatech.edu, taesoo@gatech.edu
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 19, 2017 at 11:11:11PM -0400, Meng Xu wrote:
> Since right after the user copy, we are going to
> memset(&karg, 0, sizeof(karg)), I guess an access_ok check is enough?

access_ok() is *NOT* "will copy_from_user() succeed?"  Not even close.
On a bunch of architectures (sparc64, for one) access_ok() is always
true.

All it does is checking that address is not a kernel one - e.g. on
i386 anything in range 0..3Gb qualifies.  Whether anything's mapped
at that address or not.

Why bother with that copy_from_user() at all?  The same ioctl()
proceeds to copy_to_user() on exact same range; all you get from
it is "if the area passed by caller is writable, but not readable,
fail with -EFAULT".  Who cares?

Just drop that copy_from_user() completely.  Anything access_ok()
might've caught will be caught by copy_to_user() anyway.
