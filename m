Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE61DC3F6B0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 00:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244222AbiHIAEt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 20:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236118AbiHIAEs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 20:04:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADC316590;
        Mon,  8 Aug 2022 17:04:46 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278Nwhfe031116;
        Tue, 9 Aug 2022 00:04:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=uRGN2oUfiW4oOSWg87nXTqKx/I8ttSjtuHunQDaPEyo=;
 b=TniHIoffVpBRrVyfdWoP6XVRkWcaVVCAUYJrrSG0hRkvUXkyFWj6d0R29y9aYLtDf+Ap
 gxuB2zuGWyQh8aG+e7PGJwcILCc3FmtzbMTyjImh8O+DzxC/5pn3aKdmfxTZTZ3/foV0
 T2cc+MjMXt6i7WVyEU9qwibq9vkOTZnpfkAyA3BYkrWpUCEu0D8uSkBEVyLCxHdIy64K
 sRY7trRT5xMiBfWKdPa27qMwDStDvGz717eji3QVJn+Qp3w88s1SQ7Y6Hp+6XSsE8I0J
 YkMl50Qcrt41QW4fsQvbsrXn8wkL7bp7RHMaJn3Cgq7r2r705XfiprpM+8zeyKpYptUQ 2g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsew155h1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:33 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278M0h7m011564;
        Tue, 9 Aug 2022 00:04:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hser26u66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O4163o3aXaCf/zR37m2D8EZR0fsafQdH38SqVZoJVFG9Ma8kWTWbzJMOyxgkcQ+u/gpuYMbqyuk59HAM295mWsIZ2uzi+tUgcbfOL4mJiOYyOd3o4JbcgVSFu4fiMV1xxbBmo/WTk9jtuiBNcofySUtBB8zBkimwMzf0pLuxweIz+NGX9mp7nGeNq+BEs7pQnokDEf1jS23EhNlHlE7daFHuoKVZmhaxRRUBFgzZjxyJD+7aVWgQgPoO+8QspEB6h2TCTh8yjHnQbSXm4dw51iQjY3ZnUXLAZ66HNvH9ipI5zrPyM54F5uZXwzTyUtNre1yMVRCPp1Of/rgdfIxvIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uRGN2oUfiW4oOSWg87nXTqKx/I8ttSjtuHunQDaPEyo=;
 b=DHmAmH3Nvw5Y8fbv5DriP3A8AvuFc01OytyC5YC3EeQQjJ5puGTX97DP0qmiSShr7l+iKF3Ohxo1SQ665hIa6pHJNMpAFMNmViT72efpj+hgwmZWoKdX5KxaCAWh46m6eWeVDSyRUVc9NIH05+Sjs/20ZQXDvWLddv6bk/23cjRoEXtEzX3dwQU+T4WnZEVmryJKRc/qCNq8QQnrxnPvFUpPs0LaQpmRjykfzGXmXkseoJteOPtmDcbWkZUyS0pgbPiqOl/DRXauNYZaC0YruaS1CJVsvj57bELkVGHDtJO2wxpuhX9LaBsVYi7zdNNZMSQxn6Py8wezUdiCIMETXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRGN2oUfiW4oOSWg87nXTqKx/I8ttSjtuHunQDaPEyo=;
 b=pkqZYNXSn3s9F9ov/FqKO/DoChKjLAE6DvWlxpmFlJ6qu2Mw5QiV8QMIhQhIPYg3/c0/13B602WSLCsxBa8mE738ygrp2jIDP0XFv6MAnFRjJUEpyRap885uV/WJX2Ylvdufs6YRJvx2QFKS9KrqNUtdatuxKr0Do0yaGazCCMc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN6PR10MB2590.namprd10.prod.outlook.com (2603:10b6:805:45::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:30 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 06/20] nvme: Fix reservation status related structs
