From: Doug Ledford <dledford@redhat.com>
Subject: Re: noisy reservation conflicts
Date: Tue, 15 Jun 2004 08:54:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087304066.3556.128.camel@compaq.xsintricity.com>
References: <40CD3F44.4080004@torque.net> <20040614191832.GA1298@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:6831 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265495AbUFOMza (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 08:55:30 -0400
In-Reply-To: <20040614191832.GA1298@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Mon, 2004-06-14 at 15:18, Mike Anderson wrote:
> Douglas Gilbert [dougg@torque.net] wrote:
> > While testing persistent reservations it is quite common
> > to get a status of "reservation conflict". When using
> > the SG_IO ioctl this status is returned via the
> > sg_io_hdr::status field and is simple to process.
> > 
> > However this lk 2.6.7-rc3 code fragment in
> > scsi_decide_disposition() [scsi_error.c] makes it very
> > noisy (on the console and in the log):
> > 
> >         case RESERVATION_CONFLICT:
> >                 printk("scsi%d (%d,%d,%d) : reservation conflict\n",
> >                        scmd->device->host->host_no,
> >                        scmd->device->channel,
> >                        scmd->device->id, scmd->device->lun);
> >                 return SUCCESS; /* causes immediate i/o error */
> > 
> 
> If we think it is important enough to leave we should wrap it with
> either a SCSI_LOG_MLCOMPLETE or SCSI_LOG_ERROR_RECOVERY to stay
> consistent with the scsi_decide_disposition function. Though I think the
> use of SCSI_LOG_ERROR_RECOVERY maybe should be replaced with
> SCSI_LOG_MLCOMPLETE in scsi_decide_disposition.
> 
> The upper level drivers could also report similar info if this was
> removed as sd has SCSI_LOG_HLCOMPLETE that should cover sg_io ios
> through sd and sg_cmd_done has SCSI_LOG_TIMEOUT (correct?).

Sounds reasonable, but if you are going to be changing this anyway...you
might as well put in the STONITH option.  In order for scsi reservations
to be a reliable method of host interaction control on a shared device,
you need the ability for a reservation conflict to cause the machine
that got the conflict to fall over dead (aka STONITH, Shoot The Other
Node In The Head).  If you don't have a remote controlled power switch,
then you can implement this in the SCSI stack with a panic on
reservation conflict.  The basic scenario then is that in a multi-node
failover cluster, the primary machine starts up and gets the
reservation, then as long as it holds it everything is fine.  If the
primary machine fails its status check by the failover node, then the
failover node can cause a bus reset, steal the reservation, and pick up
where the main node left off (speaking specifically of SCSI-2
reservations here obviously).  In that case, the next time the main node
tries to access the device, it will get a reservation conflict and that
is the main node's signal to panic/reboot and come back as the new
failover node with the failover node now the primary node.  Simple 4
line change required to make SCSI-2 reservations useful.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


