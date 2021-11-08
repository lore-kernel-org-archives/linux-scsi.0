Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A47D8C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 18:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8107E61503
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 18:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234045AbhKHSDZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 13:03:25 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:20151 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233811AbhKHSDX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 13:03:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636394437; x=1667930437;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QTZtWEsZ8avsdGqTz2VPvUDuNiVD0to+oAWzOtr4Ea8=;
  b=l1L1kvr2LxQr9jfHowUfby78FnJTvfFOWgFa7Uo2rfOLHPcQ425z4bDV
   jj1/jW0UsOsGkK0n/fdRi5Jiup5HDNyiFoDu5hguOyDN75jC+3mStouwS
   CGKA1cEwgVHIP9UbiiG0QuN+cS8SHTGYnwOWwgjNHm+9veWZ3LlPM2uhi
   AUDi8n6kiz+6Egl7y04+5P+cDkYoMMw/BEVY/dPLGbUS0q9rAL2wiaB2k
   jNUcKZWtwYr45Spomp+TutPDvzqUzJpRLDot+XViFIjlCosfBPowSoLbx
   Xt52txU1z0IKpmrs+6OJNoUa2AlZ9E2OvX9tMCq9rZu/LW1AFCFK7EQvq
   g==;
X-IronPort-AV: E=Sophos;i="5.87,218,1631548800"; 
   d="scan'208";a="185040770"
