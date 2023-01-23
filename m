Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB47C54EAA
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbjAWWLo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbjAWWLj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:11:39 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDD639292
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:11:16 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLhrB7029649;
        Mon, 23 Jan 2023 22:10:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=tMeDb2D5oHWe1IEASheYyeeKmhnKU7pcjAALiQckKnw=;
 b=dqXxLdtSxNOk+qDbhdg0g1Xn+kf08tifecqTrZnRf/ErcmRenvTdc5V0iSI/EceA7Ald
 NAwQcbgTYMNlpU/KDaQQt3Pz4nudHY35zraPfNnxf8yoRBSZ6QgjrC4n2In3mMZg73pw
 AbdeePwUnd160Dh2OntbcTFUyFWDlOo7ZvlVbHmNaBU4wD0jocqAxbpFcUBqH9OOtcEB
 F5h7N/LKna5/ImLmr/XpJFfdIPWwwJ+X3LgSkuWHzBjKoGzXPwdOJs+G1+0e88lk18um
 Uf4Mneou4TPdYkOf3ArpsthYs5/i7sLgBkW+2BcLRUgObyOKEDCDXQI+Ijb3sNNxw5Xp Rg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n883c41nh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:10:53 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NLXig0040193;
        Mon, 23 Jan 2023 22:10:52 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g450sy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:10:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIIL8hnwFk/CTnwp8Yh27XTj30dZNgSAmzE/rf4CUxqrejPa0ASXS9edDjm3AaLv47opi+yIyTnxAx9RluyfqpTcX9OqkSBoYuYvrCiLjLRyRNw+fWlvXlONRuIjlFMd8smMakEbR/rtC4Uyku4XE5EE17ftwNbp0ASyXvYMMKzdwhQqd2OTYCDjxtKJaL748FNtXuESKqy4q2z91EjaA1SR4U7cQ24wXtzEY4Wceu+N1Yne3gmaz0Fet2DJVtEUYp9GpHe0+vtZLWvRsaMCPqQ4QlcYaZuRwBzcCI4+/qh3I2Ew4UQ46DzMEvN0PZ4K4o+wIGtH8eYf5scpqHkaNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tMeDb2D5oHWe1IEASheYyeeKmhnKU7pcjAALiQckKnw=;
 b=awab1DoRFgWT9i2BevwIyqiorTHztxnNflottT0jRjumI08AN+/+1/YKoTPVBz6+Pwn+WQd7MEdneJ1tYNnbR9HCU9h8+jkBcwo6ZEw6vBUmAMGw8PTBBbFSO2sWrR+x3Aq0243aIvUDkAxG0iUHVlX2gRn1C0HZSDgAxxK0EeCYqLEVJL74dwl4WPlTDCdxn8FB98T2E5SDWFBptRoKJlR0Ghm6seQE78gNNDrBFCv7PMAEbbwacHK071N8ejVIZMN9GZe/FQz/OQI/+wmqaE9F/WqQnTOYTlYb7RRx/4lwfyOGGTaNHlAoDCBZ8Oc5JD0AO2Lle2cQNqP/6OnzMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tMeDb2D5oHWe1IEASheYyeeKmhnKU7pcjAALiQckKnw=;
 b=dIdkuaLPPHMOhq5WrmlqowaKWi0KnJPHW+7brBHu1vUOArsv17XbZm9G4TdWeb16P3aMCPmV5V8opilAkLcaScdcnXLiCMRkrsLK7fMG05C+N0ootHkmhvRYaPE67eXFHo5niW2nax9Zx8YlbPtWuvFRhizPwNiSJKnZZq2P66k=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY5PR10MB6167.namprd10.prod.outlook.com (2603:10b6:930:31::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.9; Mon, 23 Jan 2023 22:10:51 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:10:51 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 01/22] scsi: Add helper to prep sense during error handling
