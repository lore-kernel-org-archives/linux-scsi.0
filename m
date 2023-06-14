Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87FAEEB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243382AbjFNHVy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243376AbjFNHV1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:21:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F8D2959
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:20:29 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6k2cS026413;
        Wed, 14 Jun 2023 07:17:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=RZUJPlfKtztXPVD/evtRhkN7c36HQXXfuN/S0ofy9kw=;
 b=JS9i1Ij1NIQHA/MApkzSGHCKNuEs5bQwDd/IMkOXEuhV9KfAljinLsJSjRegBOj69EvZ
 wljOn1+wNFclVSX5pbmd1rrneVc8EG1KKahzq72y0p1ht8ixKVeLXRwwDzGWls+kmxVZ
 V2/FzcwjlXMtBJwVbDBwGKJun/tLsWvNqC0ZNWWRFPlTnXHAWNnpm3dqYCAhSvSwFwA+
 K5KfjPVyzLy2mO2TbQIUkvr/eHqHDIgqiqy43oWRSZqES0rrltY0VXMgcz+2wFrhBspT
 wyCFzd5lEbprL5rutlPrHs36tca25dYjn6SC2fcNvGxmHe3U0KjfvxUgzOKXNVH/kMP6 LA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4g3bpyt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E72W75021596;
        Wed, 14 Jun 2023 07:17:30 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm56byv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ek2xHxlbVrMu4hKLFNtzVa0v5iCFN75fqok+YC01DnZws7wOXjfmQqz5MwJT7YVV68hPE0dlY7VFaauNDBEL64Nz+Xd45V9BYcfUzquc5Ah7j8LIYpTadLPcH564WeMgT+wKPh3F53NKzYQ49SFrSjnfo/9nAznIVVwHA+nVyVgnBZVnlQFlRnfe9GAPUAlVYL/PoLybeHJfWprrM2oJWD9yf6YH2V+7BI1onitgYhj8Tvdu0VB38cFbu8X5zC8IWXF9kf890BLQd2hD1iL73HWUtz6G/Pay5zJlOdRQpp60lUMo5SXtPOzhgFBUQtkkE7gbslBtnhWqDqEQGQWv2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RZUJPlfKtztXPVD/evtRhkN7c36HQXXfuN/S0ofy9kw=;
 b=i7kBVqkpDsudaw06P1//K5OidtvLVWv7pix+N2iznegKKqMW+8jJvxc/0XzxEhsjqyfhczBUY5yQgV0P7MDY91JxeMPSOVayTSnGAEtHeEgWEz9Or9fhpObsqOsg6fhV+uHl7ffyOI8CDu7nO59AvNFonNXrEOTR4z5vzygVed6OaYqHza2EnzQxTT3K97/dvItMVAe95Uw+ClTZTIjlKV7DU2AjIJ1HhDJ3AYEr0xcmPOd4CREVkcWdElicqlo/zwVuetmW4QKx9huOr8UUA2RaZUiM3AInNGpY4EipU+41reFrGw3iUUsyv/eNUBjHPgNW7UgpvlQvAzLtcfLh/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RZUJPlfKtztXPVD/evtRhkN7c36HQXXfuN/S0ofy9kw=;
 b=mm7njwuMSi0Nm67h9nbV6JopZhuzfnYFpBpZEyLTg+FIdSdA/W3PtWadri3ym3tx9Ve9h3OEuu6xUIrxvmcU7eHXEdjOTcNwfGlCoy4B/voZBvHq/SDdpRuMSvs3ipsM1h+Etbk0S1rN53zOTjSeg7WpUKdSdRGclR0XDGuUvm4=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB7030.namprd10.prod.outlook.com (2603:10b6:806:349::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:28 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 03/33] scsi: Add scsi_failure field to scsi_exec_args
