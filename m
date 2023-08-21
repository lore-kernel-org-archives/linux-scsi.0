Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7544EE49A0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 22:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjHUWM3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 18:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjHUWM2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 18:12:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4233910E
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 15:12:27 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37LFxu7U013645;
        Mon, 21 Aug 2023 22:12:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=JjOavdJCU5K7ZmG/ooPoye1cvXMKpMUv0wyymhl2GeM=;
 b=R5seys+zgmqLTbCNu6n7F1deMksLawyuatI2pRti5k9XQxB9LPDBofob+yFagg5A5Nq4
 JamHfYDDC836inS233J3nBVh8TM+qhKYErB0j/jrHFBWuscfurF08B+5uFG/b/TpqMqc
 cXR7mKF1MKit00NOtT2mUDlDkPw32OXFuWudMzjH7JlQzCMXOVAX9oP+NbydKFLQ9rBU
 Opp7t8L6W1rkoYJtZ1P6cUdKoIVhu59KtDilSRnAwfLXlFwueZM823x33bU/N7RdZEE5
 YyFtEyYOQGd2FJShLT3YVvO8UHpE6bEHU2RdMXjkHMXez0bVl8W3UhBoA8PLLwwuFvEp nA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjmb1v179-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 22:12:25 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37LLYKED007716;
        Mon, 21 Aug 2023 22:12:24 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm642dcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 22:12:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bAJRf2wT5/+eBj3VnawxdKC+6o0qFnqVDIvnAmcBBC5b13CucXm9KS7So92tWNIosSVbcqAD/fnziyfl27OYivUkkGByZDup52S8DpI2PXNDCm8m8QvfOrZpjBY4sSIqsHCY+nNFA0bnJMHV+tE/P3ymZW1A9tq9pHcgOeffSbeRfhid0e5o8KbfhWZIsiNam0X1SkyjarVj8b3NoUcv3kyhJpMon3xVkYZHb2kKkdoxmcp0ZhO8MD5fL2rCdctmvu/6BgeaqaWRkWO9Rgh5bm6dATjWPW1wC+AntnPb3PY6tsRzcjTnVUCN1FYvbkIOzx5sOC9ITGi9rPfmtXvADg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JjOavdJCU5K7ZmG/ooPoye1cvXMKpMUv0wyymhl2GeM=;
 b=F0Rv7nSQoiExxFLvUicAgz/lnpMPaWgt83ARNmP/rydCtqYMY1UoCb7RZEA62nE96ab+w4hNQowJdANrwPljAGvXz5pBXqHvlefIp6w2OIZcdGnz+1GdjU82gddK68xvtST41kUY7HhBmQ4txHWx5mbJ0IiBln8ngSTG77vuul/l2yMPBw1uM2UsFSPtOQzjP87czsmM22CxSzMAT9mN3X9KXhvl2WAx0odAddkAoF/EU31Kvmj74dPHWDh8jo7qQPSfUa6D0hSZmtkoEKgOckUXUiLKJAv0CmI20c5wY75P+xdkS7rOvD1h21RQLb+UzftX4NnZTt40T4qPl7DNTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JjOavdJCU5K7ZmG/ooPoye1cvXMKpMUv0wyymhl2GeM=;
 b=A1Qqq8UvonqGAJ9NFd0AlH0uj1fq2F2jZ8cCZo6SaozeAx1YML+cQB00HkUtWtVOK2gMc0RLdl39lZBZODe/lHpUP1zboXn1dbrtQOGm2DsOVVmdk7/J1fhskbwKaM2fmGmk52OeFdNGJqenrv9gCbpzJdB1YpzoDZUHxs5H/E0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB7781.namprd10.prod.outlook.com (2603:10b6:510:304::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.20; Mon, 21 Aug
 2023 22:12:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.022; Mon, 21 Aug 2023
 22:12:21 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: Re: [PATCH v3 0/9] qla2xxx driver misc features
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17cpo59l0.fsf@ca-mkp.ca.oracle.com>
References: <20230821130045.34850-1-njavali@marvell.com>
Date:   Mon, 21 Aug 2023 18:12:19 -0400
In-Reply-To: <20230821130045.34850-1-njavali@marvell.com> (Nilesh Javali's
        message of "Mon, 21 Aug 2023 18:30:36 +0530")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR21CA0026.namprd21.prod.outlook.com
 (2603:10b6:5:174::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB7781:EE_
X-MS-Office365-Filtering-Correlation-Id: d486b847-96c8-4db2-4bce-08dba293b0fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p0GPjoFVg/ADMVpg8VRuPKWsoI09wY3Rv8j+CWh57thO62WAp7DVRKosppJHVCP4NmMPDI9dRt8J1o98fKkYQuSz3l/UK1uzdmFyYbyigOnuVQ1UNbrc0N1UU1MxaVQXgit3WtmngQRC7CHB49N6tEg/tZief59KoFCLGBbnT7Hw9YA4dNbanDXv5sikN0dPOu1WXpZbo/A93lnS+TP3iS3oMUWifVZLjOF0APbDPkxl6+8mBGtZcRS4VpUXBFev1/fqkfx53N9J/btZHf5Kp1KCUSPbiTFiI0UmnAqlVooPG6b2fZmLThNGFDF9sbEkcTwuSi9mYV5ubmsnhrN2NyjaljhYm0dyc4HBLXEyToOq0YTAnJhEIE1EuSmol1N/Zt2Bk42bZko6ldZAgEME1mrj6nLyrRR2ECxZNY+aDNZ17pwxEJGKk8FI0lZGfKXDfduq6g5jv8oVRbtQGYCoDl6QVtSkAsjj7wKZABUNK1++qX8hxLvM/8ET07KIFZFhJNKuTJqiHpLPB4Y9QakLUg/P2g9aJzKiyqoET+JbSnnSV605bOf5+Aj9calGsc2i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(346002)(39860400002)(366004)(186009)(1800799009)(451199024)(54906003)(6916009)(66476007)(66556008)(316002)(6512007)(66946007)(8676002)(8936002)(4326008)(41300700001)(478600001)(38100700002)(36916002)(6506007)(6486002)(558084003)(2906002)(86362001)(5660300002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4hs/RpIIT+je3V0pMBiCg9hROw4N6cl6NPt5dTMWIN4LihPoTNAmPKoCRuXe?=
 =?us-ascii?Q?n/kGDqGhlxCLNmJ4petNvjwe15U6X8haw4kAzlOXfR1ijsxA0V6ZJOH4TvT8?=
 =?us-ascii?Q?s1qporVt0zSIzwnD+dLv85bVOF3k64CXTdmz93To+qcoKeSodhrsDiKBuS3k?=
 =?us-ascii?Q?TxrVL1Kih/tDP9aMdno7I6LCr+WP3RPKzgHvXb+SQOef+1pKM66Uorq+es8c?=
 =?us-ascii?Q?lukO/MOjsxGLbuppnwOmCvMtDMvJka9KymsJAhQjjJi7ofYkrA0En07HtZ7s?=
 =?us-ascii?Q?ppzm0WQEPITazYLUL3rPxIEYwyhwHC9MalnbJogzYmmQD6HAcZLLCt8+mZja?=
 =?us-ascii?Q?OJ5b/YH53mHxjTjxWoLE3kHDHLh8XEytX7z+OlRoT0SeoTUfNfYMd0/o77Vy?=
 =?us-ascii?Q?2UyrKLBUehYvZY/O8go5G1lgpN2xGVqVgjGw7vdkvs1MzI5Q3ZwIEzYY/h2A?=
 =?us-ascii?Q?p5rbdiKqUT/DQX/OxB+jfJwzZ6PPxZ9aNy04RsGqloo1vPoxAcYe71vR5HL8?=
 =?us-ascii?Q?rOqwbaOIz2eeMnYuwjeUVpePMY7jBEadcdALuZwakpeRrFgK/sf6y69+X4IR?=
 =?us-ascii?Q?Xmkk4eh+BlDS5VHajCTpIQAjvc/ObW4OyPIryedV6k0nX7k/AlkKCaitbRS8?=
 =?us-ascii?Q?cHwl2txaUAKbpCtVSkLvbGdkRoOA41OI1HuIpdmJz0m0R2mWoZtIMkBmW698?=
 =?us-ascii?Q?usqFfe+TZogWOr1wbaFZiaN7SkDrT7I8tphcNyRFa/5Gkuud+q0llEA+RhCc?=
 =?us-ascii?Q?KpwrtZ6dB1iwUSj1PW9TllJlMQaxAhg7aggV6C971IKrpH0IZPFqYk4v23P5?=
 =?us-ascii?Q?CjduUyUwtPiCR+OVaJfU6n1KDqfQiMlULt1r0k5QmzJFgAw/y8I7OpGEbhg8?=
 =?us-ascii?Q?ElGz6GP3ZiqC5qe/boE4DpdEx4dMIr9rtISAyshKgnJLKRzwZ1KYb4HTq6ao?=
 =?us-ascii?Q?xOHji8j7Yaalg8yr4sVXppTGJVlAS/IDR9Je2y+dxYavLECopiMsP+zj4l6t?=
 =?us-ascii?Q?MK/RrkleqlQ6/bisstoq8oIa1v4WpB2DUS+09a++dx69CqvmvAhv24n3toF9?=
 =?us-ascii?Q?K/6mWYIfjyhEhZKcyt+a8M6wePRNtf07sANOrEsxUpdnveJZHjdC2ruEZ+bT?=
 =?us-ascii?Q?UR9LplIpsE7vVBF1dtS9bTLWh1uPk1DJiThQ9ixyb/k6MT+DCb8O0cB7XuMn?=
 =?us-ascii?Q?Sd77VPaXsvOiCdu2G6KvCEZXYWPuTDIZtTxeNsNcAE1UmFFN/mRlqVDr0Q1o?=
 =?us-ascii?Q?Xe2sVM6JxJ7nhaPO02KrnYKbT75xcTjjcaaZvTP8V4qOi11emzszR5m3zcDf?=
 =?us-ascii?Q?0b7Cj111WSsKbrZG3j52niWd3WL4GXaxrxwqDwckRE9TIYhn1G06xrsazr2J?=
 =?us-ascii?Q?OSQHD0ZNpL3qKhQbjqSoHUrWWU78QEg2qwCPmoS2EknsCeAzDMPYsgDvzQNC?=
 =?us-ascii?Q?VLNH2ddmxeG3X/3W/SvQkEylo1gB9BUdO708cb+ZExjnEDnfNK1PIKFSSk3f?=
 =?us-ascii?Q?g7xM9JpUaDEcacF9x8tl5UxktGGVzTQTnW6yvhLDOV7nw7H0bWXumktPxHSd?=
 =?us-ascii?Q?tT8skd+mLzFpzwoW/Kvn71R7PYnEj8oEsMwgBOYkT2NMdX7md3UINVa1B8Oz?=
 =?us-ascii?Q?uA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rcyaG/T8DuWhyHMOBf5qLzfkECW3PaQytjbU2BBipMsO/rZdhK3C7hx16D1aIjT12hgNkcK5LJlavwFCc+Cv8fs5quMZvMTvaqyk6nVWpHbPF6DkiJV0I7u/kH7eNe2RKCIuUbOEhPx37SDUB6GOIf/Dp9MRs+sPXbi38+asUYo5+P9pBuozk/ImJ4vNS64cSVL/yDU6mQJNGorFbbbV2iTz/iwR3+pdwZS67lXa0PgRKWGNwT4L+zAfnl8YO/LMSiSvJDkBS+ktLa9ZvTZ1AFb4pXlvxzsJlK1zuY+B4aeGp09QVhpoBT1Nq2wX9Sgb4Z03TmI2rTQIBxcPnHYWDB1E53oDt5/aZDvBKzGEaOTGo31qb7u5qQhQeSkgF0cVqO+hHNBWuDl/nz2O6l8x6lURfGJy/NjHe8kwxhjSMJVBAguOQi3RWxtUm+GKzMZaSPQU2fnJLB+n69uYBoMa7F9PurX2vaUIhvtKy5I6Qnqk1SPbxlyaFkwLQPK/gnkq0JajNU41j+ay1Vm5aDFAp2MW5C20wQ7hrgbRaRIC+xQ15JwQvs70yx/SXaMGZalA9307mHOB8YKti8aD988do9aAm5Dl+8AbzVsKMJMhaN054VCKc0E2W747BQecpA6xPORBqnB6TLNSkj1D/2iJeWM/FFzpSIlfduRNAlKziUeBIyfXPbXg5+BcLs+5tMfRJGqkeJO4LQVuZDdQvbILNujju0ARxiOK84mTk0GvUoBAwxpVEkoPrf7cZesBF4yG3Kx1E30EQwneb8IPvsUrgETXhtxaLu16Qb1JhGsAA9c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d486b847-96c8-4db2-4bce-08dba293b0fd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2023 22:12:21.7579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jI1ZUnOaoXDaRru+AZ2k5JvojbOCBtZFUky6AbKU59I1j1V1PSv0pIXVtUZHtSLbH0unpk444Bq42GqbR1LbvZvf2NJ+KSaoEuK2OvwQBhA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-21_10,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=810 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308210204
X-Proofpoint-ORIG-GUID: ThnEreLmaVuK3yGTC9SHqPAfWqOXbGW6
X-Proofpoint-GUID: ThnEreLmaVuK3yGTC9SHqPAfWqOXbGW6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Please apply the qla2xxx driver miscellaneous features and bug fixes
> to the scsi tree at your earliest convenience.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
