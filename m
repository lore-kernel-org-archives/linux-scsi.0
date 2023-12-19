Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E1915A0
	for <linux-scsi@vger.kernel.org>; Tue, 19 Dec 2023 01:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c/j9mx0z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nESImKfY"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJ0J54o024638;
	Tue, 19 Dec 2023 01:34:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=kudvDtLrDTiD3azDGcGhU2iM3mMBnheXxZkG4DSrSBw=;
 b=c/j9mx0z3V+OsTr+59wyD8Nnwc7CzqwNGD3qdTTyO2K43rbNDC0Qho261T53+SfnK5j2
 wTdAsB+OW+xInUefHfmL8vIkfwIkw/2gI4MVceJ3HPvBQjvv+9u6C3psv4gYRR9FNiA2
 QC8UrcvbYm3kW4E9Yn+FTN7kRAiPhpA/YxlE4Ou2grjgONPkgcgyayRUQsP9rW55lqrG
 xWAPLQ03Z/ybPsxeubJ4IDdSIPXczB0mKId61eYebbwOoFe73O3+gsEQMia3teYyGjwk
 dawkh7CkeiZ0sqqAL48P3gcjhEne2BpcfzNDJ2BXX4xfV1JxKqpmfkDW3EA83AsShlXw Qw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3v12g2cqnm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 01:34:22 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJ1PWpw030816;
	Tue, 19 Dec 2023 01:34:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3v12bc49fu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 01:34:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bm9Jmtmttq+sTeHDRZHOrjl89l+n5aw92kBot8miMvgwrAGknXH7BOR481G1W/Yn3uZ/XlASigigtoWgUkE007Fsxu6fdxPiuS9WN3A1G+zZyBNMBk5Ctvsc168/DKloZTiGuSu+w5hv+PNEL0wTJ+2KvFHW0/t7DF4KnnVLRTpAv4z2NT2ZIvU+5veqh5XbILBxKQZDBWxRM5PWeW8o9S7ZcuFFjfOL0QXi6yO43SMNr8iGSjlw9t2j/NlkLdUg0DQU/eGf4mUNtod2fehws9ZoFCjKaWZJGfok9kACUweovW4bxh6GtGlULVXHLsPaI40lb9F358szP6h4/+PXwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kudvDtLrDTiD3azDGcGhU2iM3mMBnheXxZkG4DSrSBw=;
 b=NoUMQi2ZgNKe8XPRmd394sBv8yhxfjtGfRu4eBbMPCL/HnTWbNUNAYRoSFZkwURz7VgJOmGBbcY2tKhlnwEwbii3V0bdLXG3MBqHcALHO/ej7Vnq7MXTdCA+e+4NToFFpkAcz4M2fWnYJZP5DvHcQIemGNPuY9lV8Htfq3v/1ES9ttGV5WdIiibNQcoypIclQ6POAO1uD86o2xLCsP1ye+hbBQvDDBSCUOHPzoJvJ+6ATs9P1sfKH89JvcDKRlzCICx/FlpkTo90sWXb8GVw/wqxFJOWq5WyUti9hA1ESUQFFyNjDKNcUhN5vMeQikhIvjPnEcLVxL0vtC43ATT8Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kudvDtLrDTiD3azDGcGhU2iM3mMBnheXxZkG4DSrSBw=;
 b=nESImKfYqm/AuQfc9c8hM26K+4bslDawsl7LQD+Ar3h5O4nXfskK307wNuvzUa2GW9HidoL46i59UbZ/V0vAiBa/DViRaS+/1yNr1qzN5/KNOCdo0MsL4jrx090fZ3ko1YOzCZu3YyFRSEP9teh5alJsIfNfuos4I9WFUux3NH8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB4797.namprd10.prod.outlook.com (2603:10b6:a03:2d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 01:34:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972%4]) with mapi id 15.20.7091.034; Tue, 19 Dec 2023
 01:34:19 +0000
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Wei Yongjun <weiyongjun@huaweicloud.com>,
        Maurizio Lombardi
 <mlombard@redhat.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>,
        Saurav
 Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley"
 <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: bnx2fc: Fix skb double free in bnx2fc_rcv()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17clbdlm3.fsf@ca-mkp.ca.oracle.com>
References: <20221114110626.526643-1-weiyongjun@huaweicloud.com>
	<0d50162c-b531-4cf9-a2e7-c2933791c0e5@moroto.mountain>
