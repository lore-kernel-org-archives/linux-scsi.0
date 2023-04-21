Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C51C7618E
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Apr 2023 12:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbjDUMfP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Apr 2023 08:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjDUMfO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2023 08:35:14 -0400
X-Greylist: delayed 903 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 21 Apr 2023 05:35:11 PDT
Received: from m13123.mail.163.com (m13123.mail.163.com [220.181.13.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49FECE53
        for <linux-scsi@vger.kernel.org>; Fri, 21 Apr 2023 05:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Content-Type:MIME-Version:
        Message-ID; bh=nvdgBl4lNnEeq6fDfKYOEpQmnBbGMNRN1Lql4VI6rss=; b=e
        Ta+BFVGIj0EcLt87Zq/sfEae4rj2qoZjuoySLrvLVVvca1HO6s1ceANbUtnzRtjZ
        lWwGJkZAoynhmI0TzT7GI0kxThem3js+fYFwfLphtM/5bwJeXRG0NkoNj58d9FZQ
        uqoaZPBn3cvF3GMquTCyPeTa3kpTUQS47aZMAZv5VU=
Received: from yxj790222$163.com ( [60.247.76.79] ) by ajax-webmail-wmsvr123
 (Coremail) ; Fri, 21 Apr 2023 20:19:26 +0800 (CST)
X-Originating-IP: [60.247.76.79]
Date:   Fri, 21 Apr 2023 20:19:26 +0800 (CST)
From:   =?GBK?B?08jP/r3c?= <yxj790222@163.com>
To:     linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: qlogic_cs: fix irqf_shared, share same irq with
 pcmcia  controller
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20230109(dcb5de15)
 Copyright (c) 2002-2023 www.mailtech.cn 163com
X-NTES-SC: AL_QuyTAPyctk0t4CGYbekXnUoag+s4XsC5u/sk2YFSPZE0niv8/AshU3JxJVLI0vOCACqPvRWJXDtE0tpZV5FlfKPedqTpvq758CDkrt50flx9
Content-Type: multipart/mixed; 
        boundary="----=_Part_91127_13238127.1682079566112"
MIME-Version: 1.0
Message-ID: <7a7202f1.609a.187a3c14920.Coremail.yxj790222@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: e8GowACX1TxOf0Jky7sLAA--.33754W
X-CM-SenderInfo: 510mlmaqssjqqrwthudrp/1tbiMhxYvFWB3db1hAADsn
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

------=_Part_91127_13238127.1682079566112
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: base64

RnJvbSA4MmMxZDBmODgyNDNmOGVkMWZmYWVlYTk4ZDc3NWFiZDU4ODY2YjFiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBZb3UgWGlhb2ppZSA8eXhqNzkwMjIyQDE2My5jb20+CkRhdGU6
IEZyaSwgMjEgQXByIDIwMjMgMTk6MDI6MTUgKzA4MDAKU3ViamVjdDogW1BBVENIXSBxbG9naWNf
Y3M6IGZpeCBpcnFmX3NoYXJlZCwgc2hhcmUgc2FtZSBpcnEgd2l0aCBwY21jaWEKIGNvbnRyb2xs
ZXIKClNpZ25lZC1vZmYtYnk6IFlvdSBYaWFvamllIDx5eGo3OTAyMjJAMTYzLmNvbT4KLS0tCiBk
cml2ZXJzL3Njc2kvcGNtY2lhL3Fsb2dpY19zdHViLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kv
cGNtY2lhL3Fsb2dpY19zdHViLmMgYi9kcml2ZXJzL3Njc2kvcGNtY2lhL3Fsb2dpY19zdHViLmMK
aW5kZXggMzEwZDBiNjU4NmE2Li40ZGJiOTM4NzkwYzIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2Nz
aS9wY21jaWEvcWxvZ2ljX3N0dWIuYworKysgYi9kcml2ZXJzL3Njc2kvcGNtY2lhL3Fsb2dpY19z
dHViLmMKQEAgLTEyMiw3ICsxMjIsNyBAQCBzdGF0aWMgc3RydWN0IFNjc2lfSG9zdCAqcWxvZ2lj
X2RldGVjdChzdHJ1Y3Qgc2NzaV9ob3N0X3RlbXBsYXRlICpob3N0LAogCXByaXYtPnNob3N0ID0g
c2hvc3Q7CiAJcHJpdi0+aW50X3R5cGUgPSBJTlRfVFlQRTsJCQkJCQogCi0JaWYgKHJlcXVlc3Rf
aXJxKHFsaXJxLCBxbG9naWNmYXM0MDhfaWhhbmRsLCAwLCBxbG9naWNfbmFtZSwgc2hvc3QpKQor
CWlmIChyZXF1ZXN0X2lycShxbGlycSwgcWxvZ2ljZmFzNDA4X2loYW5kbCwgSVJRRl9TSEFSRUQs
IHFsb2dpY19uYW1lLCBzaG9zdCkpCiAJCWdvdG8gZnJlZV9zY3NpX2hvc3Q7CiAKIAlzcHJpbnRm
KHByaXYtPnFpbmZvLAotLSAKCgo=
------=_Part_91127_13238127.1682079566112
Content-Type: application/octet-stream; 
	name=0001-qlogic_cs-fix-irqf_shared-share-same-irq-with-pcmcia.patch
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-qlogic_cs-fix-irqf_shared-share-same-irq-with-pcmcia.patch"

RnJvbSA4MmMxZDBmODgyNDNmOGVkMWZmYWVlYTk4ZDc3NWFiZDU4ODY2YjFiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBZb3UgWGlhb2ppZSA8eXhqNzkwMjIyQDE2My5jb20+CkRhdGU6
IEZyaSwgMjEgQXByIDIwMjMgMTk6MDI6MTUgKzA4MDAKU3ViamVjdDogW1BBVENIXSBxbG9naWNf
Y3M6IGZpeCBpcnFmX3NoYXJlZCwgc2hhcmUgc2FtZSBpcnEgd2l0aCBwY21jaWEKIGNvbnRyb2xs
ZXIKClNpZ25lZC1vZmYtYnk6IFlvdSBYaWFvamllIDx5eGo3OTAyMjJAMTYzLmNvbT4KLS0tCiBk
cml2ZXJzL3Njc2kvcGNtY2lhL3Fsb2dpY19zdHViLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kv
cGNtY2lhL3Fsb2dpY19zdHViLmMgYi9kcml2ZXJzL3Njc2kvcGNtY2lhL3Fsb2dpY19zdHViLmMK
aW5kZXggMzEwZDBiNjU4NmE2Li40ZGJiOTM4NzkwYzIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2Nz
aS9wY21jaWEvcWxvZ2ljX3N0dWIuYworKysgYi9kcml2ZXJzL3Njc2kvcGNtY2lhL3Fsb2dpY19z
dHViLmMKQEAgLTEyMiw3ICsxMjIsNyBAQCBzdGF0aWMgc3RydWN0IFNjc2lfSG9zdCAqcWxvZ2lj
X2RldGVjdChzdHJ1Y3Qgc2NzaV9ob3N0X3RlbXBsYXRlICpob3N0LAogCXByaXYtPnNob3N0ID0g
c2hvc3Q7CiAJcHJpdi0+aW50X3R5cGUgPSBJTlRfVFlQRTsJCQkJCQogCi0JaWYgKHJlcXVlc3Rf
aXJxKHFsaXJxLCBxbG9naWNmYXM0MDhfaWhhbmRsLCAwLCBxbG9naWNfbmFtZSwgc2hvc3QpKQor
CWlmIChyZXF1ZXN0X2lycShxbGlycSwgcWxvZ2ljZmFzNDA4X2loYW5kbCwgSVJRRl9TSEFSRUQs
IHFsb2dpY19uYW1lLCBzaG9zdCkpCiAJCWdvdG8gZnJlZV9zY3NpX2hvc3Q7CiAKIAlzcHJpbnRm
KHByaXYtPnFpbmZvLAotLSAKMi40MC4wCgo=
------=_Part_91127_13238127.1682079566112--

