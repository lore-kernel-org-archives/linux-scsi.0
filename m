From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 2/3] sd: implement START/STOP management
Date: Wed, 21 Mar 2007 11:35:09 +0900
Message-ID: <460099DD.2050706@gmail.com>
References: <20070320150718.GF6152@htj.dyndns.org> <20070320151359.GG6152@htj.dyndns.org> <460020DF.6090203@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <460020DF.6090203@torque.net>
Sender: linux-ide-owner@vger.kernel.org
To: dougg@torque.net
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, djwong@us.ibm.com, hmh@hmh.eng.br
List-Id: linux-scsi@vger.kernel.org

Hello, Douglas.

Douglas Gilbert wrote:
> Tejun,
> I note at this point that the IMMED bit in the
> START STOP UNIT cdb is clear. [The code might
> note that as well.] All SCSI disks that I have
> seen, implement the IMMED bit and according to
> the SAT standard, so should SAT layers like the
> one in libata.
> 
> With the IMMED bit clear:
>   - on spin up, it will wait until disk is ready.
>     Okay unless there are a lot of disks, in
>     which case we could ask Matthew Wilcox for help
>   - on spin down, will wait until media is
>     stopped. That could be 20 seconds, and if there
>     were multiple disks ....
> 
> I guess the question is do we need to wait until a
> disk is spun down before dropping power to it
> and suspending.

I think we do.  As we're issuing SYNCHRONIZE CACHE prior to spinning
down disks, it's probably okay to drop power early data-integrity-wise
but still...

We can definitely use IMMED=1 during resume (needs to be throttled
somehow tho).  This helps even when there is only one disk.  We can let
the disk spin up in the background and proceed with the rest of resuming
process.  Unfortunately, libata SAT layer doesn't do IMMED and even if
it does (I've tried and have a patch available) it doesn't really work
because during host resume each port enters EH and resets and
revalidates each device.  Many if not most ATA harddisks don't respond
to reset or IDENTIFY till it's fully spun up meaning libata EH has to
wait for all drives to spin up.  libata EH runs inside SCSI EH thread
meaning SCSI comman issue blocks till libata EH finishes resetting the
port.  So, IMMED or not, sd gotta wait for libata disks.

If we want to do parallel spin down, PM core needs to be updated such
that there are two events - issue and done - somewhat similar to what
SCSI is doing to probe devices parallelly.  If we're gonna do that, we
maybe can apply the same mechanism to resume path so that we can do
things parallelly IMMED or not.

Thanks.

-- 
tejun