Received: from mail-mw2nam08lp2177.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.177])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2021 02:00:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLn5qoMKYeuTVb2jC027JE351ZhUWXcvQ+WSvaD8yTXZ3pzCFHClLzAEjLkCq17Gub7xba5E+3t+Prx+BN5HCFzu5nZIkQU1wMvssdQ5oYIrtNP/+zuQ12EkGlKq90aFhMZxQZvauJYJioitYcQFAJuC47MWD/3rRm2xb9cCEi3xnXour84wwUFEWoLs+GLA89HGC0MZo4738Bg1b+awAzUxiK+hwTWn5mSZyr8pQYz0ewGLiQoVvbGogyWRYXejBNU8HZUEf45W5/yKy8Lh6cWkpR7yjaeDSvSxRaTKpryT9oRjXasrnhIqwoEFvXOQmE11jMkwi84adX3QHchTmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QTZtWEsZ8avsdGqTz2VPvUDuNiVD0to+oAWzOtr4Ea8=;
 b=bhshRRdHiceBhOHWgJ0lCkPofAc8pczb0O3apk3JowtRAstY9PTk2v7fwyx0WmRD8YSyARHtUAkd6I5EgJ5p4NrRlR3DzfatYu7TujJBycQtxJfQl7aMJd5vV7K544KaJwYD14VeWU6e3GBB5FhtiAZlLEbKFqnZKraNmj4qV00+oh9GfzniFFTI3kA7OUyWlaod7BDWwKaxNMw6MrGVstWEX1xSV3MzRhZXYxu7og1alwFZNeEbLJc+URMaGQbeDXAlL95e2ckAA0tx/+hfNvec4FLAOZAZpIQsfdyuoaCPtFv0D41qK9X4ZBptvagz2bLV537oZUhMswWIhdWMjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QTZtWEsZ8avsdGqTz2VPvUDuNiVD0to+oAWzOtr4Ea8=;
 b=k/ThKHQH+NjjZXKiMZ482u5CwK8RkeEDxVwrrfoW4fXCsgaYVlTs86BQGfDDBdjGNg3vGqBPDJEJoNGP2cNBcfl6AjLWWmHf2HKR+mrJQBZ+6rQhQY0w/KYVeRne/3LEXLddSO6hjN10esKoOjx8bZ/wnV7cWtlRBuEP3/rsiR8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0730.namprd04.prod.outlook.com (2603:10b6:3:f9::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.13; Mon, 8 Nov 2021 18:00:37 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4669.016; Mon, 8 Nov 2021
 18:00:37 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: RE: [PATCH 2/2] scsi: ufs: Return a bsg request immediatley if
 eh-in-progress
Thread-Topic: [PATCH 2/2] scsi: ufs: Return a bsg request immediatley if
 eh-in-progress
Thread-Index: AQHX1Jllkib5cKZqeEODTm5D9rZeX6v536AAgAAAlgCAAAOxgIAABJgA
Date:   Mon, 8 Nov 2021 18:00:36 +0000
Message-ID: <DM6PR04MB6575E77BB149D632050324A2FC919@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211108120804.10405-1-avri.altman@wdc.com>
 <20211108120804.10405-3-avri.altman@wdc.com>
 <fa7dae1f-06ac-9d5a-616d-cc00c38e5feb@acm.org>
 <DM6PR04MB6575F4831649503EE848C4CFFC919@DM6PR04MB6575.namprd04.prod.outlook.com>
 <06c95606-ac89-5750-224f-04c72b5cc111@acm.org>
In-Reply-To: <06c95606-ac89-5750-224f-04c72b5cc111@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ca8162c-1b38-45cb-aedc-08d9a2e1ab0d
x-ms-traffictypediagnostic: DM5PR04MB0730:
x-microsoft-antispam-prvs: <DM5PR04MB07308E4279CA6731A49B1283FC919@DM5PR04MB0730.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eymM3jDLRbtGx09877WsQ7T0nJYTl9rkWr+eC7OMennCliKpdCVXgobHvvsyGZ90Cwl99sZ1EKTyA6vVpPHr6/2akDOHl2PLD5KJFCy7hIfOVAlkhDSNMovZFUyjzfhUL59QNLpYtGRf+GCm/zIi4vke2MuUsHmLk8ZDhiIikB7JpNaiSybcsWcgHXbUUWtLNd7MxdjyRulFvGzG9RIYEzLRgGQbkO9GxZNnB4lIGLKrO77j1+m8A9yRN4uz5iO8iJW5g3NWGPIQON0pMCx3Q1Pjyc1eT3BULM1AIi82nz6l3xnQrro2KWit+wMVrOF/JRK2Rw6wv00gK7yWaw+mXyYRq/rrA7ApfA9mTraRYfCbezmoKwqriuBXpwdLuTUUafUz4oSF5apWtI3rblVFEuvSdp9s60EKeWPobI12xlaqUTojXQBUaDa3mUNdQfc2M06MH6doqRUoxYKbh3LGtgvs7rZqaK07xqWEkDSSZeJz9PF22zITcUV+nOmcYLcdeLy/YzDmQepa5Ye/SU6HvGw2zSGE5TADOvhJJ2sQRtq35PYpzpTGb9jqVv1ycp7VZf5IqMlp9BHsQmA6gGIr97z9dtLEwCdvkk2h9N2PjBw4Ry73D6JNDRKokTLdi2bNDVoyHKdLZbpFQrT72NSgbQlNhU3w5XTCG4A9X8o7kDjHa9wlnXoDgJ2TYyvR1Sd+8NTJjOXhfdHlSvQFH+4+JJ/nksX0e2bKX/YnLQjZ9gOuXL6q6Bu1ESs/m0+d8/7N4sTQHW6gI97FEm18ODUu2WRqazInIP+t7Q2oJSPvRn80a1giq8GNx6NgO6J/+WCNyVm35f5Mzov8hYR90A4y1A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(66476007)(66946007)(53546011)(4326008)(2906002)(6506007)(64756008)(76116006)(33656002)(38070700005)(122000001)(66556008)(508600001)(8676002)(38100700002)(52536014)(54906003)(5660300002)(9686003)(71200400001)(7696005)(8936002)(4744005)(82960400001)(86362001)(26005)(55016002)(66446008)(186003)(110136005)(118133002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VG9LbHpjWTA5a1NESnkxNGxrUGltNzVIN25rMGN1eUNDckFNckV4L2c5YXJq?=
 =?utf-8?B?bWJsb0VMVjRlOVVZVjFYNmJJYlEzWXZvR0w2VGtYWm1rdStxTFNaL1h4Zzh5?=
 =?utf-8?B?OHJ2blFmdFhuV2VyVGwwWC9hU0pNQXVRMHVZSUJyNmczL3JsT2lrbGs5MlhW?=
 =?utf-8?B?dnNQMUxscGFQYkI1YnhTNkZmbXFaT0h3bS9sbDF3bjlpcWhGTmd2Q1VrYWpX?=
 =?utf-8?B?WGJBenNUTVhVMWhFaGdrb0xqZTlINXFScWp0bW9oT2x3S3QwK2thRTZlQ2xk?=
 =?utf-8?B?QkxWOExmRlpaTS9vK3M0L1I3b05LakhEazk0c05wUEx3b0ZJcEpwWndtdTR2?=
 =?utf-8?B?R0VsaFV3S3JxMUpoTEswVnJsQ2Q4K015TGhGTGpqeElxaUhJbUhtYXU5TGtJ?=
 =?utf-8?B?U05MdC9HT2k0NzdKWFA4a29DNk9ncXpOYkdDbjVybXlLVCt1V3BBNUJVSjJH?=
 =?utf-8?B?T0s1cE5lTk5FdUxFV1o2RWs0L21Ed0FOdjlLTmVhWWcrMDU5c1lsMWhUazhr?=
 =?utf-8?B?QkprZERDcGE1dW80SmRoQjFyK3VIMFlMRFQ0Rk1ML05WTmpSTXgrTHp5dVRo?=
 =?utf-8?B?dUhVeXJzRG5QVW15ZENKZzNMRXNWZ3AxWWVjVDNMOWFnRzRQc2dGU01HYVcv?=
 =?utf-8?B?K2U5OXc4anprbEFtMzVxQmZEZWtvRm1VOUJjempyY1VXdjl2SGNRM1V0RWox?=
 =?utf-8?B?d2o5N3VrQXZ3TXpQeDV4am9QdUpVTk1NM2ozVHhBaWtwZ0krTmE4QmdKNkVI?=
 =?utf-8?B?cTl3YTFDWmo3QytrUXQzTmViblltK1BMeUIzVldUNk9DWWFyZlptOTFKb2VN?=
 =?utf-8?B?NGdPTk9sK2ZNVUJaeEEvL25nTGtoQm9BQ0hzR1h0MkFhRmZUZ0ZaQkNhd3FC?=
 =?utf-8?B?T2RuaWhjZGR3TmgyV2hkOGRYcUljTElZR3BoN1R6bERybjBpLzl0NlZDUnhu?=
 =?utf-8?B?MHFtTjZyU2t6a3ZBWHppMHk3ZFNGUWNtK25DM01ZTDNIR3BITTNraEJJaEZa?=
 =?utf-8?B?U0UwUGIraG1GWXcvd2g1c1FsMExtWjJKZjRhV0Vua3RDUmFMWjZzRTN2aXRz?=
 =?utf-8?B?TDdxVm4zbEk1TWsvbmhIT2hTa2RYQWtKRFdBSHE1bERhTm1HZ3hPbytoUGxi?=
 =?utf-8?B?eXBSektsNzNjYVc2UWpDa2tVaCtaNUNabTJyZWloNkVGeExLTTdNY0prRWZs?=
 =?utf-8?B?WWV4b2pTdCtWUktmK05BYWJPQjRaZnk5RW9NTllGMXozM09FdDlBcnNBR2Zj?=
 =?utf-8?B?L0gzeFhvSUJ6b1VuLzNkOE9TVGlkeFRVV09vdm4wa3ZVQ3VGRmFuVzVwSEIx?=
 =?utf-8?B?WmlhR2dnZDFLaTcyeDRCbWVvaW50Z00rTXpHcDd3WXYzL0gvOUNpRFZOT29M?=
 =?utf-8?B?QjJQKzRNWWhMMUtvSGlsZE9tMnVYV2dqZTNiWFYxakdzRTNFVFAwbURGaW1S?=
 =?utf-8?B?blpUMG90M0c2QzFpd05mL1UyU0RJd29vME5hSlM2bVpzNjFuVEdsVkYydnNj?=
 =?utf-8?B?M0tyMHlXQ0xqTnRMLytDa1pWYnQweVNNL0lsVmFEVnZ4eGpWNDVXaXpwdjdT?=
 =?utf-8?B?aEdCcDhFRVRsR1hQbitRSk1oZlJjaUQwODBzZFJKYWlzUFhGTitmNE5ZRGtm?=
 =?utf-8?B?MCthOEVINExTTUhmK2hmQTFQa091ekRCTTU1SzVrOGU2NTVuc0lRRjBzcmhQ?=
 =?utf-8?B?MTNhTUdIN0t2L3gvRFZBUlVnNmc4cFU5Zjk5djEyTWdReElkTjVjNlBPZmpW?=
 =?utf-8?B?WFFtQUxSekZOWDNFWlJYQncya3VoNnpqYzFqWHJCeFY1WGt4Unc4M2xSMTNz?=
 =?utf-8?B?ekVUQ0x2ZHE0RkhOaklFd0dVQ3RCWFZTR0NDVVR5cEdPcWtGSWt6Z1Q1bnY4?=
 =?utf-8?B?T0pLVlFNSDFMcllXK3VhQTBCQVBCeFVJbVRrV1phMXE5NCsrdG85KzNyWjBj?=
 =?utf-8?B?WnpwZ2FuMVZweGVNdzFVMVdVYlE3cVVObDFXYjBUcXBjS3Q3UzcyVGI2Rm5l?=
 =?utf-8?B?eTdTeDJxblg0UXFtay82UzFORndFdjlZTmpYSUdyUVZIM1diK2RRVE0yRUZ3?=
 =?utf-8?B?UllVdUpXRXFDM3oycTF2VWpSNFd6RzdWcWNySm5PU3oyUCszNVFhQS9XblFX?=
 =?utf-8?B?d1FGZGJxQW1WUnZJUGhxK1g1cW1OUjhMNy81RHlXQnV0Vk1jWGRMWGlRM1FT?=
 =?utf-8?B?aFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ca8162c-1b38-45cb-aedc-08d9a2e1ab0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2021 18:00:36.9334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3s3F5oyMEENmc3hB11yuzZo0mZIGwhiZUMslAdqHcNaagDxNuu9eFy9xseAjYgn/DGiEyXf6rChnFzfDK/8lyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0730
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiBPbiAxMS84LzIxIDk6MjQgQU0sIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+IEkgYW0gbm90
IHN1cmUuIEkgd291bGQgZXhwZWN0IGEgcmV0cnkgLyBwb2xsaW5nIC8gb3RoZXIsIGlmIGFueSwg
dG8gYmUNCj4gPiBkb25lIGluIHVzZXItc3BhY2UgYW5kIG5vdCBpbiB0aGUga2VybmVsLiBlLmcu
IGEgY29tbW9uIHByYWN0aWNlIGluDQo+ID4gdGhlIGNvZGUgdGhhdCBzZW5kIFNHX0lPIG9yIG90
aGVyIGlvY3RscyBpcyB0byByZXRyeSBvbiBFQlVTWS4gTm90DQo+ID4gc3VyZSB0aGF0IHRoaXMg
aXMgdGhlIGNhc2UgaW4gdWZzLXV0aWxzIHRob3VnaC4NCj4gU2hvdWxkbid0IHdlIGFpbSB0byBt
YWtlIHN1cmUgdGhhdCB1c2VyIHNwYWNlIGNvZGUgZG9lcyBub3QgaGF2ZSB0byB1c2UNCj4gYnVz
eSB3YWl0aW5nPw0KSSBkb24ndCBrbm93Lg0KV2FpdGluZyBpbiB0aGUga2VybmVsIHNlZW1zIGxp
a2UgYW4gdW5uZWNlc3NhcnkgY29tcGxpY2F0aW9uLg0KSWYgeW91IGZpbmQgaXQgdXNlbGVzcywg
IGJldHRlciB0byBqdXN0IGRyb3AgaXQuDQoNCkkgbG9va2VkIGl0IHVwIGluIHVmcy11dGlscyBw
dWJsaWMgcmVwb3NpdG9yeSAoaHR0cHM6Ly9naXRodWIuY29tL3dlc3Rlcm5kaWdpdGFsY29ycG9y
YXRpb24vdWZzLXV0aWxzKSwgYW5kIGl0IGxvb2tzIGxpa2UgdGhhdDoNCg0Kd2hpbGUgKCgocmV0
ID0gaW9jdGwoZmQsIFNHX0lPLCAmaW9faGRyX3Y0KSkgPCAwKSAmJg0KCQkoKGVycm5vID09IEVJ
TlRSKSB8fCAoZXJybm8gPT0gRUFHQUlOKSkpDQoJCTsNClRoYW5rcywNCkF2cmkNCg0KPiANCj4g
VGhhbmtzLA0KPiANCj4gQmFydC4NCg==
