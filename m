Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D124E574
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 02:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706668826; cv=fail; b=A32nyG0rfKU/OzWQSHnQb6G02lAoaAYrV4CJw4MAl82VP0NFoe9k5WkVYkCGy3TQm06ceKmxd0uPY8e3sFnV+l2gyks8ni0DuoeNCzNokFrw9HaG2JjwU9mdWuvdcVv90tv+qIvZWHBMRok8LoY1CoaAf8/nXvbfbpiCEZarC9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706668826; c=relaxed/simple;
	bh=ayPexeg/7BINx6RgthavAUPZTuoJTAICYBBrxYMlIgs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fzvpEGGYk/6URKptJ8aThB2Ymz4SukohB/3gwlwtscStKLASpcAMOooXc3LkSeTlMr9LbYl3VBw3FkA3WWkx/a0T1IkC2H4o8BKZPgruXr4uRnhD+aHYfeA0X09KN+5Bl+rOCCfXq38yIm8fUaB28uIJqOQfyMvhRWL1QX8HAWQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TBQW0g6N; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XcGXQstz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TBQW0g6N";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XcGXQstz"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxjvd030547;
	Wed, 31 Jan 2024 02:40:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=+npoLE7QPj6JGzOv0xqef/cLNBa4v2dKYrK+7z5d+Ag=;
 b=TBQW0g6NKNE0JkaO11MpjyEHaWDhgg/R/+FksHryi0nzr78LXzKdK+Ru09ivcppN9T4P
 qJdB/QvbY3UPwJY/Kfg7LgfHtRc9id0glBhMlpPRKUi8xZW7v0DruMQoJoKktl1JDd5d
 g0Ejs2PZRVcjh5B5YBG8JrOHo7yAS1d6jkDxI964jU2mDQ8DMIZmwNcuQTzu5hnFr6B5
 fBlL+HNgmXf0spTsaFRvCjFpcLYJ4GmOK5QdRlys0VbcgnFzXWERJE7QwgN60iqiTJc+
 PHWS+TqaUFKitP4LqpGUeAboFbmgfqm0Vy+s+lVwSX4+5ufo9l6sb6ew4p76lGKYmCL0 Rg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvsqb0kq6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:40:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40V2TIq0031394;
	Wed, 31 Jan 2024 02:40:22 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr98c8jh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:40:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qj8mXIJbLnSQLWbr6umQPfC7kZDTH1GeMRcrXYeiZpjlNFRrDLr2kTT5k9uutFcz17n5eCAw3O+ZH73rb01NfXfRGSSSEkmyIl+Y6Tbw+9tHpjKXcmVREsuOB4wUyvIR33MDpnElSanYccTCsC1cK7wfH4+h1NpcDogy4R6y8RyoOqMOIKz8HL54mvQNGXHnaqFANPPh73UV4Pq3CGDDzP9gm1NgMkCoXE8J5Djwin2Xm7Ivc7NoC8KtTOCkRxmq0HqVJ5C0e6iEOrq6DZZ9t8Tu3u0SJhFPPk2PnDmCeMOhEQrkOaizBw0+/RkXJu506nA/j2K1xckhJ2cDXn/lqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+npoLE7QPj6JGzOv0xqef/cLNBa4v2dKYrK+7z5d+Ag=;
 b=OGFF/WbtLEbJoZMwmL3aiB52/yM2Kkfc1ZoKmAdzPP1txwUyzZhmDJA0ZW4TiB3Ne46wcndVQAVty4sAK3lgYIhQfK9k+3c6F4Pn9rvKOaH9sJ0kfM573mfF+yncqWB+Y3nghcArmIcie1Y1jmWlgw7EOjTKueGk/2ou9Ptm8NmWV4v+NxoUkbZDJdDHkE8eG7swQtsg5UV0DhcU2Wi+vF0XSLIUKSh0INw55SjBzpPjt/EQ8TiquPy2J8enkogJ90V47Prx35dgPKmGhSBuByffvsKgEznOX1wavkJ/+6XW4bqMPQaAai2c0CTDHYWVDBBy5QaBLLlMmhCcGEMpaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+npoLE7QPj6JGzOv0xqef/cLNBa4v2dKYrK+7z5d+Ag=;
 b=XcGXQstzMt6hXj9J4/Wo9MTFp/3LaXkTm0yY7xw2YKEL1OTxnMEDJQooPw7Qb2dNy8gKmOJ+voamq2WZ5s3j86dM2z1sbByNBWHCyGp+4Rp/hFhoZjPLudNudFiviu88krE5hdl1g0PxvNXGsRUjeAtnGmUKcdrwVAi3z8hUD/s=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by CO1PR10MB4498.namprd10.prod.outlook.com (2603:10b6:303:6c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Wed, 31 Jan
 2024 02:40:20 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b%4]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 02:40:19 +0000
