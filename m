Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12BD2C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F302F6105A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242788AbhHEP5P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 11:57:15 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:23020 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242751AbhHEP5E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 11:57:04 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175FuGxK031605;
        Thu, 5 Aug 2021 15:56:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=BY9qci5V8rnL9DsmYFrE4rwZGVgbBSmSdV0HZO+Bsvk=;
 b=PFrzR1I5zjhnvciK79gBulO57gHp/q/9lBoECBIQL/uakIB5pI5o0bCfqVwTlXV/n+D8
 wEks5eJ0LLNZdvswav28DN0AZ5vGQHqQP1uqf14L4gu842cVPTL5aAO8Ywyz8JDLAzcH
 chcM1aeqLgu0pYhgBCXQMf9J8iyxjASKAj+IR83lGCLcOKpLUkSxAzROkYyoSll+Pnl2
 zbtItQOzfYvYrOfWwY2Hd7L252E5ozoP3/3jS0LCTYEGA/II+VI4/tfSDJiMD7cxwxUv
 Z3n8oRMjzsH/jAQLCS/Fyo8wszhs5fp65IbkI6WBe9tF+KMmgUSVMVspWJQ9dzzt+uhq 4w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=BY9qci5V8rnL9DsmYFrE4rwZGVgbBSmSdV0HZO+Bsvk=;
 b=nMlf2MStS1BW4Zdobz/UNQRWHsE/OwI2K3BvIYowFjV5lsP5Ilyyk+/BkM3owX2wF938
 01vQO8cfiF4d1v4h+hfQXsQYT3BjOyfV4QmApekP+a/u1Z0HcHtkykEWJ8ctYoopjttg
 h2+xnfDd5mimYlS29UauoXhtCfldNVnXGDrErdNowbQhr2xo4yTbA2SnSvyYk7Ax7VrW
 Plbvq0AiuxLZZ4W7jfhcCbYH2jtjOQJGzcxQ+bHSM64iVZlAgpRfg0xu9CgcnPQRHDXL
 kUDE6GUJrX1PtaCp2mgxAUkE6261dljgdXUvruRJ/1y+E2BjLjwPVkCJT1FTPBE6NXII Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a843p9tsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:56:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 175Ftalh058013;
        Thu, 5 Aug 2021 15:56:46 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2042.outbound.protection.outlook.com [104.47.74.42])
        by userp3030.oracle.com with ESMTP id 3a4un40tgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:56:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WWcFxl9dCM0nG+w5RvEYMuHFEia/Yiqtb4c4H6ccL1AiSkJN7Yeg5ch12iLrYXc7tp2t5jTjLCIBe4fW3iA4X5cHo/Q5NDC4xUa6phxR5CwMXdU0mVfyZvd1d6uvqgq2fdITFp6S4MvnX8BLXsXWbdY5jqZ/d498Asyh6WF/mgu3UpdEfH35WJ2byE23OZDd9nUb5E1mQTLhrJcZUuyONPketRYjaYxF1McCuRiVmRa+nz9py8zA40xg7qU2csqBN15QTzKIrv6J288Xh8jgnO/QAgfB8pq9hmDgkuAdAF1bC4MgbiRFfxUvT6fXfjwEYgQ8Ta57rNGXF4M0EPX/wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BY9qci5V8rnL9DsmYFrE4rwZGVgbBSmSdV0HZO+Bsvk=;
 b=EogN7soTc2ItfohVcyO4eOTgv5KVb0AvtDLq/CZoLlh8JNjXN3T3KzlrbFUqVFZDD9+2h7Wnjz1yG9hrHj+JAiR4pTRqP7d7E2DjIRZ7cKhFyzAYacpHK9q+wJQzjviRJEjfktTDKn5VQqpJgrQ18KjGGtguTP1MDs0mU6zs4PhVhBENbfo26OuMMklQSpk8HDfaEsdR/Qytqw7UYb2VjOllVJMuItctlwwLOsHboziXSc8sZYYqE1adv3I6FINv9m5Nyv3fm53F/zesUPqPQjklfBuwEzsmPlnY9pghVJpFG3X+6GHdye4QrofrUlQ+EobrXYElEBlQ0xz7CoS/vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BY9qci5V8rnL9DsmYFrE4rwZGVgbBSmSdV0HZO+Bsvk=;
 b=nPa2yDT9ve+yjrraep8lPx3GBLLCDGOitJAQfDBB08OTk0ZEqWAmy998STTiQwM0r2OLCkG8VuFYEILF7Zuc7UB6sqXCnai6dgsPksYVn8LI135RIhrcaWww9eVyJhYwLSUyXpvv7Jm+cUDJNJXH6DPHjaR2XSrWrGBBqNfzXzk=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB3023.namprd10.prod.outlook.com (2603:10b6:805:d2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Thu, 5 Aug
 2021 15:56:45 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43%5]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 15:56:45 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 13/14] qla2xxx: Sync queue idx with queue_pair_map idx
