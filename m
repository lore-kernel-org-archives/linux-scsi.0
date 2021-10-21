Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D47DBC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 14:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0BA36120F
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 14:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhJUOIv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 10:08:51 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46820 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230123AbhJUOIv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 10:08:51 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LE4SDi005285;
        Thu, 21 Oct 2021 14:06:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=twUKZBEumkWFZWwvYjPnWM+GHgnBZr/zuydVuvTKFrM=;
 b=SlgXZ/f6S9G5Lays1UbdUn02ueb7jPIvIs1TMDzrLYU2AjUML4mNSFjUFv8aFy4MqiUO
 9Z5uuKMcGe13kPfs7QqShwuPqr9UvCIBrat4VqvZhMvIOuD3XaI9Ii9bdETxLzbfNND9
 CbN/luPEf6FJgqqd6kZvfGrroFCM3/0kdA+fZ+b78Yw8uWl2SchCUNPtk1Brvq888FU3
 Yd/7XwyHSvHZO9RrqcPak7UAwqb/Xn4lkPDFIDMQugguDIJxwhgrbMi5+gitce2pajhZ
 v63sNEWdJTwoDra2Y2x9ENHijLNp01FdtDxnWxjU76Xxl6eO1W1a4sZ2/Pn8sj7vi9Kq jw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btqypnc1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:06:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LE0vOs112996;
        Thu, 21 Oct 2021 14:06:20 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by aserp3030.oracle.com with ESMTP id 3bqmsj76rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:06:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TEHHK13Db4Knfr3dqzMWaR2N3iv4ZsVYAoRxaRqcoX2r5bJmmm1czGsfA2NlVdHQEvPzJbakzE+QI2SA3Pbw9DzyW1AjojkLsYxtMEqEeX40Tuq/EG+KQIUOhcMQQepS3RL0bo8nCykvo0bgpH9Lzr7OkFZcochR9cYuNXavFObRcRtF9gIh8dKcTzl0ejcTBqVaOKB/2sb5cusrS3Maue6iePtgaPJEARWgSOWu9hEsRthCgt5cvh2pGGlCh2Vo2yw9xju8gWp9cMzZdvYD2Ey6YOyi4ddHBLaLoFicX8czqkXZuJhZ1X7QKA2Cu5nOfXllRenqrqU36tovFa9iNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=twUKZBEumkWFZWwvYjPnWM+GHgnBZr/zuydVuvTKFrM=;
 b=aT4r84cI51kZKxUzQxk1r3QZ6PUAoSG5xU78U+pHy0NBb//V2wPip8j7y30I/oV9VdLOKNHusJJWyw2Efk+CdAuutkrjO4cbfCUq7LHWxVCTxL9Dk6JuTxJatnGyFJKR2bALqOOrNil4eagX+4ql+0aUooHKdoTnThHg4l0izzod66VsxHC0vIS+ujlWgBhIK1b4UtuHfrZSu1Eng1j9O0h5+IBjiZsS+uS9kGSOB9dU95hS/3aT978QJOdD+H0jN4EVQ3NQBG0znPoYDZdFRuDir3FlPGaOa4yNwZSYRjcyl1kuTDE8QTrdeDvpVDhbtVOthqZJOPGpg0QhRgUOZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=twUKZBEumkWFZWwvYjPnWM+GHgnBZr/zuydVuvTKFrM=;
 b=egsbYG0InGwug8W7SrFZZu5+Ya1MH75Dmcli2CBSkE2FqtSln1ftVoRVd1oETK2rlK+l02WeD6UFpy3R+4Ob/ppsLwztkmb6f2rIc87KNAFINCiTBdWDCfrwRKc0O7NAkLwKLDPI9borh9OJMzmXUer579uY94IGJsnSNY7wo90=
