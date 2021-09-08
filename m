Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E4CFC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 14:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 442F26113D
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 14:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348439AbhIHOJX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 10:09:23 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:18110 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235786AbhIHOJW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 10:09:22 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 188DTPQ8006013;
        Wed, 8 Sep 2021 14:08:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=oEILGZAh8/uK614vUPkPlE5e3QpuMo+lUoZvubyNYlU=;
 b=ZfcdZ8Mhc9X5d4KfPV/FWrwpyJ/dPSbHXbeiH7GSWsY0pcgbB7+/8I1vFZ/n8vC4jrWV
 aGB0/tbkWT6xzSQse9K9OeQe6aL7q5MdNHL7HlYCSHUOIluLT5+bTIPfVGOETWlbnkV4
 CrmG32/MnZxLDQPXcdXASZsNqYKoS9SdyLe6Cd50eQQ88MU1dTosEjnsYmHKRtHaYFvj
 hvOdLAitxrbv0jhqOjRXLXdDZsN7j+/xzX3Ste08RiM72GM3Qu1WicAnU+oqKlPgLSwA
 kZvZdU0v1ExLBkCwODcXEr2dfT4B4x9cfUuxzY21yPpt8bA80/X/lvmbLHbXyIXK5hDt LA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=oEILGZAh8/uK614vUPkPlE5e3QpuMo+lUoZvubyNYlU=;
 b=OMZj79Jw8S5mPQ0lIlj77qQ6gexl8AjrQvcdpGrNlvAAVDQYlrdoWf2MKsU0fMUFNweH
 +wfBex+1kttsiYmKYE0b9tYYG80FsNWOHcrbxvUo39m5uY2gGcrs27mPEh7bA6aKYwo4
 H8j4yAstD/YnezbcYuGJZ/3mMtRC52mZXhHZ0Xn0sZjRCYRI6XkXukIijNTE5FJ5OfLP
 Cz+cL1na+T3oDReTJ4WMmPQvksMmEFW3s/mP3OHaRjYWsL0Rdy20qLU55sU4bpxiYUVL
 dQSL3eFof279iGbFzE0yZXwyq6g5wGlnQUaXJEUhEmMKq8n7rvw2SywWc8AuepuYiG9U yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3axd8q2ukb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 14:08:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 188E0CcU078948;
        Wed, 8 Sep 2021 14:08:07 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by aserp3030.oracle.com with ESMTP id 3axcpnswj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 14:08:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WjR2yrk8X1gqiSOKIpi8gIVhz5FPKrV+w0YUuX8l9yeC13HkhDfvBViwPgbOGrTe1rjJC2yG2exKN14hN82lTU84623Qm8SuncEjLyu6rBIDgC3ZcKz5gWZ2Dx/AvyNBkL7Kszkjp+dUpiCIQdoFYUAO9PBLcJWu1EQbEL76XsEW3RXJP++1z1JrWZsF7E/ufH0DtpjdrBXY5Zt4LKSh8/s2SE6tnvcIo+i7kfHBIZZP0UMEshQlXiVzZTXoT/NM9wKRkmrjPI+KAF9TuRqgzSOCW2VoCGEMZIM6ZseZWjk3CD8UU545Xv9beHKcKMrRxf5H/YwRJ7vokMANUI1+ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=oEILGZAh8/uK614vUPkPlE5e3QpuMo+lUoZvubyNYlU=;
 b=VRYhoD4ftywtysBLAUWPNVMNWQ9KoK9tHXQPdzXEsjSXOi+Ez+GPr7KxW19vRXkTbFdzHddIDHtmDAGaRtTUAAIg1inSTexCxT6eh/QinWsf2Jds5BbkfSzkIFTPS0fVUVmZb76VO0TPqI0XRbCvX+jcFbEFDusjP3RRAlx3Lx3rX5e4RpNhPfgDMAjDjict1igPV1c9+PP8qkigHpq1nx4KNc1yHmX3dzp2ntSh8EWthoSyxRdkwBxRLUd7eDPEUqtj5eXm1QOGM/RxQDxqdwgIrv6TcTjqw1Dqdzq1YPpW+kda9HrC0elAOuPwaTCJt2TFczmcg9FwKZd0z6ORkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oEILGZAh8/uK614vUPkPlE5e3QpuMo+lUoZvubyNYlU=;
 b=mLpEXSvt3g+emJjVkelQrkjk86KID2v9MYFrjMpj9Hkr3uGiLWxLnbiEtSl0LK1yOr9RlsimnDZaGa8QpC7QnIL041t5h0Ql4D/S1qAz6HYqylQZI5av0qvH59JfnuDvwkuUEvFKh2o2z83HbFmujiZSCBmBJbrl8rAEmW/IDMI=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4601.namprd10.prod.outlook.com (2603:10b6:806:f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Wed, 8 Sep
 2021 14:08:06 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::38df:8fa2:1602:2dfe]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::38df:8fa2:1602:2dfe%3]) with mapi id 15.20.4500.015; Wed, 8 Sep 2021
 14:08:06 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "djeffery@redhat.com" <djeffery@redhat.com>,
        "loberman@redhat.com" <loberman@redhat.com>
