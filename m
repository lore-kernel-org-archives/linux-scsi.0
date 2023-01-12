Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B48C46467
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 03:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbjALDI7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 22:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235842AbjALDIy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 22:08:54 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE9149149;
        Wed, 11 Jan 2023 19:08:53 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30BLE97n017447;
        Thu, 12 Jan 2023 03:08:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Z9IJ1MpNV7Ww8oAFrYQBPbt42LUUWffkJ0U4jB/bzuQ=;
 b=0c+OahWxNvigkcjZQo4ulwXhPg1vE77siPOIQKCqZMtDUMx0LI/9DNxBfyeY9kA3Ck1D
 w6mZQMVUtv6HX9ZVagAz5u7L7zPYbj2MQAAhLhlnOG5SNhbQ7pdeu7NX2eNMQWbNxKYY
 JWLQDH+qfrX20W+Qe2pSa7twzrHDjzbpS/EjRjs4oxvrkCoUNfKByjlO66BjJBhQYIWJ
 HbE80CShst3d+0LrwjA4U0WDCFf2G3mAsvYauBSZDlVNn4cuqneOlWFdlz+/Xef6508J
 ePmhjyDATiq8Cg+0pgCAs50AC5RU/AmrQ201MttbQ1e4XDtCiicDLh8xHKYqAvNkEuEN bw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n22x00up8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:48 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30C0f0Y8034176;
        Thu, 12 Jan 2023 03:08:47 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4fuxp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZxtVWUeFRyfR0DDyA3y59pkPwLMhVbhJ3NrpIdZVartp7x6owmH85IIQSfoXin3yqITIvekTNfclOy2AxkTZA5tMF0LuwaFGTTQ+QQ8K1lzqZVbfrSzVv3ki6rlPosM/znu781JC8Lf5bHbZOEZt01SuB2F6dgCuKHfMaWKhHyA017IrOm34CHduCV8TDMJA7elMKgst8edSsctm/jl9RgnphBL05Hed0bb9PwwP68Ke0esRT1LKJ25ONwbjb7Exr1UUq0zC6AAMPPSZUD7fBniVK05Y/Buv34j98Xe1FXUD4yO7v9AYIPgw6L68aeSaOtxnx+4JAxUO8Xz8FTxxnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9IJ1MpNV7Ww8oAFrYQBPbt42LUUWffkJ0U4jB/bzuQ=;
 b=dj40ulerbVU59KzjhYM6/jblIW4HKtq+QNf1o871HdUKhxzKoBUu5Algypd9LdCUu5PAilm+Lr9VRpWiGKy9dm4U322/uF4cQIO62CKMJypf+Y0+gfKMCu/M3cvlDr+QiSKzk0UjAqZNsnAKW/z1v+Mj+EhSyohNDrNv4ju6LWAjP/y+8mpVFcZPgnvhYe2NPlWelAsbIl/uJ98LDGBpUEW9H8KvCTB48guidbIroMhweRZ5NAWtZ0y+nXu//sRURX84ztLjlkFtI0fEjNdMi+wQ9du4l+I7LZOkp0gsbHlKJOo28DQqhdyGSAwmHQpmACHoY3icTYQefVsd6fF29Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9IJ1MpNV7Ww8oAFrYQBPbt42LUUWffkJ0U4jB/bzuQ=;
 b=hdSJghVDY44Cily9YmH3A2ANJgu1fFE6i0VxF0Pikl6bnZJpXZKAtPjyKcBFsO6PniwqZ5qdDf/hp0xHl0CkmMZnZWBwiZ9MoGMei8t4M6/JUXn2wOEK6KQFxvy3LnOYJZyht5XwPsvJnQRZdp6pZnK8V2SwD3sjeEWXGv7vgsY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN7PR10MB6595.namprd10.prod.outlook.com (2603:10b6:806:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 03:08:40 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Thu, 12 Jan 2023
 03:08:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 03/13] scsi: target: Pass in cmd counter to use during cmd setup
