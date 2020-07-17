Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B5D8C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 15:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 068092074B
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 15:54:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HaUxlfks";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Xnd+ckZd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgGQPyl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 11:54:41 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:8538 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgGQPyk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2020 11:54:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595001280; x=1626537280;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Lz2GtEPJu5TGwiNmLadE4cqaixHZacnnSWLWOIVegJw=;
  b=HaUxlfksDz68FsmT/xnTwFhlm1tB2S7PJJvUteHZPI+McRWHVJije2aR
   FrcI6KyTFcmAz3SUdp2ewbylKSFD1wgN4+y5renjn/gnYkKeuS76LEgdU
   tInr6DqSA/YpphBd8LXdy8gnmHZLFolfXPoCsW/MOMYSTSa+7sqz/6qd3
   OaXDdb/oHqSaJxQqS0Y3nQj7GPW3fVIImBgfOhOugecgBh7o//6BEvz6E
   1AfJmwnoc7E0vdB/F1U+FAD3OgkAW3XSodW4FCIqClNrMDZ8TZR+1sKv1
   ETjfdFhsYx3+wOcsRPASsrJ99z4IdtLGjVau2JxSep2LAqWhd7yCq8EOg
   w==;
IronPort-SDR: w7y9XvMvxnkA7p7RejzLX6ZYvgIfOiJUfBYei/v0hc/v05x+X7xrTJxwb6E8DZu7uvhAJUTDBO
 k3IjSjPgU6dOSWvICmI8d+Vwb8VQIBwhnWCx/WRkZze5YGtkH9cae9WVXzFcL6z0ZlzKab4CxY
 P29BU+0E9394bhs3ESCHGJQF68oPptuW7kduLV7NHlPylSBpI1YX9O/5rBdmad2l80XyYYnXj2
 xYumH+zmekin/4oXNC0QfCXzYykxqJP8P90/llvs3KgM6GAz9XZ+nQJ4vXO3yng4gf4S7c1bj3
 YSw=
X-IronPort-AV: E=Sophos;i="5.75,362,1589212800"; 
   d="scan'208";a="142848090"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jul 2020 23:54:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ROHBOYneaxQlRAhwCUHsnlDwYLh3nkvxVWIgxrLEmA0e0eaAcxLFYsXyKQO1BbWJiWGzPNljCkgCX2SsOadxEnQv/pj/7hjWUGp7tEgfcVTAZmo0khs7jtR6P4AxTcHnz1/fz9+43fO4baqMxQDbzFwCUX9+XSP/GdjdFCvU8n36BPpJq4G+VsCSpf/HgDikQAz1xK4KQs7TJ0v0ClpSWmj2dB1XoWfR+KeqRzaBMfaMrnwEQAyuS6SsAoVhTrFSdyXy3R6aLzvvMmZw8kCfeE3GuBmfisanlIu3EUBrKbYkc+WU3yDjfBpyfticjToid1GUBWRnmrk3A/PR/S3YBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lz2GtEPJu5TGwiNmLadE4cqaixHZacnnSWLWOIVegJw=;
 b=Q4kK8knLp+2wpNOnFvTUcPA2DvzJ+aZ0dP7kQL+xTyBW23wUvGiTWfiJGVwdWpK4V5xJRgUzM5m/+zIuxoAEDbQ68rAD/PXfSF0UAm0v9eBsNeLbRgJ9qYqWqbmuzvpNrGWNqLTZFLyYwLC3JGu2O8kl3yEI14lMf3L3Xfk3A8AQAu1RmlwfqaS7NDkOrZvQ6Y5HYn7l69HsHSFnr0Or0imRDi4ttzbrl6SywzBRRwPSQVhMVq6p4/X+GO6ZVNXPeJBCY55rerIVihobnfTP/eYvAPgxdkDMejSX31al92C61bI9pmfthzpSBeO5oeiLs4BVUhQYNFuAQ5SGGhdbtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lz2GtEPJu5TGwiNmLadE4cqaixHZacnnSWLWOIVegJw=;
 b=Xnd+ckZd+sEU6OkRakBl0G8v4BX0CnllbnctMzexKIkbDfuU0Vggos1mwvmgb1aRUfDVwhl9TgBUJ6SbPregGs8ooqVHd+CMZDYJKpOyjo4b81b0QnPePHeV36O5+MNRUQlTbUJmqi6fQLu/+zvLYgi4M+fooNDP+2elKeJOyVQ=
