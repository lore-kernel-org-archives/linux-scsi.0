Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67977CCF9E2
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:17:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241713AbjIEXR4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241210AbjIEXRh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:17:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3656E1B6
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:17:34 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385MZ2nw003202;
        Tue, 5 Sep 2023 23:16:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=MBOdNfNlR1Ur03UvMUJT+vwItsUrscoMTfCj/TovQlA=;
 b=1DEQpXgeFmqQnMXtuRiuB32c5kG07wYLhB/5pjeTm8rKj5xGpHfQf1tsOzPqhbW7hOzj
 fejFRlLwrVboTqH6XMW5iARG4dcP1sErJBb1PctPLLi2C/n5FundtX27+X7J+HXW8svX
 YehskKql/TTgBkei0Vp/J7tNcSvo0yTCzN+EJQl52SWTnPVqsTzpWkt51gXWa9aPAlNg
 aoMLmN7i3gICjey0tvWuaONTKKiZbPSU8iWu1NIBm7JmAnnVITpe/nFDUO0p3XnkxWZu
 bwyVklTJPKa0A9h+603kyeSefNDeHhwKcBKxftCBnZUAihZFrk/44dnicrNs9CFk/972 Yg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxd8d8202-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385M6wn4007802;
        Tue, 5 Sep 2023 23:16:24 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5ext2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NqFXQVBschzCD0KnzzY1PcX2tzsMkhaOk3pf1jP+QpMyOmJvffkLETOMbcSOao5co6nzw0eV3kAHKPB8huhD38lku1f+q9sLDHVcv4JbTcCtC/OJRXu4Nn3AnwJRMLOtEWm8KcwXVPrjNwOr14OvpVAh12tK311Y8TjEeArmmSABlxfCIO1x8SELyGQuj3DazdobPkjS2H7uw/vr0Nsw0CDNRH0LYdVZIJ41P8tJriJzBnvl41ndGAEO9JdhrtIMQUW04WbG+UoEPAQEYJkImZUUlGmvtUkxnPCJm8Rb6yPh4Xl7tS/oWp/NJ0+bRcnB+0ylj6E7MKq0PxT1VExrrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MBOdNfNlR1Ur03UvMUJT+vwItsUrscoMTfCj/TovQlA=;
 b=R9M3Fl4cxOlPZeyoBlMUZY0dNvVKDYhH4nz4Uc3FriCDMdb5Z4ykwW1aCO+yOvUVymHBdbsSN/KWRuI/AGHcVR7b/XDT7+Y8jieTNAZ5dlYW75uSRPEK47pwIuJYXZZZFjvCcUbYOafkvHhGdxXDPvoGUXc5HqhIXwWsbAOZYKfWBL8p2oxSXGUbuzfCs6G5JiZ6UsCgsikK+jAtSrZZx+AL2iGs9rPjeUgLSzFwUVFFx4/e25/lPPWFIcLQl7u6VB9k/HzMpNhexu1gCdSgz3amFAWqqK8Jr1ZKjSPZUA4yE6gsQluUZ7vwE7XLr/J9q6ED0YoKBxsUHN42SUAGTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MBOdNfNlR1Ur03UvMUJT+vwItsUrscoMTfCj/TovQlA=;
 b=CNdWZQakrqsFUDYvCjsMkyoziiNA6sU5FxY1Wl4Su2vXNnJhqzFoFt6eyRZvnQHqE1CHYpc06kLNs+b/58uIvR/aCwBw005GIFLaxTSKhD8IKNv4RaF23HTVoSQQkVFMTEM2T0kTfE7cjVMTVfiYsD8cC1HsPjdfqUPfMv3Q+rI=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:22 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:22 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 17/34] scsi: spi: Have scsi-ml retry spi_execute errors
