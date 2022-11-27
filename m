Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDE4C46467
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Nov 2022 12:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiK0MoZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Nov 2022 07:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiK0MoZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Nov 2022 07:44:25 -0500
Received: from jari.cn (unknown [218.92.28.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6335BCB7;
        Sun, 27 Nov 2022 04:44:23 -0800 (PST)
Received: by ajax-webmail-localhost.localdomain (Coremail) ; Sun, 27 Nov
 2022 20:44:13 +0800 (GMT+08:00)
X-Originating-IP: [182.148.15.36]
Date:   Sun, 27 Nov 2022 20:44:13 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "KaiLong Wang" <wangkailong@jari.cn>
To:     mikecyr@linux.ibm.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ibmvscsi_tgt: convert sysfs snprintf to sysfs_emit
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT6.0.1 build 20210329(c53f3fee)
 Copyright (c) 2002-2022 www.mailtech.cn
 mispb-4e503810-ca60-4ec8-a188-7102c18937cf-zhkzyfz.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <483482fb.1d3.184b91dde72.Coremail.wangkailong@jari.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AQAAfwCHj+CdW4NjZHIFAA--.115W
X-CM-SenderInfo: 5zdqwypdlo00nj6mt2flof0/1tbiAQADB2FEYx0G1gACsM
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rml4IHRoZSBmb2xsb3dpbmcgY29jY2ljaGVjayB3YXJuaW5nOgoKZHJpdmVycy9zY3NpL2libXZz
Y3NpX3RndC9pYm12c2NzaV90Z3QuYzozNjI1OjgtMTY6IFdBUk5JTkc6IHVzZQpzY25wcmludGYg
b3Igc3ByaW50Zgpkcml2ZXJzL3Njc2kvaWJtdnNjc2lfdGd0L2libXZzY3NpX3RndC5jOjM2MTk6
OC0xNjogV0FSTklORzogdXNlCnNjbnByaW50ZiBvciBzcHJpbnRmCmRyaXZlcnMvc2NzaS9pYm12
c2NzaV90Z3QvaWJtdnNjc2lfdGd0LmM6MzYzMzo4LTE2OiBXQVJOSU5HOiB1c2UKc2NucHJpbnRm
IG9yIHNwcmludGYKClNpZ25lZC1vZmYtYnk6IEthaUxvbmcgV2FuZyA8d2FuZ2thaWxvbmdAamFy
aS5jbj4KLS0tCiBkcml2ZXJzL3Njc2kvaWJtdnNjc2lfdGd0L2libXZzY3NpX3RndC5jIHwgNiAr
KystLS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL2libXZzY3NpX3RndC9pYm12c2NzaV90Z3QuYyBiL2Ry
aXZlcnMvc2NzaS9pYm12c2NzaV90Z3QvaWJtdnNjc2lfdGd0LmMKaW5kZXggZTg3NzAzMTBhNjRi
Li5kOWE2MTUzMDY5NDkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS9pYm12c2NzaV90Z3QvaWJt
dnNjc2lfdGd0LmMKKysrIGIvZHJpdmVycy9zY3NpL2libXZzY3NpX3RndC9pYm12c2NzaV90Z3Qu
YwpAQCAtMzYxNiwxMyArMzYxNiwxMyBAQCBzdGF0aWMgdm9pZCBpYm12c2NzaXNfcmVtb3ZlKHN0
cnVjdCB2aW9fZGV2ICp2ZGV2KQogc3RhdGljIHNzaXplX3Qgc3lzdGVtX2lkX3Nob3coc3RydWN0
IGRldmljZSAqZGV2LAogCQkJICAgICAgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsIGNo
YXIgKmJ1ZikKIHsKLQlyZXR1cm4gc25wcmludGYoYnVmLCBQQUdFX1NJWkUsICIlc1xuIiwgc3lz
dGVtX2lkKTsKKwlyZXR1cm4gc3lzZnNfZW1pdChidWYsICIlc1xuIiwgc3lzdGVtX2lkKTsKIH0K
IAogc3RhdGljIHNzaXplX3QgcGFydGl0aW9uX251bWJlcl9zaG93KHN0cnVjdCBkZXZpY2UgKmRl
diwKIAkJCQkgICAgIHN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICphdHRyLCBjaGFyICpidWYpCiB7
Ci0JcmV0dXJuIHNucHJpbnRmKGJ1ZiwgUEFHRV9TSVpFLCAiJXhcbiIsIHBhcnRpdGlvbl9udW1i
ZXIpOworCXJldHVybiBzeXNmc19lbWl0KGJ1ZiwgIiV4XG4iLCBwYXJ0aXRpb25fbnVtYmVyKTsK
IH0KIAogc3RhdGljIHNzaXplX3QgdW5pdF9hZGRyZXNzX3Nob3coc3RydWN0IGRldmljZSAqZGV2
LApAQCAtMzYzMCw3ICszNjMwLDcgQEAgc3RhdGljIHNzaXplX3QgdW5pdF9hZGRyZXNzX3Nob3co
c3RydWN0IGRldmljZSAqZGV2LAogewogCXN0cnVjdCBzY3NpX2luZm8gKnZzY3NpID0gY29udGFp
bmVyX29mKGRldiwgc3RydWN0IHNjc2lfaW5mbywgZGV2KTsKIAotCXJldHVybiBzbnByaW50Zihi
dWYsIFBBR0VfU0laRSwgIiV4XG4iLCB2c2NzaS0+ZG1hX2Rldi0+dW5pdF9hZGRyZXNzKTsKKwly
ZXR1cm4gc3lzZnNfZW1pdChidWYsICIleFxuIiwgdnNjc2ktPmRtYV9kZXYtPnVuaXRfYWRkcmVz
cyk7CiB9CiAKIHN0YXRpYyBpbnQgaWJtdnNjc2lzX2dldF9zeXN0ZW1faW5mbyh2b2lkKQotLSAK
Mi4yNS4xCg==