Thread-Topic: [PATCH 13/14] qla2xxx: Sync queue idx with queue_pair_map idx
Thread-Index: AQHXieRETvT75Na9ZEapau15kEP6cqtlETEA
Date:   Thu, 5 Aug 2021 15:56:45 +0000
Message-ID: <558CC233-58F9-418E-94CF-440F622CA5DD@oracle.com>
References: <20210805102005.20183-1-njavali@marvell.com>
 <20210805102005.20183-14-njavali@marvell.com>
In-Reply-To: <20210805102005.20183-14-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1726bfab-5d47-45de-6e4a-08d958299ff8
x-ms-traffictypediagnostic: SN6PR10MB3023:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB30237C4699DB91D5F9C86275E6F29@SN6PR10MB3023.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IoZnOEajzPE+D83OlLjiFdngScZY+Oz2CzfUhSMdf46qiPptfvXdrmRuD1nEijHUZh+QNK885Iq1GWNnQ7JhgdpYA4eJ/Zt5l9+mv5cSglq8S5EoVTIIuL5WFXxiq6bEfNCnczOLPRIz1mHIqnd6NZK9qspa9IYZXYKa+cPV0ebeFyJ8BpkGhjtrk5qol5cu3doOpVmabPDP1/3vUjIBFJ1g1KTI6pNBrjBTFzqHgxmYwmuoxx5P3+H+ctxwErrvLY8QkJ4KOBCLhCpdKrXLtyPYmdy6CnT3aThQkVCesp979OygBcK1w2/r6OmT5/3VidI9FabUXAeYooG2YRhw9WhFDaTmOQH/DkePIDQSaB4QIrWWRwVVXPUe0kdYNxxen9zH225K50LjSeKyJGptIBM0cYwLehgq2y5uxTrlAe6yoUeRAbvl/GQOcpENEk5zeWA0pjNfi6za9zKy5U4g+77Tup53pL/RqyqhaQ9uG6h8ItCzxRPhsa/YMTj+6GFDh2fEKe9vSRsJw8onNqnPYitJMI+pcEsM3W0hA/i/Q/SkNmIbJyffpNc52bsYMdKG6DGjTNnxGvQ5Ebi5F6sff60xRbIa4KnUxPzcORxPkNpEwwmDv0Wrg03XxDJwloah1uEe1HxIdxfRvjrQ9UR5IX2gpO4kIcigrNU6VAG91WKm1Sj/dO/Pn5epUlXd7of+g9OZ3VRS+F3wOwE3V5iyd+pgUG9bkOhQQCJ/EHhKHDbGuxcSeztZYPFKzAdRmNRL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(136003)(366004)(376002)(396003)(33656002)(54906003)(71200400001)(5660300002)(6512007)(2906002)(478600001)(4326008)(76116006)(44832011)(53546011)(38100700002)(316002)(6916009)(122000001)(6506007)(66476007)(66556008)(64756008)(66446008)(66946007)(26005)(83380400001)(36756003)(8936002)(2616005)(186003)(8676002)(38070700005)(6486002)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2IyZnR1T0JkUzEwdEZRUlB4eXp1UUs4Tk1Ndy9TeVJyTVFMNnNaanRkQ2VX?=
 =?utf-8?B?QnErNlJ6LzE0eXUxWXNmYnM5a3BjNHU5aXRMbWtXUWNqSkNLNTNMc2x2MVFq?=
 =?utf-8?B?WncweURDdGtheE9OYk9zYmUxNEd5ZHFGbFlwWHBNZXN4TGNwSldLcGxab0tp?=
 =?utf-8?B?TkhQNU0wYjdsNEthQ3JCb0J5Sno0VFQwQ2Vha3pRYXBvb0swSnc5U2tYNjZJ?=
 =?utf-8?B?bzVUTWlJTUZmcC9VN1RweDJQVDRRN2t0bjBBcS82emhxSXdwVjJyUWRZUnll?=
 =?utf-8?B?QzNER3lvSFgxV3NnU3J6V0JNQ3Z5NmVuUmFVMXd0MFpqZEVNY3hQNFc3clRi?=
 =?utf-8?B?WTRYSVRNUXdMaVBKK2h2MmVLNkhLaWdya0xweGkvNFFzalNGZmNsS3h1WEJk?=
 =?utf-8?B?VXVCTDRKelc3U0tvT3lxdjFaYTNCemZ0UUpzcUwrcGNJWUFqT2UvU3dBUEFO?=
 =?utf-8?B?QTdkV2E1UEd5ZnVXODJXVW55ekFHdlZoZ2ZwSWoveVpYK1o0Rk9Wc3B4UXlK?=
 =?utf-8?B?dFJqd21ScWM3WU9zQnIydEpDVGRobnFkNHVNejNDRmpqR1F1N1Q3bmI3cm1O?=
 =?utf-8?B?RDJjQXBBc2RncGExQ1BwRGNYanliVlJKNFhqZU1VOVNVakpyWEJoaW1FL0V6?=
 =?utf-8?B?c1BqbnozbE9VUmt2NEcwT1JmN09pcllEcjNwdGhyQnhNemp0K1YyVFdUMkZX?=
 =?utf-8?B?SXR4UnJLdXBSdE5ET0xtNThIazhrSGhrcXhGRzVWdnZ0OVo4UnA5cWJSOE92?=
 =?utf-8?B?dlhmVmxjVlRvWDR1dGU5bFFzQVlXUk0xYmllOVBmTlkzR0VwekRyWlVaWFFl?=
 =?utf-8?B?eWVvZ3M3ZmNGWGkyc080MnV0ZlQreUpmRllQTWhuMFlVTmxSYWZzV3prZlJF?=
 =?utf-8?B?THd0T1dwbkU3ZXhmVVV5MUdPV1lYM3RaelZhN25IRFg4bmlxZ1Q1WFVnSk1y?=
 =?utf-8?B?TkN3eGlUZFZzMVp0d0ZVK0x6ZFJ3bElvbGlTY0pVUG9UWDlremo0V1FzWU80?=
 =?utf-8?B?ZkxDSHJoZ2h0SCtmMjlBRmdHNE9WcFFoTTkyWXEydW9lY1ZzbjFvem5tWFJN?=
 =?utf-8?B?bjJCUE4xNFZYSWdHUGRNM2pyMFMxQ2t3Y2lPZ2RLWXdaTDJGdVdWWlF0N3pE?=
 =?utf-8?B?K2tDeDlkUGFFV1hYalZZZHFEMC9FdzZxd1U4eFZZc1RpVFRKOWFlOE01Q2VR?=
 =?utf-8?B?blM3cDR5czdZc1lYaVlFbUxWOStHM3BDaFY0c3MwRUpFbmd6dDVkSC9oaG5x?=
 =?utf-8?B?TUtsME96YWJwU1ZsczN5Uis0bGVNcjJ1b1VOQjZqYit3dWtRaGorN1ZtVkQv?=
 =?utf-8?B?RVYrMzdmaEpJNld3dTlzSkRpVXVYM1U2b1EwZnFSUnJheUdrNlJ3Mmhjb05p?=
 =?utf-8?B?YTV5QjZVZjJLaWtvT0owZjhpZHpCRmZhcnBCanZnRnhJWjU5SGlqUnlSOWpx?=
 =?utf-8?B?eHdNcDVueFhuUnNsbUhEV0lUcjIrWER3QlJsZVFhRjAvWUJoQXRwMExhOENt?=
 =?utf-8?B?VjFIUFgwckZNV0VPR3dhS3lOd0xocmd1MG5EbXlyQndPak1DNTZjZGtPQXVU?=
 =?utf-8?B?WmVEU1ZGaGFvSktMOGVhMjl3TXlnME9rWlQyVW0wKzREcUo4Z2lnaTR0ZmtF?=
 =?utf-8?B?RDVEZzIzODl4TCtpNE5Id2p4OGVOTUlFRHlsMFBTT0NOOGZxdjRNVDRCbmdI?=
 =?utf-8?B?WVpMd2VpZ2M1Y3hHUS9YdWVCd2lkVFY2UVRqVUlveXlLWnZYVkZidGVwc2Rt?=
 =?utf-8?B?MmdhRDJrbHplR0UxK1Ewa1ZZNWpycE1kN1RSeTNNd3dSTjAyUkJXdmJvT1F5?=
 =?utf-8?B?elpnanVNRURieTNiZ2w4Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <854F1E38612F8C44ABC035D55DB3381D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1726bfab-5d47-45de-6e4a-08d958299ff8
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 15:56:45.0067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LmE5k2959jQ0/XHkCMgiLmWLWcDPitl2EFDNtrLH1nRO7xO2+CkoR58pMbH8EfKFlS9wzyASO/jalpr3jWM3K2lTzCIpXjns5l4bj8WHvDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3023
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108050097
X-Proofpoint-ORIG-GUID: 3w5zOw5tfXFrH08aOiXGg72kSpzksVJl
X-Proofpoint-GUID: 3w5zOw5tfXFrH08aOiXGg72kSpzksVJl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gQXVnIDUsIDIwMjEsIGF0IDU6MjAgQU0sIE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlA
bWFydmVsbC5jb20+IHdyb3RlOg0KPiANCj4gRnJvbTogU2F1cmF2IEthc2h5YXAgPHNrYXNoeWFw
QG1hcnZlbGwuY29tPg0KPiANCj4gVGhlIGZpcnN0IGludm9jYXRpb24gb2YgZnVuY3Rpb24gZmlu
ZF9maXJzdF96ZXJvX2JpdCB3aWxsIHJldHVybiAwIGFuZA0KPiBxdWV1ZV9pZCBnZXRzIHNldCB0
byAwLg0KPiBBbiBpbmRleCBvZiBxdWV1ZV9wYWlyX21hcCBhbHNvIGdldCBzZXRzIHRvIDAuDQo+
IA0KPiAJcXBhaXJfaWQgPSBmaW5kX2ZpcnN0X3plcm9fYml0KGhhLT5xcGFpcl9xaWRfbWFwLCBo
YS0+bWF4X3FwYWlycyk7DQo+IA0KPiAgICAgICAgc2V0X2JpdChxcGFpcl9pZCwgaGEtPnFwYWly
X3FpZF9tYXApOw0KPiAgICAgICAgaGEtPnF1ZXVlX3BhaXJfbWFwW3FwYWlyX2lkXSA9IHFwYWly
Ow0KPiANCj4gSW4gdGhlIGFsbG9jX3F1ZXVlIGNhbGxiYWNrIGRyaXZlciBjaGVja3MgdGhlIG1h
cCwgaWYgcXVldWUgaXMgYWxyZWFkeQ0KPiBhbGxvY2F0ZWQuDQo+IAloYS0+cXVldWVfcGFpcl9t
YXBbcWlkeF0NCj4gDQo+IFRoaXMgd29ya3MgZmluZSBhcyBsb25nIGFzIG1heF9xcGFpcnMgaXMg
Z3JlYXRlciB0aGFuIG52bWVfbWF4X2h3X3F1ZXVlcyg4KS4NCj4gU2luY2UgdGhlIHNpemUgb2Yg
dGhlIHF1ZXVlX3BhaXJfbWFwIGlzIGVxdWFsIHRvIG1heF9xcGFpci4gSW4gY2FzZSwgbnJfY3B1
cw0KPiBpcyBsZXNzIHRoYW4gOCwgbWF4X3FwYWlycyB2YWx1ZXMgZ29lcyBsZXNzIHRoYW4gOCwg
dGhpcyBjcmVhdGVzIHdyb25nIHZhbHVlDQo+IHJldHVybnMgYXMgcXBhaXIuDQo+IA0KPiBbIDE1
NzIuMzUzNjY5XSBxbGEyeHh4IFswMDAwOjI0OjAwLjNdLTIxMjE6NjogUmV0dXJuaW5nIGV4aXN0
aW5nIHFwYWlyIG9mIDRlMDAwMDAwMDAwMDAwMDAgZm9yIGlkeD0yDQo+IFsgMTU3Mi4zNTQ0NThd
IGdlbmVyYWwgcHJvdGVjdGlvbiBmYXVsdDogMDAwMCBbIzFdIFNNUCBQVEkNCj4gWyAxNTcyLjM1
NDQ2MV0gQ1BVOiAxIFBJRDogNDQgQ29tbToga3dvcmtlci8xOjFIIEtkdW1wOiBsb2FkZWQgVGFp
bnRlZDogRyAgICAgICAgICBJT0UgICAgLS0tLS0tLS0tIC0gIC0gNC4xOC4wLTMwNC5lbDgueDg2
XzY0ICMxDQo+IFsgMTU3Mi4zNTQ0NjJdIEhhcmR3YXJlIG5hbWU6IEhQIFByb0xpYW50IERMMzgw
cCBHZW44LCBCSU9TIFA3MCAwMy8wMS8yMDEzDQo+IFsgMTU3Mi4zNTQ0NjddIFdvcmtxdWV1ZTog
a2Jsb2NrZCBibGtfbXFfcnVuX3dvcmtfZm4NCj4gWyAxNTcyLjM1NDQ4NV0gUklQOiAwMDEwOnFs
YV9udm1lX3Bvc3RfY21kKzB4OTIvMHg3NjAgW3FsYTJ4eHhdDQo+IFsgMTU3Mi4zNTQ0ODZdIENv
ZGU6IDg0IDI0IDVjIDAxIDAwIDAwIDAwIDAwIGI4IDBhIDc0IDFlIDY2IDgzIDc5IDQ4IDAwIDBm
IDg1IGE4IDAzIDAwIDAwIDQ4IDhiIDQ0IDI0IDA4IDQ4IDg5IGVlIDRjIDg5IGU3IDhiIDUwIDI0
IGU4IDVlIDhlIDAwIDAwIDxmMD4gNDEgZmYgNDcgMDQgMGYgYWUgZjAgNDEgZjYgNDcgMjQgMDQg
NzQgMTkgZjAgNDEgZmYgNGYgMDQgYjggZjANCj4gWyAxNTcyLjM1NDQ4N10gUlNQOiAwMDE4OmZm
ZmY5YzgxYzY0NWZjOTAgRUZMQUdTOiAwMDAxMDI0Ng0KPiBbIDE1NzIuMzU0NDg5XSBSQVg6IDAw
MDAwMDAwMDAwMDAwMDEgUkJYOiBmZmZmOGVhM2U1MDcwMTM4IFJDWDogMDAwMDAwMDAwMDAwMDAw
MQ0KPiBbIDE1NzIuMzU0NDkwXSBSRFg6IDAwMDAwMDAwMDAwMDAwMDEgUlNJOiAwMDAwMDAwMDAw
MDAwMDAxIFJESTogZmZmZjhlYTRjODY2YjgwMA0KPiBbIDE1NzIuMzU0NDkxXSBSQlA6IGZmZmY4
ZWE0Yzg2NmI4MDAgUjA4OiAwMDAwMDAwMDAwMDA1MDEwIFIwOTogZmZmZjhlYTRjODY2YjgwMA0K
PiBbIDE1NzIuMzU0NDkyXSBSMTA6IDAwMDAwMDAwMDAwMDAwMDEgUjExOiAwMDAwMDAwNjlkMWNh
M2ZmIFIxMjogZmZmZjhlYTRiYzQ2MDAwMA0KPiBbIDE1NzIuMzU0NDkzXSBSMTM6IGZmZmY4ZWEz
ZTUwNzAyYjAgUjE0OiBmZmZmOGVhNGM0YzE2YTU4IFIxNTogNGUwMDAwMDAwMDAwMDAwMA0KPiBb
IDE1NzIuMzU0NDk0XSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZjhlYTRkZmQw
MDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwDQo+IFsgMTU3Mi4zNTQ0OTVdIENTOiAg
MDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMNCj4gWyAxNTcyLjM1
NDQ5Nl0gQ1IyOiAwMDAwNTU4ODQ1MDRmYTU4IENSMzogMDAwMDAwMDVhMTQxMDAwMSBDUjQ6IDAw
MDAwMDAwMDAwNjA2ZTANCj4gWyAxNTcyLjM1NDQ5N10gQ2FsbCBUcmFjZToNCj4gWyAxNTcyLjM1
NDUwM10gID8gY2hlY2tfcHJlZW1wdF9jdXJyKzB4NjIvMHg5MA0KPiBbIDE1NzIuMzU0NTA2XSAg
PyBkbWFfZGlyZWN0X21hcF9zZysweDcyLzB4MWYwDQo+IFsgMTU3Mi4zNTQ1MDldICA/IG52bWVf
ZmNfc3RhcnRfZmNwX29wLnBhcnQuMzIrMHgxNzUvMHg0NjAgW252bWVfZmNdDQo+IFsgMTU3Mi4z
NTQ1MTFdICA/IGJsa19tcV9kaXNwYXRjaF9ycV9saXN0KzB4MTFjLzB4NzMwDQo+IFsgMTU3Mi4z
NTQ1MTVdICA/IF9fc3dpdGNoX3RvX2FzbSsweDM1LzB4NzANCj4gWyAxNTcyLjM1NDUxNl0gID8g
X19zd2l0Y2hfdG9fYXNtKzB4NDEvMHg3MA0KPiBbIDE1NzIuMzU0NTE4XSAgPyBfX3N3aXRjaF90
b19hc20rMHgzNS8weDcwDQo+IFsgMTU3Mi4zNTQ1MTldICA/IF9fc3dpdGNoX3RvX2FzbSsweDQx
LzB4NzANCj4gWyAxNTcyLjM1NDUyMV0gID8gX19zd2l0Y2hfdG9fYXNtKzB4MzUvMHg3MA0KPiBb
IDE1NzIuMzU0NTIyXSAgPyBfX3N3aXRjaF90b19hc20rMHg0MS8weDcwDQo+IFsgMTU3Mi4zNTQ1
MjNdICA/IF9fc3dpdGNoX3RvX2FzbSsweDM1LzB4NzANCj4gWyAxNTcyLjM1NDUyNV0gID8gZW50
cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4YjkvMHhjYQ0KPiBbIDE1NzIuMzU0NTI3XSAg
PyBfX3N3aXRjaF90b19hc20rMHg0MS8weDcwDQo+IFsgMTU3Mi4zNTQ1MjldICA/IF9fYmxrX21x
X3NjaGVkX2Rpc3BhdGNoX3JlcXVlc3RzKzB4YzYvMHgxNzANCj4gWyAxNTcyLjM1NDUzMV0gID8g
YmxrX21xX3NjaGVkX2Rpc3BhdGNoX3JlcXVlc3RzKzB4MzAvMHg2MA0KPiBbIDE1NzIuMzU0NTMy
XSAgPyBfX2Jsa19tcV9ydW5faHdfcXVldWUrMHg1MS8weGQwDQo+IFsgMTU3Mi4zNTQ1MzVdICA/
IHByb2Nlc3Nfb25lX3dvcmsrMHgxYTcvMHgzNjANCj4gWyAxNTcyLjM1NDUzN10gID8gY3JlYXRl
X3dvcmtlcisweDFhMC8weDFhMA0KPiBbIDE1NzIuMzU0NTM4XSAgPyB3b3JrZXJfdGhyZWFkKzB4
MzAvMHgzOTANCj4gWyAxNTcyLjM1NDU0MF0gID8gY3JlYXRlX3dvcmtlcisweDFhMC8weDFhMA0K
PiBbIDE1NzIuMzU0NTQxXSAgPyBrdGhyZWFkKzB4MTE2LzB4MTMwDQo+IFsgMTU3Mi4zNTQ1NDNd
ICA/IGt0aHJlYWRfZmx1c2hfd29ya19mbisweDEwLzB4MTANCj4gWyAxNTcyLjM1NDU0NV0gID8g
cmV0X2Zyb21fZm9yaysweDM1LzB4NDANCj4gDQo+IEZpeCBpcyB0byB1c2UgaW5kZXggMCBmb3Ig
YWRtaW4gYW5kIGZpcnN0IElPIHF1ZXVlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2F1cmF2IEth
c2h5YXAgPHNrYXNoeWFwQG1hcnZlbGwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBOaWxlc2ggSmF2
YWxpIDxuamF2YWxpQG1hcnZlbGwuY29tPg0KPiAtLS0NCj4gZHJpdmVycy9zY3NpL3FsYTJ4eHgv
cWxhX252bWUuYyB8IDUgKysrLS0NCj4gMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9x
bGFfbnZtZS5jIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX252bWUuYw0KPiBpbmRleCA5NGUz
NTBlZjMwMjguLjA0Yjc2NmI4YTQ3MSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4
eHgvcWxhX252bWUuYw0KPiArKysgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfbnZtZS5jDQo+
IEBAIC05MSw4ICs5MSw5IEBAIHN0YXRpYyBpbnQgcWxhX252bWVfYWxsb2NfcXVldWUoc3RydWN0
IG52bWVfZmNfbG9jYWxfcG9ydCAqbHBvcnQsDQo+IAlzdHJ1Y3QgcWxhX2h3X2RhdGEgKmhhOw0K
PiAJc3RydWN0IHFsYV9xcGFpciAqcXBhaXI7DQo+IA0KPiAtCWlmICghcWlkeCkNCj4gLQkJcWlk
eCsrOw0KPiArCS8qIE1hcCBhZG1pbiBxdWV1ZSBhbmQgMXN0IElPIHF1ZXVlIHRvIGluZGV4IDAg
Ki8NCj4gKwlpZiAocWlkeCkNCj4gKwkJcWlkeC0tOw0KPiANCj4gCXZoYSA9IChzdHJ1Y3Qgc2Nz
aV9xbGFfaG9zdCAqKWxwb3J0LT5wcml2YXRlOw0KPiAJaGEgPSB2aGEtPmh3Ow0KPiAtLSANCj4g
Mi4xOS4wLnJjMA0KPiANCg0KSSB0aGluayB0aGlzIG5lZWRzIGZvbGxvd2luZw0KDQpGaXhlczog
ZTg0MDY3ZDc0MzAxMCAo4oCcc2NzaTogcWxhMnh4eDogQWRkIEZDLU5WTWUgRi9XIGluaXRpYWxp
emF0aW9uIGFuZCB0cmFuc3BvcnQgcmVnaXN0cmF0aW9u4oCdKQ0KDQpBbmQgQ2MgdG8gc3RhYmxl
Lg0KDQpPbmNlIHlvdSBhZGQgdGhvc2UsIHlvdSBjYW4gYWRkDQoNClJldmlld2VkLWJ5OiBIaW1h
bnNodSBNYWRoYW5pIDxoaW1hbnNodS5tYWRoYW5pQG9yYWNsZS5jb20+DQoNCi0tDQpIaW1hbnNo
dSBNYWRoYW5pCSBPcmFjbGUgTGludXggRW5naW5lZXJpbmcNCg0K
