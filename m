Return-Path: <SRS0=WTMl=AV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5E1C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 06:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BB022077D
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 06:33:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="luB6hwR4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgGJGdC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jul 2020 02:33:02 -0400
Received: from mout.web.de ([212.227.17.12]:60185 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbgGJGdB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Jul 2020 02:33:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1594362762;
        bh=VSjkdBzvkGVrNT496rxp9Bw1WUlP3ENwOMf0SJfm364=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=luB6hwR4i7nRJjgxqtglc/ZyD+mjMLPZp2iT5Cl5HTYC4JxCZ0wrGM6JrxeaPfevU
         PCka1t6FKs8HhoRGOsgzzoqVrOoRMjDTCbs91FE4vGwN4jscHn8Llq5WIrcRwAFkNS
         i+Nq9kc8/RVmJoihbj7I4RUcElpGM5+Izv6Gud5I=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.129.239]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N1u6d-1krgVX0c5R-012Jmp; Fri, 10
 Jul 2020 08:32:42 +0200
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
 mQINBFg2+xABEADBJW2hoUoFXVFWTeKbqqif8VjszdMkriilx90WB5c0ddWQX14h6w5bT/A8
 +v43YoGpDNyhgA0w9CEhuwfZrE91GocMtjLO67TAc2i2nxMc/FJRDI0OemO4VJ9RwID6ltwt
 mpVJgXGKkNJ1ey+QOXouzlErVvE2fRh+KXXN1Q7fSmTJlAW9XJYHS3BDHb0uRpymRSX3O+E2
 lA87C7R8qAigPDZi6Z7UmwIA83ZMKXQ5stA0lhPyYgQcM7fh7V4ZYhnR0I5/qkUoxKpqaYLp
 YHBczVP+Zx/zHOM0KQphOMbU7X3c1pmMruoe6ti9uZzqZSLsF+NKXFEPBS665tQr66HJvZvY
 GMDlntZFAZ6xQvCC1r3MGoxEC1tuEa24vPCC9RZ9wk2sY5Csbva0WwYv3WKRZZBv8eIhGMxs
 rcpeGShRFyZ/0BYO53wZAPV1pEhGLLxd8eLN/nEWjJE0ejakPC1H/mt5F+yQBJAzz9JzbToU
 5jKLu0SugNI18MspJut8AiA1M44CIWrNHXvWsQ+nnBKHDHHYZu7MoXlOmB32ndsfPthR3GSv
 jN7YD4Ad724H8fhRijmC1+RpuSce7w2JLj5cYj4MlccmNb8YUxsE8brY2WkXQYS8Ivse39MX
 BE66MQN0r5DQ6oqgoJ4gHIVBUv/ZwgcmUNS5gQkNCFA0dWXznQARAQABtCZNYXJrdXMgRWxm
 cmluZyA8TWFya3VzLkVsZnJpbmdAd2ViLmRlPokCVAQTAQgAPhYhBHDP0hzibeXjwQ/ITuU9
 Figxg9azBQJYNvsQAhsjBQkJZgGABQsJCAcCBhUICQoLAgQWAgMBAh4BAheAAAoJEOU9Figx
 g9azcyMP/iVihZkZ4VyH3/wlV3nRiXvSreqg+pGPI3c8J6DjP9zvz7QHN35zWM++1yNek7Ar
 OVXwuKBo18ASlYzZPTFJZwQQdkZSV+atwIzG3US50ZZ4p7VyUuDuQQVVqFlaf6qZOkwHSnk+
 CeGxlDz1POSHY17VbJG2CzPuqMfgBtqIU1dODFLpFq4oIAwEOG6fxRa59qbsTLXxyw+PzRaR
 LIjVOit28raM83Efk07JKow8URb4u1n7k9RGAcnsM5/WMLRbDYjWTx0lJ2WO9zYwPgRykhn2
 sOyJVXk9xVESGTwEPbTtfHM+4x0n0gC6GzfTMvwvZ9G6xoM0S4/+lgbaaa9t5tT/PrsvJiob
 kfqDrPbmSwr2G5mHnSM9M7B+w8odjmQFOwAjfcxoVIHxC4Cl/GAAKsX3KNKTspCHR0Yag78w
 i8duH/eEd4tB8twcqCi3aCgWoIrhjNS0myusmuA89kAWFFW5z26qNCOefovCx8drdMXQfMYv
 g5lRk821ZCNBosfRUvcMXoY6lTwHLIDrEfkJQtjxfdTlWQdwr0mM5ye7vd83AManSQwutgpI
 q+wE8CNY2VN9xAlE7OhcmWXlnAw3MJLW863SXdGlnkA3N+U4BoKQSIToGuXARQ14IMNvfeKX
 NphLPpUUnUNdfxAHu/S3tPTc/E/oePbHo794dnEm57LuuQINBFg2+xABEADZg/T+4o5qj4cw
 nd0G5pFy7ACxk28mSrLuva9tyzqPgRZ2bdPiwNXJUvBg1es2u81urekeUvGvnERB/TKekp25
 4wU3I2lEhIXj5NVdLc6eU5czZQs4YEZbu1U5iqhhZmKhlLrhLlZv2whLOXRlLwi4jAzXIZAu
 76mT813jbczl2dwxFxcT8XRzk9+dwzNTdOg75683uinMgskiiul+dzd6sumdOhRZR7YBT+xC
 wzfykOgBKnzfFscMwKR0iuHNB+VdEnZw80XGZi4N1ku81DHxmo2HG3icg7CwO1ih2jx8ik0r
 riIyMhJrTXgR1hF6kQnX7p2mXe6K0s8tQFK0ZZmYpZuGYYsV05OvU8yqrRVL/GYvy4Xgplm3
 DuMuC7/A9/BfmxZVEPAS1gW6QQ8vSO4zf60zREKoSNYeiv+tURM2KOEj8tCMZN3k3sNASfoG
 fMvTvOjT0yzMbJsI1jwLwy5uA2JVdSLoWzBD8awZ2X/eCU9YDZeGuWmxzIHvkuMj8FfX8cK/
 2m437UA877eqmcgiEy/3B7XeHUipOL83gjfq4ETzVmxVswkVvZvR6j2blQVr+MhCZPq83Ota
 xNB7QptPxJuNRZ49gtT6uQkyGI+2daXqkj/Mot5tKxNKtM1Vbr/3b+AEMA7qLz7QjhgGJcie
 qp4b0gELjY1Oe9dBAXMiDwARAQABiQI8BBgBCAAmFiEEcM/SHOJt5ePBD8hO5T0WKDGD1rMF
 Alg2+xACGwwFCQlmAYAACgkQ5T0WKDGD1rOYSw/+P6fYSZjTJDAl9XNfXRjRRyJSfaw6N1pA
 Ahuu0MIa3djFRuFCrAHUaaFZf5V2iW5xhGnrhDwE1Ksf7tlstSne/G0a+Ef7vhUyeTn6U/0m
 +/BrsCsBUXhqeNuraGUtaleatQijXfuemUwgB+mE3B0SobE601XLo6MYIhPh8MG32MKO5kOY
 hB5jzyor7WoN3ETVNQoGgMzPVWIRElwpcXr+yGoTLAOpG7nkAUBBj9n9TPpSdt/npfok9ZfL
 /Q+ranrxb2Cy4tvOPxeVfR58XveX85ICrW9VHPVq9sJf/a24bMm6+qEg1V/G7u/AM3fM8U2m
 tdrTqOrfxklZ7beppGKzC1/WLrcr072vrdiN0icyOHQlfWmaPv0pUnW3AwtiMYngT96BevfA
 qlwaymjPTvH+cTXScnbydfOQW8220JQwykUe+sHRZfAF5TS2YCkQvsyf7vIpSqo/ttDk4+xc
 Z/wsLiWTgKlih2QYULvW61XU+mWsK8+ZlYUrRMpkauN4CJ5yTpvp+Orcz5KixHQmc5tbkLWf
 x0n1QFc1xxJhbzN+r9djSGGN/5IBDfUqSANC8cWzHpWaHmSuU3JSAMB/N+yQjIad2ztTckZY
 pwT6oxng29LzZspTYUEzMz3wK2jQHw+U66qBFk8whA7B2uAU1QdGyPgahLYSOa4XAEGb6wbI FEE=
