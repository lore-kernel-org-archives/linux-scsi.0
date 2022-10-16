Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B363C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiJPUAY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiJPUAQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:00:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4560724083
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:00:15 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJ231g011591;
        Sun, 16 Oct 2022 20:00:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=CXUz2yZLTeZd2IGr7kDd+IYyEIT9Z5E7aRKgFVaRZhk=;
 b=GDEgeH0mLo5joGYfl3ZRqdq7omdMhaVc4LO9/zQb9swSbs2CQNOYfHByoIA2w4liYLpv
 8oYU1dPu89oyrOfYVisM73CFG7Vs5PIXHGkyB6gBd49vdo5pFFftHoSSf6Hz7RRR5eaf
 mN7t9nfA0cblkV0Te1vYxsyE2g2hqTH6PU0YXmdm6SWlcDY7/3osViwYIQC/hZf0YTs9
 Vo3z7ju29ltCGWAd25jPNPJU0SJHfqKankNl5JGuj/PP+XrEbQk4wC0QPObmjZSKNEu+
 fMYjVK83M14CcYYHYLaLbp1Yh+qoZs2k29YvSuGxg+HNm6SbtsNL6mUo3u1QudM3clFb VA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mw39ydc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:08 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCAneH001181;
        Sun, 16 Oct 2022 20:00:07 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hqwmgmf-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P096T1IiySh2arWCr5ZFYaxyEuinDcRak+g7OhhP9MBjYuQtLeXT2xoMzbgYeKxyUrmoxZdmRzMaEw/nD3AHVjlenrI8QSBf+coktZP+Uz5db0YGMRSO8CyAOzYl3vcmPIsSqrmMzLPDPRWmz3s5W1/aOLk1Lcu5WNvyjtZnjoFSXfHYdUCCip3icDyGywurxoFk1ev9PCN1Ydv5VpJZRjTAFAaVBW5GCMqlUFiGJzngSjksTkLgn8lL6KwX+y1vRh9WBFv7QtT/Lr1zu4BvlrDjBW+QoKjTKdM+yHLMEcfo9jB8cvzMIS84l2kfobOEfX9dtGvywMSfVF1+IHTNGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CXUz2yZLTeZd2IGr7kDd+IYyEIT9Z5E7aRKgFVaRZhk=;
 b=FCqPstivTW3HgTBpeGWs+IYzr+9b479ZxQpsUa+q9DjpiJHtEq99gFe32weJLospScsXU+52C3Aq0KCOrxykln+nKCu6qbSrdmQSPcPeoHpIdDpUdSPMJw7PvKHdYm0V+Rkv7GNZDjsAGBp+CWq1Jnwp3ptP0mDgPi1IXKXK3w6ww3whoin9A8jawid3/B2NyGkqs/ky08Gk58kgzS8YtwOOHaE9oYgVtvUyuMso/wNHgSEQHy6ZYHOmDEicYMWxcp3of0vsftgeDySFNirwzXiNgmOC+qhkv6WLWiKBJASPlVPWZGAWv9pLebuFG5PtoZGrih+wFW+B1tX3dTS3AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXUz2yZLTeZd2IGr7kDd+IYyEIT9Z5E7aRKgFVaRZhk=;
 b=XpbXhxLJjvSC9jjnchDtWh4dgjfClW++RqDsCsHzLxbUMTKmbGms21xb9awpR7y1wXpmWTrVAju3cQhuJWOqk87SaQfzKJdSUasg28JS8oQnxqmAaEl2Vr/jT2iUBKXwg+drRibW+2WQW4vKazMlHHSW7o3HJV5mrkGGosYG9qo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6727.namprd10.prod.outlook.com (2603:10b6:8:13a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Sun, 16 Oct 2022 20:00:03 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:03 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 09/36] scsi: core: Convert to scsi_exec_req
