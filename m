Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11444C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Apr 2022 22:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbiD0WJM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Apr 2022 18:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238086AbiD0WIt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2022 18:08:49 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAC0237DC
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 15:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651097135; x=1682633135;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ltiub3iDq6D6Wb7M/70Y0VAAaW3D7ZlOojkFrPEHoeo=;
  b=Skr8I68pPMUR8cKi472dj8zdn4PkG/n9dfNhokP02ci3cERKVdOZioRH
   frEioB3FZ1BoI3the+3gdpWcVY+VPyHGX4jrhWEWIqrmeEKaChnlK3Maa
   BUH3ogPnKm9tHdOWwiumM/BVL3viCR4/HLGjQ9CoYGWG9ZTOvJb1GOFpn
   Paqsghnds83ZLrmNfJOVTRh1m87xjATOTqtoq6eRvuaCIERqVkrDMPGJD
   sPOIYQUfDVHPLcK9cQmYQPRLh3EdSsoVB8i+vwjx0rISr/yrCZOLvA76c
   /tJVQsmeTNeLTNkwmuu34vWd2RPStbaRCpjQZx4m8v85R74hWSL7kcN8V
   A==;
X-IronPort-AV: E=Sophos;i="5.90,294,1643644800"; 
   d="scan'208";a="198996981"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2022 06:05:34 +0800
IronPort-SDR: k48ZhxNIAyaBViLivn1hNQaW6S7A6qWfeDmilNSp1Zw3mnqdUkJlMWm576GekN+O2ncqx/rWdh
 RfPrZKiDTid5UJlrDmQULtz7Hk4IxDjClqwe1C2MR5rkC7XU5yHK63uHyxD7cXdpu3SaQs6n2U
 z6XXk7eD2aXKkdYv5CRevAL3ElIxkUXTWtA3SofMKRJo0VG6OBGZgbjTuplOAjJT6aUlRP5tWM
 3bDvM80zBzpsO14ogPiW6yzeyYdL0qer32LwrKaIppe6QOz92KpJa8kfm+NUDz4Vv6azHaXQDc
 CkkuQOo9r/A4ifM9I5io1iuo
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Apr 2022 14:36:27 -0700
IronPort-SDR: 6PSA4mM5U4H65HM6VwB/DrVVWvvf5ukHZAcqt4Q67XjfkOmmQwTT8SBJPl8GGO1y6D1VQeeF0v
 KkcquHEuSasXZ10xtZWZXjIkHknufKPdvJ5S0bnIZkKwObZzsezoQJYrMK1PtHrL0IrrCcuWgP
 +W/FKW7fGWGM5uNBbnYDrTqVrhOhLrnKVHriPi7gfnHBcZQIS2GVAzVTzKA7MgmjoUpscXi29y
 NAQsK89lYEXlZ3EI6TcZk+UaeG6FXbzImLBb433HfF1RtYnXPv+/+4tsgQk3jsanArvCEW0s3i
 +Xo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Apr 2022 15:05:35 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KpXqy6k1tz1SVp1
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 15:05:34 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1651097134; x=1653689135; bh=Ltiub3iDq6D6Wb7M/70Y0VAAaW3D7ZlOojk
        FrPEHoeo=; b=tf10gyOH0lx9kTAQMvmNEOqbTNS9DLTOZB9qsNe71qSj+MlslLY
        F2EMsRT1hYv8Uex+f8eyJX1V+hNKxnq0ZvLAwm2N9h1bKDM2qAdaXd8XFxq2OFtZ
        V4RlBXCG//INUr7wVIQqFsb2qymtVwVHXuxY8eD6UpYIYKBOcpCxEpfLcPWyOf+Z
        a1goiEri2UoD+WOlXIFCHSZYAnDDnYTLxwQ44EG/xQ6NBuYZ4KdX6hPN8R/IC8+K
        mjJuGAhmLtYWSzjRHY0sOUl5Yj3top3PIke6IkXYtsIwx8o7NXzckBhJqqv2uDvr
        xwDwWqUps86ht4CXLQyUclRDU1FKcwhVZrQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id o6PHTTDOjPkH for <linux-scsi@vger.kernel.org>;
        Wed, 27 Apr 2022 15:05:34 -0700 (PDT)
Received: from [10.225.163.27] (unknown [10.225.163.27])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KpXqx1gFtz1Rvlc;
        Wed, 27 Apr 2022 15:05:33 -0700 (PDT)
Message-ID: <c285f0da-ab1d-2b24-e5a4-21193ef93155@opensource.wdc.com>
Date:   Thu, 28 Apr 2022 07:05:32 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v4 00/10] Add Copy offload support
Content-Language: en-US
To:     Nitesh Shetty <nj.shetty@samsung.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        dm-devel@redhat.com, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, nitheshshetty@gmail.com,
        linux-kernel@vger.kernel.org
References: <CGME20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15@epcas5p4.samsung.com>
 <20220426101241.30100-1-nj.shetty@samsung.com>
 <6a85e8c8-d9d1-f192-f10d-09052703c99a@opensource.wdc.com>
 <20220427124951.GA9558@test-zns>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220427124951.GA9558@test-zns>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/27/22 21:49, Nitesh Shetty wrote:
> O Wed, Apr 27, 2022 at 11:19:48AM +0900, Damien Le Moal wrote:
>> On 4/26/22 19:12, Nitesh Shetty wrote:
>>> The patch series covers the points discussed in November 2021 virtual=
 call
>>> [LSF/MM/BFP TOPIC] Storage: Copy Offload[0].
>>> We have covered the Initial agreed requirements in this patchset.
>>> Patchset borrows Mikulas's token based approach for 2 bdev
>>> implementation.
>>>
>>> Overall series supports =E2=80=93
>>>
>>> 1. Driver
>>> - NVMe Copy command (single NS), including support in nvme-target (fo=
r
>>>     block and file backend)
>>
>> It would also be nice to have copy offload emulation in null_blk for t=
esting.
>>
>=20
> We can plan this in next phase of copy support, once this series settle=
s down.

So how can people test your series ? Not a lot of drives out there with
copy support.

>=20
> --
> Nitesh Shetty
>=20
>=20


--=20
Damien Le Moal
Western Digital Research
