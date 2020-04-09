Return-Path: <SRS0=DEWY=5Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9744C2BB55
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Apr 2020 14:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9559215A4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Apr 2020 14:27:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="H9MzFTTW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbgDIO1b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Apr 2020 10:27:31 -0400
Received: from mout.web.de ([212.227.15.4]:43311 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727115AbgDIO1b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Apr 2020 10:27:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1586442426;
        bh=QfnV65nsvDrIJ2FKo6om5JqVuDjj2mBOGH72nZKKcTs=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=H9MzFTTWuUYTUxHpFp4DsPydA0qaRXfspbonOb3mPK9wYItHiHBsgPoNq8RfvU6QD
         IjOV550w+5YyWdOGrVfH8Nul9wCgt9nWdiT1z8bAjoineyH+xh0lCyjSV3TQ2i20w4
         yNMmHyajIuoqZa7pa0Rjv4kAQSfwlbvvWgfkaeZ4=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([93.133.77.56]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LnS3i-1io2Kq0QLW-00haJI; Thu, 09
 Apr 2020 16:27:06 +0200
Subject: Re: scsi: aic7xxx: Remove null pointer checks before kfree()
To:     Alex Dewar <alex.dewar@gmx.co.uk>, linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Qiujun Huang <hqjagain@gmail.com>
References: <72bc89d5-cf50-3f3a-41e0-b46b134e754d@web.de>
 <20200407155453.sosj4brsw6r7fnot@lenovo-laptop>
 <99c64c9f-0a9f-aafb-2e32-da7e026f9940@web.de>
 <20200409114813.g3k4phoguduz6pw2@medion>
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
Message-ID: <cd462354-a14c-ddb2-c728-17a6073a5de0@web.de>
Date:   Thu, 9 Apr 2020 16:27:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200409114813.g3k4phoguduz6pw2@medion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:md2EG9/IGImBIHkso25YHvrHzRidOUFA/3StYUH4m3q8NSmIf9G
 yXqZu4zCBznGnfsKroEbErRQr/jXgpVmz2dE8Sre9KKMD3Up8HIFl2+8icdgKotTu87Huti
 JMoBTwBCIs5VZ/hhC8IfpBxXahDgo4Kleco8D268SiCVgk60hCY1VUN911hJIam4yWJa/mT
 jW+bQL28/A9KZYO8CGiJA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:2jZv9P+yO4U=:zLPcwtGopv/vSYxSpTO7tm
 Lhf0nXEmq1+2YVh2LmTHtpKHLX32x2QWdLvWPnFJfJWTL0O8yw8ZG/JI2u/dyJB17HwcPPPtV
 unNrfbF3LbpDCiHJwJVtwRW0XOJCsxecmUzRFHPs7/T2Q57tzrfTHAWa0vLOQrZMw8RnnJ3cD
 LHHl5YDDLVTr6AGwPaKrW0TmO+ars8QqHYmYjKoOihGaxOSZq8u6dji/VlvSItzj9k1Uj719o
 IGShKiax2X+ziUlvuIh4XOaZX8bRgSowBI5/9tJ9qNhy0NuNfDV3IEywLJvyfzgKo/7tf+1+A
 oK61ivO+TrICBeYkT95+lBTHIl2GtfCPKNzWIVF2gCP6pCHSra6ebnPtCasnSKasjuG+iqBxc
 9IPrT7Zx68tnr56xIS35aYIqBCffh73q8W0+J0FqDfPbNLt8xiH21o+R9JLwn8F1D3HtgT5Yw
 US8ELAuUdDXMOpNSk/eNTPuAGpBR0aw4gnDR7jgP1wpjjAMSf8G8RFcgDb/4tW6yH9sAUiItW
 zP13EPwOqqpWJfg9kgvLkiN2H/KTgCL3HgqDjCgkzD5QyeNKFyTBZploYkdPr3vBV6f5JZgKn
 egMXTc/wC4uUlq7jE5r7Lmg9MaA87OhPiBDKuWmifZs/bdVCfQkWXTJeQutr39qEUVT+BTbzI
 5qqIaodNH0ecQ2ckBwojss2VUqi0sVxTjjrPX0BfvQYWqekX0dnIVsds8WgeOSEiyPypLWLgy
 cNGxt7A7xD76PXRGFYUMlzLf26Y40f5LCc26ThoLBw2yAbiHwkMjEVkwagE8YBmr3K4viX+ey
 RZKjEPEFMUEmP9eC/K6Z04Fx+W4k5TEK+LWuAr8EBfE1AcOrWDUSDjmynPRjK67kFI2BtihXL
 xWzyaOzNZNaRpAjhEN9X1mvYnYktNgrZCw0YrQt+BHd4a4MbzCgewAFaMNdyBMxBVDerzA6yp
 b5K/lvrSk+XkprbZRl4zLmtqvLTm9ADq692U0p96XbBIRyqYc1Rp1eomkiTKtrxVNdf2oFPVl
 l2Tzxn/rRV0yZbw379ZwzAgxKOoBWo9BgI3YPcufZhunnooERU7V7r4oNCfqR6egzdPDFTNgK
 HjmFOLImkMV8GVOBfGrA8AAq4P6NUu9sNRDiENPKofer1JCRLkCW5W+ZO/DvpZodFbSejuYw9
 /L9Acsj8/rFfehP0spzwmfM/KfTL+mFVvkZgYI6mOI1PpD14DkboUwIbJ/hTlanlqSqqPm5Oz
 MlvsjaOWe+rHMBLjz
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> The thing is that this seems like an obvious improvement

Such a view can be promising.


> (albeit not a terribly critical one).

The prioritisation influences change integration considerably.


> It reduces SLoC and removes an unnecessary check.

I hope that such goals will be reconsidered also for this software module.


> AFAICS the patch you mention wasn't rejected on technical grounds,
> but simply wasn't picked up.

The usual factors were involved for free software development.


> If there is a reason why this change isn't warranted
> then I'd like to know why so I can send better patches in future :-)

I hope that also your change interests can increase chances for
software evolution in desired directions.
With which delays will specific improvements be achieved?

Regards,
Markus
