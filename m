From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH v2] libsas: fix bug for vacant phy
Date: Tue, 28 Sep 2010 16:01:59 +0800
Message-ID: <22F7A59E497F4737B292FEA765ED0D85@usish.com.cn>
References: <BE430C874DBA6841A75E65151DCC6E1C0699F1BA@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca> <D8666BDF2F024F71B478BDCA08C7833D@usish.com.cn> <BE430C874DBA6841A75E65151DCC6E1C0731F42F@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca> <01B7071A8F0947F38977CA217D833D16@usish.com.cn> <27DA42B50CD244D19895F2FCED2191FD@usish.com.cn> <BE430C874DBA6841A75E65151DCC6E1C077DA147@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca> <4CA2E901.9040908@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:59358 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab0I2H7m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2010 03:59:42 -0400
In-Reply-To: <4CA2E901.9040908@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Hannes Reinecke' <hare@suse.de>, 'Chuck Tuffli' <Chuck_Tuffli@pmc-sierra.com>
Cc: 'James Bottomley' <jejb@kernel.org>, linux-scsi@vger.kernel.org, 'lindar_liu' <lindar_liu@usish.com>, 'roy' <roy_wang@usish.com>


Chuck Tuffli wrote:
> This fixes the issue I was seeing. Thanks!
> 
> -----Original Message-----
> From: Jack Wang [mailto:jack_wang@usish.com] 
> Sent: Sunday, September 19, 2010 10:52 PM
> To: 'Jack Wang'; Chuck Tuffli; 'James Bottomley';
linux-scsi@vger.kernel.org
> Cc: 'lindar_liu'; 'roy'
> Subject: [PATCH v2] libsas: fix bug for vacant phy
> 
> 
> Hi, James
> 
> Please drop the previous patch and apply this new one.
> Attached patch fix following bugs reported by Chuck.
> 
> Chuck
> Could you test if this solve your problem ?
> 
> Jack -
> Signed-off-by: Jack Wang <jack_wang@usish.com>
> 
> Signed-off-by: Lindar <lindar_liu@usish.com>
> ---
>  sas_expander.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/sas_expander.c b/sas_expander.c
> index d1d86a6..f63dbea 100644
> --- a/sas_expander.c
> +++ b/sas_expander.c
> @@ -175,10 +175,10 @@ static void sas_set_ex_phy(struct domain_device
*dev,
> int phy_id,
>  	switch (resp->result) {
>  	case SMP_RESP_PHY_VACANT:
>  		phy->phy_state = PHY_VACANT;
> -		return;
> +		break;
>  	default:
>  		phy->phy_state = PHY_NOT_PRESENT;
> -		return;
> +		break;
>  	case SMP_RESP_FUNC_ACC:
>  		phy->phy_state = PHY_EMPTY; /* do not know yet */
>  		break;
> @@ -209,7 +209,8 @@ static void sas_set_ex_phy(struct domain_device *dev,
> int phy_id,
>  	phy->phy->negotiated_linkrate = phy->linkrate;
>  
>  	if (!rediscover)
> -		sas_phy_add(phy->phy);
> +		if (sas_phy_add(phy->phy))
> +			sas_phy_free(phy->phy);
>  
>  	SAS_DPRINTK("ex %016llx phy%02d:%c attached: %016llx\n",
>  		    SAS_ADDR(dev->sas_addr), phy->phy_id,
Hmm. Shouldn't you avoid the message here if you entered the error
path? I guess the SAS phy isn't actually attached then.
So maybe the above statement should read:


if (!rediscover)
        if (sas_phy_add(phy->phy)) {
                sas_phy_free(phy->phy);
		return;
	}


Cheers,

Hannes
[Jack] Yes, you're right. I'll update the patch soon. Thanks for review.


