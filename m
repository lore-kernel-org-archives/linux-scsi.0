Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FDCDC1975A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 08:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 699D320726
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 08:53:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="hgYogNzu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730318AbgCPIxT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 04:53:19 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:32442 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730179AbgCPIxS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 04:53:18 -0400
X-UUID: f98b1b6840094e58b476221135b3f6b9-20200316
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=8CsnDEoht1HR62sbtRaos/Ikmqwn0aOPwl68cKdnFtk=;
        b=hgYogNzu33RadNeRfecuamvaLpSpCVry2G+IO50Ly0nDbvNH34mkd3wJmv4b29kw/vOVkiCP8i3BfinShrn9KGPQYVovxpZtgNX6nt/nShZYmrDY5dlcPl+dqbAd9IILkV9V+6rZxuEv98eUaTRXE8jJ6gLl4fw0KMVGmCvhz+I=;
X-UUID: f98b1b6840094e58b476221135b3f6b9-20200316
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1411282542; Mon, 16 Mar 2020 16:53:06 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs02n1.mediatek.inc (172.21.101.77) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 16 Mar 2020 16:50:49 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 16 Mar 2020 16:53:52 +0800
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <linux-scsi@vger.kernel.org>, <martin.peter~sen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <matthias.bgg@gmail.com>,
        <bvanassche@acm.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v6 2/7] scsi: ufs: use an enum for host capabilities
