Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A33469D
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2024 02:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706062350; cv=fail; b=FGiLg6Sh+q2nIMtruuyz08fox8TrWxHnqfNsKv2rD062MPnA2rMOx18+Io/558k8zXCbPtZAabtH6e1KyT04mAW8j165j9rtNuLD5Dm2+IsmqllBptMOt4JP4fzF+1psnyrjPA2SNBReWTvDiVc3TIWzuoD+lu5BukR1/6nRdvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706062350; c=relaxed/simple;
	bh=NSdK1HVzy2G6vJ1zg6MoxxGl+Lr7Rflm5mdcqZ0yhNo=;
	h=To:Cc:Subject:From:Message-ID:References:Date:In-Reply-To:
	 Content-Type:MIME-Version; b=lkMvMutuJtGW4eG/IjH6G3YUpHqjUT1og622X9/bOLgOLqzQhMFmo6SK85t9njWdQ6gF/6+REDZv5HdsfdyjC1gC2HH0DbCMvxpDTMF1rw+A07f576EW+UAiUSquSDnn8BzjQUBM68G6WhVr3yua0h0R+A00yDhIT7zsVgXLPwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AVoAwGtN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TUVtHFRn; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AVoAwGtN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TUVtHFRn"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40NMusAl011676;
	Wed, 24 Jan 2024 02:12:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=MNtUIrxeyPAhZjO31nIk1dGmYbR1mK1wBoQxA5XyxJA=;
 b=AVoAwGtNee49vQXIy5o9sX8k1/XG+Qo//vK0oTuHXYYzmmLCvGCG72zkHU4Hi9dxCqy1
 4aqgtBc2hxAtrsAVGMeuO48q6G2JKyPsqFFIR30j1AF0m5Hm3XfaQ6AJSzH62Fr+enlT
 C1kU+JZFm5MvIbD9hA9yNAY11h4ex+uNWtpQnoAddtkJitlcH5yZEXE7y1gDU88w2nqG
 QgFqGQ7MSHXinuTOYcXiMzMQm3fEa8+WP2gDyebn4ff+rSiBRR7tw+YNi2V9GnE4USkv
 FOH3L6w7I2XnVZzhdLexSwuDwvWu7obEDpdbEZPcGpvcuUTn/rkvmvnW4vsOKx3BWG+i QA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7cuqxw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Jan 2024 02:12:20 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40O0eWUL015118;
	Wed, 24 Jan 2024 02:12:19 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vs33twdhn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Jan 2024 02:12:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1Trhnh0DXY4PDRSZpDrg4+wrZB4I2J2ugnR91P2rX9F+4tpsihYXGrDei8k/9XtxyEFl2hne93oi7HIUVYkUp2n1n2V34+V0CPTSGP4/1KVvieBYehKUMGUyWxm9Gu7z4rCQ8PXJVa/I9Tcc39G0sD4x6cANSzJG3xdcAuOWEi8sC1YfZldpqVhau71ELTGxyIitWg7maYMsOD3UmSBKtq6Zbejw7Rd2gWm+HI5PgdsWvxug9SYQ4iFIobcAWlokDL4OY+RyuKedaO4QU/3BEnuZoVVVF2xd1CvH5+VFV6eWfrtJ97ag6GuJMJiZIl7slMxLxZR/QMKRULzRz+GPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MNtUIrxeyPAhZjO31nIk1dGmYbR1mK1wBoQxA5XyxJA=;
 b=AFJ7AHBKMJFfOKPPvmnU/VDhn+3ZmHIZXlsxaAYaSVquCbplGcEkttVDpD6wT0z1MypmNxf/AH6wUAXzpx7tKH8n3aTeBbpHPFhPdd2+yW/TTL+Wc+UynjO+NFF1zmHBECyM97sc+4Oqmf/Ea0FKhnPlSnSJSX7IzqQ2HSK6nFEhpU9r5m+CRPqipycEJnZuwsnmyODxerfkl6GdFmaJPUJYYNLpvkpbtaC6c9sOMGrnBozK8nsAEhMosCYBGvknO2LJWe+GBBoVHALsFpVgkDxXaNKGSTpgSbyJ/YRoT0gfmFHiEm2zfublHnRb7mPNu6A9n86nWDZqXbZ8smXRnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNtUIrxeyPAhZjO31nIk1dGmYbR1mK1wBoQxA5XyxJA=;
 b=TUVtHFRnzOgXmapOSVqVD4jvxfe0OqIUVKwbI4Y//KIczhuIVQDNW9vA3JtJXmeaw3+8V4iIyKjidTmXb3BnRaI0KZ+ZU4B2zat5OaugtKssIben2YTIAw9EkVu2i1dVoQ/daIOORXgzv47zzQYvRJCVRhhfVZIyxzHlOB9bEM8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5747.namprd10.prod.outlook.com (2603:10b6:510:127::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Wed, 24 Jan
 2024 02:12:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::3676:ea76:7966:1654]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::3676:ea76:7966:1654%4]) with mapi id 15.20.7202.035; Wed, 24 Jan 2024
 02:12:16 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <naomi.chu@mediatek.com>, <chu.stanley@gmail.com>
