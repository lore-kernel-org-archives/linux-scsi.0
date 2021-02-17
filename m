Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4FB9C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 22:31:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8832964E79
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 22:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbhBQWan (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 17:30:43 -0500
Received: from z11.mailgun.us ([104.130.96.11]:27150 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233940AbhBQWaN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Feb 2021 17:30:13 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613600988; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Cc: To: From: Date: Sender;
 bh=LcpeerQwr9nnsJvjmhs5Td+khk4yX/3Qw+1ErsogUrI=; b=GoNQ0KoPSIDb12dTF67+HiNqZWwRCW39ZyCui/FkwVn7MHL8oZLjQpM3NCz3fVL/UK42YyQc
 neqTuz4gw+9WT4xJCSmQPev5crdpHJJOsniK0zeoukMWMNb0waf22ISS2b5GjVhwz8TZrPfR
 TUu7bigdvfwdJv2gN33NdKh0Suc=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 602d98db3af8a933044237a7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 17 Feb 2021 22:29:47
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 23FE9C43467; Wed, 17 Feb 2021 22:29:47 +0000 (UTC)
Received: from stor-presley.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5B456C433CA;
        Wed, 17 Feb 2021 22:29:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5B456C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Date:   Wed, 17 Feb 2021 14:29:40 -0800
From:   Asutosh Das <asutoshd@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     "cang@codeaurora.org" <cang@codeaurora.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v3 1/1] scsi: ufs: Enable power management for wlun
Message-ID: <20210217222940.GA18897@stor-presley.qualcomm.com>
References: <cover.1613070911.git.asutoshd@codeaurora.org>
 <eed327cdace40d1e1d706da5b0fa64ea4ee99422.1613070912.git.asutoshd@codeaurora.org>
 <DM6PR04MB65758E0EBF4171FD6E1CF0CFFC8A9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <20210216173646.GA35819@stor-presley.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210216173646.GA35819@stor-presley.qualcomm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 16 2021 at 09:44 -0800, Asutosh Das wrote:
>On Sat, Feb 13 2021 at 13:37 -0800, Avri Altman wrote:
>>>+       } else {
>>Is it possible to get here?
>>Scsi_scan_host is called only after successful add_wluns
>
>It looks so.
>scsi 0:0:0:49488: Link setup for lun - ufshcd_setup_links
>[...]
>Call trace:
>dump_backtrace+0x0/0x1d4
>show_stack+0x18/0x24
>dump_stack+0xc4/0x144
>ufshcd_setup_links+0xd8/0x100
>ufshcd_slave_alloc+0x134/0x1a0
>scsi_alloc_sdev+0x1c0/0x230
>scsi_probe_and_add_lun+0xc0/0xd48
>__scsi_add_device+0xc0/0x138
>ufshcd_scsi_add_wlus+0x30/0x1c0
>ufshcd_async_scan+0x58/0x240
>async_run_entry_fn+0x48/0x128
>process_one_work+0x1f0/0x470
>worker_thread+0x26c/0x4c8
>kthread+0x13c/0x320
>ret_from_fork+0x10/0x18
>
>>
>>>+               /* device wlun is probed */
>>>+               hba->luns_avail--;
>>>+       }
>>>+}
>>>+
>>
>>
>>>
>>> /**
>>>@@ -7254,6 +7312,14 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba
>>>*hba)
>>>                goto out;
>>>        }
>>>        ufshcd_blk_pm_runtime_init(hba->sdev_ufs_device);
>>>+       /*
>>>+        * A pm_runtime_put_sync is invoked when this device enables
>>>blk_pm_runtime
>>>+        * & would suspend the device-wlun upon timer expiry.
>>>+        * But suspending device wlun _may_ put the ufs device in the pre-defined
>>>+        * low power mode (SSU <rpm_lvl>). Probing of other luns may fail then.
>>>+        * Don't allow this suspend until all the luns have been probed.
>>Maybe add one more sentence: see pm_runtime_mark_last_busy in ufshcd_setup_links
>Done.
>
>>
>>
>>
>>>-       ufshcd_clear_ua_wluns(hba);
>>Are there any callers left to ufshcd_clear_ua_wluns?
>>Can it be removed?
>Let me check.
>
I don't think this can be removed.
The reasoning behind this call as per the commit message indicates that if
there's a reset this request_sense is needed to clear uac.

In pm level 5, the reset would still happen. So I guess this is needed.
Please let me know if I'm missing something here.
The commit message didn't have much details otherwise.



>
>>
>>>+       if (hba->wlun_dev_clr_ua)
>>>+               ufshcd_clear_ua_wlun(hba, UFS_UPIU_UFS_DEVICE_WLUN);
>>>
>>>        cmd[4] = pwr_mode << 4;
