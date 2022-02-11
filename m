Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FFF5C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347513AbiBKHDr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:03:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233024AbiBKHDq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:03:46 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4409CF4B
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644563024; x=1676099024;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LBzMf+lrEVMq1jRMiXl0v+JCtqJnjC9175uzxGxi6a4=;
  b=gVpt4CuQD2qg1AUwi/NhgeZOoQ0/+HvWeGc6487nf61eiNm9o/THcDtW
   1cnCvt2U8Map7lviyjudOGmMxdxePi6DjFk58Ql2wu6RUfCeUjiVTApPd
   PTNTA3BITR0J5+8q/WJfe2uW0w+YeaAJYO1GaSwaAe1/DxpeSAN/4/8Iw
   XX/s2FA0GoqSPSKeLjGsLUKRL+mbpYVLVgBS+sl0J/BV80o6wOWYwTkPz
   qtjDbvw6Zn/1KCRU/YsJPbtyYoscfSLF3riySSgmaZ0gxwGC1YgdZ2SQI
   BYipZ+txFquX208B58ijeYqHtO9dNO1kIsDhD+TXn8BaI5FmUjOSyuSDe
   g==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="304579689"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:03:44 +0800
IronPort-SDR: 6mGWRnEF4T6Kird5hfIIqQ5wJjbinKGmfDwNNYmcjSnqR3dIxYdtN3RVwqyCY0aaSsAVUMvFgu
 wad6FkyVTADF3WF8V0saJA3JS7EQu91t6HZMNMWZW2GOsJN25QXvtPvYHUtQ3pF5HAE6scr7rC
 +Y9KfLXer661ZweeYmwyK1UHNX7NZJ2z6PDVymkqiQtCtklyLfxq3SoVrCfS4WmGXryWSQpGep
 /RTJNfUIpJpplVWU+AXHijP0M3sodbsuZTnNv06GozLXF/JRZttrBnRsxVl1WRySw23+ghgpLd
 cT4xUDfV9/OaazS0ApjZDWhK
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 22:36:40 -0800
IronPort-SDR: RpnkWMETwDYLaq/b2bTV9q6UYDq151rp/7hViEvn3PTcOc83yvuMPtnXwHouvEUx4AtNHm0Dh+
 72gQK9Ogn5UG9DjYeRRShHFOx40IN+Ij0DoggRXiP0iNoHg067PtB5DmgUCFfmprw23Fe20ZVu
 LGbrboSC9ztIUGkZt0Y3fODLE7pa7WEJr8jKEk50mMkfA/4VMCBxKzZC/M5NKR2aCL4Mg0m0xA
 sH5LYaVK4KolB12466a8dlUB/GnHGyFai0HzjlTY2G+fdVKvyDAcygdg0h9ysl6xQ9+JQq3fcJ
 234=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:03:44 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw4N020yWz1SVny
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:03:44 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644563023; x=1647155024; bh=LBzMf+lrEVMq1jRMiXl0v+JCtqJnjC9175u
        zxGxi6a4=; b=GhxWWOZwHnpSSsZ3u8XZnYIFOrMChFHfSakv3WeHcpFlZ+mRAod
        TeGCxlriCanu1h14KVTpWi33AcQyuG6Dp8MQJIxuxbUhoXiJv+pb8+rYK19QMHv1
        8eLdA8C5KjMmZlrrYr1531mPM5rbFYjX4UWRvpSm4wefI/dgp8x6zTeXHZsHVVgt
        ihv+dw5BaOlYU7dY17HixGSUrg95k/jV9XOg5nwQsXBFz0QDPSRCMFa+npB1nlB+
        0O5UKLLtpFF7RYHCdxTdImeQtLy991c7X2TF4NeA9af3N4bklAggJHjNKeLN9OkH
        YZmqK4O5Pv01Tj+hwzOyS504c9N5dEuhzyA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id rnaAMSg5CVE4 for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:03:43 -0800 (PST)
Received: from [10.225.163.67] (unknown [10.225.163.67])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw4My5p1Pz1Rwrw;
        Thu, 10 Feb 2022 23:03:42 -0800 (PST)
Message-ID: <33abcc95-5e91-88eb-ba70-358e051aeb82@opensource.wdc.com>
Date:   Fri, 11 Feb 2022 16:03:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 04/20] scsi: pm8001: fix __iomem pointer use in
 pm8001_phy_control()
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
 <20220210114218.632725-5-damien.lemoal@opensource.wdc.com>
 <YgX+Cdjeok1ClSVo@infradead.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <YgX+Cdjeok1ClSVo@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/22 15:11, Christoph Hellwig wrote:
> On Thu, Feb 10, 2022 at 08:42:02PM +0900, Damien Le Moal wrote:
>>  			struct sas_phy *phy = sas_phy->phy;
>> -			uint32_t *qp = (uint32_t *)(((char *)
>> -				pm8001_ha->io_mem[2].memvirtaddr)
>> -				+ 0x1034 + (0x4000 * (phy_id & 3)));
>> +			unsigned long vaddr = (unsigned long)
>> +				pm8001_ha->io_mem[2].memvirtaddr;
>> +			uint32_t *qp = (uint32_t *)
>> +				(vaddr + 0x1034 + (0x4000 * (phy_id & 3)));
> 
> This just removes the warning, but does not actually fix the issue.
> Both long_vaddr and qp need to be __iomem pointers...
> 
>>  
>>  			phy->invalid_dword_count = qp[0];
>>  			phy->running_disparity_error_count = qp[1];
> 
> ... and reads from qp need to use readl.

OK. About to send a v2 with more fixes. Will rework this one and patch 8
too.

-- 
Damien Le Moal
Western Digital Research
