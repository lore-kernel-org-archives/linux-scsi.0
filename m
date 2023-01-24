Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA4EC54E94
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 18:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbjAXSBM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 13:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbjAXSBL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 13:01:11 -0500
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29C21026F
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 10:01:06 -0800 (PST)
Received: by mail-pg1-f175.google.com with SMTP id q9so11815646pgq.5
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 10:01:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QZFsTxNwz/0UvF7pU/No7bflr5IQEnjF1M26hVhcFf4=;
        b=oo8QBiEfpTYj7MKwtDtDdRuHq74LdmnYn83Yr9z+XPXAeoOYWkI9YARK6wg0oAxNvA
         dRR/AJ8SJt0pgIbhfkbvkO1V9jUsUV5Ea7Q1ACjMXWiBRtrM7y2y37BOTEGbWlQaE5i1
         NlMxuh0nXqa7+hEqzgcthZ+28pLEihuxjdZJjtcx68YyK37QQYnt8zacPur2lAB6nqhu
         7qDtiIqChyoXiGETbCM2o/RT0GBGmMvbx3okVlqVDgyEsNL5ryF7fSyIY0/gouDhEfXq
         VJzwlurjChbDgwijH9RpvaWls5th2ZlEbY71WnFsKpvlpvjflJPwJgaPbpH909sb4ULo
         rf7g==
X-Gm-Message-State: AFqh2ko79MtbfCWDxnEkrBq8ravmJVSuud53CiQ7mXgWmC2cqOp6rccg
        In4vW9L5MrF4EHSclOCp9U5zB1X5yJg=
X-Google-Smtp-Source: AMrXdXuwS0LTrORHW4hCPaTPDsEY1CHKLoAF6zfKeVRchM194uP64Y+XT3bE3S3WXJefohvp8hox6Q==
X-Received: by 2002:a05:6a00:288d:b0:58b:853f:75ad with SMTP id ch13-20020a056a00288d00b0058b853f75admr30070363pfb.12.1674583265990;
        Tue, 24 Jan 2023 10:01:05 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:c69a:cf2c:dc2d:7829? ([2620:15c:211:201:c69a:cf2c:dc2d:7829])
        by smtp.gmail.com with ESMTPSA id b10-20020aa7950a000000b0058dd9c46a8csm1897912pfp.64.2023.01.24.10.01.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 10:01:05 -0800 (PST)
Message-ID: <aa6759a1-44db-cb2d-8f12-1ef44dd03791@acm.org>
Date:   Tue, 24 Jan 2023 10:01:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3] scsi: add non-sleeping variant of scsi_device_put()
 and use it in alua
Content-Language: en-US
To:     mwilck@suse.com, Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
References: <20230124154953.17807-1-mwilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230124154953.17807-1-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 07:49, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Since the might_sleep() annotation was added in scsi_device_put() and
> alua_rtpg_queue(), we have seen repeated reports of "BUG: sleeping function
> called from invalid context" [1], [2]. alua_rtpg_queue() is always called
> from contexts where the caller must hold at least one reference to the scsi
> device in question. This means that the reference taken by
> alua_rtpg_queue() itself can't be the last one, and thus can be dropped
> without entering the code path in which scsi_device_put() might actually
> sleep.
> 
> Add a new helper function, scsi_device_put_nosleep() for cases like this,
> where a device reference is put from atomic context, and at the same time
> it is certain that this reference is not the last one, and use it from
> alua_rtpg_queue().

Something I should have asked earlier, has this alternative been 
considered? This alternative has the advantage that no new functions are 
introduced.

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1426b9b03612..9feb0323bc44 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -588,8 +588,6 @@ void scsi_device_put(struct scsi_device *sdev)
  {
  	struct module *mod = sdev->host->hostt->module;

-	might_sleep();
-
  	put_device(&sdev->sdev_gendev);
  	module_put(mod);
  }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 981d1bab2120..8ef9a5494340 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -452,5 +451,7 @@ static void scsi_device_dev_release(struct device
  	unsigned long flags;

+	might_sleep();
+
  	scsi_dh_release_device(sdev);

  	parent = sdev->sdev_gendev.parent;

Thanks,

Bart.
