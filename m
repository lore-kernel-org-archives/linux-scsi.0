Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_BASE64_TEXT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9990BC3F2D7
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 04:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A5B020842
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 04:07:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EIJZZFxh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgCEEHO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Mar 2020 23:07:14 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:16398 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725880AbgCEEHN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2020 23:07:13 -0500
X-UUID: 0a0ef529b8b04c95b797d52c5b137eb3-20200305
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=j4nSuYPozmP9Ve1URoWtgPyLgtJxDtwpFHY2z+VU3bI=;
        b=EIJZZFxhurw7kFeEUrW8BXvW0ObagqSxfqvaKdjmPQGUykDBpb5qPMFRK60zWl5/aYkwDM6NGCfnCVAy0uxsGgZJRmzsyWqCa2HNOBYNELqKt3lXO0HM/XYFr+rtxIhfPV66O0K9pXhXc9APp6g5Vm4G3jvfr9hVysRwuUTGrAg=;
X-UUID: 0a0ef529b8b04c95b797d52c5b137eb3-20200305
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1468726632; Thu, 05 Mar 2020 12:07:07 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 5 Mar 2020 12:05:57 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 5 Mar 2020 12:06:20 +0800
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
Subject: [PATCH v1 2/4] scsi: ufs: use an enum for host capabilities
Date:   Thu, 5 Mar 2020 12:07:02 +0800
Message-ID: <20200305040704.10645-3-stanley.chu@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20200305040704.10645-1-stanley.chu@mediatek.com>
References: <20200305040704.10645-1-stanley.chu@mediatek.com>
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
eTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGRyaXZlcnMv
c2NzaS91ZnMvdWZzaGNkLmggfCA2NSArKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0t
LS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMzcgaW5zZXJ0aW9ucygrKSwgMjggZGVsZXRpb25zKC0p
DQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIGIvZHJpdmVycy9zY3Np
L3Vmcy91ZnNoY2QuaA0KaW5kZXggNGUyMzVjZWY5OWJjLi40OWFkZTFiZmQwODUgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oDQorKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5oDQpAQCAtNTEwLDYgKzUxMCw0MyBAQCBlbnVtIHVmc2hjZF9xdWlya3Mgew0KIAlVRlNI
Q0RfUVVJUktfQlJPS0VOX1VGU19IQ0lfVkVSU0lPTgkJPSAxIDw8IDUsDQogfTsNCiANCitlbnVt
IHVmc2hjZF9jYXBzIHsNCisJLyogQWxsb3cgZHluYW1pYyBjbGsgZ2F0aW5nICovDQorCVVGU0hD
RF9DQVBfQ0xLX0dBVElORwkJCQk9IDEgPDwgMCwNCisNCisJLyogQWxsb3cgaGliZXJiOCB3aXRo
IGNsayBnYXRpbmcgKi8NCisJVUZTSENEX0NBUF9ISUJFUk44X1dJVEhfQ0xLX0dBVElORwkJPSAx
IDw8IDEsDQorDQorCS8qIEFsbG93IGR5bmFtaWMgY2xrIHNjYWxpbmcgKi8NCisJVUZTSENEX0NB
UF9DTEtfU0NBTElORwkJCQk9IDEgPDwgMiwNCisNCisJLyogQWxsb3cgYXV0byBia29wcyB0byBl
bmFibGVkIGR1cmluZyBydW50aW1lIHN1c3BlbmQgKi8NCisJVUZTSENEX0NBUF9BVVRPX0JLT1BT
X1NVU1BFTkQJCQk9IDEgPDwgMywNCisNCisJLyoNCisJICogVGhpcyBjYXBhYmlsaXR5IGFsbG93
cyBob3N0IGNvbnRyb2xsZXIgZHJpdmVyIHRvIHVzZSB0aGUgVUZTIEhDSSdzDQorCSAqIGludGVy
cnVwdCBhZ2dyZWdhdGlvbiBjYXBhYmlsaXR5Lg0KKwkgKiBDQVVUSU9OOiBFbmFibGluZyB0aGlz
IG1pZ2h0IHJlZHVjZSBvdmVyYWxsIFVGUyB0aHJvdWdocHV0Lg0KKwkgKi8NCisJVUZTSENEX0NB
UF9JTlRSX0FHR1IJCQkJPSAxIDw8IDQsDQorDQorCS8qDQorCSAqIFRoaXMgY2FwYWJpbGl0eSBh
bGxvd3MgdGhlIGRldmljZSBhdXRvLWJrb3BzIHRvIGJlIGFsd2F5cyBlbmFibGVkDQorCSAqIGV4
Y2VwdCBkdXJpbmcgc3VzcGVuZCAoYm90aCBydW50aW1lIGFuZCBzdXNwZW5kKS4NCisJICogRW5h
YmxpbmcgdGhpcyBjYXBhYmlsaXR5IG1lYW5zIHRoYXQgZGV2aWNlIHdpbGwgYWx3YXlzIGJlIGFs
bG93ZWQNCisJICogdG8gZG8gYmFja2dyb3VuZCBvcGVyYXRpb24gd2hlbiBpdCdzIGFjdGl2ZSBi
dXQgaXQgbWlnaHQgZGVncmFkZQ0KKwkgKiB0aGUgcGVyZm9ybWFuY2Ugb2Ygb25nb2luZyByZWFk
L3dyaXRlIG9wZXJhdGlvbnMuDQorCSAqLw0KKwlVRlNIQ0RfQ0FQX0tFRVBfQVVUT19CS09QU19F
TkFCTEVEX0VYQ0VQVF9TVVNQRU5EID0gMSA8PCA1LA0KKw0KKwkvKg0KKwkgKiBUaGlzIGNhcGFi
aWxpdHkgYWxsb3dzIGhvc3QgY29udHJvbGxlciBkcml2ZXIgdG8gYXV0b21hdGljYWxseQ0KKwkg
KiBlbmFibGUgcnVudGltZSBwb3dlciBtYW5hZ2VtZW50IGJ5IGl0c2VsZiBpbnN0ZWFkIG9mIHdh
aXRpbmcNCisJICogZm9yIHVzZXJzcGFjZSB0byBjb250cm9sIHRoZSBwb3dlciBtYW5hZ2VtZW50
Lg0KKwkgKi8NCisJVUZTSENEX0NBUF9SUE1fQVVUT1NVU1BFTkQJCQk9IDEgPDwgNiwNCit9Ow0K
Kw0KIC8qKg0KICAqIHN0cnVjdCB1ZnNfaGJhIC0gcGVyIGFkYXB0ZXIgcHJpdmF0ZSBzdHJ1Y3R1
cmUNCiAgKiBAbW1pb19iYXNlOiBVRlNIQ0kgYmFzZSByZWdpc3RlciBhZGRyZXNzDQpAQCAtNjYy
LDM0ICs2OTksNiBAQCBzdHJ1Y3QgdWZzX2hiYSB7DQogCXN0cnVjdCB1ZnNfY2xrX2dhdGluZyBj
bGtfZ2F0aW5nOw0KIAkvKiBDb250cm9sIHRvIGVuYWJsZS9kaXNhYmxlIGhvc3QgY2FwYWJpbGl0
aWVzICovDQogCXUzMiBjYXBzOw0KLQkvKiBBbGxvdyBkeW5hbWljIGNsayBnYXRpbmcgKi8NCi0j
ZGVmaW5lIFVGU0hDRF9DQVBfQ0xLX0dBVElORwkoMSA8PCAwKQ0KLQkvKiBBbGxvdyBoaWJlcmI4
IHdpdGggY2xrIGdhdGluZyAqLw0KLSNkZWZpbmUgVUZTSENEX0NBUF9ISUJFUk44X1dJVEhfQ0xL
X0dBVElORyAoMSA8PCAxKQ0KLQkvKiBBbGxvdyBkeW5hbWljIGNsayBzY2FsaW5nICovDQotI2Rl
ZmluZSBVRlNIQ0RfQ0FQX0NMS19TQ0FMSU5HCSgxIDw8IDIpDQotCS8qIEFsbG93IGF1dG8gYmtv
cHMgdG8gZW5hYmxlZCBkdXJpbmcgcnVudGltZSBzdXNwZW5kICovDQotI2RlZmluZSBVRlNIQ0Rf
Q0FQX0FVVE9fQktPUFNfU1VTUEVORCAoMSA8PCAzKQ0KLQkvKg0KLQkgKiBUaGlzIGNhcGFiaWxp
dHkgYWxsb3dzIGhvc3QgY29udHJvbGxlciBkcml2ZXIgdG8gdXNlIHRoZSBVRlMgSENJJ3MNCi0J
ICogaW50ZXJydXB0IGFnZ3JlZ2F0aW9uIGNhcGFiaWxpdHkuDQotCSAqIENBVVRJT046IEVuYWJs
aW5nIHRoaXMgbWlnaHQgcmVkdWNlIG92ZXJhbGwgVUZTIHRocm91Z2hwdXQuDQotCSAqLw0KLSNk
ZWZpbmUgVUZTSENEX0NBUF9JTlRSX0FHR1IgKDEgPDwgNCkNCi0JLyoNCi0JICogVGhpcyBjYXBh
YmlsaXR5IGFsbG93cyB0aGUgZGV2aWNlIGF1dG8tYmtvcHMgdG8gYmUgYWx3YXlzIGVuYWJsZWQN
Ci0JICogZXhjZXB0IGR1cmluZyBzdXNwZW5kIChib3RoIHJ1bnRpbWUgYW5kIHN1c3BlbmQpLg0K
LQkgKiBFbmFibGluZyB0aGlzIGNhcGFiaWxpdHkgbWVhbnMgdGhhdCBkZXZpY2Ugd2lsbCBhbHdh
eXMgYmUgYWxsb3dlZA0KLQkgKiB0byBkbyBiYWNrZ3JvdW5kIG9wZXJhdGlvbiB3aGVuIGl0J3Mg
YWN0aXZlIGJ1dCBpdCBtaWdodCBkZWdyYWRlDQotCSAqIHRoZSBwZXJmb3JtYW5jZSBvZiBvbmdv
aW5nIHJlYWQvd3JpdGUgb3BlcmF0aW9ucy4NCi0JICovDQotI2RlZmluZSBVRlNIQ0RfQ0FQX0tF
RVBfQVVUT19CS09QU19FTkFCTEVEX0VYQ0VQVF9TVVNQRU5EICgxIDw8IDUpDQotCS8qDQotCSAq
IFRoaXMgY2FwYWJpbGl0eSBhbGxvd3MgaG9zdCBjb250cm9sbGVyIGRyaXZlciB0byBhdXRvbWF0
aWNhbGx5DQotCSAqIGVuYWJsZSBydW50aW1lIHBvd2VyIG1hbmFnZW1lbnQgYnkgaXRzZWxmIGlu
c3RlYWQgb2Ygd2FpdGluZw0KLQkgKiBmb3IgdXNlcnNwYWNlIHRvIGNvbnRyb2wgdGhlIHBvd2Vy
IG1hbmFnZW1lbnQuDQotCSAqLw0KLSNkZWZpbmUgVUZTSENEX0NBUF9SUE1fQVVUT1NVU1BFTkQg
KDEgPDwgNikNCiANCiAJc3RydWN0IGRldmZyZXEgKmRldmZyZXE7DQogCXN0cnVjdCB1ZnNfY2xr
X3NjYWxpbmcgY2xrX3NjYWxpbmc7DQotLSANCjIuMTguMA0K

