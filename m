Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9651629D06
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 19:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720639989; cv=fail; b=EChy1dNzKKiAcgmxcE3lI5WlHKFPwYqSlxuIuWTUVdbhCJQWF8daqPvA6GHxBJ2X9bxcOHHfeyCKTa6jm7yXBIYfWOq+BamNZY6uP4FLYRZDrwatQl7b3UWj0AuWMK4tdJi5mjkirhy/luZX1K1dparxp4hmeChE1+JbQTpjr68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720639989; c=relaxed/simple;
	bh=Q+5TKoldhaW2vzQPs1UHKM5rqtiCouQoWaDbNQUH3ZI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G0WEn66FpCW7jAnHTCfkRWj3fIst2n1WEMVyA3eSLl//AmEuw55abAqFOjtfmYg45lCWEfr3s9Wr7jDHC31lfH/ZDuiYgo0rMRqkMvkPlGAUZv2jDuPfCO1DgcRysel54XOwM9sMG6FrQSDNXTqqel5XSpQ8ZiMdENsl1E8IZlc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Xp/w9b3b; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rSmkfg4w; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xp/w9b3b";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rSmkfg4w"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46AGCrDP006147;
	Wed, 10 Jul 2024 19:33:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=v4fKrhvOlcvneA0YALxlyI/fUZ/1fNvmpMi4/XgQI40=; b=
	Xp/w9b3bKN+8PjuUYdzhnjlv5SEA3jcVsfS125maWREerginF36DBB6aNSC0qsxY
	fI28ufoZUa+3oeAqLa11MG12Zvx/x7L/bnqAjWeG2syTTFxTNsmoM7zC9zX+4TnW
	ptFkrsVJueS6zqSPIOXqu6YAKRP7hzDJEQyRUUPTR3JQ1dfOZNKrvmEn9o+l34Mb
	N38sx7IaItvtUS+aqkWByZjSVvFg0rpUh3tKdLy73ZJg8oz3IVOZ9Es1YaDODQag
	eQY+QKUeSi1A8PpMS+h/w+aUo2GTqsRnMEeL26E0dkDoxloUlYf5P1kenVoslg7X
	aYkjBqCv7S7NGqyO1Hvyow==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wknr330-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 19:33:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46AIoxdL028933;
	Wed, 10 Jul 2024 19:33:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 409vv41fb1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 19:32:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZvljErw2AQejdnU7E4IEjUe75dWEEquRBWmJ+v7HQyQSC7ZH66oBdW1jGrr9Vs/CzEgdpj+o+ob8fXpQ05vRcfZvcbRlEvQxVGxKa0Vv/BKYiHL63Bm345dsG+ivsQNwJNrI8ewwf5TOwLVghk5OOisxdfUBN4kpmMRmtZhQWaLkLnoLYQ4pEnwUYnW4QC/V+32LXyOnytp4a99rloD9JlEc9gHtm0bn+nttfwqOJSLAqVBG5EVdHNy9lvUzQxsE8lJzE7ivImZ+uuzE9AP1lwH+leaQWFk6RyrHASnYgTf/MkJlyLBvEDxSA8NQq1iCtFowuYwJ40EYUylUbRapA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v4fKrhvOlcvneA0YALxlyI/fUZ/1fNvmpMi4/XgQI40=;
 b=Seg2J/z9ztaALgbOeMzUj5f7GaLz43jxllhTAtIgFDxaxWUd4YzkS+XDPD9rQelpS+MrYb2QxzQIAWfVz7obyri9rwS0eBQDcpL1Esmm8eXc/GpsAWryUOqWwStuCHnVTRoNEmkxyGitgJyvBbRJXN04Dx8f2/qPg2zY4kFVZfn2eTgJ2Omc9B5s6/+njO7KJIB3MHGL/8OOQ7BpqfBjmHwCvsYlfMbbPImVj72KJCcHq3bXVmAmy8iekrNnl9E+bPMq29VbXUDeqOvUb1O5P69qtXR1dEWcLGUuNhD/88xCEtBhR6ssKHWaEulWjQijRAKrlozVZ8QK/XN2gaE/OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4fKrhvOlcvneA0YALxlyI/fUZ/1fNvmpMi4/XgQI40=;
 b=rSmkfg4w4UUyAwC9Gmsqlv/RdHuijt/lD3hnxwo1yepq9/Qc15awpEI7TXiuc64XNEKW+/yC2fxZ9hrTM1U5FtTupV0PUoE3BZOLRUFeh9mFN3soN6BeixMSqYZg/ZGIyXng388Uswph15l1G67AuMcN4Y+2WFwRrGzss1NyURY=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by LV3PR10MB7937.namprd10.prod.outlook.com (2603:10b6:408:21c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.38; Wed, 10 Jul
 2024 19:32:57 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%3]) with mapi id 15.20.7741.033; Wed, 10 Jul 2024
 19:32:57 +0000
