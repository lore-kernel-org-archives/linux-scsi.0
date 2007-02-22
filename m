From: malahal@us.ibm.com
Subject: Re: [PATCH] qla2xxx: fix RSCN handling on big-endian systems
Date: Wed, 21 Feb 2007 18:53:49 -0800
Message-ID: <20070222025349.GA13701@us.ibm.com>
References: <20070219181832.GA18043@us.ibm.com> <A6970E9A290F3F4682E1EAD0EA14F32BAE5E07@AVEXCH2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55687 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbXBVCyk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Feb 2007 21:54:40 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l1M2sdh6004992
	for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2007 21:54:39 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l1M2sdQN307626
	for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2007 21:54:39 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l1M2sdHW001663
	for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2007 21:54:39 -0500
Content-Disposition: inline
In-Reply-To: <A6970E9A290F3F4682E1EAD0EA14F32BAE5E07@AVEXCH2.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: linux-scsi@vger.kernel.org, Linux Driver <Linux-Driver@qlogic.com>

I have JBOD in FL-port and if I unplug the cable or disable the switch
port, the qla2xxx driver doesn't fail the I/O soon. The remote port
status is 'online' all the time. The I/O's usually timeout after the
usual scsi timeout. Based on the existing structure, al_pa is at the
lowest addressed byte, so the b24 field's interpretation as an integer
is *incorrect* on big endinan systems. You should be able to print the
b24 as an integer and see what you get is incorrect on big endian
systems.

Thanks, Malahal.

Seokmann Ju [seokmann.ju@qlogic.com] wrote:
> On Monday, February 19, 2007 10:19 AM, Malahal Naineni wrote:
> > qla2xxx driver fails to handle RSCN events affecting area or 
> > domain due to an endian issue on big endian systems.  This 
> > fixes the port_id_t structure on big endian systems.
> <NEED MORE INFORMATION>
> Can you provide more details on the fails you are getting?
> In my opinion, those fields in the structure should not get affected by
> byte ordering.
> 
> Thank you,
> 
> Seokmann
> 
> > -----Original Message-----
> > From: malahal@us.ibm.com [mailto:malahal@us.ibm.com] 
> > Sent: Monday, February 19, 2007 10:19 AM
> > To: linux-scsi@vger.kernel.org; Linux Driver
> > Subject: [PATCH] qla2xxx: fix RSCN handling on big-endian systems
> > 
> > qla2xxx driver fails to handle RSCN events affecting area or 
> > domain due to an endian issue on big endian systems.  This 
> > fixes the port_id_t structure on big endian systems.
> > 
> > Signed-off-by: Malahal Naineni <malahal@us.ibm.com>
> > 
> > diff -r c860739bb0f4 drivers/scsi/qla2xxx/qla_def.h
> > --- a/drivers/scsi/qla2xxx/qla_def.h	Fri Feb 16 14:19:34 2007 -0800
> > +++ b/drivers/scsi/qla2xxx/qla_def.h	Fri Feb 16 14:21:29 2007 -0800
> > @@ -1478,14 +1478,17 @@ typedef union {
> >  	uint32_t b24 : 24;
> >  
> >  	struct {
> > -		uint8_t d_id[3];
> > -		uint8_t rsvd_1;
> > -	} r;
> > -
> > -	struct {
> > +#ifdef __BIG_ENDIAN
> > +		uint8_t domain;
> > +		uint8_t area;
> > +		uint8_t al_pa;
> > +#elif __LITTLE_ENDIAN
> >  		uint8_t al_pa;
> >  		uint8_t area;
> >  		uint8_t domain;
> > +#else
> > +#error "__BIG_ENDIAN or __LITTLE_ENDIAN must be defined!"
> > +#endif
> >  		uint8_t rsvd_1;
> >  	} b;
> >  } port_id_t;
> > 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
