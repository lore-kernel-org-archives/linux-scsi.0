Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEC8C48BE5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 02:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95972610CA
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 02:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhFQCvN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 22:51:13 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:46655 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhFQCvN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 22:51:13 -0400
Received: by mail-pf1-f181.google.com with SMTP id x16so3762815pfa.13;
        Wed, 16 Jun 2021 19:49:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PU09GkpdOebA1Js4BBORPX4b2AbSyG+VI/fibqpS/xU=;
        b=sf8zOrQic4rDYPS8wHW0Lk2Suj8Lo4ssZa2H4jo239FoXrn9Nq1gclTzEYbRec3YFW
         wi2xs9S73ZAlTwxx/ByJw11TrS1T+pcc6rMLj+WC7V+EGHbHIW9j65CKDKghpN6UUWkl
         /FWd4sLI8lXcqkLH9MS7oVGfLte/lDAqI8KSBAG+FGza6gMD4mzm6yjUfm6Vn+DY77lD
         nfRowxz4kBu5DuSJ3ycMvG4GLFQt6uh/Lf55VeFa3O2W0oYIHMf4zZQ4OHyTA1b0m+yM
         Z/TMpMQnpn6IY6X61NpZzzskQZszNf0/GOOCIonqeLV3ShgVkjIMQ2R4248orpuJC6QT
         wPdQ==
X-Gm-Message-State: AOAM530vwvhn68saNrqUlXwA/QHlBuXHxlS0QqtGuD6EE2dxramXDEYS
        /kk5igmjRVdFXFP+JX51yjgiSnER1Hs2ZQ==
X-Google-Smtp-Source: ABdhPJwvpKAme/JRba83mhU7fhxECxrIxIQHPhHr5N5r3j8OvecsPl0thpfr9xdZAupImqkqM1CQ4A==
X-Received: by 2002:a63:1f50:: with SMTP id q16mr2762916pgm.170.1623898144888;
        Wed, 16 Jun 2021 19:49:04 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id gl13sm6517896pjb.5.2021.06.16.19.49.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 19:49:04 -0700 (PDT)
Subject: Re: [PATCH v1 2/3] scsi: ufs: Optimize host lock on transfer requests
 send/compl paths
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
 <1621845419-14194-3-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a29164e1-ab7d-6dbc-0fb9-029f203de735@acm.org>
Date:   Wed, 16 Jun 2021 19:49:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1621845419-14194-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/24/21 1:36 AM, Can Guo wrote:
> @@ -2688,6 +2705,43 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
> +	case UFSHCD_STATE_EH_SCHEDULED_FATAL:
> +		/*
> +		 * pm_runtime_get_sync() is used at error handling preparation
> +		 * stage. If a scsi cmd, e.g. the SSU cmd, is sent from hba's
> +		 * PM ops, it can never be finished if we let SCSI layer keep
> +		 * retrying it, which gets err handler stuck forever. Neither
> +		 * can we let the scsi cmd pass through, because UFS is in bad
> +		 * state, the scsi cmd may eventually time out, which will get
> +		 * err handler blocked for too long. So, just fail the scsi cmd
> +		 * sent from PM ops, err handler can recover PM error anyways.
> +		 */
> +		if (hba->pm_op_in_progress) {
> +			hba->force_reset = true;
> +			set_host_byte(cmd, DID_BAD_TARGET);
> +			cmd->scsi_done(cmd);
> +			goto out;
> +		}
> +		fallthrough;

Hi Can,

I know that this patch only moves the above code and that the above code
has not been introduced by this patch. Anyway, is my understanding
correct that ufshcd_err_handler() can change the host controller state
from UFSHCD_STATE_EH_SCHEDULED_FATAL into UFSHCD_STATE_RESET and next
into UFSHCD_STATE_OPERATIONAL? If so, if the above code completes a READ
with status DID_BAD_TARGET and if recovery by the error handler
succeeds, will that cause the filesystem above the UFS driver to change
into read-only mode? If the above code completes a WRITE with status
DID_BAD_TARGET, will that cause data corruption? Is there any other
solution to prevent data corruption than merging the
UFSHCD_STATE_EH_SCHEDULED_FATAL and UFSHCD_STATE_EH_SCHEDULED_NON_FATAL
back into a single state and changing the ufshcd_rpm_get_sync(hba) call
in ufshcd_err_handling_prepare() into a pm_runtime_get_noresume() call?

Thanks,

Bart.