Date: Mon, 18 Dec 2023 20:34:17 -0500
In-Reply-To: <0d50162c-b531-4cf9-a2e7-c2933791c0e5@moroto.mountain> (Dan
	Carpenter's message of "Thu, 14 Dec 2023 13:46:09 +0300")
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0064.namprd02.prod.outlook.com
 (2603:10b6:207:3d::41) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB4797:EE_
X-MS-Office365-Filtering-Correlation-Id: 37a3db95-4a01-4d47-4d2d-08dc00329ed5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	QL1DQBlxLJlxAuG4OaqNR4vN9Ig9Y2uz4DaxtUA5+AotYvGS18SeCjMUXaX+yRj+gdQmJ+SdCw+PsZJPsyET+TSyUYCgFx9zQZpxNwVkSWd6JtFwqrRT3tjxt7uXdm7huFoOW8ZbOVeEUE5O7crKE+NZcWb5q2nLwczF5JFHoEckH4V71AXWWFR0ECYCFckBjTAu+S1BAg5GTftdWPJRAJunwPv+P49ae8Rcuu15TO8kUv/Dnm6IONSJtQ5vaEpUuEECt7ZNz5NJMcz4wt9Ukq4FxOo3Qf5/cxlcRNIe0UcfCKSC2DSQUM/d2gEYd7rFoSzt2dcGsHJU5g0Osw/g0wOIPjh+w9sL2nuw3dO+K3St+MYxbtccZ7U1I9cR03IHFo04IcPMW2wPBT80l4pbNJIhLPzyCv8nEhS8VsSTrGZxMxokf9TFun2GbWVfZqXkK8XouHEoW2xOtmLDklS12zqtBq3yBKL2nCSYn2QCki9Cvb+CH4wM7VUEcbqJM79NYRybywLPaXUlMNB4s5YvXTjTH7asSwRyq87fmRB2IvghF63N/V/CmaQpV4Fb3wdRclBaFL0TstqXmYQv5p3QktnMGTMA7uHfhXECfNQWyZe7t6CJijAu4eTsfUNwaDag
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(396003)(376002)(136003)(230273577357003)(230173577357003)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(26005)(86362001)(38100700002)(5660300002)(6512007)(83380400001)(36916002)(8676002)(4326008)(316002)(66556008)(66946007)(6486002)(54906003)(8936002)(6916009)(66476007)(41300700001)(7416002)(2906002)(478600001)(4744005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?p+3SiDFTM435ZQiAJXwlFtB3GuWIe+CpEgPdbVIBpdMnsTyt/XGMIPyyoMDt?=
 =?us-ascii?Q?16qvWcvS/BwGjmTcNTOXQZnK+AQf7VhLQa4lrd2EbxjPz8zC6q5VW+5045dO?=
 =?us-ascii?Q?S+EMr9Ox8LV1g2y+eq07Owd4o3iNpIWguo9VLfHFIB4omzxsG1UA4ZKmvy9a?=
 =?us-ascii?Q?rEDfzBP7J6bqQWuXa5jr99Am876EpBYt8WjoT5ytDB0g2a+pyk+tLF3F7xzz?=
 =?us-ascii?Q?z++sXSU8WyZuuv3QVbb1C7wTvv/S/T1p2sl7swt6ilveZkHaZ6iUMyb4uqlf?=
 =?us-ascii?Q?ePPtWxxHcKUQPhXu02TJOZKUtzzLRteUtIpsiNCoMs/Y7rhA76SyNdU6PNsG?=
 =?us-ascii?Q?/CPTUZ8BBktN7rICJbXG9WDHK0BMaYDPH/wAnA0/yzazwFv75YDuvcd2JVtI?=
 =?us-ascii?Q?ILOSwDG66WzgUCORGPatSI4FU3K05XgkKy3Nf62vJYfNXF3oXxmu7Lu+Np4T?=
 =?us-ascii?Q?sS/sFXsMjDQs4e24SuM4jMZI0MuSP0/HkcG96pEg8oQQXDefsYH5VkcXa5rt?=
 =?us-ascii?Q?oQNH/bss03Y6NeKHnW255HptWeHml0Q0R2p+cZ2e/WReXV5vHsTwfG0uN4I5?=
 =?us-ascii?Q?VoBRBzbFXP1gzmgikefP5zCUz3/S0bU8ab/Sn4fdPbNpNeav+51f64xC0Vd9?=
 =?us-ascii?Q?yIDLYY9Y1eV6yMFYRWPeD5NP2J/qAHHMLoD9thIulJgk0aQeXQ0syVmGn2XP?=
 =?us-ascii?Q?X0E5d1WzL3VF5FIIoZVHTWXD/leLpU5mhCa3x6WVdxIEUvR5Xe2rXIY+Q47p?=
 =?us-ascii?Q?FRV88zMwl/5tq6MjLE8hgzXm3fgLt74h4llJKsICwEcUY8pJ5GNwYcXcAylA?=
 =?us-ascii?Q?2FlJ5X2y9NKJXxjS5/6qwCJSPFpSnHfAJnxqcU8pPoxfQvSm47GUroCabZ5g?=
 =?us-ascii?Q?VMzBqjCCvNWsRm/z1HTbTwEc5KCbMzy56UKOfHxNzJMlm6+mN8eAGPhThSIp?=
 =?us-ascii?Q?RGSrEZASpt3nzqWzyyTkvvynuerK9F1t5rmjlWSornJ4oghGV0Lzf47+d5ra?=
 =?us-ascii?Q?1DInhOj51NCtEEAQ1JY5wGEmlzVLLJJ4oO1+8u8LZsDcGeKi7iv9Ndq/KiGB?=
 =?us-ascii?Q?Dc3VE8i17w3pd7YnTB1hH5M+ubHbuEDuBi5l8P5sT9WVOsV9vx8JFhXhCq7J?=
 =?us-ascii?Q?GOS5mWG7IrAnqoDNkxLdZK7BUu1EzfL2feeBPHd92UKoVi27G96iO98rVW7H?=
 =?us-ascii?Q?QqjaVZfStFKpkKtjCC/JifqdVBiQE5yec4EMnpTnI/KEx5FQt5FCZNS+ziUr?=
 =?us-ascii?Q?3fDik3YDdmHCKUrF+VR0i1MMPYgQbxvcTxWtlUbiZ2U/SqpSg+zlHCLYflBY?=
 =?us-ascii?Q?8Ki/3OBW39aRJfxhcQwPZuy8BPN8OmEf7CcIyazFDq0GoYQtRcYEfitEW82h?=
 =?us-ascii?Q?RdbfevLBPpUOjGpgOS4J87oXQHhWJROYAWvfnOkNjZgGbTnFZw38M+W3+JiB?=
 =?us-ascii?Q?+/ExCr3L5RvWdPwhWGmx1J/fcTMK2pnx9QWNE+UC/UqO3Kg4DvL6+ds2QoNH?=
 =?us-ascii?Q?zSmodmTo18WxBV84TECIkVpPLuMKgpHKqUXpjwqi3PK6dDpoKz1Rs5EOOEYX?=
 =?us-ascii?Q?xpKsuLYll+7lUoeq9oUW/+BXkQ5AZHhlVWerBRIwWmf1LkpMub4Yx1BDxaGh?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	chBaiLsekL6kx7XAqCHqaWauDbQx6XUx+RUaMeufpm6cwbX/gLqmNz+1tCiiohZ55/ahDbJysLQVRcJNX/Ce4jO8Rsl5bp64vTivhbBKmQvmMf6qiQRkFk7mtEn/Cyb1sOzuJfPxeIxahLkBacHxUkGA5t9WrtnjDXlJ/tZ2JQM6D/Gk2BMR09G/D17OyXFK1grSruamj+bRJj7Ti586xBS48UQSjU34Z8SwvxjDGw28Sj4ROBIb6j+ZBScXVlbu1Zd4LY6RjfRMPLUACdxkUfrcnG0kHaWevUukBkwRn4yiKDnMcftdJuEYrDWmHOUtdlTkfDY28ycZyuFYU7cUlNz4awfswk31N1KbIlZgLCi99zV4MVuUow/DPgVNwd4hnK7S/BJ5NFrQmQ00aPzTT23PexnMiCNdNPV25H7SLHDlxh0p2hjo0eR/RrFRM214melBJU27Kvk8f0kZ7SOMlPABcyCF7v09UpREqvykXhezCAQLFJ8IHW/JCQzHDHg5z6rLUyzQ4F0n06OWkRum18QMvTts/HwqjgG4HcC69TaGEsix7pajOdoCvbFv9o83nxDVI5aNtxznM4BVb5rqsAnouAVZLbLWrkA8dfhfbjo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37a3db95-4a01-4d47-4d2d-08dc00329ed5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 01:34:19.4194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ucKTSKHprmqWqLvMaXOxFM2uNT6JU8e6WNgAxcfp2TNZF09aHciO34G5tXNtLo87mmRB69Iqi/g7LP+zTqxLmlWCb6OOdeGULIsJKIPMVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4797
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-18_15,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=592
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312190010
X-Proofpoint-GUID: xDqurBKLqE1Xs2AB0fmTN3fpI8_cAR7g
X-Proofpoint-ORIG-GUID: xDqurBKLqE1Xs2AB0fmTN3fpI8_cAR7g


Dan,

> What ever happened to this patch? I was reviewing old use after free
> static checker warnings (Smatch) and came across it. The patch looks
> correct to me (I wrote the exact same patch myself before seeing this
> one on lore).

Not sure what happened. Patchwork had it tagged as "New/archived" which
is really peculiar.

In any case I have applied the patch to 6.7/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
