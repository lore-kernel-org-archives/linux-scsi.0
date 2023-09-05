Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E75CCF9E1
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239411AbjIEXS7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbjIEXS6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:18:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82389D2
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:18:54 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385MZkkw003967;
        Tue, 5 Sep 2023 23:16:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=CAmU9slHKJuJY/yjF4NP0LsR326+c7BwsXF2Z3pR6xc=;
 b=cLwPR8rHvDVgTiWgNlKpX6qgyT4KVmBEn03WBYt7zQ6XmIEWsvoMP+/wQ2mq5q62d0W3
 R7NmNJ77+4+QQ22wgNbJfF7k4uEQQhRmiwJxVnRGvWb5YSqqnM0tIg/JxWH/j3szIJP8
 CseOP5rRO7xCfabpYZSRtrzt2+wlT+f5iRn4gYLbzYLw6+69ZewBzBscEUUniZ6ustRU
 RybwL6y6HWb8qpt5xONavMkct5pD+aQBqe3Kitt2rZhT+uRFt+tlqij8Ye6mDw65zyub
 z0/zNdSOR39wD5izB003FZyWwpLoAIy0t/G3bldjiUz9bdRVlHd/qInLf02i6hps2mo/ vg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxd8d8207-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:45 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385MD1JQ029122;
        Tue, 5 Sep 2023 23:16:44 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5dy64-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXzmY1U7vtb770u0QjblUFohsbvLyQISQiXEFDoeXOloxZLvfuN5jVqWmQTXOmfv8m/GBcdzrAOjAIpHF4Hnp2NoPye9gkg7BUgCatWBcoAxkfuukjnYWlLev0ibb/A2dz0G2jibNuTBYW5FC4iOtkdceLqS2499hh1Kyzpt72hpRoxOJjJghi0hSVRqqY3A7pYxbBycn6YBzh82tFZerl6Xj+AQbmIgkxWNawTXHbmkcrRUs+++D3tZHGOOGlNRsKbj55dCuAO2lsa5N6bL+zkmW83Tk9hE3UNQyNU08/04nuVDCDdKkWumtVGvrg5Xy0eJ571P25SM4JKFFb9LKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CAmU9slHKJuJY/yjF4NP0LsR326+c7BwsXF2Z3pR6xc=;
 b=Dhqc2z2vY8icPR6cJqoOz6v02Nczv61l8ddhSXIjGvlxYwGjKzNPFO/Co+joz3MX0ZvR1gEjHC2v5P+YTxY3DcpZV4IgDEy6itn+j+sBw+vWeMMglNbde8HOq1KC4/uWzHIipjIHS+MuM8iY/1ncBSTTI5rxADCvKwC88/6kPJ3nP9T4KghsaSdxRjYBjJ2lo6R3XNFJPEccYSMfBOf9EP4lHes8Z39YzCx8VB8RU2cAQ7KZ7aNOLyYkoCT1avRXT8seZleXOc71Y5VqCER6DQuDOD57oz9STlbjexWgmLj0sHCI8zKy4oJX6+QYHNgjRyyziHjQJ6zghDZQ4xHkLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CAmU9slHKJuJY/yjF4NP0LsR326+c7BwsXF2Z3pR6xc=;
 b=lZzlRlwOJORS3wfI9ec9L8YhwZfgstF9nkqUlHnKgA4PsENGD/ZNC/Gs1k854PAarLnH3QAa1jV+g8SY8++kbhoKZ5PRme9sOYlWgC6xnxyUKOPc75KXb2B9nHOUyIK78ZubtBvSxtZrBXwhIqfZEba0wG23MRPTpYTu9rRW42s=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BN0PR10MB5287.namprd10.prod.outlook.com (2603:10b6:408:12f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:42 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:42 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 26/34] scsi: sd: Have scsi-ml retry read_capacity_10 errors
