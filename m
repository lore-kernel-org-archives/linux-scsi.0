Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C16AC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 22:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbiBXWbi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 17:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiBXWbh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 17:31:37 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531C049F00
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 14:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645741867; x=1677277867;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=++bDxWyUa0600WILZuVRl5CdN6JHPLb2Cu+YBAzrL0I=;
  b=d0ibP+jgycRX3ct7EVRpj/3M9peYyLqw2Kin1jGipI1yzRiJpZdVx2v1
   94s82cS/9JdYURUaAaQhq7HjnLacFPVcDNA2WXasMxjSZFchv5Mbhpnhs
   AfmOqm7ZhwG3CM9sKoziWHOmBp10CkonfxrjkZB8QsWlXvKwZ/cbjNvY6
   jeL40xQI68pJEALOlxrO4RJ2gncyVZxqQxrW7+bWJNRjM1wxHwBmAty/2
   LS0U+MPcZKCy2x7FwmhWzYssmknb/h9qQzpqpXZBdqN2QFCN/MSUvsdQw
   e0/L/fbdGWCSWWtKqsaK9l8z177DM9dvn1nTsnTLJ+9b4ZS6VTH94FjpX
   A==;
X-IronPort-AV: E=Sophos;i="5.90,134,1643644800"; 
   d="scan'208";a="298014988"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Feb 2022 06:31:06 +0800
IronPort-SDR: Y2HjSEgjJEWm4IfFdIjrquziTtdCBgJqtzZ8wc8SYxrax/P65HX7LTdyzrX82GrdZkToqfQ2DZ
 U8KUEaKEhn53dZrU0ncBt8DtCMgDZLv+dIpowyljxrBI8beAx8kZebHjgC9EeQO6dLaVmfUVAH
 3XgqDWM0zPrmhwdGv1gMy/wQsTucK1yRWDIlXcyeStwHvSWwdhRAyQHiPnDi1pvWe2c3btFjmW
 S8UGa7+0bAvvDL76PCPRER8khh+ido/JmYb/pJU5e7Cs+6qadHoKeamnYIbP8j4FJ09AlM2U4Z
 d2RZPZazk3WkKI8BxEXssWUQ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 14:02:36 -0800
IronPort-SDR: c8re7Y+7jzgeplZ+zo7f0ksj+z3JmVtgiZtnhemJOdYdfrQSrjZowXgzsXphwzC1YPajQWlmWz
 Wo/JMCNBYm/zyZxSk2EyFYI1bICQ0hDqPDP0GXyhA4J5fT7VQ74Ro/DRUDMXgheHqKj8J3oWXb
 Ep4r+izvKZdPMnyERw8MVspyabJf7iILJjXGR33Z57vIWh9uvz+2DLx03j8lcp2FyIiZL7ZDPE
 79vuz0sdJyJjJK5EjRKh8eK39Q1z0UsYWFGpXQhmAEIBMh2izwnXGsh6g8EJhBbQcUE1vUvJR3
 He8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 14:31:07 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K4SL14KHXz1SHwl
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 14:31:05 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645741865; x=1648333866; bh=++bDxWyUa0600WILZuVRl5CdN6JHPLb2Cu+
        YBAzrL0I=; b=eu7OEt3X4uLHki18rl5ZUIiZ+CH6Bgy2msSpFqYOc/W+Fh6Qqem
        rvObVY2CRzUeC9975FxRMiUClHe/MSGgG3eX0Cv08MCZSb/VJZTTlqin8vCG+RdE
        ef7IwQkuwnpjQCq4etyw4u9TkNTNxv0Msc5Wk85IE7As5cYyOdYnvTDi1avIRlOM
        UyYrJsALxYW86W9k2YG5BrWX64+uab0ThbrvpJPG54ufVR2rFjPcAeUGPiEd0i0K
        6QNlKWu+ZviwGRaaj5YzkouQGgm7i70WJmDGT8LdphFolDAnRcoNx2NKt7W5Mh+c
        LrJDaz1IlyL4HLAKbjKW3eJ+UjaF2WqXBDA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id jB4Zi-62U19W for <linux-scsi@vger.kernel.org>;
        Thu, 24 Feb 2022 14:31:05 -0800 (PST)
Received: from [10.225.163.81] (unknown [10.225.163.81])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K4SKz6h42z1Rvlx;
        Thu, 24 Feb 2022 14:31:03 -0800 (PST)
Message-ID: <c91d1bb9-dd5d-e9be-5c37-405a13e91901@opensource.wdc.com>
Date:   Fri, 25 Feb 2022 07:31:02 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/5] scsi: mpt3sas: fix Mpi2SCSITaskManagementRequest_t
 TaskMID handling
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
References: <20220224101129.371905-1-damien.lemoal@opensource.wdc.com>
 <20220224101129.371905-2-damien.lemoal@opensource.wdc.com>
 <4143bc11-1c0c-e51f-f012-595c59bc8fdd@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <4143bc11-1c0c-e51f-f012-595c59bc8fdd@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/25/22 04:49, Bart Van Assche wrote:
> On 2/24/22 02:11, Damien Le Moal wrote:
>> diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_init.h b/drivers/scsi/mpt3sas/mpi/mpi2_init.h
>> index 8f1b903fe0a9..80bcf7d83184 100644
>> --- a/drivers/scsi/mpt3sas/mpi/mpi2_init.h
>> +++ b/drivers/scsi/mpt3sas/mpi/mpi2_init.h
>> @@ -428,7 +428,7 @@ typedef struct _MPI2_SCSI_TASK_MANAGE_REQUEST {
>>   	U16 Reserved3;		/*0x0A */
>>   	U8 LUN[8];		/*0x0C */
>>   	U32 Reserved4[7];	/*0x14 */
>> -	U16 TaskMID;		/*0x30 */
>> +	__le16 TaskMID;		/*0x30 */
>>   	U16 Reserved5;		/*0x32 */
>>   } MPI2_SCSI_TASK_MANAGE_REQUEST,
>>   	*PTR_MPI2_SCSI_TASK_MANAGE_REQUEST,
> 
> Is this change necessary? From drivers/scsi/mpt3sas/mpi/mpi2_type.h:
> 
> typedef __le16 U16;

Well, sparse seems to not catch that. Without the change, I get
warnings. Will check again.

> 
> BTW, I think the U16 etc. typedefs should disappear.

I agree on that :)

> 
> Thanks,
> 
> Bart.


-- 
Damien Le Moal
Western Digital Research
