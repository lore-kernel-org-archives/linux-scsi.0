Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C45C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Apr 2022 21:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351511AbiD1Vk6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Apr 2022 17:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237269AbiD1Vk6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Apr 2022 17:40:58 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6654CC1CA1
        for <linux-scsi@vger.kernel.org>; Thu, 28 Apr 2022 14:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651181862; x=1682717862;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ks/UYFZ4BEuJfvHdflvtNX42llFGKlgREEMC26vTdf8=;
  b=m83tfNNoAWXOkGW+9stdy1sRJKtj4scFkSyoBp1uqGK+CgIDCTRBVbgv
   w76vD3cu6nHqmnap0+alt7LO9OCHAQ2dHo81E9vncquU1ybciIlNN5E1O
   bBsm0a7wUJCcBM3y38QGgJlycEb7dBhCIA9kNJPCVyjeE/6tx8dP+8qyX
   /fnRL526+zZiVXt1YNtmW8hRmB9oJ/9FfWbtbjw8sGX9GDOc50QJ+TtSu
   VUckKA3PYjo3Q+Q7fxLZp9httdFwpIxV5F9/ivJTu0gp6Bhrx8KpJUGbK
   xGVLGkEBbO/CIhmkgud2ZGUb65PG16gnD9T0cL2wzDTv9YzyH+A4gw4IL
   w==;
X-IronPort-AV: E=Sophos;i="5.91,296,1647273600"; 
   d="scan'208";a="311070685"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 29 Apr 2022 05:37:23 +0800
IronPort-SDR: BBhGXrnzpDd5SwkgvPQy55p7+P4ccV4KA4HzXs9uFVuUdBV9YkPuY2BoSYrev+ujAF5J8DlgQe
 HX2RLluoPEyN3v6Q1owEC26RheE2GzLLanMbYEdWtQaCJlBtMjMWCgBRfTlBDTtWVjL9TgwS2z
 08/1HogVunfB5R+sXOD+nUCo/K8w86w3F4DtjBDPWtyBZfEzkQqFGqecpq8jYImuwAWJhFJ9M3
 yFUPeYduetRpbAqaMIWB9wT9XeIddnMVy+P4uNtg79AsL8zs4ll4mNJxNT2/wp9uUkP3nC1DIm
 5V8TfJQr7qcAbNds5yrkcrDU
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Apr 2022 14:07:31 -0700
IronPort-SDR: 6dIwo5EXjDo6/wa1AEubQFRcQUxS/J2XWQcj1p9i9zpQ51ddzArTDQ6lq/zFvGLZuxSu912GDJ
 XU5HxZmSkWC4VofGUuetMlDHQXySSIYwtjSLSzrHFxojXno6j8CbDoO71Hwk7HIrP0GMLnvULV
 59n60kOVUePqp3Cwq8Wcm5tlQB2bLldRIjeYaI/O/1XVt48PJbCZT7tPSq7WmnzMjXYU++uUcl
 RHmCoCnwovFuMEdqLNj267KE04RRJWiU2KGtdFHbx+7BTslymejDAYCW42jDEldngTu0T6tAsy
 M64=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Apr 2022 14:37:23 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Kq88x5Qktz1SVnx
        for <linux-scsi@vger.kernel.org>; Thu, 28 Apr 2022 14:37:21 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1651181841; x=1653773842; bh=ks/UYFZ4BEuJfvHdflvtNX42llFGKlgREEM
        C26vTdf8=; b=Pia8U2+MTp2QRDkEB4f2LrGB1ac2qZfAErgsCBWCFKjMxrXVn/Y
        bwkaAOoOvDD9yplFQBQeoOJVsSLVROSZs/aY7852UH4Hkft/gJ8l5Vevs96ehApm
        H01Pi7zw03XrBAhpZA+8aNjI4XPTSKE/B53mqI7jTUhf+kO3QzvvSihGG5g4JCrn
        J7FkLjqy1G9aN6QLiRcqwX03ov+vXozvTOfikx/Qr8m+XOlL3cwYuWTPPQFKLuuT
        dLexhqGOTQGF+oDQFcdirmTE+zKbH/a93K/4NbxqEWezpvNJTnGI1pJhScoN+3RX
        JtdhbfwQOwWUwz6SrnP4PdT/zkoQdrOf4pw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id DBu60GD1ByHu for <linux-scsi@vger.kernel.org>;
        Thu, 28 Apr 2022 14:37:21 -0700 (PDT)
Received: from [10.225.163.27] (unknown [10.225.163.27])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kq88w02gHz1Rvlc;
        Thu, 28 Apr 2022 14:37:19 -0700 (PDT)
Message-ID: <a6d1c61a-14f2-36dc-5952-4d6897720c7a@opensource.wdc.com>
Date:   Fri, 29 Apr 2022 06:37:18 +0900
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
 <c285f0da-ab1d-2b24-e5a4-21193ef93155@opensource.wdc.com>
 <20220428074926.GG9558@test-zns>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220428074926.GG9558@test-zns>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/28/22 16:49, Nitesh Shetty wrote:
> On Thu, Apr 28, 2022 at 07:05:32AM +0900, Damien Le Moal wrote:
>> On 4/27/22 21:49, Nitesh Shetty wrote:
>>> O Wed, Apr 27, 2022 at 11:19:48AM +0900, Damien Le Moal wrote:
>>>> On 4/26/22 19:12, Nitesh Shetty wrote:
>>>>> The patch series covers the points discussed in November 2021 virtu=
al call
>>>>> [LSF/MM/BFP TOPIC] Storage: Copy Offload[0].
>>>>> We have covered the Initial agreed requirements in this patchset.
>>>>> Patchset borrows Mikulas's token based approach for 2 bdev
>>>>> implementation.
>>>>>
>>>>> Overall series supports =E2=80=93
>>>>>
>>>>> 1. Driver
>>>>> - NVMe Copy command (single NS), including support in nvme-target (=
for
>>>>>     block and file backend)
>>>>
>>>> It would also be nice to have copy offload emulation in null_blk for=
 testing.
>>>>
>>>
>>> We can plan this in next phase of copy support, once this series sett=
les down.
>>
>> So how can people test your series ? Not a lot of drives out there wit=
h
>> copy support.
>>
>=20
> Yeah not many drives at present, Qemu can be used to test NVMe copy.

Upstream QEMU ? What is the command line options ? An example would be
nice. But I still think null_blk support would be easiest.


--=20
Damien Le Moal
Western Digital Research
