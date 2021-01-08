Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC19AC433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:38:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DCBF22527
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbhAHEiX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 23:38:23 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32840 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726793AbhAHEiX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 23:38:23 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1084a94N026521
        for <linux-scsi@vger.kernel.org>; Thu, 7 Jan 2021 20:37:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=Q6pRn5mQPxYk6c3+9X/XCGhpri8bwebgiX9y7IooZt8=;
 b=gGutZFG8US2koL+v5JcIZrT5VYujZOFS6jNyVXGckWsEh+rRYuUI+DnhgrGj2drl9kQP
 9RiSdmfez/jepkNPe8oNhQbgBhYvSqk4B8++3UGNAw3CVkBhpqC9oTRU3cnV+K4+WcYE
 xdu5zndPOkeNUTBRx9iawUakJ8luPHFPFgNYIbaL57/IJAWAAUmqwQfKa6YtwVPT9b6v
 7GCUJTNX7d9uzW/x5aUv8WMsExoK8GwzNBtdaPsskY42VgvR5HtYbsiBGub/d1f+V3ZW
 VtOOicq4TFbHUfH7gcI8OrNv2FUbzCqcBMz2Vdsl2va4P+DubuB/3OGRQ7iprNS3xe6X HA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 35wy5a2w4r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Jan 2021 20:37:41 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 Jan
 2021 20:37:39 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 Jan
 2021 20:37:38 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 7 Jan 2021 20:37:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0a4VkF5IUSS5rI0X2Rh1qagQkSVsYK/oJzit++EPWpSftAatDcOUYeIeEFl0CzijXr9GpRJZn25UU2BiCPGKomyGz8T8oIb9MV9kVrEva6Ktkfeuc5/P5ffawJpKOnhojZ+XwEU/uOtUOKKjf/C3+XoqBFeNkFsVh/mFrXdUs8ogKfpM+k8Cq5lUVriBZv3EC/RR6yOgm0oZk/Xc9QwilEuIgHgX+VAucs/7hS+kArAeUb+rCnlsRelNBxfNXs2YG8IIJ7ttiU+5VtBVwWth9QZBBCeqXNnOqFzcL95cIgz+Nt4lHiLC4oolQbLJKv0AzsRlNg+MnkkwYupDTkdzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q6pRn5mQPxYk6c3+9X/XCGhpri8bwebgiX9y7IooZt8=;
 b=XEM3gRZnPvCSHT2tWur4t50MImygaaom96mrhRCxbR08uzi3iFcyI6WcoU4CZQmE06wzXGOERNfl0cFGN9JAEEhgp18zm9RmzjncHaBin+rg++xme1w8BheQcU2VTRWi9+4IlNAbhtvoCD8a0Aq3FjtzS95ITLLCWjSjY4SuGbVxrDVHefNzV5IybzKnV3OqBUhzOiuv0JK/dRfYIeP4yRy+b69HRxHqmPoqrSbQKMC75I+dhkODSTgM5m4Lroi/DHxG9tAkb9mNliW7X6oXE3waQtZ2Z3vkHFjXN1kfGO2ni3YuWSOc2K+G//VjbHmNYRdQ40rMca4tCF5mXTphFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q6pRn5mQPxYk6c3+9X/XCGhpri8bwebgiX9y7IooZt8=;
 b=gwarLn8+7FNnBQyv0atEww+7GxT5Uzj9hRG1AZ9L29q0JGPfzLXuIGsPW74ryl+TatgWTgDmmQLV7VwylacZMQlnsVMD+XziSIJHlYw5l/yoKM5DT8sErVqCxnOPalzXfacbN6CHxCXwuPPf/UOWVLtzoOrr7dXOb1C8OCd2/es=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM6PR18MB3585.namprd18.prod.outlook.com (2603:10b6:5:2af::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 8 Jan
 2021 04:37:38 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::201c:2fc9:faf8:16a9]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::201c:2fc9:faf8:16a9%6]) with mapi id 15.20.3742.006; Fri, 8 Jan 2021
 04:37:38 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [EXT] [PATCH v3 1/7] qla2xxx: Implementation to get and manage
 host, target stats and initiator port
Thread-Topic: [EXT] [PATCH v3 1/7] qla2xxx: Implementation to get and manage
 host, target stats and initiator port
Thread-Index: AQHW5R6kQQlNwuEDhUGOCDDEQb9RPqodJZMg
Date:   Fri, 8 Jan 2021 04:37:37 +0000
Message-ID: <DM6PR18MB303408DDE34D1E5F6C8B2EEBD2AE9@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20210105103847.25041-1-njavali@marvell.com>
 <20210105103847.25041-2-njavali@marvell.com>
 <DC6A6732-5FF5-48BA-AAEA-75DAD94F1A55@oracle.com>
 <BN8PR18MB30257A867FEEE66D619C12C3D2AF9@BN8PR18MB3025.namprd18.prod.outlook.com>
 <89A792AF-49D2-425A-AC0E-BA673C84A181@oracle.com>
