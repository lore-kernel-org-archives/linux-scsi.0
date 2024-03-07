Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D9E839FB
	for <linux-scsi@vger.kernel.org>; Thu,  7 Mar 2024 09:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709804287; cv=fail; b=XpH8qYWwf4NNGtD0e/VfbChIkhmTPUIRPQGOpvddq1zi2BRn88OCv9Jv2hCC7iFEQdY6LJ9syHWJWx8BhimtCE79I7W3OK+IiN5cAPeGTgGy7vHpFz1+TkTzMYA8OoPAJ4jnjbJTHBLGR0oe3OAzJBF5Dhve6GLtHEVKk/0Xvak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709804287; c=relaxed/simple;
	bh=U4gTKD5PGwoGle2LxegoRMx8G6yWJaRirf6bZKoRmWY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=af7AztMNeFxBkKFa2rTLJV7f8xJY4NzHZwTH828ziYJopPne1WTbq757iecPdBs2hXAAPD+x2BKGRxEhg7IXuwQa/UnZfSgwKPyTIv0wcpXzoXDNCNW8TvLe2kubNqjfJcIYvfZCIcSrIyXlwJ43PaHCYQLkhXRtBEjo7sKhrWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eMJn3ISK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=K8SyPDlv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eMJn3ISK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="K8SyPDlv"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42790C5U004333;
	Thu, 7 Mar 2024 09:37:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=7cdXl494uQ5QUdg8nO2mTpxjXQe1Mi0qDP8oPd/fMdg=;
 b=eMJn3ISK9Z3R8ZS5Qb9wFB0EAs0+n9iJPPcjlvzLjwp4Kj12/gyAabvmgxJuqEp/Bzis
 x6SHV3XxiS10KeNtjvP3yjGu4WkOQGwn2CcBRYTPIi2/ygaJvRNprwVk12oLP+f0VcxV
 CSg/0822UcNNOekiAFbMh2TleblNmMk7p2hwNcaWADchtOXWs4yLY8+W82k4oqIVxOOk
 OAnlyOHxv3IKr1iq/Jg8q/Us7Vtz6VTegYYGS35qNifX9T4b3L/06C2CMGMdYtG7O3QN
 p+P+yKL4UuaaOFygWLeLiRKGYm65wtCzFppvG7mYhjjIGhirRzFqLv2YT+2AKYDZzo8m Yw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wkv0bkbmu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Mar 2024 09:37:52 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4278DfQl031891;
	Thu, 7 Mar 2024 09:37:51 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wktjay0f4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Mar 2024 09:37:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UnoVDCEvtVb9/vPZip7dmqgxzzmiAEK5IzWqXSxCKxI9rZslilUGii+rNQklo1YVUIkd/2B4YmtKwQjnjVRItvOGYoqrQLbXz2rofT1SPBbjOcjaYDKClVnJqVJiskipa7dTgSNmH4tu8+NL6h3gFm/6WaBFMk6GzfQ++Uepxcfq8TdvzP+J5LlPkEMVOtkxkb9pwc+kKVlOvmqrxu4czYxhEo2LEvb7/naDH/HnXL1ZMT++N1MU3ZaLVx44RxenzDX7D/GjtcVSUz3HmKelhARHd6LFSisJScj2OEjeMYFEN7DTsE3aOYwmg+3ZDNGrnJ1l2IJLxgmO3U64cm181Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7cdXl494uQ5QUdg8nO2mTpxjXQe1Mi0qDP8oPd/fMdg=;
 b=Frk0QPUUDVfN6VRyRX/BclZyoYh3eU6dFqu0nMr2hL29eBck+w3UQspc1OrXsc18m0umE374zlgJQ52Ly272jfSv0lp7iiv+oBhyC1ym0RW19zvIdC4UgZayWmQO6PWwIxJCS9COVDBvGu7iih6kYriJiuQ8hx+rZ39WhvSH/NIasaWEmQwdcTiXnKT3SqSqD1xwxsRZnYNICxrIrYyLTFL7VCzW/4OSyLNg9OwtqIQ8FTDQN6IRYSpmXwzctvfqbjWIFhpQwBRVS43C7OiJarFfzzadys4/x7VZrEaxuWLyrmgQ4pCFjIU6ZbKijurIRaMeE6rG+04qLBYXbaSGsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7cdXl494uQ5QUdg8nO2mTpxjXQe1Mi0qDP8oPd/fMdg=;
 b=K8SyPDlvNkJNzQKIOwk5KT2Y7RWY473zZrOenh0ZiNoOG3bAESSrk/cvUCt7JRDYPiyvrTo8HrIxrxMI3mc9kHptQbqsjF5ILSh0rTY2TV+04LinkWm5EiRQLXO93rynmX30tyfhh0DIiBar+c1AEQO6pfuYn/zjPKTFUswOKyo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BLAPR10MB4817.namprd10.prod.outlook.com (2603:10b6:208:321::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.26; Thu, 7 Mar
 2024 09:37:44 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7362.019; Thu, 7 Mar 2024
 09:37:44 +0000
Message-ID: <218b4bb9-ced8-4480-8b6d-24969180053c@oracle.com>
Date: Thu, 7 Mar 2024 09:37:41 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi_debug: Make CRC_T10DIF support optional
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240305222612.37383-1-bvanassche@acm.org>
 <cd54668a-8f01-46d8-a597-3dc25ad1ad00@oracle.com>
 <4fbd2106-1e39-4fd9-b0e0-411105e80bb7@acm.org>
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <4fbd2106-1e39-4fd9-b0e0-411105e80bb7@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0586.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BLAPR10MB4817:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f091ce5-3a2e-4287-2ba8-08dc3e8a3dc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	ow/swmWqUmG8zFBZb3gpJemmowukBmNzckXamfCztiiJF+o9I5VD1DTkF4Vu0zamgSWmSffivPwDvVBA65ksY5zEZh5JxpGJQrzgV04N4gumH5evZPm2KTUJu3BZng/22Y49ZPY50fIQeIK/C517hWh6ABulrv92FRKfYjjAC4SMG9KTEQWrue1Z5haCTw8P6RQrgadY1sH8TAmVuV2vZh8Ij9o5ox04DDdhNfKJHXeNA2ZwZxrvwCd0+67pDJ4lVPFGCr0JMDsduU/4fd32frKHuDCtQqCy1h6rmHdfInUlUiPVymOs+ju2SVC7aV7l/wbfP6Es4Snpwqd0zj0YI/9qaAOoerciCTJAydq3C5Nu/0kvbxr2kK7vW9Qe9YUx4Z1NfBWXBj+tnYaAji7eeRzInzjyFhoYrmobpq7ORy++tZi8CMH46ty9s7KECR0lSVLvcyRHzKSrq3r9dChnzSZz6IXMZ0UDt1dwJ2QOqlRWGIvdegz/j7+FQszji5OF90LWxV+GLKml36nQtpu/gXb8dyxf/Tsa0/LgW4F3PYH4R77SzIhvLXxGNH1NSclh31ek8E0yEqsZ7Cc65ujqnuAyAjGA++zlOykSbLwy3Ws=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?N0dXMHZTYVV6MG5FdXdiRFh3V0t1bXNqY0gwbGNuazRITE0xOWVUTmVTdkN1?=
 =?utf-8?B?RHJiS2ROVjZUMHNQdnRyRzJGSEdyTUJ3OTF3SWRhc0NiYkNFRUhGcjZtTktN?=
 =?utf-8?B?M0VGRWtWdyt5WE1pd3FKUnA0by9COXViS3ZtVCt4U1RsZDJHWXJiMUR5blQz?=
 =?utf-8?B?ME1zVzF1dUVONVNNeUE3ckNnVHFhbkViZzV1R1BSSUZndmltdFoycTNRbkdU?=
 =?utf-8?B?ejVZRDJBTWVubGdXVUp6V2gvTHdMN2JLWHcwVGdlQlVhbVo0NUVNNTNBcmY5?=
 =?utf-8?B?VkJjcmowSVpGUThpWm5zbWgrczdYVjlCMFBkOExZZHNHdzlkVFVFUktRVkF6?=
 =?utf-8?B?S3c1Yk5jaDFuR0ZFcmNrTE9DbWhaTzYrTlExQTQ2ZGlQVjFackRRemExemUx?=
 =?utf-8?B?NWdLa3lYRnZlVU5HUExpazdabHhERjdVQzYwUjdsd1kvM0RBZ1E1TUNFZERj?=
 =?utf-8?B?eWtpZ3ByRW5KVXJLMUxQMkdaSzgvY21mUGlRMnQ3YktUQy9pTmQ4b0s5KzVS?=
 =?utf-8?B?LzgrMzB2aElITWxBam80OXdBZGx4bTRnZmtFbnpheDBudnZGQlFEMVhodEEz?=
 =?utf-8?B?ZHZsT21hQ01oOEFrT0RNanpTUWJOWVQ4dERGcHhNYWlYZ1JkTFRxNSt4aGdr?=
 =?utf-8?B?eWtIMzM1OXJSRnlxRFpoVHc4Ym51bVB6RE5WMHJva1NZRERPRVZ0SE1yYTdy?=
 =?utf-8?B?QWpzaDVJK0FWTXRKVmtDWjZuQTg0a3p6VE1QdXVXR003UlhGQmxQaTlnbWNy?=
 =?utf-8?B?Vi9UcUhOK1Q1ak9ROTk4NFRTTlhTTE9KZ2tHRkorVFhnR1MxRlduWU5NU3Mz?=
 =?utf-8?B?YU5pN2x5RTVXZTEvM0phR1p1aml3RmNONFNMbC9kQXBzS0FlKzFYYlpUbWwz?=
 =?utf-8?B?YVY5bWEyUlB1dng2UGRDdW5hOHRWVHNJenRkZU5MUjZldDlGUGo1cTFJWEdI?=
 =?utf-8?B?aVJtTlh6MmwyK0pVOEloOXYwZGhlNFZwaDIxQU5ETFdpd29zeVFZVERQZTMw?=
 =?utf-8?B?U0d6RUUvYkpFZVVWUEttakpmT1NFbDQxVnFHYzgyYXlQK256cnBhb29mbmh1?=
 =?utf-8?B?RWRCdjlSeVVqK1Bya2Z2SmdaL3pCMWZ2eWRmNWdLUisyU0F4L3h0c3JCd1l1?=
 =?utf-8?B?K0h0UWsyL3NzaThNcDhrbzdhWlRnTWllV1QwOE1RMFJJUDRjM0Joc1kxbVBL?=
 =?utf-8?B?UTlqN05KZmVxQWJhaUlaTWNEeVROT2t5QUE1QTA4OTdBV0pKamhteWVVanZV?=
 =?utf-8?B?dC9yVFZBZVFHRGZnOG1ONlN5WTVkWVhicVFCNzB4MVIvQmgySWVpN2l0U1J1?=
 =?utf-8?B?c0NDa0M2NGdXQWxCcFlUQ0tEU3picDY0MmNlUW05SWozMENmL0xWQmxLOGlk?=
 =?utf-8?B?NDBRTzMxLzA0K2h0YlBaN1VZVXNlcUQ4NTlQSnA3dExqeEN4MjhoOU9mYk1q?=
 =?utf-8?B?RitaRFJqUERJUnhNdXRTNlRZMUxzM0crSDdsSkFDM0FNY0RKL3VXVnVubzV4?=
 =?utf-8?B?ZmQra3V1SFdTTXV2ZEU5RHZ6dWdtQzdaWHNXM0FHWTZYOXlVc1graE5zQ3JL?=
 =?utf-8?B?L0pseFZTaFJYWEJ4aGNxU0Z1N3ltTk55dDhjWkZtRVNSRmwyMm5lNTVPanEy?=
 =?utf-8?B?czc0blBUZHJReTVDNS9sWTdsNllkT2lRTTB4NjJUejArNnhKNEtRa3I3Rjg5?=
 =?utf-8?B?UVU4UkFKUUw2Wmo1UTk2bDNlRDZYWmsvdEhCeVl4UFhLZlRhcWFUMHJpQ1JO?=
 =?utf-8?B?UnBjSXZ3V1lrcnlNK082OVVINHFLamdua1dqRitxTVBFRmZCVVhOSDNkT0E3?=
 =?utf-8?B?TlB3OEJGeFBILzFONy9oekJWUkJndG01UGhPNmRNMURGbHg2aGlBYm9rYm9u?=
 =?utf-8?B?SFVGU0ZLeURJL0ErWEl4SzZ1N3FMTzZTSHNrcjIxd2VoODRxS2NTLzdFQzlK?=
 =?utf-8?B?enZacGtmdnBYSGVjbW5UaUpNMEFiRWw3ZWxNZ3prQjMwTjlQb1BRcDVRaWVK?=
 =?utf-8?B?Vmt1RnkzakNUWGFweDdzWkZTUnd6YXRONGFvMDRyMGlqZzFWaloxVU5OeHBD?=
 =?utf-8?B?OWhiakovNTNuVEZmdExoaEF0blpKZWtWZVR0TC9SZ1p5VU1EVmNibHEvdUw3?=
 =?utf-8?Q?cjTopjktQipVvLySrcJunO2f7?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	iDDK5zUji0YLKPbGiHc6hePy4yi6EXMyuXmypXVLDl+01KJOWhsnnKvtDqBKSmRNO5dQrRIkrGCbzZ85lbWuapwKN//cP9MX+TjWzxd9/MjyLtb8gygbi0tiHasIoGGQD8VKSxxSjIsxAGgBeMO6+yq6XPg1mIxLob7/7L4GgsGY5M/dIOTxXSCalVIy1Qsz+OpIxlJyKGXIAAynt0Q82rl+T//Ti4AReb4iMXv2Ox9rq0RX+abvDb4G9Qc2rVynehaVLSQowBNgIkECTbWVgGZUHBn43oGYnw77LyC4wylugD/1GtqtjFeQSeHAwEaEUj3q/BFrrIKZij6wz0Uitya9UoUwAxYQ1nf3YnNIF5cJbXwMYSbGnFATjoku3neel/LgRS7d1ZltUNnyGHmrUCXydjDBtn/t4/39M9h0Sj6Rwt50Ilrg7mjbrrDLaxXdxQI/7NAYxw+Gq5VbEcdyvkFcHVAIN00aw0HHiUB+aqrvf1PmT596Trmgd1GdR+7Dsv+xI67b4wBw9JqgrqHKBDlPKKzbWW1UxxB9uGYSIejh0b53LG28LZsWzUYZUeUeDM4c0Hd5XYb7zsLBFZJvmpSJ9tNqFbZWfcNpiCr7Irw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f091ce5-3a2e-4287-2ba8-08dc3e8a3dc6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2024 09:37:44.4520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V8v9ZfB723zTM+xFUjKXt9ZAR1XvymkPxIzPc6u7RSkQ8Tpn6a3CpKgXiPgPfoLCYYllfH4ak2FLK+a78xGSCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4817
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-07_06,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403070069
X-Proofpoint-ORIG-GUID: UQkWE-wX7QZz4G10n4meR6XbQ-0dvV5T
X-Proofpoint-GUID: UQkWE-wX7QZz4G10n4meR6XbQ-0dvV5T

On 06/03/2024 18:27, Bart Van Assche wrote:

As an alternative, what about something like this:

----->8----
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3328052c8715..3120e951f5d2 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1227,7 +1227,6 @@ config SCSI_WD719X
  config SCSI_DEBUG
  	tristate "SCSI debugging host and device simulator"
  	depends on SCSI
-	select CRC_T10DIF
  	help
  	  This pseudo driver simulates one or more hosts (SCSI initiators),
  	  each with one or more targets, each with one or more logical units.
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index acf0592d63da..5bac3b5aa5fa 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3471,6 +3471,7 @@ static bool comp_write_worker(struct 
sdeb_store_info *sip, u64 lba, u32 num,
  	return res;
  }

+#if (IS_ENABLED(CONFIG_CRC_T10DIF))
  static __be16 dif_compute_csum(const void *buf, int len)
  {
  	__be16 csum;
@@ -3509,6 +3510,13 @@ static int dif_verify(struct t10_pi_tuple *sdt, 
const void *data,
  	}
  	return 0;
  }
+#else
+static int dif_verify(struct t10_pi_tuple *sdt, const void *data,
+		      sector_t sector, u32 ei_lba)
+{
+	return -EOPNOTSUPP;
+}
+#endif

  static void dif_copy_prot(struct scsi_cmnd *scp, sector_t sector,
  			  unsigned int sectors, bool read)
@@ -7421,7 +7429,12 @@ static int __init scsi_debug_init(void)
  	case T10_PI_TYPE1_PROTECTION:
  	case T10_PI_TYPE2_PROTECTION:
  	case T10_PI_TYPE3_PROTECTION:
+		#if (IS_ENABLED(CONFIG_CRC_T10DIF))
  		have_dif_prot = true;
+		#else
+		pr_err("CRC_T10DIF not enabled\n");
+		return -EINVAL;
+		#endif
  		break;

  	default:
----8<-----

I know that IS_ENABLED(CONFIG_XXX)) ain't too nice to use, but this is a 
lot less change and we also don't need multiple files for the driver. As 
below, it's not easy to separate the CRC_T10DIF-related stuff out.

