Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD06CC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 13:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350418AbiBKNHt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 08:07:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237873AbiBKNHs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 08:07:48 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0C6239
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 05:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644584868; x=1676120868;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=USUYx8TicVKeuTUKDGqtTrL2s93Sv2fx09IlkCmcEnA=;
  b=M5Y8J0CP7Jjvz/qrZrjGZkKrqccfUJTWfDcozgNETPNSYm2kV8XwdxOl
   PndzJpKDpDkSyVsBq5HKDLoixXxTlzghwhMBzum18J1XbXLW+bZO/VlAT
   eXOaorzsFss3xYhZuU+ZfDPy4ry81TCyNwnfp2KWRSKYdC+e8wdfz+7mf
   43NacJkZtm4/qyasPA8+qQubXxDmDhfiYUmz4v+4piQkuX6qy0HBL0tBg
   IiRla+RX1kHU0fFI/kbPTrOSUWkwEeuikste7ILZBaDz1n/w62kZeFW1V
   BpLM4y4YE9+Xbpg0WksIi3OcTkoEjGLvvGwJzHY+JiEgXoe2hD+MoLu1/
   A==;
X-IronPort-AV: E=Sophos;i="5.88,361,1635177600"; 
   d="scan'208";a="193674722"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 21:07:48 +0800
IronPort-SDR: W+jlvvgElvBd4M6htoQKRSnrF86iSos4QfqvM9rafdh7SJMRbGzwRC6JcaVooCEXP9rGxRh5IG
 amKCt8TV/RFt69Vg20kUe/kwJ8ZrLAVqrd3gjqtunjcciabnDezgJ81LDWZkgTErCII44FrV3y
 WKK8cTgd8l0apowV+OL4cQ2XGReHehJa2Lh+p3bP+GJbDUvcMBMevMyyM2njufQPxx1UcvjNcm
 +AY2nHqksXFZriE+y1c35Ds7+jJaVtYO9JgbSuXCpqzMHkV7VD3X+8cu31/qsBpyrY+IexDukg
 gidOs0FAspoUrTwr1IluGKe1
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 04:39:33 -0800
IronPort-SDR: UOqGGi7Qpr51dLulntg/L1pU0vT749aAajousnNfNMWWfdkrSaCZDKegIaEtz+eTEUR72cWWYx
 BIKUdMQG+Bs+GTY+KMubgh9WWRCat90f/OSNPtXjY2FsczHmxdQumObNoDNy7b53kZDBrvIdd8
 vUba27vzR/l/i0ugImGAe+Ir7WM36VBWfNw0mRI0odMWGSZmsT30oIZ2COEUyyPVf+dOwTh81Y
 409fxVsjjIsys/o2i8IlbS8qV8IYsvcP9NUAQs/U/86o7Yf4yEhdokYV2v4lWIrGjibKIpYvGU
 GpU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 05:07:47 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JwDS30jtJz1SVp2
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 05:07:47 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644584866; x=1647176867; bh=USUYx8TicVKeuTUKDGqtTrL2s93Sv2fx09I
        lkCmcEnA=; b=o6GKXccTAWAiyxBdLNi2nQZDs8KYRfai1wQ0wls9FoKpzucLKPn
        rMZyuGAjZUQrJfUtjSqTGyZl5yKCWzmafsyCHPnRZ4VI4B01y6U33/Sb+vcsJyV2
        NrBzk/xW6bx9FsF1vWFgkcQ8v9eC5WeCCG/BNneQvCuEELtRZilX/njxnvI3YrEU
        KSId5IlI8HYWnHyvBWgfpiHrwmoCcU+bID/uPhhtQU0z9Ed9IA8pwlwbS2i+O9nX
        JkRW4UyCt9vR0FcjFYuESSPOVRsjydtxjWefQVAL8kXSyzyhdFny72tx8eOjUw8X
        r0NikWneB42AdWONXcbCBsYwlFqwlJJ1SCg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id QC5XZnk3fUpM for <linux-scsi@vger.kernel.org>;
        Fri, 11 Feb 2022 05:07:46 -0800 (PST)
Received: from [10.225.163.67] (unknown [10.225.163.67])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JwDS14lBpz1Rwrw;
        Fri, 11 Feb 2022 05:07:45 -0800 (PST)
Message-ID: <bbd22b8c-7719-2539-2b09-701d60b7ae71@opensource.wdc.com>
Date:   Fri, 11 Feb 2022 22:07:44 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 21/24] scsi: pm8001: Fix pm8001_task_exec()
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
 <20220211073704.963993-22-damien.lemoal@opensource.wdc.com>
 <84d4c573-661a-39d5-f639-a3eb9ba8c0ee@huawei.com>
 <c21ed2da-73e9-b388-cef6-d350b504d0f1@opensource.wdc.com>
 <c6dcf35a-4d0a-b812-36b9-20c5b681aa42@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <c6dcf35a-4d0a-b812-36b9-20c5b681aa42@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/22 22:05, John Garry wrote:
> On 11/02/2022 12:57, Damien Le Moal wrote:
>>> I thought the current code was ok, as we init n_elem = 0 and we only
>>> ever loop once. Am I missing something?
>> It was not clear to me because of the loop. If the loop is done only
>> once, why the loop in the first place ?
>>
>> Hold on...
>>
>> Oh ! It is a while(0)... OK, this too ugly to live.
> 
> I didn't see the point of the while (0) loop at all.
> 
>   We need to do
>> something about this. The continue at the beginning of the loop seems
>> totally crazy as it may lead to the same task being reused, so multiple
>> ->task_done() calls for the same task. Is that sane ?
> 
> No.
> 
> And I think continue in while(0) has has effect as break - it falls out.

OK. So the loop is really useless, and confusing. Will clean that up to
make the code cleaner and easier to understand.

> 
> Thanks,
> John
> 
> 


-- 
Damien Le Moal
Western Digital Research
