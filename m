From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: [PATCH 1/1] scsi: ufs: tc-dwc-g210 driver fix for 20-bit RMMI
Date: Thu, 14 Jul 2016 10:17:55 +0100
Message-ID: <6751bae2-47a9-0ab2-b20a-68e5c0df6020@synopsys.com>
References: <1468331736-23825-1-git-send-email-manjumb@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:55592 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbcGNJR7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2016 05:17:59 -0400
Received: from us02secmta1.synopsys.com (us02secmta1.synopsys.com [10.12.235.96])
	by smtprelay.synopsys.com (Postfix) with ESMTP id 5A1A810C1176
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2016 02:17:58 -0700 (PDT)
Received: from us02secmta1.internal.synopsys.com (us02secmta1.internal.synopsys.com [127.0.0.1])
	by us02secmta1.internal.synopsys.com (Service) with ESMTP id 4BCDE4E213
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2016 02:17:58 -0700 (PDT)
Received: from mailhost.synopsys.com (mailhost1.synopsys.com [10.12.238.239])
	by us02secmta1.internal.synopsys.com (Service) with ESMTP id 2F28C4E202
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2016 02:17:58 -0700 (PDT)
Received: from mailhost.synopsys.com (localhost [127.0.0.1])
	by mailhost.synopsys.com (Postfix) with ESMTP id 1D4F718CE
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2016 02:17:58 -0700 (PDT)
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
	by mailhost.synopsys.com (Postfix) with ESMTP id 10E3B18CC
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2016 02:17:58 -0700 (PDT)
In-Reply-To: <1468331736-23825-1-git-send-email-manjumb@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Manjunath M B <Manjunath.MB@synopsys.com>, Joao.Pinto@synopsys.com
Cc: linux-scsi@vger.kernel.org

On 7/12/2016 2:55 PM, Manjunath M B wrote:
> The code was checking on PA_CONNECTEDRXLANES and
> PA_CONNECTEDTXLANES attributes to program the Lane#1
> attributes. The correct attributes are PA_AVAILRXDATALANES and
> PA_AVAILTXDATALANES respectively.
> 
> Signed-off-by: Manjunath M B <manjumb@synopsys.com>
> ---
>  drivers/scsi/ufs/tc-dwc-g210.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/tc-dwc-g210.c b/drivers/scsi/ufs/tc-dwc-g210.c
> index d6c5388..70db6d9 100644
> --- a/drivers/scsi/ufs/tc-dwc-g210.c
> +++ b/drivers/scsi/ufs/tc-dwc-g210.c
> @@ -187,9 +187,9 @@ static int tc_dwc_g210_setup_20bit_rmmi_lane1(struct ufs_hba *hba)
>  	};
>  
>  	/* Get the available lane count */
> -	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDRXDATALANES),
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_AVAILRXDATALANES),
>  			&connected_rx_lanes);
> -	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_AVAILTXDATALANES),
>  			&connected_tx_lanes);
>  
>  	if (connected_tx_lanes == 2) {
> 

Tested-by: Joao Pinto <jpinto@synopsys.com>
