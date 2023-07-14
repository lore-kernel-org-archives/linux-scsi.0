Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB33C0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjGNVih (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbjGNVi3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:38:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6136235B5
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:38:17 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4DeZ003063;
        Fri, 14 Jul 2023 21:35:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=cVeL282nvfOA3+yvDKdOMj0c+JdqSKOdqKk3lKBB+s0=;
 b=UdsXGRMM8MmiVrXwZKqKDDbpPT5BpWMy6VCgi74DhEXaYNrjCRc/Zx4YIB6mR9Q5RFFZ
 W9N31CI3W2Mb6E59zfUyif6bEg1yeVtwD31OVQb0c1EQIBVzf0jLi5vtr+FAdUCFETD0
 WEXQ9Vqoj0ZS1jA9gZ8062v/+bN3dxEu9ygDJE6zzTaZwW74SzyCzsqElGRIpsdc/Z3+
 pYfDwrxu8TEGFmNdDOPLUYF2NOPlE49cL50HWQ+g30aPLQONhaAAoIDV8+PNoceqLUZ+
 yN7fsfyWOODCzi1E/zMxvdJU+HMpTuKeue7wJqedaZ0FAtd8JQt1ZvmWu5yRFVKbd94N 7w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtqnct9v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:10 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK1QKo008666;
        Fri, 14 Jul 2023 21:35:09 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpw0h82n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DgspeLD0yzDEk2KxjAkvkourygS9fDn1PK7/30XmtrJMYikYdUWtzNlJIgr9dPwtEy++7nUpoF+SPy9D/Nko0rfUzoMtU1ntAm07uLUsYAKYhdMPENF3+DCpjXzG3TxEOJUqix5uIghRDMOs4iMM3PdQJ1r81J48K6ABoyfl2blXmYnH8v8eFQuqgK5BoYONKcHsw2d8hjWnJIcZgi6MgRrredjstLhg2iY1TDDVvxWyXhZylIaUSmpYfMKT53Q+cXVhp69b7Y2jdTuIEE4LCbbF+tnNvcpjzIawIt/LJScoknWIckHLPuACj3Tum4jaui752g0WjKAhaIA6CYEwOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cVeL282nvfOA3+yvDKdOMj0c+JdqSKOdqKk3lKBB+s0=;
 b=C4/V5U4ZLypgyXJTC0ZVLT/MZ+sokrfQ9hs1ds/T9rSLIXGTjgSylvkBIgk1XoxBY6B/b+gI1QcKtiblDIPj/xLhi4U8eZ6MlsJpiOcZcQ6If2lwnD3Mzjqfy0idLFqhgskifFCnXZqUjUdbkpq4u8vsLmHj0ATVL55yZJ1sWaX6lxXTIahs1y7hskERAh1tEuHRYujplplyHPcxuTiz2qg2yNIIIvwLjM6dV3yUsbQTr29z4pG3PczQYxEhshwaUXFEteGBZmzfkHDcmogtCD6WN0nOTSI5xIh3OO7TRFJ8Zqzq3kmyYrVen3uV8Xs/UikO2QQuIdq2e/CP4+pT4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cVeL282nvfOA3+yvDKdOMj0c+JdqSKOdqKk3lKBB+s0=;
 b=jcRV01QUM+uJXH8+2iiodY42sIEnO8LInl3vqAu6h7S0Wh046oKzjP0I5QT6Lo08cfK5zO2gW1Hixp4S7iWFiV1XyTV18n19ysSwmc6qpr4Qy+NMxLFkyYRymCS+eo1pu6Xx6bTYAqsIp6HDknMv80kG2/e4HHctQl50fytvc8A=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:35:07 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:35:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 27/33] scsi: sr: Have scsi-ml retry get_sectorsize errors
