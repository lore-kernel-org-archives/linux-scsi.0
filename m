Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B41C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jun 2022 06:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243496AbiFVGWP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jun 2022 02:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235466AbiFVGWO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2022 02:22:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343F92F38D;
        Tue, 21 Jun 2022 23:22:14 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25M0IsDK024740;
        Wed, 22 Jun 2022 06:22:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=UxmdorShGjHdQbvIISEWxKjBXUnLPYYtKPZb/v7tNAg=;
 b=VS0klLnYOxhxsNKhNKhitiyxc5NrkX8SBTuD8j5opK8erRowWqDqFtcUrgESPYJzpXy4
 bj5GfrIob4Z9Pr5DkZ7RJpcGiUlZUFR8xwcrA5PsXuiLUnTPc7W4qUGlrz+YxvDBfrck
 iRp5IC3yJ/utiH8bNYjsFYCZ3s/N1ZNU5MwONOeNbOuCPOQYQMYL4+83RK4vC1Qkwz2J
 oqzUZRfC9pMF+EEZsvUeg86njBKNKU+dzr6XsQtnji1VDbzvZoPwfjomYLXhQErwj1eF
 VhZ+i+w8qm504lVia/I6gxOojF4y77c4pKjI9HYPmaNNVLBxrJFM1qyXh/wM8QAKRxkT Vg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs5g1yjqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 06:22:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25M6KcXq001804;
        Wed, 22 Jun 2022 06:22:08 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gtg3w0ry2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 06:22:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gd1ff7q4L+oTM3HB4i5+2Nu0HzUJMYEZ3ixmtVa020fKkBKArjI/lO/wBP2JGxxmMhVrjyuaOhrBikaungHYqVTY0cbxZoO6SX7buJ86T9CWs9h6B+s6TJCcrF/HbOB/2LAXdB/8rIPcV/Nmrkp4Xs55f114SugdBBcPmzNMr00pRYtzog00ejjoY6hgvNxuHQ1QR4FDwAvUlnUz/x32d0KFcewEGPdrAogWG3k15E5ju+4vQezpn0I8cQczidkJPD0/2/1TZKf9doi+WK2c9K1RyeAo9X83AJ8K1PIV1boDR0j5QQbjvv5k+Pn4pNcVc8mea9GoEYXnOKH8CEaH2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UxmdorShGjHdQbvIISEWxKjBXUnLPYYtKPZb/v7tNAg=;
 b=OnZouSk1S5QNCgbXA22w9krqfsbOovZlLb8bRXjOx7sW18dW6llUGtI/hRztTbiBvfUdkZkY9n8NbtF+GuoGYSbfxMf25JAvRj/k3OmOrvVmOkGMi79cTjSniGJqth4hQ6x9t5TI3p1rZc2XC+fYuKrJp2GGLSIGiifeVqs+WwUWfk49tODpwyzAg4mzsGkEBnUCgi0ngEYdw/+4Uu0NKUH61h9vsYGt1tv+HJL/pHplXTY3pGvdF4BDvR+TADcJfY4LDvcr24gUpaCGhFhX6itzIO+M/n09FeZxt7Iov7oQ9LEm61hnCX+364XYQ1EthRFbIx6QSwF3qNkHI5dT3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UxmdorShGjHdQbvIISEWxKjBXUnLPYYtKPZb/v7tNAg=;
 b=A9t9OtVSA9L9+dUneubYAsYflhweW5ObWFeNwJMJm4yCLD8xN8blzDNM1fmDZ8Neqv8U7dxuLWGgDpOR8kQYgO+SKMSjeCEMVZz/L4xaCn6BW311FapuFoYAQr5NOoeEzQ5tBxa6tTrd+FiPgsRQnucOhLmJDL8rRM6irvlyPfM=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CY4PR10MB1349.namprd10.prod.outlook.com
 (2603:10b6:903:2a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.19; Wed, 22 Jun
 2022 06:22:06 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5373.015; Wed, 22 Jun 2022
 06:22:06 +0000
Date:   Wed, 22 Jun 2022 09:21:55 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Quinn Tran <qutran@marvell.com>
Cc:     GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH v2] scsi: qla2xxx: scsi: qla2xxx: check correct variable in
 qla24xx_async_gffid()
