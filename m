Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7A11D271D;
	Thu, 17 Oct 2024 08:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729152127; cv=fail; b=nqveUQZX4RnCLx9I768pVBjAxgXQC5tLyDghPitnZ39W3DTR89PiA+CnFeYWGRAm+0vZwt+ZnEsHkL30t6jF/xxuJc+44XSMlYWEGvzowT0mJmTKcQTnHA02IZ5GMVeZW21LF84gvFLbF4J8K/m+FYrf7dAMDZ+BjX676wH1KzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729152127; c=relaxed/simple;
	bh=Zfe+GEy1lNkYE4xu3v8GNeuLQBF20tk3rSdUUXP8GPA=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NfkOSGRRr4eZo8H8WOhf0eNJ+UmRa2WKbGJm5yWwGOuBZu8VtR/1ERzA68EQvLjtOT5fbRTcFgb0qNc+3SqAxDfCfA5C+n+cH9gvGvFxiTjUyzCc/lcrA9AXdAJHPMOnskLPfv9ZhW4MlRKcdp6dbWFgUHOQdMLqvl9/uc8o8bM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ULHY+6Oe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=e0Ng6Ocj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ULHY+6Oe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="e0Ng6Ocj"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49H7fb3L025057;
	Thu, 17 Oct 2024 08:01:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=5hxkL/VApA30VFH+TP9mSHF2aGcGyln/GFGEyVjV74M=; b=
	ULHY+6OepUhv8BlhmzjiF4q30Duj7EOE93Modj2KJ5lTa9jRm3bWgiW1SWyOS1Sk
	+rC3p4ZoAZT52s3X4JFWvTqtYGW0cX4OnAfj7aH5tsGO4NIleS7aB1KGSWoNbnhh
	JGbf1jpb2k5nk1dJOvW8VgrsvKQRuPXqsUo5aTWcyJBi4gRgY89uFBYKq7BTTfnY
	8xVZ1ePxtMolQyyY66Y48slRAbY3LWuFbzU+Kw/xAkRaCfakTpislrujuDlZiJv9
	lyXNpu+N+4FbE+l0CB00XRmiFeEZa2RIiXxyZLtk791u3utGGly+XHunv98QHWCJ
	wwQ+eFWYxtEctJyX5NOhnQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427fw2ntaf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Oct 2024 08:01:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49H6wo46026553;
	Thu, 17 Oct 2024 07:59:35 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjgf7gw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Oct 2024 07:59:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UxFROIYoMyAwhh1S2VSaWaC5KAaOH8gWWJEWQjge8iek95Fa7qDS16zNilN3lAYfzPAZhEKPyY0/j3X11Ise+nCNwRJYpr4EiYmkpYsXNmHX4aoWjzaaXtpFRorQ8L2IkaWhK96ney/QQ079aKU/YLdDjwyvtGWg4Um1z6nRHJ0JZ3M2QfrPVfiwQynvF0cP7xyBs7Q4Lt4MlCNCxRUj7L7jQFIx8i61SOsownCXX7ug0gpw2v2A1xcKQGiOKOoHWxzVFEus8Va8p6zvTn1Nf5hIGtTqmHgGEJZKeDQO0T2JLfwib5bjDKPgZefCCzWdGNOx+Nu+wodZoG9xIONo2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5hxkL/VApA30VFH+TP9mSHF2aGcGyln/GFGEyVjV74M=;
 b=RAIDqiGuPKfKToVcKQaljirSE1SqHx6sg9VRwHURofkfpYtecbzVQ9Tshe7h2SwMFIcTgo7Hp3155KuXgeaJZUQZZNnczb+fOg57yC0DF4b3g+9zAwouofBoJjktmtMgynQ/5FtvxTzq6UF9kuICaC/UMjXsug3g29CD0EUEcdJ7RT3r29C0MB+cX/XQIEfYAmZSMzXRwMdZJG93m/u85myC3lsgKH3yoHWThBf9bCcKJhIyBcP87686ITtBfesI98MStw898oRIpWkozJPzqgUqg8tvnapWJ6mXzqyC4NGcvxhrEGmB20D4s5LKEz/ji2wLcKPkWX2159m42Php0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5hxkL/VApA30VFH+TP9mSHF2aGcGyln/GFGEyVjV74M=;
 b=e0Ng6OcjPjqYw9GnQb/uJsV40x9BXJcDwGmISIO7B6iq6uuylzavtZqoKDA8w6V8FKglrcIucaHw+aFlgtXeFTkCxCrPH+JoXsix2WMg+S483mTgIwXpiTbBnc94A6M3bXp7Lu8n+V/AskLkfJfrvqK0t9c2FbTUic/OzurZDpg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH2PR10MB4136.namprd10.prod.outlook.com (2603:10b6:610:7f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.20; Thu, 17 Oct
 2024 07:59:33 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8069.016; Thu, 17 Oct 2024
 07:59:33 +0000
Message-ID: <be932edb-33b8-4e99-b332-85bbfcaa904f@oracle.com>
Date: Thu, 17 Oct 2024 08:59:30 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] scsi: scsi_debug: remove a redundant assignment to
 variable ret
