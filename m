Return-Path: <SRS0=HoCN=7I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C453AC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 06:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9381C207CB
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 06:15:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AiEeSq0g";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="RAvW8gEh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgEZGPu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 02:15:50 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:15154 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbgEZGPt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 02:15:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590473747; x=1622009747;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HqokLzC4hDoDVjIbf1+5JFXJSDOpcInRtpbVntEiK58=;
  b=AiEeSq0geElRQ5DqbWNAFYGJKOuef4DqA7Hdd0hsZiGz/m8MOIBZ8zjb
   DD/r1hkWD35CsHV8Tn3M3jMDEvopslmB8mr5d65mFlj+8t7OAq+VTWmvR
   F/NI9XI9by7ixGCHc/RDsNid8oSvXW6cJ71aFgQNXh5na8MgoVnDX1pcI
   ZY8fGV+iSDOfVwjy6PP2dxdBMWKuNZkS6a47lgrNeL2ZJROifOE5e1KWk
   PaWsp29stUZceVzUSZ5EDdvoVOUH4SXSyNKzkQ15JNR/NKzc0nPd0Ql5E
   ZWataswBIE0p20ehmTDdZzwHoOr6uPtAj5i2iRLby5PQaKADEY4/tqbuP
   A==;
IronPort-SDR: QxRFRzZSXwMw1Rd8qvvKqUVor50nxo5kQ/64TvY+gvUvj5bCYTnNKOrZ/ur73R0X4nHShjhQ7D
 6k2TiIEt/EXL86IIVhr0gFgZUPBFaEDkcGxTeIQPcAmZFCF9xxGJG9qHqHU0oKgmGAS/pnw/67
 qEObYbiyanSTkVoz106El/cJXl8a7NSRJ8Tg26nzb8mgBvEYS2laEUVog+704OCGupuwCL93lh
 FkblbUCM45zYPNow1B1MqR7EsFxVgxYqaF+43MELbXZuEJ3dnDh18wXWNYVUUXd/PFUP2Ecn0Y
 BT4=