Date:   Tue,  5 Sep 2023 18:15:30 -0500
Message-Id: <20230905231547.83945-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0101.namprd06.prod.outlook.com
 (2603:10b6:5:336::34) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 61a8b775-069a-48bb-01ed-08dbae661e69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NA38CjJNkgsP1eQitJVvC7q+h3UwXEgygy3gb8Cv7xFAoWBqsMoRzWX5DUOB3WRrhYEqQlvgu3SiXdsJ5Mg4ZOFEDM1kzBxTIL8aX+B5AvJoTG2Rsc3QeVHkG8kv/bwt+BASCDdcLysQFsWMarkPtgu9EvwXbgPjV71gsFFa4LiV/t1//jeZEr/hz1d08jZTYyjUQmeYnYizAYKOV0fpZss8Rk+OInUrCDWEAQvzcceWvKqwBp7g+wFprtn9UKs7Fl8BqwUgx0JrA9JjIXmGh0nhqbbQbrA4p/g2SS5xyPeEwBedLII3vSbOymATMFcatSvdNHtbj+d1k0HSBGPYCkXYPbaTb02/NcZtSU35y/0Q+AKe3urWYaKyIonNJrmlJBQuNvyXWsRCMiGgnfccgRkyznX1Qq3hog2Ql6nx1ztMtCdqLehQmy1V/KpTZMMWWLEelZHwfIGva5rJexfagl33aetnu9jVzyTUdt17+RejuRpe16m8pK9/npBGWSYoTYGfjlTCVkxyrjxDyYCqmK05BvV2JwjLVRo9PqQDNyrP79+qM+tt91EICtbM/Mon
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(316002)(66476007)(107886003)(66946007)(66556008)(8936002)(4326008)(8676002)(1076003)(2616005)(478600001)(6666004)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VSDv0/g06eCWOBG9CUTI9H1crVlzeh0sk0Zdtdqn8kLwNo19Pcul6Hm3v61T?=
 =?us-ascii?Q?CK2lnMiJKPBfgyVvQmAKe6506iWr3e6U83OGUDkYxfHcUhnoH0QK1sku6lCo?=
 =?us-ascii?Q?qSocdKZ8AnJdQXxCGnZkYrY3uuRJKP5eQKSF2EP4ECgyh7CLzQJCRZwLZme4?=
 =?us-ascii?Q?vn0RCBa1eqzpnlUUvkDOUu4/9xr0WKuFzvRzM3gqEchRBWYO5I/LBrXP6pkQ?=
 =?us-ascii?Q?0/NsaNpKtO6Jsmk5FKE6edXvtkFTBeyZykM8wbLCxc8x4Ie8ga4ra25a3QdL?=
 =?us-ascii?Q?5p9+y8xZWT6F1qfKbZhO22ngIHzbz9QhcBPEBABbamE1Lfdelgi5yysXgXcG?=
 =?us-ascii?Q?mPOwyCgGch9E6Z55GRbUAbAyJlCR4aWlb3cmscHcQZbE/LoJdZdjLs29NxHl?=
 =?us-ascii?Q?vsoJloX/vMMxMMu7RvIOEbfPnOPGyilDlPytAaUXnJC2NE+OkB8RDJuauJgM?=
 =?us-ascii?Q?nPmvfroZ2zNc+UWRiz+ZPDLJ60Bsgdvhd6LqcjE7DrKZTZWy7Y2Ps97FsGEj?=
 =?us-ascii?Q?uEv5H34XZPZj7/aIVeQqs8oLxA9UGF3wkvoxHvR95EBYSeQ0+O0LihWZsq4G?=
 =?us-ascii?Q?ccaZwDcTbd96oOrYgfBJMAT0kH/Alk02ffUze0QX29gH2vJQ+qn/jVnFQdTH?=
 =?us-ascii?Q?1i/X+XkylLbhYVefM9aegw07GNpMY6rDYy5wL9ORQFBcAbJwdteTzQPoIVQj?=
 =?us-ascii?Q?a+en74uqnnrWTpRiVBnQemfgE5JSXoC3Gq2F+9/spfz7IvaaIanY1xgEOmT5?=
 =?us-ascii?Q?/t/4JOds9WUAhTe1EJuqMGPtuTiHpScI7fIyRzUUf6wXcOWl2RKNrSOKT3eS?=
 =?us-ascii?Q?iPgQJNl+7HcyoIj1ofMDHcE0nxmsKTx4Tj3ibgp1+JzPsBuVAnvoV5RlYNUR?=
 =?us-ascii?Q?XJwZNKe4iDR9uNpJQNdF6tFN8J0S6JXlQHCJOhfQ8bi2M0WvLcRGGXQgt+By?=
 =?us-ascii?Q?GV08SHUj85wwB9tLT9FfENUM6ML8sg4OAkUM7x9i/hyG30vfh51K/RwtvmV+?=
 =?us-ascii?Q?+4HgRE6Hy3ij1quXA4NfYG2+SKk+xL1GYOBOZjVYm1B5MQZB9tsfj+OnLVoo?=
 =?us-ascii?Q?flTpAS4p9Wc9yUrBCgSivEDhQuEGKbY+s98O/d6+iTb/PQRWR7LsLpi8ACMb?=
 =?us-ascii?Q?BtIIRsObvO6SqpERHuIEVEdbOWdEmZQWDBW4CZiC1wsU4X5kj90FGqppIcwx?=
 =?us-ascii?Q?Et3D0vqF5/zPO0piaMW5AA2UEwvDKI8mXjLBjD8nmORies1NY720PK6viQPI?=
 =?us-ascii?Q?kNu5LSTBry+aonLzWojamQs2KbaSebgZiWD3sGYIiWYA8TJB+J6w5XC4Dz1a?=
 =?us-ascii?Q?ibaIO94YhMrzwe3pp2Nti3HwLxPYh45It0tKrODTM6iDie1WuOIZtmh3T35y?=
 =?us-ascii?Q?VBU6YFwufTQ7JgxCyIThNw0rY3lSbfkKhf5Mo/8LG59uITNPtn+safh5oZe8?=
 =?us-ascii?Q?N2ioy1KfYeeCgUj8S3km+sAIQeNvbWwoPJ18JNwm7rCApOg5ujEnUA+W1rka?=
 =?us-ascii?Q?9Q/6XCvrlP7tDCULcgcsHqITOqxffUUJYyVwV5Q6yDyj0ClAqyZU8rpaCaGv?=
 =?us-ascii?Q?1IVDpn//VgT1Xqtccmh7MsOO3ki3tBDfbqCffXV4aBSf8cYnE6CevswV3VwD?=
 =?us-ascii?Q?3A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 5KL40uJqUvc9YsldBpevZs/XC36KjSePImurYyJsW+hd6kW2yLrHwH8Ythv5vMd1KcV7vs3sPcK7cG2AbXMOWvRJzvOOl2/zoGcwXF2yVdoXPKzx/P2+dJjRO+m97QFtvC1Vn+unNLvOmCiW6O2VOjqHEz8kZ5McfWRtLOEUbrvqdDd8uVzkWOauO4uuykezOWE3ERViooNCwmM2VZwH+zHav8Vm4xKJyu94Trb17Oc1cJZPDf3Fqe5FMKdSaaYi36+u3oMnu8ndNB9YAEpCBXe2ofGmw0CqWZuvs4U7qL2AOwn3oMvqO65tO/yVlReitVjLEt8cpDer9VjKGWN/2qeF2a6K7mSuJIe58bKK7cY/lnMT4IfitqTRW4KExPsRWYDfyOTB5nMvqsy5kQkufs5EkhyAElUS3V7JHHbidaQwwpVKqj8UBYaD7cSBhcEgz1LmTsat7tz3TDzYgCDI3NzYUFcRJ7YUebV/0vEfaH4AQ6XS6SExidOZzkNpQYnB0K7R21MDHmhuKj1bTtgZLm4q0RtRcV/m+WO1pbmS+r7u2BFdDB45iKzTQAm32I3YAYSmZUsrK70Ohgdi8GRUcdmLgJAbNrJv8VIK/wXaIzINm6nawAvZ8pse9T0zX94f/YAzmj9E7LsO4hEibyrffCvxM3N3p6qfNlXsm2MsED+O7gXWoV17cytxFnYXmwMKZBzohxwn+KXQg22cjUb+JWP2r1cDZ3AeSDtkzXALK5bYYCG6zmeQdWHzGa0U+10BR3hMJ8mR6dAK97ZTSjAyDaGiy8moBN0Hp6xQuODzQewWlZwlHPQ6pgkEycsk/yY/xnHehaqB9iCwtrRrICA8vNKcBHMduHM1rzgsBGanmFx0MBspRCvIPkBeO4ZQiWs/
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61a8b775-069a-48bb-01ed-08dbae661e69
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:22.4181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kaZKjIwcDXN2E2Ac25iQe3vD5kd/WTiEKUilG7D5KmWXEaqQAwb/cvYnHsZpqElkmJBx66g5oJf87J/+3lmJ92/i9Qvk3PesX1sONqclMbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: _u2im0OR2RXilM1bmE1RIwUiJ3xvLq2l
X-Proofpoint-ORIG-GUID: _u2im0OR2RXilM1bmE1RIwUiJ3xvLq2l
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has spi_execute have scsi-ml retry errors instead of driving them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_transport_spi.c | 32 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index f668c1c0a98f..e04b38a009d0 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -108,29 +108,27 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		       enum req_op op, void *buffer, unsigned int bufflen,
 		       struct scsi_sense_hdr *sshdr)
 {
-	int i, result;
-	struct scsi_sense_hdr sshdr_tmp;
 	blk_opf_t opf = op | REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 			REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = DV_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
+		/* bypass the SDEV_QUIESCE state with BLK_MQ_REQ_PM */
 		.req_flags = BLK_MQ_REQ_PM,
-		.sshdr = sshdr ? : &sshdr_tmp,
+		.sshdr = sshdr,
+		.failures = failures,
 	};
 
-	sshdr = exec_args.sshdr;
-
-	for(i = 0; i < DV_RETRIES; i++) {
-		/*
-		 * The purpose of the RQF_PM flag below is to bypass the
-		 * SDEV_QUIESCE state.
-		 */
-		result = scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen,
-					  DV_TIMEOUT, 1, &exec_args);
-		if (result < 0 || !scsi_sense_valid(sshdr) ||
-		    sshdr->sense_key != UNIT_ATTENTION)
-			break;
-	}
-	return result;
+	return scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen, DV_TIMEOUT, 1,
+				&exec_args);
 }
 
 static struct {
-- 
2.34.1

