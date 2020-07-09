Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8225C433E1
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 07:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7A672070E
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 07:23:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="lLQXcIXJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgGIHXC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 03:23:02 -0400
Received: from mout.web.de ([212.227.15.14]:39591 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbgGIHXB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Jul 2020 03:23:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1594279361;
        bh=4xFv8ti/OzBQfVAv9dMHgSddCt57MGCFKZdrZ/W39nY=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=lLQXcIXJaI/RfXgWUNwMgOK2aSON8JpR4Bbv0WZn8XYIInclOzYx3xqQzaXsou58a
         CgBXWFRozLGiHl1rbLWvL0b7RoqShI+BC3nrm85khh/M/GAFVYg2P9o5JIIHheGa3a
         hqll19DXiR0SKkXgt/ySAQl36QN2xmj95l4GFuvk=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.81.209]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MUVrX-1kJWSo1i31-00RFQX; Thu, 09
 Jul 2020 09:22:41 +0200
Subject: Re: [PATCH] scsi: fcoe: add missed kfree() in an error path
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neerav Parikh <Neerav.Parikh@intel.com>
References: <977e2781-99ed-54c0-27ad-82d768a1c1e6@web.de>
 <5F067CDA.8010404@huawei.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <ec1e1405-7582-0709-f2a5-a8b91e45fa1a@web.de>
Date:   Thu, 9 Jul 2020 09:22:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <5F067CDA.8010404@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tJ4Ea4WeRgIbK/YfyxkGEjAF7FVqtNiAMnNvYGIx3QWtiQBzR9O
 yOZ6PMyj0ERCqBM7/cuSBsAOQFmQMVRWbWawJVzI5C3muSzWa4eP5VBVkCM8h++chn15IRF
 /R9Mrs/CsfjtXA4r5mX89LknsCvJ6fxJDIcCUY1dBawJ7Js4tjKCuHobrvgeLKr9MdnGyij
 XRao0L31FTJHjRpJstibA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:CbIL8RvE6Kk=:AYUYSEglmSOmihPACDuvmI
 6XMkcu7ChJSuXb+O/RxD/IM3DP4JSj91ejVeUVDiA5m7CPp5Xw48o94eepzhLK15C/xmTCgOe
 1qCxYye4rG45Pt33dkR4+T66O6Fp4dVRZL8nghqiuBATrp0P40EymtipK0XNYHVPDVsfyH8bi
 ikovuwtTN57+tbTvjUCILDMYutIp1UovEfkuEWZp1QvFruir8cykZcNQXKUpLfONGRuGjVy4i
 /ObolBKHD6xirhjDuUiYzZPRgYpF4j86BTWSXx47u9GQlGXjrUctGNeivnzOhgAC7o4jbzDT6
 I3lNhSmhD0vsm2BR2GsXMDH3kAfouwQtUsJfSjW9JAdrafkjdw7uadLMFk0T8X2Ygyc7rxad9
 HED2GJWBTr1TsaoxArawGf/Klz0sSe1MYYcodjFWrxySJW7vNwRUCLjcZ1nqn6MtsXGATiRu6
 5E+hdEQAWYcaG9m3vi+8KhdI1PJ17sbgcTvNjeFqqVcPoSsJmTnB0FOzrbjUREZdWPHl+IBUI
 Il4qZKrwUTZYEmjOw7zZRb+qmKMWhTnNw+Tu8ha+vfcuGPlRrBiyfP7HyHjMc9ItF8Hc0msOr
 f+fwngF9wZubAL9/+mGdx3Djm5wXj/JUhEBca46UmzzbWZIJ/keaH7+u9XTSpsY1sYOs71pDD
 9mrQV1JU4I4KtNR4yOw8embUEt2RN/fc9H+LZzuem8HdAhn2rLyfU9dp0ooxqBnmeLRcLi59W
 /2SsNfXG7icvpSXEuL09p9KXzPWabufxdrXEwMqY/u/v21zYTFCwMZPybvps8F/3LcQMTf+eC
 iQo3bCWJSooN9WI2CD7pkcE8i/g9z86aZ2S9boQSK/HCvDTxJY/kKCFaF1NVJdceKN3a88lIB
 DytFFqZ8hp2qCLKz/28NSFF8UPyXabqnvPfTovIGQoz3WUM/wDrEC9jL3OVLig9yjCfEk0WNW
 FiCIyg/qj0Lbk1kQuPUeOKn9izh7ShsDBAI6Ahe7I+drhRSVyEpAitk8hQDwkEfGakd+R1VTh
 IjE4uHQsutLYwbVD0CStm4bJ2NlAI7l9tNWigSLGmCohBgJqSbrHMnTZhT68Kn3mKtw/10wnD
 E6Np99TRAtyzO/INd0sZmftzMGDnEC3EAAtRE0bHED6SqOJQHmN67yUpRGr9y5e8nX/OtHphJ
 uoEYH+HmB5Aj9p97xvihWw+eYGQrDobWniT0E/wean5JMm2W8xQCWJ2LdlYqqetTZYz2+OJ/I
 AfgaQ9vZ1aHZk2pGTTiq89Iev8DIjLNgpmKpZnQ==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>> fcoe_fdmi_info() misses to call kfree() in an error path.
>>> Add the missed function call to fix it.
>>
>> I suggest to use an additional jump target for the completion
>> of the desired exception handling.
>>
>>
>> =E2=80=A6
>>> +++ b/drivers/scsi/fcoe/fcoe.c
>>> @@ -830,6 +830,7 @@ static void fcoe_fdmi_info(struct fc_lport *lport,=
 struct net_device *netdev)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (rc) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 printk(KERN_INFO "fcoe: Failed to retrieve FDMI "
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "information fro=
m netdev.\n");
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kf=
ree(fdmi);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 return;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret=
urn;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 got=
o free_fdmi;
>>
>>
>> How do you think about to apply any further coding style adjustments?
>
> The local variable "fdmi" is invisible to the function.

I have got understanding difficulties for this information.
The function call =E2=80=9Ckfree(fdmi)=E2=80=9D is already used at the end=
 of this if branch.
Thus I propose to add a label there.

Do you notice any additional improvement possibilities for this software m=
odule?

Regards,
Markus
