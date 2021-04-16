Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB95C43461
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04CC561158
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238061AbhDPCFp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:05:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36186 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238033AbhDPCFb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:05:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G1xgt1166461;
        Fri, 16 Apr 2021 02:05:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=I1Oe2AWVorcjAuB+4EZUsQ+4mDqnLURyB8JF+FnjzEU=;
 b=Wp0TJvpyLakoWug51lflJ6e/f4Z3hMMtn6gojsOPvwoqLhV3RO15qo068+fuUutRsYyd
 Z9ZnQsNOHgJgnX7DBo0TSo2AtvQVfhLTsyEYm0M0Ly/TGkIA/+a9X0aHHDsOKqugen02
 DM+Q2wZxJR24sAFuadw3dYQLak3/l3tbUrO7NZg66OEP8YtHTZGZUk4kkznW2hgSxaqV
 ZVPj0LtmbWXHZk6qTX1u6r3YWUOIv1e0B/N4K3ffOl6Rxgygc81pEpQ7YcLMhiokoXgw
 idlYHAJzkgcvPJ4pxArGLk1fRIBxeyIbD862OsWmMmVYXVqKGNphL4b6ceKgC0boMwYY +w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37u4nnqmfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:05:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G1xoQu008624;
        Fri, 16 Apr 2021 02:05:00 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by aserp3020.oracle.com with ESMTP id 37unx3snyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:04:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIPL3fUj5UY5YV+PSko3d89bK96BhUXY8Kb3bNujCmDeOjv6UZ5WcpHa7m1qIFhBPfdROCCJA6lRWdd0yCnCurxX9/btdBDUss5IW7QiW92qrJQ6J6h1s3t3QGiNKjlWchdQW2LPRj1oKP0d/fKQ6lg1eobMl4oIanGC5sq1dGNJjxheDRx4jCuhaBeRuC0JrMArbGFoN0/MvuOcfNGrpfpIBB1S+58zyb7tCcuWTMAmpMACQ8qJg589tkiZr9cUcxEgji4tyEL8xILPXjAyW4K+tGopRNpDFCF5b3HEExHn9tcfUlnRLHJg/gZbb+wAmgT8YZj/BHnOq6088lsiog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1Oe2AWVorcjAuB+4EZUsQ+4mDqnLURyB8JF+FnjzEU=;
 b=FT1M53PWmcOKBVrcRXRT7JNRHEg3PZGxP2K/C3AJyFCRYIdXUIfdlK9sPhm0t54uz39wGgfLFI6bnirG07WkIw5ZA7icohGZfZ1GtAY4AXMPahisiU9nSto8+Gut5xmxWUKEFQamzWg87doJQDnTORO3ztycj/xGJ2DjOxoLmqWwtKuTWVG8ID4JD7ny0RRddQwNqE+aqbypD1z2582zTkXLDXzxm749R4tb2z7LYYF/bU9vDYCvDUkIc6mW5LFNbrwYq6MZ4SKr3oSSbre8xdBNKdX5KI0inBLZ6HQCuem0YoUL7TMYjWiUXNzpgXysTvAZmWJSLQ28ub7QqYo8EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1Oe2AWVorcjAuB+4EZUsQ+4mDqnLURyB8JF+FnjzEU=;
 b=KizBX0Drs1+Ga9TdTXRsXpE3VxkGF25FDkacPcN0bZiHTLWEpVz6FF7vmM8nXCMxatgKLOv0fdrfXhyyEXT8OOx6F0xl+TabMSGo82+uW1voKJgE/xHbgqM2ektUdSF/BJuHS0J5HwdVoETBDb38xOJt5nTyFwBYoV2qEQOT+jk=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2421.namprd10.prod.outlook.com (2603:10b6:a02:b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Fri, 16 Apr
 2021 02:04:58 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 02:04:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 08/17] scsi: qedi: fix null ref during abort handling
