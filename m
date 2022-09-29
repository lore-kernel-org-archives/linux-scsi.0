Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCA9C32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234858AbiI2Czp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234822AbiI2CzM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:55:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F295F4DF0B
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:55:09 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNiIqD023211;
        Thu, 29 Sep 2022 02:55:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=YsXyBxN2QX4CpdNlv+A8zrvQdzppqIMxQuQmrC+ofQk=;
 b=OItsXW1igKdhALeHSBj4gJ4O+I5k2r7jvvovksaRtkFMcy/Ede58PvnxvtAnT3WgQW4k
 F+4ZCbgooLc6qdVPKTzpbkQVIEs19+W0Cr+yQx/zkaWakl5r3zN2uJ1t14aAT9dX0a4G
 DCNTLX43+Z3Mo+WW0P7mbx1mb6BmMqV0uDrxlke5pscHsvMUdI4/fS2TLVdrWazNIEux
 K4A9yCsAWpU3ZyRnLvVC986Qb/Klglt1mp3IkoOCtjRSu/HhbfqWnBWNGr6CIBR41tRE
 qqBkwwRTi2n6FDrcHAwbZfrx701IvRO3uke/ox0twpbjU7iY9ma6ScyekSTUee75cvH+ Yg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jsstpu2xe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:55:02 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28SM9Skn039489;
        Thu, 29 Sep 2022 02:55:01 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtprvtcy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:55:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3zNh/NVXb0e4gJvrOJSVeS7LK2u4+OL7jXQ3GNLrFz0hym8Dalb2oqloMQZOxbuCksDGxw0BezA3iz9uHXY5ye2SvgzA48RKay8XvQpTsnDxLZmyJXyMZsbDQz1KLtmX+mBFWESBDPljh4VsZ6SzsoLzVuh15mkWODhD35KC716UXEJlC02HpEv6UK5pOtQZ+7fSsLJtpcEF528YZeBtIVefL/9JsVV4Sm3vBaMJZapRVwrLHAynPgNfP7pj2W8RJNovOZ38KfvkKow7ZdMuRouF7N/TqAmlMneFpikND8XmDBWvJsu9WNyA/pPbSMRz8Qsyzj0zrYccd8YbID03Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YsXyBxN2QX4CpdNlv+A8zrvQdzppqIMxQuQmrC+ofQk=;
 b=heXTjBYqC8NJgCNjPDwaWvPdHD4s2Ry0rte+bU3E3w0AYyTRJ7qp0Ola//aCEKZBkRvK1I2V5Ka1LqrkiNbkhNKcapDg0EMva+j50uApcyHxyI24HQ1ad2AcG+ZR9haHjM/nFQ9mWGL+fVSoSkk9co7jt/5oIkj5nP/qiNsr+oJGr7doNDoFR+p/xUYE/Xrq4HIN8Q1fdDbJhDsvBn+GVKn/520wphX9XS7r664DXB401+1ZR6rhGiiyKgx7iYkqD6Xd8Rz6JJj90pTrvNuO5aUCVlVBug670//HF/uQmd281iv9Vf1KZ9sguTTPTnzYSAvf+Ft99Vew36r3oyIs4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YsXyBxN2QX4CpdNlv+A8zrvQdzppqIMxQuQmrC+ofQk=;
 b=qz8nrj4acuhG3unHAn8w9WNrtapzuIiyT6DjwjUshrhqGSaYhLRKrEVsYWFGmysoqbKpjbE2zM8HDXPa18VCUtFtQKn6eRiOF13tHvOp/pZBY4N/dCRyveY7zcexTFQgrAjlsWAbeY72d1J8kdG55dPMnEoLRCB4qLKyw/XIGmM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Thu, 29 Sep
 2022 02:54:59 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 31/35] scsi: sd: Have sd_pr_command retry UAs
