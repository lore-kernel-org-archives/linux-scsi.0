From: Benjamin Block <bblock@linux.ibm.com>
Subject: Re: [PATCH 6/8] bsg-lib: handle bidi requests without block layer
 help
Date: Wed, 14 Nov 2018 17:44:30 +0100
Message-ID: <20181114164430.GC7222@w530-pk1mzal>
References: <20181111133211.13926-1-hch@lst.de>
 <20181111133211.13926-7-hch@lst.de>
 <20181113143520.GB7222@w530-pk1mzal>
 <20181114154857.GA28985@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181114154857.GA28985@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, ooo@electrozaur.com, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 14, 2018 at 04:48:57PM +0100, Christoph Hellwig wrote:
> On Tue, Nov 13, 2018 at 03:35:20PM +0100, Benjamin Block wrote:
> > This seems like a non-obvious user-breakage. So apart from removing the
> > in-kernel stuff that uses bidirectional commands you also forbid
> > userspace from every using them? That seems wrong to me.
> > 
> > There is other SCSI Command Sets than OSD that provide bidirectional
> > commands, even SBC has some (i.e.  X*WRITE*, COMPARE AND WRITE).
> 
> Yes, there are a few.  But the only driver that even supports them
> right now is iscsi_tcp to start with, and we have to drag a significant
> amount of code around just to support this corner case.
> 

But we are not talking about kernel-support here, this interface is
user-facing, and for an interfaces that was made so people could send
arbitrary SCSI commands, that the kernel doesn't support.

Its probably also more complicated to make sure that no one is using
that, in contrast to the OSD stuff that - as state in the patch-letter -
never made it out of academia. Its not like anyone has to release
anything open if they use BSG/SG, its just syscalls after all.

-- 
With Best Regards, Benjamin Block      /      Linux on IBM Z Kernel Development
IBM Systems & Technology Group   /  IBM Deutschland Research & Development GmbH
Vorsitz. AufsR.: Martina Koederitz       /      Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
