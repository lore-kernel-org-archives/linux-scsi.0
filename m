Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC7ACC6FA82
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Sep 2022 11:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiIOLKs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Sep 2022 07:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiIOLKp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2022 07:10:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B44D74CC8;
        Thu, 15 Sep 2022 04:10:44 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28F95TpF021818;
        Thu, 15 Sep 2022 11:10:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=uCLMn9Q8PGLuaqNZlek1wWu1MzoF5nVdaRqKptYa07s=;
 b=tnEeuiNF78/wYxst9Lu+iiPebn1o988yZQUbFhEFpaWxZDLOkmY15eSLNdLWwodaY9QZ
 w9aJVIEEXjB9KHi9MZTUGqV8PiAWcrVTxpUzqSwhiCBg3iiOyOz95QzoUn4ZOwcU59S+
 hOorO62YRaequ67rXx55xxmiCPqxzPLjYw7+dsyk0L8xaOw/WZyYLLIMxjsEn2KfYBnc
 NPNRpWCjg842rEC4/iQfjDn69a7fzt2O2zVdABwBs/2fnGIOix4iKha+qF6CsLpgjsSU
 RJaXSjcsYue2xl1ZvbP/Wny2RkPuWE/wtpZT67A5Jd/q96qCk7tyYCqcL1H4z+lZPbQy LQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jjxypcw8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 11:10:41 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28F7qOA2021486;
        Thu, 15 Sep 2022 11:10:41 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jjym5s18k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 11:10:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4LiWLrJe5PrJGLophIizuehS1W8X5OJMiBS/35OTlB7jTt84gtpTIZSwFbgz+4qnQdmCqVV9zrlsy0dSzcZLzCZcvraIdLfj0zg5UQ1eAFXt1YJ++Fft5BzLzJzlfZi4xs+Cu5+1hR6Z0vvB7/A4+AB/RL4oKqu9GHf7l67o5jCKxJvLKmcC7XT4MmeJqgz6noQkzRkC2GYXchwYUxcQf1RHAoVvPTv9YftDrAMxNFSPAij5HrJeWwq3507juT7eR7cxm9dtMQ9tJHA1/+z/n6o1uWkFVHzLgjZSzqh7nrXc9f2B32av4q+rDfjOvUkNxqUsqp4kALbDsHTppEPgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uCLMn9Q8PGLuaqNZlek1wWu1MzoF5nVdaRqKptYa07s=;
 b=WGR1KdHiMajXPPg0fPjoWNZqutYdkibxD7ZB/fbBtm3LnXkGU3Is1MSNCC2I54L2uJjitpmxCQ5o8zs+wmPp4z83NFy6fDGMZmd3cSY+z2xK5X/sZ2DdouFctmrxjDjVptECFWhOMYU8kjHSVCfREFBia3hfuYIt0tekdN/sZ6gVF93LcWzPIKPuzn+FkrYo2mFREKfFE4dxg/K84BlGDXM1ZWqvUcjZyJG9tq85HbxeDDhGaWXngR5qeztCjDPcY7UmzSfkWCSdAqP9OVmf8v1DhAdkRYEWJX1o+H5IqELs6NQl9zk8RnvnMwd8TU/Kjt+UqY0v+nrnc3/fS8X6Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uCLMn9Q8PGLuaqNZlek1wWu1MzoF5nVdaRqKptYa07s=;
 b=ogRWQzN2+2LZ1CmBfhf3OhkHsQoVZjJr2+CZFPQVBTC5Qqi+ZyVGdoIhXgPg+rgolJp9n916bL3gWRMXCY2mgSO2CgzGJJM+syWX2Su3bksXkpf/k6mvXeg2friqNZ84IE5NBhqtj6YX6h9FhNmNUhCL5+C/+TFeKPo+1Cm8exw=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DS0PR10MB6173.namprd10.prod.outlook.com
 (2603:10b6:8:c3::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 11:10:38 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6%6]) with mapi id 15.20.5632.015; Thu, 15 Sep 2022
 11:10:38 +0000
Date:   Thu, 15 Sep 2022 14:10:30 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] scsi: mpi3mr: fix error codes in
 mpi3mr_report_manufacture()
