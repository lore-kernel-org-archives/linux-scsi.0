Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB6DC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 23:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234354AbiJZXW5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 19:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234369AbiJZXWl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 19:22:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12659DFB40;
        Wed, 26 Oct 2022 16:20:39 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM4n8s014902;
        Wed, 26 Oct 2022 23:19:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=J1WNckJHJqQzjMy2fBpZNiNiCzSfjvYL6Igwfl71aSA=;
 b=YR3hxLkag4F2W+AGdfPhJDYQi7ircMj0JmaoYyMBVjjsGjB2FFd63DAS6LWOj/poLHzG
 b5hYDcG+XtU6ZN5BYpcfRTAhyLi3iaX3Axvk9Al+iJ0mq1jW1RA8zWYmEBJId/ax9AKW
 JKcxk1Poz5pu1uOCvew2Kx7KNqZ3L485PzH03eSm7L+bUDgsyiQByAICoBnwFHnCBeuN
 Ke8sIf80eIf7Jhg9/BSJyHmOsfdAVX9cplcATEUVcN86GxIAKzCyNQTU4SDJeK1PhBuO
 oO2Tr54WFVzT1BR+0yiEG/8UGcdIK0TaCGSbiBsMHCNxB3h3irfKFffKMEkq77d2Wcai Qg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfb0aghxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:19:52 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QMDn5i006678;
        Wed, 26 Oct 2022 23:19:51 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfaggdrfa-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:19:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U5TPfIQaHfJyjr//DTYcaL4bEMiPVuatwtv8xK3F36bPl2/AUXewX9zxOoVIf2NrPqK7nSH+p5mGeA2roggueJYuRoYA5597Pg44f5GtkFICIHOvd/6qpiY7OWp6VKxVHqoczjyH4REYr3/D/k3Wvtn2/jOHEmI7VWzB/bBS87+HNemrQ1mL1312xk1vUPCYlIwBZd9W+Jz5DbBEfko524GS9+koCzDcbm+HMzKdj9Bd8DNIW4xgJCqKBGqJMgGkyRrfHxsv/F178ElzTmkDTUHvxJKxFrti9PBAbQFoUPWGnZdcwhMyBI9nUtg1sJ+yL5OsFoljAELL+Gbq0rqzFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1WNckJHJqQzjMy2fBpZNiNiCzSfjvYL6Igwfl71aSA=;
 b=USp0UZaIokYDOF5SFfpqi3Ul7NDBOcn/+Y5Q6DW3FLpSlIIFxQ9j3NVn25zkbk9mEsn/lOZyN6e/R6qjUfBs9VdIS7NqRD/Npo2KBOKLgHXBuVEP5Vk6av3LWq0+q3jJAsfigwy0uJjfbZzoXfDi1WYr5sYyXuxtpstWVq6w6KtB7w6MwL4xBm6w6yY2G2fYug6XDOpteajIJIvaO2P0ngd2WDLlFv53Qy1zPqkdTqaAP8pFkvVlCauG9qHhPSNoXZLvFk9EethFBgMtgiucamYD7dOgOFA7MKQ4vOZv0HLkvdfea7cIG55qcI2h01EY3YIRGu5IlGuUiIpOQZQ+Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1WNckJHJqQzjMy2fBpZNiNiCzSfjvYL6Igwfl71aSA=;
 b=l0aYBKkxxkkXM9tAN+uxCn/Zx9/L5jvv+w4jbQqZbYoSoYZssmG4940pooHDmWAIaM65vbqrE6sOVLafS9yYERYQqB9ojMWQP+XydqUMSXUj4RuhDY4OEKxp+kUIHEPqgBz5mohOItBRaYex9hgs+fHIYCJ9shItpUJpgtwffpQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5117.namprd10.prod.outlook.com (2603:10b6:5:3a6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Wed, 26 Oct 2022 23:19:50 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:19:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 01/19] block: Add PR callouts for read keys and reservation
