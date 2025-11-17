Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63B127EFE3
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2025 12:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763381951; cv=fail; b=TAOqhpmNJN5m249EqAGM9WFTMZq+o1rHHjjfXU3vjhbrLLizkV2guicAnuofiOXieYp3KrH/bSBUaUAKtgLQR0HR3gR20l/dGNiBY87JJb79W1HnpYon6zI8MqZ0fLWGqGpK96BlFBUwClK/LQwbXPPLG3CHoYwkUcl/qR9jems=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763381951; c=relaxed/simple;
	bh=KCAS4rcwYMNpRqiE5lYlzlbRvt+r5QRlxNvS143DaFk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LdcfGudTpGctw+0475r54V8LFCsyrBdS0B6PYRJRwu/mI84/TNxEDiDOZk1ee365VCSiSNY1Cw5T4be+oiW9jiXLLyoGNu//kbDl3GxeavThlnWSPa58SprUc9w5JkL+RTnFm2l+aA/Y0Dy4TEZ8K1pEeZZRZgEQZEm35m4cLSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GzDHroPg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BM9w+niJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GzDHroPg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BM9w+niJ"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHC8Lbk014539;
	Mon, 17 Nov 2025 12:19:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4UZx8vi1GJpaSrEdmH6mIKyEfVegdKsEYWNTgQVBYUU=; b=
	GzDHroPg+rkvNY7CBc8943Al6d0h8SsMcYd1Pht5XZWeJqMLaDjus403icM3ZGDx
	253M2CS2f4sHMk3RlLXHZnjrpmM23QQUL7apdiEI+sW1PlLODDSc4vzQbGi3aLFN
	PUkXvcSNXlbF2LURRRppEKZAaH44AsrXBA9DLCPcBa8y+Hhvdv4/96lnHxsRkNZS
	b4zmeFEdJ//N1jOFA9S801J+tN+8GEtKrypORChEPXyU/tfNVk4tOcyq9BD8GZSJ
	INI+BhuE+jEu6K/o2JCleDsEBegmFcNfDlp7+WrdL1Jtp5tItowftIcHmfyg4wbd
	kT9BiP9+pgphmJkDcrntAw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej8j2cbv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 12:19:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHBGdYX039957;
	Mon, 17 Nov 2025 12:19:00 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010002.outbound.protection.outlook.com [52.101.201.2])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyhwjw4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 12:19:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gVL/6/IGGwJLADif6EZllZeoSnV2LbWiSnq76oxc6uR4cnlyaiVH+xJ1WiAd4knEMcRdW677SCR5TisMvkh+oGOE4a5Vul9R9hzIYZVfHLvzSFNC09iMOLzMbQpS7oXQD6AOy3wYZFvODYItzOtHTTukRcdeaihAQAMzFjxojN/PtKZiyzOQyvUc/FKuXbFZVMaG9eg6QHLGSVFe6gCvFjNYPc8C7Mb1E6gINI+CY5HhRYjmgo/UvbTAqjDM35+mdtFBIKzp9A3aUtAIn4I9AbN+RXjny/nOb+/mrQPos7W4ZrIN7QAvdYMwdQRY8N+6dC7zSjIhKjHNFMbLdRCABQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4UZx8vi1GJpaSrEdmH6mIKyEfVegdKsEYWNTgQVBYUU=;
 b=qH1awRxAR81ihaM73bCATjleMNiAo0/Anr6kQlhwVs3RgpcPkZjRTSiIDH65R+9MB3V5U27fnTvABc+Sk504AEPK6MqW+kP3Ei/Es9v8KIGfXwOkEGhP3PapgjqTe+2DZfaz0NDia/ld/gInDFTJSbl0AOu3YFqY7aRd6DRpRYWbg/GlSSP6r9YhT+aoEkVNXp5UV88o36RNZe30/yFZ7Z/ao03icnigv5dn0F6QqZT4iu71PD//3HJYDvhDVIa4rld9ce+jkyzRPNZhEHHziZSoqccnbdZI/C+LPl/VIPVQj+T6yhjnsMSUB/MoS7HPAPWYSG+O+nQepB6/33yUbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UZx8vi1GJpaSrEdmH6mIKyEfVegdKsEYWNTgQVBYUU=;
 b=BM9w+niJ/rNsG2ls5YitkALLiV6AK7hUaC+fhmsonOnLmNQlbJT9SIk6HUqd+PVtaux5OuG3+OmxOF4W6X8GL3EpXLMuqspqQDuIItVOuvTOWRluATFSUPk3nRhiYnqsGTUKbe6kS6GuLrmNV9lrIYs71LK+njn2bn95Qdj+wvo=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DS0PR10MB6175.namprd10.prod.outlook.com (2603:10b6:8:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.19; Mon, 17 Nov
 2025 12:17:56 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 12:17:56 +0000
Message-ID: <cee0f307-b875-4578-b7ed-43daef2b238e@oracle.com>
Date: Mon, 17 Nov 2025 12:17:53 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Fix a regression triggered by
 scsi_host_busy()
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251007214800.1678255-1-bvanassche@acm.org>
 <yq1h5vr4qov.fsf@ca-mkp.ca.oracle.com>
 <fe16b110-300c-4b13-bf2b-56e7f2c6f297@oracle.com>
 <540bad1d-ba01-4044-94e0-4f7b05934779@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <540bad1d-ba01-4044-94e0-4f7b05934779@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0099.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::16) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DS0PR10MB6175:EE_
