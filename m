From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] mpt2sas: issue reset is not uninitialized
Date: Wed, 3 Dec 2014 14:03:25 +0300
Message-ID: <20141203110325.GL4994@mwanda>
References: <20141203100941.GB29583@mwanda>
 <alpine.DEB.2.10.1412031135410.2373@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37915 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaLCLDn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2014 06:03:43 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1412031135410.2373@hadrien>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, quentin.lambert@inria.fr

On Wed, Dec 03, 2014 at 11:36:20AM +0100, Julia Lawall wrote:
> On Wed, 3 Dec 2014, Dan Carpenter wrote:
> 
> > The issue_reset variables were never set to zero.  This bug was found
> > with static analysis.
> >
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> >
> > diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> > index 58e4521..98bd546 100644
> > --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> > +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> > @@ -3236,7 +3236,7 @@ mpt2sas_base_sas_iounit_control(struct MPT2SAS_ADAPTER *ioc,
> >  	u16 smid;
> >  	u32 ioc_state;
> >  	unsigned long timeleft;
> > -	u8 issue_reset;
> > +	bool issue_reset = 0;
> 
> Why not false if it is going to be a boolean?
> 

Good point.  I'll send a v2 for these tomorrow.

regards,
dan carpenter

