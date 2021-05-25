Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05EDAC4707F
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9B90613FA
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbhEYSUW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60760 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbhEYSUQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIGNhv122698;
        Tue, 25 May 2021 18:18:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=B2mP8b3Ak3kQ7jk6jUST18rXQme68Ec7MLUj4/2MPjQ=;
 b=tFqxxk/LUOgr7pcrgoPDC+GyqlLs8I1mztfApxHnfIOTImowEZu4i3R53EjqQPp+aDkG
 cWpgrhgilap6kWPQnKdc+yVsVOTl6B5LtUsv28BIodOUmkX/sMMqRCvipu/QS0XtRph9
 CN541pxBNnKLe/oL/sJZIbRH2dgAwMJa779QTGfuNLfkv71iouX/bPSxT/31CBXu/j2D
 TWY1ppJe8KznFjs6GKZ0SNeJRwgbjEaWG+ub6bIcgGc5WkkRcCp3Qq75cIST2gQisbjq
 442H7Glj9hQtnju6fuIkaQ7micktG4Erue21jqK6f4FalEFki85ZUgkDEYA9HTzeDNcm NQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38q3q8xcv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIEtPw166079;
        Tue, 25 May 2021 18:18:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3020.oracle.com with ESMTP id 38rehaq4xw-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NIyJgL8MShto+rISGREt76GTLV+lFMuKbUGPsnZK4OjyRYW9sciZPTmK0BKeELh00ib0g3BPZ9QbURJxT4ZfjZEPEtRGoqJvAwy7dqTo98kXczYkPdYGTW6jZy9r2Rk9mh2sEoSgu+cfIYuOckcsI3NbpvzouaD+lj7Oc/gndVZrS5ZWsHsmDyObWWhnHmIhsajMz3MyzPynnuVVsRPm9ieKvDYckh11NYAIirNc8+SPgaFe2Op6SQTtiTYfRIGd2l26QNQnR2/pSuXzXxj4GQS8Cn2eMSiET9pBjyNZaCiEeSKvjz2JS8MqFrRX5zofki8zfUaablIXfhHzN3xmAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2mP8b3Ak3kQ7jk6jUST18rXQme68Ec7MLUj4/2MPjQ=;
 b=m+f4kx825hFqGOph3ep1ErK1aoy/RpgzaxgxKCvKWpw8IscgoQs2xHfbpf3H5GU5OeaBq20TvfXmW/iqweay1Ne1HjKcMXEj3T4FwOYXpXZoqLxatn7SZkNsYaSinoqGhJL+3sz1LSo15+5/4YoTucyzS8EhK/YxsRKEN86NYtelXmnTfX2rxMaJS0TsLMIondYNp+n0jH6nAhOPSUpy3xBp2qLTBVnp35fpXKKsZ/NCrSJyMDsSR1Grs7wF/6JAGKHR7TehnkLWlr47EiPXmfvVliiuiCy15HMNzBU8jaIAxPjSN4JmdhFFgS8fb7UssLGUGcqXIqpxBwCOLpStKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2mP8b3Ak3kQ7jk6jUST18rXQme68Ec7MLUj4/2MPjQ=;
 b=m1l7nzbKG3ZSjcc05QRAW4Fsr+oYyANS7PmuYTTKW3jAqLZAm0041crkZJFibJ9IP6x86Jk7qUBlbteV/5BDzAaFBOX6cmUgXsrb81J8fJJDE7SE2cFUFiFdmFH529Vz1qUXrqxf2MHGpqJ0hPNN0UHgVyFIebSAg9XdjsjzodU=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4767.namprd10.prod.outlook.com (2603:10b6:a03:2d1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:35 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 06/28] scsi: iscsi: Rel ref after iscsi_lookup_endpoint
