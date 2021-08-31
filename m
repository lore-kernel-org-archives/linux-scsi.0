Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE423C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Aug 2021 17:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B089F610A4
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Aug 2021 17:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbhHaRTR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Aug 2021 13:19:17 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:40930 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbhHaRTQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Aug 2021 13:19:16 -0400
Received: by mail-pg1-f173.google.com with SMTP id y23so17426667pgi.7
        for <linux-scsi@vger.kernel.org>; Tue, 31 Aug 2021 10:18:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hWp5g8SKYerFG0V1fsPHsm3RhC+/nBD8v+bAVGOsq3o=;
        b=GqE8Em86hOyKN3d+lhMkeytuL9NCLy1MW8+jyaBFsfDRAraXQV5AVDfEns2yvJUxmJ
         kv2BqnjgdYYXjAcEmEQPjVQkJXjdeINBKQhdl4JXETSEe6ZmQdnfd3k8k/ABYtJXJvhs
         VKGVhME1L7dEBH8xCMfmmTT3pVpegEWfZN924d1LIOl+ZiPAVSlSfx4tNeVhgcPsAFw5
         bJm8d3bJiSlJLqHv0Ul8QXicL3tgR9C68daGRBX1OMgwhlLeQNUdZN9IGzNORlCLFnns
         n8GYnzSQV9B5oJyKnrK03kKLmGGCXAt+KfcyoJkJ6MNn1bDhlLB+fJetBIkaFf4jWQLD
         daeA==
X-Gm-Message-State: AOAM531U0cPzLoPZUGmtdYwbCoaQJkjmORodT05s7SVhHi7oDmkDOawI
        HjWQHbnvi6tz9I9+J7UiZ6M=
X-Google-Smtp-Source: ABdhPJzmqPATQygExXWW0JMc/qetI1BZ7QRHBCGr0iZzTDcqWOmmJuEGWSsrCHLd2wXXy20JXKqbmA==
X-Received: by 2002:a63:452:: with SMTP id 79mr14900680pge.32.1630430300396;
        Tue, 31 Aug 2021 10:18:20 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:fbeb:2db7:c939:7c4b])
        by smtp.gmail.com with ESMTPSA id a10sm18000643pfo.75.2021.08.31.10.18.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 10:18:19 -0700 (PDT)
Subject: Re: [PATCH v3 16/18] scsi: ufs: Synchronize SCSI and UFS error
 handling
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20210722033439.26550-1-bvanassche@acm.org>
 <20210722033439.26550-17-bvanassche@acm.org>
 <88e0dc4c-34ff-6d87-fa9f-2fc924f50369@intel.com>
 <020bd6be-0944-8e25-c9fd-972cab5e6746@acm.org>
 <69fb9f57-54b6-072c-9f53-5da8b8e3202d@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <2719c43f-d56b-b2bb-0e34-53bcec74e0d9@acm.org>
Date:   Tue, 31 Aug 2021 10:18:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <69fb9f57-54b6-072c-9f53-5da8b8e3202d@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/31/21 12:24 AM, Adrian Hunter wrote:
> How does splitting the host_sem address the potential deadlock
> between the error handler and runtime resume?

Hmm ... how do runtime resume and the error handler deadlock? If 
shost->eh_noresume == 0 then scsi_error_handler() will call 
scsi_autopm_get_host() before invoking the eh_strategy_handler callback. 
The definition of scsi_autopm_get_host() is as follows:

int scsi_autopm_get_host(struct Scsi_Host *shost)
{
	int	err;

	err = pm_runtime_get_sync(&shost->shost_gendev);
	if (err < 0 && err !=-EACCES)
		pm_runtime_put_sync(&shost->shost_gendev);
	else
		err = 0;
	return err;
}

The power management operations used for shost_gendev instances are 
defined by scsi_bus_pm_ops (see also scsi_host_alloc()). The following 
function is the runtime resume function referenced by scsi_bus_pm_ops 
and skips shost_gendevs since these are not SCSI devices:

static int scsi_runtime_resume(struct device *dev)
{
	int err = 0;

	dev_dbg(dev, "scsi_runtime_resume\n");
	if (scsi_is_sdev_device(dev))
		err = sdev_runtime_resume(dev);

	/* Insert hooks here for targets, hosts, and transport classes*/

	return err;
}

In addition to the above function the runtime resume callback of the UFS 
platform device is also invoked. I think all these functions call 
ufshcd_runtime_resume(). As far as I can see ufshcd_runtime_resume() 
does not touch host_sem?

Bart.
