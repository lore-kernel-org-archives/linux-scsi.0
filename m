Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C309EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 11:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbiBPLmt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 06:42:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbiBPLmr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 06:42:47 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFB02271DA
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 03:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645011755; x=1676547755;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=H7JVdOLSAr7Pa8fQfpOJrQt8gzXseqJahGAV2KzOWNA=;
  b=NjOu2Xi4NcGh9dibAn/ADESQG/E+iChVvcEL9hQ+EdCmA0SkGYiiG1vV
   qYt1fSA8wd/PhyfVrvjWLugJkFt5+9ofNYKwf4Iur1P2ChumZL8f52ahH
   THJ7bgJR4uS3cJAUrSdK0SGQ2j1djHEmxbi6tzD/oBkyacfZA7N/qyhJp
   pO7x+LV1Ehvwvh7lD4x6N6p80VkiJAKs3X9+9ZMjeC0jWblwHDeSiSk2w
   1C3QO1B+2iDM0RqjoUo1eparUGFU+iNrv5+kEyMxfuXPJqpfABdQk0sIS
   vI/IcUGhu9GjuKbL8XxGLMWyDAsNkLmP+yaZsMpX2oPHEhIuduGOqgPc9
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,373,1635177600"; 
   d="scan'208";a="297201338"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Feb 2022 19:42:34 +0800
IronPort-SDR: HDdIwHGGc16C9ckbazXVmimBkLtccp3x2aW/q0OzlIWpo/+7wS8kXRZpcq1yjxd5RlMytZd56x
 G6CgYl6G57i0UYkyAePwrVZfFlY1t6EWtzhY2RdG0lEhtwVChb+I6i9fjKXIyEqwlzTs0RzZPF
 PJ2EaeWW2r7GC4MwCxPEJ/5agQWbpw26U0oQKBqh2lRdzqMF4T1X0DcX9bfCCSNN7RpmOghtL2
 FLX7Et43v/y2gqMiWzt4wo90okhWg2KKJ9F4Pxp6whp0IztAtUMxOwRiiHCZzUj35Qi7ZL1DXN
 swQEvEWCu1y9VpOpZz0iO0Py
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 03:15:22 -0800
IronPort-SDR: fa6K0kw6rLB0YFCWJF2hdRUUnS81luC0XfESTsfPDR7UYMz/v4plu16PxFi+pYdJHOIBJvrWkb
 TS5pDaZ3+7tCaJ2X0z52kzumsW1YPQ1u0PNR5lDmPAJXOcaE3ttu3nfvjQrrHIuy6MRq9AEDpF
 GUGnD8Pfw4piK6D1WJgf1yhGKUPQCWlvFAjW3LWJqwNOYOn2KasfPzDgNPhpwmInY5nCFrdZPg
 Z7hDTiVDg9xGhm/v7326mXixcpsOwVuZ6fmWBZNty8c2Xuw7NKCW20aIPyMBSwIUrj4z29pmBw
 gfQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 03:42:34 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JzGKP5gFnz1SVp0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 03:42:33 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645011753; x=1647603754; bh=H7JVdOLSAr7Pa8fQfpOJrQt8gzXseqJahGA
        V2KzOWNA=; b=cj6YbtD7GygfLMzfD+00SYWky3dv3mP0TdELFYhmcNCpuI36ECP
        NejiFVu3LtRgKwCeeMbzX4WNXrQlpXuMRNadTURLUCovUCcQkam4/XF0qP2hG7/l
        uaS8kQ9jEzVFkzT3SuPfi8ywAnsYStPS0T9Rmy8V5Dl1Lk1aNVH/z6i0N5Vog8jB
        GNT+OR/vlgtPB5dCZ2SFwqgvLxyRziP8lvpDcsqM9k97YtY64knlNHMZzeky0pv3
        BdBacTmSouM6p4l0QFdVdE3mL+QQsppYaKPa5rg4wbRd5nI3iEEfAmYRgf6l9A+G
        FWzxEdlRdIIVmRq1xGKfdJkgT3VeTFe6y0Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 9PEZJNxCtvco for <linux-scsi@vger.kernel.org>;
        Wed, 16 Feb 2022 03:42:33 -0800 (PST)
Received: from [10.225.163.73] (unknown [10.225.163.73])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JzGKN44G9z1Rwrw;
        Wed, 16 Feb 2022 03:42:32 -0800 (PST)
Message-ID: <37df3c92-c28e-72d4-76d8-33356829af5a@opensource.wdc.com>
Date:   Wed, 16 Feb 2022 20:42:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 27/31] scsi: pm8001: Cleanup pm8001_queue_command()
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
 <20220214021747.4976-28-damien.lemoal@opensource.wdc.com>
 <51d7c127-f975-14e9-a036-c37416ed8679@huawei.com>
 <32efd519-3485-ee34-84e2-34a0d8c27e17@opensource.wdc.com>
 <38090771-ad24-1b20-9b79-f7f89d42ea66@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <38090771-ad24-1b20-9b79-f7f89d42ea66@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/16/22 20:38, John Garry wrote:
> On 16/02/2022 11:36, Damien Le Moal wrote:
>> On 2/15/22 19:55, John Garry wrote:
>>> On 14/02/2022 02:17, Damien Le Moal wrote:
>>>> Avoid repeatedly declaring "struct task_status_struct *ts" to handle
>>>> error cases by declaring this variable for the entire function scope.
>>>> This allows simplifying the error cases, and together with the addition
>>>> of blank lines make the code more readable.
>>>>
>>>> Reviewed-by: John Garry<john.garry@huawei.com>
>>>> Signed-off-by: Damien Le Moal<damien.lemoal@opensource.wdc.com>
>>>> ---
>>>
>>> I assume that this can now just be merged with 30/31
>>
> 
> Hi Damien,
> 
>> patch 30 cleans up pm8001_task_exec(). This patch is for
>> pm8001_queue_command(). I preferred to separate to facilitate review.
>> But if you insist, I can merge these into a much bigger "code cleanup"
>> patch...
>>
> I don't mind really.
> 
> BTW, on a separate topic, IIRC you said that rmmod hangs for this driver 
> - if so, did you investigate why?

The problem is gone with the fixes. I suspect it was due to the buggy
non-data command handling (likely, the flush issued when stopping the
device on rmmod).

I have not tackled/tried again the QD change failure though.

Preparing v4 now. Will check the QD change.

> 
> Thanks,
> John


-- 
Damien Le Moal
Western Digital Research
