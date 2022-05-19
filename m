Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D98C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 00:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbiESAfk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 20:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232197AbiESAfg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 20:35:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA1DAEE2F
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 17:35:34 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IMIp1S027449;
        Thu, 19 May 2022 00:35:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=ZEL+3pR/443NwTvVEVQLHpAFT5+e/wWGoZYmoOARmjA=;
 b=p+BjYxsmpokXQ27nNJT0ct1PMtnXfXiF18p3JzyfGi+LnvqoHxp9OWvv9AxqpOYLvTNS
 9dK69QF3O9MehmdLVRh5KogtpVYZItuV4PGcT0BRLnuVPLeHid4VZWH+vSlZMzGcJOFo
 g9QQVbaQy+MWUNOtR74kUSBgOfipkQreVgb+AlAzzn63du0zmUkdLZgzen+9Z5NLcYEQ
 BZvQhx4s6g5JV5a+BtOmUWBZ4IRe3Xm6pyV3ipQjOHFKEwwcf2sD3x1Bp7Qe1dBT+fpN
 YjAI87odTBiqbGk8J6H9rflo5/pGU2P9jCPLABjMjEvmF+214AivJlCPnyZossUtNzv8 GQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241saut7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:27 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24J0U2SI020228;
        Thu, 19 May 2022 00:35:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22va9pcg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvHjJDkJF+8+0mHaPHUN1NtNeeoDo3+zAz2hEKPkTR0bNfkVfe6JhJGPA5H5n4MFSDApHJKoZUpk2im91vEWzHrgF2dd71RzzScaEQ965gO0T//u3EVJ1lVhVviLj/SPKZ2OuKVregBI3LxwE+5YmTYyefRbtTjBYmt4cGCeFEyQm2HjTtAnOgJC4blp2ccUPI2XYku7nBZ5su5/ofWbnLRI8p3OvsILpbgGXLS3goF8KuWKBVkx3Yp4t1lHnXSfteXPzeh4w7BWVN+G6DJP3GWJGSxG/bpvY4KovcP4DhE4qvIhSziN6Ff02WuZ7YX0ckNfpBTZjZAyGqXNeqERgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZEL+3pR/443NwTvVEVQLHpAFT5+e/wWGoZYmoOARmjA=;
 b=AUF30tKPIrsejhzfTvoqCLaoLRhcf8jCrWBICF761/XSk3O9ON7nbIZnEj6vihoueU/f2cvyCJESZyks73IfGzsMl8Z240DR/vNqOS9WykqitcKrSGcH1GyR+atHqlnUTtEEq/EOCpmb4gpse0G8slKRuqhoAEnQOldp05Udwbl2jg0wZ5ni9oL/PKR64mESkvYLXesd8UmoxwRZSkyPrfdNYqhdLICNAVnlbv/9qGoIxDfKG8yJ+zJyCc+yaYw6OwjalQbusHzB/ltOrXwBA3x1QVYAk4sga6YkrRxA+QDu259ntPKZcG+4WiOWsdqxqWwfhwnuF429NFhW0U+1uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZEL+3pR/443NwTvVEVQLHpAFT5+e/wWGoZYmoOARmjA=;
 b=SG+HKdByZMJpCUsIalf/8NF5w8LQ5a4zMxnn8Ghb3FS4oEYxj01jnSacQCVpBIXUR+jIgaPtYR0NPSFJIN7kb3mEItTGgFKqiFtFohKVoMDnx9vUpPn6qKmUgqkjGNrHl/rgQ12XaFgqTqKgpyW6xkEcuhaHBkfXu5JjK3uUEO4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3020.namprd10.prod.outlook.com (2603:10b6:5:67::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Thu, 19 May 2022 00:35:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Thu, 19 May 2022
 00:35:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V2 01/13] scsi: iscsi: Fix HW conn removal use after free
