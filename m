Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA0FFC38A02
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Oct 2022 15:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiJ2Pqk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Oct 2022 11:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiJ2Pqj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Oct 2022 11:46:39 -0400
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 29 Oct 2022 08:46:38 PDT
Received: from jari.cn (unknown [218.92.28.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 58FCE63FF6
        for <linux-scsi@vger.kernel.org>; Sat, 29 Oct 2022 08:46:37 -0700 (PDT)
Received: by ajax-webmail-localhost.localdomain (Coremail) ; Sat, 29 Oct
 2022 23:40:58 +0800 (GMT+08:00)
X-Originating-IP: [182.148.13.81]
Date:   Sat, 29 Oct 2022 23:40:58 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   wangkailong@jari.cn
To:     Kai.Makisara@kolumbus.fi, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: st: replace ternary operator with max()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT6.0.1 build 20210329(c53f3fee)
 Copyright (c) 2002-2022 www.mailtech.cn
 mispb-4e503810-ca60-4ec8-a188-7102c18937cf-zhkzyfz.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <317f9e05.40.18424674406.Coremail.wangkailong@jari.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AQAAfwCXq+GKSV1jUOEAAA--.20W
X-CM-SenderInfo: 5zdqwypdlo00nj6mt2flof0/1tbiAQAOB2FEYx0BKAADs5
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rml4IHRoZSBmb2xsb3dpbmcgY29jY2ljaGVjayB3YXJuaW5nOgoKZHJpdmVycy9zY3NpL3N0LmM6
MTU3NzogV0FSTklORyBvcHBvcnR1bml0eSBmb3IgbWF4KCkKClNpZ25lZC1vZmYtYnk6IEthaUxv
bmcgV2FuZyA8d2FuZ2thaWxvbmdAamFyaS5jbj4KLS0tCiBkcml2ZXJzL3Njc2kvc3QuYyB8IDMg
Ky0tCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zY3NpL3N0LmMgYi9kcml2ZXJzL3Njc2kvc3QuYwppbmRleCBiOTBh
NDQwZTEzNWQuLjU0Nzc4OTdhYTkyMCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL3N0LmMKKysr
IGIvZHJpdmVycy9zY3NpL3N0LmMKQEAgLTE1NzQsOCArMTU3NCw3IEBAIHN0YXRpYyBpbnQgc2V0
dXBfYnVmZmVyaW5nKHN0cnVjdCBzY3NpX3RhcGUgKlNUcCwgY29uc3QgY2hhciBfX3VzZXIgKmJ1
ZiwKIAogCWlmICghU1RicC0+ZG9fZGlvKSB7CiAJCWlmIChTVHAtPmJsb2NrX3NpemUpCi0JCQli
dWZzaXplID0gU1RwLT5ibG9ja19zaXplID4gc3RfZml4ZWRfYnVmZmVyX3NpemUgPwotCQkJCVNU
cC0+YmxvY2tfc2l6ZSA6IHN0X2ZpeGVkX2J1ZmZlcl9zaXplOworCQkJYnVmc2l6ZSA9IG1heChT
VHAtPmJsb2NrX3NpemUsIHN0X2ZpeGVkX2J1ZmZlcl9zaXplKTsKIAkJZWxzZSB7CiAJCQlidWZz
aXplID0gY291bnQ7CiAJCQkvKiBNYWtlIHN1cmUgdGhhdCBkYXRhIGZyb20gcHJldmlvdXMgdXNl
ciBpcyBub3QgbGVha2VkIGV2ZW4gaWYKLS0gCjIuMjUuMQo=
