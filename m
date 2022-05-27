Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C66C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 27 May 2022 07:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbiE0HPv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 May 2022 03:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347645AbiE0HPb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 May 2022 03:15:31 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D523F40A2C
        for <linux-scsi@vger.kernel.org>; Fri, 27 May 2022 00:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1653635730; x=1685171730;
  h=message-id:date:mime-version:from:subject:to:references:
   in-reply-to:content-transfer-encoding;
  bh=Uq6Y6JcpS+LMkF9yM/5ASHepbZuL0onP3nIIGb/A/X8=;
  b=S53hQTzEUhZUvy/SQIjs5Hxlstbz6sXJ/8IkyyuJQGzEaeivK/Xfs0ce
   4JUepd02+sPqlmSwPcMTCIyDkmhHSd0fEEBMxpBmyv52JhWYDKH+RIHIj
   miDVD7X5Q7Ambo31alerQ5MxY/Oa9VuL+LBUo46mWMsZ5bMepQCse11t1
   Sc+2Q3ckn4wdscy63OkIpbnHIcI0RsRCyL9DtPVvlFMeR3UewCEjjm3Ki
   KljQMm95wR3CFR+0EEBsV9uBNgq6UsWrDNZOREqz2Hi+8n0RaH4SPXX12
   8KgKsAjyW3VE2m4Zgbx4bOUPEmJRl4rujUHPBoANN47cJnM4bACZiBEUE
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,254,1647273600"; 
   d="scan'208";a="202415916"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 May 2022 15:15:27 +0800
IronPort-SDR: DYBBkU0UWyFo8jA1TcPgv+4mRK8sR0a+nYokNGLWFCMHMC37qIJcG94aQh0s9LmBEcMtjxoTEb
 tqm2HTewegzvBaw1NZLA0mDDCWR8TtxcKs6r7+SCIbuohHqgK4uTXpCMegjYAeP+xM43GOdX17
 P69cExEYglxlJIp7kkBz0++nGMQzAb6CZq72Fl5iTTVkpOxzw7s7MqxhfqHVppzXvoUQ4Jj50e
 ocyzNSOIBW3wUtHPsXRgIyBhY30UOeu6fJaDx0OXeVSgSUdKpZSaYF2CsbMKHITx4LZbBj0U1X
 zVNBjuxz3Y9WC+4WlTP1VHPU
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 May 2022 23:39:20 -0700
IronPort-SDR: m11h//wW9u/EVGD046qyUfxtbxhSSwd/qRyjnx7MdP51lhxwD8I7Y4zj4A0mcw8uGWbQzK0Ttr
 3+8CugGUKbhR7PHLGCLdV6MBnnWsOmN7oFNHlh0dEGoFMpCBUaUqO9pS91nYLyPt89rQxgUnML
 qE5KGZlZJry6AJIji69uf/hS5YKKmyT0WKP+cKv/ornREJvRqkx66e79zNfzYPXSpZhSSpW575
 CCW4u8hClvebQKXaS1cMP6VxUVa+ygKVpRrzRuQDdU6BFqwFtU6/zXAIaJLcfB6C/+tWs//R8u
 Kco=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 May 2022 00:15:28 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4L8bg25YKmz1SHwl
        for <linux-scsi@vger.kernel.org>; Fri, 27 May 2022 00:15:26 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:content-language:references:to:subject
        :from:user-agent:mime-version:date:message-id; s=dkim; t=
        1653635726; x=1656227727; bh=Uq6Y6JcpS+LMkF9yM/5ASHepbZuL0onP3nI
        IGb/A/X8=; b=XtY3DQZwgwlIB7gLXrn6o2ydAFXNcTo4iCqd+S55/vxOOgtFaUL
        w04lrZbN6tulVtPQHbn/QEBJz5IZDUxPinI0/4OfxlyUyM2fykMC2Djrz2f6ttnC
        yYEZJsXuZv1MBKe49DsmbqvqS8G01UsiFf2e3tHf0mMRJZeW6kXSz24IYprxPR9y
        LxBwYSHKfdVlSaxJ+sMxKM+yDuGNbsrVG9v5YoCI2hGvAhk6hYwmprrDpTT9SD0T
        xG3QHrfThArB2i7vi0ro2583i6D+uhVxUAlPGD64UOUOKvyu7jpzGRqhWOJ7Y4cR
        GDd84aSFuxzBVkfeAP9YYsXSkbnnMVnDlLg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id jVI1Zc5a7Fje for <linux-scsi@vger.kernel.org>;
        Fri, 27 May 2022 00:15:26 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4L8bg13fXrz1Rvlc;
        Fri, 27 May 2022 00:15:25 -0700 (PDT)
