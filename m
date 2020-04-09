Return-Path: <SRS0=DEWY=5Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE6CC2BB86
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Apr 2020 14:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A10920A8B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Apr 2020 14:07:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="JO4QoKUJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgDIOHP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Apr 2020 10:07:15 -0400
Received: from mout.web.de ([212.227.15.3]:34897 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbgDIOHP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Apr 2020 10:07:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1586441207;
        bh=q6JT9BUFhZEDTkjJ5O6J5v2MmnwuAEBNOmdPwgmth44=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=JO4QoKUJL1tQAShFsyB81ZnvI7u+Pl/cX8UC8f+FrPMDcZR2zH+SapWIsgIwf1Wra
         CfqQRF95AwulT/tocwQYzjFBjDTAs9TajTunYXQc4ihfc58bvpEJ8jeAI+Na/tyGOT
         gD3DI4clYya3cjjyECr+esU04ifNAtCWIpo67J58=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([93.133.77.56]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Letkl-1iwX840MpD-00qh8K; Thu, 09
 Apr 2020 16:06:47 +0200
Subject: Re: [PATCH] scsi: Remove unnecessary calls to memset after
 dma_alloc_coherent
To:     Alex Dewar <alex.dewar@gmx.co.uk>, linux-scsi@vger.kernel.org
Cc:     Allison Randal <allison@lohutok.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Julia Lawall <julia.lawall@inria.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Richard Fontana <rfontana@redhat.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Thomas Gleixner <tglx@linutronix.de>, aacraid@microsemi.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-kernel@vger.kernel.org
References: <e2401a31-e9fd-e849-e27c-6e079f5556d2@web.de>
 <20200407160213.qh64de6ebrj7qkmx@lenovo-laptop>
 <807090f6-f2ee-0e5b-6e35-b0c148c7a22f@web.de>
 <20200409114218.5muicchv37ulrjxf@medion>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <099aaf53-739c-568d-df7c-e9a2d56a07fd@web.de>
Date:   Thu, 9 Apr 2020 16:06:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200409114218.5muicchv37ulrjxf@medion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:JusyzVvIVIWSc70UAc19taj5ysYDY1sU8dM0OVZBrI4gtlxZfCn
 9vA50+xURZCL+aiQrvlqBBSICvJh8oOfL9pQ5rLlnterYcCFdh/gYOyPvocESFI7dwLrR2M
 qt7zvopWRmad98G6wDWkoGi7k1DX2R3Y1SoM0tSxyZhmtTtlUJJAuf4j6j19v3jjAZyRwXm
 Bk1B23gQcqn8i/RrI8DFg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:MuJKtknjxMQ=:csZJiCPDXi62HwHssdk5iF
 3HTHF71SG1oJ3VBOzcARhPB44oGe/OaysXvh7GtTErLNY0TXdswsYcx9eI4bJnw2MoIfobqhH
 HdBi3EtLgRyCDYhmsSAaDNksBNB3fv1iivVP9gRGgk+aaGwn+7vt1NNxKN2lUrsOwIta1g8ly
 mMySnM7HVyg/16vrWwxb5gNHdi1TpMuFGsMBrbf8HOntyh9+2TMetm32o9b2pbCkWKTmGoGg3
 GkTpPMRhPaAV14MpBPQM7PTK7NwpbWOAmYOJZ/IuwEUIK/ggfEOcM8Zi+vitrl5Qizxm3B0Mr
 9HYsDxYJX/NKnqqtHHGfMoNsMhA5pUqYysZTc4Y93Rd6Ufxpa7gMugtTT0V2oywpFgRZ+gZIb
 1i7v+XeEghbx5+GX1ti1yDWSL3mQ9bgbdOrDd8bNmha1S0Ks/NUaOZyJrHODBDsxW2y1LTtJI
 7+mBvfWZLJqlck+5BP+hTgKkuu3220ajc7JVakIkfGfouXvk9WSHHlHvImHPd4Cjn9ZIQVO7k
 ncMcEtJVPyQ+DOMUDdsFh1JyqmahUMjRyTeQlj+ICGbdEa9OXlEqCQAN08rjWuMy8j61T5QG1
 WqE7jatsJKNK0aEBPimTNQQ8Oc9dL5iZs6+RgU7YWdQ6lU5pE9rwVlw80WKhQRal4jPtnGaeT
 P47MDwObKbhi9gcuXI2KHEiJN6bgyIbDttC4v1KyJRAexctQ7yOYjmu+G+bviHG1GJ+bxPmeW
 ruUops+N9hIWG3qH3xTGkTijx0wpyGNsoBzNDzsYKMzGpAMRfkyZM/WufUp28RKBz6hKeOTb/
 x1LZIATtP+/2vafh3reicT/EC2v1vboBDcRt89inR8IeRvcN/yt3PQ2au3oqHxS6UHyeb3bXt
 896LZnvsd8c4m1Fbm5y4UdtK8vXEPC9MzPC8akdExtPb86o7ABMT9aPSFyK/uUvs7jWMw/IfL
 Tguh98eflUH3Nnv9JRi4Qe7fVfJwCtrajXJl7MyftIJVlh7+TpxfBwGIRvJ+w8aUV1HvNcg9N
 FndsYZC6pGutBHagws5/+7X2TaQA6G6AwgL3LOPJMNVC5LYz9gbE+V5jeEuc/Gu0dzNRaYxRf
 BXmF0vYOkGqC/MijpCT2qwoYZxr6MlPzOGmqflGG6qDHVMmrR1mar4MVGbnkjVCwRotY5TtaC
 2uJGhfmlBrzFuYwHxSbU03FcpVZg6gLYKITXz2+1Ro3w5WfbMcG3/fHZ/7W/DAHTn2RU/zM0r
 mG+nUSNVuPhaJ1jgb
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>> * Would you like to extend your skills in corresponding areas anyhow?
>
> Sure, I'd love to. Are there any resources you'd recommend?

How helpful do you find the available software documentation
(and other communication interfaces)?

Regards,
Markus
