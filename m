Return-Path: <SRS0=3U4t=5V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C58EC2BA15
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 20:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D253520672
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 20:03:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="pO82ceHw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgDEUDG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Apr 2020 16:03:06 -0400
Received: from mout.web.de ([212.227.17.12]:34193 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726678AbgDEUDG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 5 Apr 2020 16:03:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1586116969;
        bh=VWzXLGBpcSdiL4HKp7NcBVrkYnDV3TAHKsakI0KFRsY=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=pO82ceHwmns+8ZLFgFRhkccyBV8pm0wrJtXl7PAkRUndHrv4LiHujTZ1ZSfp2dQrf
         1Xyl98mWsFPhlIVumZT2ArMAH25lTz4rnKlhk1El6rVNFHQmSeN/xBAXbZDyG8ewr5
         J2mRhxLCZ6TCvb7CLSjxp5bWfbjrtxXOiIHxJlTA=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([93.131.99.70]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LgpVS-1izpQE38i6-00oBjY; Sun, 05
 Apr 2020 22:02:48 +0200
To:     Qiujun Huang <hqjagain@gmail.com>, linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Alex Dewar <alex.dewar@gmx.co.uk>,
        Hannes Reinecke <hare@suse.com>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aic7xxx: Remove null pointer checks before kfree()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <72bc89d5-cf50-3f3a-41e0-b46b134e754d@web.de>
Date:   Sun, 5 Apr 2020 22:02:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:u+p9BHXLJrqPUXSmF3wCMpNfap19OxXKEGKXCn1Ug0HtQl22rQ3
 rZKnbcoWjO4hlzq+9buuJGUPMK122aszjMwXBE27pKgzApxMGXD6d+f6Mc+elK4KifwkR2J
 2BIeKKa3G7dW6CyXDg2sFdCvggzKol+lphVrKzJiQx9Me/Qip3Vck6bXXtSjkSyaV3KlWfn
 eYqgHWdRW3BZBa4lfp5IQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:hJymaNxIJMk=:JqUf+T0sd8BDL6HoL4lI90
 TmWVOyZhBe4xSG5N6SrtwcStaIGkSk16KdC24b4CEZ295d+ZxGn/LOWX2LjrQnJt+ZxgN0xn5
 4IwBbgkD18GC+8PMdvI2g90X56QDQ0+kYY7CtdPxIeIJ+nFx4+VDO3filf3SSPLj0OhCpVY0E
 4ZJYcCuxcgN11tNyHh8ByWsYEhvTMqhtjXbBjjwwIhTeq0QqDF5SShSJ1DOspbkv7rZpGe6bu
 jguTongcVi04TaOM7EapsHkvZxTKpTU9sUs1wBbMvf5tqAVxtVbkOIel+xXywYpbUZ52jljvp
 L+SUZ3RuY1mMWIBzsenYpDgE/UF7hM+90tQm5Ry49TkOFfR5+PN8d6vPrekXlZQRKaq0MA+K0
 Mm9zgHQ552JLyCDJ6ST+wIgbioE9SS01KqpHYD/BEAUspZxUai3+pR3Yc4pPkQaICnBjzVm+7
 SmynTeNKRhEQMMnfs3qOfaQaGvZy0q4Mqk3I8UTqj5Sfu6WtZISbPz5s7l+IPxCWa5ZsL6gMd
 e/1oPImcH3oic3jmZonofPzc02oQKrnJsTuitM4OD1oeYgeJND8Ky6sFL4OwMs6rsqzzaBc4w
 QQzMYqYU1GYf7f2omfnLsok/JNOhhlMRk5BNXMlLpm2V6fuzZkNQfKRQ+VPAShfJyQ57cWPRx
 S1l7uGRUuzxs+S4zQVmamyQerZBlS4smSW3CGe28I7H2d+BFfFrUbBw4x7Rx8eKr2p7Am+e+B
 IDdSnlFTxXpoORYIl8ZPcFHafrLopW01PC74RutsqFZJ71R4UnE8qo7A+BPHvr0MtqGh5NftV
 hVvoBQsu4nQKXV7mTqaR3S4WDa8zB3uTxL1vUn/2Hgr2+0vggyI9sM1w69YgxbZ0EO7pdCKMQ
 L1O8qQoQ/EzBVs9ZURBG1erOuYnq73lFXhFKXCd2sYScWNpd3qQvcnizIDZmg/ahJLepqS/Fa
 fpsmdRk+JTVgUSrIBoT+QYN5sbFFMbaaH4WVAQxSfIKF9hRHQUURcwh5SP/JD6SkpCw5aOgCB
 H7I8crQCXqEYJpjmKxVCi4eerNrHvwJ1z0Mtm8VADEtE7O1o5DvOAoDd5xXDYLSj4ZKzUEddg
 YthHDgT0dfE02lNmBuNRirNUgdjJ4FnVAZheJwwS5/kljtswEKzDjxKT35JlSIewjZsMSxyxH
 ToTXrRNF6cgVWTz5Qx7gAV8p+O/k0Lsc0DITnayj2pxdlZHy5+opvT0di3gtWwyGpGR6sG1T7
 O9M0291mKShH/n7Wa
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> NULL check before kfree is unnecessary so remove it.

I hope that you would like to take another update suggestion into account
(besides a typo correction for your commit message).
https://lore.kernel.org/patchwork/patch/1220189/
https://lore.kernel.org/linux-scsi/20200403164712.49579-1-alex.dewar@gmx.c=
o.uk/

Do you find a previous update suggestion like =E2=80=9CSCSI-aic7...: Delet=
e unnecessary
checks before the function call "kfree"=E2=80=9D also interesting?
https://lore.kernel.org/linux-scsi/54D3E057.9030600@users.sourceforge.net/
https://lore.kernel.org/patchwork/patch/540593/
https://lkml.org/lkml/2015/2/5/650

Regards,
Markus
