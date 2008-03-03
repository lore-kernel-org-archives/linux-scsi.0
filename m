From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mvsas: fix default can_queue
Date: Mon, 03 Mar 2008 08:59:31 -0600
Message-ID: <1204556371.3043.7.camel@localhost.localdomain>
References: <1204308113.4003.45.camel@localhost.localdomain>
	 <1204504945.3069.30.camel@localhost.localdomain>
	 <6b2481670803030017h43da68bcxd78a6142f8f5c6bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50826 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753894AbYCCO7e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2008 09:59:34 -0500
In-Reply-To: <6b2481670803030017h43da68bcxd78a6142f8f5c6bb@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2008-03-03 at 16:17 +0800, Ke Wei wrote:
> On Mon, Mar 3, 2008 at 8:42 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >
> > On Fri, 2008-02-29 at 12:01 -0600, James Bottomley wrote:
> > > I noticed that the current marvell sas driver wasn't performing very
> > > well.  It turns out that it's setting can_queue not in the SCSI host,
> > > but in its own internal data structure, meaning it's always operating
> > > with a global queue depth of one.  This patch raises it to what the code
> > > seemed to be intending ... although I think can_queue should be
> > > MVS_CHIP_SLOT_SZ - 1 (without the divide by two)?
> > >
> > > The good news is that with this change, I'm getting a respectable
> > > throughput on the fio hammer test; plus zapping random phy resets across
> > > the disk triggers error handler recovery correctly (so far).
> > >
> > > I'm having less happy results with a SATAPI DVD ... it looks like the
> > > initial IDENTIFY goes across just fine, but that we stall on the other
> > > SCSI commands ... I'm still investigating this one.
> >
> > Actually, I've run into another problem with this patch applied.  It
> > looks like NCQ fails with ATA disks.  What I see is that I/O goes fine
> > until I get more than one command outstanding to the device, then the
> > device stops responding.  I can keep the I/O flowing if I clamp the
> > device queue depth at 1.  SAS disks seem to be fine ... I can get
> > multiple outstanding commands to them correctly serviced.
> 
> Yes, I have to say that testing failed when I plugged SATA and SAS
> disk. Sometimes "insmod mvsas" will cause the system to hang.
> Only look good if can_queue is set to 1.  I will investigate this case.

Thanks.  For the NCQ case, it does look like turning NCQ off makes the
disk work fine, so I'd suspect some issue with NCQ handling.

> > I'm having less happy results with a SATAPI DVD ... it looks like the
> > initial IDENTIFY goes across just fine, but that we stall on the other
> > SCSI commands ... I'm still investigating this one.
> 
> I think we need set BLIST_NOREPORTLUN or some other flags (see
> scsi_devinfo.h) about  new some ATAPI device.When calling
> scsi_report_lun_scan , it will bypass REPORT_LUNS command.

It doesn't seem to be anything the DVD does ... it works fine with the
aic94xx controller doing SATAPI (it sends the correct reply to REPORT
LUNS).  It looks like the first hang comes at around the second or third
Test Unit Ready.

Traces seem to show IDENTIFY_PACKET, INQUIRY, INQUIRY, TUR, TUR (hang)
and then every following command hangs, but I'll try to instrument more
accurate tracing.

James


