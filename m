Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19585C77B75
	for <linux-scsi@archiver.kernel.org>; Fri, 19 May 2023 23:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbjESXEC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 May 2023 19:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjESXEB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2023 19:04:01 -0400
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635D2107;
        Fri, 19 May 2023 16:04:00 -0700 (PDT)
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-5307502146aso2681987a12.1;
        Fri, 19 May 2023 16:04:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684537440; x=1687129440;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SQuao/FKgfHtIfhTrNUUz5rFqYNJxGKOnDpvRokVUgw=;
        b=PBw9KBg4E360nIqD352pQ4gsYd21yOxtuc26HZVLMMFxPTQgHgtB8203k2Xrb8RynR
         K7m++FQ5SKMWCAJWeueeEro+RV6HNZkfOxwNDT8pRV0viDhPzhXPdE2sGKxXuCnzQiVc
         w3AI243UWp2AsZPt9aLsjtv5my3OMVWped0DafDnnJEUj0alVY9VnKyLqqRZD7/pgM5G
         zVWLJhqXHht/VodMWLcyYFgkEbtEZkuUT843r/NzmOeU/9Q8ugM8whR9FId9wxB5FAf9
         Tu0ExG9/7/bGAoxRMhHgK0HWA6XQFb5Iu8zdnA2j799njjjItVHvD1QfNJWMTnGCpy34
         T75Q==
X-Gm-Message-State: AC+VfDxYQfDi6zJ/UTKEsuUmWYNSYSy4mmT1M+N3SpHgpLVTfK82rwl2
        I9G1uVe+y9KNH6DmHHKkecxdMwIYx0c=
X-Google-Smtp-Source: ACHHUZ6g5IZtepr1SGBWAwyZnV0Y4de9/TN3MeWtsf2AoDsNmnn96a1PqPpHuXYMo2DwioqWSQQ+6w==
X-Received: by 2002:a17:902:c407:b0:1ac:451d:34b with SMTP id k7-20020a170902c40700b001ac451d034bmr5091242plk.9.1684537439758;
        Fri, 19 May 2023 16:03:59 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:102a:f960:4ec2:663d? ([2620:15c:211:201:102a:f960:4ec2:663d])
        by smtp.gmail.com with ESMTPSA id j22-20020a170902759600b001ac95be5081sm118615pll.307.2023.05.19.16.03.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 16:03:59 -0700 (PDT)
Message-ID: <5065e9ca-d5ce-22fc-4089-651cfacb7166@acm.org>
Date:   Fri, 19 May 2023 16:03:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v5 7/7] ufs: core: Add error handling for MCQ mode
Content-Language: en-US
To:     "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com, mani@kernel.org,
        stanley.chu@mediatek.com, adrian.hunter@intel.com,
        beanhuo@micron.com, avri.altman@wdc.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        open list <linux-kernel@vger.kernel.org>
References: <cover.1683872601.git.quic_nguyenb@quicinc.com>
 <7b884263c9db9a9666086a345ede85bb56d9dfc7.1683872601.git.quic_nguyenb@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7b884263c9db9a9666086a345ede85bb56d9dfc7.1683872601.git.quic_nguyenb@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/11/23 23:28, Bao D. Nguyen wrote:
> @@ -6378,18 +6407,36 @@ static bool ufshcd_abort_all(struct ufs_hba *hba)
>   	bool needs_reset = false;
>   	int tag, ret;
>   
> -	/* Clear pending transfer requests */
> -	for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
> -		ret = ufshcd_try_to_abort_task(hba, tag);
> -		dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
> -			hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
> -			ret ? "failed" : "succeeded");
> -		if (ret) {
> -			needs_reset = true;
> -			goto out;
> +	if (is_mcq_enabled(hba)) {
> +		struct ufshcd_lrb *lrbp;
> +		int tag;
> +
> +		for (tag = 0; tag < hba->nutrs; tag++) {
> +			lrbp = &hba->lrb[tag];
> +			if (!ufshcd_cmd_inflight(lrbp->cmd))
> +				continue;
> +			ret = ufshcd_try_to_abort_task(hba, tag);
> +			dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
> +				hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
> +				ret ? "failed" : "succeeded");
> +			if (ret) {
> +				needs_reset = true;
> +				goto out;
> +			}
> +		}
> +	} else {
> +		/* Clear pending transfer requests */
> +		for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
> +			ret = ufshcd_try_to_abort_task(hba, tag);
> +			dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
> +				hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
> +				ret ? "failed" : "succeeded");
> +			if (ret) {
> +				needs_reset = true;
> +				goto out;
> +			}
>   		}
>   	}

Please move the ufshcd_cmd_inflight() check into ufshcd_try_to_abort_task()
such that the same code path can be used for MCQ and legacy mode.

Thanks,

Bart.