Subject: Re: [PATCH v1 0/2] scsi: allow host change auto suspend timer
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y1cfxyx8.fsf@ca-mkp.ca.oracle.com>
References: <20240109124015.31359-1-peter.wang@mediatek.com>
Date: Tue, 23 Jan 2024 21:12:12 -0500
In-Reply-To: <20240109124015.31359-1-peter.wang@mediatek.com> (peter wang's
	message of "Tue, 9 Jan 2024 20:40:13 +0800")
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0500.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB5747:EE_
X-MS-Office365-Filtering-Correlation-Id: fa9d8b04-506c-4c5c-fea8-08dc1c81e305
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	+FZDT0NOzljqHahDUN/oNZc9QSbyvbQIhfOCMvFe8PzLG932klQcLrnf2YbP2yLWM68Ean0h/NA3Y0Vr70jjM+NNKE8CBUn7DoOWMh+hhINlv4Mgfk1lDEEaH3XlEEOBs3oGaLRlz/as2a/bqrZshvTCJXPTClpSb6ukgI6PrUDCJ2v0pZeYuFXwcmhlU88TQjei16YhlU51hdrP5IjKNAr6kDiQPX1irgqwjU+xoR0ZP+8wj0pCV+u5H4NQI82JX3/F19FuVrbWd4LBNn/OO9uMbT6cKRt0FMa1C+cEwX0Mxi1x6iMZ8mKYmrx4fJpGSCR0mb/FV1W6aCNSql/Cs3/Lw1nlydllj2z7ElS8B9Aaei1mtrxUIHozKd3Iriih6wXGRPp4v65XI+LoTdlCIEyc7fK4LTvccheQTDVi5d5P2P3B7wEtnvinlWDCr8Nkeuwg5bRg1cfBgZMxcH288lkAEyenM+HuDFT8Darv2cPHG+n9qwvLdIppyO8k4I+x4HmMGQNayYCm0MPHzjbo4aImalg6gmrDrNrF/CMMeLRjjt5ahsCPuJrqxP7cbgn8
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(366004)(39860400002)(376002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(26005)(6506007)(36916002)(6666004)(41300700001)(6512007)(15650500001)(6916009)(558084003)(478600001)(54906003)(5660300002)(66476007)(66946007)(316002)(8936002)(8676002)(7416002)(4326008)(6486002)(38100700002)(2906002)(66556008)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Gcy+2bej8Hnkk1DujUkJPjgsE/88oR0F8dBY7DTf0s8W6AWe+XH0CbWgjwn6?=
 =?us-ascii?Q?I8intmz/ucWL94HPLhVY3OEbLxquQYTeaFhOKqUmmK9PaeNi7N6SJYfo54Fi?=
 =?us-ascii?Q?NLl0BjvykTj4iwlCFnERRBYVxGoeQSQx2X0CWHDvb76+nuPRAcvUBM4vHaBZ?=
 =?us-ascii?Q?X9qQjg7lqpo5VYD2uqfzAYRdxLmIBibBJCkvQXpCVx4s+GacKBOBy2tJYxs6?=
 =?us-ascii?Q?9/UttvcioUInKl0wRWYaRKlHlPfnuCbql1R9nL2ezSrmQzvbjDky23rp5Nxh?=
 =?us-ascii?Q?i9yvYaVBGsA4xosfQGlv1xqC6oHqEaxG/WKKlIwuNLFKEBZHmmJ8EMqSrHOw?=
 =?us-ascii?Q?l8Ts9ngTZ8p6Ejyvu5a4j2KyKVmn6ngOAvuF9nB7WBgt44oxu682y4WHWCoW?=
 =?us-ascii?Q?sCpBc54Gw8og5zT3KZvWwH4rq0NaF1/BtN6v54ysafgOcs3r7FQA6zgbjZaT?=
 =?us-ascii?Q?cauyj49xWNeS+vtH2D1c9Jlcr6Na2K7QzZ9PI60SYxT+4J/Czsmwm8BlDGjT?=
 =?us-ascii?Q?G8Gh7usiWD0FaIExAY9WD4LMLERAzFkMgGHW68+2vZuS80DETDNylxIuCTun?=
 =?us-ascii?Q?AJf9XNG8exE1jbpRnIF2vPwfXoqsy+oybWOP+e/pTWDgkdSxdOP3wPmGMgmL?=
 =?us-ascii?Q?UweoggYyAP2PiFEow5EnCdaY2PH4qLpYIfynSJbabYkmihNvkEmOyJ5VObm5?=
 =?us-ascii?Q?zYMlC3UdY+CT3ze3fdVTD58GTMJF82/Ky/Yd7HW6dX442JRYxUSTCoCHeLlp?=
 =?us-ascii?Q?eEYaT63VLqUDfcRfrwAFsWA4m9edC0OXf0ajFGNPj+LakQhCHQHzVs7/H7Zc?=
 =?us-ascii?Q?ptmJUMLgTApecZEmbooBSKf1QXvV7pOuNB9AbWmxsvqPCJBNrVfNsAp27ySI?=
 =?us-ascii?Q?PHEHU4SsSC72/45RAC/MTIu2eePX4Jy/9I6Hjnw843WBPzxvqPs3VewE1ymF?=
 =?us-ascii?Q?6ATbpgdVSp3R8fsvUjoIpd+X1uOi9SMX1a6jcwruHtmJrj2sOzOqwxMVZzU2?=
 =?us-ascii?Q?RH+VbCgo14f+tUwtQVOmqqKhNJqjeG6uDLo8DjDRkyOCoxM2l4Oy2+7e8Nlh?=
 =?us-ascii?Q?gR3r5Pf6EiGIOpKgeiYXm1E4Doz7QhqQbdOkH/uAp5M9fhVBuErhZbwpT8B4?=
 =?us-ascii?Q?ugC+RbS0n5poWfqeC/1/BZnuZYSPJGqNoHZTkx4epPmC2p7pim6BJsAwcZVB?=
 =?us-ascii?Q?lLHw1M1qlnIRhOgFJIhZPJwpPbfNWZ410Wz9MMMo2SEzgdG3LeXPc49jakpi?=
 =?us-ascii?Q?QUN3xGPv4MutZ6unURZ142G14AhNdaZAi6AMCPqk/KUBpZZamqqKQStVRZ3U?=
 =?us-ascii?Q?VoLxaOfAUPexmmmnSt8ys3NUUWp5LyAjVGYOUrdweSJW0TRd34dSf8vinUoT?=
 =?us-ascii?Q?vX2yyGthL+M2FVHn4QMVweS0K0Dp6rPaIFhPump8+zn12w3I/Jv1MuDbtEVM?=
 =?us-ascii?Q?1MfsJNdpS5ojLnI2tFmyvfVE00J+lfhKOtVXWOriBOX7guuOyddVLnWzr1l7?=
 =?us-ascii?Q?eZFBcYYYJzC9RmlOIbisTeIQsui0lNkuFHPO1YOCu8pB+rYSX9qrYqXUEqrP?=
 =?us-ascii?Q?q75E2CK48nBcIQ7ycayES8uPKFHTY04t6pKHoxppDi713YieZwtmLdLpWkXy?=
 =?us-ascii?Q?Fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	CtlmHHqOFdivVP+C75Xt7/rwDdWCts9OVajcYnHQwdeGBLC8/JobWybleomynp3LxapBOeXMsY+9S9AVh3qM5RE1QNFWfZudmHKlTLlKgXO3EcWG2d1wykOtRqJHL+kl1x35o3HcV+bGnPdqmDfcNB3mu5tEwDkgzSscpv7KhkX6PajCIc1hcT6Bf2mL/ZDKZ/QRg7uV1z5Vq6bJ5Ed2qoFlb+OTDGUWEorICMGNV1sfDH8sEyMP1ttu6mbNuRhOASGkQAQ52zKjzgNrmDtY9WFawXd0mdRdLoNSaMGEQFNhmAmxJlJ0ItnJiaJst6jEzXuBKNhvG+ufQIAPcd+fRc08+GEOLknVrPRxmfKwxxj64S0/ocQe8avCeKe2ouRYzB8HxsWHnxOYHuS9ZHZ2z8zlLuIUEkUSepdhNV1PFH5FBtLSe/Bd7oFxBXIVolY963IwQ09wXaPN+I6HuA6ErOrMLED0sV/qI7klSm4dmgzXho1wzpHOsC/sitP/lKMSQG47cVH+EhIxOy6FebMY0jJVuBQ6mpNxzCYdKYrgZj4cwHsXcBsPRCIUUAPFPiR49fxyhrsq2YmT1CuyYyGeJkfwBJPkMmK1lt1K6NQNqnA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa9d8b04-506c-4c5c-fea8-08dc1c81e305
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2024 02:12:16.6994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tVseqRV/GvYy3N7ZB4WEaigwH43K/v5cPZozREj9KDjQHcuZ16cP0m3RmDFbKT+KpeHJOoDksYzq5ZKpWpSmKQTO1zRfd+H696C7WI6pgmM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5747
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-23_15,2024-01-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=800 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401240014
X-Proofpoint-ORIG-GUID: GQEXah7dELdRqcxY4Qop8I9RYdVvxWbN
X-Proofpoint-GUID: GQEXah7dELdRqcxY4Qop8I9RYdVvxWbN


> This patch allow MediaTek platform driver change auto suspend timer.

Applied to 6.9/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