Date:   Wed, 11 Jan 2023 21:08:22 -0600
Message-Id: <20230112030832.110143-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112030832.110143-1-michael.christie@oracle.com>
References: <20230112030832.110143-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0375.namprd03.prod.outlook.com
 (2603:10b6:610:119::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN7PR10MB6595:EE_
X-MS-Office365-Filtering-Correlation-Id: 8952c14f-20c2-4138-1abc-08daf44a4e2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rkqzkmcZTdsbCVkhbMV2OOlXUs/XhXTJ6AC8fA0rr+CjCLhVflv3+035IqXjngF1kdXnG6ApqvGN33HNp6ENJvTJofexrEPBDP0WSAXyq5O2/sxVTuhUPCxVx1zqG+KYkW2MKfR87hWDgHCqfpTuYvu/AExEdmGujyMjhQHQhzLqrGur9H2Ud7xPAnK3NW1craXCb5k+3BcyBWY5i7X0xd2SJHLjiLW91j14zWBV+6PILIzxM8iIq/zuFf/VUJtPBPteNiHxzraFilRc0R0tnzFZivX5MUHVRXkqp/UvW/vP8YeIYe1NKifUZZIiRpYCLkTAzJVf6PSTtWGFp/EWLC3PnUcXf3YCKU1d4BRe1daOUxLvtGLm7gFR+0/D3pniM9Q6/EOcb3GQKGJbtNf0KzuBLAAgD8ecthK6/pyvKYMV4V1d5T3lRrAeatdWGbG/sBZ7Atwk/QnliwxcWChPM7tJ637n3ny+MOfLGkqlLG5ph2aE6hX/D4Umdu2jE0hjuR+IALJsRUwZsOK0dRAXxan1KrK/zwyNITNJvfNhIwNZ17SYlezS1cvKiCcOHr/tH39VCHZtn2mWcnp+WzEcMgoFuXDA8gd7HOewe+UzfZFCniYf+iTgBn7ZPGxzODc8h+gCS1w9eO7+j03QihihgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(39860400002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(36756003)(2616005)(1076003)(6486002)(316002)(478600001)(107886003)(6506007)(6666004)(26005)(186003)(5660300002)(8936002)(6512007)(2906002)(8676002)(4326008)(41300700001)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?glVGqHTRFm5HL1Pk3YdNr1toJKJo9bFW1AIBC3rvyEaZ+DtuYqd6nRhsgPWg?=
 =?us-ascii?Q?aD0nnglA+Be9b0grfs8AgnFszWvW3P0Fdedy3lMB29mhc8wrHvhXAgBDGLWX?=
 =?us-ascii?Q?1bmr6DXmOdSnapRe1dYSaETcMk3BLmmgKrt54eTJljrs9idc5GPEZelhum45?=
 =?us-ascii?Q?fsjKvj5WJoYzyxAlaOI0/+bpm4vZU6C6C0KvJhXT+tAidPcgG8C6RaHeSbXr?=
 =?us-ascii?Q?IKZM8UCZBSjeIr0FU3ZMc14r0KC0PemaVP92WhDu55fq9azXxMVC7PQcQyAM?=
 =?us-ascii?Q?D6dgBUNUzkYMm2ZL/wASo9brOz65f3yLUvK1eZ7QLwVwXliq1JkUtIOiorhR?=
 =?us-ascii?Q?Jvl6pM9xP/NAE3+qLh9JWkLyUXGZT0rTbbZ05lRr+DhD8YpeilRtgVUaJpqW?=
 =?us-ascii?Q?DB1vl7xWRVpt7rBR/oSTX7T49GNy9MzlN0f95dvuMwQ9GkC+rVsvLTySZwCt?=
 =?us-ascii?Q?GQaX4su90yFerqvAnHXmfy7upasIhQ1lJo1E12QZKMyvpfomfS804ZHy3O5V?=
 =?us-ascii?Q?abytG9nQVSACjyrDUu7+HoiU7Clys5BtMiSY7hFgg87OkgWzsX95km8cojAR?=
 =?us-ascii?Q?6EdZBOXJlgRyy4u00MfghN/B1BwlnSgvOcm57wrueMr6m5vgyKmjRNay6BX9?=
 =?us-ascii?Q?chmt0IwEKTsh+xGej/jhg2q1pSLyuswBcbsJ4kBMRjM6LPXrntwzqfqg66Ej?=
 =?us-ascii?Q?XD41EtYLGqoD6zZ27KRju+01spb/ymzLBd7HagspiUp5rorxv2K3WWQrmPBl?=
 =?us-ascii?Q?XslPVFRF3ZYEso6zlR+Gq33cg23pzgVYbreIDgAqYIBjzQh8oEveN6kfCzqM?=
 =?us-ascii?Q?mgkJZuOL4FzYclM3GR1B/R2+FXq8tlDdZ1f1G1trSvXkh6gHx9vVJJzUGltR?=
 =?us-ascii?Q?FfpSxyQOqvrUffp8cSyikN1F57Dpb6+L0b1/yWWF9LjOwvBVzLvne91t1tIi?=
 =?us-ascii?Q?UoaFEjK714baansIVjvS92hY2pbGMcHKAoEh4rJ6YgtVon8VNmnIZfaesBIV?=
 =?us-ascii?Q?e9P/BGwFLnEqCIZtI0V2lmO6rLh2ELWG+u70JcYrKgOm2kuDRk/iGJYOrWuK?=
 =?us-ascii?Q?Qf+crZYZWaxTst1DjEYfTBKxs5mfYeZ1X+zgG0WAtrDM6O/f4Y0vur2aOBip?=
 =?us-ascii?Q?/PeJxuRi59v+5X517IgsYUCxAMerO6FP2hhpdYo8u5VXeif7xxNSYp0oBwfy?=
 =?us-ascii?Q?F77GVnCQl/PZJPbGM1gQZPyR0ucZMO47RkO8Qkw5fSPZ8jjCCsxf+P/Gb93d?=
 =?us-ascii?Q?JSe7UcH06vTHlRkbGQmzaEjkXDovCwc2lR4B6qBp2DY3kjRtiLGXiZ9GFm21?=
 =?us-ascii?Q?N905tkplAn5d4fotyHae4nbZfShL2UZb/5Wk601qqI4lDe7PBF8qVUpW3qxp?=
 =?us-ascii?Q?2CHON3RTEsWq/iO7Kn+1LoGU2kOm8qOqKZ4fK5k5xZsROo988XDAcR50ixSQ?=
 =?us-ascii?Q?3mCdLIPuMjAyYWecW5CyCv5lP59AGdfazUs3a6yk0AcXFEie91MKEE9BLSFJ?=
 =?us-ascii?Q?dv+6CY1NRZfD4XOoiFLmxbW1XdNemgVltXgCUplOoPtA+aiOOgCzIkdPJDBz?=
 =?us-ascii?Q?2wn7NCL+yQIMLSib+ZvAPeKjrSOUqus6FBKLL51yiacQW5JfEH+dJ3gYy9IA?=
 =?us-ascii?Q?+A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: po4XOIEDC1JjviqSHzdzqHwJYHAeYk4uuu90GkiRJKTHGFSyaeUfli39CM969HJsXfQO7ZNwzsbv0My/JpU0ibBwhHXJW9mWUxCU8v0ReKnJGFBbuNv0DTLZMoktuAvzAJRDeHSbnkZvSrIIgZPkTwBP1f09L4bWoBNgoZ8uxUov/AdEghvfq6ZuGzU4hzR3FSx3igkit6nej4ZilzOtMyJ7+yltzwC/HrqBrK1zGOLhSJAYCfwb43RKk71uHB1lh0rJ3YBzJ/fjoNexMYtDxD7Cm2bjgjIEhGvmOCmbx4MALXG31wz9A7cqEgaXZ7DeDF4fJECLo7K2Pdpj/QtKG/F4XaJy7ZPfn2T0+/oKcBZ06qg63F/WtS1ecYW7iK89aOzDGyw9wz6qFI9ZgVIqiT3K1CLF5e1bX7mlAisYRB+fPRI2p55dhmucP/RxUmPEn9thIdIxcPNuNE1kd4Hqy03HyJUYj9+gk5ZNrUsq46fZgQ4P4VTfTRbbWRZmtq1/THdcSO3JcWA9tsup/ImJny33QOj8UJ6J7sKI8M3bpCZBMpjfqp5y6RoYrIcy/dxZBfMohCGossOi6DSsgRnWDzLkAbxqVF79ZaoOroGOGPcATJ1qtWguK9n/o0WjKe55TJx2xIjXdgjv1je6up6QYvBIcWa7CXLpQxsQHaodDC7CcMIWAt7YRBnd/0YTzJSYC0kN9CSX9jTOk59n69p5lTV03ONBlOtD8Fgx6npYWfbBWq/WBRrmxvGXZ9im8qtmdv7Npw1SsJKB2MuW9eSi4AQqwaNm3CGWe1tBXuYatWw8q4adoWhdIxgUiuHQF3DJyoWuCVwkmovQCVb2H+NPum6ZlYnvnTVjb1g7D1L51tcTUi1pgiuia1ort7O7SOJx
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8952c14f-20c2-4138-1abc-08daf44a4e2b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 03:08:40.4113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vx+if/KySe/dd/sb1sDhPcXwiu/1F18OCT5nzm7njrMg2qmE1sQF8gX/9x0nwMZzkPDnZkAXhLIJpMbi6l/jHg+LGRCGGCg/Gc0oU89H4ss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6595
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_10,2023-01-11_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120019
X-Proofpoint-ORIG-GUID: ljP5-HTMsuuuPSKrJIL0KqeLQolqSsnh
X-Proofpoint-GUID: ljP5-HTMsuuuPSKrJIL0KqeLQolqSsnh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This allows target_get_sess_cmd users to pass in the cmd counter they want
to use. Right now we pass in the session's cmd counter but in the next
patch iSCSI will switch from per session to per conn so this patch will be
needed for that conversion.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c    | 10 +++++----
 drivers/target/target_core_transport.c | 28 ++++++++++++--------------
 drivers/target/target_core_xcopy.c     |  8 ++++----
 drivers/usb/gadget/function/f_tcm.c    |  4 ++--
 include/target/target_core_fabric.h    |  8 +++++---
 5 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index baf4da7bb3b4..87927a36f90d 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1190,9 +1190,10 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
 	 */
 	__target_init_cmd(&cmd->se_cmd, &iscsi_ops,
-			 conn->sess->se_sess, be32_to_cpu(hdr->data_length),
-			 cmd->data_direction, sam_task_attr,
-			 cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun));
+			  conn->sess->se_sess, be32_to_cpu(hdr->data_length),
+			  cmd->data_direction, sam_task_attr,
+			  cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun),
+			  conn->sess->se_sess->cmd_cnt);
 
 	pr_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
 		" ExpXferLen: %u, Length: %u, CID: %hu\n", hdr->itt,
