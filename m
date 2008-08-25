From: Swen Schillig <swen@vnet.ibm.com>
Subject: Re: [patch 1/1] scsi: fix check of PQ and PDT bits for WLUNs
Date: Mon, 25 Aug 2008 10:41:09 +0200
Message-ID: <200808251041.09507.swen@vnet.ibm.com>
References: <20080812114037.963047000@linux.vnet.ibm.com> <20080812114123.133900000@linux.vnet.ibm.com> <1219349654.3265.38.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:44429 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbYHYIlM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Aug 2008 04:41:12 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate6.uk.ibm.com (8.13.8/8.13.8) with ESMTP id m7P8df6Z185996
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2008 08:39:41 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7P8dfkk3223590
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2008 09:39:41 +0100
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7P8deZ8022602
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2008 09:39:41 +0100
In-Reply-To: <1219349654.3265.38.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Martin Petermann <martin@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

On Thursday 21 August 2008 22:14, James Bottomley wrote:
> On Tue, 2008-08-12 at 13:40 +0200, Martin Petermann wrote:
> > plain text document attachment (scsi_scan.diff)
> > From: Martin Petermann <martin@linux.vnet.ibm.com>
> > 
> > With kernel version 2.6.19 a check was introduced not to create a generic
> > SCSI device for devices that return PQ=1 and PDT=0x1f. For WLUNs (see 
> > SAM-3, p. 41ff) generic SCSI devices should be created unconditionally
> > without looking at the PQ bit. I'm referring here to the thread "With kernel
> > 2.6.19 no sg devices for devices that return PQ=1, PDT=0x1f" of the 
> > linux-scsi forum. This is my proposed fix.
> > 
> > Signed-off-by: Martin Petermann <martin@linux.vnet.ibm.com>
> > 
> > ---
> >  drivers/scsi/scsi_scan.c |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > --- a/drivers/scsi/scsi_scan.c	2008-08-12 12:51:32.000000000 +0200
> > +++ b/drivers/scsi/scsi_scan.c	2008-08-12 12:58:16.000000000 +0200
> > @@ -75,6 +75,11 @@
> >  #define SCSI_SCAN_TARGET_PRESENT	1
> >  #define SCSI_SCAN_LUN_PRESENT		2
> >  
> > +#define SCSI_W_LUN_BASE 0xc100
> > +#define SCSI_W_LUN_REPORT_LUNS (SCSI_W_LUN_BASE + 1)
> > +#define SCSI_W_LUN_ACCESS_CONTROL (SCSI_W_LUN_BASE + 2)
> > +#define SCSI_W_LUN_TARGET_LOG_PAGE (SCSI_W_LUN_BASE + 3)
> 
> These need to be in a header file, I think, probably scsi.h
> 
> >  static const char *scsi_null_device_strs = "nullnullnullnull";
> >  
> >  #define MAX_SCSI_LUNS	512
> > @@ -1080,7 +1085,7 @@ static int scsi_probe_and_add_lun(struct
> >  	 * PDT=1Fh none (no FDD connected to the requested logical unit)
> >  	 */
> >  	if (((result[0] >> 5) == 1 || starget->pdt_1f_for_no_lun) &&
> > -	     (result[0] & 0x1f) == 0x1f) {
> > +	    (result[0] & 0x1f) == 0x1f && (lun & 0xff00) != SCSI_W_LUN_BASE) {
> 
> And this should probably be wrapped nicely too.
> 
> >  		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
> >  					"scsi scan: peripheral device type"
> >  					" of 31, no device added\n"));
> 
> Does this look OK?
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 84b4879..34d0de6 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1080,7 +1080,8 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>  	 * PDT=1Fh none (no FDD connected to the requested logical unit)
>  	 */
>  	if (((result[0] >> 5) == 1 || starget->pdt_1f_for_no_lun) &&
> -	     (result[0] & 0x1f) == 0x1f) {
> +	    (result[0] & 0x1f) == 0x1f &&
> +	    !scsi_is_wlun(lun)) {
>  		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
>  					"scsi scan: peripheral device type"
>  					" of 31, no device added\n"));
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 5c40cc5..192f871 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -309,6 +309,20 @@ struct scsi_lun {
>  };
> 
>  /*
> + * The Well Known LUNS (SAM-3) in our int representation of a LUN
> + */
> +#define SCSI_W_LUN_BASE 0xc100
> +#define SCSI_W_LUN_REPORT_LUNS (SCSI_W_LUN_BASE + 1)
> +#define SCSI_W_LUN_ACCESS_CONTROL (SCSI_W_LUN_BASE + 2)
> +#define SCSI_W_LUN_TARGET_LOG_PAGE (SCSI_W_LUN_BASE + 3)
> +
> +static inline int scsi_is_wlun(unsigned int lun)
> +{
> +	return (lun & 0xff00) == SCSI_W_LUN_BASE;
> +}
> +
> +
> +/*
>   *  MESSAGE CODES
>   */


Looks ok.

So ACK from my side, if required.

Cheers Swen
