Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 103A1C77B61
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Apr 2023 17:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjDMRSa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Apr 2023 13:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjDMRS3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Apr 2023 13:18:29 -0400
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC4226A6
        for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2023 10:18:28 -0700 (PDT)
Received: by mail-pl1-f176.google.com with SMTP id p17so4512775pla.3
        for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2023 10:18:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681406307; x=1683998307;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uiJzLXaqMHZAeIjTmZriUxeD1P5s3FWn1V/kfl6lGy8=;
        b=b8FtBjo/9Jj6XfmnqhbJmqX1lc4a5cND/FpCn5Ti9/fmQWPRQzlDDRf4xx7zLsmeun
         7RyypQw/Qx+hQK/Br7VuykKsqDYGY1RNjH9HSt4hIMMaOsD6PydfuHZdgnZHkPUkLvK8
         c/lGfojSRbfp5cGpevUW4rdV+gB+HcY388HB/cT1nMYz21nIfbJjJbnGLPPhsnmSUp8G
         dyfe7rba9jmueHPF5431lZokV5xSKsutE96aQGRCdFREfcsxaHpIU+WlpEzpBdTyLueH
         5EDc6Yw1qpai4tvqJLy/3p9p2SFD/cawjEp31JlTBx7vHOrHRHzau60PG1Pv/aMxOQg/
         klrA==
X-Gm-Message-State: AAQBX9dHn3TWgf2mS8W3/nK54HXtZYxCB9v0+knbhIkm+1o+ArQ1ayvf
        gjAucfAhcELS7xR0Uwk3qH0=
X-Google-Smtp-Source: AKy350Z7QMUR0Y2/CVd48m14Npv6ByE8/n9eP++oVww13dp86QAQjB9N5c1bBk1YZKDNRYQPFxFELQ==
X-Received: by 2002:a17:903:114:b0:19d:ee88:b4d7 with SMTP id y20-20020a170903011400b0019dee88b4d7mr2666498plc.25.1681406307434;
        Thu, 13 Apr 2023 10:18:27 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:e8b4:403d:afdf:4586? ([2620:15c:211:201:e8b4:403d:afdf:4586])
        by smtp.gmail.com with ESMTPSA id p1-20020a1709026b8100b001a281063ab4sm1703603plk.233.2023.04.13.10.18.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 10:18:26 -0700 (PDT)
Message-ID: <d96ba4a5-207c-1374-f515-4a672305925b@acm.org>
Date:   Thu, 13 Apr 2023 10:18:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 1/3] scsi: sd: Let sd_shutdown() fail future I/O
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Tomas Henzl <thenzl@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230412204125.3222615-1-bvanassche@acm.org>
 <20230412204125.3222615-2-bvanassche@acm.org>
 <ZDdWXeV/DQjmhlnc@ovpn-8-18.pek2.redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZDdWXeV/DQjmhlnc@ovpn-8-18.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/23 18:09, Ming Lei wrote:
> On Wed, Apr 12, 2023 at 01:41:23PM -0700, Bart Van Assche wrote:
>> System shutdown happens as follows (see e.g. the systemd source file
>> src/shutdown/shutdown.c):
>> * sync() is called.
>> * reboot(RB_AUTOBOOT/RB_HALT_SYSTEM/RB_POWER_OFF) is called.
>> * If the reboot() system call returns, log an error message.
>>
>> The reboot() system call causes the kernel to call kernel_restart(),
>> kernel_halt() or kernel_power_off(). Each of these functions calls
>> device_shutdown(). device_shutdown() calls sd_shutdown().
>>
>> After sd_shutdown() has been called the .shutdown() callback of the LLD
>> will be called. This makes it unsafe to submit I/O after sd_shutdown()
>> has finished.
> 
> unsafe often means a bug, can you explain it in details about the 'unsafe'?

In this case that means that a kernel crash could be triggered.

>> +fail_future_io:
>> +	q = sdkp->disk->queue;
>> +	blk_queue_flag_set(QUEUE_FLAG_DYING, q);
>> +	blk_mq_freeze_queue(q);
>> +	blk_mq_unfreeze_queue(q);
> 
> freeze queue can slow down reboot a lot especially when there are lots of
> LUNs/Hosts because each device ->shutdown() is serialized.
> 
> I think it can be done by changing sdev state to SDEV_OFFLINE here.

Hi Ming,

Changing the SCSI device state is not sufficient to wait for pending 
commands to finish. How about replacing this patch with the patch below?


diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4bb87043e6db..4017b5412ba4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3699,12 +3699,13 @@ static int sd_start_stop_device(struct scsi_disk 
*sdkp, int start)
  static void sd_shutdown(struct device *dev)
  {
  	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	struct request_queue *q;

  	if (!sdkp)
  		return;         /* this can happen */

  	if (pm_runtime_suspended(dev))
-		return;
+		goto fail_future_io;

  	if (sdkp->WCE && sdkp->media_present) {
  		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
@@ -3715,6 +3716,14 @@ static void sd_shutdown(struct device *dev)
  		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
  		sd_start_stop_device(sdkp, 0);
  	}
+
+fail_future_io:
+	q = sdkp->disk->queue;
+	blk_queue_flag_set(QUEUE_FLAG_DYING, q);
+	if (!scsi_host_busy(sdkp->device->host))
+		return;
+	blk_mq_freeze_queue(q);
+	blk_mq_unfreeze_queue(q);
  }

  static int sd_suspend_common(struct device *dev, bool