Date:   Tue,  5 Sep 2023 18:15:39 -0500
Message-Id: <20230905231547.83945-27-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0173.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::28) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BN0PR10MB5287:EE_
X-MS-Office365-Filtering-Correlation-Id: f0d749bc-d4a2-405c-66d5-08dbae662787
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UiCSoUmy3CaSkHcmEMxQCF8acgKwW/zyuSKwNwb3qLJhaX5pLcIqeDdVksjnuWZedlEAz0aRluWK4W/RCuCrwbsEqIDq8OOkwLr4llrlhkjz66JW32Lg1B94WBmpligumjQptdlZdmMb1m8K593DGU35b1hKpohAlQFaELdWKj0NhPqDhHy9QMEdku9+P2j8M4SqMpH6kdw9k6TNXfZrVqJ7ZPp24gpBU+zzs1pKx4DPEpqNLML4JTH+A5JPC5QipKC569tTB0Y5J1hh0qLN4SBgkh1H0gjh+TkxPNl19z3mSXjE7YFIAMqbtfi/Sf2Kvg2irqBdZswDS5YBQykv4VMBMz9bpEh73btceut93sUhDs1r731wIyiZyKP/dimLr/+TmodjHtjq+/ThvL2gmM6uolO6CQq2qw2sgd2MUKQC3dA6wOxxMztL5ayYWp+9w2cHwrG3oN8TKz+TTb6jwBitiz64ALAPRa7y63q8iBgr90SLUCAPBfCVVerSwcXo/LzWUNfTH3/UTlqijERrtc4j4jkmQpDvKDt2lGO768wcoxjaZ6SEX9TV1PWLGWE+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(366004)(136003)(39860400002)(376002)(1800799009)(451199024)(186009)(5660300002)(8936002)(41300700001)(66556008)(66476007)(316002)(2906002)(66946007)(478600001)(6512007)(6486002)(6506007)(1076003)(107886003)(2616005)(4326008)(8676002)(26005)(83380400001)(38100700002)(6666004)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6Omn2VaD0DWL+CGok0m1h1DpGvf3SaFKgWLDjQqf44no4n6u9E8f0U40/TA0?=
 =?us-ascii?Q?xLDQhAKv6j/mEGQnfzObwkePJAs0f8e7wObQNOzhbzujoNy+imH6A9++QdzN?=
 =?us-ascii?Q?tOLiold2SaqdsqCOm8OEi/Mup68yNV0nSSRYTUln8FtLOK0yG6kMWbuLq7wO?=
 =?us-ascii?Q?B8r9IL/NYRl+R5Fv/ZcN6PAlFXa527o17YNWvhJFK45cTrv9QSjkda5X8IQ2?=
 =?us-ascii?Q?midwltjBynfj2nD1TcmtBjW3rboqZxEXZF9bqsb7VJYDaSk1xgLJ/gGfbj6F?=
 =?us-ascii?Q?GbopTiUFPQ28v7UQYy+3s943Rfp7gwn75taLl8sP0gYql82IJ4YFpt36BQ2t?=
 =?us-ascii?Q?iEtDkYyXqXLwwk8RVSc9T+evSfEXteV9ufP5pehlalpCvvZ4AxXekfjpBDZ5?=
 =?us-ascii?Q?bEe+n4IUge2HGIHlP2j8KKqtbLN1Mcz3xUV7/ikDyEfj0EwoOCOhpUIhs1ur?=
 =?us-ascii?Q?uHKBOlXu6F+b/Pury7gNjtyLLHHH7yGqcBS1gdgvKK0wJoPcD+t2RK2J9x2v?=
 =?us-ascii?Q?fYZKsvAT6GWUGVmd5Vt/2Tc24HBo7OZkee3SGNdPE9K4ddZsbC8y5RKnQWWx?=
 =?us-ascii?Q?eA/fUnKvZ6CDHzlZNWAik3b3ea95FkZkGepJ6Cv6IZ51zwwKgsaqpOkYZVkv?=
 =?us-ascii?Q?W7Vs16hMIlyaHggEvQinEDcdCWqj9syCWBcWtRSUT7BFiKIqxHbQwzzTEz9K?=
 =?us-ascii?Q?eNy/EtPfQ+wY6U4Z1rmlA4kRBQWQjXMi7gst91Chpb+GIOLOG2bGmYLA92hC?=
 =?us-ascii?Q?i3cOVW4hMfFw6aVNyHlLnOKu4SC1tepfmOUpJWmOOZpBevgxd+hSbv+VEU1j?=
 =?us-ascii?Q?Hnb/G053TccWWu5DZVn7EkGJxMeq075NQ0fALjaq3EQjbwg77BZ8jdCTHwds?=
 =?us-ascii?Q?vJjf/FfQ93nX64Z+QM0KI/jztmNpfF0PPeS2K/BMtvPNxrbdIY4aO8qL5wHR?=
 =?us-ascii?Q?fReYPA+1gWzJK3H/80TS8XDQ/hDJrPPDr3YK2K5Mx7BVTTYEpDR2z7qAO2AJ?=
 =?us-ascii?Q?z1xEEZFDMhpqGZ4u4flF3gzcIq5VE2nd9MavgJMJ4HB1TJTTtKnPafSXSdgl?=
 =?us-ascii?Q?asPCgiguEonXtsJBHCSzQsODKluAm/vytlNr/ArUVv23ylVGhwoQnt4ClW/N?=
 =?us-ascii?Q?pO8SsUIYb477hW5U5iAXabdiEFEu6zFz8fTmBHPTLeoSJ/JuVOhewowpMaUN?=
 =?us-ascii?Q?S47DoDqM3RmZIFn7/DEOV7JHb3hFQwxfcR4T51RtlstaxRFyAETe1v9BNbwZ?=
 =?us-ascii?Q?C+ge5J4BCU+p7RtZsClV1kFi4ntKj/s/AUJMRVa1QT153SGwsaWFRCYePKH0?=
 =?us-ascii?Q?XT975n0V8npyZ/bcCi0/1KO7Zx0/jkR2pr71JUuvAa1/WqNcAd6pLwkszw6h?=
 =?us-ascii?Q?E2uFxKpvouFogOBrGg8kJzWeVi/AGV5sth6tqjl3wcfIk7LgJs97uNbvvpzO?=
 =?us-ascii?Q?zr0BbfRpMuNbFaoQ2QVsMf8VKGXE/exahIvxUygFih5lEijB+PqNJwVAmnwZ?=
 =?us-ascii?Q?LFu9Nq+77osn5BqSpm4ULI908klZazQnY/MSk4aiGCJYXChh36XxGRVOOL2z?=
 =?us-ascii?Q?NRf2Vi7ayJ1puRUw6+Q9jWxe9CEOZ6RecaHwfLdFZxhazpT/1qyqd2N44E1k?=
 =?us-ascii?Q?xQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ZsORJl4DzEwM74XWrPz5M+6sRkkyInyV78ybDCbIv27zCjg3Wzn1Nf12lMDVj3qE+ZDNHTlt4FrOIrf6rbRz62FTjCXNR87wN2tlC1Y9CWrvRF8d3VQ5nElWqMlX6oh+1G0OTxeH3L5JIKPBeYluIzAuyGg3jgpUL1v/9VUJ1+JfvKuEtH9ioqbNHtPKdo3U+HgOotDDyhsXYzixcnBQGrh1M6f5Tj4STt05M4iV97MEVUtBucvm5B26rew6Txr3LICgPhn88AsUWt1YpPdzIvqBsbywFS5xUZOZ/dGxu/Z0DgtnXiV5MUErbnuJtQUraXUO8TZnVol/50lTPX5O1EKLjdN6UDr+ualhD6R83dX+EO/+FPZmJMy556ySebcIBBHjxa+6bLvS/MYUtQzMCVfrrWeoNCPGgbe26Zkib8MaBccqVoCIXRvqSaczwnR+Fz7HgiX/Wshl9PPUkPox1pNbDqU50aiKWny0zj8YV2uF6PQLEs0WKIZbL+688gP4yA8kX/jCJCvRcJefHzFLV0AYNYCOV+DxTHwEKKyJQF2vn9keAm6ZIkBM0fcpUwB+c54vQm/MFSRLT5Yl//6r6D1beIkjK5GUkft3oHrF7hzqcYNylmzZZJYXIxY9GAmMLV4JLv8KCPpvWue4aCt35Hm60qx0WuLKVe8oNaTcWRZJCI7RsqXKTPYAB714TxshRZoJYoBYGz5SHIdWe3hEPyKhzG0swvxYPekQiewrn+CNrf7FRFw08TF+LGxEny/5NLqjzqlYNe9Giz71Xz3kxl9n3X2sALT/O1BJBa9ZauvyhZZIaQj45lLjI+z0JAOaEH1UBbo1ldpXMNnkZOG4UOKMFFM/c+B75uBJt7B7pNMQvE5oUVsMVnAtitlKA2JR
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0d749bc-d4a2-405c-66d5-08dbae662787
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:37.7496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i+We0RSow+KdnSl+b1Ev1N0V9X2RDcqSdRvK2dC/IkS/xMa7PrgYQr6L3rjctkbkuFRFcrjmwylCrfOq2KtZ2JbSfs76l7IJcq2O06tsqXE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5287
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: vdSPZzWhVXbvJ3U0y4iGCKo1FJUNWG_S
X-Proofpoint-ORIG-GUID: vdSPZzWhVXbvJ3U0y4iGCKo1FJUNWG_S
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_10 have scsi-ml retry errors instead of driving
them itself.

