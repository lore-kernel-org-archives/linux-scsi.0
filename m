Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35FC7C43217
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Feb 2022 13:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbiBGNuL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Feb 2022 08:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448795AbiBGNN2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2022 08:13:28 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54F5C0401ED
        for <linux-scsi@vger.kernel.org>; Mon,  7 Feb 2022 05:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644239601; x=1675775601;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+21Yyghs+bY9yok1fzjGL7GBXTYblCJPLUpgvVaqhd0=;
  b=kutalAyAt5BXYUHXKUqJ/M1FoipuNdka+y2BDTtAc393VQ5wecqV4stf
   cJfFXbSdnzm34ZztD2qUO6ydU/2z8jx96LmX+pubZFMXbvTvNVIPN3ji5
   aVwMmz3HqrDpZ0YwlqNen633OtOb3y+6OCYJiUV1BuUmfyXzvhwoVfIDk
   ManUFtS8L1fUaZ9AUWQydlPQVLU3efLeONUr6xdANPe0VzhqtwSorp8EW
   +Kv3RZaf6pz3WEK7KUCxC8/QZyEEazs2YGh3Kv5nSpA0/4Zn52EGQBrSR
   5CKQySyTUC6qx1CfCjyyBIZFkv8sZv0Cx75YZbF0CCLxrF7EgtweApySj
   w==;
X-IronPort-AV: E=Sophos;i="5.88,349,1635177600"; 
   d="scan'208";a="197144057"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2022 21:13:20 +0800
IronPort-SDR: qq0IUDOJPWTW8l+Lm1FEyMrbvw1DqmStP/4ks0r31G4pJ/aRRnEhSVMHjZfFtL0NEpWhqpGFbM
 8eEKSw/Vmv+AJ67XS5K9kQm+Ad3MFsvCU+0MBWf1CKqfl8BA52cDHWaUg5RSs9Bx47JFeoBmGa
 pawSeY3BfCyeewj7U6KvOe2YLLlfiimW8R0fP01DqwmyHpTSnXLCQwX9j4yd0hrVVm4KjiTynb
 FVYFHjA77Vamas4mTCW0Xkt/rNo92A0fwU8t0S1SRVh3Tg1FWLwg+3oAgNNyvuFW8f56StJIz5
 coFz/Q0AzyDEqj378Bylyeng
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 04:46:23 -0800
IronPort-SDR: NxtZqTin+6mKHAt3XVDisJrLIRfdm7KqEeXhPdBV1OeDawZyTIW7v1jPZz7Na0dLxcrJBasTMb
 5ytFV49MKQT6bUqnb7DNZAghzNrgs61LaTMQjw7WIByPqqnA4b7Lf+omvUclBuZ0Nuo2fvqrmb
 OXe/WPY3/L+vtlWq7AysOXlVNpLBSelEenfmW7cCMTS1eBXMs6I4EkVHBqyj5k7XzNnO/lYaNI
 qV6BKlZBecXxuVuw2G4Hq3U+G6r6uPT9ClZAVM45rpep9cZeBij+tOf6T2ZopWRwi3J1PsuHVF
 6eY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 05:13:22 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JsmmK5z8gz1SVp5
        for <linux-scsi@vger.kernel.org>; Mon,  7 Feb 2022 05:13:21 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644239600; x=1646831601; bh=+21Yyghs+bY9yok1fzjGL7GBXTYblCJPLUp
        gvVaqhd0=; b=bT71PG1JnGgtpyzgL7ysLwH5cScwUnHimAea8aVkvrXak/d3FIh
        nR0UIyV0lbhU841TImHZ6+cwvjXsnFHUcIL9B7JHhJ6BndQ/6r25/7pBzWfdsUMX
        IEipyrvU7INZMPLGz1NGmF0gEB6XNFSwsZFbYcRucios52D3sc7sowhtcvfO8IwO
        JYYlhSXJVKHInuXdzZus7x/lMCY6myhx7s+mG5m4eoWMVrJ8DM3WKArraKoe7PNF
        c1gmANPKlp1izojLlvXz3/t54TeOWDcmVaaxHSSmWbuKa7dN814tytmrcB8U+sf0
        RBIZ05hglZCyfUlPjsTfwfxMHAhQVWBiqYg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id EGUXtRBpnA1J for <linux-scsi@vger.kernel.org>;
        Mon,  7 Feb 2022 05:13:20 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JsmmG5ddvz1Rwrw;
        Mon,  7 Feb 2022 05:13:18 -0800 (PST)
Message-ID: <071c0b1d-32fb-e02f-d4e9-1540701d837b@opensource.wdc.com>
Date:   Mon, 7 Feb 2022 22:13:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 00/16] scsi: libsas and users: Factor out LLDD TMF code
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, artur.paszkiewicz@intel.com,
        jinpu.wang@cloud.ionos.com, chenxiang66@hisilicon.com,
        Ajish.Koshy@microchip.com
Cc:     yanaijie@huawei.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxarm@huawei.com, liuqi115@huawei.com, Viswas.G@microchip.com
References: <1643110372-85470-1-git-send-email-john.garry@huawei.com>
 <1893d9ef-042b-af3b-74ea-dd4d0210c493@opensource.wdc.com>
 <14df160f-c0f2-cc9f-56d4-8eda67969e0b@huawei.com>
 <a8fae323-1877-058a-b03e-d175a725213f@opensource.wdc.com>
 <a2de1656-b1ec-2fb7-caab-657e27dacb48@huawei.com>
 <49da4d80-5cc3-35c3-ccaa-6def8165eb65@huawei.com>
 <59a198a8-1d87-bc09-d2d8-2d495ed74c16@opensource.wdc.com>
 <098f988e-1f12-c412-3111-60393dfe0f0b@huawei.com>
 <f3362c6f-b4b6-2914-0652-d786e19b6b03@opensource.wdc.com>
 <62e56609-7026-93a1-a446-a6fd68328653@opensource.wdc.com>
 <1114e27f-e6b3-e9b9-a892-f543f4636c4e@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1114e27f-e6b3-e9b9-a892-f543f4636c4e@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/7/22 22:09, John Garry wrote:
> Hi Damien,
> 
> On 04/02/2022 03:02, Damien Le Moal wrote:
>> This is the submission path, not completion. The code is:
>>
>> (gdb) list *(pm8001_queue_command+0x842)
>> 0x3d42 is in pm8001_queue_command (drivers/scsi/pm8001/pm8001_sas.c:491).
>> 486				atomic_dec(&pm8001_dev->running_req);
>> 487				goto err_out_tag;
>> 488			}
>> 489			/* TODO: select normal or high priority */
>> 490			spin_lock(&t->task_state_lock);
>> 491			t->task_state_flags |= SAS_TASK_AT_INITIATOR;
>> 492			spin_unlock(&t->task_state_lock);
>> 493		} while (0);
>> 494		rc = 0;
>> 495		goto out_done;
>>
>> So the task is already completed when the submission path tries to set
>> the state flag ? Debugging...
> 
> JFYI, I am putting together a patch to drop SAS_TASK_AT_INITIATOR 
> altogether. I just need to ensure that the logic in the isci code is 
> correct.

Great. Less dead code for the pm8001 driver :)

I was busy with a nasty libata bug today so I did not continue my
investigations. Will try tomorrow.


> 
> Thanks,
> John


-- 
Damien Le Moal
Western Digital Research