Received: from SN6PR04MB3872.namprd04.prod.outlook.com (2603:10b6:805:50::31)
 by SN6PR04MB3790.namprd04.prod.outlook.com (2603:10b6:805:4e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 17 Jul
 2020 15:54:36 +0000
Received: from SN6PR04MB3872.namprd04.prod.outlook.com
 ([fe80::f02c:697e:85b2:526b]) by SN6PR04MB3872.namprd04.prod.outlook.com
 ([fe80::f02c:697e:85b2:526b%6]) with mapi id 15.20.3174.026; Fri, 17 Jul 2020
 15:54:36 +0000
From:   Avi Shchislowski <Avi.Shchislowski@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        'Bart Van Assche' <bvanassche@acm.org>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        'Sang-yoon Oh' <sangyoon.oh@samsung.com>,
        'Sung-Jun Park' <sungjun07.park@samsung.com>,
        'yongmyung lee' <ymhungry.lee@samsung.com>,
        'Jinyoung CHOI' <j-young.choi@samsung.com>,
        'Adel Choi' <adel.choi@samsung.com>,
        'BoRam Shin' <boram.shin@samsung.com>
Subject: RE: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
Thread-Topic: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
Thread-Index: AQHWWQG2N4YY5117HE6tFmBTUW/alKkI+uYQgAB3mwCAAItIQIAAcSuAgAGDzgA=
Date:   Fri, 17 Jul 2020 15:54:35 +0000
Message-ID: <SN6PR04MB3872EF1315A288E6A7064E359A7C0@SN6PR04MB3872.namprd04.prod.outlook.com>
References: <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p8>
        <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
        <SN6PR04MB38720C3D8FC176C3C7FB51B89A7E0@SN6PR04MB3872.namprd04.prod.outlook.com>
        <4174fcf4-73ec-8e3f-90a5-1e7584e3e2d0@acm.org>
        <SN6PR04MB3872FBE1EAE3578BFD2601189A7F0@SN6PR04MB3872.namprd04.prod.outlook.com>
 <001301d65b90$8012c3e0$80384ba0$@samsung.com>
In-Reply-To: <001301d65b90$8012c3e0$80384ba0$@samsung.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [37.142.4.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cd924858-2c37-4148-b790-08d82a69b48d
x-ms-traffictypediagnostic: SN6PR04MB3790:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB3790DE12F1FE8F970D6D04549A7C0@SN6PR04MB3790.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LvDdTK5Ym4fLM0V+Fvx00BfJJXqLnxla/40MUZiPemw+Mon97FqttdLWZxFqa4jHa5ib/Bbuq4kOlzXPG+7iCdPr1Jx2Rc8Xt9OiPbwuMDA4qjQI+1qPtc2s1w01KTNSLNAHVGSybm5Le/y9r0O9NBvFElbMi8Opicz/H+9gB4u2r6MeMcdmgFxtFLfkKnTCAdMX4e6DOv0YnoKkpsTETpP8oHYvA4uB+hDVtrOmOd1Kut49Ou2rfsDdAwySnkl3nSpa6OKHJOiKLoMtCRfa5oK5GCszh3DyCAJrcjksVOeZ18KdYV6Kj/iTSPfyWWcDHbQ0A4oJ6afjCZMwX3p8f22EeuJCKKhcqVQMs8BuquAM1lqK+HcoEOGxeiCqWGlm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB3872.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(76116006)(66946007)(6506007)(478600001)(86362001)(33656002)(7696005)(54906003)(2906002)(4326008)(53546011)(316002)(83380400001)(110136005)(26005)(8936002)(8676002)(186003)(71200400001)(9686003)(66556008)(66476007)(52536014)(5660300002)(64756008)(55016002)(66446008)(7416002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: fcD5mZgVJU3xUgARVYa0ZAG2tpDPluGqX1yLQ0SayMCN84lA5UggyWS469Bzqqp67ytkM35hNMjxonq0GZ1LsbpI524sXceC3DxnAafDD0EYAJ9Vun4EB8qlQZteKsiKlPlPev3Nhr5ZmzyYCgCQKYa5pDUoU7LuYxaRuxRqlqLG/j1AJL0UCHRwDESzCTxV09nPDF3W5860xL867RK92drOdJ48pa45I86GeFuFSO/OceAfMkTBtJowTBTMTy2ecXemtCdnsxzu87YWmDBzE1oI5qq54l7ZlX59B4Vx8bB9SIf8x7F1O+i+2/MK0WAxdY+dD3avI5DWjjgLhl/xKwCZjIn6VdTGquA1kA5PN8x8BlnbUGLFYpisgi65I9qE1SVHNd8+3gmwR75up2hfn9pCcDgtci4IqS5ItGD1vYtiu3UG8b3S8PZW/M/D7oNctYS5OEbrsKo2fYgmeMcLo5aicMZaLYWVM/zkrmD7LUU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB3872.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd924858-2c37-4148-b790-08d82a69b48d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2020 15:54:36.0325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vk+SbfJqCxQprV9V7WcSEkBFu9U07l5cyv72TCSjHc/HHc89bLjwLU0A5sMiTO1wn2Ucn+Zs697HaulZcAxBCUbCKa7zFo/2nNWwvQoCRHI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3790
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkNClRoYW5rcyB0byBldmVyeW9uZSBmb3IgdGhlIGNsYXJpZmljYXRpb25zDQoNClRoYW5rcywN
CkF2aQ0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbGltIEFraHRhciA8
YWxpbS5ha2h0YXJAc2Ftc3VuZy5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBKdWx5IDE2LCAyMDIw
IDc6NDUgUE0NCj4gVG86IEF2aSBTaGNoaXNsb3dza2kgPEF2aS5TaGNoaXNsb3dza2lAd2RjLmNv
bT47ICdCYXJ0IFZhbiBBc3NjaGUnDQo+IDxidmFuYXNzY2hlQGFjbS5vcmc+OyBkYWVqdW43LnBh
cmtAc2Ftc3VuZy5jb207IEF2cmkgQWx0bWFuDQo+IDxBdnJpLkFsdG1hbkB3ZGMuY29tPjsgamVq
YkBsaW51eC5pYm0uY29tOyBtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbTsNCj4gYXN1dG9zaGRA
Y29kZWF1cm9yYS5vcmc7IGJlYW5odW9AbWljcm9uLmNvbTsNCj4gc3RhbmxleS5jaHVAbWVkaWF0
ZWsuY29tOyBjYW5nQGNvZGVhdXJvcmEub3JnOyB0b21hcy53aW5rbGVyQGludGVsLmNvbQ0KPiBD
YzogbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7ICdTYW5nLXlvb24gT2gnDQo+IDxzYW5neW9vbi5vaEBzYW1zdW5nLmNvbT47ICdTdW5nLUp1
biBQYXJrJw0KPiA8c3VuZ2p1bjA3LnBhcmtAc2Ftc3VuZy5jb20+OyAneW9uZ215dW5nIGxlZScN
Cj4gPHltaHVuZ3J5LmxlZUBzYW1zdW5nLmNvbT47ICdKaW55b3VuZyBDSE9JJyA8ai0NCj4geW91
bmcuY2hvaUBzYW1zdW5nLmNvbT47ICdBZGVsIENob2knIDxhZGVsLmNob2lAc2Ftc3VuZy5jb20+
OyAnQm9SYW0NCj4gU2hpbicgPGJvcmFtLnNoaW5Ac2Ftc3VuZy5jb20+DQo+IFN1YmplY3Q6IFJF
OiBbUEFUQ0ggdjYgMC81XSBzY3NpOiB1ZnM6IEFkZCBIb3N0IFBlcmZvcm1hbmNlIEJvb3N0ZXIg
U3VwcG9ydA0KPiANCj4gQ0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lk
ZSBvZiBXZXN0ZXJuIERpZ2l0YWwuIERvIG5vdCBjbGljayBvbg0KPiBsaW5rcyBvciBvcGVuIGF0
dGFjaG1lbnRzIHVubGVzcyB5b3UgcmVjb2duaXplIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhhdCB0
aGUNCj4gY29udGVudCBpcyBzYWZlLg0KPiANCj4gDQo+IEhpIEF2aSwNCj4gDQo+ID4gLS0tLS1P
cmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiBGcm9tOiBBdmkgU2hjaGlzbG93c2tpIDxBdmkuU2hj
aGlzbG93c2tpQHdkYy5jb20+DQo+ID4gU2VudDogMTYgSnVseSAyMDIwIDE1OjMxDQo+ID4gVG86
IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPjsgZGFlanVuNy5wYXJrQHNhbXN1
bmcuY29tOw0KPiA+IEF2cmkgQWx0bWFuIDxBdnJpLkFsdG1hbkB3ZGMuY29tPjsgamVqYkBsaW51
eC5pYm0uY29tOw0KPiA+IG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tOyBhc3V0b3NoZEBjb2Rl
YXVyb3JhLm9yZzsNCj4gPiBiZWFuaHVvQG1pY3Jvbi5jb207IHN0YW5sZXkuY2h1QG1lZGlhdGVr
LmNvbTsgY2FuZ0Bjb2RlYXVyb3JhLm9yZzsNCj4gPiB0b21hcy53aW5rbGVyQGludGVsLmNvbTsg
QUxJTSBBS0hUQVIgPGFsaW0uYWtodGFyQHNhbXN1bmcuY29tPg0KPiA+IENjOiBsaW51eC1zY3Np
QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gPiBTYW5n
LXlvb24gT2ggPHNhbmd5b29uLm9oQHNhbXN1bmcuY29tPjsgU3VuZy1KdW4gUGFyaw0KPiA+IDxz
dW5nanVuMDcucGFya0BzYW1zdW5nLmNvbT47IHlvbmdteXVuZyBsZWUNCj4gPiA8eW1odW5ncnku
bGVlQHNhbXN1bmcuY29tPjsgSmlueW91bmcgQ0hPSSA8ai0NCj4geW91bmcuY2hvaUBzYW1zdW5n
LmNvbT47DQo+ID4gQWRlbCBDaG9pIDxhZGVsLmNob2lAc2Ftc3VuZy5jb20+OyBCb1JhbSBTaGlu
DQo+IDxib3JhbS5zaGluQHNhbXN1bmcuY29tPg0KPiA+IFN1YmplY3Q6IFJFOiBbUEFUQ0ggdjYg
MC81XSBzY3NpOiB1ZnM6IEFkZCBIb3N0IFBlcmZvcm1hbmNlIEJvb3N0ZXINCj4gPiBTdXBwb3J0
DQo+ID4NCj4gPg0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4g
RnJvbTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+ID4gPiBTZW50OiBU
aHVyc2RheSwgSnVseSAxNiwgMjAyMCA0OjQyIEFNDQo+ID4gPiBUbzogQXZpIFNoY2hpc2xvd3Nr
aSA8QXZpLlNoY2hpc2xvd3NraUB3ZGMuY29tPjsNCj4gPiA+IGRhZWp1bjcucGFya0BzYW1zdW5n
LmNvbTsgQXZyaSBBbHRtYW4gPEF2cmkuQWx0bWFuQHdkYy5jb20+Ow0KPiA+ID4gamVqYkBsaW51
eC5pYm0uY29tOyBtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbTsNCj4gPiA+IGFzdXRvc2hkQGNv
ZGVhdXJvcmEub3JnOyBiZWFuaHVvQG1pY3Jvbi5jb207DQo+ID4gc3RhbmxleS5jaHVAbWVkaWF0
ZWsuY29tOw0KPiA+ID4gY2FuZ0Bjb2RlYXVyb3JhLm9yZzsgdG9tYXMud2lua2xlckBpbnRlbC5j
b207IEFMSU0gQUtIVEFSDQo+ID4gPiA8YWxpbS5ha2h0YXJAc2Ftc3VuZy5jb20+DQo+ID4gPiBD
YzogbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7DQo+ID4gPiBTYW5nLXlvb24gT2ggPHNhbmd5b29uLm9oQHNhbXN1bmcuY29tPjsgU3VuZy1K
dW4gUGFyaw0KPiA+ID4gPHN1bmdqdW4wNy5wYXJrQHNhbXN1bmcuY29tPjsgeW9uZ215dW5nIGxl
ZQ0KPiA+ID4gPHltaHVuZ3J5LmxlZUBzYW1zdW5nLmNvbT47IEppbnlvdW5nIENIT0kgPGotDQo+
ID4geW91bmcuY2hvaUBzYW1zdW5nLmNvbT47DQo+ID4gPiBBZGVsIENob2kgPGFkZWwuY2hvaUBz
YW1zdW5nLmNvbT47IEJvUmFtIFNoaW4NCj4gPiA8Ym9yYW0uc2hpbkBzYW1zdW5nLmNvbT4NCj4g
PiA+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjYgMC81XSBzY3NpOiB1ZnM6IEFkZCBIb3N0IFBlcmZv
cm1hbmNlIEJvb3N0ZXINCj4gPiA+IFN1cHBvcnQNCj4gPiA+DQo+ID4gPiBDQVVUSU9OOiBUaGlz
IGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIFdlc3Rlcm4gRGlnaXRhbC4gRG8NCj4g
PiA+IG5vdCBjbGljayBvbiBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgcmVj
b2duaXplIHRoZQ0KPiA+ID4gc2VuZGVyIGFuZCBrbm93IHRoYXQgdGhlIGNvbnRlbnQgaXMgc2Fm
ZS4NCj4gPiA+DQo+ID4gPg0KPiA+ID4gT24gMjAyMC0wNy0xNSAxMTozNCwgQXZpIFNoY2hpc2xv
d3NraSB3cm90ZToNCj4gPiA+ID4gTXkgbmFtZSBpcyBBdmkgU2hjaGlzbG93c2tpLCBJIGFtIG1h
bmFnaW5nIHRoZSBXREMncyBMaW51eCBIb3N0DQo+ID4gPiA+IFImRCB0ZWFtDQo+ID4gPiBpbiB3
aGljaCBBdnJpIGlzIGEgbWVtYmVyIG9mLg0KPiA+ID4gPiBBcyB0aGUgcmV2aWV3IHByb2Nlc3Mg
b2YgSFBCIGlzIHByb2dyZXNzaW5nIHZlcnkgY29uc3RydWN0aXZlbHksDQo+ID4gPiA+IHdlIGFy
ZSBnZXR0aW5nDQo+ID4gPiBtb3JlIGFuZCBtb3JlIHJlcXVlc3RzIGZyb20gT0VNcywgSW5xdWly
aW5nIGFib3V0IEhQQiBpbiBnZW5lcmFsLA0KPiA+ID4gYW5kIGhvc3QgY29udHJvbCBtb2RlIGlu
IHBhcnRpY3VsYXIuDQo+ID4gPiA+DQo+ID4gPiA+IFRoZWlyIG1haW4gY29uY2VybiBpcyB0aGF0
IEhQQiB3aWxsIG1ha2UgaXQgdG8gNS45IG1lcmdlIHdpbmRvdywNCj4gPiA+ID4gYnV0IHRoZSBo
b3N0DQo+ID4gPiBjb250cm9sIG1vZGUgcGF0Y2hlcyB3aWxsIG5vdC4NCj4gPiA+ID4gVGh1cywg
YmVjYXVzZSBvZiByZWNlbnQgR29vZ2xlJ3MgR0tJLCB0aGUgbmV4dCBBbmRyb2lkIExUUyBtaWdo
dA0KPiA+ID4gPiBub3QgaW5jbHVkZQ0KPiA+ID4gSFBCIHdpdGggaG9zdCBjb250cm9sIG1vZGUu
DQo+ID4gPiA+DQo+ID4gPiA+IEFzaWRlIG9mIHRob3NlIHJlcXVlc3RzLCBpbml0aWFsIGhvc3Qg
Y29udHJvbCBtb2RlIHRlc3RpbmcgYXJlDQo+ID4gPiA+IHNob3dpbmcNCj4gPiA+IHByb21pc2lu
ZyBwcm9zcGVjdGl2ZSB3aXRoIHJlc3BlY3Qgb2YgcGVyZm9ybWFuY2UgZ2Fpbi4NCj4gPiA+ID4N
Cj4gPiA+ID4gV2hhdCB3b3VsZCBiZSwgaW4geW91ciBvcGluaW9uLCB0aGUgYmVzdCBwb2xpY3kg
dGhhdCBob3N0IGNvbnRyb2wNCj4gPiA+ID4gbW9kZSBpcw0KPiA+ID4gaW5jbHVkZWQgaW4gbmV4
dCBBbmRyb2lkIExUUz8NCj4gPiA+DQo+ID4gPiBIaSBBdmksDQo+ID4gPg0KPiA+ID4gQXJlIHlv
dSBwZXJoYXBzIHJlZmVycmluZyB0byB0aGUgSFBCIHBhdGNoIHNlcmllcyB0aGF0IGhhcyBhbHJl
YWR5DQo+ID4gPiBiZWVuDQo+ID4gcG9zdGVkPw0KPiA+ID4gQWx0aG91Z2ggSSdtIG5vdCBzdXJl
IG9mIHRoaXMsIEkgdGhpbmsgdGhhdCB0aGUgU0NTSSBtYWludGFpbmVyDQo+ID4gPiBleHBlY3Rz
IG1vcmUNCj4gPiA+IFJldmlld2VkLWJ5OiBhbmQgVGVzdGVkLWJ5OiB0YWdzLiBIYXMgYW55b25l
IGZyb20gV0RDIGFscmVhZHkgdGFrZW4NCj4gPiA+IHRoZSB0aW1lIHRvIHJldmlldyBhbmQvb3Ig
dGVzdCB0aGlzIHBhdGNoIHNlcmllcz8NCj4gPiA+DQo+ID4gPiBUaGFua3MsDQo+ID4gPg0KPiA+
ID4gQmFydC4NCj4gPg0KPiA+IFllcywgSSBhbSByZWZlcnJpbmcgdG8gdGhlIGN1cnJlbnQgcHJv
cG9zYWwgd2hpY2ggSSBhbSByZXBseWluZyB0bzoNCj4gPiBbUEFUQ0ggdjYgMC81XSBzY3NpOiB1
ZnM6IEFkZCBIb3N0IFBlcmZvcm1hbmNlIEJvb3N0ZXIgU3VwcG9ydCBUaGlzDQo+ID4gcHJvcG9z
YWwgZG9lcyBub3QgY29udGFpbnMgaG9zdCBtb2RlLCBoZW5jZSBvdXIgY3VzdG9tZXJzIGNvbmNl
cm4uDQo+ID4gV2hhdCB3b3VsZCBiZSwgaW4geW91ciBvcGluaW9uLCB0aGUgYmVzdCBwb2xpY3kg
dGhhdCBob3N0IGNvbnRyb2wgbW9kZQ0KPiA+IGlzIGluY2x1ZGVkIGluIG5leHQgQW5kcm9pZCBM
VFMgIGFzc3VtaW5nIGl0IHdpbGwgYmUgYmFzZWQgb24ga2VybmVsIHY1LjkgPw0KPiA+DQo+IFRo
aXMgc2VyaWVzIGhhcyBub3RoaW5nIHRvIGRvIHdpdGggSG9zdCBtb2RlIGNvbnRyb2wsIHRoaXMg
c2VyaWVzIGlzIHRhcmdldGVkIGZvcg0KPiBkZXZpY2UgbW9kZSBjb250cm9sLiBHZW5lcmFsIGNv
bnNlbnN1cyBoZXJlIGlzIHRvIGxhbmQgdGhpcyBzZXJpZXMgYXMgaXQgaXMgKHVubGVzcw0KPiBz
b21lb25lIGhhcyBtb3JlIHJldmlldyBjb21tZW50cykgYW5kIGxldHMgYWRkL2VuaGFuY2Ugd2hh
dGV2ZXIgbmVlZCB0bw0KPiBiZSBkb25lIGZvciBhZGRpbmcgSG9zdCBtb2RlIGNvbnRyb2xzIGFz
IHdlbGwgYXMgb3RoZXIgSFBCMi4wIHJlbGF0ZWQgY2hhbmdlcy4NCj4gDQo+ID4gVGhhbmtzLA0K
PiA+IEF2aQ0KDQo=
