Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91703EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbjGNVij (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjGNVi3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:38:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F33E35BB
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:38:20 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4bNJ014926;
        Fri, 14 Jul 2023 21:35:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=m92yvgf0SoTmqBy5CyfW+waaXUiO+ASPolyL+wf7mHY=;
 b=nStnpEhYpfWLuVOFuQgOvsX2Zo7ntyR0j6I/gG35H2fuuvwcKx/m3+sIp5ydgnK9RkEv
 uABN2NLHegfX1SUfkJhBztPq1K0gxbUD4e5wA3MwlHmUd/PXBnZpMWx/8ufolNfeWbsN
 6DwXZJgmrBNnm4CTgr9gY8Q7903uAzCot1DtmQ+6BXbc5x3nvD+0Xeb07kOPBLh/dCic
 qNriIDLKHNIA8EQRwVK3KLB/bw/e38nneRRtW9jdughHwG4NSta9Cq2UoXIPLJ4mEs7m
 6gzY/mt7pdg6VGalr1yjYdjJ9EUZF2P0JzFX3GUPpQKUt6yaj8r0nLLv20IFVs/+kCNd NA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtptx2f6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:11 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK7HeG007622;
        Fri, 14 Jul 2023 21:35:11 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvsrw6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B7x87TnGadGC04B7EiY7G0TuiXMyJU7/BXjIbL0/5zQK7jMLc4BwtsXj34spW9Nz873sanWSoltVcWfjH9SfX0Kisf7GCZE6teVS6JSLtWVj287ksIzENwdkoMRg7psXf+hI0Edr3Ek1QePPTptaYu0yALmNko/BEQaAB8KW9388FpTpCHWcH9V7EjEit5c3LslIlg6sJPIpTkxDyaPndmseX0allOI7cBglLUVuU0zakI0bI5L+iy21uwFi6jtFaUhDCJDOhLo5XEmYYA95mf5od+PfVVVRUwlufab9MIcKX+ct0ZcIB15qEE1+YGob9P2LOJpEt7a0mJ2Tn3p2rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m92yvgf0SoTmqBy5CyfW+waaXUiO+ASPolyL+wf7mHY=;
 b=ZHF7Mn3mruHEwLcDvi0hJzIzSiQStw/AY1+tLitTrxtdGOS4NKDHhnEUpYG1/eTUwTEvkE6GSY08htQX3Nvws7tbp/A3BBl2Ut//fjVa5Fwyo5SFWZON727zcMKY50fqKtUy6pvlSBEwUhsIHAgwKMGDv+ZbXdiONt+ON/cwonJXpJL2VKVxJK+N+ih+q59sFqXSh+CrkUUaaTPLrpASLvlPtUjBUfhQiECiZkx5qWrpLds2KKIyijQi+wgFfGFEYLsrnmmov5pdGikdK/r0MvaFsrUm5YlcIeupVS4VakHX4FYS0yCMCeSn2CxAty0PnftA+UAoVEG/JsHN1mERMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m92yvgf0SoTmqBy5CyfW+waaXUiO+ASPolyL+wf7mHY=;
 b=t4ibPB9coboWncJMB89xLf3N+4K8pRvHl9V9WE87MiD9qKrnv+vjFo7VYL3qDXZWQJljDxoHMhD/67nFcUwSM6Pi7XtNS+7vnKV8u8pIN2Amub7iPFHHOQMMrpoxsN9kFVUgClhv0fYbCXe9MDF1ukZ+VimWtwPJnWzeKcKGxDg=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:35:08 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:35:08 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 28/33] scsi: ufs: Have scsi-ml retry start stop errors
