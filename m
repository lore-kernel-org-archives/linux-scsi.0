Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F913C25B0F
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 00:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiHIAEw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 20:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244455AbiHIAEu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 20:04:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B899F17594;
        Mon,  8 Aug 2022 17:04:49 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NweGD020677;
        Tue, 9 Aug 2022 00:04:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=TOWh3bAuUPX6VP7XrN6MZHu+fRMqHzUwFv7JzonhxfA=;
 b=sY/B5QFmmHK2ye3+N+G+onE1qZm9IiF5g1oO2NkxsujT8+D8O1qrv5w0bKCKXcGS1DFL
 3u3Z/hNfP8RHO4O3FD3rQicp8NzvCHqCNBuCTbHQ2TDTzZWKef1aYzBx/8EXhysMIsm/
 W408ACAi/z3pj53vPRanhouwOhqhCDHIjYWl8UQXyKmsdD93ftNmjjU8ur8DfdsNDQxm
 psG8l3Qym21h00qF/hqdZyOFdm/d5EVht2Ra8R4Yjrqacel6KQkVplpEgMQNOIMR9WT3
 vWJN3bUQvYTwTXtCO5/hDw93OpXzAeZLIuKGabcl2ppMhTbXf8LBipi5NfmVmWGt9SFv SQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsgut539w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:30 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278M0hLj038089;
        Tue, 9 Aug 2022 00:04:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hu0n32vhn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fY2/Xzs+ZxRoxxochO8rx1kbY8FmGyJH3ZyVPry6F1360xCVx4bwDewtpseqzoPwiZ9u8ftFMXNcAgGWwV39qJnnu1/2e8/0S/iQ46Ry4TSc9Wl7EFZ2q1teUcQfHu8EyIDIT0ctBXdwHdD00vIy9OcWPAgTzOzuRla02RNHV2caUMCH1yQ/Cacmw67mu+f1pcJDKLUlPeBsdTHP1+xrsMKrthzBxX0oTjNoJma3swm4JXbHhkH443Qe1WmXIWOLbuanGbf7nnpk0kcsutMb6P9DANy5NUoE8UhH2KnSJGNx+wc2wQ8NWsydL+jl9Uunr1p9vXB2fA+dNAO/0QKgYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOWh3bAuUPX6VP7XrN6MZHu+fRMqHzUwFv7JzonhxfA=;
 b=kPzcHFu7xd5NA1YRd/6txsLWPCc9K1fA8hyrWIIgGZXU/plWTy5b+KdE7Kj9jBRXt8jdKbD4vt3jlaxjxCKaT2d+0noR5kcvTx92DL7ngK1DxVGbwD8Bq4poH7JxRNovTrYJf9W06vlWW/zNRgXXAbhil/D1RRK+j8k9OqXyHp7M1k9/5fAltoNII1zfiQOSO1m48CP/0113KjBI8vsVW2zcCWmZe/f/wpjyh//kmBrgue+8XfN+v8+wcVemTHXydrmtezuDK1dN9RTT21+g1O0GU4FatKy6brhHEZgDn90asUcXMNNo/b6qn+//cCzcl7cUXr2YL7jB4OvFDZt/Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOWh3bAuUPX6VP7XrN6MZHu+fRMqHzUwFv7JzonhxfA=;
 b=Z+dlWA36LyEimjIaCPZd/HCGtUTwxGfrecQB0Z0wtRoXaBfQXPJE367JFvIGTilSCuVMRLBnwncNI4z71b0+jF5py160wOz98gkZQvatouM6BTqRDceKrr6u3bGuPqZdt2YwJBiPUjptZUJ2fjGEYe5iAWqRBPsGOgwbNVr3wDs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN6PR10MB2590.namprd10.prod.outlook.com (2603:10b6:805:45::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 04/20] scsi: Add support for block PR read keys/reservation.
Date:   Mon,  8 Aug 2022 19:04:03 -0500
Message-Id: <20220809000419.10674-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0069.namprd05.prod.outlook.com
 (2603:10b6:610:38::46) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b553e5a-1671-403c-3277-08da799ab9c8
