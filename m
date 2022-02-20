Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45CC6C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 00:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242855AbiBTAi3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 19:38:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbiBTAi2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 19:38:28 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2B354F99
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 16:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645317487; x=1676853487;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DIVsCpJFE7keUNwhK2x1zsb0W8lm6x7ths8HP2F4cRY=;
  b=OyGgnB7g7aJ+EkWp/XJVeTEfcfMbG9ef6iusiGSSht/seYSfjfT8ZTpg
   y0wVoPY9KR4PKqo9ahvcbDbRaX/FX58o4npVav/l6LeLWwBQJwnItlhAF
   XHLHmB/TGQyNQPMnl6Zj1RyNK8R+nDG9qisggtvaqmwQwzukr82oiTuuj
   64DNVe15G0d08aSg61LizbV6Duyy7A5UbS8Uyz6THcWH0cvgWw7Thsef4
   IWfgmEEdr2zC26vwqEiKUcLNOrKasgXa/S/iDD5QdovZSJ0JxgD7aqTws
   1J6ahKXPNFwDjbupP7bvcubJccQFhwg2biA3eN24bNIG7uhwZ2nhN/nct
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="297519179"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 08:38:06 +0800
IronPort-SDR: dONVeH7lyi7kHJffvj586p8AM1beb+PUHOCnUGgsOqh61bvelr/V81Z/3GI9WWkpu0pVeQ+A3g
 zXusXvqv4cuE4gNa0VpYIIvQbWVqFVHpKpQDR8YHb481Kn8Dje7ks9xGrBuzNV8xxQsLC/dHAF
 YuI3otQu0MB6RBrl9G6pRsEu9oOtqf3pERzvi/gK3VH4O2Tg0yA9w1Dm+8kPD02RqMs+NLn8q7
 8ACtJUfM2eSWoqeY/Zg/PaoYV7l+2vuUg6hyXPMAp6LkrZjtoKNVN1lpiVSfP8qgx0MvhbvMWJ
 Qtf6M5I2AoJoruh67AGe0hU7
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 16:09:42 -0800
IronPort-SDR: gD0O572eA9/V7A43ZGgfycaYfvoSpx0+5j4ohBA/xCeLI1gGXZ+ra6pido0kxaZ1ivRcCvwPOE
 fa1MmDsIKma1E0wFHZg4DwjE9ACcssAEXfBsFwyRepLw2DzwOsJZX4cuHy1zCHKfu/IXT5fhAb
 5dgrRQkYiv1xGYKaa6RK99Nc5aEikqBS9l8H4qNneZMD25AwVw4J+t02OQfVzdrXrLukdlq2sx
 FMv0eyS6SRtuxXM2cwcRePTWcMMbs/742oV7qpW0lRkWXW07v+OLwuWXiYl78irREE1SLISV4N
 mxM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 16:38:07 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1RNt1dG4z1SVnx
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 16:38:06 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645317485; x=1647909486; bh=DIVsCpJFE7keUNwhK2x1zsb0W8lm6x7ths8
        HP2F4cRY=; b=Fy59Ld++C/Lu0mMc8exLg8NdLaXDvwfjiL7+uqgIcuR0yBaeHfv
        WZ+YvpzqVGGnKPRRAZtbXTO6HxgurGHEDv8nLwDzxR8VX4KcShBlLKOtPljym7p/
        pPQKfbI/oSIIcgFxlkxAtlfqwWjPT+U4zxhBKegEPzeGxmg9HCwMO9X2BwUB6XxF
        oSV9Wl2PWA4GMya9y6dAk63bsQVyjR4qslyGDnFcSMfmTsKx+5g6q0ZepmR3CFns
        Qv9q/5S0jlDyT8DZ/n5eiKUO0MKEc6v3PKz3nQa9oj1Q9xZIs0QBWHPWXwUJ2YRN
        1m8iN2eQ2kixMZ/GymL5u+jdp2UrRReJIpA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 5vQQJupg0YSK for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 16:38:05 -0800 (PST)
Received: from [10.225.163.78] (unknown [10.225.163.78])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1RNq3B9Nz1Rvlx;
        Sat, 19 Feb 2022 16:38:03 -0800 (PST)
Message-ID: <b9aea895-4b24-4529-0d87-5148e6990c95@opensource.wdc.com>
Date:   Sun, 20 Feb 2022 09:38:01 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 00/18] scsi: libsas and users: Factor out LLDD TMF code
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>
Cc:     jejb@linux.ibm.com, artur.paszkiewicz@intel.com,
        jinpu.wang@cloud.ionos.com, chenxiang66@hisilicon.com, hch@lst.de,
        Ajish.Koshy@microchip.com, yanaijie@huawei.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com,
        liuqi115@huawei.com, Viswas.G@microchip.com
References: <1645112566-115804-1-git-send-email-john.garry@huawei.com>
 <yq1zgmmh675.fsf@ca-mkp.ca.oracle.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <yq1zgmmh675.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/20/22 06:55, Martin K. Petersen wrote:
> 
> John,
> 
>> The LLDD TMF code is almost identical between hisi_sas, pm8001, and
>> mvsas drivers.
>>
>> This series factors out that code into libsas, thus reducing much
>> duplication and giving a net reduction of ~350 LoC.
> 
> Applied to 5.18/scsi-staging, thanks!

Did you push this ? I do not see John series in the branch...


-- 
Damien Le Moal
Western Digital Research
