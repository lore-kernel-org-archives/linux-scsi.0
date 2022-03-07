Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB461C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 23:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243752AbiCGXvi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 18:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238170AbiCGXvg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 18:51:36 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18823B2F
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 15:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646697040; x=1678233040;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gTrB+zcRw4X+VeH6qKErl8vHI881bxGe3QAkTEkVZpY=;
  b=mqi64C2ViUq7T1iAXPmhlEX6ngaYj1SmwSyhSikD0Wj5Y20sv288tgOr
   fryqjCBPJcl7RE7tidLjSPn2z5ex6/zuDFTUuIwXShzxqXS5jg64VA+cZ
   IZd8at64a1HcMMVJ/c1NyGAvPu5Ihj4noNUcD21yNQuhsy3SbWW+7711l
   aw0acFBTQYPL1SIVvdCtQZHClx/4WYSqwDdu/irfYuTOIfoHq6ytXNGnt
   x+gaKZkybMT/1tsstmfGNzifiUE6jF6UGb9+Jdd9p9QDBFMb9aykVa14D
   4GkXDMV+nNSTrAsrFotojAu6/LJNrHJQio59kEFJ5bGTJN8zZsof7kig5
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,163,1643644800"; 
   d="scan'208";a="194707282"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Mar 2022 07:50:39 +0800
IronPort-SDR: 3fM+8brHNlwOrc59FHOQW4+dTrQPfp3nzUDD4XjtW61xt6jEUBmLn1U0w/niCH/TaRSl9v1IQm
 LjAcTC1igflFhDncg1dC5rI1qMCUyojhO6ScWz9/t4wgBn4yZ2M2465sReql4ePMi7ujByUBZk
 lopYuOYPAQG3kLOW/xAsNES1CpRt4hLNVTwSCeHiqITFlF/pYOlIhl/ZLRNDp6rmN1u9ELggFD
 Cm1awZ3wmdQ/LSMP4XXBY0RyU64IhKWhOwwBGojeMS8pBIbz0jQInu68CPc/TU3G6Px62j47dp
 6DcZAzpJPtBJmF7YTz1VwhCY
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 15:21:56 -0800
IronPort-SDR: gPexMMxUjyCgp15rqKC9aGo8Q3gU8Pm2pjR0N2VnBAwMCwsWN57/SyKuttezJQZsf6opva84p7
 UcgJgU+NnwciIRNsM1gcSyTt78ZpB69oL+id32V4tvMOWr/QfI8YIclaIlEGuwr5ppAE9GBFRO
 SMep4+CeE+3wpOwCOK+2M6zqWKCqB8Fc/GobPk9UTQc5bZ/NwFm9cz/Y0SpAaBukQzO2gtlzW1
 yWBDV1jUs8rOY37CN6Dm06i9F+p8ej9xWhxlz3ZhPlE6cpfowsdia6c28QC0XFoEAjIvE1WQu1
 VsI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 15:50:40 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KCFZl4JFZz1Rwrw
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 15:50:39 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1646697039; x=1649289040; bh=gTrB+zcRw4X+VeH6qKErl8vHI881bxGe3QA
        kTEkVZpY=; b=NCao+iHoiQVAgU6Pf+I2C2uOO0kueIdB5iK8TlMkIW9ZVezo8uk
        UzCOlNAWx8/e5nVV9Lj6vR5rBvEKSHk5IArB9eLm7krHk/DBSpvuPDQsa6j0uLOj
        jKObUFXGvL8E52DDaqIlcrd3wVoDuToPWgfq7SKG3LXyQ3GZ6MArivZW3XFS8UJa
        H44nRnszh2/GA63o0Mlfny0d0RxSiuceZf5nez7+HhMylbcZYnFh94Sw4nHw5Hrq
        INlM9nEk6Zn33WT63+hY7+tq2CkKYmZNpsye8nvSuSjJAMjCEFpkPirrBPv+DO/q
        z47ih3Tt9uU4pI2SNK0RSH9nQzDbp77JOQw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vl4TIfrc5jCG for <linux-scsi@vger.kernel.org>;
        Mon,  7 Mar 2022 15:50:39 -0800 (PST)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KCFZk38kxz1Rvlx;
        Mon,  7 Mar 2022 15:50:38 -0800 (PST)
Message-ID: <85566dd4-27c3-7200-0431-d986166bbe3b@opensource.wdc.com>
Date:   Tue, 8 Mar 2022 08:50:37 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 5/5] scsi: mpt3sas: fix adapter replyPostRegisterIndex
 handling
Content-Language: en-US
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>
References: <20220224233056.398054-1-damien.lemoal@opensource.wdc.com>
 <20220224233056.398054-6-damien.lemoal@opensource.wdc.com>
 <CAK=zhgosk4YHiKVriYAVNL8oApnA6MsEz9jvOo3imkCUpOpTRQ@mail.gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <CAK=zhgosk4YHiKVriYAVNL8oApnA6MsEz9jvOo3imkCUpOpTRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 16:35, Sreekanth Reddy wrote:
> On Fri, Feb 25, 2022 at 5:01 AM Damien Le Moal
> <damien.lemoal@opensource.wdc.com> wrote:
>>
>> The replyPostRegisterIndex array of struct MPT3SAS_ADAPTER is regular
>> memory allocated from RAM, and not an IO mem resource. writel() should
>> thus not be used to assign values to the array entries. Replace the
>> writel() call modifying the array with direct assignements. This change
>> suppresses sparse warnings.
> 
> writel() is a must here.  replyPostRegisterIndex array is having the
> iommu address.
> and here the driver is writing the data to these iommu addresses retrieved from
> replyPostRegisterIndex array.

Fixed in v3. Please check.


-- 
Damien Le Moal
Western Digital Research
