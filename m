Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF9EC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 00:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiESAg3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 20:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbiESAfh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 20:35:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E27193209
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 17:35:36 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IMIp1U027449;
        Thu, 19 May 2022 00:35:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=86XGjOLi8OjRi9dTyaXzdBvBndRof8FVXMhnuhZUIYo=;
 b=lblaU8Po7RbR1SpTxweGqWnAidAwnOlaSOESDYDl/qQFXfA1qIcchfK4L5NgLsC+Hjit
 bOnOOX4dGTSs/6pO730r2vYs5zurzLU6w07sxCP9o8GcApIbPNxz9CiG1VDFTQ7qYAj6
 /pkgU15jyQmUk7ZKjU0EbtY9gXdVATZ0ryg89KUB1wsv9V/5F+jxaC/4Oze+Bmu3ed6M
 x/IfuUei2Uo62w+EZrz7NopL9pKQRVbT/YBb1dqzW2QgIcR1GR0H8k/LaF0m+U97DGYX
 YcWRh6147PmusKb4E++DJSfSQUbpb/WfOn3HBGv51jEluFCnppq5P/XBFAzJx2rQqk1K bA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241sautb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:30 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24J0V4V8015306;
        Thu, 19 May 2022 00:35:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v4s0u2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnQa90QQNsx7oDd3Xnaz2lVe46HYo4mHOXbfFjs5d9iig7+Irq9rCgs2WarxJXPEGp7I0BrmSrUsdwmU8AbUGCuR+iWjCTtFlYP/n02xleARE9AXpEOOzr9lc4boTy3bXmKdttFmEoZCXmcui5YqWv64r9DpMNV3ODfohOsoU108c3KtAPWolnxwlADkmc9fb+UPpzp/+gQVxOV2G5g0qOjHxdL1gaNovyFt9l72fwNg0JIibNEws3o7+brxhvhSK9XMqvAoiDEcefJKo8Adii+gajLKhk0SovpUJA1crCxEMtjiDyvyTG7K+Oa55igCd7xkG/JOldHlDJ9RhNIY8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=86XGjOLi8OjRi9dTyaXzdBvBndRof8FVXMhnuhZUIYo=;
 b=AEXkwlfPByuEkh79tyD799zGMskNmbs3Pdg4FEA/tUV7FSGwtDULTajtgEwhTWtz2cLs3QCHzfb9DCt5OBjiJBMRw4UEPwUi/BEHxFiuUZdP2fa0Oq3HQv7Ig94aKzfvC8BRiMnud1HnC8I0jTtWR+Uu1PI1WzdqAnnpohbqC16kmQIq4VJe/GhHe2MEEBRGI/FLLY9K5Vbi36hUahoR1R36rlpKUFB2oMsIIQxC+TubxQ8jrpi/qVRrvfWsD8XXeVzZRXi8cENI63xrmQn3VhLRjQkwo9dZFBjGTgmMQdhzX4KWQrW+MSzdaQodpAAlA3UwLfhQQ2k6TDbQF8htJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=86XGjOLi8OjRi9dTyaXzdBvBndRof8FVXMhnuhZUIYo=;
 b=Y9FbszO8hla57pazUNBO/0n6Res6iVZqyZ3gVE0WkBPCKtYm3t1TKd6Q597Xq67JDjTtuN7myYp0epFgMh9imSfcOSCDt4Y/MCXxmzmHE3nKk54V504dgtG8ZkRnimO5JP2euIyviJXiO1k8TszCEdGfs3x/ONnuPDD0KOxvGuM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3020.namprd10.prod.outlook.com (2603:10b6:5:67::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Thu, 19 May 2022 00:35:28 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Thu, 19 May 2022
 00:35:28 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V2 04/13] scsi: iscsi: Fix session removal on shutdown
