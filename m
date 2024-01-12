Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7866E63F
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jan 2024 02:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XlSSMO63";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pGZc+AQt"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40C2bLMP009967;
	Fri, 12 Jan 2024 02:38:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=VqH3yRaYbpaWRRXWO5xQKX663V7iGhqg7LfwdMNMKJM=;
 b=XlSSMO63JR5rDqnenepHnb4gMGRkcMbVdPg3lr+bBTqYgrLBcVl++hqmwsWg7QDEFdk8
 YwOt2RC8bARSUeqKd5DKGm7TufD38FweEr8Firnkp9OI41+tjSOO2QZj6QBX8U7ir2bH
 H2gqDP2u7Jcr/ROolA7lBWHLlSSbWbyNp2IjiGejE+E43kPnVD4D72CJrRZ+ZeecYlck
 BNd424nqJa2u/Hv3qVgBTwJ6ldWJk2K9gk4miaVhg/dJLzlz2H67LKmVj96B3twMXFmN
 X8Lf3gpFHXxDiuQuBveZEDdh45HQIrwQhk9psOluuKa++l/I625iOp8P27+RwJRAmQBq UA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vjvsqg014-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Jan 2024 02:38:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40C0vF92012218;
	Fri, 12 Jan 2024 02:38:20 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vfuwmx2yr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Jan 2024 02:38:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDLThv75WbHwy939GztDfYuKi3BL24UGmp58bEhSvguyVjTRrOTJJJhMP+oPy+7A/P4l6Or6n06XBT9LFx400V+tdhIzJFOyDuDCxF3+97exicdBlqVPoO/2BAatyWA0OpondeeFUgHq0BM0FlfQSrtmJp23Qk28dwUO4sBAq+vAjRPvUDccJMyxz/pWKuS5eNtSQbMdX750HYzYAwagIsmJaAFMZcF7S3nJZ2IrzZcCSTNuhhGNgAozsK1iUCrWRLbQFWBkDHOzZlU2dbV1WG1micGPsrpZ+PSbKT2d5Ujdzt2s83JEDbKcR/TjdLUNk0hzA/WCOAMNhEd35z8jVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VqH3yRaYbpaWRRXWO5xQKX663V7iGhqg7LfwdMNMKJM=;
 b=FDHb/igxrKr5npob8rU+ZNdYERThkgYulfaLeT9V71/e1SVODq6fCW2gPUNm0mkWjUkTzUpI4WC2xNSpgc2ytTpP7s/aMkNrVLCHP38b+NcBUlm/uuDmndjddqvl5TZ7ueVxZbGLgI9iRadp9K8MHXG72X0of+Hk0lvgbQz5waWyewDKV28gw8O9oF0K7xyF9c5SGjA0StsvPjGoPBnQf6R4oHpg+gGmqyOEqdmaUo+uKOKW2CA97G1o++F3bQFO7pOQJTVvFL4vf5voM6hIRlf9wvHdxK+8SW5jejFFbwsAk3uQrpKE8aENBlNarbU6F/BQhL5Q1IrjweUIuKDXjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VqH3yRaYbpaWRRXWO5xQKX663V7iGhqg7LfwdMNMKJM=;
 b=pGZc+AQtzZM/W1OjneLqz1KYWpmHhTddd5I9P2utUwxrQUWUtO7MOvsdCWl6J+hJu1dU8FOqBHQ5kIB5gteli1Znav5tFQ294Zoyq331jdzl59NKQnt9kbbGWysjLB6JFUBDciuzCbWOV9WPFVydpoXc/e9QojpbJUqzBhS4U6M=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5700.namprd10.prod.outlook.com (2603:10b6:510:125::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.19; Fri, 12 Jan
 2024 02:38:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972%4]) with mapi id 15.20.7181.019; Fri, 12 Jan 2024
 02:38:04 +0000
