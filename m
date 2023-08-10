Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 794B3C001DE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Aug 2023 10:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbjHJKTO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Aug 2023 06:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbjHJKTN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2023 06:19:13 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B0D83
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2023 03:19:13 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3fe4ad22eb0so6243765e9.3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2023 03:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691662751; x=1692267551;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uPrudufINZTrgeTCEQipggbx0FgcH1TKgR4A7hDeMMA=;
        b=RhJz0b5w5EuazHWrc3hWOFJAJD2BqcSDLELKiMQVNBTIFWTcSyIkkCIUAkTJPCVZ92
         WRcAjB/FqWui2YgOIZ5XXhSW64cLA9yyriDpqlnmsvNCQnBcSGE0put42TpAWaZCyOrV
         m7EQYjg6tkQ24FM3Tz/hiF/R4uG0AnU4UdDDt0SXFZLMH85pouek1S17nql9wqHnA6/Y
         o4fKIljNtreow9MNSbY8oZfFB4YiTP9rZWY+PTUJjGlIHDfTp2jb9T6rnJLLWk9Bpj40
         brK/6K8ffpalw6kzjVTM3fXC1JX/gbY8vSrsgU8ExmyNp6CbDWEZWGTsqh4iFL7NWrz/
         W7+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691662751; x=1692267551;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uPrudufINZTrgeTCEQipggbx0FgcH1TKgR4A7hDeMMA=;
        b=YzsGRIpfYi7Hx5CXekMH7kJptiKP3+uWfNP8xgk8/Q6+cOixryMVX0PdOSo6/ogoyY
         37qjpIWZYJlHmrvYJDJ7XM9XiVyBgwhzbU+hslfJvh75Wp9022fZ4y4IQFZgJpe5J/O7
         x3lKe0tGqXo2AOWC6rtJAhCxC4Kt20e4WRiqxV4Z/NEFHMmsARSXFNWYJ9aAN2H57fZv
         PRT8LDHO2u+CWpIinRjftjvZ/RifX0H6T9m5RmyMOwoV44Tw6I4ebNthafNZIvjtyD+l
         UX/g9v5qxjFO07/77Hl0aGIqsMkR7gp1vG/q3+gw3QN6jWWyFCHNbxYrKfqWT1g1Ygfq
         twKg==
X-Gm-Message-State: AOJu0YxoK7yaljHE2jJeQsDax0/EbjIMQvPXb9W92V6r/GfEASQ07zRm
        X9N57Ph786Ezj+OeTRbmSpPD1g==
X-Google-Smtp-Source: AGHT+IE4r9B0909LG0iJY2iTsr28pKvnEBMbYQVNbfm9RK8Gcz1c00tBAhhySwOWeyHLV2BdNiMPMg==
X-Received: by 2002:a05:600c:152:b0:3fb:b5c0:a079 with SMTP id w18-20020a05600c015200b003fbb5c0a079mr1567699wmm.21.1691662751436;
        Thu, 10 Aug 2023 03:19:11 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id q12-20020a7bce8c000000b003fe26244858sm4551078wmj.46.2023.08.10.03.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 03:19:11 -0700 (PDT)
Date:   Thu, 10 Aug 2023 13:19:07 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     wangzhu9@huawei.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: core: Fix possible memory leak if device_add()
 fails
Message-ID: <5121c883-ef71-41d9-8153-472cf319a7b8@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Zhu Wang,

The patch 04b5b5cb0136: "scsi: core: Fix possible memory leak if
device_add() fails" from Aug 3, 2023 (linux-next), leads to the
following Smatch static checker warning:

	drivers/scsi/raid_class.c:255 raid_component_add()
	warn: freeing device managed memory (UAF): 'rc'

drivers/scsi/raid_class.c
   212  static void raid_component_release(struct device *dev)
   213  {
   214          struct raid_component *rc =
   215                  container_of(dev, struct raid_component, dev);
   216          dev_printk(KERN_ERR, rc->dev.parent, "COMPONENT RELEASE\n");
   217          put_device(rc->dev.parent);
   218          kfree(rc);
   219  }
   220  
   221  int raid_component_add(struct raid_template *r,struct device *raid_dev,
   222                         struct device *component_dev)
   223  {
   224          struct device *cdev =
   225                  attribute_container_find_class_device(&r->raid_attrs.ac,
   226                                                        raid_dev);
   227          struct raid_component *rc;
   228          struct raid_data *rd = dev_get_drvdata(cdev);
   229          int err;
   230  
   231          rc = kzalloc(sizeof(*rc), GFP_KERNEL);
   232          if (!rc)
   233                  return -ENOMEM;
   234  
   235          INIT_LIST_HEAD(&rc->node);
   236          device_initialize(&rc->dev);

The comments for device_initialize() say we cannot call kfree(rc) after
this point.

   237          rc->dev.release = raid_component_release;
                                  ^^^^^^^^^^^^^^^^^^^^^^^
From this point on calling put_device(&rc->dev) is the same as calling
raid_component_release(&rc->dev);

   238          rc->dev.parent = get_device(component_dev);
   239          rc->num = rd->component_count++;
   240  
   241          dev_set_name(&rc->dev, "component-%d", rc->num);
   242          list_add_tail(&rc->node, &rd->component_list);
   243          rc->dev.class = &raid_class.class;
   244          err = device_add(&rc->dev);
   245          if (err)
   246                  goto err_out;
   247  
   248          return 0;
   249  
   250  err_out:
   251          put_device(&rc->dev);
   252          list_del(&rc->node);
   253          rd->component_count--;
   254          put_device(component_dev);
   255          kfree(rc);

So this code is clearly a double free.  However, fixing it is not
obvious because why does raid_component_release() not call?

	list_del(&rc->node);
	rd->component_count--;

   256          return err;
   257  }

regards,
dan carpenter