Date:   Wed, 28 Sep 2022 21:54:03 -0500
Message-Id: <20220929025407.119804-32-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0021.namprd20.prod.outlook.com
 (2603:10b6:610:58::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: 3936483d-05dc-4ba6-7b04-08daa1c5ff45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 04DqsCB8TMdsljWEyy49YRA69X8bi/ddnL1LuhGeOfKWv0gA35n7El7wMX8OC3+Ny9O/96+d5PvoUgO9DEAM71W5fyCdiQEzHPrD6fpuU9GWpjduCUcT7mqdEK0+GoDSxm2f4Ga6/YoI6knoprJVvEkyOHEDIrR6mzPUBxDtCZ6DnR7DPI3I8TxR6QEn8VjzKRQcRL6UzeVNfqyyzdyQbPl9Hfwd7RMipJSUWt20VqNiFCKwQpUKhA2nArc+jx35B7hEVJ10/LtwAZFW9DJMCAHoc+TUyvN2Yi7annla99YRtZS15P1W5qStw+xMUzs5GPXgmqTNWbBCx8tE7rgD/bEKh644kL1RjEIqhC3FiK/HQnbYdJKc02Kg6pU+Ke8AcIf+667TIkvJdOFXc9o9Cqzj7QpvqHBJnBudr2f85P/OizI3Me2rFKiyWfFpI2x8nuClMIke9tmYTnVy4Uokdch8/0pWI1JVrQwvBvuLxyF9tdE6Ksdm3w7qhK5Temymg0nJ9PavoAzEt/mF5gokg0eQgszvfzErWVuInhawLOQRNtHh60qgtD/JH1bDkaZfzydJXcD9Nz5P/Whr6WmQ22VRr1m3jZlCXyGllpJwGFodr4XQGctO5IhMWOAlAHNKGk4pS24u5gfZz6viwRUCit1/Sl9wxcY7de4fpBVXQGg85o+eNVxozXimrj7WZvtYe4t5EXEgEVdgulAc76dixA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(2906002)(6666004)(41300700001)(83380400001)(66946007)(6506007)(107886003)(6512007)(478600001)(8936002)(36756003)(6486002)(38100700002)(26005)(186003)(1076003)(86362001)(4326008)(2616005)(66476007)(316002)(8676002)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VAbgtq0IQuNWojEl3htPtrtCXBwQmNxLD8wWsvs1Pi9BX5E/SnFQQIJsVCzr?=
 =?us-ascii?Q?7T8k/ElO0TLNtSMHQGpJMBQB0Pfi3EcyxoyvmIqWSCgD8LUG1eyVI3ZP990t?=
 =?us-ascii?Q?+GMwExk5lVJdB0EV5jOxrXoG923wM0kPDWbUJmmk/9GFzDPdFrwokYDYj+JR?=
 =?us-ascii?Q?exDT60rD9qx8UNeii/4AWnKZywNFRt7Jn8J8p+tz5aciXxILfBg0kiluPnMC?=
 =?us-ascii?Q?rR4eX4T8u9r4rx8RZbPXo+hEsvaby/JbU7hcEPo4Z9QqaPhbIT5WaF0jCFj7?=
 =?us-ascii?Q?sNDCLnyXIBUC9fEISDuDzt8W8QADCdJ97RlbvptqPI/3uE7nLcBWPyT84qQB?=
 =?us-ascii?Q?i/ERi3Ofjq/3Uwp2qdWNvdXtgBwaWtrN6wDtE1mtRWBPTJBr7YJLUIS+igzC?=
 =?us-ascii?Q?fCC/Zh4OEr4s2O/CFiI+UCR8STn0s5bpDZZ1ZU9TKYp+Vr3BH8lJMelcFpDn?=
 =?us-ascii?Q?1rzZxmKWHYfbtdnqSPqJd2j4vR7VjtCsi4bcufhSumfbbL0Qvr/NSQjOKVSM?=
 =?us-ascii?Q?FotgMvi4GQ3QNcvabZeVPblU9asFYtjnaYCaCePk9x9YP2qvp1gy/ZHup109?=
 =?us-ascii?Q?4IxivkSuwJIXeGBrTDEArllp5lz9HCAxdYcvF1+jhIrzC8XQxn/WGQ6IhQfI?=
 =?us-ascii?Q?4FAsGCyvfcQODbi6aQcB0nA9IXv5gmETfIVgPE+Ls74yfzvdgia2dSle9M0c?=
 =?us-ascii?Q?quSIGKixZNxHNhL9FqkDqr7ttyCgCFI70D4g1mMI+cd/Q7kVr8FTlmiTosVn?=
 =?us-ascii?Q?vC7UxX5ef0q/CVO8xUWu7taeIZZ4F7wEBdNJi2gIRrBTJ65jLN+y1b6I/Zu/?=
 =?us-ascii?Q?rtZ7XvOE63HLociZGkjYCH9OcbRJ55UA4cX33spf5M2PKwzxYiQ+6GSrbL6w?=
 =?us-ascii?Q?ynwNlFrMVK9Irf9p7jk/9ZJd4lOJLfi9bvVvQtnzvRLWHdceM/YxjMRiTuQ5?=
 =?us-ascii?Q?Mdk2wAan9QjE+lsBxEezhw0AOIlFTQE6VwaTrgGKjXy8fjgE8JUuu6ZNHlmJ?=
 =?us-ascii?Q?ksHw3hC6qzHWxV+P9U9pcoWsDlSkamG95B2AOrXTjrjIdUENB6RcppF8e6Bz?=
 =?us-ascii?Q?1bQuYhFnTvhJyxqJZeYsnwpBv+CfYIUOqIgPxBDSzpUN/3lhxx5fVP/ewkFf?=
 =?us-ascii?Q?3jLI/H/oS6tvRUvDtakVdaEFWIgnT+O+X7fR74EWUYwW+DmqQtd6lTBMCI2d?=
 =?us-ascii?Q?S/plQ86iMWqUZNu9hIWrblvaLkSK+oqNeP8ZwSu0kNvFZksj2VHGs4qrAtai?=
 =?us-ascii?Q?w3Ehk+2bhaTKf7cdOWxIzqpwvdziDRIBAf5M0IOWKkIXdgUIgO0pqmBAEjXQ?=
 =?us-ascii?Q?gW5cKVDcqY6SIW8OIjGUxuwaeYIyigFxgUpAeA509vJVRttziKNhwFElwoGC?=
 =?us-ascii?Q?pXhN2JGDDjfgMcaLNs1DLsap7fVfbeiJ6eoBQjRgafuH8vVmyoCdwmPi8xgm?=
 =?us-ascii?Q?rHYE6CjTvouulwPEc+4BPqJUWrYRiqd5rNTOEECtXWIhBSnJW33IxOwTYyE3?=
 =?us-ascii?Q?fsy2Mqhj7SVMSGEOcRW3/2lL/RyeUCHqDtQSovZ27viIAtHndrIIS6lgfdY6?=
 =?us-ascii?Q?qVatUqoNJZi7LhV3wP2ICaRfqP3MUX74uWctUiWmuAy24S3bHJWVqufe0DBB?=
 =?us-ascii?Q?vw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3936483d-05dc-4ba6-7b04-08daa1c5ff45
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:59.0500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1V19a63YT7secfANP4i1j4p1kM5MqzZ3RmblTHJyYtR2k+g/5/0Jf5ht5u+SbJY2mJLmtmlsCjVJC/Bh299DpJ6D85dMwD4DfYRjhE5pUFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: XKmecgVkDHl8mCFci55_F8Q4NfZed10w
X-Proofpoint-GUID: XKmecgVkDHl8mCFci55_F8Q4NfZed10w
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It's common to get a UA when doing PR commands. It could be due to a
target restarting, transport level relogin or other PR commands like a
release causing it. The upper layers don't get the sense and in some cases
have no idea if it's a SCSI device, so this has the sd layer retry.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cacfdde545f3..e7c7992b7bf3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1723,6 +1723,16 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	int result;
 	u8 cmd[16] = { 0, };
 	u8 data[24] = { 0, };
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
 
 	cmd[0] = PERSISTENT_RESERVE_OUT;
 	cmd[1] = sa;
@@ -1741,7 +1751,8 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 					.buf_len = sizeof(data),
 					.sshdr = &sshdr,
 					.timeout = SD_TIMEOUT,
-					.retries = sdkp->max_retries }));
+					.retries = sdkp->max_retries,
+					.failures = failures }));
 
 	if (scsi_status_is_check_condition(result) &&
 	    scsi_sense_valid(&sshdr)) {
-- 
2.25.1