Message-ID: <YyMIJh1HU2Qz9+Rs@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0194.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::21) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|DS0PR10MB6173:EE_
X-MS-Office365-Filtering-Correlation-Id: 27e73bcc-abf4-4759-a879-08da970aeb8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oCjzVKl4DwH++DIUdab3Hg3hcSiNgjGp1vQNBNVBZTJP0mUl5+GkqpQEEUwcIti/Edo3fdKi+rkwpi4ZZDXnN0kbVoQOYQlcKyS++jqXHaCQpCqFnUjiI5p5CYgT13YL7yBs4Xl3Zm9IyPlPBEeuxUpOU4586E7m1wHwZtpF+FCZxOPms+n9LZw7EZXZq2+GbjMney7SemEMF8Av7icOg9uljd0NuUde6Bb+wfdHAp0G3E+wTsq96NzdiSg+StTUVoSsgDq5cz4r7Mc5KafuiYLwj0K0wJbrx8S3+MUalJSMowaPOamC1VZm/LSB4d+YXMhzjubxq1eAO3B8fRqkGpEZhWiVReI7HzCgEMY4JdRsNc3NnxsPZshHJ24tCjFo/Z07/K6N5xCNC8o25v1RcuGX6hdcmAIp4daXuLZ3Tt8sbH5nulVSb8C37I8AVMJ27GPtJzFU8ZU9FeSfhHRY4kb6iV8sHvNU6ixu3zb5nWT9oBIjCTeScMegbv1Y09m3OzTy8L1QiUC+1gup8tIT73sGbyrOjTahSMG0fe0pCBGhPo3o1bOzBXIV0LO0xBtM9BI7G05WxFLw//EYBR5BLUFTaIG4paVSNB6CMPu+0AuDyPbFG9l4V2UlmSfknA0XAD/MZyq6eLA8mqUaglOuwHiOYs2R3v4Uhw9VUn2M1gnt9zpZjxw6F+af2Bfeys8sNsrYDRJXaN9T69MRah3QErMNUiMET6k21CXe4/gQ53OYlbBvnS/pXz6u/QDK0Bo400pCAhgwvRuim+0MsRtm7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(136003)(366004)(376002)(39860400002)(396003)(451199015)(186003)(6666004)(6486002)(478600001)(9686003)(4326008)(66476007)(2906002)(41300700001)(6506007)(33716001)(66556008)(8676002)(5660300002)(110136005)(26005)(66946007)(8936002)(44832011)(83380400001)(6512007)(86362001)(38100700002)(316002)(54906003)(32563001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LlOZQm5rNsZA8d+IrxcvMZv+3EqqBP64KxtwtmjdG85jVCrAm5i4CBytuOvf?=
 =?us-ascii?Q?zyDpDJecbW8+rKr533rcQaBdSkl5xP6TeXNK5Ma1oG+QvK4a99V6OX88WYah?=
 =?us-ascii?Q?ZcSBnLpKFL44EH812WfiHnI6Ef9nxvEzOSl2lGUAGz5FOioe9COuDHMO2PkC?=
 =?us-ascii?Q?PofgKXkJrbvqgDYXJz70SKED6kIDJnbJ3osIGYfccoRzk3rLZwlL78s93f5n?=
 =?us-ascii?Q?FV5PEJunwA+6GoeiF+Celql0MpXEVKjufUkMATDojSvcr8yjGi9gVS9FWUJh?=
 =?us-ascii?Q?NqzY4z6gqaN+KTHrPQty/e0Mz1r3giJPbionCWFDttPDoGRFzw/M7gy3urjD?=
 =?us-ascii?Q?RGKMUIYZcocR9VPhGfrmJv/IAIGEUgJTD+eyXGYAEbB3DlDAS4D0gnKF4cti?=
 =?us-ascii?Q?dL7xRdmfTDMxIv0FT0tOlJ7Z1aytIkaXaIbXcNf+CTRE8XXET2awx6A5Y4hl?=
 =?us-ascii?Q?qX0/AcqeCJJlGTeqLlC2TP1NQHr7Sn+8P8D0yO0BI+DZNG50pwJOH3dyvQKf?=
 =?us-ascii?Q?8D1fQe2KXcFcWCpfJDFGytzaKr8fV0JqNaQW4BlU3H9zotn4w16O3TTDXPAb?=
 =?us-ascii?Q?yuPQlIP2LnPkOTVvDT38zDovesWqpkc306zl/yHbFJYrqCJrDBWvPshYAPHY?=
 =?us-ascii?Q?AIjkKHzoDdpGA70QRezRw6k1lI55nhleO/7VRt2vhSBiCMGGrry7SSfJFTPk?=
 =?us-ascii?Q?t/8Q8YMMcyyqRQ1Sf4bj2ZFzp9StuFUCG1NQIIFzl8rhmC6T7PUrLunlyVru?=
 =?us-ascii?Q?SnR4+wBtEPb5MUTVSClwL9zXwyg5iGIFJyBqTpJsHzrX4srmotkWn/dD9CWe?=
 =?us-ascii?Q?fklVZnaXYaqGAG+FcEcw01PmU1AkfCeteXcZ53qJlrhlIyZjlxObKDnCFntT?=
 =?us-ascii?Q?LSsvPom9E3r3z3FOhs9eCOfHn/I6kgYJHCkwl18JdAoMzRqWynC1KR2OS9+G?=
 =?us-ascii?Q?xEvMFY3p8CocRwTW8kxukcEMUWQVloAzQlwsL3nCX/burT0VHKAkViCJqiZ5?=
 =?us-ascii?Q?d92gCnU/3OFL4yqerfoadlJM7dJLsopiakQ8tjueBUnsTJmvFGH+/top95x7?=
 =?us-ascii?Q?m1vt8MSWVZl+c2z4FQdDI5VzHqe+sYgih1vIiV2eP3iw7BwIZdMLiJf8bF3k?=
 =?us-ascii?Q?scasznKxFIN9iX1daMLMqfsH2iRGyx/7EH3HFmHBsdM09K/Bnv1wIsuDr7XP?=
 =?us-ascii?Q?ad6MKnUbl8Kk6tssJzX3QgwtUbNn9hgFiAcyA3guPr3UF6H+x37QVRZNXKE8?=
 =?us-ascii?Q?5evpxNU2xMZMo/jVt3QXgSPapBwSC1GABEb/Q674VcZfKOgIfNHge3Riw78G?=
 =?us-ascii?Q?xkbG6rjxJHNxh+m+UMGGktT1kc893L083ONGkrh0mkUn2KvGbrCLxuhcXPS1?=
 =?us-ascii?Q?RIxe+O8mObXBiRMZpxnNfOMiBzpR4bWZQ+B3tkRZMrHx8iMmXdVYQh59UhxG?=
 =?us-ascii?Q?PR2ZZlMy9T/86ec+UdKxV7tGDeeG88SB8uaQhedc963BknXMnhCxEkfY5Vsp?=
 =?us-ascii?Q?3OF16I5a+Yfqy7D2jeppwlIZ3OqN/a66kDf5NRk+ZcwK+nJNnJmiuKzpI3SG?=
 =?us-ascii?Q?5BRMl5hUwmtSn/j0aXdT/L+D2LRGnRfjzCq7fgjXzcayyK6bW1fzLgpzUBLM?=
 =?us-ascii?Q?hw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27e73bcc-abf4-4759-a879-08da970aeb8b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 11:10:38.4861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ocYvOf72xju8gbULZjrY5vK50GRaTtXbopi//ns7W8t+RVQCjaXFTxY0ghOir+TT/+C4gC3xEv9EBvZn2Xwh3zkNqYoakKm/7+FLE7KRsU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6173
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_06,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2208220000
 definitions=main-2209150062
