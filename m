Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED51C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 18:34:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76DB320672
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 18:34:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gyVflu1v";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Oj3a+b2x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgGOSea (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 14:34:30 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:4584 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbgGOSe3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 14:34:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594838067; x=1626374067;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aJAto6yulfA2fEAcqtje6fPA91WmUXDlMyM3X1buPoA=;
  b=gyVflu1v9F/fnIPtDWW/oWjKlYkbq9oIc/S5ASzEEmP/5N1tWjZ8vjO1
   4Sv95ghGcDxWGcnTz6Gv1JRXhHprRmw9mvGsR/7geGmJ2QgXP9HtytdIy
   A2p90lXv/DhnP6ICuPmGhYciu6BlcXl5PUG83/TRU+TaIIa629V2TU2pu
   Koj2MTXX1BSCq2APmWd4dL6hnUQN/EsVe42AbZmnwy9MjeiB6rWXJhyl/
   0kwOky1Ep0TdZ6EOLf12Ruwg7KnenEXwHimmDi7SnboTugX9f1PDk1a83
   0FN2NILTisVSP4DZ1xB/vIsFvKnSu4PKqX7jTTE1rurJroVKFG8U//JvQ
   g==;
IronPort-SDR: rHvRiXZgsEc8/wUpQRlpO8CI8NvRmlLVgjJ7ucbx0zOfElgcFdfZTZOds2jxiEruNCq4vlJ/rQ
 p0U7oNtF5SmchRr9Uuyapt7oLHMK2fTY9QwUaDhQXOubpS+fOGmrIonFMkaI5zyDIM6SrSjer0
 zPlJRt1r0OPYJ0aTWF8Mcz4t9p68MZwC7RK1HNGJi1JpLckYu8xUnQkf1Gyu25w6dRcX/39cjG
 eobYC/9u321R9BVJ2JIoBi+xxKGuYJCRhhsShuwkjj/TqBuxfxWNpHzSeUrs72vjMxpNFK+js1
 CW8=
X-IronPort-AV: E=Sophos;i="5.75,356,1589212800"; 
   d="scan'208";a="142537293"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jul 2020 02:34:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IdddXIHNihUAirS7nxEp2hE5x1vUfOGORV2kVFXFc/M3cz95aButQHd90xPTWbuXs6WhlRI4mvRJVIt32+FfjrkJYuvRulA/dMNNFBt19e3LmPmzvRliNK721nt+I9yyUrVHXvZMnHpITh1BKXbw4sDTP1HdNeSgfmJs7Mj2cFcO5ra9c//PRXkhdRVVNBvJMUf1iQ9jD1mj+UqnwZYNCaPYw9xCse+tei5Ax0J+HhQ7b+/d8vevJDZOn1Wz/C1fAUgV3ylBDUFnKQVrl9/ldZC08OMjJ0/JPcLc0Hl5zNbeWqacNuo0Oa1fXQPErEYRUfip9+AWx/u2GtrGbtzHoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJAto6yulfA2fEAcqtje6fPA91WmUXDlMyM3X1buPoA=;
 b=GqXWWotCd/VAs3RzlHhk9niR9x6Xj48F38JmCvKyAvJTloO+7gsEBecpbvDuUP6QTwHG4hfThNrSTr6AFB+MQoCWDoizA6N/DWKIp8za18QOMbnizJIheVB7/2cG4oZfbSuqR0sPJo6YMtLXxXhX2T/b8D0MFdLExRKpLOMjKSKxbfhRFeccLZMQyI5SHoYmmERje3G6ewPoPs6NNdChHZzkjcIjzhcs1dNsavpkJWJC0F+a/SRb+mvPfTqWZG5EGlpCdLzhQ2s/hUdE4Vz13O9OGgO5P3n5Sy7J7+SBDgXyt62AmaG9Zf8HXguxpnDKaEqKliiqxBaQDSOExXs0cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJAto6yulfA2fEAcqtje6fPA91WmUXDlMyM3X1buPoA=;
 b=Oj3a+b2xZgsSeH3zVLr3nSmW84D/KCdaGnJdbkhDNIKhOP4+XjTb531uPeqF0wGdx1SrmLxCjgHsjtd1j3XfISqYX3iwnHmTdclScmjNEKaUrfFgU24rRuCgXLIgqMyRkXbUU5fHlZ3Vfqg+VU6P/8rRQLhNlKtfoo2GRpDgz9Y=
