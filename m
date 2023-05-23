Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71136C7EE26
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 10:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236550AbjEWKYh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 06:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjEWKYg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 06:24:36 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3412E94;
        Tue, 23 May 2023 03:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1684837450; i=deller@gmx.de;
        bh=LnrOaZKOZPkWsLvDI4WNIWvJEIR5zNBixanXhsXOf50=;
        h=X-UI-Sender-Class:Date:From:To:References:Subject:In-Reply-To;
        b=hfjScB2UoBvfqAxVP255N9PqMNrvDv9KpvZ0eChwFS1gQBJ++C2oNLXFAy5r4IiW6
         1PSl1UjILx1+BNDbBFqe7PCVoTrHTOHnIuMiPWGMCizfK9lh7dVLhPAQKfhe6NHgOI
         RCJgJ+R1P46pPSnh7TwQ3AyluNLpnZnsiWfZQ18L7ziqsvnlg4erBAnnqdgAwqFsZ1
         IPIBj6q7oFW3PM3p3E0UIp1Z5KcQn4SqkVV2yOUPR2icsD+mm0BGAtcEt2iGpA1ezh
         hQ1H7PCtdPqaNTZrSFP4ImcLP0yWa7QmJ8ifZCtt2MiWDkkFLDuYwsOpSHP3lfygBx
         7UESRgVrlaCFA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.145.169]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M8QWG-1q5muI0VRA-004SXQ; Tue, 23
 May 2023 12:24:10 +0200
Message-ID: <4d786f73-8c6f-4fd1-cdd6-42f2d59d6120@gmx.de>
Date:   Tue, 23 May 2023 12:24:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
From:   Helge Deller <deller@gmx.de>
To:     Bart Van Assche <bvanassche@acm.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        linux-aio@kvack.org, linux-parisc <linux-parisc@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <5057d550-c3f4-be34-d3e6-390790051232@gmx.de>
 <89053bf1-6bc3-3778-7662-14d15bd778a3@acm.org>
 <8bd7faad-abf4-f7b3-03c9-e06f9b5d2148@gmx.de>
 <077b00a6-9587-2e28-3f8a-44871f9428ca@acm.org>
 <5e684a22-dcc1-095f-ac18-fd1b3bf81cd6@gmx.de>
Subject: Re: spinlock recursion in aio_complete()
In-Reply-To: <5e684a22-dcc1-095f-ac18-fd1b3bf81cd6@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:auW7OuoOvYAf9oQI5PN5n/Tnt+1xnbElNxtUVpNi0k/OgIqHud2
 TqoKVr0GSEQz4qxLAJFLwyBwKcrC3HQqG1wjLKa4lRrpbtVLIib9g42Pcd2FKZw/POXneAe
 1rV9OWomTfiussVhLe43JV3YypaivVh9nuAZGZlC3kDKsKIO3xEqVp2VttGcMr5YlT+Lqb8
 aiV+thm8immNkiAoLOtvA==
UI-OutboundReport: notjunk:1;M01:P0:gqsxP5t/FpA=;yBxdOI+PCebRGyif+DYLl6b+iY9
 /cFp/JBxGAY4L6FgaO6Yy1K1PRW8F+FX4GPeQZPYYB8Rku2U2dy/fnTd+HbpuWVghHo5EJ+NV
 08NVcGPDTJVsuk9+Jbtr9rb0kZPgKVpm0TlEv1E08VO/UPGvNJckushpqNjK8eEfW9Ny37o3S
 9Mzj47YkhMIHrhE6yHurDMyKWOgcByqgLXf+DXdj60Vah+cCRsBvHeM3hIq7EZIvI39bq20S8
 1ghbXJybadi0zfxu+wXCMl1lr/2uRt2MeOZBwHEQAJNtZaLbolrgxVtB6xVG/pJIHH/p6RmLd
 Y1rRf9DPkLUUSF81obgw38INEB0aA01Xpj2Q7TTkoBiknXZUJgpl45nn9rXkUEl1zv8xZmHi7
 HNyrqosgpKpLMLNcoCUoVatpr0qB1jzqg5fmDuJH+bL1kTFpcFlYAutYSBlC4YkIv3yLAAK+i
 /ApN056WtVmNlendIDvaTiUL8uqlCyA3vQMJxumrgnWKqVlw8yMpD8X4kMsbQu6DMMzYi0Cdk
 Xr8SvLYubeVaqq3RvU127252U9QCeLnnEFFI6cZ1kPOdjDLHxO3ToTFXIjqMsU2KpPLHenfnn
 coSO4pSU2JJwpDpDdMcse2FSNe+wgWc4kWzyDNGB0MJNj+bxi6esCmFFultNVivCSvmHq0tR0
 pzTM0uHp9cKjrr0RpETYf3ShwdIPs7ichuHCV2+ue87qLlSsu+TxK5l8Q7hYyno96y3VE6/q2
 wSComp136SyxtL1L7E/sCbE7BoulxaBiH00zThOkWRRs/eGiUXwsLuRmOg1echf0Jz3TscDYR
 +OzmCZPPUqEOxFyVjb/BYARydYKw7wctn+rksqHJWtE9sEpFwWNn41wS27Ed5XBuTp+5mYpYE
 PASQMRHvM8IjIRtAca618q9mIIK54I5zdYmSoIHz+woTLL+XoXay98qmnIwtsfICMVPieCqWH
 SQkoR45L+N6XCsMGZV45HgT0psM=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/22/23 23:22, Helge Deller wrote:
>>> It hangs in fs/aio.c:1128, function aio_complete(), in this call:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_lock_irqsave(&ctx->completion_lock,=
 flags);
>>
>> All code that I found and that obtains ctx->completion_lock disables IR=
Qs.
>> It is not clear to me how this spinlock can be locked recursively? Is i=
t
>> sure that the "spinlock recursion" report is correct?
>
> Yes, it seems correct.
> [...]

Bart, thanks to your suggestions I was able to narrow down the problem!

I got LOCKDEP working on parisc, which then reports:
	raw_local_irq_restore() called with IRQs enabled
for the spin_unlock_irqrestore() in function aio_complete(), which shouldn=
't happen.

Finally, I found that parisc's flush_dcache_page() re-enables the IRQs
which leads to the spinlock hang in aio_complete().

So, this is NOT a bug in aio or scsci, but we need fix in the the arch cod=
e.


While checking flush_dcache_page() re-enables IRQs, I see on parisc and AR=
M(32):
flush_dcache_page()  calls:
   -> flush_dcache_mmap_lock()   /  flush_dcache_mmap_unlock()
which uses: xa_lock_irq()	/  xa_unlock_irq()

So, the call to xa_unlock_irq() re-enables the IRQs unconditionally
and triggers the hang in aio_complete().

I temporarily #defined flush_dcache_mmap_lock() to NOP and the kernel boot=
ed nicely.

Not sure yet what the best fix is...

Helge
