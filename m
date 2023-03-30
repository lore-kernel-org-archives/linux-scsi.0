Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68539C761AF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Mar 2023 11:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbjC3LBC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Mar 2023 07:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbjC3LBB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Mar 2023 07:01:01 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F3F8699
        for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2023 04:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1680174060; x=1711710060;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4lDbixJMPcd5wP9wYZ11Y/OsJSzsmhAS1PKVDV6/1dg=;
  b=FVSxQ6P7dEhNzTn5FQ72ywX2qK6jlVFJjZ+N18M8uiSSnukxk4a9jHai
   z6eBxNp71/i6qCVgHbscmbmQDrV3EvHwL4nAkD+hZe9FIDbDAzr2xR+7m
   h8QZodB0XtP0UwJy4ewO8U3DbYecDOI4YLlIx8N7c4zx/m6jB5BRyfS8V
   PaYNyNyM9OsJL9lh8oeoWsrF20hO6VlIizZaSjgNs8AyctVZ/YiFc1t/1
   WxjHqBcB14rxRSq6/N0rrwK+P7f+RuSNWSPhYuyF6jkMgjiIvouBcLZW8
   wqSYZO5ehoHlkKIQrlQhRDgUIaOJyjOIVOpKfjrPFBAWQ5eqT6XsODzpF
   g==;
X-IronPort-AV: E=Sophos;i="5.98,303,1673884800"; 
   d="scan'208";a="226873573"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 19:00:58 +0800
IronPort-SDR: S00eI3NWB2L2IqZrURwY5OqsBNBxvNJxoknXrs9iY64wDVEpzk5pTYclNN/f10/oe05q8+3vKD
 fGKWqj1YRiwv/kwmNqh/6U1MUQVad0wWABcQIytRJGyi6D0/InCk7zliruRVKhddd0DeJWKvX6
 Ab7PTdA4IAyafCiQZ8kP0cTghfTbEOzjEpHm8uSiIGBZ4TNDTls2uX0y9I10cLr5KkuUkisY8V
 gbeOfENLpex1YRFChiS5zb8gCXL8e3Z2D8hIYVYaRnxQkAWp9KF4vxEwUfsJ0VsHtUNw+SjDH0
 vg4=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Mar 2023 03:17:07 -0700
IronPort-SDR: TCsSgCYxmaWCpfQA5RalR8gFifmdesKCzUsmOPcnNCLg1XifgVVJgYS1SdImylTSzbLpUL8UMy
 lBZNRl6FfOCQO5XH+f1bbDlos0rjeLnPKJRvlucYu/4ZOJBNiO12zjn7236n9j2NkR/ZURtzyd
 GZ4MpuRMH8yYUStnQeBaf6Tc189/mqtq+QJtGFQMK3uFJL4v5jT+V+RbfnShwRdzl37ttS1/Vg
 14v6aUerLprP4/t7k++RlniQ70IB4pYx6xT3CqO2+/9aYNqYhFj0QFnH5LIhz2310ooTsvnvh+
 Zx8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Mar 2023 04:00:59 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PnL7Z2ftMz1RtVx
        for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2023 04:00:58 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1680174057; x=1682766058; bh=4lDbixJMPcd5wP9wYZ11Y/OsJSzsmhAS1PK
        VDV6/1dg=; b=Tf9YmTi6cSEPYhNBcVj29Y6QaK8WCeH3ODUk5xdxDZcFBBt9WbU
        W5pkvplm+C9y1YR5ajmopLRQUFIvarb0X1YYk8DLPZCztt5Vsiejz8kPt3fK6aS6
        MpfoPpsJLNACxfXlZp9eQcGs9JzjxFFimpOjJRFyM+GLEi4F3WZcZt8SnA7rmqFD
        ImBy/QhjZmBzfTaIbRxGK07vzHN12cpL53FK6M+5tWo9Sxz/vJxQgS7vDd7IFN7O
        ZhwCT7laeDEY143I6X1PhGmLKgp71nIBlK78UQvr55NMackD0GX/liCbCPMnMp+4
        S7thKGZbBdq1oR8gts3nv9o0z8U5U6OiRhg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id NLiHrayslSb5 for <linux-scsi@vger.kernel.org>;
        Thu, 30 Mar 2023 04:00:57 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PnL7X2KcYz1RtVn;
        Thu, 30 Mar 2023 04:00:56 -0700 (PDT)
Message-ID: <97a2129c-b1d8-de74-014a-07e89ae95b30@opensource.wdc.com>
Date:   Thu, 30 Mar 2023 20:00:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] scsi: target: return -ENOMEM when kzalloc failed
Content-Language: en-US
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
References: <20230330023834.97455-1-jiapeng.chong@linux.alibaba.com>
 <73695d8e-a779-3c9c-5a46-b5a23381dff2@nvidia.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <73695d8e-a779-3c9c-5a46-b5a23381dff2@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/30/23 16:59, Chaitanya Kulkarni wrote:
> On 3/29/23 19:38, Jiapeng Chong wrote:
>> The driver is using -1 instead of the -ENOMEM defined macro to specify
>> that a buffer allocation failed.
>>
>> drivers/target/iscsi/iscsi_target.c:691 iscsi_target_init_module() warn: returning -1 instead of -ENOMEM is sloppy.
>>
>> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
>> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4644
>> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
>> ---
>>   drivers/target/iscsi/iscsi_target.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>> index 834cce50f9b0..d3a40c3caaf5 100644
>> --- a/drivers/target/iscsi/iscsi_target.c
>> +++ b/drivers/target/iscsi/iscsi_target.c
>> @@ -688,7 +688,7 @@ static int __init iscsi_target_init_module(void)
>>   	pr_debug("iSCSI-Target "ISCSIT_VERSION"\n");
>>   	iscsit_global = kzalloc(sizeof(*iscsit_global), GFP_KERNEL);
>>   	if (!iscsit_global)
>> -		return -1;
>> +		return -ENOMEM;
>>   
>>   	spin_lock_init(&iscsit_global->ts_bitmap_lock);
>>   	mutex_init(&auth_id_lock);
> 
> you can also just use goto out, it has return -ENOMEM, no biggy..
> Also, it will be useful to print the error message here as we
> are making this change..

Printing an error message for allocation failures is frowned upon. Checkpatch
will complain.

-- 
Damien Le Moal
Western Digital Research

