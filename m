Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF0AC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 12:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89BB161447
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 12:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbhD2MLy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Apr 2021 08:11:54 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:22930 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbhD2MLx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Apr 2021 08:11:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1619698266; x=1651234266;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XJcfZUmtaz056lRZ4KEDNI2mK6Pw7gfVOPpwp4dnEd8=;
  b=OTvYHWLvwHEfHvdszAkQryyqZXtHmhr2o26buGy9fIdVKelzAN9p9jZT
   k6weQJIJ0z6obB8fsDHQ0Je/GB1Ww5fXhBrn5nVDZ6juiyRVRNUTLLDe2
   1edrY4AcBb6cda3zciPNKFwV0TRgV5wO60cADXr18+Rz1VtYJfhmY5leX
   x8r7WNGAgeuB2bl1aWk5ELwMWUrycJY9iCo9PYUoIxEWozdpaEslVlMxk
   OkQmdUG4ON5zM9JjM/moR+tvuUMjkKRwGOUh/z9lw+ECNpOjo8+Wlxr2V
   rgh0U+v1j7sYIZSEv50AyGBefTFWOfKlWRFsmjq0/Fhobk9Xd0TNXqjU5
   Q==;
IronPort-SDR: sSTF60ms/X8n0gwLsEcQwhHvPORGwBtKl4OdLTj4pnks1WnVS4uOG5w9E+OkvCXMmk+MT9fOh0
 SPmWUnDZktH19FQqxhIBomhPJLBI8LJDV0Pthd4X47wjEHKTTcXN6bKqZ261WIOjXjVl9zYnE4
 9PkWTQcurKZoZUeinp8LNJxBd8YC351WPPwMR7jbe+q6s2NndekYrOpKu5lSs8FZ5Wo0J/wM8m
 0Y8uEwgWuIlAqZNAx8H5Ym/9lUGaY2Irr07FXnxQsIrkCwgtqV9AX870792n45Bpr19XkKTUQU
 M1Y=
X-IronPort-AV: E=Sophos;i="5.82,259,1613404800"; 
   d="scan'208";a="166653982"
Received: from mail-bn7nam10lp2106.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.106])
  by ob1.hgst.iphmx.com with ESMTP; 29 Apr 2021 20:11:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RnCNTxy0rDnvyBzoa9u6U/7H/cIHGp7bNDarPaIQPX3YHYCsDADz0VPGxbmAtZ5xStT2lypBWCa63AvqNnUQcn8U63QIqNFq6yTTrfbQjIBSG6XyXBylNrHR2iYxIUndl3mbuRgtlyk90r0dHjTvVJ3zMFBEJdmNmRKmQv639NJN2yNWDYdx6Az/yIq1qyQCotO7MwFxmYU49MpTrm1MixwaoIrNY3D5GHuakL4YVGwMZGLS0R3PJ5l0aeurwCrqwjZM4ExF2uUSaaQEwJPe4jcnvP3WX9afA1Lje478emCEiDcwdkOau5T615nZ8m7zG6I4mWGn/3kqAtAhP2SDOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJcfZUmtaz056lRZ4KEDNI2mK6Pw7gfVOPpwp4dnEd8=;
 b=MMIcbcAi5h/Gu2vaRiArC/LpfYyNE35ew3WgAiEZ/1LqXU6X0PtfaYZwVZZWs/M1HSlMEgM0lzsA7wzakIkl8b3HKP87hSZT7yVTTzlyCefFCiG2KKSu9HC1M15w4Bti76KUfXpAmcH349TWlXZM68/4lZ/g5JRg0Kh7DVKLEzC7DERc7pCrUvL0MQPS1rEaJXbKwO2x1mhHpBUEybT0V557TTp45QlUmKgxvpRi1I78MggpdISrfINMM32F3CyqjRs4s2QodkfJ+ihFVmoVOi60N/T8fBp1Rxp/3PCj12FFxa0LUmKEPHYRiIhKLOEZ/AIhZVmTBpMJ1bw/XPz0hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJcfZUmtaz056lRZ4KEDNI2mK6Pw7gfVOPpwp4dnEd8=;
 b=pJH8IndA3v217ATrivrKRPgOZKlWJ5Z5ewFGrTWEU8bRwkiXSy47prlS4w6G5wrioRQcvcQzAAgK/4IPzo4Ak2emak8MyeeWigjotsG+DoHyKP3RKSer3ju7lLw0pw0ceJz4rxjbWyfOG+P3OElLL6F3HAVhPa6HlJBHf39cj6I=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1259.namprd04.prod.outlook.com (2603:10b6:4:3d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.25; Thu, 29 Apr 2021 12:11:03 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966%6]) with mapi id 15.20.4087.025; Thu, 29 Apr 2021
 12:11:03 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        Keoseong Park <keosung.park@samsung.com>,
        "lukas.bulwahn@gmail.com" <lukas.bulwahn@gmail.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "satyat@google.com" <satyat@google.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        JinHwan Park <jh.i.park@samsung.com>