From: John Garry <john.g.garry@oracle.com>
To: Dan Carpenter <dan.carpenter@linaro.org>,
        Colin Ian King <colin.i.king@gmail.com>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20241002135043.942327-1-colin.i.king@gmail.com>
 <2be706cc-0944-4413-b1b0-52d34fbdadf8@stanley.mountain>
 <9151ca6d-7153-4a97-aaa2-7277fc5ffa84@oracle.com>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <9151ca6d-7153-4a97-aaa2-7277fc5ffa84@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0489.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH2PR10MB4136:EE_
X-MS-Office365-Filtering-Correlation-Id: f8c15bb8-631e-4564-c926-08dcee81a2fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K2N1N2ZBbmlkMXo1eDEvMmFvMHFlTFZJZi8wK0lZc2h6YzAxWVlwUnF5QkVz?=
 =?utf-8?B?djZNQVNyTStpZ1ZUREt6d1hSdVlpNnd2RnlvdTBrZzFhQzlBRkkwQk9FWEg5?=
 =?utf-8?B?WlVVSWxXbXY1UWNKamx1ZWJLVnJhclNTV00xY1VaelU2NVZDSHgxbWlTSkNX?=
 =?utf-8?B?MFJ3RHk1QlBOT3JrVUxoV1hRZ3pXc0g2N0xudXhJN3RIU1B2ZzVMemtFSzVC?=
 =?utf-8?B?M05lM2NrQ0xQWi9OVHdOeVlYUmlBWklDdGw4d0RwS054M3pybWRoVzkrRUkx?=
 =?utf-8?B?bDNwZXl3TGVESFllRk9MNkh6Z0ZsT1V1ZDkxMFF4cHpFb0VyMDhwUFhPekt0?=
 =?utf-8?B?QzVNSkk0M05DblNGcUtYYzNKRU5rS2o2MFk5RFhUbHg0V3hjLzZzSG1XOU14?=
 =?utf-8?B?SUEwZHJ4a20yWE90OU1rd2hkSiswSC8yWmVXWUxJYnoyQ2ZLTmZsNXYrd09x?=
 =?utf-8?B?TEhNRFZhTEJBcmN5TDlEVGpUaVZaN1BUak54UXlYYWhaZmttQlg4bjMyU0hU?=
 =?utf-8?B?UDdMcHRyVWcvcnhHM1VKSjZCK05FS0lmeElJVjd4MkpCeHVVa285dmlHd25z?=
 =?utf-8?B?dk4zVGdJbGtEbGxaYjZIcXZmRnZUbm9BY3lqcFA5ZFZUWVo4SE5ERzJwZlpR?=
 =?utf-8?B?V000Y3VXYUZudnAvUnZIVDM3WnNJZTg4VTZoUjNVMDhVWHNIZGR5aUU3NE53?=
 =?utf-8?B?Ni83UnRNT0xwdXRzUnFlMDJHYWF4cDN3WFFnVHN1YWhKRVRUaW5RL0VnejNo?=
 =?utf-8?B?a1hXVUVyMExicXhtZWE3SmsrQWF0OThVRlVmaEtLbloraWFSUmdSaUlrVTN5?=
 =?utf-8?B?M0cwakJUSnpzckw2UjRzaitlemg0Z09YOHVMaTAzRC9Od3FqekVaei9IKytV?=
 =?utf-8?B?WDJWRjFERWp2V1lpbU1MWlkycitQWHlQTVEwS0lqRVNJN2ZNZUlBQXBUZm5z?=
 =?utf-8?B?T3BGWnFsdExBanFpNmpqZmIvL3AzWWVKbnptZ0dDNzZBbWF5N2NtZHU1SWZo?=
 =?utf-8?B?OTJ3TkZpdXRjODVhUndYaDQxWERQUlZOa0RGWHdLbWV3Z0VNUG5KVXFVT1cy?=
 =?utf-8?B?V3IrYzlFVS81S28wS2VFRjBTWEM2cDVVcktrcTNmdU9rSWY2N1Z5SzVLMkhv?=
 =?utf-8?B?MXpIcjJRaDA1T1hEbGRvNzI1OVZxckhndDYxSU52b3l5NFV3WWpoTkorVS8v?=
 =?utf-8?B?bTVlc0I5VlJSeTFiRUhpd0duYlRzcmkrTzQ1a0tlKy81OTFaOCtCVXRMWFQ0?=
 =?utf-8?B?TldZQitwM1VCSlNYNWRmNXJXeFZwUGxuK0ZFSDdhOFRiSmg2dXM4RlBwZmlz?=
 =?utf-8?B?SUhGRXpQaFdsRktUU3kwb2JBVFJrbDZSbGZnMmxYYXZmVEpkM3VtS1p6VTlQ?=
 =?utf-8?B?dXdxekROaEVJYXhCcFRCcnVDODJrQmxYMHM3NTV4b1JyMk9SaU1hRis1cnhZ?=
 =?utf-8?B?dmxVMnZETXAxbHduQUk1Y0NKbFhSZlJoM2x6RHRscVFpU0p0bmJMMXNaUXNp?=
 =?utf-8?B?dGtQVDl0RkdPaXFsV0hlczBNaGNyQUVDb1dudmpYdzQxVFZKaTFaSkZDaTc1?=
 =?utf-8?B?V0FMSjViTVRua25aQnRFbHNCL2tFVFR5VHFsaVpMdVVhVGZxYU1mYWNtNVp6?=
 =?utf-8?B?enBsNThjeDI5MFc3OGZTbjlyNmlnUmlpL201blB6cXNab3lMdTdHMG9LSUpZ?=
 =?utf-8?B?bFN5WVB1UjRjQjFmTWhGWmd4emY2Z0NzZjB6d0ZYQnpFWHJ2STkyL0R0ZmxW?=
 =?utf-8?Q?nb3U3NU1Yk0zoGvxG6adqx9jiS9WUl9EU8solT7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bENhR2hGaURvME5VS1c3N2hDRHZmYnZmOXcyR1JnamlLR0tXZ0dyVHZRQk5G?=
 =?utf-8?B?QWw5WWsyWks2cmRlVzVORmRFS1ZkcXhtakNiak9CZ0FEbDRRN1MraVdxTytv?=
 =?utf-8?B?R3dyZVl6UVZQZU1MaHRmM0xEMU1MbGNna1l4c0I0djdnUE1kSlFncllWaElp?=
 =?utf-8?B?SVhraTlGN0JyRkVwSVMwNUdwNytFQTZuZmVVZlU4QS85T1JRYnNtZlM0U3Jj?=
 =?utf-8?B?S3hYVUhKOU5HbG5zZ1pkSlhtcjFyYnAxSEVqKzVra1VVR2RVZHpxdXlFNWtM?=
 =?utf-8?B?b0xkdnVsOVBmOUY0SCtxSWh1eHNqVTZzKzB1V3hZOVBRNXNUUDdONDV6YjdH?=
 =?utf-8?B?WU81YmVxSmJXcTF5aVBQeVRkUDRHcGFDaHdZaU9jWW9kNHhZMkwyYXRPN3RV?=
 =?utf-8?B?UE0vZmdoV3J2dUxGZkpXeXY1Mkw5Slp2R1p3QTJna1VKS2JHNkNBWllKVGJF?=
 =?utf-8?B?NmdJVkNYVUNUQVhxbkhka1prOXE3YmlFMW1PRXJ1Y3dFMzZjMHZoT3lTeGJo?=
 =?utf-8?B?Yjk4YWU0dGhQK292VTIvT0F2RktwUllmb1VrcWJpRllSbUZ1NGpRdGQ1L21p?=
 =?utf-8?B?WU5TOW90UGJpT2hVMkY2WEpwUjB4NTYrN2dQeGxxM1ZmNTlUZmx2SkRSVzJx?=
 =?utf-8?B?ZHN0K0J1MzZZejRtbFNmKzB2NXRUMVd4STNrbUphdGprL1MwY0oyOGU4TDJZ?=
 =?utf-8?B?V3ViMzRSSkpUTWs1VHl1YjVUVUt1dzI1QXphS1dPUWtDdDFKaCtwaTk3RVJP?=
 =?utf-8?B?cURvcEZBbS83TU5TUTVGMWxMeFBqTGdMUTVsWk11OENzVHE0eDhhakNqZTRD?=
 =?utf-8?B?ZmZhSUNSYnFtS2lQVmZ6WFZnNWI0MytxdnpoZlpIWStvTG0wdE5JVFcxZ21u?=
 =?utf-8?B?clh4bVFNYWtiRjhjbVdneHpGNlAvdUpyeFI5YlIvWEVhd3dNSU1SbGJjaytJ?=
 =?utf-8?B?SU42V2lONUwyV3NKK2UzRitoRzB2TlR2L1pzVGNEV0JZSHEyR3Iyb2w3REQr?=
 =?utf-8?B?UVdOVWZLcllFZThwYVZGdnJndnFLb3V4djVsenEwVFBiWk5aNGF4THdxdVoz?=
 =?utf-8?B?bnZ4Y1FDTUZ6OWtPNCtXTmRSeEZzNmRibVBzdStoa3E3cE5UT1FHQXJEeEVl?=
 =?utf-8?B?blA0S3ExcUI3RzhvTW1YbEZDWVQ1cS84aFcyd0xtTnlrQVJrZVlYcFpBMVl1?=
 =?utf-8?B?SXZpQytpYnhDM1VhSmtiVmNjZVRVeklQZGNDNDZMbHNuMlkzNDBrWDJYajU4?=
 =?utf-8?B?SXNpZWxSaklhVDRjdXJDL0tqSlBLayszdG02WVlyeXBlZWh2V3V3UTBselgy?=
 =?utf-8?B?a2xpbDFkMzNTQnh1dGZGaFF1QkY4S3dqa3BwbkpxOTRwN0MyWVZwR2k2L25o?=
 =?utf-8?B?aWtDZVAxWWZZTG5FQk9MTTl0c0FHamhZUkx0ZTBTV3RzcytCR1FrejBPalk2?=
 =?utf-8?B?RGMxOXpqU3VOMytscnlZd04wNXRMZVVMVXZNMTRHMEpML0tzeTVIY1lRVjB0?=
 =?utf-8?B?OUovZnBUcms3M3c1VERIRVJGVCtMQXdNQ2U4YUh6QzRHd2VwcjlpL3RMZTBu?=
 =?utf-8?B?TjJ4VHJjbE5ENVJPdkMxang1MUFCV1BscTVBWW4xZk9nWUJQQUVlbXdvVTJq?=
 =?utf-8?B?NlY2ZUdLbTBKVXBVeE1TVjRGRXBSOW92elQyRUQrQkdvYkVDR3pKSUJKWkQ4?=
 =?utf-8?B?SUVBR2h1MldEQ3J0bEdLajByM01xK1RFNkNVMkFudTAxbzErWW5EZE0wVzNp?=
 =?utf-8?B?a3ExTUw3dy9veVBINk1UTHFDQXZ1YUVvS0xQT0c2YUVUVlFnN0E5Q1RjMk5k?=
 =?utf-8?B?QmVjd0xBOVNWMDkvaUI2djNQdy92Vnh1VGx4dGFOcnowdEwxTXZlN280c0VE?=
 =?utf-8?B?TjZUMnBxZExIc21xc3RIWUxWRElzWE11d05Mc0tYeTZaOVdwdm9RSDFOWDZ5?=
 =?utf-8?B?RCtmcHJVN2VKVEg5dkRNS3FnWWNXckhzcHhNdEtoTEZzMkpTVXdVU2JGYVVh?=
 =?utf-8?B?clEvNXhjSVpiNU9mdnJHcVFEaVFJc1F2SDUyZmZmdTkzUzB5STR4L3pWUnk3?=
 =?utf-8?B?bENZTTFNT24vY05nSW9ORkRucC9wVTFUSUVSZHI5cEFlQjFsK2Z3aUFhZHpQ?=
 =?utf-8?B?NE5EN1VXVGxzRitGbldrWWNnL1d2Y3JPbUZhUzN4N0Z5TDVvTnBHd21kS08w?=
 =?utf-8?B?Mmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vL8qbfVSxYWcsdWqrE6jY6PW6dpaGzwsEQ2Y9RMHb9aMpji7+BQLuvHRNWDTc/THiohmhEqWiH8lLE9RVxdMrKYYdcjesNi5jWwXwvKMRZnarDSC86MhGQJkfuzzz3N/i3jLYeZ74//EmD2ZCxMVycFayaTViRbiJcu/7Kil51e2thEZXowz0K9/rD9Z+6biHO4SErz1E6TiAT8UIc07PiC0vhN6f5/Sxp3gUw4lniUfrR3nCPcYaAWjOCAgpP/l4t9aMeGehoHuT4Hr1dsieO58JxLGnao5P+addVUsaKKyUDvmEl1iPwIO/LglIT+dSBZz91jMtYyCZXB/3pTMdmNvdZQp/CxTE3Lpi7Jqgvgru26Q200Uetc06NFBol4EguNAb50MiV7pYLSYDOyc3//4xUn1AsnByIZpGF9Xgwmdl7JBXDvldHZaSk2WutngfUUekXMBvZkICh/KmBxkvKWd+gurpXRdicTjXj3EGMuUHuA17AGNvdmEPgEhs18W2EmUZKXGRDWmbIQAzAIoTKaL/lm2xPxRtLTU1OCYgDONmT9jJ8+O0V5eaIT7slR08PJ5gunefCI6ko9a19UK3m7JkX4sVLLUaNcNNMFqe+I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8c15bb8-631e-4564-c926-08dcee81a2fe
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2024 07:59:33.4807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lJ0/YdyU7yKx2zXKPbfoL0JzEsGrDxGWV14XIA1bTlnocaVlStpprAK79Dd2sq9kzoN549wJbCjLdoLS4IvXcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4136
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-17_06,2024-10-17_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410170052
X-Proofpoint-GUID: ABhD68_EDK_m03b6QFZVPdKaWCs0Ttk7
X-Proofpoint-ORIG-GUID: ABhD68_EDK_m03b6QFZVPdKaWCs0Ttk7

