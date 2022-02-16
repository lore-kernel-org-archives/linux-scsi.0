Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42231C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 11:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiBPLg6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 06:36:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiBPLg5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 06:36:57 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B35616E7D5
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 03:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645011403; x=1676547403;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=9mKGcXhptXwnwUBxCh6CB9fJv8ucAul74oHXWpqhhLQ=;
  b=edxwnFf8bvNeW23Lv6qYr+uX77m+1EtXoXOnr9c4QxpWlfKdYYvhZifh
   eTZw1mPe6qgqULI5O+cEIKvBdNxTdIr6wExgKnDc8LHl759LPOpBxoiUb
   NrTWNDdhVkjrMdiX5PIUh48fmOtIbR9XMPOsYq8UuRuGrpS8uK2XB3Snb
   jpV98Ha8BRMBuGSn/EKgNFtDlzrRIx/rysl8DaT40jDhRfBjc7ZYUohP8
   2JnTVnLdm++E/4We0JWz2szJugZA1ZfKLfRZuh0fBfPhCUjlt+5trJUrs
   V1DxWlcjhZ7cdOcZmhVgP/z4VhYoy1kZsXgyIfSAo4D6GchaPZlzOeJ0N
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,373,1635177600"; 
   d="scan'208";a="193092153"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Feb 2022 19:36:43 +0800
IronPort-SDR: vXMwSpCgI217tzR8PyS7jr6fvkFuEEz/azJ0dJ/ePC7OLd9lXND2o9x9DCtLeIzOyO75jXtYpR
 a8Es9hWd0ZXRNlohdxNo0yNi2mXpl0Zl/Ri0n5n9Ni7XQ0UirfYUey7dbR/VoWIw+W5ZEv0ySq
 38/8us+FKrs4utuD0hwPF0N1EW9NcgkGDOBN0oQIaZyVvCr0IbvGErKlSkr9jy6P8b0aSss4Ly
 vlKCYQnqLyG0C5ybW4lifiPvp+UeZ5QNkghFrVyEdPs5goGRveyaQiutKCumNxAHt54MQBrZGy
 7tbOu7Gh7aGNJHzHqW0GyN0T
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 03:08:25 -0800
IronPort-SDR: ll/CeHo04jVmJTomAj41ELc4STu9/vtLJj/OgQUtgKQQ+KZA8k91RrIQCPgn7rCC7cIv8SXrqF
 YQxbi2DFmMKQ04KymJDuDPxqkts2cZLha5lm7Fhe3dw83gsTfFlMKe3hnhismiAR4G6PA3IHfp
 V5bavd/nji9LqpuVpOdhw0vuQd3nu5uaZ05lNkKwkflmKFC0Jks6y8HgMj0fgVzZt9r/kVGDQL
 1Hw1lNWCkqibgUiX0xt91EeVHFHiaAo5ML1c2asnioJpYyyAINumyiryWcOTdt0rQtUCV4crdQ
 vsk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 03:36:45 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JzGBh3wqrz1SVnx
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 03:36:44 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645011404; x=1647603405; bh=9mKGcXhptXwnwUBxCh6CB9fJv8ucAul74oH
        XWpqhhLQ=; b=OfXNa1UAlIdAfn7T0Ypju0SqMbesnz+eLLQ3rhGvqOXpBTBSvW3
        1CVMj8rKx2PD7xad9nXsCyJW83YTf9RH01ZPFtz8bOD0pxyOwLeKZoWYKS+mF4i5
        bj2S55I+QCc7vKbRi5KOEFAqXLp3HEtGul7DLoe5YyefecdHFYGGC5qEXgk8u9uc
        ECPf3R9Hj/YSqGgLyc4i6A+SKke9ox5CogfEXK8Y8Hasp9Y8dBIPy0NvwqyG6TDT
        TEB09HnfIppmDYKnQuep6jY9H2dMpP5FmQ+4aYKmwmiUPcoUni1EYpH8YLQsrHg0
        p8POvPS+cLjqpREFNwLhm+zHc2kVdyLa2Qg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id QsWaM2d88MnO for <linux-scsi@vger.kernel.org>;
        Wed, 16 Feb 2022 03:36:44 -0800 (PST)
Received: from [10.225.163.73] (unknown [10.225.163.73])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JzGBg0kPMz1Rwrw;
        Wed, 16 Feb 2022 03:36:42 -0800 (PST)
Message-ID: <32efd519-3485-ee34-84e2-34a0d8c27e17@opensource.wdc.com>
Date:   Wed, 16 Feb 2022 20:36:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 27/31] scsi: pm8001: Cleanup pm8001_queue_command()
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
 <20220214021747.4976-28-damien.lemoal@opensource.wdc.com>
 <51d7c127-f975-14e9-a036-c37416ed8679@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <51d7c127-f975-14e9-a036-c37416ed8679@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/15/22 19:55, John Garry wrote:
> On 14/02/2022 02:17, Damien Le Moal wrote:
>> Avoid repeatedly declaring "struct task_status_struct *ts" to handle
>> error cases by declaring this variable for the entire function scope.
>> This allows simplifying the error cases, and together with the addition
>> of blank lines make the code more readable.
>>
>> Reviewed-by: John Garry<john.garry@huawei.com>
>> Signed-off-by: Damien Le Moal<damien.lemoal@opensource.wdc.com>
>> ---
> 
> I assume that this can now just be merged with 30/31

patch 30 cleans up pm8001_task_exec(). This patch is for
pm8001_queue_command(). I preferred to separate to facilitate review.
But if you insist, I can merge these into a much bigger "code cleanup"
patch...

> 
> Thanks,
> John


-- 
Damien Le Moal
Western Digital Research