Date:   Sun, 16 Oct 2022 14:59:19 -0500
Message-Id: <20221016195946.7613-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0025.namprd20.prod.outlook.com
 (2603:10b6:610:58::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: 7659ed54-f46d-4516-9ea6-08daafb103ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P7bkYcm8D6HYsPzXyFCQcoMPB7y6TrUjYP6AYdvsO05L4AdmcGE0wY3bPvsrVpsoMxAsYDBAyA1kVCQU/6Tmo2o+k9jSGQv7QBMt0BvWZllnZS3YlrC7peKDC+V+TFCl650wGue6/xM2+3edodpc1k6bHAIPERz5yKCnPTZ8IXrD+GZrEv3aMXEYeZhSS2+snnwnDQzjeHCq18dTYbhj3CXH5k5oFqX4JAI4nNEto2Rv27UvKRsdYXCtdY7+lO+kE6KpOWIv/HamqSyq0DIpFwFi3I3TK5DYpHdkpQ35yIjvDv6asAPl8hI+stuy/HufH4eLyR36ttYxZqBAXvRQeMqbXRY+8dhD1Yn8KD8IWBUA8w3tr11oKP7w+8sLqvIdnDO6hfwjJEs7TbMYVoZwhoZs4Jj3nAGhJrED/bXTFKpTDyR/Ao1lT5Fpf2WCIT28JgjiRVz++0ZgwLhv17UezNjtfXcIo5y6BwMrA9jBZwFNafaLp2GA1fpVnoUU0wCYaaMy1El8NhFGVbTidOQk+F6Vv7zogFV4M9HRvNxILCV5EMfUXS6x9DqPJ1eBa5i7CkyVD7eASZaLyS72qlDRwGNJegvQ6dwTVp3QkJFHp7NM28D6XmgnWqaG0HEjDu+7WnQpzLdf56urcLsb1lEfp0tB4hblqMT7PSOPE2tAjFpc8yQ5vdMITLqAAjPQvZ6DWTxSsUkiCkECWntvGwfcnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(38100700002)(478600001)(6486002)(186003)(4326008)(2616005)(36756003)(6506007)(316002)(66476007)(107886003)(66946007)(66556008)(6666004)(1076003)(8676002)(5660300002)(6512007)(2906002)(26005)(8936002)(86362001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U2QA3MtRODsaNusNm+kE/HpQttnyXyfP0QZKaGb55ZYP+ZqBawbMLiJprjQd?=
 =?us-ascii?Q?TmeqnRpusn+35WKyLnck1W3rxuwSBUSvlnhRW+PckKhK49vE8x5R7at6JY42?=
 =?us-ascii?Q?LS7K4QhpdwtlYLBue6RZ/YzeDohhLG7YJdgtkbt5y3sz+14P7h/6N5iBbTIf?=
 =?us-ascii?Q?7IJtAMm13vVv1zfHD/UrsNUTMzKRmU84eqVUjo5kIHxLbqGKM6qH5uEL5H4i?=
 =?us-ascii?Q?Fuc7LJYy2pxCtNqAt3g2xJStQtbS0gpiRB71pnvsOjqqbsLkNirNw8wkwKJw?=
 =?us-ascii?Q?Pv+JBmA87JKV5+KW5wn3+Pv1J6j9eux32QoVhTP2tRSSFan6NAEFcnB96zQi?=
 =?us-ascii?Q?mQiwGvRVXMR4ce813WmhUg1YnzYfp34Vs3ooUSchdzl6rhNQTuYT7eW0mi4i?=
 =?us-ascii?Q?4XvR6AiMoNZ4wk2lcTgUCKt89lH2No6WaaMoyfcniEAYeEYwTsVs7WZ1OUBW?=
 =?us-ascii?Q?IXFf6pUbIP1YnqIGWg55sHRzx2VBXhs45WIr4vAwxARpWiRZDIX2eHbXKHIy?=
 =?us-ascii?Q?kb0TQvIrCH/1j6F2q3sOvvqO6nsr6sdc9yFZ/FSGd64UDGHeFkCJxKB63z8f?=
 =?us-ascii?Q?I9aWlLyve6/60Q9yY58c+xLwckCtes8NhbLOGnXbchNMbbNMNZenxvWmX94o?=
 =?us-ascii?Q?bqkM+Ax3osbYEN1Q4u4FXPVfzBArDZKiYfDNFw5Th/60s9YdKzeYgIjQJyIi?=
 =?us-ascii?Q?M0ZWGpym/hWsFI2uGxRP8UA6UitKP1XtIWBuROJVDTfa19Uxmf8COEXB3MY7?=
 =?us-ascii?Q?V/NfQHzFuZoRKYyZ5VS3k/Frph8/T9PifvGpUCXp5On9TLRXN82CrSPd74Zm?=
 =?us-ascii?Q?73AX7za22AibvXYY7RkwRw7iJQFOQewoN4DvPmn7N4aHyLTFBbpYM/+FpmFi?=
 =?us-ascii?Q?FofFjFQmsuSId9A0nawzpn0TS/vSYBIFh3e1gKW88aJlYvPChKI+9TiXUFwB?=
 =?us-ascii?Q?PSEnJ5h4CvhHGwfihDsfUP7c6hGgW/86b9O1r97Y4pWtWDPfNGGiumRuDB+b?=
 =?us-ascii?Q?NHtdOS9latYg+ZuDnmsFkQcsFQLuvpK1YKqzYYDdG4giYTeZruK8i/Pxaxfu?=
 =?us-ascii?Q?x8nJOt95r8iqq3XTd7gerGdg+7yDNkODjz/jZFABCX0T/wlIgDC2NYMuA9o7?=
 =?us-ascii?Q?MUYz5BJdaDU56S6L5i22TdrFMtpC+LDW0vFh/OwX2M1KVTxhEab7t7v1Rt4o?=
 =?us-ascii?Q?MgdVfhCEidpmrlGDe1d+yDXqz5ufe7AYjA1LcUh5/Qk1V4gvd0ujKLTR1SBz?=
 =?us-ascii?Q?ctQE2k1dEPnVjOUMNZWhJvR5BhN67/BCS0wilnxOnrdBjkLfHWypIlDZ3DEo?=
 =?us-ascii?Q?9dDuZxMLdjJoKYwUT5kdJj+RhAGSixENyw/oP/nmq4xzFO1K8+Wc2n1EozPu?=
 =?us-ascii?Q?s2BXPL3ii8SEq7dV+Hiil+7PP6PPAfe/CsXt1sOfHTNayfbj5LWbJr7x1WWo?=
 =?us-ascii?Q?NgGxigCKiqrqLofgQDWY+cSd8igPcyD/UJ9b4uoQ2ixG9l6nQRnRupCvG8BL?=
 =?us-ascii?Q?MinLLhfTO5HjHmr3yfvwZEw2j5N2bD0iWaeQn89ef+VNBafJYULEU2vlGAlO?=
 =?us-ascii?Q?jbtQ/pygl6wrPu0S2q6JpsryGspX5ZP6O2K7Cmj7DwWMCCS1El167IgBeCzi?=
 =?us-ascii?Q?Mw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7659ed54-f46d-4516-9ea6-08daafb103ea
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:03.7376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Sk6QXvGFuOx+ZDtE35zecfpdT3Xr2oC8+9gIsIEJnCcznHUGzJ2Z0sRMvKP3YyBMAcdkJaUdSXqHz9L6d+zbRprBSeYvbocQsutlPni/Ak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: WFyqFUyjpjMapQRvULUnVCMriXnOIS-9
X-Proofpoint-GUID: WFyqFUyjpjMapQRvULUnVCMriXnOIS-9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c       | 21 +++++++++++++++++----
 drivers/scsi/scsi_ioctl.c |  9 +++++++--
 drivers/scsi/scsi_lib.c   | 31 +++++++++++++++++++++++++------
 drivers/scsi/scsi_scan.c  | 37 ++++++++++++++++++++++++++++---------
 4 files changed, 77 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index c59eac7a32f2..8d8090c8fb05 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -309,8 +309,14 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	 * I'm not convinced we need to try quite this hard to get VPD, but
 	 * all the existing users tried this hard.
 	 */
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  len, NULL, 30 * HZ, 3, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = len,
+					.timeout = 30 * HZ,
+					.retries = 3 }));
 	if (result)
 		return -EIO;
 
