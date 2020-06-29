Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68A3C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 23:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A06920780
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 23:14:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="vFf+Id/y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbgF2XO0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 19:14:26 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.2]:49526 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726180AbgF2XO0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jun 2020 19:14:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1593420813; i=@ts.fujitsu.com;
        bh=cbG5NOwyLc3AqnYYvEsDThu3inPz53X98TvlIekIdLo=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=vFf+Id/yazAb6ixz+MRuJQAHWSXRXxzmAukodeaJSISOZX6zW3bJE/Iim5mmsTBo5
         Ci7jzmCf6rOA4yPpPwAgkhr3KTfWsDcM4zUYvy7T7axnNn1hA6tjKDcDrxpK1mRHmN
         7GI9u/obKwBZT+jahwgmydM255DxTJBnzdxbuhsqerrKZv/Ts3w5TrrpJ5by4AxsWp
         KUZ/hk8hhz2yfQ7WfLAHMAkiU+mP4h5fstwkr+CtuDyc3Jd66pMd7rmNAj5n4ruYCl
         DglnztyHvgDJIztRuUcB/jscF9pb26StKBGgW/at7dvXxLzTDd04cmgmASicX4vXeK
         v7cA5mTzgk/cw==
Received: from [100.113.3.51] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-a.eu-central-1.aws.symcld.net id DE/AF-52475-D0CA9FE5; Mon, 29 Jun 2020 08:53:33 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRWlGSWpSXmKPExsViZ8MxVZd3zc8
  4gx9PRC2mffjJbHF44Rsmi0efTzFadF/fwWYxoy3MYvnxf0wWfyfdYLVoXfqWyYHD4/IVb4+d
  s+6yezzuOcPm8fHpLRaPz5vkAlijWDPzkvIrElgzlq+9wl6wnquic+p51gbGDRxdjJwcQgKTG
  SXOPtXsYuQCsvsZJVYcOcDexcjBISwQILH6bi1IjYhAgsTW16tYQGqYBb4wSvyY2sAC0bCQUW
  Jn1wxWkCo2AQOJFZPus4DYvAKOEt1Nq9lAbBYBVYkdf7aygQwVFQiXeLbCH6JEUOLkzCdg5Zw
  CdhKt57eBlTMLmEnM2/yQGcIWl7j1ZD4ThC0vsf3tHOYJjPyzkLTPQtIyC0nLLCQtCxhZVjFa
  JhVlpmeU5CZm5ugaGhjoGhoa6wJJYwO9xCrdRL3UUt3k1LySokSgrF5iebFecWVuck6KXl5qy
  SZGYKSkFDI07WB89+qD3iFGSQ4mJVFeowk/44T4kvJTKjMSizPii0pzUosPMcpwcChJ8B5eCZ
  QTLEpNT61Iy8wBRi1MWoKDR0mE9/YqoDRvcUFibnFmOkTqFKOilDiv9mqghABIIqM0D64Nlig
  uMcpKCfMyMjAwCPEUpBblZpagyr9iFOdgVBLm7QEZz5OZVwI3/RXQYiagxQWm30AWlyQipKQa
  mEQaFAPKnQu6X1vk3U1e2f/2d+Hd4qwCtpnJNVP0Og6EfM0KlI/ecXWeyoaLVdvYbix5em+K6
  5Njwm75i3JU32kUaZ3oO1r1f3O6m3tI+02jrfLOAVyL14hnaNm0lEwKdRMr9FgyaduhYu5Fq1
  4Z/b147mJZjQx3/q/E1Uv3nVfxlfBJW2Twcs//vOMno+0a0wwZd827vLG+62GQ7tF7jZani4w
  Db2Sy3yi5ULrlbnDgE469f8NNGzdN/uOR894jOmO2ZMh8PVenmBVHm/XmR5s8LDIy2RAYE27u
  UlaftuHKrmyzNekTMm6Lnma/1NZ8yzR93yOvWdabf2u8U9+1UyQoblfhVkXfqVEvHF5oKLEUZ
  yQaajEXFScCAJ2Xoo2PAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-24.tower-232.messagelabs.com!1593420812!392557!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 2952 invoked from network); 29 Jun 2020 08:53:33 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-24.tower-232.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 29 Jun 2020 08:53:33 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 05T8rGf4031582;
        Mon, 29 Jun 2020 09:53:24 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id 12A96204CE;
        Mon, 29 Jun 2020 10:53:13 +0200 (CEST)
Subject: Re: [PATCH] scsi: target: tcmu: Fix crash on ARM during cmd
 completion
To:     Michael Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        JiangYu <lnsyyj@hotmail.com>,
        Daniel Meyerholt <dxm523@gmail.com>,
        Henry Willard <henry.willard@oracle.com>
References: <20200624085320.31117-1-bstroesser@ts.fujitsu.com>
 <93e7f9ef-566e-6949-b2c7-2e822ee49f39@acm.org>
 <15C73AF2-672A-4686-A418-0C41993E8060@oracle.com>
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Message-ID: <655e34b7-c6eb-728c-1352-cd87f51d80fb@ts.fujitsu.com>
Date:   Mon, 29 Jun 2020 10:53:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <15C73AF2-672A-4686-A418-0C41993E8060@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2020-06-28 21:35, Michael Christie wrote:
> 
> 
>> On Jun 27, 2020, at 9:31 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>>
>> On 2020-06-24 01:53, Bodo Stroesser wrote:
>>> The fix is to use the maximum of remaining ring space and
>>> sizeof(struct tcmu_cmd_entry) as the length param.
>>>
>>
>> [ ... ]
>>
>>> +		/*
>>> +		 * Flush max. up to end of cmd ring, since current entry might
>>> +		 * be a padding that is shorter than sizeof(*entry)
>>> +		 */
>>> +		size_t ring_left = head_to_end(udev->cmdr_last_cleaned,
>>> +					       udev->cmdr_size);
>>> +		tcmu_flush_dcache_range(entry, ring_left < sizeof(*entry) ?
>>> +					ring_left : sizeof(*entry));
>>>
>>> 		if (tcmu_hdr_get_op(entry->hdr.len_op) == TCMU_OP_PAD) {
>>> 			UPDATE_HEAD(udev->cmdr_last_cleaned,
>>
>> The patch description says "maximum" but the above formula calculates the
>> minimum of "ring_left" and sizeof(*entry). Did I perhaps misread this patch?
> 
> Ah yeah, Bodo probably meant to write what they wrote for the comment above about the max up to the end of the ring and not max of space left and entry size.
> 

Thank you, you both are right.

While the code and the comment in the code are fine, patch description
is misleading or even wrong.

So I'm going to re-send the patch with fixed description and Mike's
Acked-by.

BR, Bodo
