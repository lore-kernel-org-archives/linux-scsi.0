From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 03/12] libata, libsas: introduce sched_eh and end_eh port ops
Date: Mon, 23 Apr 2012 12:41:53 -0700
Message-ID: <CABE8wwuCOmwsHkDH5RQTsKRh=JhUZ7oGR1eMeLrpO_sO=9Xpug@mail.gmail.com>
References: <20120413233343.8025.18101.stgit@dwillia2-linux.jf.intel.com>
	<20120413233706.8025.56546.stgit@dwillia2-linux.jf.intel.com>
	<1335115828.13208.31.camel@dabdike.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga12.intel.com ([143.182.124.36]:39835 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753989Ab2DWTl4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Apr 2012 15:41:56 -0400
Received: by bkcji2 with SMTP id ji2so1198982bkc.25
        for <linux-scsi@vger.kernel.org>; Mon, 23 Apr 2012 12:41:53 -0700 (PDT)
In-Reply-To: <1335115828.13208.31.camel@dabdike.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>

On Sun, Apr 22, 2012 at 10:30 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2012-04-13 at 16:37 -0700, Dan Williams wrote:
>> When managing shost->host_eh_scheduled libata assumes that there is =
a
>> 1:1 shost-to-ata_port relationship. =A0libsas creates a 1:N relation=
ship
>> so it needs to manage host_eh_scheduled cumulatively at the host lev=
el.
>> The sched_eh and end_eh port port ops allow libsas to track when dom=
ain
>> devices enter/leave the "eh-pending" state under ha->lock (previousl=
y
>> named ha->state_lock, but it is no longer just a lock for ha->state
>> changes).
>>
>> Since host_eh_scheduled indicates eh without backing commands pinnin=
g
>> the device it can be deallocated at any time. =A0Move the taking of =
the
>> domain_device reference under the port_lock to guarantee that the
>> ata_port stays around for the duration of eh.
>
>> Cc: Tejun Heo <tj@kernel.org>
>> Acked-by: Jacek Danecki <jacek.danecki@intel.com>
>
> Could we standardise on Acked-by, please. =A0In my book it means the
> maintainer of a piece of code agrees with the change and lets me take=
 it
> through my tree. =A0I'm aware that not everyone uses this definition,=
 so
> we can use a different standard from my current one, but what does it
> mean in this case?
>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>> =A0drivers/ata/libata-core.c =A0 =A0 =A0 =A0 =A0 | =A0 =A04 ++
>> =A0drivers/ata/libata-eh.c =A0 =A0 =A0 =A0 =A0 =A0 | =A0 57 ++++++++=
++++++++++++++++++++-------
>> =A0drivers/scsi/libsas/sas_ata.c =A0 =A0 =A0 | =A0 38 ++++++++++++++=
+++++++--
>> =A0drivers/scsi/libsas/sas_discover.c =A0| =A0 =A06 ++--
>> =A0drivers/scsi/libsas/sas_event.c =A0 =A0 | =A0 12 ++++---
>> =A0drivers/scsi/libsas/sas_init.c =A0 =A0 =A0| =A0 14 ++++-----
>> =A0drivers/scsi/libsas/sas_scsi_host.c | =A0 27 +++++++++++++----
>> =A0include/linux/libata.h =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A04 ++
>> =A0include/scsi/libsas.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A04 ++
>> =A0include/scsi/sas_ata.h =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A05 +++
>> =A010 files changed, 134 insertions(+), 37 deletions(-)
>
> This is a pretty big change for rc fixes. =A0None of the other change=
s in
> the series seem to be dependent on it, what bug is it actually fixing=
?

It fixes two bugs (which in hindsight could potentially be split into
two patches).  The major one is guarantees about when
host_eh_scheduled is cleared.  Prior to this patch when at least one
ata_port in a domain has completed eh the flag for host is cleared.
This patch plus "scsi: fix eh wakeup (scsi_schedule_eh vs
scsi_restart_operations)" fixes up deadlocks (waiting indefinitely for
eh to complete) and cases where eh terminates too early
(host_eh_scheduled cleared with work pending) in our hot plug tests.

The other bug this uncovered is the fact that libsas makes use of the
port and rphy object after libata has completed it's work, so this
patch also moved the taking of the domain_device reference to be under
spin_lock_irq(&sas_ha->phy_port_lock) and
spin_lock(&port->dev_list_lock).  Otherwise,  if no commands are
pending for the device libsas can proceed directly to freeing the
domain_device before the requested eh runs.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
