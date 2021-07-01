Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BCD7C11F64
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 19:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2078F61411
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 19:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbhGATL2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 15:11:28 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:57180 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229967AbhGATL1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 15:11:27 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 161J7Hbw024709;
        Thu, 1 Jul 2021 19:08:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=dM9IDBOkdB4PwAvleZHyVISvQBMUCss+4o6UflA3mDQ=;
 b=U4smXH2d11DoNO/S+uXV+5fX62vb8Ue/+oZrqkK2VoMzk0UfD0Rga1ZMb4agt5kc1Ew7
 NYBzZle8GKIyd1ab1kwuCir95BKp3lJI27Hqc91KeJ0sDYbrbeRsxKKnWA4FlmKuJ0qN
 zZLF7CRzTPGzI8zG5ZdZ764h8fQlMwPeyF/qomoz1qtIpTy65YICUzW2JMmK4iZbTsOK
 OYcUZVypFPZeziHaUjGHhbnXvZjxlBhqLvw3BWKm+fr4OSDe5rmCIbKyhdzWgbA0TUWg
 +I9BRKzweC2zT5mTvvVMwCdA8EMlvanRsBUy67ZI3E6yV9tY9UgPe2G5aNmp8gTW29TY 2A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39grmau78t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Jul 2021 19:08:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 161J62ds159117;
        Thu, 1 Jul 2021 19:08:49 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2168.outbound.protection.outlook.com [104.47.73.168])
        by aserp3020.oracle.com with ESMTP id 39dv2b1f69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Jul 2021 19:08:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RTlxgvBhqA1xjgsesOhMvqUO6cdgqt/TPDZCWw6Zz30pld0+NjXxXA1TO0BEoTkFUlR5hiZzVIvyQuk0wtOzc2boQRgbu03UH/DHx8+3abioi0VvT1tyNFlZwxucoNHTAYyM2u+/jdxoy6+POmzbLLKCSP3S4VgQPHMM+4XknBotWpHroZnaHy0luJORtHQsUn+g1Li+haFWdtq2SN++45t7sWFxKu5kQIy/xqPcL8IYhmR0qnUSjUHXs2APGExXwwcsFd1UF4druHtVxZitYbwqVD2mMLhFgLBgRnpGIf5V6IE2KiGmM9iqEX1ARy21xgVTackMo8QguU4xk73EeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dM9IDBOkdB4PwAvleZHyVISvQBMUCss+4o6UflA3mDQ=;
 b=a+ssJwmGe9i2OQ6DeOwldRKhyNuuxX03xlh6v4dUnA1emY65W7Cxc5+N22a5rbLATkj4ue/FEmJSb/2bcey7DlLVLv4crXJng94Rwafk9kNrdzJjuo7482SSGvzNImRAU1tUJjCT4tBOkguWpU4Vudd+QDIfTPe3sbjRUf/LOOmkbNu2DL9mV6H1ou0XyIvw9Vn/vFDSugkdZhr7kbHGme9eFMziBnEXAqR0P9DdGIJ3x6ehm3I3T7vTyNyFfamDQCv8xkx3SjWpDyN79JnN4PCO+7k3foiSAPPgSNq/DKKB80sMz8vbCWkXpVZ9vG46oKwfTRgNs83TK7DrIEYlgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dM9IDBOkdB4PwAvleZHyVISvQBMUCss+4o6UflA3mDQ=;
 b=dJ9JvC/+tsWdJyUrEWoeNkLepcsqM3+Vg6aXtm0hZ80liAcot1ZDAS1oIle9BvWXmhd6REIp35JyJDqKhHsCahMwRC9fQ6xcvDCrGONAWeq3PWo8+vAHeG0ntzC7vCKijL83o83lyTn23OvNMzvlgRbs2hF6OKD6zFsWNGx82NA=
