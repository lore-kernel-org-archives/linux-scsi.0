From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: RE: ips.c broken since 2.6.23 on x86_64?
Date: Mon, 18 Feb 2008 06:57:14 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F4399FCFC9@ADPE2K703.adaptec.com>
References: <20080213214324.GB18227@tpepper-t42p.dolavim.us>
 <532ABFBDAAC3A34EB12EBA6CEC2838F439964688@ADPE2K703.adaptec.com>
 <20080214000417.GA2741@tpepper-t42p.dolavim.us>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:48860 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbYBRO5Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Feb 2008 09:57:16 -0500
In-Reply-To: <20080214000417.GA2741@tpepper-t42p.dolavim.us>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tim Pepper <lnxninja@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

The path needs to be triggered, it is the path to handle spoofing of the Adapter's inquiry.

You need more printk instrumentation to determine *why* it is not reaching that code path. What is the result of scb->scsi_cmd. scb->bus, ips_is_passthru(scb->scsi_cmd)?

The sg breakup issue may need to be looked at, but keep in mind the driver is going down a path that was not intended.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Tim Pepper [mailto:lnxninja@linux.vnet.ibm.com]
> Sent: Wednesday, February 13, 2008 7:04 PM
> To: linux-scsi@vger.kernel.org
> Cc: FUJITA Tomonori; Salyzyn, Mark
> Subject: Re: ips.c broken since 2.6.23 on x86_64?
>
> (replaced missing cc's including linux-scsi)
>
> On Wed 13 Feb at 14:39:07 -0800 Mark_Salyzyn@adaptec.com said:
> >
> > - Is the command path code even reaching the controller's
> processor inquiry
> >   spoofing section?
> >
> >                 if (scb->scsi_cmd->cmnd[0] == INQUIRY) {
> >                 IPS_SCSI_INQ_DATA inquiry;
> >
> >                 memset(&inquiry, 0,
> >                sizeof (IPS_SCSI_INQ_DATA));
> >
> >                 inquiry.DeviceType =
> >                     IPS_SCSI_INQ_TYPE_PROCESSOR;
>
> I just added printk's in ips_send_cmd()'s INQUIRY case just before
> the above condition test and just within the conditional block.
> Neither showed on the console.
>
> > The target_id check may be flawed? It is not using the
> > scmd/sdev accessors and could be the wrong value as a
> result. Wild goose
> > since arrays are working correctly (?)
>
> In the original case the arrays appeared to be working
> correctly although
> we were worried.  In the repro case we don't actually have any disk
> attached...Forgot to mention that in the original email.
>
> > - There appears to be a missing 'break' statement for the
> START_STOP command
> >   immediately preceding the TEST_UNIT_READY/INQUIRY cases.
> What are the side
> >   effects of that? It appears to be innocuous.
>
> No change noted with the missing break added.
>
> > - ips_scmd_buf_write is used for array capacity and other
> fiddly bits and
> >   must be functioning correctly (?), so I can NOT harm it's
> functionality
> >   except to question if the kmap_atomic returned a non-null
> value, it's
> >   return value apparently is not checked. It's failure
> could speak of
> >   problem(s) elsewhere.
>
> I've got a printk there and haven't seen any output from it.
> Haven't seen
> anything from any of the printk's I've tried actually before:
>
> In the run above to check if ips_send_cmd() hits the
> condition you were
> curious about...I did capture the following from printk's I added in
> ips_allocatescbs():
>
> pci_alloc_consistent returns ha->scbs    @ 0x18446604437762007040
> pci_alloc_consistent returns ips_sg.list @ 0x18446604437762002944
> pci_alloc_consistent returns ha->scbs    @ 0x18446604437698871296
> pci_alloc_consistent returns ips_sg.list @ 0x18446604437756837888
>
> I take that as ips_init_phase2() being called and presumable returning
> SUCCESS.
>
> --
> Tim Pepper  <lnxninja@linux.vnet.ibm.com>
> IBM Linux Technology Center
>