Date:   Wed, 26 Oct 2022 18:19:27 -0500
Message-Id: <20221026231945.6609-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0068.namprd04.prod.outlook.com
 (2603:10b6:610:74::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c2bc16e-50a7-4ff8-8bad-08dab7a89451
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uT68YNrk7WdGG8kvQUcO48Y7nRWGDp2xL24UlfQB1Cb2VdyQl20Hg3uVffhzeamrTigTyWiMXxbUiQlbOhESAi7JpkHBfmIHvwhAwGQ0bbH/S80QdDv7ihYYLnt8QgHJh79WY+PtocAjNfHo94KlxD6pi+NWdwna6eb/NdQlzNMv4Y07cKxL9kP4i2U7xwxYa1xGOILRYBXaFfC+dnxqu+L7EmekQ6MHitvX8GWZSbKQ/PpXjyCHWsT7D+hfRGa0pXssM/n3WMJ0UQa3v65/vures81xN8sS4ePVXDX+KBWpS/OmugfKMusLKAlDMdgg3uWDqtIhVY1V6fVGuJb1mk2UTK+PFRVLM9zaSsW5rVGbmC7/56Eaere/g4xcQhgwUoar5lWol5aFl3DaKHK4vdP7v0x4Ti9Lh6GYFklPUEE8fiRhkohk5g7rjttyiBypMjRavpSVWI3RfRctlmSMC0kp6nEVjNu+E1H0a3lakq8EcHHOPTshLGqE7vaynlnA7fniRVlxoYHgEsAKaO7YYZ5/4aDUEcY3hAyfto2sJeXQp9t+/0MgnoQ8FRPgv+JSPheqCCjXAx4MDx2HNVrz5H/r+8HSx/nm0YC2ETQF1R5Wv4RTBysKbmx6BOH20iXqSASRheL2zaVE2DTHKk+qbmPly5sxjxQA5TYpEJnYzPqletMdzpRjLtTzAEUHkadrBmh4gg4aTpti/AzZuOaiyukSq0iBMDgM6fxAKJyFV4bU/RVXzQQSkPcflcHvEEyY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199015)(7416002)(8936002)(2616005)(1076003)(186003)(5660300002)(6512007)(41300700001)(26005)(86362001)(921005)(38100700002)(2906002)(36756003)(83380400001)(316002)(107886003)(6666004)(4326008)(66556008)(66946007)(66476007)(8676002)(6506007)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2aWnUgnhXRP2VKryG1RmaYETXGgHtQ+i460FqJrWDMEegR4tff1RcQ2JAf1j?=
 =?us-ascii?Q?jlc47IauAFWLflVqxDAD0ZtmiOCEboU3F4fnlPC4AslNgVacJpK4x8Hbu69I?=
 =?us-ascii?Q?L/Yqr0Z0GTjEt4hPmEWr4zSgdmAiGgVT+2TgzK2hIiScr2+YZG1oooeUX17o?=
 =?us-ascii?Q?hkp8bSOliPujasjyxIlmJf5Us+gmdskMhOXk+oOXAEwVFxTI4WPO/7XhX+E0?=
 =?us-ascii?Q?cK1V9oxMyk59+MUxXF5Y+en9FOAWKRisZfKEbZXFJy7/IvhpQFsL0jkvSsKL?=
 =?us-ascii?Q?68I19U2z4zGyUUjZO+Da9aEdcsHhYl+yfLN4pAryvSa6w0YIYtiJLZmasTHt?=
 =?us-ascii?Q?5m+7FPh3c3VSvr2jxYDrRWKI++Rmu6vCSCtmUgZXAWk6enewaPiS1/IQX0mK?=
 =?us-ascii?Q?QWyh0X4qnta0m4vhlzXN+CbaalQPlw5ysC2KXOJdXU21zU7W7KZk3coK97pZ?=
 =?us-ascii?Q?tma/Ml05SxEOosCeUUMmfXTwtMN9tTpGzGRaZfKW2Q11jWTgtXHTeZcD5d86?=
 =?us-ascii?Q?TyxSOLjhUd0tdHzW5b3wblTFvGYWqhEBc0kM4/+9X74dMa3GzhMaY3d9mVM8?=
 =?us-ascii?Q?Jnxt6QVPp5mY7eBFN2AzpyQjO5xwZqivZLf6NdFx3wHT71MVoSs60l1nU9u9?=
 =?us-ascii?Q?PTrQf3S7olDMJYvjB7/eJBuq58GqHFfr+UkhopTxa4c6VBHwvI6Si2X0pDYJ?=
 =?us-ascii?Q?TWKrzygSkqwo69XXNxTPw0VrlaXVrhaO8zUn8vWOZYXY86OP23Lnq165hi0A?=
 =?us-ascii?Q?bR4HJN7xncjS3+pZTsKuV98D74naUWIrNOrP/Bq3rMCPwNibMC+w9f2z99Op?=
 =?us-ascii?Q?BCXJapMPMLAFqtD5xU11cuG8c/3GYPn8BgfXdynastRT4bLp4YIxj+eq7lZq?=
 =?us-ascii?Q?1LyQNdfHwANS1AY//plOUDLwZCRQddyelXoksrTgXkai8rOaV/9wo8+/KVm4?=
 =?us-ascii?Q?m1zG/pBt7AMbFpx5Q/2piJ+ZuQeklgPc+V173w5JTyB+mXAHbnHHHgNX4oJQ?=
 =?us-ascii?Q?KYPJVAjDuK6Gs1pER7qDRyGJuSi93DRDOMrn2uqSuxRK//Z4Ktp8/yvqawdA?=
 =?us-ascii?Q?FMkUyVOHMpFV1euBaahROi7zFrzN2cO1ZCK081cZuA4+LMsKWtdM/pXUR+zE?=
 =?us-ascii?Q?8hYGTaKWMC2MHyjPw3M/amfBMYvQLTIVvY5ZBERCVPvtPza1jmaQlx/qy6CY?=
 =?us-ascii?Q?2zmSRZx73dbG0YEy5PeJQnxfGbzZVBtW6QrsLgSgIHjux8J+ZZpc5HmcZccv?=
 =?us-ascii?Q?AI0mDxUHZvp8B6Z8AX76WLns+AS3TrN6gqXsVBnNbihpB+Ezt17G7RTm1rEr?=
 =?us-ascii?Q?fFHKgLdkOzLp7dmd/olAerC06bMWoddCL9NBVF5nrp3vifuLoAv0/IWAgSY0?=
 =?us-ascii?Q?KZo6zx+6CsXUq4dup9TKDYjz6RjnOEtPqmGY4+WYF/TtnDRKOYFr9uI0a5Or?=
 =?us-ascii?Q?h4PQqdDNrdttG3Z79HUqJYWnvUhw8RXCaVGkEkf7vfJx9oEFEGH0Vtje1GoM?=
 =?us-ascii?Q?nppUVtnzs9mN+0kAOo3AnFF+UwFifTMxzSABRiDaAkrl4SThKl1vnjG7PJuY?=
 =?us-ascii?Q?x7RaoEB0uW8AtJHHZG78DXTawfbf/YRKlEx5nWTh33lmj5cGOW425o17W0KJ?=
 =?us-ascii?Q?FA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c2bc16e-50a7-4ff8-8bad-08dab7a89451
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:19:49.9294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mJoBroIVgdD5T03wC8sxLC17lMWvFHfnHr/3V0Qo9qxgIDfUFB2YVz8K/2YBaBkihmA3AS/eolz2iGK6iWc5JaN1lW+9oJSbmIKJkA+PqCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5117
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-GUID: 5850Py0goKJrFpY5EJ4AUfGNkslRckI_
X-Proofpoint-ORIG-GUID: 5850Py0goKJrFpY5EJ4AUfGNkslRckI_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add callouts for reading keys and reservations. This allows LIO to support
the READ_KEYS and READ_RESERVATION commands and will allow dm-multipath
to optimize it's error handling so it can check if it's getting an error
because there's an existing reservation or if we need to retry different
paths.