Authentication-Results: mail.ustc.edu.cn; dkim=none (message not signed)
 header.d=none;mail.ustc.edu.cn; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4461.namprd10.prod.outlook.com (2603:10b6:a03:2d8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Thu, 1 Jul
 2021 19:08:47 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4264.026; Thu, 1 Jul 2021
 19:08:47 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lyl2019@mail.ustc.edu.cn, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] scsi: be2iscsi: fix use after free during IP updates
Date:   Thu,  1 Jul 2021 14:08:40 -0500
Message-Id: <20210701190840.175120-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR21CA0036.namprd21.prod.outlook.com
 (2603:10b6:3:ed::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0036.namprd21.prod.outlook.com (2603:10b6:3:ed::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.5 via Frontend Transport; Thu, 1 Jul 2021 19:08:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a123c293-6f2c-453d-fe45-08d93cc3a733
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44617EE3AEB71107837E6D83F1009@SJ0PR10MB4461.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yy1GEP4axyD6CG+bnrcqM3k5BRRnB9ShJXJw3eK9dEBAeZ1q0jv+rhu4LxMFd8qvM9wPnq7uNxx4o2sLQyIUEzXXYFZDmjfa6+wpeGv+Ievm3Rd6C+JrM2P/eW/fXGxdP+fZvBziRVXrBHBWVcVq+WomApW1SqqdOoTsLG57SOzCEQBT3/lqTJwmqZOdvrrfEBdv8K9g2MdPQ/FP22f3Pq54kiPToc6uIpNhEglQqlMrJKExAGgl/yJmBGijWtv/v+sJOYvqgEzakQZM9Jc4pWXTFCwyN9iA7+dWbG3odT3prkBPb6B1k9yP3sn59mQImPaKQLgRa+2QQnF5sMa/cgSlHy4kXJ9anQxJBMLJb6BBVoO72dOd9bqOGv2oTfaWvMM7Q/Wv20Cjyn9HfeAPQN8pykvb53GapExP8/bOriLw8cCPjFqAZUWBGYwQHaTjpr47i8j8K2rbasK4eZofcgrknmgroPZCDTQ/RVPGqIvxGyeRI8aABiyUCs12QhFSayw6kIhBNvcZUoSOs6x/gE87JfVkLn3zCnMJNxZiN4naNUgihj+GtWbFCrZQhdliHb0jP325Jbo3VPO2Dvxn7/9XsuWGt5CKtRWho2HXb2f9oFgbteyJJw9IV0nmv82XlW7grh4cMvD14m7Z7irinJp0Q8fqOzHec/X3WgzYS9vOdAkoHVidlk04lSHj/yvhf41K5aeUyQZPaZsaw2LhO7gfNRVbW+5ldjateQtOc0g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(396003)(39860400002)(366004)(6512007)(52116002)(107886003)(8936002)(2906002)(6506007)(26005)(4326008)(316002)(956004)(2616005)(36756003)(6666004)(66946007)(5660300002)(86362001)(186003)(16526019)(66476007)(1076003)(66556008)(6486002)(38100700002)(38350700002)(478600001)(83380400001)(8676002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X+2VG0GFQf6gl2JH3tALG3OLYZKcVJFu5KW+3aRIV1ULs8o0eDrrWt00KTZ0?=
 =?us-ascii?Q?WFemQwZ0SxAoYS1231IOV7qav3VXEQQ5TBkxJdFBxaUPigp160H5tTrhVPX8?=
 =?us-ascii?Q?eQpA6UyhCvl0jlapnKh6mGtuL+IuBYQI9hOwkn+rL1YvearvbSSPiXJT0zGX?=
 =?us-ascii?Q?921y2E5/fKalum0n6hOcoJQzQeqSwmwZcH6VGB49obwRVjIuVs83mNbTFvR1?=
 =?us-ascii?Q?OBHdFKtD1IiQMAXJeS8SRovR+6JidmUGS5VttL4sXK96343m+f35y4sydXpy?=
 =?us-ascii?Q?U5BXL/MwLNcZni3kPx+AL4kwE4hXSN9BELCcS32bg/GAK5gONX3Q8eXbdRUB?=
 =?us-ascii?Q?pcCrR7KNAJbqlkKEPBtmaouelgUxwQXCXEzRtY/xONqtZPYyESz6KNGWOPJH?=
 =?us-ascii?Q?diYoWTDUMom4Zd50OU7sRR/YiOKi9g3oqM0jTqbn+TOJkzCMf8bGeUbg2TXG?=
 =?us-ascii?Q?ZOT/ZyDoABEceHhtLnC+9+FQ6BjpBUax3ocrmd0xAbGtFHFQywI010YoY5Z/?=
 =?us-ascii?Q?ZvMdfhY3Dvtk0mSSE6wr97QCdRHqh4SSTfxMV1vhJV8PVNRhOvCmq+pMnnWv?=
 =?us-ascii?Q?HpkTLdhfLI1mh7kNfAiEx9KFE9kHkTU58pnoLXK903gzW8+R+Itt81a4+4ro?=
 =?us-ascii?Q?rA6kLMfeK0RvQ/JFPTj56J8JWF487GZRrqfbSVDYKcpyXA5NjKpHynJeNg0v?=
 =?us-ascii?Q?9XaUu/2ZN3cAYzWKC65RM1krAcMQIRM4V9pXDxtn1KlOOUKnAalGznSsqGmL?=
 =?us-ascii?Q?ei1Xjyc9lTg24woYLa+XgWvUGceVjeqdd5iE5QxzgcCzww3zJc0wb8YaA1qt?=
 =?us-ascii?Q?x1n7zeEiVWGZi200gdDHtYlNdcOIEi5sX1KNQxPEduoqnI2DV2pL2CYrzBP4?=
 =?us-ascii?Q?rGe5lgx/2pG1rv2MfP29hM+DGa7chn/j/Jn9STtedUrHTcwxinYv2CQ0RVo5?=
 =?us-ascii?Q?S5pvsMD6afx6qACc4Y1uD1XGYA3om7qpyt8zIyvyRdRe1HfcjRg9k4P3J0jt?=
 =?us-ascii?Q?NOHkjHqd3I4Igd19C9iyWM1s8cN3G59KEzIQg73t7qLXNXqW16oFdfmtebIQ?=
 =?us-ascii?Q?YR3C51UkQe40Wwzw91GcIMXJ9JgvqmLAhqC9gh8qaxcO2qqEDBXlneaHVTar?=
 =?us-ascii?Q?XxQgbhdu5gln00T3lYtW2KLb+cOicMCOL9O8ii+T38wVFkj+YUml30Tv+3yd?=
 =?us-ascii?Q?S2pti8A3IxEh2/GkMntgiiM2voPvxZ2+tSABtVMIvpEQB2wd318XtOcqVUne?=
 =?us-ascii?Q?vo6ww0UhHG65tdIdrgkvsNWovCbSQ9wKOX/LMkCKW1swKQ947bLTIQy9IjnB?=
 =?us-ascii?Q?/GeWs/2QvMSaTOmEhpPPKnQr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a123c293-6f2c-453d-fe45-08d93cc3a733
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2021 19:08:47.3646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VCPkeUB5+W4UnDuPRl2s9cJ9SEnE+9gHbhMb1xPXDdJPks7WgdmByLitKaiipDwkM5PMXX6hVznpDztrN9WRVJoPZdzsxtN28QCbOVFybQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4461
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10032 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107010112
X-Proofpoint-GUID: J-X7q-st8u4rwzqABWYICJpzldY8d1qA
X-Proofpoint-ORIG-GUID: J-X7q-st8u4rwzqABWYICJpzldY8d1qA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes a bug found by Lv Yunlong where because beiscsi_exec_nemb_cmd
frees memory for the be_dma_mem cmd, we can access freed memory when
beiscsi_if_clr_ip/beiscsi_if_set_ip's call to beiscsi_exec_nemb_cmd fails
and we access the freed req. This fixes the issue by having the caller
free the cmd's memory.

Reported-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_mgmt.c | 84 ++++++++++++++++++---------------
 1 file changed, 45 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 462717bbb5b7..4e899ec1477d 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -235,8 +235,7 @@ static int beiscsi_exec_nemb_cmd(struct beiscsi_hba *phba,
 	wrb = alloc_mcc_wrb(phba, &tag);
 	if (!wrb) {
 		mutex_unlock(&ctrl->mbox_lock);
-		rc = -ENOMEM;
-		goto free_cmd;
+		return -ENOMEM;
 	}
 
 	sge = nonembedded_sgl(wrb);
@@ -269,24 +268,6 @@ static int beiscsi_exec_nemb_cmd(struct beiscsi_hba *phba,
 	/* copy the response, if any */
 	if (resp_buf)
 		memcpy(resp_buf, nonemb_cmd->va, resp_buf_len);
-	/**
-	 * This is special case of NTWK_GET_IF_INFO where the size of
-	 * response is not known. beiscsi_if_get_info checks the return
-	 * value to free DMA buffer.
-	 */
-	if (rc == -EAGAIN)
-		return rc;
-
-	/**
-	 * If FW is busy that is driver timed out, DMA buffer is saved with
-	 * the tag, only when the cmd completes this buffer is freed.
-	 */
-	if (rc == -EBUSY)
-		return rc;
-
-free_cmd:
-	dma_free_coherent(&ctrl->pdev->dev, nonemb_cmd->size,
-			    nonemb_cmd->va, nonemb_cmd->dma);
 	return rc;
 }
 
@@ -309,6 +290,19 @@ static int beiscsi_prep_nemb_cmd(struct beiscsi_hba *phba,
 	return 0;
 }
 
+static void beiscsi_free_nemb_cmd(struct beiscsi_hba *phba,
+				  struct be_dma_mem *cmd, int rc)
+{
+	/*
+	 * If FW is busy the DMA buffer is saved with the tag. When the cmd
+	 * completes this buffer is freed.
+	 */
+	if (rc == -EBUSY)
+		return;
+
+	dma_free_coherent(&phba->ctrl.pdev->dev, cmd->size, cmd->va, cmd->dma);
+}
+
 static void __beiscsi_eq_delay_compl(struct beiscsi_hba *phba, unsigned int tag)
 {
 	struct be_dma_mem *tag_mem;
@@ -344,8 +338,16 @@ int beiscsi_modify_eq_delay(struct beiscsi_hba *phba,
 				cpu_to_le32(set_eqd[i].delay_multiplier);
 	}
 
-	return beiscsi_exec_nemb_cmd(phba, &nonemb_cmd,
-				     __beiscsi_eq_delay_compl, NULL, 0);
+	rc = beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, __beiscsi_eq_delay_compl,
+				   NULL, 0);
+	if (rc) {
+		/*
+		 * Only free on failure. Async cmds are handled like -EBUSY
+		 * where it's handled for us.
+		 */
+		beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rc);
+	}
+	return rc;
 }
 
 /**
@@ -372,6 +374,7 @@ int beiscsi_get_initiator_name(struct beiscsi_hba *phba, char *name, bool cfg)
 		req->hdr.version = 1;
 	rc = beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL,
 				   &resp, sizeof(resp));
+	beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rc);
 	if (rc) {
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
@@ -449,7 +452,9 @@ static int beiscsi_if_mod_gw(struct beiscsi_hba *phba,
 	req->ip_addr.ip_type = ip_type;
 	memcpy(req->ip_addr.addr, gw,
 	       (ip_type < BEISCSI_IP_TYPE_V6) ? IP_V4_LEN : IP_V6_LEN);
-	return beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL, NULL, 0);
+	rt_val = beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL, NULL, 0);
+	beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rt_val);
+	return rt_val;
 }
 
 int beiscsi_if_set_gw(struct beiscsi_hba *phba, u32 ip_type, u8 *gw)
@@ -499,8 +504,10 @@ int beiscsi_if_get_gw(struct beiscsi_hba *phba, u32 ip_type,
 	req = nonemb_cmd.va;
 	req->ip_type = ip_type;
 
-	return beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL,
-				     resp, sizeof(*resp));
+	rc = beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL, resp,
+				   sizeof(*resp));
+	beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rc);
+	return rc;
 }
 
 static int
@@ -537,6 +544,7 @@ beiscsi_if_clr_ip(struct beiscsi_hba *phba,
 			    "BG_%d : failed to clear IP: rc %d status %d\n",
 			    rc, req->ip_params.ip_record.status);
 	}
+	beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rc);
 	return rc;
 }
 
@@ -581,6 +589,7 @@ beiscsi_if_set_ip(struct beiscsi_hba *phba, u8 *ip,
 		if (req->ip_params.ip_record.status)
 			rc = -EINVAL;
 	}
+	beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rc);
 	return rc;
 }
 
@@ -608,6 +617,7 @@ int beiscsi_if_en_static(struct beiscsi_hba *phba, u32 ip_type,
 		reldhcp->interface_hndl = phba->interface_handle;
 		reldhcp->ip_type = ip_type;
 		rc = beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL, NULL, 0);
+		beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rc);
 		if (rc < 0) {
 			beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
 				    "BG_%d : failed to release existing DHCP: %d\n",
@@ -689,7 +699,7 @@ int beiscsi_if_en_dhcp(struct beiscsi_hba *phba, u32 ip_type)
 	dhcpreq->interface_hndl = phba->interface_handle;
 	dhcpreq->ip_type = ip_type;
 	rc = beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL, NULL, 0);
-
+	beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rc);
 exit:
 	kfree(if_info);
 	return rc;
@@ -762,11 +772,8 @@ int beiscsi_if_get_info(struct beiscsi_hba *phba, int ip_type,
 				    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
 				    "BG_%d : Memory Allocation Failure\n");
 
-				/* Free the DMA memory for the IOCTL issuing */
-				dma_free_coherent(&phba->ctrl.pdev->dev,
-						    nonemb_cmd.size,
-						    nonemb_cmd.va,
-						    nonemb_cmd.dma);
+				beiscsi_free_nemb_cmd(phba, &nonemb_cmd,
+						      -ENOMEM);
 				return -ENOMEM;
 		}
 
@@ -781,15 +788,13 @@ int beiscsi_if_get_info(struct beiscsi_hba *phba, int ip_type,
 				      nonemb_cmd.va)->actual_resp_len;
 			ioctl_size += sizeof(struct be_cmd_req_hdr);
 
-			/* Free the previous allocated DMA memory */
-			dma_free_coherent(&phba->ctrl.pdev->dev, nonemb_cmd.size,
-					    nonemb_cmd.va,
-					    nonemb_cmd.dma);
-
+			beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rc);
 			/* Free the virtual memory */
 			kfree(*if_info);
-		} else
+		} else {
+			beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rc);
 			break;
+		}
 	} while (true);
 	return rc;
 }
@@ -806,8 +811,9 @@ int mgmt_get_nic_conf(struct beiscsi_hba *phba,
 	if (rc)
 		return rc;
 
-	return beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL,
-				     nic, sizeof(*nic));
+	rc = beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL, nic, sizeof(*nic));
+	beiscsi_free_nemb_cmd(phba, &nonemb_cmd, rc);
+	return rc;
 }
 
 static void beiscsi_boot_process_compl(struct beiscsi_hba *phba,
-- 
2.25.1

