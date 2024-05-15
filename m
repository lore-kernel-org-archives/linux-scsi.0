Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124353A1DB
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 17:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715793758; cv=fail; b=oBotEfgeTQT6NYVuq6UBIu/w22YyiN33pLnJKOgu/KZdNDzoQ1ZN5mtzRCiuLRVeQUbApGbEZMCcBDk+jDtiO5tTK2wq0BAavhGP6fk2URDbMQokwfnYhZhp/50/h9BeU7Pzl7E+EMdobpO1/lK7naF7gCyiGuWX23KCciojqCw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715793758; c=relaxed/simple;
	bh=Cb9cZ04AtT12mygpAvI5a0Z7hpmdI9qDejae26iWkQg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PW6SjoFaExu4XzCxspX9feJzzWcpuxU6CyO6unhPj8Q50vvItiOpk+UhtZh4NVW34R9SuBFhMtmjYQHCWBsll7s2ehtERjiw1ZKziVY7ldFoSvuuJws+DO7FmV5zw59aql2+eFSQa2ocNvUsYKX17pWI9/o6pG2+yhMGINfT32Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Arag3kX2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=D8mRhkMB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Arag3kX2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="D8mRhkMB"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44FGTMYi010221;
	Wed, 15 May 2024 17:22:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=YaSQQu2U+A50SN4trPecCf0E/6nJGGXficxmRfNP580=;
 b=Arag3kX2wccxgnZN8yZs4sa5t0NT5GjH17k7mNjiiQLUhC83iJEUhTUob8v1cg33YuiH
 jhObOlaoUlajncuz5Gxb+PYd9VA6cI7FTAchFi3AJHojTcIf+X07OC/5yNT/lT7eP0W+
 6zHcJk3vJDwqJfxz/OMo2GtKMGY6d7jmEq66AFc673hHuWFiBJ0kk30HSRIhk8D2doo8
 ZIMEnKNVqDTmzSQrq/vj5dRpwLk1YCrAjwNanLMFBDhpw4WxFwBsXBPeTlicTJcB5Swf
 8W1yMqnDTVlyS8z+tlmhlksgJaypnkgB0dRMmrUwl4FDXVw9I7C7xQJQ2IWXXLjQOPZ9 QQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y3t4ruq8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 May 2024 17:22:31 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44FG1Gre019173;
	Wed, 15 May 2024 17:22:30 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y3r86n2cx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 May 2024 17:22:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AK/6q1CBktkYtvMzIJbrInFgyuvLhL2d9CG755XINQJaOVdmyw2PL1wky3CzfnEhFffoBcoISojQFOos6rQJQ0UQ1zr8jiTXYU8kmRV3KTrZ1oNYTdjhXTkuHJfuTei8So6fGx4U/feGxN6mFtsFkv4j3FDU7DduhUHml+WG6noBno6DvaUZ7KIvnzKIXjCQ0JAz3nxLkutso8/eBssAVm7nVfoTf+uR2N9JNlQ6/yDzzgKiLVxtZdov+xfo72UcpGGLMlGPK75hdOhMzUBL8Ot6I0EbMk+w2u0j1HrcUNR8nngZw7TpuPxL15d8dGbcTbotICNAfIIg7h4otN/pWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YaSQQu2U+A50SN4trPecCf0E/6nJGGXficxmRfNP580=;
 b=nVF4ceSSfrJR1yPM6a+poi/5+IMfPo5m/lBw+f+u3AgjvKUplacyMR7kIrgeeQNdowE6PIa+8le2Rt6M/fitGHq6RB4jRxwAHh/TzfW6/+HNAO4lsP3GSa2Mw68LDlVCcePPDPTLoCHa+Nu/zcxV+sO3BZgLQ/8u1IDi81aMfS9gsJ3u0by+Vz/Jkd83CRXXkz5dTZdDyCUXM303UpbhTZcjac19q7IV8wDqz0Nr6IUdeYkisPGnXXz01RIOG7ne3dgyRojM4sHGXecuKNX6yem7LaoKcbYkVdExfajPJyfPy1ZWyUEu8gsL89c9U+T7oV+2mfFD+QtEeAeXOJXM7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YaSQQu2U+A50SN4trPecCf0E/6nJGGXficxmRfNP580=;
 b=D8mRhkMBlA4aKKirbkpp0n7bO7y7hdAYE8vDNJYgQv6K/vNJJxnD8MsHjnG0JagVFiIR4aNvEsoNI+U0pIMeYTHEa/7RNWlr6aD2dXjLxK/PRoL4m9LlPsnK9+4YHzxmYuw5A+fJS/LB8XaLjqLnh9DmA841g3fgSWyfils5P8s=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB7251.namprd10.prod.outlook.com (2603:10b6:8:da::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.25; Wed, 15 May
 2024 17:22:28 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.052; Wed, 15 May 2024
 17:22:28 +0000
Message-ID: <43db1cdb-5985-4f3d-8789-6097c47d8ea9@oracle.com>
Date: Wed, 15 May 2024 11:22:25 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: convert SCSI to atomic queue limits, part 1 (v2)
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20240402130645.653507-1-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240402130645.653507-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0122.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB7251:EE_
X-MS-Office365-Filtering-Correlation-Id: c5b2c430-c5b3-4b08-77a6-08dc75039833
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?eXBBUDNuc2JDUW15NGVvamg2QWIvQVpXd25JSmVoa3RoMlFtME55Q2Z0QmxJ?=
 =?utf-8?B?cXJhOE5GbUh2NURyZTNwczR1VDBjdjA3RG5jaVpjUU9OaURGNFlWYWtkaVBx?=
 =?utf-8?B?T0gvOUh5bFNRWmhhMHdwSmJXUmJYdk0yRUFaTlhGTnluZnM3T3k3eG9XUS9n?=
 =?utf-8?B?YzR4OGl1NU0vSVN4UnFXQ1BuQjRBT3FzdDhmd2FiUDJYemRkSkx1ZWdoQzV1?=
 =?utf-8?B?d3dmbGNwalVmNEZveGxqeld0Ny9MUGpyQmRocXZwVldsOGdJb3dWR0habkRD?=
 =?utf-8?B?UyswVDlzQ3I2ZFh3K3E1NUhkK0pkd241aGZvbkpnYytkbmJhdk0yMDAyeDNL?=
 =?utf-8?B?UXJ0TlhJbjNpR1R0MVFpa0Z4Y0c0WVo2RHF4eDl0T3YvVzBNZ3pwaFh5YlFY?=
 =?utf-8?B?ZUt0VG5QQktSb3grNzBtNmhtWEp5U21vMnMvdHB6Mys1SDNpbU1UUEg1VzRN?=
 =?utf-8?B?UnN3Mnkxbk9pdG5KNENoWlE5SDk0d0dueXFsUWFad0tmakZ6U3VzcVVRYTlO?=
 =?utf-8?B?UGhMazM2ZDJiMFhsaERQVVNIc0lrOTQ1bzJJSVpPdHZxNzF5RXRZZm9xUWFS?=
 =?utf-8?B?ZmxocTNkV1RSZm41aDFNZzhNejQ0K1hrVWhzdGI1UGFidWFBZ1NyeS9wNHN0?=
 =?utf-8?B?dFlxZjhScERyYUpYRFZzWXoxcWNLSmZLSFV6SzVvOS9HcUNjNFNZY3dXcWti?=
 =?utf-8?B?c0JIc1ZIRWRRRTRBL3RVRUIvYzR1eVlqZXdQWmQwYlM2NGNRUEFFcDVqeUF3?=
 =?utf-8?B?R0xtRTVGQjRPSWhsVkM3eVVneFp6Y2FZemZhU3B6bVBUWkc3emRHMVlsYWZ6?=
 =?utf-8?B?MWlQR3IwZUdSUktweDRlNGxQZXplRTZvZlVMR3FJd3A2RHY2endaTzQ1VGM0?=
 =?utf-8?B?cFltcEZOQW9kRXRRTjN3SmlVVFlHNkNRUDF3SmhmZFJtQ1FtUWlkRmV2eS9n?=
 =?utf-8?B?UTJYenRsTm1pV1hUME5jU3V3TmMvdEw1d3ExdXRFTFVWWFcvejlTeElCNFhD?=
 =?utf-8?B?TEFORHBXVjRSUThzTGxkY3pSVnZLSFRvSVByZ2QwVEpvT3NZWmp1eCtZcGF1?=
 =?utf-8?B?NmRqQjcyYklKYzhqWXppY1M5cFpqNjg3VnpNMXZXT0tuMERjK292N3lmWnhW?=
 =?utf-8?B?d29oeUJIY1hCOEl1c0l2MVZpcjkrTmVTY0JFUSt0eGE4a0VqN3BOc1M5cEt6?=
 =?utf-8?B?N2JHYTU4Q1BOeWhveTFaOFR4S2UzWTd1d1RJSDRCQTd0ZjRkMVhyY2RQaFdS?=
 =?utf-8?B?VnhlQUcyZllFTGRHd1ZpQk04THJOb2RpV1htUUxTK3dBUFRhcjBDK2c3SEM4?=
 =?utf-8?B?OWJhNGEvQldpNHNHcmFBS0ZRbGZCcDlBTFZPVDNVM3lDMjQrS0Raa1kvd0to?=
 =?utf-8?B?Yi9GQStJMzlkOHNXV0RhSm5velpCczZoczFCdFduTEZvSkVTcStEREM1Sk11?=
 =?utf-8?B?Z2dMdmlzb2NiSTFraXo5eFBBSGxDbUVOTE10MGIzNjF3TWJNbUMzVllLczZm?=
 =?utf-8?B?ZXVQMEZIcW1ha203TVkzZ3RJLzVhVFI3bUFDSkUvL2t2SWRyd1JIOElURG9i?=
 =?utf-8?B?UXE1Mys4NmV5TnVvTi9qVU1DcVJYaXl0RndMeTkxcmlqUm1LcVJhWEFzd3o1?=
 =?utf-8?B?cWdZT0RhL1BUanBwWFVyR0hvVmpVN3c9PQ==?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?UERXZmxQN0g3ZHJJYTVtUzlRdnRDZjYrcmRpWEdaNERPYUU5aXNvNDc5YTZE?=
 =?utf-8?B?QzA3SHkvdkRPS1h6cTY5U040bXUrV3ZFSUxSODFoT0txb05TWGpZc2FNYWFW?=
 =?utf-8?B?K21IZ0lTalh2T2dPN1FwbUlwY25kbzQxODBISVlQTEg0UlVZbExUbElybVBo?=
 =?utf-8?B?WlZrVGZ1Z3pUbFl6S0VEU3MxSTh1RnJxZ2lMYnpWK2xKTGdjellqeEIwbXlF?=
 =?utf-8?B?MlpWV0VVUGkzVXMyRXdFZno0QW84Tkdwd0I5ZWhhVUJ5Q3RNK0gvd2FsSWgx?=
 =?utf-8?B?YTgxcjBkSjIydCtPNzBic0tYb1o4clRoVUE0WXR6QzA3Nlp5Zkh6L0lZeVox?=
 =?utf-8?B?SElkcnpteWNkZkQ2Zk5QTU13UWJPUUhoRUUzT0FvNmpMeGcxR2J5bDN3MVAw?=
 =?utf-8?B?eW1NbHNCdndIaE8xcGJpTUdrd1I3TG0zdWpieml2c1NiYXBxOVhGcjI0YmNF?=
 =?utf-8?B?S1F3Y0M0cTY1bUxwVlUrb0NqREZLczNxaSsxeitDZkxiNXhBaTh1WUxNSWlG?=
 =?utf-8?B?c0MwTVJ2WDBEN3JZZlpxT2Z6WnhiUFhCYm1pVmF0aGFCUk9vMHVvK1BpRHVh?=
 =?utf-8?B?aXVWSDBObWNsMHM2SGpvMkF6Rm81N3J3a2xYdWZHcFoxZmZPT0NPSFcvcHJx?=
 =?utf-8?B?VFBKR3pDeWp4SUJreFl0dFZKL0ZaanltbTJJMElSVVdvSDFzVFhLSTR6SGxE?=
 =?utf-8?B?djM1bEpGYUFicDFEYlhGL0RHRXQ3Nk0wek80a2pTTHF5b29NRHBLSWNFUVAy?=
 =?utf-8?B?a3lmYy9QSlM4N3lmT3JBWVN0cnhxaXBUTlZlb3ZibWV4dFVJOVo2K2dxeXhF?=
 =?utf-8?B?clhYdFZXOXhDNUF1ZlhpVHhhT21PcVJNU0hkbExydTlraWdNaUFwUlZhblMr?=
 =?utf-8?B?ZWN0M2ZrTzVFeUlGS3ZLSjdHUk1zTnBTMzE1Mml6ZElpTnEyUFdja3ZRalhz?=
 =?utf-8?B?WGEzZ0h1QUFPR0MxYmxrcVg5NGVYUGZGbHpsSEpONDViTzdiVHYvaHZqaU9L?=
 =?utf-8?B?aE1IVm82Q3VlZnFjSDRQS1g4OGRFTFZRMlJudkM1WEExWHoxemk4emJkVGxm?=
 =?utf-8?B?MHBMRjAyV0lvRm9VSFFiZ0pJaFNhV1pPZWJGNDBnZmdXQ25KbkI2QWppdE5w?=
 =?utf-8?B?aUYwSGsxaE4xd0ZrQ2VDRGxSVksxaitVU1QrVzJiTGxrWFM0SFBzTnAvNjBX?=
 =?utf-8?B?dmtJZWk5S3d4YU5NQytTeE9TMFZvN1BNODFyYjg5WlVSdUJLejc5anFtS242?=
 =?utf-8?B?QXZYSUNwYVIvcGdSYjhMQVNuWld3dzdBcm80emptQTVkRU5ZbWtXUGtqbmxl?=
 =?utf-8?B?bjZBNW5tM0tPMmlUUDFNTDJzd3ozTCtmUlRUYUxKQWIxTTc2VVorTENWWmZI?=
 =?utf-8?B?VGN0T3RwMVRtbU8zeVpDRWR4c293ODQrN244MnlVTG5HV0ZxQXdjZlBZWEJT?=
 =?utf-8?B?YzFBV3lDUEhaN3J1bFJza0FkMngvRWMrejgxL3Z0MDBpQ2Ntb2RLTnUyNDRS?=
 =?utf-8?B?ekF2SjlhTHpyYThqcWpxdkpSS25sSnFEWDhOTCsyL2paQnQ5ZzltbUJOb0Ru?=
 =?utf-8?B?eHVNWEREL21NdUprNnZ2WkxSK3k5MFNET2xJeUllN1NlZ0U2NGlMOEpPRnhj?=
 =?utf-8?B?ZnQwbmJzQU91bG5nTkpxd253Vzc5VEMxZkp4V0JJMkltaUtRMUkyWnpNR0RR?=
 =?utf-8?B?d0JSam96NVFGTEV6U1FJdm1WbTR6TXpzTGRadkt2dUxRK2RYaC9xOVViY2lN?=
 =?utf-8?B?M0ZtS045QVhGMUZJMzJrc2VIcVdrTHFpOVdXaDhHWTQ0QkFXa3MvQmEveTNo?=
 =?utf-8?B?dklTcytzSDlYSjZraEdiZlFYanUrTUYyZEowWUZuTkFxbnZTUTF3MWZEamxK?=
 =?utf-8?B?QUlhWEdJS0ZkRkNNeFF2a1JiM1dLVHMxUnA1TVMzZ0RQc0g5SWM0enZHU1dN?=
 =?utf-8?B?WXB2aTFlTm5JbjA0dThrQnR1L0w5SUZBa1YrelowUzVpVWU5Tm9ZRTNSVFd5?=
 =?utf-8?B?ZS9ubmdQYW8wQTliS0RjWm02SUtsYTdtbFErNmRyZWcvSUc5RGxjdzhCZUFw?=
 =?utf-8?B?R3JUUzJpSitRRmF4TjI3TE1reGVVMkVUYTVDa3NCd0tZclVFRnBYV2pwYW5r?=
 =?utf-8?B?Ukh4R0luUmg0a0FNNkNFK3cwZ1hUb24wYUZURFovUVU3eVNYWWpCdHNuZ1Mw?=
 =?utf-8?B?MFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	1l5KGdy4iecaHe00xs23oQ3Ib7Rxw1F/HoDJvZOvMv7nF/ao4qV7Gn0XG99BFZjRY50Hk7DrV60rGBzm0Oik3CnMgEbsMoxqXT1a5H5mihksrl1cJI2rcz1sCyvEHqoWStLpKhWwr79t+a/Av4uCjZFNeK6aoUlBeSA6l7itGZPfmSTz2qWGEi40cq/U1NaikVtlmZBLTj/qfJrxkC1LwNx3fEYQHe0vy8ioVvTEgyO94XzbteZVh4qv45GG9MbPx2JpKoY+djJp8DsdbGtqZJ4EnUWmrZSKvkAE0PTb/9cnGS8PuPgMso1R9BkrrAwoh4QQ1pCQe0Bk0YcUWFMnyZXyMmpQRsfCDc4VSEAHwyF5uHQNNfsJ39kIFwO3h3bWtbEdKhNegHs69DO5hU5D2X0ZdUw3j54U3uLTA9eRTG8ORRUgmYewDrFa4HrpRehcfZTBGL3ztUkg+Hz7UwbeQkgory24CCGHxwqM9tQuF8Vt8lujLJ/ZXZ5Gu4DJHxO/mchcXG3uSzgAItWvzAWD2i2wlm9uQJQhQNQ9DSG8Wdqis040dZwiwrOpT5MQObBzEjN5Vc3+dFI2Hym7n2Rpl+HGq5IYrlpetKBOAhNh7/0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5b2c430-c5b3-4b08-77a6-08dc75039833
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 17:22:28.0473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4QwyM5PYwx3rAqAmWAc2c/DgyERmaHb+/kXN3jCMRzoeHtUTfwzov7m/dbs7+XHN4H1pbb1O/Lz+6lCThjjMww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7251
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-15_10,2024-05-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405150122
X-Proofpoint-GUID: GvqWcS9FMW1dsWBtaUBxASp0px5spaeI
X-Proofpoint-ORIG-GUID: GvqWcS9FMW1dsWBtaUBxASp0px5spaeI

On 02/04/2024 07:06, Christoph Hellwig wrote:

(reduce list)

> Hi all,
> 
> this series converts the SCSI midlayer and LLDDs to use atomic queue limits
> API.  It is pretty straight forward, except for the mpt3mr driver which
> does really weird and probably already broken things by setting limits
> from unlocked device iteration callbacks.
> 
> I will probably defer the (more complicated) ULD changes to the next
> merge window as they would heavily conflict with Damien's zone write
> plugging series.  With that the series could go in through the SCSI
> tree if Jens' ACKs the core block layer bits.

What is the idea for dropping blk_queue_max_discard_sectors() call in 
sd_config_discard() -> blk_queue_max_discard_sectors() and the like, 
i.e. the ULD changes?

I ask, as I am rebasing sd_config_atomic() in 
https://lore.kernel.org/linux-scsi/20240326133813.3224593-9-john.g.garry@oracle.com/, 
and I wondering about introducing functions like 
blk_queue_atomic_write_max_bytes()

Would it be better to start with a pattern like:

sd_config_atomic()
{
	queue_limits_start_update()
	//set limits
	lim->some_atomic_limit...

	queue_limits_commit_update()
}

Or keep as is for now?

> 
> Changes since v1:
>   - print a different warning message for queue_limits_commit failure vs
>     ->device_configure failure
>   - cancel the queue limits update when ->device_configure fails
>   - spelling fixes
>   - improve comments
> 
> Diffstat:
>   block/blk-settings.c                        |  245 ----------------------------
>   block/bsg-lib.c                             |    6
>   drivers/ata/ahci.h                          |    2
>   drivers/ata/libata-sata.c                   |   11 -
>   drivers/ata/libata-scsi.c                   |   19 +-
>   drivers/ata/libata.h                        |    3
>   drivers/ata/pata_macio.c                    |   11 -
>   drivers/ata/sata_mv.c                       |    2
>   drivers/ata/sata_nv.c                       |   24 +-
>   drivers/ata/sata_sil24.c                    |    2
>   drivers/firewire/sbp2.c                     |   13 -
>   drivers/message/fusion/mptfc.c              |    1
>   drivers/message/fusion/mptsas.c             |    1
>   drivers/message/fusion/mptscsih.c           |    2
>   drivers/message/fusion/mptspi.c             |    1
>   drivers/s390/block/dasd_eckd.c              |    6
>   drivers/scsi/aha152x.c                      |    8
>   drivers/scsi/aic94xx/aic94xx_init.c         |    2
>   drivers/scsi/hisi_sas/hisi_sas.h            |    3
>   drivers/scsi/hisi_sas/hisi_sas_main.c       |    7
>   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c      |    2
>   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c      |    2
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c      |    7
>   drivers/scsi/hosts.c                        |    6
>   drivers/scsi/hptiop.c                       |    8
>   drivers/scsi/ibmvscsi/ibmvfc.c              |    5
>   drivers/scsi/imm.c                          |   12 -
>   drivers/scsi/ipr.c                          |   10 -
>   drivers/scsi/isci/init.c                    |    2
>   drivers/scsi/iscsi_tcp.c                    |    2
>   drivers/scsi/libsas/sas_scsi_host.c         |    7
>   drivers/scsi/megaraid/megaraid_sas.h        |    2
>   drivers/scsi/megaraid/megaraid_sas_base.c   |   29 +--
>   drivers/scsi/megaraid/megaraid_sas_fusion.c |    3
>   drivers/scsi/mpi3mr/mpi3mr.h                |    1
>   drivers/scsi/mpi3mr/mpi3mr_app.c            |   12 -
>   drivers/scsi/mpi3mr/mpi3mr_os.c             |   76 +++-----
>   drivers/scsi/mpt3sas/mpt3sas_scsih.c        |   18 --
>   drivers/scsi/mvsas/mv_init.c                |    2
>   drivers/scsi/pm8001/pm8001_init.c           |    2
>   drivers/scsi/pmcraid.c                      |   11 -
>   drivers/scsi/ppa.c                          |    8
>   drivers/scsi/qla2xxx/qla_os.c               |    6
>   drivers/scsi/scsi_lib.c                     |   40 +---
>   drivers/scsi/scsi_scan.c                    |   74 ++++----
>   drivers/scsi/scsi_transport_fc.c            |   15 +
>   drivers/scsi/scsi_transport_iscsi.c         |    6
>   drivers/scsi/scsi_transport_sas.c           |    4
>   drivers/staging/rts5208/rtsx.c              |   24 +-
>   drivers/ufs/core/ufs_bsg.c                  |    3
>   drivers/ufs/core/ufshcd.c                   |    3
>   drivers/ufs/host/ufs-exynos.c               |    8
>   drivers/usb/image/microtek.c                |    8
>   drivers/usb/storage/scsiglue.c              |   57 ++----
>   drivers/usb/storage/uas.c                   |   29 +--
>   drivers/usb/storage/usb.c                   |   10 +
>   include/linux/blkdev.h                      |   26 +-
>   include/linux/bsg-lib.h                     |    3
>   include/linux/libata.h                      |   10 -
>   include/linux/mmc/host.h                    |    4
>   include/scsi/libsas.h                       |    3
>   include/scsi/scsi_host.h                    |    9 +
>   include/scsi/scsi_transport.h               |    2
>   include/scsi/scsi_transport_fc.h            |    1
>   include/ufs/ufshcd.h                        |    1
>   65 files changed, 347 insertions(+), 595 deletions(-)