X-MS-TrafficTypeDiagnostic: SN6PR10MB2590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qBeZ1/C0AVFv2b1X7vO15Wqx7Oi9ABTIEU499SYZkF3F+ssDMfvboFspgfSUppqA/mvq/O15MZvnFtVtHcNHx1AjZxqUyM8mfgj5fzYuC+XO/0xX6uE5oo5b3xcnkraC/OBphkpzHrUIp0G8/wKjSPx72niunTKLOl9P6ZGIl/7mmi8Zqaa+tBDgML1U42xNGrYEPUXQ4kohjpo0lBLYKT5cGYrd0lkQJMyjGNTZ8LP9v0wcCnnwxlPZj0jod3X/2Fyw3nDh3p4Z7VsucN3zfvdkkUtIPraAmpjxaHd0ntITezhHaOwKkreSeERTOvF/GprJ0Gd8wJ15h7ZtToB1xkDRocjBosPbD3I+DpEm59L1MWYyxYWSg7M+2eGm0cJl+YJYkeNePiH+B7SDtTx1vzO7ezhljiGKDpWoo7vqBjuo+oyfRULK4JCy6RGJmlaPpw2GZhnZPmgSut7MuoDSa0q5lk1twbpqOOI+eGdFW+RmG1oSTyhBVa+S5N8Ca21ozX4iPUWHpm63PwvkR4+9fgeAmIcTF4qC7d6slAFVNq7v+maJ3zeEuQ+qu1thu3YQuBnSUvfgslxlZOUMQShrnhIwbIFlY4vkk1fexDCTdeQzoMeEdU4zvs8/Xcw+nouDh93Mj4rqGeavO7XlsHKTo/z10v9krt7BPQ1DHc4KzRZovxI8WD47kQuvM90O1I+11Kxn4APY8x4j7hGZyC5smKv2jGcVBFhHenadk98niPFmE428mUBGqbql6h4serGOuD5cG4e6Mpb3B/c2ufP6jZ/iYxIRZKfpeu3fUgGD9Lw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(39860400002)(366004)(136003)(376002)(2906002)(83380400001)(6512007)(26005)(6506007)(186003)(1076003)(2616005)(36756003)(107886003)(38100700002)(86362001)(921005)(66476007)(6486002)(316002)(4326008)(6666004)(8936002)(66556008)(66946007)(8676002)(478600001)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q8DYItR18LfX+rGG23l5lC3T270xZy3KHo6C3GJ4GV8pP6AegXahAli8wk9D?=
 =?us-ascii?Q?E1BQWFqoAU8rvb+Ylr+WxCX/ZD0fQMc56cpnzf83+tY0jRTUBUEKnJBePaSE?=
 =?us-ascii?Q?1KLPC5FeTdGLT6Jwnwb3w/hWgNajAp/4I3TsP3n2avpi8R3IWOX0csmUU69n?=
 =?us-ascii?Q?jiY1h8J3WWLwakoSk/OEjYf568T95fCQSxUjQoucwroHazlvxaKvhldlAg02?=
 =?us-ascii?Q?SmSRr8uIeazm2eNJk2HJN4SmhJC8Zvr+36IwKajo5N9oDo9D+6ImIjb7B675?=
 =?us-ascii?Q?4S0JkTd3EC0Jn5/Ep6XxURhhz+RqnH7w7sAuLp+z4PBUfd+YoYLOJxOmprIq?=
 =?us-ascii?Q?5C0VvbZHHQDpS7i8zUSchZIxosymGajeA3sqDor2dRaO7uTEP1w9yW+QS1G1?=
 =?us-ascii?Q?r8KrMuV8E85tWw0iUTLu9LlYaLS6Jv/0r/TtqnUif2rD1NzxQwYWDxXZpvmo?=
 =?us-ascii?Q?i6qkcoUb8/IRsXQNkGpB8VaIRVzEzCpKKMPBVS5W56o4PbItbxH2xC+bSatj?=
 =?us-ascii?Q?qYbwBYNSNuCn+11XEXlKAYrAU4wizHBi3M2PGHfahphT+L0FxwcYrMbls2fV?=
 =?us-ascii?Q?iluqRHMUtCgrMpnwIImsvBD7cV+oMnvhIT2lXGwGVCxQMB6As4qRCAvHNr4g?=
 =?us-ascii?Q?F0uDtOfGRZwGxQEIFU/buNT1AWOSvf8fpsKGbFQygOfN8c55snxdlxg8B3Gg?=
 =?us-ascii?Q?HXv69E0jjeSsFiFfnGczV7Tu/FDT9jQ+RBNfPHMY/7cQy/FNP1AHH/BZZXyr?=
 =?us-ascii?Q?7mPNOUDpdsTpuEIwPORnouU82+GrJkHlBuvqjmJrd2wiFoWsiuGFX9SAdQ9E?=
 =?us-ascii?Q?TQL2Zl5cm9RVcsAoe4Ydd+GLrEunwbslHpDJm1KnFKKMygdQCECkuq6TJqO6?=
 =?us-ascii?Q?l7xfIbjdzUfZhYdSoMgsHB+1e24uTzdg02kFf7gQ9SJmrQOp8QEHExcm/UhY?=
 =?us-ascii?Q?+8GQ2LLZa/ulBG9m6Ipntgjl8tpwPnRuHD+ZDRBqZisYnJDsFE+JKbNlQuyI?=
 =?us-ascii?Q?qLPZ9q3dvng2/cxkUocnNYRvHXU3ls1qEDpP6vIa4Jgso4dCNcPbUX7NS9ms?=
 =?us-ascii?Q?XENwNBqiu0MLnfg1leQ8UzwKBsYiaWaNQ5LVnKwfeflq+u65FZHaybEI/LXT?=
 =?us-ascii?Q?80uL1iRywYqohGsRMImVv7Eh0acGGivQWMnyj7SLjSE/DTJgo2f+nyglWF1z?=
 =?us-ascii?Q?YTH7EWy05v/xSHQ+/Mxu/3h8Xwfdvo/lwtfdtmRepmgJb7HPT2vHnsDtonlh?=
 =?us-ascii?Q?ukTAYpKVpqd0iPXc0e2xkRZPiOGOvEbmjymXB5fEAlIHaSzN2OtBEBORfgha?=
 =?us-ascii?Q?Zd0LRoL0Ari1gbkcAx6eyKCLtS0BIydyUEV6N0QpIGFI2tbhazYmJZOQP5pW?=
 =?us-ascii?Q?JdwlFcBJZpslUOyhEKgh7bhSWBAJSj7hWKQS07SbbVF6C+feo6kpg1+UbgSZ?=
 =?us-ascii?Q?+v9ZD0OVybSGz/uN/MRggaoi+elvwdH183oEPfJZ37QxuJTA3+4TnpihltTx?=
 =?us-ascii?Q?nDp4d6zYuMqNHnllRcz9JkLlBjklA9I4TEMLvG1AfwPnx+Uptblm66RyCwpF?=
 =?us-ascii?Q?3+Yc7le76nGDCqsAPi2ElberLivRAf6TKWssX2qi8TaaOnB6rZFdb87pLCfI?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b553e5a-1671-403c-3277-08da799ab9c8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:27.6269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9agbnp4WCGuGJMDswSCeErMl0hu/WUKaJ11I2+7E10yMaEoIeg9ydZD2Dy+betCwAssikz6sZQbuLZCheLcyRhWm/Y4ofSXtXlKG2vKjqmA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: PhKwCM5YkdKfu68vMR_CzI-sVOpHy0x2
