From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [RFC] Set functions for scsi_cmnd result
Date: Mon, 16 Jun 2008 10:58:33 +0200
Message-ID: <20080616085833.GA7228@schmichrtp.de.ibm.com>
References: <20080612092955.GA9032@schmichrtp.de.ibm.com> <1213286142.3426.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:24657 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbYFPI6s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jun 2008 04:58:48 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.13.8/8.13.8) with ESMTP id m5G8waWC120720
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2008 08:58:36 GMT
Received: from d12av01.megacenter.de.ibm.com (d12av01.megacenter.de.ibm.com [9.149.165.212])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5G8waAH2728134
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2008 10:58:36 +0200
Received: from d12av01.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av01.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5G8waxY014741
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2008 10:58:36 +0200
Content-Disposition: inline
In-Reply-To: <1213286142.3426.26.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Jun 12, 2008 at 10:55:41AM -0500, James Bottomley wrote:
> > --- a/include/scsi/scsi.h	2008-06-10 17:30:49.000000000 +0200
> > +++ b/include/scsi/scsi.h	2008-06-12 11:06:34.000000000 +0200
> > @@ -425,6 +425,16 @@ struct scsi_lun {
> >  #define driver_byte(result) (((result) >> 24) & 0xff)
> >  #define suggestion(result)  (driver_byte(result) & SUGGEST_MASK)
> >  
> > +static inline void set_host_byte(int *result, char status)
> > +{
> > +	*result |= status << 16;
> > +}
> > +
> > +static inline void set_driver_byte(int *result, char status)
> > +{
> > +	*result |= status << 24;
> > +}
> > +
> 
> If we're making accessors, it might be better if they took a struct
> scsi_cmnd rather than a pointer to one of its elements.  Other than
> that, this looks fine.

Ok. I will update the patch and send it with the next batch of zfcp
patches.

Christof