Note: This only initially adds the struct definitions in the kernel as I'm
not sure if we wanted to export the interface to userspace yet. read_keys
and read_reservation are exactly what dm-multipath and LIO need, but for a
userspace interface we may want something like SCSI's READ_FULL_STATUS and
NVMe's report reservation commands. Those are overkill for dm/LIO and
READ_FULL_STATUS is sometimes broken for SCSI devices.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/linux/pr.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/pr.h b/include/linux/pr.h
index 94ceec713afe..55c9ab7a202b 100644
--- a/include/linux/pr.h
+++ b/include/linux/pr.h
@@ -4,6 +4,18 @@
 
 #include <uapi/linux/pr.h>
 
+struct pr_keys {
+	u32	generation;
+	u32	num_keys;
+	u64	keys[];
+};
+
+struct pr_held_reservation {
+	u64		key;
+	u32		generation;
+	enum pr_type	type;
+};
+
 struct pr_ops {
 	int (*pr_register)(struct block_device *bdev, u64 old_key, u64 new_key,
 			u32 flags);
@@ -14,6 +26,18 @@ struct pr_ops {
 	int (*pr_preempt)(struct block_device *bdev, u64 old_key, u64 new_key,
 			enum pr_type type, bool abort);
 	int (*pr_clear)(struct block_device *bdev, u64 key);
+	/*
+	 * pr_read_keys - Read the registered keys and return them in the
+	 * pr_keys->keys array. The keys array will have been allocated at the
+	 * end of the pr_keys struct and is keys_len bytes. If there are more
+	 * keys than can fit in the array, success will still be returned and
+	 * pr_keys->num_keys will reflect the total number of keys the device
+	 * contains, so the caller can retry with a larger array.
+	 */
+	int (*pr_read_keys)(struct block_device *bdev,
+			struct pr_keys *keys_info, u32 keys_len);
+	int (*pr_read_reservation)(struct block_device *bdev,
+			struct pr_held_reservation *rsv);
 };
 
 #endif /* LINUX_PR_H */
-- 
2.25.1