@@ -531,8 +537,15 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 	put_unaligned_be32(request_len, &cmd[6]);
 	memset(buffer, 0, len);
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  request_len, &sshdr, 30 * HZ, 3, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = request_len,
+					.sshdr = &sshdr,
+					.timeout = 30 * HZ,
+					.retries = 3 }));
 
 	if (result < 0)
 		return result;
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 2d20da55fb64..67f291cb0042 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -73,8 +73,13 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 	SCSI_LOG_IOCTL(1, sdev_printk(KERN_INFO, sdev,
 				      "Trying ioctl with scsi command %d\n", *cmd));
 
-	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0,
-				  &sshdr, timeout, retries, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_NONE,
+					.sshdr = &sshdr,
+					.timeout = timeout,
+					.retries = retries }));
 
 	SCSI_LOG_IOCTL(2, sdev_printk(KERN_INFO, sdev,
 				      "Ioctl returned  0x%x\n", result));
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0ad0e476f2cf..e9b19fa939eb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2123,8 +2123,15 @@ int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
 		cmd[4] = len;
 	}
 
-	ret = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, real_buffer, len,
-			       sshdr, timeout, retries, NULL);
+	ret = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_TO_DEVICE,
+					.buf = real_buffer,
+					.buf_len = len,
+					.sshdr = sshdr,
+					.timeout = timeout,
+					.retries = retries }));
 	kfree(real_buffer);
 	return ret;
 }