Date:   Mon,  8 Aug 2022 19:04:05 -0500
Message-Id: <20220809000419.10674-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0107.namprd03.prod.outlook.com
 (2603:10b6:610:cd::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 810305f1-e851-4261-2a1f-08da799abb6e
X-MS-TrafficTypeDiagnostic: SN6PR10MB2590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZLbQmnE+SciC8CgqiQEjDbMUB+rHVC8D65aseWW1OjttJu5XM32Cl71pCOvoV8szjsr68xjnMOLJJS8j8p8bmYSmdgtB+xT7MU/sPcI40dLV0P9G5slFQaVo9V27CiA8q5jeBqKv1vQFJ3P9WduK0NH0bIOpqpDmGLJV/Qp96Zo3cXEc/QhfbKWyoa2ZF7ti9M9UenwmqLzDjHaM7+maXyRUcPgGufMxlHhmWOv+AAtOloyCFPUrG05TtKljCgcfY7cYV789jYinNWT2w/3+nKlTFT5VqxaMUXP3Id6SKyAXd5UU5plDt6kcufkB57p6YiHnPOSPWHxWDij94016uNKaMffrIdlrhbimUoWAv7Sm+b7jS4EWACiaV6Nt1h06CxO4JpDCrT94inFpV3frrRBns6j/7B/aExaEnTQu8kvm2EGZVLRXpBYRVSjOeH/2pDLDQhFgh/T+sj2fEBy1cPG+JFIzew1bohuJE5M/4xKvpGwrj7hhQsBoCDzd9Y3oeFksgpsMDAeW2znfJYL8lZ84dkc4ZOmKMt5HFtkr1+nOzi/DHWaMyQpDZbSkmYUfVVm29/DBdFmL3Q9mX9q1pkoPitNe1sMFe/6lF4KPdNuTy2BrSo3dYWybdMG2qguAWuTowflpXpfpCkQgVhQtjLw8aVKgjC8alGUsLYzR72/rRn1nLYTHW78W06zKGAhmlVIimzUyVCGyo2yQnK/7J0IYNNE4AhlyiK2xZKOorztGphoe1uczni/xTlrMVuD9o1RagTnn5I0jOooFla95Jzd5HP5lLzvxWZ8iLI6Sl6s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(39860400002)(366004)(136003)(376002)(2906002)(83380400001)(6512007)(26005)(6506007)(186003)(1076003)(2616005)(36756003)(107886003)(38100700002)(86362001)(921005)(66476007)(6486002)(316002)(4326008)(6666004)(8936002)(66556008)(66946007)(8676002)(478600001)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gEK1IA1Sw8w3QZL4hrbyjV/3MFfRYzJC3AbH0b6t/ucV3Tl2ycMz804Qaq+r?=
 =?us-ascii?Q?GmZiFLMCX3lNxTHAyzFl+BEZVTSthVSJQgAtVKIJq9KXk4+7EbhgsSeyiUPC?=
 =?us-ascii?Q?xhk9dSCbG8r91+OlZdYsYMFEIii86j/u/RS/aPWdEmvH9KLV0n/6MGnxj+IM?=
 =?us-ascii?Q?zLkOHLLYMImgEhFdI6KWAjkp6/nLASRlLMcC5xV0p2q1Oevt67djq4iBGHW/?=
 =?us-ascii?Q?k/i5BHBTwxVecPA/BlM87UiizwXJZluowpT/br0R3gA6WTqOHiPeH88nfa2u?=
 =?us-ascii?Q?e09N8s8sCncM2Ez7Nl3mPir22mqUOVBszIAW+TlCr5y3KDxGcbztO5HAier7?=
 =?us-ascii?Q?Q9tIlRha0bQqmUf3RzLtghEsekdUqXa+9Bt6MljwyQEopVhWQC0iNBAnrX6X?=
 =?us-ascii?Q?xHzfIbpjgp8N01TfpLzNsjCakkwTF9736F+Lir0YKw12m1D0s5UOjChzsIHw?=
 =?us-ascii?Q?YuD30N8OMn8VFHHKCnTwDwD8W0Ix7Z5KzokkRENGdYPq/xvmFxgKBvwNwbKx?=
 =?us-ascii?Q?m7vD9Tl38sVpogfJBUCtd+NKdNZ/8cZywLRC5LOTfupQW0d2PAb+dMpQiGJF?=
 =?us-ascii?Q?VPw5vl/98GhyZjQsQFgJ56drFIC2dRLHSejklUss0VXqDbboCNTF7k5aq+T5?=
 =?us-ascii?Q?QftqNYrRcG6jWlhgKhujPyhZrXIATQAV7xl+n9ln8lNjo5fabw+EEKMeD/t5?=
 =?us-ascii?Q?aFUqEQSBDjkb1xWLLAyMvYQvMyY1prQQa7R73doI04Sk2rKIXxQ+9I4x+RNS?=
 =?us-ascii?Q?Qp/jTdezURBw3sHaLCFULH/PeIqN39jmd1iBj633iImWSzBTiLUs8ZksdyJ+?=
 =?us-ascii?Q?WwDtAqGN1a/hrf8IuHfamGSbVeYg6NZVQE0I37tMSuFzcKWj/m3t6MAxoGFM?=
 =?us-ascii?Q?IPn50DbS/Y/baUFsoJKH3gMi1eTX+Rg5ijNuL7F0CLbxrlOYyWzzCBS+79Zb?=
 =?us-ascii?Q?u9XgpbN4u+Od3JmLCpHESIIvDgrD49uQcI9qVUg9W8Y7qdUhaGktLbaabreT?=
 =?us-ascii?Q?/2SDj2eo1WAK5nCds2rTnZn5Q8MSjGpNiyS4x2WjJi5ntSKw3DXc1l3CmtXY?=
 =?us-ascii?Q?SxSKaH5iOfT8kKU01GOFdhDRxdwy0gjb1r85w97UCayv5GReBloqViO8zeDy?=
 =?us-ascii?Q?NPOJc95PXs1PYp4TK38AkLrk3RkG7Nos23Z/WzRjafuNalMrD80iLicycOUo?=
 =?us-ascii?Q?iTlNgoh/pRMT01QjJRgD6T9LBZNeDMnGdy2y2OyfuaQTlbLDsx6xiwc780bj?=
 =?us-ascii?Q?wxLE5s0wRcJNyb140Mxs1Y2uu3QFimBc0SyluzPfoINFL/FJXrUANHvVd8gy?=
 =?us-ascii?Q?Fc/buE0Mr6CwdcipOkVfQNQ3+rN2/jFOhYBUPZBhqgDvqyLPneIhYXGpKY5D?=
 =?us-ascii?Q?sGbnprAyPVMPt0Yc831KwKDt/8xyuvVLg3de68AVrNamOkUEB9G3tPLoWzkQ?=
 =?us-ascii?Q?/8dLOOypMoBWDMi3L98CNvMsCxwD1MhSTUzztR0nd6OsDQfrZJyZujQ6x59W?=
 =?us-ascii?Q?fIDpVMUIFXr3Jpim8hmE8ddXGs0Z0o9kaV5XBSP0E5JcB4n9FaB0KsiaI/+V?=
 =?us-ascii?Q?nq6z42GEvVXoL5ihjfreX7f8f78/XvH7B7br4DD3Q6VM2/PFkElCVg7+Qcy6?=
 =?us-ascii?Q?Lw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 810305f1-e851-4261-2a1f-08da799abb6e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:30.4079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tQtA0//l3RyHrTqfMDsovRRUteaEkLBKQ01EskRJ6bwzibHel9TrYxnY96P7aLkGX9bYrWvleW2Q96oa24Nj7u3hAgZ2rRJqA2XzOzssaKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: srLBY5e238ujbu17K3Eqokh7WukeXQEp
X-Proofpoint-GUID: srLBY5e238ujbu17K3Eqokh7WukeXQEp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes the following issues with the reservation status structs:

1. resv10 is bytes 23:10 so it should be 14 bytes.
2. regctl_ds only supports 64 bit host IDs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/linux/nvme.h | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index ae53d74f3696..ae4a76076420 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -757,20 +757,37 @@ enum {
 	NVME_LBART_ATTRIB_HIDE	= 1 << 1,
 };
 
+struct nvme_registered_ctrl {
+	__le16	cntlid;
+	__u8	rcsts;
+	__u8	rsvd3[5];
+	__le64	hostid;
+	__le64	rkey;
+};
+
+struct nvme_registered_ctrl_ext {
+	__le16	cntlid;
+	__u8	rcsts;
+	__u8	rsvd3[5];
+	__le64	rkey;
+	__u8	hostid[16];
+	__u8	rsvd32[32];
+};
+
 struct nvme_reservation_status {
 	__le32	gen;
 	__u8	rtype;
 	__u8	regctl[2];
 	__u8	resv5[2];
 	__u8	ptpls;
-	__u8	resv10[13];
-	struct {
-		__le16	cntlid;
-		__u8	rcsts;
-		__u8	resv3[5];
-		__le64	hostid;
-		__le64	rkey;
-	} regctl_ds[];
+	__u8	resv10[14];
+	union {
+		struct {
+			__u8	rsvd24[40];
+			struct nvme_registered_ctrl_ext regctl_eds[0];
+		};
+		struct nvme_registered_ctrl regctl_ds[0];
+	};
 };
 
 enum nvme_async_event_type {
-- 
2.18.2

