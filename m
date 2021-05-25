Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26286C2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 08:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0978261400
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 08:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbhEYI0a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 04:26:30 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:56168 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbhEYI0I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 04:26:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621931078; x=1653467078;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w9RshUuUfaTLGRMDQVWmDe8fiY9IpBAOjL5S+U3Q9xw=;
  b=e+y2R9AkoU2B+Fjb/x1KHIlP+st0eDBLgi2XnwjpDa/bVH7aai77n3YZ
   jgEhhpfVSaod7y0hP4tnZ6TKl/s9lgl4xk+CzBvSW2G7Tdx80/vDkK42W
   gTTYYbDyurzP9Fm/5t9IZmECfRjWTiM3ILOhmgMViY2ZKFT7AzljnW+dp
   6xwNhdTx/O4bbqOiIDXq+M4VMK1Z03kvKWXRhzeFLK8o8SLsWOcUGs2fY
   QkSulSx6ZiXuSrTAzVavc+aM476z4m+2+J4nrfwQzQ2J83nZsGSivaOPw
   AK9kJlParjlmUBf8ZdAD88ocJxIaK5ntFWdVfdDM6QmlHf11fhq1OXqfe
   g==;
IronPort-SDR: qMT5zF7TVmgYjnho+9d/htA06gGzYTMYhTeln2AIh+bM6ujrL4+IeOkecqfIYs0YbtBpvfp5ux
 aJ78d+d7p+/8DO05TJLEOyIGrhNYQXidRzHGgE6LCs+xgJuxbOvKFCmyy6PhN9+ARvhfl6qCQ/
 T6OM3RQlbiDDfmHTcsfRGpqebeOQECvOnslP2bZRW1YhWiGld043SUzDOhfeWNVrZyjcLCMl4U
 9OYsR1QbBpAYGSiWCsdEhfm3L38d5xAOXkFO8qmnX0VCx4Yw3B4a5mMj5cthvzLLnB310L/eLS
 xk0=
X-IronPort-AV: E=Sophos;i="5.82,327,1613404800"; 
   d="scan'208";a="280633084"
Received: from mail-mw2nam12lp2048.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.48])
  by ob1.hgst.iphmx.com with ESMTP; 25 May 2021 16:24:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jq5IKLxDD/4h8q0AbYEi4VfcE8yMdX7FfEz8LomaaDMdAOGueN7xcn3GilXjd466775E8gg01A6ASzrHKvKMeVddCzKneRI/kV4N/IARzliqx6odvtXzFZw/Ja1KqyrDB5+QacKO5xosxsU2TrExC6S109XVRx3Q0bnBSQj9muvbTYsBJGI3op5nbCng5k1Xfa4LxDIrJKFnv1OD1yFZp/lltaCfIEiMiBT5ewI5kn9zTLLR0POVyiP9h3lJ/NA7Yxz9ld79P8Y1Uor+aVzW4XWKj7TnD+tIcs7EiPSp1Zpsb4FqVHIP3BqPKtmN+7vL4Mp0WC1mfDOtMFv/Wa1opw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w9RshUuUfaTLGRMDQVWmDe8fiY9IpBAOjL5S+U3Q9xw=;
 b=abKxp4QvOd+99v6NbWGWldtF1Gy3SRtxEnyL51DQ2TOrDgoFJ9No8ER2JQf7hCsLulJZrfGQEC/s3RbNNg24jeKHEKJ8Y9lxCTyzAT6iRCiV9d57ag3xbN38f4zaIM2jJypLeFaY7DkFD4uEjigTEMgYKdaK8YnxmXQ0tbhlWtSWAsU6HTLr0yiEKjqffWnGdC9rLBhfP+RH8nH2Q/esTF/8nnSnDHCGBux2THZ7vNRqdcYYQnPW3QJM8wsA7u9c7J8rVknEtvMWE7YZN2TvrlwgkHQulpQ7fjn7WdjYaXALfb/m0m0FbjV5t1mmD1DublqXRvA33zspppE5isGrmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w9RshUuUfaTLGRMDQVWmDe8fiY9IpBAOjL5S+U3Q9xw=;
 b=VGcMQ+M2x1172SfQ7PfPv7wzDCiMf3rihHRiLA8fQkBdR0SYUKzP8LFSJARduSPl6jkb2iT0RAKQfu6Odx2NEQ4FD7Lq5vaal7duQ3ksZ6TRJg6d9yoPe6FbyIZBgsNSVxq1nh9UVEwtx5XcanwAe2aNg4P2rdncf+hOQ0L3QVk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4026.namprd04.prod.outlook.com (2603:10b6:5:af::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.26; Tue, 25 May 2021 08:24:30 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966%5]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 08:24:30 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
