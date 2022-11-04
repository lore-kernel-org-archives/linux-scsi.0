Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D9AC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiKDXYb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiKDXYE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:24:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A5260E7
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:24:03 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj7Ga013358;
        Fri, 4 Nov 2022 23:21:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=SkkKotKylVfX7iw4b3lN4De9tC+CB1VWZ9B7wGdSk1M=;
 b=Ljj67fnmUj3syXf+RIVVZxeDyzJLgNbSxetyJ8xVxIXP5Ls9PaUCwVJJ5yWGr55yfs5/
 DmP11s74ZYY+ZxkK8c99tqAo+Lp/xV+QS6ArCpWtU3iX2UYGwfX0fjVJ6qjIEmrTdKXt
 7AgetGqKzvtm8jD9q4Kt9wNqJc/dINqCte+g5hZhl1FVc0jNsm2YdUA8xmDXbk3stGev
 p7+phoYxYU7twnxE6XtOxB77kQVN3HBa7R9ZHhv7BkrdDGDNHlEBphlTWX29jgfHtyFq
 AH677bTGPAfIKVYfF6az2BX9e4Ym48CVQt6gmOBhREHBwzP0JTnx3E6v05z71AwVrHHw /Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgv2as1kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:54 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4JeSjT023043;
        Fri, 4 Nov 2022 23:21:53 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2046.outbound.protection.outlook.com [104.47.51.46])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpwp09p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MXzdBLAZ4CjlQ7YwLUmkqR0Rb+qGrEmzqb/SnDrg6Cm072IKfWw0JQC/z7L/ZYDzC3Mn/xad4n78ZvW2g1hi3YphGYDwqQOape8I9warI2MZ7IfOlQOXpZJtzZ3O8CBGSZ7lTxsyICIE+AEoLlGtnE68QGdLfIuEBVQ6Y9QF9DIQ2upzIlxKOu7KBfin2UsMf8KeqFc8wBgJctJKkprIAv3saOE6LsNJFwR02skpqc157Q68ckhRIJRMkY8U45rxyTvKWP2ZRzBJHojdqqGe5i4f9rfOqByyCHmSMHXaxefo7G+JyMPS0GH7SvfHIlNHOh6HzfNCkjWdBMQ/u73/tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SkkKotKylVfX7iw4b3lN4De9tC+CB1VWZ9B7wGdSk1M=;
 b=FV08d8VGXShdXEJqkzIrILFZr8vQjKf4ld9iDDZVcYPeCbtmeWITt8APUEPqlBAKzq565R9XvGz72UtDwZjOqXnDiv27aUJ6UXmu0QEovWaEwnzEf1s/HYtZiWDEi12j83FsHDCwvU2eSFgmipd9g6JB6Fpe3qMZe7aQYfqQqifMJ4mEDRK48+WoYnCytqzGKmWLalQ950wdmvoCk5wCSzwRb8Oq31Uv9TjhqnZdRX1wEEoV6B4ZyggKBZo/cp8qr1HVqKumHW8d95Oy4np9h2YKUGh7BJ8l4SOh32af46Yn08gXDWWy+rCrMRQ/CcXGd/eqas2q4W1mAnCzhF+EzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SkkKotKylVfX7iw4b3lN4De9tC+CB1VWZ9B7wGdSk1M=;
 b=orQ3fNvODz42G2YfWc/HsNw6SIbLq1TnAR9RL1YDh36O2D+VYuTb1vQRbBd1gAaYEqFqNkV5eylH2oHXpD8fD1OyEcAUT3zlFlY3Z7aO2fb7zPqfsWY2N2wmBY2x/lhZKR5XNR8xZCRmWPA11x0HKI8suE/FfHAo/nBNW6yww3M=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4756.namprd10.prod.outlook.com (2603:10b6:303:9b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Fri, 4 Nov 2022 23:21:51 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:21:51 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 15/35] scsi: virtio_scsi: Convert to scsi_exec_req
