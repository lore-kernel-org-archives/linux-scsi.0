Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFF53A257F
	for <linux-scsi@vger.kernel.org>; Thu,  1 Oct 2026 18:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790880686; cv=fail; b=atGifgFpXJKwtiCA/XWlWYxy4gH2HsrRvDjTxgkwc36Q7zDXJ4wTTHA3cIUUT8C07H8+ZQOe43f1dERQy6F+/ZS7Z5hOS4C/WZ+qotx5pm0fHhGsy45pn14FwVk6Bb1U4VH0aaebsgDsgE3FLy1dsZZWjReF4wUT57dr2uxpRhg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790880686; c=relaxed/simple;
	bh=eqjdyw0ydl2qHyQf2on8Kat+6MNd4OSJiNREcPH6wJc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YhJZ++uSNVZ7MDAfJNVJ0+L6PJuhXZrUI3YNKGZ57+tFGA+zhzImXQ5qFPUbjXlEuwAJ3guG9ieDX4GhzGCbitZZWndJF9DQa6+/jYEtRaXucJFuecOWoG+8EBbQLvCPxqBz3QHcba6baGBjHOWnq4QVaLSD1BkVTc8WWOsgXdY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=em+219Cs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=H99ldwsx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="em+219Cs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="H99ldwsx"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 691Ftino907908;
	Thu, 1 Oct 2026 18:51:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gVXAYhfIqU+bucSYvqpj5eOwAmiNY6wmSRxFNMqgBVs=; b=
	em+219CsOIrSbvHTElYAcetw/GlwAYTQWdYgSd0Vd4/1ePpFLo+LaI44gcye8mRr
	278kvI5ooqBx7hsNmshBOAAIXkUX5APin7bAe9+MWGYkps9FFifWwXcnx3u/wkKG
	45cbMnrM1CPSK/+KdaeUpD3hyw5yYReUy4cDTKSApBakW+qCYfVK0a4fF0DyEtOX
	lqeU2w6XESH3L1qgsT9A4hxow081Qmj2TgPOhWgbRTpg52F/Wv2ppWPBcYiDGPdN
	qEELkNW4HUdQ7MOofruzMlXwq8eAg+gqmtZLdS+iAerDRv0/I7f4WK96KiERU1ou
	Sn31N4V6FR+3rfykDY+VpQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gx4u2huey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Oct 2026 18:51:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 691IoOF3039506;
	Thu, 1 Oct 2026 18:51:21 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010005.outbound.protection.outlook.com [52.101.193.5])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gx4gsnxqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 01 Oct 2026 18:51:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a7Wj2AERcGiqxlfvyPDtioNCwj2IVHddajHPiecRNy7z3IeJX9oPgvL8Zsynz8nuWXYCYt/0X8U6iJ2OfVhDH7sgG4FWvUnS+Wa67NFNLSxLnsRQJXsy260lMHHADMjsWBmeMskyrApAtdNE1dvHh72rvjGrmCpwQcRavukbCYzPlmjG4Zn75NUOLF2013gUERQ5tbB0WANrKS6tvu6uJYGq9BLUT/jzzTaH3yYXTLulCALv5HI9s0At2o7PG2/7nPkEYXy5jdCGEK3pfdXVKOL7OcnfntKQXPJlulxuLw5Q9aUI0Fcc0gRonKEV8ITDzhN/we+NY38rJBtAjT9Ggg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gVXAYhfIqU+bucSYvqpj5eOwAmiNY6wmSRxFNMqgBVs=;
 b=bDcQtMJbbA1aS1nteVUWK0tyT3UgkO3U1BUP2jPyaJf9/RJrKXbbGPzugcRZP5sQcbfeUqqj7ln0nkqPyi4mougDLoGR03rXnuGLbkyEly2NrGmfK4Fivf9wjuDlXj9e0MDuHnZCM6FhVPvvR6RQZhTKhOHwUy1k0FHGCA9HoMQBiYqfZpv16IqtzIli6TUYI+KvR7J2wUYTCIRZ072liReHG/Mf6QiuJT4etN1PaY5PRodanLhTKOJBjri3g5XBKuDHm66KdG1f0tu7mu1hTrS/rTfyoa/rXQCOrlG4Mtoi7scBV4pSrkkKf7zelbpZtjMutXSva+qgFoCGhaLHWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gVXAYhfIqU+bucSYvqpj5eOwAmiNY6wmSRxFNMqgBVs=;
 b=H99ldwsxI3Oe47BZ4LLYqzL59uf+BfnG7BU6xUfBb66+wDQeEo/RC8nSEbwUsZLpgtVgSgpoPUAqHHRBAJrpPQVEclbps3ayYe5lY3FYFLCyPqFLJlLDlRHyjKHKCu4IIH0hTd4i1h+1M8qMmV2I82KIyK5/KsRCsVT6/6tUNqo=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from MW6PR10MB7639.namprd10.prod.outlook.com (2603:10b6:303:244::14)
 by SJ0PR10MB6302.namprd10.prod.outlook.com (2603:10b6:a03:44e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Thu, 1 Oct
 2026 18:51:15 +0000
Received: from MW6PR10MB7639.namprd10.prod.outlook.com
 ([fe80::8386:1d11:46b2:b163]) by MW6PR10MB7639.namprd10.prod.outlook.com
 ([fe80::8386:1d11:46b2:b163%5]) with mapi id 15.21.0472.015; Thu, 1 Oct 2026
 18:51:15 +0000
Message-ID: <ec2e3ec9-6c25-4c13-87c7-71f104e31b8c@oracle.com>
Date: Thu, 1 Oct 2026 11:51:11 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/1] scsi: lpfc: defer SCSI rport node put until
 devloss callback
