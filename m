Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDEBCC0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Aug 2023 05:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbjHKFkT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Aug 2023 01:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbjHKFkR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Aug 2023 01:40:17 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4686F2D43
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2023 22:40:16 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3fbea147034so14251065e9.0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2023 22:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691732415; x=1692337215;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hMLQo3bp2h3I51QElRS65GYn9jN1tJi7u7499fhe2Tg=;
        b=VxHfXqs/wz0YCnDzAhUPRCAI24WBV61ohHbvBe+M9d3TVFTr/42rijAHIPEMOqO9CH
         XYFZL4+QP8B2Gmy1KlGuqIw/F2FVkKM0kjcnQsLEeYeoP1TBPmpo3XhbRIhO8n+nGYWR
         oruqyujBsCR4MfeNcNgRHhIDsWANrdmEU8tEewkgKIGAb1dTk/Z/goSQ2GQOfCdLVMFw
         8+FN/CI2IkEb42dYVt/ZpEGSWRjmftGRi1DIUxiwrO3T5pB0uKdlM58p4XyDBrnm7659
         H4oct/e+rHjHja0mAThAYv7m7guW3O+16KMI6UdEdVZyd+dZfvhX/ZjQjxU+dOrI8uWk
         A3tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691732415; x=1692337215;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hMLQo3bp2h3I51QElRS65GYn9jN1tJi7u7499fhe2Tg=;
        b=ehhaDjw8FViMhaBsqJaHxViYCD2VE093OPuNmGXwjXMlwODMpjpX09JcI1Q3+Tf3/P
         5vEaHsbj0Cd7gSFo8cAWPB7YtHy140pUb5UhXPzi3UYREjmkh0p96PmSjOWxVFFS+ucZ
         QuaXKYDDnBtVqGrRw8wUyIRmWleleacwv6rzFf12fJZrY6lRjMNXg2rwsBARXSxV08fw
         hUMEBto76eVpdNlJdnye0ZewvPjlqVHG41b0Kvstc3yaknyp3ImgQtZHiGmr8Q9Fr6Yg
         qWmT0nlI1hqgxXaKq6QgKkDPskb2fENu7POTP8mCQcnY9QasWw5rC76hvyVCcuNd2Hzy
         GN7Q==
X-Gm-Message-State: AOJu0YyQAb4UnpVlGaeodUGVenZ0bYZC1ycoZNDb1sEfuj9gLzTsdVN6
        JKH3NSSmG2V/iBPHAovn/bkc3Q==
X-Google-Smtp-Source: AGHT+IFcrH/RRXHexJw7RrqV03fXgWcytHOtySGe+eUrHkaTY3C3VoWLCxoE8wYVyb/S241daSLVjQ==
X-Received: by 2002:a05:600c:215a:b0:3fe:b78:f4b1 with SMTP id v26-20020a05600c215a00b003fe0b78f4b1mr761050wml.2.1691732414708;
        Thu, 10 Aug 2023 22:40:14 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id m9-20020a7bcb89000000b003fe407ca05bsm6935252wmi.37.2023.08.10.22.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 22:40:14 -0700 (PDT)
Date:   Fri, 11 Aug 2023 08:40:11 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     wangzhu <wangzhu9@huawei.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [bug report] scsi: core: Fix possible memory leak if
 device_add() fails
Message-ID: <9d94e39b-24a1-4a74-9f5e-6c0327449b11@kadam.mountain>
References: <5121c883-ef71-41d9-8153-472cf319a7b8@moroto.mountain>
 <470fb552-7356-4a62-a4bd-545b4f94e040@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470fb552-7356-4a62-a4bd-545b4f94e040@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 10, 2023 at 08:05:21PM +0800, wangzhu wrote:
> Hello Dan Carpenter:
> 
> 
> Sorry for the patch 04b5b5cb0136 I submitted, I thought put_dev(&rc->dev) is
> not the same as kfree(rc).
> 
> Then should I submit a revert patch again, or you can fix it yourself?
> please let me know what I can do.
> 
> Sorry for the inconvenience again.
> 

It's easy enough for fix this...  Although instead of calling
list_add_tail() and then list_del() I probably would have prefered to
move the list_add_tail() right before the "return 0;"

-	list_add_tail(&rc->node, &rd->component_list);
	rc->dev.class = &raid_class.class;
	if (err)
		goto err_out;

+	list_add_tail(&rc->node, &rd->component_list);
	return 0;

But the diff I sent you is the more conservative option.

regards,
dan carpenter

diff --git a/drivers/scsi/raid_class.c b/drivers/scsi/raid_class.c
index 711252e52d8e..86ed1f66d749 100644
--- a/drivers/scsi/raid_class.c
+++ b/drivers/scsi/raid_class.c
@@ -248,11 +248,9 @@ int raid_component_add(struct raid_template *r,struct device *raid_dev,
 	return 0;
 
 err_out:
-	put_device(&rc->dev);
 	list_del(&rc->node);
 	rd->component_count--;
-	put_device(component_dev);
-	kfree(rc);
+	put_device(&rc->dev);
 	return err;
 }
 EXPORT_SYMBOL(raid_component_add);
