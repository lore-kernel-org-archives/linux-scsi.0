Return-Path: <SRS0=0D1w=7E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 632E2C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 08:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E48B20812
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 08:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgEVIzF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 May 2020 04:55:05 -0400
Received: from mail.zju.edu.cn ([61.164.42.155]:50578 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728424AbgEVIzE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 May 2020 04:55:04 -0400
Received: by ajax-webmail-mail-app4 (Coremail) ; Fri, 22 May 2020 16:54:48
 +0800 (GMT+08:00)
X-Originating-IP: [222.205.77.158]
Date:   Fri, 22 May 2020 16:54:48 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   dinghao.liu@zju.edu.cn
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc:     "kjlu@umn.edu" <kjlu@umn.edu>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        "Avri Altman" <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        "Can Guo" <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RE: [EXT] [PATCH] scsi: ufs-bsg: Fix runtime PM imbalance on
 error
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.10 build 20190906(84e8bf8f)
 Copyright (c) 2002-2020 www.mailtech.cn zju.edu.cn
In-Reply-To: <SN6PR08MB56932A6D579AFB4E28AFD001DBB40@SN6PR08MB5693.namprd08.prod.outlook.com>
References: <20200522045932.31795-1-dinghao.liu@zju.edu.cn>
 <SN6PR08MB56932A6D579AFB4E28AFD001DBB40@SN6PR08MB5693.namprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <4a6ba414.bf5c4.1723b9792df.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgBHkD5Yk8decHj_AQ--.40656W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgUIBlZdtOQgrAAAse
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJTRUUUbtCS07vEb7Iv0x
        C_Cr1lV2xY67kC6x804xWlV2xY67CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DMIAI
        bVAFxVCF77xC64kEw24lV2xY67C26IkvcIIF6IxKo4kEV4ylV2xY628lY4IE4IxF12IF4w
        CS07vE84x0c7CEj48ve4kI8wCS07vE84ACjcxK6xIIjxv20xvE14v26w1j6s0DMIAIbVA2
        z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWlV2xY628EF7xvwVC2z280aVAFwI0_Gc
        CE3s1lV2xY628EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wCS07vEe2I262IYc4CY6c8I
        j28IcVAaY2xG8wCS07vE5I8CrVACY4xI64kE6c02F40Ex7xfMIAIbVAv7VC0I7IYx2IY67
        AKxVWUGVWUXwCS07vEYx0Ex4A2jsIE14v26r4j6F4UMIAIbVAm72CE4IkC6x0Yz7v_Jr0_
        Gr1lV2xY64IIrI8v6xkF7I0E8cxan2IY04v7MIAIbVCjxxvEw4WlV2xY6xkIecxEwVAFwV
        W8ZwCS07vEc2IjII80xcxEwVAKI48JMIAIbVCF04k20xvE74AGY7Cv6cx26r4fKr1UJr1l
        V2xY6xCjnVCjjxCrMIAIbVCFx2IqxVCFs4IE7xkEbVWUJVW8JwCS07vEx2IqxVAqx4xG67
        AKxVWUJVWUGwCS07vEx2IqxVCjr7xvwVAFwI0_JrI_JrWlV2xY6I8E67AF67kF1VAFwI0_
        Jw0_GFylV2xY6IIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lV2xY6IIF0xvE2Ix0cI8IcVCY1x
        0267AKxVW8JVWxJwCS07vEIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIAIbVCI42IY
        6I8E87Iv67AKxVW8JVWxJwCS07vEIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIda
        VFxhVjvjDU=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksIEJlYW4KClRoYW5rIHlvdSBmb3IgeW91ciBhZHZpY2UhIE1vdmluZyBvcmlnaW5hbCBwbV9y
dW50aW1lX3B1dF9zeW5jKCkgCnRvIGFmdGVyICJvdXQiIGxhYmVsIHdpbGwgaW5mbHVlbmNlIGFu
IGVycm9yIHBhdGggYnJhbmNoZWQgZnJvbSAKdXBzX2JzZ192ZXJpZnlfcXVlcnlfc2l6ZSgpLiBT
byBJIHRoaW5rIGNoYW5naW5nICJnb3RvIG91dCIgdG8KImJyZWFrIiBpcyBhIGdvb2QgaWRlYS4g
QnV0IGluIHRoaXMgY2FzZSB3ZSBtYXkgZXhlY3V0ZSBhbiBleHRyYQpzZ19jb3B5X2Zyb21fYnVm
ZmVyKCkgYW5kIGFuIGV4dHJhIGtmcmVlKCkgY29tcGFyZWQgd2l0aCB1bnBhdGNoZWQKdmVyc2lv
bi4gRG9lcyB0aGlzIG1hdHRlcj8KClJlZ2FyZHMsCkRpbmdoYW8KCj4gPiAgMSBmaWxlIGNoYW5n
ZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+IEhpLCBEaW5naGFvCj4gPiAKPiA+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc19ic2cuYyBiL2RyaXZlcnMvc2NzaS91
ZnMvdWZzX2JzZy5jIGluZGV4Cj4gPiA1M2RkODc2MjhjYmUuLjUxNmE3ZjU3Mzk0MiAxMDA2NDQK
PiA+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzX2JzZy5jCj4gPiArKysgYi9kcml2ZXJzL3Nj
c2kvdWZzL3Vmc19ic2cuYwo+ID4gQEAgLTEwNiw4ICsxMDYsMTAgQEAgc3RhdGljIGludCB1ZnNf
YnNnX3JlcXVlc3Qoc3RydWN0IGJzZ19qb2IgKmpvYikKPiA+ICAJCWRlc2Nfb3AgPSBic2dfcmVx
dWVzdC0+dXBpdV9yZXEucXIub3Bjb2RlOwo+ID4gIAkJcmV0ID0gdWZzX2JzZ19hbGxvY19kZXNj
X2J1ZmZlcihoYmEsIGpvYiwgJmRlc2NfYnVmZiwKPiA+ICAJCQkJCQkmZGVzY19sZW4sIGRlc2Nf
b3ApOwo+ID4gLQkJaWYgKHJldCkKPiA+ICsJCWlmIChyZXQpIHsKPiA+ICsJCQlwbV9ydW50aW1l
X3B1dF9zeW5jKGhiYS0+ZGV2KTsKPiAKPiBObyAgbmVlZCB0byBhZGQgcG1fcnVudGltZV9wdXRf
c3luYygpIGhlcmUsIHlvdSBjYW4gY2hhbmdlICJnb3RvIG91dCIgdG8gImJyZWFrIiwKPiBPciBt
b3ZlIG9yaWdpbmFsIHBtX3J1bnRpbWVfcHV0X3N5bmMoKSB0byBhZnRlciBnb3RvIGxhYmVsLgo+
IAo+ID4gIAkJCWdvdG8gb3V0Owo+ID4gKwkJfQo+ID4gCj4gPiAgCQkvKiBmYWxsIHRocm91Z2gg
Ki8KPiA+ICAJY2FzZSBVUElVX1RSQU5TQUNUSU9OX05PUF9PVVQ6Cj4gPiAtLQo+ID4gMi4xNy4x
Cg==