X-Proofpoint-GUID: PhKwCM5YkdKfu68vMR_CzI-sVOpHy0x2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds support in sd.c for the block PR read keys and read reservation
callouts.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c         | 88 +++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_proto.h |  5 +++
 2 files changed, 93 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 88ce1464527c..f1d4d0568075 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1683,6 +1683,92 @@ static int sd_get_unique_id(struct gendisk *disk, u8 id[16],
 	return ret;
 }
 
+static int sd_pr_in_command(struct block_device *bdev, u8 sa,
+			    unsigned char *data, int data_len)
+{
+	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_sense_hdr sshdr;
+	u8 cmd[10] = { 0, };
+	int result;
+
+	cmd[0] = PERSISTENT_RESERVE_IN;
+	cmd[1] = sa;
+	put_unaligned_be16(data_len, &cmd[7]);
+
+	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, data, data_len,
+				  &sshdr, SD_TIMEOUT, sdkp->max_retries, NULL);
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
 		u64 key, u64 sa_key, u8 type, u8 flags)
 {
@@ -1757,6 +1843,8 @@ static const struct pr_ops sd_pr_ops = {
 	.pr_release	= sd_pr_release,
 	.pr_preempt	= sd_pr_preempt,
 	.pr_clear	= sd_pr_clear,
+	.pr_read_keys	= sd_pr_read_keys,
+	.pr_read_reservation = sd_pr_read_reservation,
 };
 
 static void scsi_disk_free_disk(struct gendisk *disk)
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
2.18.2

