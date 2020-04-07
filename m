Return-Path: <SRS0=qNH0=5X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A46AFC2BA1A
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 16:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B17C20730
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 16:57:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="RzD4waIt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgDGQ5E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Apr 2020 12:57:04 -0400
Received: from mout.web.de ([212.227.17.12]:36377 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbgDGQ5D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Apr 2020 12:57:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1586278590;
        bh=VYjOv751hGIO6e6H/n6kePCjB92E1MhJ+L5qHzX+zDE=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=RzD4waItOMY8lSgIUk0z6+zbjsSFeoo7US2rQqfBf7A6ai9rWB8qev86ySIDyvq3L
         qaKGTxojGuBiocXZSArJMZ94pvlUlPOB5GrxSaiit6+SzfXJ7pIIpz6cCRo/4JMfqH
         IADodRq8KSlE97/hD+75Icf9gE2p+c4UlcnbtTBc=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([78.49.5.104]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MOzsZ-1jPyeX2T71-006Mj7; Tue, 07
 Apr 2020 18:56:30 +0200
Subject: Re: [PATCH] scsi: Remove unnecessary calls to memset after
 dma_alloc_coherent
To:     Alex Dewar <alex.dewar@gmx.co.uk>
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
        Thomas Gleixner <tglx@linutronix.de>,
        linux-scsi@vger.kernel.org, aacraid@microsemi.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-kernel@vger.kernel.org
References: <e2401a31-e9fd-e849-e27c-6e079f5556d2@web.de>
 <20200407160213.qh64de6ebrj7qkmx@lenovo-laptop>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <807090f6-f2ee-0e5b-6e35-b0c148c7a22f@web.de>
Date:   Tue, 7 Apr 2020 18:56:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200407160213.qh64de6ebrj7qkmx@lenovo-laptop>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:xxr66DgWr9Hg+3ovkVmwDGvM8UNKsWnP0Z+iO1MYs+PzBAu+yQ2
 wsbpITBnAILzGzz1Pt4x7p48ohW6Ifp/9PKZhANqRNS25KePYJZqYAivm6h5kfHHIYxwpGX
 Ir5eJMGI9ri9XPfOeOcW6mhxSmw8xFzpSQeeJYAP14NCEuNWBkC/TO2ZKjWZ9lk61c9gxnz
 lD7hyaQFFzryBMdJP38ng==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8K5Lsa2On1M=:bZI8QkuaaXEYH8gc8RSd4Z
 L4df/ORXTpaTqMfPaIUJSouqwjOi7HbaT9LWdU44w1SJn8XqAonSpiFewqlY7mW5m+btz6l6b
 WSeE0GUPS24kAv93557YsDNxwA8d460Foog9HAcGWzs1Nenc3DQmern2Lb+aAAHdM5/QxuNcr
 ZZ+oHp618ANYJEofirk+u7mEG2o6+TcBAfH/5qpskK5YgSKwvXS4lEa8hDvEW7EQIgQ0APRzP
 8WlQ3oYsWk+ytozMv0hF24FnxPDwOTgxHCu+PMeITq0xyMulSxGoq4nSQ6ZpMYULnH6zhrU0v
 Nj5qeLpz4J4jJ/DTVc7lHZKcL9UYSucjs5bNbl8e+qtFGxUVGLT5q3GNvLy2P+VHcnc2K7e9i
 Oi3A7u0v1R6CelJ16OL9k2blm9ezVi3AUSMj709et3u+pPxEYI4KObtYTyl/ODlNOXOR3g8QT
 S1mghFPwlxENaHVlaYAE/+LfvlptVGGvrobGZwjBOBLNGUX4E7oyAABI5uobpGrqIvcVzVV3o
 8lnmAUxpnH3tTD0luVtHFtczZ/Y4kdQti1UxcJp1/KAapE+5MFoZs/WFqYGzB8aP6HBYtzLXn
 /nO1xAA5Tzf16CngBpKQ7GiuuOIvJrtyn+xnzHPn90VJD3SL5QcGNJ2C1qJCUBhk4WWXzD8+1
 FBQ9/T4PFQxIeCVI6899RgHcvZPI0H0VVt3J+j1IjNUVSdz5lak0VoP5mgIUzYMiKn9knGD++
 AYuWneJd3oUrejK0XuKS1memjXFYNsR4YfVm0IQtSWzqmFRBZQYKzbMniAp84UzwZzD7Ots1i
 YMfLS3sCINIPtBeawdcvJlnokBHDpCF34pqHtoG5gaRDWx8FkNajmxXK8HyIiuPBQZHdt4E3M
 rHhECF0nJ22Ylh0WtCGvR9El7E7t92HGHP2cXy4DXU02cD9t9KxGTZ8IhKnd2cG3a2Od7KDV7
 xdSynT448JDfarZH0LHElCbdKx9bVehmgavHnx38cUjR5yM7Z1UupjQFFwjdToGGEFLNYr90k
 U3IexsxHfnUK6qvVOAyfBciZw5H9XZTLoUqGwOUE3B6WDqxtbBFn+kQrgvXoy30BD7Lkvq55X
 aKlBRZaFC8o6cx1M6yUD0H/xhkIQyTHUzw/LoKQcQ0er8gsXoihpzeiaaZa/35lX8lP58glT2
 DYaQG7jOsMPsvsl6fdy0MtC1f5oWEFIZAsIJJl4OGVLL5JAW56ctpos67mN9SYUbGZxXU0k5T
 BfmPKdPnLC9jLIgL6
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>> =E2=80=A6
>>> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
>>> @@ -4887,15 +4887,13 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t=
 *vha)
>>>  	    "Entered %s.\n", __func__);
>>>
>>>  	els_cmd_map =3D dma_alloc_coherent(&ha->pdev->dev, ELS_CMD_MAP_SIZE,
>>> -	    &els_cmd_map_dma, GFP_KERNEL);
>>> +					 &els_cmd_map_dma, GFP_KERNEL);
>>>  	if (!els_cmd_map) {
>> =E2=80=A6
>>
>> I find it safer to integrate such source code reformattings by
>> another update step which will be separated from the proposed deletion
>> of unwanted function calls.
>
> Good point. This whitespace was autoformatted by Coccinelle,
> probably due to my bad SmPL skills.

Some system factors can be involved here.

* The source code formatting can occasionally be improvable
  in further ways (despite of help by a software like Coccinelle).

* A change mixture can become more challenging.

* Would you like to extend your skills in corresponding areas anyhow?

Regards,
Markus
