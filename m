Return-Path: <SRS0=qNH0=5X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B612C2BA1A
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 16:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 022632072A
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 16:32:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="cdKRRIah"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgDGQci (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Apr 2020 12:32:38 -0400
Received: from mout.web.de ([212.227.17.11]:46547 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbgDGQci (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Apr 2020 12:32:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1586277140;
        bh=1QXk0kglKncjSEgu6UTFVCnPyetO/PRHvyiAud9o2KI=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=cdKRRIahL+10a6qpIINxGKk/dXBUycNxEpjbtVQYD86A0LMmYgesF6X4dIEL3ArLF
         QoAduXR8QHSfxctU9tj25EYBW068MCvvZS4FkM/cQHZrrZOf94mZIgHkasFdDwzJzN
         PLJUup2ueZLhWcC0oH31HF1BIXVpU30lShFPLf6c=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([78.49.5.104]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M8iH2-1jRJjk2NSO-00CBs1; Tue, 07
 Apr 2020 18:32:20 +0200
Subject: Re: scsi: aic7xxx: Remove null pointer checks before kfree()
To:     Alex Dewar <alex.dewar@gmx.co.uk>, linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Qiujun Huang <hqjagain@gmail.com>
References: <72bc89d5-cf50-3f3a-41e0-b46b134e754d@web.de>
 <20200407155453.sosj4brsw6r7fnot@lenovo-laptop>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <99c64c9f-0a9f-aafb-2e32-da7e026f9940@web.de>
Date:   Tue, 7 Apr 2020 18:32:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200407155453.sosj4brsw6r7fnot@lenovo-laptop>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:D7UzCIEZpu3yjkzGyVUqKA3cFSssRuF/qJNq5UnvEb5jlYmVHIp
 LpjY6x8ohyThGCVB9SLJWCdgx5sDWKvu3SxhWPtkuzLzYMx0tkXq6N3eQzZK6wwpBWsPtyH
 PZ1owk6N5h7kHkZ8gCSuEDpqQO4DeZQic0ZmXcKQ6w8EdG0b2TazLU4RN9fYTAgaOGwrVAn
 /TqWrD3QMYw5Dfc3lgg3g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:LeeTaExtV6Q=:wkvrnyZwoOjs8yBaMCHWCK
 S0Lw9wk4IB2oa0Yj3DD7h65DKACBlhkXBYKkQymnMZpvkXPJa2i+fIOzLRjXR4kiFq2hHm+ib
 pt58NYoLlAGqVk93HvvULR1JYui30e8wjjYJijF/lO8o/MxQ1roanSOfmY2IkMcqMljxDF0ms
 8nUdmnqB5/KYsC7aRzhWY5r7LI+9qbUIePQRpXbxsKkc3oSKB9xCVOXB9qooPq1AGXw6HBUSG
 NWmhXUSw7tvY6yspAPrp7/tT+U1YZfBfqnVPIbJ78wwwMqYlfBnJfdWPmMD9gca485rM0tAYB
 RI/YbUdaA/yoW5zlSBsmoBtwxu01tmny9R4LDG6z7VOPXEHZ7HZM1S0zQ1tUXX4zs8lfqU54+
 VYbtHapHXj3GcrEXs30PON4AI/yhxZdAxWysDXIrcFgyFmvMhG+AK55uSFVSfyiGLB1HmSjgA
 B8hEj1/lViiwEvyVm5xc7lohbLJHOKP5BrJunujIVqU4nPwDlCZ5Z46gTjhTwsGPB+qCVOGg3
 lIzqnywTxVFlSj0A9zAdaj+BNuQUnHE6nKpyWu4qFUp+kIMypo/wfLvCkiHG3UCnKZmaFg5S+
 SiehPuDS6KH5nFB37jsILOqZqNTqYK36QYoj5ikKWUI9e3lJ5SmOnBAVRyPFfQkrkiKo6omv3
 1mqtcvXXq6HcgG/tj2o88Sjn7v8cfsJM8ZHXQL2M/KAy2WS5nHOsp/9UUGdjCjDRvS0yQ5rEY
 hasROWS2QOkVOdlki8/N9iMGNd+Djp+3IDOBJlt7oV3tcomVZ1zhYsLO1mWcYUVdxDaZB3yvt
 Pl+nUemZj3fwvhy1CYfZ6kW+oKLrj1/kFQRnRgM+vLs8YA91WbqxGL39Gtix2ea104cEwjhgG
 L2Lh9gqXI4zQ2Zpjt1asQz4/4liZ3EnKwmLP0zVKE4g1pShXzUhEmSkFEmBeT0+S2jPjD2h+5
 W+0+VplAAwoYKf066D4yuaWp5/lo0yEVnLy2jHb1b00kadwCcxg+jWpbxJAyzVxaj+DI6rCb+
 k4hFYJcN/1zhpVfTYdsgWcxoqlhP4yT/VjHUo1T4a+mcKvCTUq6WTAdWOwd2oPpVSA5LzIbu6
 XPPyiCAGwNyCuDfWgULycAWNw4NspuDTaSLtu9UzOjBnwKyVTcS7wshDklt+oI6ljn7FGzf6I
 7GmxBKzTEEz0KrczGxdEqqU2fC/h5QCrrxeRTwS2p9lZx3QFOyo/d9CSrwExQtEnZxzOU5iks
 Vt0uxQtKNTNHg1IlY
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>> I hope that you would like to take another update suggestion into accou=
nt
>> (besides a typo correction for your commit message).
>> https://lore.kernel.org/patchwork/patch/1220189/
>> https://lore.kernel.org/linux-scsi/20200403164712.49579-1-alex.dewar@gm=
x.co.uk/
>
> I'm not sure I understand the relevance.

I pointed your patch out for another contributor.


> Are you saying I should reference this other patch?

I suggest to take another look at the development history for presented
patches according to a known source code search pattern.


> Thanks for the reference. I'll mention it in the commit if I do a v2.

I am curious under which circumstances the affected source files
will actually be improved in ways which were suggested a few times.

Regards,
Markus
