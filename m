Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26678BF5;
	Fri, 12 Jan 2024 02:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m2eEKIna";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="r1yI6tAQ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40C1AGU1003382;
	Fri, 12 Jan 2024 02:43:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=Y9SL7yI5BRiyiY4IKFm81nLgRWkQN+jZyEvmTnme76Q=;
 b=m2eEKIna9D99qHR8fbnGM1Zqpo3Y+SFlRfZ0wELNf3cAVF6MX3V1dOGEhgMCWjieVviF
 TG8RDPwvmZDQd72Xff63ova98BYOBfZ+mSHKIvYJhJYFpXFWrz38r+Zll8zbvL87vmkb
 2BaR0qYiq1vT4hoYY4YfyzPcTktLwz7PFvZv7XvBi64PgZHBKGws9kv8WOMTfEhxGLPi
 Mq2qG6ldToRTMvt/Y0NbgsyLoo9wfLVSjlKRGSwYRUeisURoJL+iW2u0aLnPIA8tCTM5
 HVFkWZTb073M8BNMcBXgdmlwVDTxOl+b4QX0S8DCo/OaOcihIUEaZL+zNuseKXVFWzzh Rw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vjnwv8yhj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Jan 2024 02:43:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40C20iHA013731;
	Fri, 12 Jan 2024 02:43:30 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vfurfmuh6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Jan 2024 02:43:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RPKaS8m9SUEtCBymO/gSOFqw1kYxgGpk2vTM7IfHODkahYp1VOGEvwSecJIRyRVb5yTbyQDrVKl1ipLDusm3WWvArUb3cvGHELSkA374HrlMeZw4asQT2sFTwSu/tcGdmzhXM0eto4bFmrD1ZrjAUlbc0BrvPi7scRH9GDRO3A6V07Ut6R5MJnBXdngwTDBsoqGSaLmG9S6CqyvCKYvjtOWHaPayNOdpSHuGBQONAXILggz//RPF9Pvzj/38XNX1K2BpXbAOeDJqG0ecKV086WR/E/fz9K4ysiorSIplG5mCXlwt3Nh8K6bHVn5YWEYgYF9Je6Iz0YHkXmmrszbTFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y9SL7yI5BRiyiY4IKFm81nLgRWkQN+jZyEvmTnme76Q=;
 b=QR37HvusCl2VX2khd7c03RgAmaVMLyPHvdNezpMZIH/8DuwTQKGuibdzemnjQtGZOdPAreX/9pz84YibR/InURv2PQtDhH09mz+56IRsNCOIS2TRZrO0ia8fkzjdaOtlsvleV4mnL8jh0WaqE9gTfwUWGlArpc03NsJW6GvHrSS4Rr8LRgFHm9N+B83SGs5NascnsY+L8A2ZrG4a5I1xyjqB2qybu3+flT+sv9P0W6dnc9tPXVQ2xYMBBUBMcRcowIkOVheR/SPLCF8B+JFZMht1ZGc+PEX5mXCA49T8HxF1eiVjkJ8I4hxsLGlZ0jL9vflvyZLKqGXnI13iwS2IYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9SL7yI5BRiyiY4IKFm81nLgRWkQN+jZyEvmTnme76Q=;
 b=r1yI6tAQYQc7AxKvbkk+Z/XIo6SFBLCpF53jaJOMxelk+bHGM6+MB2uHiSmXa+VwG5gGWzYeOKEQqG3rq/6i1Ol+GvlYuD4zbnJ4y27zrZYdDHPJ2OMYxoyPLzfnoOrAzeBhf5zz7QwHcg9EqrGv7OSUSjmA0aknloDXcWnvPRc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5700.namprd10.prod.outlook.com (2603:10b6:510:125::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.19; Fri, 12 Jan
 2024 02:43:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972%4]) with mapi id 15.20.7181.019; Fri, 12 Jan 2024
 02:43:27 +0000
