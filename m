Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F89C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 12:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384944AbiEBMSK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 08:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384946AbiEBMSI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 08:18:08 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6388011A22
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 05:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651493679; x=1683029679;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=upcjxMBu+P7WwqT0zp8eXVNlC+8I1RqcfjsnBpDAUsk=;
  b=IUJQNPQVAwgIXqK2p+ed2gTX7OCkjIofKQerMgI5tJ45EH41BMnfMCFS
   CKGVKtwIORxtL9o7Tps9mrZUGG5jAfBQNu7k0T7PabojStIrDb9WFz2be
   XbxhL8RqrNVD6w4APXVlenNF/46/XsaJnKl+MdlMYoVX6sRhKGZN9YfU7
   oc8iBVfR3qXlvfcwYTDLwx12BAEC1GoNQbj3H88VJ+hp7wHQmIFt4UMDZ
   xW54EITPC76oP3vCDEOu5FFiI9Oh7O+aUfOGRJXAjj4oqBNA/fIaEkEtA
   EceVjusSdf3cgKKd9ml8H/XFycAt6PTDpcBk7Cn68bHxI9x7itSBFDEU0
   g==;
X-IronPort-AV: E=Sophos;i="5.91,190,1647273600"; 
   d="scan'208";a="303545445"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 May 2022 20:14:36 +0800
IronPort-SDR: /tQI5pXmmD3iQZRK8LR21gg7RhrCj2WRuwajjGDSrRe81RUg6jQTC7RpbyPfen/qM/HoLVwLA4
 p9e/8x1bRI6kHd7G8dBkNtnbWIq9BU/4aLpZDz5vP4YQxmoPGiq7rOIFlGHVOQoBywCIJB1xDs
 fQjZb/84tMKVLKCpdL+uwNMnykS4H/zIn76UCKIqqkmXaHBjfgTCXnj4qUXjIgBDDHn40mn6Ue
 Fnyex+jy2Jlabi5xSUMRuQie6iyJMBs3pENiv9aOe4nVis2s9d7EaR9z0FsPKr08jio59iPW6I
 1i5gcLFazbzobbMj5bZIe63Q
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 May 2022 04:44:41 -0700
IronPort-SDR: ShZmq1YnBuwC6gLsQoytq6NURHzVAi0L08ZqdHt/jzb+iHvUnzoQ2tZq8WLRDcVEje+CMpEZQO
 /YXKt5lBEOWb1flkxxIxCQwJLPl/2tYodS1yN52C1GY9u2bmGPkVWGwPoV+SyMGSYnwcXUMJ2y
 6MJyeNug18fHVKt+5OjcyEMBcsvPXVOua+CmQR0/LcF6keVefz1vHxVMSp/cy1DE2SlXW2SOJD
 dmNYyLhuXJiSz2qRMSfrqLKFNTUjP8CadA/21rsTtHHkoBUTQXmhmqVbD0uLNGba9B2KxEhlRw
 1Ks=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 May 2022 05:14:38 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KsMTm5yG0z1SVp0
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 05:14:36 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1651493676; x=1654085677; bh=upcjxMBu+P7WwqT0zp8eXVNlC+8I1Rqcfjs
        nBpDAUsk=; b=ciG1pDAWwoPGHqJ1HX4eF9v2xlPWggbWDb1uKGSNO/jkj8TEDpa
        ILi9HAbkAFNq5EiDhdSuVQosgo82rHtnp1u+5RraiVW1JKJnulP6lgEwewflYcZn
        SLU2nqSrCmvaBlOlhq/SwUz0aYIxD59HoZfzPFAJDB0k2U9prTJ30nuAfheIJUi6
        cxSGNnQB+pIT+qHg0gj218RXQsNIz7HUN6KLbDp7SK40cYGKfLGC+QPoZ1ef02fi
        CGm1HBmySTkuifTYQNn+nm3D/0IlH3vsNc4RSAOlTiP0Ce5dxFXvF9P5lhzKnytM
        U2jRb8KhbGXd9hS/QVpsB1BuBNTzztKOoGA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 84KLSzAULOy9 for <linux-scsi@vger.kernel.org>;
        Mon,  2 May 2022 05:14:36 -0700 (PDT)
Received: from [10.225.81.200] (hq6rw33.ad.shared [10.225.81.200])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KsMTl4knDz1Rvlc;
        Mon,  2 May 2022 05:14:35 -0700 (PDT)
Message-ID: <260b95e8-74bf-9460-cf0d-7e3df1b1a3c7@opensource.wdc.com>
Date:   Mon, 2 May 2022 21:14:34 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [dm-devel] [PATCH v4 00/10] Add Copy offload support
Content-Language: en-US
To:     Nitesh Shetty <nj.shetty@samsung.com>
Cc:     linux-scsi@vger.kernel.org, nitheshshetty@gmail.com,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org
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

On 2022/04/27 21:49, Nitesh Shetty wrote:
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

Why ? How do you expect people to test simply without null_blk ? Sutre, y=
ou said
QEMU can be used. But if copy offload is not upstream for QEMU either, th=
ere is
no easy way to test.

Adding that support to null_blk would not be hard at all.



--=20
Damien Le Moal
Western Digital Research
