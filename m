From: "Abhijeet Arvind Joglekar (abjoglek)" <abjoglek@cisco.com>
Subject: RE: [RFC][PATCH 5/6] fnic: add descriptor right, buffers, device interface
Date: Thu, 12 Mar 2009 15:10:51 -0700
Message-ID: <9E88C8678BF34240A8C61D4078A3D251A4A39F@xmb-sjc-23e.amer.cisco.com>
References: <20090228022152.12158.11200.stgit@feynman.nuovasystems.com> <20090228023230.12158.72176.stgit@feynman.nuovasystems.com> <49B97403.4020302@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-1.cisco.com ([171.71.176.70]:18100 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbZCLWKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2009 18:10:54 -0400
Content-class: urn:content-classes:message
In-Reply-To: <49B97403.4020302@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, "Joe Eykholt (jeykholt)" <jeykholt@cisco.com>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Mike Christie
> Sent: Thursday, March 12, 2009 1:44 PM
> To: Abhijeet Arvind Joglekar (abjoglek)
> Cc: james.bottomley@hansenpartnership.com; 
> linux-scsi@vger.kernel.org; Joe Eykholt (jeykholt)
> Subject: Re: [RFC][PATCH 5/6] fnic: add descriptor right, 
> buffers, device interface
> 
> Abhijeet Joglekar wrote:
> > diff --git a/drivers/scsi/fnic/vnic_cq.h 
> b/drivers/scsi/fnic/vnic_cq.h 
> > new file mode 100644 index 0000000..4ede680
> > --- /dev/null
> > +++ b/drivers/scsi/fnic/vnic_cq.h
> 
> 
> > +
> > +/*
> > + * These defines avoid symbol clash between fnic and enic 
> (Cisco 10G Eth
> > + * Driver) when both are built with CONFIG options =y
> > + */
> > +#define vnic_cq_service fnic_cq_service
> > +#define vnic_cq_free fnic_cq_free
> > +#define vnic_cq_alloc fnic_cq_alloc
> > +#define vnic_cq_init fnic_cq_init
> > +#define vnic_cq_clean fnic_cq_clean
> > +
> 
> Are these functions implementations the same as the net ones? I only 
> looked at the first one and it looked the same.

Yes, they are the same, it is the low-level queue/buffer code that we
wanted to share across enic and fnic. We did consider making a new
module out of it, but its not a lot of code, and there was the problem
of where the common files will reside, and how we share it across the
net and scsi subsystems.

So, the plan was to re-define them for fnic (since enic is already
integrated) and then go with what the kernel community thinks the best
way is.

Thanks for the review
-- abhijeet
 
> If you are going to share code then you probably want to put 
> them in a 
> new module that both enic and fnic can use.
> 
> Are you going to ask where the module should then live 
> (drivers/net vs 
> driver/scsi)? I do not know the answer.

> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
