Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2AA7C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 07:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CF4264EDC
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 07:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbhBYHxH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 02:53:07 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:52525 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235332AbhBYHwm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2021 02:52:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614239561; x=1645775561;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jggiidtAA3MgdDuqsb9/+tWyhnV9clx7qaG8XBQhZo8=;
  b=PhSb10uhhud+TU3/8CG3d10xOMamGkT3qSXnTBCQ6NVCal/2JOY/oOFu
   2tEhxayZ7iVq8gJacXVe0kX/g19UcC6275smI7H7f5Wx6aGDtzN3mW/Xp
   2XrF/vDcZfSYfuNKmmdraZlG83VPV3zyBD32NHvZwEK+dRuo+DBdhIPDZ
   vn+T2js7C16MO66dP4LvYoVtFvsGd0kjRxuCUXMIJ+4Johj1SS9lBNl/6
   5lYqSVMHdrCyMLhKs7O6WFQUd6+X3yj9cEhhWUnKzCH6UEnwbgswVPdrl
   apu2KxZjAXcVB2BJc4AzfE1db+CFsCcBjm9jUDsYgEW4sck6SdgYhSix7
   g==;
IronPort-SDR: 4JprJ0mkb/htRYE9QzAD8i56rGzm7mLRGlnlbLXy6aCMeyE4xy1znNemTbFLZ0c9N9M/U7kmoo
 riDo52pfWwisLGZhP+H2C+2Ay9XbT2TgiidMLZXiyZm1GSXAsivGtM0h8UPHmLCsnXSPfNb13+
 uYhueqc8ySh7eNuRHs+D1MjPUsnMTnpaN6QJDR3O1o8jiXszA+ul6TawcDZNS063cdOPNiGFBk
 EJWXI2SyWECx0SrgzGNp16DkBHzwSFqG3DkJH4OYP3AL+MeMiQ4L2r8uqpQoOoULucxMrpqtUj
 exE=
