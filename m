Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A6815B2
	for <linux-scsi@vger.kernel.org>; Tue, 19 Dec 2023 01:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UrOkDE9/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rOSJU9XM"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJ0J74T024853;
	Tue, 19 Dec 2023 01:51:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=F5Skxtq7wL7zRNsxNMoAF18k1MzSvZCGuzS3qcntJ9s=;
 b=UrOkDE9/Imv/IJ6SiQsIwnRzIJ8Ku7ubxQ4X0zFgOGmKsh/pVJ7w9lh6NxHDl6P2leQW
 Si27XfHeeUP7QzfvQLwhejk1wgZZSZSI4pC6oPOb4sIhLo8wqkim9mhbI0F6AV45sNB+
 On2yVmj6bGojNHWmZBFTZVfaptiJSkjX2OhowWg00VIOyjq6Qg0YjI8GQstFt3Rup5ph
 R8c3PO6kuqjkM4coFTQJR77kF9inuQahh3eBeCJxf7PG6zxvyLoxigiR6oQBp12CQmBW
 UfYP19xPM0m1ggpzdY/4gmSa5Ri+HkvP+d7oNd5eOgoZkvsq3k2NE5FyqE+wY+2jt1F4 8w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3v12g2cr8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 01:51:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJ0B9v0020887;
	Tue, 19 Dec 2023 01:51:34 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3v12b691y4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 01:51:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ASK/JV359soQIYLrHLdZgDQVDhTVx+Q4kZJ2LJM0d5dSaCIYtsEclSIU3oAE8eeeswsrodli0N38zI6agIHIoElLMIf84twK6cevfnBcXxwPDkZM+5aM6Fy6gh5ecI4Vk4/m+Rlw7f79wM3eQZ+zowujK+5RVspOiMHPNdMnjjsx2p2C6pcGFDfpI9s5AOp4VRSUTk4jqYAwJl+NPv/st9ESdyGjCA1LL+CEHkMYDdsPojzUD1uixv7RgxlZdVzN9AvRcDIwUNgoCha1XX9iUNSpVFJ4MJ+GnZdsInwMx5El9j3uNsYndJbZUNEmJTxc+ht/gUuMI99fs1NDAxP+kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F5Skxtq7wL7zRNsxNMoAF18k1MzSvZCGuzS3qcntJ9s=;
 b=c0o76mFptWAGZvBzaJwGXCSRYVsTFtVwg7wh5ZyCQRqZ4cpDqNxtpJ7O2b/rqZfyve9ddVRODwn6nBgWrb9wijFeVbXeMOGBNcBRpDwk6LMCKktBlxwKlFacOdBnorymrVZiMRABRv7xTdbNP+kSqd62kFcK6CozUdBkjOFyr3Qog4raTORVamhwgIkKk3OiA/hEsj45SvYf+uAx7qZGaHBP6BqqypGdXAyvB1I1mWUZq40do6cWa2Brfr3kIifaodXDqjL62gWvf3bs/ojSWPA4rqNw7m8iKyMi9sWuUS5HWiQWck/MPcaTT7sWFJjVSaCqcWi8RuvsOPOj1E6IEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5Skxtq7wL7zRNsxNMoAF18k1MzSvZCGuzS3qcntJ9s=;
 b=rOSJU9XM9JJg33I/lgGyDFXBDRekSAaEJr0xgaidOgL9y4CLriETfVdfBhvcMPajh6NttI7ARvxdiR1ukMrqFtRCpO3g+x173S+dG5+FO5WKWZ+NItNQNKuikzN+PllRwty86Wiys3YQI6qgNQrg3DtM/iZCy1jfc80/upqvGzw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ1PR10MB5905.namprd10.prod.outlook.com (2603:10b6:a03:48c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 01:51:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2b0c:62b3:f9a9:5972%4]) with mapi id 15.20.7091.034; Tue, 19 Dec 2023
 01:51:32 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] Simplify the auto-hibernation configuration code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r0jjc63o.fsf@ca-mkp.ca.oracle.com>
