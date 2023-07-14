Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72158C0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjGNVen (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjGNVei (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:34:38 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8422A3585
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:34:37 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4VFQ019212;
        Fri, 14 Jul 2023 21:34:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=FeD80m4y0fRC0CIeffXenHhQXqbDKXtLAnIb4w3BvR4=;
 b=g1ONt+JiIpi0XBVHtAg3e4hdr1NO9JqLv/NGtSbtNkeCVZnjCoX8UifPbq/Ap+xbCqUR
 z34Y7EaV4KwEN5AQ4lLtYB4RbCDhC95LmX4Bx7lZjxElmXn8V+NCezUTh7atk7GHeIvI
 nhpqBXvzG6dOaTGde5Z/FVWLuoxPwkbPyy5m3lnf7uwdfS9UBbTVxvvCNNMT+8NRrEnV
 9E625XWZ93SCnvpQ/hGHmhb/TRgxatp7cCIV3mFZQwTVHjCZA+ASWkdU01iFvncIHEax
 Eul1J/TueoXN8e9XYWwglJrjCRqmmOqoIDf8+QWWDK4OFRR5RF/VyQ32GLnsODBG5z2p FQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtpttjfgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:31 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK49On033027;
        Fri, 14 Jul 2023 21:34:31 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvrs4a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEJtDB+AD7P/RcgRUdFD2Ud8M4FVPGtFv7vaopX6+xrGl8EQ93Pur76mi6P0FwhRQWB3HJuLuXb0tmQ/l+DXhRFMqsEOpzm53wWeu+yIgr1dsrLBz/byBjIM5p1m/R9lxd3cRX7/xl34KPCmd77YYH+q+8hl1CgJRf+1FFB6qoql2nHCbl58ZuttvIAoNj3N8vYfkLiOWOKucx0HX99OHIsrrY2/SOstBlSTst999Vfm/UlETqJ89rkdNrUnEWYY4yvTIdlGVGf+qXWSegoILZ05Jt8qnWAX+0Sq/2aaaV8sSoVyDJNtkqp87EEcM8dDnhi5ZmWiZgi5hVVDoV1Vpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FeD80m4y0fRC0CIeffXenHhQXqbDKXtLAnIb4w3BvR4=;
 b=K8xCLqwQcOtII9TTS0midNzNNxJQpraSLlOWNlin9QO5hqec1HHSqjADJAadwLbzMDrksTEkofTPUPxKjK4WDhtrEyA4BfsqwOtv7UVZl9u4ZwIRKxe3CNJ2C3CxuN/s1DZqJstVGaq+mYT/LQk7U5DnKMYylsSrrpQochMqJvXKptbDEHocH5e1m5jeL4BFU5XIK0RXtv07ojGXVIkg1o6vOgcYo4yV7hwr0u7auISteEW1VB1bGxK77hru1thvQoapgkRM3LO6Bv1qcK/r2wnPoXTyRAK5wxuRsW8DGZtlK9S/8u23Y58EdI8RsOLnjl4xOoXth3ixpJDlp5i26w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FeD80m4y0fRC0CIeffXenHhQXqbDKXtLAnIb4w3BvR4=;
 b=dBLLJv0fl1Icj0p3ri3xhVREWgdcWtKcVPy8fvXv8ly+vcaYMDeaJyiyoBct2fWWS21cYacYdMS7tL7/tpyFntijd95ijb1KcStlbsY3FWmqbXusVgfiETc2EjEFOfnf2ZvhGbol/uLJSxMZQMBByXeyUzm1tb8fVudCvkiJvR8=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CY5PR10MB5962.namprd10.prod.outlook.com (2603:10b6:930:2d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:28 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:28 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 04/33] scsi: Have scsi-ml retry scsi_probe_lun errors
Date:   Fri, 14 Jul 2023 16:33:50 -0500
Message-Id: <20230714213419.95492-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0071.namprd03.prod.outlook.com
 (2603:10b6:5:100::48) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CY5PR10MB5962:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ef6e47c-6ba6-430e-46ef-08db84b21a73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tuI3z6WfhtvS0F3F9dJQUq5a6JtFi7Nq3QYICvHfq+6ebWslD5mxpb6m/+yaBKaMMIB3ab7Qqg4J/xZtXU8fd1BrmPQiftT4pqPhrkt38Fx+P8BoU/fRRHkglweLp7JsHRpZ/txQ901OL/6B6MiX5s417x3MTey6hB0vBSXwuadfTWzvQFaNWXno8OILJNfxJdiw0OvC2VvRCdXhJjHMCB73CPZr1EENuNnmif8QXBJSuE86VUgOBVz9cAMpzCNnK+OG0t5ZOyHit4y63teyS6Wz9qmeRaO3AmsvkT0zk9AEqFNrjE4a6ea02RKJsqfHLsGD7tU3P7xKHyc8eCyw5oahHEf33OhO1PUCNCIDpbVLKcbRJbEhh5tlte0DQu62uqVBBPXq/SfEmrnuAGJdLTL1ufjLadZ0uto3XCSJUIlqAKPCGamF7a930ggmpW+Jsh5wuCLgEKSsePKTQEj8/8XGQaYXeRPm/wE6+TS26LkQblSuSy0s9drxM+RkXDNqf0D2YFsbnVSIV2MlJrRopASSEKXldt9YaRkfoaltg/ZUrjTk/mmB9BNFS9bBlgrB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(396003)(136003)(366004)(451199021)(6512007)(36756003)(316002)(8676002)(8936002)(83380400001)(5660300002)(38100700002)(2616005)(41300700001)(66556008)(66946007)(478600001)(107886003)(4326008)(186003)(66476007)(2906002)(6666004)(86362001)(6486002)(26005)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TTrDfKEtVwcjo0kyh5p/qDfirDXCEpKMZ0eUWmJSNp3/N83i1mL+ZQvb2DNk?=
 =?us-ascii?Q?wU0tw3IfD8o8JD2PmA40+vi6igoL17x07w6V0yStHOrt4R/RIoM8ORztFXep?=
 =?us-ascii?Q?YLQm4WP+YeUScC8juOZq6W61zISv+aCnN2jEErezskpnCNRcZJ4B4WF1E/lh?=
 =?us-ascii?Q?a8gUvMpMppuwCKjeU3dtSIcme9RwSjgp1MTq4owj5adYQ4CLS1CoubiSpa2X?=
 =?us-ascii?Q?BZxJpTE2RLQWk5/BgysfFdvZ9Qk/USP0GJ0/YJYuM3ejoVPEa3eLkzNtuI2T?=
 =?us-ascii?Q?WaewgTnz06chwkMQB01NvjO0j3JZtrO+i+GZJoiqVWoJvQ5F2cPqARn5xvVu?=
 =?us-ascii?Q?9/JMZfigN/TxastizZYXhOs6SCE6CBcWiY50cN1Eir4wt56U3V5FE7pqcV8w?=
 =?us-ascii?Q?BBvt276vT2igREl+ffxzMLXk195jTbT/BZRMBSvh0I1I3cDY7QJBByzOvi5v?=
 =?us-ascii?Q?CX4O7P/bmBqh02j8RqjC//clSRvFNPtGkNh35IjGKUTOWx5ImNcJbU7eEdK+?=
 =?us-ascii?Q?tw7FyOm/aLkRc7J2Gv8sPrrRMZRBdadHO1KW+Lfv+BVKGlzf6aLfx9oi4ya6?=
 =?us-ascii?Q?GpJiHGfQk3W3ACpWAS1GjeQw8sDL2FqSMhPUfuevGjjbwZL5px8rO//8avyD?=
 =?us-ascii?Q?GtFSlnhPdcKhgdxtRqL0MasSdCWNr4vSELlIb+gQ6o0Gal3u9FyxKCCmfB4/?=
 =?us-ascii?Q?9OEsktKvfLvOtmqPtPJungPDw3o3yxXOCaUrLoHtldhvEoG9IuT3QHlf5D23?=
 =?us-ascii?Q?7ohjgSYjLnpsJVLgaaTS+R9v/H6DTjz83HtUoyVWCJa7suVi6Q9MC7eZkCsn?=
 =?us-ascii?Q?hi2knl7PZoRvnHJp3I0JFM9M0MvGJB80q1fjHuyUfb1lYI3WSwcdqZ3k9V93?=
 =?us-ascii?Q?GH9Cx+f2oh0ZF/xyFOzqt25gc63mW/41Tth4nAGgopbjO77IYsPb1YL7rW7P?=
 =?us-ascii?Q?WSA7/kTOr5sWvozzP8r5PlmlmW3wTg5dEdzn5GPSe2LSuBxL+DnL1uxI5Db7?=
 =?us-ascii?Q?pe0R6MuKpK5t+89F5I3ipaQVwvT02fMlRQpV7D0qptV8MHGl3vmrDFm9d3RL?=
 =?us-ascii?Q?V359y2A3m79XK9WWoiUrXRjdhI2dggV4hMf/wGRwO0CK31AOxDZpXwK6wAHy?=
 =?us-ascii?Q?b/wE6QEvxebjNRWCQ1Q5OoMi94iKAZfLHFhW+zAlkPOwghRnc1xnur7hntL5?=
 =?us-ascii?Q?9r0goBRhfwhAF+aYnVjXa8nje6ZdonD3ILUN9+UTw+jLHeIJHUG+/iLpZ7NC?=
 =?us-ascii?Q?cVuPjNTTQ1BMFomdaMLRJGbBuCEek3QkPNqFLS1lHBUqqgNRnNAuQvJYRRuu?=
 =?us-ascii?Q?lxzDnb1tXG9cA2rTv2/pGlDd3YKKsncHiDfgBkldt5kzBpagtu4sEnb0ImRe?=
 =?us-ascii?Q?IkaadDDWpA6ieOdNRuQEMs4mQsklR+rvHzhWw+FHr9Rw3b8Gq6tr8Xh6nhFI?=
 =?us-ascii?Q?EruPjUkWFBHHyRP6/X7CUBxvpdsgRFd1OEKt52qvfya+cVUXFEzdvrdaoWri?=
 =?us-ascii?Q?zTfx5SqDqSxMb06XUZq255Y0vaqqDfcWL6S190TG+DBNGauG32s+76e47C3D?=
 =?us-ascii?Q?J6vgUDRSAs5xZb48j8ksAMuCqeflyVjk75z2wv+xIsMzCuj/DewhiOeK4CjQ?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +tLFvUpnXEM+3yX8/qx/bfDn8cYrxbXdF2Iw9yCSvAig82xicOYU9/ALZehqb9ciAdKz1HDLyENmVK0PffZIgoIvpT42K1ROOnijfzX63rFYMh2/qQT9L+SRP7wPQemsczR/blADzErg6JRUmVLUDvVm6jT9sYNAzbFH2eO+VbatHY9UkpSOAi5DQ3xIkh72T04OetcP4lQweOUYXFNYhXh7DCdzv+VhtwPsA8DGt1XTAHQlD7F56okTm57xsJSCVRGoJvGIuxwgB5xiLhzPpqqoM2ZMywiG/ikFpWslN8JCXdvd2GmTFqJn2eX9t/vehoaVbHHcL7Pal851yh5r0r0PxPH6/1iyRHp3xrJS2kuQh/bNcS2I4AcWxvE1UKs2aBrGdr7nwZTkWfm8DYUj9srRuzqnoCayVJN4y+BNrd7ck22IQaVGs6iysMLVmAZmb3InRVHQL2I3jXUUxIlp0J5fjJTIrxdvgInlY+koM0sg6WauERCYhEKVpQclSAh35zQMLbBoxfslcD1ePSg8/MODWLlHWcDPkIzAg3NjqfrwCT+bOaZyecH+1UAgJ7jsGZiJkjKE1E+3de39sTNB/UzbvhwUzg2sOm8HlkyRvtRj+STGVHTQSK+1+tIxVjb9RIugAO8iXIvfNPqEJ3SmY9MeEe5Jnqe9w7wila3BHta0CCAf9j7OUFLtf9MWn6Q0lDwTfDt5q0ry3rXCYpACR/WW87zene7oTB0Tpf074x3+nEXmLvgSHz8JGVVUdE6kcSdylCgsOeUf1pbws/56NSN0mQdD0RjNCRl0B9fZaawy4MSfEO5tgldOa2O12W7w5omhjSVzvsWkCPkQwlOl42ffU1dQE5KKkJd7BiPG+jwR3DnJTMjpOnRnhUMYBKLU
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ef6e47c-6ba6-430e-46ef-08db84b21a73
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:28.7262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a7r6YXENlGzn4gvapKsoFeS5d8tif3NNB2E2ctFe3RK/F3N3RMEcdMlx0/KWKfxWoTMJSWbpGSzXV0OWmH4GhyTVbaPDka0Yp7mpJ2PQz/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5962
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-ORIG-GUID: xydX1APW4U8yIBSjCBJYKGmkOB4kN2E7
X-Proofpoint-GUID: xydX1APW4U8yIBSjCBJYKGmkOB4kN2E7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_probe_lun ask scsi-ml to retry UAs instead of driving them
itself.

There is one behavior change with this patch. We used to get a total of
3 retries for both UAs we were checking for. We now get 3 retries for
each.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_scan.c | 42 +++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index aa13feb17c62..39070d9e2d11 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -647,10 +647,29 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
 	int pass, count, result, resid;
-	struct scsi_sense_hdr sshdr;
+	/*
+	 * not-ready to ready transition [asc/ascq=0x28/0x0] or power-on,
+	 * reset [asc/ascq=0x29/0x0], continue. INQUIRY should not yield
+	 * UNIT_ATTENTION but many buggy devices do so anyway.
+	 */
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x28,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
 		.resid = &resid,
+		.failures = failures,
 	};
 
 	*bflags = 0;
@@ -668,6 +687,8 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				pass, try_inquiry_len));
 
 	/* Each pass gets up to three chances to ignore Unit Attention */
+	scsi_reset_failures(failures);
+
 	for (count = 0; count < 3; ++count) {
 		memset(scsi_cmd, 0, 6);
 		scsi_cmd[0] = INQUIRY;
@@ -684,22 +705,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
 				result ? "failed" : "successful", result));
 
-		if (result > 0) {
-			/*
-			 * not-ready to ready transition [asc/ascq=0x28/0x0]
-			 * or power-on, reset [asc/ascq=0x29/0x0], continue.
-			 * INQUIRY should not yield UNIT_ATTENTION
-			 * but many buggy devices do so anyway. 
-			 */
-			if (scsi_status_is_check_condition(result) &&
-			    scsi_sense_valid(&sshdr)) {
-				if ((sshdr.sense_key == UNIT_ATTENTION) &&
-				    ((sshdr.asc == 0x28) ||
-				     (sshdr.asc == 0x29)) &&
-				    (sshdr.ascq == 0))
-					continue;
-			}
-		} else if (result == 0) {
+		if (result == 0) {
 			/*
 			 * if nothing was transferred, we try
 			 * again. It's a workaround for some USB
-- 
2.34.1