Date:   Wed, 18 May 2022 19:35:09 -0500
Message-Id: <20220519003518.34187-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519003518.34187-1-michael.christie@oracle.com>
References: <20220519003518.34187-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7e98917-8749-4010-8550-08da392f7840
X-MS-TrafficTypeDiagnostic: DM6PR10MB3020:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB30205DA4DC1222DBD8DA187EF1D09@DM6PR10MB3020.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gT1rmUL6e8IQDkMcm2T5dNJtHak9e/EB4Zs3dfssd2P4QBX3OlAFPDuOqAykENBNBAc/Fgu168YOGkWnApMnhmyISZZND7pdwGB/nWHqe3GJuHP3FEqFaSpiz/qWsuDKEevwk2Ex2JNUTvlX705t3F1XKGbjzfR9fcw5NxL/F1Jk4spvyqOkVK6TvT6s0mayNQVToxurVmwwm+r3XXP4+Xlj+jYbtaoDWydvXAWkFqQ3e0X3Yo1mrLB+F04WDq7TaSrhppI+D1noQDQlruCnHsFpU62OY9q/RiKStn8/W+1ytUaeYahOcp49zSj3nMMgx66e4kFRw3MSYrjeHToCiXPhVZqPS5vT+7eZ81Gb/5fj3jyfBr6tw6lDA2vw3MJF2+Xx1YEa/tLYMG+EQIlJiN4IX7fGRiOM9OxDfYROdbx1nB2aJu+dbNBEfb674r7k+llHFmj7X0UpZVV37NHaw2fpyVxEzuNmi+Kk2NatZ904HRcKu1hkK5LznTWNWn44Z0ig8t+G0F1FZS4ZTSmSZl32UPhIzsdB7POsCvi9MbLK4Lj4Yrs75+49uvtqY1TOOKDKVZNzIU0BpIoKdp5AwsuYpbJJKBISlsuJc9wm62gTB6gsv1HuIA9iKauTPdYaDl8LlVxFxA+xnOPF6FBKO/beCeNYiuHBYIaJudpMyAj4zGhrK7S2vBcHmZuSqtAzmKYRlYETu+0sxi4OupcCHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(83380400001)(186003)(66556008)(1076003)(52116002)(2616005)(2906002)(6512007)(36756003)(26005)(107886003)(8936002)(66476007)(38100700002)(86362001)(66946007)(5660300002)(8676002)(6666004)(38350700002)(4326008)(508600001)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?704Mm9j610hjqYysXwfyF4VNRSLHcAqqIYkH+vmCWux/GKwpmbb1fWtKFukj?=
 =?us-ascii?Q?Ddc5cwDCrpjQLEZXiTxLAzSO+c6y17SX+//m5b/u+nWThsvFQB6Jl6EuIlS2?=
 =?us-ascii?Q?bdPXoqkWjfWA70CXrTjS2fKq5JP1LoMxlULp06QvI6m6FgD4FjGXXR0KGKHS?=
 =?us-ascii?Q?MYGOpWYeAcGLnKaGQ6qQt6WVDpRFynt/UCM+83cSB0BhdaHL9G622Tnho45f?=
 =?us-ascii?Q?I8eTUtcZQuyXHyvfAM6jMlzZ4He8ekUExPyWEpguto11Pl0vteohZX3CFeTw?=
 =?us-ascii?Q?dw0+R3bw5VUEzCu/D82yBqiB6RA9WFbiYYaLeC9JVpLdCqv4pmcn5b8UXuyq?=
 =?us-ascii?Q?512/PDQRe8y7EmWbTjsa1vnw5M+B0cYi8rW+Bi7w+UrnKuqw+NxuJ4u8y3K3?=
 =?us-ascii?Q?B3pnNCc/JJd7WFVviIBQK5GQN/sKkbsjtZf3CclzljxohhKRC/8tyd5L0f6Z?=
 =?us-ascii?Q?KW0hGKd4AjTwmmWbwIzbrw3EQxytttfVQdg9MwRCPyqfoREe/OjvQ3L2v0rH?=
 =?us-ascii?Q?zC+hRD7au4HOg9MMjax+fmnm8RgU55x8rJLpOR5fcR/uIhcr4gvZA3b73k06?=
 =?us-ascii?Q?jBg/mwNYbTgRJZxsu4Y28W+maSa3zkOeDHRHzsOmKsHUiAQZ+9zdf2EX3UiN?=
 =?us-ascii?Q?rUbS9tiVXvduNluEx6J7HD6YoVOSy+XtsEOHghpYwkou1aIMazZPctRB0dD8?=
 =?us-ascii?Q?fvR13GExPHZpGcLMnyw4urAlRTjnRnGf040aV0T4UjutXk/PH5y8pRmLdB8n?=
 =?us-ascii?Q?BbjQLgUsCUOhWC5ue3hEn12Mn3nrXTnTWanbTMHVCrmyJX30Xr0b/6R+F/b8?=
 =?us-ascii?Q?V231m+TzDuKFijWk1dT/881XzpUP1XScUeSKDKG3xPlxzmb3fvKXfUAFtVBl?=
 =?us-ascii?Q?NymLo3XIxsEbIfCES9wxBhGsQKY3IZafMd+LXC/8n3LrewP8fV8WEsiRxhKG?=
 =?us-ascii?Q?rqs5XaHTrqAaPaxsiaxRP9yz01oH3uSs+diGKL/RRV3gm9u9L5pTylJK3v5V?=
 =?us-ascii?Q?2Ne1kGra6xL+ZTfX9Bn7mn2eQabZxmoxaDvAs/Jaocly5PpilJEAhFd/g3ZV?=
 =?us-ascii?Q?jC3ihI/DyGZh9IVYO8557KRTuoL0lxRbPBB5JUfk+ndZ/XnZyJ8StF76UAlg?=
 =?us-ascii?Q?kBsgRYSk1csZbeA7YiyPMiZfzGKaNoBGySChoWE4gbRo6bz73dtD8dqTPfrw?=
 =?us-ascii?Q?f9vTVNrNe2ZYJtbo16pBrGVPJcxmm81ydSwX0N5E4E0ZdjoxpjjvYqoePURO?=
 =?us-ascii?Q?uln6wk6hEFQKPjMMtZY4pbFhkuMZirIWdrGpV4CsRZzEz3qfHBee6OVGd3Ak?=
 =?us-ascii?Q?eGl6uU7nH/LHehiTPG+NTqDcfGlLDxzmqKMP/fJ0Y13g2c8hbnzQ6dHBuf/B?=
 =?us-ascii?Q?qir3Gbimkdo4n8Tr0/IoOab0UsaUGq+ScczIt13lQPhbfOHQsC4E1LVbODm1?=
 =?us-ascii?Q?zRjfh000VdvBTUDmx/pGjejCGU436dYZ/LaGWUrTeNV1jJtS5QkSnxvraXn9?=
 =?us-ascii?Q?1y0UPNwsud9F++/BJsRXlJGr48FubqjTtJ+qi98or1DqZeX/KYFCuUfDxt6R?=
 =?us-ascii?Q?b9D++eTf572D+Yk4oQOWzwbBz8qWxiQyU7oJufnqUbs1Py7zTCw1R3d0YNAh?=
 =?us-ascii?Q?pap3N+44oQzcCQ4USplKBRmGdeTrQQICA7dRntda0TTuROcpN0DQ2/oUbn3H?=
 =?us-ascii?Q?lyP6sThftUdD9fxdYmfbzpUxGVsjCRKkBxlzzIIRFHOcnhCi8LgWK9z59coC?=
 =?us-ascii?Q?mva706DgAVJ6o5JkJ7n8kqOL0qaFIkk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e98917-8749-4010-8550-08da392f7840
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 00:35:27.4461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nqgzKO+98+gZsCzpFBlwwMnV6K1JQjTDVpo5Ls+fdW7gF9wo/RbD5xJ3XtmtAPJKvgjWCh5298kIL47edTh0JkU4mHxpw/EQltVYd+NFjtY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3020
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_06:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190002
X-Proofpoint-GUID: X8kYMF443pKHRS2mlA6GRfFcO0Lq9QCX
X-Proofpoint-ORIG-GUID: X8kYMF443pKHRS2mlA6GRfFcO0Lq9QCX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the system is shutting down iscsid is not running, so we will not get
a response to the ISCSI_ERR_INVALID_HOST error event. The system shutdown
will then hang waiting on userspace to remove the session. This has
libiscsi force the destruction of the session from the kernel when
iscsi_host_remove is called from a driver's shutdown callout.

This fixes a regression added in qedi boot with patch:

commit d1f2ce77638d ("scsi: qedi: Fix host removal with running
sessions")

where in that patch I had qedi use the common session removal function
that waits on userspace instead of rolling it's own kernel based removal.

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
index f8d0bab4424c..e36036b8f386 100644
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
index d0a24779c52d..471422641ab3 100644
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