Received: from BL0PR10MB2932.namprd10.prod.outlook.com (2603:10b6:208:30::16)
 by BLAPR10MB4849.namprd10.prod.outlook.com (2603:10b6:208:321::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Thu, 21 Oct
 2021 14:06:17 +0000
Received: from BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188]) by BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188%3]) with mapi id 15.20.4608.019; Thu, 21 Oct 2021
 14:06:17 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2 04/13] qla2xxx: edif: fix app start fail
Thread-Topic: [PATCH v2 04/13] qla2xxx: edif: fix app start fail
Thread-Index: AQHXxk3TX0tgfSvlJUqATwXvPNENxKvdfQQA
Date:   Thu, 21 Oct 2021 14:06:16 +0000
Message-ID: <F904C42E-8361-4F5C-A44D-41CA75D2DBCA@oracle.com>
References: <20211021073208.27582-1-njavali@marvell.com>
 <20211021073208.27582-5-njavali@marvell.com>
In-Reply-To: <20211021073208.27582-5-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04af7243-cbc9-4906-4614-08d9949bf335
x-ms-traffictypediagnostic: BLAPR10MB4849:
x-microsoft-antispam-prvs: <BLAPR10MB484963199898DAD7D5213E2CE6BF9@BLAPR10MB4849.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:170;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0Kf+OTFl2JkIWbB2UtOzwerx0Y5TuHoVOBAC5T7KwtBJ2W1Y8gZDto66QWr3+OjEXlWg4ZAmYY+i0hS4y3g3I1J6dfmdXEj81rtVji/Xj0XjzRwIn+clpHp/IFyZ4qz+Fffdo18KwD8K5lI2ynRbX1Ox0yrCq2ub9fVb1ZQdNDeVWnDrlhlujAPcxzF/YsUwMY+9BZt/5kJHymjH8O1UZ7eYLHMyCBZiSbCm55WvI5LRWzRrl3gvYMNRd07sHIEcFcCaSOiBQKcvwIfU+5tNkAWPxClMjXVbIE7qQNHyjJ/enbcaGFtqwyBXiJ0p99oIyMbARYP0WbBBrD30qfn2qtjtj5xOkVGZSjcWFruRFEDszFea0MpJDGvMg3BB1QCKOZofDqVZU7ZsengmAoSbCtxyamXJ0SqzK/3EOuhbq5EdZvtTL020CnAqc9BhcDTwEHci1ctRW8ZT/WOMXRWn+fJO6gUI5dEhaBUHcWiKZDGSU9HQAQIJvq7yfPtDLg0S5oB/bl/7AI15ND1RHoGNSHV9zYBUr0UWkboZzdVjMem1IVXNKS7aXhtBIoPi5BrY0748LJIwRCngg2d9uun/Xx4YaIiDGHv7V1HlWB9yvyx8yMtgfGmHzTHKbu4ZEXFGoZsSFpna1Ul9saMx4ikCUAw0R2rEj5HK/SNyt4F7EgH2sH07Icqfp6f+xjR/6LQVVvWTMpclH8PedK2dfEU9C1aYEKNKX+Yy+42SH4X2wZKcBGfTkJlBwfG2MPT4usbK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR10MB2932.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(76116006)(71200400001)(8936002)(2616005)(6486002)(54906003)(83380400001)(66946007)(4326008)(33656002)(2906002)(5660300002)(316002)(38070700005)(6916009)(66556008)(86362001)(8676002)(66446008)(64756008)(6512007)(38100700002)(26005)(186003)(508600001)(122000001)(44832011)(66476007)(6506007)(36756003)(91956017)(53546011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R2JhbnRjSytPV2J3TVhTRmljUWZ0aFNzUElmcktBeTZVeG9qalFXRUE3R1Ev?=
 =?utf-8?B?WUluSzNHQS80K0IyeGp4Njg0ZExrY1JCWTVSQngzQ3JZYW10cTRjMU9EaFpC?=
 =?utf-8?B?R2VyTkJ2ektCekVCOUM5bE5FNHdYS1hReHVwaS90TDdjaGdYVnpac3E2SUpS?=
 =?utf-8?B?UC90VUV6b3JtcWc3RUpWMENZc2tHaUJ3YUwzalNEY01ncGs0ajhrdnVSSzJF?=
 =?utf-8?B?c2daS0ppZ3BIM2F6NWVaNHovM2VkS29uV0xRYlNCS2t6cVNxQ1ZFK0xuNFNF?=
 =?utf-8?B?NEZoR0xYNzQ2VHhySDB2SC9MQ0tFNElGUDA2S296MTVxdk1aY0ZGSmZsL2xN?=
 =?utf-8?B?MklTYk43WlZvSCt2OE5BQnRRb0ZyK0hOQ1ZEOHNrOVkvQm1XVjQwTmlpOEk3?=
 =?utf-8?B?VjlqQlk3UWNRRzgwNjRLYm1pU3V6dGFWUXdlN2RnSEUrMThwU0ZBZE1sSzR1?=
 =?utf-8?B?UVhld0gwSGRqb29kaHgxdnZoeVhWaGU3NExsZWI1eVg1RXJ3U0IwdDdKZW55?=
 =?utf-8?B?d0VTRjRMc3lsZGhFUUxkb0ZsYytyaHJEc0ZqbHMrZXFpR2h0eDViYmt5VmNo?=
 =?utf-8?B?U0xiVlN0aW1JdG9ody9SczV5TldKOWxRVDBBTUVuWHhiTjVRVVJFajVuZjZz?=
 =?utf-8?B?Ym5KZ0RoZWhmQk8xY0VwNk5VVWc4TEhmSHFGQXRHZHo0TEFSMEVONW1UK2JF?=
 =?utf-8?B?eG5SL3VBTnVIbnBZU2lqQmNYSTRPQ1NudjBrR3Uwek1tOUdSUHVOSjU0TUQ1?=
 =?utf-8?B?QVpQdWUvK1VlRmNtZFUxNGFlbzMzZllwZ3psb0ZVeVVEY3k3dHU4Y0JSRkYz?=
 =?utf-8?B?U1gwNGxFVkNKcmc4cWNLcDlndVpGNWJCdDZjL0xIMHJFOFZNT3VmOUExeWlw?=
 =?utf-8?B?c2E1d1JUNS9hUVZuWFdOaEdSOGNZYlQxNUY1clM2TEFzWThPTEUzS0U0dGRx?=
 =?utf-8?B?RDJRRzhzZU1IVHA0VXBOY3pNbzlhN3BoVG5NenNwc05SMTJPbjFvSDdxd214?=
 =?utf-8?B?b1RCTytYSlBtdTN1VDBlOGJsWUhoRUgxcUtsSGlBVnJqd1NneWtyV0xJYVc5?=
 =?utf-8?B?SGxHUW5lVHNRdEdQUENIZHlvQWhFVVgrY0t0N3IwWGozN2g4QW15c1VJdmEx?=
 =?utf-8?B?TjkvQVo1QTZMUHh5TlIvdmlQeUxXSkZTdGFMOGFRd2xEdm4rajdwanphd3oz?=
 =?utf-8?B?cGJET1RFOU01dGFRWDhvcE42amJMR29WaklzUEhuZ3ZrOXlDaTl2OE1jVlZu?=
 =?utf-8?B?bkpLSGthV096TlJSaFpKS093cmxPY0s3Tlc2MjdERG9rNGkxWFJ5U3dPTGxq?=
 =?utf-8?B?Tlh1Q2cvRG94QVhlZEJPaXNWOFdzU0dRVHRYRjNZVU1SOWhTekRueC80Ukl3?=
 =?utf-8?B?Ym5jQ3B5dnEyeEJwUVRLTlk2UTR3bjBqSkFaQmt0cCtYWmdFZ3dTWFh4RlY3?=
 =?utf-8?B?Y2ZYbDZXb0ZPVzBCanV4TTArMUppNGhpTEhnT2N4eWo1V0JVSEJZOVFUbUlY?=
 =?utf-8?B?dWJvbk5SMkdTakI4QnUrKzZjUEFtc01oUFhjSS9IWnFzaTFjdUhoMTA2RUpj?=
 =?utf-8?B?QnVqWWNnTThQOWFwUUpDbTFyV3l5eW9OcndhTWVweVJPYnpjaXpuekpncFJS?=
 =?utf-8?B?blNyOXJqNnZVSWdLeGNmQzZvRkgvVG5EN015Y2dwQkNUSy9MdVJwT3Y2UDJ0?=
 =?utf-8?B?T1lGMzRHamplLzl6ZDUyS2RiZXlDb0JsVHBGYlh2cVFpUUw4amV5dFE2Y25x?=
 =?utf-8?B?OHp4SkZXNW0zdWRsT0tGOURWZlRoVmRkdFd3RUJjSUxjUWVQNWt6Ry9qbXQ2?=
 =?utf-8?B?NWR6REJ3bkxiTGQzUUFlQ3NrditRR1p6U3RzQmVJT1p0VWVDRmpBREdkWU00?=
 =?utf-8?B?cmhzNzlkRkh3bDdIRnNGSFRjbEJ4M2NMcWFFWWJoeVltaTV2UzdiQmQ5YUFC?=
 =?utf-8?B?S1hTZ1ZSRm1vb0FqeHN0Nld1clhnYTU0dVNKM2xnUzcyTE02R0xjMm05Vkds?=
 =?utf-8?B?R0hJZzdMQm9BPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2813B29B1A96B1489B3676C4D19F8FEF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR10MB2932.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04af7243-cbc9-4906-4614-08d9949bf335
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 14:06:16.9793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: himanshu.madhani@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4849
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210075
X-Proofpoint-ORIG-GUID: I9YadxfLkpc14GRmAhcceSRpzgMwXpMG
X-Proofpoint-GUID: I9YadxfLkpc14GRmAhcceSRpzgMwXpMG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gT24gT2N0IDIxLCAyMDIxLCBhdCAyOjMxIEFNLCBOaWxlc2ggSmF2YWxpIDxuamF2YWxp
QG1hcnZlbGwuY29tPiB3cm90ZToNCj4gDQo+IEZyb206IFF1aW5uIFRyYW4gPHF1dHJhbkBtYXJ2
ZWxsLmNvbT4NCj4gDQo+IE9uIGFwcCBzdGFydCwgYWxsIHNlc3Npb25zIG5lZWQgdG8gYmUgcmVz
ZXQgdG8gc2VlDQo+IGlmIHNlY3VyZSBjb25uZWN0aW9uIGNhbiBiZSBtYWRlLiBGaXggdGhlDQo+
IGJyb2tlbiBjaGVjayB3aGljaCBwcmV2ZW50cyB0aGF0IHByb2Nlc3MuDQo+IA0KPiBGaXhlczog
NGRlMDY3ZTVkZjEyICgic2NzaTogcWxhMnh4eDogZWRpZjogQWRkIE4yTiBzdXBwb3J0IGZvciBF
RElGIikNCj4gU2lnbmVkLW9mZi1ieTogUXVpbm4gVHJhbiA8cXV0cmFuQG1hcnZlbGwuY29tPg0K
PiBTaWduZWQtb2ZmLWJ5OiBOaWxlc2ggSmF2YWxpIDxuamF2YWxpQG1hcnZlbGwuY29tPg0KPiAt
LS0NCj4gZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2VkaWYuYyB8IDU0ICsrKysrKysrKysrKysr
KysrLS0tLS0tLS0tLS0tLS0tLQ0KPiAxIGZpbGUgY2hhbmdlZCwgMjggaW5zZXJ0aW9ucygrKSwg
MjYgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgv
cWxhX2VkaWYuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9lZGlmLmMNCj4gaW5kZXggYWQ3
NDZjNjJmMGQ0Li5jYjU0ZDNlZTExYWEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEy
eHh4L3FsYV9lZGlmLmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2VkaWYuYw0K
PiBAQCAtNTI5LDcgKzUyOSw4IEBAIHFsYV9lZGlmX2FwcF9zdGFydChzY3NpX3FsYV9ob3N0X3Qg
KnZoYSwgc3RydWN0IGJzZ19qb2IgKmJzZ19qb2IpDQo+IAlzdHJ1Y3QgYXBwX3N0YXJ0X3JlcGx5
CWFwcHJlcGx5Ow0KPiAJc3RydWN0IGZjX3BvcnQgICpmY3BvcnQsICp0ZjsNCj4gDQo+IC0JcWxf
ZGJnKHFsX2RiZ19lZGlmLCB2aGEsIDB4OTExZCwgIiVzIGFwcCBzdGFydFxuIiwgX19mdW5jX18p
Ow0KPiArCXFsX2xvZyhxbF9sb2dfaW5mbywgdmhhLCAweDEzMTMsDQo+ICsJICAgICAgICJFRElG
IGFwcGxpY2F0aW9uIHJlZ2lzdHJhdGlvbiB3aXRoIGRyaXZlciwgRkMgZGV2aWNlIGNvbm5lY3Rp
b25zIHdpbGwgYmUgcmUtZXN0YWJsaXNoZWQuXG4iKTsNCj4gDQo+IAlzZ19jb3B5X3RvX2J1ZmZl
cihic2dfam9iLT5yZXF1ZXN0X3BheWxvYWQuc2dfbGlzdCwNCj4gCSAgICBic2dfam9iLT5yZXF1
ZXN0X3BheWxvYWQuc2dfY250LCAmYXBwc3RhcnQsDQo+IEBAIC01NTQsMzcgKzU1NSwzOCBAQCBx
bGFfZWRpZl9hcHBfc3RhcnQoc2NzaV9xbGFfaG9zdF90ICp2aGEsIHN0cnVjdCBic2dfam9iICpi
c2dfam9iKQ0KPiAJCXFsYTJ4eHhfd2FrZV9kcGModmhhKTsNCj4gCX0gZWxzZSB7DQo+IAkJbGlz
dF9mb3JfZWFjaF9lbnRyeV9zYWZlKGZjcG9ydCwgdGYsICZ2aGEtPnZwX2ZjcG9ydHMsIGxpc3Qp
IHsNCj4gKwkJCXFsX2RiZyhxbF9kYmdfZWRpZiwgdmhhLCAweDIwNTgsDQo+ICsJCQkgICAgICAg
IkZDU1AgLSBubiAlOHBoTiBwbiAlOHBoTiBwb3J0aWQ9JTAyeCUwMnglMDJ4Llxu4oCdLA0KCQkJ
CQkJCQkgIF5eXl5eXl5eXl5eXg0KDQpTbWFsbCBuaXQuLiB3aHkgZG8geW91IHJlbW92ZSAlMDZ4
IGZvciBwb3J0X2lkIGZvciBuZXcgbWVzc2FnZS4gQW55IHBhcnRpY3VsYXIgcmVhc29uPw0KDQo+
ICsJCQkgICAgICAgZmNwb3J0LT5ub2RlX25hbWUsIGZjcG9ydC0+cG9ydF9uYW1lLA0KPiArCQkJ
ICAgICAgIGZjcG9ydC0+ZF9pZC5iLmRvbWFpbiwgZmNwb3J0LT5kX2lkLmIuYXJlYSwNCj4gKwkJ
CSAgICAgICBmY3BvcnQtPmRfaWQuYi5hbF9wYSk7DQo+IAkJCXFsX2RiZyhxbF9kYmdfZWRpZiwg
dmhhLCAweGYwODQsDQo+IC0JCQkgICAgICAgIiVzOiBzZXNzICVwICU4cGhDIGxpZCAlIzA0eCBz
X2lkICUwNnggbG9nb3V0ICVkXG4iLA0KPiAtCQkJICAgICAgIF9fZnVuY19fLCBmY3BvcnQsIGZj
cG9ydC0+cG9ydF9uYW1lLA0KPiAtCQkJICAgICAgIGZjcG9ydC0+bG9vcF9pZCwgZmNwb3J0LT5k
X2lkLmIyNCwNCj4gLQkJCSAgICAgICBmY3BvcnQtPmxvZ291dF9vbl9kZWxldGUpOw0KPiAtDQo+
IC0JCQlxbF9kYmcocWxfZGJnX2VkaWYsIHZoYSwgMHhmMDg0LA0KPiAtCQkJICAgICAgICJrZWVw
ICVkIGVsc19sb2dvICVkIGRpc2Mgc3RhdGUgJWQgYXV0aCBzdGF0ZSAlZCBzdG9wIHN0YXRlICVk
XG4iLA0KPiAtCQkJICAgICAgIGZjcG9ydC0+a2VlcF9ucG9ydF9oYW5kbGUsDQo+IC0JCQkgICAg
ICAgZmNwb3J0LT5zZW5kX2Vsc19sb2dvLCBmY3BvcnQtPmRpc2Nfc3RhdGUsDQo+IC0JCQkgICAg
ICAgZmNwb3J0LT5lZGlmLmF1dGhfc3RhdGUsIGZjcG9ydC0+ZWRpZi5hcHBfc3RvcCk7DQo+ICsJ
CQkgICAgICAgIiVzOiBzZV9zZXNzICVwIC8gc2VzcyAlcCBmcm9tIHBvcnQgJThwaEMgIg0KPiAr
CQkJICAgICAgICJsb29wX2lkICUjMDR4IHNfaWQgJTAyeDolMDJ4OiUwMnggbG9nb3V0ICVkIOKA
nA0KCQkJCQkJICAgICBeXl5eXl5eXl5eXl5eDQpTYW1lIGNvbW1lbnQgYXMgYWJvdmUuIFRoaXMg
Y291bGQgYmUgcmVwbGFjZSB3aXRoICUwNnggZm9yIHNfaWQNCg0KPiArCQkJICAgICAgICJrZWVw
ICVkIGVsc19sb2dvICVkIGRpc2Mgc3RhdGUgJWQgYXV0aCBzdGF0ZSAlZCINCj4gKwkJCSAgICAg
ICAic3RvcCBzdGF0ZSAlZFxuIiwNCj4gKwkJCSAgICAgICBfX2Z1bmNfXywgZmNwb3J0LT5zZV9z
ZXNzLCBmY3BvcnQsDQo+ICsJCQkgICAgICAgZmNwb3J0LT5wb3J0X25hbWUsIGZjcG9ydC0+bG9v
cF9pZCwNCj4gKwkJCSAgICAgICBmY3BvcnQtPmRfaWQuYi5kb21haW4sIGZjcG9ydC0+ZF9pZC5i
LmFyZWEsDQo+ICsJCQkgICAgICAgZmNwb3J0LT5kX2lkLmIuYWxfcGEsIGZjcG9ydC0+bG9nb3V0
X29uX2RlbGV0ZSwNCj4gKwkJCSAgICAgICBmY3BvcnQtPmtlZXBfbnBvcnRfaGFuZGxlLCBmY3Bv
cnQtPnNlbmRfZWxzX2xvZ28sDQo+ICsJCQkgICAgICAgZmNwb3J0LT5kaXNjX3N0YXRlLCBmY3Bv
cnQtPmVkaWYuYXV0aF9zdGF0ZSwNCj4gKwkJCSAgICAgICBmY3BvcnQtPmVkaWYuYXBwX3N0b3Ap
Ow0KPiANCj4gCQkJaWYgKGF0b21pY19yZWFkKCZ2aGEtPmxvb3Bfc3RhdGUpID09IExPT1BfRE9X
TikNCj4gCQkJCWJyZWFrOw0KPiAtCQkJaWYgKCEoZmNwb3J0LT5mbGFncyAmIEZDRl9GQ1NQX0RF
VklDRSkpDQo+IC0JCQkJY29udGludWU7DQo+IA0KPiAJCQlmY3BvcnQtPmVkaWYuYXBwX3N0YXJ0
ZWQgPSAxOw0KPiAtCQkJaWYgKGZjcG9ydC0+ZWRpZi5hcHBfc3RvcCB8fA0KPiAtCQkJICAgIChm
Y3BvcnQtPmRpc2Nfc3RhdGUgIT0gRFNDX0xPR0lOX0NPTVBMRVRFICYmDQo+IC0JCQkgICAgIGZj
cG9ydC0+ZGlzY19zdGF0ZSAhPSBEU0NfTE9HSU5fUEVORCAmJg0KPiAtCQkJICAgICBmY3BvcnQt
PmRpc2Nfc3RhdGUgIT0gRFNDX0RFTEVURUQpKSB7DQo+IC0JCQkJLyogbm8gYWN0aXZpdHkgKi8N
Cj4gLQkJCQlmY3BvcnQtPmVkaWYuYXBwX3N0b3AgPSAwOw0KPiAtDQo+IC0JCQkJcWxfZGJnKHFs
X2RiZ19lZGlmLCB2aGEsIDB4OTExZSwNCj4gLQkJCQkgICAgICAgIiVzIHd3cG4gJThwaEMgY2Fs
bGluZyBxbGFfZWRpZl9yZXNldF9hdXRoX3dhaXRcbiIsDQo+IC0JCQkJICAgICAgIF9fZnVuY19f
LCBmY3BvcnQtPnBvcnRfbmFtZSk7DQo+IC0JCQkJZmNwb3J0LT5lZGlmLmFwcF9zZXNzX29ubGlu
ZSA9IDE7DQo+IC0JCQkJcWxhX2VkaWZfcmVzZXRfYXV0aF93YWl0KGZjcG9ydCwgRFNDX0xPR0lO
X1BFTkQsIDApOw0KPiAtCQkJfQ0KPiArCQkJZmNwb3J0LT5sb2dpbl9yZXRyeSA9IHZoYS0+aHct
PmxvZ2luX3JldHJ5X2NvdW50Ow0KPiArDQo+ICsJCQkvKiBubyBhY3Rpdml0eSAqLw0KPiArCQkJ
ZmNwb3J0LT5lZGlmLmFwcF9zdG9wID0gMDsNCj4gKw0KPiArCQkJcWxfZGJnKHFsX2RiZ19lZGlm
LCB2aGEsIDB4OTExZSwNCj4gKwkJCSAgICAgICAiJXMgd3dwbiAlOHBoQyBjYWxsaW5nIHFsYV9l
ZGlmX3Jlc2V0X2F1dGhfd2FpdFxuIiwNCj4gKwkJCSAgICAgICBfX2Z1bmNfXywgZmNwb3J0LT5w
b3J0X25hbWUpOw0KPiArCQkJZmNwb3J0LT5lZGlmLmFwcF9zZXNzX29ubGluZSA9IDE7DQo+ICsJ
CQlxbGFfZWRpZl9yZXNldF9hdXRoX3dhaXQoZmNwb3J0LCBEU0NfTE9HSU5fUEVORCwgMCk7DQo+
IAkJCXFsYV9lZGlmX3NhX2N0bF9pbml0KHZoYSwgZmNwb3J0KTsNCj4gCQl9DQo+IAl9DQo+IC0t
IA0KPiAyLjE5LjAucmMwDQo+IA0KT25jZSB5b3UgZml4IGFib3ZlIG5pdHMuLiBmZWVsIGZyZWUg
dG8gYWRkDQoNClJldmlld2VkLWJ5OiBIaW1hbnNodSBNYWRoYW5pIDxoaW1hbnNodS5tYWRoYW5p
QG9yYWNsZS5jb20+DQoNCi0tDQpIaW1hbnNodSBNYWRoYW5pCSBPcmFjbGUgTGludXggRW5naW5l
ZXJpbmcNCg0K