Subject: Re: [PATCH 07/10] qla2xxx: Call process_response_queue() in Tx path
Thread-Topic: [PATCH 07/10] qla2xxx: Call process_response_queue() in Tx path
Thread-Index: AQHXpIN4X43xA5/HCkiIR0+Uu1YNzauaLNuA
Date:   Wed, 8 Sep 2021 14:08:06 +0000
Message-ID: <9150DF21-3603-4178-B0D2-9442A39F53BD@oracle.com>
References: <20210908072846.10011-1-njavali@marvell.com>
 <20210908072846.10011-8-njavali@marvell.com>
In-Reply-To: <20210908072846.10011-8-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ead2dae-ba40-4a52-fd8c-08d972d21486
x-ms-traffictypediagnostic: SA2PR10MB4601:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB46017DCF44E006C0695FDA1BE6D49@SA2PR10MB4601.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9/zHykpBJes9Mh4doVTyDDfX0ujQ+KqXebelT3KO3NrCtFV4i7Hnl6UOJcDO0ObSClk9VwGbvZrbg2i8ne9hyfIZCmySPJwPWINIaDBP+wbcbzKQOXKtro+u3/LmSmBrMesmE/0B4I50uKEGEhi4/ye8WEV6RkexDcQgY9gZkARNerKUXUOm0vWSKDqdWHqJ7D3HZY3QxyTFY9RRY6soyjk2iNwGAn0Xs4XL9yc13ezMyhBqhr/ugZJpxGwLv2iJZ8230sgB81ESY/+AzEqdSA+kbhNphLW7+qzFUlWOz440R4L/PYnND4+3C7BE+JzGlW0Vc8E/eUlvp8IMcEcEZn5FKTgy1spPX1gPN2B55B56SgdZRuOo/BwPl3BX5J9lTDL8F7QzCWXpZTBm1tEogthHCtWZbyJiJp3Mv5PvfXVyvIkg3R7hALul3/PvxrPKyKHV5lsUwXedW9PPpoWhS4NcPyDSGMehvzWn6okOq85yjkXj535p5pSG9n9YyTWZVhl0OwSqMvwxH0rO6H3q+oq7AkPLKR2Y7IWuaXDhMwjNElTGRoch426sD+DD4aZzpsYoK1qdWvlYwOFNypswB0ZXZK477ujAERBD0U9Ka5OGk+SwXtX5kjPFfYVw/GNNmKFIVCqd8qupfrNV6c2nYd3Vvf96ba8hglddGLido6T7FrsjKFdXLrI9pPe5JMhv78osciea0HZ1XS/c5EHcFFEvR5YOkWCOjv8nRHP+yZiWfew1cTfHb3SZpUdM1j2G
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(39860400002)(366004)(346002)(396003)(66446008)(44832011)(76116006)(6916009)(53546011)(6506007)(186003)(36756003)(38070700005)(316002)(38100700002)(122000001)(71200400001)(4326008)(2616005)(66556008)(64756008)(86362001)(66476007)(26005)(66946007)(83380400001)(2906002)(8936002)(33656002)(5660300002)(54906003)(8676002)(6486002)(6512007)(478600001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZzFMWGNyMEZpckJLYlhmUHR0aTlXYmtyaGdKSUhwVVR5Z1dPdE1lV2g1dTk3?=
 =?utf-8?B?a1VPY3R0cXBOU0k3cDYyOWZIbkFYL1dDbkZNd3UvQWo4L2w0c1FqVnVhUnFS?=
 =?utf-8?B?NXVRL0Rpajd6YmJrL1EzVkZ1TzJWcXZPOUxRdDFKZ2NGZUNhTUNYNWtORXlL?=
 =?utf-8?B?SW9Lby9NQUxCOVJzL2pRRjZXRzIwV1Y3SDg5eDBNQlJFWnFJcnFrcnpjckMv?=
 =?utf-8?B?ZjVSV01IbGpURUZHdXZTWGF3U1gwU3FzYm1XYTdsbEF6YlVrV0tRWllxbnNv?=
 =?utf-8?B?bTJQTll4MmE2ZlhpYXZsR1dzTE4rcDhlc3RxOW1GcjhpdDVBaTFOWm1obWlO?=
 =?utf-8?B?RkNud3F6LzZlMDZENVl5WXhXQmhQcnMyTG9rSnhLMUNvZjdHVDl3Q1NUTi9t?=
 =?utf-8?B?OGFYUG5pbkJ3dVdsNVdmR01adEhKUWY1SDlYNjNsRHJkOTRGVTVrWWRpbThV?=
 =?utf-8?B?dmx1R2JreGxVcnNPVmdWMXNjMzdhYjh2NnpWM04yNDMzN3BPMk5hSmhCMzl1?=
 =?utf-8?B?ZEZCWGZ6OVp2MmFQNEhoZ2dsUnJIM3A0eXM1TzJvSC9uRDdMZm4xNGdXRDBv?=
 =?utf-8?B?dGk0VWVTQXlVL3lpdEpZMlVSMG04d0VwRFFqc3pzREhWNTdEMCs5Y2lYb21a?=
 =?utf-8?B?b1B5MnBhL1owRXJKcnVRYmJnNlhMN0Y3V1pkbmJ0RHRCb0diUUMxL2VGWWNR?=
 =?utf-8?B?bDlkQjNvT2wwWjdRV0NQRjMwZkY2MXRCUnEzcG40VFBWSnFkVUZSN0JMcmxi?=
 =?utf-8?B?VUlsWGhBMWlOSHZDVUdBV3VLR3JicnkyTW90Vjk3V3paV21aWXJKN2Mxd1Q1?=
 =?utf-8?B?M1YxanMvdmtrR1NTSDhKdFVSLzRlQ1lXWDN4cWFWWnh3SmVqVGlldjVOd2xl?=
 =?utf-8?B?U1h5bzVpZGU5blVkMmdMN2hacXRMZ2doYWE4ZStrVlhHZDMyR0NOUkxmLzgx?=
 =?utf-8?B?VWlzc0FDMGxGOWVqSzllMkJPK3Q2MUZzR2FEOFBIWTRnWjIzL2tUU3pwOFpw?=
 =?utf-8?B?S05WVVVPSnJrSzJBcmFWVWtVeW9POUhrME1GY21xREdFQXY3TFM3V0NQRWJ1?=
 =?utf-8?B?MzZZbzJETlcyTVNYSnZiS1g3VmwxcEVYZmxxcUZ4dzdaUVZwbHNnL3lxaTF2?=
 =?utf-8?B?SDd4a3l2QkJrc3JjeDhicE93d2cwVjUrbTJJamdkSm9yRmZBL2lUMlJkbSs3?=
 =?utf-8?B?cW1CTjNwK2pycmgzQ3R0NlJXaW0zK3NBWVhhTFRldWdiU2N2cHhFck9MWDdH?=
 =?utf-8?B?SlRpVUNFSW1ZY015ZjlHYVZGcDlUOTI1emVJMkt0OFNWTGx5RjJ4bktkNEVT?=
 =?utf-8?B?UlIwSFkzMklGWXJSM1FmT0VJMU1BWnZFTUN6cGFYVGR0Q3ZjNDhSdzhFY2ox?=
 =?utf-8?B?M2MxRnF0TWRQMGJTUjBOSnhXTXZkTTZINkh4SlBXSGNZMVAwUmtEZml0NWF5?=
 =?utf-8?B?S3BSeGdUbXp3UVdVdGI5dEUrNmZGSkVDSVJNMVdIOXJyeW5wTjE5WVVBVFF0?=
 =?utf-8?B?QSszTk10VXJ5MVJ5MWJLc2dBKzRlTGxoTUNMSFFiV0xnSVhlQ0VLcUR6cy9M?=
 =?utf-8?B?Y2pYNFZYcDNsVUtmNmJKR3orSEpGRDZISjhFVk5VTmtiMW16bE9kK29ReG5O?=
 =?utf-8?B?bkxYTVk4M2RlbHVPZmFzT0QzbzJXSkQxQWFvVjZFZWhtb0dyRTJSNG5SOThE?=
 =?utf-8?B?ZHB6emI2N0RoUlZ2ZW9FK3U3eDhGY1JLWS9nRXA1bWowNm5FUFIwRHRudDV4?=
 =?utf-8?B?cnpDU2RDSHBlOEJZTHluR2RlSFc5ZjVDT0xoZG91Z3BuQ3lhU0wvZEhrUk94?=
 =?utf-8?B?cTl5dTRYcE9nOExvdTJYdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <470061F806F4CF47BFDF6ED5C3DA83BE@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ead2dae-ba40-4a52-fd8c-08d972d21486
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 14:08:06.1006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L4r++KuRLe1p/7+obo+rqiUB8WLOwTYkrZ6mMh8iVPHtJy6Nh6KoFpoUs22CVTXNvn//s08FxXdymGD2lu8N1VHQwZzcSrHdSVtqVbRgD04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4601
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10100 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109080090
X-Proofpoint-GUID: FBWUxqHgfAC4I-md2wa74ESV66qS68Ze
X-Proofpoint-ORIG-GUID: FBWUxqHgfAC4I-md2wa74ESV66qS68Ze
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gU2VwIDgsIDIwMjEsIGF0IDI6MjggQU0sIE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlA
bWFydmVsbC5jb20+IHdyb3RlOg0KPiANCj4gRnJvbTogU2hyZXlhcyBEZW9kaGFyIDxzZGVvZGhh
ckBtYXJ2ZWxsLmNvbT4NCj4gDQo+IFByb2Nlc3MgcmVzcG9uc2VzIGluIFR4IHBhdGggaWYgYW55
IGF2YWlsYWJsZSBmb3IgYmV0dGVyIHBlcmZvcm1hbmNlLg0KPiANCg0KSeKAmWxsIGxldCB5b3Ug
ZGVjaWRlIGlmIHlvdSB3YW50IHRvIGFkZCB0aGlzIHRvIGFsbCBzdGFibGUgb3Igbm90LCBidXQg
aWYgeW91IGRlY2lkZSB0aGlzIG5lZWRzIHRvIGdvIGludG8gc3RhYmxlIHRoZW4gYWRkDQoNCkZp
eGVzOiBlODQwNjdkNzQzMDEwICgic2NzaTogcWxhMnh4eDogQWRkIEZDLU5WTWUgRi9XIGluaXRp
YWxpemF0aW9uIGFuZCB0cmFuc3BvcnQgcmVnaXN0cmF0aW9u4oCdKQ0KQ2M6IHN0YWJsZUB2Z2Vy
Lmtlcm5lbC5vcmcNCg0KPiBTaWduZWQtb2ZmLWJ5OiBTaHJleWFzIERlb2RoYXI8c2Rlb2RoYXJA
bWFydmVsbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlAbWFy
dmVsbC5jb20+DQo+IC0tLQ0KPiBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfbnZtZS5jIHwgNiAr
KysrKysNCj4gMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9udm1lLmMgYi9kcml2ZXJzL3Njc2kvcWxhMnh4
eC9xbGFfbnZtZS5jDQo+IGluZGV4IDg3N2IyYjYyNTAyMC4uMGFlMWUwODFjYjAzIDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfbnZtZS5jDQo+ICsrKyBiL2RyaXZlcnMv
c2NzaS9xbGEyeHh4L3FsYV9udm1lLmMNCj4gQEAgLTM5OSw2ICszOTksNyBAQCBzdGF0aWMgaW5s
aW5lIGludCBxbGEyeDAwX3N0YXJ0X252bWVfbXEoc3JiX3QgKnNwKQ0KPiAJdWludDE2X3QJYXZh
aWxfZHNkczsNCj4gCXN0cnVjdCBkc2Q2NAkqY3VyX2RzZDsNCj4gCXN0cnVjdCByZXFfcXVlICpy
ZXEgPSBOVUxMOw0KPiArCXN0cnVjdCByc3BfcXVlICpyc3AgPSBOVUxMOw0KPiAJc3RydWN0IHNj
c2lfcWxhX2hvc3QgKnZoYSA9IHNwLT5mY3BvcnQtPnZoYTsNCj4gCXN0cnVjdCBxbGFfaHdfZGF0
YSAqaGEgPSB2aGEtPmh3Ow0KPiAJc3RydWN0IHFsYV9xcGFpciAqcXBhaXIgPSBzcC0+cXBhaXI7
DQo+IEBAIC00MTAsNiArNDExLDcgQEAgc3RhdGljIGlubGluZSBpbnQgcWxhMngwMF9zdGFydF9u
dm1lX21xKHNyYl90ICpzcCkNCj4gDQo+IAkvKiBTZXR1cCBxcGFpciBwb2ludGVycyAqLw0KPiAJ
cmVxID0gcXBhaXItPnJlcTsNCj4gKwlyc3AgPSBxcGFpci0+cnNwOw0KPiAJdG90X2RzZHMgPSBm
ZC0+c2dfY250Ow0KPiANCj4gCS8qIEFjcXVpcmUgcXBhaXIgc3BlY2lmaWMgbG9jayAqLw0KPiBA
QCAtNTcxLDYgKzU3MywxMCBAQCBzdGF0aWMgaW5saW5lIGludCBxbGEyeDAwX3N0YXJ0X252bWVf
bXEoc3JiX3QgKnNwKQ0KPiAJLyogU2V0IGNoaXAgbmV3IHJpbmcgaW5kZXguICovDQo+IAl3cnRf
cmVnX2R3b3JkKHJlcS0+cmVxX3FfaW4sIHJlcS0+cmluZ19pbmRleCk7DQo+IA0KPiArCWlmICh2
aGEtPmZsYWdzLnByb2Nlc3NfcmVzcG9uc2VfcXVldWUgJiYNCj4gKwkgICAgcnNwLT5yaW5nX3B0
ci0+c2lnbmF0dXJlICE9IFJFU1BPTlNFX1BST0NFU1NFRCkNCj4gKwkJcWxhMjR4eF9wcm9jZXNz
X3Jlc3BvbnNlX3F1ZXVlKHZoYSwgcnNwKTsNCj4gKw0KPiBxdWV1aW5nX2Vycm9yOg0KPiAJc3Bp
bl91bmxvY2tfaXJxcmVzdG9yZSgmcXBhaXItPnFwX2xvY2ssIGZsYWdzKTsNCj4gDQo+IC0tIA0K
PiAyLjE5LjAucmMwDQo+IA0KDQpSZXZpZXdlZC1ieTogSGltYW5zaHUgTWFkaGFuaSA8aGltYW5z
aHUubWFkaGFuaUBvcmFjbGUuY29tPg0KDQotLQ0KSGltYW5zaHUgTWFkaGFuaQkgT3JhY2xlIExp
bnV4IEVuZ2luZWVyaW5nDQoNCg==
