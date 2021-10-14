Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CFEC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 07:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF49B61166
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 07:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhJNHRA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 03:17:00 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:26565 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhJNHQ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Oct 2021 03:16:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634195695; x=1665731695;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MdrmTyOR6X97DIdM8+1E7tTlY567oP1G1hdsqgdA1no=;
  b=DbzkWh5zV0D7Fjx9/vfYtak5TWrCcD4jPxpC0gJqDiFDO8pY48oSd5Sg
   Pg9PI3LL8aYCVSq0Q6SeMQa17dlrBRhTDv63zu4JM3hi0p5MTKIE1xzcc
   EnLp8q5UthDccb20kOpQrifG5XCA93W04G9G1Aehvat0cdpij22dpnIic
   cbEF6uoHuP1w27q+auvn5XEn8OwxM5NQw/64FCs2jKh3zzmZkpe9g4SgL
   YcMRYAqs43pfCDz4fMNwg6Bt9hdte5PbBVkX3XheTiPbi0q9a4yXL+3MV
   RR8jlYHeMuWBzPR/6rBrTN+djZhnHIJ74P6UIfBCxXSbeXDBd3ngkINRt
   w==;
X-IronPort-AV: E=Sophos;i="5.85,371,1624291200"; 
   d="scan'208";a="286678378"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hgst.iphmx.com with ESMTP; 14 Oct 2021 15:14:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cn9BSfK8PCuoJBqdt2HJqXXpyJlAKhaflE2UsHgjU3rk7EXMmla3OwwOx2c6zKkJIH6/EP8Ug1k822fZTh7Wl8jj2Dkrzm8vsb9rFjK+OIl7ed112tLOgg5skHLKKq8f9UEeGiDGx/tqktC26ZOQYZD0sgClSL9e+bMVANpRodxVJxG/6ABhsrCDH/Z+NMik/Pr1NW4XLJ6sReBMR0WfcVlXAwTq2GF/jw2WzMRXAqMOae2LT7L12LiAajaELpUrMWkZPA0iNGhVXJNjAh3pLcVKI6/I/LAA4ithJczv2RN0pBN4MOpi+1Q5so/h9NyIZb0liyGZZAqg+0smJQuEwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MdrmTyOR6X97DIdM8+1E7tTlY567oP1G1hdsqgdA1no=;
 b=EGcnihkU26piW8HfaPg7R/Rp4TZfzLWPBrtupESM8TLR/MGfEaoo6A594matGl+viOD48Ge3P7CdvCSRGNc4TADBQD82UwzNQrij6rKDxTHEyRXXXnuMvB64Hx+RhO9a9cOB6q//gU3VRN8a3A03wCHiqonKzziXWfmnBjirmTC6q+yVrjJQk6pB9fBs+ufM4ElGBy9iR3huEIHKQuhHGqCWJdm3IC3gL5Fo7SPgVyFuQ6G6p2jKUqn+9aryXIrVjZPMRluVVKmaQMOu009wkbXgJzuCn+7XNg78BdQitt+paRY12YaTNVQ27dHXcWAo8VPztxN/YNfX/+DMDllKcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MdrmTyOR6X97DIdM8+1E7tTlY567oP1G1hdsqgdA1no=;
 b=fkJ2K697AWrxqc5An3v7XJu2IEVFMpfp5bpXo5KFiovOJoUC5QrWA7jg8ndm58YmPZyE0BaqK84FeTOnyjZsV1ev5lIJWhtx30VxIONh/3QGn+QrUVevy4fBCYVuePv1jz9JupyFsVca9ejZnYMjo/97CZxTN8k3mzx3DxaA72E=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR0401MB3656.namprd04.prod.outlook.com (2603:10b6:4:7a::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.15; Thu, 14 Oct 2021 07:14:51 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4587.026; Thu, 14 Oct 2021
 07:14:51 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/1] scsi: ufs-pci: Force a full restore after
 suspend-to-disk
Thread-Topic: [PATCH 1/1] scsi: ufs-pci: Force a full restore after
 suspend-to-disk
Thread-Index: AQHXv2ku2NZWv96wbUuf2yAo3I5eeavSBXCQgAAHtQCAAAoS8A==
Date:   Thu, 14 Oct 2021 07:14:51 +0000
Message-ID: <DM6PR04MB65758944A3DC9618E6DD03B2FCB89@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211012125914.21977-1-adrian.hunter@intel.com>
 <20211012125914.21977-2-adrian.hunter@intel.com>
 <DM6PR04MB65755AE8057F920F2CB4F40EFCB89@DM6PR04MB6575.namprd04.prod.outlook.com>
 <af42f79f-4cb7-000d-b366-feac7b5f5c60@intel.com>
