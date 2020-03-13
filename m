Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92CA1C10DCE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 09:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68B942074C
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 09:01:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="iCHsI1XA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgCMJBc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 05:01:32 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:50531 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726443AbgCMJBa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 05:01:30 -0400
X-UUID: ddc50b42c9a24a119135ea4bd5b978f5-20200313
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=5GP+rWEB4Ry+EREqzXdiuDUuJlQ0dpJ3Jx7HxcM2j1c=;
        b=iCHsI1XA9UuKuL8dMTzTrCf5hfz/GttOrkp0YoYuhsm9Kq9RaQbZEv49hEVjc9I2rTsxLOjakGbRlXwajbV8Brt1t85eAzIWslVzJINuiVeLkOEkgjy20DThOJKn2Sv1HZDO41LKOYquYvxLc8jajI6p+ztEaaayV7p9p1M/XSc=;
X-UUID: ddc50b42c9a24a119135ea4bd5b978f5-20200313
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 480071865; Fri, 13 Mar 2020 17:01:22 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 13 Mar 2020 16:58:32 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 13 Mar 2020 17:00:32 +0800
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
Subject: [PATCH v4 3/8] scsi: ufs: use an enum for host capabilities
Date:   Fri, 13 Mar 2020 17:00:58 +0800
Message-ID: <20200313090103.15390-4-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200313090103.15390-1-stanley.chu@mediatek.com>
References: <20200313090103.15390-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 746D601E7189448243DD6ED4F47D36CD3759AD0F6EE8D10DB828FC3623A144642000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VXNlIGFuIGVudW0gdG8gc3BlY2lmeSB0aGUgaG9zdCBjYXBhYmlsaXRpZXMgaW5zdGVhZCBvZiAj
ZGVmaW5lcyBpbnNpZGUgdGhlDQpzdHJ1Y3R1cmUgZGVmaW5pdGlvbi4NCg0KU2lnbmVkLW9mZi1i
eTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NClJldmlld2VkLWJ5OiBB
c3V0b3NoIERhcyA8YXN1dG9zaGRAY29kZWF1cm9yYS5vcmc+DQpSZXZpZXdlZC1ieTogQ2FuIEd1
byA8Y2FuZ0Bjb2RlYXVyb3JhLm9yZz4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgg
fCA2NSArKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0NCiAxIGZpbGUgY2hh
bmdlZCwgMzcgaW5zZXJ0aW9ucygrKSwgMjggZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KaW5k
ZXggNWNmNzlkMjMxOWE2Li5mZWMwMDRjZDgwNTQgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kv
dWZzL3Vmc2hjZC5oDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQpAQCAtNTAxLDYg
KzUwMSw0MyBAQCBlbnVtIHVmc2hjZF9xdWlya3Mgew0KIAlVRlNIQ0RfUVVJUktfQlJPS0VOX1VG
U19IQ0lfVkVSU0lPTgkJPSAxIDw8IDUsDQogfTsNCiANCitlbnVtIHVmc2hjZF9jYXBzIHsNCisJ
LyogQWxsb3cgZHluYW1pYyBjbGsgZ2F0aW5nICovDQorCVVGU0hDRF9DQVBfQ0xLX0dBVElORwkJ
CQk9IDEgPDwgMCwNCisNCisJLyogQWxsb3cgaGliZXJiOCB3aXRoIGNsayBnYXRpbmcgKi8NCisJ
VUZTSENEX0NBUF9ISUJFUk44X1dJVEhfQ0xLX0dBVElORwkJPSAxIDw8IDEsDQorDQorCS8qIEFs
bG93IGR5bmFtaWMgY2xrIHNjYWxpbmcgKi8NCisJVUZTSENEX0NBUF9DTEtfU0NBTElORwkJCQk9
IDEgPDwgMiwNCisNCisJLyogQWxsb3cgYXV0byBia29wcyB0byBlbmFibGVkIGR1cmluZyBydW50
aW1lIHN1c3BlbmQgKi8NCisJVUZTSENEX0NBUF9BVVRPX0JLT1BTX1NVU1BFTkQJCQk9IDEgPDwg
MywNCisNCisJLyoNCisJICogVGhpcyBjYXBhYmlsaXR5IGFsbG93cyBob3N0IGNvbnRyb2xsZXIg
ZHJpdmVyIHRvIHVzZSB0aGUgVUZTIEhDSSdzDQorCSAqIGludGVycnVwdCBhZ2dyZWdhdGlvbiBj
YXBhYmlsaXR5Lg0KKwkgKiBDQVVUSU9OOiBFbmFibGluZyB0aGlzIG1pZ2h0IHJlZHVjZSBvdmVy
YWxsIFVGUyB0aHJvdWdocHV0Lg0KKwkgKi8NCisJVUZTSENEX0NBUF9JTlRSX0FHR1IJCQkJPSAx
IDw8IDQsDQorDQorCS8qDQorCSAqIFRoaXMgY2FwYWJpbGl0eSBhbGxvd3MgdGhlIGRldmljZSBh
dXRvLWJrb3BzIHRvIGJlIGFsd2F5cyBlbmFibGVkDQorCSAqIGV4Y2VwdCBkdXJpbmcgc3VzcGVu
ZCAoYm90aCBydW50aW1lIGFuZCBzdXNwZW5kKS4NCisJICogRW5hYmxpbmcgdGhpcyBjYXBhYmls
aXR5IG1lYW5zIHRoYXQgZGV2aWNlIHdpbGwgYWx3YXlzIGJlIGFsbG93ZWQNCisJICogdG8gZG8g
YmFja2dyb3VuZCBvcGVyYXRpb24gd2hlbiBpdCdzIGFjdGl2ZSBidXQgaXQgbWlnaHQgZGVncmFk
ZQ0KKwkgKiB0aGUgcGVyZm9ybWFuY2Ugb2Ygb25nb2luZyByZWFkL3dyaXRlIG9wZXJhdGlvbnMu
DQorCSAqLw0KKwlVRlNIQ0RfQ0FQX0tFRVBfQVVUT19CS09QU19FTkFCTEVEX0VYQ0VQVF9TVVNQ
RU5EID0gMSA8PCA1LA0KKw0KKwkvKg0KKwkgKiBUaGlzIGNhcGFiaWxpdHkgYWxsb3dzIGhvc3Qg
Y29udHJvbGxlciBkcml2ZXIgdG8gYXV0b21hdGljYWxseQ0KKwkgKiBlbmFibGUgcnVudGltZSBw
b3dlciBtYW5hZ2VtZW50IGJ5IGl0c2VsZiBpbnN0ZWFkIG9mIHdhaXRpbmcNCisJICogZm9yIHVz
ZXJzcGFjZSB0byBjb250cm9sIHRoZSBwb3dlciBtYW5hZ2VtZW50Lg0KKwkgKi8NCisJVUZTSENE
X0NBUF9SUE1fQVVUT1NVU1BFTkQJCQk9IDEgPDwgNiwNCit9Ow0KKw0KIC8qKg0KICAqIHN0cnVj
dCB1ZnNfaGJhIC0gcGVyIGFkYXB0ZXIgcHJpdmF0ZSBzdHJ1Y3R1cmUNCiAgKiBAbW1pb19iYXNl
OiBVRlNIQ0kgYmFzZSByZWdpc3RlciBhZGRyZXNzDQpAQCAtNjUzLDM0ICs2OTAsNiBAQCBzdHJ1
Y3QgdWZzX2hiYSB7DQogCXN0cnVjdCB1ZnNfY2xrX2dhdGluZyBjbGtfZ2F0aW5nOw0KIAkvKiBD
b250cm9sIHRvIGVuYWJsZS9kaXNhYmxlIGhvc3QgY2FwYWJpbGl0aWVzICovDQogCXUzMiBjYXBz
Ow0KLQkvKiBBbGxvdyBkeW5hbWljIGNsayBnYXRpbmcgKi8NCi0jZGVmaW5lIFVGU0hDRF9DQVBf
Q0xLX0dBVElORwkoMSA8PCAwKQ0KLQkvKiBBbGxvdyBoaWJlcmI4IHdpdGggY2xrIGdhdGluZyAq
Lw0KLSNkZWZpbmUgVUZTSENEX0NBUF9ISUJFUk44X1dJVEhfQ0xLX0dBVElORyAoMSA8PCAxKQ0K
LQkvKiBBbGxvdyBkeW5hbWljIGNsayBzY2FsaW5nICovDQotI2RlZmluZSBVRlNIQ0RfQ0FQX0NM
S19TQ0FMSU5HCSgxIDw8IDIpDQotCS8qIEFsbG93IGF1dG8gYmtvcHMgdG8gZW5hYmxlZCBkdXJp
bmcgcnVudGltZSBzdXNwZW5kICovDQotI2RlZmluZSBVRlNIQ0RfQ0FQX0FVVE9fQktPUFNfU1VT
UEVORCAoMSA8PCAzKQ0KLQkvKg0KLQkgKiBUaGlzIGNhcGFiaWxpdHkgYWxsb3dzIGhvc3QgY29u
dHJvbGxlciBkcml2ZXIgdG8gdXNlIHRoZSBVRlMgSENJJ3MNCi0JICogaW50ZXJydXB0IGFnZ3Jl
Z2F0aW9uIGNhcGFiaWxpdHkuDQotCSAqIENBVVRJT046IEVuYWJsaW5nIHRoaXMgbWlnaHQgcmVk
dWNlIG92ZXJhbGwgVUZTIHRocm91Z2hwdXQuDQotCSAqLw0KLSNkZWZpbmUgVUZTSENEX0NBUF9J
TlRSX0FHR1IgKDEgPDwgNCkNCi0JLyoNCi0JICogVGhpcyBjYXBhYmlsaXR5IGFsbG93cyB0aGUg
ZGV2aWNlIGF1dG8tYmtvcHMgdG8gYmUgYWx3YXlzIGVuYWJsZWQNCi0JICogZXhjZXB0IGR1cmlu
ZyBzdXNwZW5kIChib3RoIHJ1bnRpbWUgYW5kIHN1c3BlbmQpLg0KLQkgKiBFbmFibGluZyB0aGlz
IGNhcGFiaWxpdHkgbWVhbnMgdGhhdCBkZXZpY2Ugd2lsbCBhbHdheXMgYmUgYWxsb3dlZA0KLQkg
KiB0byBkbyBiYWNrZ3JvdW5kIG9wZXJhdGlvbiB3aGVuIGl0J3MgYWN0aXZlIGJ1dCBpdCBtaWdo
dCBkZWdyYWRlDQotCSAqIHRoZSBwZXJmb3JtYW5jZSBvZiBvbmdvaW5nIHJlYWQvd3JpdGUgb3Bl
cmF0aW9ucy4NCi0JICovDQotI2RlZmluZSBVRlNIQ0RfQ0FQX0tFRVBfQVVUT19CS09QU19FTkFC
TEVEX0VYQ0VQVF9TVVNQRU5EICgxIDw8IDUpDQotCS8qDQotCSAqIFRoaXMgY2FwYWJpbGl0eSBh
bGxvd3MgaG9zdCBjb250cm9sbGVyIGRyaXZlciB0byBhdXRvbWF0aWNhbGx5DQotCSAqIGVuYWJs
ZSBydW50aW1lIHBvd2VyIG1hbmFnZW1lbnQgYnkgaXRzZWxmIGluc3RlYWQgb2Ygd2FpdGluZw0K
LQkgKiBmb3IgdXNlcnNwYWNlIHRvIGNvbnRyb2wgdGhlIHBvd2VyIG1hbmFnZW1lbnQuDQotCSAq
Lw0KLSNkZWZpbmUgVUZTSENEX0NBUF9SUE1fQVVUT1NVU1BFTkQgKDEgPDwgNikNCiANCiAJc3Ry
dWN0IGRldmZyZXEgKmRldmZyZXE7DQogCXN0cnVjdCB1ZnNfY2xrX3NjYWxpbmcgY2xrX3NjYWxp
bmc7DQotLSANCjIuMTguMA0K

