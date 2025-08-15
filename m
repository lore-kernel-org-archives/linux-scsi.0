Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABD71553A3
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 07:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755244276; cv=fail; b=o0X85dyON1E+HBdJA4ZrtQfWvC8nigm5W06AXreBU2L68QfXmW1tEwFnNGoxDn8TYU9L+6sZomJSPmF9yPmQJshYl0dsc17bIVadUCDB5Orh/h+3xEFVZajHjj0V28fgKlGENuLf5m/LEOmijWE5bOfhFP+pfPTC7OWzI1DAFwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755244276; c=relaxed/simple;
	bh=LeqmObJS2cVTncdO7oWCrwRjGcDPcqT1/fMj86F4Kho=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r66xVuf8WKL54dsVL7zDhiTdByI3hr3uMZsN3yRznQULi3D61QpUAqAq0Uk5513ZqRWAIAGAnHrnEcWskS+Su3i9OLPx0zZu96syE/WIIvNs6AkdHergm4Lfy8dJhpTr/1g4LopxIOQnXgy7FT9z6k4hfUVMGleMSzJfZycLPTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WIaWtL+L; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yTZhEwwB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WIaWtL+L";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yTZhEwwB"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57F76SNj023009;
	Fri, 15 Aug 2025 07:51:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RwXrrRYPt8SBSe8nDNQ3x+p3Y1H+7zSE8nVp1zN5hhg=; b=
	WIaWtL+L6W325jJUYgpC5gE4vyfK1OmO5JeEno00J3EvTce1FlmubxKlDAAIqac5
	pqpvpKuUTLTSd4g/tOtN50sqv+n1tq6axHAjCwU5VTFiIZACeALLaz0RnrU5sNem
	okeONlQ9XUn47c+7HLbkbX5vmv6wy8agZWvwe/t25OXnDktS9Xj5tNcW1O/wrmco
	rw+5i/LOxt9FtJMkKeSLjoPZz6SZPCEpOaVkGIV2Fbui7A+yxXN1mRPUS0cuusMT
	Nhh6AUUzlAtr85Xc/kBFsOyH+cabl0T5hsHd2i7Dh0GvhjgF2dG24YpPAlBs1KQH
	G2j+0LGOe2fVget0Mfeq1Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48h7rmtq0h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 07:51:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57F6lC3o038586;
	Fri, 15 Aug 2025 07:51:03 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2050.outbound.protection.outlook.com [40.107.220.50])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsm9s3t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 07:51:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qdd0fgqpKM1jrDzDrGJ9XURyvz+aUvrsCHvRbO1zhTCa3l8Z5FxeI4rMnZmVq08LRBbdvF3R9A83gMSAqZyYFl44/yHbBjLQQICDCS6BIOu07VRBJLYXnsvPDO048Fa0RQCh+vK6LLZV5buAS5O1fR4WKG7h6bvwE9J9Mw/MGc5OpA+4/MXA0AnKWIMUL+c1mDM00ho0XxiMEJt9krsg7y/DS0h+6WFn1G3I5npec8yZwu8/tHW/1+MfdXeRERbZDXMHgelaw++19vb9yA6lOBJv+N6I/P7JiZIof/RmQRjx/r0JWe6ZK+gUrV4ryq0UzSa7oet8e7bJV18+hxa31A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RwXrrRYPt8SBSe8nDNQ3x+p3Y1H+7zSE8nVp1zN5hhg=;
 b=iIw79MxALDIc2v0mbPlJh/mrjfVEYlEXKIedNgci1jxE+exnGf4ysY+ipG/5PqPSvBwuNCG58uHs0SnXTuGVg+6aiUhsI6Xz60djHHQcAG4Fq31xjQ0fccyF1f+KDxaCg8apNoZqfbPZafKdoe7RuKObq58wyv1EopHu5nYx3w0VhNm/W/4YGkhlUPMxdRiiKeA3mMLsRekL69geweo8yTYJPjV7wYYSohYqla+oVD2iNJTkN8H+nRRMXGlIibFl+egGTaXvVB0tDavcDeu27XzhGLjbrYnr+x7dCQ6AadNqOB2ekV7kFW4CBLPvSfCxUfNTiFLLP4p9k3x+d2j1Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RwXrrRYPt8SBSe8nDNQ3x+p3Y1H+7zSE8nVp1zN5hhg=;
 b=yTZhEwwBQLxeWblw7Fz7SXzRFeRYLEY+5UiVgOWRBVDElA21/MJ1IOkNmT7yWwAaoNQWdJrc/Xb753xbwr3f0OQ88yNLzV/kFgQ6Tg35Ql6soKEvKcfdqEuJnuiA0vzJ35rBHkhCcX1b0QGUa+Aikr4agYRBUL8rocVCI0Ua2y4=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ5PPF972B28679.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7ba) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 07:50:59 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 07:50:59 +0000