On 16/10/2024 08:16, John Garry wrote:
>>> scsi_debug.c
>>> @@ -3686,14 +3686,12 @@ static int do_device_access(struct 
>>> sdeb_store_info *sip, struct scsi_cmnd *scp,
>>>           sdeb_data_sector_lock(sip, do_write);
>>>           ret = sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
>> You would think there would be a:
>>
>>     total += ret;
>>
>> here.
>>
>>>              fsp + (block * sdebug_sector_size),
>>>              sdebug_sector_size, sg_skip, do_write);T
>>>           sdeb_data_sector_unlock(sip, do_write);
>>> -        if (ret != sdebug_sector_size) {
>>> -            ret += (i * sdebug_sector_size);
>>> +        if (ret != sdebug_sector_size)
>>>               break;
>>> -        }
>>>           sg_skip += sdebug_sector_size;
>>>           if (++block >= sdebug_store_sectors)
>>>               block = 0;
>>>       }
>>>       ret = num * sdebug_sector_size;
>>          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> And that this would be a "return total;"
> 
> Right, the function is currently a little messy as there is no variable 
> for "total", and we re-assign ret per loop.
> 
> So I think that we can either:
> a. introduce a variable to hold "total"
> b. this change:
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index af5e3a7f47a9..39218ffc6a31 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3690,13 +3690,14 @@ static int do_device_access(struct
> sdeb_store_info *sip, struct scsi_cmnd *scp,
>                 sdeb_data_sector_unlock(sip, do_write);
>                 if (ret != sdebug_sector_size) {
>                         ret += (i * sdebug_sector_size);
> -                       break;
> +                       goto out_unlock;
>                 }
>                 sg_skip += sdebug_sector_size;
>                 if (++block >= sdebug_store_sectors)
>                         block = 0;
>         }
>         ret = num * sdebug_sector_size;
> +out_unlock:
>         sdeb_data_unlock(sip, atomic);
> 
> 
> Maybe a. is better, as b. is maintaining some messiness.

BTW, let me know if you are happy for me to send a patch to fix this.

Thanks!
