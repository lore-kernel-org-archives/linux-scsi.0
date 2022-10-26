Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3DC4FA3742
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 23:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbiJZXZG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 19:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233784AbiJZXYl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 19:24:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928B915747C;
        Wed, 26 Oct 2022 16:22:12 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM3G31014699;
        Wed, 26 Oct 2022 23:19:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=tK+bsy3wrzj0WqmQbPNp+kxYuYFoxLUwKLFSYqtmQ8Y=;
 b=uF8flnIQxV2AR3ebLwVQgPmCmGlCbShVgjxp8Vmo1BwJnJqkFywfB9WRz7p08/WIfuVC
 2FXLZNLEOjlwr0SVDEXNdxrY2lqST5QaI38PAFLiZ2J1Hisk/QDzexyqPqZPV75pusnj
 F3/Bmj6xwdoG4ihsdXTTo4ifnMCThgn09cEilBTPnllQluflPknGitAdYns/O6RC93bz
 Vq7B3KVOWY4AX6LqOfv/Q8UOBQdPVdwQrMgLJ8zt6NxFn9Lmyj6jVAJv5ZRsSn9nvULV
 6Fj5ZWS4uV1QrLZLm1SwrvH4dYc4lTA2Dt5tj8Obc6oytbNGOLwutpQNWvjkO3cRmAa8 5Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfays0jf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:19:56 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM7DOA006899;
        Wed, 26 Oct 2022 23:19:56 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfaggdrg5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:19:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C3rq0Zx4cYG/xL2iZsMby52Abts9l/SColwzlO02MhKMwUBnUiEnXTWvM9x8Jw7/Aw51AAwQcVRWK2tR/uhIQtvlUi+6+hWKz+HK3wckSDfQs0OZddVp3eDx0yFIwXDN2LlM0UidZP8lucZyJUFs5bOqBkPTG9qzKnJV32tL5rt470KbN9OQCm0n/rUKpZ2YIyxn+zEW1XVUZtzbqWLgSa3JKicZKD9GFuYU2zvEJws4y3owKIL/v1/jF6c5QFJ1v6pUfe1CmKJ7kOCWTiNuWjpB9mypsxu3I7Ru6OFCYxJ6iJBJHXeshrFvTan7BldZ3PKKZRxbSrXgHw8n2WPR3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tK+bsy3wrzj0WqmQbPNp+kxYuYFoxLUwKLFSYqtmQ8Y=;
 b=VjsgwFy04zhuid6+L7Sooor4N4GCRtRYswUyq51lJpO5QCiNY8QkDXSLr/Lpp4CtxSZb0P21j9fmQy63HMfZUzz0DxigdleecducRQI4sl1o/YXAyULOUDn9Ah5B8HnP0U1+KKwWrBChl/5HfJKih/s8DK8QfnkT+7zSwkRPMGT1jjxR1WLFugYoO2a50bQgv5nEL4FZuMr6t7WawyS+9ZNiaQ6ltc9LJb+gf4GaA5F9BAKcZzU7cHCiUWrdybrBgXyK+OgtDvV0MYHyKLDPjxSdc8V1T0huwoSmXmeDYqMLp9wwl01kaeIDdhdSVUxe+9bywOSZZ5VNKCEpHAl4Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tK+bsy3wrzj0WqmQbPNp+kxYuYFoxLUwKLFSYqtmQ8Y=;
 b=lU178mnKqOjH0mzpQC/uS/61I5jCTkqvcOUJFMCfs+CVIxi4iftMK57cGYTCAE0A5D/DeuI/szROOmlkYxWVK3xN1qH5q6OETj/iL9OD5QkUhj5lN38hv6VRYoMcgK3sEbVdcgPmHjG7uSuIP2RLDvwVkQjBvbNzFZyt2LTgKdg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5117.namprd10.prod.outlook.com (2603:10b6:5:3a6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Wed, 26 Oct 2022 23:19:54 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:19:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 04/19] scsi: Add support for block PR read keys/reservation
