Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90875137C57
	for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2024 18:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708022568; cv=fail; b=lo8GyoMEKF7Y1MnsfFxipWVwio3CU4lXvRrBCfK5qDj7eac9cZWoCA4bMiIxHl9Wrpwjtj2d7HOjecH6MQpSrC/nThTTyN0GxeK+AOYSqMQ07PaWBtetynGOMa3QrysFe6V04dni4uzOxatH6+v1Qw1o6qNsCMYpOEc38QjWosM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708022568; c=relaxed/simple;
	bh=gDv/7tGDbdxpHtLrrw5t6Dy6BuPsyHQ0oiv6JtdndeI=;
	h=To:Cc:Subject:From:Message-ID:References:Date:In-Reply-To:
	 Content-Type:MIME-Version; b=Qv7SO7/1sTa9x3MKzuvuZHSX7WZPj3+PyPMOUyikqFtH9Rr00MOAYvvpzHxfrAWiH2jl5AhFZwV9G04s774wQzfECHdrlCKJNZfFVSgKwZwQ00bXT4h787lfoXlUU19LeyC4bYCVf3cacHGr/m3IbgD5f1zZ9oCGkWzjTr1/Isg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jyY8mT7q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dkde6RLH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jyY8mT7q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dkde6RLH"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41FFSt4u006133;
	Thu, 15 Feb 2024 18:42:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=liFM3+xvAjm4dDme5hXrS1/jm/ZjONYK35qDAMsg01E=;
 b=jyY8mT7qyEEmsVAuT+EhosLcbqfLtzOwwc/6WeRAW4oiF97qYa1jCHIX5CaNMD6kzlle
 XwhTQIVXX3jF2hzVyRnCucoi3zpEAtb9Nu+3xRbs547FHTQfDy6eG55UkTRrddNTYgBu
 6C2epqjmFPHRN2owJtJfOGeb/plab9rIWaq3y57i+aIzJIU9PZ+IvJ6+kKsKFz1wl/p3
 e3Pmm7a8FnztKb3UQSWJIxQVsgeZp6ZTBwV9+lp0zN6oT5jhDG1fcB72EzVM2e+Sl5f/
 d0p2jz1wjKNROvVAP6NogJFxBoR3isNR1rRD+h8BuIXAlS50M3cXjfYrgSa6r+o4W4a5 5g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w93012xbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 18:42:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41FI28iV024638;
	Thu, 15 Feb 2024 18:42:39 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w5ykh8he2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 18:42:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ke7HY5kgVZxQdphckUigk1N+lqAZEg/ZY+6R31Fdalwvu6I7I7SSgZ2xiV91ByzfQ0XuzSem1gH7EaaqAEJkDFbBuTd4GI5B56tOwIY8QGtvaUyxBJcAsAYtb0LkrBpMwqbyKlRm0txfbf0RZROmMhZX2pYSVh9i/gf5wSnGS2yzIpSbA+wDQcbG/C06YprtAWGt1Soy6rFRb7hZm4aZMT2+/bLpmSQkx+r0x9IEU+3gkiINkm2I6VYMRo/A7nUkEcZAjKt7WirYQiscngOrlpT5gtqqRXRD2sorJVVFY13DaK8DMWxTocEQH4Lmzg52NOEXq7Gx4bQTG1rzpGIuQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=liFM3+xvAjm4dDme5hXrS1/jm/ZjONYK35qDAMsg01E=;
 b=k2WaxTRO8dVcPjG4YF1F5ZtrZUThHrQC0XYvL6ZddKPu1IYFz5RY3SlDVrclYdZtmFIyZEm8bK3ii6QfOGwVDmMHbITVxSCOdax7WcssikRECLp40x8y6f9jA//ZuR3rbrWKkkF632Bdsv4V/iVHBxDCMyS4M5MG8HlNT6eW43IWLdtlHkLNsxI+19O12AtyGCmX0ESwoI1qW9pPPTnzahFSUMGbk1GQuy+nq1m4p3h20Wns5MUYVCNnRcPsVPQKgczE6ZUiIBnEZUMqsjwHgNdUyYFTU4saZcGXnaheBBZGYQ5+ZnW1c2Fvoj/85HtLU026I4bYxk0TXlZRxIpgCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=liFM3+xvAjm4dDme5hXrS1/jm/ZjONYK35qDAMsg01E=;
 b=dkde6RLHCt3TjV72T152vm8Dur5gFR7wlhi+SmBPh3s9OMD+QitKxk0aXTmg1hSEj62mFPSrTzhlTfiucNap1a5lEMvkvxcpACpAG9yVexS5yxf0rBl1R9RIFUfSD+1lR+TrPja/Bx2kV9RsFcfTLm4N039IMYI7Ormh/kkQQ9k=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM4PR10MB6885.namprd10.prod.outlook.com (2603:10b6:8:103::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.31; Thu, 15 Feb
 2024 18:42:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1b19:1cdf:6ae8:1d79]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1b19:1cdf:6ae8:1d79%4]) with mapi id 15.20.7292.027; Thu, 15 Feb 2024
 18:42:36 +0000