X-Proofpoint-ORIG-GUID: K0o_tYN0LQuK3Xf8j0bTFOwEse6XD6Fz
X-Proofpoint-GUID: K0o_tYN0LQuK3Xf8j0bTFOwEse6XD6Fz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are three error paths which return success:
1) Propagate the error code from mpi3mr_post_transport_req() if it fails.
2) Return -EINVAL if "ioc_status != MPI3_IOCSTATUS_SUCCESS".
3) Return -EINVAL if "le16_to_cpu(mpi_reply.response_data_length) !=
   sizeof(struct rep_manu_reply)"

Fixes: 2bd37e284914 ("scsi: mpi3mr: Add framework to issue MPT transport cmds")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 58 ++++++++++++++------------
 1 file changed, 32 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 2367d9fe3fb9..74313cf68ad3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -145,6 +145,7 @@ static int mpi3mr_report_manufacture(struct mpi3mr_ioc *mrioc,
 	u16 request_sz = sizeof(struct mpi3_smp_passthrough_request);
 	u16 reply_sz = sizeof(struct mpi3_smp_passthrough_reply);
 	u16 ioc_status;
+	u8 *tmp;
 
 	if (mrioc->reset_in_progress) {
 		ioc_err(mrioc, "%s: host reset in progress!\n", __func__);
@@ -186,41 +187,46 @@ static int mpi3mr_report_manufacture(struct mpi3mr_ioc *mrioc,
 	    "sending report manufacturer SMP request to sas_address(0x%016llx), port(%d)\n",
 	    (unsigned long long)sas_address, port_id);
 
-	if (mpi3mr_post_transport_req(mrioc, &mpi_request, request_sz,
-	    &mpi_reply, reply_sz, MPI3MR_INTADMCMD_TIMEOUT, &ioc_status))
+	rc = mpi3mr_post_transport_req(mrioc, &mpi_request, request_sz,
+				       &mpi_reply, reply_sz,
+				       MPI3MR_INTADMCMD_TIMEOUT, &ioc_status);
+	if (rc)
 		goto out;
 
 	dprint_transport_info(mrioc,
 	    "report manufacturer SMP request completed with ioc_status(0x%04x)\n",
 	    ioc_status);
 
-	if (ioc_status == MPI3_IOCSTATUS_SUCCESS) {
-		u8 *tmp;
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		rc = -EINVAL;
+		goto out;
+	}
 
-		dprint_transport_info(mrioc,
-		    "report manufacturer - reply data transfer size(%d)\n",
-		    le16_to_cpu(mpi_reply.response_data_length));
+	dprint_transport_info(mrioc,
+	    "report manufacturer - reply data transfer size(%d)\n",
+	    le16_to_cpu(mpi_reply.response_data_length));
 
-		if (le16_to_cpu(mpi_reply.response_data_length) !=
-		    sizeof(struct rep_manu_reply))
-			goto out;
+	if (le16_to_cpu(mpi_reply.response_data_length) !=
+	    sizeof(struct rep_manu_reply)) {
+		rc = -EINVAL;
+		goto out;
+	}
 
-		strscpy(edev->vendor_id, manufacture_reply->vendor_id,
-		     SAS_EXPANDER_VENDOR_ID_LEN);
-		strscpy(edev->product_id, manufacture_reply->product_id,
-		     SAS_EXPANDER_PRODUCT_ID_LEN);
-		strscpy(edev->product_rev, manufacture_reply->product_rev,
-		     SAS_EXPANDER_PRODUCT_REV_LEN);
-		edev->level = manufacture_reply->sas_format & 1;
-		if (edev->level) {
-			strscpy(edev->component_vendor_id,
-			    manufacture_reply->component_vendor_id,
-			     SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN);
-			tmp = (u8 *)&manufacture_reply->component_id;
-			edev->component_id = tmp[0] << 8 | tmp[1];
-			edev->component_revision_id =
-			    manufacture_reply->component_revision_id;
-		}
+	strscpy(edev->vendor_id, manufacture_reply->vendor_id,
+	     SAS_EXPANDER_VENDOR_ID_LEN);
+	strscpy(edev->product_id, manufacture_reply->product_id,
+	     SAS_EXPANDER_PRODUCT_ID_LEN);
+	strscpy(edev->product_rev, manufacture_reply->product_rev,
+	     SAS_EXPANDER_PRODUCT_REV_LEN);
+	edev->level = manufacture_reply->sas_format & 1;
+	if (edev->level) {
+		strscpy(edev->component_vendor_id,
+		    manufacture_reply->component_vendor_id,
+		     SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN);
+		tmp = (u8 *)&manufacture_reply->component_id;
+		edev->component_id = tmp[0] << 8 | tmp[1];
+		edev->component_revision_id =
+		    manufacture_reply->component_revision_id;
 	}
 
 out:
-- 
2.35.1

