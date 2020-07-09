Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D5C3C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 20:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A01D20672
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 20:56:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="qje773zA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgGIU4M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 16:56:12 -0400
Received: from mout.web.de ([212.227.17.12]:42939 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgGIU4L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Jul 2020 16:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1594328148;
        bh=25PBfwofqpYcfnQfB5TODkB8Oa0DXvIt4BdkJKGuJBk=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=qje773zAmD1f4Fe02ewAEcogKpw8x6oQ0MyN3lmjJ1TwQaVjJN2DN45ZEIJv7pkLx
         GI7g8/jkD9vw8Uhei347kQl/76aW8jZ3NKRHyk21pKE/gnORE0UNrkrUr0pAmxmmql
         wHQ9k/6akVGjkgHbnOua1GlwW9AN89t3K4438188=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.81.209]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M6mL2-1kng6i1PQi-00wRrr; Thu, 09
 Jul 2020 22:55:48 +0200
Subject: Re: [PATCH] scsi: virtio_scsi: Remove unnecessary condition checks
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Xianting Tian <xianting_tian@126.com>,
        linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <a197f532-7020-0d8e-21bf-42bb66e8daec@web.de>
 <e87746e6-813e-7c0e-e21e-5921e759da5d@redhat.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <072edd61-9b00-4c63-804f-e98bf271b683@web.de>
Date:   Thu, 9 Jul 2020 22:55:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <e87746e6-813e-7c0e-e21e-5921e759da5d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:2z9+KJz3jWsgHHQ4rbuCJap3wZt7E+Qo+O2KXBNCUnqljNihlEJ
 EdgUiaF8rRhbFguE/M04oKVbKaJqjVybRdjGWdJQVVJtUpfcrj9baHgeqg1L2VgJe1ShbkT
 NmMfUirnkush5ndlcv6DzpPRAiDucpVVmmJKBFEkTQx54uBLQ5XOjm9XtQCSmjH6YDLkk3h
 /No7DFON7QbW+WfqT/FLg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8x9yh20XVHw=:lVcyL0nnjk3YqchssiW6aQ
 7EBXo8VKzyAW2qkjw2p/hs8hega1+KTEAQBi6R+/B15dLm3rwBevHAw+BkblOgpJ3WiS13flq
 Ku5s9YseXkRofjpnR3hCYVWjGxZxypVevKT5QIzRvL1l02yNXIpbW3Sa5UPJK5JCe7qr++d77
 +gcMEabVKA8Cz95DLVl7dnRwq8EsedgsoHu9/yqvbPK2IRLMcwihOw/+xYi5gUCsbmQOD/RRK
 faQPdenR8S7cgYOupgo+VMShyXq5r+Fe8U8Xxd4tvopsCnleHEGmt9+Uf1ii7SlD9N2jg0EmU
 aPB8m6IoKPs9LbjG/zoxNp7kMgFwx7QrCHFRFSclh+D8hLRsU0ChlCs/67qjkQLNumQyCQVWj
 gJyNsyUrE5RjOExoUjX0IiEpU/Jm2WtZXL6UidNmc4zCI6yAysXXQJe4JNyJ3iQ6Mw20l1sBQ
 gU+K+C4BbV0q0jezvnhXWv+r2IC9UJ/Y0sZycFK+U9xp8U17OMeaXeP1X7+UXjiQbGBVIlNRb
 wXV1Vj9rmx6FbAESJtTREu//V3pvJQ1FSOPizUzwBOwKqxIucY6Z1LhE6WpG/BzQQxmXQ4mWt
 xdjkZEs17+Z6Kn7Kd1gabIPm/+3UHXt3XQeCswua/2tT5IKFIbJ97WvobZNtAa9vRW2HxUHfY
 wIBoMUlgOC+bkWyPbAQZzNxGMMCe21rd5gIK0XKq4W2TSjrwAUnLe/IDX14vH8EjXuvfozbpT
 zgdbtjhDSnJbThvM2UNZSYsAsX+sVBQrisMEMyuInUHxn1wjDIPjI5P8UhRwLcX8Y8TVUiCvo
 Sgff4p7PX8I0sqkke8qMcVh2LLCvXFNY/HpEE7zd979fdMxZLdq6e5SN5GcgdwIo7AniFWriY
 4Z9vIMOxqepxcVTn0fuic0v/Srvu8HBi17N9+sWoqS0BbGHQTwGKaefL+Z2TRl5xFd/5hdDrt
 uiYgRJP3A1U5ebBrfCjXQqcC+naRWUUW4V9DhrwSvu8n/1gzxv1TN90J8BBYZU/xfhy1B9qn2
 TwGqXLrSR6YA3W8oags1DBfhLuOBXbbNQ8LumlYofp/AT0lHDKESgEPOtogr/bi3xaycJy74L
 aE1DvZC8MBrIW+6CkVTZ2wMo8HGLuQOWcQ+rC0IO691je2q5DcIIerYF3zl37ttpla7alfDol
 GkfsykWKgpijNj+8fGkVGgWZUVBpLFAqj3xWqkSHo8jg3FjCsqPqKo2jgNQ6wxcJZX6XCQVeJ
 p+r2EGY1SYbIiLvz9QVJseSgeSMPsX7rlgPUM3w==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>> +	mempool_destroy(virtscsi_cmd_pool);
>>> +	virtscsi_cmd_pool =3D NULL;
>>> +	kmem_cache_destroy(virtscsi_cmd_cache);
>>> +	virtscsi_cmd_cache =3D NULL;
>>>  	return ret;
>>>  }
>>
>> How do you think about to add a jump target so that the execution
>> of a few statements can be avoided according to a previous
>> null pointer check?
>
> The point of the patch is precisely to simplify the code,

I propose another bit of fine-tuning there.


> executing a couple more instruction is not an issue.

Can an additional label help here besides a possible identifier renaming?

Regards,
Markus
