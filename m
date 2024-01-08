Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FEB52F97;
	Mon,  8 Jan 2024 16:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mPQtXjTT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gNZc+4F4"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 408GJRdL028440;
	Mon, 8 Jan 2024 16:27:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=SiT02Ou1KYUwG9/kWHZ8pbPkC/bUc6WqZMW1BRBS5zU=;
 b=mPQtXjTTyGSy2z01w3tNrpUZf1sqzbdD7JaiXd3GLxc2irpIAxUPQ+IQRoOe8H4mmP+X
 72W2KzVFfMiRdlZ2FLUzvOlyR3XMrGNqi9eRJWvrymlP+nRC5+PPjTckuJ94yTJpVjFM
 foFLldIVeFTxQMg3Cu/x1gYpp1+Lw+M8LCAy0LEPdW3xjUY9VDE3EfzMaL0tWXrp5ZzR
 F0h3dPBgg4ftW9R4wZWRysyDI1HdhkHHJpIGo5GKtri7oNg3AsV0no8a1pi6JpEQ+q1b
 yyQKOdBz0y5nn1SBkiFoME49Iur4q0moMYtW2usnmnYqPKe0QMv97yUKS28QTV0DmIdo lQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vgmf9r0vh-10
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Jan 2024 16:27:59 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 408G3DoO006738;
	Mon, 8 Jan 2024 16:14:42 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vfur2cxe3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Jan 2024 16:14:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGe7Ksbo4Jdwld4sXx0xYcgEsm9QzEE5B4S9T2zHRKsBebHTH53b9dNfcZ4lVQyfYc5LrU/zPJuCoCLadHEkKezlB04okg+Gx31mkD8TQ+zghAPdU7bZM5BJG6BDpqhqhE9k/opJ/wK2SJmFJqLSmiElArsrQpoXv1Z1Py6cwa4+5FrdzkFAFdd8EfG/gQbWGGrSzJRVMgCVyvoLJKjG4tLzGuzLGb6YXk090Yc8O34TSimgdts7Q2LGFnZ8g9n+CQvCdxTub1yetvwiHAzGdb2MH3khuWZEvrKPnrtrkxOwngcYrJiHqT290NWR6gYOKyxhatnNQvAkA3ZALu9tsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SiT02Ou1KYUwG9/kWHZ8pbPkC/bUc6WqZMW1BRBS5zU=;
 b=k3Dz0mi2P+ndrsDXNm9JkCb1WinUUVxC9fumRBwuZmyGtwpA+8maG29uZXXdU4rRIok92hrWKeS993hOiSviAOOfQwCWItECFkGiTt1Gkdwie2Myq3XMuUIl8gizrtEsbwkAgqMKEtVjlQwQYSEQBjjNUOa5MNBgRoZi0FdBUMWtmWbBqonxj4Gl7Sn19WAt+yXzgTHqnvnoNnhw+vqZpuMpqovEjNQYTJNFZ1xDoTGVd7IS+gmzoGuCVdA0oXtjO33+VXDF9bdiIKJGvT/qq54LKiTZjSm9wZHchNOVgPeOVzu4qvutmRGH1svfor8rj1BOvXjFVY8CeaII+uodFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SiT02Ou1KYUwG9/kWHZ8pbPkC/bUc6WqZMW1BRBS5zU=;
 b=gNZc+4F4BCbBEhX0caXvzXxHURPyBAHt99pWPLbpTX0DNtIyP/w9iN8+GY2Dtiep8zz0ZsIaD6TnSgRn/dNDbmaPCHgV+p2pCthGKPjo5XIVz9IV9czd0MmHIrVU2WLNWwc+832UiPNq90a+qnsr1SHWtxzKC6VAxXTQqPdPww8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BL3PR10MB6019.namprd10.prod.outlook.com (2603:10b6:208:3b2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.23; Mon, 8 Jan
 2024 16:14:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972%4]) with mapi id 15.20.7159.020; Mon, 8 Jan 2024
 16:14:39 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: remove another host aware model leftover
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq134v7951a.fsf@ca-mkp.ca.oracle.com>
References: <20231228075141.362560-1-hch@lst.de>
	<20240108082452.GA4517@lst.de>
	<1a4f6e1e-9981-4e2d-bacf-3e387addfa47@kernel.dk>
Date: Mon, 08 Jan 2024 11:14:37 -0500
In-Reply-To: <1a4f6e1e-9981-4e2d-bacf-3e387addfa47@kernel.dk> (Jens Axboe's
	message of "Mon, 8 Jan 2024 08:26:45 -0700")
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0005.namprd07.prod.outlook.com
 (2603:10b6:510:5::10) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BL3PR10MB6019:EE_
