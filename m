Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6412A14E2C1
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 00:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969363; cv=fail; b=LdIFL/whv8poiSfODblcjUwWKLLGlYEkmXOLWRlcuk6Vb5UYXCNld90cDCBCbo2NZqj/yv3YiOCnLtQc38diqsrg9SQHG/s0A9lOrKXZfTWSDqDWznkfPYM1Vi0S2KQOjpM3Hyq3uUuLcyH3uwSjGagsBL0kO740S/9dLlWH/Bw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969363; c=relaxed/simple;
	bh=Z2s1DAJMlboxwFQ7K6T/a5eWyB9BCDfWPEOs3Sjc/BA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=V1XCZHT/0nc1m9wy3jNuOKhOmGaxeGDj/sMarts0rYpM0WL455IbPD2FK1Vdnatfhyk81GMQqSJDE3fsKiOZ0FbwdNI4W7aIWVwWpv4VJCobT6fzA/6u0t60HqNDGJfCx5GpJe1Qu1jOGvcD0zG65QHc+R+ysgLgmVy0hZKXQbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nzLVv112; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YL/9K150; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nzLVv112";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YL/9K150"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMoq7d026501;
	Tue, 23 Jan 2024 00:22:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=GumYsAdzRdmAjg7ud3icqplo0EAItN1svWEtdMeRs7U=;
 b=nzLVv112Bz67/t+J3HeSEuAu1M+fziELBrBSe+Z3P4oQBES2RglVy8npkPOwNlTkf1U2
 3aAuWF2cnMF2bIsw+JH7b3+blf+fYCfBFTFDGhNGBfOovQx8qNZ0XCZabWTpDOK/b1iJ
 WmKwMFjzHUIapChS0w1iVybO34MI/w0KgE4osEW7PeLDaf3tza9uHAgqEH4fuJDOQm2B
 FejVjYmsBGzWDg/uYlbPmnWIwko4U1PW63Y1NXNY62n9sW6PnABOTYxfIqKbyjb/JwEs
 phPGQanQlokQ97wzjRbLbgNwsOqVPd1PKg1IrF0Z/lZiVtva0OMr+WubIpgJ4QKeXWCE Fw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr79vw0w7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMqMga013112;
	Tue, 23 Jan 2024 00:22:34 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vs3700jkc-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+B66W4zzaPkwqwwjnv5lyZe6fQBlw53xGS+D/0nn808tcITEYK9Epcth8FgUKSWO8JqaXmLdKTX2GNGHYpggHZnr0ggvUXmBYdCPOlbwKHfCk/NvdvO2hwOWMN7SBmxpxf0o9ZYIy+SIkj5ONWaTykQDvMRAijRrz+I3yzMuR00V00FZ2pvwxZ6UAUOvJO6A3kmYHswnKpkmhvS87uVd4tOPEOLhAIlTAoXiisWa0BqgjA7qk/W8NUgGqHk8qRnp6i77d/dwV3OKnk5eaU4h2i+0gTOYrwPRaEIrcEMSXvWUEXKwn4y1XmfftnRm+gQID0drfJTIcoqjMwma4KYzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GumYsAdzRdmAjg7ud3icqplo0EAItN1svWEtdMeRs7U=;
 b=SDXr4+ef6mb1pa8C+2BDe+LltkArw8BEPs4XQOwlx8VlUIV2lSCEIlJ23Eowspbl8HPD+KqRmK6gINNNDyAbggb5cEVTHCMvlYGA4Y+e2vLFokQwey5zhD5mfH9L0oNEjBBzCKpW0JZNRSYfLSKwfecRJHLXu1qNZzuq+HjVOrIDrpwM13VM3I/WDMOI+sPa8TY4dIDmJpba9pc5U7gzzW2AtbIq2Y00wwEjsG+tthhAxS1wdLyTPXgayimr75xyKCoCvM3zD9ynic3tX/Inltv4XKfb30KKd/iKFl63N5lhKyvibAHJcp8Dbk8fx1OislPBgM5v4p6CNpCZ/KUCYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GumYsAdzRdmAjg7ud3icqplo0EAItN1svWEtdMeRs7U=;
 b=YL/9K150iqBkwKr5lCuR3zYzguKiDqT1VNvfMhVd6eef9nT8jvPzW/IvVXz7d9JEtMREIqmuQYBcthlwGlMNPW/DvC/k1is43sa36SdXgZCk4Ln/tS3xbyVjlHVhA7wOtrZ2q3aojLH2/kXAmuv3xCWoVFEJd6KU+OTOJgMlio0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB5340.namprd10.prod.outlook.com (2603:10b6:610:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34; Tue, 23 Jan
 2024 00:22:32 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7202.024; Tue, 23 Jan 2024
 00:22:32 +0000
From: Mike Christie <michael.christie@oracle.com>
To: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v13 06/19] scsi: hp_sw: Have scsi-ml retry scsi_execute_cmd errors
Date: Mon, 22 Jan 2024 18:22:07 -0600
Message-Id: <20240123002220.129141-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0119.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::34) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB5340:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bdac062-dde6-4a05-0006-08dc1ba96400
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	E7j0dtM3pOADTztKLcBcsnc199nzqZNDHmESTaF73YUneu9QZuWmIZmGkMQ2+t4CHZSeCqxsvLzNq0LJqkhLFc3f02jSEV2y8UXjrueBu6HBdHLqqd+IXicr3bCHUb+X+3p/Oo8LyiVo5Rvq5a1G31Yl59xsqg7w2kR1CFFb1NzMH1mspQBrh1Zl9+Sq16JsnOKqQXmPbclgYpVtZqcdjmL0/2OjYilN+Dg0Kpo+wV6G/T2Wi7dCa/i5gwIkxNVmtlGRC7y4vwFgTmcT9xU/1S1or+4xZkpnKLpQQycwpkWrel6VwC+UEKI1T6xfOZ3muF+Me0fkYE98kSdFzrXniFtIInKLrAzXnVV4G+aTvVuQA5VDFRq4EvckMKM6Ob0Xi2K2dbGtC7omANJfNX844kTZYOfjKFWDu7nIkibHiY3CvIvvmFqSftoivzoRAfSQMHWjqDDpLOFecyXSOZloY2LRiuW/g+IHLedmNAuDa3qTgWDx2TSQwWMG8MA9LZc8/SHxugJbY+Y7HYxE0eEm2BSYo2yL9zmQvOGO10IU17QtRW+7xkIWnC0XYKuxAMPWhLnOmuAdmSI9d4lycrG6OVGsyZbqZKMENhh+IG+m2WadAKhSn2WcuyeElaCuyWf3
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(346002)(376002)(230173577357003)(230922051799003)(230273577357003)(451199024)(186009)(64100799003)(1800799012)(2616005)(38100700002)(6512007)(5660300002)(6506007)(6666004)(83380400001)(1076003)(107886003)(26005)(478600001)(6486002)(66476007)(316002)(66946007)(66556008)(86362001)(8936002)(8676002)(4326008)(36756003)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?NMrKsbzNcNjPUHeUlsXyW0zZp2AI5hljTxXX9pxShmRHcLc2kEwsMlzAV9wx?=
 =?us-ascii?Q?RAjnm3RQtfHGONqEY+1IPCKjeJrCB2FxhUQ53+W9X87xG21IvcJZCCmBm7+q?=
 =?us-ascii?Q?OUyznwzjbp5B1xK1xOrSgroWXQIL/QZXxUDsvYeL/2QCVnaY6Uqv4CoIh+Xh?=
 =?us-ascii?Q?29TBNzy0p6knRJByiC488rL1A+bFTcFTezCWssfZgmfKjARvF3SYDQuvHHIq?=
 =?us-ascii?Q?XCkFOxNp5EEBi/3on8LM7bKqLAqVC4lzsxTexwhnx8Uu48AszwGb044OBwK+?=
 =?us-ascii?Q?VYkjbci9L2ed/eRrdtUkmabDmok/TyrN3aueO8WD/iqid4SOv0neEU7u7cTq?=
 =?us-ascii?Q?I6Z5G+XfWRc45K/2nzQNy6SHQtZ1IWUNg7hwEvJp+T3lBMI3H6lIIBY/yWMz?=
 =?us-ascii?Q?6GeeKLH15qgPXHAj7qocqmftO7DKXzCw7twpAlUnYlJwEhf3+YnrBDZmvwJA?=
 =?us-ascii?Q?mTi5XNG+gYMGvw5vwq+4635v6fQhUAnC8NkBMHGX1+mp+snTwtke026BUwAO?=
 =?us-ascii?Q?m3/TKKp+qPhXfCykvSgW5X3is0k72gPowSqRff7vz1cZAFjO/BrJAaFUt+p5?=
 =?us-ascii?Q?GYTJZh8xwSDMpvXfSeZmRTkggYJsWRRdd2Eepkf2+DyfOqwuy1Dxk3CjeFdY?=
 =?us-ascii?Q?FNdIe1/Tms1tvFAshDsJ8Lna6gtKqbqG7kDr2IyB0wYEM3uFBcA76vTPFHCV?=
 =?us-ascii?Q?mBWAuoE2CUsyYrCWV7Mb0i+En8wshc1oCIZ01SK1mHNbMV8zDX6zx9Lxjr0H?=
 =?us-ascii?Q?VvyIPnSB+sAmmRyyt2eiUakkCOQztW1BnLjPGR31uUDn2ozUrAKC+KN+eVpI?=
 =?us-ascii?Q?VA8vs0vqNZ6Wu1a2E3Xddpo59SdTceN2mHTst2WrZS8n7fnczQb34A1yJEBL?=
 =?us-ascii?Q?fso/sNSVlPGFKX+zRAajikfGqTXbGRrNv/rYJiDljLKrNkbagL1MykvozCpL?=
 =?us-ascii?Q?ljxTjfqvwSejsr4g71hr822LueXfufa68xKWzjSRV0ofX9sleP+coXy48PzS?=
 =?us-ascii?Q?k4KIi20lZ+Berdhf17zFxe9IpinSfgde69J7m9ODyGp0xKDsQ4+9+U+W+Tsc?=
 =?us-ascii?Q?sB8wGj2tep0+TvpDZzyQ6Ue106+hoZZUfIEHk8yT9kWUHkggBVBigca5nmQW?=
 =?us-ascii?Q?2HzA1pC8y0SqZJGEDchjKs34SSvqW75oOeweENOlwvY6BlewpidZ5CPJcIk3?=
 =?us-ascii?Q?5qfDyE7vuknK+IYv0oT7ALacRGpnKs0uWFTxllPz/vG9SfYJ/niCCAJdJkPw?=
 =?us-ascii?Q?76lFFTxncbsn22kOZacYcF0xls6aeC6VDei51OKenL86qbhjXfJtQ5kr5ENt?=
 =?us-ascii?Q?9nIGJP62KHhe/5DZUqk3eA65lpCMKMYHMw1LxeboYp0RykFKlmBl7jbE+Cb7?=
 =?us-ascii?Q?gmISx66VOoQbDm8q58dFemEsJKJAuXw2vLdU5NRALoWV61Vrtu8EBYX5TdMO?=
 =?us-ascii?Q?Nx/ER6DU04VThtpMsKRAFDjPFUeOh6dUq9fxknVjyLyE+WMD2IjWZP9fPOKV?=
 =?us-ascii?Q?QzguY5h49IGqssTVZxUizpsWyVljHh9gsh84Q0aIpV+gQBN+aBcXB+FaTIkt?=
 =?us-ascii?Q?yCTcGt2S5k9XGXZSTZjh+tYTd6lP70FbfC1WyYsbroz/YfPCM5VidKTxifp3?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	7kug5zIvhC4rjF8KwpAKX2xyn77k6HbNhHkrHo8JsFwBl7JtY6kPvJQNW0PSh++EHnAccsW/5APE57jB2xfSJL74BOmBp0JZkCQGfX0sWbtSrPqh/0cs0Vs2tl6vbLZy0VkA6VvmNm6i+5lUPeFR+nWRaw24hENPXmDL4eL5PR8TQ1S8dBubw8b+DpIt8vnPB7qphQbYAGMC40uEjtteAdOLChBpiJSq6Icl0DP1okO9UXiIa3VwdWK64KZwpXaqloJs6j6p3gruu8orIb86cbRQSTxyjLQuJdR17Vi+WQSCmuG7vyCREUmzGl0QaNInp9YIJQRtHvM/pmkztXFCLate0uxA7r5/23rrgRoNqZ6C0aTWJDnfJxs9JKR5SAjFAyPDymYPbMhW6xnZRPTQMgYmS6mzNM6n6ts7FMyqwFRr2gQ0amCu9t4/CYRYqZuZA6YWl3yAlTvXZUzyL8BMT6oZuh77zZKM1GeqBQtDp1qXOsGo9pwJOYcm/xnLQ9RYTdXXhpgRF/UGocohGPE34GTjpY1IJxkHBi1Ea2e5Zlc3iyexGzN3H5lvLC3DTGH8ePjCL48Hvmfn9g+udBI3xy1KILkjGnnyRZW4R/QrYyg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bdac062-dde6-4a05-0006-08dc1ba96400
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 00:22:32.1977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: goAMGKBN+yhIG5wCcc9rlHQlT+ZHyIuD5KAIOBkx3UsZ/bXuu7bRGZ6W0mHwm+cTnxqGog5d12y/U11BV2fbR3CT3kYKOsJnsYByPZZdKi0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_12,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401230001
X-Proofpoint-GUID: uGt6jK7Wm1kGtd2pZj5tmQ66OPyfYiqQ
X-Proofpoint-ORIG-GUID: uGt6jK7Wm1kGtd2pZj5tmQ66OPyfYiqQ

