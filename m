Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DBC2D796
	for <linux-scsi@vger.kernel.org>; Fri,  1 Mar 2024 08:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709283601; cv=fail; b=EDpYrIdP6+Xo7Xazzd+76zuG0/AG4wAAYjbSkWSk4SaGYK5pFLjiIHtyZ+3ooZIAwlBDiwP6Dv5CFb/l8Vzej9kK/xSS7lmr5nAAbPa0Q/IfGtcPYPzXi0wKTxYrEiOqdjy91MVz4BNesWaqkxlroBl9CwGupHAwQ6bdujTNAq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709283601; c=relaxed/simple;
	bh=VechRQtGu3wGp+UYkchR1vr0CyPFjPt6NOon6q3ZPpo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NWURQQyEiu84eiAUC+6zz8DE9eE737LXgo83EqunVaU+u7y4WbHEDhISadQWD3lABfwf8ZBJI77w/Ju21Qshx2PcUCEFEVhuPkA3qqKQVyj003ma4k3CJXxxEdGF6sS7ZZC3eP5vhjin9L+PNWoEYQRbDI3HnaRWGIw4tiw5Sgo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i0KLaYBL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JOieylUF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i0KLaYBL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JOieylUF"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4210iYZT013104;
	Fri, 1 Mar 2024 08:59:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=+K/RvwLCXrJBVESlQ2HjrTPsTHGvW5uNOQITp795M0Q=;
 b=i0KLaYBLEXK0k1LQaKH/ZU6/wdOIpkhyXA47DWwNyM7N/23PhCyV92NfUKP9GEJv5B5N
 zXvuo7zqom4IkKaKDD7/YiIjhdCFhaJCVPSU2BxJuUk1wrB4hj4WJyL8KtV2FzTtjc2G
 KDgbrJdj3IYb+V3ClFJBpEJIoyKAj/OZOzhDnfMjcKCE5WI03NYg2RT7Tt/kTQk0rmnE
 l0H5MgPKVjvgOHrkIdkAl+gy6jnVmS7L9+GIsi2fhgJWl1g5p4H/wQoOms0EK2ju6a8b
 LYrwzlCggVLWXeBpbXeHM/NfTLRYPc8eGyLoTlcWY1Q/a1oM6WKJffwIbEsoBStdBKyI hg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf722r5hn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Mar 2024 08:59:44 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4217pJv3022335;
	Fri, 1 Mar 2024 08:59:44 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6wca0j8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Mar 2024 08:59:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UXB4mfDFAyWl6LfyfzINcTuPlNiPj+TuIuqyADBNv6WhKOSOGvA2QJBGrhMfK2SXMVhY/K3WjxqVD1ecDlNrDiwJryNl5Ojq9KAjsvV8Av55c9bPQ5agJo5JTpIze+ZhYaQEA3bBFJkRBFXBcvizvn8QnNlqgeAkouykTKescyAPCPH9BbiFU18fNA6fBr8grA0dYGowQIsc512U0iIvp8Z9u9GPW+aZT+rywWy5yVQF5IHOgR9Q8fcbFkGZ8j8K13MOiV0FGXnODf1qo0zL9aBstOoXQZhwUnomcE3PRLWBnxns3OEWCX/Z3EcYMzIvMmuJTDStlyq5qeaaf5Sumw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+K/RvwLCXrJBVESlQ2HjrTPsTHGvW5uNOQITp795M0Q=;
 b=Xmoc0mjJKrzpRotsrVmqFCkYWtEytwkKplaFxBc6ku+fV3iuP7fR3q6pWC0fSRhhGpkf4PoBS8Sjads0axFTFe/TXjBe6KyzMynny/K726cdn+tiAHr0MBQKP/DYiVouCFF/TPzYMhqPAxhScj2kf54AspbikiEse7JLbeQZBTBzHHDa9T73Wdf9MdavHGhQNn6ASE56ZuPr/joBiXxvO4N6CXufB8GTifSEog4JIm/ydj77kHfxhOj+6ptoStd3vSa0+VTMdzHjaC525yhBEy2n6MhS5Y6MAnskdbOKIuX9wz7FxZz8qRCj0z3D6vxflg9PvkFiaHlYBs9I7IsWEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+K/RvwLCXrJBVESlQ2HjrTPsTHGvW5uNOQITp795M0Q=;
 b=JOieylUFpKbcs+0zbpF4u1eD5yTTmH/NkZSQwQOrnVWdyUKZonMAcKc0/4ZAqdP4Ubtv34ww4XcjkSNlDTDQMITUrhM0GQvLTE1CCVsCW/FII8Dsi+qW93XuOnYKNjsLg7KodiP4jhxDpCPF8pWc6d1iA8AhLdpRrErZ2ERVc7k=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB5726.namprd10.prod.outlook.com (2603:10b6:303:18c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Fri, 1 Mar
 2024 08:59:41 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff%3]) with mapi id 15.20.7316.039; Fri, 1 Mar 2024
 08:59:41 +0000