X-IronPort-AV: E=Sophos;i="5.73,436,1583164800"; 
   d="scan'208";a="138503062"
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.172])
  by ob1.hgst.iphmx.com with ESMTP; 26 May 2020 14:15:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OiJBXo4QC3XIrKKjOwrt3sr1XiuyMK2OD51tsRx8iGm3uwkF30v0PbjLJOkeqsvLYKUvXrxoh9o7kEsuBnBPxHlADg9dECK5CK0eWU5F5cqAZQ5j+SGxpoVtyDI4P5Jygq8lQ7xh4AaWKmJ8Cq05z5+VJ9Why0HKQSsyc5ROGINo9fDligV1e18w669btzMbruzeSAkFAoCxGSdWyWhLyTbhSyVG2gP2+EzOn6EJjfTFoNYfLv8HB+RudKeGmrme2OfRcQctSr7Ru1Lx4VFGN6G2ZdX9HGzXnHAvhsa8JZIgR9BOITKZYu9SB6ZMLLrVN3aVeLDPJcsOf4YiPxiu5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HqokLzC4hDoDVjIbf1+5JFXJSDOpcInRtpbVntEiK58=;
 b=mQsANp4jsWHVv2qlzUVoHXv6rxQWEN7hFbollK+UaSxoJaJHbilCjn+G/glBaGXPy2ksn+6Pi0bYDzQtlU3WNQx15wXIwsEYbVEm9s8UN29g2pSI8Gre3L6u6ejOsWVseUqRZHqGNQljkjN2dBZxbtIsfRWwU0c3b3MpXRKEQceEQAA7ICEPE64A0wIifSQJDZUw/ggKPm1YUqEoqvW7wIUdp7HNNvN9GdyJGTp2fBAgqzUusvB8rWJwz0k03kKU6ahcIBv/jmh2E7KRaK7NiS+QlwVyJIjwt/S/KcLTE0/Uk0ULTiBGSArIpo9alTwq0jAjk1C1Bb0q83pxKNP2JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HqokLzC4hDoDVjIbf1+5JFXJSDOpcInRtpbVntEiK58=;
 b=RAvW8gEh21FbNvdleeemMr88BMxfTV1TtFmcZcGX1dcDq7Nzu50OEO6XKnoExH1HdOW8/WxcwR0XHAfepSwflr8T91uT/G7bxSo+uCdNIpGk/mqZcrVFVaYDQ2NHREoWRvdV1A+LoYd2VwuZMk9dRhR5u/YjWjNe6iyc7s7TXRE=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4432.namprd04.prod.outlook.com (2603:10b6:805:33::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Tue, 26 May
 2020 06:15:37 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 06:15:37 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>
Subject: RE: Another approach of UFSHPB
Thread-Topic: Another approach of UFSHPB
Thread-Index: AQHWLi/ZJIgJKMJKI0iqt61IMTjbaqi0VZyAgAP8IICAAJtZAIAA/5Jw
Date:   Tue, 26 May 2020 06:15:37 +0000
Message-ID: <SN6PR04MB46400AED930A3DC5B94AED25FCB00@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <aaf130c2-27bd-977b-55df-e97859f4c097@acm.org>
 <835c57b9-f792-2460-c3cc-667031969d63@acm.org>
 <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
 <d10b27f1-49ec-d092-b252-2bb8cdc4c66e@acm.org>
 <SN6PR04MB46408050B71E3A6225D6C495FCBA0@SN6PR04MB4640.namprd04.prod.outlook.com>
 <231786897.01589928601376.JavaMail.epsvc@epcpadp1>
 <CGME20200516171420epcas2p108c570904c5117c3654d71e0a2842faa@epcms2p4>
 <231786897.01590385382061.JavaMail.epsvc@epcpadp2>
 <6eec7c64-d4c1-c76e-5c14-7904a8792275@acm.org>
In-Reply-To: <6eec7c64-d4c1-c76e-5c14-7904a8792275@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f9df2c23-70de-4879-cd97-08d8013c3511
x-ms-traffictypediagnostic: SN6PR04MB4432:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB4432C0655C136417158B9848FCB00@SN6PR04MB4432.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 041517DFAB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mgjdUEDVEqdCPMLqcv6pT+8gnh2awgoQVvfUrFMS2aO5sw1G3zhFvVFpyHPPGlmd0XRiMGkuKm6ZMwThYxdd0Z4bblISVzxAWpEcgRzbRNWfvz2tWKvxfQOpr+6jZ7nyWCVqMksY0ugJI6HpQ1y5gwhMR26yuxRd+dMdCeHwt79gv2CYzWmeBRDUgvD4JRQs1j7cNuENtoxbxDwAO/CqMeqzwMSqOCfPUi9jsT+1SrzDwY7Ws4eN71Oa5WF5F9wJrg4H7qt+nJ1kVQATTa+bzS0m5dy44pNPmezpeDKEMxSrC+fjtYijvXZpIJbMUuGJ5oxiE6DOPe5q3p0a79zWgJ8Vsz/zBH18+31wiGvHG+jE4g5QeANqoeWPbh+4KqK0iOj7TN1Owmxp91wVoErUTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(8936002)(3480700007)(55016002)(66946007)(66446008)(9686003)(8676002)(26005)(110136005)(6506007)(5660300002)(54906003)(33656002)(76116006)(7696005)(66476007)(316002)(66556008)(53546011)(64756008)(478600001)(4326008)(71200400001)(2906002)(86362001)(7416002)(186003)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: XAFtSPt16/fq4xGx+ECbHiyQlBa0yYtqHZp4uhI4HzOJUoM4r+0lGjSEAV3fZ/Df9dqbxct0csVZx+fPKAT/lSVQ6qMiRnUZ7j2Cuj78/gqBK5KV7xsM+/VghN1aPw/xpS/d9jzQ3+EeqKlxdwpRhOPTf4yjC/IuxvBtdArgdd2kHrf+Mikn1XzylgM+mUdWMcIqCpKla9BxnbteV+98v6SDQnwWuooAgVjTYSMCvulIPHMK7MlI0LMtMHiv34mV6xJo31O082/FmjA7QZ0bTSoB5u8NI5WPPO8nmmbGYX7IN9Nav8+qGke1652XnN8th/QweR+ZKr9NEok4j+JPPo+K8FdrZJAk6FQ4tkRNJnO/znJmrY+EZMuxy1sV/h0LBR5p7xY0kFpMzzpTnd+0Lpi2yotWLfvwPfjjb+DU4vb8DkqIY0baUYsIC9o7q7l50Zsxo39Txq0T7oioQISiF8OiTwuUDTmlp63S9SxtNho=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9df2c23-70de-4879-cd97-08d8013c3511
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2020 06:15:37.1357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /q7BWgEi6E8Hvbn+BoNejq0gO9QmA7mjEYFERWCo1A39cmhrvS+259ZXO1/yONFFcZLfkQoRNuOeMiYyYcCU3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4432
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBPbiAyMDIwLTA1LTI0IDIyOjQwLCBEYWVqdW4gUGFyayB3cm90ZToNCj4gPiBUaGUgSFBCIGRy
aXZlciBpcyBjbG9zZSB0byB0aGUgVUZTIGNvcmUgZnVuY3Rpb24sIGJ1dCBpdCBpcyBub3QgZXNz
ZW50aWFsDQo+ID4gZm9yIG9wZXJhdGluZyBVRlMgZGV2aWNlLiBXaXRoIHJlZmVyZW5jZSB0byB0
aGlzIGFydGljbGUNCj4gPiAoaHR0cHM6Ly9sd24ubmV0L0FydGljbGVzLzY0NTgxMC8pLCB3ZSBp
bXBsZW1lbnRlZCBleHRlbmRlZCBVRlMtZmVhdHVyZQ0KPiA+IGFzIGJ1cyBtb2RlbC4gQmVjYXVz
ZSB0aGUgSFBCIGRyaXZlciBjb25zdW1lcyB0aGUgdXNlcidzIG1haW4gbWVtb3J5LCBpdA0KPiBz
aG91bGQNCj4gPiBzdXBwb3J0IGJpbmQgLyB1bmJpbmQgZnVuY3Rpb25hbGl0eSBhcyBuZWVkZWQu
IFdlIGltcGxlbWVudGVkIHRoZSBIUEINCj4gZHJpdmVyDQo+ID4gY2FuIGJlIHVuYmluZCAvIHVu
bG9hZCBvbiBydW50aW1lLg0KPiANCj4gSSBkbyBub3QgYWdyZWUgdGhhdCB0aGUgYnVzIG1vZGVs
IGlzIHRoZSBiZXN0IGNob2ljZSBmb3IgZnJlZWluZyBjYWNoZQ0KPiBtZW1vcnkgaWYgaXQgaXMg
bm8gbG9uZ2VyIG5lZWRlZC4gQSBzaHJpbmtlciBpcyBwcm9iYWJseSBhIG11Y2ggYmV0dGVyDQo+
IGNob2ljZSBiZWNhdXNlIHRoZSBjYWxsYmFjayBmdW5jdGlvbnMgaW4gYSBzaHJpbmtlciBnZXQg
aW52b2tlZCB3aGVuIGENCj4gc3lzdGVtIGlzIHVuZGVyIG1lbW9yeSBwcmVzc3VyZS4gU2VlIGFs
c28gcmVnaXN0ZXJfc2hyaW5rZXIoKSwNCj4gdW5yZWdpc3Rlcl9zaHJpbmtlcigpIGFuZCBzdHJ1
Y3Qgc2hyaW5rZXIgaW4gaW5jbHVkZS9saW51eC9zaHJpbmtlci5oLg0KU2luY2UgdGhpcyBkaXNj
dXNzaW9uIGlzIGNsb3NlbHkgcmVsYXRlZCB0byBjYWNoZSBhbGxvY2F0aW9uLA0KV2hhdCBpcyB5
b3VyIG9waW5pb24gYWJvdXQgYWxsb2NhdGluZyB0aGUgcGFnZXMgZHluYW1pY2FsbHkgYXMgdGhl
IHJlZ2lvbnMNCkFyZSBiZWluZyBhY3RpdmF0ZWQvZGVhY3RpdmF0ZWQsIGluIG9wcG9zZSBvZiBo
b3cgaXQgaXMgZG9uZSB0b2RheSAtIA0KU3RhdGljYWxseSBvbiBpbml0IGZvciB0aGUgZW50aXJl
IG1heC1hY3RpdmUtc3VicmVnaW9ucz8NCg==
