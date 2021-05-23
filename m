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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52DD8C4707A
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3178861205
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhEWR7j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35768 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbhEWR7e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHufLE120977;
        Sun, 23 May 2021 17:57:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=B2mP8b3Ak3kQ7jk6jUST18rXQme68Ec7MLUj4/2MPjQ=;
 b=KIpQiXehgqrNdIdeC1vTy8cInGYhU5BhngUTFKI+GPrmPLdyAW5cERBPGKx3cEmp0ADP
 +1maI41pByaErph6puridXXO5LpiJ/4yIqyCBgAfyyrKub+pjyOSCXBr77XbZxkO2tG6
 WjqDmaptuzrANxzLo7pkwzPA2G27jOyq0ntPVznd3H9d7mVz60H2vndaGGww3sFINI7s
 XAULn5jgA98S3iENt7hin14yu77au47wTX0gVlhqrdIXb3yRaPxvE/KicrtpM+31wnjS
 4782u+RgVZ6y/e8FCXYewk2QQ8QrW7sFfRGsIv79vREMv1KD1kj1SVZ9eyaxtW0lZsGt Hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38ptkp1erk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:57:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHucLQ161902;
        Sun, 23 May 2021 17:57:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by aserp3020.oracle.com with ESMTP id 38pss3qbd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:57:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6pZaDH8ewruiMdk/E+ulIOHWEMt2znCkvYrP20I+a9nx/F6LYanpcfWao0SN7Y8zh/NzB1dcHM52EKBNR3RWCss8wN74S0mk70O0/oWSy+fLkeLOv3ils1ChoGcL6Atr2Td2tZreeU9Lec6pCLZGOhwcAtD+FYjokVwEQ9R9/vdQiAbo1lw6t03PngkrcDb4Eu6l3Jg+AZ7FXrXjBrUogUYzL3N3Qz7MZNsNDJgEacswzu0Y/lCGN5aImh7L0hyDamkjX3jY+rU6o1vlo/6nZAOlSkbUkhxlDCO2yy+BtsH2asIsedsYDYo665hgd7a3Wuwq4+X162HW15o73lElg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2mP8b3Ak3kQ7jk6jUST18rXQme68Ec7MLUj4/2MPjQ=;
 b=LOOAEwY8kBVqzDdSZJ+nfJlSxubFsevTLBtrei9jNJQvN1h3SQjbRhJMtlanVjDTwpSLzch2bAaVvSxllL4V5w8r8TsZVRXRXKg6fQP24AF7OZw7HTRiXjCxim4hSu5k+cMfFnS7p5pEpo6/sq5qPXdUmU/CB2D8OVu6IMeqCX73ZP7TBM2pmyY01R4LL+I2iAlzQcPRnLVFiSiAalieqsiq1PfZCo+YsvolEfNvWOfnuChASZz2aVarJ62CX+emATVe2lOdhEue92ICEczm3oHilZ44Y3i89Bn//3UzhTOBF8Yzm+TKiTopsRhSjOwTOGcL0xAb79IMHt4km1OVnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2mP8b3Ak3kQ7jk6jUST18rXQme68Ec7MLUj4/2MPjQ=;
 b=Xp6cy5ogfLt2ZghmrZtOVC/LUwGYVDkJCovafdx5beOgdNeArl6yTcBYJGJss0mTQLMkAyCOaq1uisP6cgmIr9xk6u9y7Trw5l8m8MB8gbS8pAZfp0tyb5CtcY7fzHcbCYMhjo/HovxOMOFB3mH09hIRJhBLBW3SfX6EkSIyEN0=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4004.namprd10.prod.outlook.com (2603:10b6:a03:1b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 17:57:55 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:57:55 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 06/28] scsi: iscsi: Rel ref after iscsi_lookup_endpoint
