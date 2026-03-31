Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836CC13D53C
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 02:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774922528; cv=fail; b=aHlD167pT7fjucYrpgvXhWwUYin2WnDAGGZZ30eZzXvYJN7h5OSAdM/Dun4NUjEILESvqQFl1T5MzgHCrPNPslNHnef3dhqFf9t6dQHxAuDCACV2hVd5xawxSnomWSSg3s0p+1s0tRWIi+x7ybXYgcCGDdwzfTuawBeOmJJusXg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774922528; c=relaxed/simple;
	bh=Rz8ZjARGqKatTO9pUQew4R3F64KPfoGCk0SxCx6H04k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GJuBqYXdwJFYJFpkW25ziipeOXCsGQRRvcJLBjJ7l/yGvm/4MSlHPFbSOrVvj337vSRdpbUjnJ7YEU4hY6ZMUDd6sBgBETZqBtK2zrqv+hIYjRlH4xmGbyqFcE1KyfTAZePrQ+VGHbWxivTqKQYEMueVS+aVx+c2+1Z1hqlplC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=qti.qualcomm.com; spf=pass smtp.mailfrom=qti.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SjNRotF/; arc=fail smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=qti.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qti.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SjNRotF/"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62UKmUNB2407599;
	Tue, 31 Mar 2026 02:01:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Rz8ZjARGqKatTO9pUQew4R3F64KPfoGCk0SxCx6H04k=; b=SjNRotF/XvxL37IK
	cGny5ylU9UWDYhdGCyWoGWO61t1sxiGFp2R4BO9GAVDd0UN6W0woykoNXiNfcucJ
	cq2x/CZ/090Vw2MDOLgls66G4MbHSuyGUDzIO/npQgLn9Kh6EV/H8TKnwOkihIEO
	PHtjAGsKS+wCqvGK6z78IVhCX0qllIpnlCd6aHvQXA6iBvxFqVZYJcfPdqeOzMxA
	a6k/i2OY541IWem83Hl6GSk2yGA9j7reviuPzqKiqus2CK6x6gCBJgSZz3vsUMD6
	q26tcocBFeCgqJkn+Sa7PO273EJC91EtYlFgUwYLCM/ulNdolY47m8qw4dWBjL38
	5RA9Bw==
Received: from bl2pr08cu001.outbound.protection.outlook.com (mail-bl2pr08cu00102.outbound.protection.outlook.com [40.93.4.10])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d80hertx2-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 31 Mar 2026 02:01:53 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YcWPzbBuvtDSplxZxD9NUniVHJfRGv2RCJ6awG8QEei2VYpAIkMAcCnd7TuQYMpPDGMivSKjW2JoTtHPVN6jDB7N00VX1/hUp2Fmh9YYKLe1iV5qMzIv8N0ZgAlLpYMoal/70FaRdw4a6OKSEwRN4av7P6U9F5zdeLft2hMKomdH9Mbe0KYHTuz0UM3evCxF+Gso2Cc7MDj3FuYNGpjOOb478K6q5/ymN9jTQ9HukZHWX++l1tBwQF8MA6ldpBhkPj2PPVsv/MtScxQk/YPemWUqyCtpUcyRe/BVTYHZY1m32gYLkhgc7qoJn6I4c05cifRaf6syX4mCYZfynTFGGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rz8ZjARGqKatTO9pUQew4R3F64KPfoGCk0SxCx6H04k=;
 b=LNrOmHCyXBmfpy/YDDxex43pXzmNdrwgbsfZ4ZE8GVEZk0/9+4lm4/zogQediJFgtO/olTat7vCUAowJ6VAwiXqblt6HPA3rQQXduJ8bgHMZvt/BY095GkrnuUH/VntFFFHOd15r23H4d1PAasVXP5TF6E77frf4DJz7eXKIpVpWG5oTZtYWQWpI7w/lGF7G2+d5ORnpkPlEcq7pH3Op5m8ZdfKhly5eFzxov+T1oelhGTCFKqVFNIPhS8m7m64Gu/RDVkXJRwkTbGBnQgCf6BZlOleTn2SQG/4QKc0GLAkMglApOUurvRK9n2yIJDoi34AyD35BprK9Nsts3c77vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qti.qualcomm.com; dmarc=pass action=none
 header.from=qti.qualcomm.com; dkim=pass header.d=qti.qualcomm.com; arc=none
