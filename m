From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH 2/14] bfa: Brocade BFA FC SCSI driver (bfa part1)
Date: Fri, 21 Aug 2009 18:58:14 -0700
Message-ID: <B0A7AF226B49A14897036E9B3A68CFFECB1A935EAF@HQ-EXCH-7.corp.brocade.com>
References: <200908200659.n7K6xqMZ006536@swe57.brocade.com>
 <200908211935.46316.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:43034 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933007AbZHVB6O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Aug 2009 21:58:14 -0400
In-Reply-To: <200908211935.46316.eike-kernel@sf-tec.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>

Rolf Eike Beer wrote:
> > +/*
> > + * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
> > + * All rights reserved
> > + * www.brocade.com
> 
> Shouldn't that be 2009?

Yes, It should be 2009. I will fix it.

> 
> > +char *
> > +wwn2str(char *buf, int bufsize, u64 wwn)
> > +{
> > +	char *ptr;
> > +	union {
> > +	wwn_t           wwn;
> > +	u8         byte[sizeof(wwn_t)];
> > +	} w;
> > +	int i = sizeof(wwn_t);
> > +
> > +	ptr = buf + bufsize;
> > +	*--ptr = '\0';
> > +	bufsize--;
> > +
> > +	w.wwn = wwn;
> > +	while (i > 0) {
> > +		i--;
> > +		*--ptr = n2b(w.byte[i] & 0x0f);
> > +		*--ptr = n2b((w.byte[i] >> 4) & 0x0f);
> > +		if (i > 0)
> > +			*--ptr = ':';
> > +	}
> > +
> > +	return ptr;
> > +}
> 
> I searched for 20 minutes and found nothing. Is there really no standard
> function to printf a WWN? I mean, every FC driver needs this, no?
> 
> fnic:
> -"%llx", wwn
> 
> ipr:
> -"%08X%08X", be32_to_cpu(wwid[0]), be32_to_cpu(wwid[1])
> 
> lpfc:
> -"%02x%02x%02x%02x%02x%02x%02x%02x", wwn[0], wwn[1], ...
> -"%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x", wwn[0], wwn[1], ...
> -"0x%llx", cfg_soft_wwnn
> 
> qla2xxx:
> -like lpfc, version 1. Harder to find as there it is called port_name and
> node_name instead of wwpn or wwnn or wwn
> 
> Is there really nothing like this? Should be an easy job to write one and
> convert all existing drivers over to use this, no? Would also add the
> benefit
> as that all drivers would print that in the same way.
> 
> Ei-printk("%WWN", wwn)-ke

I am not aware of a standard function to print wwn. It would be nice if all the drivers print wwn in the same format. Regarding our implementation of wwpn to string conversion, we are making it unnecessarily complicated, I will fix it. 

Thanks for the reviewing the code.

Jing