There are two behavior changes:
1. We no longer retry when scsi_execute_cmd returns < 0, but we should be
ok. We don't need to retry for failures like the queue being removed, and
for the case where there are no tags/reqs the block layer waits/retries
for us. For possible memory allocation failures from blk_rq_map_kern we
use GFP_NOIO, so retrying will probably not help.
2. For device reset UAs, we would retry READ_CAPACITY_RETRIES_ON_RESET
times, then once those are used up we would hit the main do loops retry
counter and get 3 more retries. We now only get
READ_CAPACITY_RETRIES_ON_RESET retries.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 64 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5b80f1df4cd9..781df1fefa84 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2528,42 +2528,60 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
-	unsigned char cmd[16];
+	static const u8 cmd[10] = { READ_CAPACITY };
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		/* Fail immediately for Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.ascq = 0x0,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.ascq = 0x0,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = 0,
+			/* Device reset might occur several times */
+			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Any other error not listed above retry */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	sector_t lba;
 	unsigned sector_size;
 
-	do {
-		cmd[0] = READ_CAPACITY;
-		memset(&cmd[1], 0, 9);
-		memset(buffer, 0, 8);
+	memset(buffer, 0, 8);
 
-		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
-					      8, SD_TIMEOUT, sdkp->max_retries,
-					      &exec_args);
+	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
+				      8, SD_TIMEOUT, sdkp->max_retries,
+				      &exec_args);
+
+	if (the_result > 0) {
+		sense_valid = scsi_sense_valid(&sshdr);
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
-
-		if (the_result > 0) {
-			sense_valid = scsi_sense_valid(&sshdr);
-			if (sense_valid &&
-			    sshdr.sense_key == UNIT_ATTENTION &&
-			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
-				/* Device reset might occur several times,
-				 * give it one more chance */
-				if (--reset_retries > 0)
-					continue;
-		}
-		retries--;
-
-	} while (the_result && retries);
+	}
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(10) failed", the_result);
-- 
2.34.1

