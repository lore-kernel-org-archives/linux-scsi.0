Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C180B44D6A9
	for <linux-scsi@vger.kernel.org>; Tue, 20 Jan 2026 18:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768933253; cv=fail; b=OH41OkjgORgTOoADcoUcAEe1cva2nR5FNDxjiCDLmcxqSpcN923PDJLsypVKjuIBEP7nbfhAc1zbfotZGvg4/o7nReUsIjZ81TOBibBmCxE8Yx/8rs7kZvsHAdUZuvygxP/ddeuPtqYn4nrxmM3Lo0BG+0kavaR8K82qt/ABZ0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768933253; c=relaxed/simple;
	bh=ZS2HhFQOVMI012+HSc84/DX6dp8VkQHofPhYrebSXKM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Qv+Be/2HBB9ozj0QdssIsGNyrbGZLMa7s3SSNw7bPXNizKB5yK5IaM880Qvfk+2CcwbRGyWPwOyhe9RW/YKZL6lB36SlSMwle/ogQFZPhseJv5XCtweg8fSf11byU4+XDYxtlPNC1rhsbW2cY0ETwlj4g4QZYg2kpgw3YQZVnDw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rkWPkmM2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=o6eoJ1Xb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rkWPkmM2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="o6eoJ1Xb"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60KI3Z7O3524038;
	Tue, 20 Jan 2026 18:20:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dKtBv1eNdZIzKfUF9Q66kJbwET/OHLTftkDJokAqCMw=; b=
	rkWPkmM2HGLIzgZemaoQKOC8p/lJxMdoxELgnYxYrE+iO2bxAUkmyyfTxhAwuCcc
	BArg84yMzxKOfAUvWsVF+npSHT1Yukgm/qvxiURhTXKUS/ROpXiuyrurYqTljfWh
	BDIkw6PZ+PPGxys5RjOOhJdqsCEoXaToZB5xpQtRpRYM03zRsBT/hX9Qu1kZJlIL
	ad1O5DHf0Hr2LxVJsHfBnLD5i83Y9ruFtce6PmYVYASgZzRkmdcK6AINX8f9ph7x
	syYU2KNWtzQvADIHOSNfInjrjS2N+3PKbZ+zAlzVqPrKfIWZkkSS/p+Z57QZgqEH
	uupVr5pdXVCmxONTHjjoBg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qc7gy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 18:20:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60KHeIbG032257;
	Tue, 20 Jan 2026 18:20:44 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011021.outbound.protection.outlook.com [52.101.52.21])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vdtnxg-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 18:20:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T20PVobxpVyNKOJav/WySg6XCuxlV2ipmK7QPmIZAvdy1e/kwVOVQGomQf7B8bUpMgjIrgM5WHCvchkonfRwhPYhA3hMZKjQg0TAG9opHl9+gsjzPwDjt4NdNvLL3fKxU4oXfPonzxU4Yn/2PGDx4CSa3ALyZXU6bqMKoEcioTbQe785IH0+gHAkqEnbcEdjgYfgR4nq4SoOdg4lqO2bfUj+NlOtYIERB5YVbgWZ/QXIFlU1Vhty/bBpoUF/6l4nvJOrhOa5BCIUT067uucNYtAhUhKrbGmUZh94w1HBNrvBO4P1pE5KTuP1G+fFqN05TTtmzDpozvfKV9ppZygLdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dKtBv1eNdZIzKfUF9Q66kJbwET/OHLTftkDJokAqCMw=;
 b=OKI1GKyCECfaOwZbC77fjgXi+IJ0QDEAOBGrpg1v77KXFyCqEEqFg2yvxgDDF0Mq7BmHi7liPJFXjPi+FaN/uhhjNHG3h/De0ie6dUDAFQPAVVGm+L58Eqhsx3waWDPyF/jFnq+MWtYa26XIeRVunIW8Jlmch2HS3Zg3fYJ+N+122iZgkEe62mEHaKWq9BbzFTfRKcsd9O1Wmp2lh0uI0Bawedq7A/i42INbQnuAELcCTaYMEQ9/Cr3HWFHbx8Onshl7P/qm2AtncpBoQJoAlFP1jePjC92ywmWXMWQ++l0A4A3RKXhMpgPc3J2lsdguam7o6vadK52d9/+7N5NNHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dKtBv1eNdZIzKfUF9Q66kJbwET/OHLTftkDJokAqCMw=;
 b=o6eoJ1Xbfn/rvGcFqCQKVN8Ug3q04ZB3u6NXygB/Pej2KxbXCczLH17fQLx1nlZoVZjmIOmkxzu7V8TL+fMYCg8vD/Ao3uZ7vHiwOHPpPWMldHm0EWwlbYE0PoiTutbN7M9/0gSblPBCRDG9uQkcw4pSP1r00KWbgKwyU7D+UdI=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB6701.namprd10.prod.outlook.com
 (2603:10b6:8:137::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Tue, 20 Jan
 2026 18:20:40 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861%8]) with mapi id 15.20.9542.008; Tue, 20 Jan 2026
 18:20:40 +0000