To: Vitaly Chikunov <vt@altlinux.org>
Cc: megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        Kashyap
 Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena
 <sumit.saxena@broadcom.com>,
        Shivasharan S
 <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil
 <chandrakanth.patil@broadcom.com>
Subject: Re: megaraid_sas: multiple FALLOC_FL_ZERO_RANGE causes timeouts and
 resets on MegaRAID 9560-8i 4GB since 5.19
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18r3lful5.fsf@ca-mkp.ca.oracle.com>
References: <20240210011831.47f55oe67utq2yr7@altlinux.org>
	<64phxapjp742qob7gr74o2tnnkaic6wmxgfa3uxn33ukrwumbi@cfd6kmix3bbm>
Date: Thu, 15 Feb 2024 13:42:35 -0500
In-Reply-To: <64phxapjp742qob7gr74o2tnnkaic6wmxgfa3uxn33ukrwumbi@cfd6kmix3bbm>
	(Vitaly Chikunov's message of "Thu, 15 Feb 2024 18:18:29 +0300")
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0153.namprd03.prod.outlook.com
 (2603:10b6:208:32f::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM4PR10MB6885:EE_
X-MS-Office365-Filtering-Correlation-Id: 17e49e1f-30da-4724-8132-08dc2e55e127
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	J/cvv8t9Rrg8bPayPJyze7EFcuC9ckRp45mU4ldksKNwVmceQutCyA8kkzyRwf/dfChchPUSD1iWk/05Awbhm91sb4WIJ/mIRNewZCtPwhjkGPsW0AiB60nPuLACBIkQQxM4dRMxOp1ICenTkznZbweWdnL1hyGm1BqSi9ub6VxSb4UimzwCWD0MByKGfljocGzVfQD0VE0hwivostZCvDFf+nVgmIvrmmDe3qoTU7CM8OkBipDm+MSgAqMGlyl38FfoBTXS9o9WNqBuEvRNZxNcRZRXqSmPImfzTo2PmHHgEGCgvPEbcDVahn9RRfWgpmVlXiln1WOLY1YO1mZwxDXcf1oIXyIQAEjMHZ89N5MmzUKzUX3QIIjeSpXXN800v/R97TerPTNt3oZ7H9ASmXgNwRxtJ5hdEHydjPkGpOJQrGTswE44rV6bx93Cs5BEZbJ5pBrAHH70XrurB7mlcpR7USTpLjNvQejRuzhTBwMTYJdyLarL2/vyJVbS/H8W4sHUS8LKzexzETdHfsKF6//BSghXhScQEWelnystja5cW2opBCUjHB+K6kHMCnvX
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(366004)(346002)(376002)(396003)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(5660300002)(4744005)(2906002)(26005)(4326008)(66556008)(8936002)(8676002)(316002)(41300700001)(478600001)(6916009)(66476007)(66946007)(54906003)(6512007)(36916002)(6486002)(6506007)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?YZlraY6IyiIXpSWYvNlJy2Q5YQWuVBcIwOndEO3Cyd5wtLz/CHKhcLM0X85n?=
 =?us-ascii?Q?gIFsa+/kJPgSxziW4J+c9rX+lb4XXtqNfnMcWoYfder4AfcGfTewsTzyqlQT?=
 =?us-ascii?Q?zhm7Q70glZjwN/JC8aLA49FJEw6A12W9e9LFCGSeJJ8z3nxHxejXQo3JcgMJ?=
 =?us-ascii?Q?5pHEAZ0T7poO/pGXI+wBvBdIcsLg09AKisXgEQdu/HkX8qa7tYITh3xDexsc?=
 =?us-ascii?Q?0QJviTPuA0T0s3O/ekU7LL9PfuTQX1xABWIr+FaO5bv9X7eLYjnz4SbMnA4A?=
 =?us-ascii?Q?9P01K7R4bmrCW3R2PqlwUfTMgQZOxT8406lCUY/jZPjpDb53cnH4D+beDCvr?=
 =?us-ascii?Q?zw4rfAgC4ekwxRIwO7qzSxT0UA6BB2EVsdXEO7r1KEETc+RA7nTdRVod3Qfo?=
 =?us-ascii?Q?ugYQ1m+mh0M30MeNWJn3ztbzcni9kgDhBXcBbnk6VMwhjK0opI48xoJALVPe?=
 =?us-ascii?Q?rzuhF/dds0fJxW7+cbu7c2BqesMjA8iuneDvgp47AWUtmh4HNuI40AjddeCU?=
 =?us-ascii?Q?tVnoH+f8BTdRXVochHDlTuy1y2N6BX7vJD2KoRjLUrjD599GLqP7Cd6d5wNK?=
 =?us-ascii?Q?vaw7ffDSBVzVwmovtcET4E92D4xV04BAimcgQbZrm/RAwrtMB8zcS1PEnJ6j?=
 =?us-ascii?Q?3YBrd1MI783v6JFNZ/YT7iCSS1oSmQ5ADS0Doesnfk6DHrXPsz916CYJk/7Z?=
 =?us-ascii?Q?tK5VpjNJnl2PcBu5QcEmJcYjzE7e6hfyniJDZKx86U6Y3nhtC8TJIGblp/yo?=
 =?us-ascii?Q?fDap0pjjrFHT/R2gBVeyw9rvlvctsLen8YeAJHmEBmiGYUk/lhzc86ef/oJK?=
 =?us-ascii?Q?H0omfItCN1A9r2Bgy7TQeNpNRd74D2/0dPse9wyKjAhU/y9o1pvCZ9X9M68I?=
 =?us-ascii?Q?dzNGscAmWXn0zZtAqh1efSsHSO1RHkrJEY8ADKI4TWKY2PEsD3vnYXumY8zi?=
 =?us-ascii?Q?zBKj3z8r1MHVZvstIGLwKI3UAX79y5DF9jvflT7c5XKThW3DUrB2heA1kHQ1?=
 =?us-ascii?Q?J5lbCqghinLDxFg6oa+gHORXavrXGLX2cSU7AjOupBXLDBmhmXL6U35WgTtb?=
 =?us-ascii?Q?O6RjShJh5haWlxvS1hbHVSOLN0T00id+5y/5i04UZxIpi/a+NDIqzCSV1FFp?=
 =?us-ascii?Q?aHGE9LsVFzdDL8Ye23JQisEedzktXKSS9KGFEAs8LtPIrTOWYS+qsue04m42?=
 =?us-ascii?Q?HB9hfB6ngqk27zxYEo9TmDDyEN/wy2QtMXebEowGPtxpW1/pUtYWe3P84B9G?=
 =?us-ascii?Q?JhhCdViRpM/E78xNEa4WGXlB/XYDt8SusZkai37OVT7ox5phsmj7icoCHQHL?=
 =?us-ascii?Q?Azb/MdJzlvSrpH34bcqeLmVy1+J7hIEytBX/c2YNROxkr22MHZo0tDYhxkPg?=
 =?us-ascii?Q?2nkKqCniSr32r64zkxiFRjjTBu6Tg0B4HF4Z2T/08hlyDy4FE3mbdqW/d03D?=
 =?us-ascii?Q?vwlCRu/Lw4Gf//3ERoWluLu3mfk9CinAn9BmMCUHPQydR/EMVH7Y4UMOMf1z?=
 =?us-ascii?Q?yXwjIdDWQdS/ZJNhYzjGct/Dm0PN98bT1c+izqxwSfrc8+sR2qCEEqA5e82n?=
 =?us-ascii?Q?dRQUdVKVXtKPmqNIHld50t+SM09FwpS7wMRy6POa5HJJgd66d598OGLqJume?=
 =?us-ascii?Q?SQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Nt1PvkLPrpKRjTyuPCsoCzEworVSscXQKdIA103IopvKT4H6nGMVUC/sUWKyvWmDDmFTcFxI8BB64Xzdd/1VzJDQlOeTKYMd8dIjBDt+63+x3sFZVmJ5QvvB6qIpkQXXEd4JUoeRUJJ10cdJ706Bt4gPS1NAddboP9elx9izXGD5nsOdKzbY547txfcSuwkEYjLpPHG7/B2UCb9KOFeLP43amKrP6C0yWt+0nBpL3HKhjow195k+tzkZafFnn9/YYihmdyLZFv1J1n4tkOnOk29CT+5qvuGSHMwyafZuvhrQBPg5w1zHiZq/QmNEmZo0SdAaaTcISOxqtLm9QeFyEwaNeAm4sqvE4JoKMkhL7vQwP9jE7LbkKyMhMcZa2J+F/ZJ/dNMLNlDfPCtQe1IG/yOZ/hkRurTcssRvh7CaWGR43p2czh4UlXUG/qNuSc9SzjtpKEU5NUiXpG1MUX5r2F/7oYx+hAcSfwdrwpWpdInIFnLmfiB/87N0ny8/86/Gj2nrtMcIUAgx9v8g3FlgW9gYhb2eiiro2QL82OPFkwYcAFgNyIEx9QBiSClTToVCxm5OzcWCz0piaQfdHlMHOobtcKryiO+RVu1/ZnSfteI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17e49e1f-30da-4724-8132-08dc2e55e127
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 18:42:36.5260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Xk3oz6a0bIYa6JBmR/8in/ZMF58oJm/mOkpYFFYF9UUc36quZwbtkiaBm3Edej1FE1lYpfLSoiKt0FyuV6J83DDtk/oV4mAu/eVakS7eUI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6885
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-15_17,2024-02-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=828 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402150150
X-Proofpoint-GUID: A0Mxd_5jJZpD6JOG3Rwvrak5UAQAeE10
X-Proofpoint-ORIG-GUID: A0Mxd_5jJZpD6JOG3Rwvrak5UAQAeE10


Vitaly,

I'd appreciate it if you could test the patch Bart referred you to.

> I am reported that bisect found this commit to cause above mentioned
> problem:

Also, I would like to understand why things fail as a result of the
original change.

Could you please send me the output of:

# sg_readcap -l /dev/sdc
# sg_vpd -l /dev/sdc
# sg_vpd -p 0xb0 /dev/sdc
# sg_vpd -p 0xb1 /dev/sdc
# sg_vpd -p 0xb2 /dev/sdc

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