This has hp_sw have scsi-ml retry scsi_execute_cmd errors instead of
driving them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 49 ++++++++++++++-------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 944ea4e0cc45..b6eaf49dfb00 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -46,9 +46,6 @@ static int tur_done(struct scsi_device *sdev, struct hp_sw_dh_data *h,
 	int ret = SCSI_DH_IO;
 
 	switch (sshdr->sense_key) {
-	case UNIT_ATTENTION:
-		ret = SCSI_DH_IMM_RETRY;
-		break;
 	case NOT_READY:
 		if (sshdr->asc == 0x04 && sshdr->ascq == 2) {
 			/*
@@ -85,11 +82,24 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	int ret, res;
 	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 
-retry:
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
 	if (res > 0 && scsi_sense_valid(&sshdr)) {
@@ -104,9 +114,6 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 		ret = SCSI_DH_IO;
 	}
 
-	if (ret == SCSI_DH_IMM_RETRY)
-		goto retry;
-
 	return ret;
 }
 
@@ -122,14 +129,31 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev = h->sdev;
 	int res, rc;
-	int retry_cnt = HP_SW_RETRIES;
 	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	struct scsi_failure failure_defs[] = {
+		{
+			/*
+			 * LUN not ready - manual intervention required
+			 *
+			 * Switch-over in progress, retry.
+			 */
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x03,
+			.allowed = HP_SW_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 
-retry:
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
 	if (!res) {
@@ -144,13 +168,6 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	switch (sshdr.sense_key) {
 	case NOT_READY:
 		if (sshdr.asc == 0x04 && sshdr.ascq == 3) {
-			/*
-			 * LUN not ready - manual intervention required
-			 *
-			 * Switch-over in progress, retry.
-			 */
-			if (--retry_cnt)
-				goto retry;
 			rc = SCSI_DH_RETRY;
 			break;
 		}
-- 
2.34.1

