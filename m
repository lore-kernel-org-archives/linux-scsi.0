Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13FC6C54EAA
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:12:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbjAWWM0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbjAWWMH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:12:07 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CCB39B85
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:11:42 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLhmIS029599;
        Mon, 23 Jan 2023 22:11:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=vjQmDYi56qgd/4v4ggJXrsu+1iFKLC3hEjq5b+aU1NE=;
 b=b8mIFxQwBZQmEwyFUZwELjMT5nao7ZJnEqXbIlE6aaskSvEtszDAIhho2az5QeKXRtae
 vF0HCfet8xa0cdme+qMvhLDwi42SrtvpcSy+H3HUxD8X1xuOaLDnmbXbbeD84dh8sw5n
 PQZUAiCpiINZjYdaKiLnjiI3TnjNY7KSO6XUUJXisJcslZewCNA128FoIWaSG1n9oPRU
 IyOzMvAGQJeDQpLb5t5U7JfRAZIOAeAXAinF4jrHulyAJlWFr/oT5+F4eS/J74XqVmrF
 xAcmnqazQ7T8TFclU0eCANKmEXx55XeMEJCmtygy2wC8Qo0FuwcLl54g8wxe4lfvhqo3 Nw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n883c41p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NKRmF1040303;
        Mon, 23 Jan 2023 22:11:09 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g4511n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WuADLq9jD+LFF//QWAh+go6doI2Bc15yx6TyGpxbvZdU77aNCRffwV84zXxN6LYNfSKzb/T1iuYkEdkBT6KBOFpZkbPclkbbqLnb+sxDd4e3a++Eq3Y4bq6h5UaCaA63iSFI2FUPfF66JwcoPmvRdLrs4essArL/ueA02IHH8JsMK8Oxj+h3NXHBp+6QJZQ/AV3AvQVkq28R+VgHG0xYcDFGY0hTHtZH8TgYLPmVq2CcGqhJgB+EA+nw1TXEYEW5ZgpzU7T0ZxsupO75g2NO7xMi5Qm5VCd8NiB0rO+Gp6FMVWN+Fi3GrImS6VoWK1eeeIBIvUjmTa2FKvJ1T9PPiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vjQmDYi56qgd/4v4ggJXrsu+1iFKLC3hEjq5b+aU1NE=;
 b=HyqDy1NNh1BxKdLD8hPSTJxCKvN7QeNqGsdP9MldZ4Akdruhm+g+HfSh5pAsHuMebBvNXwwCBklVNzPP0QEHzIGfcquP6Fnk2dS59mtqShxGgQaMbTsmXzT5rIitYjdGxCQCjeR6RE0KLclPCOjM7qgtiHTjhF2sujd7D00OdsUdulmO8jjBphWvDGr2IdhUxwjkbzPnk8xBTjcEtFu/RbGn4Uo4pctts1gqtAfxU7e6h+HGsvD1JEBC92w0lSUWfPKGxXyBeVZ9VHD7a5Csh4dViGJmock2ix2cHPRFhLljPI8qS0Pc3UzOQlWqkQ6/sZIl12ZcZ/Q4Httsh1OgKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vjQmDYi56qgd/4v4ggJXrsu+1iFKLC3hEjq5b+aU1NE=;
 b=pvNDwnE0EWpl71or80pzFAELzadRViZnPCRReWNQL4n4TcEqC22HLOy9hbF+tbcZS4+vX7vtICMvny+NIO8J7sCa3kWI04Y15TlRH4DAAbGXMWpyPiMqgn3niw+nFYuz/lbmNJN4U1SNvj3O8wuImnvMMSFqJwSAauAen01IUs8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5597.namprd10.prod.outlook.com (2603:10b6:a03:3d4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.16; Mon, 23 Jan 2023 22:11:08 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:11:08 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 12/22] scsi: sd: Have scsi-ml retry sd_sync_cache errors