Message-ID: <5fee91a3-551f-4a48-9ec0-b8e58b9d4236@oracle.com>
Date: Tue, 30 Jan 2024 18:40:18 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/17] lpfc: Move handling of reset congestion statistics
 events
Content-Language: en-US
To: Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, justin.tee@broadcom.com
References: <20240131003549.147784-1-justintee8345@gmail.com>
 <20240131003549.147784-11-justintee8345@gmail.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240131003549.147784-11-justintee8345@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0287.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::22) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|CO1PR10MB4498:EE_
X-MS-Office365-Filtering-Correlation-Id: 35745871-4a30-4eaf-1645-08dc2205f71e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Ik3pp7uHmuDPWqWPUTOXx8oq//2sb+rIV0qmJwCtZvFfd0CwmoPNDv1Rb3HT4t+GDYJEgU3UkDiRio1Fql0p8TLV7f1O2Nnq6NUh2WWjK63Wby11+fBMSC4XJF1vHUEJY9DZesV1gV8RXpyZmod16eEPBU/wd+LKoXSWRtDr5PB3soGx4ck+5IQF/6prEHopARN1sd1J9j3Ct7HEZhOv/qgwhhR3XQQ93NO6OaVB+tJoc8GQj7xI/65FutvxhrpYvVTaC93R9BXTv9nE+fsJuZVQNkyvE1dYWtyJGwW3G15YAuaEe0qLfglbRSYIQEB6a6SAUnWX2T4Os+Mn0sJWXMkUDpACSqMPp/TeTLlxtwDEU3Eapqg9ANJWl+zJUXk9RM0NDgHgOLxqbLzw3teObKXg0x/kKKt78AXYdYeZtwr5rr1h16Q6A7hpgmdUdBWbtUpTOidY+Ry3C9EZ0RnXDTc5NfUFBdc1w+n9tna0UaeywnFWrqXSXN6mQaL7exv44+iK1ewJB6GeppP+TCH0xpFqLFL8SJ5hbSO/B6D5ofhmozELozN9JTY9GqxfOMGls99l0/fRLaFZXGCry4X1TpQg4x9PWnmExd+4zs9Dpnrzm1c5TAuVwt/5DNAyUjBVi0rLzclRBgKVJRofKeePHw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(366004)(376002)(346002)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(41300700001)(2906002)(5660300002)(36756003)(66556008)(86362001)(66476007)(66946007)(83380400001)(316002)(31696002)(36916002)(53546011)(6486002)(478600001)(6506007)(26005)(6512007)(2616005)(8936002)(44832011)(8676002)(4326008)(31686004)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?dGxLNXNMUG9mbSt3cDZxUlk3TEdFdU9mR1BQUEgvZEZyU0tWL3FOK21oUFJP?=
 =?utf-8?B?OUYwVURBSlRlRDR1TXRMcE8xZ0hSZGN2dUtwZWQrUHk5Y0YzYWN2RVVHdERY?=
 =?utf-8?B?Mm02ZXUwejJEeDVuU0ZJZ0hzbjhnL0VQVkJXVjNINDMvOEo5VkxOdGhGcDdX?=
 =?utf-8?B?M0p1VGk2ZTQvdVM0b1huS0RuT3dzZnJzL1VKRDI0UWJvNUhMQXd2MFVEaG1V?=
 =?utf-8?B?Q0FBc01oSFFLT083cTRBcHhKTElCQXpKZFBwN0I1N1RYOUwrVmduOTFaRHVL?=
 =?utf-8?B?MVhCTWR4VG8zWnBBV0kzRVF2ZGtlQUVseHBHMWxFWUtSTDQ2TG5IN2VVejJo?=
 =?utf-8?B?WFpab1c2V3VkMEpHMGRlWllPZmJrd2lzRjRLL0ZzRHZqb3VrekZDMWt4eEE3?=
 =?utf-8?B?NERTTC9zUm9Gb3hKY3l5cTFnOGNBWFVuNmJmb3Z2S2pocGNXNjF6VEJaazFW?=
 =?utf-8?B?YkhCdXhPRWZJaE5xYXVGWjFpaDVpRHlLWWtHakI5clZYaTl0TXRRYzZmSEsx?=
 =?utf-8?B?LzYyVEpjczRMNmx5d1Yxakt3VVJySEtQNXlkQlUyVStFN2QzYXl6VnprZlJS?=
 =?utf-8?B?bllua3pkWUMwN2hpMXArL2YyZ092UmtteTJzNUIvZFZUVHU4NXY3SjBKeVF2?=
 =?utf-8?B?MVZSWGNDTTVoV0tJNWJnakhRSTN5TnRKM2N5YWdZWUVzK05QaDlhVDI4S3Mz?=
 =?utf-8?B?ajJBNlg5c1JwMWV3RGpXT05XRnZFUEtyY0RtaVdvZTVhNlMxdkthcEVCOTRx?=
 =?utf-8?B?M3VMKzVqRVNEZ1J1ei9xMFcxcU9hZFlTRFVyYW92YWxYaUF5MVNGc2VhcUdm?=
 =?utf-8?B?bWlydDlCNzNZWTlWZEZYY2tUM1RMMjBMbk9ITER2U2swaHc0NVdYODRuNndj?=
 =?utf-8?B?RE1ldW5jeHNNVk1hTjYxaGNEQU11aDh3bzZ5ditTQUNFMkVDYU8zMHhMd2kr?=
 =?utf-8?B?cjIvZWtoZjFVWDhQWXFxdzVLVVpiUmRISTYxbHptRDB6ejJub1k4cTVwc2x4?=
 =?utf-8?B?c3BtaXlGaTQ0d29oR3M0MGE0YkMwQnE4c3hOanI0Q0FvODNDTTVXeXZNd2Nv?=
 =?utf-8?B?VHl0Z2NkdVhNcXFOU1VnTFlNZVJiSjdVZ1NNQWpDcjRaU3p3ZU5vNFVOc2U3?=
 =?utf-8?B?QjFzTzZ2K3lSV3R6WUQzNEExNmd3QmRPaUNLMVBRWkx1QnBXa3N6R0FNM3Bp?=
 =?utf-8?B?Y2FTRkdiMDlUNlZ1YkVVVmpiRFJSSHlRdDB5UDBvRVRsbVllSkpxa2NrOGo1?=
 =?utf-8?B?MFdMcGprK1pxeGV4R2lrSW1vM2lqeEdxU25IQkRMaUVHc2VzYk1MRzJmWXk1?=
 =?utf-8?B?TWpZOGpoOFVlYk0wcks2T1hTNTZFaVc1bTgrQUdaOXl3NkUyYjlWOWJtZ3VX?=
 =?utf-8?B?eDZVZHBjcFVCNDY4cW5QMTZrYVVCS0l2a2lWZ2krMzJrczZXZzBxKzhISjVz?=
 =?utf-8?B?c1JldEZnYTloWTZySWRRclVIay93Rmw5K200S3ZzVDNza0V3U29yemtyaTZO?=
 =?utf-8?B?QWtDbFllb0VzL2d0Q2FKcmlRR3ZuOGF2UElqWHgyaFptbUUxM0xab1p3ZTQ1?=
 =?utf-8?B?SUJiN1VzSU43aXhxZitQZ3VKMXVsRjl4RGM1bmdHOWFvTUdIQzBjcWpxOTRn?=
 =?utf-8?B?dkVPZU1JL1BQS0Z2eTZCOStKTVVkbU5yM1Z2S21aSndoajQ0a2lpWGFOR0FP?=
 =?utf-8?B?eVd0TnlmSUxRbW95eFNMZDZuVVNwS21iQXNWd3U2dEhETGJ6ZkdBN05lNXJL?=
 =?utf-8?B?Vng5TkdYVTIzVXp3aktDVzhFV3ova2dqdmJHYjRqS29pZFV2SWVMRWFqV0pX?=
 =?utf-8?B?V0NaRWt0VllOb2p4R1dOSGMzTzN2UWpMMG5PbUV5RkVMaTZoU09DcC9xOUNk?=
 =?utf-8?B?R3Z5WTJCeUNiTDZTNW0xaEJCb2tDbjBwS0FhS3plN0liVDNTV3BDb0Jxa0Yw?=
 =?utf-8?B?MkFjUGtBVERDQzU0UzNvcjM2eHJHQXNXc1R3a3FUZ0NJd1RuN3B0NEgwTzVy?=
 =?utf-8?B?SGt1UGF4bGp3SzlBZDR2NkpyOWdFUHp6VXp4cFBnb21NazBzTkxhckUrallX?=
 =?utf-8?B?VlBtUjdmUVdBdWZMeGRwVUthOWtWZ3lFcHYrRGpna2JKM01QSHg4VVgyNXB6?=
 =?utf-8?B?SDBQRWs4eG4rdXRjdERXQ3JqT3d4MlRaZkFmWk9vMWhPOUE3YXhGVHdVY25M?=
 =?utf-8?B?cVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	4NODSHQOCgJsfh7jT+7dQ3G5cWjCc841myHmzRHRxdLmH3qaLUnA1cEEZ5Gqv7umJnD6gSVF8eL26W9aoHcThwyzkm7irZCpelioQ9kbpjKTRB5RLb037J++AH1h5A4A/eRJB95EaJO7QLXbFzxEvvLvKbTtunn7xAoq11NE2Bu9yTnQij4NvPWFPiIlH6ey34RMQ+bgNV8AU/0N9MP02gmpBtEDBEwpGpq+VLB3JyZPAiO6kj+zD/GIRMtmQ3VGPqk1lleACauEH/CWLw3Xx0HHpaIMy9Go5Bz2h46XDfDAhgN7vl3oO2IXQ2AduAoEqeJ6bzLpRghoPgtYrh2byiK3yKL/oxsaWJkNhxBv1E03go7R4vTkYpjHbKUEJAO5+6wnzo+yg08FgDqBCd2BKepfYNkOqPl5mJEyKQ9ssqvbB9z0dYFzq0e6i4cf6ekoaddrd8kolto1f2F6vs6l4GnRWsuS/X5+4hnL3tPFokoIXfLPXx8XthiB43IcFxYpsFdBOn6yOFR3vD/NOtqQz81vKDWeyQcc1rrbbxNyJUxfL3YtEQxOz2SIcZpAWr0ecZdWxUdDzrbzb4ryTJlsASixJiiAZhxnV6DGFo0VVnU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35745871-4a30-4eaf-1645-08dc2205f71e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 02:40:19.7609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4bDHU0WS7l2vBqGM4RoGlGgH9Wd14h6kVCdiTNpUXimW9fJFpwHJ+6BASsM/LnwlkUqJZ6AUpPq5K8srkLLV7YtcU1ZydH+wqstKTLFXTEM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4498
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_14,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401310021
X-Proofpoint-GUID: WSwL8OehirrGaMx-ntqGfFsMz7H7hn7s
X-Proofpoint-ORIG-GUID: WSwL8OehirrGaMx-ntqGfFsMz7H7hn7s



