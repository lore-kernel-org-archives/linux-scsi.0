From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [SCSI] sd: Ensure we correctly disable devices with unknown
 protection type
Date: Wed, 6 Feb 2013 22:29:03 +0300
Message-ID: <20130206192903.GW4989@mwanda>
References: <20120926082648.GA6721@elgon.mountain>
 <yq1txuk9ojz.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21228 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab3BFT3G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2013 14:29:06 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r16JT4dd027839
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 6 Feb 2013 19:29:05 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r16JT3xo000254
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 6 Feb 2013 19:29:04 GMT
Received: from abhmt108.oracle.com (abhmt108.oracle.com [141.146.116.60])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r16JT3gi022835
	for <linux-scsi@vger.kernel.org>; Wed, 6 Feb 2013 13:29:03 -0600
Content-Disposition: inline
In-Reply-To: <yq1txuk9ojz.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

This patch wasn't applied.  Probably because it didn't have
[PATCH] in the email subject.

regards,
dan carpenter

On Wed, Sep 26, 2012 at 10:39:44PM -0400, Martin K. Petersen wrote:
> >>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:
> 
> Dan,
> 
> Dan> 	 warn: buffer overflow 'cap' 4 <= 4
> 
> Argh, yes. Type 3 is 4 because it's a bitmask.
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
> 
> 
> SCSI: Fix range check in scsi_host.h
> 
> The range checking from fe542396 was bad. We would still end up walking
> beyond the array as Type 3 is defined to be 4 in the protection
> bitmask. Instead use ARRAY_SIZE() for the range check.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 4908480..2b6956e 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -873,7 +873,7 @@ static inline unsigned int scsi_host_dif_capable(struct Scsi_Host *shost, unsign
>  				       SHOST_DIF_TYPE2_PROTECTION,
>  				       SHOST_DIF_TYPE3_PROTECTION };
>  
> -	if (target_type > SHOST_DIF_TYPE3_PROTECTION)
> +	if (target_type >= ARRAY_SIZE(cap))
>  		return 0;
>  
>  	return shost->prot_capabilities & cap[target_type] ? target_type : 0;
> @@ -887,7 +887,7 @@ static inline unsigned int scsi_host_dix_capable(struct Scsi_Host *shost, unsign
>  				       SHOST_DIX_TYPE2_PROTECTION,
>  				       SHOST_DIX_TYPE3_PROTECTION };
>  
> -	if (target_type > SHOST_DIX_TYPE3_PROTECTION)
> +	if (target_type >= ARRAY_SIZE(cap))
>  		return 0;
>  
>  	return shost->prot_capabilities & cap[target_type];