CC:     Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: RE: [PATCH v1 2/3] scsi: ufs: Optimize host lock on transfer requests
 send/compl paths
Thread-Topic: [PATCH v1 2/3] scsi: ufs: Optimize host lock on transfer
 requests send/compl paths
Thread-Index: AQHXUHgHUX4+5y22lkmg8exJdO90rKrzENmAgABaTgCAAHAxUA==
Date:   Tue, 25 May 2021 08:24:30 +0000
Message-ID: <DM6PR04MB65752DD2F442C178B2D0233AFC259@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
 <1621845419-14194-3-git-send-email-cang@codeaurora.org>
 <41a08b3e-122d-4f1a-abbd-4b5730f880b2@acm.org>
 <d4ff8e1a-f368-6720-798a-a2a31a4d41fb@codeaurora.org>
In-Reply-To: <d4ff8e1a-f368-6720-798a-a2a31a4d41fb@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a246c1f-3f92-44cf-f3bd-08d91f56849b
x-ms-traffictypediagnostic: DM6PR04MB4026:
x-microsoft-antispam-prvs: <DM6PR04MB4026181F1966F147B6FAAEBAFC259@DM6PR04MB4026.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d05LY/RTq7lEApMH7PODwv4rLBsdTgDDr/LawGHt7wf//ipedV831BQ0DEIrG3tNB1BBNe4feFRENx8lFzrdQfzLmlsmzGL0kHCm5Llyw+q7GO5tRxLBfCGzq9zn9wh6mPue7CidTefeb5Y6aROlMSPDJWW4Bv+ZIqMwwUdSewnJISUcvvEY5UGUSCTJP1/2Ag6ek9RWCEjiILDaAOuequkw6IiMVQpztjAEHiGrvy00RdF2h1sv7xXoFldtPDdN1A1+aNoxEVPqSFeFLcez4aB31UWh6qbJhKNFqeHVJToG40DdAZDqjPMQHzFr7Tppmj8sJ+QUAKBNgCT41FtGz7XO+eFSvq/Z7cw7iDMYYcSUcVrkBHxlaw2MZk3F9v3z+yo0SApSOiB/ba/mMXQLCwRK6QGXm1uBw4csQx/64ZdYOevS2LjcWG8C8eTiB/6CxYUJHv43h93ETxMXTR9z22R/bGh0S6+ockKbfmU9fjZgdyBDAhI0ah46pVyiDDkspE6IOD3BqtSpK8u85zW7/ec3OwPpRCV/0t6noP/PE44eX6W4qlZ8LUCydrcEqiOi058bgQSJXOUESchD+9z9PYQCPZ8a27cvhlTLFOBu/4s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(7696005)(186003)(66446008)(2906002)(53546011)(66946007)(6506007)(478600001)(66556008)(66476007)(83380400001)(33656002)(8676002)(5660300002)(8936002)(55016002)(9686003)(52536014)(316002)(64756008)(7416002)(76116006)(54906003)(4326008)(26005)(122000001)(38100700002)(86362001)(71200400001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MWVuUmFnUFNjOVY5dENsazJ6NlQ5bmZkSk11VFc0SFNxZUNPUEYvcW9OMi9z?=
 =?utf-8?B?OGV4bG5OVjZGTGhQVkUrNDltZ1lyU3BTbWNJdWtiTmtmL2piZng0a216SWU0?=
 =?utf-8?B?cTRjMDFXRlN4bXlvSWY4clRmaUJ2Y2hpQkYzek9ZdzYxQ0dvclR4ZlRpeTdy?=
 =?utf-8?B?cXdNUEgxVDZ6WGxEdll3OVp2WkdSM29VWGE2cnIrODV1dFJrRjdGR0FMQS9v?=
 =?utf-8?B?NzNVS1RhL2szRDBOYjBWZzRPS3BmeFQvQWtWZEVWMmJ2aU9ZS0pSQ2taQ0R1?=
 =?utf-8?B?ejFUNGRtSDR5ckx4RlJyT1VySnVsTGNrdGttRVZxYW1jQUFmVDBDSmxYeFY1?=
 =?utf-8?B?WGZjWjFjcmllcUF3UzBKSWg2aTNsejc1UFNBd2tyNFF2RzZxR3NYekd1dFJL?=
 =?utf-8?B?ZVhNVUZ3c1djZldDWUV1S0lUZmtTZmhLaTBtRlhlQXg5RWo5S0ZCakE0Vk9Q?=
 =?utf-8?B?SzRncDErM3VLbU9ETFFheFJzdWZCYUVwSzJHakNBenJzeDd6M1cvSGJVNFZ3?=
 =?utf-8?B?K1RsK3NoWFFacXpMV2NiMXZWTnk1RTRxbi9DU2JEMGZGcjlmNC90blZiLzNN?=
 =?utf-8?B?SGFscmt6c0NZQ1Rock5yUVJSYklHc3lFS2RYZ0VBSTJrVm15dUV2bkdZd1Z1?=
 =?utf-8?B?OWhrK05DQTd0ZGNQUTUwczN4U2ZmdGhSbDdIQUdCREJSS29WUE9FMFFENXFo?=
 =?utf-8?B?RFZ1cmFnWTVMNW5HdzU5azRyMjJHcHc3SXFoUzFHS1NOSlhsYnZQaSs2VDF3?=
 =?utf-8?B?TUtMenNVYitPUGR2dnJGRFV0TVZPZXEwSEZBa2h0bE52TGxtWlFOek93Zkp0?=
 =?utf-8?B?ZE40QlBWeDE5akJ2UnNMZ3JLU0xGUENaLzVpQU93RHFOVCtnci9aOTFMUUdU?=
 =?utf-8?B?YjhnTWF3ZE9WL1JaTHpGU0VrUUc5TnBlSHYwRmRwNWxTV1pQOTViZGtSTTFy?=
 =?utf-8?B?UnNjblJZZmJoZmRiR1M5NzNsNjZDZXd0cHMvLzl3ck5xZ0JjL1lWaEFmT0Fk?=
 =?utf-8?B?alRlM29ncXlPK3p0eEVJUEZ2eWJRSmx3UVF4bHZRZGhLYlV1Z2k4dWlBcXFU?=
 =?utf-8?B?K2xEQzZSUUlhWTUxTTl2MzVOTkdSQjc0aUJWSmEyOGltM2hKREdxdHBnN1Fl?=
 =?utf-8?B?OGUxU1NpS21aZjkxeEVsWmxZRWZ3dlArNVM4Z3BwZkxoejM5MlhqT3I3V25K?=
 =?utf-8?B?NWViVkthZUFFVzNPT28rVUdXZTA4OVI0ak1YYndaUDVERHZRUG44OHZCQ0VU?=
 =?utf-8?B?TzBJRVhvVEJuK2trUTNRNDc5TW11cXdETWVPYkVUWDlYdThKVDZaK1c5b1dK?=
 =?utf-8?B?dlU5eVl4MFNpYkFxRW1nRFJPczhmd0JFaGdrWXIyT2g0WGN3VnBUN2FIK1M0?=
 =?utf-8?B?QjdMU0htRWpVNmNhbUplaUpxWVZvV1laWEd6emhyS092OWEzRTl1V0huNFBP?=
 =?utf-8?B?SWh6c2E4dzh6K2pCWWc2V2h1WWRnT0F2bHVvcmMyOEpGV1Z1cHBZbEkrTERq?=
 =?utf-8?B?Tm50SmMyUlB5Z29UQjlHVm8wMmpCR3F1WDI2bjBCeXE5WGFpaWVvNmVRMHJv?=
 =?utf-8?B?VXZWUFNFWkFtekg1Q2Q0bWpHTjlvN3gwUkVPbCs1Z3pqTlVpK09BbHlkL24w?=
 =?utf-8?B?akJPcDlWNVE3QWE5SDJZZUkvc0FIRmx1Y3ErNm4zL25HUVlIaDZ3dTJ3MHRV?=
 =?utf-8?B?T0RJYmMxcG0rQlZBYlhXMlVhWmlUWGFKU0kvUW9vMVVLazJDTUVySEp1Z095?=
 =?utf-8?Q?NAwQ/HmQMfcN1e4JXfadW3HZixaHITBGFLOwLAr?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a246c1f-3f92-44cf-f3bd-08d91f56849b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2021 08:24:30.0812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NnAt17LRLH55w39EGgmcJMPY9+3sl0wo+rTI7eLfbkU8Ss7KHF5xK3sHLZXk1DQgvjtsveJju+zXojSaCOgQsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBPbiA1LzI0LzIwMjEgMToxMCBQTSwgQmFydCBWYW4gQXNzY2hlIHdyb3RlOg0KPiA+IE9uIDUv