Date:   Mon, 23 Jan 2023 16:10:36 -0600
Message-Id: <20230123221046.125483-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0128.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB5597:EE_
X-MS-Office365-Filtering-Correlation-Id: 65bc47e5-050e-4a28-34e4-08dafd8eba97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ed31hleMu6eVS7LqWzGesucnY/z8IysVjDTYtUaLGKDp7ceCJDqlXWs86sBgFav8y7SKtjECBRhecCY11fM+TcJYwIT05CfX2qmpOtyY63MRlLPAZZ2CMS9FkwCx9CHikqNxG2ZIqNqHqlddikrtJ4YlIyFCJ0tPpCt9ua8+GKPlR6+ChtDf+UWTiLMQYGwSX/FofyOvArNTYlPLFfINjA7GhLT7puDLhEqtp/ExPuJz7aOudrh+1vqIM7CUjBEd18e6sotQFHAyWLu6chhRitUaopj4yf8DJZVmi1kAlINyK00eqdwL9ySHFcZVpKspeKlHMRsI6XWuERxWWRI5JKoaNvbKwCLU9+XjgzFsSmOLnLMk4OmS3RzsMXI4WIXWDdE/WPtiZ31VGjGrHGt70q249z5k1Tdia/+L7/VMc7NN4FQnkd3i2Xf9RBvlZWRtcxsYqHa9p0mh2Xa9JyEtdnB1HkEOQh6+nxPRdd2Cu2tjZly7kddQ+3xY7rATY04OXFWtDdlsfQ0RWv8qAGYq5Yym6aqGuQiCdbF4pwHbzzqu4Ae+NvyD2GiRK2JVJT6/ZIzKFGuHu11l84RV1SoEmnCgzIKcsd88PiyNGIwNs8qm4sotXFtjxcOfFVA7W7qP+Ma0oLb1lEXiTxH5QYGPvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199015)(1076003)(66946007)(4326008)(66556008)(8676002)(6486002)(2616005)(66476007)(83380400001)(6512007)(6666004)(107886003)(41300700001)(26005)(8936002)(186003)(5660300002)(6506007)(2906002)(38100700002)(316002)(478600001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CRfkd/DGZNeOCcvNOXdb3B7oZi7Sik192rUZ0ebsaCzzFVS1SjkWDcgMWO2Y?=
 =?us-ascii?Q?wvjJ8ZI9Z7JCiJdrN+GMVE5v5gdjxvdyfPc5Y6SXCy50W7gn8xCP1Y8N1ryr?=
 =?us-ascii?Q?lb3Y3IUaRZLgKmiZdvXI8XDN1tB7bpyZRo3bfbss4je25LrNMg6NZT53TYka?=
 =?us-ascii?Q?VDpfYG+ZxPjBTPaxKZo2ySSL2ITW5Lv3/KThx0DMTKw9daaiF8Eas5D/xW9y?=
 =?us-ascii?Q?hjjF+tQ61wkadkcpSz40GwbK6jdD9v1gU2F2TJ7Roz24QVJRvK7A9g7MX+Re?=
 =?us-ascii?Q?GoI6YtiLHVJDaCnoTLuycDbGepcfhJU4epk0qk+TsjigIMe6dcr8hr9huFJK?=
 =?us-ascii?Q?KjyDHS6QtTO9rIbGFMud1WxCeUg+gDp42i67R7YXrB5b1eYjotH+wXRAwGP7?=
 =?us-ascii?Q?qN5l52vSZPThyp2TKE56fCJ4ueE7DoOO46uH/YmnkWRYhodGD0bi2MoSWZI1?=
 =?us-ascii?Q?8j57rkEYXxqnqbhKCFEmZQ/zqDtIlOQr2/UnlCR7XpIPy7bICZNcIMoeAdrc?=
 =?us-ascii?Q?n3a/B78uzmd3OMB4felrz+0H/LBVz1XoemAeAQt/qcdNUONa7Cee0NDDMsXA?=
 =?us-ascii?Q?yOzlmFazH+BH4ce2WrFf/mncFx8ZP/ES+l9MGN7hmT2OVETXVgH709Qa8YUM?=
 =?us-ascii?Q?K97sHnY/h93NpD/dUv8+yJ4tnX17jpwJvpwBhTl6DUWsfJwFHsO0/iyy5Vr8?=
 =?us-ascii?Q?MjhnmocD7GxXwk1M5ukX8Uz4GzEnwdVFPnhik2DtBSkfW7asBFE6lPsltjv+?=
 =?us-ascii?Q?jGtgOlIE/b7FUKJ2dnqQy/VpH7Gcq/hWT3uYIYyVElV3JiwfXq4JjWRliYuJ?=
 =?us-ascii?Q?rxD/2mppFKuPgF1/gXEDlYiHgdcCLD6JegQ/Kpx2zdTSo+b+nNTH6mis6bfV?=
 =?us-ascii?Q?A8JN7J6LxJiIzOOBo6U3nUygwu6nnIoZ9Z/jxrhxDiQpnDkInRgGP4PPCXSE?=
 =?us-ascii?Q?lMiUWzUNCul3uuLSH3cY4jJBMK2ipxwVppF2TneMMrnwAmzRVcJdqrIU36Vw?=
 =?us-ascii?Q?/eSD0K/YEp1ejlphkDWgApQoe7S8/fUfeCAthTf3bYXxUAeHZrORwfkRL1HG?=
 =?us-ascii?Q?JwPbG9YlrA5eA7KFVcoPljK+64fDIBbhIS5DBKmfe0RcCGy2MyEWIxrGB2mw?=
 =?us-ascii?Q?Dl9Tm50OQToGkXX7hZJFkE9TuAfbprVDgAEkohOSakVC1dlvB5ii5x8uwBnL?=
 =?us-ascii?Q?zCF8umtY0HQC2SvUqQfZJbvxzs2k0Bl3K7MvNP3eCEksjOfNXDmmYX1kpaAV?=
 =?us-ascii?Q?U0hJF03Cg/+iZQ4+iPl7RCOWosmgzxX27MBC7Qzj6wwZ/d9HV+9+hhac8Ilh?=
 =?us-ascii?Q?Bo9w4icE6DAl5hfp8SONdRh9++SpgZpSbFmz2LJnTURPrkB5jRhywXOrawa9?=
 =?us-ascii?Q?1reybAAwQYq82pJF4W54TudJTVMEG1HVPn9vI5bdqm87YbWh1+Ooie+C0wA5?=
 =?us-ascii?Q?rQCdk6h3wetdKXUVIUmQR+v+dyFoVmKmMNIF4B84wi3+uqBENWuqPcsNBWAN?=
 =?us-ascii?Q?K0A4JoADwTfrl8zMZSnLIjFDeM3JtnDeSRWmSUbv9idTk6Mp2JYaqU3eiR5F?=
 =?us-ascii?Q?2VsYW46OSbs0vbpJFFRem3SP07Yv+SSXbftXu7sKmulEsveXgy09J4dlo5IV?=
 =?us-ascii?Q?8g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: G1owUYjqO7lm5SFj0fqfeQNbK1sYoKJwbhCaWYJzwbm66Jh7SACCuvzWrvGin3EAWkPH5wbs0hzejZ836AwhAxC6xupg+5MuBa3zPouxXzc2OULLdq1FAtbOFBQeIQ0ppqh8bT8hfUnRyvvd+Nky1dCoUWTBW+pCARiQB5h7c7KaB7WKZYFEGJJ6BDW+HFHpbYz3fKNvENkn2ZoJEe0GfKvfLlTcngf1WibnOWg8oNQoh2jk3WyvTTwCqwFiQFbq69uuuojBVlEFtONoCc8OK2sLyVPJxMDFMR5jiJzUvnCcnMcUgqyZMT3yicoz07nwvhksKMOunSYPsgaS8e/5DdzR2cEDOQf3GTqTlxogSl52DXbugj8knUUXHvDxaynXkPB6wxLJCLrs5iAX43Hz3V37X9xy2Ax1o66f5bxbYD18VfdQtUgNNAU/kRuukpfyaBxmmLEdoFhoV4vV5rKuvrMSIvVYq0VZ8Y/EC/SmT4yq9e9reLTrmP5CO5DXyvU85AMSDPXT12MK0/1ifFU/6MbQWYBLr0pHDwwiUoNYZaW1gUsPoBBNz4sqivtSfaBvP4HPy/XURkMpLMFelAhOt1hy0GtD4t4fcqhr3cv3nE6XSgAVS5HBIN1+iEsAUDqIc6d8euLtFa0Sr99uCdGr8PmJdXGIrRjkFWxDS4wBm6WqGg9fPzBrK9et8HwaJgMsFeKIpGOoaSGOiyWO8lw/MMWIU42apZIr7nDLnQgBSoJNY0QtbqhgCr0loJoR2ChjPSGtm1i1KG3B/SF+pe36TXDJX2C25D2m9Z+oY/eB2h1gFePD9bmvRcpRd6THk7I6ZIB+P+zN2VZYhQXCNQDzpaTE6MgMTs2Kf2jACj4zb/Db8WqA9D3+wTG5RKx9sDKI
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65bc47e5-050e-4a28-34e4-08dafd8eba97
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:11:08.5563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /+xekq34KBTH0fnkeqVkW+/L3NKZhrWCpBYaIVx5aAy397SVB/XTAoZGPpvZX21Im4iolr3ns5HwzUJkJeNknxZ/QaLdEHSC6QDZ1nRafDs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5597
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230210
X-Proofpoint-ORIG-GUID: hI25rbnqyQvmnNAX_D0_fU6R1M7-qXnY
X-Proofpoint-GUID: hI25rbnqyQvmnNAX_D0_fU6R1M7-qXnY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has sd_sync_cache have scsi-ml retry errors instead of driving them
itself.

There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs the block layer waits/retries for us. For possible memory
allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
will probably not help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 89aabab82763..63d2c6ebf948 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1581,15 +1581,26 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 
 static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 {
-	int retries, res;
+	int res;
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
+	/* Leave the rest of the command zero to indicate flush everything. */
+	const unsigned char cmd[16] = { sdp->use_16_for_sync ?
+				SYNCHRONIZE_CACHE_16 : SYNCHRONIZE_CACHE };
 	struct scsi_sense_hdr my_sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.allowed = 3,
+			.result = SCMD_FAILURE_RESULT_ANY,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.req_flags = BLK_MQ_REQ_PM,
 		/* caller might not be interested in sense, but we need it */
 		.sshdr = sshdr ? : &my_sshdr,
+		.failures = failures,
 	};
 
 	if (!scsi_device_online(sdp))
@@ -1597,23 +1608,8 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 
 	sshdr = exec_args.sshdr;
 
-	for (retries = 3; retries > 0; --retries) {
-		unsigned char cmd[16] = { 0 };
-
-		if (sdp->use_16_for_sync)
-			cmd[0] = SYNCHRONIZE_CACHE_16;
-		else
-			cmd[0] = SYNCHRONIZE_CACHE;
-		/*
-		 * Leave the rest of the command zero to indicate
-		 * flush everything.
-		 */
-		res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0,
-				       timeout, sdkp->max_retries, &exec_args);
-		if (res == 0)
-			break;
-	}
-
+	res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0, timeout,
+			       sdkp->max_retries, &exec_args);
 	if (res) {
 		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);
 
-- 
2.25.1