Date:   Wed, 26 Oct 2022 18:19:30 -0500
Message-Id: <20221026231945.6609-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0075.namprd04.prod.outlook.com
 (2603:10b6:610:74::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: 4268b3b1-7c2f-47dd-1ec7-08dab7a8973e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d3LqOwSGJ2gGy2ILbgz9rxjLBv3cS26OQgehEjXWZRTO+8FXz5bAUqXYh9B+cfaCA+YPT97U66ruu6ZD3sPeg4u0vOTBfF/liJkwdIgr63UZwTe9tLJs2Hq2q/eXjQFpQ4jhlCU6mDu0VBEQbRjfH/Q8/IlCsP0HohHIPkJWQPk9mnTv7LrqIqFylEHbL3AV7Nmd456EGI2y2XvZjIjCYc6yzS2b8ukvAySPVH5qqLTsf/K/gSU2h5UxKz1eg99wISkJ9rEpWsctx/hC0E7iPJxRXmvXxeUwEPneSmOtrsle+1aaXWqlMa9yodeQHU6gqA9XG8I9s0dGRfHNUoyQ9zcBdrrwPNl4GY3n4K8EzH+GqYgjgRtMx2ucx2PphyQRG0u6uy3eCtMdWINZztX9bFgX7Xsd7ujb3GZj0aj+S8nZFcBldJfmEsbv2bgtQrmIdY3B6+10LW9NVgz0wfvxS2HBgKgSC9rd/5/yQALUSKtqUim0dVjFjdw1INgouse2nw2qe7rdeEwRgphtdlTJ24j0Zp4d3BTMx8cQ8MZqo4+SFNWEM6kxWmW5Q7m7RE+fe5LcQBmXBm7Shi5StynIbWRU2WYEHs7pmQNXgxD4fjAfExp95nLV3f7wBQLPD2gOcLyHAWtLfyCz3u4fGYAjif/5CTFlnm4WFboxtTK6gvCKXdektYv/GpqAlOmfgfhHcCKhJJ5Nn5nOzMJJWGhyQiTWDJ71bzBympRwlvOpKe9NKgjBkRlnzmOYDhs6a+X6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199015)(7416002)(8936002)(2616005)(1076003)(186003)(5660300002)(6512007)(41300700001)(26005)(86362001)(921005)(38100700002)(2906002)(36756003)(83380400001)(316002)(107886003)(6666004)(4326008)(66556008)(66946007)(66476007)(8676002)(6506007)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W+mEVVXEnp0I5EH/A4pg7DyJwrXanlgrPM7XDuoskSXl+ebeeGp27xpHqIO8?=
 =?us-ascii?Q?kno4EPlTbhVSgBdOHymLr7OElchBM4cUeHadCa3pIY4I8hc9HzVP1fXKaMrj?=
 =?us-ascii?Q?0dvh3nritlGfQv0fEQa7I/6PcLG2gvreXtfiSUXtN8AfiP+Ap8RZPa73hYVE?=
 =?us-ascii?Q?E01x9AeUqWdqZIad65fA1XAgboWcOc6inb/a0AMhhKZE3Pa/HzOJLb34xNTr?=
 =?us-ascii?Q?X2x+W3uAc8Kbm5rrBKmAv1RwAh5PwFijhstM0C3t/W4DGsg+CdKysqKz2BRW?=
 =?us-ascii?Q?75HlJ0tBkh2V8g4HobbCX0+ahEV5LJI+aNgojN9BI2ZlwSd4cTJEzt7HaCKG?=
 =?us-ascii?Q?z/vpD1U1b0mrrlKAkplXUxz6Qj4bhq6JW7noFVdqfy2LZeerOG7FFFlApFJY?=
 =?us-ascii?Q?Q2+/T3gWJv5Mai3JTPRYWCfoIdHEIiqDBjuItXN8MdxbrXsm2olv7ihqTfVf?=
 =?us-ascii?Q?MbumOdAK543TapCscMFE2CSEv6Npl5oMjAL7pMjqCW+eIfBAvV+UlDbepMcX?=
 =?us-ascii?Q?zRodNR8eHK6u/8MN/uBG3YL3gsAGPJ+91jpKjki0mzGoVlmoBYDyuocVqUTQ?=
 =?us-ascii?Q?pDMi80LqQ5GKAUESONWKTyilClwR9vBegvqIJqCeONn/lKI4fN6M98el8W0g?=
 =?us-ascii?Q?fWMeEQoqaTKy73fsl2yRvW6eU2FlPOoyWTlW3d/Mn7Me97trHX6e0NI7+Ucr?=
 =?us-ascii?Q?0SyIHiZprkcOVABQgJZPXUFqf7EBxfUFypxJoOPqBqsHb2HyhPyFKHh+Jl6l?=
 =?us-ascii?Q?dyj8y+OIpHZvF9y43V6L8TGZTqRSsiK+VPioEbb0ShJPFCHqt5H3MSFONw/Q?=
 =?us-ascii?Q?vZatKatGUeErVJ6zLBP3SS0ikFHxCFUNLf+BAxhTdFI//0ArA7OffFjuP2J+?=
 =?us-ascii?Q?hnd//YQ6B6rnXh1HYBpF2a3+Y4ZFV8ojXlmpjuG6WNkE1zMQvE+gy4qxvxuR?=
 =?us-ascii?Q?VghH2XebKzATlcxNcEuzoPYA1QwzOvWRDjW4d+x/3fZqjRzEQK1KuUtnj0QJ?=
 =?us-ascii?Q?SBQTpXpLh+ZXgezeOwshWakaRG/tA8TzNshPTfyw04kWXRUmIo4ObXg0sZcO?=
 =?us-ascii?Q?kqbMPdQ4CFtSioWdKFBVM/Qev3ha8XOjItGtBjjZeAMU9S8IgW0yDh6XJTpb?=
 =?us-ascii?Q?LU1nTPBg0jR40yd+cAwqjEWoCbjcjPNLMzcBLNpkcs3+h3zeXuLaY5tLxm+7?=
 =?us-ascii?Q?Ao+yoTJgaFrpbPLfoh/4TIPLdyh3muGFfkWsxrSN9Q+xax/A7zESD5ll1Qwz?=
 =?us-ascii?Q?wWt4SD5LPB0OoXwtV+/VQE0he72Ya0Qs7SqdArEKFhXyTpqF6deTvKBm6js3?=
 =?us-ascii?Q?0lX6a9gUKTkP4TJgW7QoUn7926SZ8VIeoYam1Xp0lUW8ITEIgWaR4RfstLoW?=
 =?us-ascii?Q?hU6EbRB7sI4bFX56GWTjibADjJZE+KU8W3UTGJQnl7zpfnlSA32Qiw++fY1Q?=
 =?us-ascii?Q?hJRyth6NgN93mpZV2YKD1AKuYpHuKOxCYjw51aaSwfZ3P6aYiUAGptEESPa2?=
 =?us-ascii?Q?mBWqDgDWYJpLfFeIimvkZKD2ZFqou4jry3eY2H5nRvcza2EFBftoWE9yHHvs?=
 =?us-ascii?Q?x/nVFq6UZ0rJ59rsMMvKujO6iKh5TzER8GJwu8oVB01bBc9qF+xai/MLzil+?=
 =?us-ascii?Q?zQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4268b3b1-7c2f-47dd-1ec7-08dab7a8973e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:19:54.7572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ISDdVSXoIBZYmbyQHpcd1GGOxwwExVEnQUhV/od0D5Ni2t8BQj7M+U6Q/UrrK3xpu4VaZLOjJEmDrDi500dT9uVFPhVZvHzceANB8DGuZ6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5117
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-ORIG-GUID: _lesu5tDV6ptlLEOxODzWXY3G-xBinMW
X-Proofpoint-GUID: _lesu5tDV6ptlLEOxODzWXY3G-xBinMW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds support in sd.c for the block PR read keys and read reservation
callouts.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c            | 104 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_block_pr.h |  20 +++++++
 include/scsi/scsi_proto.h    |   5 ++
 3 files changed, 129 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ad9374b07585..86b602399000 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1695,6 +1695,108 @@ static int sd_get_unique_id(struct gendisk *disk, u8 id[16],
 	return ret;
 }
 
