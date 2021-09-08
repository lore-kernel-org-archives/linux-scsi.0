Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7675BC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 13:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6136A61100
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 13:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235767AbhIHN71 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 09:59:27 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:32618 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235446AbhIHN7Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 09:59:24 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 188DTPMO006013;
        Wed, 8 Sep 2021 13:58:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=DLQNUlVtgMPBBr2yVe6YC7RpyjcHitfiy57vSoGcq7Q=;
 b=flCn+0syBxq0Ri483SqknMzH3IYTQHNl/Wfm1yFll52p4UXXvsMGuGW8uTD55+asNJ6v
 7lUIs4D8NpZdBtChgs/NKy5a60sbnnAMg1mPgE5O7wKAB3yuy9jSlsCoHTlhkP5lgSZK
 BPU1bd7abv6uQvjPoLkVxu1Lvge3yzBliOUZJT2ZiFk8voFPzOn6Sexu0dXJg0YKx13r
 omhfGyIHCuH9FQgPcd+LK/A83RozsFYu2XuY2NjhF6l7z195KNEBMD+Bup+q48m2w/Js
 2GhPUHzK0d6573HNwTZNz8r91AlcBTNGAugGfT/r20K45s7pILV329WkelhFLjD2ri0t FQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=DLQNUlVtgMPBBr2yVe6YC7RpyjcHitfiy57vSoGcq7Q=;
 b=EvGUdU2/84FyBFicm/5B//ULADbLQ8ILhuJlbsB0dEWxtLwmmHi2bCKSbU8Iap3BL61T
 EjmAOaIIYj3Nx3k2rH8sKsrsm73cdLuBU9N9/c7cKh9hlYcLK9kIS1NUYG4l03KMYEDo
 yhaR82z4UxJ4bXuMZLNsyS7PSmKFbW9fkjxRG4/8UtCqXzYRySjCLveBJcj/emkMKYej
 oUacGRiNOFGXQUcADcW/h+tYOofn4tv6a0fYkC/uupTksBqXBjUmimrnJ4ivZS0IQfix
 I6oJT+1qztxlt2Q7fpI38R2Ki891U7R63RdqbxyO+BAd8wRrJ0YXRdbLFOwVzuyUUqzc Yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3axd8q2tde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 13:58:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 188DuDxA063041;
        Wed, 8 Sep 2021 13:58:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3030.oracle.com with ESMTP id 3axcpnscnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 13:58:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Epgj7uLNocuH3aBRaggvMkC1qey25u7ECaqeJ9bxnRAvEQgg63RIBXvNXP7NTydFdJX3345t/xi7F9AX0C0GcmjCZU8bVVePcIgLLZKM/Soo5Hum7aHcv3o6H6Ju6PXjt2UtJMRgEqseEi8Q3BMldfebVA2TvUby6KNGw/MXzyBt8X05ET54rdsqZfS4iKgp//3965wHLJTdsGn6jiBwOP6uAtHkbqbhXzWmOqb16FPSuM3EXaafXqEwRVbIu1lD5D0RIlEZNJySCONdOHNDXkDvxyld5VHShmGjTB3Ug3nFdbzKR1ZCODqU5hPWFzoJaNNXyaa6WJQXBR6Y+li7Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=DLQNUlVtgMPBBr2yVe6YC7RpyjcHitfiy57vSoGcq7Q=;
 b=m1CZeFLeoFPQj5cYVCbry702Ia6WmdjH4ChRjdSBnoPN5gGFQuz3fXBBbNei6vLQxCjTVOtYHx8svwmCgff2fazGBaJDdxu6kOqLdetSw+bLTyb5+kMLNHy5QcFF74IYCCtdw/A2/4QioPNRQqA9mazDEGco+ZjpIVdS6zeLjieT3uAXYQBB9KKF1xvHaGUiNEjIHdH+kXmtPs1H0OKFVfc/P9SuiC2dLx77WF/tc/MRRbrb5oieK5ansFj6RbWuWzkF3HehI23XfcdjK9v1gIBHp/ipGp7fHD6aLdCX3iqw3pAL7k22Qg77Oq6kir1yNAROrEzcTN1fpLU0FTRpMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLQNUlVtgMPBBr2yVe6YC7RpyjcHitfiy57vSoGcq7Q=;
 b=g4cuSh8pgGBc27DINt2GMVvhZPvLAum1aS2zMGKoLD96xJhmxwgAoR+TOrtJkSnC/lu/pPySOK89gz27W8EgHDuXjdTN74ymaTGEplLhQFSY6lBGG1zGOnp5XZoE/QT6gTqe+NuOI4X/EudQDpa74r8YklH8OX8wxM8UUFj9XCQ=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2830.namprd10.prod.outlook.com (2603:10b6:805:cc::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.26; Wed, 8 Sep
 2021 13:58:08 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::38df:8fa2:1602:2dfe]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::38df:8fa2:1602:2dfe%3]) with mapi id 15.20.4500.015; Wed, 8 Sep 2021
 13:58:08 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "djeffery@redhat.com" <djeffery@redhat.com>,
        "loberman@redhat.com" <loberman@redhat.com>
