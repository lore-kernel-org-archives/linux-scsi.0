Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E335C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 03:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiBJDyJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 22:54:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiBJDyH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 22:54:07 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4388923BF6
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 19:54:09 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21A2aeof014382;
        Wed, 9 Feb 2022 19:54:07 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3e4am94f13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 19:54:07 -0800
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 21A3pAAQ031734;
        Wed, 9 Feb 2022 19:54:06 -0800
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2177.outbound.protection.outlook.com [104.47.73.177])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3e4am94f11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 19:54:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbOzcPEv/9hhVYRgk4RRMTFNTvaVdwy41SvGY1Ej5wHdS4Rdkm6LLFKgtLjnQE5mYNGd5lFWh/JPYDT37TPbOuWbCrM8leyb8SyHT2rTOS8iyB4PVE+d/eh9Z/eoLmOZTnpI+zNPfdHREoeEIDeUPJ44ciMnaYJTaqGlXQ3duj325cRZir28nncI8uizV994pvKRgdC6RQoRrO2d285/fntEwybdoF0967cl3f84wrpriGadY3pdVd33VqbxxbjUlgOn3o7XGzrIkmepl9Xjwnx38hhHcPf5Ppog+BpiC1LgwCUUu210NeRjxT2ZSSteUPO0+PgO+PCt6IuKkyMTfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q0qYXTCSrbRrUYUQ5/RZqOctcSbuODckbW7nKNWAvZM=;
 b=VaFWtUb1+Fr/mivc2SqO1PVoipkqF9l9P4bB/hZ9vIZNY0ixzjS1BX5GXbJPNIxDQ/6mlR4ymefgVSKMbGXR6LTp5ZWLv2OKPzZcefypj/n+LYVzXnKX5EY6A1aWiFms7MoQDtmORYJEZARBkJSVl05qAbvcVMd6NW5Q39+z2KKmQ4NPNbgoyR+63Nph9jiix3+uay9Rsvre+SQ+CGJ+UZD7NeO6s07A2PjPYMcILqsoStyzD76B3lp1u6o7/lBFmna9G3P/powWCc/9sK2zoO1oDXjggnxQDAztNUwA1mbZcYkO6RJnNa98K/I+2whZHYUlk/VdHP6KUSFH4NBiBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0qYXTCSrbRrUYUQ5/RZqOctcSbuODckbW7nKNWAvZM=;
 b=IspBNxzjNOn08OubLTZMrO1Z5nc4rjQ9oJdjgJt+4f0/dmiQgYsEVjME9PUU7TGTygec6HkMcemScXyemtGs0O2pHclwGEYe+MMwzjewwz5YdzZvXYe+wGz8gzc8w+McG2vSK2uA7g33B9Moce0B+UPI1sohZTLhSZ4dQ+cQkiE=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by BYAPR18MB2487.namprd18.prod.outlook.com (2603:10b6:a03:139::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Thu, 10 Feb
 2022 03:54:03 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::b449:a2ad:6124:26aa]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::b449:a2ad:6124:26aa%6]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 03:54:02 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Ewan Milne <emilne@redhat.com>, Nilesh Javali <njavali@marvell.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH] qla2xxx: Add qla2x00_async_done routine for async
 routines.
Thread-Topic: [PATCH] qla2xxx: Add qla2x00_async_done routine for async
 routines.
Thread-Index: AQHYHM/qOsOceH0juUyphPR39p7P5KyLqEIAgACBZLA=
Date:   Thu, 10 Feb 2022 03:54:02 +0000
Message-ID: <DM6PR18MB30343AE823BEEA0E946D6533D22F9@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20220208093946.4471-1-njavali@marvell.com>
 <CAGtn9rnZZy9cENPt0hE4okN20BNTbWK0c0Jj7-RwdaAMmZW3Rw@mail.gmail.com>