In-Reply-To: <af42f79f-4cb7-000d-b366-feac7b5f5c60@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 42972690-8c1e-47d4-f5c6-08d98ee250d8
x-ms-traffictypediagnostic: DM5PR0401MB3656:
x-microsoft-antispam-prvs: <DM5PR0401MB3656153419148D53960D3530FCB89@DM5PR0401MB3656.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dy6FzH0ZXHNr3kzr4br/abq+GIzkIN6P+FMKIhIze1hOtsItLGusggp0MzSxI/0nF9SsjYcHwt72oil4Eo1kMAgMicSN30E+XApVACfoSY1U7S4Dce5QuvQ3fJmhb9fqryOKaFhIQytm3ZBE9xS8ebJtw728eN0gv55oVw26E0yKhdGQZ78drmE5DFF69Nn9CKwujI4iAXYy0F4zdqWwu1I3/DV7moeGgfufO2KbWLKxI6OlTAOvjRFiRgDt+nMTXdtWoiw4CUijdaYiMi4u6n8eCZmQNVD5t2nWH5bVA6zJ1vmtDMH+gylJdsAmMLYffBzzMhGEjIFjbTnx+Wmr7hUD40Lh5iZgysT/ZucHocQsHRhpKyjZ+m7n51qezyYYYycEFLvr2rB1i1Aau52aQu13e0lMF5znkpN4ODUsTgNtUkVzcv4VdYkjrzph/2OWxIesyNjo+eXyOCjRhPx4TNGNapeb8FyV7pYlzzTrISpPo1+m/OVQlXxKZl/7VoHcFC1r0WrqXgMDcLO8oFm7/Cu5oS4GHu7OQb82YJy9x7jFPBut4/hi/xiIQ8V8f4bOC8G23aTSufS/t8ybNQ+jd+/GO5sh0FjS8o57OVsvlBNimXXq9+7mPLnoRRtzWHoDjRK6W59mPUpoewIgxTn8vr9WXoUKAglji2ZYfRacD7ZD949hJVdiubCpGGB9yUa3UZK0qYyYL39WDt6dXYGvDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(15650500001)(8676002)(64756008)(2906002)(9686003)(66556008)(83380400001)(82960400001)(4326008)(86362001)(55016002)(38100700002)(110136005)(6506007)(5660300002)(508600001)(186003)(53546011)(76116006)(8936002)(38070700005)(122000001)(71200400001)(33656002)(26005)(66946007)(54906003)(316002)(52536014)(66446008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VlhiRkIwMktvWXExai9qNEI1bEdJWUVqSjVGWVBQS2pxTnMrd3ZWUHk2TDZm?=
 =?utf-8?B?Y1FzbVNPS3pxekxFUkpaeHQwNXpFZ3lnRUJwVXlYVEhyRStNSUJRSmJGT2Jn?=
 =?utf-8?B?eVlTZkhDTkIyb1EzYm9uZEMyT0IzeFBONUVCa1U4c3hVR0NqaUFvWTJDdk5H?=
 =?utf-8?B?UExmNWVLNnZ0MCtvcjNiZklxSEJpajJDZ0RFbG1CSm5WVmlWNjBuMkRZaVA1?=
 =?utf-8?B?WDFpMkkxYTcxUWdGN0UwRnVnNEtGV1ZSWjJCR3ltU0ovUnJ3V0NVTHJtdEpZ?=
 =?utf-8?B?WnNVWHA3bkNCYVVYR3lhNlBXNmpnbWRvdStsOTdzTG1mMTQ3cVJDTUMvWVQ3?=
 =?utf-8?B?RXVJemg3WlpZdyswS1Jrc1hwL1dnZFIrN2tZK3B5ZWNBc3NINFUyTWlMZVZ2?=
 =?utf-8?B?RlF4U0VGQmNXaHNDNEpTdnlZRW1BMTFTbG02N3VPandHK3NvNjRXKzN1dkk1?=
 =?utf-8?B?cTRxYW5EaHFXazJTOVduaXd6ZmVTd3pFSnd2RFdLTG1iMUtEdWlUaUQ0V20w?=
 =?utf-8?B?bzlLL2M2eFVqb0M1cXNpV1lqMXNqdkgvN0VRaGRWSk1YVEd0ZTNHaDVtVHpo?=
 =?utf-8?B?Ty9QOEhwRFJva1hvZ2p4V1o1Qm1UT0F1dlMwYjBDMEpseld6RGpSbk9MM1VE?=
 =?utf-8?B?dGJnZWQ5U1Z0RW1FVmoxR2dSNWp0clMxYWFvbU5Ma2R5SVkrODNQVjNqRWxr?=
 =?utf-8?B?YXZvS0FpZHo4MUZscDRBSndHNTVrd0k2QVdiaE5CeG03eGxmRmpPU0w1c01y?=
 =?utf-8?B?YzdtdzVvSGNzNEVBOHE4aTFYT1hnMTRVRHpjenNhMW9rdVlaekVSanVnaUYx?=
 =?utf-8?B?OW1hQ0g5cWI1VEdWV1ovVm1RR04zTUNZNDJ6VGh2UFB3RFUzdG43a1BjcWRY?=
 =?utf-8?B?eWZSQUVpUVZXMVZFZVV2VnhlNFFQZDJ2aCtCa0MrVWsrMVEwWGUwYVBsbEZK?=
 =?utf-8?B?T1VmM1h1TmNWL0xEZHRPckp3QWdtUlhEWmMyZ21rVWIyOFhub2ZFaWpxTmNX?=
 =?utf-8?B?TE11QzYxekRLMUJIN3hnQ0NJSE9pTWw3bmxDeGczRFNKWWpPa3FIMU5LVzBl?=
 =?utf-8?B?TGdVTXJqZHFrRElSYXBCeGZZZis3UVBjV28wUllRbjBmTnFjQlpnb2hYUERZ?=
 =?utf-8?B?R3NpV1VTd0N2Ny9XS21yOUtoYkVmY3BZK1F3Syt6bFV0NzArdGpBd1YzVjcy?=
 =?utf-8?B?aGdiSy8vVmx0TXE4dEY1QU02T05zU2pNOWJtc1ppaUlOSVRyd2JvVHdWSDJh?=
 =?utf-8?B?bFRnQnBpaUlQVEZuSmJVOHowS1JHcWsxRWk4Yko2Q1E0cUhDeFQxWjhRSlZI?=
 =?utf-8?B?eFJlQlVEZ0pTUVhIRDl2UVdNL29iK3FvOHYrcjFqbHNNQ21jUlUxVklVTnR6?=
 =?utf-8?B?QzBIaFlqNkNjZmNPb095NDY2d1VBdE4vbGtPVzhkTnpQYlAyMjZ6Q0l6cVg2?=
 =?utf-8?B?RmNybjZieTREaXFUVk9IYkhwS2hKR290dXRpMTdEdFVOeEtZdTF1MU1RR1lF?=
 =?utf-8?B?aWd3YWdhZG16WmI0T3NjWWd6REJ0RTVSL0oyRnhRd2o1S3ozNE4zNlpaeXRx?=
 =?utf-8?B?SXczbm1uVlJNc2xpc2pOcExFeWFwMWJMOElYVG03dWI1WkplUEczWllDY3Qz?=
 =?utf-8?B?VC9XdmtBSWUyVVQ2WUd3MzJpbWhCYlVMSlk3N2dCVE1pVjBrWmhRdHhJRmFr?=
 =?utf-8?B?cWxjdjVUOFNMTTA0ZnBrRTZxWUNnQVMxWVRHWDUrZTN6MTdtTWNleXMvbTdE?=
 =?utf-8?Q?eQsf9kZs207BCNh/wXl9zxqdOXILgqOd5SbvXQz?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42972690-8c1e-47d4-f5c6-08d98ee250d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 07:14:51.8286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MoQPtvuey0GPyNtoZTUhIyJ0TGUdlu10hXYnpFITPk22xPMUb6tbt6w9rbwvq6urXzZiB8fCLNrcGyaZyaE5WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0401MB3656
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiBPbiAxNC8xMC8yMDIxIDA5OjE1LCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPg0KPiA+PiBJ
bXBsZW1lbnQgdGhlIC0+cmVzdG9yZSgpIFBNIG9wZXJhdGlvbiBhbmQgc2V0IHRoZSBsaW5rIHRv
IG9mZiwgd2hpY2gNCj4gPj4gd2lsbCBmb3JjZSBhIGZ1bGwgcmVzZXQgYW5kIHJlc3RvcmUuICBU
aGlzIGVuc3VyZXMgdGhhdCBIb3N0DQo+ID4+IFBlcmZvcm1hbmNlIEJvb3N0ZXIgaXMgcmVzZXQg
YWZ0ZXIgc3VzcGVuZC10by1kaXNrLg0KPiA+Pg0KPiA+PiBUaGUgSG9zdCBQZXJmb3JtYW5jZSBC
b29zdGVyIGZlYXR1cmUgY2FjaGVzIGxvZ2ljYWwtdG8tcGh5c2ljYWwNCj4gPj4gbWFwcGluZyBp
bmZvcm1hdGlvbiBpbiB0aGUgaG9zdCBtZW1vcnkuICBBZnRlciBzdXNwZW5kLXRvLWRpc2ssIHN1
Y2gNCj4gPj4gaW5mb3JtYXRpb24gaXMgbm90IHZhbGlkLCBzbyBhIGZ1bGwgcmVzZXQgYW5kIHJl
c3RvcmUgaXMgbmVlZGVkLg0KPiA+Pg0KPiA+PiBBIGZ1bGwgcmVzZXQgYW5kIHJlc3RvcmUgaXMg
ZG9uZSBpZiB0aGUgU1BNIGxldmVsIGlzIDUgb3IgNiwgYnV0IG5vdA0KPiA+PiBmb3Igb3RoZXIg
U1BNIGxldmVscywgc28gdGhpcyBjaGFuZ2UgZml4ZXMgdGhvc2UgY2FzZXMuDQo+ID4gSXQgaXMg
cGVyZmVjdGx5IGZpbmUgZm9yIHlvdSB0byBkbyB0aGF0IG9uIHlvdXIgcGxhdGZvcm0sIGlmIHlv
dQ0KPiA+IGNob29zZSBzbyAtIEhlbmNlIG15IHJldmlld2VkLWJ5Lg0KPiA+IEJ1dCB0aGUgcmVh
c29uaW5nIGlzIGEgYml0IG9kZCwgYmVjYXVzZSB5b3UgYWxyZWFkeSBzZXQgU1NVNCBmb3IgeW91
cg0KPiA+IHNwbS1sdmwsIEFuZCBvbiBTU1UzIHRoZSBkZXZpY2UgZG9lcyBub3QgZHVtcCBpdHMg
aW50ZXJuYWwgdGFibGVzLg0KPiANCj4gSGliZXJuYXRpb24gZmxvdyBpczoNCj4gDQo+ICAgICAg
ICAgLT5mcmVlemUoKQ0KPiAgICAgICAgIGNyZWF0ZSBtZW1vcnkgaW1hZ2UNCj4gICAgICAgICAt
PnRoYXcoKQ0KPiAgICAgICAgIHdyaXRlIGltYWdlDQo+ICAgICAgICAgLT5wb3dlcm9mZigpDQo+
IA0KPiAgICAgICAgIHRpbWUgcGFzc2VzDQo+ICAgICAgICAgc29tZW9uZSBwcmVzc2VzIHRoZSBw
b3dlciBidXR0b24gb3Igc29tZXRoaW5nIGVsc2UgYWN0aXZhdGVzIHRoZQ0KPiBtYWNoaW5lDQo+
IA0KPiAgICAgICAgIGtlcm5lbCBib290cw0KPiAgICAgICAgIGRldGVjdHMgcmVzdG9yZSBpbWFn
ZQ0KPiAgICAgICAgIHJlYWQgaW1hZ2UNCj4gICAgICAgICAtPmZyZWV6ZSgpDQo+ICAgICAgICAg
cmVzdG9yZSBtZW1vcnkgaW1hZ2UNCj4gICAgICAgICAtPnJlc3RvcmUoKQ0KPiANCj4gSXQgaXMg
dXAgdG8gLT5yZXN0b3JlKCkgdG8gZW5zdXJlIHRoZSBkZXZpY2Ugc3RhdGUgbWF0Y2hlcyB0aGUg
bWVtb3J5IHN0YXRlIGFzIGl0DQo+IHdhcyB3aGVuIHRoZSBoaWJlcm5hdGlvbiBpbWFnZSB3YXMg
bWFkZS4NCk9oLCBvay4gIEkgbWlzc2VkIHRoZSBwb3dlcm9mZiBwYXJ0IGJlZm9yZS4NCg0KVGhh
bmtzLA0KQXZyaQ0KDQo+IA0KPiA+DQo+ID4gVGhhbmtzLA0KPiA+IEF2cmkNCj4gPg0KPiA+PiBB
IGZ1bGwgcmVzZXQgYW5kIHJlc3RvcmUgYWxzbyByZXN0b3JlcyBiYXNlIGFkZHJlc3MgcmVnaXN0
ZXJzLCBzbw0KPiA+PiB0aGF0IGNvZGUgaXMgcmVtb3ZlZC4NCj4gPj4NCj4gPj4gU2lnbmVkLW9m
Zi1ieTogQWRyaWFuIEh1bnRlciA8YWRyaWFuLmh1bnRlckBpbnRlbC5jb20+DQo+ID4gUmV2aWV3
ZWQtYnk6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0KPiA+DQoNCg==
