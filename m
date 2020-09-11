Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06930C43461
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 03:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F57521D81
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 03:37:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="tVnjNEDk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbgIKDho (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 23:37:44 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:21927 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725306AbgIKDhn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 23:37:43 -0400
X-UUID: 11c0ecf10e584e54b3cbb8bbe5851728-20200911
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=Q3rQNOBjXLnDvyO+i0Tu0z7EKCOBPItUhlWyNSIm0QM=;
        b=tVnjNEDkftjqmv4NYoZGvasEv0Io5dwKFMTUZNXEvzOgrHpZKxc+zTnk75pFsAPz6HP0J2e2MbB87EjVWnkhozj/AwA08wye2q/ApMXqUikmSjmqSyU+rYc60FgnSW5n8tk4rEt7dJARvDv6LF6i8K3Lsq4qj3N/8EP9K2VUqtY=;
X-UUID: 11c0ecf10e584e54b3cbb8bbe5851728-20200911
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1969438269; Fri, 11 Sep 2020 11:37:39 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 11 Sep 2020 11:37:36 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Sep 2020 11:37:36 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <robh+dt@kernel.org>, <robh@kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <arvin.wang@mediatek.com>,
        <HenryC.Chen@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 0/2] scsi: ufs-mediatek: Support performance mode for inline encryption engine
Date:   Fri, 11 Sep 2020 11:37:33 +0800
Message-ID: <20200911033735.21751-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWFydGluLCBSb2IsIEF2cmksDQoNClRoaXMgc2VyaWVzIGFkZHMgaGlnaC1wZXJmb3JtYW5j
ZSBtb2RlIHN1cHBvcnQgZm9yIE1lZGlhVGVrIFVGUyBpbmxpbmUgZW5jcnlwdGlvbiBlbmdpbmUu
DQpUaGlzIGZlYXR1cmUgaXMgb25seSByZXF1aXJlZCBpbiBzcGVjaWZpYyBwbGF0Zm9ybXMsIGku
ZS4sIE1UODE5MiBzZXJpZXMuDQoNClBsZWFzZSBoZWxwIGNvbnNpZGVyIHRoaXMgcGF0Y2ggc2V0
IGluIGtlcm5lbCB2NS4xMC4NCg0KVGhhbmtzLg0KDQpDaGFuZ2VzIHNpbmNlIHYxOg0KCS0gUmVt
b3ZlIHVubmVjZXNzYXJ5IHByaW50Zi4NCg0KU3RhbmxleSBDaHUgKDIpOg0KICBzY3NpOiB1ZnMt
bWVkaWF0ZWs6IFN1cHBvcnQgcGVyZm9ybWFuY2UgbW9kZSBmb3IgaW5saW5lIGVuY3J5cHRpb24N
CiAgICBlbmdpbmUNCiAgZHQtYmluZGluZ3M6IHVmcy1tZWRpYXRlazogQWRkIG10ODE5Mi11ZnNo
Y2kgY29tcGF0aWJsZSBzdHJpbmcNCg0KIC4uLi9kZXZpY2V0cmVlL2JpbmRpbmdzL3Vmcy91ZnMt
bWVkaWF0ZWsudHh0ICB8ICAgNCArLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzLW1lZGlhdGVrLmMg
ICAgICAgICAgICAgICB8IDE3NiArKysrKysrKysrKysrKysrKy0NCiBkcml2ZXJzL3Njc2kvdWZz
L3Vmcy1tZWRpYXRlay5oICAgICAgICAgICAgICAgfCAgMjIgKysrDQogMyBmaWxlcyBjaGFuZ2Vk
LCAxOTUgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjE4LjANCg==