Date:   Fri,  4 Nov 2022 18:19:07 -0500
Message-Id: <20221104231927.9613-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0066.namprd04.prod.outlook.com
 (2603:10b6:610:74::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4756:EE_
X-MS-Office365-Filtering-Correlation-Id: fa178958-4c3b-4c60-dabd-08dabebb5772
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9YsY+9xOlBRDjoV6+PuXsxoj3IcDCmlfB5qIGp+w44s3DdHJQDySqzA8nkEZx1GqdHzfnlLPLS1Y/0cDEczPBetp90JrDuTlOFPQDEApAj3bRX7cz8quCk1Xz4hRinrYTzEH2ff6fK32RIt4oetaMRgu7SKftS8vW73h/tcwIyh6+dnB27hWL2UindCIkz3AXrQt+P5bcEPuS1KTs8zwLFkkfhRXIfjo5cpVgJ1qR7+dWZxjtbqlMbEX2v/rwM+S/MC8ENCYrOagsHYVNLnoqD3SaK6oNIcHuQ6GBgXlaPbXUijcTee9d3KZT8Qxs/83A5SrTfYeiQuA2je/Hy99TD1W4J0eHdw7Nk3TDQlOmP0elv/hqJeVIlm3mwiZpcGlwG3YoQ+7eLYRuXp1e8lz7YjAMOBfsfQ5cvSoT1ZyujALv1jzYgeQ/wM3tfpx9/wY8wbuVUsu75bdvlh1cIKhw85WjOD/QF6/GOkRa8cCnok7Yvqy4OBhqtJFLDHpLW3G13+TId0SgETOUPKLd56tqe9s49nPX4QiY31UrTWR1D/2lly/1Ff4eT1tIXy/6qzuxDwaP4ekHboKf9NhDjdXHGE+fpZeLm6EjYje5I5uMEmnVuNKTAXeFxfh6vz2qn60y7rDSfrYm65d0W0oH4IpllCWOHubwBisOpDrSQXr3S9aqWgyiAQxtlYWNVtMuwoBNuViQYvqBJ4ba517PI8viQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(41300700001)(2906002)(186003)(1076003)(2616005)(6486002)(478600001)(107886003)(6506007)(316002)(4326008)(83380400001)(66946007)(38100700002)(8676002)(66556008)(26005)(36756003)(86362001)(5660300002)(8936002)(6512007)(66476007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sKpVnLAV6/F9K1YPcuuTkTZelvMX8gCD2sIl7Pthl7aUmyutwBIDEMs2lZE7?=
 =?us-ascii?Q?Y0RaUv1r3eZhZqbNPoI6LPELZvRAzS0poxTREe/02BQmwbyWjOmja4ilHvdV?=
 =?us-ascii?Q?4tdRP7F0NUVUoHVdpJT4yVaCo9DaVw8wF4EYYYIDjPYBc3kYGRFI3na0DkRb?=
 =?us-ascii?Q?lE5aICfi5FjdWtC1G2DTC6fd9p+W7MKA+oEJxHxSMUQNtF8VO3cYOb8TWP6/?=
 =?us-ascii?Q?e/HK/ZtEyY/nVg7x3tIU5LBU/sN/V4xgpDm6wL9J8uNvFBOjHCHQRTXX5e5b?=
 =?us-ascii?Q?qLZYsw8WLALxd7M8ub2Yy33DbmGDDMrSXsJL8rQ7y0pJ4hy7AyRCYrkc+Qb1?=
 =?us-ascii?Q?Aql1EitbG6l1Av6hJe4JjF4/RU+iSXMtA9X6NobZO7hx5pPcWRYvDLnpXJ2o?=
 =?us-ascii?Q?elOVTZxe1d8X3M2hYMKGlTwIp0BGAdoGzgXw/5YVPR0oHtbglJApD2GU+hJv?=
 =?us-ascii?Q?CB+7ZPnWfpdYHLoZMarNPKxyLNLb8IybVgPZLjD2FPcSfZNXtgOCXEmMRTWF?=
 =?us-ascii?Q?ie93wxOzygRJmw/jmeHWbHNiUY0oC6XaTmIJcc75uq0lS5zwAam+D3DjKx/W?=
 =?us-ascii?Q?8VfXgMqGyEj5RXtft8HXEmNx5s4x8ege+FTs3aWkWIg9qdCg2cYtgaaXQFCG?=
 =?us-ascii?Q?WHhfjph14lc+M7A4QyIOIHLXcNi151/w/f8qaJTPu4Zw8F8wl3XzvnrBRGUC?=
 =?us-ascii?Q?xAKcOFohj3cmrTSuAEl8ckNyGAPYKYr3YJmgdB1Vq6ZjhIp7hJKsPwH2ekOm?=
 =?us-ascii?Q?tR+qza0zNu/a9IFSNG7UlwTZ42JPvzUN7kNbCDbo02stdkvDfx3ha4HYcUNs?=
 =?us-ascii?Q?Lh1kqeZiO6fvFnZnHOvoiwPjRE0vFA+wQDQVrhv98pvV/RV6XsYAs30JGRL6?=
 =?us-ascii?Q?JrKxnBc+c9MPH76ALYucyQL3TpPcnI9dkOIdOQoa9rFlSggTfAlJ8A3A685N?=
 =?us-ascii?Q?K4qn6bMHdbhtpRns09nJXJLDLPgv3ZMK9dPz1sli0IzvRXjnqguCOuientoF?=
 =?us-ascii?Q?8gPO2lGDYFS49ZsXih/mQtfox1dQoj/FCL5YwUi1fQueIpU/uMq+qQK0659d?=
 =?us-ascii?Q?eNfD/c2CBLAPE3cZfRxcGHTr3iKLofGYtU23GanvIDdSnvj+2blJihXHARq5?=
 =?us-ascii?Q?aZVOboaeMVQ2LTYVkHzlWbHERIMuL/hcylYxY75BJIJJnPaurz8udcNik+4s?=
 =?us-ascii?Q?qMk421d7TLxgm3V3yh60wCAoUmnFfJcvVW2AasGB/BmkfJOuQI0GvblJrj/y?=
 =?us-ascii?Q?OAnBPMOC3OOaDxWuEjfQxCpI6ZCa3sPdDF1HLSSlXtHTbU0PEG9tICqQFTLr?=
 =?us-ascii?Q?9iF2nxu9KnD8ebpP1R9PEtN6CeCGL3PEkXIj+BtybfodgoW2cYO0lzckGbB1?=
 =?us-ascii?Q?ybvITG51R/Gf7TgS9F7J5XNNchQ6vW0CvGqbTB1YG33r306kIwjU/vCDmFsP?=
 =?us-ascii?Q?oXOtWYhA5oUbO4EWorDKs8B11PnRt5XLFUnFgcoSDNrU/Bzu2AwskDQcnOf5?=
 =?us-ascii?Q?SqfAI5G7ni3uEiO74+0bTsFx1q2E7bP39f8NUtj86RlfdTEXyC6g4ipXZ91O?=
 =?us-ascii?Q?ULjXcH5mg7SL00pVsNUIUTEI1h+rYrY2f2TRUKMdxcc/9Dge68Fv8t1z/8iK?=
 =?us-ascii?Q?VQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa178958-4c3b-4c60-dabd-08dabebb5772
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:21:46.3684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: onixktq7VEuhP3ZTS4rTDCPDdRAFn6C9qqzwnM8TIaIMQh11rmTuS26clpHtjKBd+EFgxpX8fdxWzawp2oVVMEHIo0cQTBzChCd1X0jwvag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: xm-T0xHyJfhXXVQjVoV98IFNWZfBE8PC
X-Proofpoint-GUID: xm-T0xHyJfhXXVQjVoV98IFNWZfBE8PC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/virtio_scsi.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index d07d24c06b54..e5d26b4eff8c 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -347,9 +347,14 @@ static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
 
 		memset(inq_result, 0, inq_result_len);
 
-		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  inq_result, inquiry_len, NULL,
-					  SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = scsi_cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = inq_result,
+						.buf_len = inquiry_len,
+						.timeout = SD_TIMEOUT,
+						.retries = SD_MAX_RETRIES }));
 
 		if (result == 0 && inq_result[0] >> 5) {
 			/* PQ indicates the LUN is not attached */
-- 
2.25.1

