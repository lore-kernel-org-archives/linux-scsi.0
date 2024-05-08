Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CAA10A31
	for <linux-scsi@vger.kernel.org>; Wed,  8 May 2024 03:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.133.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715138308; cv=fail; b=rS5htWGx4XfW/9VU8PQDUOZIww9U6Vtsj49N67GcYDBaONaxMRGJDySAZmCZ0KZdWA1cPi1/zskJCHj7ypA/P5ZdauB7FOHofj2ohLz9JIW7QoI6phMtyf+Y6TclH2PQxt3sjUFX/rmHdOT07KvNlHvPKVl+sHJT6X/zBafu+mk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715138308; c=relaxed/simple;
	bh=zFHyNik8e3KllJMz5yPA0ubM7kgUSwrNZAtyC7pelWU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qArw5Ehp8mEOATF3oSccpxSodvfonyCREfv4ofRPwyLXdzI7MHPj32TNoDc/IhQ562/8LElIEeSgUvmrdsIw3RtRGGemzG+msRw8/d3GXlTyr2J8p3dBYIcUAXtPpSOxzy8yWZ3TRHM22EeOWzMAWiCosjXn3k0wMWhC+8sKSMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=ynm5Ns1X; arc=fail smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="ynm5Ns1X"
Received: from pps.filterd (m0170390.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 447J2lJ4001723;
	Tue, 7 May 2024 20:59:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=DHxkq430VUfhhrmWktnAhU8IO7ge+x/6ewrmEqf+RC8=;
 b=ynm5Ns1XeJ5EQ7w0gbabmmbpR8pSSooVNqr4GkD+cReLG+cwENg1vP89cYzsvy3HoSVN
 Dh0hyHfdhdo8+ccZVSVOb4/St1EXq3Fs6UxHPt79DA9FdZw7NbKMc6AvTjNNrJQTDCg9
 icwZ9b9JLJkMZly0ECXpE4VjBG09qvT+d6xWPAKBcsMVgX4UmpXvuwCGfMBx3BegkrqM
 57xJ2uABzXNBuxjC/tC96tbTEgiRk61rihTqeyxYkJ7bbCKJe1fV6n5ck9EilM8Lk5bh
 2PrTruPJsQH3Z9TCYCI3lMkUenbHgyYMHQBXKhAo5HQPwCpk0EMo8zlIwkSBPROU5ZT+ rg== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 3xyt40h45k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 20:59:21 -0400
Received: from pps.filterd (m0090351.ppops.net [127.0.0.1])
	by mx0b-00154901.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 447Nt3iK020623;
	Tue, 7 May 2024 20:59:20 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 3xyxcs0m2n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 20:59:20 -0400
Received: from m0090351.ppops.net (m0090351.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4480sN6J024601;
	Tue, 7 May 2024 20:59:19 -0400
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 3xyxcs0m2d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 20:59:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKeU5KNKnsizo2s8nYQ6vvck8nkjs+HEHuK9lDHL7F5BJOoLe1NQni03mfxEuE6xWBrcryii95mBGDbrZCeQiwhhvijO+3NZSKbR9LhPW1c0rKfDpXoU07yR/Zp3hiA6QTMx8B9DmNg2s1iUUSwjv3VaV5zgLeejg9pseSUuGdQyA8pifyRTLqH9mIIpHOlvdTo0BhntowqKA+ccoioX+kgXxwqMdx2ym/4RGxuLJtH7cskTeZ/Mk1sA1PfWSEvqng8F5Ae5I/DFrR4aAV8qTixQeEQHeUQoQy4WfjYT+82njvsFYF5VtW3LoKZP9+sILYrkBqM34L5wC7oHbc1EEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DHxkq430VUfhhrmWktnAhU8IO7ge+x/6ewrmEqf+RC8=;
 b=PVjgf95WCRiYr6fUeizlKMT/A9VhiVf6bndBOEmqcgtQFEUyHILJhplSqy4/CT7V3stj4NpNGWqTB25SC8riJeqrH14bK260iRlM8W0j7R2pwsXklLr4S3OP6Jsh00tJITn0qOOwMFENiEXGeAkJlwICFWzXKRNW4nKbws3gWVHQ1GeZDXOdTWqkxUmHuWyFBih4zUlAOuoOoczi5fYYN0W7yoebMXqvoScDGNddSDi5fNVWCINRB4hHjyHwFiK63ysj7O5VHdUUUjoMl4TrADMXUZ4CusBSWfoWbBYTW749us5nn7ZeMhtKfiOWOULhhAiIzojqpqgEaJfK6rUkgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
Received: from SJ0PR19MB5415.namprd19.prod.outlook.com (2603:10b6:a03:3e2::13)
 by MN0PR19MB5683.namprd19.prod.outlook.com (2603:10b6:208:372::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43; Wed, 8 May
 2024 00:59:15 +0000
Received: from SJ0PR19MB5415.namprd19.prod.outlook.com
 ([fe80::74b4:8ac3:e695:ed47]) by SJ0PR19MB5415.namprd19.prod.outlook.com
 ([fe80::74b4:8ac3:e695:ed47%5]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 00:59:15 +0000
From: "Li, Eric (Honggang)" <Eric.H.Li@Dell.com>
To: John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
        "james.bottomley@hansenpartnership.com"
	<James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
Thread-Topic: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
Thread-Index: 
 AdqWJbfhv3GSaG0rTeK0+6km85YpNwADuoMAACHtcIAABC5uMAEPIjxwADJmXIAATNqvUAALeYiAAIffgZAAQPLpEAAB4+wAAANgfMAACRv3gAAUU6tA
Date: Wed, 8 May 2024 00:59:15 +0000
Message-ID: 
 <SJ0PR19MB5415CFA77DCC17E0BFAEEF76C4E52@SJ0PR19MB5415.namprd19.prod.outlook.com>
References: 
 <SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <09dd80bb-09f9-481f-a7a7-b9227b6f928f@oracle.com>
 <b1a5552c-689e-d220-88d3-56d24752be5b@huawei.com>
 <SJ0PR19MB5415831DB91059696672B163C4172@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <SJ0PR19MB54152CB3D611259510902505C41A2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <c004da1f-b9fe-4641-9d0f-162eabde0101@oracle.com>
 <PH0PR19MB54115A3BDCD9319781FA652FC41F2@PH0PR19MB5411.namprd19.prod.outlook.com>
 <823ab904-33a3-4ed0-8794-cb36b9ad636b@oracle.com>
 <SJ0PR19MB5415F1D35AFB4039A426079CC41C2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <PH0PR19MB5411390C5A29A953CAA70062C4E42@PH0PR19MB5411.namprd19.prod.outlook.com>
 <7081399f-d4e8-4af9-9cff-2bcb1e4c6064@oracle.com>
 <SJ0PR19MB5415A5F70B0D51BA96CBC76DC4E42@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <b82bee4f-67b7-4355-a152-1f13d4918220@oracle.com>
In-Reply-To: <b82bee4f-67b7-4355-a152-1f13d4918220@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
 MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ActionId=86fd1bf3-7d95-486a-bdfd-04df894eef81;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ContentBits=0;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Enabled=true;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Method=Standard;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Name=No
 Protection (Label Only) - Internal
 Use;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SetDate=2024-05-08T00:56:54Z;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR19MB5415:EE_|MN0PR19MB5683:EE_
x-ms-office365-filtering-correlation-id: dbb4787a-95b6-4af3-8a05-08dc6efa1515
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-7?B?L241OWV6YjRSTWVmcU1kdHlsaXdlQktacFFJKy1mdlpQVjRwUUJHU25URll4?=
 =?utf-7?B?TVVhRGFqbGZJZFgvYkFDSE9GYnNjUk1DelM3Y3VDRGxsZWYwM2ZHNXRkLzZY?=
 =?utf-7?B?TTRDNEFMalczUjhHb3hMdkd4emREemtXVistYWE1RVBJTmlYVHViSEJuRXFo?=
 =?utf-7?B?VmpvR3BnaTljZlBUQ1pyWGJtcjFqUXpqRlNIN0VQTmFNNXRsRDJBS0duMnZS?=
 =?utf-7?B?ZkFLWFlqSjExdFBBTkZnaXk3bSstSDdHbmppeVduMFNDN3lBZ243dXN3N0xW?=
 =?utf-7?B?eUxVaUNWMSstSVEzb3YyT21NM1BVKy1uTXREWlk3N2FEVElubWEvNWhYMGhI?=
 =?utf-7?B?NnRYT2p4SlhxNVFrQVBkOGh3Ky1RVm1UTVZFdGNqOTFUaWN3aDhveXFoTUZz?=
 =?utf-7?B?V2lEWWY3Q3lqMlUyb1g0Q1MwclpXUXJnd0tzVE1FeWY3dUdXQnp6ZVNkRHpL?=
 =?utf-7?B?OWQ2Q1JyaGFURm1Ib2RYNjFrQmRYVFBXTzA3WkRMa3Y5VW55VmNKaUVwaUl0?=
 =?utf-7?B?bk9MN3VoUVNvbDNlSk4yNGtPdTU2RFRFRVpQZnc5R0tmQlFIeGcvaU9zS0pW?=
 =?utf-7?B?amhNSFpLeU5lMEpvT0krLVR5MDl6Ky1teDRTSTJrRE5GaUVjYTRScTlnZXlV?=
 =?utf-7?B?RGxuWmxqSGVvWlJGZlNEc0pDTUFJcWpRSGNtV2VvR1hzbXdhODNRLy9zMmZq?=
 =?utf-7?B?eHZ5RnVLdjRIQXgxeTI1a05nZ1Qyb2hDKy1LZlMrLXBoQUVlVm05QUlNZTM=?=
 =?utf-7?B?T2QrLWQ4SDZEQWZva1FyZ1ZnaUlHV0lpSk5ZeGF3SzBQRGxvQUhNY2kvKy1k?=
 =?utf-7?B?OEJSbHJUMFhYczgwWmpweFdBVGpqaWFwSUNWSGdTMWs2NXYwckZFTERKMFZn?=
 =?utf-7?B?VFNnN1NFcHhhdy9ZNkcyV3NpOG5leHJKa0xPL3lnUVJJbkMrLVRTanlnNkU4?=
 =?utf-7?B?bFh5MUNmd1hzSCstbW5HSWxMd3E5N1B2TWVaandUMnBMOHJkalBjVzJRUkFk?=
 =?utf-7?B?UUdIN0Z3MWh0dkMvbVdSQmN0VTFWTW8zUlhVVXh3QXh4S1RiREhhNXVwUVZw?=
 =?utf-7?B?My9zZmptc3NidFBnKy1LbC84NzMzMUdtOGx0Ky1KNElUa2xMNTV4OEFNOHA0?=
 =?utf-7?B?ZjZaZm95QWZLbnhVb2owNmg3YVFYZ3JnTHZ3aFpDYkRMd3dnKy1ub0FEMEVB?=
 =?utf-7?B?RWJKdVBWMU4yMThTNi9tUGF0c3p5Nm0rLWE0R1BjNVR0WDljRXJVaEl1MlpK?=
 =?utf-7?B?Y2MzbUFQZVdxTnB6VEliM3lYRHpETWt2TXYzUDFlMFduUy9vaDI1SXFqWTBF?=
 =?utf-7?B?eW04aUdaN0hJcHVlNGxyNWViUWR0c2RiKy1YOVlYMU5lY1VxMjZLNjdKbTJY?=
 =?utf-7?B?NHAvTTdSVDlkTzFDUWJPeEZLMWhBWVpRM2UxYWpWcmIzTHZhUmc1QkxRR2JF?=
 =?utf-7?B?aWpVVTcyT0huU3ljWkNZOFUrLTRjUEJ0STVFN2hSYnFyWnRZNzlxU1E5OW8=?=
 =?utf-7?B?ZystYjI0UklKWWNhNkZsMUpLa3BJVW4vdWQrLTJFTW9zZjVRa3lFb0FKWWRz?=
 =?utf-7?B?QkdDb3NCOGpadlRuQjJRZlJCSzF6NnhyVlFSMHF2SXAxdldjeFN5SE5sUU95?=
 =?utf-7?B?aFhOS1ZmNVFHSVNhZWtoQ2JwUk9KUGFEZG82Y21JdEx3UE14V3lpdnNtYkEy?=
 =?utf-7?B?TTNPbFpmeFFZMUsxWW05aUlnbzFIUld3U1BrbUJDc3FPZ2hJNGhRT0FtMy9w?=
 =?utf-7?B?NkVYSkptdE93SEIzZ3VlR3l0S2p2VHhUZGxJYjUySTFBbllvT0phYjJuV1Fp?=
 =?utf-7?B?WVVQaXJLbFgwZUZFUlY4d1phSystc2U3MnNnMXh2dDB6SVgzdzQwc0E=?=
 =?utf-7?B?K0FEMEFQUS0=?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR19MB5415.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-7?B?amR1MVp1eHg0YXc3S2x2aXRoZCstWFhSNGtxaVhzNkRqUXNOTkxRMFZ1dS9m?=
 =?utf-7?B?T1NjMW8rLURaTEgxWXArLXRDZ1JWKy15U09Eb0VkR0J6MlQ5ZWZkaGYydHJv?=
 =?utf-7?B?ZVloS2t5ZVVrYUZKTWo0U2k4bk1xUm1xd2t5Tmtlb0p1SUwrLXJPTUU0MVJ4?=
 =?utf-7?B?aXFBeTJjUTE1V2xvUDZyc1A2dzZmcU9oSjVRYjMrLVdMTDZwL2RneW94UE9k?=
 =?utf-7?B?NGdBR2x5aystdWFZR1R3SzNjbistMHJxekZFKy1oMFdITGlKcTdya2ZNN21H?=
 =?utf-7?B?QTFKaGVXa3A2YzFYQmJFbGxZQzg3QS8zKy1iellVZ0cxb3FmL0FkY3h5TUo3?=
 =?utf-7?B?eTRFb3NDR2tBajN0bDJXcGIrLWFtc2VzTlgvODZHMHZpMW1oc3Q1NDcwWjBh?=
 =?utf-7?B?U1laNVlvVzdVTW9XQWNmdjRTWUp0RjBBVExydXYvV1B0Q1dRWCstUnQxancx?=
 =?utf-7?B?TUVNY1owRHI5cXpFSVFxVlBXcmpOR1NkdkRlTkJQeDgwbTR1NSstcFlZVGE1?=
 =?utf-7?B?Q0ZCTDJ1UUpDMXE0SjBrcW13aGR1OVc1MUVYUGdDT3J0SzlsOGFjRVprbGdF?=
 =?utf-7?B?djhlSXZTeGkvaHRydjdVbHJIVFArLUNSRVlEekZkczgzc3MrLVJ2OFRiQzhy?=
 =?utf-7?B?T0ZQWFZSbmVxNGlXTlVyTmkwNHpiRFFkbXVCZWYwUHJXSFJBZkZqTkx1SFhP?=
 =?utf-7?B?OGpQSWhZT0R0WlZsSlM1b3B4R09zTzl6Ty9QbmJ5QmJSTmhsVXVma3k3R09X?=
 =?utf-7?B?d0hJazhFN1RvZzF6dnpmaWZBT2gyTzlmQkwrLUZRcmd3OXlWR0FwMGVlQzF3?=
 =?utf-7?B?OVlmN1grLVdUdGNzQnpYVFJoMlV2SHNQUFIzelRBNDlqM1NSUkVzSW1yYUVF?=
 =?utf-7?B?QnJwNUFyRVUxaXdwUXpiWG41akJHZkVreGNEcTkrLWgva0dPV2hMZ21BVHhy?=
 =?utf-7?B?WlliVWYvcUNMMDBWbUlUREFybDZJU3JubjcxYlFKZWZSckI2Z0dBOGY5NjNl?=
 =?utf-7?B?dDJaVm0xOGJIbGpUaHhzUFpOZSstSUxPMUo5ZkpESjl3c2NVYVhzeUZjUk4=?=
 =?utf-7?B?Ky11MEJwMnN6MU9ZVDM4d1Q1S1FPZ1FPc1BqNHg1VUltMjlaMnZLcVlKYlM4?=
 =?utf-7?B?ZllLbDZZVXpESlA5SWo3bEtJenVxTURxVWZJVEg5VllMMmF1NjQrLW40VHhP?=
 =?utf-7?B?YmpsQWVaL1ZhdE94SjRya2FDNHFlTistdk9XaFZNM2l6cGo4QjlKZnpydk1o?=
 =?utf-7?B?T1Y5NXVSeG5md3VCcTY0eENXclBJWlpzckJyOXpYT2Y2bk10bU5qUDB5TWVo?=
 =?utf-7?B?eXMyckZ0TTBVNFJiZmR4SWpMaDd3Z3htbG4ycExNTjZFMjRETFpMWUFOVFMx?=
 =?utf-7?B?ZlhrdmpqbTlWL2lOWmE0U1FPamdYTnRndmJQSDVlQ0hEKy12azBZWjNiZEJq?=
 =?utf-7?B?SGsxNE5FNXJUWEo2WnhBS3IwOUhyWjlHWG1zQUNyT21pRnY3OE1JMUpycUlz?=
 =?utf-7?B?bTA0LzV4dEtpRjVuVkcxNXdudzFIR1I2M2t1MXN0Qm5HcGs4cVVrRSstKy12?=
 =?utf-7?B?ajZ0dXpKbGEyRm9ldlIyS3QxSGhsS1ZNZistandLUFRBcFpobmNFUDlqc3U4?=
 =?utf-7?B?TXJBRDluVlJ2QVljeEtadVBpOHlRd2tLZkV3eWp3eHNPN3VTWG0zdkYvV3A3?=
 =?utf-7?B?OWU3T1JsNTVYUTNxeG5Zb0ZFaTFBL3QvU1pxeHNWVTFLRUdaQU1lREwxMHFV?=
 =?utf-7?B?R1BjeTFBSTRxcEU0V1VOKy1TNWMwT3pjKy1MeTI3ODRCS2tzL29SdTI2Mkp6?=
 =?utf-7?B?WWFmOTJOdUoxU0hwYjhVRFZ4SzNnOVhZU0wzQVVDaXlJb2lLQ1BHWU5DMVJP?=
 =?utf-7?B?d2FBZ1hiUEUzKy1WYVIybVR0dUVhdzIwc3phc0liNnJVYVdjNFc3QXNXSk9M?=
 =?utf-7?B?STA5YmQwR0JmWFphTlQzZ3cxUXFEcUZuS0lzVVdHdlVZSkJMOTg5SnUrLVpV?=
 =?utf-7?B?QjBaMGF1alY3b3VvZEFWYTRibUxibG15UWVpVFY1SFpLR1FNYXA0cm5GQmM4?=
 =?utf-7?B?NTlneHFiN2ZlblI3dUNzQlU0VnFnaU1Ec2VYWWNRekorLWhacWUvQXhpcy8z?=
 =?utf-7?B?OWE5ZzJvWkZxakpPTlR4czlSZFViYmdKeGZIYWRteWxiRnl3K0FEMC0=?=
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR19MB5415.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbb4787a-95b6-4af3-8a05-08dc6efa1515
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2024 00:59:15.4047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IOBfoP2CruTCpCiS4fSclSFezWWn9HaHZUPg4UDxfm64dMB9hFj5+MByDApWc1weKdTDManWub9ASuStOM1Fzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR19MB5683
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_16,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405080006
X-Proofpoint-ORIG-GUID: emdp2dgQ6HDB0V2FYlPQq8KHZY3ZRo9E
X-Proofpoint-GUID: emdp2dgQ6HDB0V2FYlPQq8KHZY3ZRo9E
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405080005


Internal Use - Confidential
+AD4- -----Original Message-----
+AD4- From: John Garry +ADw-john.g.garry+AEA-oracle.com+AD4-
+AD4- Sent: Tuesday, May 7, 2024 11:15 PM
+AD4- To: Li, Eric (Honggang) +ADw-Eric.H.Li+AEA-Dell.com+AD4AOw- Jason Yan=
 +ADw-yanaijie+AEA-huawei.com+AD4AOw-
+AD4- james.bottomley+AEA-hansenpartnership.com+ADs- Martin K . Petersen +A=
Dw-martin.petersen+AEA-oracle.com+AD4-
+AD4- Cc: linux-scsi+AEA-vger.kernel.org
+AD4- Subject: Re: Issue in sas+AF8-ex+AF8-discover+AF8-dev() for multiple =
level of SAS expanders in a domain
+AD4-
+AD4-
+AD4- +AFs-EXTERNAL EMAIL+AF0-
+AD4-
+AD4- On 07/05/2024 12:17, Li, Eric (Honggang) wrote:
+AD4- +AD4APg- Sure, I don't particularly like it as a fix either. But firs=
t I would
+AD4- +AD4APg- like to get your setup working again to verify that only thi=
s needs
+AD4- +AD4APg- fixing. Indeed something else may be broken since a1b6fb947f=
923. In
+AD4- +AD4APg- addition, if we need to backport a fix, I would only like to=
 backport a fix for real known
+AD4- broken topologies, and not theoretical issues not experienced.
+AD4- +AD4APg-
+AD4- +AD4APg- But what exact setup do you have? I am confused, as you seem=
 to be
+AD4- +AD4APg- talking about your setup being broken, but then other setup =
may also
+AD4- +AD4APg- being broken, but you don't have access to another setup. Wh=
at is the other setup?
+AD4- +AD4APg-
+AD4- +AD4- This issue was reported by our tester. His setup is SAS Control=
ler
+AD4- +AD4- +ADw---+AD4- SAS Expander +ADw---+AD4- SAS Expander +ADw---+AD4=
- SAS drives
+AD4- +AD4-                                                                =
     +ADw---+AD4- SAS Expander +ADw---+AD4- SAS drives
+AD4- +AD4-                                                                =
     ......
+AD4- +AD4- When this issue occurred, no SAS drives could be detected.
+AD4- +AD4- As a workaround, I've already added those codes removed by the =
commit a1b6fb947f923,
+AD4- and at least we could detect the SAS drives.
+AD4-
+AD4- ok, good to know, but it would be good to confirm that just re-adding=
 the code to set
+AD4- phy+AF8-state is enough.
+AD4-
+AD4- +AD4-
+AD4- +AD4- Since our SAS expanders are self-configured, we don't need to e=
xplicitly configure the
+AD4- per-PHY routing tables.
+AD4- +AD4- So, I am not sure there is any other issue in this workaround a=
s some per-PHY routing
+AD4- tables are not configured.
+AD4- +AD4-
+AD4- +AD4APgA+AD4- I think the root cause of this issue is the order of fu=
nction calls
+AD4- +AD4APgA+AD4- to
+AD4- +AD4APgA+AD4- sas+AF8-dev+AF8-present+AF8-in+AF8-domain() and sas+AF8=
-ex+AF8-join+AF8-wide+AF8-port().
+AD4- +AD4APgA+AD4- My concern here is whether or not we still need to conf=
igure
+AD4- +AD4APgA+AD4- routing on the parent SAS expander before calling sas+A=
F8-ex+AF8-join+AF8-wide+AF8-port().
+AD4- +AD4APgA+AD4- This part of logic is not present previously and I don'=
t have environment to test this.
+AD4- +AD4APgA+AD4-
+AD4- +AD4APgA+AD4- Back to your question, I believe we do need to join a w=
ideport to downstream expander.
+AD4- +AD4APgA+AD4- Changing the phy+AF8-state to PHY+AF8-STATE+AF8-DISCOVE=
RED will skip scanning
+AD4- +AD4APgA+AD4- those PHYs,
+AD4- +AD4APg- I would have thought that re-adding the code removed in a1b6=
fb947f923
+AD4- +AD4APg- to set PHY+AF8-STATE+AF8-DISCOVERED would only affect the fi=
rst phy scanned
+AD4- +AD4APg- in that wideport. Other phys scanned would have it set throu=
gh calls
+AD4- +AD4APg- to
+AD4- +AD4APg- sas+AF8-ex+AF8-join+AF8-wide+AF8-port()
+AD4- +AD4APg-
+AD4- +AD4- I don't catch your point.
+AD4- +AD4- In my understanding, it would affect the rest PHYs in that wide=
 port, not the first one.
+AD4- +AD4- The first PHY has been scanned/discovered and added to a port (=
at that time, it is just a
+AD4- narrow port yet).
+AD4-
+AD4- Agreed
+AD4-
+AD4- +AD4- Call to sas+AF8-ex+AF8-join+AF8-wide+AF8-port() makes the rest =
PHYs associated with that existing port
+AD4- (making it become wideport) and set up sysfs between the PHY and port=
. +AD4- Set
+AD4- PHY+AF8-STATE+AF8-DISCOVERED would make the rest PHYs not being scann=
ed/discovered again
+AD4- (as this wide port is already scanned).
+AD4-
+AD4- If you can just confirm that re-adding the code to set phy+AF8-state =
+AD0- DISCOVERED is good
+AD4- enough to see the SAS disks again, then this can be further discussed=
.
+AD4-

OK. I will work on that and keep you updated.

Eric Li

