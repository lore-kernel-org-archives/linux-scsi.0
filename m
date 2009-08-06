From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: sg_reset can trigger a NULL pointer dereference in the SRP
 initiator
Date: Thu, 06 Aug 2009 15:43:45 +0000
Message-ID: <1249573425.7073.16.camel@mulgrave.site>
References: <e2e108260908060039x7718577yf932d8a9188fe0cb@mail.gmail.com>
	 <4A7A949B.60408@panasas.com>
	 <e2e108260908060838u34b97ab4n6e2007dbb6937ff5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56322 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756080AbZHFPnv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2009 11:43:51 -0400
In-Reply-To: <e2e108260908060838u34b97ab4n6e2007dbb6937ff5@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Roland Dreier <rdreier@cisco.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, OpenIB <general@lists.openfabrics.org>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2009-08-06 at 17:38 +0200, Bart Van Assche wrote:
> On Thu, Aug 6, 2009 at 10:30 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> > [Just out of memory, I've not inspected the code for a long time]
> >
> > It looks like an srp_request was never allocated for the reset
> > command. (since it never went through .queuecommand)
> >
> > static int srp_find_req(struct srp_target_port *target,
> >                        struct scsi_cmnd *scmnd,
> >                        struct srp_request **req)
> > {
> >        if (scmnd->host_scribble == (void *) -1L)
> >                return -1;
> >
> >        *req = &target->req_ring[(long) scmnd->host_scribble];
> >
> >        return 0;
> > }
> >
> > Specifically scmnd->host_scribble can just be Zero.
> > When queues are active that does not matter and a device is found
> > since the reset does not really need the scsi_cmnd. But in above
> > scenario the queues were never used and the array entry is empty.
> 
> Hello Boaz,
> 
> Thanks for the info. Do you know by heart which SCSI drivers process
> the SG_SCSI_RESET ioctl correctly and that could be used as an example
> for fixing the SRP initiator ?

Basically all of them which are in regular use for clustering; so SAN:
qla2xxx; lpfc.  And for legacy SPI clusters: aic7xxx;mptspi

James


