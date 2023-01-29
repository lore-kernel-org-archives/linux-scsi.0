Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86443C61D97
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Jan 2023 23:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjA2Xpr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Jan 2023 18:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235199AbjA2Xpn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jan 2023 18:45:43 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB8F1DB8B;
        Sun, 29 Jan 2023 15:45:40 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30TMNxgn022092;
        Sun, 29 Jan 2023 23:45:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=YbFqQoDV+s/omj+4YVm2wMB0w+9V+JoX7/crHNmatd4=;
 b=pNtxeQoLu3egu7a1jtQ/mw47vTjBPGf+2yC36cxJncZe+NnnpRXl2g3GHgczcIEEd2UJ
 nD3tIjs5O61O57yC5iZ/EbDxM7FXZp7lXUdXhRSZwTwR4tVMRqxfvet5zaYj9vR0e3eL
 rjkqqfscPh/K6EHPio/sAwXLWq79Eg4YowirHjqbk67g7RWj0Yr1DAJDOwr6iq/g6Mgs
 3exBE2ipTv/jVnOQNwEW5gQHruJS4sE3BUrJF/VcxNyF+RFUVJCuarshnfoproetIyNd
 5Kx9DWA66vMBGRv+SVkaNjYpTfgySReW/CRDo/evpBA6c5sstqV7+c2eX/xGaiJEdLaA Gw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvn9srpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:45:29 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30TIT3gK018653;
        Sun, 29 Jan 2023 23:45:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nct5anww0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:45:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdXWoSzV8H53EdRhlDx1YJIr172fAPXP8CGWQn5VFUUT7p0a2ZJ5reKqWP1/FCVbFe9ugUaJp0xCWnCsGU8TUioJqEpEQa+tJIOFZLpEh8uR0p3Ra8g5OXXqJj2XsOZLv3p7BN2SFL67QAcgacjKNkKUgW3b+wmahs8a7n7PAvK8lpFZIzxsnoDcKm5Dn+ELwQ6d02wLz5z8S95+3IdQjSj9V7ofGaMrKwxmVyMkWz86HA4Col3Q2exsncz5rqeThyr2vXr1/IRaN0Vt+XsZzBOswgFcBgQ1d4x54gzDalEVy75tgv/YX3H+fUcmiSePdYo2I/89jZEd2TXB/xUzsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YbFqQoDV+s/omj+4YVm2wMB0w+9V+JoX7/crHNmatd4=;
 b=Oi5xI+Gn8biJkf0ztMm7d463atRlQNRWTkTGioI4VqybwDN8dJLG66tHG+Z1t+n+HoWz1FuGRTw0j99S64QAqS6beMrw7tU5tT9vSIS8vAm794seGu4Po8dVPx8hh91QFRveUpxjiPBK5xXy2N1ehhR0mDDVe5OuO8g2WvzyvAvcqzkh74JUhv5rPFfEg/rv0xW6u7DHYNJAc6+hDv2BxFKi/hY2qQdvc14tuf31zOG+fE6zRcrWbnIURSiNTOBMM5A6gvdDD3z3+pa2QsXjnE4EIeCN4ryzbbwksN00xutqeLnRhCNcdtSAz27uIOai9ABJQxDxcXoFYmOEBi8t1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YbFqQoDV+s/omj+4YVm2wMB0w+9V+JoX7/crHNmatd4=;
 b=S2PNi9HBfW4jF7eDAXehs4Sdqo2NNaLdrq17Ioj8A70qbQPcT8j7jbmJjviFZdgqqNijoepbjAwypBfMgE3eO0r+1KXY6xMZencM/NArP3Of62rJDMfj80+FXGehY/LDSNHAKmp2czdu22odYGcmwhHms9IM/uO/t55tKLqmtOc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4649.namprd10.prod.outlook.com (2603:10b6:806:119::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Sun, 29 Jan
 2023 23:45:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 23:45:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 11/14] scsi: target: iscsit: Cleanup isert commands at conn closure
