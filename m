Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91841C25B0E
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 01:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236262AbiHLBBP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 21:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236246AbiHLBBH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 21:01:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47D194135
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 18:00:57 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BN6Boi010965;
        Fri, 12 Aug 2022 01:00:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=RU7aQJ08CXuNCZ9nQecYARbikW4uJ4g4tOmLmpkuX+Y=;
 b=sSf7qH1jcN1VkogxrW+ZIsIPpCipYE5NGMNnAvPFOPLjc+ZtvBw0+8CcLxS+hrJQxv0v
 zdSolRQi+7gr0Mg3wI4MapjOlh+jJLH5PGgE3rV3SaS9lpQK8YCAIh8+p4/sE2ZPwI32
 V8M7nccApaRhKb341AmynsLFYfaqmDBYjVMAV3XFkPtqKdxO/iWA8Pbt/yXtB6h6Qj0+
 KCAHIl475ZSI61hKduJhKsINKvtZ9gGknVk2pbhqnXmWTsEc4T63xt2NVylFzS+JEmYO
 M3+Riiqu9oVRPFXAgDD/ppSQtzqqPZf5jGE/AvypokBradJwMrPyPiR7lYLyiusPJe1A +g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqgp256-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:43 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27C019dA019052;
        Fri, 12 Aug 2022 01:00:42 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqkmy70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OcZVnVU94tnbjPcU2U9CpQ9BtVrNGhc9dIXo8MACz8A+7tzQ74eHMfFn4jV0f6ca7z/7OkTj5NIlCAgd7LfwRhi2+I0j0IEdofLQFKqfuZe6gXERgDpRxsY+uLVDVN8Qhgg/m36Q88CjsbXz/9ozJiHphccR6Lg2COTEeIpc0WqzL8UXWS3vgttOPhjcvg8quH/Pti/tXmEsOgwjPDLJR2t0cEDgNLX9601tE81aWiKe8IaHz5G4Ld2QTm/lWH7gU9nFTH0+W0bIcVD3xqUrLHZSJBUtjxj00g627DtR5VSLPgIKKxMfJQzXL73syK/XveUccNTfW1vpovLnNvT4nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RU7aQJ08CXuNCZ9nQecYARbikW4uJ4g4tOmLmpkuX+Y=;
 b=Mu77Cp0lc2fqJV2niKd5MIQhHxiDU0SI1KppZaZnEfsHwmGCueERwsLW/g8XDELZIaufR822Tv+GLEXQKP0y/9g76xi8M2vLW9dPtGsPZp+nraBsXg1xxT/wE1FRLAmgqZUrP4RwDYWd8Wdevfbz9t63svDU5nf8orfoS+yMUV9GXqtSUHt1x5xyIEEHI5qblgP6dw3LuRH2PmzkfaAqzWgfNV9UeswV1WNojN3L+R0uGpxeo42qMEJAFHq2FMPwylewJBqmq4kceYUkDGi+M22vaVvt/ECGq7TV1kgEj8JyNuKdJ1ucRjIJu7jERm/MH7zUg4URAPQzEm4KjJWTYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RU7aQJ08CXuNCZ9nQecYARbikW4uJ4g4tOmLmpkuX+Y=;
 b=IQv0otmhBS3w8nj0HFQvhgpxzLqYSsq86Xwd27khHcplpY1aHGcFEJiKqwZjDWKIWqvXkdDFU3I2/BdqhiPpzSEvTBVu1lkP5tFkr+uNVzoJ+reV1Ez98RHWLh3jlsT5u9/exHTOhffMrasYL3IyWQ2X13s66rFoOHmU8HuBYZs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5386.namprd10.prod.outlook.com (2603:10b6:610:dd::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Fri, 12 Aug 2022 01:00:40 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.024; Fri, 12 Aug 2022
 01:00:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 08/10] scsi: Add error codes for internal scsi-ml use