Date:   Thu, 15 Apr 2021 21:04:31 -0500
Message-Id: <20210416020440.259271-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416020440.259271-1-michael.christie@oracle.com>
References: <20210416020440.259271-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR02CA0100.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::41) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:04:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3619bab1-80d0-4d66-1856-08d9007c090a
X-MS-TrafficTypeDiagnostic: BYAPR10MB2421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB24215E7784E4977C7CF6F9D5F14C9@BYAPR10MB2421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rLp8tW5IUyfM/c8EjQ0zp90hfsU4rP88ZcK0sPWevUBHw5K+WHRk6hDpahqlW8D1l09y6dMUEv6e/4dQe74Z6dCupKywCX4T9myB7MeOnqe+h6gjkkyq8i4QAP7zpTIKB7R9tBlkHeSvcwK6bMb0GSAf41BeUSOVUfWokZDTxzgfCttTAc7FxOg86tKnJBcrVjm2M7MDemi8rAAg0qzac2mJEAQdatW6KW4Ad5fB3sPIPJPC4PbbM0ypM9FXFFFdGgxO9aqx7/QvgY5CoCW7oFyjuQ8fTNxyUkMCTWHzQowxsLkXDnUO+2BwIRFZl/6tCWDFWNp3YthgyMBuDaDgiOs2aPnjf+Nkig8NDD6mKbIGBBThip0tN+v/n9+wdHa3rgY4h3I1oT2b2VsFEr8z0Up8CLOzhnTlWbDbr7mFGrAJFKyaFO0W0Okyrao3cdhiXYfs5URhV6pt1zt3QYZehA/o7vpkQMZONrtib3ZYdh8temspHSB+MyHr+CuWUtBHuiJQSYoxV4cx06SPHXIby9NOb9yQl0lLwecbHYVpvnIaBXBXjpIOnZ/tgCNcIWm4Itq50uF81Y+Q/W0M+DM7nUFz6ej+VTuoUfspIJbbHhojOKCFm5LO8JAaRHjRIU+61ye/XRYtaCQ+etVIJ+VZP/DAJx7SpsGtGvV1dxYKCkiAsL0H3O0lUj6wa+BznQXE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(186003)(69590400012)(16526019)(5660300002)(1076003)(6666004)(4744005)(36756003)(26005)(107886003)(83380400001)(4326008)(52116002)(2906002)(6486002)(2616005)(6512007)(956004)(8936002)(8676002)(316002)(478600001)(66556008)(38350700002)(66476007)(6506007)(38100700002)(86362001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?AxTk6WrRW/wCdFhDd/uN2G/d9LMG9ZxNvcI1Vz/PrWffGXfviUhVjHfVc5bL?=
 =?us-ascii?Q?MXOi6vn5dr+Q8PqZ2amvPrqmLf7iAzxqGp57uNlkw5JmRpeUF8czA30nKPcM?=
 =?us-ascii?Q?s4KEAaIXKBgFKrxollRkLWzEe6B4WuM8p0ZHReqsAEx7wxasDSMvSLXOZ/cl?=
 =?us-ascii?Q?/+tdts6+XQdbg6sClLjW1Swel6c9yzY8JaOn9iVynlp9OtWq7+7dtwR5+Efh?=
 =?us-ascii?Q?mR04hsJ1s0XF+Q2DBflAv8/+PYyKZGJuB3XEyNWMPXpKwI27y3WcE3HkZ/JK?=
 =?us-ascii?Q?H/xiMDD0f9lNm5UOHm0fR9IS9MuMB6qdt5/Jw16qANQe46SP+Bw/Cwcdo4Zr?=
 =?us-ascii?Q?vAfILQbitjyugeEg+duhfosQgXzNaHKNXwRQwGgPy0dnwEFIHEeSPrL49w1p?=
 =?us-ascii?Q?eV9nL6yAG3A96xhBdC7NwXxbFlYPrHYN1PlsZu6Syj/69aS/ttsh8iB6coyT?=
 =?us-ascii?Q?0ca4p+Qp9OMi7+G+cFGL2Yzsz8NDFupzcPBtBoM0zr5NY+njCJF80xVq1THM?=
 =?us-ascii?Q?qyLGm4qEs6dQ9o+ycSkobC9Bp2ZVB/wVO8w1h3eOChThJX0pDeZsa7fQLxgF?=
 =?us-ascii?Q?/0/A8adW/9rAnDYq47BY1KJu88nXe6R85aKiW/VZbXqVzPCwI7X9HijGbPh/?=
 =?us-ascii?Q?jRD5U+g/NQgUJ4jc8KsDZg8Se+mqVO8eTyB99DmZ2gDhezmdeJLJg2CXUm3C?=
 =?us-ascii?Q?EseT1m8uJZ7v3k7mb46B8Zk8eDJnt5LqCBkDbl0m1zeBIRlEgiMaBExIirCN?=
 =?us-ascii?Q?tZIPNOB8bBFqLO+cR13n0jXdZmQ9axV5PAzkopdNt3E+4XhXhTpdKDpRI/si?=
 =?us-ascii?Q?TcbLcZVJ8vrDmQ1RL7JYD23XDxvsSq2NpG4ebIhdI2CkL9LIulufCG0sKYtX?=
 =?us-ascii?Q?++jFKj6r3jWDK+ni5YdEsh2dSaSlRmMvOm8eQ2+eHPpn4qQ+o+5LjZ+xS4+F?=
 =?us-ascii?Q?q8rEGdBw4KsLsuP6V55MPowmRbVBvk/m5qeIOjhzIcA8XqtxR9nJEYNI/eqR?=
 =?us-ascii?Q?boYPqcBsUyFJ8J9Dcm7+y7lylIX17YL02gTiF0M1kHsugJSWL4hEvsF94Eva?=
 =?us-ascii?Q?+VzkVdfoMhE4Us0jxTnrScDT1Ec+FwURnTZAcq3uHTRPoOR1dgYoTiZfcnrH?=
 =?us-ascii?Q?LLayRPSWNuUejq8sH4gShdaY+/APyUT/4AU28G12KM/ccqXahQCBtq5OA9nv?=
 =?us-ascii?Q?yzSCOmKGqOop4cMvULt2uyW8c/ParisbnGnwWKCmVFlE2alAeB5/oGfBR/Lz?=
 =?us-ascii?Q?W0ltP6OiCL2Wu2Ap5ySyoM7USiJW7yDn+xz7nu1CiHs2QO/cjm2gCRc+3Tef?=
 =?us-ascii?Q?srJPc6O53j9yff9xT1BJBpym?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3619bab1-80d0-4d66-1856-08d9007c090a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:04:57.9735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kj8AnSIvNAMUxM5LUH5Cj4qFo8sh2q8uiXGA+9JXiEltIK7Yf5sQIlmSpe/6iayPOTzho/+1/opMMCmsx5hP4uJfGb8fgPjshm40g9B0mno=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
X-Proofpoint-ORIG-GUID: BLPYNUpiAbKhbLVxUxA5C-BZtl8qceBs
X-Proofpoint-GUID: BLPYNUpiAbKhbLVxUxA5C-BZtl8qceBs
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If qedi_process_cmd_cleanup_resp finds the cmd it frees the work and sets
list_tmf_work to NULL, so qedi_tmf_work should check if list_tmf_work is
non-NULL when it wants to force cleanup.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 440ddd2309f1..cf57b4e49700 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1453,7 +1453,7 @@ static void qedi_tmf_work(struct work_struct *work)
 
 ldel_exit:
 	spin_lock_bh(&qedi_conn->tmf_work_lock);
-	if (!qedi_cmd->list_tmf_work) {
+	if (qedi_cmd->list_tmf_work) {
 		list_del_init(&list_work->list);
 		qedi_cmd->list_tmf_work = NULL;
 		kfree(list_work);
-- 
2.25.1