Date:   Fri, 14 Jul 2023 16:34:13 -0500
Message-Id: <20230714213419.95492-28-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR07CA0012.namprd07.prod.outlook.com
 (2603:10b6:5:3af::20) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: a4faf154-d54f-4789-fb83-08db84b23187
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WrP6QjGNVTmeCIchERh740uN/1JmMkPCWyj7N3TTwtCHyfiuuSv2XSexbsxcDeWhHl7OHgb3RL7x+WmqUd7q6qbE7KDHv1zf7GNv/iqk0I6tus5fdsWh6KdqJ1sAX4axDnMriSgb0FqOiTtFJd5E4uCjlNWS2UCGr8dRaILhLluXx5D5q1/9Ct163a2/mgYKp8txKDZz9mwKy/78m0p5oaET4qE7uDwR+gqPd6skQ5TMHgFs/GMrcfUowTDpuKuvVZhWfwmZJxtIm9QMJCrn4KYBv9JfOIEoNOgKXnLIC9RHMrUgg+LuMiVC1GE65fy+lKLEvgxTQEvDH+CF6ghchiEPUCK2fx95kQwuyCRXpyC8C+yuKe1Vfli9c8YyCdBUlpGSd4BKb3q8i2vrvXWrTh9f0TO5Bitcut7Bv80MJlVxdMpcI/plXDCrht60KWuTJH4ss3wbh0XksIYBZkBQE4dPOtrvxzES+QEXJwAKtatN5RruQETm0LzBqYR6sk3FWa3uj9dz9NxAOMIt+U3duMqzBPELLvYqSJ0BE91NyYkBcTIRvLON4xmKnWHjB8DI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(5660300002)(38100700002)(41300700001)(8936002)(8676002)(316002)(86362001)(2906002)(6512007)(26005)(6506007)(1076003)(107886003)(6486002)(6666004)(478600001)(2616005)(83380400001)(36756003)(186003)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VdmCjULnRQqGGV5PHf6lBxVDBpC3cTjdPKVCV6M63lXWXU9Kh7wdJbKy9DD8?=
 =?us-ascii?Q?j/BuDWzwnQKJvUE6OfPw94oWYlA0F6u8z/mkpW/FndX+VIoQZU8YMeXkD9rw?=
 =?us-ascii?Q?+tlsLhumMOrGoInrcsK835lbe2XSprbNWr/d6d47i0lxt1hWfPKBVGKnUyZx?=
 =?us-ascii?Q?2EiXrwSE48pl50OpqnuIVFZ0+1HgNpYgW2Z/oz5aNYVH0zCYP4xcyTEa3evi?=
 =?us-ascii?Q?hejW+oI72mQXBQ6zU41OCKcZnaL/0BEF6qnNRXsiImFSCIOXb/TYkRglMHba?=
 =?us-ascii?Q?fz1R/ouSCipVw0/HRLVHjK3lbsEIHKsT8oDvRjsnkcP4jWXHHnd4r38Vve3L?=
 =?us-ascii?Q?zKZICzsybDB4XMtEqV8JTthO4o6S7ZJmz33jmPOkpPmbERsNCt1P5zYMHXex?=
 =?us-ascii?Q?j9jTzp7BliZ5Hb3SpUKc+XbFDtwLtFcPHvf43sYZjEbRFqXU5S5wjFQSSY5C?=
 =?us-ascii?Q?6+rnVrN2JliUgjWP447VOcyggpjPlLRJ7Hgdt1dP6EylYKITj0LWgN2WDove?=
 =?us-ascii?Q?HO8j5b7P8mwGeeGGwnMOklJb3kq6UrBkgfG8Nw9BQfJ7iEJC2IpfGQ5n6Mz4?=
 =?us-ascii?Q?+AKAJYh2vjI9B9MsJhatPVb3FyLedIZqNHZ+xn18YLa+qCwLfiQVV+Qf2jLp?=
 =?us-ascii?Q?vuGatJNNMVZy9EkkYkXmYPfM9asaBdM4U9QiyubZnxMjkzQC7u8WLh362vH6?=
 =?us-ascii?Q?t/omSYyuGsf6mR26Up3QS8hEDNGPiZtQlMKnpO1ycJVl1vgrSnqJh345M2QI?=
 =?us-ascii?Q?ZfmxqE/3IAkUNlN6Yk13brCaXjm7mrrdEeMj6ardJ5Rsv0irynauJiqbRJSa?=
 =?us-ascii?Q?5RZrA1q7DDfmM1POKmTahN6SPY1pWdArDrEE8X3INvkOOPbKw3y4LmraG+70?=
 =?us-ascii?Q?kbIRGgBCVnTPy/ko3ggv9ljb3sfkFN7W0hdLH/FqqFg1jbGBq58X+W0hWOLR?=
 =?us-ascii?Q?lovqljWTiWdkDbvPAH39p8sP03U2j1TkwGzvA7B5DaCeFCyHW5kQiq+psCNn?=
 =?us-ascii?Q?jnUYSdyrBfM4csZsD+dOH5DAUPrzIPifvfIFLWAq5jaey0Nv+4tmYQYHSpnF?=
 =?us-ascii?Q?jwhdp/EjHofgbJU1EcXvWoVelqpg5L8dYpPOkBGsL4fQF0yHbYrQtklKcrDb?=
 =?us-ascii?Q?5B5uBCKqxSrhXX3ypjnms99l62gyXQpzxFhia5asPct2HOaczRjkrOT4bTVB?=
 =?us-ascii?Q?OmaI5zl7/CYyijzlpF+NCLbAsgMMDdj75Sol7DqEnRHSXQnHrBgTfleB9n4R?=
 =?us-ascii?Q?ygsu1ZSkK+utzYKf1gSin7mdxzQzQCKPXdTEsjlHF1gbgAoEUQbdLv9KK6fI?=
 =?us-ascii?Q?jzJrZh78x6Pk8y/aQolslWQjEd+qqxFlpCtu24DqCB2C2KPf3Z2sm1QI7INI?=
 =?us-ascii?Q?+pLMRSKFtuIqs99XNx82RsGzHoBGwoTpi4M4yBZEjIk1+MRGI3I906k6SYJ6?=
 =?us-ascii?Q?Vghf5NXhj0yID+GGtFCvNFJbPOQrrBGqhbucfpbZajdbZ3fBzOBmjBSv67O0?=
 =?us-ascii?Q?d1h2BMOQ98mqTn+IsF9/l1YDTF73CTRgx9HoA6rPnOi5aCGxVu3Ja2idoyH0?=
 =?us-ascii?Q?Fo/As0xqmn1EI5XFqJaoq0TLZShC9+gkVd3acz3C8+bT4wpMQcFYSnrrYCak?=
 =?us-ascii?Q?5w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: zd5T7AAPUgP8sWhYn0F07eHJ4NBFrnngIXk+N/ItfjLqAehB2UejCO2qeEX0xcCtpS6VM4TbVKJcwiBCJsf4deMSSoO/N7B7C+Xfzm7oDpEt8q6l2iGoIe8vznNoc5EMXpJdyrQb7ixkVKYJZ3QNmBEpvamkR0yZZeIKIk9OOWoxS+uVf0EuZvwBzerMMFkyhr/OWB3Sfxa2pGkFx4NP2xrspl79mp829cgjYx+RJb0QFiuL2J4DYIpDBfvy/K6sQnvhEP/7wKwixj/zNjEA0jtAbQAqPs+k3sJATXLJ0Cqv0hVFiY6BUG7Kp1wiwIueHXZ7BODo8/3VmVTN0kiPmPgRrPyYYTXUYl3wT7LSAnlV4+f8BMhNemGlf8gFReUnYl0r+AzqtiCVTPWBma+avmu6qsl5+KtBk5Ym6c5T4mwOAGyHq2tJ2tbvThKoquncgs3etA7oT7E1wKsI54MjOwE0v71cAmgjSU22UKqVtoGZOJ8oex2HbnomJsICejyzYa8kKa+BG2ARgXi1WNHcx2Te5YDLwduZDG+tZy/nxSXU/gaybxz9o33IO+CUs09OjV65FyQhMoZprP2lRRCLcKfwRAGZKPlEJlOXFUeRcBP7Esqu/wdyO15Nt7W+hmtNo/bbSQsNKpj6kcMYWLTM+ekbez63Q42AVk6CUJUnxxtmg8lyLashTEgjhu5hr/GIdPhPguhl+PBGCbpIqkmm7kl/UavwWcqJQgzHFH2zxKY+5hG6K3MvTX17/29CfJd2//1j2hZMcESmHA6SYczhy2PBURKWjfbT29KUNZ8HiqGdQbU3OKy+ndG2SkezUYRgX/dtA76SEeTfvnKwrKxBWbD10/qcM2urq6QAaw/cFa4ZOgIj6h3NzHsV2HsIG4Wq
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4faf154-d54f-4789-fb83-08db84b23187
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:35:07.4538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /JpkcISXj4t4Goon5DYRSMoHFbJK9aQ/YCwQl7bvRTtfgQcgsmmhgmCTPTkxlyAgc07HAhjShZwrnv0NAstHS3W0YvDItNESav4tQtBF1DM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307140198
X-Proofpoint-GUID: qxkHvthSY2tvlZVcMe1zjjpM_CyR8qhw
X-Proofpoint-ORIG-GUID: qxkHvthSY2tvlZVcMe1zjjpM_CyR8qhw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has get_sectorsize have scsi-ml retry errors instead of driving them
itself.