+static int sd_pr_in_command(struct block_device *bdev, u8 sa,
+			    unsigned char *data, int data_len)
+{
+	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_sense_hdr sshdr;
+	u8 cmd[10] = { PERSISTENT_RESERVE_IN, sa };
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 5,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
+	int result;
+
+	put_unaligned_be16(data_len, &cmd[7]);
+
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = data,
+					.buf_len = data_len,
+					.sshdr = &sshdr,
+					.timeout = SD_TIMEOUT,
+					.retries = sdkp->max_retries,
+					.failures = failures }));
+	if (scsi_status_is_check_condition(result) &&
+	    scsi_sense_valid(&sshdr)) {
+		sdev_printk(KERN_INFO, sdev, "PR command failed: %d\n", result);
+		scsi_print_sense_hdr(sdev, NULL, &sshdr);
+	}
+
+	return result;
+}
+
+static int sd_pr_read_keys(struct block_device *bdev, struct pr_keys *keys_info,
+			   u32 keys_len)
+{
+	int result, i, data_offset, num_copy_keys;
+	int data_len = keys_len + 8;
+	u8 *data;
+
+	data = kzalloc(data_len, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	result = sd_pr_in_command(bdev, READ_KEYS, data, data_len);
+	if (result)
+		goto free_data;
+
+	keys_info->generation = get_unaligned_be32(&data[0]);
+	keys_info->num_keys = get_unaligned_be32(&data[4]) / 8;
+
+	data_offset = 8;
+	num_copy_keys = min(keys_len / 8, keys_info->num_keys);
+
+	for (i = 0; i < num_copy_keys; i++) {
+		keys_info->keys[i] = get_unaligned_be64(&data[data_offset]);
+		data_offset += 8;
+	}
+
+free_data:
+	kfree(data);
+	return result;
+}
+
+static int sd_pr_read_reservation(struct block_device *bdev,
+				  struct pr_held_reservation *rsv)
+{
+	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
+	struct scsi_device *sdev = sdkp->device;
+	u8 data[24] = { 0, };
+	int result, len;
+
+	result = sd_pr_in_command(bdev, READ_RESERVATION, data, sizeof(data));
+	if (result)
+		return result;
+
+	memset(rsv, 0, sizeof(*rsv));
+	len = get_unaligned_be32(&data[4]);
+	if (!len)
+		return result;
+
+	/* Make sure we have at least the key and type */
+	if (len < 14) {
+		sdev_printk(KERN_INFO, sdev,
+			    "READ RESERVATION failed due to short return buffer of %d bytes\n",
+			    len);
+		return -EINVAL;
+	}
+
+	rsv->generation = get_unaligned_be32(&data[0]);
+	rsv->key = get_unaligned_be64(&data[8]);
+	rsv->type = scsi_pr_type_to_block(data[21] & 0x0f);
+	return 0;
+}
+
 static int sd_pr_out_command(struct block_device *bdev, u8 sa,
 		u64 key, u64 sa_key, enum scsi_pr_type type, u8 flags)
 {
@@ -1787,6 +1889,8 @@ static const struct pr_ops sd_pr_ops = {
 	.pr_release	= sd_pr_release,
 	.pr_preempt	= sd_pr_preempt,
 	.pr_clear	= sd_pr_clear,
+	.pr_read_keys	= sd_pr_read_keys,
+	.pr_read_reservation = sd_pr_read_reservation,
 };
 
 static void scsi_disk_free_disk(struct gendisk *disk)
diff --git a/include/scsi/scsi_block_pr.h b/include/scsi/scsi_block_pr.h
index 6e99f844330d..137bf2247273 100644
--- a/include/scsi/scsi_block_pr.h
+++ b/include/scsi/scsi_block_pr.h
@@ -33,4 +33,24 @@ static inline enum scsi_pr_type block_pr_type_to_scsi(enum pr_type type)
 	}
 };
 