Date:   Tue, 25 May 2021 13:17:59 -0500
Message-Id: <20210525181821.7617-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525181821.7617-1-michael.christie@oracle.com>
References: <20210525181821.7617-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:3:ac::13) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45989e37-872a-4cc8-ae26-08d91fa982be
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4767A01941FE86DC0EEA0A46F1259@SJ0PR10MB4767.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 686oZC219gKIfvJT890VeLhMYLrRP6wsKTENKf19iX6R3Ml7MbD1k+69fyaVTQfF5J29u4njRs67yMWAB0VWsyN7ErFngokew6TZaejzRq3Dq8Z6DDMTweVCptE+emugoxwbHzpvLknMuyNBLzWuY9BBh971tTVmUSan/RZ5jfBY9g+iXhXUoiNOBeQ9jIOhgJyFiL8ZJ8F5wl+MUIzLl7IGc3sf0Sx62FW2AzHyh/REqJBQ2Rve8ZF553GuNLbarhZx0HZbQUJuEKsb0pVdB/yO/4nVqMN/fAQQaBJ0NLLVanZhURLveJVRZyUbsS6jsaxxAGJQZW2nOlU0hV1iJS2MojJ2dbim6W+Byf9Tp3KSfCXFyAvLR46o1NU/xh9eFuSILQplRaLEl/mnMlHHUfYkS0rVAGAtzphs9kwzxkwnL+6K6D2Ui6wXhs8BXcfT3UgcuSz4kdwQfEnk9jUPX7xCpM+wNRsfRhi414maQUkuBQZ86C/0HV1TmCl7tFkKV3itypIEeuJPkxy/BVsh/aKuo1JGaHzsFjBFmD24qPFbEd38rBW2BIfmo9uAzylOkSlhZQ9rWeaAHuOnSZ9ZXlE/TYTmA33ipGM83fJ1weAj2moVVHs3hmcM/1lnzqhdP4DzDTVw8yL2w1nY5+gwif3pOWB2WdyQAcpoCUpj2li98ENW3seImRDeg2sEKn1/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(136003)(366004)(38100700002)(83380400001)(6512007)(26005)(1076003)(4326008)(5660300002)(956004)(6486002)(6666004)(2616005)(30864003)(38350700002)(86362001)(107886003)(36756003)(8676002)(16526019)(8936002)(66476007)(2906002)(66946007)(52116002)(6506007)(316002)(66556008)(478600001)(186003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/4KHWvkxorOQ0vszeAliyJACpHEp2SN0CeZQkVtL1YZGwGh/s12VSjkByDX+?=
 =?us-ascii?Q?XWLDnJLbAi4cgg7CgyPHuD4PVEAXGCYOXaZWPMXF1ShyvLRXs8rd9neGhm9L?=
 =?us-ascii?Q?Z65zpjyBaq/oRQ4rqsYckjLeZDHmliQ3AARGjQapDsHT0M5J3p1gmChqniL4?=
 =?us-ascii?Q?l+BBA4Q2YIlWkOj8+BHhtXHQd7/wiPhomFTKG2fDRpH+IMYzVW71dOwgJ4k7?=
 =?us-ascii?Q?LK7tOW5nwSeQwHCapNvlAfXRIgyXYWZD3wGzWEJQmyH4BjoKVe6aFLG8jL6n?=
 =?us-ascii?Q?mT9P7t4C6saFc7u7cqJZVa5bUti351qeGmUvNsP+XWWdFfAZFI6ucPpKKC7s?=
 =?us-ascii?Q?ATj6txLgHb0YQ5bSlUtXq0MtDS9twSJYjio4+pTw1QBNI4ScFtNv55FwboIP?=
 =?us-ascii?Q?YFeOaVJcrtSl+8tiHpHqdwheSHTYGO+OT4TWeFFjF0bcEPWNjmwjdFBoG9Z1?=
 =?us-ascii?Q?x0WbQjp9D3fm87HSrFTG6TV3BVM0q+HrkuTeitdZb+8SSYlNzhtazlUVBGP/?=
 =?us-ascii?Q?Vuy5tyiQIUz1eI92EPGIvqbpeV6LjlgNhyO+yzrwrgm8vwIHVhTBdjWm+IvW?=
 =?us-ascii?Q?u5Ee9X1NwsKYcCdfPEV/bcL0b3kA8XTQMbF6/hCaTt5C3i6VFgz3a1j9RpOD?=
 =?us-ascii?Q?8tQz1YZxX/UhpZF2/h+I5WpbCdHq4sEv2zyMBj1qF0jbCT5HcWzZRw+Tl9NV?=
 =?us-ascii?Q?ZJ4bNTh0Lj+dX1PPhtfVZxa0mWyaCIJvVEkwdzFFsqPRhjSalwWrFAPVGIRi?=
 =?us-ascii?Q?ju1bTPQDwLH0nyncJI+/o6XjnhN3CoHC1y8yOCfxKDXlGeOlxHi1HasTNK/V?=
 =?us-ascii?Q?EixRWs+PbsRMI8UDw5v0NDcupWUbqDX4NxzP/Y0xiwayrItJPQyGVXxe+R2A?=
 =?us-ascii?Q?cIPdq1ma8/OXIdHU/m4HXFn9IT1C90VDZ03/et3uJ6wOq/8vIeXx2/tTda2f?=
 =?us-ascii?Q?g59HGT/Zpx9PxC/d8qVI7zn4r7N3C6CRT4+VCNj0fed1HxzL5te1al8LDVOb?=
 =?us-ascii?Q?zppdxe9l6Td9KXfbyWqcsk6xxKPHo0MvJdo/rrCIwQK8NAc6G8uHWoW4Y+9E?=
 =?us-ascii?Q?DmTYyRsg++HU0ZHLlj6ZYBPg67f9nz6CzG2r9HycXGvXqQko1KszRTeGkocv?=
 =?us-ascii?Q?XEitmEf6pqPS/17pjdybwS+Plg5KLQizls+cynkJg6iDldYloZ1W0vUYJWz5?=
 =?us-ascii?Q?6HRJPK6nHn65xInMdottLyL4qVt3MIClb3lK+pRKaIU5OeaMh9ZUb3RGeiov?=
 =?us-ascii?Q?RuHTWTQdVmtx2IeaF51ehUjikLX7XIOBC+bagOESrCf/EdLhXjrBfEwmr8eg?=
 =?us-ascii?Q?nhsaBMKvDTIgNTLn3p8e4RKj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45989e37-872a-4cc8-ae26-08d91fa982be
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:35.4783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nVL7pso+pSZRNnGZ13WeXPXcR13lpvVKmVMtqV1YIygv10UUtOatXZQuEQ700wEi52cLU57oi8Vo9Rh12ThSJdcXPoSiuby3NK+7Nf0YQM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4767
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-GUID: rhKpiDl5w9JtdPTVXxJN4GbC9VxokfnK
X-Proofpoint-ORIG-GUID: rhKpiDl5w9JtdPTVXxJN4GbC9VxokfnK
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patches allow the kernel to do ep_disconnect. In that case we
will have to get a proper refcount on the ep so one thread does not
delete it from under another.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |  1 +
 drivers/scsi/be2iscsi/be_iscsi.c         | 19 ++++++++++++------
 drivers/scsi/bnx2i/bnx2i_iscsi.c         | 23 +++++++++++++++-------
 drivers/scsi/cxgbi/libcxgbi.c            | 12 ++++++++----
 drivers/scsi/qedi/qedi_iscsi.c           | 25 +++++++++++++++++-------
 drivers/scsi/qla4xxx/ql4_os.c            |  1 +
 drivers/scsi/scsi_transport_iscsi.c      | 25 ++++++++++++++++--------
 include/scsi/scsi_transport_iscsi.h      |  1 +
 8 files changed, 75 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 6baebcb6d14d..776e46ee95da 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -506,6 +506,7 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 	iser_conn->iscsi_conn = conn;
 
 out:
+	iscsi_put_endpoint(ep);
 	mutex_unlock(&iser_conn->state_mutex);
 	return error;
 }
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 51a7b19bfffe..8aeaddc93b16 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -182,6 +182,7 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	struct beiscsi_endpoint *beiscsi_ep;
 	struct iscsi_endpoint *ep;
 	uint16_t cri_index;