X-MS-Office365-Filtering-Correlation-Id: 611ae79e-a4e3-479e-2ae7-08dc1064ea43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	xHWWKxHafawZqjHUae1caA8jc4SzLw+Tysr+r32/C2OmBAAguDdG9S9tWauyEpX3peGO2wJH9C9ASOAwOfs/+WhiZwfIvMX14CvpVrecjKXcF1S5adFa5kBM0lAA6ca40wbclt9+niMvGeicGJjx2K0iyKe8Ma93q8jDsxuPuLvP16HmPzegRtQgRUEhAeAcqg3+cduf7X267ZaaT5OinBskQa0KUVz9mmCa5sHAfAKZITf0L8/iU87NKA8uKLcRf8qqs1Qq5mSsnBRKn6iDmW3Wyx43RWzMrB8h/c6bo5S8oY8caybg23bMwqvIYNW6+n9FWF8hkAhsSYTskYH+WEmK5Xc6uc9Csnx1g3grnE7us6QuIF75s6dAlBRoJDtbSA1HNeBExPihTgZ1zLlOsmxE1NzYlfca2nUVhQeeNcZ3yGPD5R4ODP8/uuFdJA3EE0RVNYzMHTr1c0I+R5AcRUmsjsmAccGFNApcWXJpv5nCL3awG+zWRlaFakhAU2C/sKt03rGGEGHJSGc4CCQBGK7MGCamP+6wSXipB6g0QH//eUolx8fDb4OvQvxo125z
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(136003)(39860400002)(376002)(346002)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(38100700002)(2906002)(4744005)(5660300002)(86362001)(41300700001)(54906003)(316002)(8676002)(8936002)(6486002)(66946007)(66556008)(66476007)(26005)(6916009)(478600001)(6512007)(6506007)(83380400001)(36916002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?c1pSERu79qe67dDSSKWWU/J4nfTazGlzNxg7ZPAN9JJCmi0oj1obbcA0ZSTM?=
 =?us-ascii?Q?DMdhd7skDhYht0+PkaivXooJ3WCtcrl9ILsgVVd0VjA1frDlkXEnwKuwhu0X?=
 =?us-ascii?Q?UurViNPyj3/2TrpN9Oo4I89maQWooCv0b+Pjr3vO1+IeRnI9LBm1ScjDukTz?=
 =?us-ascii?Q?aPXxweAV6QemLskcAGSOrytmQ4geYAgNNygcvQ/rPil6RTYqHueBPhYdPWAk?=
 =?us-ascii?Q?ycXr+wksClHV55ilPgGyEtzv2FUNTNOA9uhZ8OzWNt72UAELhKo273ysF22H?=
 =?us-ascii?Q?457N1BwdiGeEDLeN0UxxrlfeT8uR4oqHuPfgcQNFIomtBQKKugndnF/rOaeg?=
 =?us-ascii?Q?zKNwZnrBTqtpL8g0SvWy4iuBZtA3wEIS6a6bPWTtv5DVgJnsWAmBu2p3Mpoz?=
 =?us-ascii?Q?gmPvEPm+1ce4FaDn+Y0KEsdLJfoCVb1LQDBjo0CNQEm4V1/4XXECOXXxFj0w?=
 =?us-ascii?Q?dIWNJG00QnycBRU0hzr8v6IUBRcscKJvYwcFg8h0nfbQABc6WYTJRJOIWOkr?=
 =?us-ascii?Q?QRg65kS8gdvZwon5IftIlvXoWEXSt0kRTlQ5yP1p28o5QnMUrpzcjvrScUfO?=
 =?us-ascii?Q?IHF0dPd+O4yr4eX1wuhKdvALA+DBUnX1TOkZjwiqLg9iXDymyY6sma3zYmLh?=
 =?us-ascii?Q?cxA5/f7KknT6ibyIp+9lumBOTunGOZAFTca2yuxMa9P7ZdY8jmUGIX9DkQqT?=
 =?us-ascii?Q?d3bAATL3t915j1qm9pR9FijJxmWcsIxfdwdZCyPHS6gkqQfFvfRALDx5MZP5?=
 =?us-ascii?Q?uBdFG6okFEeLrE4e3chrYsl6lj/5F8xjhk/ym2yU1qa1Fbe5iHzJU7gY3/SF?=
 =?us-ascii?Q?qcRdOX7fhvj8Usdto0hhMqmsUkCs6FG4z2uvku0Ap5/6XbutQ4bxri3FiNjS?=
 =?us-ascii?Q?YwsGHLUc/vdXbGLqEELXPeKzfi5BhdkobgkkWpyhJxDV+y4mgKP6Vzs1o1K9?=
 =?us-ascii?Q?oW1sbI8zykcA/0OTKk5SJwSEWAeQZwEa+rx6aa5sfyco98W1vo9rAABUM5FS?=
 =?us-ascii?Q?G4Xwd3KzPdDBzR4B5Bu64fmbMaiKeSX5VqICDlXXWQ0HT92M90EVn4T/6JFq?=
 =?us-ascii?Q?fBi9O0qhHbZQCi+Yu8thtDrGUWt00KATu6IavwZ2e8krZ9EGBZUCbBR+S1DP?=
 =?us-ascii?Q?1W+b/Q/2P3Jvo1dtQTTOeuzakVw9hqdk1+DeImYfhI5nezoDZNkpWKioKyxQ?=
 =?us-ascii?Q?9rctIMVyKDkzZmGcfWffXlXXok63NCPfgnXLJdgVBd19eP4wY76rZR7fgzrb?=
 =?us-ascii?Q?UkWEWkCKtam+SytBixjJvX33WL0jXpMxfczJJrZuxvB9kyBJ2NnMmcd9WgVC?=
 =?us-ascii?Q?a1Xy88x4+buZf5l/vY3n78qySWmoda2K4vFqpSDdcN9Opo9Da7lzo1+LnE/U?=
 =?us-ascii?Q?kzjQVhhBsMU8U+A2WL1JzFWAtGh5PVouuz18AT5Bl6MrZqQboDqVIQun+Wu3?=
 =?us-ascii?Q?qs7Omdu/WJvTciQI/pn8cmnF2OqEAhFCaogQXn3RZdTdEu5Dkc+4NfAJTUf8?=
 =?us-ascii?Q?rPxeeLU1R9ZIPhbB1VjujXPtAnbwvexSLR13gUMUz7Xcc6WpvrE6MZbhZNYh?=
 =?us-ascii?Q?zm1Ck5lDX1hszdiwj7/xOI3jgz1kxE64HuR9gLLmqDuW0JxoSBeQDD9cwq4j?=
 =?us-ascii?Q?Vw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	F+zz/yqAItcegs479j3c1tv9mw7jycx69Dr4al5nq1YKBV8D/26fmP8haW7q7+zwbaUUD4fr/X4fC+WY0v4MgArkgYRoJjZXQHQ3JzDSh6h5Xy5CnKsfOIUFWEuA4Q0a2rKzU1a5nq+flhtwDRR1GSJV8lT7Nu94LH25dlBcmpG5q4RfhY05j2BO+D1N2hn3T0N9ROKms074BDQZebsL50GVM8MlSosTeHqtZA6MG/xCA8o+wRIH5d7s0ZDXaW0e4QlQrBgdnwDT2BCoLEwJ4gsXlv2VmS1P/B7aFlvekXhuWbhdK0/hxvTVONu33esI7cjbWCm2caW6J0BODLQybc17Gmk64B/5vEZMwMwfFsOtTvsVzU6yu5C3S2vGd7UykU6YkxwHWPbsjZM3XiGl2oYXKREI3+gos5ZOsiJiT1CBZbDpmXgOZYMpGubsfkjNfcRUmX55NTQK/RPhTaXYjiRtGUU21keVZmU73UOMsv41bx9ohxGy6I//W/7MpQPaiVcdyj3H67lux4xhYt1SdepFGb9tEFSQu61xXM7blzUX5VtOO3Q+GrBtbUu5/n4UUSuS16ssTzCL6mje8lNGySHW3ZC4aRZmAIMdntv5ziQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 611ae79e-a4e3-479e-2ae7-08dc1064ea43
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2024 16:14:39.4513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HZhjbErpdUqod6u0MIPCgq9HQ/VAI5y8AXMhDmhwCLF1QuXPO745KKQMDkHDdLOCRyeLoZXWBwIKc8m1npKCOW3hogXvDWhBaxaxUR5DkrY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6019
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-08_06,2024-01-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401080138
X-Proofpoint-ORIG-GUID: fobyApqPexGFSf8V-PWzHbmFtqlEtAdF
X-Proofpoint-GUID: fobyApqPexGFSf8V-PWzHbmFtqlEtAdF


Jens,

>> can you take a look at this? It would be great to finish the zone
>> aware removal fully with this for 6.8. Thanks!
>
> Looks fine to me and I can queue it up. I'll do so preemptively,
> Martin let me know if you have concerns and I can drop it from
> top-of-tree.

It was addressed to you so I assumed you'd be picking it up. Looks good
to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