To: Niklas Cassel <cassel@kernel.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Kevin Locke
 <kevin@kevinlocke.name>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: core: Kick the requeue list after inserting when
 flushing
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wmsf46pr.fsf@ca-mkp.ca.oracle.com>
References: <20240111120533.3612509-1-cassel@kernel.org>
Date: Thu, 11 Jan 2024 21:38:00 -0500
In-Reply-To: <20240111120533.3612509-1-cassel@kernel.org> (Niklas Cassel's
	message of "Thu, 11 Jan 2024 13:05:32 +0100")
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0466.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB5700:EE_
X-MS-Office365-Filtering-Correlation-Id: a8846eb0-6041-427b-15f7-08dc1317806c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	JbwsKoMTNVeYhjSqjlsy4HX80lhmpVwsvwKT1MSLkiYdkgh6Ac2ZQN3UBPxP4Jmuu46hKG6f2LqvU3GXLvh7/+mwcOWYbYaY5PEXJfvisRZaFr8SK00NDsXXnjyb/S0cU53N4uKeV7mrFdAQXpDqDFsgHVDvgGkTIVYFZVP7RBlCt3r/004zvSy1NHv7Fb9XSEhKbBP2OGLztBh9cJkLpv8ItuFZxhI9zGA8bJsgF7U5EP/9Es36A1eGwdTgZrvLNqM3dg3dTVR3a3el7GXuW7+JHZ4USBJAcYKpIcM79twmkOvu1i95tXN6IQNe+XjaeaZ+fF1cmn254VUWhpcJye0Fbkxt9oeeQLnaXmnPaTu8BkuV+BaZhxiJaTeT4+DuommcW+EMMb6+jDH8q1AmumEGbN/evL73N3atUQW4/lfproeh3t55uyCGqQEkMGU7/oR+GWAyT7zGeFo/vBYNYAIwp4z7XH+b1JeBxtUqScmtVCjQqXZkEQ2MMptrJWl3cH7yyxtx08uPO+fokfZDvMIiFgQsthtEdKH7rBA9+SYKY/U2K62fp+F39p+BszDA
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(136003)(396003)(39860400002)(346002)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(5660300002)(83380400001)(8936002)(4326008)(8676002)(2906002)(26005)(38100700002)(86362001)(558084003)(6666004)(6506007)(6512007)(36916002)(316002)(54906003)(66556008)(66946007)(66476007)(6916009)(6486002)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?J0ONpx7lSPk5M4H1L5u7pZ6r6AtnEHVg8EU/0fnzIhNVU37g4vlk9W12DLm4?=
 =?us-ascii?Q?jcd33mplEBC6BtFfNFu4PCXQfrD5SshE2PafYZ6R9rPJjqFdo69kR+v6edWt?=
 =?us-ascii?Q?qWPjhd7DwMd+DDWpijxGfPgAT5V16sGipGWREzmQvj96rFwyyVA6N5E76hAX?=
 =?us-ascii?Q?S9qYDFVkWEsBHutioSFLHjY1A+ltq/b+7AUx2/RS8hJCb5KN+EKapFSgeZLK?=
 =?us-ascii?Q?treQ+Kd1PMTtbp2iTx5YwF9iVhd9oZuU/eZIL8dF3wd9GRp7ojjLA5tCj2Z5?=
 =?us-ascii?Q?wbqKHMvHfrGh7kcExpgxFMBphqEehScJggsDvLwHUKbfCC09jUnZkFGt1Tvd?=
 =?us-ascii?Q?LVCf/uNN+bqHQ9ESATfe/KinC+wN3Mh/DORNuSxiUOpLHuhacG37d76crQLh?=
 =?us-ascii?Q?X3qii6zAplyx9XvtURGnyr1waWjFq2wfpltMHqp69fMou7+O2jfXaSxC9JBb?=
 =?us-ascii?Q?s/9K0P4uIwqj1JUq/2FkqUoTaoxgf42lWnLu3YVEczF0RG6x/djx9X5dPCCW?=
 =?us-ascii?Q?vhTd1JQm9v3LLWWg5bosFrFXfEoHeexBvMKFytHsvW3V4zw0xh1cJF5kLjVf?=
 =?us-ascii?Q?p2n+ZKhGEIVuQA3nUeYqMV3fMM7V0XMGsBRHa5GyTMProvwdIUJsmmObDrfG?=
 =?us-ascii?Q?DRrtY2dtHMcNHT7CkplOifyf+SjwEYavTB/8HvG5CWF+kXYRsSGMKXWqRUFd?=
 =?us-ascii?Q?YwV3cBHxXnGVAN2m2vND+ZAgqq1XWRnxOjlqZul0EL3bXL1Qr1iHiCTGr1lv?=
 =?us-ascii?Q?zYnX4VHfBH/bSmD3Y/5JmaOpsIhu35ckeffYLpDIIkK8Daacv5FyfZaXKVrx?=
 =?us-ascii?Q?0SMGxFlOVhWlS88AVzUbD0MTGhmVnts4soJQHDxQ28jeZYrGllyIft4k/4xo?=
 =?us-ascii?Q?YX0LYWAaG8JsVjyIdmDaKY+fCMpolTSp/zg5vuij3C7G1C2PfOpM2Z/xZgyp?=
 =?us-ascii?Q?eBZ2zBZlzCE9Nst7oab/x9kxrSKC7TdqYE+4+Iy4vOeT4FYKQYDqG60xP+wp?=
 =?us-ascii?Q?Q5yl8yyNm2RJYD9eCVdOjC1s+j+wAk4DIjCKbaMj1T05IggfV22e7URrNG8x?=
 =?us-ascii?Q?SAjysUfruoaJH4f58kwjgt1flrrKq/UBKifQaCxn2eiil7Qx3P9g4aq9LwWB?=
 =?us-ascii?Q?UhEJtM854KSDGBeouuNJuXD0XOEy9ckFv4i5x92fHk6Kiextk8ASD3BFTaOq?=
 =?us-ascii?Q?FuflJHV4AsNsmBsY2VvYvESw5VUNtBRyP4moK1xjGJgc0fe+boTDYeVvCnFe?=
 =?us-ascii?Q?37ro1YHvvd8/h7RQVfjbqVN3SUi5jKJu3DebE2g90/j2Y0s/wgmY+U/6ra09?=
 =?us-ascii?Q?KIo+wohDPQQinVOZT91gtqBfCdw6GM592lrl6ImN8APjmE+Tayd/Spa5WYY8?=
 =?us-ascii?Q?uupztR28tBx7T7d4kmyUzJuWm57oMtkgr7MpAun/R9V99sQ0ZsBKfGg49P4w?=
 =?us-ascii?Q?aU36+8ZIrHcTetYpDPrCT+4mJrm6D/3IwwpcFxx2HjgTaAhI5UiOYPVPNR6j?=
 =?us-ascii?Q?FWr3WyNU8rO1aIpbdZHwQmX91mggHcBwwk2kuoYTlGh3Pj32avwFR9/NUPku?=
 =?us-ascii?Q?Mb94uaiR5X3wd3xIOE7O8Yf0BOp0QAAPOkWZM71r7/fZAPC0qN0YYSnCQWyW?=
 =?us-ascii?Q?Fg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	MBCV4khriXlNTu9ZEUfNvRHx8I1KQwdrAc4pb3efu+KTtOY0rngLtgbnojPad0hYiSxY6SZkhtwTDs5CrhmwF+BPnXuXHNNngHNfJjrDtvAda0NuEC/Rhm16oYNPkNObl1fbh4mqIlEOxN/3DfJ7wZCY8U0LDGnFX5lN5re76zeZ63pF3AB19MBmPLiBlX8E5NichwFwKtzsaE4f54Bh/S+4c9OLQcAUyBQX3VlMQBuiDJxDKa+jGyjGHBOz+8ZAWECG292iKK25NfB3ClUzhkILcvJ9z/x+C6E02Gc4/uai6TWWmA7KAibWb8eH1SLVud/DSA/HjkuFVomVbGTTKIYTzPo8ynOslXZXj5AXyMvI8YyIlenRwCdWYUQw0CrYixK9zc6E4Wd9ZH0cVgvpGHmMF0+dyx2kdbafIaJ5Wej/qP3LS6ws7dz/w0KtYwPl0IApWqgXarnW0+Zpv4r1PtQwPVEH/ApLEQC64hmgPM/1QxeHJVO+snXNE0qI3FTZVKJXg4DMZPf1hKFadUOkEHqBRUR+FFRQ/ArD+mFIVB61hjj/AqaMfbQl96Hfxx9dzxQM7vgE2i+Dy01q0JlFuKXH0WrAElVy2dIXMhyRvSc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8846eb0-6041-427b-15f7-08dc1317806c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2024 02:38:04.0635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 74VfAco5AoZLOALQWnXFTzYiGEfuTT/DEp92Co0jrPd0Ia78TMFyA2fDh1jbpIbCB4RErfB1h3DACHmTadFQgwYZH8xQkifDutgUbg64vNE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5700
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-11_15,2024-01-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 mlxlogscore=814 adultscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401120017
X-Proofpoint-ORIG-GUID: -7crI7Avwxb0Q5IXdybBM87CGV_Qlffl
X-Proofpoint-GUID: -7crI7Avwxb0Q5IXdybBM87CGV_Qlffl


Niklas,

> When libata calls ata_link_abort() to abort all ata queued commands,
> it calls blk_abort_request() on the SCSI command representing each QC.

Applied to 6.8/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