Message-ID: <71a41bd0-1243-4fb3-ae83-c2cfae229296@oracle.com>
Date: Fri, 15 Aug 2025 08:50:56 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/30] Optimize the hot path in the UFS driver
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, hch@lst.de, hare@suse.com
References: <20250811173634.514041-1-bvanassche@acm.org>
 <d5cd0109-915f-4fe7-b6c2-34681b4b1763@oracle.com>
 <d4151040-ab1a-4b3c-b5f9-577e907b43fc@acm.org>
 <ff0705fe-0bac-408e-a073-a833525dabf8@oracle.com>
 <e651aa7e-aad2-4e4e-afff-3e89a61f13f9@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <e651aa7e-aad2-4e4e-afff-3e89a61f13f9@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0210.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::11) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ5PPF972B28679:EE_
X-MS-Office365-Filtering-Correlation-Id: 440801a4-1052-4bf9-8433-08dddbd07957
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V2pjNmNUa0Zyd1AwMkpYNE1KenMzY1U5MzlMYzNINXB2S3QyY3lVR2JzanJJ?=
 =?utf-8?B?T1Z3dTVSejlqUUROMGw1anYvVU5FcFRJRFBPcXpoamxmY3hGTlpCQTBjcE1m?=
 =?utf-8?B?cjNKQnVZZ1Vrb2NoL3VyUnB2Sk9rK0ZTVVhQSDV1Q0QrcmUxMjNQbEhKMnNi?=
 =?utf-8?B?U1NmKzdyZGVweklMYU5YMVpRVFlocUxiTGRqVU9lVjlQbGVlM3EwcWxmTTR4?=
 =?utf-8?B?dytUdmdOeTFsV2p2eWZtWTFkaWV5dTNGRVVmWlF3WDE4KzVLalN6V1U4d2F4?=
 =?utf-8?B?YnJvT3UzUU1pRFR6M1Roa1NCSXdvMHRvaDMxZlFLb2dkOHlsNTdwYVkvbHFr?=
 =?utf-8?B?cEpKU2pwbXNqQnlYV2pwaGNoUng2NVhzUGJhMk80RmFDdnpldVBmQk9ESURJ?=
 =?utf-8?B?YkpRYkVNbTlhYUFHT1dpLzV3RDRWQVU5WFBtK0VwUGpJWTRNVitjbmVqSFds?=
 =?utf-8?B?MnpGU2hoa1IwSHVqWUg5R3FDNVI5OXNNTmNzYVZLOWpqTkY2Tm4zcTlEOFc1?=
 =?utf-8?B?NjliM1N3aGJBZWg4WkZrWEFJL0hKUkVZQ3NRSHpGbm4vWHlQTDdxY0pQR1Ns?=
 =?utf-8?B?ZDFtZEM1UCs0Ykg4YVZUb3dac28yeG8zZVk2akZWZVNoeGxyMVNqSWgrQnRV?=
 =?utf-8?B?RkJaQlk5bGo3YlZpek9YaVNwRVhCdDZsdys1TEZYb0RHUVlKY0pCV3FGOEYy?=
 =?utf-8?B?QnlId3JXU3BxWWNaY1VoV2xQUlU4VzdVL0xabll1WVNaMzRIakhLRHZMdy9Z?=
 =?utf-8?B?aHp5NkhndXhrbkVEdXBYRW8yNVZoRDMxanBOYkczM2RCUFJJQXgxZFFJb0Rj?=
 =?utf-8?B?SUZ0dDViQ3B1Y1lCVDMyNXNiSEhNT3lPUzJ1KzlvRitKT1JwZVR1WU1hVWJ0?=
 =?utf-8?B?bGNLdlVwVS81V0dTMGdzVkUydXNVRmMzYkdHSTdhTTJXZ1dxdkY4dUN0cVNn?=
 =?utf-8?B?MFBTUVpuU2FIQW9JU3JnSlluam9tcW1RU05TQm9jOWEzMi9lR3FiMUZOSWR4?=
 =?utf-8?B?TE9WNVZidWxzZjNSM1FsaTVUazhrNE94N2tXZDZOZkJUWkhyWjhSYm9DaFBR?=
 =?utf-8?B?Uk0xR21pU2tQK3pLYlUwNVpRZ1VFaE9tQUpKS2tDREpNRld5b1g4bFQ5enFx?=
 =?utf-8?B?YnlpeGwxZU5GcUV4elFhRm9NdFNyYkpiS3JDZ2tuNlhva2wxMSt4b3QvZGpp?=
 =?utf-8?B?SzJ1WWkvNm1hem9Sa1d6ZXhiVEFKUC9ITG9HdnIzSUtaUFZHRnlLT0E3SSs4?=
 =?utf-8?B?TURpaWt3dS9Bdm9HVnB5U3RRZ2REaHdaOXhWS0l5U3dIVHg4cTB2cXp3UW1V?=
 =?utf-8?B?cUl5ZVlORlRZSjMrWk12STEzcGlTVXhWNTBNZlZqekVxSFFKRFVLS0EwYlRj?=
 =?utf-8?B?eCtxNlpSSmxXdzRGMHBHQ2dHcWRDL0NEbmNVTk5KSnQ3UGxmOWxkRjFzZ01G?=
 =?utf-8?B?eVNEbHIvQ3N1Qks4NEk4YVo2Nks4c3BMbE5GeFJsTjlEcXNDWVpaK2JGZDBz?=
 =?utf-8?B?aVBHMHp4M0orZXl0c05tWGlPRDVvVGZWUTJTRXpjeWg1VDlUWVFxOTl3NlBh?=
 =?utf-8?B?VU1uMUpuWGwwbUhKTVFselQ4UURoenVjeDRPRlBYNm81c3VmOGtXNlhleTQv?=
 =?utf-8?B?T2srWFNNOXdPaG5SWFZteG8wL1JSQ0F4MWxObkNQK0ZzbXU1bjdGNUVMT1h2?=
 =?utf-8?B?T2FzZ0VadGNVUlBQVisyRTdQU01KRW5LQm5WQ1J6eEdoV3g3ZWpGazg4Tldq?=
 =?utf-8?B?MmFHT015RDU5aXhFUUZIazY2R29ZQnVkOWllbFQ3encrNFVScDJESEI0WTZ4?=
 =?utf-8?B?QUxwSEtqQXhqOFZPRVl0dlpMNTQ4NFFRUnROMDZEWW5tdkxTOUh2R1k3V0wv?=
 =?utf-8?B?eGhuSmVITWt4OHp2ZlZBL3p6cXd5KzUxRVd4SlJmUVlKbWlBd2lmL2R5TVls?=
 =?utf-8?Q?9Q8TXofVUpc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YXk0ZmJxOVNtWFZkZFhkSlNjNzQzWVB6R0dZeUg1THVRK0UwaDNOUnFkUFps?=
 =?utf-8?B?cWk4bnZWcExYRzhBZVBhRmVXUkFwaFl2YVJmRXc4YXhCTzR6elYrS1JJOG1G?=
 =?utf-8?B?QzNpWXFqUDBpYkRYc0dvTEd6TWduU1VkbGc0STFsTTk5Q0pJTHRnV3NTajFu?=
 =?utf-8?B?NnBwbUtRcnlWOUpkVFQyVWxCeGJOS0l4UmxMTlZjOUtsMy9NTU9hSk9SUzlv?=
 =?utf-8?B?bEVnaDljZFk3Vk5xQXQ5MEgwNGlwaXpBa2xlbStUZ2ZLMjU4dllidUREc1pa?=
 =?utf-8?B?L0djM2QrM0s3SW9PdGQ2RW55OW1VUEtWbUwrcHFLY1NQNTJiSWpPbGhMekZn?=
 =?utf-8?B?SVNkRS9DYVovNGI2VzVQL3ZlVWd2Uk1qeGJ4Yk9mN2xCdkVvOXQ3bGw1elZs?=
 =?utf-8?B?VHZqZ25ndk5ULzhLVXhia3NWb0xjVTRLenJDMXNvWnV4MjBYcmg5dDN0R0Qv?=
 =?utf-8?B?QS9EbnRodEpFOHUxZXIwWnBlT3YzU2lxYldrQ3NrbDRrU25DUXNSV2dXZThx?=
 =?utf-8?B?bU05UGEzbk4ya2RNcXRlYnV5K0FWek1RNSs4eUxCUndGVFFiZm9LcFFxNHVp?=
 =?utf-8?B?Z3lTRDNKR1d6WmJtaDRJcWd4TUkvbVMyM2pzL1gyZlZPSDkvSE1HWE9PWkpW?=
 =?utf-8?B?N21CdTZXdTVLN1hGNFVoSUpzaEp2eE5OYjRra2RaOS83WG5qeEZLWWRsTzR0?=
 =?utf-8?B?N1lCYU5kVXI1U1c2K2QyT053SEFaMDM0MG10M1JjdlR0UjRadTFxZlFlUVRG?=
 =?utf-8?B?dC8zRjFIbFZiei9JRjhaT1IwNzBoTHhaRjAvTU9NUHpPOG5MN3VmbGs1RVVI?=
 =?utf-8?B?cElLYjRFZDB2YXdMTzBTNzNDQ1hXWXorSFNobnJnWUdKQi94Wml0TUd5dHVO?=
 =?utf-8?B?Zk81Q1NvRWpKSVRLMnZMWGRocHhaa211elRWSmk2R0pVaWZsbDZvRUJTdGRY?=
 =?utf-8?B?RmFUcitpYnRnRTh2TDVtbzdSTG1wK3k5RDVBZWpiMy85Tm1UbW5qSm9SWWh0?=
 =?utf-8?B?VVpiWUpEN01YQ1UzaXhKVXZwQlZ1VU9IbE11Qm83ZWRWMlRwbFl1SElOWmVw?=
 =?utf-8?B?RXA4aHYwQXlxcVRYcVZ2NkxZb2JwV3hXazdRWnFmc3VjZWJIV0hGV0Z2YTJt?=
 =?utf-8?B?Ulh2MzBIdEJ1ZUIyN2JmTStrVHZ5b1hFS043ckk4SkFVb1lkUkwzUXI3aTNN?=
 =?utf-8?B?MmtUbm5ITzVOZHJQUWk1VFFQVFZzQW1PMWhwL3Ryc3k2aHdKSHgxNm0wWTBm?=
 =?utf-8?B?aW91THliYjVxQ1BBQWdFUlplMXI2TlZaMGJOS0lIY3daNHhWcWRpN0dxdy9I?=
 =?utf-8?B?QlZ2SzUrbmlBVnU5UThDN0JTY3lVUWRJUnhKZ0pjZHVsR1A1aTYxTm5vbHlH?=
 =?utf-8?B?MnUwR2xVczlJQncyK2dXcFoxVjU5Sjh4QTBYT3Bwb09kYllUa1ZVRXp2SDY0?=
 =?utf-8?B?ZzlxN2RHM3AzRjREdTZTT0FNdWszcDJGdDVyZTVnbTdJaU9FY0pXRU1BcWpm?=
 =?utf-8?B?VWRuc2xEeHgzL2x6T3YzSWI3ZTYvSTNMUVJ4THd3NXI3cXpxZzBwZnBiR1Bp?=
 =?utf-8?B?ajBuRzh1N0VJYmxTN0NhZlg1V05KRjBndXFiZnF5NnR5Tmo3TlQrUG12RFdo?=
 =?utf-8?B?bG5nKzYxSWhhc3d4dkVIYXFIYWM1dnI1L1UwbUVQZ3YvRnc5eW5mY2xOZjhv?=
 =?utf-8?B?Nlpqb2p1bHE4bk5hMElHZ1NJSnF4SC93WGtPa2lwemhaUmNOQzVNTGlGN1F3?=
 =?utf-8?B?RWhTcnB1dzVVbVhyZmNjNDYwOU1rbHhPZXpBUm1ML3FmOGw1ZSs2Rm81Vmkx?=
 =?utf-8?B?WWhoTjMrelBpWXVBNVBlQklkUDBtR1JlNmJnY0pRVW1qMzU1eVNyNGRYQ0xT?=
 =?utf-8?B?TjhSdE5ibWxNdnM0RjBlcnlvQ3ZmL2pKWlR6eUdybDhaR1E4SkYveEJDaitO?=
 =?utf-8?B?WHR1RUJSQmdJc1FvSXBUb0xnMnJDcGZZYTF6QjV0dVVvTnBmVFlJc2xCUHc5?=
 =?utf-8?B?Ni9KYXNKazArRlJHTDErQmxHNkNiTkhrV0ZwSDRFMVZ6QlVUcVE1Z1NMUUJ1?=
 =?utf-8?B?SlBDSUNxTmJSYitGRzRidzF5QUlnMW9GTy9kZTh1Mkgyb2pDTjZERkovV3E1?=
 =?utf-8?Q?blOcm41Ix0zM/I9992ziTdXfx?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oM5PikMwEL3mkYiYgXMdu10BOXcrOfZYDxX9j/IpRxz1c9cnepxmbpKaW1sXDsTfwh7YkN0G/byqsU9TLDqwCOMoK1abMp9agvXLVLQHuZvPz8PH984Cl5uMyln/So9OCJWCcKYrG7mt73xdxdl1yeE8BEpiHjg49j9hW3aZyjCqEnM/PnC1fuGKTuHd+/OIxMZGXLTb8gbhYvFi0LMnl0qkKmn4/763jZJ2Bx80UqquD8t0kjlKrEYO1bsn2lLyzurEYUK9W0LtKw9OeytI3BvS+O3qsxwJHq94yAXDH/yfrNVQzmdgblEBgCwzTRbjchfTEGxRqxRirkuMiQmZpKaEVdQhaJVvl/BFQc8ru3jToY1vVpV9vWofRbrrcgJfTjXh8x6hbGWHUw06doa+TMLJa68rb+cTM7QzpWYCN2ROaSdKixFZJUrxSPbTyJPqtDvZf7uVIp48JVaFSiRtvZLAaXPzNpAiaXkblkCcZ7LjRMNzXRcHrMJ0YKF3RBdF3wrs1jwMAtMBil7xOeH5my1lzifo/2TUtTZzfje7otF66InqcsL8YS+z0AUs1SGnlQlUx0DBFGhVxNDlNUUQ8wLHMWhDCh9b2WCgVAXCcWE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 440801a4-1052-4bf9-8433-08dddbd07957
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 07:50:59.5192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GmIXpUMpahTbGrmzIl6prTrHKgv8bm+w0IwfYzZ64yBxEv2/ON8tuWrdfxrwf/KYYYS/+dyDk7KrQriMhBLfVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF972B28679
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508150061
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDA2MiBTYWx0ZWRfX2YtpbU6pz3sw
 tiuXMxoYAkOtU0Qs3FrH3zzwB8hOTEcMOUkb0bwIXQWtpN4P8Cg2soPqpVAMrH0znYKEjfMQuRi
 nOlXl/dK2SJgFjjhRF+UYvY6Piog4BsQT+qAbDBVIF5iZgKOTZ01pTBlSLrOaR1gGZ6REKV17iP
 cvzfeDdj3hG4DXcZVljJ/1qsSn0jELAobaD9pjMBQ44mFYlFuR8EzPHLMs9azvnVfhQvy7XZSrN
 B7K6WJcLFY2/cNn+mv/LEQ7GqZzaoxPzRVV7VlCFVnU5vo1haxiiQver8S4McrlJCL0xDVSGynk
 mviyKQWtqkZ+yH+IuzX3S56DZ8tSSRl3IiS1NoHRFoZT4meEwxqd9E2RJW5zqFUHTE9PDrhXB7o
 1AjGSytrb08J5/Uct4W6WIMiuRlgcfQhsOZ0r2cHzsmGkWFNDAXJouAB+Coxprj4V90W6oxK
