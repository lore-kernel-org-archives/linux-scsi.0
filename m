Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8169DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242069AbiBKHSS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:18:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbiBKHSS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:18:18 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01407CEF
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644563897; x=1676099897;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Q9AsqirndMAHQHZqQIwUkk9DMMp46P1Fw6UY/Alc89g=;
  b=Pgf+fwaEAnCDOcuXyH14L4SLlFDewU5P5fMcSFkOxn/zWzklpue3WWtV
   wJypUQ8xhlacHdLoHZzCoyJJord24xM9TG3vAP7zPaHTvLNPFrA48Mrez
   VwG2XhDbpVGy00FbMJSwCTh7yC5RqtEKb0Yr3h0oS5u6JBYMDwdzyDC92
   tWK3ZKTEufft+ywAofUEP18TmE8aLvbIufhiukP5mqSkAKg/HEptWNHv+
   cL1iw6UV7gbUjE5JYYFa6kRHpfNWodh37Gqc29kEGNsk31tCPbxhpLc3y
   gIKciLOE5Lu+M1SOciWefZRjjqZFHj5tfmc/ISIEgllBFmMZucPBpQuDO
   A==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="304580638"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:18:17 +0800
IronPort-SDR: Kv4Ha95El7vPNkQZGqFaxUqxi1NjkH3X6OpnIth9IZNOoxsVZMn6CaMuBHJ8cSWUkGE/38Rn1C
 PrBwSFYA5eCT7xKu7HLmlr38LCq+bBUvRTtW/3XKFQcBp4tXQxzB1lJOmekNS4aexJSVmJ2Hpw
 3m5cO6dXaat/ayF6i3bsRMtftsQZacbsUNGMBMiIIXcTEdhk7PhBD938MF5go3TsIMSpTIx6m/
 7eeUf4ufpzNuIn6pIcpxqrKLm+SwH3oItwbz16lLsWRAeO6IG9LO9LSStkygLJBc+ShVdn2NEK
 PChp99JdQ4LJhPqCJ0ZK0mIo
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 22:51:13 -0800
IronPort-SDR: MDoMwEnbJxGPK+V6wr4CEx+wYkq5vDJX/XrDzFdStyKS/Wz9b6XXffPh4EDtM13n+OMachStIe
 yTuPhbxSDYnEC25z/f3lZyeNdZ+jT8FBKEuvhRiAirBhtqKBd7sYva735vitdCiBaLUyemVfT/
 gfeAlXVMhRtRiegIdy/BUcED1aUGFb4IkSnRmc6QEDRtw7lRlSLYEk4MIHqSzldyt3FTrQfKik
 3bhznPPrgvqOkand1rUv7K+OBYu5CibkPJxnbum2PG/m4Vg7vAeCXNyZxgY1kk7/blmMO2OlRs
 MRo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:18:18 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw4hn2mXCz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:18:17 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644563896; x=1647155897; bh=Q9AsqirndMAHQHZqQIwUkk9DMMp46P1Fw6U
        Y/Alc89g=; b=O9KoePm9AsIT9yr1c2tNbKIaCU+w0dn8p8Ukzn9RVCXNVk9u1pR
        X+eudy1MpP/w/3fd6z/cFqkOhHQISQN/IirX3FRwCGjHJpsJvmDhVgJECZaMJAfD
        VKu4b5FO/llzHenT2sZ4KdU/BCuy4GcCw4WMBu0Bdw7S1BuGLg2fvrI+CKKznvoK
        /zdkqzlBAw6wpFgih3smngajvSRwuprGdsnJioHikm5qWZSt3RBKzJnjVCyWHWkn
        3g+TYGtVF12Pp0i1SvpAMSyT2bO1pQ744gDuYks+gHfX7GEXNZ1cFq6f2h8Ag7Qj
        MnQJj6MjJIS63tpbUGQ8txUlnbtrJLPmUFQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Krapd6qHddLJ for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:18:16 -0800 (PST)
Received: from [10.225.163.67] (unknown [10.225.163.67])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw4hl5yf3z1Rwrw;
        Thu, 10 Feb 2022 23:18:15 -0800 (PST)
Message-ID: <904f84fe-f728-5fd6-eb71-fec597c88e29@opensource.wdc.com>
Date:   Fri, 11 Feb 2022 16:18:14 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 08/20] scsi: pm8001: Fix local variable declaration in
 pm80xx_pci_mem_copy()
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
 <20220210114218.632725-9-damien.lemoal@opensource.wdc.com>
 <YgX+v17KB3VZWPjn@infradead.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <YgX+v17KB3VZWPjn@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/22 15:14, Christoph Hellwig wrote:
> On Thu, Feb 10, 2022 at 08:42:06PM +0900, Damien Le Moal wrote:
>> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
>> @@ -71,14 +71,13 @@ static void pm80xx_pci_mem_copy(struct pm8001_hba_info  *pm8001_ha, u32 soffset,
>>  				u32 dw_count, u32 bus_base_number)
>>  {
>>  	u32 index, value, offset;
>> -	u32 *destination1;
>> -	destination1 = (u32 *)destination;
>> +	__le32 *destination1 = (__le32 *)destination;
> 
> I think the right fix here is to declare the destination argument as a
> le32 pointer without the incorrect const attribute.

Yes. Much cleaner :)


-- 
Damien Le Moal
Western Digital Research
