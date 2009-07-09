From: "Michael Chan" <mchan@broadcom.com>
Subject: Re: [PATCH] BNX2I: register given device with cnic if shost !=
 NULL in ep_connect()
Date: Thu, 9 Jul 2009 00:15:07 -0700
Message-ID: <C27F8246C663564A84BB7AB343977242178EE780AB@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <4A558C57.30606@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3927 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077AbZGIHPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2009 03:15:19 -0400
In-Reply-To: <4A558C57.30606@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Mike Christie' <michaelc@cs.wisc.edu>, Anil Veerabhadrappa <anilgv@broadcom.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>

Mike Christie wrote:
> Anil Veerabhadrappa wrote:
> > diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> > index f741219..98148f3 100644
> > --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> > +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> > @@ -1653,15 +1653,18 @@ static struct iscsi_endpoint
> *bnx2i_ep_connect(struct Scsi_Host *shost,
> >     struct iscsi_endpoint *ep;
> >     int rc = 0;
> >
> > -   if (shost)
> > +   if (shost) {
> >             /* driver is given scsi host to work with */
> >             hba = iscsi_host_priv(shost);
> > -   else
> > +           /* Register the device with cnic if not already
> done so */
> > +           bnx2i_register_device(hba);
> > +   } else
> >             /*
> >              * check if the given destination can be reached through
> >              * a iscsi capable NetXtreme2 device
> >              */
> >             hba = bnx2i_check_route(dst_addr);
> > +
> >     if (!hba) {
> >             rc = -ENOMEM;
> >             goto check_busy;
>
> Do you want to do the test_bit(BNX2I_CNIC_REGISTERED,
> &hba->reg_with_cnic) test here instead of down below. If it
> failed then
> you might try to do a cm_create on a cnic that is not
> properly registered.
>

Good idea.  cm_create() will properly be ok because there is no
hardware interaction.  bnx2i_send_conn_ofld_req() will fail if
the cnic is not properly registered because there will be no call
backs from the hardware events.