Subject: Re: [PATCH 04/10] qla2xxx: Fix crash in NVME abort path
Thread-Topic: [PATCH 04/10] qla2xxx: Fix crash in NVME abort path
Thread-Index: AQHXpIN0Jy1S36nNzEG8ArdS/KLUQKuaKhQA
Date:   Wed, 8 Sep 2021 13:58:08 +0000
Message-ID: <7D36D2E5-FF26-4CAD-A881-AC1E291736B3@oracle.com>
References: <20210908072846.10011-1-njavali@marvell.com>
 <20210908072846.10011-5-njavali@marvell.com>
In-Reply-To: <20210908072846.10011-5-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ec85927-05c6-4d91-465f-08d972d0b083
x-ms-traffictypediagnostic: SN6PR10MB2830:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB2830E97F061A4F9AD8A0E169E6D49@SN6PR10MB2830.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:619;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tOsUQOXzKqwZnfjK8ns27BjMiDAwPVvMgr0dM9Soy3YDVitDeb8gz2FC0TpTWVgu0DoGLo4XkTLctFyBJ4GjiiasyElf2ILEMQMHXIuyc4U3Rm7bXlRfO371UNuwR11r5vYtlT6sVYkein41knqrdZmM8C3PqXcIjMEQjuDsaS8ni5RR9lnwoG6Uz4vZLAYlyreoyz8syU7vY6SC5+wwYfwZhVqbPE9wVE8MrNy5Tkgp296X00U/WChNTVjXC9FGSVmesUxKeXNQdRwuHUpa8e/e6WZO5sR6Xe9oytXed/DKTnRLRHZjfqUwP3uLnuM6ol5lwjjUIEwb1UIiPDkYANXF6si69qQNPj35OokwGca9taWsR0VJvks6kwOskj/zUUbKfJjlcnkG4d0WFMwSh33F9ZDoDr0fYH2rVw+snDyfYnNfj7goVZaDpdvedqppk5xn0QgrhYopMYAzKsQUse7bWa2wNLEW6vs1wdsGoUaCIoiZHwbwe+Hco9AR0ntfLiJv+Jo3fU9toOxXbufpCSf9mAy7Uv+G0Mbufeg+TovbzBNtFW7z3KiWtYcgDg+n/kzoZRxoMT/e5nzaOQE5dXjsWxaSq78eNo97pKPfTRFh2n+X5eJTfOnNn2t/YG0bbA95CVvYCnV0diUoVv0MuvM/nUth/fTad4ixoQ+opPhPreGrxeNHzsPLsZURkKz/QWQRpM5TWlzXnd1Hm4N2JZpVxOsYP+OwvKZkrmvEjF0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(136003)(346002)(376002)(71200400001)(86362001)(36756003)(316002)(4326008)(83380400001)(33656002)(2906002)(76116006)(6512007)(6916009)(38100700002)(122000001)(53546011)(54906003)(2616005)(38070700005)(6506007)(66476007)(6486002)(66946007)(64756008)(66446008)(478600001)(66556008)(8676002)(44832011)(5660300002)(186003)(26005)(8936002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RmNLRUVxSnV6MmpoY21FbU1nUjhCYmdGekpLVHdyRmE1V2Y0NVgxWldBNEhO?=
 =?utf-8?B?OWtyekZHS0p5S3hTZUpxYnBwbWpFT1JiamFvc2hMV2NuaXM0Z2xBTzZaV1Zp?=
 =?utf-8?B?eEtuUnp1WVNvRTFsdTExQTVFbzVxWG0wNnFaa1V6bGJnZ0JOa0FNWWFGZndi?=
 =?utf-8?B?dDF4ZUlYYnMvTCtDWGl6RTFrOG1hSHBPaDFFMGl6UG84VTlpQzA0YWthRitF?=
 =?utf-8?B?M0U1Z2h6R1VmeFQ1ZmZ5RmtLczNxMjd4VWNCRmdOV3ZQMmpzbVlSVGdsSUFy?=
 =?utf-8?B?bzBOS08wbXZOaGl1Q3VXZmYzVFFtR2xSMjlUYmFZa291cGh6RWlHc2tYK0Z3?=
 =?utf-8?B?RnExRG1YMXVrNmNFcHdmejVxdUZMOStQTUFvYzlKUE0rOVhicDBRbTJHcTR1?=
 =?utf-8?B?QUZ1N3pMM25DTjJuMHAxblNHSm4vVFZrcVpVejd6NThCNTU5aGsxdEo4NEUw?=
 =?utf-8?B?QWM0SU05b0ZxOXBUaDRJTXhIN1BXTVN0aFNZMkw1SEErZ2hRMkRlUEJpdHJy?=
 =?utf-8?B?RWtYZTVoSHcxZ094dFMwUlB2ak5ZS1NvejFMUGE1QmZwcEEyMnM4SFczbEVw?=
 =?utf-8?B?VG1KUFlzMWRsTGJ3NzhaNVdQM0dmWTRKNWdSdDY0VlpOaGZzUzZwVDZRaWZB?=
 =?utf-8?B?cUJvb1IyaGtiZjFta1YyK3VJeFY3YWJVaWVlejRCWVlNZnhHUkhlOEJ0UzRV?=
 =?utf-8?B?MkVZb2FPMkorR3cwR1NQeFF0ditzektqZDBGMlpQZUVITmdZU2VnZGRjTVc2?=
 =?utf-8?B?cWljVWFFSTV3OXE3RlliNEpGdlkrNnZuTGdaMkppbkdOQTAwckxPaTh1WGhF?=
 =?utf-8?B?Qngxbys3YWVPQlJIVm5qRkkrRlJ1ZHpseWxTNlFFdEcvTFpBa0ZPUzVndUpV?=
 =?utf-8?B?U3pYSWtwRDZZVEZMdmt3TitseTE3bnU1K3FhSjRWWFJHQzMxQWxOMThGMW5L?=
 =?utf-8?B?S1RPdjVsOTlsNTM5NVBJVy9VcTFTdHpqYVpuNHBralJ3UDJEc244djU2Qis1?=
 =?utf-8?B?T2dCcytmS0hrSUtmVGFVeXBYZUY5YnBSWEhTSjcyT0JrVkxlMDVFQU9SbEdZ?=
 =?utf-8?B?UkFPNmhRdmFxUERDb3BOeUhoYzVWYkxDeWNwOGZEd2htVTd2c1l4K1VzMTZy?=
 =?utf-8?B?RTREcGNHRGVOVFlvV21mZ1kyMVJHMHhNNzdGS1NnUVZ1OXZnVTRXN294TjBj?=
 =?utf-8?B?Q1FNWElEWGlTc0pnUjlqWVJRT09FMVJvYWhkeWZDVVBnbmNySHE2R2ZiSkI3?=
 =?utf-8?B?YzZ6ZTkrbTJkaDB5Z20vRVlSUFJlR1lwT3EzYkEzTjV6dWNvVVVYYTFydlZK?=
 =?utf-8?B?a3UvV25iVk5xS3FHRDFwMzJ1VnpDRTJhU0RVc3M4K1ZQRlVOeUlxTGhxMXho?=
 =?utf-8?B?SVV1dWVranFpQ2Y2cEtyZ01HblFpMGRObjhqM2lWcWFQM2xSaGQzUEp6QzdQ?=
 =?utf-8?B?SUxvSTlJMFR2TEpUQWVDVmk0d3FJZFduaG1DdFFGczdleE9PUSs4ZExBVUdo?=
 =?utf-8?B?bWlHZEkzdWI4aWlKM3E2b0pLVFg1UjNsWjRnS0g1WC85WTEyUm9RcE05TkhQ?=
 =?utf-8?B?U0UrQ2JOVUZ5ZmlLUkxiempqYWJ6cDg5RkhHeUM2Z2l2ekZMa1lhQWtlMG4v?=
 =?utf-8?B?OHVkU2dYQkNyNGduTXV2dHNxaTZVaWJyelpoaHpnTGNsSEFrTmN1eTJFZXFk?=
 =?utf-8?B?UHpBaDZqYlQrS2ZseXdxQys4WnJraUczV3Z3UlUzNWdsMG9UdWNQdklRdzJQ?=
 =?utf-8?B?clFTck9qZXpVSTZML2ZGMWJ0U2dKNHhuNjVLQ0N6aFJuVVNIU0tOcnJPMmVP?=
 =?utf-8?B?UWdEYTFuUkExN0IxNVZ2Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D7EAFD4CE2369344805B6F5B57F2B4F8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ec85927-05c6-4d91-465f-08d972d0b083
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 13:58:08.8493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a36prcgz9For3b617kn1A31Baiad1v6rt3CR5wZltCfHLleEosFeg+/MzsowINkXqlT/9yY/zJfqLNng42+9LELD+kXwl8LUq3ogMYh48gg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2830
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10100 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109080089
X-Proofpoint-GUID: EN8TX_m4CfZWdiOWjwsWIlIZcBz14OJb
X-Proofpoint-ORIG-GUID: EN8TX_m4CfZWdiOWjwsWIlIZcBz14OJb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gU2VwIDgsIDIwMjEsIGF0IDI6MjggQU0sIE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlA
bWFydmVsbC5jb20+IHdyb3RlOg0KPiANCj4gRnJvbTogQXJ1biBFYXNpIDxhZWFzaUBtYXJ2ZWxs
LmNvbT4NCj4gDQo+IFN5c3RlbSBjcmFzaCB3YXMgc2VlbiB3aGVuIEkvTyB3YXMgcnVuIGFnYWlu
c3QgYSBOVk1FIHRhcmdldCBhbmQgd2hlbiBJL08NCj4gYWJvcnRzIHdlcmUgb2NjdXJyaW5nLg0K
PiANCj4gQ3Jhc2ggc3RhY2sgaXM6DQo+IA0KPiAgICAtLSByZWxldmFudCBjcmFzaCBzdGFjayAt
LQ0KPiAgICBCVUc6IGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UsIGFkZHJlc3M6IDAw
MDAwMDAwMDAwMDAwMTANCj4gICAgOg0KPiAgICAjNiBbZmZmZmFlMWY4NjY2YmRkMF0gcGFnZV9m
YXVsdCBhdCBmZmZmZmZmZmE3NDAxMjJlDQo+ICAgICAgIFtleGNlcHRpb24gUklQOiBxbGFfbnZt
ZV9hYm9ydF93b3JrKzMzOV0NCj4gICAgICAgUklQOiBmZmZmZmZmZmMwZjU5MmUzICBSU1A6IGZm
ZmZhZTFmODY2NmJlODAgIFJGTEFHUzogMDAwMTAyOTcNCj4gICAgICAgUkFYOiAwMDAwMDAwMDAw
MDAwMDAwICBSQlg6IGZmZmY5YjU4MWZjOGFmODAgIFJDWDogZmZmZmZmZmZjMGY4M2JkMA0KPiAg
ICAgICBSRFg6IDAwMDAwMDAwMDAwMDAwMDEgIFJTSTogZmZmZjliNTgzOWM2YzdjOCAgUkRJOiAw
MDAwMDAwMDA4MDAwMDAwDQo+ICAgICAgIFJCUDogZmZmZjliNjgzMmY4NTAwMCAgIFI4OiBmZmZm
ZmZmZmMwZjY4MTYwICAgUjk6IGZmZmZmZmZmYzBmNzA2NTINCj4gICAgICAgUjEwOiBmZmZmYWUx
Zjg2MmZmZGM4ICBSMTE6IDAwMDAwMDAwMDAwMDAzMDAgIFIxMjogMDAwMDAwMDAwMDAwMDEwZA0K
PiAgICAgICBSMTM6IDAwMDAwMDAwMDAwMDAwMDAgIFIxNDogZmZmZjliNTgzOWNlYTAwMCAgUjE1
OiAwZmZmZjliNTgzZmFiMTcwDQo+ICAgICAgIE9SSUdfUkFYOiBmZmZmZmZmZmZmZmZmZmZmICAg
Q1M6IDAwMTAgIFNTOiAwMDE4DQo+ICAgICM3IFtmZmZmYWUxZjg2NjZiZTk4XSBwcm9jZXNzX29u
ZV93b3JrIGF0IGZmZmZmZmZmYTZhYmExODQNCj4gICAgIzggW2ZmZmZhZTFmODY2NmJlZDhdIHdv
cmtlcl90aHJlYWQgYXQgZmZmZmZmZmZhNmFiYTM5ZA0KPiAgICAjOSBbZmZmZmFlMWY4NjY2YmYx
MF0ga3RocmVhZCBhdCBmZmZmZmZmZmE2YWMwNmVkDQo+IA0KPiBUaGUgY3Jhc2ggd2FzIGR1ZSB0
byBhIHN0YWxlIFNSQiBzdHJ1Y3R1cmUgYWNjZXNzIGFmdGVyIGl0IHdhcyBhYm9ydGVkLg0KPiBG
aXhlZCB0aGUgaXNzdWUgYnkgcmVtb3Zpbmcgc3RhbGUgYWNjZXNzLg0KPiANCg0KQWRkIGZvbGxv
d2luZyANCg0KRml4ZXM6IDJjYWJmMTBkYmJlMzggKOKAnHNjc2k6IHFsYTJ4eHg6IEZpeCBoYW5n
IG9uIE5WTWUgY29tbWFuZCB0aW1lb3V0cyDigJ0pDQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9y
Zw0KDQo+IFNpZ25lZC1vZmYtYnk6IEFydW4gRWFzaSA8YWVhc2lAbWFydmVsbC5jb20+DQo+IFNp
Z25lZC1vZmYtYnk6IE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlAbWFydmVsbC5jb20+DQo+IC0tLQ0K
PiBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfbnZtZS5jIHwgMTQgKysrKysrKysrKysrLS0NCj4g
MSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX252bWUuYyBiL2RyaXZlcnMvc2Nz
aS9xbGEyeHh4L3FsYV9udm1lLmMNCj4gaW5kZXggMWM1ZGEyZGJkNmY5Li44NzdiMmI2MjUwMjAg
MTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9udm1lLmMNCj4gKysrIGIv
ZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX252bWUuYw0KPiBAQCAtMjI4LDYgKzIyOCw4IEBAIHN0
YXRpYyB2b2lkIHFsYV9udm1lX2Fib3J0X3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0K
PiAJZmNfcG9ydF90ICpmY3BvcnQgPSBzcC0+ZmNwb3J0Ow0KPiAJc3RydWN0IHFsYV9od19kYXRh
ICpoYSA9IGZjcG9ydC0+dmhhLT5odzsNCj4gCWludCBydmFsLCBhYnRzX2RvbmVfY2FsbGVkID0g
MTsNCj4gKwlib29sIGlvX3dhaXRfZm9yX2Fib3J0X2RvbmU7DQo+ICsJdWludDMyX3QgaGFuZGxl
Ow0KPiANCj4gCXFsX2RiZyhxbF9kYmdfaW8sIGZjcG9ydC0+dmhhLCAweGZmZmYsDQo+IAkgICAg
ICAgIiVzIGNhbGxlZCBmb3Igc3A9JXAsIGhuZGw9JXggb24gZmNwb3J0PSVwIGRlc2M9JXAgZGVs
ZXRlZD0lZFxuIiwNCj4gQEAgLTI0NCwxMiArMjQ2LDIwIEBAIHN0YXRpYyB2b2lkIHFsYV9udm1l
X2Fib3J0X3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KPiAJCWdvdG8gb3V0Ow0KPiAJ
fQ0KPiANCj4gKwkvKg0KPiArCSAqIHNwIG1heSBub3QgYmUgdmFsaWQgYWZ0ZXIgYWJvcnRfY29t
bWFuZCBpZiByZXR1cm4gY29kZSBpcyBlaXRoZXINCj4gKwkgKiBTVUNDRVNTIG9yIEVSUl9GUk9N
X0ZXIGNvZGVzLCBzbyBjYWNoZSB0aGUgdmFsdWUgaGVyZS4NCj4gKwkgKi8NCj4gKwlpb193YWl0
X2Zvcl9hYm9ydF9kb25lID0gcWwyeGFidHNfd2FpdF9udm1lICYmDQo+ICsJCQkJCVFMQV9BQlRT
X1dBSVRfRU5BQkxFRChzcCk7DQo+ICsJaGFuZGxlID0gc3AtPmhhbmRsZTsNCj4gKw0KPiAJcnZh
bCA9IGhhLT5pc3Bfb3BzLT5hYm9ydF9jb21tYW5kKHNwKTsNCj4gDQo+IAlxbF9kYmcocWxfZGJn
X2lvLCBmY3BvcnQtPnZoYSwgMHgyMTJiLA0KPiAJICAgICIlczogJXMgY29tbWFuZCBmb3Igc3A9
JXAsIGhhbmRsZT0leCBvbiBmY3BvcnQ9JXAgcnZhbD0leFxuIiwNCj4gCSAgICBfX2Z1bmNfXywg
KHJ2YWwgIT0gUUxBX1NVQ0NFU1MpID8gIkZhaWxlZCB0byBhYm9ydCIgOiAiQWJvcnRlZCIsDQo+
IC0JICAgIHNwLCBzcC0+aGFuZGxlLCBmY3BvcnQsIHJ2YWwpOw0KPiArCSAgICBzcCwgaGFuZGxl
LCBmY3BvcnQsIHJ2YWwpOw0KPiANCj4gCS8qDQo+IAkgKiBJZiBhc3luYyB0bWYgaXMgZW5hYmxl
ZCwgdGhlIGFib3J0IGNhbGxiYWNrIGlzIGNhbGxlZCBvbmx5IG9uDQo+IEBAIC0yNjQsNyArMjc0
LDcgQEAgc3RhdGljIHZvaWQgcWxhX252bWVfYWJvcnRfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3Qg
KndvcmspDQo+IAkgKiBhcmUgd2FpdGVkIHVudGlsIEFCVFMgY29tcGxldGUuIFRoaXMga3JlZiBp
cyBkZWNyZWFzZWQNCj4gCSAqIGF0IHFsYTI0eHhfYWJvcnRfc3BfZG9uZSBmdW5jdGlvbi4NCj4g
CSAqLw0KPiAtCWlmIChhYnRzX2RvbmVfY2FsbGVkICYmIHFsMnhhYnRzX3dhaXRfbnZtZSAmJiBR
TEFfQUJUU19XQUlUX0VOQUJMRUQoc3ApKQ0KPiArCWlmIChhYnRzX2RvbmVfY2FsbGVkICYmIGlv
X3dhaXRfZm9yX2Fib3J0X2RvbmUpDQo+IAkJcmV0dXJuOw0KPiBvdXQ6DQo+IAkvKiBrcmVmX2dl
dCB3YXMgZG9uZSBiZWZvcmUgd29yayB3YXMgc2NoZWR1bGUuICovDQo+IC0tIA0KPiAyLjE5LjAu
cmMwDQo+IA0KDQpPdGhlcndpc2UNCg0KUmV2aWV3ZWQtYnk6IEhpbWFuc2h1IE1hZGhhbmkgPGhp
bWFuc2h1Lm1hZGhhbmlAb3JhY2xlLmNvbT4NCg0KLS0NCkhpbWFuc2h1IE1hZGhhbmkJIE9yYWNs
ZSBMaW51eCBFbmdpbmVlcmluZw0KDQo=
