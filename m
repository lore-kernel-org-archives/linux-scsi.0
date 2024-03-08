Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27938225CF
	for <linux-scsi@vger.kernel.org>; Fri,  8 Mar 2024 09:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709891170; cv=fail; b=T/EbGMqgaowot6fd3Pmv/xWTTzlpk8C6wsaQETlXB+mV+bHFXb++pAfSRqG+oQzqsvCEdaTpdhHzyv4lQZdONNlv7zqnmKgzZ7IfNU6CjlzLpiLq7mG7eLlTlAL2P44sJE27/P3QrU5Pvk75AM+0plhaMn/EPYNnEPjurmk6A5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709891170; c=relaxed/simple;
	bh=YocaZcPqeP6p+vPBXEVaZKsv43V3Dgi6i80XlGVHSF8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ECkI8IVGcd2CLWaKM/8CnWc1Hk5jR40+C5PSVUDT/2ZAHyShsmOA1rVmG5gud1iiGFc9D9jULjN9R8k0biFPjcJggDjALoIlx3EudRuB42HNSCZ5S86umpgOHnERuU5Qo0hx0rEM60scjgi2fm+T/7HBntsx96c63oHKDRtqGQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NIEuPFN1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=p5sFJjmL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NIEuPFN1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="p5sFJjmL"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4281iDd9011677;
	Fri, 8 Mar 2024 09:45:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=YZDi/2ya3wKZ0Auv+YRn6ntV/s22KrYJq/PDBT8S20Q=;
 b=NIEuPFN1DgH6f1nmDPTEzJz49Urgxi6hZ8hhH9E0UgUKnfh3FuhxPR5FmIyrqm4M05fO
 6AHvcjl55AqM/aaO5pQQ9i3dgtxPv1aTpIR0+CpFzprc++xBil4f1W/Cii+j2n7QU4qt
 uKumfj5IIIduhsB1hL68pOma5aOhIJk7c3KFTCzu6kfK/TPb4BnsPQGzqESjZFRrvVcQ
 v4HB2ANl9I9YCNw0qzPEu0TAtfqjSF6KcbMo7X29z/h7HerXT5j2OPfsIfx8ZwVN8Suf
 KCWI7qOiQQKcGjQGKP2IKudzTxgz9qr73hQgB24U/9+VXqOd2Utdve473fZC9xNcGatP 6Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wkvnv5k3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 09:45:55 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4287sEle004904;
	Fri, 8 Mar 2024 09:45:54 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wp7nv2m5w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 09:45:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VAvxIY5YMV43cidOvnMGmf+gVDYO3CP5Prpv+hY9PDjvgNLIFqoPmRONlnPvCnvy9x8OATiQahpXpou2ZuUf2SpyCki5h6MmHIwkOEy7aMd0KETus2kIlZAhOfQWGYTHUya8B70ziFN7lBwzAR5qea9KTu6uHCF7u2gPJ6Mu1cIsGK2kocIRT32xM77NzNtj2bRsA8s/PsF+jww9BRfDYXFdQ5jwx+DSueCD93K4dLiFZorvKLgdm26NDLgHKAT5hHT7mkfUJtFnqettugEWvs+NHyTSDAv83dKok7HKszW1vAuY0j61vSw81uB4k//f+OWrKmzyVfPq+UnRP/9x9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YZDi/2ya3wKZ0Auv+YRn6ntV/s22KrYJq/PDBT8S20Q=;
 b=OwCDTnNC+fFRKqZhlhFSevypAOSHAPQckclwPYFYWM3rWzZfRHViJpChHpWQWUbSVtRKXDeKswXo5cuih3DentG4YG18MAk8dc0f1rSrOVgN8bG9tzNlKkZYQfvPcQex/Jlw8h290ianfZzX6iQTEuMXKIHHInpWQ5NZXZVFmabtPoApiTci2O1xEtjypszIoGULP2RPGpgiZ6mwwkyZ19qXhCa9nXq6zEUetXlu9KkuoKLezO2EAJYFJhRDcGYjic9ACxKJL4SO7xmhumybt49q0Xzwj06qZ8pxKpwKJLMwWCRclzpey1q1jTPXAWvMBCVxLItbCrUwkrNH6DWsyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZDi/2ya3wKZ0Auv+YRn6ntV/s22KrYJq/PDBT8S20Q=;
 b=p5sFJjmLEZoBtjSI+FLT1S6wciWV7dOt+lH2kn+BAW9DPgcyYe0LAC/jjlP2XAVULv9+rI7ngANAXvxP9LdIeQil+sTPlD/jdCDWtF/tfHREykYnqM34+mrzswEA3A0ZOmcuu999Os0AMD7zZhAMdVefnqmTWjJ+fEDHvTUKJgE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB6087.namprd10.prod.outlook.com (2603:10b6:8:bf::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.29; Fri, 8 Mar
 2024 09:45:52 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7362.019; Fri, 8 Mar 2024
 09:45:51 +0000
Message-ID: <ef5dd96c-0de6-43bc-ba64-05729329ba2f@oracle.com>
Date: Fri, 8 Mar 2024 09:45:47 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi_debug: Make CRC_T10DIF support optional
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240305222612.37383-1-bvanassche@acm.org>
 <cd54668a-8f01-46d8-a597-3dc25ad1ad00@oracle.com>
 <4fbd2106-1e39-4fd9-b0e0-411105e80bb7@acm.org>
 <218b4bb9-ced8-4480-8b6d-24969180053c@oracle.com>
 <2f2c14e4-1a8c-4472-9ac4-887b8b0f2689@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <2f2c14e4-1a8c-4472-9ac4-887b8b0f2689@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P191CA0003.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB6087:EE_
X-MS-Office365-Filtering-Correlation-Id: a1f942a2-4a5b-4b07-38f8-08dc3f548ab7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	fiM2ZlRh7PtDfrLySnA0rLbPbB+3z6mhdALbyLzWEjnXvplSotdWC0MSdlM8pnp/Ej8QXn9v1XkPnPjtiwClvEpWp3YQLZVtoxENI8pWWuYmwuJ6mDIFUTGh++3Z4s4xzXRvQ57Xtdia+/YrMc3B2aRmI2MQza23yiIH8F2namTCSpbs2SdnPIHIBzLghHBGiO6ouNsYYVwiuKaQlp5J3+k10rSh4WMbSZZv7i66JW6cdNuaALycKV+6wXNF1XQb32S3hiGbZWZ9p4tpa7kpEzgv4iMkWFHrJdjaVlOH2WdWfonXim1AZnQ8VlOAMA6TAv/D6gyUKbFR4r3E9riFinHGFa8At4c0OOtQhZV8LLNYYPBU6sEPKfcSe3LLJkyDenC+6Z99WK7rroEBKcAd5xgvjSI+fQABQrqPJZIry6nwcDCYuQEbJunXMU1TMtjP4wXinA05mZfoJSlWuGm9wDmIbazX+BUV+jdlgLIjcKt5gFarrRvK1P9fD5rmwbZ/cF95iapC2NCLWmlMZzPPHRE6SmxucElZ54KMENiigRHPrdkD13J1JRNocvB42W2m3P36EkiYhY/OdYii5JSCWfxwNTsYJH0bo6/UOAf5fneF0t2rYaRfRALT9IndAUmQ/fF2HWbw5W/5yOt8UcyBwh1OXGqv4hbyKKLMBeR+91I=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?V2pSSDdrTG1JQi8yVWg5aitvczNTMXkvNytaOEE2S1dFUTF6SDZZS1ZDOVg1?=
 =?utf-8?B?Qjk2U3VYWnJEK0RMZlJIaFNTdkdzbUt6SjF3bUlNWFgyQWU2NEo1K1QwcmZO?=
 =?utf-8?B?Mk13K1dRZ1NWMnFWeGN1K3VmTFd3V08wSGcvcW9IZHZpUjQ2U1ZSZDIzNFdI?=
 =?utf-8?B?ek5rb3MrZkZuSExCRGR3NHFJM01XOVFIQUNIb09pY3h3UlFpWUlhaEdrREpJ?=
 =?utf-8?B?VzZ1Qm9WNWpwVEhmM0l6ai9IRk4ySGRCbW9BZWdDN2tvNGkxa1FRTk1aNHUx?=
 =?utf-8?B?UU1oSjVjR2FwNkZYbCtpZGNBM0dMR3NLTkloWmp0djd1Vm5DS3B4SE9RTGRK?=
 =?utf-8?B?ZzZHQlJ6YXBxUVNOMGFnWm5MS2EzWWpCL1QyS2F4bEszV2FCNHZPSjVOajhl?=
 =?utf-8?B?S2VpeVk0Zi9obEFTc3NlNGc5cTI5NUxRSitGRlR6UkdqK1ZiRUxtc2h4ejhS?=
 =?utf-8?B?cExTZGVsQmRyblRHRHFTNGsyY0dCTUo1dzFZWDZwaGphT0NuMTlVcE4vNkk4?=
 =?utf-8?B?TWU2MVZFZW0zN0VpUE54VjVrMUJOUHlwL0JDNjMxdWhaMzJmOGFjanBtL0hS?=
 =?utf-8?B?L2JNc0QzVVRsR09zSVFRbGV5N2M4amtnQ3Z0RFl2c1hTVE51Vk5DVFp1Y2xX?=
 =?utf-8?B?SFJkNnJzaTdjdXpILzgzMk9FbWhZZ3lHaFFWVFNmb3hjSVNXMWFhL2JJWXFT?=
 =?utf-8?B?WUlobkgrSnU3OEh5OTFsNGlaK2IvOE0rcjFadWFQRmxOdFBPbFhtVWFUV0Fj?=
 =?utf-8?B?d2pwc0xUUHJDdnNYNEhSMHhjeG1heDZ1T3JqR1g5UmNYM2ZpZ0srazJhMTBz?=
 =?utf-8?B?YWZmR1RGeU94STJmUDNsRkhEc1JxeTJoU1NGVnNpZEpjbTdGenZZVjZPRmhm?=
 =?utf-8?B?TzEreWlnMytDbHU0OW14cmFPRGM3VmZQRjZwODFLYTZoL3pRS2VhNHcvSHc2?=
 =?utf-8?B?NlJxV0tCVVlLSXV5a0huR0JqYmt4eEZxWmlwNXRlMGtCRzZWa0ZjUG9GZzZq?=
 =?utf-8?B?VEo1Y2FvbzdjNHEyY29DZ1FlL3VkaWRqa3pYTVZXeWhRa2FYU1JqWm5ndHEw?=
 =?utf-8?B?a3Z1bTlRNmprc2Zkby9ueHNQeU9uUWF1V0ZXZzZ3ZmpWeDI5Zmc0OEZqeXVG?=
 =?utf-8?B?NkRCU1lENEJQMVJOL0FmY054NVR1UmlwclhXT3l4WkJTQmY2dWdVR0FvRlFl?=
 =?utf-8?B?K2xDUVhHMlh4VFpqT2VGUVpwNG9RZlZGSVl0aFN1Q3lzbnlVeWRpU3UzUk1s?=
 =?utf-8?B?cFl4WXZVWWc3RWhrWmdXZlM4andrVEZhSldhVlZBTzRIS3V5NkZZV1JTUDk0?=
 =?utf-8?B?T0laNHhCcW1LTUpjNzlsbUxzUElFUC9XYjJDVlN4WStBdm0vQndTWUlTcEJj?=
 =?utf-8?B?NzhvTmVzVytwRUdHQ2hjZjh2Qk44MnpTTWJQRCtRbUU2SDFCZXl4U1Q5aXBY?=
 =?utf-8?B?a0FNZ2pYQlpONXRPdnByVUF3N0tDR1BHRUhvN0E3YzNBRVlxWEl1WFZiZGxT?=
 =?utf-8?B?cmRWME1ibFRCOWJSUFVQaW1SQ1VSUEhmdGE2Z2s3RWdwMWE5TnVtOHRkdW0w?=
 =?utf-8?B?cEVsVTdYMktKQzFlbkpYN1FWMVlnZXZrVGxVRDcxNjFNb3g5bDJ1Zmp3bXMv?=
 =?utf-8?B?MHZIZk5Wa3l2UGlrVXVuSEtMS2dWTjVScWdHT2tpamdlRTBwdVlRSmJUbTVq?=
 =?utf-8?B?bDdKMGF3dS9ZaEVhandKQ3ZXMTFDdC91NXl6OUFtaXlrS1FEejdtM1JTYnFG?=
 =?utf-8?B?dW55cG11NnBSbzVxclU2L1pXZ3cwS3RLaEY2aTlkd3FjTHluU09ETlFSSm9H?=
 =?utf-8?B?cS9OVUs5SWFDQzZpcGlHWGxzK3F5U05SWnAwQ1YraGRvTGVkekZaaVEwbk5K?=
 =?utf-8?B?V3dIUFF2eFhMeEtVVERwV0ZmTzQ1eWhwTGExYklGOXJkMWpWbGk5dU5MOU10?=
 =?utf-8?B?enZ4cHQwOC9maXNMVXZzdjFWcU8zb2tzcGcwMmlvd25uSUdkcU9rSjBXamx1?=
 =?utf-8?B?d284WGsvQjNld09mM3hCd21tcTJPMHFkZjVMb1g4aUFGTjVua2RKcHJRKytl?=
 =?utf-8?B?cGZhQk9iMnowZGdPdWtkMi9uT2dmbEE0aE05TzZ1bHJMVVFIbzRWZGhPSzQy?=
 =?utf-8?Q?mQFMOczMjoVcapFLgtcAsM3+2?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	3jVyEkIykG6bIYdVMclbsNxGyrOiLhG7UYMmz2USKn+dBVxE9VKvMjl+zeHmGiIZl4XW0WUn+PsdntZGJqRe+GLlG7XhcTkvVOky1qR31i1kMQKON0zED+5zdQcB7E3ZuS981WKH0piWMBf1BG3C+sk/dhruzuR8MgXSFqkDwLPfSrCgQRFRWbX6oNOzbDXd78wPB7oglrtBPCDQVbhFJk+gMys76KILN1gfgr2UUOoDUuLSkq4e3LrZV6UKnIqlgbgSHs5VhESE4FZcijxMUo2rWbRXun2J9ntQGpLhZfGyD02IS4Wtp0d512GysYqzeZRNzsXggicCJH1PXVJ3FqS1eF5lW1sobrCknunQEywQQw/JvHs9ZpdWwyNUZsOROSSC1MDn/bDIEeO4Bdul1SNfAcMJQVL9cwZglLoX6IpjLI8QOpyQmgKJdahzg8qcIetDr2Edqxs0l3OQv8waW9516jEPNAoMBUjWJErIXLz5n7Tjw2ihvjhm+bW2vi1hNzACD6ZOxbxlmOC/mAFUnLUW87rqlBc6aGx6Ylyw23jGrCF1z5tLjbkBaHl59Z/mtQmPobDrZxX8hNC7Mig1aESrrziE0SZUB01oaDU/De0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1f942a2-4a5b-4b07-38f8-08dc3f548ab7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 09:45:51.8722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0KfpcMaMBJesvTOQJgthhoQPkMnu5asaUUYIRoz8v6xzvMM9kcE5fetHy7nXTTMbU69aBNFkQPEJLVaG2Ymp8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6087
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-08_06,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403080076
X-Proofpoint-ORIG-GUID: pA4BJ25Yi6ZSoroSKCLcnAygZPPkITX7
X-Proofpoint-GUID: pA4BJ25Yi6ZSoroSKCLcnAygZPPkITX7

On 07/03/2024 17:59, Bart Van Assche wrote:
>> +#else
>> +static int dif_verify(struct t10_pi_tuple *sdt, const void *data,
>> +              sector_t sector, u32 ei_lba)
>> +{
>> +    return -EOPNOTSUPP;
>> +}
>> +#endif
>>
>>   static void dif_copy_prot(struct scsi_cmnd *scp, sector_t sector,
>>                 unsigned int sectors, bool read)
>> @@ -7421,7 +7429,12 @@ static int __init scsi_debug_init(void)
>>       case T10_PI_TYPE1_PROTECTION:
>>       case T10_PI_TYPE2_PROTECTION:
>>       case T10_PI_TYPE3_PROTECTION:
>> +        #if (IS_ENABLED(CONFIG_CRC_T10DIF))
>>           have_dif_prot = true;
>> +        #else
>> +        pr_err("CRC_T10DIF not enabled\n");
>> +        return -EINVAL;
>> +        #endif
>>           break;
>>
>>       default:
>> ----8<-----
>>
>> I know that IS_ENABLED(CONFIG_XXX)) ain't too nice to use, but this is 
>> a lot less change and we also don't need multiple files for the 
>> driver. As below, it's not easy to separate the CRC_T10DIF-related 
>> stuff out.
> 
> The above suggestion violates the following rule from the Linux kernel 
> coding style: "As a general rule, #ifdef use should be confined to
> header files whenever possible." See also
> Documentation/process/4.Coding.rst.
> 
> The approach to use multiple files in order to avoid #ifdefs in .c files
> is strongly preferred in Linux kernel code.

Then what about this change in this patch:

 > +#ifdef CONFIG_CRC_T10DIF
 > MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=0)");
 > MODULE_PARM_DESC(dix, "data integrity extensions mask (def=0)");
 > +#endif

The idea of putting #ifdef in headers is that we can stub APIs. But that 
does not work for CRC_T10DIF, as the APIs don't return error codes - 
that's why there are no stubs today.

And, as noted, this is a general rule.

BTW, I don't think that modparams should be compiled out like this. 
Better would be to leave as is, and error when the user sets them.

scsi_debug is complex, to put it gently. I don't see any value in 
splitting it into further files, spreading the complexity. More 
especially when there seems to be little gain. scsi_debug requires 
CRC_T10DIF, so let it have it.

Thanks,
John