Date:   Wed, 18 May 2022 19:35:06 -0500
Message-Id: <20220519003518.34187-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519003518.34187-1-michael.christie@oracle.com>
References: <20220519003518.34187-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b78be213-0f61-4012-317f-08da392f7765
X-MS-TrafficTypeDiagnostic: DM6PR10MB3020:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB30202A24925A08391CB247A2F1D09@DM6PR10MB3020.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U5vD8UH/QZOI/OmkAoqtTvxbSYyOikMVYySsCvm7Azdxrb11rUYKal6741pa7XPctPmz6bB2fZhYNGl0wwL1Ft7gu9kWuxzMYLMJttLep038th70WWFR4awKYX6yhLGrPsaloBjdIr75noJI7fBCHwkIOeT8IioO54yNrNaKOtKff8Ez2tPkxKzh60Td51//GmQaYFXXKHWh96feVSSHVLVOUM6xP0T88ZqW5SY8CYCjNXutbVGVRi2Hj9FRriyybEkpNoIvuiU+fZWu4D41bth76yVvxFZQj7ee9fxa5Y70JnHI297bbMi3ejdNjtsIxP1oQtRigXFM+lXS+Yn9uq/iA8JmG24fNVmVbXW0xhjxPcZyyl5kvXY3uEMDd+f78TPk3RFRuP7BLJ5sv2Ohw0iOrFo/kvSQKsBQ0oitTumxmtxG2NUu5ilSTjNbypZINVLH3240natddLv3MBk1DAdNI4R49kj71EJcXN5ZHjZG0tuWI0RyYNNbWSargfh5uN1dZxg38fiDsfxv6obGPiOESMbKACPRAL761CEPKmZhqk+xVbGmnTExs8/Ue5ySL1VJ4rsxpksplv1XiTsTd9Y1W6cfQBQDyn4zLMzLZNhf+wlrdkCWVjWMoRzdxuqYIrvab1gIHDuef1jnIIUrvTFxTLSMtV6CgbrNtpiwVciFjuobWx4QPZ4+WcA3SExxVhOPmG1EILBMquhjzgPUZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(83380400001)(186003)(66556008)(1076003)(4744005)(52116002)(2616005)(2906002)(6512007)(36756003)(26005)(107886003)(8936002)(66476007)(38100700002)(86362001)(66946007)(5660300002)(8676002)(6666004)(38350700002)(4326008)(508600001)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?42u1gFcNggWtxzEAHi2G24k2ktszrygJKumyTOYpnRvcAKEjPtyZimU5aDf6?=
 =?us-ascii?Q?XGRvhQTWGGCT0o6sfmlJgrmz+X+UpzlOjPCt++ijXkbf7PYmmcnBrS8pYUPW?=
 =?us-ascii?Q?aVK6ECuZtcEWbGlhWBHkAGS2YgZTglhw2Xxs50xkunjUv436jtm7sQ2CFimA?=
 =?us-ascii?Q?AZN5e2NPr78l0D+cgg/ymZXDDy1WRBM2ho351/Ryz2em/TNuVn8NJI/bL8BE?=
 =?us-ascii?Q?rpkQ0pkn2nEIsCx9zadoRKqYiesgk3NRzk6FwuKOThn9y6aNDoRDD0P4ip3E?=
 =?us-ascii?Q?ZtAFnGg4fQdLHKx44FuPIu7KyvXdj+dld/FO7Q5xlkXHDHzBAln2mxK3Y0E4?=
 =?us-ascii?Q?NQMXrUy1lK9qEONnEOfnLY6guiK7Z4/b1/fgVX6iy8BE0FexXRh602cRNDvJ?=
 =?us-ascii?Q?pBCqHU/rd/Q8Vg09d2w9SvpRJxJgHlCfPqacayGqVjxfimxKi2stC2GNywqF?=
 =?us-ascii?Q?/vtVH8AHa9BY2IkbSuInNxQCtNeow2mGINvr25DTaFybpfa4sWjQJUELFZJq?=
 =?us-ascii?Q?2YB8TAVQThY4KjRcJFLP6REsx7Ig0lPg/uCBie/we0+m48cnl5U6Dk/rJHJQ?=
 =?us-ascii?Q?NBbquuSpv7Q/r3ueeAS0McXI5exTOiQgbuGLIYoV4v1bUe4JQ4c/5VL1Nk/6?=
 =?us-ascii?Q?J4F52AhZYstsnetcJzFjRBA84kZ/WPPBobouxt8hjfy0Cs7xrnjeYut9FLjM?=
 =?us-ascii?Q?/Pn4AhaFF/yTeMatzqSaR4/A1QDLGdwxxXJoKzeBSO/fLDdmQFiY3p2qO3sz?=
 =?us-ascii?Q?i+ym44y4zkXoJLGoS8/jTJLnOX/9bgDbNYOoYf5jQKyODkVEDxPKJc+SyFFq?=
 =?us-ascii?Q?0on3ENXIA3NFBebl5V18qM1zXaAJCtRKrow2t7uvDNUioGQZeSnFAz6w5+gG?=
 =?us-ascii?Q?MrdxORc4cPP1yi9Tou8WARHoHoyeGn+aCRXqwlRCpk9e899WdB8LVsPWvbWP?=
 =?us-ascii?Q?jkbWEm9FXHqlZTp889ekz9dmCVzoVhZQvmhMWbJsZRhjrhvXAA31CoH/+d6N?=
 =?us-ascii?Q?gCJbIi9+vaqbfP8FEWuJy1NQ54x5M0OxyfGLQjaikjraweS1kE5gbz53Pnfi?=
 =?us-ascii?Q?qk0f4meL4hBoQQkVxqc/KIOGizrmhknMTLEEwxkFr3VF6Ycej9NYOTf+Zduz?=
 =?us-ascii?Q?XMugl2ees2dHsrQyym5UbxtJF51AdkGzYChvutebkF6kQRYr6WMSKTnUqGjG?=
 =?us-ascii?Q?zK3q1LATmEZQII4e/4NBLhxIk/+RRVp4XbVJHVMExiVJQyXhs2Az+griy9yU?=
 =?us-ascii?Q?LVIFSL7yKxHyexKDG4v0D5Qk2iZyEWz/o8plJAUZZudoxq5k+07qiMBFo6se?=
 =?us-ascii?Q?LqzeekCVRpazqvStFqdh+dSAZQZBWIYMtL/E0cRKTCMNPRqBXXPwxQ3gcvRa?=
 =?us-ascii?Q?VpfGXIpxNnHb4t3Ql/GpmHtTr47esGK9mqS/MOl9l+R8YFVLJdJdwscMHYVt?=
 =?us-ascii?Q?QK7BUuprGpHsO8iLdTfqXCChjBQaoTWqmJoBZPLDTtFLmFd00AgQeeRWn6RI?=
 =?us-ascii?Q?WsEQx4ETr4nWpk3RSjQQN/ukqPIv86IlPwwYmwFTABrmAIMuqRBljUeu9Utg?=
 =?us-ascii?Q?IywET+oZchxh4x487rYEZ35d7IBjlPyv4VQ1qnTSHG1E0VT2TAw/i+hbqsOS?=
 =?us-ascii?Q?oWN7BQJBXeQcelGK4fURQYpF7N9nwenWrQzan7R86dYq2dOiWDqzp8XAtffu?=
 =?us-ascii?Q?0BX9m4N2mYryXIweeG0IIht4uNqy3Oh8gWtzV3NEVrms4Yr/hn54LccjRDm4?=
 =?us-ascii?Q?/Tw+nvyffoxFrv/kKPAtvovUTvAA0Zc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b78be213-0f61-4012-317f-08da392f7765
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 00:35:25.6806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lax7YkRnMfP4Bvejfl3gSBDI7HWkdk4j9cjDm0Ox18Jc1wz0SOjOBswNmiSIC0HPaHQrsjl3SZaOsvWzjfQQBILAN2yt+yUIPg5w13bwm9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3020
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_06:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205190002
X-Proofpoint-GUID: MZbN2t4orqvZUQf1DoyktudmXyy1R2Wl
X-Proofpoint-ORIG-GUID: MZbN2t4orqvZUQf1DoyktudmXyy1R2Wl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If qla4xxx doesn't remove the connection before the session the iscsi
class tries to remove the connection for it. We were doing a
iscsi_put_conn in the iter function which is not needed and will result in
a use after free because iscsi_remove_conn will free the connection.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2c0dd64159b0..e6084e158cc0 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2138,8 +2138,6 @@ static int iscsi_iter_destroy_conn_fn(struct device *dev, void *data)
 		return 0;
 
 	iscsi_remove_conn(iscsi_dev_to_conn(dev));
-	iscsi_put_conn(iscsi_dev_to_conn(dev));
-
 	return 0;
 }
 
-- 
2.25.1