@@ -2188,8 +2195,15 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 
 	memset(buffer, 0, len);
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
-				  sshdr, timeout, retries, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = len,
+					.sshdr = sshdr,
+					.timeout = timeout,
+					.retries = retries }));
 	if (result < 0)
 		return result;
 
@@ -2273,8 +2287,13 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 
 	/* try to eat the UNIT_ATTENTION if there are enough retries */
 	do {
-		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
-					  timeout, 1, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = cmd,
+						.data_dir = DMA_NONE,
+						.sshdr = sshdr,
+						.timeout = timeout,
+						.retries = 1 }));
 		if (sdev->removable && scsi_sense_valid(sshdr) &&
 		    sshdr->sense_key == UNIT_ATTENTION)
 			sdev->changed = 1;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 5d27f5196de6..58edd5d641f8 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -210,8 +210,14 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
 	scsi_cmd[3] = 0;
 	scsi_cmd[4] = 0x2a;     /* size */
 	scsi_cmd[5] = 0;
-	scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE, result, 0x2a, NULL,
-			 SCSI_TIMEOUT, 3, NULL);
+	scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = scsi_cmd,
+				.data_dir = DMA_FROM_DEVICE,
+				.buf = result,
+				.buf_len = 0x2a,
+				.timeout = SCSI_TIMEOUT,
+				.retries = 3 }));
 }
 
 static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
@@ -674,10 +680,17 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 		memset(inq_result, 0, try_inquiry_len);
 
-		result = scsi_execute_req(sdev,  scsi_cmd, DMA_FROM_DEVICE,
-					  inq_result, try_inquiry_len, &sshdr,
-					  HZ / 2 + HZ * scsi_inq_timeout, 3,
-					  &resid);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = scsi_cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = inq_result,
+						.buf_len = try_inquiry_len,
+						.sshdr = &sshdr,
+						.timeout = HZ / 2 +
+							HZ * scsi_inq_timeout,
+						.retries = 3,
+						.resid = &resid }));
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
@@ -1477,9 +1490,15 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 				"scsi scan: Sending REPORT LUNS to (try %d)\n",
 				retries));
 
-		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  lun_data, length, &sshdr,
-					  SCSI_REPORT_LUNS_TIMEOUT, 3, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = scsi_cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = lun_data,
+						.buf_len = length,
+						.sshdr = &sshdr,
+						.timeout = SCSI_REPORT_LUNS_TIMEOUT,
+						.retries = 3 }));
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
 				"scsi scan: REPORT LUNS"
-- 
2.25.1

