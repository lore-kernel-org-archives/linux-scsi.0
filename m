Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65EAACCF9E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242166AbjIEXRz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241072AbjIEXRh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:17:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95803CC7
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:17:34 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385MYx7p002873;
        Tue, 5 Sep 2023 23:17:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=vn1LlRYjOsTH+U7UguqzC8GO/ATJbuphW4usSB9v/NA=;
 b=nl5KnGNiuFJeoS/Wh8SUzKaI2SMAwRHJdetwRvqMayAx4rFFLao9D12cnx+K0XiN0iV1
 c2a0wmzJALU1bcXf12LQKJv/bgoROg93TfrhVJ9YnYNO3IM/sDT/a6NhZOBcYZVtbzkj
 TzMCoqSMn+ETVv+cMY2CNiCVICfKLQjhQ+8kkutqwoccoFsrRGcqW08x6Bhl+60qX3YI
 qBVe/Vnx5iD1Bj1MX6txL8xa1tjhNcdbo7J2mBKqB6jZS7SQx0sy/yTWwyR7XSBPz+v6
 kKPXzKUAVfJFUBjHb5PE8Yb7f264aO0+sFJPf2l1W+bbFgxJL8lJ4rgADcvJoxYZqAmu 7g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxd8d825a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:17:18 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385LwVYj028173;
        Tue, 5 Sep 2023 23:17:17 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5e4hn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:17:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8PAKGfruLwbZDAc5kBoN39LSuB+DvGJR9UQxp5haslhCsNaFFEls+QjBR/dBXFoDN9rkLMcWYQQaAlg0sApKy63dm0gMHTXB6bpyXFKmGMerHbxzWHd7sATHiffn8euazKpwB0JCXcy0L3djxKvFcI3QWCYHKGc6cRYOu7MnoD/oU7/Uwa5pz+AdK4/B2IBlZUgClP2FYQA9XqNMn+WDlrKakPES5kME2H83h4jJcssx6bnaBPxy74j3kBpEGENesxez9LPGLol2fxNrG4MdtFGC+CuRX3rsoTSazDGS6p13co4WIXXFYpkC5k4VbC/F5bEg7VeYHvHFfD868Cuag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vn1LlRYjOsTH+U7UguqzC8GO/ATJbuphW4usSB9v/NA=;
 b=nwqevOG9Pm/cstkZCfiwOzeTZq4kFaBPVLzSZdZT/InIfa7gvRoGJSZ5+gvsxpGKri7FsY/wu70aYJRcaWk21xgK7d56xh28Pjc7m5MgJLaBeuQgD0yENjrbwIZ2j0qKddmI3ZO453UBlCoWWjcRZOw9Se91ouCNQhy+YXqjYQvzq3p07Tz6znyf5HeazfNx40uCwgn0XNAWnfOHyEOIClxpob6mvFUT+6iNl5QoMuuFz03NCZwtaiUkAMMRxbPuY3ko6ZjHSrvCuyqfiEPCs4wlNHFCoUOXu6s6vk2Ay7ymZd6GitCNaaiavGav9AXIKY50k5Nz+TUr4Bj3zXsRjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vn1LlRYjOsTH+U7UguqzC8GO/ATJbuphW4usSB9v/NA=;
 b=hPWDBSW4MKNk4hp/cGAjX7dinQ+geflLIkcM2t1TAnufOYAMw7z7hj68nThTMylCMtWFh1Yo4vgme1FGP2k0T11sOy9mLI84u6KZhIo9VJC1sqr3OvOm/L3OeTu0NNLsXYj0g6tLcJfUEXIluuab2M+D/wXrtOD1eSaNW8MUkWk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by PH7PR10MB5748.namprd10.prod.outlook.com (2603:10b6:510:131::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:17:15 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:17:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 31/34] scsi: Fix sshdr use in scsi_cdl_enable