Date:   Mon, 23 Jan 2023 16:10:25 -0600
Message-Id: <20230123221046.125483-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0009.namprd11.prod.outlook.com
 (2603:10b6:610:54::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CY5PR10MB6167:EE_
X-MS-Office365-Filtering-Correlation-Id: 81cd3778-30bb-46af-10e6-08dafd8eb016
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KG2Oq3TKBm2OwIDrCEE3Sili+nQIW/fTLHSb4t13ewWUtkC9q+JvMEj7s3Bmk3YLgV8/3OUChbA3B/WUDeYWDUfURHMX3AW9pg4el/0WLr9XSfi/zwFXTJl3LNOYaAoW/Okr8UnfRZAmeh4cdeYSOqJU/OUmrB7OnDdeJ7mjgx5FxinYKX4ZgwdaeDbCKVCyD95//Znr6mWnp1CyVgncqcGYXCxBnP5OI3V9YYeRrYpzZZh0sHUp+h0KnettZTccZhxeeHGWixdVUrZU79pjUriLGGyE2B9rEy6VQcudWGkJc9Ww4c3ovfbQRqiMjzChcDpjdJY+XQQDLjf2oz5Nw1rFujOtycN7GWi+9Ye3ZZXoByQv/VGkIhJD3iOgjCs10FBcXRXa2n048h3dHBnVHraYBmGrkWUmAmZ4+tEKQV7uTOMBdTOEHdVjwWBLYAybrXxivGKHq5hD8q6T1iMLdjJMCgVi36Z8fSbaLAYGOQdOdswOTjJ4bHfhWPKkdfzUW+4S1q4MI7DKQPxaKM0as/Zh4bd4aLkmtuoiMyEZfwjAO8bGRiXNeTaVOyNQyLxAepjYsWvPlRJdyLdRizWoiPjwxR9qBmb+9fb0cIATj9qCF0hmuasd/tcUGX/kFHexBQuetTMMQvMPiVaVf00CfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199015)(86362001)(2906002)(8676002)(66946007)(26005)(6512007)(66476007)(186003)(41300700001)(4326008)(2616005)(478600001)(66556008)(1076003)(6486002)(6506007)(107886003)(316002)(6666004)(38100700002)(5660300002)(8936002)(83380400001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L1LJphzaOT3cwCv+XXSsnTCWxMBXflz+n7HiuoI89A/i4mVxEt128Q7N6/Sv?=
 =?us-ascii?Q?g/RtEQd24HK3HgLndzxcwshD0HLYceFagr0Zx1bBMRU7Xo53rtBkUx9/QZvP?=
 =?us-ascii?Q?LEYC7JBINV79j2h0mUdG8SU9d3U7AkxFRQwcJFIwLD4GiFJQCLJnGA1SWo1X?=
 =?us-ascii?Q?8+UuKW0IaDRwktM3YDhaYRLQx1wYXGLKuhJvUTde/nfo5h7VOq+6BN6PpgtW?=
 =?us-ascii?Q?gA5UY0j7W3bGjaEjIfOepTKGjy/v87qwt30R990cdPCEiZbRXpdnSDPQsoE/?=
 =?us-ascii?Q?utmJjBkguDRfR7KVc3pgVmE6TNJ2s3/aQ8BykfBoJ+X9bw8zmqVt0Wu5TWTQ?=
 =?us-ascii?Q?zHidEdDQ0WWAi3m+2rpXxQlJOp6vyuTHw7uRuyo1bpjok26J7zl1xVfxZuGn?=
 =?us-ascii?Q?Bx9PrjAcmBFamndQckFLwh31WSyfWzXngW+1Hy+NFktyWMvMs6jjs6A9CLGZ?=
 =?us-ascii?Q?y0rEgTYYeq1oWIZyMLZzrM67abFqETHhi7YqkvIn6EDfhbNqNIibRI+jOgCo?=
 =?us-ascii?Q?iQCJNptBn/rT42P/Rhjs8VxpuasPMHdk68C7bVRevutRR32PVtGzGm1tIZYV?=
 =?us-ascii?Q?z6jo+zMEi7c4HYQlqQ1bOqG9HrKJDd8CfResI+YBmL/RjBhOuJpPqFcQqEPE?=
 =?us-ascii?Q?GfPWVJFVMq2rG7kDavb/Tt8lq7QNM5AJRoopOWAS84vPrSeXD49Z9Ugz/Ktw?=
 =?us-ascii?Q?l0ITgbOb32fS7xI/MinT+71+u83E8oiLv5ab0rLTfa3+Afx4kDHa8TT/RIqe?=
 =?us-ascii?Q?gXYD2QCeOL/vzJ2xxTNaHKCNcaj/q9YK5jw4jKcODDhc9qKyhrqzbySNhQGR?=
 =?us-ascii?Q?cGkgRbApNxaWpTJR9U+JLeoPkyqRbWgYK4GOQubp298MuwQnyRxZMmHPkMll?=
 =?us-ascii?Q?h377FxQCXoiRRduMPP7E+guls1O2fdhVr3BkDFTw1gTOpBN2T+JLizsVFXMs?=
 =?us-ascii?Q?z15Vo2UwBME31d3DsGSKsCWPjAbaeQod6kWplmD+Fi2i02TqIW6/66LueQxx?=
 =?us-ascii?Q?566SW7Wulso3HBkwRCfb23qSPxZXSxqE1ezMM4JXw5tS5fTOSqTfSJUFm3DU?=
 =?us-ascii?Q?gupS5SFKpV1wBoCBfAUzBNy4HtbUiTvu9LPYGORpp4gOsXPfGKrjdleW8XWU?=
 =?us-ascii?Q?rJtg9CR2qe1qZkPU7dWxeZEYa/Dpa5eUUTPqnX0Cq6smHPtDIvuqW//D2ivg?=
 =?us-ascii?Q?1DUC+ZBDKaLa5yFxH3SVsFcwedpNGl2P1kXhn0z0jnKST5aJ8APA9Mg432po?=
 =?us-ascii?Q?wMw5o8Rskzo8cq59sK155UootMFqshtDCmiwE0wkJAPwS0Ftk/icH3gD2zeo?=
 =?us-ascii?Q?cfGhrKIxNQhbyH208W1Uhk7EAG0W1f54HEJRPEBH7nbJAHksG1pFRpqd3Qy6?=
 =?us-ascii?Q?nXhe1hLkT+UZA3MMRrR7gZOmpV75An788a2aBCyKIIhpMD3xtY5LTfuqyqfo?=
 =?us-ascii?Q?nqSD0u4hzv2pe6qa0YkAtht+kHZtO9quiGCfY5HjhWksowxkex6e0OFDt50K?=
 =?us-ascii?Q?ePyFJkvV7myVnHrkUsDcjKlvXVafRbTah0UDW5m/yeRW2TJs5zPYNmP/oDx4?=
 =?us-ascii?Q?6Nlh5MueXCQxKTNNi8cqVByjLRTgdmKlpTebjuumOt5WhbcgH7s28Bd64I3g?=
 =?us-ascii?Q?KA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ZSDuRrjnhYPMPvDpIxr04pO40qFVYtXK26pLQ27rOwYCxlclC03GmcrMQhm8bQoYj1RuJWlcqJ7rmt6LaSCvz7RWWJWd2gUP9Sq5Ie5XpXVeCx14igfvBwHjOcyjleEmOsd6KDpAccW6RH6DNUb7oWfhnfHmxq1dYJXwJQDZ03utOjHKX2KvKveFm0yrdL+R7SIVNC1OldACFnRYbdeHRnyVJzVlW76Wx64KsqrHMav6xgEckp3VlRsKcWPk7ocgsMyONe3WrcohDz8LVdxJxohCIqA/g+YJCZ3q2FYbUmpzU+CTB+e35uTn1KCSbUfjdn7zAEfbDTfMVPSpL2dFaVisEhsLaTGzanhZtrZsMAsdhXWfRe5f/IryWZtK4PF3KHRs5gOMkjtcRb+4xzOXPmIBEZxE1OyYdgJfJEIEOVbQyIggQdQs/gL51K7JHFHjYvJKfXB/8n2Ogllw7BrN52zRcwTtPpwu1SDqBWxxDnor7CzuGTl4NeLI84jhMq/feOOqdRhJkTYY88DzP+oa1we3bM0OoTltJBLvZr2jEYTzSERp1lHvjMXB9fi+1VqM0kuolbgXqbfyWNU1TNg55LEKCO9k4WsqB7Pq+d8wZ2GplRQoVGJgfGLcx4pXPZKE82ItNsMCBqRtxzX+iJ2HFKmhOch7gOtEZd5VljICcai4UiscnriNiO0VxdkXV7684m5uIakUbTBHPF0MoqHJLxRlnDx4noZ4BmldEkA9nBk0u+PU4EpPJ2d1BojjVQHrz33eF1KTUKIHU8hOj5AUUI9YxJN6qyUryjQySqC314o1PU2xDnGSoYRRDxKh8+uQrLuK2gH4PRYbK/tpkV28Y8fP61wrBtHW8hYl75drUlcHdEG0fCsDKD10NqAvZiAr
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81cd3778-30bb-46af-10e6-08dafd8eb016
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:10:50.9328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WbgkgdGA5/TVnErEPRpM8gG2q39auWyjEIwk9qQe1uADDiBjZf0dZHZci4R0t5Iwt2EsKbdZcX0LJKmUUFDMMonsrbkYqqgydsPKYboB8lg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6167
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230210
X-Proofpoint-ORIG-GUID: 41-YzJ19UHXuFy2SKiALtNjzCefTHNJY
X-Proofpoint-GUID: 41-YzJ19UHXuFy2SKiALtNjzCefTHNJY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This breaks out the sense prep so it can be used in helper that will be
added in this patchset for passthrough commands.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_error.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a7960ad2d386..c68db2c39016 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -518,6 +518,23 @@ static inline void set_scsi_ml_byte(struct scsi_cmnd *cmd, u8 status)
 	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
 }
 