Message-ID: <8b6264ba-2e60-409c-afc9-30effbe6ef67@oracle.com>
Date: Tue, 20 Jan 2026 18:20:30 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] scsi: megaraid: Return SCSI_MLQUEUE_HOST_BUSY
 instead of 1
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        megaraidlinux.pdl@broadcom.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20260115210357.2501991-1-bvanassche@acm.org>
 <20260115210357.2501991-3-bvanassche@acm.org>
 <4247de59-248f-4e77-b3cb-7bb0ee712761@oracle.com>
 <b4d3246f-0c48-43cc-9897-804da65ea546@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <b4d3246f-0c48-43cc-9897-804da65ea546@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::6) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB6701:EE_
X-MS-Office365-Filtering-Correlation-Id: 744069f3-ab73-4b2e-a9ef-08de58509d9c
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?eVNuMHRpUUlBeG1rMEx6c3pEU3R5VlVHTTVUZGJEYUhXaGZNZ0h0amV5MFJu?=
 =?utf-8?B?UU13SFJFUkc0b0h5bXg0NS9lL0VHRnJwQ0RSbzlueVRZQldXUFhCdlkvN3lj?=
 =?utf-8?B?S3loUk5lcDhZMnowRVFRN0hBbkJXWmNmZ29MT2JsMjlxeklBTDdwM2FUN3VY?=
 =?utf-8?B?KzlZQnZ3eUIxWlB3aWxJWGF4TDRYRlRSMnFiYWRycnc4Q3NqRnltZS94TUox?=
 =?utf-8?B?dkxta0V2b211TzNJMmt0MFFMUUp1bnJZRG56bUhSRkR1NWhFZGdoM1lhRUtt?=
 =?utf-8?B?dzZjV3NNMUpaVVowQXhDZjFYVUk5Q0Z3ZlZxNzlxTGJ5MFhvMytVK1hselEw?=
 =?utf-8?B?QUx2MVBYcytiNFkya29uanZhbjRiMDkzY2NXSWdOT2VHejZtUU95blpkc0Zt?=
 =?utf-8?B?aFlaOHBzZTV3MmlJb3FOdWlIbG9vRzh5Ky9IN25FS1kyaTRxNmdvU1pCUXM1?=
 =?utf-8?B?ODJBZllldzU3ZUdVWUZ1dFFONlRJdnlGZS90SGczTVVGdi9oVHNWbXFoYm5n?=
 =?utf-8?B?TlFISzNNck4zeFhZakhyVDZDZ3VFOVl4NDRlVFF4czZzd3FtZ2Y4T3BXejM4?=
 =?utf-8?B?UExUMHYzZWNpRXd1bkQ2Q0JCWkYvVjRIWW5rVkpPVHdkeUI0YXNVSTBjTlkz?=
 =?utf-8?B?SWxYaUNuREUwSTJWaytWYXpPeVhacDh0MTE3elUwR1NzOVdiMkhYSVZ3QUls?=
 =?utf-8?B?aFR1SllpQ2lYeGpsS2ZoZzFmeDFqbWpkMWYyK0llaWU1dEd5ZGxSZ3dCVUx6?=
 =?utf-8?B?Q2hlRFBDNlY5cDlMRzgwNUZrSFYwcisxYStITEMxTm5BRExKQjRxQW96dXc1?=
 =?utf-8?B?VnFtTFNRZFhCUUdwZVVBY2tqdWxvcW1tQlNZZGZxdkhkSVZvZ1hLMElUZmg1?=
 =?utf-8?B?a240YWhzZFl1SmtBSjgxKzM3bThZTW93dzYxc3F5UUVxcUY1RkZDUTVhWXNO?=
 =?utf-8?B?c25HTG9rZmxtNkZMNzR5cDhEc2ZzR2E2NTdwdjhqSWRYd2t1QzRhVXVuelg1?=
 =?utf-8?B?Zm52SDk5RjZzREV5Q3dHY3RYcWphc05MWTJLaFhnbVVIcXVVcTBWTEVUcmFj?=
 =?utf-8?B?UnBQSzRkc2xrUXJaS0lOMitYMzdHZlJHK05DanVzcGY1QzM4OHplaVgwcGli?=
 =?utf-8?B?SndYeEdjY0xqMnIyeDBCK2ZWWTdhQ2dPMGErYXp4M2t6Mko3SmlQZkRCTnRl?=
 =?utf-8?B?cEEzRjlTQldVYi8wUnNReU1vYmNaSHRLUEhKVW9mQ01FcE9XQTJ0Q05zZWFL?=
 =?utf-8?B?MUQvMkpUQzJTTGZxSW5qenI4Ymd3NkNVRGl6TWY4aG0yaE1ucEdtallBTVYy?=
 =?utf-8?B?UmdvcGQzL2NpTzUzM3NYaGhTSHVNa3BqeVcrb0tYd29kSVVUVTA1dmZMWVl3?=
 =?utf-8?B?Y0Jab0FQTlpZaElQcU9iQUp1OWF6bkhmbXNIUlp2UWgxdXVEQTNVdDVBcWJi?=
 =?utf-8?B?MlczVGlyS0IxcUt4cy9teUhmZ3hmR3pjMDVxRnBzNk1YK1NpZHYxV0h3RVM5?=
 =?utf-8?B?cWFCMzh5eFJQdGlmWisreGVBbVM5WkluVWxIQVQ1T0NaTmsrRU1ZVEVLY1I3?=
 =?utf-8?B?dFRmUlhHamY1YVYvTkZYVkFXcm9iV3pvMTFybkUveFRsK3Y5aDd6TUcvQlYw?=
 =?utf-8?B?SGQ2UmdnSGtaOEowcm5OMU9xejZBSVBxUU0vN0hVWUE5b3BWNHF6NWM3Q3Fw?=
 =?utf-8?B?TzBzSDF6S1hqcTRPREFIemlDbXR5WGJWS3h2bTErK0ROL2dvUjdPN1FFRVpK?=
 =?utf-8?B?Qi8xSFg1Q01uTGlHTWVOV212RXFUbFVBVVF1Uy9XL0FzN3J1WVJJOUh6WWZB?=
 =?utf-8?B?alRISUt2RXhHWEo5OUltVGdTNmtkRFdSaHI0a2dYWjBzTm1QZE9wcTZTcjRL?=
 =?utf-8?B?ejBQWmFUQWJ3aStiTkRCSjJIeGE5SFlkWFJFZVdGTEpVTjN0Qk9qQzl5R1RY?=
 =?utf-8?B?U0dxdHk0V2hiUHVrLytiTU9Ga2NCVWlseDJsUzRuenJtQjZXUzBlUWNEVXBP?=
 =?utf-8?B?YndVem5LZ3lUNW9BdllGcGd4STBZbm45djJCb0JTSnU4YkcvNW0vTWo0WUs0?=
 =?utf-8?B?b0J6SmRVemM2N2JOUTczbFdaNUhCTFFwYXRSMTM3ZGcyaThvMWpKbXozbXV6?=
 =?utf-8?Q?QNg4=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?SjJvTXZZT1FETElqWjEzU21vd3BkWW1SWXVUOUNuTVk5MzBvOEVjMUl5cmlG?=
 =?utf-8?B?N0lWMW42NzFmVkt2dU9Ld2N4bEV4SnhvUHdIR0lJQS81a1hTMWh2cW0wd3dk?=
 =?utf-8?B?THVyS1EzM3lweXJ4SXlRckViMXVsWWR2QlpINTc5b1Jac1ZDQW4zeXIzMCtZ?=
 =?utf-8?B?bm1ubXlnLzZ4LzkwMjBwMXIzYUtMQS9WcUUrczJlQUl6dmpMaTFsTHJ6VkdZ?=
 =?utf-8?B?N3pLOElVKzhRdHV2SVlSYyswQTR1andCN08yRzdTY29tNjFVeS9CRldHSkJC?=
 =?utf-8?B?WXBxZFVyWUg3MG5yQkFQaE0vVnZySnBjZDJmbm1RUjU3NE96SEpiU3h1bWRB?=
 =?utf-8?B?ZzdtNFVQbXV5VXdaTDR1emZ4TEdqcEx5OFFNRjVoOW4yd2Uzb2dJOVo2MTd0?=
 =?utf-8?B?WEVEQzZucllEeWJWaTNMc0ZRbzJ0dTZjWUwySFFhNW85MUNRT28wRFcvVTA3?=
 =?utf-8?B?djMwanJzeEd5SFdxaFNZb1JJVDhMU1MySjFab005a3dlMytuUWtLVFd4RkJ4?=
 =?utf-8?B?TVRqNEVESEo3d3k4eWZ4bTk5NzZnQTA1c3hCRkhSVUZKMHlpcXNlc3pON1hG?=
 =?utf-8?B?S2lSbFZqOC85ZHlQa0FEc09iaE1JRkpLYk0yNzV3dEU1N1UxSUJDQ09XMnNx?=
 =?utf-8?B?MzY4Y2k2ajFza3UxNzVEK3N1a3JYQWVnYlFqYTZiakZ6UTV1WGJCTGlWSnhL?=
 =?utf-8?B?dUZ2Z1hTeHhSTENRRVI0THFmTWpZVVcySElGUTJmbGZhSTJwM2tHRVpvWTRI?=
 =?utf-8?B?c25aSm9qQmhuVUVKZjBLY3ExRFd4aEhFZ1FkdXVWZklRcXRlRGk3U2RCZkpP?=
 =?utf-8?B?d3hEMTNONVpjY25Nb2h4d1JRRXRTWkQ3VU1PK05iUWI2YXcydFpZMzRRZVo1?=
 =?utf-8?B?b2UyWUROTG0xYVJUWlpmNWgyK2h2c1RoRWhjU0N2NHA2MlRsUkdhVDIzOVdQ?=
 =?utf-8?B?YUc1dkRFdlJJb2NUT3lhMzNyaFhvNDA0S2MwSTFrU2tMUVNUUWJyZUg5ZnFZ?=
 =?utf-8?B?dXFQQXllSzJIL05pWXMzaUlXWnkraVZENmN1S1F3L0Ewak10MWoyck81OHNw?=
 =?utf-8?B?Vy9vK05GOENJalA3dEU2L0R4eUJqTGNmM1NIVEZVZWtudzRBSXlWSlhid3E5?=
 =?utf-8?B?U3I3eFRCRXNzTlprUFE1RlJRL1lHd25PZEQxVWNVc1p0N1EyV2pnVkdObzJS?=
 =?utf-8?B?K0REMTUrbEZsQlU5Y09WTDBzb1ZnS1BNMlpyVTFqdWo0OXpuZy82cEsrelhL?=
 =?utf-8?B?azJTUGpZQ29naU56eWQrRnhia09aVXBZanpLM3JPQXdhdnR6YnArTDFTWGpx?=
 =?utf-8?B?Wlk5LzRpam94OGxCN2QvazBRNWhiWG5CZ3BTSXRydWxHVGY3QytDUHl4WTlK?=
 =?utf-8?B?VWRZeS9ZdDFDQlFzeFpBazdHNWhSVjQ1YWdOYmtiQllMU0xmVnk0TU11NERj?=
 =?utf-8?B?VnlBWUt2T2V4R3YybWV1L0paNnRjUXFMNFhuMlV6TndKYTdnemg1d1U3R25P?=
 =?utf-8?B?eFFrY2E5V21NY1FZT1pkMTkrUVJGQ0hkbWZKQzBTV0hVcHBYa1Jqb1RGdzI5?=
 =?utf-8?B?bjZWUXpYS056NmU0eU9YUlBWeDc5dmZvWWM0K3JRUTB0NituQkpQdytuOTJ3?=
 =?utf-8?B?T2xQS0wrcXBJVllhL2NTNVF6Z0p1NHF5aUdOS1dVaEI1VnZKZXZIc1lGQjB1?=
 =?utf-8?B?MVgvc01VK01IUDJldlZ2MFVHb05KUXlwdExIRVhqN1RzNGRMcmQ1T3ZxQ3hX?=
 =?utf-8?B?eVViWUhOdTVOWDNRYTJld2gxRlZ4d3lYNTQ0WWlLY0xhdnBIeDFNRWoxSk92?=
 =?utf-8?B?amh6MDJ0c3ZzNWZRRTUwRG1IVk92cE5QY3dzWDdaV3hXMHlWeWhlUmMxaHVF?=
 =?utf-8?B?WFBKeGhCZEVkRTNQOXhadWFQTVFjL2lYdjlpWFBPSVZPdkFtWGhqdUhLNXhN?=
 =?utf-8?B?aVJTT2pITnhHL3VQbHIrNkY5NUptbzhTMEFUYSs1cEJ3S2IwVGdnN09jdnlv?=
 =?utf-8?B?dXJhaCtFd1RNMjRNbnhmcWE5bDdub0hsZ0hCZEF4L3J2anVqV1BwRjdCZFQ3?=
 =?utf-8?B?R2M4N0w2cXc2dE5KeXlaR2xMcFlXZXVmRGY3bzA1enJ3RjFYbFd6UnpZbFhw?=
 =?utf-8?B?YlFycTRwL3ZLczkzdUVXRmNSNmRvaGRQRmJvMUZUUW1WRUhmSSthTjEwdVd0?=
 =?utf-8?B?M09LZitqdFFZMVBTUklGZjhXc2FLRDdaWmZqR3A0TW1xSWtMcVpndk8reFlE?=
 =?utf-8?B?WHZaeTM2WGJOUFJLVzdOV0hlMGJqb3U1Skp1NzNPcEpYUTZucDFEV0VpTVB2?=
 =?utf-8?B?YzRTTE9LTjVHQ2x5S2VJV2MxRnRSUisxVHQxNlVINmxSNjZqVHFYZz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YBpx/LeCPVblQ7Wl2EGy2EtWCTS1lYooZNeFReTSDqdmC8t8/RyMJXKcVehpU2BVG2p1hVSUaxUDQLjuqjffqw2gAv6H8X5YKD+qH86lL7RJKObZhVG6E2q/Mpba2EGlUGgd3esRqs4vZTQsLP1MfWLtvCppTAyi12mU1Q8jgm6SoiZsDWKupdmqHfCkujTu1UHNS8SuDum+Yipusl3EfIB8oi9LYP/1Fh6GbhaW3zorVLqrD+wcT/ATF975BHxPfvWryauljcytwmVYs0yoLit+WQnr0+b+FVYnrjl8li6ZplR+YHNOpvp7sYp9DA/aCFghVU8J1imrbQdVYeX1l1ZPuiBabJ5Vijq26QqnN/isiA7hn8U0TWa55VPk6BP5UYd572ub1C9ZFd3GjZpQrebYJ6oy5QMO7PxfUpEAEhxqcv/WALCR0gIcsIFb4l40iFsboOGn2Y0sbfuIvFtDI6MSU8CSoCwkrDJvF1dpWRpU6lutV9L7S1zMKJAzHqZ1BH/KDHH8LqHPRe29xHlQ4//K/hEmJRZ4wHmyNsJv1/XEoHyiVo92Q0RVLuMX4nhADaENoGmn+b7yYmS91y2TfJ/HeeNsE4R2BCLNMEnnfsw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 744069f3-ab73-4b2e-a9ef-08de58509d9c
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 18:20:40.1153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ECU/lZSApP8bKnkjSxymoxUdSBkrIl9q6n74GhBvcL5r1ncvLImOzzfc0VwCOQdxfe0jq1jALcruYVrsQFKIkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6701
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_05,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601200153
X-Proofpoint-GUID: N1CGxFjdpwuI-GSbiiRV6wkRPhlUxMwr
X-Proofpoint-ORIG-GUID: N1CGxFjdpwuI-GSbiiRV6wkRPhlUxMwr
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=696fc77d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=8dekcahqvZX6z7_rrLEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13654
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDE1MyBTYWx0ZWRfX2yM/v9uL8zbS
 wqsj8EWgDD3CHTP5+0PR/Gg0w6Dzm8Rtqr5zINviFo2OntZrF5itTFNx7J/T4YLNqp56227A+kW
 MA5aopvzD4dCfTNvr8yMDQMNJec2r/aEy0/U+axAucfLqifzqnL7HJvgRqZSpCQ4q289pO86UzY
 /VAsjDv2hkSynWqZshqTzJ0/ViNPALyCW6nVjlv69hntUC2FGSvh+HSm3q+d2N3DB8HOXDAz418
 UuyxcqyXZe+9YE5wsEfcL1PZDixjvhAMt2nItV05hEyYIXnfS5LtZAkd5k8ttNv6PivY6Qk+p0I
 KB1oKLepXMmogw/9YBBv3WHiH6VqG8ox/F03GlfpnGYHEiR7mRDfzSF8if6i/CLzVSYGd4HNees
 OUcGYl6fscQZexYAbOpHUhvE5St/bmsStrOKfdAHWA7ACS01PJqpmDZ4x0qoFJNxhWgcA7Pc1Y/
 VtJcWq8n/FCQ9MaHeGA6S/yFtlTrmaypIpi0t7vY=

On 16/01/2026 16:52, Bart Van Assche wrote:
> On 1/16/26 4:39 AM, John Garry wrote:
>> On 15/01/2026 21:03, Bart Van Assche wrote:
>>> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
>>> index a00622c0c526..54ed0ba3f48a 100644
>>> --- a/drivers/scsi/megaraid.c
>>> +++ b/drivers/scsi/megaraid.c
>>> @@ -640,7 +640,7 @@ mega_build_cmd(adapter_t *adapter, struct 
>>> scsi_cmnd *cmd, int *busy)
>>>               }
>>>               if(!(scb = mega_allocate_scb(adapter, cmd))) {
>>> -                *busy = 1;
>>> +                *busy = SCSI_MLQUEUE_HOST_BUSY;
>>>                   return NULL;
>>>               }
>>> @@ -688,7 +688,7 @@ mega_build_cmd(adapter_t *adapter, struct 
>>> scsi_cmnd *cmd, int *busy)
>>
>> should @busy still be a pointer to an int?
> 
> The next patch changes it into a pointer to 'enum scsi_qc_status`. Do
> you perhaps want me to move that change into this patch?


I don't think that there is a need, as long as it all ends up correct.

Thanks,
John