In-Reply-To: <89A792AF-49D2-425A-AC0E-BA673C84A181@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.103.215.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2eb84961-c635-4f66-ea3f-08d8b38f208b
x-ms-traffictypediagnostic: DM6PR18MB3585:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB358589D5D727A99533003233D2AE9@DM6PR18MB3585.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AmYLYKDynvgsBBT9pYhCF3a132kyAP8uKlvHndsp5Nn6aA+mrZNB5OMvMeBGGzl+9p49TJ8nW/gir7QSVtClsmHjNuat4QSH+DvD4+LRhqNXqFPMCMC6b48ip1WhkAzhXs1UIfzajhd42pCGDYFADC6UCTZEaB2rjeaigEDFMk/z0rTjoGAeLwbAMvZe/bGn4Ojb+XFu4btq+uSTUBporQ0pgExxR4aM5uoxTyTn+nD4XaV3/ZLgD2WN9W56iztiPLH7iJpz5Sik3JC6CJ14rdW9BSUxSCbSPcQYdstrSNIFaBMML5/nTLRkal0TdKlxp/qc319LpNjaK8L7pCpZfhLV05LWopaZeESiD/40hi1DkIRdyxqbvRT7TpmTZohtA32B/U7YSF+61yBemC9pGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(8936002)(76116006)(107886003)(66946007)(6916009)(66476007)(2906002)(54906003)(4744005)(66556008)(55016002)(64756008)(7696005)(9686003)(71200400001)(83380400001)(26005)(316002)(86362001)(6506007)(53546011)(8676002)(52536014)(478600001)(66446008)(5660300002)(186003)(33656002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?blhqbGJrMzIzTlJwTGRiTmExUkZBWFVsMGNLUmsweEUyd0x5SnFlenhSVmxT?=
 =?utf-8?B?Q0hyMGg3SlZxdGpBbzFLU0lmYzJkODkyZlI2OFZwZ3luUGhBdUpvRnVrbG04?=
 =?utf-8?B?SFJtTTZ1WXF2NmpGck9jc3FGQk4wNUFRYlJ2WUpqeHo5VitXRzFBZGRZbUU2?=
 =?utf-8?B?MWM4aVMvenJRN2NGMFRHbTlua2VqeFB6RXJIYVRMOWlxTlJ2SWVyQmEySnVy?=
 =?utf-8?B?ZFNSTFJjZkM1Tkpma0poSU00N1Vqb0cwL3Uwei9aQTB3RXZzQU80bjVKMnVm?=
 =?utf-8?B?aXBJU0dQZ2tPc2VZRTVldWxIS2J0VEprc3MyV21tWFJCK2g5aTNsVkhqYkFm?=
 =?utf-8?B?Vm1yWmVXSllEd2dSVW9pcVpNb21Kc0lYb0JVakpJd25vUDF1QVAxbEljQXYz?=
 =?utf-8?B?ZVhrbDE0K1lqd1JSQmlMWS8ybE9MNjRLQ3BzL1lka08rbTlRNHlEakJlYWtr?=
 =?utf-8?B?TWxJZEJVRGRST1llZkFPeDk4UjVKUVFDYm9jTkdIYnhqSG12d3VMOFhaUVAz?=
 =?utf-8?B?V3dtYVpLeGg2OVM5aSswN1A2VFJ0SDgvUk1mRjh0TC9RZ1l0ZElDOVVsT2tp?=
 =?utf-8?B?VU0vNVk0RGNOaFBaaUJlRVZ5MVVHcUV2cEVDaCtUMytwY0FxK1M1NjRhaDFD?=
 =?utf-8?B?VkhPSnFEb0tvSWdON2c2MHRqRlp1dWVIREFxSHpHK3EzRHk0bXg2SC9telVW?=
 =?utf-8?B?YndMOVJLTHo2V1hwbHhac2laZ0pkWmdmcHh3RENLTk83LzNKQ3B2K3FkdVVh?=
 =?utf-8?B?ZUk2ZzBuUEZlS1FqZTBvUi9xR09iWGMzZzc1OW5mbEFPNXpxTlZYMWRvbnVB?=
 =?utf-8?B?NVRoL0xtMkQxSW1pcnlONGVLdTZRT3dqcFhqSWFUT2hzVWcrTloybTVjcmxU?=
 =?utf-8?B?cVNOWHBCSmpROWE1ZEdJNFlGdCtlemtLMFIwb05oK3dCWk5ETjlCV3Z5WUlJ?=
 =?utf-8?B?Q3JQRC9NZlVnNTNTVFNlb2c5eGJHZ1lSbWRvb3JwZFQ2OElIcE1nbVYwKzYw?=
 =?utf-8?B?amQxV3l6aE5pMUJaMXp3RXU3bGN4S0pHVENCS2ZRb25QQWkxOVdmUjFLU0R2?=
 =?utf-8?B?S0czaGhjM2wvZTRoRTlIN1NpcHdCZnZoZ1B5SzN0TTVTaXVLcXlPSGREdno2?=
 =?utf-8?B?OS9FQ1dqQlBXNHNLK0UwY3BCYVN6M1cvaEJ2V2FvRDhMaUtpWXVJWHc4S0Ju?=
 =?utf-8?B?SUVNMjVlbGNhZjd0ZCswYjdPOUwyaXJGclZFQW00WngydVp5TDQ5Y0ZhZlRZ?=
 =?utf-8?B?SHpRUXo5N2hvNnFHN2E1dXU1bTVJZk0vYVU1bkZUMDRQd3BiS0xabG8xTHdW?=
 =?utf-8?Q?AoS7LWULqyHCI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb84961-c635-4f66-ea3f-08d8b38f208b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2021 04:37:37.2215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1mV5zII3+ttKT6rdNzDwV4Xp66XdjAmSzgN9sQGn1leAYk1cs0XGGd5vfBhdkcDvy77EXSIqE/2x7oNlEiAWRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3585
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-08_01:2021-01-07,2021-01-08 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgSGltYW5zaHUsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSGlt
YW5zaHUgTWFkaGFuaSA8aGltYW5zaHUubWFkaGFuaUBvcmFjbGUuY29tPg0KPiBTZW50OiBUaHVy
c2RheSwgSmFudWFyeSA3LCAyMDIxIDExOjI3IFBNDQo+IFRvOiBTYXVyYXYgS2FzaHlhcCA8c2th
c2h5YXBAbWFydmVsbC5jb20+DQo+IENjOiBOaWxlc2ggSmF2YWxpIDxuamF2YWxpQG1hcnZlbGwu
Y29tPjsgTWFydGluIEsuIFBldGVyc2VuDQo+IDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT47
IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBHUi1RTG9naWMtDQo+IFN0b3JhZ2UtVXBzdHJl
YW0gPEdSLVFMb2dpYy1TdG9yYWdlLVVwc3RyZWFtQG1hcnZlbGwuY29tPg0KPiBTdWJqZWN0OiBS
ZTogW0VYVF0gW1BBVENIIHYzIDEvN10gcWxhMnh4eDogSW1wbGVtZW50YXRpb24gdG8gZ2V0IGFu
ZCBtYW5hZ2UNCj4gaG9zdCwgdGFyZ2V0IHN0YXRzIGFuZCBpbml0aWF0b3IgcG9ydA0KPiANCj4g
DQo+IA0KPiA+IE9uIEphbiA2LCAyMDIxLCBhdCAxMTozNCBQTSwgU2F1cmF2IEthc2h5YXAgPHNr
YXNoeWFwQG1hcnZlbGwuY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+IDxTSz4gSXQncyBhIHN0YXRl
IG9mIHRoZSBwb3J0LCBpdCBjb21lcyBhcyBwYXJ0IG9mIG1hbmFnaW5nIHRoZSBwb3J0LiBJZiB0
aGUNCj4gZXJyb3IgY291bnQgaXMgbW9yZSwNCj4gPiB1c2VyIGNhbiBvcHQgdG8gY2hhbmdlIHRo
ZSBzdGF0ZSBhbmQgcG9ydCB3aWxsIGdvIHRvIG9mZmxpbmUgc3RhdGUuDQo+IA0KPiBJbiB0aGF0
IGNhc2UsIHNtYWxsIGRlc2NyaXB0aW9uIGluIGEgY29tbWl0IG1lc3NhZ2Ugd291bGQgaGF2ZSBi
ZWVuIHZlcnkNCj4gaGVscGZ1bC4gSXRzIG5vdCBDbGVhciBmcm9tIHRoZSBwYXRjaCBhYm91dCB1
c2Vy4oCZcyBjYXBhYmlsaXR5IG9mIGNoYW5naW5nIHN0YXRlIG9mDQo+IHBvcnQNCj4gDQpTdXJl
Lg0KDQpUaGFua3MsDQp+U2F1cmF2DQo+IC0tDQo+IEhpbWFuc2h1IE1hZGhhbmkJIE9yYWNsZSBM
aW51eCBFbmdpbmVlcmluZw0KDQo=
