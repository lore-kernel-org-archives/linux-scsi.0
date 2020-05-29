Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8CF0C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 10:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A55CA2074D
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 10:09:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="DPkyrqJ3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgE2KJb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 06:09:31 -0400
Received: from mout.web.de ([212.227.17.11]:54043 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725681AbgE2KJ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 May 2020 06:09:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590746948;
        bh=JKeMacfXaOGqud1C1KeJRX000f1ebFNNh25h6Ivz62E=;
        h=X-UI-Sender-Class:Cc:Subject:To:From:Date;
        b=DPkyrqJ3xxROgDSc6NhOzVwMRKARyEDUMp0Pzu3zcbOqc2uBZPesgajrW1G1U8JxC
         m53eejK0PO8A/8EC1TRt0XFvYXVgpCsqIS/TR9pCr28J13tEB1dIEdV2cXGogHxpyk
         1sJv2odAaAaErbBgtHG12E37dlHQ5eH1UjXtVgHE=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.165.0]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MThAi-1jVmFA1dmi-00QSzc; Fri, 29
 May 2020 12:09:08 +0200
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Leech <cleech@redhat.com>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        Kangjie Lu <kjlu@umn.edu>, Lee Duncan <lduncan@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Fix reference count leak in
 iscsi_boot_create_kobj()
To:     Qiushi Wu <wu000273@umn.edu>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <62ff53e5-32d0-0440-045d-881350b2e6cd@web.de>
Date:   Fri, 29 May 2020 12:09:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vTRUWehU/DHrU2DUP28btpGrWnuMd4+h88H42tvoTy7k7vS2EBT
 Qv4RGT1H8WhAv09pN2Vv7dfrOyACh5W78AqXOUXvYF+xnls6zkdwTCvb+ijWQLVumrMRHQ+
 OD8BxTsNLhlNTnypHCnzdtBWZ7Qs0VdrUEjaRYeCC9y7fKtaw16x3TCANhvcWhPrc8Vv1ZW
 6pOcwkhXXRzmmHi29R1tA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:OjKtTZt2LZA=:gFbMUDbwyEXMlFgjGDyX50
 /9SxR9hYBTgcpEfSwF9eGESnzJwFBRCYRVE4XcDLoeCUo1LjXu8CSNlTfCz/tHFJiAcsZB/+u
 S6qVNYteMGN/AaZC0dDUtRHZfjB0SkwjsJf/avzg8HVOttN/WvL94rYgHshEXBFLVFCRBkQ2f
 RelljmOgqD4qO1qoz/D+o/HJRP3Hvy7Rx2z04Xh0ckIZBzNZYUHvuvI7A9O9UR0uNMdsCpDyl
 sI992X54pmIjxpN1gGQvrA/iygWWT96INjmwVTbmlcDmgkizIpTIM3KEbmJAhVF7bVC1UXXrH
 1fLd0lUPLXm9EnoqjzGoELYshy2d0GITzTHGe09nrQqHsV7gxo3sAg146JiqXRuSKSuJVbYlr
 kGy4GYqC8tc6N//cPn5q7iplpGjYgW60VCzrb/CJvLxrHmu7NWDPV2x8ep2yq9bdqhNwNbS1W
 M7BCAIWlMZVHazpInfdvmuQPiMQWw+1nfE+v+2HG7k8aAlMlKnMZop95JLn27xKvP6/An2eHr
 Pwm5Ruz6mdPaMtmrprzI3HBsbwiFGPBInOyPKl/ygB7N/YvPoDxnC+FG+lwp9mv7x2teJ+qEU
 X6xh6Kt87NzzxOWhCbZSzbylrMa1RAyAv8iFlFMgVdafAGZmtdX+SjHKOYKxeMYBztfGJQ4R+
 gpuG9qEmR9abfX0ugEKPtxOGeM7RhWm/5jODF8tPBxz53uWoTtQSEfKM7wl6QWu110rHsjNZi
 fSiARd3Fo2O0yuKjXCdgzy8UNhzlhrtKbqk9GW7/rPYkpCt9JMkzogyn4HfG3OgxasXpqzUsa
 2j64W+NcL+IWTutsu8W6YlAECtBoWW9LJbck9M9KXQSooQ/2wqGuWLcv2TjaWgkWDwinvL4bq
 g/azpLs7aj6G6KizPOHyrgVpuRia5u7+zKsKtE1Rl6/umSoLs+iN2Kjty7+uF4v9lxZWUZew9
 yHxAzm7ZqeoYH5AjBCSFpd06zTKbi4dfkrYm2+dzrTALWaiU5k8MAvCbfK53S/frIcHDgQsdk
 kxcDluJXFODjIao832mWIR8LDUoIl8Xofs8EziJHsr9UQLrrj3tNTycbl6H2ZFb6b51Z5YMQD
 ccMHwyL+lr9dIdVl+x2JIjzhHkzMH7RTy9rwIBXNBWoHr1Ovq7f+yPo+EvkSoS+WuMiQQGusL
 P5jDxghChO+E3OHRFYv58RIa3TXU/lskl/oEDEehAXHdRLj7qVKJF1/qwxr0wtFPUk0bsdwpt
 l8RCjSUveVWvi9qc1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> kobject_init_and_add() should be handled when it return an error,
> because kobject_init_and_add() takes reference even when it fails.

I find this wording approach improvable.


> Previous commit "b8eb718348b8" fixed a similar problem.

I suggest to omit this information from the commit message.


> Thus replace calling kfree() by calling kobject_put().

How do you think about a wording variant like the following?

   Thus replace a call of the function =E2=80=9Ckfree=E2=80=9D by =E2=80=
=9Ckobject_put=E2=80=9D
   because of using kernel objects in the proper way.


Please take another look also at the message field =E2=80=9CTo=E2=80=9D.
Which recipients should be specified there first?

Regards,
Markus
