Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4A3C77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 20:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238509AbjEWUMj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 16:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbjEWUMi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 16:12:38 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770C4120;
        Tue, 23 May 2023 13:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1684872739; i=deller@gmx.de;
        bh=yuwHIW/1YtWzgHXNZUZyEoqfBptWG5Tjh93c//38xj8=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=X6P1YwS2E2v2IRSAlK2UpshmJ5c4/mqpux3uzkDjWqUG6FeUwbsTrMnfcJCnRQuoF
         KecrgfBpaVmv3SosI7qdxZ6M8HL1GleQnIJyPgTKQyibJOkm0mj4EQfTRMPOadq2bA
         wOdf7FU3xpFgQO5U4cnG2mQC7Tnr3dGzznW0h1S1JTY425bCmSvQE96d55T7THqdLf
         trCyiWlVp8SY1hLqk8yr8yA6Ipg6HLOJ70SYFWLnnE723mB8ZoKitIcA5CUByIZ8ZS
         KjGJiHE3tnSy0SLJ5xbCKUHYGuNGMHTAy1pP6TcKQS/P9LD8aEt/W05/S2jcBWt/Hz
         hE3sF7mLuJViw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.145.169]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MfYPY-1qd3z11ovA-00fzPd; Tue, 23
 May 2023 22:12:19 +0200
Message-ID: <fab032d7-def2-0763-7f40-b607479063fb@gmx.de>
Date:   Tue, 23 May 2023 22:12:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: spinlock recursion in aio_complete()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Dinh Nguyen <dinguyen@kernel.org>
Cc:     Linux SCSI List <linux-scsi@vger.kernel.org>, linux-aio@kvack.org,
        linux-parisc <linux-parisc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <5057d550-c3f4-be34-d3e6-390790051232@gmx.de>
 <89053bf1-6bc3-3778-7662-14d15bd778a3@acm.org>
 <8bd7faad-abf4-f7b3-03c9-e06f9b5d2148@gmx.de>
 <077b00a6-9587-2e28-3f8a-44871f9428ca@acm.org>
 <5e684a22-dcc1-095f-ac18-fd1b3bf81cd6@gmx.de>
 <4d786f73-8c6f-4fd1-cdd6-42f2d59d6120@gmx.de>
 <ZGyawdtBhNnvvTv3@shell.armlinux.org.uk> <ZG0bkNJ5jQC1a3pY@p100>
 <9fa519ab-a470-9e32-d3dc-f342ddad1026@acm.org>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <9fa519ab-a470-9e32-d3dc-f342ddad1026@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:gS8zyaHTD7rRYgW/2gPPA1ZyXTkiEtBVY3hOgeNE7HRpUjqYD73
 03c4oKxs5ai8aOOy2qGK2LlnFkj2r2RMR9r0hgP2JA1c8HaVdicFHReS4HbdSf5w/mhtYni
 VkWiLBqj2eZJC4pkumAEJzo8H6fgtIZ/mKFYI859ZsfpKKrWd1F+dyJuVTFi6g2nH4T8l6c
 fo75iccZJ1DxOYvkxKiMw==
UI-OutboundReport: notjunk:1;M01:P0:vfIqBDgR3rI=;oDDmt4gWWAmwOaYdQW63iD/EYQk
 /Oi7Xi8pUknnBhzdFX+eGWbH4DG237rxtStOUVHgoofeG6wEdvlFumMrLNiS54CwVSmOKPXme
 piyrNaNgTD9koYbXiTb8VlfmV38mVxkAHKMp5sNmpaK1dINQySLqxNVUyt96ATjsuTnQSVQU+
 FMZblgbIhUZGJ+lO2SIFQ21zZQS+rGxrWKMUn0OEY6TrxTjLnaXJFbEKVwCfTaP9D2+pECR15
 ER0JA6dOdYNVACPbdufDb3nbPBPho0OrV2lMez14qEeEGshkBEj0vQqaN4tiWHEL3Rjk0VyFy
 pC1PgGsn4z7qYwoR0xjv1KyV3+UohuNauLpKQiOf3gKfzZxDa5EnEBu0deC1OXDN14aegMtpP
 ndv3kPQ5ri4BipAAM1EJ0tqb5oG6PqpVZuMv+SSltX4YctsZe0UoPTycPy6BYBn1myjvi6Nd7
 iRUdiypsSjb0I2Ja8SVKqSmSuchytK8NEdr3aYfUezho1Q819SVTi6nnh3SIXsmH+huG1Jhwj
 5fBBqNqLTBI2isZ+ieBqx82KmvRArSZ65Wge5Ujcjtj1PTPYt6uAa6iB3dL4i8oGppNXyVuZE
 Gbb8AYY2Bwn33AkpTS2zCUELGF47zCsK80tS6UVD1U32Y9v2GUIIT3xNuRZrDVkg+LWy3e0RT
 ++CY5dQMlwR/SeFYYnev6vXt6gazOp2AhbYjkrjzRx1e8NkUcWrcw1SJ/HxEzHHJem0jfdGfX
 +YaZQ3o7k6+W8P/k9zGfH0j20zXdZVRJ1u+m1PMdDEVfVJGqotczdC2uyhJ1PYYK5TQ+ZE557
 dxSNLy2egjs55Gej4VbtJJ6Ah5gXwZoYoM1oUPftZXGaiXmTRxl5E1TqlSkKewiMouvfeSIw8
 BBW6R+oHE5u0l1ku3BVnTYTFD7WS7AkkCaFUi3/N/sDeKVbuBN8fEguBiPHVHDRq2ddZ1dGkF
 tc0r2A==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/23 22:06, Bart Van Assche wrote:
> On 5/23/23 13:01, Helge Deller wrote:
>> Subject: [PATCH] Fix flush_dcache_page() for usage in irq context
>>
>> flush_dcache_page() can be called with IRQs disabled, e.g. from
>> aio_complete().
>>
>> Fix flush_dcache_page() on the arm, parisc and nios2 architectures
>> to not unintentionally re-enable IRQs by using xa_lock_irqsave() instea=
d
>> of xa_lock_irq() for the flush_dcache_mmap_*lock() functions.
>
> Please consider adding a Fixes: tag such that this patch is picked up
> automatically by the stable tree maintainers.
Sure. I'll probably split it up as per-arch patch as well. Just wanted
to get some feedback first.

Helge