References: <20231214192416.3638077-1-bvanassche@acm.org>
Date: Mon, 18 Dec 2023 20:51:30 -0500
In-Reply-To: <20231214192416.3638077-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Thu, 14 Dec 2023 11:23:56 -0800")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0012.prod.exchangelabs.com (2603:10b6:a02:80::25)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ1PR10MB5905:EE_
X-MS-Office365-Filtering-Correlation-Id: c1e25fe1-3933-4c22-83e9-08dc00350678
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	jloykvXB8qWeQpt2C/dzKVGeWKEf5j55tig18gjfts+NWE1FDaoF/mQ16GMruQAeoSxYtd68L/g6lmcskSQTbTOLpBTR2iwPxe4fiFkHAAvbPt8CPvPwfJ/Kd+avt/iaSgJbfplaiCLnokQ7QKJ+ruP9UiyLN3P1dMb3Rqm0zq//92z00LRdEsjDK2b9H/DGEfaidLefp7Hl0bk2D8ORaULLDDUltcR+4mTB9B2pDH3fWLGTEB/gt3VFaQH6JaX/bk+zQUQSmNnxv7kqftCN6TNFztFq5h4KLqpS717RJg7krY2Zlo9NUO7fd0aFsVB4TvCUAXdCRNZCN6LJYW9uhpY5Rk98uy3Yc/WE4hROCor5F4RNfKStnMmwr3SKD6FjOXE6ixuOcFhwf+W5kqlb14Q7QvehQIav5Eh1xX3vT2tj4bE4mLDkmh6vjwypkIUVK1ArxTkTFI8bUP846UbLfiqqHixiGfeVTH+rNZw2ktUNlcf5HOLDK0syWnvkhDlcvi7hpDhuVraWQ7szmPE4lJ47siYxaj8HgldsbfsYIF9evW8GS7+6oJv0zzvjKX92
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(346002)(366004)(39860400002)(136003)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(6512007)(6486002)(478600001)(66476007)(66946007)(6916009)(316002)(66556008)(8936002)(5660300002)(36916002)(4326008)(8676002)(26005)(6506007)(2906002)(41300700001)(86362001)(38100700002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Ulw6Dd77d9KtyvzDkBqQWD2tc7C5/ohavmqiGz0qqE8xjTunpBIAmgW0ptKx?=
 =?us-ascii?Q?Mv/96v/31EK5RgHBWdetMOsVWZzMkq4QwXZXDJzeHvji88unhb34p0JybjNv?=
 =?us-ascii?Q?pTZ4jnfLGDH8fhcCp6Wj6QeAqXsVvYTHN+kyBjSomN4487/wiTBz9I2LRGjF?=
 =?us-ascii?Q?S3V6tmEUQmMNxyFUQbbJLkxiAkQUbEdT9vf3mPg52zMlWbNdxi9/qL6zwT4g?=
 =?us-ascii?Q?mJ4XwJ8VEnVVDInoADWy7yGrUFBzpQQ9Ct2uOv7wnrL8Zzhoj0jATLQyCPzl?=
 =?us-ascii?Q?JiNkJtPzSMrsIu0zWTDLZW3rhm67R9DdbXHDjEizZfl2c0WKI8sba3on3r0m?=
 =?us-ascii?Q?6QucAYxM9D/goj2IMNmltE3glQSCRXoAOgDLb/cvFgZ7HWdP1RW0gc2T7LfG?=
 =?us-ascii?Q?VardLedXSpuudyvlhqtc9zrndmvJpEbPoXNQ2BsbTvs+52q2Rgk5SF+CmvKl?=
 =?us-ascii?Q?CSlRacJU4BE1j0d+0FTNVlLRglkYqPz9no0WElGvB1Vp2UrmNWWf5a+zPfew?=
 =?us-ascii?Q?g6UioiyaHUCvFw3ifXZJMsAYx/uMJIqGxBLa+C+opjW5yPwKdzUaNPNncbW6?=
 =?us-ascii?Q?NgSb+B6diGXJk7+TtINNaHyOEUGhSDfbTS8i1CClgwaYbrWRhiQ87Nvf17Jp?=
 =?us-ascii?Q?MaIWt+OvfFjiV+Fdf59dbZ+/ImyYEXucO/Qbx4mj4L1ox/UDEEUf+2CoDd8N?=
 =?us-ascii?Q?QX4njt69Mf2fuAGBq2fu5lpG3be1PDQPPfVQtwzUuFgaJa2vasPn7on7KNcw?=
 =?us-ascii?Q?WHGTg6mTOehEph8n4DZpHiXHrVgZzjdckeXFpqpzkFbX/SMPgf0ErvBHIM6a?=
 =?us-ascii?Q?HX38HPERlaeatX9p25rHHrvZ1ZjI0erEjJ/678Il4un519j6CQI/awXh9tSD?=
 =?us-ascii?Q?NgY7/vgHugTYnZ6AC255GwcY6tGNMsHDXnHQLZFw/AqS5O/kfzMNpKlzKIYx?=
 =?us-ascii?Q?Gi3kd/8i1KEqsQ4NQPRrGP3ogFSJV16H14UmpiCHVmzS3fhmVU+HsbMyj3BE?=
 =?us-ascii?Q?/HbEQ0soVC4mN3+qr4MGutJFRzmp8Ycsd6spzr1mNX2jUmqY0mT90KdTbMIt?=
 =?us-ascii?Q?n6d3p9AlFlAZkLa6/pBczYKNBUvF2VNS7SB0F1ttx0GvDsrmtC9X7lSVPxjH?=
 =?us-ascii?Q?dEjG0d9pTrvmojRruuKm6F9dZz+jCdWilWkqx/WyEN6Q9u0cpYDYrUOQLLB/?=
 =?us-ascii?Q?o7/rhyiePzmBVQc7Polv+siwzKsbapDKkT4NnM37GSZfcR32yVrC2fDzGKqg?=
 =?us-ascii?Q?sYIFtAgfqeXCencfPLCln9r7MDmkMVWXQiv9zfz5y/41dl/3RhFKp1KP8GgY?=
 =?us-ascii?Q?D3YbQs/n5nEn4z33kQhWrpdLGA16ySOIkRkCw17ryBWHzGf39Iya8Q5klN7j?=
 =?us-ascii?Q?eYnwwWzHSi1RSZBj78pP8g/qQ9KP+CIdJ0LQccPvViEAXDd2HZ8bgfuZHKR1?=
 =?us-ascii?Q?KKmbAf1zXGdLnRzqDfArU8o4f/lkTFJ1xbMSu22vB+nklBnsLcuzW5fJG2H8?=
 =?us-ascii?Q?b0j0hCn4zIgnJrMBz48AIuZDZlBrAuo8daFyixWB/z4Yw5QDrtFL27wY+XFi?=
 =?us-ascii?Q?yiHQeIFZkdRouB+sRqBnebIcvCTr70bh1uBH7dWCBMbFH07dl0pAmTTmCP1T?=
 =?us-ascii?Q?zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	UdXFO5FfVTvRS6QapZdnSwd5FJSp6jC8ctWZbZEYAbsYDti3dykUVU8YTK7f/wwP+aomar2XYx+U382GDRrIFkrT0kv0eO9dW8x72HwNsqlrNq9P4mSbIxb9Kx/mac/7GR1eDOGahJxVUfOSvrw0UuIPjf7YErriVHXkb7mll8E7pt5xjFpFzBFbzGmSY6M35BULBF4Rh4Noua99HTnoMyuc6qT83bWLUViCYIk3JdZgpNPTACBGHGS8JSAFFBmBVnTdz9Vz1tY1mILX79Dqa3AJLuivCSdJU2ynFxoy6EIi9AxA+r2oQ1KSRdJDZ0ypSaFABXJxe2OkJABnsHhZgpLuoHEAIKOJcIaVxg9eNm36nkHEzQIs78V9jM+ePaIjV4GOr7FwysT6nv1vfvATOl4zKQ8w6Vp5H6RTe08/UTQW00Od8fTsKGdBPNR3wp+rHV3eqI9YMjJTexY+tcejYU1qJHcpC5e8+0ccKVDvNrOIing7eBJ7BK01Z9N4NhsNJljryAwtprGGwaweLRRbiap57gCUNfpWFzK3ZJmBYZlJjEwrcZogT4l2491xKGYJ1/rTzqWPMc9//E50O+dcnON74qu8zhm5cdu/Gk5iabE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1e25fe1-3933-4c22-83e9-08dc00350678
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 01:51:32.3154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7pi/qH4wlIqcBN2aepb0OLmAwFEFsm+FQ0ewJgX0oXTavtAsWWsPCu+NSX/r4rWZJLZV0rj3EOygM9g3zoUq/oGFo+YPPsu/Xh1KysW8UK0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5905
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-18_15,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=815 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312190012
X-Proofpoint-GUID: QYP0N1KactLlEsQOPR64-Xy6qRWrXN1x
X-Proofpoint-ORIG-GUID: QYP0N1KactLlEsQOPR64-Xy6qRWrXN1x


Bart,

> The two patches in this series simplify the code for configuring
> auto-hibernation. Please consider these two patches for the next merge
> window.

Applied to 6.8/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