Message-ID: <90f9e49c-dc56-4ea3-94f6-bd6748cea429@oracle.com>
Date: Wed, 10 Jul 2024 12:32:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/11] qla2xxx: validate nvme_local_port correctly
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com, emilne@redhat.com,
        jmeneghi@redhat.com
References: <20240710171057.35066-1-njavali@marvell.com>
 <20240710171057.35066-3-njavali@marvell.com>
Content-Language: en-US
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240710171057.35066-3-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0122.namprd03.prod.outlook.com
 (2603:10b6:208:32e::7) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|LV3PR10MB7937:EE_
X-MS-Office365-Filtering-Correlation-Id: e7e3ab89-d4cd-4915-daf8-08dca11719f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?cDRXVXlXdzdyWmpNK0p4NHB0ZUpXV2xkZGVja3ZxL2ZJSDUvOE1naHdndjVv?=
 =?utf-8?B?d0phVDd2Y2dVenVPaUxLZEw5cnBLeWhFVTF4VEhTNnMzQXF4VkcvZklVMFRy?=
 =?utf-8?B?ZHNMUWxVNnJuOEU0RXRheUlVMG50STNvellxZ21QeDNCbjFGclhJVUErcUFr?=
 =?utf-8?B?cm5BaDhLV2N0SjRLTGFaV1N2T3BKbzhEK2tXVnhCN0M2VzZrRkJYY0R0V1pt?=
 =?utf-8?B?SzJMVFl2MXpzYUVlWGdXRTByTSs1aFNiMVVJbUdzZ1l1L0FZWllyNm9DNmZM?=
 =?utf-8?B?VmdxKzI3cG5ZZ25HdnZpZGp4Z0Y1RXUvQ1grMTFtZUlMRDlydGJkVWtGQ2I5?=
 =?utf-8?B?dnRldWp5Yk96K1lCWG8wWWNUelg1WjQzVkRhWG01OVhQNmY0RVZTR01BR3g0?=
 =?utf-8?B?eWZNV2FiU3hRNkpRMDM4OW5UN0ZkZU5ETWRnTDI2czRNdXJIbVdJOGpxRVMz?=
 =?utf-8?B?OUx4cjBEUytyQ0tIL2ZDTFpUUS9sWHNYMVVzbG9vdlpoWHlLbXR6Rjd6anlP?=
 =?utf-8?B?T0ZyZUJvVWROYUlHZ0RLVEpCckYxbVhiTFZMdUNtWXZHbkJpdWFyNWdiZjF3?=
 =?utf-8?B?WTRrc1ZmV3dxSFpwUGQxRE5mT1RsczduQmlEZ283eWJQMjJJVkVPdEJQY0NS?=
 =?utf-8?B?YmdpU2FDdm43ZmprdWt2STA1eVIyQ1ExYTBHU1U4UUFQMm1CU04vRU5IcDkz?=
 =?utf-8?B?dGxmbTF2TlVVR3FqaisxZG9IT29lR2NzWTB2bnpleHgzQ2h1TW1KbFZ1NDVL?=
 =?utf-8?B?YnQwbmxCbU43NUhoci9VYnpNMlNONWFtWDVIRUdMR2U1eXhSNE9VTDYxWGVX?=
 =?utf-8?B?b0U4cFlvNXQ5Z0tGdG50SjZkbUloK1MxNG9MNW1ZdlViTjZrM2xMYWlSOXI0?=
 =?utf-8?B?UHZQdnV2V21HNW1jc21HS0ZxcEtkdkZyQ2hRTEdmcDZhc25kRDQ5T2pTY1ZR?=
 =?utf-8?B?V04welppbHlINmk5NHVFVTJrUXZQQUxuSXFvVDdWWUZlN1V4cm1Ta0ZwVUQr?=
 =?utf-8?B?cVd4QzBhVXMrdmJHdVBMT09lQjVxbVdUNjNpbThCa3lEU1V4bXVmc0w1dWhm?=
 =?utf-8?B?Ym5HVm9oR1BraFFvR2FhQXFnM1FSSVF5NzlrWFAwb0ZPSzJJazJtdG9IbjV6?=
 =?utf-8?B?aFJQeTRaRDMvVkJ4bDNKSC9qYmM0d0FmaEc4ZGhVZ0R6VzAxeERRWWxRaHht?=
 =?utf-8?B?K1JWU2IzMlVucmxyMUFqRCtKbmhEa2UzYStGVjZ4Y3d6RDdFZzA0T1VrR0Zh?=
 =?utf-8?B?Y1FhZ01RelF6czQxVFhUZkJmaUNhU1RTaXNhc2ZEL3NuMERRdjBuZ01OS3dT?=
 =?utf-8?B?K255RHFNSkpieG5rZG1vWGppaW82SzAwNm1VMWY5RWxNVDRFdXBhazBiYTZC?=
 =?utf-8?B?UGFDcDBoTXlGQWlnN3BkeHBieDhwd3BUVnhoejJ6M3E1dUV6TXRKSGZCVHc4?=
 =?utf-8?B?dmpyNHF4WkxvMUxlZ0cyMEMvSGZ0RFdqVER0Sk9IUHBEbmE3UDA0K05IR0gz?=
 =?utf-8?B?NzVvU2J1L2poMWcrelUyRDVPVVVsVGhJTHh2bTB6dTBQbGJOeVo5T1MycjQv?=
 =?utf-8?B?bFFjdjZkSDNJcHBsSDBwYVJOM0JBSnFVY1VxMmpDQy81TWZwQUJYVVZhSlFa?=
 =?utf-8?B?ZmhsT05vRnZ3bmJlclZnMHF6WWJjWkhibjZGVldMYkN0MXpjbVFTeTQ1dnRj?=
 =?utf-8?B?WldCQnI0MzBwMU4xUEZ3YVpuemdZcTZMUjRLamcycTFaaDRHaEU1Zy8xb01Q?=
 =?utf-8?B?Z3BRMWc3eVhuazU1bkNIOHR1aTdVVkJETnBpajNqL0djWUFhekNFeUhuMHp4?=
 =?utf-8?B?azlHTWU1d09qT0Joa0xDUT09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?VGdKYysxejVsbzgrZnVyUE9INng5RDN6YWJwdENiMys1T2JXbW53Y2t2U0Jk?=
 =?utf-8?B?R0ptZ2E5cndzaDRQM3dPSU1uQVBXRFZLTUxKRk5GbEdRTGRDOXpwVC9vZiti?=
 =?utf-8?B?M0hLbGFVUWNGM1Vyb1U1VjM3bWU0TVM0dEU1S0VYOXExRFRDYVV0TE5ncUtu?=
 =?utf-8?B?OUNrZjg4WU1oUnkzUWRIMWIyRGU3Zm10RFZHNi9QZ2NuajlVL1kra29LQ09K?=
 =?utf-8?B?dUdaL0RQZUNCTnhzZmFVUUpYNUJGYUdMcDc2ODRjcUZFWkxlMU5sQ28xajZi?=
 =?utf-8?B?U2xyblVObmJ1enVod1M3YnlWTGEyZGdJblpaU1llSXFmeFI4c2pFQVJrdkpO?=
 =?utf-8?B?ZGdOMlpVMFlSTitaeFhuVlo0bUlma1Y4dXFyako2T3hoOTluclB2V2JBNmwy?=
 =?utf-8?B?L2VoM3hiUUVNaEdPOHQ3YkM2VkI5RjYyZzJNVUNBRlJHVkxMWUEyVWt5eU1S?=
 =?utf-8?B?UU96d3ZIVk9EY042WkhOeTVnUHNhR3ZBTVlWdzlnN1JrZFZjUjYrZnVHWXZO?=
 =?utf-8?B?VmVjbEtZMGhQRmhMa1d0U2xHU0ozN1RsZUZGV1ZZTTZOZElUcjRIRmdzNXJi?=
 =?utf-8?B?Vk0ycXNBampBdmZrc0VTZHRBdWJ1bDNiU1p4aFh3TEhMV1MyejJnWUJPd3Z1?=
 =?utf-8?B?OHZ0ZFRYb2FXdEVucXpDcUN1KzUrVU9mUHVEMEYxSS9kQk1YeFV3N28zVmh5?=
 =?utf-8?B?dngrTmc0ZFpYNEJiY3Y5SXZLQ3d5QjNMV0lNdmNCNFVoM0RNaFBOS0pEbnQw?=
 =?utf-8?B?YWZMY3l6UHJ6L0QwY2pGRmhVYXhMbkNmNGxOTk1uY25FeUt4NmJWNVZUN0Jw?=
 =?utf-8?B?TE9aemV5YjlXa2l0MTF6UEZSMVZEdnpaY2dIWHp0WmFFbURlNCtwcDVGeEhJ?=
 =?utf-8?B?WDR6dENUTkF5RkpRd3g3YURiWFlvSTI4VEtOUGJ6U25Bd2ZCa21pT09aVGpD?=
 =?utf-8?B?U2pZdDh6UlUzNStaOHVhd24rdW8xMFUxRGViTFFjbmwraTRTSlZIT0ZaQXRM?=
 =?utf-8?B?bHNaZ1I0YmdDNi90L2FST1Jvck93UndpTHdPYnNoaHZieUIwUDMyZ1BScVNJ?=
 =?utf-8?B?bHdKcXZ1dlMrOUNrTncxTDdkWU5RYzE4TUdzQmZnc2N0bXhxcE43eXFEOUV4?=
 =?utf-8?B?UlJBL1JSNmZUY3FGMCtPbmI4M2hMV2ZxcUtwZXR2bWN6cnIvbWdNazM0NTc4?=
 =?utf-8?B?MzFma2luRFRObXZZOTdJTG1kTWRGNm5zdkJpcWJxU3RkMlZmT1czNm9kQzNI?=
 =?utf-8?B?dXZERjJHMVBYYkRsMHlSSG16c0JTU0RxdWxOUWtYUkVKM1dFNWg5aCs5bFJy?=
 =?utf-8?B?NHJJNWJKOG1yc1AzWE5rd08zZm5UQmFFaDlOTFdGRENrYjNZSVN6UHFFNW5o?=
 =?utf-8?B?TFFmUTZSM1VGbDl4Q242OXJLcjhzWitlRklmTlc1ZTFGS2VyMjM0UTNHR0NU?=
 =?utf-8?B?TFBaNmJWOEdoWGJ4UmVsa1F1SXNEM1UyY29mMjlDOFpNbFV0UFc3emJjTmpX?=
 =?utf-8?B?OU5qSndjWTFRVmxYKy9WQWRoOEd5Q2hZbTR3Y3dKdGVIamFNNWVIb3Mwc3lv?=
 =?utf-8?B?VzE4WnliQVlzODRDYktkczc4ZldNYUdPOVA3cE41ZjFzZlM1YXNMMlIrQjIy?=
 =?utf-8?B?Q2U0TjRLNHNRNC8wWWNPTEZZa1dFbDN0Z1BBZG9YMlFtQ1MvKzdIZFBDRW9E?=
 =?utf-8?B?QXRFN3BiaVUrSnlISVoreERRdkUzMVJjd28xbU95Z0x1ZzkyalZSVTFocFlq?=
 =?utf-8?B?eXBCZ0lCVHF6NzZyWXVjSnJIQ0tuQTg2T2FOZ296dlpveStzN2xyVlloVFht?=
 =?utf-8?B?UmZoVXJ2K3JrNEt0dk5VbmI0NGUybjQ5dWcvdjdhbmUvMEFJdE93bE1wQjl0?=
 =?utf-8?B?SndHbWEvRlNOSXFWaC9WV1pBalVzSWxISk5EZUlBQ05KWnRjWmZGcmp6NFhU?=
 =?utf-8?B?ZUNqNFByY3lweFlhNDMrcXEyWEU5ek44Sk5PdFpqbUxTZGpWd2UwdzVHeUlY?=
 =?utf-8?B?MUZ5WlVMdUZMbjZmVSs1UlNWMnBDN2g2MlVySjVmZDcwdkw2QWpXOXRiS2Rn?=
 =?utf-8?B?cTVGWVBQWnJlNjZRSjcyakZIWjhlOHlOeHRnZWIvcTQrT1Y4OWR3WXJXbmlK?=
 =?utf-8?B?NTk4OFhDOE8xemR0cDRSM0dmKzZrR0luK3ZqeTh0bER2clJFV0MrQ0o5OTUv?=
 =?utf-8?Q?QKukULmxZvU8oZl3H8NpTk0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	oa5nr5XA+BJe4tbbOJH2PWMLfSFnVl3R8I9fCsOKAu57D7BohTD7mkJZ1EL+n5JK295Dx5JTuiNV9Qj86SJIkhxwyIE/lqX/dDkgN39PbJYMgG0wSt2tLDJ3dnUZDQ8O8OJmzQFR8a/aZyNUyCFIWvmW8N1CQwk/e9NoO7nF353UQBP0y9sfKvejeQYJBmWYmlJuSamSJmpBf7q/u9ZQOx1HRFHB+QN2+8lTilPf5YaWKbUP2FmIEYjE9cCD9XTv+MSWnvhpjtrU7bDxqJCDrk2gBfUhLAbLhtRgwsCClwASoqrv79pcNHFU2Lf6HCW4uVLP28chPCaIuZ0QChiVN/2dFborPtqXMcyXsfDV7RDvudFU2wR406egovzm/lIvmrBKflO4Q0wjxBBIbLX4GFAmxosnKPzqhUy0L4hcFdU8Gk8C2jof7CJePSb7EXt7Vw3O7Wgjle4YLavt7zZYV6csx0amCbZ2DCpAKNB/os7uOuPu0DtJ9SN5jNQbSYI2680GgjpeR8gEPSxwGscJbF4803LwfEmaDzS6YWPAxGS+VmOtXqPxVCx6cntJH3I0Hr9UgcAXe0CfKxQKdfasMIR/7pUU1bxqnZ4elMK5do8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e3ab89-d4cd-4915-daf8-08dca11719f3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 19:32:57.3057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AmyogMWoHeDW2NcBG8Pin1u8fRiart357bqlcl2VjhusWcT8BudIhOkiwX5t+pPix9QdC3UbOnptCbOHDkpFoxMIxbSgcnzpAHhwkDsdciU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7937
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_14,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407100138
X-Proofpoint-GUID: huyHDlyJph4lYIXksF4HPFo6ULMZrJyE
X-Proofpoint-ORIG-GUID: huyHDlyJph4lYIXksF4HPFo6ULMZrJyE