Message-ID: <YrK1A/t3L6HKnswO@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1h74djxoj.fsf@ca-mkp.ca.oracle.com>
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0157.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::22) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9c4dbb5-71b2-415e-07cd-08da54178792
X-MS-TrafficTypeDiagnostic: CY4PR10MB1349:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB134958E4F32D73B74FBADCCF8EB29@CY4PR10MB1349.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z8xs6h9YiyDkBv/l2owACSzuIaemBai8VW2Svnv/dJB5QyIG7v/YSstHU9UfatuV+K8CP4BHxgzKy+K4PkD2A6jJRYa2SgqmXLalk271Ep+tUVw+YzmpA3SwzlEViGYg2lw+R1PKnoBgKyjTJ/g3IpJHqt0inObtx2q+cT+5I2qniqAyaabcYchP5yF5jkVWjjzkw152rEVp0rOlLCGWWNtRx67PjPsV1VAUxhsxS99IL+zgho4kJQH/5N1qmfmLdnVkv76x3WGRxsi9klYe7EgHB0GBM+GvrLAf2ZOeuamyi+dsfnhqT3TK+qVJRYblm5IzQV5qHtdV58601eVNZZlUUPXAaY+Mfu2poKbVTck5n7w2JH+3B0Bvpmqvcko8M2f1R4DnIszDGmT7FYhEsx7Cbex4HFDcbzFt7ufSSlHb44/4f12l9o/4S+c0bgBlWf7vZHmLPpXzEJY+23nF/yLdiqfu/KrFyvWDRr8g6ImLFsyYHkvGvBPq+H8YLDUUd20GN4kVKAocojhwqEcPG6EIsugXVOVmgZbhYkFs0fz7qaIvdrowFhJBR4oBeqi1kNfFRuUU9iTRBrABEfEp7OmkXf9Wt/XZZDrS9hO388BIxPDqu0nOLcRp8BDZOjcnjD78cSuGDfsgeEzYsYOLhIenwQyy6eZ0pPQiF7ChAL52lcF/4wVvCekI/u7rU/F3aJhEB/ctxEi2vaZtDZw/vBdRknFCFBZ1ztU4Q7X2OVclEXyx6C5YFwKVtt2FQK6xcnBX53NPGmeCFOjflNAaLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(136003)(346002)(396003)(39860400002)(376002)(2906002)(66946007)(6506007)(8936002)(5660300002)(33716001)(9686003)(6486002)(478600001)(110136005)(316002)(52116002)(66556008)(41300700001)(44832011)(83380400001)(86362001)(8676002)(38100700002)(4326008)(38350700002)(6512007)(66476007)(6666004)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5czTVVN2V7QtZH/3B3gT0YQMUV3QXGSmb76hrEXurB951Af8d8TVs4rhVdAe?=
 =?us-ascii?Q?1DtiR2Ew4KaaluDcnSA6OFmdbJlPeAj0EOFvm80RQIAF8TJSu11B4rq/KGqU?=
 =?us-ascii?Q?+CZ2R0EyP22qofj80PJ3gmQSs87z/rb/E3trOrG9c6bhjjOPoSzm9pRAKjZl?=
 =?us-ascii?Q?he9jqQWmlVsnmFFl/k2jOMETM9InYyllU+4ioqA240lM7mc+Jz2XfvOAWP3Q?=
 =?us-ascii?Q?iBOaMaYFGGNfBK/IovkwlcvOMEiaY6BEKnUWWxN2JtL5pVhDAPgoQbI+faS1?=
 =?us-ascii?Q?EwmQxdOj5vsDAq7ybIB8V80AWlOeWY4HsXlyqDzrFDeoJ4ZtmqZGjqclnYqa?=
 =?us-ascii?Q?+a5t5lVxS7Pz/DPtqXdfhNyK7lpICiuRS/v4105bV7hw0l/k3522P/jGEEYf?=
 =?us-ascii?Q?o1Dn1jqEfAi4fpO9BqktEtE+evJ1APVwX54vRgwiNC+EwH7PwFif60u3Lu/r?=
 =?us-ascii?Q?kIULqiTRgh/oMZZLWNrfULSWqBmXUNKoqcew1GharoxlnRUNqPUcqDUT9lhE?=
 =?us-ascii?Q?k7arsREAtUBQle7ce+MgSw/EHYl1KUPCZgVVu9xzI6+/UbMQe7CPw+RRr8sV?=
 =?us-ascii?Q?Hywq5KFllhB7OMZGnaXyd9XaUSN+giYgx+B7ALQl8xLjEsfSVgV0vCVO1kDa?=
 =?us-ascii?Q?3AhoUWVr8OxpJacB3QLNrXgH8nE70Qf2mY+brJfs18KSyKxqj8ZnQPNm82fO?=
 =?us-ascii?Q?W3IQpaaZrwjzFzQAtaRhUoaUYg9aeXcNQOReAz6LSLK9yWSHsQFlpfILVMQC?=
 =?us-ascii?Q?iOCva6KlETyXborboeKhX++8bfg3idsfzbE1KGbL2QLzu1O+3IYIfE6cFmdD?=
 =?us-ascii?Q?+Y6kPA/v+pgRYBcb26azD92tzEEFj8PX0d7btu6Ui1SYWiOvkReXtQpo59t9?=
 =?us-ascii?Q?DKJw4V12WoRwFTHAOZq/4tyufYSD+IwNbzFUaoiSCxzdwUKo4MyTxVXfsZs0?=
 =?us-ascii?Q?ioa/DaRlD/aI1oeAHR9KR5E1Idm+SRaMt9B8gxpL2Ga+yxicsYmK5w66krLY?=
 =?us-ascii?Q?iuN7GPWCK3f6TCjupvOtegAGZQ+W3OWqAT3He2R58IjHMOsX6AJD/ieZv68i?=
 =?us-ascii?Q?EJP6nJYGyYXrTN6/3Np16IgN8OuTNHYee49sL8HbJUDbUrm0nYn9+jEW4eo2?=
 =?us-ascii?Q?10+VBGadMhwd7xNCpCmnLIncyj1j0oPWzaZXCp7C+Rv7kgiFrXaD5RkY/4cy?=
 =?us-ascii?Q?lnVcAlBOOvyKoQXwUZ1pmNMEkXPkzWJs4kv1YFeBtKftVKvLi524XvGDom/G?=
 =?us-ascii?Q?J2p7o1o+ne15ZpwhcjghlbNKYGfSMpBklM6uhwDZx/E3rq/yk7p5Te1OEAP3?=
 =?us-ascii?Q?PPMRxYXIhcuZW+YgmxVvHjaMFEOoZyLQS4htxdirJXzToFsnnrWuuYqjAHMp?=
 =?us-ascii?Q?Dia2rvDenwWxT5VEqTUtxYbm1N2WAKKZZL8NL48Uz4BptQPfhko6zMahu7/b?=
 =?us-ascii?Q?0NzUX+3LA/jWuWRAkxGeUUxoOYcu69pRvJdNBVObrCGe7otCCE0IocLu+ABk?=
 =?us-ascii?Q?HTLf/X2YXYqg6qXe0vvRnsOMYNHEDSeL37lbgpI3B3FNsswO+e7h+5q3kBaH?=
 =?us-ascii?Q?E/jEwP50iGqC9CICflBy7au46yECCql72s8FCVIyhPWaGPxSW1CuaJA2tg9C?=
 =?us-ascii?Q?sBkRiMWc1Do4KW8rAscj/d/mw+aq4pKsbnFuIs2Aa9mfKd6NvgxOqHTgHV+c?=
 =?us-ascii?Q?Jmx0on8rVspay5OqGenOCEtI1BEPPxIm+lFrMtjYW4/2DmRBTh6nQUOnuS/4?=
 =?us-ascii?Q?ELniqVtPXXmD+zpRdZUxfgQQbLPa8ak=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9c4dbb5-71b2-415e-07cd-08da54178792
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 06:22:06.4790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j5t5R4Vn8bg5eyQuFdc9h2LfA74WZjeR9V95eq/B+sAilhSj6FzlwZT9jQ0ySle9avQsqfuhpg5cFhiwKZiDQrqyTiu+qVywQ4xXKSySsR4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1349
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-21_11:2022-06-21,2022-06-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206220032
X-Proofpoint-GUID: WwoJphGwmlv-HJbGbqI0Sz1dAo4pgfLN
X-Proofpoint-ORIG-GUID: WwoJphGwmlv-HJbGbqI0Sz1dAo4pgfLN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is a copy and paste bug here.  It should check ".rsp" instead of
".req".  The error message is copy and pasted as well so update that too.

Fixes: 9c40c36e75ff ("scsi: qla2xxx: edif: Reduce Initiator-Initiator thrashing")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Update the error message as well

 drivers/scsi/qla2xxx/qla_gs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 68fb91ef380a..dff06a3255d6 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3389,9 +3389,9 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport, bool wait)
 				sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
 				&sp->u.iocb_cmd.u.ctarg.rsp_dma,
 	    GFP_KERNEL);
-	if (!sp->u.iocb_cmd.u.ctarg.req) {
+	if (!sp->u.iocb_cmd.u.ctarg.rsp) {
 		ql_log(ql_log_warn, vha, 0xd041,
-		       "%s: Failed to allocate ct_sns request.\n",
+		       "%s: Failed to allocate ct_sns response.\n",
 		       __func__);
 		goto done_free_sp;
 	}
-- 
2.35.1