On 1/30/24 16:35, Justin Tee wrote:
> The ACQE notification event to reset congestion statistics should be moved
> into the specific lpfc_sli4_async_sli_evt routine instead of being
> processed from the generic lpfc_sli4_async_event_proc routine.
> 
> Signed-off-by: Justin Tee <justin.tee@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc_hw4.h  | 2 +-
>   drivers/scsi/lpfc/lpfc_init.c | 9 ++++++---
>   2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
> index 5d4f9f27084d..f6b1168304f3 100644
> --- a/drivers/scsi/lpfc/lpfc_hw4.h
> +++ b/drivers/scsi/lpfc/lpfc_hw4.h
> @@ -4069,7 +4069,6 @@ struct lpfc_mcqe {
>   #define LPFC_TRAILER_CODE_GRP5	0x5
>   #define LPFC_TRAILER_CODE_FC	0x10
>   #define LPFC_TRAILER_CODE_SLI	0x11
> -#define LPFC_TRAILER_CODE_CMSTAT        0x13
>   };
>   
>   struct lpfc_acqe_link {
> @@ -4339,6 +4338,7 @@ struct lpfc_acqe_sli {
>   #define LPFC_SLI_EVENT_TYPE_EEPROM_FAILURE	0x10
>   #define LPFC_SLI_EVENT_TYPE_CGN_SIGNAL		0x11
>   #define LPFC_SLI_EVENT_TYPE_RD_SIGNAL           0x12
> +#define LPFC_SLI_EVENT_TYPE_RESET_CM_STATS      0x13
>   };
>   
>   /*
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 70bcee64bc8c..8e84ba0f7721 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -94,6 +94,7 @@ static void lpfc_sli4_oas_verify(struct lpfc_hba *phba);
>   static uint16_t lpfc_find_cpu_handle(struct lpfc_hba *, uint16_t, int);
>   static void lpfc_setup_bg(struct lpfc_hba *, struct Scsi_Host *);
>   static int lpfc_sli4_cgn_parm_chg_evt(struct lpfc_hba *);
> +static void lpfc_sli4_async_cmstat_evt(struct lpfc_hba *phba);
>   static void lpfc_sli4_prep_dev_for_reset(struct lpfc_hba *phba);
>   
>   static struct scsi_transport_template *lpfc_transport_template = NULL;
> @@ -6636,6 +6637,11 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
>   				acqe_sli->event_data1, acqe_sli->event_data2,
>   				acqe_sli->event_data3);
>   		break;
> +	case LPFC_SLI_EVENT_TYPE_RESET_CM_STATS:
> +		lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
> +				"2905 Reset CM statistics\n");
> +		lpfc_sli4_async_cmstat_evt(phba);
> +		break;
>   	default:
>   		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
>   				"3193 Unrecognized SLI event, type: 0x%x",
> @@ -7346,9 +7352,6 @@ void lpfc_sli4_async_event_proc(struct lpfc_hba *phba)
>   		case LPFC_TRAILER_CODE_SLI:
>   			lpfc_sli4_async_sli_evt(phba, &cq_event->cqe.acqe_sli);
>   			break;
> -		case LPFC_TRAILER_CODE_CMSTAT:
> -			lpfc_sli4_async_cmstat_evt(phba);
> -			break;
>   		default:
>   			lpfc_printf_log(phba, KERN_ERR,
>   					LOG_TRACE_EVENT,

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
