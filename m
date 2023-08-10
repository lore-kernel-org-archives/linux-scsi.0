Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 320EDC04A94
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Aug 2023 12:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbjHJMF1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Aug 2023 08:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234561AbjHJMF0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2023 08:05:26 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5043A10F3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2023 05:05:25 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RM5F528C3z1L9w8;
        Thu, 10 Aug 2023 20:04:09 +0800 (CST)
Received: from [10.67.110.142] (10.67.110.142) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 10 Aug 2023 20:05:21 +0800
Message-ID: <470fb552-7356-4a62-a4bd-545b4f94e040@huawei.com>
Date:   Thu, 10 Aug 2023 20:05:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] scsi: core: Fix possible memory leak if device_add()
 fails
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@linaro.org>
CC:     <linux-scsi@vger.kernel.org>
References: <5121c883-ef71-41d9-8153-472cf319a7b8@moroto.mountain>
From:   wangzhu <wangzhu9@huawei.com>
In-Reply-To: <5121c883-ef71-41d9-8153-472cf319a7b8@moroto.mountain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.142]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Dan Carpenter:


Sorry for the patch 04b5b5cb0136 I submitted, I thought 
put_dev(&rc->dev) is not the same as kfree(rc).

Then should I submit a revert patch again, or you can fix it yourself? 
please let me know what I can do.

Sorry for the inconvenience again.


Best regards,

Zhu Wang.


On 2023/8/10 18:19, Dan Carpenter wrote:
> Hello Zhu Wang,
>
> The patch 04b5b5cb0136: "scsi: core: Fix possible memory leak if
> device_add() fails" from Aug 3, 2023 (linux-next), leads to the
> following Smatch static checker warning:
>
> 	drivers/scsi/raid_class.c:255 raid_component_add()
> 	warn: freeing device managed memory (UAF): 'rc'
>
> drivers/scsi/raid_class.c
>     212  static void raid_component_release(struct device *dev)
>     213  {
>     214          struct raid_component *rc =
>     215                  container_of(dev, struct raid_component, dev);
>     216          dev_printk(KERN_ERR, rc->dev.parent, "COMPONENT RELEASE\n");
>     217          put_device(rc->dev.parent);
>     218          kfree(rc);
>     219  }
>     220
>     221  int raid_component_add(struct raid_template *r,struct device *raid_dev,
>     222                         struct device *component_dev)
>     223  {
>     224          struct device *cdev =
>     225                  attribute_container_find_class_device(&r->raid_attrs.ac,
>     226                                                        raid_dev);
>     227          struct raid_component *rc;
>     228          struct raid_data *rd = dev_get_drvdata(cdev);
>     229          int err;
>     230
>     231          rc = kzalloc(sizeof(*rc), GFP_KERNEL);
>     232          if (!rc)
>     233                  return -ENOMEM;
>     234
>     235          INIT_LIST_HEAD(&rc->node);
>     236          device_initialize(&rc->dev);
>
> The comments for device_initialize() say we cannot call kfree(rc) after
> this point.
>
>     237          rc->dev.release = raid_component_release;
>                                    ^^^^^^^^^^^^^^^^^^^^^^^
> >From this point on calling put_device(&rc->dev) is the same as calling
> raid_component_release(&rc->dev);
>
>     238          rc->dev.parent = get_device(component_dev);
>     239          rc->num = rd->component_count++;
>     240
>     241          dev_set_name(&rc->dev, "component-%d", rc->num);
>     242          list_add_tail(&rc->node, &rd->component_list);
>     243          rc->dev.class = &raid_class.class;
>     244          err = device_add(&rc->dev);
>     245          if (err)
>     246                  goto err_out;
>     247
>     248          return 0;
>     249
>     250  err_out:
>     251          put_device(&rc->dev);
>     252          list_del(&rc->node);
>     253          rd->component_count--;
>     254          put_device(component_dev);
>     255          kfree(rc);
>
> So this code is clearly a double free.  However, fixing it is not
> obvious because why does raid_component_release() not call?
>
> 	list_del(&rc->node);
> 	rd->component_count--;
>
>     256          return err;
>     257  }
>
> regards,
> dan carpenter
