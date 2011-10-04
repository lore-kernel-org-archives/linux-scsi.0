From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH] [SCSI] libsas panic when single phy disabled on a wide port
Date: Tue, 4 Oct 2011 16:35:17 +0800
Message-ID: <D6A545ADF9C246F5892651DCA75412AA@usish.com.cn>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com><1316691000.10571.6.camel@dabdike><FC1F9E38C0703341A1A750524E2525A9018AE2C6@XYUS-EX22.xyus.xyratex.com><FC1F9E38C0703341A1A750524E2525A9018AE2CF@XYUS-EX22.xyus.xyratex.com><A94E3BEBF01D46D5B15046388D9F7DE7@usish.com.cn> <CAA9_cmdq455AZJUPNdjCrn7JT90AXZtZbGGejcpLDX3zYfu+2A@mail.gmail.com> <FC1F9E38C0703341A1A750524E2525A9018AE711@XYUS-EX22.xyus.xyratex.com> <FC1F9E38C0703341A1A750524E2525A9018AE726@XYUS-EX22.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:54085 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab1JDIet (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2011 04:34:49 -0400
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A9018AE726@XYUS-EX22.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Mark Salyzyn' <mark_salyzyn@us.xyratex.com>, 'Dan Williams' <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, 'Darrick Wong' <djwong@us.ibm.com>, 'Xiangliang Yu' <yuxiangl@marvell.com>, 'Luben Tuikov' <ltuikov@yahoo.com>, 'James Bottomley' <jbottomley@parallels.com>



Hi Mark,

Agree with your analysis, I'll verify when back to office.

Jack
RE: [PATCH] [SCSI] libsas panic when single phy disabled on a wide port
> 
> I am talking to myself ;->. Dan (et al), I inspected deeper and I
> *think* I see the culprit in sas_deform_port().
> 
> Could the problem be that the code should have been refactored to:
> 
> +	BUG_ON(!phy->port);
> 	sas_port_delete_phy(phy->port, phy->phy);
> -	if (phy->port->num_phys == 0)
> +	if (phy->port->num_phys == 0) {
> 	        sas_port_delete(phy->port);
> -	phy->port = NULL;
> +		phy->port = NULL;
> +	}
> 
> And also fixed up is sas_ex_discover_end_dev() at out_err (this is on
> soft territory, need to dig into sas_port_delete):
> 
>  out_free:
> -       sas_port_delete(phy->port);
> +	  if (phy->port->num_phys == 0) {
> +	       sas_port_delete(phy->port);
>  out_err:
> -       phy->port = NULL;
> +	       phy->port = NULL;
> +	  }
> 
> And finally in sas_prot.c at sas_deform_port() (simplified, I still view
> this as split-brained though):
> 
>         if (port->num_phys == 1) {
>                 if (dev && gone)
>                         dev->gone = 1;
>                 sas_unregister_domain_devices(port);
>                 sas_port_delete(port->port);
>                 port->port = NULL;
> -       } else
> +	  } else {
>                 sas_port_delete_phy(port->port, phy->phy);
> +		    if (si->dft->lldd_port_deformed)
> +				si->dfp->lldd_port_deformed(phy);
> +		    return;
> +	  }
> 
>         if (si->dft->lldd_port_deformed)
>                 si->dft->lldd_port_deformed(phy);
> 
>         spin_lock_irqsave(&sas_ha->phy_port_lock, flags);
>         spin_lock(&port->phy_list_lock);
> 
>         list_del_init(&phy->port_phy_el);
>         phy->port = NULL;
>         port->num_phys--;
>         port->phy_mask &= ~(1U << phy->id);
> 
>         if (port->num_phys == 0) {
>                 INIT_LIST_HEAD(&port->phy_list);
>                 memset(port->sas_addr, 0, SAS_ADDR_SIZE);
>                 memset(port->attached_sas_addr, 0, SAS_ADDR_SIZE);
>                 port->class = 0;
>                 port->iproto = 0;
>                 port->tproto = 0;
>                 port->oob_mode = 0;
>                 port->phy_mask = 0;
>         }
>         spin_unlock(&port->phy_list_lock);
>         spin_unlock_irqrestore(&sas_ha->phy_port_lock, flags);
> 
>         return;
> 
> The way I see it, sas_deform_port() is the culprit that is clearing out
> phy->port when the num_phys is equal to two, falling through and
> decrementing the count one more time.
> 
> Sincerely -- Mark Salyzyn
> 
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Mark Salyzyn
> Sent: Monday, October 03, 2011 9:08 AM
> To: Dan Williams; Jack Wang
> Cc: linux-scsi@vger.kernel.org; Darrick Wong; Xiangliang Yu; Luben
> Tuikov; James Bottomley
> Subject: RE: [PATCH] [SCSI] libsas panic when single phy disabled on a
> wide port
> 
> 100% agree with Dan! In fact it is my fault for not digging deeper when
> I had the duplication relatively close at hand (but production pressures
> had me move on, in my defense). I definitely attacked the symptom. The
> patch is a piece of hardening, which can remain as paranoia after the
> root cause has properly been discovered (turned into a BUG() likely).
> 
> I have lost the resources to duplicate this problem at the moment.
> 
> Sincerely -- Mark Salyzyn
> 
> -----Original Message-----
> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On
> Behalf Of Dan Williams
> Sent: Friday, September 30, 2011 9:43 PM
> To: Jack Wang
> Cc: Mark Salyzyn; linux-scsi@vger.kernel.org; Darrick Wong; Xiangliang
> Yu; Luben Tuikov; James Bottomley
> Subject: Re: [PATCH] [SCSI] libsas panic when single phy disabled on a
> wide port
> 
> On Thu, Sep 29, 2011 at 7:21 PM, Jack Wang <jack_wang@usish.com> wrote:
> > I can reproduce this bug, so I'm ok to get this fix in.
> >
> 
> Mark admits this is a band aid.  I'd like to understand the root cause
> of why the port is NULL here.
> ______________________________________________________________________
> This email may contain privileged or confidential information, which
should
> only be used for the purpose for which it was sent by Xyratex. No further
rights
> or licenses are granted to use such information. If you are not the
intended
> recipient of this message, please notify the sender by return and delete
it.
> You may not use, copy, disclose or rely on the information contained in
it.
> 
> Internet email is susceptible to data corruption, interception and
> unauthorised amendment for which Xyratex does not accept liability. While
we
> have taken reasonable precautions to ensure that this email is free of
viruses,
> Xyratex does not accept liability for the presence of any computer viruses
in
> this email, nor for any losses caused as a result of viruses.
> 
> Xyratex Technology Limited (03134912), Registered in England & Wales,
> Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
> 
> The Xyratex group of companies also includes, Xyratex Ltd, registered in
> Bermuda, Xyratex International Inc, registered in California, Xyratex
> (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co
Ltd
> registered in The People's Republic of China and Xyratex Japan Limited
> registered in Japan.
> ______________________________________________________________________
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