X-IronPort-AV: E=Sophos;i="5.81,205,1610380800"; 
   d="scan'208";a="271322660"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 25 Feb 2021 15:51:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFE+23sz9f5OgwnXgmuoIUwWu70tCC6fQjPQTaIOmBXDmJJr53r3GO5/aO/+wRIINoUQ1b0tWPctBlT7Q0MWkCU4iTKqqHA0auUVh3lnGcLTVrucVOcG0jOws9opI1etRJqjeUoVAWfRySc3V0dEfQ3ZqXLvCSWPdZlvqIGRfK+fbwJlFngLM30W0XEmbW+5exE8hREhjQgEPmVmZVLdwr8IE5NZA+/mThXWhZdTjy+Mg6UWEpZ+PMZ1dhTHTSv3XWZbaSb0LY2j6ld8NvEOJYizNPDIsfmn6ucE/CRTQk2b8KDBvTGdy6Rq0x4+0F/OmH+RcXgO7yI/in8KfLMX8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jggiidtAA3MgdDuqsb9/+tWyhnV9clx7qaG8XBQhZo8=;
 b=LUgOpN0s3lNdZeAusXMLvcX7lTcoPtuHgXHbvu17brkuEljO2OPU/7txJ0ricry8Ummq+lfJfkDCKb6BadECUvCFh9mo+/AbsJ/ugE6h7oxojGQamLsDh/3t4Dcus5OpEZiAJqLUaClWAp3n7w/3ZD2Tfd/jbKhC2dFQuLUsdHac4WufEs7qjJYw1ND1B64K0QqyScqjZeNrfgh8gmhlCAXfNRgTSheGjLVoJvFd5TLpuu/dKBGEWE7B1AZkHqCw3jQqtTDmitpK136pQ4kaV0VMgK132qYHC2WEr2sebO4sjdJrPVxGdLnzmDqpDlI/f1FnZ1YVSxxJgRvejWwDkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jggiidtAA3MgdDuqsb9/+tWyhnV9clx7qaG8XBQhZo8=;
 b=K2B5M8gN6+RFDD5MmurpdS6+F0kV7QT8hnFvun4VhucSrX1Hk6zAOTpTkV97DXQdUbW6bRexGg4gBImFM1rbqlxki7tUgTpVOHNtaaRJ2as0BWPeBoV8lLJJW5tbh2EdYggRO4rTKwjMPh4/D429CQO55KuD5jK320KqrasYZMA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5355.namprd04.prod.outlook.com (2603:10b6:5:101::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3868.29; Thu, 25 Feb 2021 07:51:34 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3890.020; Thu, 25 Feb 2021
 07:51:34 +0000
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
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: RE: RE: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Topic: RE: RE: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Index: AQHXCP2Y/e9Fs0BGVk+8HmhkjtrqFaplnxOQgADNhgCAAIxTEIAADQXggAEn3wCAAFYQ8A==
Date:   Thu, 25 Feb 2021 07:51:34 +0000
Message-ID: <DM6PR04MB657579C18529F8D42C47ACA7FC9E9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <DM6PR04MB65754EE70E1E61C46309AF9DFC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
        <DM6PR04MB6575DA862FD50130DAF1E573FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76@epcms2p1>
        <20210223235458epcms2p666e7cca021e09c715ca3b11ada39ebeb@epcms2p6>
        <DM6PR04MB657573102C577230A3079DBBFC9F9@DM6PR04MB6575.namprd04.prod.outlook.com>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p7>
 <20210225024246epcms2p76340994168c3985fcb55106ba54463ef@epcms2p7>
In-Reply-To: <20210225024246epcms2p76340994168c3985fcb55106ba54463ef@epcms2p7>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 53566fdd-da1e-4fec-0b46-08d8d9622c28
x-ms-traffictypediagnostic: DM6PR04MB5355:
x-microsoft-antispam-prvs: <DM6PR04MB5355D8C1969BAEE802D07449FC9E9@DM6PR04MB5355.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SSjsdG9ti+yXwLM3xnyq6gdUwq9FIWdNIbojulWXBDUuF3/+ZqEvFuraJywBle5FSZ5VzPu7e68S7UYtucYGJVlfivzwXvbWx7SU9x7jETK1witNeu1aQLWZS96cp3r+ptTbiJqmF8ozRNkXjPvc/VM4SNVq8gUhp6P/1jYAK+6D7iKDJeK/D3iUteaRyRHy2oHeXdhXC/ASB+aKOzW9q2A1ifP37j/m5L2laQEkAUMY/pkcSMfNQwKSt/mMWWaDmFRS1uiYVF3JgQe8Qa0Orwh8M4azWrMkBYENG1W7jZHTKynPPuNhbSH2FXw80DefRH/lq1pPd4ZPu2DwRxjIQde0upFz7mTCRd1ZpHbrGdDGLMZD4VEIMMAAFUoCvSKbJ0fbnFImcXLm6t6O9FlaEeUClmwr6C2DeA4MUerm2KAMMaNMTSXSpgcJZbATzy/aNVJVMbMb2V1OsbfRWP+9w3sbCFhJW56hA3k6fLV0LGWYe2MS2gjdDCUgNypJxt2qlOeRqCg4N8oUt9kvXZSPBMe1awPmPhFOen8YTKzGdvtHDKEeJA1nZOToP2lN672A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(26005)(921005)(186003)(66946007)(33656002)(2906002)(76116006)(83380400001)(7696005)(54906003)(9686003)(8676002)(86362001)(55016002)(66476007)(5660300002)(4326008)(64756008)(66446008)(8936002)(7416002)(71200400001)(66556008)(110136005)(478600001)(6506007)(316002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?emg1MUVTbjEyZFMzS0h6QWZHVVNteUFhNG1wT1lrZHF4K1lOTyswVk5uVjdv?=
 =?utf-8?B?QjA3VEliSlBZNHFSU2l1QVFpUEQ3aTdVSHpjVFdERWJONlo4NDJCb3Uxa0du?=
 =?utf-8?B?YWtsVy9SbVE0ZmZRSkcwT2NNbDJJVS9FWkdUTjJobHo4cUNrUnpuNnQ4dThr?=
 =?utf-8?B?VXBQdXY0MDJobDd1Ti9SNzJlOVVRaEg4YXQ4eXZtUDVvMUg0SDZYcjhnVkhF?=
 =?utf-8?B?L1hOdW0zekZUby9tcnowcGpucmNIY2RsUFJzMGkxMy9GUDNRdGRqTnhwSC9O?=
 =?utf-8?B?ZFpWM3oxOEJTRGNOMDJoZitiMkV2ZzhBVEtXVTZKR0xsQVNIbHNQMGpkaUxF?=
 =?utf-8?B?allXMXo1WkhBUng3SWlLSVNkNU1oVlBmcFc3R0VuRzNsRitPNzAzMnROSk5s?=
 =?utf-8?B?ZFA2UWxuQTJqVUVGRnU5RGdncXl6NU4wN0ltSVBIUDUraFdFRDFpbTFHbHBJ?=
 =?utf-8?B?eHQwOXBBdDhMQWI4b0hvREpHTzhyS0ZtRmJXb2NrUmV0TVYrQXBzVnVNTGYw?=
 =?utf-8?B?ckFFZWZ1bEdnMmFRNlo4TkYwTllzZlhKd0hVRjIrZXhoM0lkdG4xanFVQUM4?=
 =?utf-8?B?Q1k0V1c2eitlWTJzY1BKZzVTbVVJTjkwZm1KT3gxWHN5ZUZQOHhMZDVUd2ly?=
 =?utf-8?B?Ynl4WWxqdlFaQWhGTzlZT1R5b2pMUzZwWXZIRllBSVhOSnMwSTd2a3NwWlho?=
 =?utf-8?B?U24yNjhTUlVOVk1nUXd3VjdNSFJBRXF4SHJzdktKUFJsMU1idi9UN21xUlBn?=
 =?utf-8?B?c3lScHoxdTN4eDZtYWthQUVCNmZPbEMyWXhFN2UwV1ZVUVU3UUVSM0RyK0tt?=
 =?utf-8?B?by9admYwcXoxRDN0TDNyL3cxUzZNSERLVTFpdUFUbDNjeGNCaVErbGZOSURW?=
 =?utf-8?B?dElibDZNSFRtTDkyZ0VhSUVvam0yeXBmSDk5VTVMcmc3K0ZvTWR2Rm13THhF?=
 =?utf-8?B?MW1jQkdRQUN5Z0hSd1dzUDBxSEo0V0xWMVZPTGgrdCtjRXJWRWtXL1RoKzFN?=
 =?utf-8?B?dTVJazFOSENyR2tCSGxHSndxUFVCNytpaE1RYWlXUEl4Y3l0aEJJdzFoLzZM?=
 =?utf-8?B?T2NYN1g2d3lzeTVFaFJPWEJVaTFsSXJ0NWdpU0hhNkp2N1lSZmJrNTdTa05D?=
 =?utf-8?B?Z09QaFM2VkVrQ1NpMmVkK3J3aXo1OGxWdFZuNktmaVEzSUhrbnhtS3ZFTUNy?=
 =?utf-8?B?dmU3eDVBNGNCN1crMWNhbEpNODNwVkI2MzNkUU5tWG80UE5jZnJqeTZkZWxD?=
 =?utf-8?B?bmtvU2xaSW40eTJRQ1dKMmZ4ZDJWTXk0ZzB2bFlHN2t2b3BhVHNVRVgzUzdL?=
 =?utf-8?B?Y3JLTW9pc2FFbVlUZjNpMEJTMERYN0xjZUxwT2RjMC9rR1FjazluWEVuV2Z3?=
 =?utf-8?B?LzFYSlhWb0prcnB6bkgrMExvUjA3dDZyRnF2U05YaFhyMkc4TlB5UXo4MmlL?=
 =?utf-8?B?Q01qWXdZSnp3TlpDNGQrVGZaVWNYL3A2aE1aUmhsTXV0dnRZQVhGKy94S2NO?=
 =?utf-8?B?MVVYYVJwZE5CbThWd3J1a1hmWGtxYlZleDJCR2UwbEMxcGN1L2VNNTRIRWo5?=
 =?utf-8?B?MjI5T2kyZzVaOTVKU3BEekdXS2tyWVJrOUFRaXZKR2dkZ3lFZzdDQVRqd0lo?=
 =?utf-8?B?eTEvanh2UlpMUW1uSnUxRjh1K0NzREpZeEpsRGVFdjJzR1Roc2k2d1VXcmtp?=
 =?utf-8?B?N3RKNVNXSXBXNWZSSnNqWUdsYTgrdW04TG50cThQYzBBd1NTOExPYUlIa053?=
 =?utf-8?Q?DXee1MuLTggUUKVmgIum3jliPXbKNrx/zpDQgUC?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53566fdd-da1e-4fec-0b46-08d8d9622c28
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2021 07:51:34.2823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Exm9HRpjq0q7eHN6BBDfZyLJ13nbbjZHJbPzxzc9nMdK3pitH3rmyqkeX/bJF2+A0lkyzjcdXx0RzGCrEBa23w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5355
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gPiA+ID4gPiBAQCAtMjY1Niw3ICsyNjU2LDEyIEBAIHN0YXRpYyBpbnQgdWZzaGNkX3F1
ZXVlY29tbWFuZChzdHJ1Y3QNCj4gPiA+ID4gU2NzaV9Ib3N0DQo+ID4gPiA+ID4gPiAqaG9zdCwg
c3RydWN0IHNjc2lfY21uZCAqY21kKQ0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ICAgICAgICAg
bHJicC0+cmVxX2Fib3J0X3NraXAgPSBmYWxzZTsNCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiAt
ICAgICAgIHVmc2hwYl9wcmVwKGhiYSwgbHJicCk7DQo+ID4gPiA+ID4gPiArICAgICAgIGVyciA9
IHVmc2hwYl9wcmVwKGhiYSwgbHJicCk7DQo+ID4gPiA+ID4gPiArICAgICAgIGlmIChlcnIgPT0g
LUVBR0FJTikgew0KPiA+ID4gPiA+ID4gKyAgICAgICAgICAgICAgIGxyYnAtPmNtZCA9IE5VTEw7
DQo+ID4gPiA+ID4gPiArICAgICAgICAgICAgICAgdWZzaGNkX3JlbGVhc2UoaGJhKTsNCj4gPiA+
ID4gPiA+ICsgICAgICAgICAgICAgICBnb3RvIG91dDsNCj4gPiA+ID4gPiA+ICsgICAgICAgfQ0K
PiA+ID4gPiA+IERpZCBJIG1pc3MtcmVhZCBpdCwgb3IgYXJlIHlvdSBiYWlsaW5nIG91dCBvZiB3
YiBmYWlsZWQgZS5nLiBiZWNhdXNlIG5vIHRhZw0KPiBpcw0KPiA+ID4gPiBhdmFpbGFibGU/DQo+
ID4gPiA+ID4gV2h5IG5vdCBjb250aW51ZSB3aXRoIHJlYWQxMD8NCj4gPiA+ID4NCj4gPiA+ID4g
V2UgdHJ5IHRvIHNlbmRpbmcgSFBCIHJlYWQgc2V2ZXJhbCB0aW1lcyB3aXRoaW4gdGhlDQo+IHJl
cXVldWVfdGltZW91dF9tcy4NCj4gPiA+ID4gQmVjYXVzZSBpdCBzdHJhdGVneSBoYXMgbW9yZSBi
ZW5lZml0IGZvciBvdmVyYWxsIHBlcmZvcm1hbmNlIGluIHRoaXMNCj4gPiA+ID4gc2l0dWF0aW9u
IHRoYXQgbWFueSByZXF1ZXN0cyBhcmUgcXVldWVpbmcuDQo+ID4gPiBUaGlzIGV4dHJhIGxvZ2lj
LCBJTU8sIHNob3VsZCBiZSBvcHRpb25hbC4gIERlZmF1bHQgbm9uZS4NCj4gPiA+IEFuZCB5ZXMs
IGluIHRoaXMgY2FzZSByZXF1ZXVlX3RpbWVvdXQgc2hvdWxkIGJlIGEgcGFyYW1ldGVyIGZvciBl
YWNoIE9FTQ0KPiB0bw0KPiA+ID4gc2NhbGUuDQo+ID4gQW5kIGVpdGhlciB3YXksIGhwYiBpbnRl
cm5hbCBmbG93cyBzaG91bGQgbm90IGNhdXNlIGR1bXBpbmcgdGhlIGNvbW1hbmQuDQo+ID4gV29y
c2UgY2FzZSAtIGNvbnRpbnVlIGFzIFJFQUQxMA0KPiANCj4gSG93ZXZlciwgdGhpcyBjYW4gaW1w
cm92ZSB0aGUgb3ZlcmFsbCBwZXJmb3JtYW5jZSBhbmQgc2hvdWxkIGJlIHVzZWQNCj4gY2FyZWZ1
bGx5LiBUaGUgcHJvYmxlbSBjYW4gYmUgc29sdmVkIGJ5IHNldHRpbmcgdGhlIGRlZmF1bHQgdGlt
ZW91dA0KPiBtcyB0byAwLiBBbmQgT0VNIGNhbiBjaGFuZ2UgaXQuDQpZZXMuICBJIHdhcyB0aGlu
a2luZyB0aGF0IHRvby4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo+IA0KPiBUaGFua3MsDQo+IERhZWp1
bg0K
