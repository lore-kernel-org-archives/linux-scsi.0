Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24F6CCF9E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242202AbjIEXVa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241995AbjIEXVZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:21:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849D1D2
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:21:21 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385MtGbU023608;
        Tue, 5 Sep 2023 23:21:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=zRpp60yOn36Qig8mH9tbnGp+ZIWAhy2zVlEhlZSj7cI=;
 b=vKKtfQgkeBZNFiNNQ6lcfbLqXLUWKfXzhPKBeaC3d4cSAJTZ/PZ4cSMyMafPsZx6v+h3
 DePQSizpGO11inJqmUral0/L/w2A2Am73s350y7KKeDT8EpsMuaaaB/rGT4t6SxNojT+
 nGMO/Mzm9rE+0jfF/PIfSECwyicEr+0DmaB8iDBFlXF5Ux2a1NTjxTOcOGnLWVSUZUFV
 JupZjsjEB8ED/upjSS0IEomHGVVzIKgVqE/pJfyEAzXi1ed6b+wEkSSL4Fc6YnCGHd+l
 DjCS4SnUWAjO1ayHmnHntHD9hF6Ukk0f+naGHilSBB4hBqGYBxBzkopzE1Epqivb5MEI fQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxdhg81jy-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:21:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385M2ToZ037100;
        Tue, 5 Sep 2023 23:15:55 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suugbpc5m-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:15:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kLE5ozKWgmm/osGCMeffVl4h96CLtHKBenzLhp/oiLWRkF0xhWRlXh/VoZIGGwysHg3+f1yVZ0Mze4P8rfBdUbEnKqaM5hNNZoXlIaNtUypk8ghOA2uBPMUGCvaJlW1FBUYOFwoiVkTXQPLmQ8JNLiNolduOzz/wR3rJutuZB7pPGz36VFR+yFag5owaG0rp86MF3zps+IIlsMZ6jGMKfRyYL4mh/vjqAmv6e+Mzcb9jjiuPcO90MxxJ+uPGjQZutwkOrSiaq1g8YVHTUWkayr08z6qwd7xaVIXShDPHndsM0gsQMFg3ml+YGFnzt1XZftv1kwQ+aItt5zDJHwBCkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zRpp60yOn36Qig8mH9tbnGp+ZIWAhy2zVlEhlZSj7cI=;
 b=gw8xZ9HdARALnmicv7QdZ9H2lUDTrh0bIBJq7reB47ulMmhl7eisZfCHGiIVeE+jzQIQRqiarvhSfqombvo350QvvzLAIXOKzXhfayfV7+A3IwqO+hOWSWwmh0R1Fuxj3yMSG0XFtx4sAaLHATD+QJRUgaiXysOUOQ5NMHdADeNr6Z7vmk04N6RLVmNkbKknYLyCdl3BGjqLfUCqzTiQxL+galM7D1mo3M8vQoLWlW/cTD3pGNc9HZvSpfARkAvT0Wy8QB9pFtnDFJtWobDhOMaOkLT+CUML50/bi8Pg9ugKFwqWdkRE91cTTAwLCqzZfixZkvmp1R1J7s7AMtB8pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zRpp60yOn36Qig8mH9tbnGp+ZIWAhy2zVlEhlZSj7cI=;
 b=MMp/QCGr7NnHFUXzUyKfUB7cpu253ya3zJx3DEEwK/nZ1SA92/v/xakM0bcilaSX5bHskYjmDQwpSAe1QqFO0CQ7npNgrGhNLCXChlcv5FYCTR9Cnk6CbZ7fBfXzHeNgtln2BIoLI1RXLaunPJPy8lcYMzY+XDOY+b7zF/SR+80=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BLAPR10MB4849.namprd10.prod.outlook.com (2603:10b6:208:321::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Tue, 5 Sep
 2023 23:15:54 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:15:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 03/34] scsi: Add scsi_failure field to scsi_exec_args