Date:   Wed, 14 Jun 2023 02:16:49 -0500
Message-Id: <20230614071719.6372-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0062.namprd02.prod.outlook.com
 (2603:10b6:5:177::39) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: e943901f-0f1f-4223-bf9d-08db6ca768e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hXk7XB3kh+6J7gXfq2d5JRzilmcwrrdFv+bHYXJVmbD7IEh2Nq7J8oVbGoCMRVEvx5jK0cAD+da1Ff5lyDgNn/cUunWdnVA+MkLiAyJAs3jGcy2/nYSk0BXeudYQpIZLQmu5tzoVtKaU+4v7OMlMjjfecBWtogI0oVfwG4hKsLCNr8GL+10p3R1I69znjGR9xkCfBaGDdFNI2f1IJ7LW9fH9tcSlZedcHsrZ61FZTNdw4er1gYLglJAZ62jCsMG8ELa4aEtFCDqDDR3pYZnmzI0kM8OBEpaYsOrolGfmQPqSwtrcHPhteHEI4qInAjegHrJiE7D6TANFEEZZM4aqotGAoIxGab6v0i4dJM4AQ4w45JtAFAnqppyi0GGtKK7Sd2fMAmhkTYYH95LJbwQMyqRY078Szti8iqNeAHQ7I3q+Ye4bkMbMdvQjzW5NAj8CV55j+aNHHtDtqspWEh7Obr7saynSAk7N/6LEFrAykSppvLqoRetOufP7zdGRp5V4DQ7mmN75BvTDUsBBrgB0cjxK6uO7wlDaEhJLbcbYj5sCsm7MV9c9ahQN306zny99
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(66946007)(66476007)(66556008)(478600001)(5660300002)(8936002)(6666004)(4326008)(8676002)(36756003)(41300700001)(6486002)(316002)(38100700002)(107886003)(26005)(186003)(6512007)(1076003)(6506007)(2616005)(2906002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yUNB/5mLkARh88mU2IGwMdd0mSxOXmwcEHLY5/5K4ZCthMkGrJVFJsjE82bv?=
 =?us-ascii?Q?BvPGVXts8YDOg20PI5suLqPuR5FtzNy/onsfsweHvWQ42kHUMrsCEBiF53Y1?=
 =?us-ascii?Q?XNDr5kXpAPrTZe0DHjJP5pXWp92ShpgDx7lXRXUbjoWLwRPOvgWeAaebICjx?=
 =?us-ascii?Q?1H4o6LEt2ilevaiKStjiM+3WxztoVJk87Lg40WJA4X1eDK3eOYPMlCrGUzmV?=
 =?us-ascii?Q?iZ1lqaV9TYD3wuAy6LB7KOZHisfyNUZ/UAbYgdm3T70pPu7Xka15I8Bs+gny?=
 =?us-ascii?Q?v4DHn4xDFyTrn2pFLbFN0mM/wOHP7AXA0AS5IKE89zHryKs8o8CFbA6vlfuR?=
 =?us-ascii?Q?ie3OSxcTjsK7YxUjg5e4vg5zQTH2zRuvOK0rKku5bFADy+Zv40GYo+sEpyMm?=
 =?us-ascii?Q?L5YFpzm0xZ4ONTe/I345dV+EsLboC3hg8GxdkW60YO3VqODr91udn5vSj+8f?=
 =?us-ascii?Q?bK5EPuBW4/WSk8iiyXU/mUXwEHOxZqniTw2Pbdr+ZgR3o2/ouVwBYmkS35ni?=
 =?us-ascii?Q?k6hfYZhuofdQ/lyTZlbqhHKouCLv3pDHAYdU1AqOBXjeqJGfM0w43Pmb1Twl?=
 =?us-ascii?Q?BKNxvjuE/I2Fl0k4D0+kQRyN/8QiCs1Qv6ldCXN431Ds7BGG8+duiJWC+q9C?=
 =?us-ascii?Q?CVyuoWC1Q0lih2cKbyJONRGhVptYXnRhkyjU22rhkJXed7SfO0Sk6By61qGH?=
 =?us-ascii?Q?Zmfidm1Ylgdx5J5njLe128IYu/b1zlFh5uQ5vJMkjLKahzM+u8SDliSkFpMV?=
 =?us-ascii?Q?d/gvduOaiKTl2gf87nk2fQRtcqo0WJDUZVJK6uL7pKsgMsXuXG3rbxrFGYgG?=
 =?us-ascii?Q?geMtPOoFjkXS7ILQhbIRrddtzcX5tiEAnYJgxWjRQPmj3OIAimriKj+OCs5d?=
 =?us-ascii?Q?qJtu76AhB2rRZSSuyYexwUw3nQ2tkF2jKQounYaMWyBuBm7Ln5CM5xKlJMhE?=
 =?us-ascii?Q?AwwmWQSB8Fx8VStxgTOqfsMdc1C7XOqUQSw2qxfSrJo00c1fZR0qmOE8ZhJY?=
 =?us-ascii?Q?x5eNEiztcGYCGDZDMUoxuzX6hUsY40pEbfbF/vuqBCwOwEM+h7pcMphNyyH4?=
 =?us-ascii?Q?79PPgOEMygiLfxb5YbHVhCF83XSdqropDwky7lIYENbA0MV0kY3L9QrrnjuU?=
 =?us-ascii?Q?blblbvo1H6Ne4A0eYewOEvDdBj8OvZuvxlhiAnA7ag78VJmYlhqOeIZdjsaD?=
 =?us-ascii?Q?ZBtYnEBSoK3D/6FIDyCvGD2LW5CR1j4LjlWlvi+ze21TM2RVkrWo/7MC7gUB?=
 =?us-ascii?Q?Yv9EylNsaeuAQ3aF/1OhUnIpybT/GWAAJRH+vXMPaNYP8FFy2dLXQLKwEtIT?=
 =?us-ascii?Q?rYBJqlyxzEVakoWxXpiqNZLmgkqHGMdDRwJ00TUqs8b4GGM3ccgVK5U/V32x?=
 =?us-ascii?Q?VEZ3+hpRu8FJYPHM4Q5O07jpsPFPCKJW80+o3sUSh5yVztwZyApCbNE9k3qB?=
 =?us-ascii?Q?PKnNR85Ne14hNImAdZj2MQHqpf0Z6rfcLFLUcEtVyewARgD7EoNn8Z/4LEPi?=
 =?us-ascii?Q?o+U/DUUo/6jHe33Ael2l80VcKuTatjQrKLiuqYm8AIMNdM4p6pvmkd+ZSU2j?=
 =?us-ascii?Q?nysQUqP9YK6N2pq80K8fpOraWYC1izQfuKQsihLn4WmBRCw5kiX7zpWg6NMW?=
 =?us-ascii?Q?xA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: KgmYaRGpxb81raCIu9pCIoj/PAF0Ts87gCkh7ULmsV73IXb2iTHeT/FKrHNEzeztEordoLiaOzT7RzNRzDNOlqy0omafWc8zDry957LEwtpD3xX6XYJnC0Ah8SlPMCFPvuThmvVWfdqWnlRGxjvezs4sPsH8CcJ0XS0cRnHy+28ON6NLrLUL3gVDGe72QHtIvvAvCFt0NUJklRyqRKeVmCR67Cr0SA4mgNxxQ/mQ/uACY7FM5o69Vl0ORpML3wZ3JBPwNN6bbHE2eMpUiXM0CM62aa5JEg1AlnGNcSMZAyX4i7SSx5gBDY+YENE7LyYJvyBazvhchOLPQ9G9Mxs9MBJY0JXbi4DmUwt7BBTs8HzMF2iMYcBKhNNiLYZ1lRebWgHj50heZ+HSVBCMS+6E70xKw8Z23AucX2Ef1zK4V+eT2m/0IWeDGJgl1Go9NF8rTAmlxf5ikbCliyBjDy7LcQ6HoI4gb4JUmwao4QoElTpYxGBt46tkhDMC2sX6zBBxSLFcYNm7a0i56elxXdZ9otSoH3tg7/f2d2fJNt8djvBvMToUqQ+ZJ4XWAEeLUq5/D+KqshgBcfn+PKoT29pmFtPub/qEQGwR0yx/1eAe3ISlXUSwYwjeELmSoPEX9hpXxO7MWrrNAhXR1CSJQwWyahS3im5VVsVZTuoz15WHN8+H2+EQHWwZTPYItxcLpcIihWCtybtRpBFfaXFEzC2Crc/0WKrGB9w8khHZceQkhoD/Sh2TM6GAnioWVRwJnwibvc93RnmZ43yO8j+JTb977R23biAXiv5riD76vfUthVIzZroQ/gM/rO8UDxUvAsN3+n5VU8aolXyBd+IsyMWZQ6amqzHiQD2vHM1XsJlfzDK7a2PfF1QHBkqT9d8ZbTgP
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e943901f-0f1f-4223-bf9d-08db6ca768e2
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:27.9171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I4ueGiNBdwmCq1u1Z/8BtQplAJ32CHKJFe4aPvHpjSq0ZPlr4J/Pb/qN8VyOIlxwvnJ9uqeQis61l6P6TeSAv5fXLb9YgWH3/htWAExINpM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140062
X-Proofpoint-ORIG-GUID: -ThxQ1zHilVvuRX9hdTyLdM9FFFnFRyp
X-Proofpoint-GUID: -ThxQ1zHilVvuRX9hdTyLdM9FFFnFRyp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow SCSI execution callers to pass in a list of failures they want
retried.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c    | 1 +
 include/scsi/scsi_device.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 53cb649b2f28..f539fc4b7148 100644
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
index b2cdb078b7bd..381d08220665 100644
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
2.25.1