To: Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc: Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH] scsi: target: add TMF to tmr_list at the handling
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r0in46gu.fsf@ca-mkp.ca.oracle.com>
References: <20240111125941.8688-1-d.bogdanov@yadro.com>
Date: Thu, 11 Jan 2024 21:43:23 -0500
In-Reply-To: <20240111125941.8688-1-d.bogdanov@yadro.com> (Dmitry Bogdanov's
	message of "Thu, 11 Jan 2024 15:59:41 +0300")
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0485.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB5700:EE_
X-MS-Office365-Filtering-Correlation-Id: f48d4d91-f6a8-467a-b1ce-08dc13184160
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	m8DwGqs8SdBoMqKGLBHTZwA+RzEW1p7bk7QwKGR0Lti+lK9ZAGWE15mTEbxfX2RoRPCRZ0wjPy/pAHGP8bufywtBjkw+WliyduiY0dgWGpaRRmksagEltLfQMWGGwy2Y00kxcn3cAefZ4iKXluklw/pdo3qBJk8mLmlCuAJvIZM8uOvWeAo2wNDY8PX2Wt8MgDnN/Dp25UPfkpFU650McwnjDuNObmQLMmK+0vtKiY8UgBvYWWu8H0wkwNVM8rFaSh3pCcVcKvu1zZzBWqeSeG3sNfN4OM+7VKOGSqNpKotYIl2Bgx+nCkuuJpSNw3iVfRFTz1iFaefu56V1l5eVK2WeeCyASC3GKkIruAYzZq1YEvaTmCU/X2Ryz6bsjqbaDxgKUU+22BUEtg5cdBow4aQJZkBnP2pIlaigEEhvMpx8EhwARLzv4B1C5wfvTboZqsByvrxFz5jNG7kblnpJr1n3rblI2iSci54XWrJp8VhOS81/YMao4ZwUe+66z/2SuCfOq++8i4kikbQ2Z1u7VFQQJB/cVmYOTZ3PK9EG/sf+f+o3I7Kuc6EgxUNxd7Kh
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(136003)(376002)(366004)(396003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(66476007)(54906003)(66946007)(66556008)(6916009)(316002)(6666004)(36916002)(6512007)(6506007)(6486002)(478600001)(41300700001)(8676002)(4326008)(8936002)(2906002)(4744005)(5660300002)(26005)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?0/Jy/NPXxfUqdfs0Y2fDtSW44oXmpC4ejIfAG7ShR876W2M0KirrJEgdHsRr?=
 =?us-ascii?Q?NQH/f+UuyUEWqAtoB/19hngYnTxqgEhi0zxKnHFOpm/HhXBV3TXMqdFVo3ts?=
 =?us-ascii?Q?XVxugsXP+k9wAEbzJUyJuYdxiamoyLGmsTEtZto9L9H/x0ahVvDZ7BR/Qv1X?=
 =?us-ascii?Q?gsRf4KiU5iVzJWDn2ORLlWeFTuo5GoZmsRIgBRGoxlk/+sZuJz8Zw0+jDQMh?=
 =?us-ascii?Q?4g1ohAE1YaIM5rP6FI+N1M4HuJtkO7uJnlXPcMRr8mwJMdmUDWIjL4LQ/bFb?=
 =?us-ascii?Q?5vLlGyLjj1VDo6BBlH3tvy0Jls7TE7GdWB3tA7TAxEAPzkvhmZv1Rn0ZEwmm?=
 =?us-ascii?Q?Fc38RwQud4VH7B3iaHDiwuiE6Tgk7c2xRLshS6C7oVOTExCwdJ9BkpsjvWDb?=
 =?us-ascii?Q?MS++tBdmEt4n/AQVXDP2H75kjdYWlRb/o1/J5FuRX/rLUkUmfM1iTRwrOMEe?=
 =?us-ascii?Q?/zH7+2lvpEA34rY2JsyK8S7CSlXSod6W0dngsK4WwEotaBFH6HKEbkgFQqmO?=
 =?us-ascii?Q?H0WOUWHdR9XwS5OaxAXjexIWFaBMrI7nBVkOEj5nZKR0Y0sWdfykEVGXzikl?=
 =?us-ascii?Q?K2uHMslOUtLACv2eCKlRXwXl+Zt3IG0n6eBWD4JYoZdR2Xh5GVNA1+GsXHsr?=
 =?us-ascii?Q?lMteyryR/wXOVp8TB9y0H/8SpK7GsfjbqMFdzec3rBmXsyysJefLGC6q49T8?=
 =?us-ascii?Q?Ju2dtZmtW5bblhXVjtWklL6GXtdrvF3BcoRCSOAI8tNneaQ4G4V2rtAwLavI?=
 =?us-ascii?Q?y1w9/rl2rGhT/NcHNRBzA5MX3GJ0pWh6DHTVPPjeLh7cTbUVpv9LC1Te2X/7?=
 =?us-ascii?Q?cv/YI/4mtBwKlDJ70zFcY/61PtchIpFj9qUeXSJR9ZwtROjmPDA71zbIw2Yr?=
 =?us-ascii?Q?XVomkjRQb535OyzmLNGDMmjWbDbY9CH/evaZOtUoXxWz0hvcoiEvNGaWxMe0?=
 =?us-ascii?Q?3Mol1mazn8oTUZIdWKEuAXnePr779/xgZDZbpaiLRByWL9DsGaT+hgtW//Ky?=
 =?us-ascii?Q?iiUUQhX9RLaqde7hGXyIhxkJf67Ih/5wajagvkttCTPBaMlWeuhS+t/nMUxq?=
 =?us-ascii?Q?haarfZKoEr1OiySjbzGp28FajGyCJ9tbfc0pTFD784rPEV/Il8EDxexmpXrF?=
 =?us-ascii?Q?UXPEIpQotanBHXD0nRAXd5KIIEh3Fbr8njKlTolPxHbco0faY2qQVKbM7dCu?=
 =?us-ascii?Q?CpFtu2ppFogxwpH8oRmDRfaS4oH3yXkKYuFJlGJXCX9qHhEaPTS++ljPaC4P?=
 =?us-ascii?Q?mBb4mKQ6ErjkBy7ZemySQCtA9aE1/wJ4GqAwX1eCf5d60mIxCcScQXhooNzi?=
 =?us-ascii?Q?fKT6EG4RZ7YRYpkqTXVWO7veSHDa5znRDB1KOUB9m/bpz6ZoSzkwBzTP5Fs1?=
 =?us-ascii?Q?xfX6SvLlpfwjjC7M9DEBE6YUDw4G3TGWN1p4zl/ehaIQBxa4eOgVeIqLMXk+?=
 =?us-ascii?Q?Dz7UI+EzjY6W5Z2orNors77V546dK6P/U1BkK1hkpECu2SR4KTu/zeLqmeVP?=
 =?us-ascii?Q?B/90zCHEvI8OYMDIZTyFN9rSA/vdLoyWx0+Djm2tLn4C0ay2nzqCt3VWnBlP?=
 =?us-ascii?Q?199icBSvdIj6AlIRtZFAn/osbsEX7qJfc59O3g4PwV83Y/hy1lA0zkDl50v9?=
 =?us-ascii?Q?+g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ls6abvlKY3EKr+WIsqaqMk173UsNTN8/S2V/CuSFyQ2jXAsfKO2srhXmFsH0aUZtoAfas6s3n/jucMCDGMLsmykM/5DBL8L1PhKi6OANVhrIP4PrV2UuxBP9ktrZzoHtAiz0/FUwkd314oSszzPvZ3dCqseu2gXh7HBXR43Im70BhOtQVbgVq63dQI1hFye7pRDrNQnZn/Fms0j3+uFNn4Y7J1ZdwtTrFwOLXYcr/KRlzkovw2XmAwfbs8wyMcYpYg5mWzHQBL82Ik7sZ7Gsgjs0aeXBnXCBoz2IJ84e2Cj1psvpbA0xLIOap0ZBGpS9f6dDlVbrecrKN20VwRrDfycxOfryucFDQHfF6upNsKASlvOWilIIW2ipuDouWH5u7KBSOexQ2/nC5HIcTjM+ADTqPp5jrrq+r7kBmbUyJ8bsq6XUIoTz5yqM7d3mM+lMB/0HHtBFpKpOqS9dB3BlDDsWrR44VPQSWuqB519pzdaE/1XSf5hcNjXtdPeXZ6hhzoGdWfvnR81H4J39zQ8qM0BsKbxEgdU0hJULS77uuNDPUC5UBPFMWRwgEaY+LvwSbSMVJaL3G3NIiZmh/wrIrrp8GGrVcsCUGELM9C5pCPc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f48d4d91-f6a8-467a-b1ce-08dc13184160
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2024 02:43:27.7832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b9L/snks8QX9b/BLEsUZBUNC0eftGyL81Vo6q87q5WInQHCprbdy81h89MbDa1gtz4LNd15YJRMcoB1lQsBfYMEjwJ2buebhknGwIAfxtck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5700
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-11_15,2024-01-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=897 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401120018
X-Proofpoint-GUID: 9JB-yiFB9HQDjSGu2J9wBqnUPNwfvg9G
X-Proofpoint-ORIG-GUID: 9JB-yiFB9HQDjSGu2J9wBqnUPNwfvg9G


Dmitry,

> iSCSI Abort that are responded by iscsi itself is added to tmr_list
> but it does not go to target core. On other side LUN_RESET that goes
> throught tmr_list takes a refcounter of that abort and wait for
> completion of the abort that will be never completed because it was
> not even started in the target core.

Applied to 6.8/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