+static enum scsi_disposition
+scsi_start_sense_processing(struct scsi_cmnd *scmd,
+			    struct scsi_sense_hdr *sshdr)
+{
+	struct scsi_device *sdev = scmd->device;
+
+	if (!scsi_command_normalize_sense(scmd, sshdr))
+		return FAILED;  /* no valid sense data */
+
+	scsi_report_sense(sdev, sshdr);
+
+	if (scsi_sense_is_deferred(sshdr))
+		return NEEDS_RETRY;
+
+	return SUCCESS;
+}
+
 /**
  * scsi_check_sense - Examine scsi cmd sense
  * @scmd:	Cmd to have sense checked.
@@ -533,14 +550,11 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 {
 	struct scsi_device *sdev = scmd->device;
 	struct scsi_sense_hdr sshdr;
+	enum scsi_disposition ret;
 
-	if (! scsi_command_normalize_sense(scmd, &sshdr))
-		return FAILED;	/* no valid sense data */
-
-	scsi_report_sense(sdev, &sshdr);
-
-	if (scsi_sense_is_deferred(&sshdr))
-		return NEEDS_RETRY;
+	ret = scsi_start_sense_processing(scmd, &sshdr);
+	if (ret != SUCCESS)
+		return ret;
 
 	if (sdev->handler && sdev->handler->check_sense) {
 		enum scsi_disposition rc;
-- 
2.25.1

