Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFFC1C54E94
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 21:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbjAXVjw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 16:39:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235054AbjAXVjq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 16:39:46 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C0D1CF7E
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 13:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674596380; x=1706132380;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Qd6GlOwYoybiib2oWiWQIX1FOUfCwCEdPWZivN6s5lw=;
  b=PnqxYpf9RHDZjQS8vIcK3KPMNhyvZQHaLLEQOygbpNFucU4DQWRr44A3
   urRK8c/JqrieKcSlOxUQvW4swYmq4Di0kMmD/5TPoCMPcPeP/4uQOOUfj
   LaWfF++ng+c5gPiNnmdWM5/rhN4pReWJCuPZpvFEkof0vSG3FOsmAvq8R
   fNGSDISBUQ7vfsb95fW6NxigStfz5U2qhNQJU4m57XqP7ksZU6RbED//4
   xd11MZpVmWATb87S6xlIb8W+I+vV42xyBj6LzVhdROCQzPQFb/luwPddG
   9aiITUhtKp8yaxLlHsH3f3Mmk9LPEJNbCs6btgFkJqrWYTXIDdtQ/Vojz
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,243,1669046400"; 
   d="scan'208";a="221481303"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2023 05:39:35 +0800
IronPort-SDR: /GbN/86gS4g4vJ6kGgnNcg8Q4/FUcX9rk1d2NypESnoQ0WJBnZYs+Q3uKtMEaIhhse8OW0CDe7
 YHeLlr7Lo8GZd2dK7gl5GXVmoZz7x2FJGm0664yp9JlG9n6AkKe32YL2h6Y7ygxFo9NmqRzGUO
 WuUvd9/m9ACdjB+luKJo2m9OywoePet1v8xwSPOZgM+0QDIqVNic0884PwF5DPOF34Xie5SnCj
 4WAowBP7GbanANk+ETFpnzec1BvHYHsUTjS+CpYD9ULepDh/AibBq4Alz1bqNFZa/QE1NNByNp
 QTs=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 12:57:07 -0800
IronPort-SDR: pQ7hSAvWPkme8dnquLp7blscfQbvRSNZf+aoGLWJ36HoVXb4ud541oikDbCEDm9Z9apvK9FBC1
 OX1tdBfooNX5vnMv3XwD5hAP5oBG7CZJ4YB2kAceU7n9OS1LPj0EEtWnNINQLlz4IP7NWfAaXs
 Q8lgvOGrCPJ59qnziqT22tSD6xWq6rWcW6MnFSP6738NhaCBgSohhRilCi9+JLCMNCmBOn1olz
 3XTCXxtaXfJsAezsj42uanMozwRVBeR7wYHq8Shn6yqTd5On3VC/6UdVRqS4sK2TscDo+78ZMg
 /qg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 13:39:35 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4P1gNR0Nsmz1Rwtl
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 13:39:35 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1674596374; x=1677188375; bh=Qd6GlOwYoybiib2oWiWQIX1FOUfCwCEdPWZ
        ivN6s5lw=; b=E1yAk+97ZRJTqcpSwJiNQYoRCvTkJZ4HWeX2uA/mv2k0YibOtMd
        1Kc/S5m4H+rL1CkjeO05UxH88uUEKagj6AFGCSjGHf+meS6nuR0VJINKol2s4GNh
        vBza/2XOEEMNkelPLGW7/egYOLDreDJKkL5CVGLD1JAN5xhRnSNVzRVX8UvLe3m6
        uuJvo+wfLeYKYNy+HcBbETWJIpY00wUPkMWRK/C5mh5W+evxJsq51z2yLP0FvjfQ
        Qs9dRGI2uIqoqbcAiUxf3ToJDJpTArfQ84cOAAvhpXJMerNhWnFdx83kS6jjeQyi
        /mjZ1K3Peh5OL5H/DAdob+BTs9H6T7ZQSQg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id zWFn-3VRNQga for <linux-scsi@vger.kernel.org>;
        Tue, 24 Jan 2023 13:39:34 -0800 (PST)
Received: from [10.225.163.56] (unknown [10.225.163.56])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4P1gNN3q95z1RvLy;
        Tue, 24 Jan 2023 13:39:32 -0800 (PST)
Message-ID: <542987b0-c4c0-6ed7-b950-84faee0a2e55@opensource.wdc.com>
Date:   Wed, 25 Jan 2023 06:39:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 02/18] block: introduce BLK_STS_DURATION_LIMIT
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Keith Busch <kbusch@kernel.org>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-3-niklas.cassel@wdc.com>
 <517c119a-38cf-2600-0443-9bda93e03f32@acm.org>
 <Y9A4s5tlsdx0S8s4@kbusch-mbp.dhcp.thefacebook.com>
 <a127b2d1-b7b0-66e4-5af1-bd292a46e752@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <a127b2d1-b7b0-66e4-5af1-bd292a46e752@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/25/23 05:32, Bart Van Assche wrote:
> On 1/24/23 11:59, Keith Busch wrote:
>> On Tue, Jan 24, 2023 at 11:29:10AM -0800, Bart Van Assche wrote:
>>> On 1/24/23 11:02, Niklas Cassel wrote:
>>>> Introduce the new block IO status BLK_STS_DURATION_LIMIT for LLDDs to
>>>> report command that failed due to a command duration limit being
>>>> exceeded. This new status is mapped to the ETIME error code to allow
>>>> users to differentiate "soft" duration limit failures from other more
>>>> serious hardware related errors.
>>>
>>> What makes exceeding the duration limit different from an I/O timeout
>>> (BLK_STS_TIMEOUT)? Why is it important to tell the difference between an I/O
>>> timeout and exceeding the command duration limit?
>>
>> BLK_STS_TIMEOUT should be used if the target device doesn't provide any
>> response to the command. The DURATION_LIMIT status is used when the device
>> completes a command with that status.
> 
> Hi Keith,
> 
>  From SPC-6: "The MAX ACTIVE TIME field specifies an upper limit on the 
> time that elapses from the time at which the device server initiates 
> actions to access, transfer, or act upon the specified data until the 
> time the device server returns status for the command."
> 
> My interpretation of the above text is that the SCSI command duration 
> limit specifies a hard limit, the same type of limit reported by the 
> status code BLK_STS_TIMEOUT. It is not clear to me from the patch 
> description why a new status code is needed for reporting that the 
> command duration limit has been exceeded.

As explained, this allows differentiating the "drive gave a response"
(BLK_STS_DURATION_LIMIT) from the "drive is not responding" case with
BLK_STS_TIMEOUT. We took care of mapping BLK_STS_DURATION_LIMIT to ETIME
(timer expired) for user space too, to not overload ETIMEDOUT used with
BLK_STS_TIMEOUT.

We can certainly improve the commit message to describe all of this in
more details.

> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

