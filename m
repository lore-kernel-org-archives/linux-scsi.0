Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3336EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 07:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240900AbiDGHXM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 03:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241822AbiDGHWj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 03:22:39 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFB4DF39
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 00:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649316040; x=1680852040;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=NsgAzcmXaMEf1Yp7W0xayn+Bwj3dPHXVAY2n+CoJd6o=;
  b=mFh0oblgD9i6pYh04FrdX7hR3LNkKmFH3HNzpqDs0+TIqxWjhyiNQ8af
   /K3xOdKMtHLDJoI8mHV23YoiknqTlr8dH3b0YwYUqwN6+WQct1K3ndD+F
   HzvQoe7Dn9/D//IPh8nLicUucQlvn/bN4VWDHBkNu3qdi+5+jGGzuyFBw
   0jLTr7UiSMWcq8C82q+S+6SCcV5Y0tF4/1RTTZNGArJ7QM7KWo4jPiE2j
   INkRLwYlQJmS3/C/vpewcRQWn4xHs97HSgDWMeDo4LgJ6FpLdCThoPomw
   EJ7qCr9x7zWagsKIW6amo2f4cjKojFTmtX3mF1DT0o6jZW/CefyvbURw8
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,241,1643644800"; 
   d="scan'208";a="309283910"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Apr 2022 15:20:40 +0800
IronPort-SDR: AnxTMuEWsuEOsI2uh1DNff62dM1hj6q8KNF32mQGvhzbAVKhataIFGmXa88R+7JdEKA2clKA4z
 DQgNYmtmU62Vj4QndybwwEhvZyVidfCGyqpk9Jj4YIyHYxmRp2P9gTdD1UByCuxSrB2qWHTtHM
 IQEWrlqNQrVIIP7xLzGGV9AaGR77D7J+ieyhV9TtfEqHkbXhNTmtPXsRrgzuoUCZj1+lINCjb3
 HdZEdAFPjIW0n0sAgM5FxowZWzYFxJdYKW8FziA1tuBlv9uLKnpYy1DhohfaNB54wvBsvaw7TE
 OJCANJ1JoeA8uFJ8N9nRwCt9
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Apr 2022 23:52:10 -0700
IronPort-SDR: DEfQKxQcJxiDQFbePeMvknqa+ReqPK+XS5D2tL04j+hBbgCzfwCHn2HHuwFuGxZzFXsWjaffF7
 5raeyS2tcZ208X3QybzyIM8Ukk7YD8LYCGbH3gC8Wnpb5u5uAqpp87HmOghznESR0d4yj/Ivhp
 45LZX27x+wkPEkKAjmk1RCXSz6DF5f1Pu8HPV8rZ7TpZonhsz3AFPysJa3G1vYU9IC4TXwvufU
 KPUYak1EhaeiMXlIG64CzdC7BkpTRMgQXGBflvuyAzdMzxSkv4vh+YqjLgJVmvm6w3bRLNYXJu
 U3M=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Apr 2022 00:20:40 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KYt882JVmz1SHwl
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 00:20:40 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1649316039; x=1651908040; bh=NsgAzcmXaMEf1Yp7W0xayn+Bwj3dPHXVAY2
        n+CoJd6o=; b=bXArdDVTTY4PoyriZvvM1XxJvTMbE5yzfb/h83OTQrvVIQPRNBU
        lI3CSNjLiYUnJmPEqTUB2jU00ADrD05Gh7exLRApc6JPMVJK6KhWtvGQVlgBCAmy
        00lQCEn6V95E0Cf5dyi2HTUAllgAArG+uD5kmmgBMrt0F6PbspWLAtStcUtNhFw0
        DYPStF9jXTEy06EfGZPcyZz8w5Ytm09HkC4R0SB8wSHZcGz3NJhG5tBUMRI6v6s6
        4BrZZrATmgGzfMAhdZYb4o/TgJm8a742oDvnmO+3d8yiyC3c+ce9ip9CJOONKQec
        nz/pgSzbvCfP/OkRiSI+Dns0hPTg8YosQ9g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id xEgwu-a_hP77 for <linux-scsi@vger.kernel.org>;
        Thu,  7 Apr 2022 00:20:39 -0700 (PDT)
Received: from [10.225.163.4] (css-nuc-sbp2.ad.shared [10.225.163.4])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KYt872686z1Rvlx;
        Thu,  7 Apr 2022 00:20:39 -0700 (PDT)
Message-ID: <c0b4233b-6444-be93-ac17-51163c3e3de9@opensource.wdc.com>
Date:   Thu, 7 Apr 2022 16:20:37 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [Bug 215788] arcmsr driver on kernel 5.16 and up fails to
 initialize ARC-1280ML RAID controller
Content-Language: en-US
To:     bugzilla-daemon@kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <bug-215788-11613@https.bugzilla.kernel.org/>
 <bug-215788-11613-hW858ssuEw@https.bugzilla.kernel.org/>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <bug-215788-11613-hW858ssuEw@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

+Martin

On 4/7/22 16:10, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215788
>=20
> --- Comment #12 from Jernej Simon=C4=8Di=C4=8D (jernej-bugzilla.kernel@=
ena.si) ---
> Re firmware: both controllers are EOL by manufacturer and are running t=
he last
> released firmware (1.49 for ARC-1280ML, 1.51 for ARC-1212).
>=20
> 5.18/discovery seems to work fine (I can see the volume and partitions =
on it).

Martin,

Your series is the solution :)
I have not looked at it yet. I wonder what change you have that solves th=
e
issue ? We should have that subset backported to stable if possible.



--=20
Damien Le Moal
Western Digital Research
