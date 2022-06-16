Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C211FC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 22:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379006AbiFPW2U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 18:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378980AbiFPW2G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 18:28:06 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E6D5A5A0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 15:28:01 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GIjK5T032718;
        Thu, 16 Jun 2022 22:27:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=+IsWFV1Ki6G1SeIPLtn/Zqj7H16z+suOYZP/ctlhx6I=;
 b=uQTnVRPES14areKRiCDa5hMjKPl9ypFcsTtDrTOTTFCijUh929lFsrV/dvfB/Wfbc+z9
 Al2SIVkuik7PSiIkoCZPtDy3SZLFkznjtptJLxmIJmzuEfqM3jsuVfcxmexC9mYHk/Ar
 R6pCo98awchyUcVdwRnPagEl/+fyp83RBqY1CdH6sA5LuN5LvvXbs+sk+uBrAomxaa2y
 wnRC4BlD0I27NKN22IPhEGK86Nn1GbQ1qYaDiu/2cMDkyb2yCnbnAGUtp7Cv1vi1X/jA
 Nfd+VZQ2F6TIXSZkYZ6JbvFl9EshKpDzMPxtbfp9a1+KgT8cZBydk3UNaeiRrjb8dNIQ 2w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhu2vm14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:27:54 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25GMGQsu002680;
        Thu, 16 Jun 2022 22:27:54 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2046.outbound.protection.outlook.com [104.47.51.46])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gprbtah99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:27:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XosRfn4sl/MKm2cjCwnGhEykHCifbzvFma+QdVinz8EBVnCuQ0KoRdoL8eLwjgBT6RFXu4molyAeNRpZ6SczA5nhaEAbwdwj5HPs9KpN3KEkksd6QxjlfsdMGXbnZxpcwFyrf6VBRYldOYd8StceL4yw+lu193iRSJdL/yljuE1cnS+S7FgJN8ZKkSleyzG6M8G1B0ewaM0/kjifojymFI80oXTNSKTXJCLGeX64iNk5pfW+U98/aaX2IisWcN8AOZtCiTIDS6JczvvNoROGofVxYb8YF0AC9mG6bOdi/NaoG5C8Yv1anFgrsTuPCuNWT2Vch66iXIBaRNc+O9d1Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+IsWFV1Ki6G1SeIPLtn/Zqj7H16z+suOYZP/ctlhx6I=;
 b=QwTV+Jap3+GwReyEuH2IEI+cN1XyUSkQwfMkAGsQlmvm4e8ejp7s5LpL4hwaxVTJ9msJf+VvQ7rm+PCxL9B1P7ajZjpF3jaWyw0aM1aUN+4L/9lneuaa8VENmkN7hB0NKoyUB32+jcy45G4qgRts6S81TPnE9twm9RBQLtW3cezYd9U52EXw0G2zTWcvt7MDZtxSrpvghumAnWQrk3WcD8lpju1iYtpTpW1wHyxVgILhvKq9BNUSEGljNe7KcgHYfhc5uirSS0snJV6lNvLRrn9ACKWvYUjcPXGZUdnp0vnRXUN3UfnCjthy5dxeU1K3MoAoWwMxF0BYxDfZR31gkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IsWFV1Ki6G1SeIPLtn/Zqj7H16z+suOYZP/ctlhx6I=;
 b=qVH6Nx7/UyNwqvEuTDKzwi9SqdXFnsfibycbgaclzScCoXIZDzdJNN/ue7QoJWOVyIHI2iQmzlFDPQT6DoDgjJXWhaOa5hxd7wPXKMBU90NoHcSktyfxeQTkkUJ/eo/33qJZoxNQfbXEr0I/Fgd6LE5e3K6RgBvNrPrRlAnP8z4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN6PR10MB1267.namprd10.prod.outlook.com (2603:10b6:405:e::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.14; Thu, 16 Jun 2022 22:27:52 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Thu, 16 Jun 2022
 22:27:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 6/6] scsi: iscsi: Fix session removal on shutdown