On 7/10/24 10:10 AM, Nilesh Javali wrote:
> The driver load failed with error message,
> 
> qla2xxx [0000:04:00.0]-ffff:0: register_localport failed: ret=ffffffef
> 
> and with a kernel crash,
> 
> 	BUG: unable to handle kernel NULL pointer dereference at 0000000000000070
> 	Workqueue: events_unbound qla_register_fcport_fn [qla2xxx]
> 	RIP: 0010:nvme_fc_register_remoteport+0x16/0x430 [nvme_fc]
> 	RSP: 0018:ffffaaa040eb3d98 EFLAGS: 00010282
> 	RAX: 0000000000000000 RBX: ffff9dfb46b78c00 RCX: 0000000000000000
> 	RDX: ffff9dfb46b78da8 RSI: ffffaaa040eb3e08 RDI: 0000000000000000
> 	RBP: ffff9dfb612a0a58 R08: ffffffffaf1d6270 R09: 3a34303a30303030
> 	R10: 34303a303030305b R11: 2078787832616c71 R12: ffff9dfb46b78dd4
> 	R13: ffff9dfb46b78c24 R14: ffff9dfb41525300 R15: ffff9dfb46b78da8
> 	FS:  0000000000000000(0000) GS:ffff9dfc67c00000(0000) knlGS:0000000000000000
> 	CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 	CR2: 0000000000000070 CR3: 000000018da10004 CR4: 00000000000206f0
> 	Call Trace:
> 	qla_nvme_register_remote+0xeb/0x1f0 [qla2xxx]
> 	? qla2x00_dfs_create_rport+0x231/0x270 [qla2xxx]
> 	qla2x00_update_fcport+0x2a1/0x3c0 [qla2xxx]
> 	qla_register_fcport_fn+0x54/0xc0 [qla2xxx]
> 
> Exit the qla_nvme_register_remote function when
> qla_nvme_register_hba fails and correctly validate
> nvme_local_port.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_nvme.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
> index a8ddf356e662..8f4cc136a9c9 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -49,7 +49,10 @@ int qla_nvme_register_remote(struct scsi_qla_host *vha, struct fc_port *fcport)
>   		return 0;
>   	}
>   
> -	if (!vha->nvme_local_port && qla_nvme_register_hba(vha))
> +	if (qla_nvme_register_hba(vha))
> +		return 0;
> +
> +	if (!vha->nvme_local_port)
>   		return 0;
>   
>   	if (!(fcport->nvme_prli_service_param &

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