+	int rc = 0;
 
 	ep = iscsi_lookup_endpoint(transport_fd);
 	if (!ep)
@@ -189,15 +190,17 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 
 	beiscsi_ep = ep->dd_data;
 
-	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
-		return -EINVAL;
+	if (iscsi_conn_bind(cls_session, cls_conn, is_leading)) {
+		rc = -EINVAL;
+		goto put_ep;
+	}
 
 	if (beiscsi_ep->phba != phba) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
 			    "BS_%d : beiscsi_ep->hba=%p not equal to phba=%p\n",
 			    beiscsi_ep->phba, phba);
-
-		return -EEXIST;
+		rc = -EEXIST;
+		goto put_ep;
 	}
 	cri_index = BE_GET_CRI_FROM_CID(beiscsi_ep->ep_cid);
 	if (phba->conn_table[cri_index]) {
@@ -209,7 +212,8 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 				      beiscsi_ep->ep_cid,
 				      beiscsi_conn,
 				      phba->conn_table[cri_index]);
-			return -EINVAL;
+			rc = -EINVAL;
+			goto put_ep;
 		}
 	}
 
@@ -226,7 +230,10 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 		    "BS_%d : cid %d phba->conn_table[%u]=%p\n",
 		    beiscsi_ep->ep_cid, cri_index, beiscsi_conn);
 	phba->conn_table[cri_index] = beiscsi_conn;
