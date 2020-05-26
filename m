Return-Path: <SRS0=HoCN=7I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93950C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 10:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75C902073B
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 10:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388187AbgEZKNC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 06:13:02 -0400
Received: from spam.zju.edu.cn ([61.164.42.155]:55030 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728810AbgEZKNC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 May 2020 06:13:02 -0400
Received: by ajax-webmail-mail-app3 (Coremail) ; Tue, 26 May 2020 18:12:46
 +0800 (GMT+08:00)
X-Originating-IP: [222.205.78.173]
Date:   Tue, 26 May 2020 18:12:46 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   dinghao.liu@zju.edu.cn
To:     "Vignesh Raghavendra" <vigneshr@ti.com>
Cc:     kjlu@umn.edu, "Alim Akhtar" <alim.akhtar@samsung.com>,
        "Avri Altman" <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] scsi: ufs: Fix runtime PM imbalance on error
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.10 build 20190906(84e8bf8f)
 Copyright (c) 2002-2020 www.mailtech.cn zju.edu.cn
In-Reply-To: <73cb87f7-52ac-1a18-364e-977080cc149c@ti.com>
References: <20200522045335.30556-1-dinghao.liu@zju.edu.cn>
 <73cb87f7-52ac-1a18-364e-977080cc149c@ti.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <20dbb267.d17cd.172507864cf.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgCH_0Ke68xesPgJAA--.2822W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgkMBlZdtOUEVwADsL
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJTRUUUbXvS07vEb7Iv0x
        C_Cr1lV2xY67kC6x804xWlV2xY67CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DMIAI
        bVAFxVCF77xC64kEw24lV2xY67C26IkvcIIF6IxKo4kEV4ylV2xY628lY4IE4IxF12IF4w
        CS07vE84x0c7CEj48ve4kI8wCS07vE84ACjcxK6xIIjxv20xvE14v26w1j6s0DMIAIbVA2
        z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIAIbVA2z4x0Y4vEx4A2jsIE14v26r
        xl6s0DMIAIbVA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1lV2xY62AIxVAIcxkEcVAq
        07x20xvEncxIr21lV2xY6c02F40EFcxC0VAKzVAqx4xG6I80ewCS07vEYx0E2Ix0cI8IcV
        AFwI0_JrI_JrylV2xY6cIj6I8E87Iv67AKxVWUJVW8JwCS07vEOx8S6xCaFVCjc4AY6r1j
        6r4UMIAIbVCjxxvEw4WlV2xY6xkIecxEwVAFwVW8twCS07vEc2IjII80xcxEwVAKI48JMI
        AIbVCF04k20xvE74AGY7Cv6cx26r4fKr1UJr1lV2xY6xCjnVCjjxCrMIAIbVCFx2IqxVCF
        s4IE7xkEbVWUJVW8JwCS07vEx2IqxVAqx4xG67AKxVWUJVWUGwCS07vEx2IqxVCjr7xvwV
        AFwI0_JrI_JrWlV2xY6I8E67AF67kF1VAFwI0_Jw0_GFylV2xY6IIF0xvE2Ix0cI8IcVAF
        wI0_Jr0_JF4lV2xY6IIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCS07vEIxAIcVCF04
        k26cxKx2IYs7xG6rWUJVWrZr1UMIAIbVCI42IY6I8E87Iv67AKxVWUJVW8JwCS07vEIxAI
        cVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUU==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBIaSwKPiAKPiBPbiAyMi8wNS8yMCAxMDoyMyBhbSwgRGluZ2hhbyBMaXUgd3JvdGU6Cj4gPiBX
aGVuIGRldm1fY2xrX2dldCgpIHJldHVybnMgYW4gZXJyb3IgY29kZSwgYSBwYWlyaW5nCj4gPiBy
dW50aW1lIFBNIHVzYWdlIGNvdW50ZXIgZGVjcmVtZW50IGlzIG5lZWRlZCB0byBrZWVwCj4gPiB0
aGUgY291bnRlciBiYWxhbmNlZC4KPiA+IAo+ID4gU2lnbmVkLW9mZi1ieTogRGluZ2hhbyBMaXUg
PGRpbmdoYW8ubGl1QHpqdS5lZHUuY24+Cj4gPiAtLS0KPiAKPiBUaGFua3MgZm9yIHRoZSBwYXRj
aCEgQnV0IHRoaXMgZml4IGlzIGluY29tcGxldGUsIEkgaGF2ZSBwb3N0ZWQgCj4gYSBtb3JlIGNv
bXByZWhlbnNpdmUgZml4IGF0IFsxXS4uIFBsZWFzZSB0YWtlIGEgbG9vayEKCgpZb3UgYXJlIHJp
Z2h0LCB3ZSBzaG91bGQgY2FsbCBwbV9ydW50aW1lX2Rpc2FibGUoKSBvbiBlcnJvciwgdG9vLgpU
aGFuayB5b3VyIGZvciB5b3VyIHJlbWluZGVyIQoKUmVnYXJkcywKRGluZ2hhbw==
