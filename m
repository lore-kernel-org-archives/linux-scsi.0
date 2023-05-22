Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C65C77B73
	for <linux-scsi@archiver.kernel.org>; Mon, 22 May 2023 21:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbjEVVW1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 May 2023 17:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbjEVVWX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2023 17:22:23 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9243CA3;
        Mon, 22 May 2023 14:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1684790534; i=deller@gmx.de;
        bh=oPgyShCoTYZ8j8AWCuIJUeij7AIoIuUuoeNZPt5npKU=;
        h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
        b=n6ufsmQTD9vz5xkLKv71ragGG7n/qqFsOMRIGYp+FMJEKGxy/JjslddBDF7jYwqVL
         lPZogFXSSFcHuAlXiqoDnUB7lKeMSRqtD8KjwvNRiijmzhQ5O96Py3pw22zeDEP8VW
         WUEcDFTk4OnmTk6C9zkZEu97VSsemXT4FBXj/r5V23da6aODD88085mhJ0ISMBjAWg
         iGDAHiGgwtHsoxciZNCHZj77VyH2L2A9YhoGzxaYxHLVXMpxQuETlBFPBBQfktUJXo
         67/LcUe15bEzclpdYovur2s7M7PZSH690uOyNDuaK2w4emJ84srcyt9fJbETRuXbfU
         3Imyb3d6c8ojw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.144.112]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Msq2E-1qGOS62Scq-00t94Z; Mon, 22
 May 2023 23:22:14 +0200
Message-ID: <5e684a22-dcc1-095f-ac18-fd1b3bf81cd6@gmx.de>
Date:   Mon, 22 May 2023 23:22:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: spinlock recursion in aio_complete()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        linux-aio@kvack.org, linux-parisc <linux-parisc@vger.kernel.org>
References: <5057d550-c3f4-be34-d3e6-390790051232@gmx.de>
 <89053bf1-6bc3-3778-7662-14d15bd778a3@acm.org>
 <8bd7faad-abf4-f7b3-03c9-e06f9b5d2148@gmx.de>
 <077b00a6-9587-2e28-3f8a-44871f9428ca@acm.org>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <077b00a6-9587-2e28-3f8a-44871f9428ca@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:1jsMV1PfasLTfLGcO/iUb5GrC1M7UCw2bBi3d5QY37h8/8s/7cO
 KcJTfODqpXEYXYM+eHBgm1mk+ZxJTFDWRyfm1KG2I74ZkjZjqclqF+H717sgbLYkVRTbRpz
 1cCYv9R64f4O5fEEGfCoGi8AVt3F+nLgE00LBozV3SfMxPuWKHm6AOu7cMqecho8eikv7ky
 uHM8FNUdxn0yUVHzoaOcA==
UI-OutboundReport: notjunk:1;M01:P0:FKk3c8vJxLA=;QCZuixA8yB1MuEWR0OZXLtdAhUV
 q3PrhPWesL2WS3vqVLUHZXYfxkb+Wh/YsydfOd6W4kWOyfXhxlm75xgqGBn/rsDmy1OR6H/WE
 +nh/OtIGAS2E7TxVAvZf8roebQC+JRNnCOMY4Shhb42sfD1LwmEHydTEFHIEajK9+80gTFdck
 kUJqJKoxI7390OMRMr1KxOM7phxnQMfVLYy5t4PJP+FbjWB2NNT/h6DG8DvIOMbm2jcoYD0Jb
 Zjz4N7UShvGufFLUfC/sxhNFumTN9GkkUzUqzdDQONJBrP+mpZXHC4vDNErDPR7VEndNXL/K2
 6FXdTx2ICvxffIItWTcUvRE3Us8Ib/URXju5LXHWXFm16f/QwLEPqWW0Z3ZBuJoIHaHqGKKpX
 02Qdk6VQsuUTt6yiBPStBbi109bU9G0awcXdVHGXeGks4evOBbwl6WmnF//Nb+XRVvUmJcFrJ
 QFZJairJRl11ynbErNAAOLWdTCNJu8KRX1oJhFkpI1kt73pDwyizR9eAkmE284C8o18Kw7+ch
 /ZxYzNEAs1gDRJGVPbBnR7OBlnXNBmABUaFL06mJJSUBHyzl3j8uZQi7ZMoMj+2AXjEUsFxBr
 N2KfXWqPRRgFBJ9TpF2tlvnbcL3miQrbyd6PYqIn+LjGa4xjAGSY0Grztk652GUhJ71tQ0NZM
 yFkYnLJopi6X45s0hHD83+ykH89SBqhyAMZc3dXY7QW8VnOW7tX3zE8vXZFrPkpT/4ZHMaOX2
 pYl6Rymdt+PqbqTo0J2ay2L5Oyj42cy4PodeNWdgmMO71a5+AvYXfNpq0VWtpjpZFj4Wl4Y9g
 grPmL3r96Z8RnX0kdQwzQ/x1LIp6z2ix0fqYs/8SU/DOYhVjloi9l69GzuXBtaxfQ5zVAJ2KA
 T38ttY4r9LjqOwKbgAhhx8nD1La5oOdtqIltvWhyJFEhSZ/PzU8k2l8jw3J+70c042yPKptpQ
 HTUjXA==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/22/23 22:58, Bart Van Assche wrote:
> On 5/22/23 13:51, Helge Deller wrote:
>> On 5/22/23 21:28, Bart Van Assche wrote:
>>> On 5/20/23 22:43, Helge Deller wrote:
>>>> On a single-CPU parisc64 machine I face the spinlock recursion below.
>>>> Happens reproduceably directly at bootup since kernel 6.2 (and ~ 6.1.=
5).
>>>> Kernel is built for SMP. Same kernel binary works nicely on machines =
with more than
>>>> one CPU, but stops on UP machines.
>>>> Any idea or patch I could try?
>>>
>>> How about performing one or more of the following actions?
>>> * Translating aio_complete+0x68 into a line number.
>>
>> It hangs in fs/aio.c:1128, function aio_complete(), in this call:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_lock_irqsave(&ctx->completion_lock, =
flags);
>
> All code that I found and that obtains ctx->completion_lock disables IRQ=
s.
> It is not clear to me how this spinlock can be locked recursively? Is it
> sure that the "spinlock recursion" report is correct?

Yes, it seems correct.
I can see the machine hanging in exactly the same lock when I build withou=
t
the CONFIG_DEBUG_SPINLOCK option and check the processor registers with th=
e TOC
command (TOC on parisc means: stop CPU instruction processing, save all CP=
U registers
to an area which can be analyzed at a later point in time, then reboot the=
 machine).

So, the spinlock recursion from kernel and TOC both agree.

Again, the strange thing is, that I can only reproduce it on that specific=
 machine,
which has only one CPU but runs the SMP kernel.

Helge
