Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E76BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 22:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbiEQW0a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 18:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiEQWZr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 18:25:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BD552E58
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2022 15:25:17 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKiI9n031641;
        Tue, 17 May 2022 22:25:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=zNDMzd3ozPBbhQxOijWZaIue71pL6z1s07tA7W3XdYc=;
 b=biO2GVIpwJuXtO+0fHwXwKiGZkyGoz1jEL6wXUNu0mwZyqjia3m2ky/b4nTlW1RS/Qj4
 99QQ8Zava00dYr0jw2Dcm7KzcEgg01OygnXn7u1M512+DsmdM2QamT5VMLKnyQXe8f9T
 34g+pJceWM6J/p9cz14kL6Q+XMgSkKt+CZR53tIbdWaabxeUJH+S39+lCfga5A+wlnjD
 LyeXBidRmklq98XXhUz6046Lj8qks7dNvtZ8SQK6fuGIlulmSf91w5TbDE/n4YBH/qoC
 M6wuLRbOZ1TjunCg+jevbAZBW4G8x+4zT3URk7leU65gQWJJYGpEx/Ultl4v/M5fkQrK SQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aafjgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24HMP12F008394;
        Tue, 17 May 2022 22:25:03 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v3m138-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YDPcNjS54UGk0LUN0JREE38TP39yn4F7fjBY2kxHW95/OLe07PTyXOF3XOsX46VuLHXZjx3Ah1MdM03y7TPGfAL1XvuhwAvjlVjzc0qS6BzTf0Aa/Kn4QS8JLy+vwP/cVS9FVxusDEYK92JrXOipM1Zjg9z4/xtBX+/WCux7JNAr+mk9UJkXw7Wq1cl98/X6KJ5l0lxFiiSnIqru7VmW3pR3+RbE2Ts/Sw1kZrbo1w3tnmTpCEAzHupbJlHSrleEOiwvIPCnTW+xGhZ8ddw2iI2eLI4KpcTCAcpeMApN2SZD/3s11gBmG8mwu1Q8l1lYezXl/C/uZ4L8RN7PGRbl9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zNDMzd3ozPBbhQxOijWZaIue71pL6z1s07tA7W3XdYc=;
 b=HjURH2VLmRbtRz/an6/VpN/usm038wZJ2FJx55uWGrabEf0nTomOJa7j52RS5NgUxwsrMl8ugtXl/rrbHYU7+c0HuF0Wgxa1xa+41YuviPpe3n1aHr7rTD3JBhnEAG8Q1L84jIr0+9JYVI7/pITjpSC4lCxestCdGy1pz9HsxWeJjauF2ph+8yHTwd0NyQT2kkhR2SZflOILKc+zqj1e/hyfjRREZx5sIX88P3SuIfj4E+dKmkVgTmkcjHKC8TuBCh46JXzB07CF/J+qoKzZTiGVMlfqjPDidyHdS4AZTh7zv+T9hcz1zsZZsW42IMaRldo7puvoNZ7RoGqhz/FS8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNDMzd3ozPBbhQxOijWZaIue71pL6z1s07tA7W3XdYc=;
 b=TDDPDKsq/0QytIqJaE+EzlqEMyLD/BLUi2LKDrrW8dDGsak7FZvzyPPB5Tu9kEL7/xj80t5h021yQq5Bg7onjObXkHGmqbxrYGalULRnNhZaohSD+EYaIkFhFZJWaGxGYEK/eFshFiTM82cPf9CdV0n6MHMCAIAuNPIrtmwNAWc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5517.namprd10.prod.outlook.com (2603:10b6:a03:3e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 22:25:01 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 22:25:01 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Wu Bo <wubo40@huawei.com>
Subject: [PATCH 09/13] scsi: iscsi_tcp: Drop target_alloc use
Date:   Tue, 17 May 2022 17:24:44 -0500
Message-Id: <20220517222448.25612-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220517222448.25612-1-michael.christie@oracle.com>
References: <20220517222448.25612-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0078.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c4fdd90-3fb1-4bd0-ce0e-08da38541495
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5517:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5517404D4463A4C137507F65F1CE9@SJ0PR10MB5517.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pfPAXcu/4wmVBdqYfM8Ux/b2De+fI0im7Cja9H67xy2RLnzA36OxwMMMgWnR7lw7y8SCMeKWvsPEo+7t1JfWdidFYPcYHP7T3GqIwSBWTN9w0Sb4UdSQUuXbVByxKhU12TT59Xx5/Te16HX10PXC8vwrQRry6J3QXVUgb+4DlGtOaitlhpzCWVv931NxKfXqJhQpX5dwuVenQbY5GwUQpvmVP6ueZqd1CBK60i0WXKthuTZw1oUd4d2epbG6M2qV7lZKSSkNC25JJ/2VXL49FsntRlG+PuJRElGp2nLSQXSbMr/pTkgjrDqD5kBkyFazdTXO8HfLxRVXUA5LIexksPQVV5W9K1ABqHAfFru0OgJMc9J4KgMbqFSWuxqeMhejpFt9yeg7EaMGpMuNzVr60TTOhBbaRn4dC9k0ch7fBWy7RTmgsHZOgN5nJJHuHvS1yHIBZG0LaZ+fkbDVC0Z9ZNE5PX0KOB0h1GmI+RiSzyhAu+4F+SN1PBxfnHjqvWllAU0wnlYspBnDantRHjS6wfAbFZtL6H402GnfclPctynzw9ju/x2ah67Jfs6CWnmGoC6H2TM6LFwwae9sBgMbdkA0D1kd7SBDDCT1gzXn7KLdXbcPb3JtXqj707/5wpxbQyEeQTvNyvJuWA4nKf97kN3gzIDWPephDjneatgStxTkdjMpHHjTmsSQheS0wHKQqHyx3ZNzKbdLR6FozV7OSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66946007)(66556008)(4744005)(66476007)(2616005)(8676002)(2906002)(26005)(6512007)(6506007)(54906003)(1076003)(316002)(6486002)(186003)(83380400001)(8936002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(5660300002)(36756003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?raRJZZ2J7xvyqjcKz/4E2hnTPp46kbod5jElk4LPIgTcDRyKFYtBb2zB2wsC?=
 =?us-ascii?Q?ch6kKn9JdlnPJrLIZps0ojVrayE/baQEXCFGUcEwtqOQnphycbH6hj6Rm5UC?=
 =?us-ascii?Q?tbTlxPiwR74G3r/gtrCoSkjgRkuthFepVN/4MJB0RiAgQkzr1+DnggY4ilGC?=
 =?us-ascii?Q?Ao4icn0qUsjBObMiUf0gIoI67CgO5Y0AbdLWBIwNKDr0ie8St5RsEClF8B1J?=
 =?us-ascii?Q?Zvv2eGs321QMMdMBxdnHEKwQLtpzHd1y9+VShigmhypuJrNPdnKAEJLF+0kF?=
 =?us-ascii?Q?I4hDHIzZlHh5CIBA0CFwG7AgGknCYTk8M2Dh2OWokovBG1hBrVNImjxIXVfh?=
 =?us-ascii?Q?oU+rBBm1ABUGLNwhHgMgE+R8Q7j9FO2+WZTCT2dbbmhhjq11UZxS0qktK8ec?=
 =?us-ascii?Q?37zvAb9varjzMWqwsn052LAW29ZDKZF86gANpWeUbV72oB51tcI1puEMZ2kk?=
 =?us-ascii?Q?FXevQRjQaeuWJ19QXscR2CUUq5e6noViYBxZvmmcgKe6MqAow8Nr01BLhg2F?=
 =?us-ascii?Q?NT6zH4SRkmVTq5s343k1qG9IUoZtkCIvK0N5ui7d5rBxxwlzVaadtd05O56D?=
 =?us-ascii?Q?GpPqNzvf1f2JSEXiAPMQEQSI8sWStGR3lK7B8prTiL1poBdeVB8MHdR6+FdE?=
 =?us-ascii?Q?N3EGgt74Fztn3+2H+3l9s+JMxrHVL5jzqO9HJ51I492UfbztTb3GJveKoxKD?=
 =?us-ascii?Q?DZPcDkvYC0vbQeaH4ZIuoXDly8TUwjr29iFexrXhjNuzWBER0eY/2SeEr1iR?=
 =?us-ascii?Q?2DG0i/fzvFlfNpgcURJUk8Qf2pCt1Rk2zSxxaWuHqXqiOqcYT04dt1auZrwj?=
 =?us-ascii?Q?I2wO6LkMWFcP+zC2t44S3Q4XD2MpnkjDlvnO/xLOd+Kto5ynvU9Q+96bAMlY?=
 =?us-ascii?Q?qp9H5OW6AWeheGBIk/t+PcUBNAlfiKVQdoSt4kmb7lebW8PHy2gCpGuCnFJU?=
 =?us-ascii?Q?snVYXAERzhTzZ58v9d6UueLA9Z4buOjYb3J4R0uG6zzW1nCRtqlMW6i+0vjj?=
 =?us-ascii?Q?Yof8RrDVA/DkgspLvvSuvUJH0RgCG2vYKneUF7Dx4hV8k4yRY7luzt9w6Qjn?=
 =?us-ascii?Q?Favg9WGz+dH5OTJqsYAZgTJcvsbh/bl0ySGdpDPJrQ62UieNGJuuzO8wOtQb?=
 =?us-ascii?Q?4u+xLJL6hgOer5/gAUCWjoc9mUN65xWfImyCREIp4Vh0DQxmwT0rcxSKwDa1?=
 =?us-ascii?Q?6+rbpXaeZDge0MnMOcALXJr9UUoAFtC5tCy/KHOo7ne4kll1t3nAjBkiERY4?=
 =?us-ascii?Q?mLT0lwsEzw+IbMaXNLK+ARwLCtjfUvXNocdeyU+d5eYigIb4Sc6HC0Z8nuDF?=
 =?us-ascii?Q?+G5o3bmymlmJKOlK+HLzzzgej2VF55FnOuxhsuJab+P3ZFHnMD7EHgZ/O+3j?=
 =?us-ascii?Q?z5QfbEYYuU6lxHUTXMjGIt4rq/Ju1ytXFTO6AoCKXkCXTeaVZKFH3lH6QBb3?=
 =?us-ascii?Q?uxNhsxJ0Juqc5FPUSX5QRn67AVmSjx/kmmFO+qqbM/V/ciBtfMe3J7ZIu+O7?=
 =?us-ascii?Q?FLLmORY8Mhkpr9rqWX4UKtimos4h/falG6a7eFzpnCDgasFIi7eJfoFsTmdB?=
 =?us-ascii?Q?c4s2dEpK/X1+qB2/vK3tc70BBrFxIlU/p/nCyjrh6jslAkGhsKI60JYJgZEM?=
 =?us-ascii?Q?iM5pZiO2emfhskDg9BoBniShGzrHhZXSiB9pJd9jj4ErkvfV++PL+7GvZ3uQ?=
 =?us-ascii?Q?8L6bxJd5HwbVMaLr3Uq0Sgv2qr7jM1BU8hePDT6I3Jvzz/CrbBQ2i7L2oFNn?=
 =?us-ascii?Q?v5PDNcj+2yMHjs20p1ODKRG5S/AMOuY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c4fdd90-3fb1-4bd0-ce0e-08da38541495
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 22:25:00.1679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wvF9Ixc5yos5jLE1q1WxMfIXnP2MvqmYsKgAUceZ8xYzuxxRvb5zLqPh5O1qVSngdoIvh44fxOQ2Ncin7A3tZ+jgjZvRw71hqsKDghCDqqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5517
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170130
X-Proofpoint-ORIG-GUID: cOXDFbC7hjMx4S38-MfLMyjZV1wGiou8
X-Proofpoint-GUID: cOXDFbC7hjMx4S38-MfLMyjZV1wGiou8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For software iscsi, we do a session per host so there is no need to set
the target's can_queue since its the same as the host one. It just results
in extra atomic checks in the main IO path.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Wu Bo <wubo40@huawei.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 5e3b59ecf5b0..29b1bd755afe 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1042,7 +1042,6 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.eh_target_reset_handler = iscsi_eh_recover_target,
 	.dma_boundary		= PAGE_SIZE - 1,
 	.slave_configure        = iscsi_sw_tcp_slave_configure,
-	.target_alloc		= iscsi_target_alloc,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
 	.track_queue_depth	= 1,
-- 
2.25.1