-	return 0;
+
+put_ep:
+	iscsi_put_endpoint(ep);
+	return rc;
 }
 
 static int beiscsi_iface_create_ipv4(struct beiscsi_hba *phba)
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 9a4f4776a78a..26cb1c6536ce 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1420,17 +1420,23 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
 	 * Forcefully terminate all in progress connection recovery at the
 	 * earliest, either in bind(), send_pdu(LOGIN), or conn_start()
 	 */
-	if (bnx2i_adapter_ready(hba))
-		return -EIO;
+	if (bnx2i_adapter_ready(hba)) {
+		ret_code = -EIO;
+		goto put_ep;
+	}
 
 	bnx2i_ep = ep->dd_data;
 	if ((bnx2i_ep->state == EP_STATE_TCP_FIN_RCVD) ||
-	    (bnx2i_ep->state == EP_STATE_TCP_RST_RCVD))
+	    (bnx2i_ep->state == EP_STATE_TCP_RST_RCVD)) {
 		/* Peer disconnect via' FIN or RST */
-		return -EINVAL;
+		ret_code = -EINVAL;
+		goto put_ep;
+	}
 
-	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
-		return -EINVAL;
+	if (iscsi_conn_bind(cls_session, cls_conn, is_leading)) {
+		ret_code = -EINVAL;
+		goto put_ep;
+	}
 
 	if (bnx2i_ep->hba != hba) {
 		/* Error - TCP connection does not belong to this device
@@ -1441,7 +1447,8 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
 		iscsi_conn_printk(KERN_ALERT, cls_conn->dd_data,
 				  "belong to hba (%s)\n",
 				  hba->netdev->name);
-		return -EEXIST;
+		ret_code = -EEXIST;
+		goto put_ep;
 	}
 	bnx2i_ep->conn = bnx2i_conn;
 	bnx2i_conn->ep = bnx2i_ep;
@@ -1458,6 +1465,8 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
 		bnx2i_put_rq_buf(bnx2i_conn, 0);
 
 	bnx2i_arm_cq_event_coalescing(bnx2i_conn->ep, CNIC_ARM_CQE);
+put_ep:
+	iscsi_put_endpoint(ep);
 	return ret_code;
 }
 
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 215dd0eb3f48..dbe22a7136f3 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2690,11 +2690,13 @@ int cxgbi_bind_conn(struct iscsi_cls_session *cls_session,
 	err = csk->cdev->csk_ddp_setup_pgidx(csk, csk->tid,
 					     ppm->tformat.pgsz_idx_dflt);
 	if (err < 0)
-		return err;
+		goto put_ep;
 
 	err = iscsi_conn_bind(cls_session, cls_conn, is_leading);
-	if (err)
-		return -EINVAL;
+	if (err) {
+		err = -EINVAL;
+		goto put_ep;
+	}
 
 	/*  calculate the tag idx bits needed for this conn based on cmds_max */
 	cconn->task_idx_bits = (__ilog2_u32(conn->session->cmds_max - 1)) + 1;
@@ -2715,7 +2717,9 @@ int cxgbi_bind_conn(struct iscsi_cls_session *cls_session,
 	/*  init recv engine */
 	iscsi_tcp_hdr_recv_prep(tcp_conn);
 
-	return 0;
+put_ep:
+	iscsi_put_endpoint(ep);
+	return err;
 }
 EXPORT_SYMBOL_GPL(cxgbi_bind_conn);
 
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 30dc345b011c..80f8d35b5900 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -377,6 +377,7 @@ static int qedi_conn_bind(struct iscsi_cls_session *cls_session,
 	struct qedi_ctx *qedi = iscsi_host_priv(shost);
 	struct qedi_endpoint *qedi_ep;
 	struct iscsi_endpoint *ep;
+	int rc = 0;
 
 	ep = iscsi_lookup_endpoint(transport_fd);
 	if (!ep)
@@ -384,11 +385,16 @@ static int qedi_conn_bind(struct iscsi_cls_session *cls_session,
 
 	qedi_ep = ep->dd_data;
 	if ((qedi_ep->state == EP_STATE_TCP_FIN_RCVD) ||
-	    (qedi_ep->state == EP_STATE_TCP_RST_RCVD))
-		return -EINVAL;
+	    (qedi_ep->state == EP_STATE_TCP_RST_RCVD)) {
+		rc = -EINVAL;
+		goto put_ep;
+	}
+
+	if (iscsi_conn_bind(cls_session, cls_conn, is_leading)) {
+		rc = -EINVAL;
+		goto put_ep;
+	}
 
-	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
-		return -EINVAL;
 
 	qedi_ep->conn = qedi_conn;
 	qedi_conn->ep = qedi_ep;
@@ -398,13 +404,18 @@ static int qedi_conn_bind(struct iscsi_cls_session *cls_session,
 	qedi_conn->cmd_cleanup_req = 0;
 	qedi_conn->cmd_cleanup_cmpl = 0;
 
-	if (qedi_bind_conn_to_iscsi_cid(qedi, qedi_conn))
-		return -EINVAL;
+	if (qedi_bind_conn_to_iscsi_cid(qedi, qedi_conn)) {
+		rc = -EINVAL;
+		goto put_ep;
+	}
+
 
 	spin_lock_init(&qedi_conn->tmf_work_lock);
 	INIT_LIST_HEAD(&qedi_conn->tmf_work_list);
 	init_waitqueue_head(&qedi_conn->wait_queue);
-	return 0;
+put_ep:
+	iscsi_put_endpoint(ep);
+	return rc;
 }
 
 static int qedi_iscsi_update_conn(struct qedi_ctx *qedi,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 74d0d1bc208d..0e7a7e82e028 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3235,6 +3235,7 @@ static int qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,
 	conn = cls_conn->dd_data;
 	qla_conn = conn->dd_data;
 	qla_conn->qla_ep = ep->dd_data;
+	iscsi_put_endpoint(ep);
 	return 0;
 }
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2eb77f69fe0c..bab6654d8ee9 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -266,9 +266,20 @@ void iscsi_destroy_endpoint(struct iscsi_endpoint *ep)
 }
 EXPORT_SYMBOL_GPL(iscsi_destroy_endpoint);
 
+void iscsi_put_endpoint(struct iscsi_endpoint *ep)
+{
+	put_device(&ep->dev);
+}
+EXPORT_SYMBOL_GPL(iscsi_put_endpoint);
+
+/**
+ * iscsi_lookup_endpoint - get ep from handle
+ * @handle: endpoint handle
+ *
+ * Caller must do a iscsi_put_endpoint.
+ */
 struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
 {
-	struct iscsi_endpoint *ep;
 	struct device *dev;
 
 	dev = class_find_device(&iscsi_endpoint_class, NULL, &handle,
@@ -276,13 +287,7 @@ struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
 	if (!dev)
 		return NULL;
 
-	ep = iscsi_dev_to_endpoint(dev);
-	/*
-	 * we can drop this now because the interface will prevent
-	 * removals and lookups from racing.
-	 */
-	put_device(dev);
-	return ep;
+	return iscsi_dev_to_endpoint(dev);
 }
 EXPORT_SYMBOL_GPL(iscsi_lookup_endpoint);
 
@@ -2990,6 +2995,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 	}
 
 	transport->ep_disconnect(ep);
+	iscsi_put_endpoint(ep);
 	return 0;
 }
 
