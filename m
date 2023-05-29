Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61483C77B7A
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 07:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbjE2HbJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 03:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjE2Hay (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 03:30:54 -0400
X-Greylist: delayed 906 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 29 May 2023 00:30:50 PDT
Received: from m135.mail.163.com (m135.mail.163.com [220.181.13.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D0D0AB
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2023 00:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Content-Type:MIME-Version:
        Message-ID; bh=5cejVgWI/rmBV4cgvO0DdmyafsCZkok3tJr83AbS5YA=; b=Q
        GmGPtFu6uyH+O5KENGZyaGy3VlR1TbiBsNPQ7uvHGrea6Mf7LtGUxbazaSIA8tv+
        jpemx3IFlv+ViJC8iMsfL+bP8T8AgDzvauLH8KmJHchcBxocKZuk5XLw2zm+Lvxj
        VKzEUinU6HYncKA9pMYipjLXzH9Z2LYMhKIZC/+07I=
Received: from yxj790222$163.com ( [124.126.176.74] ) by ajax-webmail-wmsvr5
 (Coremail) ; Mon, 29 May 2023 15:15:05 +0800 (CST)
X-Originating-IP: [124.126.176.74]
Date:   Mon, 29 May 2023 15:15:05 +0800 (CST)
From:   =?GBK?B?08jP/r3c?= <yxj790222@163.com>
To:     linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: qlogic_cs: fix irqf_shared, share same irq with
 pcmcia  controller
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20230109(dcb5de15)
 Copyright (c) 2002-2023 www.mailtech.cn 163com
X-NTES-SC: AL_QuyTB/+fu00r4yCRbekXnUoag+s4XsC5u/sk2YFSPZE0uCnW3wkaf2FfGVnZzcS9MSGsrgaHSwpl4OVUYrJmfbDqjUKNTWg9vYV9R4bKjGN8
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <57837fce.3209.188665c4d0d.Coremail.yxj790222@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: BcGowAD3u7T5UHRkiQoVAA--.34671W
X-CM-SenderInfo: 510mlmaqssjqqrwthudrp/1tbiQxl+vFc7ekbRVAAAsN
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RnJvbSA4MmMxZDBmODgyNDNmOGVkMWZmYWVlYTk4ZDc3NWFiZDU4ODY2YjFiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBZb3UgWGlhb2ppZSA8eXhqNzkwMjIyQDE2My5jb20+CkRhdGU6
IEZyaSwgMjEgQXByIDIwMjMgMTk6MDI6MTUgKzA4MDAKU3ViamVjdDogW1BBVENIXSBxbG9naWNf
Y3M6IGZpeCBJUlFGX1NIQVJFRAoKU2lnbmVkLW9mZi1ieTogWW91IFhpYW9qaWUgPHl4ajc5MDIy
MkAxNjMuY29tPgotLS0KIGRyaXZlcnMvc2NzaS9wY21jaWEvcWxvZ2ljX3N0dWIuYyB8IDIgKy0K
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc2NzaS9wY21jaWEvcWxvZ2ljX3N0dWIuYyBiL2RyaXZlcnMvc2NzaS9wY21j
aWEvcWxvZ2ljX3N0dWIuYwppbmRleCAzMTBkMGI2NTg2YTYuLjRkYmI5Mzg3OTBjMiAxMDA2NDQK
LS0tIGEvZHJpdmVycy9zY3NpL3BjbWNpYS9xbG9naWNfc3R1Yi5jCisrKyBiL2RyaXZlcnMvc2Nz
aS9wY21jaWEvcWxvZ2ljX3N0dWIuYwpAQCAtMTIyLDcgKzEyMiw3IEBAIHN0YXRpYyBzdHJ1Y3Qg
U2NzaV9Ib3N0ICpxbG9naWNfZGV0ZWN0KHN0cnVjdCBzY3NpX2hvc3RfdGVtcGxhdGUgKmhvc3Qs
CiAJcHJpdi0+c2hvc3QgPSBzaG9zdDsKIAlwcml2LT5pbnRfdHlwZSA9IElOVF9UWVBFOwkJCQkJ
CiAKLQlpZiAocmVxdWVzdF9pcnEocWxpcnEsIHFsb2dpY2ZhczQwOF9paGFuZGwsIDAsIHFsb2dp
Y19uYW1lLCBzaG9zdCkpCisJaWYgKHJlcXVlc3RfaXJxKHFsaXJxLCBxbG9naWNmYXM0MDhfaWhh
bmRsLCBJUlFGX1NIQVJFRCwgcWxvZ2ljX25hbWUsIHNob3N0KSkKIAkJZ290byBmcmVlX3Njc2lf
aG9zdDsKIAogCXNwcmludGYocHJpdi0+cWluZm8sCi0tIAoKCg==