There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs the block layer waits/retries for us. For possible memory
allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
will probably not help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sr.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 07ef3db3d1a1..100480f5bc2c 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -716,27 +716,26 @@ static int sr_probe(struct device *dev)
 
 static void get_sectorsize(struct scsi_cd *cd)
 {
-	unsigned char cmd[10];
-	unsigned char buffer[8];
-	int the_result, retries = 3;
+	static const u8 cmd[10] = { READ_CAPACITY };
+	unsigned char buffer[8] = { };
+	int the_result;
 	int sector_size;
 	struct request_queue *queue;
+	struct scsi_failure failures[] = {
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{}
+	};
+	const struct scsi_exec_args exec_args = {
+		.failures = failures,
+	};
 
-	do {
-		cmd[0] = READ_CAPACITY;
-		memset((void *) &cmd[1], 0, 9);
-		memset(buffer, 0, sizeof(buffer));
-
-		/* Do the command and wait.. */
-		the_result = scsi_execute_cmd(cd->device, cmd, REQ_OP_DRV_IN,
-					      buffer, sizeof(buffer),
-					      SR_TIMEOUT, MAX_RETRIES, NULL);
-
-		retries--;
-
-	} while (the_result && retries);
-
-
+	/* Do the command and wait.. */
+	the_result = scsi_execute_cmd(cd->device, cmd, REQ_OP_DRV_IN, buffer,
+				      sizeof(buffer), SR_TIMEOUT, MAX_RETRIES,
+				      &exec_args);
 	if (the_result) {
 		cd->capacity = 0x1fffff;
 		sector_size = 2048;	/* A guess, just in case */
-- 
2.34.1