Date:   Sun, 29 Jan 2023 17:44:38 -0600
Message-Id: <20230129234441.116310-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230129234441.116310-1-michael.christie@oracle.com>
References: <20230129234441.116310-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0033.namprd04.prod.outlook.com
 (2603:10b6:610:77::8) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4649:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dbb9118-fcd1-474e-13cb-08db0252e630
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uEo2oy1CfmLEvrQgqqkMuQmPolfIZypcEIvB1BFVL07NuLoCe+R4sEvqOPUvNiVmt6hu1hfY3DCelIsWTqr47RkAkVNtM94b1edBdXdwp6WnBtmb9GchjQ2a3PaIT+y3rLYtnjdXMrQt8DBSYaKI0NXsy1uaNJEFo9TjqoVO8J4/VSxHGtDcys5eRF61/YmeHwkotb9VBWcOQxHg27BLl6Qe8t5iSrovxJQp2f+BhUJMqZ3E49ZUqu/aiKxlskrkcsrkGn3oRjkhXoJdtOCvWlqGFrI5hDsy2+jVa3taIXqfyVGmfl09ZeJJ/VfEAu0mwYTrdNv5WwFg/pRm/x9KUYBzQBIa01SoU2i2khAOhCoMp6vMvuoAWX1Au7E7a26vQj5DTIw8HYLAzlB7ahnaPn6nXZMUlby8H1cF7qGS3oOzIH4KOyaX3D2yVODcqKRVs3rKj7tJbLTq9cnKnaSaghBDMngK88Ic0rUCqrYidg10JfuVeukpYoxuYidzDuJ1H2knyRZ0jwfr+tsYz3ydvtL3mpidnwnfd4HFRC+pw9t4lTJFQze1xw2HgCctxEJ3AO1XguQ5AlaDGN83DgY8O3P9uQJPPr51HNzNxfX0jepHx0P6glBRMFdlAhiscp9ySXquT16tbyfHFIJFZS+rmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199018)(316002)(5660300002)(8936002)(41300700001)(66476007)(8676002)(66946007)(66556008)(4326008)(2906002)(6486002)(478600001)(26005)(186003)(1076003)(6666004)(6506007)(107886003)(6512007)(2616005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ifvW4cfIW7hYCn0cRTe94j1zMc9CxQPcy0TcbQi9O200xXlDPeqOlO7yLH5Q?=
 =?us-ascii?Q?dtWSYe5H3DmuBmFk6ZtEfdWL2o3+QsmC/+sP+eSg3eVP3CaXbyBZyf2xrnuk?=
 =?us-ascii?Q?cPAKs1LH8pdtHvEVn7sCcPBZB74cAznmzlLnZDc2DJymDLeD1BvfKetwiK3H?=
 =?us-ascii?Q?Ia9ztdPdn+ThaIYxE/OvDlf01MGuAJfQFCFVsIgZj9AZ4w5TSLGkkKoryg4X?=
 =?us-ascii?Q?LFe/+xZYrDzPQHYBKLJQDvHs+X7whaiEyjR9KV+PCYUKrj1YKCDlGiagqH00?=
 =?us-ascii?Q?/npuwIpCF2FJIUnygcFJXOyCBx4eltB2Uv6HMV2gdkIqP4vyqn3MXOnnXys2?=
 =?us-ascii?Q?LeR0n6oX5a94AU6FDDt5DtJK++ES/PHuN3nd+ULrrCsS3IhE9CM+0u3iy8Hl?=
 =?us-ascii?Q?y+xJECHGk5nxedO2uIas15qtBIp/vUb17U1giBEkAzatlCpoIte64j4hkb2P?=
 =?us-ascii?Q?7k1+L2KPc4qsVZiJ2Nz4hzFq9Z8aQPHH3D+aAjLWe9BYgZ4ifp00G488XCsk?=
 =?us-ascii?Q?xmZ4smMatgAubciHubnuaIxFoHFbylyH/71tsDN6EBbDX1142bga9ykJhttT?=
 =?us-ascii?Q?HNB5SUkiSmJsTGhuvgb+QTfeGDGbcNgFcFtxKvfy8RZvr/JuqM9IYkfQfc5x?=
 =?us-ascii?Q?bTIxM2R950iXRhu0q1b6i+4UKOe75wBRf6AyNso050IDwWTtTsONw28vhAPw?=
 =?us-ascii?Q?Dt4n0ImehJojUoFPJ2EJTtxERbeL3Q3/6+WWstv7yW7qQXVaz4iXmQM0qBns?=
 =?us-ascii?Q?xMZ6E6U0oVHChe8zRZDaDC89Dvg3ds4LqdDnUAMNymgWvncI1rn517nAwBFH?=
 =?us-ascii?Q?7q6A0/EnjeuoRaE69BLvKaep3rRjIyHoEX1K9Hco2NnNxXEdOpsbU3sEhqCp?=
 =?us-ascii?Q?Sx+uDoLCU+a/UD3EUV/gzpyMbQqlY2iQ+iVVOxkED7Kfbf0eKl1DIxkUrIlS?=
 =?us-ascii?Q?5dR5UM775DHPHUjY7yGq0pdRhCfR/mXlA4UgpAsRD6XfMoa+4IRBK0XBCeQr?=
 =?us-ascii?Q?ViixckCmt0OTcq+5Fvv01XGp6gdVh5h/qPOP6mU7lhiZpfUJRQH9HIxNez/v?=
 =?us-ascii?Q?9gFYo2c46tTeDrAUNfBfDoNYCh0u7klf4NZzU3yB8XY/cgr0MC91bgIEWp9V?=
 =?us-ascii?Q?E+qr1KE0uxaMI8bkB7zN18zqSuTThxmc0kKUmvpJnLbTmVYxMsTnZZBaHS/4?=
 =?us-ascii?Q?Zu4Iz2aBqnxxwwkYslufgB5PqWaUjZaMsSCkHW8CLUmgP/Wv3rj+DmKFIm3W?=
 =?us-ascii?Q?+IXPO9BqwiJvJGezsBU0rkOxWSMAuq5t8duuEYYqm3u4nQliuRvWyyVAGCpM?=
 =?us-ascii?Q?3G0+00PSK3+AatPylzCdgbP0hbSpde/eQYMPiOLIH/1QvXaVXCDo0vlDCJEn?=
 =?us-ascii?Q?sGPWmjTn1QjE13tYuKDG8+8VQgDTWYamy27RAECyeS/mUT0FhtrWI2Gl2GUZ?=
 =?us-ascii?Q?6AW8GbGC2R9dCKqjd+to82DgLfya2z689Jisa3f2ut9EfVr3BW43vgavqzkR?=
 =?us-ascii?Q?igi6DgMRCD2wA/XXIY3ij6ae7TIdOHZJGl/04buseIofH5uW72T20Ym8ubDg?=
 =?us-ascii?Q?rCesuHN7+TRCZPCS3hwWgSl8ggfWUHYGd4VFwmD4xGhYy65TtwGk5sST9wqV?=
 =?us-ascii?Q?6w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: XHcw8gebJLG7P2IVU65dbEc9BLUTjFY7Wl3GmGQbcqAaIBmEg1RNX8lWY4zZ0GBVd/HrmZOKm7VNjhVS6Zb8GqoEl5UMM2Yoln5x9DfKajp/fBi4AzMTGjhoHFnTj9wt7pa7l1lcAltORWDuyYLEZYQaO5DMPMQBnGaHLDgpx1firdDkI+mnnkGuGp7D42LttXDcPvih8GpU6YENvey5jOhFZ7i+pZbtS9ObsNPuUvyePu649NSAIrVoLRsPyjzyEweSFyw16UPakAf81S5O4dtNm/HdlGRqAcn9SVd1hyxmuhGAoVRIjc3XPHI3UVdg1zfGuC2TzQ/Uiu9NsanZKnr8yJETyFOGldY7T7cwjNw+Iom2YoZl+gfP7V+AfPXBu+nSfz+ngBGgBw2FeuHtZmtI0xyhSAabEb8UjcSPj+RhCODtcgkFENdV83vOWK6pGFkF+Kf03Gq2sptxeBDAHw2GvGdYjyNpgkTsAqW2ENOGtn76Pbvr9ddiOTpkEVYKm/E5I+oxPyFu6SMQgpzULA2rH6XvgKyBf5bLva+NPtN3Mm8oXoTsdtfUo7+O7udQx/DX4kqAJJ5bF7WrVrmTQdB/qrwE7XJd6YkxpWQfESdYY3xaQeN2kQGPN+0mFUqc7I0B8cXWFoo4C2+2LFX1GKZ1rdO7B/n+mfuPZzv2V3RkfHJTvh5McsWiNR4k1SlYgN8OpmeJdEuihuv3Fbd+trH6R86O3MoMzs3Ji9JBdhkKSleRWxTY1Djaz3n/ed3GW90CMja41IbRulyaf3ZxW5vhusfslgckg16okCsz0pKn+o85vlVfCiha3w5HdZbAWNWwrc46f3ko83qzxo8eEyik2v/0nNZkwqbNRUbcOFht7vhHW3tnR2Ya/dpsXO8D
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dbb9118-fcd1-474e-13cb-08db0252e630
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 23:45:27.7260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uSYFJbeLLLSAbHEzORH2Ec/pTh31JFJeauzGPB+MpUxoBZiV8FcBNj2MACEh2TIn5tJH/Un3IOWv7pozoIiTcE8mdm3EJM7vtp/oAFmU2m4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-29_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301290235
X-Proofpoint-GUID: mTQ1QSu_Ipil09A38nv8xg3PFBBBArw6
X-Proofpoint-ORIG-GUID: mTQ1QSu_Ipil09A38nv8xg3PFBBBArw6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, isert does target_wait_for_cmds before iscsit calls
iscsit_release_commands_from_conn because we can race where LIO core
calls into isert when it wants to cleanup the connection. The wait
prevents isert from freeing the connection while trying to post responses
but it can result in a hang during connection closure if there are se_cmds
on the iscsit response queue, because when isert calls
target_wait_for_cmds the tx thread is stopped or we are running the wait
from it.

For example this is hit when a command times out on the initiator,  the
initiator sends an ABORT, then the connection is closed. When the command
completes it will be placed on the response queue if TAS is set, and the
ABORT response will be placed on the response queue. So at the very
least we will hang waiting on the last put on the ABORT's se_cmd which
will never happen.

This patch adds support to iscsit so it can now handle isert and iscsit
running commands during connection closure so we can have a common place
for the code.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c      | 33 ++++++++++++++++++------
 drivers/target/iscsi/iscsi_target_util.c |  8 +++++-
 2 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 2a011afa6dff..a57527beb340 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4231,6 +4231,15 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 				 */
 				list_move_tail(&cmd->i_conn_node,
 					       &conn->conn_cmd_list);
+			} else if (conn->sess->sess_ops->RDMAExtensions &&
+				   (se_cmd->transport_state & CMD_T_COMPLETE) &&
+				   !iscsit_cmd_failed(cmd)) {
+				/*
+				 * isert is still handling these cmds so wait in
+				 * target_wait_for_cmds.
+				 */
+				list_move_tail(&cmd->i_conn_node,
+					       &conn->conn_cmd_list);
 			} else {
 				se_cmd->transport_state |= CMD_T_FABRIC_STOP;
 			}