Subject: RE: [PATCH v3] scsi: ufs: Add batched WB buffer flush
Thread-Topic: [PATCH v3] scsi: ufs: Add batched WB buffer flush
Thread-Index: AQHXNklm5twCSLGZOUWfgY+XPtSAe6rLcwHQ
Date:   Thu, 29 Apr 2021 12:11:02 +0000
Message-ID: <DM6PR04MB6575A081E212A6ED3F534E12FC5F9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <CGME20210421003815epcms2p7acd6c25a95fdecdfa854964436212cd0@epcms2p7>
 <1891546521.01618966682184.JavaMail.epsvc@epcpadp4>
In-Reply-To: <1891546521.01618966682184.JavaMail.epsvc@epcpadp4>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d3b14b4-08f3-4c4d-9acd-08d90b07dbdc
x-ms-traffictypediagnostic: DM5PR04MB1259:
x-microsoft-antispam-prvs: <DM5PR04MB1259704928757F8404C7987EFC5F9@DM5PR04MB1259.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HHuKbtZf8qyjHdUdp+krd1wmUGZEP6lQVRCardgTt2ww6s/ZbsEsZ013XZk+lw/8lf/CWe0Hg6f0iu1lXkAgwpM4sNiKDjvhiKAmqLZrVGt12y494HyOHtiMuJX7r1rSDyremSINkFl/ACAC+QRqmJLfIBDbz3Ad+YXqeDpZXEiYM4bZD553hCDSNbOypm9CJjK4s3mLKPtiDSPT8hnxB/p2fo1s4ZVHGSVJvsSjD572y+CL5drwuZFpqhT8FSJk6ZE5cq+CHCL/OJOrGf7dCU1YyvkFTteU5eqjwXWosgepnst1BlROeRnqeYuuh6m3GVgkvVZwuQZCGr1Ag/XtHr3Z/utqDODZ8x4kmsybnJTbfHJgsFrrA+37i6xoK2xpVgFy3cVdGp/hH1EADxdCJDDbuno0Y8VyOKdfihNjwVNuQiGVVOx9wu8UiaIXmtLMHj0QBR3aZzltfl7lGCD32tdzAA4REmdytISvhPZPvcgiLpTNF//bMt/WcoGfOp0Fl4gewyg4JqsrlZGWzsa6qULnq1WwGzYPZwPiBLPpleb3wYwAbOriywCz5A+4tAp6UCD/wlzfkyS2HIvF+kXiqW967mJJFAAJ/kFJ/KhWba4y3tsdNUSUqSKYj7Egl+y87jQt3s5wNY/wSh4tnruJLw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(110136005)(86362001)(4326008)(316002)(9686003)(5660300002)(66946007)(33656002)(64756008)(921005)(76116006)(6506007)(54906003)(8936002)(66556008)(2906002)(38100700002)(26005)(55016002)(83380400001)(66446008)(52536014)(7696005)(71200400001)(122000001)(186003)(66476007)(8676002)(478600001)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bWlsSzhoQjk2djdKSHJTenVVNWZVKzJjakt2MjB4OEFWOFFqWU94VWNVakxI?=
 =?utf-8?B?MkJYbTVSbjl0R1VOUXpLSTdRcHBhUVRlbUQ1ak1rSGRSTzY4M3VFY05PSlNG?=
 =?utf-8?B?LytXR3ZkTkpXTFVJN2o1ZXluWWtXRTIyMHhLMWpKWllEN2FyblF2enVzeWFZ?=
 =?utf-8?B?d2FEb1dUaEhUcWl1cnhVOFRLWElEdTVTSk9hRnhmd2MwTlRNekxIVUVJNzRk?=
 =?utf-8?B?MVB2aXBoWmVTUjFoU0tETjdXeVNTZlhLSTdhVlVyQzF2aURxMVd0a3BMRGVy?=
 =?utf-8?B?UzlDNUlLeW1YTzZ1dXFaQ3Fmd05GK01jdENSa3hnRnZRb0J6YlltZHdjYXBY?=
 =?utf-8?B?M1FWbGRxVzhRNEVTczNONU9zL3FnODZsWGpGN0I5V0poenlsd0VRbHJYSGU5?=
 =?utf-8?B?YkVjYTRuanFYQzJEZlUzYnEvTUxMNVBna3p1ZytsYnh3amQ2bDkwYVZMMmNo?=
 =?utf-8?B?MDZjZW5MeGVyWnV1UTRITVVLL3JlT1Yvek9JNTdqcWIzQU1tcUJBOTN2ck5B?=
 =?utf-8?B?eU5hQUZCMHhXRGlIZ3YvVmMvbnhQZ2RnM3Zjb3lVcm51TkhTcmttV3laRTF6?=
 =?utf-8?B?K3c3cDhFb1dpS3RsbTRPZXVreXN6NUZuYnNYT011VWNESXo5N2d4R2NMbEt3?=
 =?utf-8?B?VlROTGw3OTZrMURkM3cvQ1hUZmxLL2pBT01MRTJjalNMLy9rMUxLaVVXS3Rn?=
 =?utf-8?B?aml6TzY0Y1RLY0tBVlZnaFgxSzNpdjc1bkpPUDYraDY1YmNLNGJ3SHdTZU9h?=
 =?utf-8?B?eHlsT083dmpIaWRzRWMrSlRiYjNBZTFCZ3dGZzVQZ3h4Z1BoTlMxd1VGSm94?=
 =?utf-8?B?U2pudFR1Rk5iSitERlhpa3MwWENGNmpLYy9BcW9kWlRUTmZjQ1lRMXBUN2Jw?=
 =?utf-8?B?b2tlMnhycGNkK2tnNXI2STJtNTVDY0hGT3BrU1JrZ2VRWHJkNWc2Y0I0NzMx?=
 =?utf-8?B?ZTNxaWFIMFVMVWFXWVJjQUNINFZCMXpCNE9GN2tHeHZrcmc2TDVqQXpUT2Ez?=
 =?utf-8?B?YlA2UHFjemFwZ0t2M3hYaWg5Skl2UXZad2dtMnhYL01pTTZCK2xjSnJmMkpO?=
 =?utf-8?B?Njd6d1VzSm51bTZGUkpwTGJzdHlYN0ZzbFk4bUY4UmdHNFNCWmdteGpxV2k5?=
 =?utf-8?B?Wk9iQjYycnVLL0c5WDE5aEswK0cyOHRNeE5vL3pIYkdpclQwVWdZVDVLTDRG?=
 =?utf-8?B?UkM4aDdTZjdadGk3OXo3V2ZXY0U1WFlpbHlnY3J3cTBveCtuVDB0UVBqWVk4?=
 =?utf-8?B?bGduZ1VncDhKMFlCK2Z1bmNQVlRnUmQvY2xycW9BYWRyUFRtZ05GeWZZRUhJ?=
 =?utf-8?B?RnZtMmdmY3Z1R0IvZjNySmxtV1NXejY0amV4bjVzNkhnVzFPazlpRTBwcXRp?=
 =?utf-8?B?Vmp1UmFxdHl1Z3doRVRLblRjOGExbGZaTmlwQ1c4RnAzNm5tUDU2L3NLRHEz?=
 =?utf-8?B?Z0FURDhLckVCZkY3NzFIb2JLcTNRaG5CdzM0b2FmY0h0bSsvcms0NGNwY1JG?=
 =?utf-8?B?M1VHNW5TdHVkVFJyVnNJTWFPOTM0WHYyckRKakRNSUo3eEd3Mk8zSkJXZmFR?=
 =?utf-8?B?MjZ5MXlJMWNmNy9Zd3ljVDM0Q0NmQzBmaWNlZlplRXFJb00yRlhQSEJ1dzgy?=
 =?utf-8?B?SmJySlFuRlpyU0piRnBZOFdNR1dkSERsOFM1dnZ6ZUkwR2VpTFZ0ZnlrK0tn?=
 =?utf-8?B?UENZSzAxaW5JYUFPODRvckNMVXJ1eGZTc3p5STNhUExIMGszR3licitqei9O?=
 =?utf-8?Q?sqVQxBWHzngl+Cm0vsmtxeBvHwgn9kQwBQVboX/?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d3b14b4-08f3-4c4d-9acd-08d90b07dbdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2021 12:11:02.9088
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LpnYBsePQw8awtkW0d31tpbCOBaa1jlGKFnn05Pxh6iQAyxF+yIzLloub7cyqPRvScWpgvmTC2lEKpINtcsYnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1259
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IEhpLA0KDQo+IEN1cnJlbnRseSwgV3JpdGVCb29zdGVyIChXQikgYnVmZmVyIGlzIGFsd2F5cyBm
bHVzaGVkIGR1cmluZyBoaWJlcm44Lg0KPiBIb3dldmVyLA0KPiB0aGlzIGlzIGluZWZmaWNpZW50
IGJlY2F1c2UgZGF0YSBpbiB0aGUgV0IgYnVmZmVyIGNhbiBiZSBpbnZhbGlkIGR1ZSB0bw0KPiBz
cGF0aWFsIGxvY2FsaXR5IG9mIElPIHdvcmtsb2FkLg0KPiBJZiB0aGUgV0IgYnVmZmVyIGZsdXNo
IGlzIGZsdXNoZWQgaW4gYSBiYXRjaGVkIG1hbm5lciwgdGhlIGFtb3VudCBvZiBkYXRhDQo+IG1p
Z3JhdGlvbiBhbmQgcG93ZXIgY29uc3VtcHRpb24gY2FuIGJlIHJlZHVjZWQgYmVjYXVzZSB0aGUg
b3ZlcndyaXR0ZW4NCj4gZGF0YQ0KPiBvZiB0aGUgV0IgYnVmZmVyIG1heSBiZSBpbnZhbGlkIGR1
ZSB0byBzcGF0aWFsIGxvY2FsaXR5Lg0KPiANCj4gVGhpcyBwYXRjaCBzdXBwb3J0cyBiYXRjaGVk
IGZsdXNoIG9mIFdCIGJ1ZmZlci4gV2hlbiBiYXRjaGVkIGZsdXNoIGlzDQo+IGVuYWJsZWQsDQo+
IGZXcml0ZUJvb3N0ZXJCdWZmZXJGbHVzaER1cmluZ0hpYmVybmF0ZSBpcyBzZXQgb25seSB3aGVu
DQo+IGJfcnBtX2Rldl9mbHVzaF9jYXBhYmxlIGlzIHRydWUgZHVyaW5nIHJ1bnRpbWUgc3VzcGVu
ZC4gV2hlbiB0aGUgZGV2aWNlDQo+IGlzDQo+IHJlc3VtZWQsIGZXcml0ZUJvb3N0ZXJCdWZmZXJG
bHVzaER1cmluZ0hpYmVybmF0ZSBpcyBjbGVhcmVkIHRvIHN0b3AgZmx1c2gNCj4gZHVyaW5nIGhp
YmVybjguDQpJIGd1ZXNzIHRoZSBpZGVhIHRoYXQgc3RhbmRzIGluIHRoZSBiYXNpcyBvZiB5b3Vy
IHByb3Bvc2FsIGlzIC0gInNldCB0aGUgZmxhZyBvbmx5IHdoZW4gdGhlIGRldmljZSBzaWduYWxz
IGl0J3MgbmVlZGVkIi4NCkhvd2V2ZXIsDQphKSBPbmx5IGEgc21hbGwgZnJhY3Rpb24gb2YgV0Ig
Zmx1c2ggZHVyaW5nIGhpYmVybjggdGltZSBpcyBnZW5lcmF0ZWQgdmlhIHJ1bnRpbWUgc3VzcGVu
ZC4gIGFuZA0KYikgVG9kYXksIHRoZSB3YiBidWZmZXIgZnVsbG5lc3MsIGlzIG9ubHkgdGVzdGVk
IGluIHJ1bnRpbWUgc3VzcGVuZC4NCg0KU28geW91IG1pZ2h0IGVuZCB1cCB3aXRoIHNpZ25pZmlj
YW50bHkgcmVkdWNpbmcgdGhlICUgb2YgdGltZSB0aGUgZmxhZyBpcyBzZXQsIE5vdCBldmVuIGtu
b3dpbmcgdGhhdCBpdCBpcyBuZWVkZWQuDQpUaGlzIG1pZ2h0IGNhdXNlIGEgcGVyZm9ybWFuY2Ug
ZGVncmFkYXRpb24uDQoNCk1vcmVvdmVyLCBmb3IgcGxhdGZvcm1zIHRoYXQgcnVudGltZSBzdXNw
ZW5kIGlzIG5vdCBjb25maWd1cmVkLCB0aGUgZmxhZyBpcyBub3Qgc2V0IGF0IGFsbC4NClRoaXMg
aXMgYWxzbyB0aGUgY2FzZSB3aGVuIHRoZSBwbGF0Zm9ybSBpcyBjb25uZWN0ZWQgdG8gVVNCLg0K
DQpJIHRoaW5rIHRoYXQgd2UgbmVlZCB0byBmaW5kIGEgd2F5LCB0byBtb3JlIHByb21wdGx5IGFs
bG93IHRoZSBkZXZpY2UgdG8gc2lnbmFsIGl0IHJlcXVpcmVzIHdiIGZsdXNoIHRpbWUuDQpIb3cg
YWJvdXQgY2FsbGluZyB1ZnNoY2Rfd2JfbmVlZF9mbHVzaCBtb3JlIG9mdGVuLCBlLmcuIG9uIHVy
Z2VudCBia29wcywNCm9yIGJldHRlciB5ZXQgcmVzcG9uZCB0byBhIFdSSVRFQk9PU1RFUl9FVkVO
VF9FTj8NCg0KDQo+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgNCj4gKysrIGIvZHJp
dmVycy9zY3NpL3Vmcy91ZnNoY2QuaA0KPiBAQCAtNjQzLDYgKzY0Myw3IEBAIHN0cnVjdCB1ZnNf
aGJhX3ZhcmlhbnRfcGFyYW1zIHsNCj4gICAgICAgICBzdHJ1Y3QgZGV2ZnJlcV9zaW1wbGVfb25k
ZW1hbmRfZGF0YSBvbmRlbWFuZF9kYXRhOw0KPiAgICAgICAgIHUxNiBoYmFfZW5hYmxlX2RlbGF5
X3VzOw0KPiAgICAgICAgIHUzMiB3Yl9mbHVzaF90aHJlc2hvbGQ7DQo+ICsgICAgICAgYm9vbCB3
Yl9iYXRjaGVkX2ZsdXNoOw0KPiAgfTsNCldoaWxlIGF0IGl0LCB5b3UgbmVlZCB0byBzZXQgdGhp
cyB2b3AgZm9yIGEgcGxhdGZvcm0sIG90aGVyd2lzZSBpdCBpcyBqdXN0IGEgZGVhZCBjb2RlLg0K
DQpUaGFua3MsDQpBdnJpDQo=
