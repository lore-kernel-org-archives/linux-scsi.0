From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: mvsas regression since 3.5
Date: Sun, 23 Dec 2012 08:44:57 +0000
Message-ID: <1356252297.15812.2.camel@dabdike.home>
References: <CAJiejCRCXgCw957to0fWhQPS69doacY9DOaQMpfyxM4bm3igQw@mail.gmail.com>
	 <50D6AFF2.1010708@gmail.com>
	 <CAJiejCQXQWztiA8ksfRmxqx969FFpuL3DXH=EXmbOkYHE6VA5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39281 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751113Ab2LWIpC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Dec 2012 03:45:02 -0500
In-Reply-To: <CAJiejCQXQWztiA8ksfRmxqx969FFpuL3DXH=EXmbOkYHE6VA5g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Drunkard Zhang <gongfan193@gmail.com>
Cc: Xi Wang <xi.wang@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Jack Wang <jack_wang@usish.com>, Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

On Sun, 2012-12-23 at 16:26 +0800, Drunkard Zhang wrote:
> > Particularly, can you first change
> >
> >   #define bit(n) ((u64)1 << n)
> >
> > in drivers/scsi/mvsas/mv_sas.h back to
> >
> >   #define bit(n) ((u32)1 << n)
> >
> > and see if it works for you?  Thanks.
> >
> 
> Thanks for reply.
> 
> This commit just applied in v3.8-rc1, so can't be it. I'm testing
> related commits too...

There are only three changes to mvsas between 3.5 and 3.7:

95ab000 [SCSI] mvsas: Fix oops when ata commond timeout.
cca8501 [SCSI] mvsas: remove unused variable in mvs_task_exec()
f0bf750 [SCSI] libsas: trim sas_task of slow path infrastructure

And of those, I can only see f0bf750 being significant, if you could
revert it?

After that, it's probably a bug introduced into libsas, which has a bit
more of a complicated history from 3.5 to 3.7:

8d8e7d1 [SCSI] libsas, ipr: cleanup ata_host flags initialization via ata_host_init
303694e [SCSI] libsas: suspend / resume support
2955b47 [SCSI] async: introduce 'async_domain' type
f0bf750 [SCSI] libsas: trim sas_task of slow path infrastructure
a494fd5 [SCSI] libsas: drop sata port multiplier infrastructure
b17caa1 [SCSI] libsas: fix sas_discover_devices return code handling
26f2f19 [SCSI] libsas: continue revalidation
b2311a2 [SCSI] libsas: sas_rediscover_dev did not look at the SMP exec status.
e7db822 [SCSI] libsas: use ->lldd_I_T_nexus_reset for ->eh_bus_reset_handler
9524c68 [SCSI] libsas: add sas_eh_abort_handler
5db45bd [SCSI] libsas: enforce eh strategy handlers only in eh context
36fed49 [SCSI] libsas: cleanup spurious calls to scsi_schedule_eh
e4a9c37 [SCSI] libata, libsas: introduce sched_eh and end_eh port ops

So I'd try a bisection rather than trying to revert individual commits
in there.

James