MjQvMjEgMTozNiBBTSwgQ2FuIEd1byB3cm90ZToNCj4gPj4gQ3VycmVudCBVRlMgSVJRIGhhbmRs
ZXIgaXMgY29tcGxldGVseSB3cmFwcGVkIGJ5IGhvc3QgbG9jaywgYW5kIGJlY2F1c2UNCj4gPj4g
dWZzaGNkX3NlbmRfY29tbWFuZCgpIGlzIGFsc28gcHJvdGVjdGVkIGJ5IGhvc3QgbG9jaywgd2hl
biBJUlEgaGFuZGxlcg0KPiA+PiBmaXJlcywgbm90IG9ubHkgdGhlIENQVSBydW5uaW5nIHRoZSBJ
UlEgaGFuZGxlciBjYW5ub3Qgc2VuZCBuZXcNCj4gcmVxdWVzdHMsDQo+ID4+IHRoZSByZXN0IENQ
VXMgY2FuIG5laXRoZXIuIE1vdmUgdGhlIGhvc3QgbG9jayB3cmFwcGluZyB0aGUgSVJRIGhhbmRs
ZXINCj4gaW50bw0KPiA+PiBzcGVjaWZpYyBicmFuY2hlcywgaS5lLiwgdWZzaGNkX3VpY19jbWRf
Y29tcGwoKSwgdWZzaGNkX2NoZWNrX2Vycm9ycygpLA0KPiA+PiB1ZnNoY2RfdG1jX2hhbmRsZXIo
KSBhbmQgdWZzaGNkX3RyYW5zZmVyX3JlcV9jb21wbCgpLiBNZWFud2hpbGUsIHRvDQo+IGZ1cnRo
ZXINCj4gPj4gcmVkdWNlIG9jY3B1YXRpb24gb2YgaG9zdCBsb2NrIGluIHVmc2hjZF90cmFuc2Zl
cl9yZXFfY29tcGwoKSwgaG9zdCBsb2NrDQo+IGlzDQo+ID4+IG5vIGxvbmdlciByZXF1aXJlZCB0
byBjYWxsIF9fdWZzaGNkX3RyYW5zZmVyX3JlcV9jb21wbCgpLiBBcyBwZXIgdGVzdCwgdGhlDQo+
ID4+IG9wdGltaXphdGlvbiBjYW4gYnJpbmcgY29uc2lkZXJhYmxlIGdhaW4gdG8gcmFuZG9tIHJl
YWQvd3JpdGUNCj4gcGVyZm9ybWFuY2UuDQo+ID4NCj4gDQo+ID4gQW4gYWRkaXRpb25hbCBxdWVz
dGlvbiBpcyB3aGV0aGVyIGl0IGlzIG5lY2Vzc2FyeSBmb3IgdjMuMCBVRlMgZGV2aWNlcw0KPiA+
IHRvIHNlcmlhbGl6ZSB0aGUgc3VibWlzc2lvbiBwYXRoIGFnYWluc3QgdGhlIGNvbXBsZXRpb24g
cGF0aD8gTXVsdGlwbGUNCj4gPiBoaWdoLXBlcmZvcm1hbmNlIFNDU0kgTExEcyBzdXBwb3J0IGhh
cmR3YXJlIHdpdGggc2VwYXJhdGUgc3VibWlzc2lvbg0KPiBhbmQNCj4gPiBjb21wbGV0aW9uIHF1
ZXVlcyBhbmQgaGVuY2UgZG8gbm90IG5lZWQgYW55IHNlcmlhbGl6YXRpb24gYmV0d2VlbiB0aGUN
Cj4gPiBzdWJtaXNzaW9uIGFuZCB0aGUgY29tcGxldGlvbiBwYXRoLiBJJ20gYXNraW5nIHRoaXMg
YmVjYXVzZSBpdCBpcyBsaWtlbHkNCj4gPiB0aGF0IHNvb25lciBvciBsYXRlciBtdWx0aXF1ZXVl
IHN1cHBvcnQgd2lsbCBiZSBhZGRlZCBpbiB0aGUgVUZTDQo+ID4gc3BlY2lmaWNhdGlvbi4gQmVu
ZWZpdGluZyBmcm9tIG11bHRpcXVldWUgc3VwcG9ydCB3aWxsIHJlcXVpcmUgdG8gcmV3b3JrDQo+
ID4gbG9ja2luZyBpbiB0aGUgVUZTIGRyaXZlciBhbnl3YXkuDQo+ID4NCj4gSGkgQmFydCwNCj4g
Tm8gaXQncyBub3QgbmVjZXNzYXJ5IHRvIHNlcmlhbGl6ZSBib3RoIHRoZSBwYXRocy4gSSB0aGlu
ayB0aGlzIHNlcmllcw0KPiBhdHRlbXB0cyB0byByZW1vdmUgdGhpcyBzZXJpYWxpemF0aW9uIHRv
IGEgY2VydGFpbiBkZWdyZWUsIHdoaWNoIGlzDQo+IHdoYXQncyBnaXZpbmcgdGhlIHBlcmZvcm1h
bmNlIGltcHJvdmVtZW50Lg0KPiANCj4gRXZlbiBpZiBtdWx0aXF1ZXVlIHN1cHBvcnQgd291bGQg
YmUgYXZhaWxhYmxlIGluIHRoZSBmdXR1cmUsIEkgdGhpbmsNCj4gdGhpcyBjaGFuZ2UgaXMgYXB0
IG5vdyBmb3IgdGhlIGN1cnJlbnQgYXZhaWxhYmxlIHNwZWNpZmljYXRpb24uDQpJIGFncmVlIC0g
dGhpcyBsb29rcyBsaWtlIHRoZSBoYXJiaW5nZXIgb2YgYSBtYWpvciBjaGFuZ2UsDQpBbmQgZ29p
bmcgZnVydGhlciB3aXRoIHJlc3BlY3Qgb2YgaHcgcXVldWVzLA0Kd2lsbCBuZWVkIHRoZSBzcGVj
IHN1cHBvcnQgLSBlLmcuIGRvb3JiZWxsIHBlciBsYW5lLCBldGMuDQoNClRoYW5rcywNCkF2cmkN
CiANCj4gPiBUaGFua3MsDQo+ID4NCj4gPiBCYXJ0Lg0KPiA+DQo+IA0KPiANCj4gVGhhbmtzLA0K
PiAtYXNkDQo+IA0KPiAtLQ0KPiBUaGUgUXVhbGNvbW0gSW5ub3ZhdGlvbiBDZW50ZXIsIEluYy4g
aXMgYSBtZW1iZXIgb2YgdGhlIENvZGUgQXVyb3JhDQo+IEZvcnVtLA0KPiBMaW51eCBGb3VuZGF0
aW9uIENvbGxhYm9yYXRpdmUgUHJvamVjdA0K
