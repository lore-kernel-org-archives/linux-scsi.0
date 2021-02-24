Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7854DC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 09:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27C34614A5
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 09:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbhBXJyE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 04:54:04 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:44611 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234349AbhBXJxz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 04:53:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614160435; x=1645696435;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Lpr9DZ8Q0oHKGjq4ZOCxX0ZX/At+ep5gJnKfoNzN9Lc=;
  b=VOjpDPj9nglUDiBPywaWcCc4tC00T0Y1HeyNvDMNoPCMmOuXVPRgNcrP
   ueWx3Y8QgWvlpYPsFb9c26os4KmeLxdRQ1oyXXQnYXh6Va9qzegX4n9XS
   tp5e4mHixIJZOdO2GWbXo2YsHAoljRNt6b9yaAwbm2WJH5qXbjJrJATUv
   IAQRVtKMmYxRStecp6/A8KoWkpeskyGYrslhrXRLVSQQ1yH5De6Nj+mQ0
   tMVfPZhDhEFNflIZapM6dEIZL5Hnm+dyBdJJolbc/UpJgc/Zs8OOb83vY
   vIy5p4+vRAwHVOpe3QxiSyXOulwTrmhTCV5J2Dm9qmqNSHjQJXJvbOPvS
   Q==;
IronPort-SDR: JYtxP4r6ZNBxjfMqNdTUqiZM3rdZbmBimRWwMIRtwJ4lkikB4nnIf2Slvdf0JH6cyHbTjUSf/h
 7AJhQLUoYxYyCrc9y3FW/A8Cped4LchF1St9Qmli12gQgkHN3L+KhV+5YeeKiCigH2/hnqtwKP
 A5aCNZc0Ox7lq9HdIFV6pLINFkbHuafiftFxElDr5Djkb1SOILcHysKeU3cjc5Gm51pesttW3/
 42/QJC4A7BkgHZASbGOfpA6Q9M/z04r0ufP/brhzBvvXvybZilqAR2whXKVw1DtpmHHiBlfeuW
 wZA=
X-IronPort-AV: E=Sophos;i="5.81,202,1610380800"; 
   d="scan'208";a="161849420"
