Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8365E810D5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Sep 2023 02:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjI1CA7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 22:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjI1CA6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 22:00:58 -0400
Received: from jari.cn (unknown [218.92.28.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0144B7;
        Wed, 27 Sep 2023 19:00:56 -0700 (PDT)
Received: from wangkailong$jari.cn ( [182.148.12.64] ) by
 ajax-webmail-localhost.localdomain (Coremail) ; Thu, 28 Sep 2023 09:59:28
 +0800 (GMT+08:00)
X-Originating-IP: [182.148.12.64]
Date:   Thu, 28 Sep 2023 09:59:28 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "KaiLong Wang" <wangkailong@jari.cn>
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: lpfc: Clean up errors in lpfc_sli.h
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.1-cmXT6 build
 20230419(ff23bf83) Copyright (c) 2002-2023 www.mailtech.cn
 mispb-4e503810-ca60-4ec8-a188-7102c18937cf-zhkzyfz.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <220c85fc.89b.18ad9833276.Coremail.wangkailong@jari.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AQAAfwDnhD8A3hRlR3i+AA--.593W
X-CM-SenderInfo: 5zdqwypdlo00nj6mt2flof0/1tbiAQAJB2T8PZMAAQAVst
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rml4IHRoZSBmb2xsb3dpbmcgZXJyb3JzIHJlcG9ydGVkIGJ5IGNoZWNrcGF0Y2g6CgpFUlJPUjog
ImZvbyAqKiBiYXIiIHNob3VsZCBiZSAiZm9vICoqYmFyIgoKU2lnbmVkLW9mZi1ieTogS2FpTG9u
ZyBXYW5nIDx3YW5na2FpbG9uZ0BqYXJpLmNuPgotLS0KIGRyaXZlcnMvc2NzaS9scGZjL2xwZmNf
c2xpLmggfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24o
LSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvbHBmYy9scGZjX3NsaS5oIGIvZHJpdmVycy9z
Y3NpL2xwZmMvbHBmY19zbGkuaAppbmRleCBjZDMzZGZlYzc1OGMuLjEwMjRmOTJkYTk2MCAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zY3NpL2xwZmMvbHBmY19zbGkuaAorKysgYi9kcml2ZXJzL3Njc2kv
bHBmYy9scGZjX3NsaS5oCkBAIC0zNzYsNyArMzc2LDcgQEAgc3RydWN0IGxwZmNfc2xpIHsKIAkJ
CQkJICAgY21kICovCiAKICNkZWZpbmUgTFBGQ19JT0NCUV9MT09LVVBfSU5DUkVNRU5UICAxMDI0
Ci0Jc3RydWN0IGxwZmNfaW9jYnEgKiogaW9jYnFfbG9va3VwOyAvKiBhcnJheSB0byBsb29rdXAg
SU9DQiBieSBJT1RBRyAqLworCXN0cnVjdCBscGZjX2lvY2JxICoqaW9jYnFfbG9va3VwOyAvKiBh
cnJheSB0byBsb29rdXAgSU9DQiBieSBJT1RBRyAqLwogCXNpemVfdCBpb2NicV9sb29rdXBfbGVu
OyAgICAgICAgICAgLyogY3VycmVudCBsZW5ncyBvZiB0aGUgYXJyYXkgKi8KIAl1aW50MTZfdCAg
bGFzdF9pb3RhZzsgICAgICAgICAgICAgIC8qIGxhc3QgYWxsb2NhdGVkIElPVEFHICovCiAJdGlt
ZTY0X3QgIHN0YXRzX3N0YXJ0OwkJICAgLyogaW4gc2Vjb25kcyAqLwotLSAKMi4xNy4xCg==
