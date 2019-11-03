Return-Path: <SRS0=nNaJ=Y3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54270CA9EB0
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Nov 2019 16:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 206502080F
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Nov 2019 16:06:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="qjM5p57w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbfKCQGN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Nov 2019 11:06:13 -0500
Received: from mout.web.de ([212.227.17.11]:34129 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727523AbfKCQGM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 3 Nov 2019 11:06:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1572797155;
        bh=GSIEPbeviwDPyqWBwBBoeofIwNE7sbotxn3Ui+wd03E=;
        h=X-UI-Sender-Class:To:Cc:References:Subject:From:Date:In-Reply-To;
        b=qjM5p57w1RSlzzLKr4miqUV5mG8GAgV7vgqxXq6j1C+5JVA+SKGgkrTLI3NansRZo
         6IbmcA0K2CEfsHH0SUKpCHk1KZ77yCXPgekCKo4MJZLlARhgNbdVkmit5nfYKB4aIp
         5QHCzBZw2NWwMxOuxafypCNUmjD/X1x5jUVJTB9U=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.243.72.216]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M4ZTk-1i1lj5063A-00yhUA; Sun, 03
 Nov 2019 17:05:55 +0100
To:     Thomas Meyer <thomas@m3y3r.de>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vasyl Gomonovych <gomonovych@gmail.com>
References: <1559161113902-328168114-2-diffsplit-thomas@m3y3r.de>
Subject: Re: scsi: pmcraid: Use *_pool_zalloc rather than *_pool_alloc
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <07841ae4-03d2-1fdd-1c32-85c55688bb2a@web.de>
Date:   Sun, 3 Nov 2019 17:05:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <1559161113902-328168114-2-diffsplit-thomas@m3y3r.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:bu2cBKjnoeapiP8pw2tOQ7AuHiajnv9SZb/fEb9zSDFMcDziLwz
 6nY2W0YwIPbiAtVf4E1MsIxJ/Kj++UGTzyY7TsuS5w1d8X5S0JPBf9K3LQI+5n583bPinQw
 OW+F1Qs1OdG3PpF2kJYW81CTaodp5WTNGSNnCLjLcOndW0kv9i0sdkVMVDekdUD4KGwgPGv
 jakfL5MlM9RF6OvgnVyJw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:c2Ux9lCyc20=:NX5HGu2XeB0/6lWgdM7Da6
 ElWM0iznT3xTbBgAtxJygbUMTihf54wF62pgqiztZeaAJuZPZi0r0HL57NbwTBluB5re6qZnX
 sGBpSwYjSbehLFOaBuiv4VUNXut2Z1Yf3wBe4wklFFqK/fjzJI3zud962AQ6iWVI3/lNqdETX
 NxEjUOwoC8zxCJk2w4Zbh6Yn6cBDwNGAV70gmTikJWt2FmgqG+EUWPGM9nFsw+o0siLtihR54
 UQsy/QcegNjXEl2cRih9vxcHqPxPA5KsH+5acA2ZJw8FX/IF56gMN1NmQh4YNFgG/184VxVkq
 R8NjL3KoA7mx+lCXZG0yPXiih4kl5W/DY27V4iDf1jVG+F+YoulXwG4Y5Cu/CQQuNUn9D24Nx
 4RPikHfI4JbOQ/G1QsQWbRGRE4pSB+CuQfQbqYNj+yx05hXBQbyBAToUZCtBIfeEcP4qT9iSD
 FQnoESwbcwFy54G7V81tLigjhkxe8wMvz+1nDKWktfHEIAefPU4xidnLC9iOLmu0fbNMzoTba
 +3OpbN/Km6ZS59ThO5mV9ssSQdxpoEl8aZg6l9E84/Kzr5cCAsDMwUh1EcJ6UIUOkhCtTdCzE
 zxaOd0z/dYoWS0NmpUufAaqf6S4awbFG334g2BpPlN107HBD/ZQqO7MHs+rVndqllP0y/omhR
 BDSa/WyB+lA2rIPs9jAgpW4PvbyLYeEJFYRHsYq/1rb348LhTCyp+5f/T9Bd5Leb7jLHc+t9s
 6gM5uYcV84r44dpu/hBc+ZJo2Uaqw5/k730NwK0u31Na9vE+IjI3Ag2NkZ6jDygLKSGUjXJcg
 ZjfF2BcLCgOBxG/qevVQiYlZ0fiezWIpTJHpppcYhNxCOV+WooB/uEflnoHCr+B4sLrvkRMsS
 gRDazvCvY7ojCd0r+XaexA483pjGfz9h5DW1YQFfHvYR6bXAnwuT6yaWjyxfE66kWUrFAYAIH
 2WLeBusM5PPXa+Mp0XIw5wc6A+B25ssu78swMGbmSAoSOf+7iorNA8xNUWdtA40zs26Ei5pt7
 71Zr6yQG48w6O/405Jk35I925iwL+q9GPNvGUJRA8VvNZrDrLDDmFqE7ro30F8epNEtrUQQfz
 wVO3fnLHo9HQ5JQz6DczsnS0llzIUmAJdIc2CT2dtjyD17rWfxGrSrUfY17fAjWV3qk8vEVP1
 JNSr9tCQSUOBQnXuHsDxkqoenFHpLX25J0Dz+CS9Wx2tFMjqLZbfW5gfmm5QXDmFOfyvpORI4
 nHOHFx2tBTa2s69aNFG88DeW015yzTO1IRvbMI2Z8qt3i+N/aMqyIQtWOAug=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Use *_pool_zalloc rather than *_pool_alloc followed by memset with 0.

Do you find a commit message nicer from a similar change suggestion?
scsi: pmcraid: Use dma_pool_zalloc rather than dma_pool_alloc
https://lore.kernel.org/linux-scsi/20190718181051.22882-1-gomonovych@gmail.com/
https://lore.kernel.org/patchwork/patch/1102040/

Regards,
Markus
