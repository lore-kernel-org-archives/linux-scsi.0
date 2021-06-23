Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B47B3C48BC2
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 21:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 981FB613D1
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 21:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhFWVxs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 17:53:48 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:46701 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhFWVxs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 17:53:48 -0400
Received: by mail-pg1-f178.google.com with SMTP id n12so2903121pgs.13;
        Wed, 23 Jun 2021 14:51:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fUmvPVX0pNQIpjmU77OymHRA3RCFDEaz2r2r5An26CU=;
        b=WE6K3ixx9ZKwUBRJcQKnAa95TdW41cOfeK+YLoRT6RnOIX5jexaW5qy/167iBPFswF
         Dhv9doeTcQyr8UnaDOifT2/2MfYbdRiIL/8ZQO2ghuC3uH96CKR62yczJLDP7Talbd0Z
         KMvcOFNBD5wcMPufeXR7B6DVb1b8CMVg+tpva3x7vH9DkapMIvffssYtlvBujeIt88ga
         HtF7sZG3r/4caFCgcgvlqePIs5S2X1TjNJYA/tQ6PHDgWtHf3TFaVV7s5nUC+T+SxdeS
         lUGdRS0rl5QpHg26qAjlX8nprQ1uYnipKW3XWIGYifD1c0QSJo274UL0+wUVlsG/pW+q
         BuaQ==
X-Gm-Message-State: AOAM531pmzE1f2JKFMvjgaJKR/ShPX2coazIMH99uF0GIDUXSn5skFfx
        cG6ncEy/N9Hoy5QZtSb5Bdue4Lr2Ye8rZw==
X-Google-Smtp-Source: ABdhPJx42xVRRIB+q7a9sc4Jiiu5InUUuYgK3gVaUOxdUo3/xj+CTKhFqajB5H5q52kid44vcx2sgw==
X-Received: by 2002:aa7:9381:0:b029:306:34f8:b5d5 with SMTP id t1-20020aa793810000b029030634f8b5d5mr1725330pfe.23.1624485088483;
        Wed, 23 Jun 2021 14:51:28 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id o12sm74022pgq.83.2021.06.23.14.51.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 14:51:27 -0700 (PDT)
Subject: Re: [PATCH v4 10/10] scsi: ufs: Apply more limitations to user access
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
 <1624433711-9339-12-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <89a3c8bf-bbfc-4a2a-73f0-a0db956fbf0e@acm.org>
Date:   Wed, 23 Jun 2021 14:51:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1624433711-9339-12-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/23/21 12:35 AM, Can Guo wrote:
> +int ufshcd_get_user_access(struct ufs_hba *hba)
> +__acquires(&hba->host_sem)
> +{
> +	down(&hba->host_sem);
> +	if (!ufshcd_is_user_access_allowed(hba)) {
> +		up(&hba->host_sem);
> +		return -EBUSY;
> +	}
> +	if (ufshcd_rpm_get_sync(hba)) {
> +		ufshcd_rpm_put_sync(hba);
> +		up(&hba->host_sem);
> +		return -EBUSY;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_get_user_access);
> +
> +void ufshcd_put_user_access(struct ufs_hba *hba)
> +__releases(&hba->host_sem)
> +{
> +	ufshcd_rpm_put_sync(hba);
> +	up(&hba->host_sem);
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_put_user_access);

Please indent __acquires() and __releases() annotations by one tab as is
done elsewhere in the kernel.

>  static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba)
>  {
> -	return !hba->shutting_down;
> +	return !hba->shutting_down && !hba->is_sys_suspended &&
> +		!hba->is_wlu_sys_suspended &&
> +		hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL;
>  }

Is my understanding of the following correct?
- ufshcd_is_user_access_allowed() is not in the hot path and hence
  should not be inline.
- The hba->shutting_down member variable is set from inside a shutdown
  callback. Hence, the hba->shutting_down test can be left out since
  no UFS sysfs attributes are accessed after shutdown has started.
- During system suspend, user space software is paused before the device
  driver freeze callbacks are invoked. Hence, the hba->is_sys_suspended
  check can be left out.
- If a LUN is runtime suspended, it should be resumed if accessed from
  user space instead of failing user space accesses. In other words, the
  hba->is_wlu_sys_suspended check seems inappropriate to me.
- If the HBA is not in an operational state, user space accesses
  should be blocked until error handling has finished. After error
  handling has finished, the user space access should fail if and only
  if error handling failed.

Thanks,

Bart.
