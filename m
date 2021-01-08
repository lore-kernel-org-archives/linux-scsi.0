Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C11C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:41:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE9DE22D01
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbhAHElu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 23:41:50 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7582 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726793AbhAHElt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 23:41:49 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1084elJL006296
        for <linux-scsi@vger.kernel.org>; Thu, 7 Jan 2021 20:41:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=Ex3WbNY18hFGSTUc72wlhTxpK2G65MnZp28JOHa+s0U=;
 b=UY1L5dFDqCennmclPDLN0EJNDLLuhYJI6HRvVGBOPfOSuEz9Vlb4ATNpL0SAYKdptju5
 etLm6WtEjyI5/U/Q6zbT3BLZzyNzAoWP3uNlEAun3lSfZViCPd3BuMa3nX5JBdUATlTX
 UUqGhn8reApE5RiEQ38O24L3k8uX0oFTSeSqpbi5Uwv5oSqrPYoEpSdUSWXrDo5vvNsY
 2KUjpjGyduD/T2VxLCg6tnThC40MoCRnowJyeV4flIxOm1GEMvxLgdbxIILrIoMcAtD1
 psHeDubLQtw7Ec0ErIAn7wP7HwTk4QFcxNuxkAFTT/zekO8fzfWhQiVl13+MUyi07gNw MQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 35wy5a2waj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Jan 2021 20:41:04 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 Jan
 2021 20:41:02 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 Jan
 2021 20:41:01 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.50) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 7 Jan 2021 20:41:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXlue+j80Tts77UlgjwV8pu8YzaXANJhZBewQPyCa2h1u7vhutiS82OQJL9wQP/ElfokpR7sUwEb7qTYlUAR6gKgPBCUHY9t0KFG3FKO4LaXUSPXMkyoFuQWd+1LWN+Pc3Sp+Be98eoGEiB1mReotARSlLqVwYr+VgXd897kkA9hLhfVRgKIEPOg6U8ZcRqxYT6X+GWyL5+rIbVjwyKpLfUsCMbIPV46s+5SwS0bu5fHYJt13XWsyrHSkUXWIy5IB2Q0IMRs75fZkdouG0fZFgE4N4Wi5w251kSUvUksQxU+xJfH2F68ywfEW3xZLLg/okEwGzq2ihBX6TKfmj3QdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ex3WbNY18hFGSTUc72wlhTxpK2G65MnZp28JOHa+s0U=;
 b=bewy65Ps+DRm3lXjRaLiSq28WObG/kRfoZtqYcQnYu0VB07nEHQfePtNvQNpIoVV16WC9/6dsgEVNyE68gF0kP+ODarwLkRKDaxaaPc2vrjZ2sGS7Tzj9cDuF3IuHH3T0qWGEDM8LML7rfhbQenQvG0SfF5pTPi9S7+wwtPzT44GV1nXXvD+EODILAlbwix8WUzmFMWlvKgA2pgJXOkmpEbTV8Bg338g27USPcMTPiG/bixx65I50ilF5/QJI6XcB/eW/0eqL5ghQKWNB+X65EKwAfONc5P/Kzo4kWzvJE86mpZpwvqv0qt+q+8zaNZJWmYXJCSno8nMImlWf9xopQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ex3WbNY18hFGSTUc72wlhTxpK2G65MnZp28JOHa+s0U=;
 b=g6TdHyQ/t3xzZesx3GdXrQbYcQz4oyztxRLhuewNV9cMLQCgNb1KAH5ac/jccQcrw5AzrZKNAQYbXlYdrYBFfSFJE9Jc0Ve+xhjJ8HE7OwitdKn9/3zJweGfSYRjBk1nkq3Zf6ZoVTZFoap61sHS+jimi6J6yqjIaZwzvqpfkh8=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM6PR18MB3585.namprd18.prod.outlook.com (2603:10b6:5:2af::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 8 Jan
 2021 04:41:00 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::201c:2fc9:faf8:16a9]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::201c:2fc9:faf8:16a9%6]) with mapi id 15.20.3742.006; Fri, 8 Jan 2021
 04:41:00 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [EXT] [PATCH v3 3/7] qla2xxx: Move some messages from debug to
 normal log level
Thread-Topic: [EXT] [PATCH v3 3/7] qla2xxx: Move some messages from debug to
 normal log level
Thread-Index: AQHW5R4eyGNeyembzES4RXAD/4zJ5aodJfLQ
Date:   Fri, 8 Jan 2021 04:41:00 +0000
Message-ID: <DM6PR18MB3034B771D4E40754307D4714D2AE9@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20210105103847.25041-1-njavali@marvell.com>
 <20210105103847.25041-4-njavali@marvell.com>
 <DABC7D0B-6734-4229-9812-DB573235246F@oracle.com>
 <BN8PR18MB30258A9BFBC37C8C9CB9E80DD2AF9@BN8PR18MB3025.namprd18.prod.outlook.com>
 <C683E56E-D2E2-448A-B8F3-959161A5D352@oracle.com>
