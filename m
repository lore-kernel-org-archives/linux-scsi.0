Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA8FC33CAA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 07:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13A2724125
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 07:50:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="nTjqDVvL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgAWHuP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 02:50:15 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:49427 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725955AbgAWHuN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Jan 2020 02:50:13 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579765812; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=WYCodPgSQbxsvqvCCjKLZcm4QATIvQ6uhvXA/IjZoVE=;
 b=nTjqDVvLU5gmlRyoCVZd9aNq7ZkqDXyO2kcoOT3JPpGc6hqtzHWaJu60ggb1cidOswx8lwlb
 I/xXGx5bHtILiuQCNhyKoX60eAoITJlArhlYeZ+Drxl+k9JuElYAlTsGsGYxllTVhSEgAZtb
 ADk3unAj/yr3InzSTnQbpmTCUGY=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e29502c.7fe6e4bbe180-smtp-out-n02;
 Thu, 23 Jan 2020 07:50:04 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 74932C447A2; Thu, 23 Jan 2020 07:50:02 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: hongwus)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9629FC43383;
        Thu, 23 Jan 2020 07:50:01 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 23 Jan 2020 15:50:01 +0800
From:   hongwus@codeaurora.org
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/8] scsi: ufs: set load before setting voltage in
 regulators
In-Reply-To: <1579764349-15578-3-git-send-email-cang@codeaurora.org>
References: <1579764349-15578-1-git-send-email-cang@codeaurora.org>
 <1579764349-15578-3-git-send-email-cang@codeaurora.org>
Message-ID: <5e18c16a6f01043ccf4756ea7677441b@codeaurora.org>
X-Sender: hongwus@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Can,
   It makes sense that set the load before enable regulator or set 
voltage. Just avoid voltage drop.

On 2020-01-23 15:25, Can Guo wrote:
> From: Asutosh Das <asutoshd@codeaurora.org>
> 
> This sequence change is required to avoid dips in voltage
> during boot-up.
> 
> Apparently, this dip is caused because in the original
> sequence, the regulators are initialized in lpm mode.
> And then when the load is set to high, and more current
> is drawn, than is allowed in lpm, the dip is seen.
> 
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c2de29f..c386c2d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7225,6 +7225,11 @@ static int ufshcd_config_vreg(struct device 
> *dev,
>  	name = vreg->name;
> 
>  	if (regulator_count_voltages(reg) > 0) {
> +		uA_load = on ? vreg->max_uA : 0;
> +		ret = ufshcd_config_vreg_load(dev, vreg, uA_load);
> +		if (ret)
> +			goto out;
> +
>  		if (vreg->min_uV && vreg->max_uV) {
>  			min_uV = on ? vreg->min_uV : 0;
>  			ret = regulator_set_voltage(reg, min_uV, vreg->max_uV);
> @@ -7235,11 +7240,6 @@ static int ufshcd_config_vreg(struct device 
> *dev,
>  				goto out;
>  			}
>  		}
> -
> -		uA_load = on ? vreg->max_uA : 0;
> -		ret = ufshcd_config_vreg_load(dev, vreg, uA_load);
> -		if (ret)
> -			goto out;
>  	}
>  out:
>  	return ret;


Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