Date:   Fri, 14 Jul 2023 16:34:14 -0500
Message-Id: <20230714213419.95492-29-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0102.namprd06.prod.outlook.com
 (2603:10b6:5:336::35) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: 30f807d5-d155-4e73-0c08-08db84b23255
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IzTTyDSoymWOr0sPxQfxVejpH3VqF2h9Fl0MzaLo0whbRTOim1nS7jO1Epw4azKKbtDqqExX7qkc+9LOZNtavm9c+l6luQVhtOJONOmudoq80d+WobdCC4uBP61Vi5ojnfZYASqNx5UJN+VOOpv9XG4lS12diIGo61eqOfTB5/ThnNXzfVGly4Kkbs1hS2edQ1ZWPd72Tvm4HOREHmyonvxckmwhEOGMqjbTTsftKIEmy2wJieye9GE9U6nCeaW5VAVlK6fH7eEs16Otg2KQkequzkrGaNhN0wa+o+mo499f7Om4qKuMKVUhqFPZ5w72v/pu/ZoBMbkyUBdlC9OUfLX/STMMJ9OLzhO475K1l85Np5+Zg9R9rryUyUhB9z8Lng/3hHe+fclUYhhH8HJpeNphultnBk1BIdW/ZCYjIxFzvC3a739jeldeReNEpk0Csxs8iLIDK1PfGZ4s+PSBZThlf0lejw0PoKWFhwcLDOx+EWWE9IM/UjfAA9gR6n2sgyd0wCIfcXl5vv/HZO8TTQ+i/B1yzdxB4Z7FMDrRufqkQyGsdCCxJ3xwzWZEldpG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(5660300002)(38100700002)(41300700001)(8936002)(8676002)(316002)(86362001)(2906002)(6512007)(26005)(6506007)(1076003)(107886003)(6486002)(6666004)(478600001)(2616005)(83380400001)(36756003)(186003)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fBvyZqMml1yNRR80i0V4r48d3j+rLKUV3oAQAJuMP+LgN2nHpPPxArnpcNV6?=
 =?us-ascii?Q?bVF6pQlLVz2zlLcLfqXv8cVTYsf6pmnF/s5PKJZdV9m3WsiRv55XYRErUE7s?=
 =?us-ascii?Q?OWvDobA7/yudl7Vu+lBYkf4GtzqzpnxV83de7Gn4O3rtBNsgmCW8SlixmQ8J?=
 =?us-ascii?Q?UrSF/cH9q1rwt0NCQlWY7VmVDH3xJyq7v12M8ERy0BvQtzAnKj/4zgu1LuTZ?=
 =?us-ascii?Q?bV0ntd2Uz6bODRJbpO8GTVzpKQTf1izYRcbDJgB6ylCZShG6L+fP64Afcpml?=
 =?us-ascii?Q?9+r5Ni84xeEWLn1SuAUGFsu2fpKygfbHInzQRapWopY1j5x8GfF44vgvQ5oA?=
 =?us-ascii?Q?u4Khz78gVWZ0jTc+t1gBxfD7LPNtLV7We13WNZ4WJhW/Bg8NWSBSzUfQh/gw?=
 =?us-ascii?Q?IclOW353kHhpKhkmOJo1qp57D8wa1e+2F/hZPtxeyPEfchCxaNdLQcujk4FR?=
 =?us-ascii?Q?96UHODd3hyPVr5O/pHFo8k+lbpU/IWarC4MVnd3C1VPoCsiQ9Shl//LslavF?=
 =?us-ascii?Q?gGy+zlYt/sfNU4due4S1Tp/3g0ZVBV19XXo6faWhcUyuoPkdwV75PgAxYXAQ?=
 =?us-ascii?Q?ArUyoxb0fhDmuO7mreUQbb3ThzkEswdj71qdw0kLt4cvROTrTmYOvuE4m6EG?=
 =?us-ascii?Q?Z5PiJ11JuM8xvG1kWUeAwSwEP01glb3ohbBJ9WpC3sdZGJeXEo5brzqIHb1R?=
 =?us-ascii?Q?TAst7pJ4GmxOD+AscL5NIdU2bf4kBLioScTkS1JPJzCUNehd726yt3dLBejC?=
 =?us-ascii?Q?GifPTsqvAyiA3SbKVIOcsbaEMESTvQVKGajFyUZcaRyhxSiKoUMyV2AP1CQo?=
 =?us-ascii?Q?RhvPUUObYTg8gAfUxhX9Wn3X9RjDOM/qCCY9j4f0KSRb2IruvQ8SJ0+PgnAY?=
 =?us-ascii?Q?7+QlYi7/CPzN7eGBjdoqNGnxvdbPOwTAPsi1OfgMFlHEi04HlWOH6Zs6lRMm?=
 =?us-ascii?Q?GVa4aVcWo9CfgK1KViwJMoqCLvuzYueGKxGKJZNT7+jM6kQjcx7msrGeZ+5q?=
 =?us-ascii?Q?IbYwe6QVJUmQBtW4c1FIgXC12vyDMJbwCZ7Ww6SSYaZDRzGF37oqxrdvC9Nw?=
 =?us-ascii?Q?QPl+TRh1HZHy7Gzmf+4G+nEECZqsv11Ql/OdTYsrmfNtskdmHye5sZC8LPCd?=
 =?us-ascii?Q?MZaNqEKJVdSKXQOjq5BZxeUsmoA+4s/VUu7zYoAzKi3J0Jm34YNDTinTC/Bh?=
 =?us-ascii?Q?92ryDI+znUTGDyinVBQtA26IWzMGXIDE3GEbFINHhBbqNrEjVe6kYcf5nEaz?=
 =?us-ascii?Q?7TuRbt4aeNJyXcnpAjEEXguoEuv71u4XO2l9bzOEWz+ZFF3hYZ6MVv2fE+90?=
 =?us-ascii?Q?gUOHEw1AniIjWx3ZdLeEiGQvDy6bX06J3rSMyyxTkR27vkeSVejEwiMp0/qy?=
 =?us-ascii?Q?URDu/lGeCza+b6xb8zuoXxlpABadrKgpXnka8oe4BWF0MIPsUyyXynHkuK4m?=
 =?us-ascii?Q?aqHIDM5bOSDV+9C51nQbQ+ouK06BpuFTw2ZYXJDqKc49EgTk2xFQVKDOAGqt?=
 =?us-ascii?Q?Eu8Er0QGVWCAUQoIuNsbFyi6mza/8wJRFqUF7nDkEW3xG4U7f14CGYNu2a1o?=
 =?us-ascii?Q?1akrYkobr0kR3mUw45bxNxvmnEtuVTuDksWzFBnIAoFOI6wh+ZmawzInRiIe?=
 =?us-ascii?Q?QA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3cweuYOcrkhnZGtBb5S2gNYq8qMmw39qxUHc3QiGt4mDb63/Ah+YCVEhxw46YePgZqrRxeCYLqkKysd2B7LuaRwOE7KWXq0lT7PjMzMGjqpYZLehTCYLp0CGDHAX/euWJ+2GDTvM/6keVh514cW32GnsiGAh63XmPRThSK+phRtZbYqaq+5/5CkJtvxDaqgLa3bTnsi0vVpuotDN7FMYgsz1Qo9JbzJwTSL9l4SqqfJio+RX0h4prHg4uY6ajSrXi7vjh6TU7qudJPOZm/tY+/AyigPXvUHqeVZPIkaVsuujlXXWPC2Jb8yxHlokWan3sTxMXZgw5TBhWh70ISCvTc53aGkfnK1u6yZI+1dWIYoIgoNn0/hyKYiLpvdBENxzefqJqFvFuyUed3EbkEsVIU0OQmqjUAiJrAN8x6HzFejjI8YLfM0xkFQoxNshxaFQMTYbsbetJAHbwVkPUt3xJgNrDPKSvzOvuMapGxPPx9ws2B+U34okEfhJcWuiCY4BY1duAyYe6AcKbzXhiGYxCGg1YvygACDsWJAuhUlrl0Vtx+mdtwN1tFsfcAPU0HezB90L2WsvClhtBW3Pi/ogDSWSWu7Sc6QJT8beyaDgie5fB54nuXU0h+bg+du7ETi966QlDUFlvHoIFO+D1nB2M85DfP6TF/ukkGfM8zUNXGvgfhxa4sSy3iBImJbH5IDl/bLOFcsFt+TuqUg9CeprGCkfAtwDMIPr76ifSY6pi2/W1GGiYaZNaWocUpHYQL+Xl+UcpApmqMkaLgUq/P7Y8HHDrWdGPyvkhHB6KQAMcxYYN5vrsGRktbQgq9G4EGlqkVlPC3Pvvoe61VN8mQCqUIzfJLZlC+iMdIhSqM1EBnywgfUZEdpku8HllaJ5xqMB
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30f807d5-d155-4e73-0c08-08db84b23255
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:35:08.7928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cr2dZvvW4NOF5e74ieZ3URMwB/bYs1W0PQY0ZYKPXT100JtZc2WsNE4of+fX4efQRVlaNxdRUk9e+vV39aSi6Q1ngG/mJREBLNGQptVSrbA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307140198
X-Proofpoint-ORIG-GUID: sGVr7fxev82uYO8mLbCIExK8dYH-kVJx
X-Proofpoint-GUID: sGVr7fxev82uYO8mLbCIExK8dYH-kVJx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi-ml retry errors instead of driving them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/ufs/core/ufshcd.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 983fae84d9e8..267c24c57396 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9291,7 +9291,14 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
 				     struct scsi_sense_hdr *sshdr)
 {
 	const unsigned char cdb[6] = { START_STOP, 0, 0, 0, pwr_mode << 4, 0 };
+	struct scsi_failure failures[] = {
+		{
+			.allowed = 2,
+			.result = SCMD_FAILURE_RESULT_ANY,
+		},
+	};
 	const struct scsi_exec_args args = {
+		.failures = failures,
 		.sshdr = sshdr,
 		.req_flags = BLK_MQ_REQ_PM,
 		.scmd_flags = SCMD_FAIL_IF_RECOVERING,
@@ -9317,7 +9324,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp;
 	unsigned long flags;
-	int ret, retries;
+	int ret;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->ufs_device_wlun;
@@ -9343,15 +9350,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
 	 * already suspended childs.
 	 */
-	for (retries = 3; retries > 0; --retries) {
-		ret = ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
-		/*
-		 * scsi_execute() only returns a negative value if the request
-		 * queue is dying.
-		 */
-		if (ret <= 0)
-			break;
-	}
+	ret = ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
 	if (ret) {
 		sdev_printk(KERN_WARNING, sdp,
 			    "START_STOP failed for power mode: %d, result %x\n",
-- 
2.34.1

