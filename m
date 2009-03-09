From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Getting TRIM working
Date: Mon, 09 Mar 2009 09:52:35 -0400
Message-ID: <49B51F23.3060907@interlog.com>
References: <20090303190700.GD20511@parisc-linux.org> <49AE47DB.4030200@panasas.com> <20090306191620.GA25995@parisc-linux.org> <49B39DCB.3040203@panasas.com> <1236547480.4861.12.camel@localhost.localdomain> <1236547956.4861.17.camel@localhost.localdomain> <20090309083614.GP25995@parisc-linux.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090309083614.GP25995@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Sun, Mar 08, 2009 at 04:32:36PM -0500, James Bottomley wrote:
>> Actually, found the reason, blk_rq_map_kern will blast the original bio
>> from the request.  You could fix this by chaining it back again at the
>> beginning.  If that works, we could just wrap it into a block API to
>> prevent users from having to muck with bios.
> 
> How about constructing the TRIM entirely within libata?  I won't be able
> to test this patch until Oregon wakes up, but is this acceptable?
> 
> Advantages:
>  - Don't need to wait for T10 to finish designing UNMAP

The spc4r18.pdf and sbc3r18.pdf drafts were released recently
at t10.org. Both include thin provisioning items (e.g. see
UNMAP and WRITE SAME(16) in sbc3r18.pdf). So the design and
implementation of thin provisioning is pretty well done.

If you attempt to download these drafts you will be
challenged for a t10 login, select guest and supply a name
(e.g. "incits" is the name of the organization responsible
for this). I give "Linux" as my company.

Doug Gilbert

>  - Uses well-tested ATA_16 passthrough layer
>  - Changing the UNMAP implementation to do multiple ranges won't break TRIM
>  - Will be easier to adapt to a future separation of scsi and libata

[snip]
