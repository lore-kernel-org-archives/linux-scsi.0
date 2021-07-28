Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 648F3C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 07:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47C8B60EB9
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 07:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbhG1H2P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 03:28:15 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:59050 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbhG1H2N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2021 03:28:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627457292; x=1658993292;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6SlGO7bxVoC0E6xIeQfLVCD9SLcqMfaJ4UDG9+oJolU=;
  b=A7tb2OANxMfGmJcv2VQzpu2v3tNbYLoloFo/cBS1GyoBLQPDrdjSutGi
   SCIbbIFcyZvrP/br2VMQcB0b/0TD3VaCaJTERtwayekM1IzqcS+ebiyd9
   UUJWDkFjGQ8JEGhaThf4FQu3JiFaoZ1S7zTdZzZDq1jDFA8NPFaLR7a95
   gAg7i3hvkAINz9tuz/AQ6ETlwk8cD0hDengV+MTaq/eBxoEU2L6BW+xDg
   VT9PZAbjeK2/IL0NKntjN3rN+397Lh2huIidn0kSKTL7HCvkXkvRcsnQl
   sQJa329PRJqUNe9rHgl9HsFw7Y2J26KYi5tYj+xi5ep/60QP8DH2dhdFy
   A==;
X-IronPort-AV: E=Sophos;i="5.84,275,1620662400"; 
   d="scan'208";a="279503349"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jul 2021 15:28:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXgPQidiiPN8puAkEEzZBusjOslYPzHTdFGoBvjqKwmsC1ZRY36yHE6F/WnupYo0dcaZ/WfMMCAnmCwkiEkjofGZgHv7B/KVIPBqpeM/q0uz2IZadWqrkGZAWnFzBfV3BI6LcxhkQuQWm+Rt512tnOTfVPX8ZYfr7YEOBVnW0cI4GHrFFTSSrNK4z755Gvm/5oBTUkKuhgASf1saBF33iM6648S5vATihs6DiFRUl9bpJ5kJIrXiDq/JFDowyXiV6ogav3p/o5K9+W0CNSitHV7sp24Jh7uvncS1TiEj5zi2yXTBKOy/9e1wX2anSn3+MSls6l/NpRehy/vzmb62gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6SlGO7bxVoC0E6xIeQfLVCD9SLcqMfaJ4UDG9+oJolU=;
 b=RlvpAN9azjTe4+0Lt5sJEBbdqMtxCyFt5u2K0ttCPeD1YGZGzpAtOdo5Gz4mkMLRqdsoa0A9VLHBZP7Hkz0P1jhnGGi50dvBNr4r2U+E4POuSp3fzrlM77gCjWK8tHO2djNZcyvbzHHRFTjBPDgsSZaI3NJztHe3I4Mj11aTSGlWHdcAUti+YVrUNLi4Emvaow1qFCRmWMWkr01biE1kMXQl61yZ1deOJSPaC5cFkwkc+UniOlHJ5COjiYIvAkPWAZNhdjUl6m+srbVBK7taYDfjMeOGkm3yTaRqTjO4Yi9CRQVZ9w00OSGv/6hFR+Uxx3DWhFfbcCqtvKLamkrz3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6SlGO7bxVoC0E6xIeQfLVCD9SLcqMfaJ4UDG9+oJolU=;
 b=y2qermrYxuwi21U5/Q24s5NeBco70sAGkLHUlPvMBMVtLIqiq3guSKytPD26tPmlU5/JYr9JzSgw6GDqK/jrc67WRvD9Mkf8i61c7akvZOxjPJBuCrLdNWhHXw5cNsYllQF9UuznE0J6LgJcQ/ATqn4QhY1wprIYIylWeBpRQbc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6574.namprd04.prod.outlook.com (2603:10b6:5:208::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4352.26; Wed, 28 Jul 2021 07:28:11 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%7]) with mapi id 15.20.4352.031; Wed, 28 Jul 2021
 07:28:10 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Subject: RE: [PATCH 2/3] scsi: ufs: Map the correct size to the rpmb unit
 descriptor
Thread-Topic: [PATCH 2/3] scsi: ufs: Map the correct size to the rpmb unit
 descriptor
Thread-Index: AQHXguQLgVo9U1ii0ky5+6dEuQeYcKtX1umAgAAkK2A=
Date:   Wed, 28 Jul 2021 07:28:10 +0000
Message-ID: <DM6PR04MB6575191C52E5323A9754B2E7FCEA9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210727123546.17228-3-avri.altman@wdc.com>
        <20210727123546.17228-1-avri.altman@wdc.com>
        <CGME20210727123637epcas2p23457bd807cee66ec4c4e487a3a15ef33@epcms2p7>
 <2038148563.21627450982237.JavaMail.epsvc@epcpadp4>
