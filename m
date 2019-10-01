Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBAC1FA373E
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 08:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABFFA21855
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 08:08:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="KDo5Rr3U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732725AbfJAIIf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Oct 2019 04:08:35 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:35316 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfJAIIf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Oct 2019 04:08:35 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9188GGL039985;
        Tue, 1 Oct 2019 03:08:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1569917296;
        bh=u0cggHMWmXH1/BQhRH2hltbM1FnM0NE1gudWCQoPpcc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=KDo5Rr3U6MgzYN8aJcr23hU/Dh/U6YYupfk1Aq2Wj7kTn92wDhtRFkLvZ2Os3D0/G
         nIgUzkZxPOAT6mJFfDBe2sBqV23xZVq6w/P84ZBoMMr84tB3ek06QRApjEs4XT5qDK
         nQw1raolrDb/se/FhSWlE/2UshsMiRMF+1ki0pIw=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x9188Gsp129452
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 1 Oct 2019 03:08:16 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Tue, 1 Oct
 2019 03:08:06 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Tue, 1 Oct 2019 03:08:16 -0500
Received: from [172.24.145.136] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9188CZK128433;
        Tue, 1 Oct 2019 03:08:13 -0500
Subject: Re: [PATCH 0/2] scsi: ufs: Add driver for TI wrapper for Cadence UFS
 IP
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, <jejb@linux.ibm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Janek Kotas <jank@cadence.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <nsekhar@ti.com>
References: <20190918133921.25844-1-vigneshr@ti.com>
 <yq14l0tw21j.fsf@oracle.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <bfcdfce5-64d5-4cd1-cefd-b363e6fddcd5@ti.com>
Date:   Tue, 1 Oct 2019 13:38:46 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <yq14l0tw21j.fsf@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 01/10/19 9:27 AM, Martin K. Petersen wrote:
> 
> Vignesh,
> 
>> This series add DT bindings and driver for TI wrapper for Cadence UFS
>> IP that is present on TI's J721e SoC
> 
> Will need some reviews from DT and ufs folks respectively before I can
> queue this up.
> 

Ok, thanks for the update! I guess I have the required reviewers on CC
for DT and SCSI/UFS as mentioned in MAINTAINERS file for . Please let me
know if I missed someone

Will wait for their comments/Acks.

> Thanks!
> 

-- 
Regards
Vignesh