Message-ID: <d94983a5-9c0c-494d-8fb7-51e3dd2d3460@oracle.com>
Date: Fri, 1 Mar 2024 08:59:32 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi_debug: Make CRC_T10DIF support optional
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240229172320.2494100-1-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240229172320.2494100-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0034.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::21)
 To DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB5726:EE_
X-MS-Office365-Filtering-Correlation-Id: fe1239bb-ee65-4a92-4921-08dc39cdee80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	SPHeXHdOUyuwMfCOQcndHJMIIGaHHKKaExB6bsI7iBE98ZsKj6rNXE1hTgU9UatAuaF2Kk+vdsBa/90ael1ea3no8lQiolLHEkBuNREiisj8PJKuBN/a5TiPz59K+Z6eapRSYNec7Pk/PKcdRfjr2b2bHVCTBDcY/dVU7iA872KckbbWWHHL43yeK34mUbEdeq1HzISdYSTJxfy8LuN7dMxi2z3GsDR5P3E8DfV11rdbhdhEJ6+AZ61oTiSlaw9/Wl40wsI+vgt47RMKQVHajY9DNoerXOdswQXCW2Zf7IoroEOrXZ8tFfFhbOl9LgAxCEYTwo8itrrDRpsFcGXh0Bga9IkpcgXcEfl46UriZkb5dtcVgq6Lh796uzqHCcqyMDvoK4PUCHgefr0rqLzSPqAbhKIMRKNulZwwDY9pQWRJtM+zCU36Eu6mZ6uhH4PDPJfeleJ4nvX/NYXGUle1QoB0fV/AIN5EzGPapVF+NgblDGGoNejNaaa0v4eGs2OXRYHq11uuQHQn50bKh/zYwmr++DR+rx1nB8PShKaF0MSl1nRDeHVrfP3M2G7YjMRvy97vOZMFTJr2NLE8yCriPynUfIK6UbiVHY2dav80OQ4DNHLPeSpRvhmISXnhjSC9d+Ll4YdMqJIBrdDJWaEYng==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?VG5KOUxYUkZRZEFpWWVqOU9PdUZyQm5vZ1UzSlRDekZjWEE5QVQzYk1EZ05Z?=
 =?utf-8?B?OWdvOEQvcXpySWdtTDFjYWoxNlh2WlV4bXBSNHhKVDNqQmZPV0VTWWpKWWRY?=
 =?utf-8?B?RTlteEFhU2NMWGpabTJQZGwwRGpjMklCV2VrYkxYUXp6aU41c0ZuYTdrQXZV?=
 =?utf-8?B?N0M0aWxDVE4rTS8xWmVwVk0xMHpnUS85dW5hNFNxejdvVjFmdHgzVzk5elkx?=
 =?utf-8?B?NElEQVQ4bFpUNnlOYjZkM2h6NnJCN2Fqd2hxNERSMnFhY3NvUElJOUhCREhV?=
 =?utf-8?B?SVl2VVpzbzF4Sy85UC9zTjVXWUhHbXA0ZXY5YU4zYkdqRm8rbUh1NjJkcjJ0?=
 =?utf-8?B?ZDFURkI1T3IvbWxGWVVHZHVsSnVIdldtT0NJMW8xdnllZG55aXFFWXZtMGJh?=
 =?utf-8?B?QXU4dmZhb0wydlprUFM4SVlHd0V4eWZEVVhPTXI3RnI4bjY2azFoeWVZVi9O?=
 =?utf-8?B?ZmJoZFNWMyt6QzdvZkl1MnRrc256SnlqcG1IMmJpdVNHWHRxbmg2dTMxNEp3?=
 =?utf-8?B?UXh3UW4yMG5qK1JqR3ZLUGFaM2Mza25rWVhJa2RUQkp0bG05SnM3cENXbGM5?=
 =?utf-8?B?c1pwL1lXc0pwVHhuc3JTYlNqWEhjei95K1RtRFpBUkluQWgxcnI3VFNZU2FF?=
 =?utf-8?B?akJVNTcyV1Q1OG1yTGtpQ0NCNXhDaGppUFR5clZ2bFlCcTBBeVl3eUdCTURv?=
 =?utf-8?B?MlNhbEVPNjdIZWx6QWprR2ZzczNBeFZlMk9QQk12VXEyVWloVmtTTlRsZ1Uw?=
 =?utf-8?B?WlhzcGxQeEtXQjJMSzNGVEhwdGh4WHd1ekltcWk1djVPbURxQ1lxOFNweTFR?=
 =?utf-8?B?TlB6U2Vpdm1KalJWdzVZeGJLSmgzYjdqcGtnNHBlejgrcXlWV203bllBY1M2?=
 =?utf-8?B?VWdmUEhub3pCeFFodk1La1Q3a2VHVllROUZ1VnRBdmQ1Yy9rWiszWmNRMXlq?=
 =?utf-8?B?WkZmT1lBYVhWRXlZa2NMTnBXT3JSMVR4WG1kTGhTRnF3QUZadVNhSElxT0lF?=
 =?utf-8?B?SDJUSXFqT2lZdGpqOGJvc3FIb1k5ZVcrSVVxV0d1UHJzNGZ6ZGY3Zlo3dnBl?=
 =?utf-8?B?b1VZUEVyemRiK3NRWjg4b1E1cm1ueUJYS2hUdTMzZEU3MnYrWTdHclUzOGlw?=
 =?utf-8?B?RjhaazhUTWpWSTMxc204blVCQUFoRk0yaWxLU3FFQll0NWFLSDd6SmszSFJS?=
 =?utf-8?B?MFl3ekVmSjl4c2xRMGs4UXhNWTByZXNZNUVVajNPdTZqSVgyK29HMlNOTkxm?=
 =?utf-8?B?MW8zb0VhdlQ0d1p2OE9wMGovWTc1QnFKMWhOVFdFaTNYM3VwcUhVeW5Ea3hE?=
 =?utf-8?B?M3YwMWw4MjMyRnFEWSt1akNhcVJLajZCbkpqWnpUREpVNDBOVFBjdUNkRlRk?=
 =?utf-8?B?L0VPazNIUFl5NzhXa2tveGhVT2pBK0NKa1phUWhqOTViWHpMUUxLS3JxNWps?=
 =?utf-8?B?MFZrYkJlZTBLam9KYzdHMUhxdzRtbEZiemNNd2JrRjZTUTIwckhhWEFNTDh1?=
 =?utf-8?B?YmtOdWc1MisvUGRiUEVLUmE5ay9KOTE5NXhWQzcrQk1ybFFsTkpPcEZrT2Vh?=
 =?utf-8?B?OWJvYXRPZGhtaVpaN1NZSXZCYlNwcEh2bUswdGhmRkROWndGMndrYWRpaE9B?=
 =?utf-8?B?TFVpZlhWMmZCQzduTDlSalpxVVMwOEtxcEhWeUFWdld1M0JySGZYVldnRjlE?=
 =?utf-8?B?OWlzb2tVTXV4MHZHVk5zRVRVem5UVEZmYWxwTVZQMWRFVDhwVmNQQUVBQVhE?=
 =?utf-8?B?SGRFRWthbEdzTU92VFZRcUp6K0xMVnNnMW8zNCtSZXR6Rmk1bjdOdXBHVkRO?=
 =?utf-8?B?Q1hwN05kdFlPOE9KVjhYNU1CMG1KM2srdVFodlMveHh4cTFxSWF4UFJ6TVJT?=
 =?utf-8?B?Nm11NzhnMmJMaW9qLzBOQ3NsL1VXWExYUVNtL20wNlNEMDhuVEtGaTJWYXpJ?=
 =?utf-8?B?RXppNDZldDZBTEFuVXJxRkx3OFYrTFAxcHNna0xTYWtDb0NmVFVWOGtsSUli?=
 =?utf-8?B?VGpUNnNYcjBHZ2VTRUVnL1pJUHl3NFNNQzZGVHl5QzNqOGJnQ1Nza2kvNnZ6?=
 =?utf-8?B?MWZWTTRxUnFYTGM2aGgxYjlhSzA3S3JNbG5yWk1yRWZLREg0RnBCcnRQZmll?=
 =?utf-8?Q?yL+Cc7C06NTmNn3xfjlZ+4ekM?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	kqpjfr2Shrl+QxPvu61+whkv8+QSXXPyrUcHx0qkPEqVXDCLQgB51vm1XPQEWSV7DwMPte8iszHFQOYrWBvBZyWDIgfXUX4iNCSwfxJWX0MvcrDVt93B4aPLN1hiEgKMEv8QPw9D58XKPz6byYlGT1eqSGF8BpsqFVpfJIen9i5hOrUy/YzNGXhca5WaLxYaTmJ+WP602Z/fhlcwJ9NL5o0kC3XRLvclR5Iqch42Ynk7cu8rpvUcQILJlaliYQBAP/Xtjgf6xdAwSNF/ap7tHRDK9ldnMc6tUcI0yLgjiFeLufkxUN9FZIVXheQ8mFPNs3Siq8zOLOT/++jXDZa3RoRbhZEk4nHmhGqSVIuUlvF56xJrQx0aWbVjTA8DMLdWv6ry0kfUYseEafB3vRpkDWP2U4kO3m29Z6ASIfQzFIduXOByONkctyKTQprLqZCweSIulYSesjiNi69y798Jv71D5T+3Ji18/hPjNAKUco/fNRbTGHpsDqNylgYWbqS0vgdiMziFBxtWx8GScBYTAa9DW3QTKlm4EUsQdTSWtlpR6D+oSQVb8I4bjWaPYxwXyl/2IDHhxql1cG0rHXhD324URvBErFuFaxG8pWRFDhI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe1239bb-ee65-4a92-4921-08dc39cdee80
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2024 08:59:41.5694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ASqqj10EAFI2gJ1zxyG0vzUbryV6BBHy1SPINBR+lZxN5I5YKoYJQQfPm3WU4ebkZq1p7L5+dUjAUtDW9sh8Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5726
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-01_05,2024-03-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2403010075
X-Proofpoint-ORIG-GUID: Oo2-2MgmvuQOLMqPKbez-wRbnvn2HGZ7
X-Proofpoint-GUID: Oo2-2MgmvuQOLMqPKbez-wRbnvn2HGZ7

On 29/02/2024 17:23, Bart Van Assche wrote:
> Not all scsi_debug users need data integrity support. Hence modify the
> scsi_debug driver such that it becomes possible to build this driver
> without data integrity support.
> 
> Cc: Douglas Gilbert<dgilbert@interlog.com>
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>
> ---
>   drivers/scsi/Kconfig                          |   2 +-
>   drivers/scsi/Makefile                         |   2 +
>   drivers/scsi/scsi_debug-dif.h                 |  65 +++++
>   drivers/scsi/scsi_debug_dif.c                 | 224 +++++++++++++++
>   .../scsi/{scsi_debug.c => scsi_debug_main.c}  | 257 ++----------------
>   5 files changed, 308 insertions(+), 242 deletions(-)

That's a pretty light commit message for so many modifications.

Thanks,
John
