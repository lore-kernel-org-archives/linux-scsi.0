From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: aic94xx IO errors with "escb_tasklet_complete: phy0: REQ_TASK_ABORT"
Date: Wed, 4 Oct 2006 22:56:21 +0200
Message-ID: <20061004205621.GF5091@rhun.haifa.ibm.com>
References: <20061004164438.GC5091@rhun.haifa.ibm.com> <20061004132929.A29689@florence.linkmargin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:19054 "EHLO
	mtagate3.uk.ibm.com") by vger.kernel.org with ESMTP
	id S1751120AbWJDU4Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Oct 2006 16:56:24 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate3.uk.ibm.com (8.13.8/8.13.8) with ESMTP id k94KuN5n033978
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 21:56:23 +0100
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k94Kwksl1618002
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 21:58:46 +0100
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k94KuM9i000369
	for <linux-scsi@vger.kernel.org>; Wed, 4 Oct 2006 21:56:23 +0100
Content-Disposition: inline
In-Reply-To: <20061004132929.A29689@florence.linkmargin.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Warner <andyw@pobox.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

On Wed, Oct 04, 2006 at 01:29:29PM -0500, Andy Warner wrote:
> Muli Ben-Yehuda wrote:
> > [resending as it probably hit the 100K limit the first time]
> > 
> > I'm seeing these aic94xx IO errors on an IBM x366, usually after I
> > copy ~20GB but occasionally as soon as heavy IO starts. Happens with
> > and without Calgary enabled (iommu=off). I'm seeing this on two
> > different disks which badblocks claims are ok. The machine usually
> > stays up and keeps chugging along after this happens.
> 
> Since you're working in this area,

Not really... I just need aic94xx working reliably so that when it
breaks, I can be reasonably certain it's because I broke Calgary :-)

> the processing for REQ_TASK_ABORT, REQ_DEVICE_RESET,
> SIGNAL_NCQ_ERROR and CLEAR_NCQ_ERROR needs fixing as all 4 events
> collapse to REQ_TASK_ABORT, because sb_opcode is masked with
> ~DL_PHY_MASK before the switch() in escb_tasklet_complete(). In
> unpatched code, check the phy number reported in the REQ_TASK_ABORT
> message:
> 
>   0 => REQ_TASK_ABORT
>   1 => REQ_DEVICE_RESET
>   2 => SIGNAL_NCQ_ERROR
>   3 => CLEAR_NCQ_ERROR
> 
> So you are seeing legitimate REQ_TASK_ABORT values, but need to look
> at the remaining data to see what the chip is trying to tell you.
> For REQ_TASK_ABORT, status_block[1..2] is the transaction context,
> and status_block[3] is the reason (TC_NO_ERROR etc from
> aic94xx_sas.h)

Using your patch (thanks!) I get 

aic94xx: escb_tasklet_complete: REQ_TASK_ABORT, reason 0x05

which corresponds to TI_BREAK.

Is an old firmware version ("Razor_10a1") expected to work with the
aic94xx in mainline? alternatively, is the new firmware version
("V17/10c6") expected to work with older aic94xx versions? if either
is true, I can try that tomorrow to see if firmware version makes a
difference with the bad aic94xx.

Cheers,
Muli
