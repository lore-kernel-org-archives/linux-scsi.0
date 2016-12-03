From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: scsi: use-after-free in bio_copy_from_iter
Date: Sat, 3 Dec 2016 11:38:02 +0100
Message-ID: <20161203103802.dmvqzzquthwa7kd7@linux-x5ow.site>
References: <CACT4Y+aBd+1pssnsVx2x145n7Q1nDMU=xc7NAiOCtpy-MA-EDg@mail.gmail.com>
 <CACT4Y+auCpJbXhmxbr4OmSHbiVkatyWmDxGGShs=WvO=HCXRKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+auCpJbXhmxbr4OmSHbiVkatyWmDxGGShs=WvO=HCXRKA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Doug Gilbert <dgilbert@interlog.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, axboe@kernel.dk, linux-block@vger.kernel.org, David Rientjes <rientjes@google.com>, syzkaller <syzkaller@googlegroups.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 02, 2016 at 05:50:39PM +0100, Dmitry Vyukov wrote:
> On Fri, Nov 25, 2016 at 8:08 PM, Dmitry Vyukov <dvyukov@google.com> wrote:

[...]

> 
> +David did some debugging of a similar case. His 0x400 at location
> 0x2000efdc refers to 0xffff at 0x20012fdc in the provided reproducer:
>     NONFAILING(*(uint32_t*)0x20012fdc = (uint32_t)0xffff);
> Here is his explanation:
> =====
> That's not nice, it's passing a reply_len mismatch of 0x400 which is going
> to cause an sg_write warning (in 988 bytes, out 38 bytes).  input_size
> will be 74 since count == 80, the mxsize is 0x400 (!) so after subtracting
> SZ_SG_HEADER we get the 988 bytes in.  This forces SG_DXFER_TO_FROM_DEV
> when we really want SG_DXFER_TO_DEV.  If you set the value at 0x2000efdc
> to 0x24 rather than 0x400 so there's a legitimate reply_len equal to
> SG_DXFER_TO_FROM_DEV, I'd assume this passes just fine, assuming your
> container can get enough memory.
> =====
> 
> I've tried to replace 0xffff in the provided reproducer with 0x24 and
> it indeed does not crash.

This is somewhat expected, AFAICS the value at 0x20012fdc ends up as
hp->dxfer_len in the SG driver. I did a lot of debugging (actually I spend the
whole last work week soley on this) but I can't find where it does the actual
use-after-free, so if you have anything to share I'd be glad.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
