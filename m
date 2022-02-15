Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3263DC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 23:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244150AbiBOXpH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Feb 2022 18:45:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiBOXpF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2022 18:45:05 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD99DAAFE
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 15:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644968694; x=1676504694;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=DGGTuN3t0LZjITpYlpEpW7Ii7O/xugmqopM/JiuKHr0=;
  b=rT64OeXQo1893xiBDxY8NmvFA/EBGTWAAm2g9o5nYyXX2Gv9AeilWxgX
   iPL7f9XkOsXCkznwXjyqiyKveTYozQ1WTmrCg2AEMglZe+gh8BxNq/lkV
   mGkShJ85RU54oSj6KJ85sPou6N7u0gQj8KPFw6Xei3JQBnvhHobYZCGB/
   vSiZNDcV8lYFGXPQDhWoqczptJb+otn1cgTt4QYd5eTZREEfCwU4t6sp+
   VgzG0S00D6aw/ehaR9kcm8ashu5AEP7EeJ0TSPK6mPAMU3GkB5aVnEtm5
   /fUDxiQMxDfSCHmzsljjH9rbt1eDOxwkGnwiSQTfKhmt8aJS8KL+Yw2uH
   g==;
X-IronPort-AV: E=Sophos;i="5.88,371,1635177600"; 
   d="scan'208";a="191978219"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Feb 2022 07:44:54 +0800
IronPort-SDR: LMnJjCJYBpr/XJuuHqkMEjaN2uwc7AUQFO99auKnlEYuO5XEy8UBW6+utBRlgvMMax0Ub1Li7h
 7qcGo6CxOL8BjM1pXX5ZmnqBhTZsaF59B9vYKEAOy8Hkor2esGb53eJkL12MXYcor0m0wAM8w9
 La3JyaWicUK7X5RI8FKIIOSBZ0g5i0HaEXQMSuw0bOgLHj/uL/EGbn4dILf+uog0o3hhOExpcE
 H2xxQJQodbGg0L8/zyN71TNEz6G6UddzIGTKqi2zG2YhNTirHZCJEiMPFHjiXokfemJuXET/0u
 J0aj0Y3EQu/gFL7hbrSVgcdb
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 15:17:42 -0800
IronPort-SDR: +VGpfYLBAGsDeS299MfuShKXqb5s1yDgZR7f+57jFrv1d2FXxvt4V+XZNRy3yf3RGNtznOzeGO
 41Sgn+0gfR34BK4VxBin/l1FZvrI1rJdQ8CLRwnc37ro4lES9S7bgUxKZ0Bd76iCqxZWjjqglM
 tKGNRR1XyT393YxCDnMLHNCjZdxRN+Nxk1A5emB1FYwwmx/qtdTQiJ+AY8chahMj8zlsca93hi
 2QLhpxl4k1zqyA/6Dopv7ypnQWbpQj4QQYYhJQ67IlS9eJVQTMmlTTqIcgC3H6mrFNMSGXsCs+
 wSM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 15:44:54 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JyyPK5Frwz1SVp0
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 15:44:53 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644968693; x=1647560694; bh=DGGTuN3t0LZjITpYlpEpW7Ii7O/xugmqopM
        /JiuKHr0=; b=ZQJ9qrcmp0qqKgVl6LH01G/2k0z76+wFJljbTxfoLjSlCbTQsl2
        I0N+EA3vKt+CIP+b/ajRYStJSZZ8//Qzx1feLigUU7UjLtph2i7dAGXaRB9qHKoe
        kX3tornKLePmw/A7A2940Zc2taVG+ZVP5FvxqcINphgCMwvKnN4nisRSbnqsYf+6
        qBvWFOlFUuYM8Oc6b6aQdiRRir37QKRQACa4rxZEHhU9RIgTJTEUJlfbvH3WEU90
        LQvYFtImYZxx3Xe3M7FeJfYz+PoHCarBqzF4msNixnH0ES6ErBcyt9BgGpyAVyrp
        lrjiZULGMAgWzsYwZemUhcZ3Fc/9OTiiw6Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Sg9fieEd_4Ec for <linux-scsi@vger.kernel.org>;
        Tue, 15 Feb 2022 15:44:53 -0800 (PST)
Received: from [10.225.163.73] (unknown [10.225.163.73])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JyyPJ0Cv7z1Rwrw;
        Tue, 15 Feb 2022 15:44:51 -0800 (PST)
Message-ID: <67e630db-9a8c-d441-51db-44b1a06db19b@opensource.wdc.com>
Date:   Wed, 16 Feb 2022 08:44:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 20/31] scsi: pm8001: Fix tag values handling
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>, jinpu.wang@ionos.com,
        Ajish Koshy <Ajish.Koshy@microchip.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
 <20220214021747.4976-21-damien.lemoal@opensource.wdc.com>
 <7672bdd5-e2e9-0716-6487-5e2f76c8269c@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <7672bdd5-e2e9-0716-6487-5e2f76c8269c@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/15/22 20:09, John Garry wrote:
> On 14/02/2022 02:17, Damien Le Moal wrote:
>> @@ -1685,19 +1683,13 @@ void pm8001_work_fn(struct work_struct *work)
>>   		struct task_status_struct *ts;
>>   		struct sas_task *task;
>>   		int i;
>> -		u32 tag, device_id;
>> +		u32 device_id;
>>   
>>   		for (i = 0; ccb = NULL, i < PM8001_MAX_CCB; i++) {
>>   			ccb = &pm8001_ha->ccb_info[i];
>>   			task = ccb->task;
>>   			ts = &task->task_status;
>> -			tag = ccb->ccb_tag;
>> -			/* check if tag is NULL */
>> -			if (!tag) {
>> -				pm8001_dbg(pm8001_ha, FAIL,
>> -					"tag Null\n");
>> -				continue;
>> -			}
>> +
> 
> This looks so dodgy that maybe it is intentional. I think experts on 
> this HW/driver need to check this further.

Well, the tag that was allocated for this task may have been the
perfectly valid tag 0, so this really looks completely bogus to me, like
all other tag == 0 checks.

Will update the distribution list for v4 to add Jack Wang
<jinpu.wang@cloud.ionos.com> who is missing.


> 
> Thanks,
> John


-- 
Damien Le Moal
Western Digital Research
