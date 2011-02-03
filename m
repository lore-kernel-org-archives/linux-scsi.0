From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: Re: [v2 PATCH 4/5] bnx2fc: Broadcom FCoE Offload driver
 submission - part 2
Date: Wed, 2 Feb 2011 19:42:38 -0800
Message-ID: <1296704558.268.552.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
References: <1293170555.4676.574.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
 <4D316634.5030300@cs.wisc.edu>
 <1295311066.3536.105.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
 <4D4922BE.40907@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3892 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab1BCDmu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Feb 2011 22:42:50 -0500
In-Reply-To: <4D4922BE.40907@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>

On Wed, 2011-02-02 at 01:24 -0800, Mike Christie wrote: 
> On 01/17/2011 06:37 PM, Bhanu Gollapudi wrote:
> >>
> >> Are you sending a abort when a lun or target reset has been successfully
> >> completed? Does your hw need the reset? SCSI spec wise the lun or target
> >> reset will take care of the scsi commands on its side, so there is no
> >> need to send an abort.
> >
> > It is better to send ABTS on all the outstanding IOs after issuing
> > lun/target reset.  targets may take care of scsi commands on its side.
> > But the commands on the flight may have to be aborted. This is as per
> > the FCP-4 spec in "Table 8 - Clearing effects of initiator FCP-Port
> > actions" :-
> > "Exchanges are cleared internally within the target FCP_Port, but open
> > FCP Sequences shall be individually aborted by the initiator FCP_Port
> > using ABTS-LS that also has the effect of aborting the associated FCP
> > Exchange. See 12.3."
> 
> Ughh. I must have misread that before. I think libfc is broken then.
> 
> 
> 
> >>
> >>> +}
> >>> +
> >>> +static int bnx2fc_map_sg(struct bnx2fc_cmd *io_req)
> >>> +{
> >>> +     struct bnx2fc_hba *hba = io_req->port->hba;
> >>> +     struct scsi_cmnd *sc = io_req->sc_cmd;
> >>> +     struct fcoe_bd_ctx *bd = io_req->bd_tbl->bd_tbl;
> >>> +     struct scatterlist *sg;
> >>> +     int byte_count = 0;
> >>> +     int sg_count = 0;
> >>> +     int bd_count = 0;
> >>> +     int sg_frags;
> >>> +     unsigned int sg_len;
> >>> +     u64 addr;
> >>> +     int i;
> >>> +
> >>> +     sg = scsi_sglist(sc);
> >>> +     sg_count = pci_map_sg(hba->pcidev, sg, scsi_sg_count(sc),
> >>> +                           sc->sc_data_direction);
> >>
> >>
> >> I think you could also use scsi_dma_map instead.
> >>
> >> And if not I think we are supposed to be using the dma functions instead
> >> of the pci ones.
> >
> > OK. I can use dma_map_sg() intead. But this function inturn calls
> > pci_map_sg(). Is there any reason why we cannot directly call it?
> >
> 
> People like abstractions. I guess we are trying to move to the dma 
> functions. If you had some other bus then the dma wrappers would hide that.

We handles this anyway.

> 
> 
> >
> >>
> >>
> >>
> >>> +
> >>> +static int bnx2fc_post_io_req(struct bnx2fc_rport *tgt,
> >>> +                            struct bnx2fc_cmd *io_req)
> >>> +{
> >>
> >>
> >>> +
> >>> +     /* Time IO req */
> >>> +     bnx2fc_cmd_timer_set(io_req, BNX2FC_IO_TIMEOUT);
> >>
> >> Hard coding this does not seem right becuase the scsi cmnd timer can be
> >> set through sysfs. It could be set lower than this which makes it
> >> useless. I think libfc is dropping their similar timer like this and
> >> just relying on the scsi_cmnd timer now (I think they just do the rec
> >> but not the abort now).
> >
> > if it is a lower value, eh_abort_handler() code kicks in. Default scsi
> > cmd timer is 60 secs, which may be too long to wait to sends an ABTS.
> 
> 
> Do not work around scsi-ml and the classes. If really useful it seems 
> this should be in libfc or the fc class so all drivers do the same thing 
> if capable.
> 
> Also if the abort fails you still have to wait for the scsi eh to run.
> 
> And if the the scsi timer is too long why don't you just set it lower?
> 
> Also, it is 30 secs by default in the kernel, but some distro's have 
> udev's that set it to 60.


On 02/02/2011 03:24 AM, Mike Christie wrote:
> >
> > Also if the abort fails you still have to wait for the scsi eh to
> run.
> >
> 
> Actually you do not have to wait for the scsi eh to run, right. It
> looks 
> like bnx2fc would log out the port, which ends up calling 
> fc_remote_port_delete and that would cause the fc timed out function
> to 
> return BLK_EH_RESET_TIMER to prevent the scsi eh from running. Is
> that 
> right? That type of eh strategy behavior seems like something you
> want 
> to sync up with libfc or the fc class so all drivers do something
> similar.

As per FCP-4, if the ABTS times out, we will have to explicitly LOGO the
target and relogin back. If we rely on 60 sec eh_abort_handler, and if
ABTS times out, SCSI error handling will go to LUN RESET, TGT reset
path, which is a generic error handling than transport specific error
handling.