Received: from mail-bn8nam11lp2172.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.172])
  by ob1.hgst.iphmx.com with ESMTP; 24 Feb 2021 17:52:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KBHDiycc12gcYVrrKFpllx7RJnen3+619HMl5YDKkmIWXCJ5f69wXCFJcwQMz7JHxkHb9MtSjLwqz/Y3VHheN3NKaEI4fiHNSP5oE+dNRc5d0VD3mLQCqWxZKn3kuClOnsaJ+SAcNrM7tEqM5dI22xtV+iFtiZl2A/JUTq2wPKhx4fKOEJ30NTrnqoBTV0+wd26I7ikCdMe+2v2gMDYgxnXdwC4Y7QFWDJeFQrxLraD9ZMkVvUwRDuLoRfNkk2W/C+ROl+YcQdSfz5DU7UI7XBVdvLtwgmmwyy06WDIlYAWIVo5e5DxDcTML6G+GQ8IsWSjo/d4Z/oBK6rnaR+IfAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lpr9DZ8Q0oHKGjq4ZOCxX0ZX/At+ep5gJnKfoNzN9Lc=;
 b=iruILHDoevmYTjZNtJhsXzI4Y1ifLXubN9IJSwpOjM/sOAwdtM1HOclCdkXOHy4zj4XjrZszGsG2utYnWEz/WjXBZNmt5OQwSq/SJTolC6obscTBaG+zB290Rg4BrKHWoIqwvI5MGahZcN2rMzjApFOzUNSPAYe5wPSG0IFFlvK8vtgqvZrnxsnhHdDk40lJXGoTUvcwuGklGNpmr/ICDMU/UpJVIVCyOP2haSf9jEChlZ5MsP+bZoLI/rFGC6QG8NyRX4lBc+kAGnNtgYVEC6TKeInlXw7kAtusd7L0AeyDguU+pbWd7moQyZuNx1SaMmJaeZnWO2UoEiyqwkN+Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lpr9DZ8Q0oHKGjq4ZOCxX0ZX/At+ep5gJnKfoNzN9Lc=;
 b=iSn2lsK4+XZ81XOx83gSt52OTMUpGHf2Lbb+FHv+bMyvji9F70+Q1l5GrwCnvoTviYyd00VOrI3c3p0cngMSFCiem69w8THVwu6IB9lZ5mQv3VPmYjJVxw0+OYFCu4sM6+GKCgyonM2tnJw0/1BSY8PUehJlOAFAWRfNmufGSg8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0269.namprd04.prod.outlook.com (2603:10b6:3:79::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.19; Wed, 24 Feb 2021 09:52:43 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 09:52:43 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v24 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Topic: [PATCH v24 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Index: AQHXCmlPpjVkLGqQUkG6P1vSKUTKEqpnDutQ
Date:   Wed, 24 Feb 2021 09:52:43 +0000
Message-ID: <DM6PR04MB6575BBF6F89002222EA5FC1DFC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0@epcms2p6>
        <CGME20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0@epcms2p2>
 <20210224045532epcms2p2215025506b062e2fdbad73e51563dca6@epcms2p2>
In-Reply-To: <20210224045532epcms2p2215025506b062e2fdbad73e51563dca6@epcms2p2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 01690725-5269-4ca0-3494-08d8d8a9ee48
x-ms-traffictypediagnostic: DM5PR04MB0269:
x-microsoft-antispam-prvs: <DM5PR04MB02694861ECB44714E637B98FFC9F9@DM5PR04MB0269.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dPb5D8wfE2+rt1Ije8bNm4rkYCXy4pEBRdEeqL9dHQL3gbaF7r968ZIOdaB4quTXDO+9jvysiUq/Ho1iGLFkMLDeEiCjRf7PHuEHzjoaC0RmGYpS0cNa2QvVux1nGXoyZS6BlPGhK8yaOCVHVPVhwu6zRNWxna5dRvRVInIJJVN4MOM9lnxwhJjvjDukOnFpfTjO1oGNvIZAIE29c9wof0Rv7M+NbE76MyR6YrcpWdLzE8zeN0nwTHX/rCJ6ImWzxDVOXdoStaqu4ka4j4AtSSidVwkk4Q6cQatA+tVfyRPij6EQ8RVtWeWKsJyp8Vnc/fVOuSnloGMQ5ObEzjXf1j0+0WUg3iaJhxGahRBSNiCeXACKXccDsk7nt3rvYPGIbkMHC7axi+iWW+m6n+TDuD5lBy6C50n7vwiicr4FXqMRDHEuxSsOP93AnQj7pUpBp/A10rUq0/6S6RTFdRpUroDswp19uyOBfId736b6yqjk3GsEfcxzWg1P3lp/RkW1i+MtG3Ar8CcBpzUdBSIBG38/oxjMCbXun92KKpWBdzyzrYV7iLf+VXCaHg5YAaNI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(54906003)(26005)(66476007)(316002)(66556008)(921005)(64756008)(66446008)(33656002)(7416002)(110136005)(4744005)(8936002)(8676002)(7696005)(6506007)(9686003)(55016002)(76116006)(4326008)(86362001)(5660300002)(52536014)(186003)(83380400001)(2906002)(71200400001)(478600001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dk9EaTJJWjdxdnk5bE43RFhZajMrZ1dHaExiNGZLS3pENmxHQ0lHUXF1bVox?=
 =?utf-8?B?QWdFV1JHTys5dFJINGs1VGM4ZzlYeWsyYmN1UVBzcHd3d2RNSnQwOEZkVmVG?=
 =?utf-8?B?TkdYaXBSYWoyN3pWdVoyR241bGh2ZzgxRXlTSU9IK0NhVFNmd0JIR0xFQmYz?=
 =?utf-8?B?SDdlRmhUeW1pclJNcDBTbG5IdmxtMEFnU1BLMjZWQTE3UWpJVGJJRC9UQ3Vj?=
 =?utf-8?B?UHdCL2NmaHJmMEd5Y3F3S1pESFlVVm42ZlVUWUxKWFlkaVcxclhtMndzWXBz?=
 =?utf-8?B?YytNdHc1c0JDc2hVRVI3cjhzcTZrbCtZUm4zbEJzM2htMFh1UWU5TDBnSWRL?=
 =?utf-8?B?K1pzTElOcGdCM0ordDFKaEhsV1pXMXZGajFFS05FOFIrMjZKMWE1bU5NME5m?=
 =?utf-8?B?M1ZzSWFkNXI2MTlUVndnemFmZG5zVHgxWXNpQnNyY3BaRk5abDU4SitqMjFv?=
 =?utf-8?B?Q1E0N1FtNHdiMnl2MzRrS2lxdGtqWXdoZ1ZCTElJQTgzOXBUcEtsTkJ1Rkp6?=
 =?utf-8?B?OUh2bVlxQTVVMjhTb2N5VlRHS056MjlOdnUyYVo2NzU5bmF6ZDN6S0p2VEl4?=
 =?utf-8?B?MFhUZzkxbXpuZTloUER5emY4VTJDeXBVdHJuRithV1dXVG9pRVRoOVRGQ3l4?=
 =?utf-8?B?YTB4MmJsN0d5ME43c0VlcmlnTWltbTF0MnRkUEZWNXczWVFmYXBKZVIwd1hP?=
 =?utf-8?B?TjU4VFRNUTdqa1A1MUZ2MWlNclh5UVRVc0ZiZEx4b2h5WDRSTU5sZTdNRmFl?=
 =?utf-8?B?OERYZ1Q3UW9peGowUkN0N1hmZnQybEtSQlVEODFnMGgzZEx3QmJITUFNTUZF?=
 =?utf-8?B?K1FVWTE2elh6TEN2RDhIeks0TEJ0ZTRwYld0WEw3VWJzQ2tPNUh2VGZUVWZk?=
 =?utf-8?B?clErbzZTaVUxS05abVI4dkhhSC9tOHNKa1BUS3c4MmRuVHVSc1I0c0c2bjlr?=
 =?utf-8?B?R0pTM1ZPaG5LQ3QwVldid2lLTlFmVkdxeTU4TE9xZG4wSHJZbDhSVjFRTjFZ?=
 =?utf-8?B?OVBsUFF3czZncVlNbVlpYjRpR3hqK3Z6L3lsTTdVVDBNL0pRODRYLytOMk0w?=
 =?utf-8?B?WFpsdFlVc1Vta2JJQUtUWWtacXVSRnNaUloybm90cTlMMC9xTGtmR29vTWlD?=
 =?utf-8?B?Ry8rYXFNeXhQenhsNkdHYlRvL0F6bGxZTUlVdE9PZ2dlS0NsSWNyQWpTeW44?=
 =?utf-8?B?TGdHSHMrWlNhQ2U5ZVRUaXVoek9EZUdLV28xWDFCTlNPbXlLL3FDdzY1MTly?=
 =?utf-8?B?NGFxY2JLUkhlYlBXamMrL2VDcVp4Vi9Pa2c0bU9keVh4QkxqelJmV2pxSCtR?=
 =?utf-8?B?ajNsWDRQTEU2YktlcVF6cUlLQmdVUitVd2daSENiQ3J1Q1dvQ1BwL05ObTNG?=
 =?utf-8?B?MmFCUTFzdmVYemFQUTN4U0dQVVZFcjQrTE16ZEgxbkpFRFROTkJ3ZS9TSkNL?=
 =?utf-8?B?RmRMNVhYSDVoN20wSWN0bXBhckNYRTNYd2JDV2JjZnFpT0QwWTJUcXp0bHpT?=
 =?utf-8?B?MG90WW93N2lDM2ZMaUE5QmJrenNqZTZpdkZzR1U3UnlOWGdwQnVxeGdwdEJC?=
 =?utf-8?B?M2xVajZiUkhtaUpEbDBpTXFTM0w2QmFSMStQR21wNXBOODlEQ2JUMHRCKzBL?=
 =?utf-8?B?Um1kVElsWGU1QVI3V2J2bzE0azdEVDRHUDEzTDZ6WjJCN09BVUdtcUV2MTBo?=
 =?utf-8?B?dnRlNUQzVFBoMkhtdjBnL3dKbWdrSElYbm5nZlJRWE5Ya3dwU01pR25BampH?=
 =?utf-8?Q?Svy0yPfAeJFS0AAgNRr9FmrBTUXfH7dW5s3BXJf?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01690725-5269-4ca0-3494-08d8d8a9ee48
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2021 09:52:43.0373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qUayQqelfAMaztqQU/7mSLHZrdatA2/KBccEjsSTJHABx57gJo5Jg4jOYh3Tb6tWrGGsbbaX+K2k89KYKgR5lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0269
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+ICAgICAgICAgaWYgKGRldl9pbmZvLT53c3BlY3ZlcnNpb24gPj0gVUZTX0RFVl9IUEJfU1VQ
UE9SVF9WRVJTSU9OICYmDQo+ICAgICAgICAgICAgIChiX3Vmc19mZWF0dXJlX3N1cCAmIFVGU19E
RVZfSFBCX1NVUFBPUlQpKSB7DQo+IC0gICAgICAgICAgICAgICBkZXZfaW5mby0+aHBiX2VuYWJs
ZWQgPSB0cnVlOw0KPiArICAgICAgICAgICAgICAgYm9vbCBocGJfZW4gPSBmYWxzZTsNCj4gKw0K
PiAgICAgICAgICAgICAgICAgdWZzaHBiX2dldF9kZXZfaW5mbyhoYmEsIGRlc2NfYnVmKTsNCj4g
Kw0KPiArICAgICAgICAgICAgICAgZXJyID0gdWZzaGNkX3F1ZXJ5X2ZsYWdfcmV0cnkoaGJhLA0K
PiBVUElVX1FVRVJZX09QQ09ERV9SRUFEX0ZMQUcsDQo+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBRVUVSWV9GTEFHX0lETl9IUEJfRU4sIDAsICZocGJfZW4p
Ow0KPiArICAgICAgICAgICAgICAgaWYgKHVmc2hwYl9pc19sZWdhY3koaGJhKSB8fCAoIWVyciAm
JiBocGJfZW4pKQ0KSWYgaXNfbGVnYWN5IHlvdSBzaG91bGRuJ3Qgc2VuZCBmSFBCZW4gaW4gdGhl
IGZpcnN0IHBsYWNlLCBub3QgaWdub3JpbmcgaXRzIGZhaWx1cmUuDQpBbHNvLCB1c2luZyBhIEJv
b2xlYW4gaXMgbGltaXRpbmcgeW91IHRvIEhQQjIuMCB2cy4gSFBCMS4wLg0KV2hhdCB3b3VsZCB5
b3UgZG8gaW4gbmV3IGZsYWdzL2F0dHJpYnV0ZXMvZGVzY3JpcHRvcnMgdGhhdCBIUEIzLjAgd2ls
bCBpbnRyb2R1Y2U/DQoNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgZGV2X2luZm8tPmhwYl9l
bmFibGVkID0gdHJ1ZTsNCj4gICAgICAgICB9DQo=