To: justin.tee@broadcom.com, paul.ely@broadcom.com
Cc: linux-scsi@vger.kernel.org, Dai Ngo <dai.ngo@oracle.com>
References: <20260929223133.2922017-1-dai.ngo@oracle.com>
Content-Language: en-US
From: Dai Ngo <dai.ngo@oracle.com>
In-Reply-To: <20260929223133.2922017-1-dai.ngo@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0264.namprd03.prod.outlook.com
 (2603:10b6:610:e5::29) To MW6PR10MB7639.namprd10.prod.outlook.com
 (2603:10b6:303:244::14)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR10MB7639:EE_|SJ0PR10MB6302:EE_
X-MS-Office365-Filtering-Correlation-Id: c1596a50-6f2b-4b4c-71b3-08df1fecf825
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|18002099003|10067099003|5023799004|6133799003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	rC6LmCrz9gmEHez9hFHMqXIRi0AZV6JIPULy2Ta7ZoKxf3RM/5ON0sS8edfX29TcrnVytZTB3gAXnzZ+yV9G4MkZ9Xwg3BM2Ggc1yEeBl85E++9mN6uWTGqCxbN6/Ae1RccJsA+1wBN1nq1oo+VgLOjFROjP4VUXX1gwJf5WlIAEnvD0/51rll2H87Pb0iafapVF1g7mTuAxuIBTOp0KUGPyv9Dm+esVZtSAYcaEDfKGwKSsKfC/Eelkj4QKhHv07nmGtTQ6Q+JisYNqLg/QytbJK6JKAUNEit1PdJgqBEwspTASfMBFM6BJ96/zHeJ2Yhc8yarI2HpTzrbgrglh+ggaogJlZ1qbArUVWGgCbjsJzUIAca63nMuc2SpDzl/iGe07hfHvyWDbZV2t6eRZTJTrWg9C/KaIOdoLH2pWwPAFsaLb5xrozFmj/e0GuUfqR8AquDgHLxiVrDnqev0hH2XEOZqz/9KN4eRmb2asIegdHRI4gAbmHnXOklvh4l+ZaG/pvO4/kFCIVWJb6YRyCoj4RBSiWFvDJ53bsCK9ysUj0/USjKYnraCmRelbGa7zaOihiHhQMEpQB215sdbmeIVQ1Zkrw9dSUNvnqNpUpHJm0CdDr4Bzqo8THzeNgbBmaiXe8w5iol28pkTAA4G+qUz2evKY24o8M7xEOxhCWlI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR10MB7639.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(18002099003)(10067099003)(5023799004)(6133799003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDQ1Q09ZQk5Ddm9nQm9Ec25vTlg5b0cwS0t3WEN3dU9WYkw2Qml4NGNwbXdP?=
 =?utf-8?B?Q3Y4bDJpWmNpT1NMenQxRDMxM2VhcFBiT0h4Mk9ZNFN4b2o1YkpkeVNJRGVX?=
 =?utf-8?B?TjRFK1kzVFVqVEpKOUc3TytEd3RQQTVEbFU4c0QzRUlIM3FxMVZkWDlKM2VR?=
 =?utf-8?B?NU9wWW5ndlowanpuTkRYcktSSFAzMm1nbkhtUFFPbDVraUFyZU5ybnFWSkx3?=
 =?utf-8?B?dWVreDcvaUtwTnZOaDRjMlNiQW4xcnZCcUZLNXJ1ZUxNOThLa2hYS2FYSnpF?=
 =?utf-8?B?QXpWaUd2V2pITWZxQzNIbStVL2VpY3I0bk4rS1VzVWxEOWdrZDY4VHNLWldw?=
 =?utf-8?B?bjc4TWhDMkt6c3EwYkRkRkFzaTVJVkM5QkVKcTNXYXhBbW85aVVtOG56R2Vi?=
 =?utf-8?B?Q2MwVWM3cENOaXdpa3NqVlhlZ0FyUE0yL0E1ZTV4V3ZsUEE2K0c0TkVRanRZ?=
 =?utf-8?B?bFdIbFBockpvWVVXRVdTcCs5aWE4d01oOWhtVklsSFBrU2RBT05qOXdtR2ZC?=
 =?utf-8?B?RHpsaDdLc25hdlJVWGVxQkdnTEt2WUhNQ0xEeWRoRlRJOVQ5OXVxU3pFdnB3?=
 =?utf-8?B?eVBPR29zVFNpNTBpRzU2eEZPajJtajZlOGFkVnRoM2NMNEdTd0Q0dkJjVHJ5?=
 =?utf-8?B?eVlPa3RzODgzRjkzVHo5MEltR2tGUHh6aXhCaGErdi9OcHdZS2lacWdLRU1R?=
 =?utf-8?B?MDVvOFZYUUx4ZUx4MmIvSWcvUXNUOEwxQzVOaDMwTnNQQVNqMWl1VEpzdlJ2?=
 =?utf-8?B?eGhBam1ZRmRNdHB4QXl6aDNxaW8yMjhLTW9SdnY3aFFlZWRTMDN6WG12M2Jp?=
 =?utf-8?B?NGJNNEZaZjRwYWcrZTVsTzZYTEVWUTJJL05idkNIS2hKbzZ0Q3BBMjJ4dGFm?=
 =?utf-8?B?SWFiMTRIYzBoNXFhY2wzOFpxNHVtcTRGb01ldXFaK2VMOURJSnFvdzhLRFg5?=
 =?utf-8?B?ZFloUFcyM2k2dVdnSC9rWStkb0xPT0xiWWJ3TkNPZmErNTVKajlSV3dVeFRa?=
 =?utf-8?B?ZGJQclNZWlBaRm9malRlWEQ1Qk1Tb1JzdU9HK1dKYjFUclhVUzhmeXZyVWts?=
 =?utf-8?B?NTNDc212c29sakM1R25LWlpGSGI2czgxcGQzbkVmYkMwekFQdWt6N0ZDOERE?=
 =?utf-8?B?YjFXWDZQdEZ2SnVZbnBXV3I5Z1BMWmU4d2VHbzBIaDRRMUNOOHNQc25XUGJm?=
 =?utf-8?B?TTA5dnRzNVR0S1NpOTFFSUt3T3hnbGw4QU1nUExxZU0xSzJrL0hkaFcxR3R1?=
 =?utf-8?B?QzRlUjVhTkx4WFY4SmlRZDV1TWNTRmVrcjIycUpVU2JybFRUa1NKNUFyT0JY?=
 =?utf-8?B?TnQ2WVRzNXNNQnVMNU1uYUdzVmxJTDl3a3IzZW1LQ1JrQTdURlgydmlidjd4?=
 =?utf-8?B?WitJRDE2b2VzSGh0MEwzWkhRVDNjM1FjTkZLWjVQWEx6dHAzTDh6NmFKSDlW?=
 =?utf-8?B?S2FIUEEzdTloOEl4MDNrTW40Vk5aWUJWVEdGckM4Mmw4T0pValBaWnRCNnZB?=
 =?utf-8?B?ZVlJRWdMd2o3RHJHcVBVaVk0YkhSOG83UGJrQWVLQlROWmIrMVQ0WWRDU2Rk?=
 =?utf-8?B?OURlMmI3M0ZtVXBkR2tzRDRWMWZwMjdJeXJlNXFTeEFsWXE4Sy9NNUM4aWk2?=
 =?utf-8?B?NVFiQjR5akZQc1FLbHRHSlFtcVBrK0FRV1lXOUw1Ymx5TmlpOWFlRjVwcm5O?=
 =?utf-8?B?eUNCenRwNDJsYy9pZkFlSUtWcWRYUnhzK1FNWEptOXJuNSt5T2JvWE1seVRY?=
 =?utf-8?B?YjVmWHVaN1BtWW9TbnFrYStPYzRjc3ZwNEN3UUI5ei82dSt1RmN4OXo2ajc5?=
 =?utf-8?B?SEtQZmxKMXVtd3FPWkM4dDgwL2VuY2RpaDlGM2V4cm0rUTZmcXBCNXBqenVl?=
 =?utf-8?B?Q0ZNOEIrQjhraTNuaDRZN0haeEo4WGdVVFB3bTNlUzdvMGpaY1ZTMlllTlJO?=
 =?utf-8?B?alUyZmpibkZYTGd5TW42S0RvZDA3ZWFDdTZtak9wSEdQOTJibklQWkJKd2x6?=
 =?utf-8?B?d0VQclc2WFBPQk5peXdNcnROVFJXUFh0d3p4QU9HRXdTODBxTGljSGF1VlY2?=
 =?utf-8?B?RnBRR0VQZnV3Y050TW5BTkdZYjE4MWp6TGxPUWwzalN2dVNFQVJISzcxWXk2?=
 =?utf-8?B?N2xxN09xanJaQXNpMzAwSVhISVQwcjdHZHhEa0p5dUlwSHZKckNhS3UrYTZV?=
 =?utf-8?B?dktzYjZEQStsaUtBY2lEWkw0UU0rYWx1Y0VCYXozZFB6OXRuRk9QRVBMVGFj?=
 =?utf-8?B?aWo0NmxYak9MM3YzNVdxS0g2Z0hEQ1lHMkJlQnpueG9YOXZmM2k5dmdKREVy?=
 =?utf-8?B?dFJSdk9pZk9yMkVOSC9Wcjl1TENoTlJmV3JCZjJld0tERGM3SHROZz09?=
X-Exchange-RoutingPolicyChecked:
	u6EdFbvBq6D+j1uO6RsCBuMwSq2MXL+tEEtoD3ZTTAr36l+ec6rD0vq2rAlT1wlqap/PT96f+ANeHJostWg/pR4g47tQrj+ZMdJw0tmjyUaFFwz3k/rX+dHYw3G+CsO+Wt41+EOTgsQkOSEmivGT/e6n+pXkgurxEBfpvU0KGFwMawb0bR/4txlx/7QlB/BcU11TelVQB74QrkahQV3P8FZqVHGe+MuCgTQJTKkjGfpUKxIge9dE8dfU7tIr4s1WGYcF95SC0dm9TGyqBkU8xNHEORYxrh4qsfJDQNn5MLr7yuykIaWpsbS5znZZZFVd5LLw3g9SusBIT86y15VkRA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	39VyMUa5HWBsvLjyXE1JGVSRMZOcpEZE3BErsIfzBbmomJ/zh7OTRQGwKSQ8Xukqkn1r35uroDOiq7AhAyefivVNwxGCV7tMaDS/Db4FvoHJwb8mwJWLpdsUDTugigp1RpKedOfkk96o38mKEk3LVki8+t5bZ42SfjAhFud6EqIJtHtY12G8MP72uk2jUYhXlKMMhS9BQeum8sPqRj94iCObCxaovqYCDt/4rJWUj4tdRuglwdF8BXIs43CT29qKVKr/0YSeEmBmc83J1OmFvlH8qcvFH5WbZvJsYOo50GG9NncOLhx2hSb2vLVgcEE6DepnHcSWOmGcVs0vZPQ//YPCN265OSY1XriZ2ctrUsxxpzFAdpXzlyZmR9wWtNfQsULoqi0NopSm7YII5s9VK5wmCoILxHw7hqEULDNohev3ha7JUoA932YudZK56wMRBTrhhjwRZOgPiPX6jmpoxpjJP8m3HCMXdBaNoW/CJYhEXgb5qGojGcGF0inGDZpt81cNbzdVOuFjNFrcbDoIFYAPAaSKk2cYvjFBxlr+pp/I8vQLv3/Z+qx+MjlEemvutXOqurIhAENk/nhYd6Yjr4fQVKAjSGa6E4iQccrf4Ag=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1596a50-6f2b-4b4c-71b3-08df1fecf825
X-MS-Exchange-CrossTenant-AuthSource: MW6PR10MB7639.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 18:51:14.9647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VqudIIagtUTS1ZbVSsy1q0URqyS8lRvb8JV6TN2AlfhlH0KDyHiRsOHW1wi/jWdjdJ4dQzYM08JTqWaOFOFrkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6302
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_04,2026-10-01_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2610010075
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDA3NSBTYWx0ZWRfXy1Wp1IJI8u6U
 f9qk8BLbiqe9tW/N/bLXWu+7joWdJ+P9ibH9yc8W3peFmiuHS+6qh3pKSgTnZuOTeas0gfaOuK2
 6GJ032l21drTABBmfQzLGDvP5eFGQ4aYDBV7LCRp+ZE0uBgNHsGO
X-Authority-Analysis: v=2.4 cv=W9itxhWk c=1 sm=1 tr=0 ts=6abeabaa b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8
 a=tQ0koLjJYXGO8F86vjEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13537
X-Proofpoint-GUID: _Fw1dW_wG4U3G13YVj2ekgt-iA2s2fto
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDA3NSBTYWx0ZWRfX1+xdQlTMxjcI
 G/Y1v5UvaNnngmGvB+jZiyzLQ1J4PewS7YJavEJOBj2sPkO18twLdAQKvyQTvqpgofiOlPo7OcD
 1GxHd/bZgM1cglLz/Dn3TeTltld0pIpGpv2n6j8r/knTObYIjhuXZFSA9XeedViCgpfdLltOe/O
 GBFzSOhqHK746ixutjeej5QOzwGF13JnQc7KeOY9X3WYsi+nvUBYqrpWtth2iT+M5aUlS04bGRG
 ar48Amy0XKkF/BdKLTVZgohMjb12co0T6dPbBEaPuepU/gkU0njQpsGcEc8bxlC8CVPtfFR7wyW
 8BxXvvd6VkGEiLDVe5cKhYGA+l/YUCucWv1+5xru2HzwTJF/3Nlc1/jqbFNlr98Scqd5WOO7NFo
 YcuIM6+clAT0p2sCNgPLM5U0MMePCTRdn7ue5VUfV8/ju54hUXHUcpnW1nMLtFNMUwLJyTBgfNV
 pp+BMkFLgleEXrxWqVQUrrk2LqwzCvHwmqN8VHhI=
X-Proofpoint-ORIG-GUID: _Fw1dW_wG4U3G13YVj2ekgt-iA2s2fto

Hi all,

I’d like to withdraw this patch. The changes are growing larger and more 
complex than intended.

I’m working on a simpler follow-up patch that addresses only the 
use-after-free issue triggered when the FC cable is pulled, while 
leaving the pre-existing issues unchanged.

Thanks,

-Dai

On 9/29/26 3:28 PM, Dai Ngo wrote:
> lpfc_register_remote_port() stores an lpfc_nodelist pointer in the SCSI
> transport rport private data and takes a node reference for that
> association.
>
> lpfc_unregister_remote_port() calls fc_remote_port_delete(), which start
> SCSI transport devloss processing.  The rport remains usable until that
> processing completes: the transport can still invoke
> lpfc_terminate_rport_io() and lpfc_dev_loss_tmo_callbk(), both of which
> obtain the lpfc node through rport->dd_data->pnode.
>
> Do not drop the association reference immediately after
> fc_remote_port_delete().  Retain it until lpfc_dev_loss_tmo_callbk()
> detaches the rport and rport private data from the node, clears
> SCSI_XPT_REGD, and drops the association reference.  This prevents the
> node from being freed while the transport still has callbacks pending.
>
> An rport can reappear while devloss processing is in progress.  Before
> calling fc_remote_port_add(), acquire a provisional node reference.
> When the transport reuses the prior fc_rport and its old SCSI association
> remains registered, transfer that old reference to the new association
> and release the provisional one.  Otherwise retain the provisional
> reference because the old association was already released by devloss.
>
> Associate a generation with each rport private-data assignment. A
> devloss callback captures the generation and, while holding ndlp->lock,
> verifies the pnode, generation, and rport before changing association
> state or dropping a reference.  Thus, an old callback cannot operate
> on a reused rport after the transport has cleared and reinitialized
> its private data.
>
> Set NLP_IN_DEV_LOSS only after these ownership checks succeed.  A stale
> callback therefore cannot leave the flag set and suppress a later
> node-reference release.
>
> This preserves one node reference for each active SCSI rport association
> and closes the devloss callback use-after-free and rport-reuse races.
>
> Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
> ---
>   drivers/scsi/lpfc/lpfc_disc.h    |   1 +
>   drivers/scsi/lpfc/lpfc_hbadisc.c | 139 ++++++++++++++++++++++++++-----
>   drivers/scsi/lpfc/lpfc_scsi.h    |   1 +
>   3 files changed, 121 insertions(+), 20 deletions(-)
>
> V2:
> . in lpfc_unregister_remote_port(), snapshot ndlp->rport under
> ndlp->lock, clear rdata->pnode, clear ndlp->rport, and clear the
> SCSI transport registration flag while holding the ndlp->lock.
>
> . in lpfc_dev_loss_tmo_callbk, check rport's private data before
> using it and and use READ_ONCE() / WRITE_ONCE() for the lockless
> pnode handoff.
>
> V3:
> . Redo the patch based on Paul's review.
> Delay dropping the SCSI rport node reference until
> lpfc_dev_loss_tmo_callbk() detaches the rport from the lpfc node.
>
> V4:
> . Fix the node lead reference when the remote port reconnects before
> dev_loss_tmo expires. If fc_remote_port_add() reuses the existing SCSI
> rport, transfer the reference that is still held on the rport instead
> of acquiring a new reference.
>
> V5:
> . Fix devloss callback use-after-free and rport-reuse races identified
> in saskiko review by introducing rport association generation number.
> lpfc_dev_loss_tmo_callbk checks the generation number verifies the pnode,
> generation, and rport before changing association state or dropping a
> reference.
>
> diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
> index 51cb8571c049..4236e2397357 100644
> --- a/drivers/scsi/lpfc/lpfc_disc.h
> +++ b/drivers/scsi/lpfc/lpfc_disc.h
> @@ -141,6 +141,7 @@ struct lpfc_nodelist {
>   	struct timer_list   nlp_delayfunc;	/* Used for delayed ELS cmds */
>   	struct lpfc_hba *phba;
>   	struct fc_rport *rport;		/* scsi_transport_fc port structure */
> +	u32 rport_gen;			/* SCSI rport association generation */
>   	struct lpfc_nvme_rport *nrport;	/* nvme transport rport struct. */
>   	struct lpfc_vport *vport;
>   	struct lpfc_work_evt els_retry_evt;
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index 4f68038789b5..c47a8ccdf2b5 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -157,15 +157,21 @@ void
>   lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>   {
>   	struct lpfc_nodelist *ndlp;
> +	struct lpfc_rport_data *rdata;
>   	struct lpfc_vport *vport;
>   	struct lpfc_hba   *phba;
>   	struct lpfc_work_evt *evtp;
>   	unsigned long iflags;
> +	u32 rport_gen;
>   	bool drop_initial_node_ref = false;
> +	bool drop_scsi_node_ref = false;
> +	bool stale_rport = false;
>   
> -	ndlp = ((struct lpfc_rport_data *)rport->dd_data)->pnode;
> +	rdata = rport->dd_data;
> +	ndlp = READ_ONCE(rdata->pnode);
>   	if (!ndlp)
>   		return;
> +	rport_gen = READ_ONCE(rdata->generation);
>   
>   	vport = ndlp->vport;
>   	phba  = vport->phba;
> @@ -187,6 +193,16 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>   	    !test_bit(HBA_SETUP, &phba->hba_flag))) {
>   
>   		spin_lock_irqsave(&ndlp->lock, iflags);
> +		if (rdata->pnode != ndlp || rdata->generation != rport_gen) {
> +			spin_unlock_irqrestore(&ndlp->lock, iflags);
> +			return;
> +		}
> +		if (ndlp->rport != rport) {
> +			spin_unlock_irqrestore(&ndlp->lock, iflags);
> +			lpfc_nlp_put(ndlp);
> +			return;
> +		}
> +		rdata->pnode = NULL;
>   		ndlp->rport = NULL;
>   
>   		/* Only 1 thread can drop the initial node reference.
> @@ -202,6 +218,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>   		 */
>   		if (ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {
>   			ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
> +			drop_scsi_node_ref = true;
>   
>   			/* If NLP_XPT_REGD was cleared in lpfc_nlp_unreg_node,
>   			 * unregister calls were made to the scsi and nvme
> @@ -213,9 +230,6 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>   				if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
>   					ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
>   				spin_unlock_irqrestore(&ndlp->lock, iflags);
> -
> -				/* Release scsi transport reference */
> -				lpfc_nlp_put(ndlp);
>   			} else {
>   				spin_unlock_irqrestore(&ndlp->lock, iflags);
>   			}
> @@ -223,14 +237,13 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>   			spin_unlock_irqrestore(&ndlp->lock, iflags);
>   		}
>   
> +		if (drop_scsi_node_ref)
> +			lpfc_nlp_put(ndlp);
>   		if (drop_initial_node_ref)
>   			lpfc_nlp_put(ndlp);
>   		return;
>   	}
>   
> -	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE)
> -		return;
> -
>   	/* Ignore callback for a mismatched (stale) rport */
>   	if (ndlp->rport != rport) {
>   		lpfc_vlog_msg(vport, KERN_WARNING, LOG_NODE,
> @@ -239,6 +252,31 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>   			      "refcnt %u\n",
>   			      ndlp->nlp_DID, ndlp, rport, ndlp->rport,
>   			      ndlp->nlp_state, kref_read(&ndlp->kref));
> +		/* Drop the reference held by this stale rport. */
> +		lpfc_nlp_put(ndlp);
> +		return;
> +	}
> +
> +	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE) {
> +		spin_lock_irqsave(&ndlp->lock, iflags);
> +		if (rdata->pnode != ndlp || rdata->generation != rport_gen) {
> +			spin_unlock_irqrestore(&ndlp->lock, iflags);
> +			return;
> +		}
> +		if (ndlp->rport != rport) {
> +			stale_rport = true;
> +		} else if (ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {
> +			ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
> +			rdata->pnode = NULL;
> +			ndlp->rport = NULL;
> +			drop_scsi_node_ref = true;
> +		}
> +		spin_unlock_irqrestore(&ndlp->lock, iflags);
> +
> +		if (stale_rport)
> +			lpfc_nlp_put(ndlp);
> +		if (drop_scsi_node_ref)
> +			lpfc_nlp_put(ndlp);
>   		return;
>   	}
>   
> @@ -254,15 +292,44 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>   		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
>   				 "6790 rport name %llx dev_loss_evt pending\n",
>   				 rport->port_name);
> +		spin_lock_irqsave(&ndlp->lock, iflags);
> +		if (rdata->pnode != ndlp || rdata->generation != rport_gen) {
> +			spin_unlock_irqrestore(&ndlp->lock, iflags);
> +			return;
> +		}
> +		if (ndlp->rport != rport) {
> +			stale_rport = true;
> +		} else if (ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {
> +			ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
> +			rdata->pnode = NULL;
> +			ndlp->rport = NULL;
> +			drop_scsi_node_ref = true;
> +		}
> +		spin_unlock_irqrestore(&ndlp->lock, iflags);
> +
> +		if (stale_rport || drop_scsi_node_ref)
> +			lpfc_nlp_put(ndlp);
>   		return;
>   	}
>   
> -	set_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag);
> -
>   	spin_lock_irqsave(&ndlp->lock, iflags);
>   	/* If there is a PLOGI in progress, and we are in a
>   	 * NLP_NPR_2B_DISC state, don't turn off the flag.
>   	 */
> +	if (rdata->pnode != ndlp || rdata->generation != rport_gen) {
> +		spin_unlock_irqrestore(&ndlp->lock, iflags);
> +		return;
> +	}
> +	if (ndlp->rport != rport) {
> +		spin_unlock_irqrestore(&ndlp->lock, iflags);
> +		lpfc_nlp_put(ndlp);
> +		return;
> +	}
> +	if (!(ndlp->fc4_xpt_flags & SCSI_XPT_REGD)) {
> +		spin_unlock_irqrestore(&ndlp->lock, iflags);
> +		return;
> +	}
> +	set_bit(NLP_IN_DEV_LOSS, &ndlp->nlp_flag);
>   	if (ndlp->nlp_state != NLP_STE_PLOGI_ISSUE)
>   		clear_bit(NLP_NPR_2B_DISC, &ndlp->nlp_flag);
>   
> @@ -271,7 +338,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>   	 * rport. Remove the association between rport and ndlp.
>   	 */
>   	ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
> -	((struct lpfc_rport_data *)rport->dd_data)->pnode = NULL;
> +	drop_scsi_node_ref = true;
> +	rdata->pnode = NULL;
>   	ndlp->rport = NULL;
>   	spin_unlock_irqrestore(&ndlp->lock, iflags);
>   
> @@ -287,6 +355,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>   			list_add_tail(&evtp->evt_listp, &phba->work_list);
>   			spin_unlock_irqrestore(&phba->hbalock, iflags);
>   			lpfc_worker_wake_up(phba);
> +			if (drop_scsi_node_ref)
> +				lpfc_nlp_put(ndlp);
>   			return;
>   		}
>   		spin_unlock_irqrestore(&phba->hbalock, iflags);
> @@ -304,6 +374,8 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
>   						NLP_EVT_DEVICE_RM);
>   		}
>   	}
> +	if (drop_scsi_node_ref)
> +		lpfc_nlp_put(ndlp);
>   }
>   
>   /**
> @@ -4475,11 +4547,14 @@ static void
>   lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
>   {
>   	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
> +	struct fc_rport  *old_rport;
>   	struct fc_rport  *rport;
>   	struct lpfc_rport_data *rdata;
> +	struct lpfc_nodelist *pnode;
>   	struct fc_rport_identifiers rport_ids;
>   	struct lpfc_hba  *phba = vport->phba;
>   	unsigned long flags;
> +	bool drop_new_scsi_ref = false;
>   
>   	if (vport->cfg_enable_fc4_type == LPFC_ENABLE_NVME)
>   		return;
> @@ -4499,10 +4574,27 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
>   	if (test_bit(FC_UNLOADING, &vport->load_flag))
>   		return;
>   
> -	ndlp->rport = rport = fc_remote_port_add(shost, 0, &rport_ids);
> +	/*
> +	 * Keep ndlp alive while the transport cancels or completes an old
> +	 * rport's devloss work. This reference becomes the new association
> +	 * reference after fc_remote_port_add() succeeds.
> +	 */
> +	pnode = lpfc_nlp_get(ndlp);
> +	if (!pnode) {
> +		dev_warn(&phba->pcidev->dev,
> +			 "Warning - node ref failed. Unreg rport\n");
> +		return;
> +	}
> +
> +	spin_lock_irqsave(&ndlp->lock, flags);
> +	old_rport = ndlp->rport;
> +	spin_unlock_irqrestore(&ndlp->lock, flags);
> +
> +	rport = fc_remote_port_add(shost, 0, &rport_ids);
>   	if (!rport) {
>   		dev_printk(KERN_WARNING, &phba->pcidev->dev,
>   			   "Warning: fc_remote_port_add failed\n");
> +		lpfc_nlp_put(pnode);
>   		return;
>   	}
>   
> @@ -4510,19 +4602,27 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
>   	rport->maxframe_size = ndlp->nlp_maxframe;
>   	rport->supported_classes = ndlp->nlp_class_sup;
>   	rdata = rport->dd_data;
> -	rdata->pnode = lpfc_nlp_get(ndlp);
> -	if (!rdata->pnode) {
> -		dev_warn(&phba->pcidev->dev,
> -			 "Warning - node ref failed. Unreg rport\n");
> -		fc_remote_port_delete(rport);
> -		ndlp->rport = NULL;
> -		return;
> -	}
>   
>   	spin_lock_irqsave(&ndlp->lock, flags);
> +	/*
> +	 * A reused rport normally retains its old association reference.
> +	 * However, devloss may have completed while fc_remote_port_add()
> +	 * was running, in which case it cleared SCSI_XPT_REGD and released
> +	 * that reference. In the former case, transfer the old reference to
> +	 * the new association and release the provisional new reference.
> +	 */
> +	if (rport == old_rport &&
> +	    (ndlp->fc4_xpt_flags & SCSI_XPT_REGD))
> +		drop_new_scsi_ref = true;
> +	rdata->pnode = pnode;
> +	rdata->generation = ++ndlp->rport_gen;
> +	ndlp->rport = rport;
>   	ndlp->fc4_xpt_flags |= SCSI_XPT_REGD;
>   	spin_unlock_irqrestore(&ndlp->lock, flags);
>   
> +	if (drop_new_scsi_ref)
> +		lpfc_nlp_put(pnode);
> +
>   	if (ndlp->nlp_type & NLP_FCP_TARGET)
>   		rport_ids.roles |= FC_PORT_ROLE_FCP_TARGET;
>   	if (ndlp->nlp_type & NLP_FCP_INITIATOR)
> @@ -4570,7 +4670,6 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
>   			 kref_read(&ndlp->kref));
>   
>   	fc_remote_port_delete(rport);
> -	lpfc_nlp_put(ndlp);
>   }
>   
>   static void
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
> index a05d203e4777..6e8bb2232cba 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.h
> +++ b/drivers/scsi/lpfc/lpfc_scsi.h
> @@ -42,6 +42,7 @@ struct lpfc_hba;
>   /* per-port data that is allocated in the FC transport for us */
>   struct lpfc_rport_data {
>   	struct lpfc_nodelist *pnode;	/* Pointer to the node structure. */
> +	u32 generation;		/* rport association generation */
>   };
>   
>   struct lpfc_device_id {