@@ -3015,6 +3021,7 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 
 		ev->r.retcode = transport->ep_poll(ep,
 						   ev->u.ep_poll.timeout_ms);
+		iscsi_put_endpoint(ep);
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
 		rc = iscsi_if_ep_disconnect(transport,
@@ -3698,6 +3705,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 					ev->u.c_bound_session.initial_cmdsn,
 					ev->u.c_bound_session.cmds_max,
 					ev->u.c_bound_session.queue_depth);
+		iscsi_put_endpoint(ep);
 		break;
 	case ISCSI_UEVENT_DESTROY_SESSION:
 		session = iscsi_session_lookup(ev->u.d_session.sid);
@@ -3769,6 +3777,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 			mutex_lock(&conn->ep_mutex);
 			conn->ep = ep;
 			mutex_unlock(&conn->ep_mutex);
+			iscsi_put_endpoint(ep);
 		} else
 			iscsi_cls_conn_printk(KERN_ERR, conn,
 					      "Could not set ep conn "
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 8874016b3c9a..d36a72cf049f 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -442,6 +442,7 @@ extern int iscsi_scan_finished(struct Scsi_Host *shost, unsigned long time);
 extern struct iscsi_endpoint *iscsi_create_endpoint(int dd_size);
 extern void iscsi_destroy_endpoint(struct iscsi_endpoint *ep);
 extern struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle);
+extern void iscsi_put_endpoint(struct iscsi_endpoint *ep);
 extern int iscsi_block_scsi_eh(struct scsi_cmnd *cmd);
 extern struct iscsi_iface *iscsi_create_iface(struct Scsi_Host *shost,
 					      struct iscsi_transport *t,
-- 
2.25.1