Date:   Tue,  5 Sep 2023 18:15:16 -0500
Message-Id: <20230905231547.83945-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::28) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BLAPR10MB4849:EE_
X-MS-Office365-Filtering-Correlation-Id: bccbbb0f-7acb-4c89-9564-08dbae660d83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z8qclF+fn4PgqxuUfFDKceTP8OE2oppPE1Q7UHp7D42CIXfROdG3papsxAUBYlPcIJyCRO2YXX+PRpblwx4V4Sf5jRbr6xi3sCGzftzWWySWe5F45PmI+r48YcBSWGFKZja3nL7WvAmmT9801zq8zKlwrkJW4VxLNj35mAsfnDtV9TUEwAouP81EiDKohhLwa3tiGTSLTbRYDGgOYgJUHjlfhj0GtnMxuvHYkXrB7T4T72k8kMT/l7lk3pbwXAEYLzjJdBLaetZ3pxydyu3uyTcuiGDROSTgWr/mGrS7uYhVP0DS3/5If2RAoqN7ij7FafYyB+vFX1KVhh59NjVnfqTofdOTVzr+sFD/5orYlCHhq3TQHckahnin9hpM3Sy2OFzjcLc3dZ3iAyWi/AZp4ooqJZJnUdcJ0VwnoJMw+8bCCORGEoV03dTzmPbzFcaMuQJheM+JgP9oqH0+aSQBMq/Ja78l4DnKwSw2b6vu8aFhu+vcS/WGfrpYDVwBwXlpzT2XDOiyXsQJRidr8LaySD1qdeyyoS7lv9dCY2QWFfDsxrxAS/+VSCjk3PDQJPzY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(366004)(136003)(39860400002)(451199024)(186009)(1800799009)(41300700001)(36756003)(8936002)(8676002)(4326008)(86362001)(38100700002)(66556008)(66946007)(66476007)(316002)(5660300002)(478600001)(2906002)(6666004)(6512007)(6506007)(6486002)(1076003)(2616005)(107886003)(26005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BIKzJjAPQmI5rvsl5j8erv+kTZQWFJ9sssiCjXkmeFufDauibDk0EBFYO62I?=
 =?us-ascii?Q?+bQPfHXGVpp2cyVxX2vrm2AWKi8JOThWplS0QVC2pTvUGCsU0zqykU1fVSbW?=
 =?us-ascii?Q?Lx3e2o4nUwAjJSsiLiguQbSo7lklWbgzJIbGdaaUAMPPCB796qHpDaPF12xk?=
 =?us-ascii?Q?LPF/FwGiw01wLz0ToANA9XOLRZ5h93R58uOra5baQy2jSXxqOmcRQ0A8POMK?=
 =?us-ascii?Q?JVniG4kf/9nKYut1VCMNtBbJcf6LQly75vLyrkNC9bLCurw+1IrQveAP1JX3?=
 =?us-ascii?Q?WtGFEl6cegwy99hoMcLwOJCYxnptZvTbQnJlKp+OTx3Fs2o5bJN9Uw2eFGGs?=
 =?us-ascii?Q?tgLIdIrW2CYfCVuCrvWuQ9qr/3ZU3NVJBAB62iQqKkmvlEHw5l2a0UtNt3V/?=
 =?us-ascii?Q?RTaFXYrlYQL0mQC5wqHmuGFaSThCeIKLhnrrk6rIuSiUjlqDa6Zg0lfthpxf?=
 =?us-ascii?Q?e4m0zWE4w4DOmKIQySohcG6yJAylpQ50zpD/VKZzDMGZ6sLnWJcjLgtzHD+i?=
 =?us-ascii?Q?nVeRwRiiH/mkg2Esnkvp3oLz4eKbVigoFPALkcuABYYoJ4PtuOnoKVtU/ukM?=
 =?us-ascii?Q?qj3xDu6Pr8WFDwLQgMmaZY5VN4HZ6wNwqRdIgHQkKNuyP18M6mehfD1zpS6k?=
 =?us-ascii?Q?Rwp0RmfT+9gIqM1XjRa4OYVZEo/4PnXhnjmg0J73xHO1wT8d7ZqnC/hrYisE?=
 =?us-ascii?Q?aTe+A0cuwoWWgqa+UJl4zPpiy06ktytkKvUGv623SDV0ONMW1k9XN00vjMB+?=
 =?us-ascii?Q?L2+2f60R5vEM0/fVZtzgTA7gWeFeAf62M2g3J+APCcjatNvGHZYVN015FAwI?=
 =?us-ascii?Q?obgBhpQ7dRm2IRq0hcDXgYk2Y6KbGJsndb5gZi7gsv0rb5g55e1v4YxwDqe4?=
 =?us-ascii?Q?Ua3KneAn1Kk1hz2df+OsUPAqupVgnGZ1bfO0zsx3QPrs85HqExd46J3LHusk?=
 =?us-ascii?Q?UfADKsFqFCsKovMF8Wi7rg9Qf7JtBBhcpJRtdwav1iFqSO0gXF+11xnpgDrq?=
 =?us-ascii?Q?icvuYq4HuR7hN6updq4sUs9mAN4HCy3835Fj3XHTB6U5mB0AGxn6YmxoOUAd?=
 =?us-ascii?Q?ZXPdQwwt1y/JW72zVZ0TySPE3LSI7+41T9KJMgrSlj19CBI+oRChcEoanbr0?=
 =?us-ascii?Q?Zvhw5Raf9aIl8Shalhw206Csrk6ZzB6xh7OSXzm0ZFP78xj9pONnuM0WgzPQ?=
 =?us-ascii?Q?V/9qhzV+h21hX6Yvc+vg5sPoV6g5danp8O5K3FhjHpSKJVlgUghZZdds3nB+?=
 =?us-ascii?Q?HpzIWR5mKGTO64JODGHiIazIBMDmUsdIcEpuKo6qarZxxNe72Rwlv2uQJwES?=
 =?us-ascii?Q?T449dfrgNp268WVTwX4ipSXNgCyFNRuaNQaqia67YTZv9hI6zp/xswC+iZB2?=
 =?us-ascii?Q?Ct1J9c1YnO5Q15dDFOIIRgfJdT59AWWhl0kBgNBpZkP+P4ihPVqX0urak8BR?=
 =?us-ascii?Q?SpYdxk2MXa22ZkYrzPCMtIx2P/opyJvuddOzIUCyGKjSv9ED/9+mSQD1m61E?=
 =?us-ascii?Q?tXpwsFTV0jq3omBlg0kulBEbDGb53JftZSoA/z2k0Csu8dKZOyJWTgD6JsRS?=
 =?us-ascii?Q?QNNHvdvx/golnoCzc2JKAroile12iHoDv728GRG6LJhTp3Hh7PgcNSQmpjUZ?=
 =?us-ascii?Q?Jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wXZbKtnTBR7AOXwqAUe7PYxAN4qfqPIFM2DD4yg3hVsUl3w984rB4bm7PnmxN+NSLMn2dcY88AyJDLDoPyYVTjF43azXa2zReuv3dqiUh8vpPXQWqAntMduNcd2+ZEcZdZfdrvsHfH/Fh4ygt7wc1hRi7im5J8vecfj1vakBDtx14gzh+j2k6Y9/HNbQknLZHlaaClNY9fnU0JrfTl+HsCN7y9p20iRSjTB3jwT/+2prnjnmVDANKhXC9qqqjJfn+lRkNZp6WuOTigTuG3o4HNunL8b+Y0y6d0Wx2thvAm4i1dpo8Nu579qeKqLEOF2fSAeAUvRkyS2WR86r9YcRWD6lJXIDMmUxJlS3F+0gZWWj7kP1ySCsoOU40XfMhvzcT7YWW3yWhVhgVY99hq2RFdDCX5V8MW/IUmpeCthjRr4Z1M+bjPg3XcSjBY97Hsq7/BZ3dFa+HP58QJFTZA2pwDL/F39DIv7Vs62Alspiem8xHqdRPPjIL1NQZv16XKewDHSHnLrYNRmdxzVE5wo7nxj4NwKyp0VlHHXy5tI4qqR5zU9Eq5A0EC5ABYR++H8QDn4aRl0p+BS5Va/46JcO4vy5Zja0V1aLN6VrQlFga3wB8VPmpANyufnRV9OQOBJHvHkeLBiKv1C9dqznWK5khrXtiug8IfYvmIq6Nmd4CsPW2YmpvpBlAQjOJP+eHx02NofcirI/I7gAoG0ZGuPTunJmoObIr/uaWOT16VVygfLAqIBfw8PhVRG1ewOU/4tXAWDzR8gqa/1TN3IB9zwFqsBNjN5xUaqBCfXACwXkKdtrU7Og0cLq/b1zMBVL5EHltdfpbotFbBuZDXtcWq+NVDO9xC7bLDd6+1NjE6eCUwr9wmlB31g5cwNdsYh7dNlX
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bccbbb0f-7acb-4c89-9564-08dbae660d83
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:15:54.0432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WdOY81nkRsRd8hRaEViaRcvVrVP4Z77LPPp6eJQbifDiJ0sBbnHGuNGzL8nzWH5sCqHxOH/LVzGIWpxNF59jvfzGFy3uWwCVDbXyA+ad22s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4849
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: iAtwqEJYapjz0ZGWcHosLeVLPyL2xGlx
X-Proofpoint-ORIG-GUID: iAtwqEJYapjz0ZGWcHosLeVLPyL2xGlx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow SCSI execution callers to pass in a list of failures they want
retried.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c    | 1 +
 include/scsi/scsi_device.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7c3e18663c64..d9432bbb64fd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -237,6 +237,7 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
 	scmd->cmd_len = COMMAND_SIZE(cmd[0]);
 	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
 	scmd->allowed = retries;
+	scmd->failures = args->failures;
 	scmd->flags |= args->scmd_flags;
 	req->timeout = timeout;
 	req->rq_flags |= RQF_QUIET;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 75b2235b99e2..accf6c80591b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -14,6 +14,7 @@ struct bsg_device;
 struct device;
 struct request_queue;
 struct scsi_cmnd;
+struct scsi_failure;
 struct scsi_lun;
 struct scsi_sense_hdr;
 
@@ -472,6 +473,7 @@ struct scsi_exec_args {
 	blk_mq_req_flags_t req_flags;	/* BLK_MQ_REQ flags */
 	int scmd_flags;			/* SCMD flags */
 	int *resid;			/* residual length */
+	struct scsi_failure *failures;	/* failures to retry */
 };
 
 int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
-- 
2.34.1