In-Reply-To: <2038148563.21627450982237.JavaMail.epsvc@epcpadp4>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 043cdd05-3fd2-4363-d17d-08d9519940d2
x-ms-traffictypediagnostic: DM6PR04MB6574:
x-microsoft-antispam-prvs: <DM6PR04MB657476ACDA507DE4E027BCA4FCEA9@DM6PR04MB6574.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1N2Ne2+LkBoe78NvicXT9u/faoPmxwmMm4jKyUTO8OReh2zdCFjYXt/70MGAMGxJ1kCNTbOLB/ldYOQ7kSDoTidJD6hPqG7OWIfML+DgSJNKPT82Kz+t0v3mBONHmArqctXRjvy1GwBrRrOeGaHTaTkpYDD9IqhqqKLWkX16RX5LELRK+yN3C2B5MoUTYMQkeJZJii9/w+WaznlSYBv2KQoudoNZ7Vx60NMvbNGsaYIncy6yFwF8SuVyAhCERDHEXz0ytQhjTUMjuGmGr5zo0H6aFxmedXL4yRrrRdh43CoGOFFWY+Ib2PDKNurgcPl8/oEa9qhOzE5r+kxbSeouzuESjWqeJNBr8K08HTysbSyK4NrxNdjauql4apZCljCxK2GYAFsForsTAa0jxAGJJ0PFx+qPSd3SXr9djS4gYtwvIGPX6xnDCKkfF60aH8fYS76tU3JstsV+IHT/s5aCkP9oYK25emjV3VWUb0Pawv4+XQQ282KZMc/HCz6YoLfurLncJUVveG4FBlao+IVri5SyJ1pBzc3XSrH9PEiJiZa+DbC8F2ECDC3L9GpQwTOZNzmVxlYqgVq+6QSSopXqzWVGOVGBRwSWOAzzwV9X5RdxuD15AsT5EOJS30Uzo0wamnbeyQn++Wxqrn8FyLn6CpN4MCDj8SpwWrkRFN8K3E7dkIuyptv9KVYJmPupRDcjnzKzxeAqwA5bEk8f6J64Ng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(4326008)(110136005)(5660300002)(66476007)(316002)(66446008)(66556008)(76116006)(54906003)(55016002)(8676002)(122000001)(66946007)(71200400001)(38100700002)(38070700005)(9686003)(7696005)(83380400001)(26005)(8936002)(2906002)(86362001)(52536014)(64756008)(508600001)(186003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MjBpQlFvdXpYYklVcEk1ZlI1dXJWK29XL1BMSWdZUTBHUGR0ZHpyUitwWUZt?=
 =?utf-8?B?TTVUNE9GYkJaTTRsMzJKaGtCaWJLMXFUSFc4VHFucURnSkdqZjVodkpYK3F6?=
 =?utf-8?B?ODlWcHZHR2tQT2xZMVBuNm9XVkg5Sm9USnFQZVlxaU9hdlJmbjZ0MGtsd1li?=
 =?utf-8?B?WFdNamI1b2JGcjNDWDdwa2taS2prcUlqeDlMNEpIZnFCU2VIL1ovOVZsakI3?=
 =?utf-8?B?TThNUVZNbFY4eTZhd0VVYUpXcVE1QzRNZjFMV0hZeDU3RHlWRzVJemdCNnAy?=
 =?utf-8?B?a0czSWoyQ1BnRjRTY3pUOTRIRnp2SXA3U2FMQi9sOUh2azRJTHVTSUFVL09n?=
 =?utf-8?B?QkxpM0FnNU9tTnI0T3BzTzh5RGVaTTVtZDB0U1F6b0N1V2lTcEdkWHFxTHlm?=
 =?utf-8?B?S08xUjk1alZrSjdaK28zeTNFQmZtMmEzc0cxZzh6UUhNUDdCWXlveG9xdzRh?=
 =?utf-8?B?eHEvNitXZ3A2Z3Y1MXRtS1dZYVZhZVFDbnMzNkx5ZzA2a2xOcFhrQVVwODRl?=
 =?utf-8?B?emhKRm92NU84SUREejhlOTBVZGpyY2czVjFpYWF0QUdzZWRrbVhyUWRuaVZx?=
 =?utf-8?B?Y0hCRnI0MWxxSit3K3VwenFUVTJwZ09SYkpPa3FEdVZEVW9zVDAvWmQrYlFZ?=
 =?utf-8?B?bVRtY0RRVkt1ZXVKZzJEOGhGa3J0bkdNWG9UY2JKZ0JZbEZTTElHVDV5U0R3?=
 =?utf-8?B?OHJSanhLZVhtOVdRc0Z5dlJYQVMrRUxIWHRhUUd4WVl1aDFkUEtZYVJYd0Ey?=
 =?utf-8?B?SldkTDh6b0piYmsxcktxWndBUDFpd1RlclRhUUVZL1hMeklzM1ducjBxNHVM?=
 =?utf-8?B?UXRJNDQ0TUtITVdvaXZ3L3lFTXh2dk4rUlp2Z2MrNlJHNzg4QjR1c1M5MGpo?=
 =?utf-8?B?c1NaWjZPT3RWTFU2bk54OTdhalpXOWVxZDhrQ1lZQVcxSXJPSnJUWXl1NmpL?=
 =?utf-8?B?MlBDWWRxTUMvMUFLdWhPYVNITzd5MGZvZVpjQ2J6MUh0N2VtMHd5b3VyQm9a?=
 =?utf-8?B?ZEtNZ0UzNzMySTFPRi9hV2dzZG1NTUkxQlZQQ2lsMEJHWHVKaEhyT2lKUm5j?=
 =?utf-8?B?OW1hTUFibXYyejVWMDE5NEZxTUNtSVNiUEFLakpxdHg4VWp2QjVEdFl1eUYz?=
 =?utf-8?B?WjUvcW5ZY3hpbk9BekhoNDUvdUEweFQyZXVtZm9KQUFkM3VGeVd6eE84NlRV?=
 =?utf-8?B?VjF0WXRyWmgrTjlONHdaU1dOc01YSWtzS0oxcm9uTTFTVzB4ZEUvNDRsSjVK?=
 =?utf-8?B?dURFNCsxcDZjRmdLekZjY3FQYWQxT29KMzlnZEJWWExkanYrUGhSZm5HZjRu?=
 =?utf-8?B?MU5pL3Y2elY5ekdIeTJRelVrWk1WTVRJK0srZkJNY3NyaFRSSnZIbjRRcU5B?=
 =?utf-8?B?Rm1KRWtXNkkrNzFQSGEwa1p1UTNrY0YwZ3JsLzd0WEFLWFJMdlFDMXBpdGkr?=
 =?utf-8?B?c0VBVTQxVmZVQ1FlVW5qWFM4blVDUC9POUJMWldwaEg2V1lrd3ErbUhKakRi?=
 =?utf-8?B?QXRGVTdXN0dBWkdrdnBIMllDbzd6NUNlZHZMMDV0ZldXT054ckFDNmNaOU0z?=
 =?utf-8?B?RjFyNU8zRmI2ZCtNbEQ5dWFjMjFLUCtFOWFucXJDcC9FWGh4NUQrTzBiYytO?=
 =?utf-8?B?cnBlbXVMdWVBMzFjdCswc2J1QWZEMHhFZ3hPbUNqU2MxWlFPMXdpd1Z2UGlr?=
 =?utf-8?B?azBQaTRrREFNRFVpSEo4cGxtc3JVV1l1RzhMVk1lVlkwcHJ4OHF0aDVmRGJn?=
 =?utf-8?Q?2NCtPsAzgUBZoOgMJk=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 043cdd05-3fd2-4363-d17d-08d9519940d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2021 07:28:10.7546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o3v4ZSAafdtjjtMqudOYrQSdfYI8NY1jrss55dmbx95WnvVwLQrvV+7Dq2m98YkmPf1+3rGHhtiOZOtLw6HzBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6574
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBIaSBBdnJpLA0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMuaCBi
L2RyaXZlcnMvc2NzaS91ZnMvdWZzLmggaW5kZXgNCj4gPiA1NzljZjZmOWU3YTEuLmQwYmU4ZDRj
ODA5MSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmcy5oDQo+ID4gKysrIGIv
ZHJpdmVycy9zY3NpL3Vmcy91ZnMuaA0KPiA+IEBAIC0xNjcsNiArMTY3LDcgQEAgZW51bSBkZXNj
X2lkbiB7DQo+ID4gICAgICAgICAgUVVFUllfREVTQ19JRE5fR0VPTUVUUlkgICAgICAgICAgICAg
ICAgPSAweDcsDQo+ID4gICAgICAgICAgUVVFUllfREVTQ19JRE5fUE9XRVIgICAgICAgICAgICAg
ICAgPSAweDgsDQo+ID4gICAgICAgICAgUVVFUllfREVTQ19JRE5fSEVBTFRIICAgICAgICAgICA9
IDB4OSwNCj4gPiArICAgICAgICBRVUVSWV9ERVNDX0lETl9VTklUX1JQTUIgICAgICAgID0gMHhB
LA0KPiA+ICAgICAgICAgIFFVRVJZX0RFU0NfSUROX01BWCwNCj4gDQo+IEJ5IGFkZGluZyBRVUVS
WV9ERVNDX0lETl9VTklUX1JQTUIsIHRoZSB2YWx1ZSBvZg0KPiBRVUVSWV9ERVNDX0lETl9NQVgg
aXMgY2hhbmdlZCB0byAweEIuDQo+IC4uLg0KWWVzDQoNCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ID4g
aW5kZXggNzRjY2ZkMmI4MGNlLi5lZWMxYmM5NTM5MWIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMN
Cj4gPiBAQCAtMzMxOSwxMSArMzMxOSwxMyBAQCBpbnQgdWZzaGNkX3F1ZXJ5X2Rlc2NyaXB0b3Jf
cmV0cnkoc3RydWN0IHVmc19oYmENCj4gKmhiYSwNCj4gPiAgICogQGRlc2NfbGVuOiBtYXBwZWQg
ZGVzYyBsZW5ndGggKG91dCkNCj4gPiAgICovDQo+ID4gIHZvaWQgdWZzaGNkX21hcF9kZXNjX2lk
X3RvX2xlbmd0aChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBlbnVtIGRlc2NfaWRuDQo+IGRlc2NfaWQs
DQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpbnQgKmRlc2NfbGVuKQ0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaW50IGRlc2NfaW5kZXgsIGlu
dCAqZGVzY19sZW4pDQo+ID4gIHsNCj4gPiAgICAgICAgICBpZiAoZGVzY19pZCA+PSBRVUVSWV9E
RVNDX0lETl9NQVggfHwgZGVzY19pZCA9PQ0KPiBRVUVSWV9ERVNDX0lETl9SRlVfMCB8fA0KPiA+
ICAgICAgICAgICAgICBkZXNjX2lkID09IFFVRVJZX0RFU0NfSUROX1JGVV8xKQ0KPiA+ICAgICAg
ICAgICAgICAgICAgKmRlc2NfbGVuID0gMDsNCj4gDQo+IFNvLCBpZiB1c2VyIHNlbmRpbmcgZGVz
Y19pZCBhcyAweEEsIGl0IGNhbiBub3QgYmUgZGV0ZWN0ZWQgYXMgaW52YWxpZCBkZXNjcmlwdG9y
Lg0KV2hpY2ggdXNlcj8NCk9oLCB5b3UgbWVhbiBpZiBzb21lb25lIHVzZXMgdGhlIHVmcy1ic2cg
d2l0aCBzb21lIHVwaXUtYmFzZWQgcXVlcnkgYXBwLCBsaWtlIHVmcy11dGlscz8NCldlbGwsIHRo
b3NlIGFwcHMgYXJlIGZvciBkZXZlbG9wZXJzIGFuZCBmaWVsZCBlbmdpbmVlcnMsIGV4cGVjdGVk
IHRvIGtub3cgd2hhdCB0aGV5IGFyZSBkb2luZy4uLg0KDQpBbHRlcm5hdGl2ZWx5LCBtYXliZSBp
dHMgYmV0dGVyIHRvIGp1c3QgcmVtb3ZlIHRoZSB1bml0IGRlc2NyaXB0b3Igc3lzZnMgZW50cmll
cyBmb3Igd2x1biBhbHRvZ2V0aGVyPw0KVGhleSByZWFsbHkgbWVhbnQgbm90aGluZyBhbmQgc2hv
dWxkbid0IGJlIHRoZXJlIGluIHRoZSBmaXJzdCBwbGFjZS4NCldoYXQgZG8geW91IHRoaW5rPw0K
DQpUaGFua3MsDQpBdnJpIA0KPiANCj4gPiArICAgICAgICBlbHNlIGlmIChkZXNjX2luZGV4ID09
IFVGU19VUElVX1JQTUJfV0xVTikNCj4gPiArICAgICAgICAgICAgICAgICpkZXNjX2xlbiA9IGhi
YS0+ZGVzY19zaXplW1FVRVJZX0RFU0NfSUROX1VOSVRfUlBNQl07DQo+ID4gICAgICAgICAgZWxz
ZQ0KPiA+ICAgICAgICAgICAgICAgICAgKmRlc2NfbGVuID0gaGJhLT5kZXNjX3NpemVbZGVzY19p
ZF07ICB9DQo+IA0KPiBUaGFua3MsDQo+IERhZWp1bg0K