In-Reply-To: <C683E56E-D2E2-448A-B8F3-959161A5D352@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.103.215.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b0fc757-5fe3-4c60-e98d-08d8b38f9957
x-ms-traffictypediagnostic: DM6PR18MB3585:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB3585D26290768A8CEB33CEDCD2AE9@DM6PR18MB3585.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yHLxXcakmhvDeVkzMZDp6LZe/BP29m9sWxasMnGdAueJdp9ff2ZlTO5NVCXj3oM4EFV9AIj4caoScGfDajtv18/LykX36bGc9+aJGIPPnXfHV3rI6Efjhq0MMrg6tKF2CEtNMDdYj3xz50r0UTAXO75Hdvlm2oujBaFyw1BcU7ZXZDsEJubrdcUPRfhtd0zikz7jmaFiW+LG8csGCt/jDCXBF2ZDucbGnG4nphNJxM7y2t+hiEIdEc1Qd6PmoUReLlPfWO7BdyjHHtohiYUJWT4IIh4iSIluGE8Aaj0LgyrKCOtGcCHk2wcKl2FZLju55ytkITqufzxstdFxE0CdDYJDz4IlvQJnfB/Djmz7CkooVwo5V0GbYV8jh34UBOhl1dV5QHL6Y03thshuokjj4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(6506007)(53546011)(86362001)(8676002)(478600001)(52536014)(83380400001)(66446008)(26005)(316002)(186003)(33656002)(4326008)(5660300002)(15650500001)(8936002)(76116006)(66946007)(107886003)(6916009)(7696005)(9686003)(71200400001)(66476007)(2906002)(54906003)(66556008)(55016002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dWp1WDZSMjVYZGdrcnYrMmlyUGVIWDc4ZHVUaytHc3dZMmJqdXYyTnByd0hw?=
 =?utf-8?B?NXZ3UzlzRlZrWVByd3M4bWFHRGlwTGtTZlVBbDJ0dEFiTWEwbVp5dElUZjRj?=
 =?utf-8?B?Z3JrSzZVdlJZL1JXZnM2c3ZyeDhIaVlDaURiWFoycjE4QmxoWDRIQzJMMG9F?=
 =?utf-8?B?bWVSQ2t0cVl3VEVZR1JmNVY2d2lzSDErRFFvakxmVDVpbXE3V1ZYT21WRVFi?=
 =?utf-8?B?dGUwOVdsRU1taU1nOUl5N0NQLzk1aEVJUm01VkZtR2MxOERXekIvYkFXNDJQ?=
 =?utf-8?B?bnA1R0NLTEZKZHNOaEhpd0FvRTFBOER3YWZaTHZiNFdsdVpUdmNxazlCUnQw?=
 =?utf-8?B?UXhNdXE3anJqK25hZ1NWMDFyc1JnNjVWVEFUWEFROEpLb0FGTVN5TXg0TFhs?=
 =?utf-8?B?K1JDaGF0ekV0WDFYOWNUbVZ1VVFJNHA2V1kwWVYxeUgyYnpycEFDamtBRXh6?=
 =?utf-8?B?K1E2VFlRZ2hPOXBIUHRuWEFFRUVmRlNYYS9hMjB0NDBlYjVyTTRNTDdYS1NP?=
 =?utf-8?B?UVlhWmRldlNuVmhZcVg2U1VsQWh0c0RQRGlML2E3dnljQ2FyaldEd1IyQkNG?=
 =?utf-8?B?VEU0Q0lLd2pFNEIvdVhtaE1hUWtKbDgvN3VzODhCdWxNSUsxOUVzaUxXRVNu?=
 =?utf-8?B?Y0NTNG5vR0R0cEJGTlVWUDVLRjB4cGFCYk9taGw2KzA1SGdmdTJGNnhyeFNN?=
 =?utf-8?B?aDhPelZVOGFRenNUNHNCMk1iUjBRWUV6b0xSaUlsUGNtZDREeGVHM2dVSXY4?=
 =?utf-8?B?Qk1IQnhXeUVpcjZWeVJ4bkVoZE5RdDlNSTFDR05KR1g3TGF1QytOdGV3bml0?=
 =?utf-8?B?azlNYU9ocnM4QU9HNVhwRkl1K1MwaTFzcVhmeS9XaUl4bk01N2s2d01weUJl?=
 =?utf-8?B?M0R4OWhmRUR5MXY0a1FDSmIvUVErRDBlY3I5a3V3TVl0TTJ5OWFOUnlya2w3?=
 =?utf-8?B?UFBkSS9IdUltT1Y2aXBnWnJjb2JPZE0vdEpVK05sS3lyWnIwSU0xcFhKL3B5?=
 =?utf-8?B?RTAvb2pYdWFJc0NxcVduYWtxNld4VmRzT0lLa1NqRjgwK0dpVWJEY0llM3VI?=
 =?utf-8?B?YjBUc2daT01uVEFySHlzOEMvSFVtcFFod0xnUGxwbDh5Vmd1UFpsQzlZRmND?=
 =?utf-8?B?WnU0WTM4T0ZuNFhOM2xQR3RuUS9uSWtlNk1KQVdTOE9ydnpaS3B0R0c5MmNx?=
 =?utf-8?B?cWUzM09uQVNCTmZBSjFPRENTNDE4ODNSY094UUtobE10NjgxMjlDNE1CUTNy?=
 =?utf-8?B?bTFnbTkxcGFGd2JkMVM0VTNNYWNpSGkwaGNUWHZhSmxFdzh2SmdyczkvUHEv?=
 =?utf-8?Q?voAxkS9BbW6L0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b0fc757-5fe3-4c60-e98d-08d8b38f9957
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2021 04:41:00.6106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N0/cTIOxy9vYC3gamY91/XjuiUOIJLlj3YcrrQF0PRVZYWE6u1L9Snbu1Bl80CBEbc613O456VmwpIb0njMXYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3585
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-08_01:2021-01-07,2021-01-08 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgSGltYW5zaHUsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSGlt
YW5zaHUgTWFkaGFuaSA8aGltYW5zaHUubWFkaGFuaUBvcmFjbGUuY29tPg0KPiBTZW50OiBUaHVy
c2RheSwgSmFudWFyeSA3LCAyMDIxIDExOjIyIFBNDQo+IFRvOiBTYXVyYXYgS2FzaHlhcCA8c2th
c2h5YXBAbWFydmVsbC5jb20+DQo+IENjOiBOaWxlc2ggSmF2YWxpIDxuamF2YWxpQG1hcnZlbGwu
Y29tPjsgTWFydGluIEsuIFBldGVyc2VuDQo+IDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT47
IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBHUi1RTG9naWMtDQo+IFN0b3JhZ2UtVXBzdHJl
YW0gPEdSLVFMb2dpYy1TdG9yYWdlLVVwc3RyZWFtQG1hcnZlbGwuY29tPg0KPiBTdWJqZWN0OiBS
ZTogW0VYVF0gW1BBVENIIHYzIDMvN10gcWxhMnh4eDogTW92ZSBzb21lIG1lc3NhZ2VzIGZyb20g
ZGVidWcgdG8NCj4gbm9ybWFsIGxvZyBsZXZlbA0KPiANCj4gDQo+IA0KPiA+IE9uIEphbiA2LCAy
MDIxLCBhdCAxMTo1MSBQTSwgU2F1cmF2IEthc2h5YXAgPHNrYXNoeWFwQG1hcnZlbGwuY29tPg0K
PiB3cm90ZToNCj4gPg0KPiA+IEhpIEhpbWFuc2h1LA0KPiA+IFRoYW5rcyBmb3IgdGhlIHJldmll
dywgY29tbWVudHMgaW5saW5lLi4NCj4gPg0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0t
LQ0KPiA+PiBGcm9tOiBIaW1hbnNodSBNYWRoYW5pIDxoaW1hbnNodS5tYWRoYW5pQG9yYWNsZS5j
b20+DQo+ID4+IFNlbnQ6IFdlZG5lc2RheSwgSmFudWFyeSA2LCAyMDIxIDg6MzcgUE0NCj4gPj4g
VG86IE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlAbWFydmVsbC5jb20+OyBTYXVyYXYgS2FzaHlhcA0K
PiA+PiA8c2thc2h5YXBAbWFydmVsbC5jb20+DQo+ID4+IENjOiBNYXJ0aW4gSy4gUGV0ZXJzZW4g
PG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPjsgbGludXgtDQo+ID4+IHNjc2lAdmdlci5rZXJu
ZWwub3JnOyBHUi1RTG9naWMtU3RvcmFnZS1VcHN0cmVhbSA8R1ItUUxvZ2ljLVN0b3JhZ2UtDQo+
ID4+IFVwc3RyZWFtQG1hcnZlbGwuY29tPg0KPiA+PiBTdWJqZWN0OiBbRVhUXSBSZTogW1BBVENI
IHYzIDMvN10gcWxhMnh4eDogTW92ZSBzb21lIG1lc3NhZ2VzIGZyb20NCj4gZGVidWcgdG8NCj4g
Pj4gbm9ybWFsIGxvZyBsZXZlbA0KPiA+Pg0KPiA+PiBFeHRlcm5hbCBFbWFpbA0KPiA+Pg0KPiA+
PiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tDQo+ID4+IEhpIFNhdXJhdiwNCj4gPj4NCj4gPj4+IE9uIEphbiA1LCAy
MDIxLCBhdCA0OjM4IEFNLCBOaWxlc2ggSmF2YWxpIDxuamF2YWxpQG1hcnZlbGwuY29tPiB3cm90
ZToNCj4gPj4+DQo+ID4+PiBGcm9tOiBTYXVyYXYgS2FzaHlhcCA8c2thc2h5YXBAbWFydmVsbC5j
b20+DQo+ID4+Pg0KPiA+Pj4gVGhpcyBjaGFuZ2Ugd2lsbCBhaWQgaW4gZGVidWdnaW5nIGlzc3Vl
cyB3aGVyZSBkZWJ1ZyBsZXZlbCBpcyBub3Qgc2V0Lg0KPiA+Pj4NCj4gPj4+IFNpZ25lZC1vZmYt
Ynk6IFNhdXJhdiBLYXNoeWFwIDxza2FzaHlhcEBtYXJ2ZWxsLmNvbT4NCj4gPj4+IFNpZ25lZC1v
ZmYtYnk6IE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlAbWFydmVsbC5jb20+DQo+ID4+PiAtLS0NCj4g
Pj4+IGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMgfCAxMCArKystLS0tDQo+ID4+PiBk
cml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaXNyLmMgIHwgNTIgKysrKysrKysrKysrKysrKy0tLS0t
LS0tLS0tLS0tLS0tDQo+ID4+PiAyIGZpbGVzIGNoYW5nZWQsIDMwIGluc2VydGlvbnMoKyksIDMy
IGRlbGV0aW9ucygtKQ0KPiA+Pj4NCj4gPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcWxh
Mnh4eC9xbGFfaW5pdC5jIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYw0KPiA+Pj4g
aW5kZXggNDEwZmY1NTM0YTU5Li4yMjEzNjljZGY3MWYgMTAwNjQ0DQo+ID4+PiAtLS0gYS9kcml2
ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jDQo+ID4+PiArKysgYi9kcml2ZXJzL3Njc2kvcWxh
Mnh4eC9xbGFfaW5pdC5jDQo+ID4+PiBAQCAtMzQ3LDExICszNDcsMTEgQEAgcWxhMngwMF9hc3lu
Y19sb2dpbihzdHJ1Y3Qgc2NzaV9xbGFfaG9zdCAqdmhhLA0KPiA+PiBmY19wb3J0X3QgKmZjcG9y
dCwNCj4gPj4+IAlpZiAoTlZNRV9UQVJHRVQodmhhLT5odywgZmNwb3J0KSkNCj4gPj4+IAkJbGlv
LT51LmxvZ2lvLmZsYWdzIHw9IFNSQl9MT0dJTl9TS0lQX1BSTEk7DQo+ID4+Pg0KPiA+Pj4gLQlx
bF9kYmcocWxfZGJnX2Rpc2MsIHZoYSwgMHgyMDcyLA0KPiA+Pj4gLQkgICAgIkFzeW5jLWxvZ2lu
IC0gJThwaEMgaGRsPSV4LCBsb29waWQ9JXggcG9ydGlkPSUwMnglMDJ4JTAyeCAiDQo+ID4+PiAt
CQkicmV0cmllcz0lZC5cbiIsIGZjcG9ydC0+cG9ydF9uYW1lLCBzcC0+aGFuZGxlLCBmY3BvcnQt
DQo+ID4+PiBsb29wX2lkLA0KPiA+Pj4gLQkgICAgZmNwb3J0LT5kX2lkLmIuZG9tYWluLCBmY3Bv
cnQtPmRfaWQuYi5hcmVhLCBmY3BvcnQtPmRfaWQuYi5hbF9wYSwNCj4gPj4+IC0JICAgIGZjcG9y
dC0+bG9naW5fcmV0cnkpOw0KPiA+Pj4gKwlxbF9sb2cocWxfbG9nX3dhcm4sIHZoYSwgMHgyMDcy
LA0KPiA+Pj4gKwkgICAgICAgIkFzeW5jLWxvZ2luIC0gJThwaEMgaGRsPSV4LCBsb29waWQ9JXgg
cG9ydGlkPSUwMnglMDJ4JTAyeA0KPiA+PiByZXRyaWVzPSVkLlxuIiwNCj4gPj4+ICsJICAgICAg
IGZjcG9ydC0+cG9ydF9uYW1lLCBzcC0+aGFuZGxlLCBmY3BvcnQtPmxvb3BfaWQsDQo+ID4+PiAr
CSAgICAgICBmY3BvcnQtPmRfaWQuYi5kb21haW4sIGZjcG9ydC0+ZF9pZC5iLmFyZWEsIGZjcG9y
dC0+ZF9pZC5iLmFsX3BhLA0KPiA+Pj4gKwkgICAgICAgZmNwb3J0LT5sb2dpbl9yZXRyeSk7DQo+
ID4+Pg0KPiA+Pj4gCXJ2YWwgPSBxbGEyeDAwX3N0YXJ0X3NwKHNwKTsNCj4gPj4+IAlpZiAocnZh
bCAhPSBRTEFfU1VDQ0VTUykgew0KPiA+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEy
eHh4L3FsYV9pc3IuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pc3IuYw0KPiA+Pj4gaW5k
ZXggOWNmODMyNmFiOWZjLi5iZmM4YmJhZWVhNDYgMTAwNjQ0DQo+ID4+PiAtLS0gYS9kcml2ZXJz
L3Njc2kvcWxhMnh4eC9xbGFfaXNyLmMNCj4gPj4+ICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4
L3FsYV9pc3IuYw0KPiA+Pj4gQEAgLTE0NTUsOSArMTQ1NSw5IEBAIHFsYTJ4MDBfYXN5bmNfZXZl
bnQoc2NzaV9xbGFfaG9zdF90ICp2aGEsDQo+IHN0cnVjdA0KPiA+PiByc3BfcXVlICpyc3AsIHVp
bnQxNl90ICptYikNCj4gPj4+IAkJaWYgKGhhLT5mbGFncy5ucGl2X3N1cHBvcnRlZCAmJiB2aGEt
PnZwX2lkeCAhPSAobWJbM10gJiAweGZmKSkNCj4gPj4+IAkJCWJyZWFrOw0KPiA+Pj4NCj4gPj4+
IC0JCXFsX2RiZyhxbF9kYmdfYXN5bmMsIHZoYSwgMHg1MDEzLA0KPiA+Pj4gLQkJICAgICJSU0NO
IGRhdGFiYXNlIGNoYW5nZWQgLS0gJTA0eCAlMDR4ICUwNHguXG4iLA0KPiA+Pj4gLQkJICAgIG1i
WzFdLCBtYlsyXSwgbWJbM10pOw0KPiA+Pj4gKwkJcWxfbG9nKHFsX2xvZ193YXJuLCB2aGEsIDB4
NTAxMywNCj4gPj4+ICsJCSAgICAgICAiUlNDTiBkYXRhYmFzZSBjaGFuZ2VkIC0tICUwNHggJTA0
eCAlMDR4LlxuIiwNCj4gPj4+ICsJCSAgICAgICBtYlsxXSwgbWJbMl0sIG1iWzNdKTsNCj4gPj4+
DQo+ID4+PiAJCXJzY25fZW50cnkgPSAoKG1iWzFdICYgMHhmZikgPDwgMTYpIHwgbWJbMl07DQo+
ID4+PiAJCWhvc3RfcGlkID0gKHZoYS0+ZF9pZC5iLmRvbWFpbiA8PCAxNikgfCAodmhhLT5kX2lk
LmIuYXJlYSA8PA0KPiA+PiA4KQ0KPiA+Pj4gQEAgLTIyMjEsMTIgKzIyMjEsMTIgQEAgcWxhMjR4
eF9sb2dpb19lbnRyeShzY3NpX3FsYV9ob3N0X3QgKnZoYSwNCj4gc3RydWN0DQo+ID4+IHJlcV9x
dWUgKnJlcSwNCj4gPj4+IAkJYnJlYWs7DQo+ID4+PiAJfQ0KPiA+Pj4NCj4gPj4+IC0JcWxfZGJn
KHFsX2RiZ19hc3luYywgc3AtPnZoYSwgMHg1MDM3LA0KPiA+Pj4gLQkgICAgIkFzeW5jLSVzIGZh
aWxlZDogaGFuZGxlPSV4IHBpZD0lMDZ4IHd3cG49JThwaEMNCj4gPj4gY29tcF9zdGF0dXM9JXgg
aW9wMD0leCBpb3AxPSV4XG4iLA0KPiA+Pj4gLQkgICAgdHlwZSwgc3AtPmhhbmRsZSwgZmNwb3J0
LT5kX2lkLmIyNCwgZmNwb3J0LT5wb3J0X25hbWUsDQo+ID4+PiAtCSAgICBsZTE2X3RvX2NwdShs
b2dpby0+Y29tcF9zdGF0dXMpLA0KPiA+Pj4gLQkgICAgbGUzMl90b19jcHUobG9naW8tPmlvX3Bh
cmFtZXRlclswXSksDQo+ID4+PiAtCSAgICBsZTMyX3RvX2NwdShsb2dpby0+aW9fcGFyYW1ldGVy
WzFdKSk7DQo+ID4+PiArCXFsX2xvZyhxbF9sb2dfd2Fybiwgc3AtPnZoYSwgMHg1MDM3LA0KPiA+
Pj4gKwkgICAgICAgIkFzeW5jLSVzIGZhaWxlZDogaGFuZGxlPSV4IHBpZD0lMDZ4IHd3cG49JThw
aEMNCj4gPj4gY29tcF9zdGF0dXM9JXggaW9wMD0leCBpb3AxPSV4XG4iLA0KPiA+Pj4gKwkgICAg
ICAgdHlwZSwgc3AtPmhhbmRsZSwgZmNwb3J0LT5kX2lkLmIyNCwgZmNwb3J0LT5wb3J0X25hbWUs
DQo+ID4+PiArCSAgICAgICBsZTE2X3RvX2NwdShsb2dpby0+Y29tcF9zdGF0dXMpLA0KPiA+Pj4g
KwkgICAgICAgbGUzMl90b19jcHUobG9naW8tPmlvX3BhcmFtZXRlclswXSksDQo+ID4+PiArCSAg
ICAgICBsZTMyX3RvX2NwdShsb2dpby0+aW9fcGFyYW1ldGVyWzFdKSk7DQo+ID4+Pg0KPiA+Pj4g
bG9naW9fZG9uZToNCj4gPj4+IAlzcC0+ZG9uZShzcCwgMCk7DQo+ID4+PiBAQCAtMjM4OSw5ICsy
Mzg5LDkgQEAgc3RhdGljIHZvaWQNCj4gPj4gcWxhMjR4eF9udm1lX2lvY2JfZW50cnkoc2NzaV9x
bGFfaG9zdF90ICp2aGEsIHN0cnVjdCByZXFfcXVlICpyZXEsDQo+ID4+Pg0KPiA+Pj4gCQl0Z3Rf
eGZlcl9sZW4gPSBiZTMyX3RvX2NwdShyc3BfaXUtPnhmcmRfbGVuKTsNCj4gPj4+IAkJaWYgKGZk
LT50cmFuc2ZlcnJlZF9sZW5ndGggIT0gdGd0X3hmZXJfbGVuKSB7DQo+ID4+PiAtCQkJcWxfZGJn
KHFsX2RiZ19pbywgZmNwb3J0LT52aGEsIDB4MzA3OSwNCj4gPj4+IC0JCQkJIkRyb3BwZWQgZnJh
bWUocykgZGV0ZWN0ZWQNCj4gPj4gKHNlbnQvcmN2ZD0ldS8ldSkuXG4iLA0KPiA+Pj4gLQkJCQl0
Z3RfeGZlcl9sZW4sIGZkLT50cmFuc2ZlcnJlZF9sZW5ndGgpOw0KPiA+Pj4gKwkJCXFsX2xvZyhx
bF9sb2dfd2FybiwgZmNwb3J0LT52aGEsIDB4MzA3OSwNCj4gPj4+ICsJCQkgICAgICAgIkRyb3Bw
ZWQgZnJhbWUocykgZGV0ZWN0ZWQNCj4gPj4gKHNlbnQvcmN2ZD0ldS8ldSkuXG4iLA0KPiA+Pj4g
KwkJCSAgICAgICB0Z3RfeGZlcl9sZW4sIGZkLT50cmFuc2ZlcnJlZF9sZW5ndGgpOw0KPiA+Pj4g
CQkJbG9naXQgPSAxOw0KPiA+Pj4gCQl9IGVsc2UgaWYgKGxlMTZfdG9fY3B1KGNvbXBfc3RhdHVz
KSA9PSBDU19EQVRBX1VOREVSUlVOKSB7DQo+ID4+PiAJCQkvKg0KPiA+Pj4gQEAgLTMxMTIsOSAr
MzExMiw5IEBAIHFsYTJ4MDBfc3RhdHVzX2VudHJ5KHNjc2lfcWxhX2hvc3RfdCAqdmhhLA0KPiBz
dHJ1Y3QNCj4gPj4gcnNwX3F1ZSAqcnNwLCB2b2lkICpwa3QpDQo+ID4+PiAJCXNjc2lfc2V0X3Jl
c2lkKGNwLCByZXNpZCk7DQo+ID4+PiAJCWlmIChzY3NpX3N0YXR1cyAmIFNTX1JFU0lEVUFMX1VO
REVSKSB7DQo+ID4+PiAJCQlpZiAoSVNfRldJMl9DQVBBQkxFKGhhKSAmJiBmd19yZXNpZF9sZW4g
IT0NCj4gPj4gcmVzaWRfbGVuKSB7DQo+ID4+PiAtCQkJCXFsX2RiZyhxbF9kYmdfaW8sIGZjcG9y
dC0+dmhhLCAweDMwMWQsDQo+ID4+PiAtCQkJCSAgICAiRHJvcHBlZCBmcmFtZShzKSBkZXRlY3Rl
ZCAoMHgleCBvZiAweCV4DQo+ID4+IGJ5dGVzKS5cbiIsDQo+ID4+PiAtCQkJCSAgICByZXNpZCwg
c2NzaV9idWZmbGVuKGNwKSk7DQo+ID4+PiArCQkJCXFsX2xvZyhxbF9sb2dfd2FybiwgZmNwb3J0
LT52aGEsIDB4MzAxZCwNCj4gPj4+ICsJCQkJICAgICAgICJEcm9wcGVkIGZyYW1lKHMpIGRldGVj
dGVkICgweCV4IG9mIDB4JXgNCj4gPj4gYnl0ZXMpLlxuIiwNCj4gPj4+ICsJCQkJICAgICAgIHJl
c2lkLCBzY3NpX2J1ZmZsZW4oY3ApKTsNCj4gPj4+DQo+ID4+PiAJCQkJdmhhLT5pbnRlcmZhY2Vf
ZXJyX2NudCsrOw0KPiA+Pj4NCj4gPj4+IEBAIC0zMTM5LDkgKzMxMzksOSBAQCBxbGEyeDAwX3N0
YXR1c19lbnRyeShzY3NpX3FsYV9ob3N0X3QgKnZoYSwNCj4gc3RydWN0DQo+ID4+IHJzcF9xdWUg
KnJzcCwgdm9pZCAqcGt0KQ0KPiA+Pj4gCQkJICogdGFzayBub3QgY29tcGxldGVkLg0KPiA+Pj4g
CQkJICovDQo+ID4+Pg0KPiA+Pj4gLQkJCXFsX2RiZyhxbF9kYmdfaW8sIGZjcG9ydC0+dmhhLCAw
eDMwMWYsDQo+ID4+PiAtCQkJICAgICJEcm9wcGVkIGZyYW1lKHMpIGRldGVjdGVkICgweCV4IG9m
IDB4JXgNCj4gPj4gYnl0ZXMpLlxuIiwNCj4gPj4+IC0JCQkgICAgcmVzaWQsIHNjc2lfYnVmZmxl
bihjcCkpOw0KPiA+Pj4gKwkJCXFsX2xvZyhxbF9sb2dfd2FybiwgZmNwb3J0LT52aGEsIDB4MzAx
ZiwNCj4gPj4+ICsJCQkgICAgICAgIkRyb3BwZWQgZnJhbWUocykgZGV0ZWN0ZWQgKDB4JXggb2Yg
MHgleA0KPiA+PiBieXRlcykuXG4iLA0KPiA+Pj4gKwkJCSAgICAgICByZXNpZCwgc2NzaV9idWZm
bGVuKGNwKSk7DQo+ID4+Pg0KPiA+Pj4gCQkJdmhhLT5pbnRlcmZhY2VfZXJyX2NudCsrOw0KPiA+
Pj4NCj4gPj4+IEBAIC0zMjU3LDE1ICszMjU3LDEzIEBAIHFsYTJ4MDBfc3RhdHVzX2VudHJ5KHNj
c2lfcWxhX2hvc3RfdCAqdmhhLA0KPiA+PiBzdHJ1Y3QgcnNwX3F1ZSAqcnNwLCB2b2lkICpwa3Qp
DQo+ID4+Pg0KPiA+Pj4gb3V0Og0KPiA+Pj4gCWlmIChsb2dpdCkNCj4gPj4+IC0JCXFsX2RiZyhx
bF9kYmdfaW8sIGZjcG9ydC0+dmhhLCAweDMwMjIsDQo+ID4+PiAtCQkgICAgIkZDUCBjb21tYW5k
IHN0YXR1czogMHgleC0weCV4ICgweCV4KSBuZXh1cz0lbGQ6JWQ6JWxsdQ0KPiA+PiAiDQo+ID4+
PiAtCQkgICAgInBvcnRpZD0lMDJ4JTAyeCUwMnggb3hpZD0weCV4IGNkYj0lMTBwaE4gbGVuPTB4
JXggIg0KPiA+Pj4gLQkJICAgICJyc3BfaW5mbz0weCV4IHJlc2lkPTB4JXggZndfcmVzaWQ9MHgl
eCBzcD0lcCBjcD0lcC5cbiIsDQo+ID4+PiAtCQkgICAgY29tcF9zdGF0dXMsIHNjc2lfc3RhdHVz
LCByZXMsIHZoYS0+aG9zdF9ubywNCj4gPj4+IC0JCSAgICBjcC0+ZGV2aWNlLT5pZCwgY3AtPmRl
dmljZS0+bHVuLCBmY3BvcnQtPmRfaWQuYi5kb21haW4sDQo+ID4+PiAtCQkgICAgZmNwb3J0LT5k
X2lkLmIuYXJlYSwgZmNwb3J0LT5kX2lkLmIuYWxfcGEsIG94X2lkLA0KPiA+Pj4gLQkJICAgIGNw
LT5jbW5kLCBzY3NpX2J1ZmZsZW4oY3ApLCByc3BfaW5mb19sZW4sDQo+ID4+PiAtCQkgICAgcmVz
aWRfbGVuLCBmd19yZXNpZF9sZW4sIHNwLCBjcCk7DQo+ID4+PiArCQlxbF9sb2cocWxfbG9nX3dh
cm4sIGZjcG9ydC0+dmhhLCAweDMwMjIsDQo+ID4+PiArCQkgICAgICAgIkZDUCBjb21tYW5kIHN0
YXR1czogMHgleC0weCV4ICgweCV4KQ0KPiA+PiBuZXh1cz0lbGQ6JWQ6JWxsdSBwb3J0aWQ9JTAy
eCUwMnglMDJ4IG94aWQ9MHgleCBjZGI9JTEwcGhODQo+IGxlbj0weCV4DQo+ID4+IHJzcF9pbmZv
PTB4JXggcmVzaWQ9MHgleCBmd19yZXNpZD0weCV4IHNwPSVwIGNwPSVwLlxuIiwNCj4gPj4+ICsJ
CSAgICAgICBjb21wX3N0YXR1cywgc2NzaV9zdGF0dXMsIHJlcywgdmhhLT5ob3N0X25vLA0KPiA+
Pj4gKwkJICAgICAgIGNwLT5kZXZpY2UtPmlkLCBjcC0+ZGV2aWNlLT5sdW4sIGZjcG9ydC0+ZF9p
ZC5iLmRvbWFpbiwNCj4gPj4+ICsJCSAgICAgICBmY3BvcnQtPmRfaWQuYi5hcmVhLCBmY3BvcnQt
PmRfaWQuYi5hbF9wYSwgb3hfaWQsDQo+ID4+PiArCQkgICAgICAgY3AtPmNtbmQsIHNjc2lfYnVm
ZmxlbihjcCksIHJzcF9pbmZvX2xlbiwNCj4gPj4+ICsJCSAgICAgICByZXNpZF9sZW4sIGZ3X3Jl
c2lkX2xlbiwgc3AsIGNwKTsNCj4gPj4+DQo+ID4+PiAJaWYgKHJzcC0+c3RhdHVzX3NyYiA9PSBO
VUxMKQ0KPiA+Pj4gCQlzcC0+ZG9uZShzcCwgcmVzKTsNCj4gPj4+IC0tDQo+ID4+PiAyLjE5LjAu
cmMwDQo+ID4+Pg0KPiA+Pg0KPiA+PiBJIGxpa2UgdGhlIGRpcmVjdGlvbiBvZiB0aGlzIHBhdGNo
Lg0KPiA+Pg0KPiA+PiBDYW4geW91IGNvbnNpZGVyIHJlbW92aW5nICJsb2dpdCIgdmFyaWFibGUu
IFNpbmNlIGxvZ2l0IHdhcyBkZXNpZ25lZCB0byBwcmludA0KPiA+PiBtZXNzYWdlcyBvbmx5IHdo
ZW4gYSBzcGVjaWZpYyBkZWJ1ZyAoSU8gYml0cyBpbiB0aGlzIGNhc2UpIHdhcyBzZXQuDQo+ID4g
PFNLPiBsb2dpdCBpcyBzZXQgdW5kZXIgY2VydGFpbiBJTyBlcnJvciBjb25kaXRpb25zIG5vdCBi
YXNlZCBvbiBhbnkgZGVidWcuIElmDQo+IGxvZ2l0IGlzIHJlbW92ZWQsDQo+ID4gdGhpcyBwcmlu
dCB3aWxsIGJlIGNvbWUgZm9yIGVhY2ggYW5kIGV2ZXJ5IElPLg0KPiA+DQo+IA0KPiBZZWFoLiBJ
IHNlZSB0aGF0IGFuZCBzbyBpdCB3YXMgbW9yZSBvZiBhIHN1Z2dlc3Rpb24gd2hpbGUgeW91IGFy
ZSBvcHRpbWl6aW5nDQo+IGRlYnVnZ2luZyBlZmZvcnQgd2l0aG91dCBoYXZpbmcgdG8gZW5hYmxl
IGV4dGVuZGVkIGxvZ2dpbmcuIGlmIHlvdSBjYW4NCj4gb3B0aW1pemUgbG9naXQgbG9naWMgd2hp
bGUgYXQgaXQgd291bGQgYmUgbmljZS4gSeKAmWxsIGxlYXZlIGl0IHVwdG8geW91LiBObyBvYmpl
Y3Rpb24NCj4gdG8gcGF0Y2ggaXRzZWxmLg0KSSB3aWxsIGxvb2sgaW50byBpdCwgSSBhbSBub3Qg
Z29pbmcgdG8gY2hhbmdlcyB0aGlzIHBhdGNoIGFuZCBzZXJpZXMuIA0KSWYgSSBlbmQgdXAgaW4g
bWFraW5nIGNoYW5nZXMgdGhlbiBpdCB3aWxsIGJlIG5ldyBwYXRjaC4NCg0KPiANCj4gSG93ZXZl
ciwgd2hlbiB5b3Ugc3VibWl0IHYyIG9mIHRoaXMgcGF0Y2hzZXQsIEkgZG8gd2FudCBtb3JlIGRl
c2NyaXB0aXZlDQo+IGNvbW1pdCBtZXNzYWdlLiBVc3VhbGx5IHNtYWxsIHRoaW5ncyBsaWtlIHRo
aXMgY2FuIGVzY2FwZSBzY3J1dGlueSB1bmRlcg0KPiDigJxkZWJ1ZyBsZXZlbCBjaGFuZ2XigJ0g
ZGVzY3JpcHRpb24uDQpTdXJlLg0KDQpUaGFua3MsDQp+U2F1cmF2DQo+IA0KPiA+IFRoYW5rcywN
Cj4gPiB+U2F1cmF2DQo+ID4+DQo+ID4+IC0tDQo+ID4+IEhpbWFuc2h1IE1hZGhhbmkJIE9yYWNs
ZSBMaW51eCBFbmdpbmVlcmluZw0KPiANCj4gLS0NCj4gSGltYW5zaHUgTWFkaGFuaQkgT3JhY2xl
IExpbnV4IEVuZ2luZWVyaW5nDQoNCg==
