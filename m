Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B9E9FA373E
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 23:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbiJZXZo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 19:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234282AbiJZXYy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 19:24:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C6C13D5A;
        Wed, 26 Oct 2022 16:22:33 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QLHdMe020594;
        Wed, 26 Oct 2022 23:20:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=WjZyaw4GuQsHxZtd2vwavDBaYa6DO4LJhuSgnPLLX0U=;
 b=P+XMKyRc7IVc4ni/nnjxpkRh+WeVTUB80+HUg3x+7sn9nBMsCuAJ7UqeWrtrKQA/Dh4K
 Jy4eczQ34OnsrvA9gMPB3IVzjeU31dG8851v2CTgeww35EFLimK6EVxB9dVB6KCQnBcG
 PsfXB+PYORgnb01o6cIF/JgD/fIMwV/j4BaAitel60i+RdNf5wVEGFPDob6zoDo4xpZ9
 SQWvNdP5IKsJ/s5p3L1uPTDilsrc+gIeCv6HCvwM3mfN6/KNTu0HTz8fMIOo6aUMrW5E
 8qKNUY2RONRqByJ2hMW5IL89jmrbT8y9Xh8ZNEhJaFDVYKXIjL3//XbEL4LnlS4Okku9 Bw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfahe8n85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:20:00 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM2B77011647;
        Wed, 26 Oct 2022 23:19:59 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2171.outbound.protection.outlook.com [104.47.73.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagqduvx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:19:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nt+5mL+LkxpgX+qiENhl1B0JOdjix2lZp9vOLH8DTDS1anunfOs69lvJwMPopi5b72eJdP8kn+Wuoob3a+I21TbcQDHeffRIR26xhpUHcjQqo2/ZJ+ufIHGoICNCdaLIqXHeKmLECggM+AcsA+WlY91kVNQF3DgTRfy5SOXcKnZi8ABhxymuGxYgayhRZU720FjlKoA7iUSvAxOXADgBL2uX+klwtfxxl61JqTC9LCqQhuBbrFIdCNcbHvLohOYCIjv4SLllg8VbCZS+Ng5AXZsMPHfEI/gRHgrbW3gkKW3S8Ni3ctIYX4davecwh5RgvDaknM8fYEdfhPgytW0sKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WjZyaw4GuQsHxZtd2vwavDBaYa6DO4LJhuSgnPLLX0U=;
 b=dFjxMVRUP4AHVpX3qazxSdMHFwHPCW+65l8HplZN57j7XfmbB4PqXldmdgMAIkxbWN7QFuXzwbln9FKmqMaLb99p5qAGwLQQXsw2+gYot46jGUHLptQbJ2jprQ7kb/7wmYj/kDnVVl7yEoz7MADT5xeTTN65U6R/gxmNVh6hCcxdpdBJ/ypIoRB06Z/HRryOc7LrvIG5hxV1WinnnUkMZjGpNSeYu9bAhjklFH8ir2sWZCcbV5FV52V5vtbak4ZBC/5F8kzc/G1zXl1TfuzbypCjvXK7Ag0CA2CAKaieeBMOswzX/kEuLHLXFzY1XI1DPA5NJ61aDv8sMsGum4HBPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WjZyaw4GuQsHxZtd2vwavDBaYa6DO4LJhuSgnPLLX0U=;
 b=gT8gI3nEi7k9/6s1Ka3vOZ/Hx+tNChx2dgMggmbLk2/7VNt4pZkxzAlrJ2Kprw2uxi2qMe0NXmAlWWk6TrmGN1BC8KabmYimfvW8C4WKb7CfIq4dzx8MCHj2/Sfdpes1+//QjAztDcIXzzvj7nFCC1y+VYDd677z+3W2/BoDzwg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5117.namprd10.prod.outlook.com (2603:10b6:5:3a6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Wed, 26 Oct 2022 23:19:57 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:19:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 06/19] nvme: Fix reservation status related structs
Date:   Wed, 26 Oct 2022 18:19:32 -0500
Message-Id: <20221026231945.6609-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0005.namprd10.prod.outlook.com
 (2603:10b6:610:4c::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: 78e65c10-a66d-4dcd-c67e-08dab7a898f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ybSNEqjAgQkQ/Dgo1ZXRjuqji265Soha5j8jma0OUj0GhT5X+Bu7slltIrCkGr0t548GL3aBBNN8aAFgMiYu2OlLMLnrCWDmKRwAFz93c7v4QU0TB+v15IhX+xgdbZSOZuU8C2HwMVN8pBgPuC2+bPhd5OpVghPqBY9LogPyD5murAHEtVhyEASg9tB4xX0LgadhsigKR+PURaEc8nWl3dgfexLVWLczRhTWQeLtbpTuiufCaolgVme47UHgPP6IDtD3Zx3pRhPzuIV1KPIsKSeG7LkHeawmziVKDugDPtSNlyIwJygvlsr7v5y4ESL9uww0QY6GUSQnbRwvFruTYDe7XAYi0AlvTlLYVwsORpFe5GCqsQwCW1dmX97n5pVpMR2bNXKNqixXx16MWJYrPUbEcfYr32QswGtzH5rCMO8SFlAVN/yrX0kybSvssLD8REy2yh7bW7eqxVJ/1iW7e80bj4W/vFXG+IUBJZuyf1h17425wc563qtZBf2JI/b1XK8Zx2v2BOXpgwCnjAXw/H9tKIaMrxwOzp27pKs3JFdyYQhQyx61sMzrg61xPNiMQRk3sgxmTtH+14LtKb25Yu1xeHqPcir3f7/gQmSboxLS7wEV0+s+ayN84kKddPs3chwxhOP4tKWV9anCfKf8/n42h52D3z9xMZFrEucVr75jwCXof2dekezuHoD8bF8E/wYmJ++EIlnaK6icJBDkkCmATZLph/hYI6CRPUOp7yxdwxBK+kC/8bBSsHmYq7zJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199015)(7416002)(8936002)(2616005)(1076003)(186003)(5660300002)(6512007)(41300700001)(26005)(86362001)(921005)(38100700002)(2906002)(36756003)(83380400001)(316002)(107886003)(6666004)(4326008)(66556008)(66946007)(66476007)(8676002)(6506007)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GpHtxvxOjp2yV8RHxoeenslBTf7D1/oe9xV5ol5f/N6yiOhr7ETa61rvfUG5?=
 =?us-ascii?Q?w73Xe/dnjOr4fQZQ0oXFxQESFeJV2IHhIL99fI0nbTvU050ZUjfR3oLcay9k?=
 =?us-ascii?Q?Y0+i8E9v2J2pX9dkyUQTpEMa6OsRRDjncclbmZi8zKYpjg2jxevlL3L01wnr?=
 =?us-ascii?Q?dMSte+XcZdqIm/S1+ivkZzT7xvydLo4lh7ENts4zOUZXVtIDEcYdYZM5anmV?=
 =?us-ascii?Q?jOGtgAr4Bw1lqYd2T1ijoWOih3iuBL28FcFoLyRO1o8fBOBJSIVo0S0MP9/g?=
 =?us-ascii?Q?VwJnaxLNIkf33nKfn3RWnsXsWapA0qcJk69dUpA2ntdNrFufvpfjghY/TSBo?=
 =?us-ascii?Q?jJJAvKUq+qbgmPLbZiHFP/cJcem1yWqgNl+AtYyti40I24kx68pbJtqNjUzw?=
 =?us-ascii?Q?6GCms1RBcJCz2/uNbLqJ7ZgKvs9dhBfzKRurw/8x+7BytCkKD7wp0WnHw9tY?=
 =?us-ascii?Q?SVE6kqG578w0ngMFhstkjZbX7C6rLp2zJ/K9jP9nMaiNfIURczW9VGeCJw6/?=
 =?us-ascii?Q?R+CSArH1sOlOeTbkZTbbpwRgqfKyFIpm+ZbSJkmk3pRwUDvL4WckHZLKNtba?=
 =?us-ascii?Q?YNf2gCR8Di+5Z0/GYIjNDKd+iHoZlu9iLsF5DSTvIGI2szsGhPGjXosOnU7w?=
 =?us-ascii?Q?NTlltq2OTHlijlIEpumGJ5jbuVreCLu77EWN4WoECGOZeFGJ94ag4WMnO7W8?=
 =?us-ascii?Q?cw2HLD8g+MuL/+jimDoK0DMSSeLAX6DOLsXjrs0kXXVKoFeSR9BeKdmXDzHv?=
 =?us-ascii?Q?++uPuyX0z7Al1Lv8xpqNKIELe1JWqpxhYC01aghENDhs63yfOppymeAUhfdn?=
 =?us-ascii?Q?WTdZPApNj0FmzWhEkn/kM5HbnZIbGOWlLIVn/zHHmEskDBvyeupEJmsQkSCI?=
 =?us-ascii?Q?bDhovTnROnMmFVV+8doRGFs3I5m5KWZVfx9XQBjjexg/ndIP+cMgNxlTJn+P?=
 =?us-ascii?Q?AOLpZQYACAlPBnfLm1S1TA1GarJt6DnV6sEJNoNKLlRscdnYtP1UVZwWXhy4?=
 =?us-ascii?Q?fsqMLLKPsE5XLg3x/fF9sYtfjJjvxceV5z6joobXRNR058AllRmb6MdUT2te?=
 =?us-ascii?Q?86umAkRQxMIQ7+YZWgctCiqnoIWxMYjAwnuMYs6K2/+El2pwdC7WFObSrCYr?=
 =?us-ascii?Q?Ok9OuWBz0NmMsJI0Rw52sAxU7h4BLn5TmdbN+EFl8B/ckB5cpgYg7n9Q1VTO?=
 =?us-ascii?Q?S9EEbkunpm+KYhLNtEXSQ8ld5vuiwNNjr6MMhb0aKOKlfb8y+P+MEyM45WwO?=
 =?us-ascii?Q?nSc26WVQ6rBG8irGpxoJasHWC7EiSTYThVopFKTtL4379iMRQ2C+QkUmJCZ6?=
 =?us-ascii?Q?dXE1o5FTkDqNen+dUSEKRITzY11zi5wmE9rp1tum2HF3GAW2F7r3+pCkZWcp?=
 =?us-ascii?Q?klQc5GTpOvz+ZKco5/TQ5MpIcZudCxY38PsmnaHbS5ml0zfw6gk/m91cE4Dv?=
 =?us-ascii?Q?PApABnUEEybtWmvkDO08fnMjtu2bd2n1YLKFr8u+PK0LTaUoUHZiuW/OcJ23?=
 =?us-ascii?Q?I2PXhjokrmIAFF+c4T6lBETVnkqbDcJY4km9jRyFcJqDgVzRLi0eaEyAjKwH?=
 =?us-ascii?Q?8hEJGCYfgmmZnGWH7E0dHM9JrrXFzEZr/I4gEoOaXpThC1dqVBlozJ5vuUdc?=
 =?us-ascii?Q?4g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78e65c10-a66d-4dcd-c67e-08dab7a898f4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:19:57.6632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uP3K0yTq/h7G/A7c0BzmmVEO3c2GW3z1XXonxLFR3ddW1qiT1z+TNX/me1v/qV/7YlboftG299ZnKmf/Li7xNe2KHpqueaUO57A2YR0F66o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5117
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-GUID: bCfK1Uw-eqSyB0xW1iBvE9DYX7_Ze5zl
X-Proofpoint-ORIG-GUID: bCfK1Uw-eqSyB0xW1iBvE9DYX7_Ze5zl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes the following issues with the reservation status structs:

1. resv10 is bytes 23:10 so it should be 14 bytes.
2. regctl_ds only supports 64 bit host IDs.

These are not currently used, but will be in this patchset which adds
support for the reservation report command.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/linux/nvme.h | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 050d7d0cd81b..3ab141d982d1 100644
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
2.25.1

