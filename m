From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: Re: [PATCH V2] scsi: ufs: add support for query requests
Date: Thu, 18 Apr 2013 01:24:14 -0700
Message-ID: <4f618017941695cac811fc9c960874c4.squirrel@www.codeaurora.org>
References: <1366024056-8429-1-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1366024056-8429-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi All,

A minor bug was spotted, as shown blow. The fix will be submitted with the
next version.

> +static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb
> *lrbp)
> +{
> +	u32 upiu_flags;
> +	int ret = 0;
> +
> +	if (!lrbp) {
> +		dev_err(hba->dev, "%s: lrbp can not be NULL\n", __func__);
> +		ret = -EINVAL;
> +	} else if (!lrbp->ucd_req_ptr) {
> +		dev_err(hba->dev, "%s: ucd_req_ptr can not be NULL\n",
> +			__func__);
> +		ret = -EINVAL;
> +	} else if (!lrbp->utr_descriptor_ptr) {
> +		dev_err(hba->dev, "%s: utr_descriptor_ptr can not be NULL\n",
> +			__func__);
> +		ret = -EINVAL;
> +	}
> +	if (!ret)
> +		goto exit;
should be:
if (ret)

Thanks,
Dolev

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