Received: from LV3PR02MB10127.namprd02.prod.outlook.com (2603:10b6:408:1a5::7)
 by DS1PR02MB10418.namprd02.prod.outlook.com (2603:10b6:8:215::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.27; Tue, 31 Mar
 2026 02:01:50 +0000
Received: from LV3PR02MB10127.namprd02.prod.outlook.com
 ([fe80::99c7:61ba:32fe:69f7]) by LV3PR02MB10127.namprd02.prod.outlook.com
 ([fe80::99c7:61ba:32fe:69f7%5]) with mapi id 15.20.9745.027; Tue, 31 Mar 2026
 02:01:50 +0000
From: Can Guo <cang@qti.qualcomm.com>
To: Bart Van Assche <bvanassche@acm.org>,
        "Can Guo (QUIC)"
	<quic_cang@quicinc.com>,
        Richard Patrick <richardp@quicinc.com>,
        Xiaosen He
	<xiaosenh@qti.qualcomm.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K .
 Petersen" <martin.petersen@oracle.com>
Subject: RE: [PATCH 0/3] Reduce interrupt latency
Thread-Topic: [PATCH 0/3] Reduce interrupt latency
Thread-Index: AQHcwHQfL6+i6R/WfEOf5CpT9QGFLrXH40Og
Date: Tue, 31 Mar 2026 02:01:50 +0000
Message-ID:
 <LV3PR02MB10127544190699309108FAE5EF953A@LV3PR02MB10127.namprd02.prod.outlook.com>
References: <20260330183311.1941942-1-bvanassche@acm.org>
 <6e4ce34a-23e6-4dca-837a-b89feb504e41@acm.org>
In-Reply-To: <6e4ce34a-23e6-4dca-837a-b89feb504e41@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR02MB10127:EE_|DS1PR02MB10418:EE_
x-ms-office365-filtering-correlation-id: a974817d-81f9-44b5-246b-08de8ec97910
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|56012099003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 Uh2gYeGD1cQbycPT2PSGG5f4/YfAmDmscP7UFiJFnri2bREgB/+CMwNmJjzgH5qaoupowyBRzHk/XsOVULMJlB7tDIjnyS+4ZlZ7vZeWGOIRD9vdlnfNgIVUyIWLeXrZHdM6XIG41+uL1lRphXc+gcYriENTs8ubIVCWijMlVJF6g/zA00E40wADU49Xp3RKeFCthGq0L2lVwmGwIs+Rz96d7J/EAuZTgPcDW4tImYA9F9Lku7ggHr77vmVeJFGpXwo2xfGc05/iH25e+4yUleDX/iTs5dzNq+Ipn8bHTWL0wnxJtPL/X+cacRnwtckWm+MtXgLJvULupo4YMfmJgo8SCVDlz6ueYgnQf5c3gTZOH48Rn01QJYyx7D1P19+NUb89YpF98Zp80V1cUth9Yg1ZAyjXs8IwL9aLWuSfKFxPLeuHFTspP0clLH85N4VAaFZ2qgG4VgyOFTf/m+3PU805M5mINwiSrEQZ6xboXGkyeSrECj/VacY54lQttiSm7VGXQEGe+fDyrpNTeo5dgOKM2fV2b+bjZ4AgV7SjdbSRVaa2t2g6bhhGrKM90XGHDihxqlWPTUeO1DT5zU0YB/+jUMAquZOwtsMJ9a+KmerYizV0gyu2ryYKQ+Dv/7cLifqjWEAPWmWTGlICtyU4v3BgEUsITwzRGn7oIOm9AzA496gK0CK03DwsjgTnudGmNshtDZ8RlcmNCzy+5r8Q7aolACZJvv1vvimvI/2MMEL2T88s0vrnDKJ/z4ABHMAXLgu14wxMDTuBVyI3rMXAu5cTKE1sC9sO6l4EqoE2+KM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR02MB10127.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Q1FTNCsxMlhpNHdweWlVZGsrZWZycElvZVdDVWNoNnliRCs1R0RVeCsvZys1?=
 =?utf-8?B?WUZmNk1XMEdqR21nbVJxOEJKVFRQNFF5S2NENzVZNzc5bGdpcWk4TytaMDZs?=
 =?utf-8?B?MU4wQ0NHWjVWelh2VDBOQ24xVTFvRFhlV1AyR2lWN2M3Q09Wb1lGUUV3ekUx?=
 =?utf-8?B?R2FnM0pTN3R1YlRFUUdLYkp4VmFlSHZVYmpRQnplcTdHdWdFOEdXdC9aQnFm?=
 =?utf-8?B?QmJITHZORUg5U2JIZmdPallaSG9BVVZyd1FMbzY1UEJ5cVI2b21ZSlpjSGk4?=
 =?utf-8?B?Q2M3UW5ZSHRSY0RQNmJRNElnMFllU0tRMm5lWk9oVHNpK2VMeEoyL08vdzNy?=
 =?utf-8?B?OE14ZTJ4TUFMM0J0K1cvMDlxUEcyYXU5WXpIaTJVUGIrNk9PTHBLWVJ0UjZV?=
 =?utf-8?B?R3dCV2ZhNjdIcFRTWmE3RFFoRlNGNnpQSTNmMUExZFB0d09pWWFVUGRwemk5?=
 =?utf-8?B?UGRaT0Y1VXJkRGhJckhLNWx5NFJrN0p2ZFpaNnQyT3ZxNkxPblVKSitFNjBw?=
 =?utf-8?B?c0FQQXpzZUJ0dWhsSmpDVHh3WjlQRUNsWC80NWtCc2ZMbnhaNmJaZWhSWmVN?=
 =?utf-8?B?ZlYvTlNiVkVaN0pzU0RwMVl3dzZkRkozTVJmRWE5ZFg3NUhZSG9nSWdvOGM5?=
 =?utf-8?B?cXl1dnRKUkRBZVZFSGhTcjFRVSsycjBWMDNYSHNkUXpMQUUwK1NqNVNZbVlu?=
 =?utf-8?B?N0FuZ0ZsSEl4VlhUZURxTDk3K0xrbk00S29ua2Z4bnlKVnNDMTY3dmJmUGIw?=
 =?utf-8?B?akhPbnlMbWtmRUdNczl1anJ6ck81ZHBiL3NKd1lxNXZwZ0FFMXNWalZla0tv?=
 =?utf-8?B?VjRoZlpvRCtGVERvb29tNmFvUjBPYVowZ0ZBWFhvSitleGo0VkJBVjFjdCtJ?=
 =?utf-8?B?YWxCK1FKalNKbXlER2ZPd1Z6QzZLRVdXRGtuNVBUU0dSdHhaSTd1RVdqb1li?=
 =?utf-8?B?QlZrbGZOYUthUUhsaUN3RUxWdkZPUlFnNjJFVjVuZE4zOHNWcGtNSDBYQ3R6?=
 =?utf-8?B?VFhkUlpEYjlaM3gwaEZlcEtwdXZiSjBlMHRsSzJBOTA5S2NwM0VIU240NFpo?=
 =?utf-8?B?ZzdpRkNOZXVoa3RMRDBJYzBhWmlUZGpkN09YNkdFUmlOT2lkeFZZMERnUU9N?=
 =?utf-8?B?MGVDejE5MWY1UjFLRjFpd1dZanlya3JLbnhYOU0wRGRpYUl2YTRkc3piL3FC?=
 =?utf-8?B?OGFiRzhqeHFJdlZSY1owc0dxK21YeVhraXhtOVpDdXFwUWk3b2pUWWFIeXpw?=
 =?utf-8?B?SUtzM1JNOGxpQzVSYVVNWDY5TDlIYnZPVFFWKzh2WGRSbXBlNHdUVEZ4SW9X?=
 =?utf-8?B?Q21qZTl4dVM2VkZRVkx0eEd0TWdBY2liL1hDc3RBMmVZQkd0a3Y0N0w1cGVa?=
 =?utf-8?B?ck9pblppb3BObDJQdDZmMEpsV3RxZ1ZaZGY4Y2t6QlVUWHZsZXltcDdsNVpu?=
 =?utf-8?B?QnN5TG5tZTZ3eXFiRWhFUTZFOVZMNFV1YWV3NkVJeGFRT2hOZVpxZmtVNXlv?=
 =?utf-8?B?a0o0Nm5uNjdiZXg3OUhXeWFLU1J3R0hDZjFaUytjbEZhN0RxcEZtRFFFODRa?=
 =?utf-8?B?KzhDWnZyNGJvUmlNNVRxVU1CeWVsYUFvZnhpa1pNbzF2RTNwQ1A2NkJzY25u?=
 =?utf-8?B?RXdkem9VdnRSaEtZd0xrSURhNk5ENS8raHoyWmIwbGR6bnlSVi9vUnI3WVBK?=
 =?utf-8?B?V0J3N2xrYU01NEpmNEpLYlAvMnh0TFRud1lvSXg5b2t1c1hTenRSZXo4VVVL?=
 =?utf-8?B?YkpRQTJRUmo4YlZkSnBTOXhyVEpCOSsrS29zYmNzams0M05yV0hORGxNM1Fu?=
 =?utf-8?B?WFlKOXA5RmhYZk55M1V1TnlHODJWVkhCMjVwK3YyYnY3Yy9WTVRybVV4cUpv?=
 =?utf-8?B?YnFOcmRPVngrUjI0SHdkaEVONlpZNFh1TEtTalFZOEhEWlgya2tQYlNSYW4x?=
 =?utf-8?B?Vmkyblkxb05nbk9KTkFHdll3OVFhZWI0NCtwMThsVVRBL01qSUpOQ0g4WDJK?=
 =?utf-8?B?K3NtVisvOVBNa2ZWeEhSdXBweldST1QwQll4ck8xZ3ZJbml0aHM4V1FkUGhP?=
 =?utf-8?B?YU95WmNhZFkxcDkrWGVvTEg2ZkRGRjArQU1BNlZQVllTendWVlR4am56ekJy?=
 =?utf-8?B?d3lZMmNudGRqTTIraC9VbW1VRGFzNDZucE9qVTlLZW50OC8wNFlPa0pPcSt6?=
 =?utf-8?B?U21lSnA1T3JENFcxc29FSXBmNmRIRXB6NzdlUEd0Z0lrSmUwZVY3dU96bVR2?=
 =?utf-8?B?TzM4NlRRa0JDOXU1UThvYjZTOFdqT3NYSEowYnRBN0xFMmREMVV4VkYvODg4?=
 =?utf-8?B?WnVncERWZGRTUjdHSEFubW40T2xMOXV3N01hVWs1T2NONURvQ3h5Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	sJclSce97Z2QspzsflzjzcuOXCZ3CpQeduncwrxDv2pEetkdwPqlr5a/2fJjXCdiysodJ78ng9IuOAi8n8JkPbcbcWF6d7tSx/vwzMh9nKfGUMF3/Lhka5v0QaywEGGhRD9egXudX58PR6J0XZMYK4LChzqn8up4w60gflcmO2UM2ya/PFqXwKLVJ9meeFYjCfcorq/636YE0faJlLuRDZPWg73R2E3i4re0vSMggNxAStFiGEACcJI8NOYWcpOHwgQnVZ9Pa7XsZMgg4xYycSmBbA2S9photE6xg6E5A+RMxP9l4dlDsJy9LupE43wRXanOwK/qpv8nFSfqI7jlxQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1oS/Z8SBjCaQ31uaqE7ARUGlNPrXG0LcgHhYr0RvbLvdk3JnnuOdEVn8N5J5EW2uMy3VzJDtd73tm4aO74Mzk0R3z2ql79pM/+PnaCBD3BxzcM6KovlIExAEMWT7eC/yzNWWMljsR4F3cvPdgvE6XRTe0xgaSANUw5opwUl3wu1sT5Xu2UR21RjK5oPJ/fts5chHRpDYRakwNXAqmZ5/IYlxHIuyj9+KFb5N6KLhHrLMIfpd3lEFypnEXsiQabinYK8ewohm+r9qb/D+g0FNUoDMXdnOxGkF0KzST7nOiduk6jPrSv4m9TyfbP3UR84aA4uyjQG3y/PWYHzgmgx9VISFtEKU5E0OKF/XUsy+PkcEMDO4gY7fuYF0H9cy8QX3wwFYe5BvS+EsOyl9AZwOlBWWw0xZTzqhM3Qs3Qz8DNs0UxP0//a1tcw44esH7vnct0vyPgb7FReIXVVX+UXOFfUMk3wWyAJ1DG0eZXoctf6jdSNgRd4kwdwR3Amk6ReAelXqgO0i7AWHfNqLFSsgdW1UJ0wJO33U2nxfYmf55Mv9zOFIzZUE7/1wgj5skdRYVTEI2PgSVPFnpvNNkrNsDNrpJbXwpeUZi8G3SyVyLdVoaRpXTBLQMwASGIV8UZWJ
X-OriginatorOrg: qti.qualcomm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR02MB10127.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a974817d-81f9-44b5-246b-08de8ec97910
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2026 02:01:50.3645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TEzKkw0VO4gGxcdiHS/3ImPz06rXLJhqIZDjAMm7caB8TYvcdyRpDrQK4Gi6W9JsrcHjhqPWlyInsWAE19y8bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR02MB10418
X-Authority-Analysis: v=2.4 cv=Gb0aXAXL c=1 sm=1 tr=0 ts=69cb2b11 cx=c_pps
 a=Ycvd2K91t9vP77DbJT42RQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_glEPmIy2e8OvE2BGh3C:22 a=N54-gffFAAAA:8 a=COk6AnOGAAAA:8 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=yzsTTDT-Jb-B5knWzdYA:9 a=QEXdDO2ut3YA:10
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: 0DBrDiqy4VDCKMefBk1OtKSMO0_LoiFd
X-Proofpoint-ORIG-GUID: 0DBrDiqy4VDCKMefBk1OtKSMO0_LoiFd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMxMDAxNiBTYWx0ZWRfX+2ABc5jDVheN
 ALR2aI9i7SUiKTu76zGWs0ICvbj82LbZtesEDWBZbA46X+kDPnB9TpYEU+kY4ffKiMvRUKJ6khs
 0VX68QQ9VkCId+vPOGjrHbO+nU8WsWTR4R/ijhP93NR57U/9JipIDRRGKKAbPue5rvfBrFeoQai
 kiXlA7/lKyVkPSW8jFwWoxLfzmdZ6g5hR4HeWcv1ZDhTEOc6Cq1i0l6jgN7gEKiqA3W66sTyIsH
 4WcUki09CUeb3j+M5pkU/Nt+Dzx1llMmz+Qs8NaAzNMlUb7w4RMQl+87PzOzh1XSGeRryxGOq6h
 GM86PPfKt1sc+BiyUOAHAQ1jiGJK7gttuiwzTbD8jms0NgL1pDxzM2Bf4AO3Hh0+0Vb4am3gyoq
 1Ny9TjrKZ8HJLkI4WIEMacpWbDJe53PV8B3AbXdXXd5TdM9+sb6EyvfLswki5KoOsR2ssISJs4z
 VrH3ovS0GAFn/M92OIg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-30_02,2026-03-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 spamscore=0 bulkscore=0
 malwarescore=0 clxscore=1011 suspectscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603310016

SGkgQmFydCwNCg0KSSBhbSBhZGRpbmcgWGlhb3NlbiB0byBoZWxwIG9uIHlvdXIgcmVxdWVzdC4g
UGxlYXNlIGV4cGVjdCBzb21lIHR1cm5hcm91bmQgdGltZS4NCg0KVGhhbmtzLg0KQmVzdCBSZWdh
cmRzLA0KQ2FuIEd1bw0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogQmFydCBW
YW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+IA0KU2VudDogVHVlc2RheSwgTWFyY2ggMzEs
IDIwMjYgMjozNiBBTQ0KVG86IENhbiBHdW8gKFFVSUMpIDxxdWljX2NhbmdAcXVpY2luYy5jb20+
DQpDYzogbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IE1hcnRpbiBLIC4gUGV0ZXJzZW4gPG1h
cnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPg0KU3ViamVjdDogUmU6IFtQQVRDSCAwLzNdIFJlZHVj
ZSBpbnRlcnJ1cHQgbGF0ZW5jeQ0KDQpXQVJOSU5HOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJv
bSBvdXRzaWRlIG9mIFF1YWxjb21tLiBQbGVhc2UgYmUgd2FyeSBvZiBhbnkgbGlua3Mgb3IgYXR0
YWNobWVudHMsIGFuZCBkbyBub3QgZW5hYmxlIG1hY3Jvcy4NCg0KT24gMy8zMC8yNiAxMTozMyBB
TSwgQmFydCBWYW4gQXNzY2hlIHdyb3RlOg0KPiBPbiBBbmRyb2lkIHN5c3RlbXMgaXQgaXMgaW1w
b3J0YW50IHRvIGtlZXAgdGhlIHRpbWUgc3BlbnQgaW4gaW50ZXJydXB0cyBzaG9ydC4NCj4gVGhp
cyBrZWVwcyB0aGUgdXNlciBpbnRlcmZhY2UgcmVzcG9uc2l2ZSBhbmQgcHJldmVudHMgYXVkaW8g
DQo+IHN0dXR0ZXJpbmcuIEhlbmNlIHRoaXMgcGF0Y2ggc2VyaWVzIHRvIHJlZHVjZSB0aGUgdGlt
ZSBzcGVudCBpbiB0aGUgDQo+IFVGUyBpbnRlcnJ1cHQgaGFuZGxlci4gUGxlYXNlIGNvbnNpZGVy
IHRoaXMgcGF0Y2ggc2VyaWVzIGZvciB0aGUgbmV4dCBtZXJnZSB3aW5kb3cuDQoocmVwbHlpbmcg
dG8gbXkgb3duIGVtYWlsKQ0KDQpIaSwNCg0KQ2FuIGFueW9uZSBoZWxwIG1lIHRvIHRlc3QgdGhp
cyBwYXRjaCBzZXJpZXMgb24gYW4gTUNRIFF1YWxjb21tIHN5c3RlbT8NCkkgZG8gbm90IGhhdmUg
YWNjZXNzIHRvIHN1Y2ggYSBzZXR1cC4NCg0KVGhhbmtzLA0KDQpCYXJ0Lg0K
