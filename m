Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1638DC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 16:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF26C60184
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 16:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237098AbhIMQYc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 12:24:32 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:41957 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237568AbhIMQY0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 12:24:26 -0400
Received: by mail-pg1-f176.google.com with SMTP id k24so9930074pgh.8;
        Mon, 13 Sep 2021 09:23:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VyKSUuGuAhaAEJAAqdwsNaH9f4jcl2f+j/dwqt4uh+Y=;
        b=48x3i+jeL0B421Y1pbitg/mfdF+0jz3cqzehGbmJmVWoSgvh/Jt0IBgZB6DGCFVuyH
         WL+9mDRWkiOLigfLp64VPnHIvuDpeIx1iwoDrOncQT57gM0zkZbcGUt9NWwdlPJpXv3u
         8RFOOtnUxyaYdCRjpdtu2K670KB5Ap4HE5QFaEDLLViMTA6jxTdBrinS7hv7uFwKUYqj
         ZLQZKWi/fIzBXzob6/ReWGm/IvkfzMjlEcejpYEKFgeSLVIwVISQ27Vv5FrEl30n3WC2
         0a3NzZfomTU0Tc3POrRkQQcAit0TomTfFsKFbc1xpPCBXJbPODooVkAu548kWEy/Uvsp
         pz9w==
X-Gm-Message-State: AOAM533cdzmuryDBpu0a6pYLMwZqevPss8OhLCZp72B1yzXns7GtsJPK
        mtZNIoIZvDKTtmgv11zgtws=
X-Google-Smtp-Source: ABdhPJx+xtnUOS/GKE+9xgTfNQZgTm5KSMdRDY+q2GX+O2hihbxxUn3l2ARDDG3gDVQeEaynkmlJ9g==
X-Received: by 2002:a63:561a:: with SMTP id k26mr11854841pgb.144.1631550189638;
        Mon, 13 Sep 2021 09:23:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6765:113f:d2d7:def9])
        by smtp.gmail.com with ESMTPSA id t9sm7681143pfq.185.2021.09.13.09.23.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 09:23:08 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] scsi: ufs: ufs-exynos: implement exynos isr
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com
References: <cover.1631519695.git.kwmad.kim@samsung.com>
 <CGME20210913081152epcas2p2eac4a8dbef33164a150dccf2e282dcce@epcas2p2.samsung.com>
 <746e059782953fca6c21945297151d2bb73d3370.1631519695.git.kwmad.kim@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <baf17040-70e8-d850-30cd-74944e41285d@acm.org>
Date:   Mon, 13 Sep 2021 09:23:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <746e059782953fca6c21945297151d2bb73d3370.1631519695.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/13/21 12:55 AM, Kiwoong Kim wrote:
> This patch is to raise recovery in some abnormal
> conditions using an vendor specific interrupt
> for some cases, such as a situation that some
> contexts of a pending request in the host isn't
> the same with those of its corresponding UPIUs
> if they should have been the same exactly.
> 
> The representative case is shown like below.
> In the case, a broken UTRD entry, for internal
> coherent problem or whatever, that had smaller value
> of PRDT length than expected was transferred to the host.
> So, the host raised an interrupt of transfer complete
> even if device didn't finish its data transfer because
> the host sees a fetched version of UTRD to determine
> if data tranfer is over or not. Then the application level
> seemed to recogize this as a sort of corruption and this
> symptom led to boot failure.

How can a UTRD entry be broken? Does that perhaps indicate memory
corruption at the host side? Working around host-side memory
corruption in a driver seems wrong to me. I think the root cause
of the memory corruption should be fixed.

> +static irqreturn_t exynos_ufs_isr(struct ufs_hba *hba)
> +{
> +	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
> +	u32 status;
> +	unsigned long flags;
> +
> +	if (!hba->priv) return IRQ_HANDLED;

Please verify patches with checkpatch before posting these on the
linux-scsi mailing list. The above if-statement does not follow the
Linux kernel coding style.

> +	if (status & RX_UPIU_HIT_ERROR) {
> +		pr_err("%s: status: 0x%08x\n", __func__, status);
> +		hba->force_reset = true;
> +		hba->force_requeue = true;
> +		scsi_schedule_eh(hba->host);
> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> +		return IRQ_HANDLED;
> +	}
> +	return IRQ_NONE;
> +}

So the above code unlocks the host_lock depending on whether or not
status & RX_UPIU_HIT_ERROR is true? Yikes ...

Additionally, in the above code I found the following pattern:

	unsigned long flags;
	[ ... ]
	spin_unlock_irqrestore(hba->host->host_lock, flags);

Such code is ALWAYS wrong. The value of the 'flags' argument passed to
spin_unlock_irqrestore() must come from spin_lock_irqsave().

Bart.
