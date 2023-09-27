Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C16FCE82CA1
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 14:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbjI0OzK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 10:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbjI0OzJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 10:55:09 -0400
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB3FF4;
        Wed, 27 Sep 2023 07:55:08 -0700 (PDT)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1c6219307b2so47776155ad.1;
        Wed, 27 Sep 2023 07:55:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695826508; x=1696431308;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FwuoirC5/alxCyx4Z02Z0TdCSZekLLl+v1JapU8py78=;
        b=t/CZx05sPYhazUW17odxloJmDVCc3QHFr8Ve59sWI7JhfbHqZUA7Tu/+cBMS988JyT
         70MyC4ZWLSGSskEWIZ4sgqBQqX8yxzrGIa+P/goUigt2MAtiRVZkhz0n2izMnRXGMvp2
         9sxkIgfbQCF1ZsXTaOyCKUD/fErDjMKFD8KSGPQmVOFda9EbXcxPX+Bp/ig4DijLx560
         kk/jqHC8wlQys6eBuAq/Bg9/dobc4LDMD7IkkQgx7eoNBg5L43ckzBkI/gcXNN0g/mhF
         CCjibEYg8hoxjwC22/TAtX6Udn6BBO/7SsoFuSzuR+kRTu9JA+tRm1SU+tovv+LX5KKF
         FVPA==
X-Gm-Message-State: AOJu0YzcrbvOGId5phFHqp1lXg495Nu3bGHwXA8w+Xy9kC6OkeSE6SMd
        HmgsttHH/QBTMf2ZiCtpwvmeeJekCsW9sA==
X-Google-Smtp-Source: AGHT+IFbQ+mD+lONq9LDtgV2Y8Wnp++/QuP0FWQsdkBVXRGqgKNq1K89BaoZIpdfLfc4FZsekN7yNg==
X-Received: by 2002:a17:902:74c7:b0:1c3:9f2b:4d08 with SMTP id f7-20020a17090274c700b001c39f2b4d08mr2048088plt.20.1695826507556;
        Wed, 27 Sep 2023 07:55:07 -0700 (PDT)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id 17-20020a170902ee5100b001b7cbc5871csm3646169plo.53.2023.09.27.07.55.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Sep 2023 07:55:07 -0700 (PDT)
Message-ID: <540deb44-d213-4c55-8227-894b74eae27c@acm.org>
Date:   Wed, 27 Sep 2023 07:55:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 09/23] scsi: sd: Do not issue commands to suspended
 disks on shutdown
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230926081507.69346-1-dlemoal@kernel.org>
 <20230926081507.69346-10-dlemoal@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230926081507.69346-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/26/23 01:14, Damien Le Moal wrote:
> @@ -3891,21 +3895,26 @@ static int sd_suspend_runtime(struct device *dev)
>   static int sd_resume(struct device *dev, bool runtime)
>   {
>   	struct scsi_disk *sdkp = dev_get_drvdata(dev);
> -	int ret;
> +	int ret = 0;
>   
>   	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
>   		return 0;

As far as I can tell there is nothing that prevents system wide
suspend or resume after a SCSI disk has been discovered and before
sd_probe() is called(). So I think that "sdkp->suspended = false;"
has to be added in the above if-statement. This is the how SCSI
disks are registered (synchronous case only):

scsi_probe_and_add_lun(target, bflagsp, sdevp, rescan, hostdata)
   scsi_alloc_sdev(starget, lun, hostdata)
     __scsi_init_queue(&sdev->host)
     scsi_sysfs_device_initialize(sdev)
     shost->hostt->slave_alloc(sdev)
   scsi_probe_lun(sdev, ...)
     scsi_execute_req(sdev, INQUIRY)
   scsi_add_lun(sdev, ...)
     scsi_device_set_state(sdev, SDEV_RUNNING)
     sdev->host->hostt->slave_configure(sdev) /* may do I/O */
     scsi_sysfs_add_sdev(sdev) /* enables runtime PM */
       scsi_target_add(starget)
       device_add(&sdev->sdev_gendev)
         kobject_add(&dev->kobj, ...)
         bus_add_device(dev)
         bus_probe_device(dev)
           device_initial_probe(dev)
             __device_attach(dev, /*allow_async=*/true)
               __device_attach_driver(drv, dev, ...)
                 driver_probe_device(drv, dev)
                   really_probe(dev, drv)
                     dev->bus->probe(dev) = sd_probe(dev)
                       gd = blk_mq_alloc_disk_for_queue()
                       device_add(&sdkp->dev)
                       sd_revalidate_disk(gd)
                       device_add_disk(dev, gd, NULL)
       device_add(&sdev->sdev_dev)
       bsg_scsi_register_queue(rq, &sdev->sdev_gendev)

Thanks,

Bart.