Received: from SN6PR04MB3872.namprd04.prod.outlook.com (2603:10b6:805:50::31)
 by SN6PR04MB4526.namprd04.prod.outlook.com (2603:10b6:805:a8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Wed, 15 Jul
 2020 18:34:23 +0000
Received: from SN6PR04MB3872.namprd04.prod.outlook.com
 ([fe80::f02c:697e:85b2:526b]) by SN6PR04MB3872.namprd04.prod.outlook.com
 ([fe80::f02c:697e:85b2:526b%6]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 18:34:23 +0000
From:   Avi Shchislowski <Avi.Shchislowski@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
Thread-Topic: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
Thread-Index: AQHWWQG2N4YY5117HE6tFmBTUW/alKkI+uYQ
Date:   Wed, 15 Jul 2020 18:34:23 +0000
Message-ID: <SN6PR04MB38720C3D8FC176C3C7FB51B89A7E0@SN6PR04MB3872.namprd04.prod.outlook.com>
References: <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p8>
 <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
In-Reply-To: <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [37.142.4.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 31eeaf3e-dcb6-4661-4099-08d828edb226
x-ms-traffictypediagnostic: SN6PR04MB4526:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB4526F4FCAE4A9FC6B92DFF7F9A7E0@SN6PR04MB4526.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L8Z/j2gbgH588TAozO3m5IHkOt8BImotFNUXVhC5ZUxok/vb3JhPLBOP6TAY+jj6bvYenfKq0R1eaTJC5wBqX0F/RKnuwsotpcnUmEq0G6nU556MbWYZf13HDZK0nz5jpfTjFdEn3JY5v6ZI5C9rc+PWCrBvAL4sJl0diGryJiUdC0ptO8f1/6WuP0pe4vhE7QhtCXWLe9nWeDn6qcHg8v/r/yy5Ogjj/q5bblp2BVMe89hLpoDX8NXCyg7NgW7W1V1b+bYlPqbRZ5mhhvBOgBCZ6L4tZ5+Otl9ThQVfTmg+rDdSVZgCuc/gUylwW8xZrqsjPrbEnhveaxG8kvGFgbI+hH1OMTKqTo/GrmgCHkl9D8TTdt3U5jEE60GWSy26nIPDfQTMZ0wwNMn0dqYBq2jiKmplPa/h29iQ+kCQWf/PI1sLq/n8x8TDTgvqRFc3R6LEPIRvAZPi9X5Vl5aCNg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB3872.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(316002)(966005)(110136005)(54906003)(76116006)(53546011)(9686003)(4326008)(6506007)(55016002)(7696005)(66946007)(83380400001)(66446008)(64756008)(26005)(186003)(66476007)(66556008)(52536014)(5660300002)(478600001)(8936002)(86362001)(71200400001)(7416002)(2906002)(8676002)(33656002)(921003)(36394004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Eu3em5S8zbZKKhvl1PoyBfG7q5dQsOqDgZYH880AV79eVfo27vHEsMLgHAEgWpfHUo+kZRKYDlMWZlkdlcPsQMC9eXXZQ5fRFkq8nQmKgirqLWCHSXRdDZjxZ9DK8KWIa1RB/Idp+9l2RL3GxVFEQU8wrgHomlVs6yaUtSNPnqsbSOWbnDyGzOaL3krOjwAIxG3vQAjoYyO6zA8O+DGwtC3+V8PIGmjZxp37pa2zUADyRKMHkvOs/IOc8vPTtfBlzxg610EGI7+JCOQM+Xs3gjfAARhW5gWSO42ajcxpZlmsprXp348BSpZxSfM0NZh9AYTkLinALNBVCEZALsDnCzbNLgc2/rNUhQUtyjinAXGtjkHSJV/oXCXNYS+k+50BlyrtwjLVvU9zSC/jo58ranHAfZSObDGsU7H89I4POFAmT2DbtsZ2/J6tje/o7+UoxLWksPapRKdEU/TQt/H3HoquBQaeGaO9bXdXynrhyWI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB3872.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31eeaf3e-dcb6-4661-4099-08d828edb226
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2020 18:34:23.2597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xuW5PTgVqmb2yYI6jRM48NBo3J4cex/gwhpMJyUp2FK9JQOWiFIcHz9E8p9k+z3IUtF37wI3b9nNaFIQxsgmZrIpAOmmkGcZkSljKIOqjJE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4526
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGVsbG8gQWxsLA0KTXkgbmFtZSBpcyBBdmkgU2hjaGlzbG93c2tpLCBJIGFtIG1hbmFnaW5nIHRo
ZSBXREMncyBMaW51eCBIb3N0IFImRCB0ZWFtIGluIHdoaWNoIEF2cmkgaXMgYSBtZW1iZXIgb2Yu
DQpBcyB0aGUgcmV2aWV3IHByb2Nlc3Mgb2YgSFBCIGlzIHByb2dyZXNzaW5nIHZlcnkgY29uc3Ry
dWN0aXZlbHksIHdlIGFyZSBnZXR0aW5nIG1vcmUgYW5kIG1vcmUgcmVxdWVzdHMgZnJvbSBPRU1z
LCBJbnF1aXJpbmcgYWJvdXQgSFBCIGluIGdlbmVyYWwsIGFuZCBob3N0IGNvbnRyb2wgbW9kZSBp
biBwYXJ0aWN1bGFyLg0KDQpUaGVpciBtYWluIGNvbmNlcm4gaXMgdGhhdCBIUEIgd2lsbCBtYWtl
IGl0IHRvIDUuOSBtZXJnZSB3aW5kb3csIGJ1dCB0aGUgaG9zdCBjb250cm9sIG1vZGUgcGF0Y2hl
cyB3aWxsIG5vdC4NClRodXMsIGJlY2F1c2Ugb2YgcmVjZW50IEdvb2dsZSdzIEdLSSwgdGhlIG5l
eHQgQW5kcm9pZCBMVFMgbWlnaHQgbm90IGluY2x1ZGUgSFBCIHdpdGggaG9zdCBjb250cm9sIG1v
ZGUuDQoNCkFzaWRlIG9mIHRob3NlIHJlcXVlc3RzLCBpbml0aWFsIGhvc3QgY29udHJvbCBtb2Rl
IHRlc3RpbmcgYXJlIHNob3dpbmcgcHJvbWlzaW5nIHByb3NwZWN0aXZlIHdpdGggcmVzcGVjdCBv
ZiBwZXJmb3JtYW5jZSBnYWluLg0KDQpXaGF0IHdvdWxkIGJlLCBpbiB5b3VyIG9waW5pb24sIHRo
ZSBiZXN0IHBvbGljeSB0aGF0IGhvc3QgY29udHJvbCBtb2RlIGlzIGluY2x1ZGVkIGluIG5leHQg
QW5kcm9pZCBMVFM/DQoNClRoYW5rcywNCkF2aQ0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0t
LQ0KRnJvbTogbGludXgtc2NzaS1vd25lckB2Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LXNjc2ktb3du
ZXJAdmdlci5rZXJuZWwub3JnPiBPbiBCZWhhbGYgT2YgRGFlanVuIFBhcmsNClNlbnQ6IE1vbmRh
eSwgSnVseSAxMywgMjAyMCAxOjM0IFBNDQpUbzogQXZyaSBBbHRtYW4gPEF2cmkuQWx0bWFuQHdk
Yy5jb20+OyBqZWpiQGxpbnV4LmlibS5jb207IG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tOyBh
c3V0b3NoZEBjb2RlYXVyb3JhLm9yZzsgYmVhbmh1b0BtaWNyb24uY29tOyBzdGFubGV5LmNodUBt
ZWRpYXRlay5jb207IGNhbmdAY29kZWF1cm9yYS5vcmc7IGJ2YW5hc3NjaGVAYWNtLm9yZzsgdG9t
YXMud2lua2xlckBpbnRlbC5jb207IEFMSU0gQUtIVEFSIDxhbGltLmFraHRhckBzYW1zdW5nLmNv
bT47IERhZWp1biBQYXJrIDxkYWVqdW43LnBhcmtAc2Ftc3VuZy5jb20+DQpDYzogbGludXgtc2Nz
aUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IFNhbmcteW9v
biBPaCA8c2FuZ3lvb24ub2hAc2Ftc3VuZy5jb20+OyBTdW5nLUp1biBQYXJrIDxzdW5nanVuMDcu
cGFya0BzYW1zdW5nLmNvbT47IHlvbmdteXVuZyBsZWUgPHltaHVuZ3J5LmxlZUBzYW1zdW5nLmNv
bT47IEppbnlvdW5nIENIT0kgPGoteW91bmcuY2hvaUBzYW1zdW5nLmNvbT47IEFkZWwgQ2hvaSA8
YWRlbC5jaG9pQHNhbXN1bmcuY29tPjsgQm9SYW0gU2hpbiA8Ym9yYW0uc2hpbkBzYW1zdW5nLmNv
bT4NClN1YmplY3Q6IFtQQVRDSCB2NiAwLzVdIHNjc2k6IHVmczogQWRkIEhvc3QgUGVyZm9ybWFu
Y2UgQm9vc3RlciBTdXBwb3J0DQoNCkNBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBmcm9t
IG91dHNpZGUgb2YgV2VzdGVybiBEaWdpdGFsLiBEbyBub3QgY2xpY2sgb24gbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bmxlc3MgeW91IHJlY29nbml6ZSB0aGUgc2VuZGVyIGFuZCBrbm93IHRo
YXQgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCg0KDQpDaGFuZ2Vsb2c6DQoNCnY1IC0+IHY2DQpDaGFu
Z2UgYmFzZSBjb21taXQgdG8gYjUzMjkzZmE2NjJlMjhhZTBjZGQ0MDgyOGRjNjQxYzA5ZjEzMzQw
NQ0KDQp2NCAtPiB2NQ0KRGVsZXRlIHVudXNlZCBtYWNybyBkZWZpbmUuDQoNCnYzIC0+IHY0DQox
LiBDbGVhbnVwLg0KDQp2MiAtPiB2Mw0KMS4gQWRkIGNoZWNraW5nIGlucHV0IG1vZHVsZSBwYXJh
bWV0ZXIgdmFsdWUuDQoyLiBDaGFuZ2UgYmFzZSBjb21taXQgZnJvbSA1Ljgvc2NzaS1xdWV1ZSB0
byA1Ljkvc2NzaS1xdWV1ZS4NCjMuIENsZWFudXAgZm9yIHVudXNlZCB2YXJpYWJsZXMgYW5kIGxh
YmVsLg0KDQp2MSAtPiB2Mg0KMS4gQ2hhbmdlIHRoZSBmdWxsIGJvaWxlcnBsYXRlIHRleHQgdG8g
U1BEWCBzdHlsZS4NCjIuIEFkb3B0IGR5bmFtaWMgYWxsb2NhdGlvbiBmb3Igc3ViLXJlZ2lvbiBk
YXRhIHN0cnVjdHVyZS4NCjMuIENsZWFudXAuDQoNCk5BTkQgZmxhc2ggbWVtb3J5LWJhc2VkIHN0
b3JhZ2UgZGV2aWNlcyB1c2UgRmxhc2ggVHJhbnNsYXRpb24gTGF5ZXIgKEZUTCkgdG8gdHJhbnNs
YXRlIGxvZ2ljYWwgYWRkcmVzc2VzIG9mIEkvTyByZXF1ZXN0cyB0byBjb3JyZXNwb25kaW5nIGZs
YXNoIG1lbW9yeSBhZGRyZXNzZXMuIE1vYmlsZSBzdG9yYWdlIGRldmljZXMgdHlwaWNhbGx5IGhh
dmUgUkFNIHdpdGggY29uc3RyYWluZWQgc2l6ZSwgdGh1cyBsYWNrIGluIG1lbW9yeSB0byBrZWVw
IHRoZSB3aG9sZSBtYXBwaW5nIHRhYmxlLg0KVGhlcmVmb3JlLCBtYXBwaW5nIHRhYmxlcyBhcmUg
cGFydGlhbGx5IHJldHJpZXZlZCBmcm9tIE5BTkQgZmxhc2ggb24gZGVtYW5kLCBjYXVzaW5nIHJh
bmRvbS1yZWFkIHBlcmZvcm1hbmNlIGRlZ3JhZGF0aW9uLg0KDQpUbyBpbXByb3ZlIHJhbmRvbSBy
ZWFkIHBlcmZvcm1hbmNlLCBKRVNEMjIwLTMgKEhQQiB2MS4wKSBwcm9wb3NlcyBIUEIgKEhvc3Qg
UGVyZm9ybWFuY2UgQm9vc3Rlcikgd2hpY2ggdXNlcyBob3N0IHN5c3RlbSBtZW1vcnkgYXMgYSBj
YWNoZSBmb3IgdGhlIEZUTCBtYXBwaW5nIHRhYmxlLiBCeSB1c2luZyBIUEIsIEZUTCBkYXRhIGNh
biBiZSByZWFkIGZyb20gaG9zdCBtZW1vcnkgZmFzdGVyIHRoYW4gZnJvbSBOQU5EIGZsYXNoIG1l
bW9yeS4NCg0KVGhlIGN1cnJlbnQgdmVyc2lvbiBvbmx5IHN1cHBvcnRzIHRoZSBEQ00gKGRldmlj
ZSBjb250cm9sIG1vZGUpLg0KVGhpcyBwYXRjaCBjb25zaXN0cyBvZiA0IHBhcnRzIHRvIHN1cHBv
cnQgSFBCIGZlYXR1cmUuDQoNCjEpIFVGUy1mZWF0dXJlIGxheWVyDQoyKSBIUEIgcHJvYmUgYW5k
IGluaXRpYWxpemF0aW9uIHByb2Nlc3MNCjMpIFJFQUQgLT4gSFBCIFJFQUQgdXNpbmcgY2FjaGVk
IG1hcCBpbmZvcm1hdGlvbg0KNCkgTDJQIChsb2dpY2FsIHRvIHBoeXNpY2FsKSBtYXAgbWFuYWdl
bWVudA0KDQpUaGUgVUZTLWZlYXR1cmUgaXMgYW4gYWRkaXRpb25hbCBsYXllciB0byBhdm9pZCB0
aGUgc3RydWN0dXJlIGluIHdoaWNoIHRoZSBVRlMtY29yZSBkcml2ZXIgYW5kIHRoZSBVRlMtZmVh
dHVyZSBhcmUgZW50YW5nbGVkIHdpdGggZWFjaCBvdGhlciBpbiBhIHNpbmdsZSBtb2R1bGUuDQpC
eSBhZGRpbmcgdGhlIGxheWVyLCBVRlMtZmVhdHVyZXMgY29tcG9zZWQgb2YgdmFyaW91cyBjb21i
aW5hdGlvbnMgY2FuIGJlIHN1cHBvcnRlZC4gQWxzbywgZXZlbiBpZiBhIG5ldyBmZWF0dXJlIGlz
IGFkZGVkLCBtb2RpZmljYXRpb24gb2YgdGhlIFVGUy1jb3JlIGRyaXZlciBjYW4gYmUgbWluaW1p
emVkLg0KDQpJbiB0aGUgSFBCIHByb2JlIGFuZCBpbml0IHByb2Nlc3MsIHRoZSBkZXZpY2UgaW5m
b3JtYXRpb24gb2YgdGhlIFVGUyBpcyBxdWVyaWVkLiBBZnRlciBjaGVja2luZyBzdXBwb3J0ZWQg
ZmVhdHVyZXMsIHRoZSBkYXRhIHN0cnVjdHVyZSBmb3IgdGhlIEhQQiBpcyBpbml0aWFsaXplZCBh
Y2NvcmRpbmcgdG8gdGhlIGRldmljZSBpbmZvcm1hdGlvbi4NCg0KQSByZWFkIEkvTyBpbiB0aGUg
YWN0aXZlIHN1Yi1yZWdpb24gd2hlcmUgdGhlIG1hcCBpcyBjYWNoZWQgaXMgY2hhbmdlZCB0byBI
UEIgUkVBRCBieSB0aGUgSFBCIG1vZHVsZS4NCg0KVGhlIEhQQiBtb2R1bGUgbWFuYWdlcyB0aGUg
TDJQIG1hcCB1c2luZyBpbmZvcm1hdGlvbiByZWNlaXZlZCBmcm9tIHRoZSBkZXZpY2UuIEZvciBh
Y3RpdmUgc3ViLXJlZ2lvbiwgdGhlIEhQQiBtb2R1bGUgY2FjaGVzIHRocm91Z2ggdWZzaHBiX21h
cCByZXF1ZXN0LiBGb3IgdGhlIGluLWFjdGl2ZSByZWdpb24sIHRoZSBIUEIgbW9kdWxlIGRpc2Nh
cmRzIHRoZSBMMlAgbWFwLg0KV2hlbiBhIHdyaXRlIEkvTyBvY2N1cnMgaW4gYW4gYWN0aXZlIHN1
Yi1yZWdpb24gYXJlYSwgYXNzb2NpYXRlZCBkaXJ0eSBiaXRtYXAgY2hlY2tlZCBhcyBkaXJ0eSBm
b3IgcHJldmVudGluZyBzdGFsZSByZWFkLg0KDQpIUEIgaXMgc2hvd24gdG8gaGF2ZSBhIHBlcmZv
cm1hbmNlIGltcHJvdmVtZW50IG9mIDU4IC0gNjclIGZvciByYW5kb20gcmVhZCB3b3JrbG9hZC4g
WzFdDQoNClRoaXMgc2VyaWVzIHBhdGNoZXMgYXJlIGJhc2VkIG9uIHRoZSA1Ljkvc2NzaS1xdWV1
ZSBicmFuY2guDQoNClsxXToNCmh0dHBzOi8vd3d3LnVzZW5peC5vcmcvY29uZmVyZW5jZS9ob3Rz
dG9yYWdlMTcvcHJvZ3JhbS9wcmVzZW50YXRpb24vamVvbmcNCg0KRGFlanVuIHBhcmsgKDUpOg0K
IHNjc2k6IHVmczogQWRkIFVGUyBmZWF0dXJlIHJlbGF0ZWQgcGFyYW1ldGVyDQogc2NzaTogdWZz
OiBBZGQgVUZTIGZlYXR1cmUgbGF5ZXINCiBzY3NpOiB1ZnM6IEludHJvZHVjZSBIUEIgbW9kdWxl
DQogc2NzaTogdWZzOiBMMlAgbWFwIG1hbmFnZW1lbnQgZm9yIEhQQiByZWFkDQogc2NzaTogdWZz
OiBQcmVwYXJlIEhQQiByZWFkIGZvciBjYWNoZWQgc3ViLXJlZ2lvbg0KDQogZHJpdmVycy9zY3Np
L3Vmcy9LY29uZmlnICAgICAgfCAgICA5ICsNCiBkcml2ZXJzL3Njc2kvdWZzL01ha2VmaWxlICAg
ICB8ICAgIDMgKy0NCiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy5oICAgICAgICB8ICAgMTIgKw0KIGRy
aXZlcnMvc2NzaS91ZnMvdWZzZmVhdHVyZS5jIHwgIDE0OCArKysNCiBkcml2ZXJzL3Njc2kvdWZz
L3Vmc2ZlYXR1cmUuaCB8ICAgNjkgKysNCiBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jICAgICB8
ICAgMTkgKw0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggICAgIHwgICAgMiArDQogZHJpdmVy
cy9zY3NpL3Vmcy91ZnNocGIuYyAgICAgfCAxOTk3ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKw0KIGRyaXZlcnMvc2NzaS91ZnMvdWZzaHBiLmggICAgIHwgIDIzMiArKysrKw0K
IDkgZmlsZXMgY2hhbmdlZCwgMjQ5MCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pICBjcmVh
dGVkIG1vZGUgMTAwNjQ0IGRyaXZlcnMvc2NzaS91ZnMvdWZzZmVhdHVyZS5jICBjcmVhdGVkIG1v
ZGUgMTAwNjQ0IGRyaXZlcnMvc2NzaS91ZnMvdWZzZmVhdHVyZS5oICBjcmVhdGVkIG1vZGUgMTAw
NjQ0IGRyaXZlcnMvc2NzaS91ZnMvdWZzaHBiLmMgIGNyZWF0ZWQgbW9kZSAxMDA2NDQgZHJpdmVy
cy9zY3NpL3Vmcy91ZnNocGIuaA0K