Message-ID: <3f35b011-4aab-4c9e-4a0d-220d7babba5d@opensource.wdc.com>
Date:   Fri, 27 May 2022 16:15:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: Null Pointer Dereference in sd_zbc_release_disk
To:     Dongliang Mu <mudongliangabcd@gmail.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <CAD-N9QXY57RvFwGQvh8U7WBc3JCX-0kpqB6+fZ=oJJtHmFdUwg@mail.gmail.com>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <CAD-N9QXY57RvFwGQvh8U7WBc3JCX-0kpqB6+fZ=oJJtHmFdUwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/05/27 14:51, Dongliang Mu wrote:
> Hi maintainers,
> 
> I found a NPD(Null Pointer Dereference) in sd_zbc_release_disk function.
> 
> There are two definitions of sd_zbc_release_disk:
> 
> #ifdef CONFIG_BLK_DEV_ZONED
> void sd_zbc_release_disk(struct scsi_disk *sdkp);
> #else /* CONFIG_BLK_DEV_ZONED */
> static inline void sd_zbc_release_disk(struct scsi_disk *sdkp) {}
> #endif
> 
> When CONFIG_BLK_DEV_ZONED=y, the function implementation is as follows:
> 
> void sd_zbc_release_disk(struct scsi_disk *sdkp)
> {
>     if (sd_is_zoned(sdkp))
>         sd_zbc_clear_zone_info(sdkp);
> }
> 
> static inline int sd_is_zoned(struct scsi_disk *sdkp)
> {
>     return sdkp->zoned == 1 || sdkp->device->type == TYPE_ZBC;
> }
> 
> In drivers/scsi/sd.c, sd_probe() allocates sdkp with kzalloc(). If
> errors occurred before the assignment "sdkp->device", after the
> allocation, it will triggers a NPD in sd_is_zoned.
> 
> I am not familiar with kernel configuration. Does anyone have a
> suggestion to fix this NPD?
> 
> I really appreciate any help you can provide.

Can you try this patch:

 From 875899a114bce34f9549857ce87ea309b366b1cb Mon Sep 17 00:00:00 2001
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Date: Fri, 27 May 2022 16:07:20 +0900
Subject: [PATCH] scsi: sd_zbc: Fix potential NULL pointer dereference

If sd_probe() sees an error before sdkp->device is initialized,
sd_zbc_release_disk() is called, which causes a NULL pointer dereference
when sd_is_zoned() is called. Avoid this by turning
sd_zbc_release_disk() into a nop if sdkp->device is NULL.

Reported-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
  drivers/scsi/sd_zbc.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 5b9fad70aa88..236a766c8de4 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -804,7 +804,7 @@ static void sd_zbc_clear_zone_info(struct scsi_disk 
*sdkp)

  void sd_zbc_release_disk(struct scsi_disk *sdkp)
  {
-	if (sd_is_zoned(sdkp))
+	if (sdkp->device && sd_is_zoned(sdkp))
  		sd_zbc_clear_zone_info(sdkp);
  }

-- 
2.36.1


-- 
Damien Le Moal
Western Digital Research