Date:   Thu, 11 Aug 2022 20:00:25 -0500
Message-Id: <20220812010027.8251-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220812010027.8251-1-michael.christie@oracle.com>
References: <20220812010027.8251-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0022.namprd05.prod.outlook.com (2603:10b6:610::35)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5a21c63-e9e8-40dc-d87a-08da7bfe136e
X-MS-TrafficTypeDiagnostic: CH0PR10MB5386:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BPiwcU41dlqolIIkI1WIU2nOn3iY3pYhtW0dwzbug9Kc1lYWa2aAjoLB/RaMJApXozAD7XAvmACIs4EZ47rqnO4PAue1/aOTmW7pd+l58kGPoX3ZHFU1u1Hw08wvTw661LpbNp5+o3y1ZaG4AHaA7bLQZaSCbb8viGHpdW/L8bmmD0hx2pMWepUf9fVeGWQQ5lnQdH4fAgCjnvJok8jlgTrtIdGT99voBqNXP7JVS7alVAcC17TWL2F3A5fuUfI0NByycOd9FAYsUTfCbev8GrJFR9nIm1bOdb2XiFOshKKsMJdqG9Q/QLk7e8otOhSo7GkASHgtZfF88FBIdNrlkBoYX0s6RxeBpswGsyS3bAqBpvW55C1Og3ZmLcG4T4d4P9BWahwz3KCk+DAElYACajAOLreKALC3jDRP2HBz6q+Q4xOGOvVXAer2Z3yzftIfBWLtXsEUUk6E4VIUA06f/FJ3k3bfx8xPg0gkpdwLB0lG2s13ih8GDwvsTju4sM6SobM4c5SaYVw/UlC4nd1Ztok8ZLnN6zU2FqoMxu4lC81P6S0RU1HEwHrJoEd7gsfsLsLdEMK3CNqvZjNuSOxd0HXJ4fRQuXnnCwCr0vz0Fo4SeYO4AZISE2MYUbTEpost+EeRC17EdPXm8v4/cqcbZogq0U5CFMjn9jVhmAa4Z04FEcEG/WhZAyS4LY6oSU7RZC6XKonyIYEGivo8iWK5sEXM6StJVd0zrgxsYohYYlbzJU476oMmNFQOeGW/Xx60XGnhteVq5dGAFtpCuMS9GTcL+bmXtBwIGw+KSoRm1is=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(346002)(376002)(396003)(366004)(921005)(2906002)(38100700002)(54906003)(83380400001)(316002)(4326008)(8936002)(8676002)(1076003)(66556008)(6512007)(7416002)(186003)(6486002)(2616005)(478600001)(41300700001)(86362001)(6506007)(36756003)(6666004)(66946007)(26005)(5660300002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w4Hz/tJXHGvEIuH+KDqR1x5pLfQ28lp+HIvUGtzE/nvqFkjqvvTh8lU7eM/n?=
 =?us-ascii?Q?MzW38XgOP8cDgX25LhosIRAyj5IR7Kq4t9qVlWGVEvrgfw6ihU9cQCKGbeYa?=
 =?us-ascii?Q?8Gegg4OJgzpddJcZSxapEdYK02PfInq8xziNz78SObnSYJKSs/Yye1rez9/m?=
 =?us-ascii?Q?8144pf4QdAYYpKlN9X9tJK8F69Qr5erA/kURCzcYQRgRQLjbuyLSkHsJFoBQ?=
 =?us-ascii?Q?d1ToyJyunmHrAuQfpTFbcI+Ckp/3Rdy7jQldngzDp7YeDKJpmk+0+SUKVI0M?=
 =?us-ascii?Q?HDKoZ35RKvlbITmpEalnt24Vx0ZPLkM1Om5xFoZnACme8gv9Sbvm/iq/N6ae?=
 =?us-ascii?Q?E63NKimQKls/z3MgWQzZM2lVSWD3aMjCM/oq1mwjmieGN7Tr9QCY2W1/gZJV?=
 =?us-ascii?Q?mLqeHa4RNUP7mzG9wV3PcHIiE+NN5FXQakuY6c/xAhj7y//IfzLhUmMjGURu?=
 =?us-ascii?Q?XAG/HQtF6UVVFc4u5SOVLJ0AAHbJwtoOCVWa2xZBXltFB/u3BssHMgzPM7Tb?=
 =?us-ascii?Q?g6L5C6hUIqk4dfa6If5H/JHw69S0gItbbk8QxdqsJqbNRcMlenWu2bzDc/FT?=
 =?us-ascii?Q?ZMl993/qUYhv35l7lcKfgziPU2bFoqTd2HiUfg8nLSYYHiI/CHOGQvV6yGe3?=
 =?us-ascii?Q?3JRQNI5G5RenngZpN2rvuoeFNB+hZ12btRjabWtDz8P0P9qy4REIy5vT4pPh?=
 =?us-ascii?Q?o/hGsMbe1Sn3gF7h/XOA9skQlapkR9emb4CLG9Y92v2oYWuDGiEbH3jhlulc?=
 =?us-ascii?Q?Jcqp/FY7SaJp/+hvMVZSUmhtatpYmGke5UzN7HeSjic4XeGONf+RK9vR7rA1?=
 =?us-ascii?Q?ua4E4uW91q0C2i09ATyBp0FB0G59nCt36DQmnOjKnyTbSufwSpbE/77pfi7i?=
 =?us-ascii?Q?sGQMJjY0Lw7Nm9y86rwC0lyzvY3VQOEL+L0RlWC8weEE97ym8vlyTlTJHi9L?=
 =?us-ascii?Q?htWCyd4H0fsDsc/8i1JT1F9Jn9NeBVqCwj5GLjV/c1wrZnLrlPwbNyTvIsGn?=
 =?us-ascii?Q?p2XTRjTbDfoKYCdhgCAWGk09+gjYLUjGeuaT49gfm+xre+rGTI4aTwM9Y201?=
 =?us-ascii?Q?+jB4QPuDoOlgNo9Ebos3k47jf+Ie+gVHjNDEbK8jbKCuiBW3pvoTjTYD66kX?=
 =?us-ascii?Q?7hWlBOJMjkvu4yOg7ryWLwS+nPKkooBsHAM2awm4SJz5sDgoVEaKcgjcRb45?=
 =?us-ascii?Q?X2KKP1EVa/gHXJ+0eIsk0Mw1AvEaL5G1g36YtK3b0Vafl48UKLXevOQXGSKn?=
 =?us-ascii?Q?6ee6nRbUWL/y2T9Q3FKXjD7yeBZtl0/4EYKt9bAxSpoceZQyvrfJDvzHXuEe?=
 =?us-ascii?Q?diuwh+kHmEzxyfzz13NyIzRBW5u6um+IyE4GrkJ0NbLRJo+kMgPNAtwMLwYu?=
 =?us-ascii?Q?JCOV6Wn6D86iF28lQClYfJmF9PXx+ubu5c1uEWKs10EZ4uCjnkd7+Nod8R82?=
 =?us-ascii?Q?RjDRl4F5VlWPA37zHvie5XZ6ty0+wfwBX2n+df3AjJhBV1wEC7Qz9TofQwLY?=
 =?us-ascii?Q?UmCtGfkac4ErkArOFAiHmOc+hShOqC4KG6miTcqrtM6+yBaFrJ3dcAPaR38z?=
 =?us-ascii?Q?Stkdha7ecBbTTrj8Ca94vfPct5k2Eicp+eBUp9PVVXpjyW4HfmUuJ8FZ7XV4?=
 =?us-ascii?Q?uA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5a21c63-e9e8-40dc-d87a-08da7bfe136e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 01:00:40.6162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: to9mKKD+VTyQ7LuheblS15PKidQtNJT3Yn9PrJJVW+S8pa/ZxUJGCVnGy/vU+DR9KTb8u8Mc9zn73IbeEChb1sxKaIMFTBB0tcbN4KsfTm4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5386
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_14,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 phishscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208120000
X-Proofpoint-GUID: 398SZF5r3N3NpEovecD_gaesQIdq2tG-
X-Proofpoint-ORIG-GUID: 398SZF5r3N3NpEovecD_gaesQIdq2tG-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a driver returns:

DID_TARGET_FAILURE
DID_NEXUS_FAILURE
DID_ALLOC_FAILURE
DID_MEDIUM_ERROR

we hit a couple bugs:

1. The SCSI error handler runs because scsi_decide_disposition has no
case statements for them and we return FAILED.

2. For SG IO the userspace app gets a success status instead of failed,
because scsi_result_to_blk_status clears those errors.

This patch adds a new internal error code byte for use by scsi-ml. It
will be used instead of the above error codes, so we don't have to play
that clearing the host code game in scsi_result_to_blk_status and
drivers cannot accidentally use them.

The next patch will then remove the internal users of the above codes and
convert us to use the new ones.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c |  5 +++++
 drivers/scsi/scsi_lib.c   | 22 ++++++++++++++++++++++
 drivers/scsi/scsi_priv.h  | 11 +++++++++++
 3 files changed, 38 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 448748e3fba5..d09b9ba1518c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -514,6 +514,11 @@ static void scsi_report_sense(struct scsi_device *sdev,
 	}
 }
 