X-MS-Office365-Filtering-Correlation-Id: 452279c1-a8ee-49e8-6713-08de25d3571e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K1lNTHYrcmhpQUhkUzl2R2xrYkp2YlFWdDV4K1A0U0ZETkJzSmFhVzlFbHpY?=
 =?utf-8?B?SkkzMXJqZnJxclVlL3JXNldIa1A2L1k0QjBaM054enUvb25QVjNXTmthVDJl?=
 =?utf-8?B?VGc5ZTBIWlRta1dCdDJGazJTeVNuQ2RyYVkwOE9IZy9nQjIvaU50RElOMFdU?=
 =?utf-8?B?a3ozRnI3RzNBMDFQMlBqS1VhVU85Mi9SZ09VSC9ieXVwTmhXNnFxZXFNT0lI?=
 =?utf-8?B?VnJ5dzhKWFRKYnRrN3cvRkRMeE1pUHNsSmlVQ2dWV3pBZXFuMUZDQ2xWN05O?=
 =?utf-8?B?UCt2OUs4Vk9JL1o4OXpRRml3RS9jOHl6OUFqb2M2UmJoR0xzejRDYjVzeGpU?=
 =?utf-8?B?S1ZJb1l4UjJPYkpTR21SZ2R4bUhJMTZaSjB1aWJYWnV5OWZVbUQrbW5RMFNy?=
 =?utf-8?B?RWZlcW9DUERPRVBXYktuRjlPTUh0NWpXK3FWanNGRVFWbjZFaHh2QStpS3Rz?=
 =?utf-8?B?RHBDUythVi9qbm1PWjdOOXZURXNWRUZ0Q1pzZm5TK2F3aUl5VTdyR0FKQWRN?=
 =?utf-8?B?REZIMW1adWl6VmhWNEZRZFdDbGlTUmhsNHVIaGhpTkFNYzk1amRoOVVBajli?=
 =?utf-8?B?c3B1elBheklHSHhjc1o5c0RsVzZyaG1CcTc4MzVuLzl0ZDdublBZZ2Z3emg3?=
 =?utf-8?B?K0luMDBuMjhKcUoxZ3BzcEQ0UmVqc1lKOTB3dURJYUg1cWVXR2Z4QUsySkFa?=
 =?utf-8?B?OXQ3THUybzdaQndZVTkvd1dnek9OQ2lhNnFCNTFORUlkOXVKY2ZGbkNYcmZt?=
 =?utf-8?B?c2NYR3ZDZk10RnB0QVJPVE5CWEszOFpCUTlMK3VvUHVTNHY0d0ZLaVh1QkNY?=
 =?utf-8?B?WXk2eEpVZ3FGTmZFR3lUSm5ETlZTK3BvZm9GUFUwUjlvOEd2WkNHbFBCcm5q?=
 =?utf-8?B?K3I1L1JPTjdzRVd6QkJrRFl6TUtpaTNwVG9kQTgvUGlySDVLSDhaS2YzQVpo?=
 =?utf-8?B?QVZISEVxY1hvTHNvS1E1VmVPT2UvczV5L1c1YlJwbGlqajdmR2s3L1diTGZH?=
 =?utf-8?B?M0xWd3JnSWZMTWJIbElwUWJOTWVJZE9EUExOeDFxcjQrVk1WYkpFZkNGd2ZC?=
 =?utf-8?B?SkFZVmF3am14ekZoK0JzMUNaZ1NTbHd1clRVU2dCejZ1azZ2YTdETW5ldHNZ?=
 =?utf-8?B?MWlFcW1nemRDemZBbitnRWdpbmVWU285dnR6ZWVEbHNqR2R0ei9sWklZTHIw?=
 =?utf-8?B?Z3VWS1NrdDBOK3hMZjg0cHpRQlJuTndWdGh3NjQrcTVLWWxhbTFiOEtsbkNy?=
 =?utf-8?B?dDRycGZzVklNZEg0VDRqWmM1WERzM0RPbEdZcktVUDNpeXhIVVEvOHJOSTBX?=
 =?utf-8?B?VDUzZmwrWk81bVh3OTlSclhuajhqdEhCOHNqNWRxUnpVandJM296b0FkRzVq?=
 =?utf-8?B?L2JNVUlkMlRkNHZtL3F4ZXphMFpzcElCNUJBSjdjZkxkd3BSNEpkN1F0QWND?=
 =?utf-8?B?SkFJZktITTI2K0htT0Nua1dBUGxPNHB0NXZNVVJTYnlHUy9qdWxzeVdGYnBC?=
 =?utf-8?B?ZS93aW5IZlB4S3E0bDVsZXJLYUI5T1lWcUtQMHZHSnhrZDluTzBLRm9ZT3pQ?=
 =?utf-8?B?dGpmNFZjdTV6VmtXNWNyYUNEZjk4RjdWK1oxWXV5VnNSSWE1L0k5T0dNT2ZL?=
 =?utf-8?B?TUNHOHE4b3prVEpRaFVYZ3Q5anA1YTFSTEZQdDRsZ210akVaZGRFSFhod3Vj?=
 =?utf-8?B?NVhBOXNramhQdzdTSGZXdDJQU0JQWnovR0NieTdUZ0NqNjI3dk96cDN1MXVi?=
 =?utf-8?B?dXNDOUJPMHdTalRzWm52L2NiWUtRaFRmcDA5VDRHb0VUVHhiS25ZalIvdjlk?=
 =?utf-8?B?SEEvaXFKcHpFTHMzUkc5ODkzVDd2ZUhDc01YVHJBVVhRZW9RWWZNOHVLQmo0?=
 =?utf-8?B?Qy9naWxIUzNtb0xNTUdmRXliU0hXSTFtS09WWkN0WTluWVhvSk5FemlEZXRx?=
 =?utf-8?Q?ZOnK78IGflSZpdtAS/IA+UWBD/yfczw4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bFhzcXpRWEcvUGV6eENuV2VacTFaME1kU2hWS2VLclhpelJrNUtrTm1zRUVM?=
 =?utf-8?B?RUlRRndTNW13WVFlcGJxRWtudFdZTzNxc2VUZTc0NGFVb3Y5b0JkTis3clBO?=
 =?utf-8?B?bk1La2NsSnB6ZEVRSm1TVGsrSkJ1L3VWTEhBRzdBSjhzcnpJek9QNkNFdXRx?=
 =?utf-8?B?b3FsTldhTmtYRWF0V2FiaG5xdk4rKzZ6K3dRb2hNTzNCc3IzeDYzZk5yZ0hN?=
 =?utf-8?B?RlZJWW5tb2tYd0dRUkpDYnYyVFlvbzU3WkZ5NHNKaml2clI5alJNZWx1dyt4?=
 =?utf-8?B?VzZGUE5YWlAzNFJoSmRBQll6WUxYREVFYzl5TlJzMWE2R1k1c1c2M1lkRytZ?=
 =?utf-8?B?bzR1YVF1UHdBZnJ1YmdvMnJIUjBhbWFwK2pEdXUrdFptcWc3bk4za21yc00w?=
 =?utf-8?B?eGNtN3kvcUs0eDBHNGY0Tlp4Z2Z2cXNDbjhscExoMGVDUTZxN2ZBbmUyaXVH?=
 =?utf-8?B?ME9ZTXJkUmFKa09TUWY5NEV1UnFvVGJxbGtMMVpDODhxNFo5SXM4L0NZUGpR?=
 =?utf-8?B?Ui96Q3JVcUVLUEtBTVk0RGFXSk1YOXRYNlFKMzBMdFVrVnZvU2p1NDlGNFhJ?=
 =?utf-8?B?bkZXcWVRY08rcWVORGV5THBvK2JjbTZBNWJGbWp5Zm9mZnNNSVU3VUZ0RWtW?=
 =?utf-8?B?KzBLZkVsSVB3NVhYY0FZcEVvell5OHduSTVLcTJBa2t4VTRkR3laZTBaTXF0?=
 =?utf-8?B?MjVTemhncko1UGhvRm4zcnJTNHJzZWdQWFJMNFltdlIyMVNrejU3UkVxWHc3?=
 =?utf-8?B?TkZaTFdTT2NROERSNmZkL3dBc3RBSCtkcjZNV1VQVHZneXV3YUVKa1NzWnox?=
 =?utf-8?B?SlpaQm5PNVliMkNJelFFZ2NmR2Mra0F4TkdBeVg5ZExlaVcwUG0zVENBOWdR?=
 =?utf-8?B?SW82WElKN3h1cWFLTXJuU0VrUU5CN2E4NWdMM2pqOTNDQ0Z4dWJ1emovUUZB?=
 =?utf-8?B?akZLNnhoRnh0ZDVhaHg0QkRSSEFOZFd0bzlSM3BHeXpnQTdVVGptZmZ6cVVL?=
 =?utf-8?B?V3orekYwcU9FQ0d5TCt1MFpBT1VxMWVrWEd5Q2YxYmhQWHFQRlovM1p3TS9a?=
 =?utf-8?B?c0tyRjZyOXhFQ09vRXNuWjZ4UytWOXc5T3NIWGswZzZTTk12bVV4NWhnTXJL?=
 =?utf-8?B?Q2FwNXkvN0hsRytmRVB5RkxKMER3alVKVVArcjI4cWpXa2thR0YyNElqSUNk?=
 =?utf-8?B?UDN1M214TS80SzNSU2w1SkVyOExieEh5L1NzN0hVWlluTFJ3TkJZYUFJZDFJ?=
 =?utf-8?B?d3hXWDZiakV4eVRZWjJnb1RBQUpYcEJoc3BzWXd2Z1pLZXlGeFFIbmsxR1BG?=
 =?utf-8?B?aHlXbG1iMXAwRDA3Zlo1ak84RHV1Q0QrT251OTk3dTZIWmpXdFZwNnBZcTlu?=
 =?utf-8?B?OXEvbkNxOTk1bWtoMkZtWXVOVEhlU1lGRmNFa0dQVDlSalRzN3VaVU5Hbm1M?=
 =?utf-8?B?ZjB4d1U5SHdHTjREbU5yU0NVVENwaTIwb3N6emZKZXV3SUpHRTR5TDVLa1g4?=
 =?utf-8?B?ZHdUQ3I5Mk56L3VvSElacGRaK0t1WG5Ib0phc2IvTmdLOEZHTGNqUlZRSE1J?=
 =?utf-8?B?ZUtLZWlhQ29NcWpGb3FONTZnMDVxa3NjSGo0bjNlUGFFaE5MRVFlTG55cmdi?=
 =?utf-8?B?OVB1THpmL0RjdVdzK2xrOW5nRGMxeitDZ2hEbmJyL0o3QjV2YkU3Z09OYlVM?=
 =?utf-8?B?TmJVSnJTU3dQUWRiRkdldWN4NWhSSWxicmhCc1BBVVBoMXlwa3o0dFU2SWg4?=
 =?utf-8?B?endnaVcwckVGNzRFUzIzcVpUckYxOFN1cUNyOStGQ05zM3doN2p2M3RPdURk?=
 =?utf-8?B?RWdSUDdMRVZXbjNaeFdtc2lIYTlVUEJBMUhpdENXSmhQUmJxYXpyaG50eEZN?=
 =?utf-8?B?NElxcHp0bmh0VmFSdWtuSDd3OVcwcmhJSHdCS0F5SndHZm51ckRhVkYxYm9k?=
 =?utf-8?B?WkFYQmhPNThVSzF5QmJFYWpHakp1eStLb0wybkJxanlWdGZlZnhXWG9TY1ph?=
 =?utf-8?B?Mm84MVBXbW9zQ2J6SWVYdmdZR1pXSHVUL08zMTk5Ujg0Qnp3SlYyNjZoM2FY?=
 =?utf-8?B?MXQvSXhEZS9nZ016RFg5RzRqdWMwSm1GNjAraVNzQ3N1R2NLUndmU1FsbDFJ?=
 =?utf-8?B?ZnhtRzcwVWFqTmIrcDFKb2l5UEVwSVhzSjA1SDlPdTgrd3AvUVBEcUw1bDJp?=
 =?utf-8?B?UlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vLITvkLW+nxXZfYdte2AvqMjVHBARox886VEdfAF7mwlf3l6X3+uk/WGujl9AYcbVvAMePUMtaKxTNTwPAS57plPYA4txMw8nL+omEsK0laaOO5VYpaE9hKAQnhyxt/pqo3c0vrn3NmwdJ9z4F/HZCSaoY07g/Qj95/Dg2wLBI0wPgBDAmnk+r7yM5EmvvC58xmUViVT5FQT9udJP2NAyfIMUrOJFUmfIFG4KMWp8da0dDRhnzhRC2MKDMv1QLsZnl+2lHir2RQZj/MjUPccHtWb7z9X81wzUAwekw4zjY/cLo47FrXo1pIsTEUt3P3QXD5e6Rn/QdL24zjanv/56Ptf4SK6Ig1wFRcr2m2mdO3nAykMVEXeEc9JVJhee10W/Tvo0LOImq8cCBjWntrlwPd0/xxuKTsRaUoQJPKEoZZ0D/BxCeFpgbyAew3sAnvsRsuVA3EQfBfd2ID5SGd5Hcv8Cwu6uKjy/TmZKyxSzmbQu4+a15v/D7JUx61s91VUE4Xj+rPyhTusB3TbOFf7VtWALWeFiXFME5EceL+VrBkRbsss4mXi1gqAggkdzRuYarKtc796cqTOOL0X7K/KemLILvYmXzl0mLkW/d7SuSo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 452279c1-a8ee-49e8-6713-08de25d3571e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 12:17:56.6817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E62S/vb7h6RJgA3649edD2/UaTyo9dsSYXOD8DATtPZ+IBOOPUhhTpJJI65BUKoIihMCSa05sCqJz0elqW9t/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6175
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_03,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511170104
X-Proofpoint-ORIG-GUID: j5bJVQFRJPh1Un-ioOMi-zIfUel6zxLe
X-Proofpoint-GUID: j5bJVQFRJPh1Un-ioOMi-zIfUel6zxLe
X-Authority-Analysis: v=2.4 cv=I7xohdgg c=1 sm=1 tr=0 ts=691b12b5 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=UNo0xLzX1HV0IkxSV3UA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX7mvs/4s9ZhFa
 lTgazw3ahJdKc01rCUnmmY2+FfxwmHL49Zh+EfO9QYn2yUfrCfgMsnjUlGJXDiH13riQzlMO+yp
 aXDsnczqyX4Udj+7Tj3P/xokhHQFLot9sJOqXQjRvENuzlO2cUEhNeQiY3jeJomGftN1B27MMcB
 Hnp6khz66raQZPiT404FW7KzmhVZqCB2kT3mFNZJ2dqqVEB7fd+7COIhoujtc7Idq5LvGCWdHw3
 VbgAlEPRIkSWfdeDxVIrfaBZTmVjnJ8zMZVJYut85SyGp9DfjGWigakTKGb2TIlBFEvt1goTNSN
 5wd/bkMOZNmHmInuJED9ZSo/21jaMfuabhsk0qvxUNzWPzzDzjid7/jjEeVX3QDEWiy+jCWIzSB
 /Z2fF5//P+XcdqtDS9+lTPV3PfmAwXZw/UZj6AS0ijiRNqfLR/g=

On 22/10/2025 19:07, Bart Van Assche wrote:
> On 10/22/25 1:13 AM, John Garry wrote:
>> On 22/10/2025 03:26, Martin K. Petersen wrote:
>>>> Commit 995412e23bb2 ("blk-mq: Replace tags->lock with SRCU for tag
>>>> iterators") introduced the following regression:
>>>
>>> Applied to 6.18/scsi-fixes, thanks!
>>
>> I don't think that we should call scsi_host_busy() on a shost which 
>> has not been added, so it would be nice to have a plan to fix the LLDs 
>> also.
> 
> A fix for the UFS driver has already been merged by Martin. See also
> "scsi: ufs: core: Reduce link startup failure logging".

Hi Bart,

I am auditing all the other scsi_host_busy() callsites to see if it is 
possible to backout the change in this patch (which checks tagset ops is 
non-NULL before calling the tagset iter function).

Can you confirm that all paths in the ufs driver are safe, as there are 
still some references and they involve workqueues (so not so callchains 
are not so obvious)?

So far it seems that only scsi_debug may have a hidden problem, but I am 
not overly concerned with that.

John