Message-ID: <8eb9a827-45f1-e71c-0cbf-1c29acd8e310@web.de>
Date:   Fri, 10 Jul 2020 08:32:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <e87746e6-813e-7c0e-e21e-5921e759da5d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:FX8FryPsmDViqZC962m+4pWDswlnK0V23fb+GXCb9B8DsrzKIVX
 /Gpa47Lg1rGyg9CeIk40gidvRDCiBv/8l/d89KQtqdM8s1gtegZW2Us4yxQ3+5z9P98S6km
 5Ga5Nh5MU6nbh6D3AWdoK6YjbjWz2iVZya5SIBrjxfzh2MotWESRdx2/8ko/HagQjZn46Gv
 o1Mca4OZXEV8z4JFGZWCA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:GzZE6VK4dOQ=:t83HzhaOTridvOKZEMYg4s
 37je6YWVvcLbOOeADbRW293V13Skt9rKaCjupP6EDdG5Yo3fXCvhdsz4QsOaDAhvf2lZJYvLw
 eABTTxVWPSeQ8+1gNzHIWf/Kh7yHLDjqEynFnX1qc7E6qGm5M255uWQdH6OHn4xeXYYG2lMuL
 nUKRAENTDtZhssKrwAurgRCABZAn9/B6darxqgvrnJeYWme1ZeFke6xxW3bibQyc1CAAtdG+6
 KNZqHajoAfIGP2fBzh1Q1UUofwtKjjya+Dyc7FyIwLWT1+JwNQIfFGQnbzs1RXKa7FfzneiVM
 xMjilyCMNd3aZrIt6GdKTeLyDwFQ3ygVbtjS7xtmyjGk3srowDcF36OPWf+XuawMYGpKJray3
 hv+D8F9z0FjWCecV7qQGOsuBVTki8FDJXpSVmLnemkngS7MDP5igzBDNCLPLy1TVuiZwnl947
 OpRbRBGmX6/x3nH5XBAbPZviVQs4XB95HMNCiD5tOQAJxp5Fif3ba3PVmez1v3ez5BBkA35yy
 ih7ihcLip9xXoHoMsBAjVUOSiygCh2W2wBKuYfk8cE6iQ3F/+EVUURAj8+P2VSNryfgk7zVn7
 6DsyS0yhGSbi4/Z78nW5aFCg7cgJnNhbqOY1wP9IQEmYJ1wY/VH4LRCxrO0m1Tf9PIq+HeLNS
 KQWK/1BXDyvizekBx2AmRE6c5O0R3ySHWtRI8JbnuDxhzzolv9ZrZxVVfI8y1R0qX8+a+jP+A
 VXXkARNs5US0hCzukvqtXP+OQi7D0e5NsWeoA9dvi6GzS6fEiHjJHILbW1XXueQW5Y1q87NyN
 i3zce6VY5Mm/QWUSyrNzrhMjdmjjKfja4Gn6MjRWsVsvl5fGOKJFgi+lNFplfDOVsEiuVpIrr
 aYZmbpwYT+nZQ0qVNi9U+d3K4aV6f5TJ22Gt/FoGgMw8YkY78cARo4ABVGZKFdvvKtEqj8a1y
 YgOC3+gjjw892t6It2ygotT8skx22qXtbrmBQEr3oz26gj3oIFiJgy4R13lX3k0UzBVptEPXO
 uSHZsOSA2ElSChxDsgBtVR8pBvKYEGpRkAvaUvHYYs9F7qswVd/GV3e43PlKzLUOF1mkmBJlY
 V3uV5HJ3pWmC9JmhhL/8fZHLqHJrhGVCqS+v/6FCs4Ad9ZhXYUIYPupcxKG/UpnjjvQeeJzVo
 lwxUypPvrnrgLsxNM2JsMP6BSThb4CxujB0rB19MChinhdJvINDZ2n/eJ51otPCe2RzszVjkT
 z3+KgY7HKaOr7Pzx03aSZpVQh0YeVF3ObYPgAQQ==
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

I suggest to reconsider also Linux coding style aspects
for the implementation of the function =E2=80=9Cinit=E2=80=9D.
https://elixir.bootlin.com/linux/v5.8-rc4/source/drivers/scsi/virtio_scsi.=
c#L980
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dr=
ivers/scsi/virtio_scsi.c?id=3D42f82040ee66db13525dc6f14b8559890b2f4c1c#n98=
0

 	if (!virtscsi_cmd_cache) {
 		pr_err("kmem_cache_create() for virtscsi_cmd_cache failed\n");
-		goto error;
+		return -ENOMEM;
	}


See also:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?id=3D42f82040ee66db13525dc6f14b855989=
0b2f4c1c#n461


> executing a couple more instruction is not an issue.

With which update steps would like to achieve such a code variant?

destroy_pool:
	mempool_destroy(virtscsi_cmd_pool);
	virtscsi_cmd_pool =3D NULL;
destroy_cache:
	kmem_cache_destroy(virtscsi_cmd_cache);
	virtscsi_cmd_cache =3D NULL;
	return ret;


Regards,
Markus