Date:   Mon, 16 Mar 2020 16:52:58 +0800
Message-ID: <20200316085303.20350-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200316085303.20350-1-stanley.chu@mediatek.com>
References: <20200316085303.20350-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VXNlIGFuIGVudW0gdG8gc3BlY2lmeSB0aGUgaG9zdCBjYXBhYmlsaXRpZXMgaW5zdGVhZCBvZiAj
ZGVmaW5lcyBpbnNpZGUgdGhlDQpzdHJ1Y3R1cmUgZGVmaW5pdGlvbi4NCg0KU2lnbmVkLW9mZi1i
eTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NClJldmlld2VkLWJ5OiBB
c3V0b3NoIERhcyA8YXN1dG9zaGRAY29kZWF1cm9yYS5vcmc+DQpSZXZpZXdlZC1ieTogQXZyaSBB
bHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQpSZXZpZXdlZC1ieTogQ2FuIEd1byA8Y2FuZ0Bj
b2RlYXVyb3JhLm9yZz4NCi0tLQ0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggfCA2NSArKysr
KysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMzcg
aW5zZXJ0aW9ucygrKSwgMjggZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Nj
c2kvdWZzL3Vmc2hjZC5oIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KaW5kZXggNWMxMDc3
NzE1NGZjLi41MjQyNTM3MTA4MmEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hj
ZC5oDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQpAQCAtNTEwLDYgKzUxMCw0MyBA
QCBlbnVtIHVmc2hjZF9xdWlya3Mgew0KIAlVRlNIQ0RfUVVJUktfQlJPS0VOX1VGU19IQ0lfVkVS
U0lPTgkJPSAxIDw8IDUsDQogfTsNCiANCitlbnVtIHVmc2hjZF9jYXBzIHsNCisJLyogQWxsb3cg
ZHluYW1pYyBjbGsgZ2F0aW5nICovDQorCVVGU0hDRF9DQVBfQ0xLX0dBVElORwkJCQk9IDEgPDwg
MCwNCisNCisJLyogQWxsb3cgaGliZXJiOCB3aXRoIGNsayBnYXRpbmcgKi8NCisJVUZTSENEX0NB
UF9ISUJFUk44X1dJVEhfQ0xLX0dBVElORwkJPSAxIDw8IDEsDQorDQorCS8qIEFsbG93IGR5bmFt
aWMgY2xrIHNjYWxpbmcgKi8NCisJVUZTSENEX0NBUF9DTEtfU0NBTElORwkJCQk9IDEgPDwgMiwN
CisNCisJLyogQWxsb3cgYXV0byBia29wcyB0byBlbmFibGVkIGR1cmluZyBydW50aW1lIHN1c3Bl
bmQgKi8NCisJVUZTSENEX0NBUF9BVVRPX0JLT1BTX1NVU1BFTkQJCQk9IDEgPDwgMywNCisNCisJ
LyoNCisJICogVGhpcyBjYXBhYmlsaXR5IGFsbG93cyBob3N0IGNvbnRyb2xsZXIgZHJpdmVyIHRv
IHVzZSB0aGUgVUZTIEhDSSdzDQorCSAqIGludGVycnVwdCBhZ2dyZWdhdGlvbiBjYXBhYmlsaXR5
Lg0KKwkgKiBDQVVUSU9OOiBFbmFibGluZyB0aGlzIG1pZ2h0IHJlZHVjZSBvdmVyYWxsIFVGUyB0
aHJvdWdocHV0Lg0KKwkgKi8NCisJVUZTSENEX0NBUF9JTlRSX0FHR1IJCQkJPSAxIDw8IDQsDQor
DQorCS8qDQorCSAqIFRoaXMgY2FwYWJpbGl0eSBhbGxvd3MgdGhlIGRldmljZSBhdXRvLWJrb3Bz
IHRvIGJlIGFsd2F5cyBlbmFibGVkDQorCSAqIGV4Y2VwdCBkdXJpbmcgc3VzcGVuZCAoYm90aCBy
dW50aW1lIGFuZCBzdXNwZW5kKS4NCisJICogRW5hYmxpbmcgdGhpcyBjYXBhYmlsaXR5IG1lYW5z
IHRoYXQgZGV2aWNlIHdpbGwgYWx3YXlzIGJlIGFsbG93ZWQNCisJICogdG8gZG8gYmFja2dyb3Vu
ZCBvcGVyYXRpb24gd2hlbiBpdCdzIGFjdGl2ZSBidXQgaXQgbWlnaHQgZGVncmFkZQ0KKwkgKiB0
aGUgcGVyZm9ybWFuY2Ugb2Ygb25nb2luZyByZWFkL3dyaXRlIG9wZXJhdGlvbnMuDQorCSAqLw0K
KwlVRlNIQ0RfQ0FQX0tFRVBfQVVUT19CS09QU19FTkFCTEVEX0VYQ0VQVF9TVVNQRU5EID0gMSA8
PCA1LA0KKw0KKwkvKg0KKwkgKiBUaGlzIGNhcGFiaWxpdHkgYWxsb3dzIGhvc3QgY29udHJvbGxl
ciBkcml2ZXIgdG8gYXV0b21hdGljYWxseQ0KKwkgKiBlbmFibGUgcnVudGltZSBwb3dlciBtYW5h
Z2VtZW50IGJ5IGl0c2VsZiBpbnN0ZWFkIG9mIHdhaXRpbmcNCisJICogZm9yIHVzZXJzcGFjZSB0
byBjb250cm9sIHRoZSBwb3dlciBtYW5hZ2VtZW50Lg0KKwkgKi8NCisJVUZTSENEX0NBUF9SUE1f
QVVUT1NVU1BFTkQJCQk9IDEgPDwgNiwNCit9Ow0KKw0KIC8qKg0KICAqIHN0cnVjdCB1ZnNfaGJh
IC0gcGVyIGFkYXB0ZXIgcHJpdmF0ZSBzdHJ1Y3R1cmUNCiAgKiBAbW1pb19iYXNlOiBVRlNIQ0kg
YmFzZSByZWdpc3RlciBhZGRyZXNzDQpAQCAtNjY0LDM0ICs3MDEsNiBAQCBzdHJ1Y3QgdWZzX2hi
YSB7DQogCXN0cnVjdCB1ZnNfY2xrX2dhdGluZyBjbGtfZ2F0aW5nOw0KIAkvKiBDb250cm9sIHRv
IGVuYWJsZS9kaXNhYmxlIGhvc3QgY2FwYWJpbGl0aWVzICovDQogCXUzMiBjYXBzOw0KLQkvKiBB
bGxvdyBkeW5hbWljIGNsayBnYXRpbmcgKi8NCi0jZGVmaW5lIFVGU0hDRF9DQVBfQ0xLX0dBVElO
RwkoMSA8PCAwKQ0KLQkvKiBBbGxvdyBoaWJlcmI4IHdpdGggY2xrIGdhdGluZyAqLw0KLSNkZWZp
bmUgVUZTSENEX0NBUF9ISUJFUk44X1dJVEhfQ0xLX0dBVElORyAoMSA8PCAxKQ0KLQkvKiBBbGxv
dyBkeW5hbWljIGNsayBzY2FsaW5nICovDQotI2RlZmluZSBVRlNIQ0RfQ0FQX0NMS19TQ0FMSU5H
CSgxIDw8IDIpDQotCS8qIEFsbG93IGF1dG8gYmtvcHMgdG8gZW5hYmxlZCBkdXJpbmcgcnVudGlt
ZSBzdXNwZW5kICovDQotI2RlZmluZSBVRlNIQ0RfQ0FQX0FVVE9fQktPUFNfU1VTUEVORCAoMSA8
PCAzKQ0KLQkvKg0KLQkgKiBUaGlzIGNhcGFiaWxpdHkgYWxsb3dzIGhvc3QgY29udHJvbGxlciBk
cml2ZXIgdG8gdXNlIHRoZSBVRlMgSENJJ3MNCi0JICogaW50ZXJydXB0IGFnZ3JlZ2F0aW9uIGNh
cGFiaWxpdHkuDQotCSAqIENBVVRJT046IEVuYWJsaW5nIHRoaXMgbWlnaHQgcmVkdWNlIG92ZXJh
bGwgVUZTIHRocm91Z2hwdXQuDQotCSAqLw0KLSNkZWZpbmUgVUZTSENEX0NBUF9JTlRSX0FHR1Ig
KDEgPDwgNCkNCi0JLyoNCi0JICogVGhpcyBjYXBhYmlsaXR5IGFsbG93cyB0aGUgZGV2aWNlIGF1
dG8tYmtvcHMgdG8gYmUgYWx3YXlzIGVuYWJsZWQNCi0JICogZXhjZXB0IGR1cmluZyBzdXNwZW5k
IChib3RoIHJ1bnRpbWUgYW5kIHN1c3BlbmQpLg0KLQkgKiBFbmFibGluZyB0aGlzIGNhcGFiaWxp
dHkgbWVhbnMgdGhhdCBkZXZpY2Ugd2lsbCBhbHdheXMgYmUgYWxsb3dlZA0KLQkgKiB0byBkbyBi
YWNrZ3JvdW5kIG9wZXJhdGlvbiB3aGVuIGl0J3MgYWN0aXZlIGJ1dCBpdCBtaWdodCBkZWdyYWRl
DQotCSAqIHRoZSBwZXJmb3JtYW5jZSBvZiBvbmdvaW5nIHJlYWQvd3JpdGUgb3BlcmF0aW9ucy4N
Ci0JICovDQotI2RlZmluZSBVRlNIQ0RfQ0FQX0tFRVBfQVVUT19CS09QU19FTkFCTEVEX0VYQ0VQ
VF9TVVNQRU5EICgxIDw8IDUpDQotCS8qDQotCSAqIFRoaXMgY2FwYWJpbGl0eSBhbGxvd3MgaG9z
dCBjb250cm9sbGVyIGRyaXZlciB0byBhdXRvbWF0aWNhbGx5DQotCSAqIGVuYWJsZSBydW50aW1l
IHBvd2VyIG1hbmFnZW1lbnQgYnkgaXRzZWxmIGluc3RlYWQgb2Ygd2FpdGluZw0KLQkgKiBmb3Ig
dXNlcnNwYWNlIHRvIGNvbnRyb2wgdGhlIHBvd2VyIG1hbmFnZW1lbnQuDQotCSAqLw0KLSNkZWZp
bmUgVUZTSENEX0NBUF9SUE1fQVVUT1NVU1BFTkQgKDEgPDwgNikNCiANCiAJc3RydWN0IGRldmZy
ZXEgKmRldmZyZXE7DQogCXN0cnVjdCB1ZnNfY2xrX3NjYWxpbmcgY2xrX3NjYWxpbmc7DQotLSAN
CjIuMTguMA0K

