Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FEBC433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 11:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD224206D8
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 11:47:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="c11L0oJG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgGZLr1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 07:47:27 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.2]:24095 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725794AbgGZLr0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 26 Jul 2020 07:47:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1595764043; i=@ts.fujitsu.com;
        bh=4RsOc36uFgmJoUKqePmE8Dow4FvCrjzPDrAS4P+3E7Y=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=c11L0oJGYktcaIbnTvFReF+adX/m9Yu7E3WLNtUTzP6g41xLxYVmt99QRrkouYSkM
         AGIBQE1WH10hdhRCICduqflLtd6RAINAohvqz32tKDIjEyG5IgsIXYMbt9xH1hza70
         smcs1x9TlG/AJtrYSQ89zr8ILjZpUoSQseqgk1J+JJKSbVkT1dTOxdvIadTiRUwE1k
         u2leEEGee8d89KVckGG0FrnE+3I99vZepLF4cqKJG0dcwFcHXRH6q5La/uQhxTs12N
         /1wNCBomk9XjT5Zf7rYPn/FBSlNsaJa9eqG4ao641oVahYWx88qMNIuNUJwsKBIXDp
         98LFAebKTZ+4A==
Received: from [100.113.3.12] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-a.eu-central-1.aws.symcld.net id AE/3D-55518-A4D6D1F5; Sun, 26 Jul 2020 11:47:22 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRWlGSWpSXmKPExsViZ8MRouuVKxt
  vsPAKn0X39R1sFsuP/2Oy+DvpBqtF69K3TA4sHh+f3mLx+LxJLoApijUzLym/IoE1o2v5GsaC
  X0IVT+b/ZWtgvMvfxcjFISQwmVFi5q85rBBOP6PEvluL2LoYOTmEBfwknvw4zQaSEBFYwyix6
  PVSJoiqpYwSK9fvA6tiEzCQWDHpPksXIwcHr4CjxOajJSBhFgFViSs397ODhEUFwiWerfAHCf
  MKCEqcnPkErJpTwE7i0R0VkDCzgLrEn3mXmCFscYlbT+YzQdjyEtvfzmGewMg3C0n3LCQts5C
  0zELSsoCRZRWjZVJRZnpGSW5iZo6uoYGBrqGhsa4hkDTXS6zSTdRLLdVNTs0rKUoEyuollhfr
  FVfmJuek6OWllmxiBIZzSiFj6Q7GaW8+6B1ilORgUhLlnRYiGy/El5SfUpmRWJwRX1Sak1p8i
  FGGg0NJglchAygnWJSanlqRlpkDjC2YtAQHj5II791MoDRvcUFibnFmOkTqFKOilDhvfTZQQg
  AkkVGaB9cGi+dLjLJSwryMDAwMQjwFqUW5mSWo8q8YxTkYlYR5dUGm8GTmlcBNfwW0mAlosfs
  lSZDFJYkIKakGpmUfrpZlNq/5cEho5hZGN/GoT3kX39vwaIlwn78gFzBbyHvLO+HA550Gj8pU
  Vc7L5M6ed5BHd1pb0J0lnV2fF84uiWm1Ouq31+PACl25jsUCXpL6T96u5Zlp+mVthh0TL9f0Z
  c/WJrZ/mlFav+Kx1Kalhz1/u/d6rt4t4hW+6l/Iq/Ysx7mrqybv7VxddHPxo3a+59Eyd7JfKj
  E7X2KxL1zL+DvjY/rxpAfvlhd0W14Tb+KPszZ5rrj+jPv3nnWaeQ47hZO0FvWF2j7UzxNt2KB
  2YP/ZRa9n/+nef2j1FA2NXqf0tcdfvn9TzStQE/x2zWHWBapHp9ZVmlvufLNh7peKPR1HClcv
  FvG94Trj+0ElluKMREMt5qLiRAB7AopQYgMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-30.tower-228.messagelabs.com!1595764041!145249!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 23058 invoked from network); 26 Jul 2020 11:47:22 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-30.tower-228.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 26 Jul 2020 11:47:22 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06QBlL03031423;
        Sun, 26 Jul 2020 12:47:21 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id 3905320478;
        Sun, 26 Jul 2020 13:47:20 +0200 (CEST)
Subject: Re: [PATCH v2 8/8] scsi: target: tcmu: Make TMR notification optional
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200717161212.10731-1-bstroesser@ts.fujitsu.com>
 <20200717161212.10731-9-bstroesser@ts.fujitsu.com>
 <454b34ff-47c6-f54d-7b52-642b08f8cbd1@oracle.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <386df45e-bc4c-46a8-d671-9e9b24814af9@ts.fujitsu.com>
Date:   Sun, 26 Jul 2020 13:47:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <454b34ff-47c6-f54d-7b52-642b08f8cbd1@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-26 02:06, Mike Christie wrote:
> On 7/17/20 11:12 AM, Bodo Stroesser wrote:
>> Add "tmr_notification" configFS attribute to tcmu devices.
>> If default value 0 of the attribute is used, tcmu only
>> removes aborted commands from qfull_queue.
>> If user changes tmr_notification to 1, additionally
>> TMR notifications will be written to the cmd ring.
>>
>> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
>> ---
>>   drivers/target/target_core_user.c | 39 +++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 39 insertions(+)
>>
>> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
>> index 92b7a2e84e64..95e66b707373 100644
>> --- a/drivers/target/target_core_user.c
>> +++ b/drivers/target/target_core_user.c
>> @@ -118,6 +118,7 @@ struct tcmu_dev {
>>   #define TCMU_DEV_BIT_OPEN 0
>>   #define TCMU_DEV_BIT_BROKEN 1
>>   #define TCMU_DEV_BIT_BLOCKED 2
>> +#define TCMU_DEV_BIT_TMR_NOTIFY 3
>>   	unsigned long flags;
>>   
>>   	struct uio_info uio_info;
>> @@ -1260,6 +1261,9 @@ tcmu_tmr_notify(struct se_device *se_dev, enum tcm_tmreq_table tmf,
>>   	if (unqueued)
>>   		tcmu_set_next_deadline(&dev->qfull_queue, &dev->qfull_timer);
>>   
>> +	if (!test_bit(TCMU_DEV_BIT_TMR_NOTIFY, &dev->flags))
>> +		goto unlock;
>> +
>>   	pr_debug("TMR event %d on dev %s, aborted cmds %d, afflicted cmd_ids %d\n",
>>   		 tcmu_tmr_type(tmf), dev->name, i, cmd_cnt);
>>   
>> @@ -2706,6 +2710,40 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
>>   }
>>   CONFIGFS_ATTR(tcmu_, emulate_write_cache);
>>   
>> +static ssize_t tcmu_tmr_notification_show(struct config_item *item,
>> +					       char *page)
> 
> Sorry about this. Just some nits.
> 
> The spacing above got messed up a little. I think you only need 2 spaces, but it looks like we got some extras.

I'll fix.

> 
> 
>> +{
>> +	struct se_dev_attrib *da = container_of(to_config_group(item),
>> +					struct se_dev_attrib, da_group);
>> +	struct tcmu_dev *dev = TCMU_DEV(da->da_dev);
> 
> 
> Could you use udev or tcmu_dev for the name. Sorry for being a broken record on this one. We use dev or se_dev for the se_device struct already and it throws me off when scanning the code.
> 
> I think patch 5 and 7 need the same fix up.
> 

I think I missunderstood your previous writing. I intentionally used dev and not udev because I thought you wanted it ...

No problem. I'll fix. 