@@ -4243,19 +4252,27 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 		list_del_init(&cmd->i_conn_node);
 
 		iscsit_increment_maxcmdsn(cmd, sess);
+		/*
+		 * Free cmds that:
+		 * 1. we have not got acks for.
+		 * 2. are (or will be when the backend completes them) stuck
+		 * on the response/immediate queue (failed cmds, TMRs, iscsi
+		 * reqs).
+		 * 3. completed ok on the backend, but hit the CMD_T_FABRIC_STOP
+		 * or CMD_T_STOP checks.
+		 */
 		iscsit_free_cmd(cmd, true);
-
 	}
 
 	/*
-	 * Wait on commands that were cleaned up via the aborted_task path.
-	 * LLDs that implement iscsit_wait_conn will already have waited for
-	 * commands.
+	 * We need to wait:
+	 * 1. for commands that are being cleaned up via the aborted_task path.
+	 * 2. for isert we need to wait for iscsit_queue_status calls
+	 * that posted a response after the ib_drain_qp call returned but
+	 * have not yet called isert_send_done.
 	 */
-	if (!conn->conn_transport->iscsit_wait_conn) {
-		target_stop_cmd_counter(conn->cmd_cnt);
-		target_wait_for_cmds(conn->cmd_cnt);
-	}
+	target_stop_cmd_counter(conn->cmd_cnt);
+	target_wait_for_cmds(conn->cmd_cnt);
 }
 
 static void iscsit_stop_timers_for_cmds(
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 26dc8ed3045b..b0d7d6c73a1c 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -753,7 +753,13 @@ void iscsit_free_cmd(struct iscsit_cmd *cmd, bool shutdown)
 	if (se_cmd) {
 		rc = transport_generic_free_cmd(se_cmd, shutdown);
 		if (!rc && shutdown && se_cmd->se_sess) {
-			__iscsit_free_cmd(cmd, shutdown);
+			struct iscsit_conn *conn = cmd->conn;
+			/*
+			 * The command wasn't aborted via ABORT_TASK but didn't
+			 * reach the driver so allow it to cleanup resources
+			 * now.
+			 */
+			conn->conn_transport->iscsit_aborted_task(conn, cmd);
 			target_put_sess_cmd(se_cmd);
 		}
 	} else {
-- 
2.25.1

