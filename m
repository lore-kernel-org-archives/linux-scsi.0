Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 152FAC001DF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Aug 2023 09:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbjHDJUe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Aug 2023 05:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbjHDJT6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2023 05:19:58 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C2855AC
        for <linux-scsi@vger.kernel.org>; Fri,  4 Aug 2023 02:16:28 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3fe45481edfso8011825e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 Aug 2023 02:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691140586; x=1691745386;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SSpvyfA/MTZewnYAClf/EKSaz42AlvyVcqw57VCbq6w=;
        b=P8rl/MeDNY9MMRhSdX1qHvv9FnHARNEYV0kHF4NtfsDi7yvOfTMfmBGqbcINkWdrKe
         IlUEe19f6TpEXR2UANcCmSBdwfdCyhwQ1xERLE6BMsvz3RNSTo4RtytGC/W1chOpb4Yc
         w13jSMiZ4DsITtZ9MvXlFnuLnjhw+4SE2tpH9LoqvRjkhdguXP2I00DNsykePWJTJI4U
         3cyydXe4KwEGHStK8SH0Hb5q73Cc0NCcH69opZDQItUj5n+3sc7FhG7OeE2hMrQq9pdk
         tv6vcdI1moQVxXWPDqxBuwdGag+BlOCQUKm6aXiinh0C4HU/HYXdgyyx6eLRKEXiKpZC
         F2cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691140586; x=1691745386;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SSpvyfA/MTZewnYAClf/EKSaz42AlvyVcqw57VCbq6w=;
        b=M0vo1u4pdlv//juupJZLmFi7QaPQ/o9mkRFDPiMsooMcBYcBiz6qz/UgfI6W3TKPBM
         /Bko97ku85IrPqNToeZlSTYjuo6REYCYVppeo0J9a7uTWHkHHNETc9g9kv3ZQu8QaEqd
         t1iqW6lg18NjRZyrS+FVOY3uSMh+eX75W9q0paJF1DcUJfLvums3GVk9j4FBotYJcRjM
         vAg4z9yZ1R5nLysfTZYcpGvYChCDITHLuxlJqq0+7ESldzenSETkOWGPRkvAqMHjVrrm
         S+/EH1EyECK0MeEWJA+wykS2Ykt6sv/7Ei+mkdeejy07lWsrt4kDJHeDtyJmOOKy1TpV
         bqeQ==
X-Gm-Message-State: AOJu0YxSBDy0Pn1ET2Tve+BjRkZ6CsuYdlEu2uYRm92SuvmVTWdwunpL
        K8us2Bjb3whNgUv7GPxbUmqYRA==
X-Google-Smtp-Source: AGHT+IEobdys/V7ywDGQS1v9ksobI9pigajtu/Y1B+pWcks57VvjrtvcFgCiG6AWiI/+XmzsQClosQ==
X-Received: by 2002:a05:600c:2811:b0:3fe:1287:d2b0 with SMTP id m17-20020a05600c281100b003fe1287d2b0mr1122818wmb.3.1691140586564;
        Fri, 04 Aug 2023 02:16:26 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id j9-20020a5d4489000000b00314172ba213sm1996431wrq.108.2023.08.04.02.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 02:16:26 -0700 (PDT)
Date:   Fri, 4 Aug 2023 12:16:16 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     hare@suse.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: myrs: Add Mylex RAID controller (SCSI interface)
Message-ID: <69fc0c44-2c81-41b2-afcd-a75afcfc8c44@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Hannes Reinecke,

The patch 77266186397c: "scsi: myrs: Add Mylex RAID controller (SCSI
interface)" from Oct 17, 2018 (linux-next), leads to the following
Smatch static checker warning:

	drivers/scsi/myrs.c:1508 disable_enclosure_messages_store()
	warn: no lower bound on 'value' rl='s32min-2'

drivers/scsi/myrs.c
    1494 static ssize_t disable_enclosure_messages_store(struct device *dev,
    1495                 struct device_attribute *attr, const char *buf, size_t count)
    1496 {
    1497         struct scsi_device *sdev = to_scsi_device(dev);
    1498         struct myrs_hba *cs = shost_priv(sdev->host);
    1499         int value, ret;
                 ^^^^^^^^^

    1500 
    1501         ret = kstrtoint(buf, 0, &value);
    1502         if (ret)
    1503                 return ret;
    1504 
    1505         if (value > 2)

Smatch is complaining about negative values of value.  Why is 2 allowed
when ->disable_enc_msg is a bool?  We have a kstrtobool() function as
well, btw.

This is from an unpublished Smatch check but I'm working on it to get
it ready to release.

    1506                 return -EINVAL;
    1507 
--> 1508         cs->disable_enc_msg = value;
    1509         return count;
    1510 }

regards,
dan carpenter
