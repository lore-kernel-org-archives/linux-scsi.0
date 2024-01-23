Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4941350E0
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 00:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969355; cv=fail; b=tzx4lx/rOqCV94LnK2rsjN3IZ0id3KnSwHb6NmJHSC2eTJi9buc7JkM9Y1XmP9q2Ufwcw0FQeXTBYJdWjUWycNFwVA1w1SUVmGBrlWiqhpXJDrS25vPZxVvx9JvDlHVNhmNGlZStx+eLFpxJu5TYiAUNwOsLtnEH7g0wg3zhYgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969355; c=relaxed/simple;
	bh=CtmBDi/0aJY7K99YAAp/lMWEHDmh/c+vIStxSFXcres=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=WOAwv/VouWK9V/CF5vK08nho9iHlSj85Ru9adBOwl4tcNhCFPNWsmi3WHcm75GibA4ceNZywhGCjdlFJWuvN2QXTr8Hdwgl0LUKoPmKkAnze25W8jbsTIiIkN4j3gfhObD8uvX1PsGAw+8SxoJGa0+gHs2BxbxE7fl4J8QHoy4E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=myYsAqK2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FAJMR1Y5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="myYsAqK2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FAJMR1Y5"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMoq7c026501;
	Tue, 23 Jan 2024 00:22:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-11-20;
 bh=RHiKqhzTCsCX6WktaHf+S6BYJwm8DVgrU7y8vF2vx3Q=;
 b=myYsAqK2piwUkVKUCcUNaSoTfdznHAvGLbPaO7kQo9fgXCQ0cqVQv4Bigf6G1L0Ns0vx
 hfBkiUG6B3DY1MWGHeZHJIamRN2egQOLuifMDOCfU6J/ubbN9/kMMrP1uNdikh1eVZXg
 qgU54kdlLxAF4vei/6yTWOVaYBj+pEoR6j1tSwIoAUInQ9GVkjMFrvswdbyKUAa+8dnB
 0i7keEs50IjWadCiwqAlO2z+hMyzkRijSNf+1NGTAcAiZ0UctmaSSPxFNizZwzlghVH4
 4L/75SeZVLcP6A6ifeL4Pam7pgiFqAkqDGB1WpPtef/XfQ31OWzGiK87mtGcuW0O4RpE GQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr79vw0w2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:26 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMoP93013174;
	Tue, 23 Jan 2024 00:22:26 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vs3700jge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJLxCUVu0BHpRcR+y8lq2fFnXExTsmYqdG8+OXa9GS3onJv2g5QlhGFvbMTljt/UOrXO73Sy2+G+Dh7A7LgrG2EVSYpiD2CBrNvjbaxM8HoeFd7rasfxaTtayVuPIVdS2FVnCypzTTr8k4+OHV7/6uz2q2RGRMzH139Vu92qgYwQsAyI5d0MKC8EGsxaa0RXxYj8FZUQgQEloQzhN3y8hu+vtO9TSq/01hsQ92fBtUAFW3fLB00ewmC7jT8sEdNawBH2k5jN6tsvAwYmIP6rfv2pGMfzf7aFSYWSNzMkcO4lfE9yvXoXP5ST/O1aXU37hm/CoqpJIl9OZO09pJnKQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RHiKqhzTCsCX6WktaHf+S6BYJwm8DVgrU7y8vF2vx3Q=;
 b=PinfGQBL6v3Ag6M6NEyc5p/6VpiU6gyTe55NRAiIgs8+7U57pixiHy20f8DsxwXv5lvaGy/rNI+7eQtXDXpMGinpC5yT6lsasrgwKxkWKhAE6reonypUfS99l590gjrAXiHTtWdqpBQq4Jb9bnNpTyxhLMy9wmGov/7WBw9HychPkoV/U4cO0MxMsrGrvK5H8bUfd+AdQAYvXiCBsMUo9r6764DWr1Z0wSm4HYc0Zj/px39M3RWeGA3GW8rS8g/7mPfwCSym34HdEw0pY3+Oy6OtoCKxrTVO0LRimxpBQFk669n+wJzwBV44dKEZyTlgODZX6OBnEgwfk+tAgy8JMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RHiKqhzTCsCX6WktaHf+S6BYJwm8DVgrU7y8vF2vx3Q=;
 b=FAJMR1Y5d0zVhokemPQaobMODeD5UUCeRYYwav8Cj9HKjTyy3TUYTnIOCx9BhIezjrluAlrpAsRHfCLwzgAH4rWgTMwZiTiC4F97LR4IzW265CQNnAtr7xJ45+5bN4BGziHqAVxf2dw+v8Kbisop7/4VVMNtbI88OST3ies7FuM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA3PR10MB7041.namprd10.prod.outlook.com (2603:10b6:806:320::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.32; Tue, 23 Jan
 2024 00:22:23 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7202.024; Tue, 23 Jan 2024
 00:22:23 +0000
From: Mike Christie <michael.christie@oracle.com>
To: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH v13 00/19] scsi: Allow scsi_execute users to request retries
Date: Mon, 22 Jan 2024 18:22:01 -0600
Message-Id: <20240123002220.129141-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0074.namprd07.prod.outlook.com
 (2603:10b6:4:ad::39) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA3PR10MB7041:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cdd4844-a9ce-455d-5f43-08dc1ba95ecc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	UKEbny57efvQTQ8yJwzCJtxj/APov1imeyGPfF8MDC4MXfrWiE0+ZMQoET+D/wyWKtliIkR5bJLbhNNWzx3W3YWXmsVBh0kMvvFC/JaIYel53o6vjl/DgsgbLhsXumiCOcijo4vaCxcN/afttoVbpRjiuppfg+kjdD24zH8oKKbAbviEuJq0BKVfrcj4EF5ZAsxUiMw7SiiG5DIMKRhj3EXOTgWE3jCVAk1PRakFzQ0hVIVIOTQYFmTLMh9RBgClVjuiwTq4zs3bZLl7Y/wfKQ96u0/TvRFdPwhzGtfweZ0hrE2XQswsjC4Itc+nERnzBOs4dhHavjkHZVzo+5IrJYyfhbmD1ZeBviKqD5yz14PAYYDf1AzGq/s/xe+nV8UP8xfzccC93g2D8RlGddUI+/kBngEu0P2w9QkXO6CJsoS943NFgIXDEHrKdhc7nxwxP0YJ2oh/NJnXP+bP6meicp82sdkVaO7xzycKpe0uCMrjF1VRIc2WiZ3/JBSUBzFnkQuPMbH1ytguc+NjBeHHEcqbMGcI0Lx5+FoGuGut5OPHxDq+hj8aQz+SYFZN9PfL
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(39860400002)(346002)(396003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(38100700002)(36756003)(86362001)(83380400001)(1076003)(26005)(2616005)(316002)(8676002)(66946007)(66556008)(6666004)(8936002)(66476007)(6486002)(6512007)(45080400002)(6506007)(478600001)(5660300002)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?376V6jskxdQT/xhcj+MFXJuV5XTk1nKK/d04kU4tTZF+G701JcphvO84Ix5M?=
 =?us-ascii?Q?C0Z0a94iuBKLCrRJJ7AUXD1nh2Rep9bXG5X7j7ZlcKFSrZ960BdHdUD5sKdr?=
 =?us-ascii?Q?ragGWoULHwzcZXLvKIURoAJ8YGNLo1K3QmmaVcS9TKr3siZ+yXNjycNLRjrb?=
 =?us-ascii?Q?jJzb1z11/ADSu41DMKkl2JeUAmQwoh7RcX3AcrkLDZyiBbQkGurkdo+CiC5V?=
 =?us-ascii?Q?1gtnYtMwqa9HRC+eFH+673IBk1RUeS3TjXCaAuj0hiYOa+nAGc5Zz+OAD71w?=
 =?us-ascii?Q?WbLqhHNN+FjEIvkfcOSYeyrBFQZUz/kgwDHpaVuoGjKiSYEOsihXFUkshMce?=
 =?us-ascii?Q?mP53hpW/cHh5aE++axWQ/aoADNxOL2EnkfFJ7PX2Tlut7bQZv751Fd+ojr3F?=
 =?us-ascii?Q?FCvle15xvlyBpTnnBFHAoNcFOguFato22H9I56HnjUxVmftPv4kVu52tUDpN?=
 =?us-ascii?Q?QmLsM6DrUtMYtD0tafErGjjjVIVs7FGpLFBHBp3MdS7hZ1Cr43laXOQQr9QM?=
 =?us-ascii?Q?HHBgaeuIqJ86OoaBK2zGnJ1CTq353kZN0i9gHH2hwbehTh7YvAFqP+TqCWs9?=
 =?us-ascii?Q?R+I1wEaKC2PRojQOZKKuZnLWjaLjI7YFkvXeIYBxhz25b3kNw0IGR1dkUBsN?=
 =?us-ascii?Q?tKhnBhDNyWnzjCpbhzU/quocFbJPybJA4NvhcNmsBFVFgcLUH/8kE9n+lyHO?=
 =?us-ascii?Q?+7oxGWODM/Aff7lGQu0YHTWfevpiiBBy4HAgsX8vBQf3CRebb0SfoLqKh3AM?=
 =?us-ascii?Q?x8TJUc8pGX1JsptTqMdLWnMoMgWQmbcLbZFhV3wbKIVqBSJUZH0mep8N96nW?=
 =?us-ascii?Q?Cwuqda4/titNg7xSgbMwC8qqIJjxTO44mTaAeSLr1yreWVrV3JLyx8cem4po?=
 =?us-ascii?Q?19gdqlev/3Hy2rNpEgeekKeFZbpoAiLDrPJghiJRt+LUssZTx5UPHzyoxyxw?=
 =?us-ascii?Q?oL+JhIxWwC7VZUdU4sD9EAzHotXQPldaze58XYhUSgjKKPKxAv67DtyHAprN?=
 =?us-ascii?Q?XA5FiSe0NQ9530WivfTw1YWz83u7W3lDchsuuuPpE1aivBLKl1CEhfTOhlOy?=
 =?us-ascii?Q?cwWx/P1Xe07GzaWVrBnKdFfwltUbv25QA0rEHi72zZtVtiTAcvE+Dus9UBpc?=
 =?us-ascii?Q?AwmJEB7jJZgfUHJTA/cbNSef1GGax8fPyKK8pPfdOHpUXDoMwKpgrGj925FU?=
 =?us-ascii?Q?0RSw5Zzj3os9TG1KpBXQVxI8o3NDUO1hW/8yZVrGjX/3fv3MOjp79ab0YhQ8?=
 =?us-ascii?Q?MG2eDdDvbOsu2STKS7csK+tIV6CvC0jN4q+bIzy3GK4AIEKw1kvPnDnyuOZs?=
 =?us-ascii?Q?ZkAobrZjtsPcFfswWk+tAWVblMRPx2uFdTFm9+9slBjwfpOWOIZ0+vHfr0li?=
 =?us-ascii?Q?21pGML05QeiZWnvU+rCSSFlFsEm5jmFH04Gl7m0JhzdDUTnVvh/IL9z7Lt9b?=
 =?us-ascii?Q?P6rOlq0XYrZ96ggFE1vh+6xf1babv58Bb8yvq09SyXok+dKHgLb5bShc4lb5?=
 =?us-ascii?Q?ZLs5rmf/97i7TJswO8nLU1dvvHRydK0lm1Qkyf4aRSxCEihkrBlOt+sR4hd8?=
 =?us-ascii?Q?j5fdlBaV2Tk5J7OQ56EfLML4EXglbu5RQAf41lF9zN2kLYmoaQuMVe5cPDOR?=
 =?us-ascii?Q?pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	A9/cAXJcHbsht9ukedixZ2ewWxkVixImayQC/Q7+BkEKcJhPv4xd38dTXWk3HInhkkulrhQsLYx+X7ywczprtzlMVGTdblB7LsdvvSli0xzzIx9mjBNp0MiBI05yMpli2zMFhV6QvqTlA/K5X+ZTg5mTlQ0bvk0yBcFAsYZZ7vckRtvwttqqxRpGKUwa+82UcLDfsYsPHtlw3d9KL8kUP9Q6Zh6ZnMGj7yYTYa7BaVpuqaCaBUWveJGNTDy2rLwsVIzRKs9UHD3mehQPliG8s5W3sQR/UQlDD1C/JxFnUy3z2IHHJzuP0rcRXX/Zc8wwRY4iMyuxLOEmd5jNgy5UokdOPdeJmx+EKuJvldtvW5c9BFtCvlOeDWXIqtinCNNHOZmSCZf54n45oVh3ReXhGYm5+tqzXwV09dTNTxWVAmiwfMMplUW48hosnH0z7UMX/nO+yMs0vYzPQ/98/KaURvvXdHxJ1+ZJLmB2m05YjaVpgoyIu3bKnAz2RVrDkbHksW14KaAuW2IyCoJWxgAZIkeHI2L89LUjPUa7jrymXv46NFh1bvwZPV7pWjPaGAXwWjgEiQJqf9NZn8MPdQ+W9nmE4gPAeRDph9sBsWOaogI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cdd4844-a9ce-455d-5f43-08dc1ba95ecc
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 00:22:23.5262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D2iXlMHq6ckk3OfykR5c8O4dDyspqQxvgJCLO/R6QyQre48WKOEG7+469GUKN4zsQ2WaEoXvrP6VHyKFYNf7cuEBhg/fwm2xHe603DdEOdE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7041
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_12,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401230001
X-Proofpoint-GUID: 84PyDF-fJP71wCoaAApmKizS7NYk_LF2
X-Proofpoint-ORIG-GUID: 84PyDF-fJP71wCoaAApmKizS7NYk_LF2

The following patches were made over Linus's tree which contains
a fix for sd which was not in Martin's branches.

The patches allow scsi_execute_cmd users to have scsi-ml retry the
cmd for it instead of the caller having to parse the error and loop
itself.


 drivers/scsi/Kconfig                        |   9 +
 drivers/scsi/ch.c                           |  27 ++-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  49 +++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  84 +++----
 drivers/scsi/scsi_lib.c                     |  26 ++-
 drivers/scsi/scsi_lib_test.c                | 330 ++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c                    | 107 +++++----
 drivers/scsi/scsi_transport_spi.c           |  35 +--
 drivers/scsi/sd.c                           | 326 +++++++++++++++++----------
 drivers/scsi/ses.c                          |  66 ++++--
 drivers/scsi/sr.c                           |  38 ++--
 drivers/ufs/core/ufshcd.c                   |  22 +-
 12 files changed, 822 insertions(+), 297 deletions(-)

v13:
- Rename scsi_execute_cmd's retries variable and update those comments
and the scsi_failure struct to try and make it clear how the retries
values differ.
- Fix up some misspelled and add missing words in patch descriptions
- Fix up patch 6's description.

v12:
- Fix bug where a user could request no retries and skip going
through the scsi-eh.
- Drop support for allowing caller to have scsi-ml not retry
failures (we only allow caller to request retries).
- Fix formatting.
- Add support to control total number of retries.
- Fix kunit tests to add a missing test and comments.
- Fix missing SCMD_FAILURE_ASCQ_ANY in sd_spinup_disk.

v11:
- Document scsi_failure.result special values
- Fix sshdr fix git commit message where there was a missing word
- Use designated initializers for cdb setup
- Fix up various coding style comments from John like redoing if/else
error/success checks.
- Add patch to fix rdac issue where stale SCSH_DH values were returned
- Remove old comment from:
"[PATCH v10 16/33] scsi: spi: Have scsi-ml retry spi_execute errors"
- Drop EOPNOTSUPP use from:
"[PATCH v10 17/33] scsi: sd: Fix sshdr use in sd_suspend_common"
- Init errno to 0 when declared in:
"[PATCH v10 20/33] scsi: ch: Have scsi-ml retry ch_do_scsi errors"
- Add diffstat below

v10:
- Drop "," after {}.
- Hopefully fix outlook issues.

v9:
- Drop spi_execute changes from [PATCH] scsi: spi: Fix sshdr use
- Change git commit message for sshdr use fixes.

v8:
- Rebase.
- Saw the discussion about the possible bug where callers are
accessing the sshdr when it's not setup, so I added some patches
for that since I was going over the same code.

v7:
- Rebase against scsi_execute_cmd patchset.

v6:
- Fix kunit build when it's built as a module but scsi is not.
- Drop [PATCH 17/35] scsi: ufshcd: Convert to scsi_exec_req because
  that driver no longer uses scsi_execute.
- Convert ufshcd to use the scsi_failures struct because it now just does
  direct retries and does not do it's own deadline timing.
- Add back memset in read_capacity_16.
- Remove memset in get_sectorsize and replace with { } to init buf.

v5:
- Fix spelling (made sure I ran checkpatch strict)
- Drop SCMD_FAILURE_NONE
- Rename SCMD_FAILURE_ANY
- Fix media_not_present handling where it was being retried instead of
failed.
- Fix ILLEGAL_REQUEST handling in read_capacity_16 so it was not retried.
- Fix coding style, spelling and and naming convention in kunit and added
  more tests to handle cases like the media_not_present one where we want
  to force failures instead of retries.
- Drop cxlflash patch because it actually checked it's internal state before
  performing a retry which we currently do not support.

v4:
- Redefine cmd definitions if the cmd is touched.
- Fix up coding style issues.
- Use sam_status enum.
- Move failures initialization to scsi_initialize_rq
(also fixes KASAN error).
- Add kunit test.
- Add function comments.

v3:
- Use a for loop in scsi_check_passthrough
- Fix result handling/testing.
- Fix scsi_status_is_good handling.
- make __scsi_exec_req take a const arg
- Fix formatting in patch 24

v2:
- Rename scsi_prep_sense
- Change scsi_check_passthrough's loop and added some fixes
- Modified scsi_execute* so it uses a struct to pass in args


