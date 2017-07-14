From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [bug report] scsi: sg: fix SG_DXFER_FROM_DEV transfers
Date: Fri, 14 Jul 2017 11:01:11 +0200
Message-ID: <20170714090111.GA8497@linux-x5ow.site>
References: <20170714074603.7mi6jshrz6zfru4b@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51378 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750853AbdGNJBN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Jul 2017 05:01:13 -0400
Content-Disposition: inline
In-Reply-To: <20170714074603.7mi6jshrz6zfru4b@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 14, 2017 at 10:46:03AM +0300, Dan Carpenter wrote:
>    761          case SG_DXFER_FROM_DEV:
>    762                  if (hp->dxfer_len < 0)
>                             ^^^^^^^^^^^^^^^^^
> Not possible.

Yup and thanks to:
647         else
648                 hp->dxfer_direction = (mxsize > 0) ? SG_DXFER_FROM_DEV : SG_DXFER_NONE;
649         hp->dxfer_len = mxsize;

I should've noticed that earlier.
Care to send a patch or want me to do?

> 
> Btw, I was looking up the type of hp->dxfer_len and I noticed that the
> documentation for hp->resid is wrong.  It says:
> 
> 	int resid;                  /* [o] dxfer_len - actual_transferred */
> 
> My guess is that resid stands for Response ID but I'm not positive.

Nope, it's the residual length. It's set by scsi_req::resid_len

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
