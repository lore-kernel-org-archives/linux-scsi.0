Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05426C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 03:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D79972085B
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 03:35:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="iN7IUOpd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgGBDfE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 23:35:04 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:20722 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725857AbgGBDfE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 23:35:04 -0400
X-UUID: 32f0e419367a415bb4c3a376fc4a9b5d-20200702
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=O8tR3m1usHUyKyTLuqtgxgifBOAcJvs4RhW300Axtyc=;
        b=iN7IUOpdM60nFIddzEpaCCTf0nsW6aiHatJa5NusX4xna0sJey4i8wj+Ne9tc3GToHwsd/blN77dU2okKRmPY8QC54FrudvUU0yhKapvfhL6V7Ysx3PLNpPXs38eZC7ywhxc+O1SbWqTBmpSCA0ihkkDcYwYNr+FtvO373DCCB4=;
X-UUID: 32f0e419367a415bb4c3a376fc4a9b5d-20200702
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1812564571; Thu, 02 Jul 2020 11:35:00 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 2 Jul 2020 11:34:51 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 2 Jul 2020 11:34:52 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <bvanassche@acm.org>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [RFC PATCH v2] scsi: ufs: Quiesce all scsi devices before shutdown
Date:   Thu, 2 Jul 2020 11:34:51 +0800
Message-ID: <20200702033451.26635-1-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Q3VycmVudGx5IEkvTyByZXF1ZXN0IGNvdWxkIGJlIHN0aWxsIHN1Ym1pdHRlZCB0byBVRlMgZGV2
aWNlIHdoaWxlDQpVRlMgaXMgd29ya2luZyBvbiBzaHV0ZG93biBmbG93LiBUaGlzIG1heSBsZWFk
IHRvIHJhY2luZyBhcyBiZWxvdw0Kc2NlbmFyaW9zIGFuZCBmaW5hbGx5IHN5c3RlbSBtYXkgY3Jh
c2ggZHVlIHRvIHVuY2xvY2tlZCByZWdpc3Rlcg0KYWNjZXNzZXMuDQoNClRvIGZpeCB0aGlzIGtp
bmQgb2YgaXNzdWVzLCBzcGVjaWZpY2FsbHkgcXVpZXNjZSBhbGwgU0NTSSBkZXZpY2VzDQpiZWZv
cmUgVUZTIHNodXRkb3duIHRvIGJsb2NrIGFsbCBJL08gcmVxdWVzdCBzZW5kaW5nIGZyb20gYmxv
Y2sNCmxheWVyLg0KDQpFeGFtcGxlIG9mIHJhY2luZyBzY2VuYXJpbzogV2hpbGUgVUZTIGRldmlj
ZSBpcyBydW50aW1lLXN1c3BlbmRlZA0KDQpUaHJlYWQgIzE6IEV4ZWN1dGluZyBVRlMgc2h1dGRv
d24gZmxvdywgZS5nLiwNCiAgICAgICAgICAgdWZzaGNkX3N1c3BlbmQoVUZTX1NIVVRET1dOX1BN
KQ0KVGhyZWFkICMyOiBFeGVjdXRpbmcgcnVudGltZSByZXN1bWUgZmxvdyB0cmlnZ2VyZWQgYnkg
SS9PIHJlcXVlc3QsDQogICAgICAgICAgIGUuZy4sIHVmc2hjZF9yZXN1bWUoVUZTX1JVTlRJTUVf
UE0pDQoNClRoaXMgYnJlYWtzIHRoZSBhc3N1bXB0aW9uIHRoYXQgVUZTIFBNIGZsb3dzIGNhbiBu
b3QgYmUgcnVubmluZw0KY29uY3VycmVudGx5IGFuZCBzb21lIHVuZXhwZWN0ZWQgcmFjaW5nIGJl
aGF2aW9yIG1heSBoYXBwZW4uDQoNClNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5
LmNodUBtZWRpYXRlay5jb20+DQotLS0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgMTcg
KysrKysrKysrKysrKysrKysNCiAxIGZpbGUgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKQ0KDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91ZnMv
dWZzaGNkLmMNCmluZGV4IDU5MzU4YmI3NTAxNC4uMThkYTJkNjRmOWZhIDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2Qu
Yw0KQEAgLTg1OTksMTAgKzg1OTksMjcgQEAgRVhQT1JUX1NZTUJPTCh1ZnNoY2RfcnVudGltZV9p
ZGxlKTsNCiBpbnQgdWZzaGNkX3NodXRkb3duKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQogew0KIAlp
bnQgcmV0ID0gMDsNCisJc3RydWN0IHNjc2lfdGFyZ2V0ICpzdGFyZ2V0Ow0KIA0KIAlpZiAoIWhi
YS0+aXNfcG93ZXJlZCkNCiAJCWdvdG8gb3V0Ow0KIA0KKwkvKg0KKwkgKiBRdWllc2NlIGFsbCBT
Q1NJIGRldmljZXMgdG8gcHJldmVudCBhbnkgbm9uLVBNIHJlcXVlc3RzIHNlbmRpbmcNCisJICog
ZnJvbSBibG9jayBsYXllciBkdXJpbmcgYW5kIGFmdGVyIHNodXRkb3duLg0KKwkgKg0KKwkgKiBI
ZXJlIHdlIGNhbiBub3QgdXNlIGJsa19jbGVhbnVwX3F1ZXVlKCkgc2luY2UgUE0gcmVxdWVzdHMN
CisJICogKHdpdGggQkxLX01RX1JFUV9QUkVFTVBUIGZsYWcpIGFyZSBzdGlsbCByZXF1aXJlZCB0
byBiZSBzZW50DQorCSAqIHRocm91Z2ggYmxvY2sgbGF5ZXIuIFRoZXJlZm9yZSBTQ1NJIGNvbW1h
bmQgcXVldWVkIGFmdGVyIHRoZQ0KKwkgKiBzY3NpX3RhcmdldF9xdWllc2NlKCkgY2FsbCByZXR1
cm5lZCB3aWxsIGJsb2NrIHVudGlsDQorCSAqIGJsa19jbGVhbnVwX3F1ZXVlKCkgaXMgY2FsbGVk
Lg0KKwkgKg0KKwkgKiBCZXNpZGVzLCBzY3NpX3RhcmdldF8idW4icXVpZXNjZSAoZS5nLiwgc2Nz
aV90YXJnZXRfcmVzdW1lKSBjYW4NCisJICogYmUgaWdub3JlZCBzaW5jZSBzaHV0ZG93biBpcyBv
bmUtd2F5IGZsb3cuDQorCSAqLw0KKwlsaXN0X2Zvcl9lYWNoX2VudHJ5KHN0YXJnZXQsICZoYmEt
Pmhvc3QtPl9fdGFyZ2V0cywgc2libGluZ3MpDQorCQlzY3NpX3RhcmdldF9xdWllc2NlKHN0YXJn
ZXQpOw0KKw0KIAlpZiAodWZzaGNkX2lzX3Vmc19kZXZfcG93ZXJvZmYoaGJhKSAmJiB1ZnNoY2Rf
aXNfbGlua19vZmYoaGJhKSkNCiAJCWdvdG8gb3V0Ow0KIA0KLS0gDQoyLjE4LjANCg==