@@ -2055,7 +2056,8 @@ iscsit_handle_task_mgt_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	__target_init_cmd(&cmd->se_cmd, &iscsi_ops,
 			  conn->sess->se_sess, 0, DMA_NONE,
 			  TCM_SIMPLE_TAG, cmd->sense_buffer + 2,
-			  scsilun_to_int(&hdr->lun));
+			  scsilun_to_int(&hdr->lun),
+			  conn->sess->se_sess->cmd_cnt);
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 60647a49a1d3..c395606ab1a9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1441,14 +1441,12 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
  *
  * Preserves the value of @cmd->tag.
  */
-void __target_init_cmd(
-	struct se_cmd *cmd,
-	const struct target_core_fabric_ops *tfo,
-	struct se_session *se_sess,
-	u32 data_length,
-	int data_direction,
-	int task_attr,
-	unsigned char *sense_buffer, u64 unpacked_lun)
+void __target_init_cmd(struct se_cmd *cmd,
+		       const struct target_core_fabric_ops *tfo,
+		       struct se_session *se_sess, u32 data_length,
+		       int data_direction, int task_attr,
+		       unsigned char *sense_buffer, u64 unpacked_lun,
+		       struct target_cmd_counter *cmd_cnt)
 {
 	INIT_LIST_HEAD(&cmd->se_delayed_node);
 	INIT_LIST_HEAD(&cmd->se_qf_node);
@@ -1468,6 +1466,7 @@ void __target_init_cmd(
 	cmd->sam_task_attr = task_attr;
 	cmd->sense_buffer = sense_buffer;
 	cmd->orig_fe_lun = unpacked_lun;
+	cmd->cmd_cnt = cmd_cnt;
 
 	if (!(cmd->se_cmd_flags & SCF_USE_CPUID))
 		cmd->cpuid = raw_smp_processor_id();
@@ -1687,7 +1686,8 @@ int target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 	 * target_core_fabric_ops->queue_status() callback
 	 */
 	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess, data_length,
-			  data_dir, task_attr, sense, unpacked_lun);
+			  data_dir, task_attr, sense, unpacked_lun,
+			  se_sess->cmd_cnt);
 
 	/*
 	 * Obtain struct se_cmd->cmd_kref reference. A second kref_get here is
@@ -1982,7 +1982,8 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	BUG_ON(!se_tpg);
 
 	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
-			  0, DMA_NONE, TCM_SIMPLE_TAG, sense, unpacked_lun);
+			  0, DMA_NONE, TCM_SIMPLE_TAG, sense, unpacked_lun,
+			  se_sess->cmd_cnt);
 	/*
 	 * FIXME: Currently expect caller to handle se_cmd->se_tmr_req
 	 * allocation failure.
@@ -2986,7 +2987,6 @@ EXPORT_SYMBOL(transport_generic_free_cmd);
  */
 int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 {
-	struct se_session *se_sess = se_cmd->se_sess;
 	int ret = 0;
 
 	/*
@@ -3003,11 +3003,9 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 	 * Users like xcopy do not use counters since they never do a stop
 	 * and wait.
 	 */
-	if (se_sess->cmd_cnt) {
-		if (!percpu_ref_tryget_live(&se_sess->cmd_cnt->refcnt))
+	if (se_cmd->cmd_cnt) {
+		if (!percpu_ref_tryget_live(&se_cmd->cmd_cnt->refcnt))
 			ret = -ESHUTDOWN;
-		else
-			se_cmd->cmd_cnt = se_sess->cmd_cnt;
 	}
 	if (ret && ack_kref)
 		target_put_sess_cmd(se_cmd);
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 49a83500c8b7..91ed015b588c 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -591,8 +591,8 @@ static int target_xcopy_read_source(
 		(unsigned long long)src_lba, transfer_length_block, src_bytes);
 
 	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, src_bytes,
-			  DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
-
+			  DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0,
+			  NULL);
 	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, src_dev, &cdb[0],
 				remote_port);
 	if (rc < 0) {
@@ -636,8 +636,8 @@ static int target_xcopy_write_destination(
 		(unsigned long long)dst_lba, transfer_length_block, dst_bytes);
 
 	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, dst_bytes,
-			  DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
-
+			  DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0,
+			  NULL);
 	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, dst_dev, &cdb[0],
 				remote_port);
 	if (rc < 0) {
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 658e2e21fdd0..c21acebe8aae 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1054,7 +1054,7 @@ static void usbg_cmd_work(struct work_struct *work)
 				  tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
 				  tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
 				  cmd->prio_attr, cmd->sense_iu.sense,
-				  cmd->unpacked_lun);
+				  cmd->unpacked_lun, NULL);
 		goto out;
 	}
 
@@ -1183,7 +1183,7 @@ static void bot_cmd_work(struct work_struct *work)
 				  tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
 				  tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
 				  cmd->prio_attr, cmd->sense_iu.sense,
-				  cmd->unpacked_lun);
+				  cmd->unpacked_lun, NULL);
 		goto out;
 	}
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 65527174b8bc..d507e7885f17 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -151,9 +151,11 @@ void	transport_deregister_session_configfs(struct se_session *);
 void	transport_deregister_session(struct se_session *);
 
 
-void	__target_init_cmd(struct se_cmd *,
-		const struct target_core_fabric_ops *,
-		struct se_session *, u32, int, int, unsigned char *, u64);
+void	__target_init_cmd(struct se_cmd *cmd,
+		const struct target_core_fabric_ops *tfo,
+		struct se_session *sess, u32 data_length, int data_direction,
+		int task_attr, unsigned char *sense_buffer, u64 unpacked_lun,
+		struct target_cmd_counter *cmd_cnt);
 int	target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u64 unpacked_lun, u32 data_length,
 		int task_attr, int data_dir, int flags);
-- 
2.31.1