Date:   Sun, 23 May 2021 12:57:17 -0500
Message-Id: <20210523175739.360324-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523175739.360324-1-michael.christie@oracle.com>
References: <20210523175739.360324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:5:40::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:57:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8c4e8b5-e860-4bfb-5f5a-08d91e144ad2
X-MS-TrafficTypeDiagnostic: BY5PR10MB4004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4004748C9B912C9FE4FED0C5F1279@BY5PR10MB4004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H5u6l+hfcJ+XAgoPwRr/V0aYv+0Twy0v30rV5h8iEayZNeiaK53QhdAO8ZZOD+oTabeOASfL7ZKmjCfAHTilzxKA33VAtMLY06pKrJK1ho/aGsnj6NqyL+LK9NH5F7L8IhYokfnPVaJ65cvTpMhYUn39XIKuOFy1u0he7qetz/p7VVrUbFNLiKs8r/w0lvuJguYvUhMd5fbd99PTCIRVk6NyipWjzVdRq7N4enLiIcTOd/TqFcUfLZDmycvdiMl0W/01xB3WYstKV+sQo5SG6R+E8z9jvwYjOgCUgOLABmGjumLkuOG1IhquaWbFIwrYEO5phlTeQgyGNrvDapZsOYc60MuoZ2UTiqKQHtFXNx6CER1GW5vBpsE/XYhAYsanIq/ahZT4j2ReqIOou0gSts8MBRVN6YKdP3nzvS0S4svoWsog6zxP1zNCP9r1kLZ1QyWF355011sDouPq9ZqSgHipp88BrjAYwOXn0rQ3Fvb6m3iFVsXP6qnklvb+jfj6XzigjFViJgAtBc1kIMbVeUN2C6bNf0Dr/XeB48SV7uxdyeyyCtzrZ7a68c1RD8dkQ0vYAxPwvKBhcnBu5OrTywlYzr7AEpjymDIJ03/BL6jBFanUr0bDKvr/Jp6SrTXx/zA8OEThnfJfiPwi8485cc89KR6eyIo11SBJcu0jD0/EwXcz6LbyGom8TTW4ca7s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(66476007)(66556008)(956004)(2616005)(66946007)(16526019)(478600001)(36756003)(2906002)(83380400001)(30864003)(86362001)(5660300002)(186003)(6486002)(26005)(4326008)(1076003)(8676002)(6512007)(6666004)(8936002)(38100700002)(38350700002)(6506007)(107886003)(316002)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QJXL5RXhjxDlLroJTaYesGPtWBPVdOXaEpPCoCh/rxE1MHMPkJpQ0/nIx5gE?=
 =?us-ascii?Q?o5NSk2ENFAP6dgmjTj1Ag/cTYOOKE+gFu6B3BFaLBZS1OD75yfLNamwsiYBa?=
 =?us-ascii?Q?VKv3WNSvecuYqiSLTPKw3JIB728i3zkTR00o0zoJEN0hIxZQ0ttnIBU1J5tI?=
 =?us-ascii?Q?7zbScdEd1Nc67ftcJnSAH4wQQUMESHkbsMnU9aGmte5bimDnSGPAPv/iPZEB?=
 =?us-ascii?Q?fPpT1W3DKuKeaM7bSQnWeDYqMRgmpugRd795AbQ6tsF2F3PKEPyYnRNlOb5t?=
 =?us-ascii?Q?QUURRZER8HinVmcIsLqgk+NrN45rJ0G8T+dspcvQW8gyq1s/fAYh3XEoRWDT?=
 =?us-ascii?Q?In0CtZxuMwNKYQE7zf5svrTdtYhx+6PhN9qYPKkMjkVMuBvP8Uu3gQUwxc63?=
 =?us-ascii?Q?ps1HpPUwJGc5lJjzZy7iPVnUEcc+Rt3A1qdTlHV+H4FqQurj/Jj5ih8o1gZx?=
 =?us-ascii?Q?EpU+yGZ4xqaTN1l6k9mvCxg3FMxQu4HohTsNBqtpXNILbucnUDbApTZedrRn?=
 =?us-ascii?Q?G/bcMBX1f6Cc0Aahe1O/1xOX7OBiJSPHJRkGb8M/F+BcCeq8XuazS7p6LYa9?=
 =?us-ascii?Q?aBIZSlFvTb5f5i08nOYqtUFAXLPDhP+nx/KEOtmoIp66UEcsh1V6gpR6d2jS?=
 =?us-ascii?Q?PSuXwVkn6XIwaT530Kycyeq6UrHnkcoJffR6ObIo0P5wbroHnD/7xE79ANcl?=
 =?us-ascii?Q?doP9YKf2tH/JkR7iqQa245YAJ1sEhV8725t8S/oyH+/YxHGN1dvntxJLP7MN?=
 =?us-ascii?Q?IAeH8ljGQ0Wwz5fIDG/dxFRk4aynvlCmdWTgmptJHxBlwXQv2dLXd1NC4R3D?=
 =?us-ascii?Q?jEzYLhNEabluIMqr+bLj/eGZWNLFBlP5l8KN9Jzyg3tBhZnFixwYFS7eqj+F?=
 =?us-ascii?Q?86TqIdB7BXdtXaGTl6zD2tMEDwvingBS4Ub1gUNN9PX//x65h5xIU9GENMUq?=
 =?us-ascii?Q?9xotOwJhDtzVSF390PWD+BOQX7cobCrq3WXgjT1XG/+xHvSRlcrNTCdvDkJA?=
 =?us-ascii?Q?lKmGMUj9Gi3N/G/+4MWhB4D8849vFHPylbksnp1C1AJeUVEGw8piJQcUcW/o?=
 =?us-ascii?Q?/Vp4SP5XNxxNcAD96DA2/dUw1oSS56ljrRVLGpLIp3xii3jtxgLkQk38WvRL?=
 =?us-ascii?Q?O87GAc1NLXI+ujiex+SqSuXn71cxbdmj68RfkcYpUflNBcWuPHCnb074dI0u?=
 =?us-ascii?Q?LEqwOUsIQQLy1gKAuwlUB1FXdKzi+hTuZ3nJFLNdh3NEgsK/Sxk1fZxrpxwx?=
 =?us-ascii?Q?ZOsx9S7rsLcyy6ucA0o6njUgb1xC6hv3IKeb6Aqdr6cptjKwZYRLGyVeY7b2?=
 =?us-ascii?Q?rk7EQR/DKwA8Cle+KhWeChPc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8c4e8b5-e860-4bfb-5f5a-08d91e144ad2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:57:55.4365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qU13LF6NLl5Af5UB5ATRtczA5zJVFIyjLBaWW0BLt6zPsPe6kLNTu4lO3rntE8rCoi4HczkVX+bz7mkTVeGzrGOfSydnGOPg9GTSEiIpcrQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
X-Proofpoint-GUID: vXf3TqM_irdVqyR0tY28hncwlB-FRuRs
X-Proofpoint-ORIG-GUID: vXf3TqM_irdVqyR0tY28hncwlB-FRuRs
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
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

