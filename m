Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E4515A843
	for <linux-scsi@vger.kernel.org>; Sat, 15 Feb 2025 07:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739604484; cv=fail; b=M9nZ2GQ9D3DTwba2vJ38iVUNTKQ5HuCXCNV6MS5SiB24gcPLEDJAA1skktIWP/4r7OVlHY18pR6M0019yLk5rfnMCczJPdgcZ1XwVRIVEerOVsecsvMQbhzns55WLx7xcOcB+ZqwhxgTai1FpkJe4H/FnwZc1BelB7gCZzrP2ZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739604484; c=relaxed/simple;
	bh=Ftdf3TNkKMfaZYifqGjg1QPB/0NPlABqGA4j/KhiczU=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ilmWm32ulF0pgdOyTBQmiBG8IgvwpEKa00Xv05RzvNb/C3BZs0kPtNt5OLFmYb3qiitAZQat48yTWrGK0mykTAph5W8yq8Edfoc228E6PUMVAfJNEp+4YNPgsGD6FD4jc463JZSuDByZX6fS/uDpSwSZws2EqrAcYf0xN5ozbO0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gK7fCYAP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XeDiL+5J; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gK7fCYAP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XeDiL+5J"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51F5fiBq015551;
	Sat, 15 Feb 2025 07:27:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=LRasUjJrKJNbXGQB8N8xMLlTYqw5QVsGrsdwSooK7/8=; b=
	gK7fCYAPUYQQi4mmdM0YwLvRDH4EDyw2/nSTWxpd6mL5J6/kJaLzfWc4TkZ2XGHh
	CeFudQcZo0PtisWM/jSXdCjF+k9O/pkO2ZcK8QQ7d8EnYzD/Gs5l8luozcIG+peh
	bnFxZJBrlaK96Gv6ImNyQS4iOZLfrPrT8B9UqyfWokrRS2n24woo7Q1poRBJHokk
	PYZVbymui5p3VC0TZDGka1C1gHtS47m2BwcHhHE3/flZxFcsHXCQ4vPtwGyGQdgp
	EZ2ir6gZ2ZuR77cKlmrst0MgkfSh1lKg+cRLeOyFWKPBljUG6VxmTsVf24jY52ot
	xIJHeFkRn6aNkRM+0V6GXw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44thua85d2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 15 Feb 2025 07:27:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51F6SGju028412;
	Sat, 15 Feb 2025 07:27:51 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44thc5wjkp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 15 Feb 2025 07:27:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xfMEwRrGmhEBNTMouNnMKzNQVN1I1uvodnWzgydP30vPR3u/D7H0Vblji6LYA1v0IRgHqs7m9Dq4Y7Zp6C6524X2rk85EKNWFmCMWhELl68zC9Hv6Ifkc0xL4olp+vc3d+XIbSuy7BdUXhRQ6Gyq0zqV7KbDHKI42Rr2Mi0MrhrsZ2RNS2cMw6Y4X4sTWW08tAAUP6l81yEdjQ9SCB4fQZ98k7XgLNgMV1DN5MVnoi+mv899nXckxYsMr/Z2vtWiLxFYTq/hiHrbF+Iwux3e1flNGYhyw2g1quBaUDY6MsPZL4UXlyDAT/blrToO15hhKWlIt6VsyfOFYCN79W4neg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LRasUjJrKJNbXGQB8N8xMLlTYqw5QVsGrsdwSooK7/8=;
 b=OEBn2BXd5q/01BH2IuIgNfKMhqKjCcaI99rwVGO7iVsrz+f+YGDf4bxUpfkJs73Op+YNn7hab/7210eAsOo7G4XiHqr1O5QsvCt48JQV9CnYYIiWxS8orz1h2RvkfPos1xlCsW9T1oczWnEtjL7fC7k0KEJYJ4oCsaEq4ekjbIrQMpFNy2oOpcTvR5ty/I/vJllqMXvNCauJ2XvYd5K7g9UOmsxP1H2zGTUQ7xKlgrTvUDBwHZzAmjSAXVkGqefVjJayWMknZTyAemxVVKVmpJswUbUr5MdJUHzNye5mKpl4zG50TQlRP2IUjuEpC3uucKI5tQNfz/hMX6Fx8T553w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRasUjJrKJNbXGQB8N8xMLlTYqw5QVsGrsdwSooK7/8=;
 b=XeDiL+5JvQVmgLKWZLO1Y+oopCZ8DGUNMVI3LVAF1cS9dPjLoyC9E1TriWSADNcLkFDqkqHEqNuOw60leEEQnqw7h/0P0GgSR/DosEivrUef41PBRi1YDPpmELBfWyjZyNfLkG45kv4tRfy931ryRw0iPaQZDuRRbNxIFT3yk6A=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW6PR10MB7637.namprd10.prod.outlook.com (2603:10b6:303:246::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Sat, 15 Feb
 2025 07:27:49 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8445.013; Sat, 15 Feb 2025
 07:27:48 +0000
Message-ID: <0d0efe55-4cdb-40c0-ac52-06155ea86cae@oracle.com>
Date: Sat, 15 Feb 2025 07:27:47 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: core: clear driver private data when retry
 request
To: Ye Bin <yebin@huaweicloud.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20250214011618.286238-1-yebin@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250214011618.286238-1-yebin@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0028.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW6PR10MB7637:EE_
X-MS-Office365-Filtering-Correlation-Id: 4571be20-ed95-420c-9cee-08dd4d923fa3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S0RhOHoyNnBOOTRkd0lHa3ZoM3EyOXNMR0JadmZKMlJGdEdUTmtXeEZaaDRF?=
 =?utf-8?B?Yng0TzVtQmNvUXRQSUp4UEM4VjN4Z0RKNmpUZ2hHaGRxL21qNVE3Q1g1dzMy?=
 =?utf-8?B?Y2ZNZ2JOSERxQktBcHVQSFBqWmh4b2R6S0FjVGdIOVRuVnJ4enVQUEZDSmdY?=
 =?utf-8?B?aXJMSk5GVDBvKzBTZTlkeHh0Ny9DUFozdzFMT3p5eWUrSGczSkhjak1OeHYx?=
 =?utf-8?B?cTBNQ3Y1VXYyQVBLWldldStWV01vemxsSGwxK0hPVXBXM3pQTitTa2N0ZG8z?=
 =?utf-8?B?RGM0aDlTelQ1MWF6cXEyZjFaT1NkejVqZzEyRFozaTNhY2t0N3g5UmFBd3FV?=
 =?utf-8?B?WEF6bWhtYTR2c3JCNG1iVG5sZDVYUGQxS0F0Mm9WWkJPN2RjTDJjV1VSSDFB?=
 =?utf-8?B?WjdnQVRWU01BejkrZkRNNmJDV3pEdFBWcGVkelNKa2x2L2NzZkdQRzBFV3dW?=
 =?utf-8?B?VTNvcndrOVM5OEQrWXlqTkFOU3pyVk9pdmV6emh3M3NzdzVNYVhTV0l1KzdE?=
 =?utf-8?B?QUZkcFR3Q0c4a1htQmE2VEdJSDQ0TTR4MTd2QjUwSnVsQU80ZXAwNG1YUUFJ?=
 =?utf-8?B?WTkyRjBQZUwyNXdYL1BzemxXeU1ZK1lDYUl4L2pqbWhINnRidmRHSGFoZXRZ?=
 =?utf-8?B?RlRMaUJzK0YxY29JR2o1WU9xS0d6R0Jxc29nUVh4eFBxS0hIa0tkdS85Q0RR?=
 =?utf-8?B?LzMyTnlIZmxIWHhhS1BIbDM1MGQ5cGJGOGhMRGJXVVY2T3UrMnVyaVFlN2Jy?=
 =?utf-8?B?VHhpeUE1RW56ZGhZUkZ3cXowOHRrQ01EMGp1MVBqVVhtL1IrbW16M0ZBNllE?=
 =?utf-8?B?L2ZIVWFpOFhEbXVHTFo2eVVST0IvSGlKOFBCQnJQV3B2Y2h0eDAxeUp5NHJN?=
 =?utf-8?B?OFZSWC9CVmplcE1PTXNZRHh5RERRL3lEcFZLUmxSL3FCMUlJdTF1WUlJSnFI?=
 =?utf-8?B?VExnTjhvUWsvK3NWNXNRbTVaTG9adUhscnRFdWhTU1ptUm1ra3FKRDZ1bUF6?=
 =?utf-8?B?dHRtTXUvM2tyeWlzbVd3aW5uVWg3ZVUzaG1JT0RRSGN0eit4NVk1bERuSmln?=
 =?utf-8?B?M3QyQXBkSncvdkFrRThqQVpDZWo5WUxPNG5scG5SQWVRRzB3NUZrd1owV1RX?=
 =?utf-8?B?bHBLbXQ0SnZhSXh5QStKVXpNcHhjKytZYVRFSlQ3dVlVZUNua0tmNFJxdlh1?=
 =?utf-8?B?Qy9uakV3N3dFODRTMHJLZzVQbWJYelFmM1FLdzgzRUlOUDZ5SEMxRzRKaXg5?=
 =?utf-8?B?WUJNaVk4RXRJUnZVUEFaYU5tVGRDSmdsOVgzdjBEVngzelFoMlUrV0UxTVVO?=
 =?utf-8?B?K1lQNjhSTm01WjZOTmNaeDgwOXdkVlFTUUdpbGFyYmlEMzBqQnNpYlhpZEZN?=
 =?utf-8?B?ejBSREszTTRCamlMeXNETGdBZjdTM2l6cWpVS0RYUFZsQ2ZLNmltdk1xWks0?=
 =?utf-8?B?akF4RUtvbVNjWXVRM25vR2hCcGYvMGhGYXcydWEySm1NcDA0RkFLeFV1MHRR?=
 =?utf-8?B?Ykx6a1h2ckEzcDZiM2M5UkU2QXUxSzJaRys0bGE2ajJXVG1XZElqbTNuU3dW?=
 =?utf-8?B?NHo5T0dVZlBvTTE2aFVRVGVSS3hOTGNHdStKd0svZm1sU2pjTTFsYTl0UEQv?=
 =?utf-8?B?WXNOcXBVY3M4Q25zUlFjTEd3RTVPNTBlRzFPM0RrWUs3SXE0WmlNRUpXSTdp?=
 =?utf-8?B?b28wUE1BVW1qS212VHF6U0ZoMDR3bWFVbk82dWIvNkNxMnFPZnc5NVJCN1Aw?=
 =?utf-8?B?TENzcDlFVUJmSWM0QW1NM3VGYlEza0ZDcHpRaFNEYXRxL1Z4SDVMQXNIajcx?=
 =?utf-8?B?SExiOVRRSU1Cd3RSM2FTQjYxUGsrelVnZUlpZmEzbExuSGlnTS9yM2RSVnhq?=
 =?utf-8?Q?lnhEAfvW/UaOs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MkNxWWhqUGh2ZCtJL2xyYkpJdTc2Q2pUMFFjYVF3ZUZXM1owYjhnWGdvUnVp?=
 =?utf-8?B?eUNsOUo3ajBoQ3krU3ZFcHlEY3BDcFBsNXhVOVFIUVo0VXFlVlduYkpYRDUr?=
 =?utf-8?B?VGY0TnpDcWlPNitKVTRsVXNVZ2ZXY0lzYytsWUM3MEE3aHBWN294WVp3dzhG?=
 =?utf-8?B?QTlaQU1tditEZWJIeFFjcFFrcm5Fc2MzTkZiUjdMRGJrcjdBaFFXeTF1TG1w?=
 =?utf-8?B?OXdWVWhwTlQrd1lIL0NtWEV0RTlmOW5oMUc3QnIwUG8vSkRsMXdIWWY1T1Mz?=
 =?utf-8?B?ZWJrb002RUJFSlJyNDAvdDNwVU9VZ2dYNG9FWUhsNDAyR3VsSXd5U3h4bzBD?=
 =?utf-8?B?ekhXMHI4QmFLS2RtU0lhdWlrM2hlbklkMFFvQkRFWXNta09nVXYwblVnMW9h?=
 =?utf-8?B?c3hSejJEZmovK2pqcFVNWWM0M1FpNm5TeDkxd2srQ2pKSCtnTW1PanR2Z1pP?=
 =?utf-8?B?NWlpdVNGbTJQMUhhdzB6d290dVRWbTVNa2J6WlVpeitsdlFubEU2d3lZSHlq?=
 =?utf-8?B?alFqanZGZDFaVUxKSkwrbXkraXZlOVB1bVRRM3pYM2M4RFhrc0tmSmdqdTZN?=
 =?utf-8?B?SHZkUzN3VklXb2VWWStNbnd4U3FOaUMxOE13eVdkMXE0SW5RdjZyZ2VDQ05w?=
 =?utf-8?B?TFdnemJjR2t6OXVkOTM5NjEvZTVTNTFYY0Ftb2UvMFgwU3Znc0htU3l1NWNR?=
 =?utf-8?B?REpaYUJKMitFTUs4MGMwQlFOR2Izc3hVV05YakNkOE5SL3ZucldnVG96aG85?=
 =?utf-8?B?VG1lMDRURzZESkxaQlJGVkdUNktJTjNzN3RDWWZsT3ZFcG0zcHFFWWtucTZK?=
 =?utf-8?B?TGo4N05INUMybE9HNnd3K0oyaTduWHhPRWVnTWFNSW1VT3l2N3VOVXc2QjZh?=
 =?utf-8?B?T0FoRm5xMjRScy9LemRZdW5uMGRtZmFJVHg5Q25HVDJZVG9HY0M0R0I2WWFX?=
 =?utf-8?B?NVdPR1FQTjREaGU2dUhzQS9USzFGem9VNjFmMmRES0FoVWdGdTZNTUVPanFM?=
 =?utf-8?B?SXhYQnVXV1lVeEQrMjV0czF6aTRUdHl6Ty9Gb2lXNmcxdzFxSzJqMFFWeXlx?=
 =?utf-8?B?MTFhQnphb1RNK2k3NjBFZDFMWEIrMlJlVlI3bDhScGpMK09FT3RXSDFlQ0xV?=
 =?utf-8?B?S1pYMWU3UTlaTzRIMDhLa1Z4aVBnVXlZM2RTcVE2ZEs0RlhBeWxMNHVZTHR1?=
 =?utf-8?B?bWhtSlRHTTU3R3JtMDlhL1NaSkxyUnBUSGM2U3BiVUtGYU9YSFFxZlc5NytK?=
 =?utf-8?B?UjNxM0hHMzJ0OHdoQUlDdU53Q3I4MFlnQ25ibG1udEM5Q3lHMk9zVDVFRHZC?=
 =?utf-8?B?U2RrOHBzMDF4YmhrNkVrWVhWd2djb2VkOS96S1pCSWFzTHQvTkVBcUw3dUJz?=
 =?utf-8?B?b3paR1BvdTh3Um8wNWxZMFFicExNV1hKQ25GQlc5ektiQmMzWnlsVEtkSGht?=
 =?utf-8?B?ekZKUGZSa3VHVno3U2lFeUFya3NtRHFiM1NZOWJEUzZzaDRIbHBoTmhqRlJx?=
 =?utf-8?B?T0dyMTZYZ1lFa081ZnBDU0Q2RXhpSzdPMWtzdGdKZ1c0RHlSc0tsV293Tnpm?=
 =?utf-8?B?SGVIUDgraTg4OVAyV3FCWFl2YW1YelZCVk1TcXUya3hlK1BjOTdqYU5uYTJo?=
 =?utf-8?B?eWVBRnNWNzVzMG5xcUhzaW41TmVmV0F1MlFCdzlyQlJKb1N3R1d5UmtQMWJv?=
 =?utf-8?B?V3IxcDVZUTBKeEs4a3J2c3hHT0NMS1VxS1AzU1VvWFN2WGNHTHh5cVQ1ZDNC?=
 =?utf-8?B?QnVHU3VGaXFPT1RpcTRRNUVNeXYveGZIVEhESjNZeEdQY055QXQ3cFlNZnpr?=
 =?utf-8?B?VDNacDF1VWgzektpOGJUb09lK0Y4SjY3aWRBYUdTY1dzUGVONXBDQTFLU3gr?=
 =?utf-8?B?NGhPUDg2akc0SHZ4RWtBUy90WUJabXJUM082cVM4ZjVWb2J4YWJGZmVBT0h5?=
 =?utf-8?B?dDNPUVVwMnkzT2FKazRzTFl4aFBVNU9uS3pLaGxySW40bWU3bW83RGNiU1Ar?=
 =?utf-8?B?bmJ4TWlLVGJkN1RQUFhVT3h5MlFTWUhESmxkOVM2bW5ucVdXcFpPb0U3L2Nr?=
 =?utf-8?B?Z1Bsb3Q1UVVPUTFJL0szQUkyazZITkVxUTQwSERrek44VDZTeVc4T3RJUG9v?=
 =?utf-8?B?cDNidTZXNVVZWXNPVGJ5eW1RbEErbHdZQ21KeG1Rbk1yK0pHeHU1dTd5NWlI?=
 =?utf-8?B?UXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aYBynWTMmcbSKY88oeyNlnlzQWvGlFKzmKd0NjQbCsz+TF1VybusDcVy1e+jmseDzOmbsE0EcaXHDdwhoES3J/wGVex6AjqywJIaQqJ4YaX8LbMGogDDUjwZC5SECT4A8LiZ5MVyMA96NYPgHutpWmhIxbu9BPhPIay78YXzopAJ59m9cL6uacmxnORdqv5Wo4v9JN0MhzDaCQKNdNfrs6kgw+L89Fq2Bx4ZYkHAckGK1MCfMzdPJ9zakpR95KC2fNKQYrZrHCA6rG9J7UmjI3nsfUWBlxK1Ba1gyfstDo8OKeaq5WYRYvwqLflQy20YXlBy6Py7XNGU63RcbgrSKJi05aDlX3bhGfFo49pjEwGo46x/g4pnGyB6g7vG8UcvkL/jDsw9d2PoZ/CdCexaYcghhArIUuazodNh//IonrcqopBhpRfygzH3LmIyP2z18vbh7dsHE46iZ1eB9Hf4xlui11qC8t7uo8gC7HYF04k2csy/+aKdsbW6Zz7t0P4DeFiTX1rTUd0OJTCyCLON5eUdS+6ia5Bl8yVhdduzAHHfqnHSVHiznlqBHemkL40GkLKQykN7JAtP8FtAaCVtcgNPsUgtJWMQEmIqG7WOT5Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4571be20-ed95-420c-9cee-08dd4d923fa3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2025 07:27:48.7930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Qxpw57pexW1WR9VRd2fv7163uMwCpxMVmFH4Wk+rFufCUcifP0mS7tjSsJUkl5UY5BeQCEH6Ir48X3MhD28Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7637
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-15_03,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502150063
X-Proofpoint-GUID: b1SYxrYlCqfAAP16CGvG7lrEqPFlrxHu
X-Proofpoint-ORIG-GUID: b1SYxrYlCqfAAP16CGvG7lrEqPFlrxHu

On 14/02/2025 01:16, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> After commit 1bad6c4a57ef
> ("scsi: zero per-cmd private driver data for each MQ I/O"),
> xen-scsifront/virtio_scsi/snic driver remove code that zeroes
> driver-private command data. If request do retry will lead to
> driver-private command data remains. Before commit 464a00c9e0ad
> ("scsi: core: Kill DRIVER_SENSE") if virtio_scsi do capacity
> expansion, first request may return UA then request will do retry,
> as driver-private command data remains, request will return UA
> again. As a result, the request keeps retrying, and the request
> times out and fails.
> So zeroes driver-private command data when request do retry.
> 
> Fixes: f7de50da1479 ("scsi: xen-scsifront: Remove code that zeroes driver-private command data")
> Fixes: c2bb87318baa ("scsi: virtio_scsi: Remove code that zeroes driver-private command data")
> Fixes: c3006a926468 ("scsi: snic: Remove code that zeroes driver-private command data")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>   drivers/scsi/scsi_lib.c | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index be0890e4e706..c876b1c82153 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1669,13 +1669,6 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
>   	if (in_flight)
>   		__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
>   
> -	/*
> -	 * Only clear the driver-private command data if the LLD does not supply
> -	 * a function to initialize that data.
> -	 */
> -	if (!shost->hostt->init_cmd_priv)
> -		memset(cmd + 1, 0, shost->hostt->cmd_size);
> -
>   	cmd->prot_op = SCSI_PROT_NORMAL;
>   	if (blk_rq_bytes(req))
>   		cmd->sc_data_direction = rq_dma_dir(req);
> @@ -1842,6 +1835,13 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>   	if (!scsi_host_queue_ready(q, shost, sdev, cmd))
>   		goto out_dec_target_busy;
>   
> +	/*
> +	 * Only clear the driver-private command data if the LLD does not supply
> +	 * a function to initialize that data.
> +	 */
> +	if (!shost->hostt->init_cmd_priv && shost->hostt->cmd_size)

Some drivers do not set shost->hostt->cmd_size. And none that don't set 
shost->hostt->cmd_size also do set shost->hostt->init_cmd_priv, AFAICS.

So for those we are always needlessly checking both 
shost->hostt->init_cmd_priv and shost->hostt->cmd_size.

So how about re-order the checks:
	if (shost->hostt->cmd_size && !shost->hostt->init_cmd_priv)

> +		memset(cmd + 1, 0, shost->hostt->cmd_size);
> +
>   	if (!(req->rq_flags & RQF_DONTPREP)) {
>   		ret = scsi_prepare_cmd(req);
>   		if (ret != BLK_STS_OK)

