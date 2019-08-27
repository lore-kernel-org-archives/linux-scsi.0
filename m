Return-Path: <SRS0=cdy6=WX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFAA7C3A5A6
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 05:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D62C2184D
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 05:34:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="YFnlFasJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfH0FeO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 01:34:14 -0400
Received: from mout.web.de ([212.227.17.11]:32817 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbfH0FeN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Aug 2019 01:34:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1566884008;
        bh=/nekiW6MnMYef0+et4HGmSzRulN/vr7UdPk6serwXNc=;
        h=X-UI-Sender-Class:To:Cc:References:Subject:From:Date:In-Reply-To;
        b=YFnlFasJzS+yzTUp9zyRo1GlLKp2UYVwdNER9oxS66gOtG7tSdraR/XCO8sBbG+3h
         j48JIkOioDmGQdmH/bM/Pwh74CGOMNSmTZ2X8qOFjXbcrQMtMFt2hjCD0QgCgwjtvj
         d2Fvx7JML3VVQvvigdeuPQl/VkBjw+JnJogbv9KE=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.143.232]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0Lpw2l-1ifh551XwF-00fmGk; Tue, 27
 Aug 2019 07:33:28 +0200
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, Chris Leech <cleech@redhat.com>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org
References: <20190729091339.30815-1-baijiaju1990@gmail.com>
Subject: Re: libiscsi: Fix possible null-pointer dereferences in
 iscsi_conn_get_addr_param()
From:   Markus Elfring <Markus.Elfring@web.de>
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <b1e07f98-f376-9617-a491-b916152251cf@web.de>
Date:   Tue, 27 Aug 2019 07:33:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729091339.30815-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:tl0+mgXQOGwRsIeFa+UbFRkl1Jmz+YOpWrzInliNBHhviGs569z
 A2/JJYk0VGswZy4Lg7pkeCYhARU+tFRsq5XZvDzoaoMFkY6OoZOis0s+ajaa2858NhJ1jbO
 XwFJ0DpAfETdl3Qg6lRG2rQzBOhiooj66YHVmdREFgUtae2v64bIEfWp9bGjrCui1plfO6S
 t0MmJBsiR2we0wFtiBlEQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:rlIg6ZFyLio=:Gld43aEV9E20oKBbGnYWPJ
 xZmf1HtIXTS7lZ+08V7pPLmJUAVRFWLRRtPJ+XUqFgzMI8r1ftGsjgoHs4QQvi8eEiNIkI6hv
 vl8LYCtrdXiGfkTgjpB8HL13TvxCpIkUH0elP3BV0CPhdNfcpoYFNzPAAn4u7pk0xK3LXAEUq
 igqxFABC8HwOyb6t0/RjCGKZtafrbbpdZQk3ILF+u1euIVIcQH4b+QGxyeZEcdNAPO4+jaoC4
 L8mODAbnI/zgUKY80SW3W/JwTpv7O0r8fe7O5cpE7bVA7oVjAXUHTGk/7GD9N5XcbkrbEh9SB
 4Xb8G68PqzNid9Y7c9L29uOvHuHiNHzT1e6FhFJ1QJWsHTuS2T1QXC32OMC+UhOLJ5tamHYps
 JbxJDwclUT1y9yr6uE/XABpf4uB/9oqZH790i2YVxaqHwNi465ePSoEIWTNM/N/pI0dE0g9sv
 GvD+rgObUw0OkuAgWW8I3BkkUXpMpU59o1Z6D4SLqfUQezvOZBNbqMl0tM5AT6mjYe3erMua+
 D2faKPx3iITEF7woMUQZcJCQbi/xS8aZrqycZ3MrZBQAHHoYdd/OQS+9pAPTZJvTziWRGE8dV
 vZO19sHobkulyMPJ4hZUelOTQw2i0w+1k9FmID9CIP+rN2wFf4ZzgpHwHr2B7oED8oJHAEtLR
 rY6dV53Plo7DG9PtBor9wKHlOqSV5xtsXeYYVaN2iOkm+I47xMWbnbFgBbm2LkDdS4iOXqq91
 T/psggX2+LtGwxg6ZoJhaSrEe5tAoZE8cXRs+dEpCQJjN+dxW27Qb398urZmXuszvdvW0kmeq
 HPokkRZfVRkSJtVnnJaotA+K0Dhb97aKvem7KnxgVZASbRovzGit8S1sHPNNZKcVDoKP4zYRx
 CMYxdfGvLdXipR94ja56kbCto3HA9WYEQlpbKHBiJsYeQezTJztZebm40q54SIhuYjXOuIul5
 +ZZnzTGBHg01B35Tsut5rqhC+ntveu+MfvrZGeL3D895ChuIsnwQk2h2371oXqf5Hdl88uZoj
 2pGhRx1TrAcKmBb89XTwc8zmm/qaeVbH3AZBgFl2750mClmsrWxVkAMZ3a2YtUT3uVU/CkCY2
 7773DHZMUaR25U3iytwrAsz6Pt47Aj0UASSUFqCMB93Ey4IAKarFHPT8RJFqkts0YpFFty/YN
 gOzcmUc3O98HNu4TrGyuQNa2y+THQD44zvbJ0A7um01yd9/w==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> These bugs are found by a static analysis tool STCheck written by us.

Would you like to improve any more commit descriptions also by
adjusting such a wording?

Regards,
Markus
