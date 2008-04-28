From: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] qla2xxx: firmware semaphore to mutex
Date: Mon, 28 Apr 2008 11:57:13 -0700
Message-ID: <1209409033.12461.64.camel@localhost.localdomain>
References: <20080428174742.163523860@mvista.com>
	 <20080428180846.GX14990@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([63.81.120.158]:26349 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933717AbYD1S5R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Apr 2008 14:57:17 -0400
In-Reply-To: <20080428180846.GX14990@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James.Bottomley@HansenPartnership.com, mingo@elte.hu, linux-driver@qlogic.com, linux-scsi@vger.kernel.org


On Mon, 2008-04-28 at 12:08 -0600, Matthew Wilcox wrote:
> On Mon, Apr 28, 2008 at 10:47:42AM -0700, Daniel Walker wrote:
> > Signed-off-by: Daniel Walker <dwalker@mvista.com>
> 
> I did this one too ... my version had a nice little twist.
> 
> > @@ -2813,7 +2814,7 @@ qla2x00_request_firmware(scsi_qla_host_t
> >  		blob = &qla_fw_blobs[FW_ISP25XX];
> >  	}
> >  
> > -	down(&qla_fw_lock);
> > +	mutex_lock(&qla_fw_lock);
> >  	if (blob->fw)
> >  		goto out;
> >  
> 
> This one we can do as:
> 
> -       down(&qla_fw_lock);
> +       if (mutex_lock_killable(&qla_fw_lock))
> +               return NULL;

I'm not sure what mutex_lock_killable() does, so I would imagine that
should be in it's own patch .. I don't like doubling up on changes
because I feel it's harder to review, and harder on git bisect once it's
in mainline.. That's why I was saying "one lock per patch." ..

Daniel