Date:   Tue,  5 Sep 2023 18:15:44 -0500
Message-Id: <20230905231547.83945-32-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0177.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::32) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|PH7PR10MB5748:EE_
X-MS-Office365-Filtering-Correlation-Id: 064bfa0b-dea8-464a-2af4-08dbae662c96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: htm41k7O2avbDrWoAobBYOb8ESWV3Ca+4rvwnKcoTAX+sOoDa9ybyQ8+eWQj2Nibkic9Vm7KLW2uB4UvBXeEmpxqKyjT80Yf6Gyktl9mOQArtdyRQs9np2nwIacVeaep1uQ+ulhvtYNoCZY48zm0JUgG+KjtuYQosMLKxwUrznPxmDWtaDVWQeA4aVgkdCTjpE83Yuk0/M9RSHzd9AsXYgomhZQw+rOGFxY5c7pjVo2LR6ZkiN0T4MvfGM3yGgOpcZxf6s3OlbwRJgVbnq0pCksV7O0GhoZPQiK1apBq8jr5HOfab+EJOdQM1vuEaj9wjhqIStZfucQrhOwkErVfM6cixBjiE/TirP0pFnoLAL3QoxXZzzkl49I12dBwkrBhLeRy6Qze11pQO/CaWpo+LdtG3x1YKx87nPLV2C5xcxdGOz48iMySdtSD/0M6LRODllMmFm3lw8Be4wxF9Hz1rqN6whe3LOdraTWir5VekXnffiVVyZk0b2PNfoE3qz2Nkv7sapDtKVggm5ph/tFHXAfrRXSYN7/AQ78uJXp95mCRp6pqTp82ONw1DQ8Gk2g0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(346002)(136003)(376002)(186009)(451199024)(1800799009)(4744005)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(66556008)(316002)(66476007)(4326008)(8676002)(107886003)(66946007)(2616005)(8936002)(1076003)(6666004)(478600001)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?otLocO4Ww0bk8wusvsGuay4HYvclQwEvrLwGefnh1xgTdHemiZvjDwKD7x3L?=
 =?us-ascii?Q?tVBoIKvHla0D7dNyoseIEr6b1FecPPjSiMRHAU6+mmSCdCJmco7+AG4GbNWW?=
 =?us-ascii?Q?XQotybtUERJGn80gwXvP+ZsGi5Cz4e+ApFLj0Gcauu8ZWK44mLkRtdmPz+pB?=
 =?us-ascii?Q?QgNL39gAIbxpQpajL8G7hEEA+eLy4xEwF8YKhefczsNKb9pLXu5Hl9QI3N5T?=
 =?us-ascii?Q?JFOAj9CxwxYrarbRHxP2ZetCSHE3A+BtTw4IECXORlq0sCr1wAeJEzrzh8bC?=
 =?us-ascii?Q?RRQSGcdwk2E7ucOIwVyQTWExpnEz/TPeERL5RxN+xaW8Avtv+HdpOWC5+oVo?=
 =?us-ascii?Q?jm/D8yTgiL/oStXljBbMmeyxqckgIMjD1tA+12raEG8n81usJlX5CoEfDXIq?=
 =?us-ascii?Q?aHayuLpXl3MFE6fqL7uSQ+3sZAB+TZGtY1N6g9umcIUHUrV7gAdywmbDFZ21?=
 =?us-ascii?Q?nHK8X9Lltws1ae+OoxPx8T5Gg76Z/6iu8oQhjLx05PwZWP+fpAZwK0gjDrRx?=
 =?us-ascii?Q?7Z9j3C+WCiLfecosxvLquhNovHY4Ip0BoKGis0REnzD04F8j18tlUWEVZmxL?=
 =?us-ascii?Q?PNd1y8nd/tZb2mDLMXytFI3/xNuF0W2dLGaxYBi3Io+zg3KM2vP0fM7OdK/8?=
 =?us-ascii?Q?m2Gh8xbu6jdiAV3eXVlQPEgZ/Zs0H52jI7HIamsPkMMd/Y2wLAYu5b+dQb0l?=
 =?us-ascii?Q?YpAtvFUnG9kzwtulhoYGk1y/o2Bgd1DMTyju9sYmHsgzl+y77uu+CEh7MPC4?=
 =?us-ascii?Q?UzKyxT+WfmFa8/Bteg77kq/7qkjgaInRoYrXmi3F6ZtcY6AU0HCoqcXww6Oy?=
 =?us-ascii?Q?/LbRkxX3SgVMCZ/O3eZexXiL4mYlPnMfvBXtTjzePulTN7eCMwoCtnoOH+b7?=
 =?us-ascii?Q?ibHo4KVrrIqnIp1ouIK2Y+If4dNV7OXmsOSK53xug81hHms2ve1kuTazS4eI?=
 =?us-ascii?Q?vBWJmtteatqNC8KpfI1PyieoRvpeMuLN3BpvhqF2hITJG82C5cDgCIVLcXZq?=
 =?us-ascii?Q?8n0s1QN8haQLUB0430ZO/+Y3FMaYpsu/R/PEDWljZz06I/Le+vNeiPnmybjs?=
 =?us-ascii?Q?yXzNK31wkXW2Rld7P0Cmiiek6JXD8RwT9cojypSvw3M/qlPLwL2sYq1mTaZN?=
 =?us-ascii?Q?QM/1OMOXi1mM9Ii91LMLxquu2QCRuie9Hbo/AEpeNa4QFncWiZ+w8EdgEJE1?=
 =?us-ascii?Q?JP+bthMLWVg+1TNZ0HAeSnO+hpW8F+ijfRdQYd9QrfchuNX4v+fJ7EBbS6Pu?=
 =?us-ascii?Q?rPfUauwCOnw4dyRXPj/Sv6cNs/Qc6lb2b7DF7q1H/TTxzDOOG4ejb/YPzVFT?=
 =?us-ascii?Q?crqnDIwb2UPLl8X/B2F15rkb5gUCuEhliis44wfdVRrpA7pKQ3xhu8Ej5+Fl?=
 =?us-ascii?Q?7FGm7/twT3RNgedineOKsUw6lrc5V9VkV0URv7ITtKTSzU6ItbVlwwim4rSy?=
 =?us-ascii?Q?nUMo72C9ixfjVqtNj3EbNj0qVMT2GR17Tr9SdEYoD0lKo0EOdHQM+bpZHPwl?=
 =?us-ascii?Q?fmiSL/uIE4yIx5FiQh3G9ApEk18ICAtqPFJkl7+4saD8n62iizPx7t/FYXdi?=
 =?us-ascii?Q?naAM8pZZOiO+tdgiZdKcJz/DdRQpXMsxG9XKBcFjW+C/CllrLiS6NdYUal+r?=
 =?us-ascii?Q?nA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: M+kFYUpsb+D/7W/YAhB+ay6gzobtGdNu7RrID64iYvbo/nFgYRbLoIwPXxIfToYjTlEl7PSw+qjiAkYsk36P9+VXjKn4c1rBJgCsedWothgrI4e5grP/hTlcKqP7u9W2Jv6YSMDaHSzu+OBbbom1YLRiCpy8KBx4WWlXoAp+y7Toz7cJS9P3jqSJ3BthzdxTfJB+oIO30CESJRumAlsBO59cBptTZBO+TUj8FN8jbK69BtRYa2Y5Bt7aeRJYDcy11EGd7ykbH+ruylmzam1aplehM9tzkDtU1NSatwiK4kSXoM3bPXPKy2P3bhT3wbhQY3kF9Sfi2PLNiQ+pCrqLTEgkQVtrFcOn+HulhtZYTFBt3NZvFFS83BiRw7QiG3D3J4y3aopDSweo6r1CxeugPhjo8KJHgrwCa8h+Y1O2ZYZARMOchLMcmU1e5axnSb8zNg3j3kS0+7SK6+/5EesjeokmhZHTGWjq1lZO9hYO3/8Cy8W2IKVrrMsuW0t3G/IYMcO6PhGjZFH/QTPPB3+4vCZrtHQrTqol5cxphBP+eRE6Un2lEG2pwT80vb4rRKIEpIb+9yKWgkCMFex/0aKuPjOZOvV/t9OgU2cDiGhOqzPYHg1g8Iw0X6uc5MJdxnZwr4Pkp0VgCDd/dzpaxZutKjGH0WZYT3FF1SsoE6sx7KxwKgK8CeTsoZorkC3fh46sbAFufhA2bnuUe8OwGbnuzPTpvbpotzUVEX6vow37xOWGdl6Jb8ugc5kKB5TXUA/waGPhEQS1LecatGKVCaESLjsq3/g1371fg19384rjBzBj6n/33Hl4MXt6lY6SGA7ZGbgN7xcB9WHdBTR96NEwqL7Xz+Cveq3Py2ofFcpuMfq2AOazs9MHPQ64AHBmc+SQ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 064bfa0b-dea8-464a-2af4-08dbae662c96
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:46.2139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pvMbQEseOgMuQ+MEAf3KJ+OvLprlh4Ww8Bhk36pvahI5nI/JDYat0NfDAI1fjBUo9t5MykFQRQPYSfWrt3asUA+rVWTIlUF3aTvM6HYEKVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5748
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309050201
X-Proofpoint-GUID: RyzNzdKXTB7LcDSx1XmSSnm6gJ8lPOZ4
X-Proofpoint-ORIG-GUID: RyzNzdKXTB7LcDSx1XmSSnm6gJ8lPOZ4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when we get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index d0911bc28663..d1c0ba3ef1f5 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -692,7 +692,7 @@ int scsi_cdl_enable(struct scsi_device *sdev, bool enable)
 		ret = scsi_mode_select(sdev, 1, 0, buf_data, len, 5 * HZ, 3,
 				       &data, &sshdr);
 		if (ret) {
-			if (scsi_sense_valid(&sshdr))
+			if (ret > 0 && scsi_sense_valid(&sshdr))
 				scsi_print_sense_hdr(sdev,
 					dev_name(&sdev->sdev_gendev), &sshdr);
 			return ret;
-- 
2.34.1