+static inline enum pr_type scsi_pr_type_to_block(enum scsi_pr_type type)
+{
+	switch (type) {
+	case SCSI_PR_WRITE_EXCLUSIVE:
+		return PR_WRITE_EXCLUSIVE;
+	case SCSI_PR_EXCLUSIVE_ACCESS:
+		return PR_EXCLUSIVE_ACCESS;
+	case SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY:
+		return PR_WRITE_EXCLUSIVE_REG_ONLY;
+	case SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY:
+		return PR_EXCLUSIVE_ACCESS_REG_ONLY;
+	case SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS:
+		return PR_WRITE_EXCLUSIVE_ALL_REGS;
+	case SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS:
+		return PR_EXCLUSIVE_ACCESS_ALL_REGS;
+	default:
+		return 0;
+	}
+}
+
 #endif
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index c03e35fc382c..0fd6e295375a 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -151,6 +151,11 @@
 #define ZO_FINISH_ZONE	      0x02
 #define ZO_OPEN_ZONE	      0x03
 #define ZO_RESET_WRITE_POINTER 0x04
+/* values for PR in service action */
+#define READ_KEYS             0x00
+#define READ_RESERVATION      0x01
+#define REPORT_CAPABILITES    0x02
+#define READ_FULL_STATUS      0x03
 /* values for variable length command */
 #define XDREAD_32	      0x03
 #define XDWRITE_32	      0x04
-- 
2.25.1