Thanks,
John

EOM

> On 3/6/24 05:19, John Garry wrote:
>> On 05/03/2024 22:25, Bart Van Assche wrote:
>>>   drivers/scsi/Kconfig                          |   2 +-
>>>   drivers/scsi/Makefile                         |   2 +
>>>   drivers/scsi/scsi_debug-dif.h                 |  65 +++++
>>>   drivers/scsi/scsi_debug_dif.c                 | 224 +++++++++++++++
>>
>> inconsistent filename format: scsi_debug-dif.c vs scsi_debug_dif.h - 
>> is that intentional?
> 
> That should be fixed. Do you perhaps have a preference?
> 
>>>   .../scsi/{scsi_debug.c => scsi_debug_main.c}  | 257 ++----------------
>>>   5 files changed, 308 insertions(+), 242 deletions(-)
>>>   create mode 100644 drivers/scsi/scsi_debug-dif.h
>>>   create mode 100644 drivers/scsi/scsi_debug_dif.c
>>>   rename drivers/scsi/{scsi_debug.c => scsi_debug_main.c} (97%)
>>>
>>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>>> index 3328052c8715..b7c92d7af73d 100644
>>> --- a/drivers/scsi/Kconfig
>>> +++ b/drivers/scsi/Kconfig
>>> @@ -1227,7 +1227,7 @@ config SCSI_WD719X
>>>   config SCSI_DEBUG
>>>       tristate "SCSI debugging host and device simulator"
>>>       depends on SCSI
>>> -    select CRC_T10DIF
>>> +    select CRC_T10DIF if SCSI_DEBUG = y
>>
>> Do we really need to select at all now? What does this buy us? 
>> Preference is generally not to use select.
> 
> I want to exclude the CRC_T10DIF = m and SCSI_DEBUG = y combination
> because it causes the build to fail. I will leave out the select
> statement and will change "depends on SCSI" into the following:
> 
>      depends on SCSI && (m || CRC_T10DIF = y)
> 
>>> --- /dev/null
>>> +++ b/drivers/scsi/scsi_debug-dif.h
>>> @@ -0,0 +1,65 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> +#ifndef _SCSI_DEBUG_DIF_H
>>> +#define _SCSI_DEBUG_DIF_H
>>> +
>>> +#include <linux/kconfig.h>
>>> +#include <linux/types.h>
>>> +#include <linux/spinlock_types.h>
>>> +
>>> +struct scsi_cmnd;
>>
>> Do you really need to have a prototype for this? I'm a bit in shock 
>> seeing this in a scsi low-level driver.
> 
> I will leave the above out and add "#include <scsi/scsi_cmnd.h>"
> instead.
> 
>> dix_writes is defined in main.c, so surely this extern needs to be in 
>> scsi_debug_dif.c or a common header
> 
> The scsi_debug-dif.h header file is included from two .c files. Without
> this header file, the compiler wouldn't be able to check the consistency
> of the declarations in scsi_debug-dif.h with the definitions in the two
> scsi_debug .c files.
> 
>> For me, I would actually just declare this in scsi_debug_dif.c and 
>> have scsi_debug_dif_get_dix_writes() or similar to return this value. 
>> This function would be stubbed for CONFIG_CRC_T10DIF=n
> 
> My goal is to minimize changes while splitting the scsi_debug source
> code. Hence the "extern" declaration.
> 
>>> +extern int dix_reads;
>>> +extern int dif_errors;
>>> +extern struct xarray *const per_store_ap;
>>> +extern int sdebug_dif;
>>> +extern int sdebug_dix;
>>> +extern unsigned int sdebug_guard;
>>> +extern int sdebug_sector_size;
>>> +extern unsigned int sdebug_store_sectors;
>>
>> I doubt why all these are here
> 
> All the variables declared above are used in both scsi_debug_dif.c and
> scsi_debug_main.c.
> 
>>> +int dif_verify(struct t10_pi_tuple *sdt, const void *data, sector_t 
>>> sector,
>>> +           u32 ei_lba);
>>
>> Is this actually used in main.c?
> 
> It is not. I will remove it.
> 
>> I do also notice that we have chunks of code in main.c that does PI 
>> checking, like in resp_write_scat() - surely dif stuff should be in 
>> dif.c now
> 
> I'm concerned that moving that code would make resp_write_scat() much
> less readable. Please note that the code in resp_write_scat() that does
> PI checking is guarded by an 'if (have_dif_prot)' check and that
> have_dif_prot = false if CONFIG_CRC_T10DIF=n.
> 
>>> --- /dev/null
>>> +++ b/drivers/scsi/scsi_debug_dif.c
>>> @@ -0,0 +1,224 @@
>>> +// SPDX-License-Identifier: GPL-2.0-or-later
>>> +#include "scsi_debug-dif.h"
>>
>> I always find it is strange to include driver proprietary header files 
>> before common header files - I guess that is why the scsi_cmnd 
>> prototype is declared, above
> 
> Including driver-private header files first is required by some coding
> style guides because it causes the build to fail if the driver-private
> header file does not include all include files it should include. See
> also
> https://google.github.io/styleguide/cppguide.html#Names_and_Order_of_Includes
> (I am aware that this style guide does not apply to Linux kernel code).
> 
> Thanks,
> 
> Bart.
> 

