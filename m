Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4FE7C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 23:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbiBXXTd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 18:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbiBXXTb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 18:19:31 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C01723892C
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 15:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645744740; x=1677280740;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=pr5g1OurZt+M/4GtXsnSqGs9UgLlb5cYv1RaVLspDdg=;
  b=gYptbPwMUBnvGXaEd1C70IYLoMQKdGGx/O28Bm+Dp7brhn1PkoDRK7lA
   2k1+AhV3TEY9aWcB4CLgQ2NpMIiRLAlJzq0McXTQ8g31pGjpnkQIl6Mcc
   PNqjFlZFGa7IupkuFT0+x4IueHXQrc2BySAQNTl8UiUKSLNIn7/fFnpql
   QVVWWj7nwxxgnjPLhGbIBUU43W/IbBf4+93VfAirvbDIcvD1X/cWrw+XX
   VAD50jjLXRVQMrPUKt0cPVOw2lFuhxhDc8MKOpHsXZso+Vi7F3uLCCBVp
   +hgoclph/s07yUD06gGujpqVWnTZ4w1o1mJF8E9NO6O49oo/4hx1KiJQq
   w==;
X-IronPort-AV: E=Sophos;i="5.90,134,1643644800"; 
   d="scan'208";a="298017443"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Feb 2022 07:19:00 +0800
IronPort-SDR: L3R208YYtXhSGhgKoTv1/cqpqjntka+H3+09eVwgw/DyB/rlryHj1EsdAOW9AcM7uXd4HKsFVf
 5hXGL4oF7usZeGOklro9etZKjp/zRWU70mlmFOrjytDp4XsnQ32MgaSYmXRmii3GnUemSTMeZs
 3XO3i9nb4ZZ3JPWSgZVlL1VR+YChb3K2VOBGEZF1NjLyyqLMkOWFAY5ghb4xqXAi/4fP2RSk4g
 yFsQN+IlzYXzh1i5n92FftyoDfgOuaqPbZxDqZDdTCJ9ieM4GTHpQ4YAiXTnHj5Q0eB9HupOJ7
 m9DV3EHIkaKj+mgdTfv6/FcG
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 14:51:35 -0800
IronPort-SDR: 1Wc5ZVqSOU9CkzBWRMTeli0fZfYCpXjsF7hx4hWyfv4cXAGO4w8uyDxr3YzNj52oIIxfQupueL
 z+q8B5pIPBdeEPQ0xfm0pRzNbdiXMPpMn8KA3+QutK7NsYVcgobM2HofIe4NuvdhwYc/hVkIhd
 C5UUc9E+4Bcb11nUplukHnIAQ94YBahGntMTWqeKXMH8CVr6FV/azRJ2ipgGaJsnIVh5SSSVnC
 wo6hjfnpPxqR6MT8v6AdZQD9KL9qTgst5GMii1jV8sr7DgdY6BdAuCQbfmoLwGV8EDMhFlCbiS
 pVs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 15:19:00 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K4TPJ1ZGTz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 15:19:00 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645744739; x=1648336740; bh=pr5g1OurZt+M/4GtXsnSqGs9UgLlb5cYv1R
        aVLspDdg=; b=UYMENO3IYUcJx351L0/POFR1n4afHp+76JdHF7FASK4BATjlL8a
        MO+fJZqVQ3VWfFdQ4rFV3tyZjBDQIEjsk55S7ZMrGt/f/ytkV8vINP2GJ0krr27u
        ugPyOvm9fo/Vfr9BILcwLN3DRZ6eME1soERtQ6fJmx7peUkmag4jzv4SiC1bY8En
        9DFubvf8XBLqvQTl681liJ6dP+Vi6GF0wNUTdBnIFd5wtQWsrtoB+TAf1ZW3lWAl
        KDSxrq14jYkfzLvXks8yx3GdoHxNjfP3Gh36EYCKOZcVuy/38tDe4+60g7tzRyFe
        Gik+pvHzEr5f31KE7SFJ64AL97umxCLQyCA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Cu67SlTX5F61 for <linux-scsi@vger.kernel.org>;
        Thu, 24 Feb 2022 15:18:59 -0800 (PST)
Received: from [10.225.163.81] (unknown [10.225.163.81])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K4TPG1JH2z1Rvlx;
        Thu, 24 Feb 2022 15:18:57 -0800 (PST)
Message-ID: <f3119d75-25d9-ab1a-8712-891e0c81ce70@opensource.wdc.com>
Date:   Fri, 25 Feb 2022 08:18:56 +0900
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

Bart,

You are correct. The type change is not needed. Sending v2 with the update.

Thanks for checking.

> 
> BTW, I think the U16 etc. typedefs should disappear.
> 
> Thanks,
> 
> Bart.


-- 
Damien Le Moal
Western Digital Research
