Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C38EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 22:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345155AbiBJWop (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 17:44:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345168AbiBJWoo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 17:44:44 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6FB5F45
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 14:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644533083; x=1676069083;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=G5frLUnXTzMi3cXM68OvzRGggeQ3t2E2YhR1gGwKdq8=;
  b=VDh9nvoHNVojZFw0Q7Dl0fqaG9okcUWny4nAVpMlbWK8tQekzg5uFwu9
   +pw3cbltzgNvsGPrIEWRnBk0IwG+Du9wWfI5nZZvvw8wGhYyo04zvc37V
   vL8SwnMzHrR9w4GotJ75ULkVPJlHAISN2FSW+lGlzL4hJPu2jPH65oW1A
   13XwncdWRFb5zGEBTWWm/OLyyt0qInD/creNs7c/f7eu2M7SV1xnREwTa
   cbth+ifHne67qzYjJxujretdLuupN15OoQGSvHtp3nN3K2GOqDypCqyIE
   8+NtsHpy5zmbCrWEfuDs6ltA42W0HCCV6qVtT/+htlUEeacMZu7HwWEBG
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="191585774"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 06:44:43 +0800
IronPort-SDR: lTMNPXv51wd5uyTjOOT84XbBeSBza/R+DuWu82dYZNrkBPa1Ck8JTSI1c7ZHZpNMVtz8N+4DIi
 ticQ6urUbtkU9F/lev4TP3MU9PhJz4hxB2UFXCbOtbRYEtFYrDKg7QqYK1t+tbJjUhOfhoHrrt
 3nmvwAKF4fIIhshvXrBBke6D18ZHKsnSk+Z59g3xCUaHPj/n8ndHZ/4Xz709e2TpczBUIg6dj5
 VLrD/ic5tu8i/BP7l3piEF2xbryuoxttyp4eCNrtB13yZFFGcAkDLrOHkpQY63h6i0vYenfSvj
 RJEYGQJ1ffiNFHWkvLJ/IOss
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 14:17:40 -0800
IronPort-SDR: QN2vGjLMnabAXMg03laZDSIiIN4amckqxschlAeZlMpKebZHnXGSFp4v1LlVSIK8qkO+1AhFBe
 VZtWrJUnISJcvMLd5AJj9Pda+ZPG7JBCqpUxM8di3M8hZ1PWUo0fzu70p7kKqX3UJEDr6OQGtZ
 33832J33iqmyhsrzNP4m5ap/dzvr57EjgvQJ7SxpmKte9pTbiV1NvZGI3aa6u+t9udmU3hUSxw
 kVp+kmYU/d7FyUAhTid5hmu8F7GyZivUXqPG5H6uK0Ob3vZpVx/F4DPj0i2mW9uE+wJvf9/Yxt
 8bs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 14:44:44 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvsJC2PnPz1SHwl
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 14:44:43 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644533083; x=1647125084; bh=G5frLUnXTzMi3cXM68OvzRGggeQ3t2E2YhR
        1gGwKdq8=; b=VAxoBqHXhPT9EDd3w7kFRs1poVmx3nEw/AfmkNqHk0zY7ODHXRD
        1Z7icuaQeWjgIGo0HdBqk4ok7s36fanltv00rxKQw9HVjiCRFSF0q+hyB7wqaFoE
        ANHhqWlaFLohioOdfYtNS63QHr3z+sBsW0rjbyHzulqutOk5X+yb7TejzHJR9l+S
        qr4+GIdBHdYGMLrkY7GuDvw/85xi6wwUZV5Li3ULI2+rfCqBMk8t5F/O6+zo3JfL
        MnUrfXoj8Ng0Lc998UgFA90JKWl3JUK7iCpQZxxz9zOHltR5pkB9c6cRNIUno6VJ
        EESWYd3nJ+CRI5DAPcIDANocO0p13DVrjBQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id olxh3r-9JJRK for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 14:44:43 -0800 (PST)
Received: from [10.225.163.67] (unknown [10.225.163.67])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvsJB2K3Fz1Rwrw;
        Thu, 10 Feb 2022 14:44:42 -0800 (PST)
Message-ID: <ea6b25db-d4da-bab5-8bf2-ec5024c95f89@opensource.wdc.com>
Date:   Fri, 11 Feb 2022 07:44:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 00/20] libsas and pm8001 fixes
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
 <b3efd3cf-e36b-9594-06b8-9772bb525e00@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <b3efd3cf-e36b-9594-06b8-9772bb525e00@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/22 00:35, John Garry wrote:
> On 10/02/2022 11:41, Damien Le Moal wrote:
>> The first 3 patches fix a problem with libsas handling of NCQ NON DATA
>> commands and simplify libsas code in a couple of places.
>> The remaining patches are fixes for the pm8001 driver:
>> * All sparse warnings are addressed, fixing along the way many le32
>>    handling bugs for big-endian architectures
>> * Fix handling of NCQ NON DATA commands
>> * Fix NCQ error recovery (abort all task execution) that was causing a
>>    crash
>> * Simplify the code in many places
>>
>> With these fixes, libzbc test suite passes all test case. This test
>> suite was used with an SMR drive for testing because it generates many
>> NCQ NON DATA commands (for zone management commands) and also generates
>> many NCQ command errors to check ASC/ASCQ returned by the device. With
>> the test suite, the error recovery path was extensively exercised.
>>
>> Note that without these patches, libzbc test suite result in the
>> controller hanging, or in kernel crashes.
> 
> Unfortunately I still see the hang on my arm64 system with this series :(

That is unfortunate. Any particular command sequence triggering the hang
? Or is it random ? What workload are you running ?

> 
> Thanks,
> John


-- 
Damien Le Moal
Western Digital Research