X-Proofpoint-ORIG-GUID: 49yXjB7IjN43mgYq0jWbAk9aE47rkV9F
X-Authority-Analysis: v=2.4 cv=UN3dHDfy c=1 sm=1 tr=0 ts=689ee6e7 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=i0EeH86SAAAA:8
 a=nd6G2UZdAz4TlUJwdQEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12070
X-Proofpoint-GUID: 49yXjB7IjN43mgYq0jWbAk9aE47rkV9F

On 14/08/2025 17:51, Bart Van Assche wrote:
> On 8/14/25 1:40 AM, John Garry wrote:
>> Some further initial points on this series:
>> - the driver still has the separate tmf tag set. Why cannot the tmf be 
>> allocated as a reserved command in the shost tagset?
> 
> The UFSHCI standard defines different tag spaces for TMFs and for UFS
> commands: [0..hba->nutmrs) for TMFs and [0..hba->nutrs) for UFS
> commands. These ranges have to be kept separate because of how UFS host
> controllers use these numbers. The TMF tag is passed to UFS host
> controllers by writing it into a bitwise register. From
> __ufshcd_issue_tm_cmd():
> 
>       ufshcd_writel(hba, 1 << task_tag, REG_UTP_TASK_REQ_DOOR_BELL);
> 
> The UFS command tag ends up in a protocol header. From 
> ufshcd_prepare_utp_scsi_cmd_upiu():
> 
>      ucd_req_ptr->header = (struct utp_upiu_header){
>          [ ... ]
>          .task_tag = lrbp->task_tag,
>          [ ... ]
>      };
> 
> Mixing up TMFs and the reserved UFS command and allocating all these
> from a single tag space would require a additional code and data
> structures to translate reserved tags from the [0..hba->nutmrs]
> range to the [0..hba->nutmrs) range. In other words, code would become
> more complex and harder to maintain. Hence, I prefer to keep the TMF tag
> set.

