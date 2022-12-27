Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D174BC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Dec 2022 02:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbiL0Cdl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Dec 2022 21:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiL0Cd3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Dec 2022 21:33:29 -0500
Received: from jari.cn (unknown [218.92.28.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 43B9610CA;
        Mon, 26 Dec 2022 18:33:18 -0800 (PST)
Received: by ajax-webmail-localhost.localdomain (Coremail) ; Tue, 27 Dec
 2022 10:32:17 +0800 (GMT+08:00)
X-Originating-IP: [182.148.15.35]
Date:   Tue, 27 Dec 2022 10:32:17 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "KaiLong Wang" <wangkailong@jari.cn>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: scsi_transport_sas: Fix the following coccicheck
 warning:
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT6.0.1 build 20210329(c53f3fee)
 Copyright (c) 2002-2022 www.mailtech.cn
 mispb-4e503810-ca60-4ec8-a188-7102c18937cf-zhkzyfz.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <4a48b6f.39a.185516c69cd.Coremail.wangkailong@jari.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AQAAfwCXn+AxWapj12IKAA--.229W
X-CM-SenderInfo: 5zdqwypdlo00nj6mt2flof0/1tbiAQADB2FEYx0G1gAVsb
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

CmRyaXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9zYXMuYzo1MjU6OS0xNzogV0FSTklORzogdXNl
IHNjbnByaW50ZiBvciBzcHJpbnRmCmRyaXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9zYXMuYzo1
NzI6OC0xNjogV0FSTklORzogdXNlIHNjbnByaW50ZiBvciBzcHJpbnRmCmRyaXZlcnMvc2NzaS9z
Y3NpX3RyYW5zcG9ydF9zYXMuYzoxMTgwOjktMTc6IFdBUk5JTkc6IHVzZSBzY25wcmludGYgb3Ig
c3ByaW50ZgoKU2lnbmVkLW9mZi1ieTogS2FpTG9uZyBXYW5nIDx3YW5na2FpbG9uZ0BqYXJpLmNu
PgotLS0KIGRyaXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9zYXMuYyB8IDYgKysrLS0tCiAxIGZp
bGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9zYXMuYyBiL2RyaXZlcnMvc2NzaS9zY3NpX3Ry
YW5zcG9ydF9zYXMuYwppbmRleCA3NGI5OWYyYjBiNzQuLjU1MDQwNjdhZGNmMSAxMDA2NDQKLS0t
IGEvZHJpdmVycy9zY3NpL3Njc2lfdHJhbnNwb3J0X3Nhcy5jCisrKyBiL2RyaXZlcnMvc2NzaS9z
Y3NpX3RyYW5zcG9ydF9zYXMuYwpAQCAtNTIyLDcgKzUyMiw3IEBAIHNob3dfc2FzX2RldmljZV90
eXBlKHN0cnVjdCBkZXZpY2UgKmRldiwKIAlzdHJ1Y3Qgc2FzX3BoeSAqcGh5ID0gdHJhbnNwb3J0
X2NsYXNzX3RvX3BoeShkZXYpOwogCiAJaWYgKCFwaHktPmlkZW50aWZ5LmRldmljZV90eXBlKQot
CQlyZXR1cm4gc25wcmludGYoYnVmLCAyMCwgIm5vbmVcbiIpOworCQlyZXR1cm4gc3lzZnNfZW1p
dChidWYsICJub25lXG4iKTsKIAlyZXR1cm4gZ2V0X3Nhc19kZXZpY2VfdHlwZV9uYW1lcyhwaHkt
PmlkZW50aWZ5LmRldmljZV90eXBlLCBidWYpOwogfQogc3RhdGljIERFVklDRV9BVFRSKGRldmlj
ZV90eXBlLCBTX0lSVUdPLCBzaG93X3Nhc19kZXZpY2VfdHlwZSwgTlVMTCk7CkBAIC01NjksNyAr
NTY5LDcgQEAgc2hvd19zYXNfcGh5X2VuYWJsZShzdHJ1Y3QgZGV2aWNlICpkZXYsIHN0cnVjdCBk
ZXZpY2VfYXR0cmlidXRlICphdHRyLAogewogCXN0cnVjdCBzYXNfcGh5ICpwaHkgPSB0cmFuc3Bv
cnRfY2xhc3NfdG9fcGh5KGRldik7CiAKLQlyZXR1cm4gc25wcmludGYoYnVmLCAyMCwgIiVkXG4i
LCBwaHktPmVuYWJsZWQpOworCXJldHVybiBzeXNmc19lbWl0KGJ1ZiwgIiVkXG4iLCBwaHktPmVu
YWJsZWQpOwogfQogCiBzdGF0aWMgREVWSUNFX0FUVFIoZW5hYmxlLCBTX0lSVUdPIHwgU19JV1VT
Uiwgc2hvd19zYXNfcGh5X2VuYWJsZSwKQEAgLTExNzcsNyArMTE3Nyw3IEBAIHNob3dfc2FzX3Jw
aHlfZGV2aWNlX3R5cGUoc3RydWN0IGRldmljZSAqZGV2LAogCXN0cnVjdCBzYXNfcnBoeSAqcnBo
eSA9IHRyYW5zcG9ydF9jbGFzc190b19ycGh5KGRldik7CiAKIAlpZiAoIXJwaHktPmlkZW50aWZ5
LmRldmljZV90eXBlKQotCQlyZXR1cm4gc25wcmludGYoYnVmLCAyMCwgIm5vbmVcbiIpOworCQly
ZXR1cm4gc3lzZnNfZW1pdChidWYsICJub25lXG4iKTsKIAlyZXR1cm4gZ2V0X3Nhc19kZXZpY2Vf
dHlwZV9uYW1lcygKIAkJCXJwaHktPmlkZW50aWZ5LmRldmljZV90eXBlLCBidWYpOwogfQotLSAK
Mi4zNi4xCg==