In-Reply-To: <CAGtn9rnZZy9cENPt0hE4okN20BNTbWK0c0Jj7-RwdaAMmZW3Rw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bca4df4f-6bed-45ba-f320-08d9ec48fa2d
x-ms-traffictypediagnostic: BYAPR18MB2487:EE_
x-microsoft-antispam-prvs: <BYAPR18MB24876994CA319E2E1A05F758D22F9@BYAPR18MB2487.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xuI7FDx0fH19w/jJ5rZhjnyWbHaEa4dNRE0Hp0T2KSW9ZhMVrP7wzZcbRcMxwTZBdI+Tp/YECk/5wfNvWsvqolWpOaZKr6MyM038pkzjz2vtNjFuMGIU1QHtcuhdxkWBjtyM+z6yK/T8bHkQMycNckLY2TLvuQkFhNlZbdb3Ht9FwC2Q8G6vzdUQ5RS3ORdGGAUsiWBqGu0in79I5ZfpORzx7RnAwB/7mEXp0Ty2IKWIv04YDIOfuVH665RmoMmel4J7xCrxaFooe4cf2XIrNKAtb9y0zWBbWm8mNXIyhIWgBGhc9jScacuWxTjvAq/wcBuXjky523E/erExYNj5Cu9DXQyZ/e4iHFCpFVJslyWpwj9/e31zyHUw0du7/s2ogqraQKUfbJzkhWmxFbOyHynMduLARp86+4AlILjWR3QVt4vuyRDqtjzODzm/qiwtrR6JW7iyiaVQpy7F+vwvy8rQthVvXWu0sf7IrpkouIHkdqn8zhsj+/MxpDaYwX8fqDWGGKZe9TMv1a93GuV/TRNEGaPlBrVPZM+ofFQRcYk8Bt/jLlZhVwD6D4S3p4OOz9cSXooubLf/BbYmvdI/vJ06+kXcWVVPRZyQBO6IKYsS9vhVL2m1JdlOuGhrQoIsMoLty/8voz3u/7frOq5Msxt8l9pqU4mnzvI34S0OmDEu7RW3s97KHWAkfrfW+Eri4y1+GPo+zj69R+tYYeZELQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(52536014)(508600001)(76116006)(54906003)(6636002)(316002)(9686003)(7696005)(6506007)(66476007)(33656002)(53546011)(110136005)(66946007)(4326008)(71200400001)(8936002)(66556008)(8676002)(64756008)(66446008)(26005)(2906002)(186003)(38100700002)(122000001)(86362001)(38070700005)(107886003)(5660300002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dVVheE82SmN1d0srdmZQZm9ZU2J4UHFIakJLd3o4RWQ1MWlYSWc0dFZjcktT?=
 =?utf-8?B?TDZ3L3dldDBJQWdra05TOWlPZk9mSzhZQWhJRWw2bTBObkZiZDljdmczVWlV?=
 =?utf-8?B?V3djR1Mzc2J0cG9wNXhaYWMxeFdOczEzWUNydWl5bmRTUFFvS09TSFByY3FZ?=
 =?utf-8?B?aG1SV2R0dFR0R3hkbFNSdzJoTzRaZnRaU0ZtbzV0Q3BwUHZ4T2llS250UDFE?=
 =?utf-8?B?OVRxL2R3VE42M1RaRGRQT21aLzBJVGphRW04SWJvNms3cFl5R2RKQk9jWVUx?=
 =?utf-8?B?MDV0NkZYemd6T0V6VzNQSHZ5SUFaVHJlZFVqT0Y2UXlBTXRHZmxPVjkyTGx5?=
 =?utf-8?B?T0dnbk1SYUJQQWpYRE5pdnVYN0NjbkVvcmMrSENESVF2RTU3V0dSUjcrVjFZ?=
 =?utf-8?B?enJTUlhmMXBwbFd3N0tneEw2NUh3RS9DQ1BnNFRvVWN5M0pQcFlHclNQWWVU?=
 =?utf-8?B?OVBLOVU5UlllU2Y3T0N0VktSajh0QktDMVpMbG9HTVZEUXNNNmxCc3VwVThB?=
 =?utf-8?B?eHdRRmxkUE9KaG1iUURZQWhiclZ3dE1EbWwwbWNRUU1MQXhIaU52Z1haOUZh?=
 =?utf-8?B?Y1R5SXZ4SzI4dFFsRGZjc0pUOEdKYmo2V2dlYWtMVmU1S3l5OTJLTjNPQWVl?=
 =?utf-8?B?SkxaVXdOK1hQYmhMNUtydy9DTmdtS0lqVGNiY091SlJBSnJPNEp1K3R4d0pw?=
 =?utf-8?B?Z3ZKbE54ZEJaMTVMSFNUMmdmNk5yTUQ0Q2FvV1J4UWE3Z1FyV2hqK1JWUDlD?=
 =?utf-8?B?cEtHcFNHTEMxK1ZqdmQyTCtYMWhmbnBSbTI0blRyRE4rdXhwNm5Pazc3Zit2?=
 =?utf-8?B?NFVZdXdsYXFUUnliS0t2YVlic3BOYS9xN2F1Q3VkMTdQRDBtOFJuSWNKOURB?=
 =?utf-8?B?ZDJIRS9SaXNqTWo3cy84cVZ1Mzg5Yk5kSnU0YUVJQWNEaUgwNkFqZ2RFYnhM?=
 =?utf-8?B?ZTBleTZZNUVQNmZkMFJuNHgvVzJORTM2a3VveVdUbkd2ZEszSDgxYktHMnNE?=
 =?utf-8?B?Ti9zeW5CWWMyb2E3VysyVk1KNXc1L28wYW1yanJnaGdWU3ByQjN2Y3BEOG9T?=
 =?utf-8?B?ZU1GMzlZczBRYjFpRGdqY3BiMjJhQU5UMGg2WDhqdEREb05wbThmeXRsRFJh?=
 =?utf-8?B?Y01ka0tsMjl2dTRyTE1zamd0Rm1WLzlJQ2gwMk8wZStuVWthQlhkR0p4QU42?=
 =?utf-8?B?cTZreldBTUpjNjdieTh6RzhJVldlWElsRXBiYkhWbVRIOTY2WUJNeUFVL0FR?=
 =?utf-8?B?anc3VDRtMm9JY3BwZHJQUk5yNlZyUlpDSEJUSUpMTVRQcW9RME1FcEd1YlQy?=
 =?utf-8?B?ZEFlaHgwaWIrU3pwcTJKdFlPR1VmWmxsOUZMM2poRFF2NmlLeUdkWTFuNGQy?=
 =?utf-8?B?T3BjTnVuZVVTUk1XL1A0VWZDTWpHS2tIVUhHMVlDTDdrWkFPbFg0Qjg5NVF2?=
 =?utf-8?B?UFhvRVNXcXNJRFBLYjd3b0RZOE9BYzhDQVJCU2JUdE80Y1ZibUNqTFJEVGNC?=
 =?utf-8?B?VjhnMGNVYlFSMnlHZkZER0Z0K1hQNE1LcDdNNEsya2ZPQzl3dHYrcmg4eEFF?=
 =?utf-8?B?YldPT1g3UGxnS2ZKVFZRZitEQ3A5L2FBdnhwOS80czd0L0lRRXM2RVRrdkJs?=
 =?utf-8?B?VEh3UitYNkk0R1ZyMWF3bm1yM0NoMEpjb21jQ2hIaklsMktrTlZwdjQ1WXIx?=
 =?utf-8?B?OGpSTXFTS0o3Ukh1aVpRamt1Mi9FMWpHMkVVemFHOE0zaSt3QjNUT2RDREpn?=
 =?utf-8?B?bm81bGUzV21zNUp1YkdZdG9yaTd1ejkxOHYwQWpyWUM0dHF0VWZiVnQ0YW82?=
 =?utf-8?B?VUxVYkI1Vjd4bzRORlRmOWdzK1RzMVlYakt3VDJaeGwyMTRTMm1mWjBNWE9a?=
 =?utf-8?B?QUNrVU9waHZHL05CRjZhZGZ5R3o0alJTVDZjb2t5bXE1NisvZzFXcjNvdlkz?=
 =?utf-8?B?Smt1ZHNtb0dHcVNCbk12YUJ1OTVnK0MxeXplWktYakJST2ZCKzNlRWhCeW9K?=
 =?utf-8?B?OGxMWHBLVUY3K01Qdk1wYWlpTm5vTFB5VllaY0l1dW00STdxNVNMak5hem54?=
 =?utf-8?B?MEJhVlZYL1owRkp4M2dkSngyL2VpVnl2eUY0M2R0ZXdQUHc5OUJiQk8xLzNP?=
 =?utf-8?B?QkxYNXBBWS9VWmlFWmF1a0Z6R05wa05Ma1lXS3hKRndWRWFYTW13RW1JZXVT?=
 =?utf-8?Q?sJyDYFUyDAQuPv0414m0aBs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bca4df4f-6bed-45ba-f320-08d9ec48fa2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 03:54:02.7345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yEopwKm5huuFeeZTtz+6JH9shw7VOdXukND5XvyJgaIqk2XQAuyH/pZGCyLqj1iuBhuUf6L6eX9vJtsHbaVYKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2487
X-Proofpoint-GUID: aR-IobrAVlOROICFhjwKWnLdeyv2F3ZO
X-Proofpoint-ORIG-GUID: ThEmxg1SrOF59ks5DsAclp_3JVHInlF6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-10_01,2022-02-09_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgRXdhbiwNClRoYW5rcyBhIGxvdCBmb3IgYW4gdXBkYXRlLg0KDQpIaSBNYXJ0aW4sDQpDYW4g
dGhpcyBiZSBtZXJnZWQgdG8gb3JpZ2luYWwgcGF0Y2g/IA0KRml4ZXM6IDMxZTZjZGJlMGVhZSAo
InNjc2k6IHFsYTJ4eHg6IEltcGxlbWVudCByZWYgY291bnQgZm9yIFNSQiIpDQoNClRoYW5rcywN
Cn5TYXVyYXYNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBFd2FuIE1p
bG5lIDxlbWlsbmVAcmVkaGF0LmNvbT4NCj4gU2VudDogVGh1cnNkYXksIEZlYnJ1YXJ5IDEwLCAy
MDIyIDE6MzkgQU0NCj4gVG86IE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlAbWFydmVsbC5jb20+DQo+
IENjOiBNYXJ0aW4gSy4gUGV0ZXJzZW4gPG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPjsgbGlu
dXgtDQo+IHNjc2lAdmdlci5rZXJuZWwub3JnOyBHUi1RTG9naWMtU3RvcmFnZS1VcHN0cmVhbSA8
R1ItUUxvZ2ljLVN0b3JhZ2UtDQo+IFVwc3RyZWFtQG1hcnZlbGwuY29tPg0KPiBTdWJqZWN0OiBS
ZTogW1BBVENIXSBxbGEyeHh4OiBBZGQgcWxhMngwMF9hc3luY19kb25lIHJvdXRpbmUgZm9yIGFz
eW5jDQo+IHJvdXRpbmVzLg0KPiANCj4gVGhhbmtzLCB0aGF0IGFwcGVhcnMgdG8gaGF2ZSByZXNv
bHZlZCB0aGUgY3Jhc2ggb24gYm9vdCBJIHdhcyBzZWVpbmcuDQo+IA0KPiBUZXN0ZWQtYnk6IEV3
YW4gRC4gTWlsbmUgPGVtaWxuZUByZWRoYXQuY29tPg0KPiANCj4gT24gVHVlLCBGZWIgOCwgMjAy
MiBhdCA0OjQwIEFNIE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlAbWFydmVsbC5jb20+IHdyb3RlOg0K
PiA+DQo+ID4gRnJvbTogU2F1cmF2IEthc2h5YXAgPHNrYXNoeWFwQG1hcnZlbGwuY29tPg0KPiA+
DQo+ID4gVGhpcyBkb25lIHJvdXRpbmUgd2lsbCBkZWxldGUgdGhlIHRpbWVyIGFuZCBjaGVjayBm
b3IgaXQncyByZXR1cm4NCj4gPiB2YWx1ZSBhbmQgYWNjb3JkaW5nbHkgZGVjcmVhc2UgdGhlIHJl
ZmVyZW5jZSBjb3VudC4NCj4gPg0KPiA+IEZpeGVzOiAzMWU2Y2RiZTBlYWUgKCJzY3NpOiBxbGEy
eHh4OiBJbXBsZW1lbnQgcmVmIGNvdW50IGZvciBTUkIiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IFNh
dXJhdiBLYXNoeWFwIDxza2FzaHlhcEBtYXJ2ZWxsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBO
aWxlc2ggSmF2YWxpIDxuamF2YWxpQG1hcnZlbGwuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJz
L3Njc2kvcWxhMnh4eC9xbGFfaW9jYi5jIHwgMTcgKysrKysrKysrKysrKysrKy0NCj4gPiAgMSBm
aWxlIGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW9jYi5jIGIvZHJpdmVycy9zY3Np
L3FsYTJ4eHgvcWxhX2lvY2IuYw0KPiA+IGluZGV4IDdkZDgyMjE0ZDU5Zi4uNWUzZWUxZjdiNDNj
IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMNCj4gPiAr
KysgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW9jYi5jDQo+ID4gQEAgLTI1NjAsNiArMjU2
MCwyMCBAQCBxbGEyNHh4X3RtX2lvY2Ioc3JiX3QgKnNwLCBzdHJ1Y3QNCj4gdHNrX21nbXRfZW50
cnkgKnRzaykNCj4gPiAgICAgICAgIH0NCj4gPiAgfQ0KPiA+DQo+ID4gK3N0YXRpYyB2b2lkDQo+
ID4gK3FsYTJ4MDBfYXN5bmNfZG9uZShzdHJ1Y3Qgc3JiICpzcCwgaW50IHJlcykNCj4gPiArew0K
PiA+ICsgICAgICAgaWYgKGRlbF90aW1lcigmc3AtPnUuaW9jYl9jbWQudGltZXIpKSB7DQo+ID4g
KyAgICAgICAgICAgICAgIC8qDQo+ID4gKyAgICAgICAgICAgICAgICAqIFN1Y2Nlc3NmdWxseSBj
YW5jZWxsZWQgdGhlIHRpbWVvdXQgaGFuZGxlcg0KPiA+ICsgICAgICAgICAgICAgICAgKiByZWY6
IFRNUg0KPiA+ICsgICAgICAgICAgICAgICAgKi8NCj4gPiArICAgICAgICAgICAgICAgaWYgKGty
ZWZfcHV0KCZzcC0+Y21kX2tyZWYsIHFsYTJ4MDBfc3BfcmVsZWFzZSkpDQo+ID4gKyAgICAgICAg
ICAgICAgICAgICAgICAgcmV0dXJuOw0KPiA+ICsgICAgICAgfQ0KPiA+ICsgICAgICAgc3AtPmFz
eW5jX2RvbmUoc3AsIHJlcyk7DQo+ID4gK30NCj4gPiArDQo+ID4gIHZvaWQNCj4gPiAgcWxhMngw
MF9zcF9yZWxlYXNlKHN0cnVjdCBrcmVmICprcmVmKQ0KPiA+ICB7DQo+ID4gQEAgLTI1NzMsNyAr
MjU4Nyw4IEBAIHFsYTJ4MDBfaW5pdF9hc3luY19zcChzcmJfdCAqc3AsIHVuc2lnbmVkIGxvbmcN
Cj4gdG1vLA0KPiA+ICAgICAgICAgICAgICAgICAgICAgIHZvaWQgKCpkb25lKShzdHJ1Y3Qgc3Ji
ICpzcCwgaW50IHJlcykpDQo+ID4gIHsNCj4gPiAgICAgICAgIHRpbWVyX3NldHVwKCZzcC0+dS5p
b2NiX2NtZC50aW1lciwgcWxhMngwMF9zcF90aW1lb3V0LCAwKTsNCj4gPiAtICAgICAgIHNwLT5k
b25lID0gZG9uZTsNCj4gPiArICAgICAgIHNwLT5kb25lID0gcWxhMngwMF9hc3luY19kb25lOw0K
PiA+ICsgICAgICAgc3AtPmFzeW5jX2RvbmUgPSBkb25lOw0KPiA+ICAgICAgICAgc3AtPmZyZWUg
PSBxbGEyeDAwX3NwX2ZyZWU7DQo+ID4gICAgICAgICBzcC0+dS5pb2NiX2NtZC50aW1lb3V0ID0g
cWxhMngwMF9hc3luY19pb2NiX3RpbWVvdXQ7DQo+ID4gICAgICAgICBzcC0+dS5pb2NiX2NtZC50
aW1lci5leHBpcmVzID0gamlmZmllcyArIHRtbyAqIEhaOw0KPiA+IC0tDQo+ID4gMi4yMy4xDQo+
ID4NCg0K