+static inline void set_scsi_ml_byte(struct scsi_cmnd *cmd, u8 status)
+{
+	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
+}
+
 /**
  * scsi_check_sense - Examine scsi cmd sense
  * @scmd:	Cmd to have sense checked.
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4dbd29ab1dcc..92b8c050697e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -576,6 +576,11 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	return false;
 }
 
+static inline u8 get_scsi_ml_byte(int result)
+{
+	return (result >> 8) & 0xff;
+}
+
 /**
  * scsi_result_to_blk_status - translate a SCSI result code into blk_status_t
  * @cmd:	SCSI command
@@ -586,6 +591,23 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
  */
 static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
 {
+	/*
+	 * Check the scsi-ml byte first in case we converted a host or status
+	 * byte.
+	 */
+	switch (get_scsi_ml_byte(result)) {
+	case SCSIML_STAT_OK:
+		break;
+	case SCSIML_STAT_RESV_CONFLICT:
+		return BLK_STS_NEXUS;
+	case SCSIML_STAT_NOSPC:
+		return BLK_STS_NOSPC;
+	case SCSIML_STAT_MED_ERROR:
+		return BLK_STS_MEDIUM;
+	case SCSIML_STAT_TGT_FAILURE:
+		return BLK_STS_TARGET;
+	}
+
 	switch (host_byte(result)) {
 	case DID_OK:
 		if (scsi_status_is_good(result))
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 429663bd78ec..2b9e0559ddcb 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -18,6 +18,17 @@ struct scsi_nl_hdr;
 
 #define SCSI_CMD_RETRIES_NO_LIMIT -1
 
+/*
+ * Error codes used by scsi-ml internally. These must not be used by drivers.
+ */
+enum scsi_ml_status {
+	SCSIML_STAT_OK			= 0x00,
+	SCSIML_STAT_RESV_CONFLICT	= 0x01,	/* Reservation conflict */
+	SCSIML_STAT_NOSPC		= 0x02,	/* Space allocation on the dev failed */
+	SCSIML_STAT_MED_ERROR		= 0x03,	/* Medium error */
+	SCSIML_STAT_TGT_FAILURE		= 0x04,	/* Permanent target failure */
+};
+
 /*
  * Scsi Error Handler Flags
  */
-- 
2.18.2