Maybe so. But it is still less than ideal how the TMF tags are managed 
in the UFS driver, specifically having a stub in ufshcd_tmf_ops. Have 
you considered modelling on how the NVMe driver manages the admin queue?
  >> - I like that you are using blk_execute_rq(), but why do we need the
>> pseudo sdev (and not the ufs sdev)? The idea of the psuedo sdev was 
>> originally for sending reserved commands for the host.
> 
> In the UFS driver several reserved commands are sent before
> ufshcd_scsi_add_wlus() and scsi_scan_host() are called. 
If you must send "host" reserved commands (which are not for a specific 
SCSI target), then it would be ok.

But do you need to send any "reserved" commands to a specific SCSI 
target (which are not TMFs)?

> Hence, the
> pseudo sdev is the only sdev that is available when sending reserved
> commands like the initial NOP OUT. Allocating the well-known LUNs before
> sending the initial NOP OUT is not possible because ufshcd_sdev_init() 
> gets called while adding WLUNs and there is code in that function that 
> is based on the assumption that UFS device initialization has completed
> (ufshcd_lu_init() calls ufshcd_read_unit_desc_param()).
> 
>> - IIRC, I was advised to have a check in the scsi core dispatch 
>> command patch to check for a reserved command, and have a separate 
>> handler for that, i.e. don't use sht->queuecommand for reserved 
>> commands. I can try to find the exact discussion if you like.
> 
> It would be appreciated if a link to that conversation could be shared.

I looked, but I could not find it. It may have been a private 
conversation while at my old employer (so now lost).

Anyway, here is a reference implementation:
https://lore.kernel.org/linux-scsi/1666693096-180008-5-git-send-email-john.garry@huawei.com/

Thanks,
John