Date:   Thu, 16 Jun 2022 17:27:38 -0500
Message-Id: <20220616222738.5722-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220616222738.5722-1-michael.christie@oracle.com>
References: <20220616222738.5722-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR18CA0070.namprd18.prod.outlook.com
 (2603:10b6:3:22::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 121932c9-0417-4e13-c304-08da4fe77394
X-MS-TrafficTypeDiagnostic: BN6PR10MB1267:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB126721A16627EA8A1D2C1B93F1AC9@BN6PR10MB1267.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0FzjvlnAG6VLJ3Tu6cptBXQlSX0FWYKeBMIQulsXJ4ildPwSeV9vN0vFA56vQxhWBWlv4fv/p4X1jPD1D24ca9Al9xJn4PiI6wNahHxl1uere0+Ym3KSsfoV7h+SGXLIEB9TGKb6QmQ4xz639e64dJELOxGO/vdwfzY34r6kZVqjk94HgYHagVTXD/JlXZl+aDJJtDBy6yDU3J36eST/Qzi1XV06PRX+Rcc214sBbCyCpPdR5zd28rJomAPpz+nQBTOahRP3/Aacna+IxJQ2ogf/MQ2EjzL43iPqTvyHTIILuFFuWJtwr4vzr6Ns2mytk2+/ELFdAP0/UI6Wmzi3PO0QJSZoygsBW50aTnudDISn+5BPLJr+6m99U5KAwA898JzcUCuvBGDhnEKlV9I1K2Mdivh02BHDi+evDWqDsmRhbc6EcG/4fkRM0i4aVCVeyeHJzmeXD64are18eKCij/dcDoZub0tA/Za02zSYzX0+2ADH3y/PmIajGk1JASJ2QmKNBXqwwGYWqAqNh/EJPrgLwTmh5zIR4x0TyzkB9+w8CGNyIhSPLCFiNMdlgi9Hp1xsp0ylZaGsRBBuOdF3TSMnb5VLWNNXNHniwiJZVa/V3XyAy5SkN8fo4EraoEDVLVee1vxI0rYLkukI59siExQLkJWWjbl4qxvX7Shet+L2dl/y5S1jhH0WtclQI457qoknHu/gnw5G6aUKxWGuww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(5660300002)(83380400001)(107886003)(36756003)(2906002)(86362001)(38100700002)(6506007)(38350700002)(26005)(6512007)(6486002)(1076003)(2616005)(508600001)(6666004)(66476007)(8676002)(186003)(66946007)(66556008)(316002)(8936002)(52116002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Uzpnup0qrz249Rt28UxUGgAGa2SFZthNNsMn6LmKbMkj1iVawh7F8MRIuvRL?=
 =?us-ascii?Q?ghurM5apodtABcqGQYceUnIX2/wPjFPhatRTISVCs13kkxVNTcCXxikNncC0?=
 =?us-ascii?Q?ssTsUuRlEtN1ucTqbD3jfI/tPzG3WI2asW+3X7F9wXI4BtXepYgfZKgo0cPd?=
 =?us-ascii?Q?4wxwSP8Rv+Rv8yZgrA87FlZzv8XST7aoV9JQdeOKykU7B5lz5Hy3dj7hF90A?=
 =?us-ascii?Q?98C5jR0kvSY8sjWz1UV7+ja+zhI/5uvZ1LhQ6iJcxdbi3zIhaPK1PAMZXWzj?=
 =?us-ascii?Q?rCB/a2OQgZC9IlTguQKpMu4Lx9iSdWkI9zJ8e8Axj2BP4rY9gN2kSj+yOH3w?=
 =?us-ascii?Q?jdlGYwQdpAcvHjlBucxIwFwq7zjFgA2haEVP0q67mI+txHW6ooi1jYTy9A6y?=
 =?us-ascii?Q?3RdVC6KDfOIhdwXoGkhXlCaFZ5qNcGpqL63LHdceOi+cs6Z47lUNQm0aHisn?=
 =?us-ascii?Q?RSdj9cIh5HmKtWc4cAn36fTGKSJX7Do51ljIAQpFRCFB9bpUmhLL80/r29Bk?=
 =?us-ascii?Q?EgjUJGUJpFTYopeMvdrMEcnKx/p44wTczQP5GoBDdrsBj5stdgWytjFzzeDL?=
 =?us-ascii?Q?w14hluL9WCVqSifjyAEh38ZAr8oR+ile1o5RTHAGGPiWI7Zwa2pNQL+xvnRl?=
 =?us-ascii?Q?bZBGhghD4IP7w3mdnloTFRIe16sFph3EdJPgBF7YglDD8sq9MrtUum6CoapP?=
 =?us-ascii?Q?Pkrx3YKKDGM4zK8JAYIw+BeOEA4hJBgIyy/o0prprTeGB6R6XOwThHmAcNwp?=
 =?us-ascii?Q?OrfR15UQSO0XqHIaH0+3XYM8Mre1M44QALVQ6/xI6JnHGmgZtNdanddqhzpY?=
 =?us-ascii?Q?OJgdMboj/Pt4RLSc9zj/xNyuYpdigNGKzPVxQEgj5GUV/w30m0yXhiA3QerI?=
 =?us-ascii?Q?bo7lav9Xno5hakvQnaVhNALav09sgE9VKx/1tWQyx7sRapcVJAkWn3hTcheA?=
 =?us-ascii?Q?2H60w4qbu9L8CrEJW4bbDLNrhRDIfZ8jhq3OWis2As8bcdxpkgkDAoYq411G?=
 =?us-ascii?Q?izTpsu3SlRkuLJm2bLhsM7UU0hYUbeFCObWywwa+wJy3JnBxr7XWXzwYG88I?=
 =?us-ascii?Q?OQNXDflIuGknBRvyvFojyNHMP9J4YaVyJJJY6Xaz2/QLz6Qq97ONIrWe4jF9?=
 =?us-ascii?Q?Kqs0+6DzDWt+hyMSDpDM1m65IRLmXzl3SO9miTjLUge8oCbzshh4hK58PELN?=
 =?us-ascii?Q?jyl9cCimckEsDpaI7Hl5LLK2eqVbmqMDo68NJphP31LHuxDMSuemCNe29dZE?=
 =?us-ascii?Q?iW/JKu57Mdtai+U5IzGy9wXsM7vRenVt7kQAnsN7yWaZQIhVLdxakbbgprbu?=
 =?us-ascii?Q?6blQdo3Vf1ZNiJLIl9DZpi7eHOTAtEkOCNl2jczXwaeXs4mMN/sXQfzXQTBZ?=
 =?us-ascii?Q?JtiFk9kd6xTckE6bB9zzCqdtGefhlK1zK/MdQRmqD8qKi8UTCvCRg1CdxPVk?=
 =?us-ascii?Q?hbxg+yxH7JngCYwfm9sKhBcUcrjQbfK/REPnB8Ty8h+athCdyXtEdvyavP+M?=
 =?us-ascii?Q?dFC4fWmrmlq9SYNxHl8IDTsDkcmJUxW4MUOql0PUR9yxPuI22YF10fHomZMz?=
 =?us-ascii?Q?PWe2yGTIYDnuXo9n6UeI3yUwbK4U8oA/JDGDa4ilPPhMP1NqF1mXESYZj/ke?=
 =?us-ascii?Q?NMpaLNA0ZpJDsuVZ5dLEaLVBrmls2ZeQEUb6+LUosuklhLgD9qZnD7ErbOrj?=
 =?us-ascii?Q?uf1Jy1v2UcyBBifPigNSa2t7ogZR+9ZBdC3Joja1L+K+V5fDvkhKLr1vcg1i?=
 =?us-ascii?Q?YJs95BySX2GHAxvnRfQNULbruQi0X3U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 121932c9-0417-4e13-c304-08da4fe77394
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 22:27:52.3390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nxONKX2Qr6BTigbHhwkWdbLAwRBNMZ3qTfJ1e9lA/ga1Fn+GxX5NOPcT5jFmGMAWAhuLZkkjZjB9vPqjpbfFjMWRS1/SdbwG3P0XEPHqstQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1267
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-16_16:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206160090
X-Proofpoint-GUID: uV71Ya3ZPIPyUvT9Au3gIR1b0xrob4d5
X-Proofpoint-ORIG-GUID: uV71Ya3ZPIPyUvT9Au3gIR1b0xrob4d5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the system is shutting down, iscsid is not running so we will not get
a response to the ISCSI_ERR_INVALID_HOST error event. The system shutdown
will then hang waiting on userspace to remove the session.

This has libiscsi force the destruction of the session from the kernel when
iscsi_host_remove() is called from a driver's shutdown callout.

This fixes a regression added in qedi boot with commit d1f2ce77638d ("scsi:
qedi: Fix host removal with running sessions") which made qedi use the
common session removal function that waits on userspace instead of rolling
its own kernel based removal.

Fixes: d1f2ce77638d ("scsi: qedi: Fix host removal with running sessions")
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 4 ++--
 drivers/scsi/be2iscsi/be_main.c          | 2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c         | 2 +-
 drivers/scsi/cxgbi/libcxgbi.c            | 2 +-
 drivers/scsi/iscsi_tcp.c                 | 4 ++--
 drivers/scsi/libiscsi.c                  | 9 +++++++--
 drivers/scsi/qedi/qedi_main.c            | 9 ++++++---
 include/scsi/libiscsi.h                  | 2 +-
 8 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 321949a570ed..620ae5b2d80d 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -568,7 +568,7 @@ static void iscsi_iser_session_destroy(struct iscsi_cls_session *cls_session)
 	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 
 	iscsi_session_teardown(cls_session);
-	iscsi_host_remove(shost);
+	iscsi_host_remove(shost, false);
 	iscsi_host_free(shost);
 }
 
@@ -685,7 +685,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	return cls_session;
 
 remove_host:
-	iscsi_host_remove(shost);
+	iscsi_host_remove(shost, false);
 free_host:
 	iscsi_host_free(shost);
 	return NULL;
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 3bb0adefbe06..02026476c39c 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5745,7 +5745,7 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 	cancel_work_sync(&phba->sess_work);
 
 	beiscsi_iface_destroy_default(phba);
-	iscsi_host_remove(phba->shost);
+	iscsi_host_remove(phba->shost, false);
 	beiscsi_disable_port(phba, 1);
 
 	/* after cancelling boot_work */
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 15fbd09baa94..a3c800e04a2e 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -909,7 +909,7 @@ void bnx2i_free_hba(struct bnx2i_hba *hba)
 {
 	struct Scsi_Host *shost = hba->shost;
 
-	iscsi_host_remove(shost);
+	iscsi_host_remove(shost, false);
 	INIT_LIST_HEAD(&hba->ep_ofld_list);
 	INIT_LIST_HEAD(&hba->ep_active_list);
 	INIT_LIST_HEAD(&hba->ep_destroy_list);
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 4365d52c6430..32abdf0fa9aa 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -328,7 +328,7 @@ void cxgbi_hbas_remove(struct cxgbi_device *cdev)
 		chba = cdev->hbas[i];
 		if (chba) {
 			cdev->hbas[i] = NULL;
-			iscsi_host_remove(chba->shost);
+			iscsi_host_remove(chba->shost, false);
 			pci_dev_put(cdev->pdev);
 			iscsi_host_free(chba->shost);
 		}
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 9fee70d6434a..52c6f70d60ec 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -898,7 +898,7 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 remove_session:
 	iscsi_session_teardown(cls_session);
 remove_host:
-	iscsi_host_remove(shost);
+	iscsi_host_remove(shost, false);
 free_host:
 	iscsi_host_free(shost);
 	return NULL;
@@ -915,7 +915,7 @@ static void iscsi_sw_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 	iscsi_tcp_r2tpool_free(cls_session->dd_data);
 	iscsi_session_teardown(cls_session);
 
-	iscsi_host_remove(shost);
+	iscsi_host_remove(shost, false);
 	iscsi_host_free(shost);
 }
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 797abf4f5399..3ddb701cd29c 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2828,11 +2828,12 @@ static void iscsi_notify_host_removed(struct iscsi_cls_session *cls_session)
 /**
  * iscsi_host_remove - remove host and sessions
  * @shost: scsi host
+ * @is_shutdown: true if called from a driver shutdown callout
  *
  * If there are any sessions left, this will initiate the removal and wait
  * for the completion.
  */
-void iscsi_host_remove(struct Scsi_Host *shost)
+void iscsi_host_remove(struct Scsi_Host *shost, bool is_shutdown)
 {
 	struct iscsi_host *ihost = shost_priv(shost);
 	unsigned long flags;
@@ -2841,7 +2842,11 @@ void iscsi_host_remove(struct Scsi_Host *shost)
 	ihost->state = ISCSI_HOST_REMOVED;
 	spin_unlock_irqrestore(&ihost->lock, flags);
 
-	iscsi_host_for_each_session(shost, iscsi_notify_host_removed);
+	if (!is_shutdown)
+		iscsi_host_for_each_session(shost, iscsi_notify_host_removed);
+	else
+		iscsi_host_for_each_session(shost, iscsi_force_destroy_session);
+
 	wait_event_interruptible(ihost->session_removal_wq,
 				 ihost->num_sessions == 0);
 	if (signal_pending(current))
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index deebe62e2b41..cecfb2cb4c7b 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2414,9 +2414,12 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
 	int rval;
 	u16 retry = 10;
 
-	if (mode == QEDI_MODE_NORMAL || mode == QEDI_MODE_SHUTDOWN) {
-		iscsi_host_remove(qedi->shost);
+	if (mode == QEDI_MODE_NORMAL)
+		iscsi_host_remove(qedi->shost, false);
+	else if (mode == QEDI_MODE_SHUTDOWN)
+		iscsi_host_remove(qedi->shost, true);
 
+	if (mode == QEDI_MODE_NORMAL || mode == QEDI_MODE_SHUTDOWN) {
 		if (qedi->tmf_thread) {
 			destroy_workqueue(qedi->tmf_thread);
 			qedi->tmf_thread = NULL;
@@ -2791,7 +2794,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 #ifdef CONFIG_DEBUG_FS
 	qedi_dbg_host_exit(&qedi->dbg_ctx);
 #endif
-	iscsi_host_remove(qedi->shost);
+	iscsi_host_remove(qedi->shost, false);
 stop_iscsi_func:
 	qedi_ops->stop(qedi->cdev);
 stop_slowpath:
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index c0703cd20a99..9758a4a9923f 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -411,7 +411,7 @@ extern int iscsi_host_add(struct Scsi_Host *shost, struct device *pdev);
 extern struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 					  int dd_data_size,
 					  bool xmit_can_sleep);
-extern void iscsi_host_remove(struct Scsi_Host *shost);
+extern void iscsi_host_remove(struct Scsi_Host *shost, bool is_shutdown);
 extern void iscsi_host_free(struct Scsi_Host *shost);
 extern int iscsi_target_alloc(struct scsi_target *starget);
 extern int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
-- 
2.25.1

