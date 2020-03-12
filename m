Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C83C10DCE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 13:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1590206BE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 13:24:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="PyjpsZIQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbgCLNYF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 09:24:05 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:28267 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727411AbgCLNYE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2020 09:24:04 -0400
X-UUID: 380f0d2542664016bd3f581a94ff4175-20200312
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=V0NA4KPO9Qx6CWFwXlXwaAgsNy5l/HosjCAdNi25TcM=;
        b=PyjpsZIQvhTCsIDavHa5LWp3HnhUGTSwoycCKh15fxrCEthEADXatTImVcs0xKKI3N0unqAxUYdOWp9laqS4de3HLpWc9ceGpJtZn9NckNoAKhAxwgR27BkaZF6USBY955amFM5IDwoA11gLpJJF72hXH+OKX10n4F2WadkPIy8=;
X-UUID: 380f0d2542664016bd3f581a94ff4175-20200312
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 488595626; Thu, 12 Mar 2020 21:23:54 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 12 Mar 2020 21:22:24 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 12 Mar 2020 21:21:02 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 3/8] scsi: ufs: use an enum for host capabilities
Date:   Thu, 12 Mar 2020 21:23:45 +0800
Message-ID: <20200312132350.18061-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200312132350.18061-1-stanley.chu@mediatek.com>
References: <20200312132350.18061-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 0BEB4D93DAC092F45A1519B6385E4B70DB87E75A0CB19D3376E0ED452461A4382000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VXNlIGFuIGVudW0gdG8gc3BlY2lmeSB0aGUgaG9zdCBjYXBhYmlsaXRpZXMgaW5zdGVhZCBvZiAj
ZGVmaW5lcyBpbnNpZGUgdGhlDQpzdHJ1Y3R1cmUgZGVmaW5pdGlvbi4NCg0KU2lnbmVkLW9mZi1i
eTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NClJldmlld2VkLWJ5OiBD
YW4gR3VvIDxjYW5nQGNvZGVhdXJvcmEub3JnPg0KLS0tDQogZHJpdmVycy9zY3NpL3Vmcy91ZnNo
Y2QuaCB8IDY1ICsrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLQ0KIDEgZmls
ZSBjaGFuZ2VkLCAzNyBpbnNlcnRpb25zKCspLCAyOCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5o
DQppbmRleCA1Y2Y3OWQyMzE5YTYuLmZlYzAwNGNkODA1NCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
c2NzaS91ZnMvdWZzaGNkLmgNCisrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCkBAIC01
MDEsNiArNTAxLDQzIEBAIGVudW0gdWZzaGNkX3F1aXJrcyB7DQogCVVGU0hDRF9RVUlSS19CUk9L
RU5fVUZTX0hDSV9WRVJTSU9OCQk9IDEgPDwgNSwNCiB9Ow0KIA0KK2VudW0gdWZzaGNkX2NhcHMg
ew0KKwkvKiBBbGxvdyBkeW5hbWljIGNsayBnYXRpbmcgKi8NCisJVUZTSENEX0NBUF9DTEtfR0FU
SU5HCQkJCT0gMSA8PCAwLA0KKw0KKwkvKiBBbGxvdyBoaWJlcmI4IHdpdGggY2xrIGdhdGluZyAq
Lw0KKwlVRlNIQ0RfQ0FQX0hJQkVSTjhfV0lUSF9DTEtfR0FUSU5HCQk9IDEgPDwgMSwNCisNCisJ
LyogQWxsb3cgZHluYW1pYyBjbGsgc2NhbGluZyAqLw0KKwlVRlNIQ0RfQ0FQX0NMS19TQ0FMSU5H
CQkJCT0gMSA8PCAyLA0KKw0KKwkvKiBBbGxvdyBhdXRvIGJrb3BzIHRvIGVuYWJsZWQgZHVyaW5n
IHJ1bnRpbWUgc3VzcGVuZCAqLw0KKwlVRlNIQ0RfQ0FQX0FVVE9fQktPUFNfU1VTUEVORAkJCT0g
MSA8PCAzLA0KKw0KKwkvKg0KKwkgKiBUaGlzIGNhcGFiaWxpdHkgYWxsb3dzIGhvc3QgY29udHJv
bGxlciBkcml2ZXIgdG8gdXNlIHRoZSBVRlMgSENJJ3MNCisJICogaW50ZXJydXB0IGFnZ3JlZ2F0
aW9uIGNhcGFiaWxpdHkuDQorCSAqIENBVVRJT046IEVuYWJsaW5nIHRoaXMgbWlnaHQgcmVkdWNl
IG92ZXJhbGwgVUZTIHRocm91Z2hwdXQuDQorCSAqLw0KKwlVRlNIQ0RfQ0FQX0lOVFJfQUdHUgkJ
CQk9IDEgPDwgNCwNCisNCisJLyoNCisJICogVGhpcyBjYXBhYmlsaXR5IGFsbG93cyB0aGUgZGV2
aWNlIGF1dG8tYmtvcHMgdG8gYmUgYWx3YXlzIGVuYWJsZWQNCisJICogZXhjZXB0IGR1cmluZyBz
dXNwZW5kIChib3RoIHJ1bnRpbWUgYW5kIHN1c3BlbmQpLg0KKwkgKiBFbmFibGluZyB0aGlzIGNh
cGFiaWxpdHkgbWVhbnMgdGhhdCBkZXZpY2Ugd2lsbCBhbHdheXMgYmUgYWxsb3dlZA0KKwkgKiB0
byBkbyBiYWNrZ3JvdW5kIG9wZXJhdGlvbiB3aGVuIGl0J3MgYWN0aXZlIGJ1dCBpdCBtaWdodCBk
ZWdyYWRlDQorCSAqIHRoZSBwZXJmb3JtYW5jZSBvZiBvbmdvaW5nIHJlYWQvd3JpdGUgb3BlcmF0
aW9ucy4NCisJICovDQorCVVGU0hDRF9DQVBfS0VFUF9BVVRPX0JLT1BTX0VOQUJMRURfRVhDRVBU
X1NVU1BFTkQgPSAxIDw8IDUsDQorDQorCS8qDQorCSAqIFRoaXMgY2FwYWJpbGl0eSBhbGxvd3Mg
aG9zdCBjb250cm9sbGVyIGRyaXZlciB0byBhdXRvbWF0aWNhbGx5DQorCSAqIGVuYWJsZSBydW50
aW1lIHBvd2VyIG1hbmFnZW1lbnQgYnkgaXRzZWxmIGluc3RlYWQgb2Ygd2FpdGluZw0KKwkgKiBm
b3IgdXNlcnNwYWNlIHRvIGNvbnRyb2wgdGhlIHBvd2VyIG1hbmFnZW1lbnQuDQorCSAqLw0KKwlV
RlNIQ0RfQ0FQX1JQTV9BVVRPU1VTUEVORAkJCT0gMSA8PCA2LA0KK307DQorDQogLyoqDQogICog
c3RydWN0IHVmc19oYmEgLSBwZXIgYWRhcHRlciBwcml2YXRlIHN0cnVjdHVyZQ0KICAqIEBtbWlv
X2Jhc2U6IFVGU0hDSSBiYXNlIHJlZ2lzdGVyIGFkZHJlc3MNCkBAIC02NTMsMzQgKzY5MCw2IEBA
IHN0cnVjdCB1ZnNfaGJhIHsNCiAJc3RydWN0IHVmc19jbGtfZ2F0aW5nIGNsa19nYXRpbmc7DQog
CS8qIENvbnRyb2wgdG8gZW5hYmxlL2Rpc2FibGUgaG9zdCBjYXBhYmlsaXRpZXMgKi8NCiAJdTMy
IGNhcHM7DQotCS8qIEFsbG93IGR5bmFtaWMgY2xrIGdhdGluZyAqLw0KLSNkZWZpbmUgVUZTSENE
X0NBUF9DTEtfR0FUSU5HCSgxIDw8IDApDQotCS8qIEFsbG93IGhpYmVyYjggd2l0aCBjbGsgZ2F0
aW5nICovDQotI2RlZmluZSBVRlNIQ0RfQ0FQX0hJQkVSTjhfV0lUSF9DTEtfR0FUSU5HICgxIDw8
IDEpDQotCS8qIEFsbG93IGR5bmFtaWMgY2xrIHNjYWxpbmcgKi8NCi0jZGVmaW5lIFVGU0hDRF9D
QVBfQ0xLX1NDQUxJTkcJKDEgPDwgMikNCi0JLyogQWxsb3cgYXV0byBia29wcyB0byBlbmFibGVk
IGR1cmluZyBydW50aW1lIHN1c3BlbmQgKi8NCi0jZGVmaW5lIFVGU0hDRF9DQVBfQVVUT19CS09Q
U19TVVNQRU5EICgxIDw8IDMpDQotCS8qDQotCSAqIFRoaXMgY2FwYWJpbGl0eSBhbGxvd3MgaG9z
dCBjb250cm9sbGVyIGRyaXZlciB0byB1c2UgdGhlIFVGUyBIQ0kncw0KLQkgKiBpbnRlcnJ1cHQg
YWdncmVnYXRpb24gY2FwYWJpbGl0eS4NCi0JICogQ0FVVElPTjogRW5hYmxpbmcgdGhpcyBtaWdo
dCByZWR1Y2Ugb3ZlcmFsbCBVRlMgdGhyb3VnaHB1dC4NCi0JICovDQotI2RlZmluZSBVRlNIQ0Rf
Q0FQX0lOVFJfQUdHUiAoMSA8PCA0KQ0KLQkvKg0KLQkgKiBUaGlzIGNhcGFiaWxpdHkgYWxsb3dz
IHRoZSBkZXZpY2UgYXV0by1ia29wcyB0byBiZSBhbHdheXMgZW5hYmxlZA0KLQkgKiBleGNlcHQg
ZHVyaW5nIHN1c3BlbmQgKGJvdGggcnVudGltZSBhbmQgc3VzcGVuZCkuDQotCSAqIEVuYWJsaW5n
IHRoaXMgY2FwYWJpbGl0eSBtZWFucyB0aGF0IGRldmljZSB3aWxsIGFsd2F5cyBiZSBhbGxvd2Vk
DQotCSAqIHRvIGRvIGJhY2tncm91bmQgb3BlcmF0aW9uIHdoZW4gaXQncyBhY3RpdmUgYnV0IGl0
IG1pZ2h0IGRlZ3JhZGUNCi0JICogdGhlIHBlcmZvcm1hbmNlIG9mIG9uZ29pbmcgcmVhZC93cml0
ZSBvcGVyYXRpb25zLg0KLQkgKi8NCi0jZGVmaW5lIFVGU0hDRF9DQVBfS0VFUF9BVVRPX0JLT1BT
X0VOQUJMRURfRVhDRVBUX1NVU1BFTkQgKDEgPDwgNSkNCi0JLyoNCi0JICogVGhpcyBjYXBhYmls
aXR5IGFsbG93cyBob3N0IGNvbnRyb2xsZXIgZHJpdmVyIHRvIGF1dG9tYXRpY2FsbHkNCi0JICog
ZW5hYmxlIHJ1bnRpbWUgcG93ZXIgbWFuYWdlbWVudCBieSBpdHNlbGYgaW5zdGVhZCBvZiB3YWl0
aW5nDQotCSAqIGZvciB1c2Vyc3BhY2UgdG8gY29udHJvbCB0aGUgcG93ZXIgbWFuYWdlbWVudC4N
Ci0JICovDQotI2RlZmluZSBVRlNIQ0RfQ0FQX1JQTV9BVVRPU1VTUEVORCAoMSA8PCA2KQ0KIA0K
IAlzdHJ1Y3QgZGV2ZnJlcSAqZGV2ZnJlcTsNCiAJc3RydWN0IHVmc19jbGtfc2NhbGluZyBjbGtf
c2NhbGluZzsNCi0tIA0KMi4xOC4wDQo=

