Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF722CCF9E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241713AbjIEXTg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239898AbjIEXTf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:19:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C5BB0
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:19:31 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385KnmDA009395;
        Tue, 5 Sep 2023 23:17:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=OhKRiqSA19KCDNZA5NyVJKsTQbD4gsZCXEXls1SlHnY=;
 b=cv3e3QO0Ae2UScqnGFbedlWqWATFlAV9gR1yjBhQV1iWuKiQ5W9MBPASx4tp20wqScmf
 +dWOtRcY+hFQ5lbekPhkjKJ6ebYdEHx6DHNO/1TzUDb8iTVLlTtxLHf0R7hNAwta/oj9
 Ko5NxzEpnQXDyIfepx4zaqgsYGR+6CC5nTD5yBEGLIgkckNV17L5MyNKhJ7vyvRCmsye
 bmV04vIU3ahlrgjfGtl0V/g2aNTqHTeyyBlJ2SMhrs/Kgjx9mIpxwpwtaa36Ue8eCdP6
 V9vGh8yg4JgImlT2TEN5/qKOY4lC34iXY/UXvhwRbWoxYZr8I0vQ6Q+MSjVWt7DgE/Yr Og== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxbq3894m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:17:18 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385LwVYk028173;
        Tue, 5 Sep 2023 23:17:17 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5e4hn-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:17:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZqDrDqfbBtXz1Cl60zu1qfRPRzLU5A6+VmPazg3BPCl4rjj7PtbzePVw27coZKqKwy3pVCuuE+hMLA5Gqh2MOTWM1PN9ZJBhr8wuVg4ARXYAppG//cSrTjOtGUe7ZUrHGVCXYhyXn3Lc+Ox7IJdhxHcKkYfVmzASJXPYDj1mVm9M/7Gr9JS71XnRzChi/oNH7TQvQtoa6p5x4dIyz4j1Q1f0mfiRFRhWw50tPABXzMdlg7JywKqPzfvUH0uQ5Z6LWXHmWIXqJS7MaEfgHnO5QGmSaPkEwHHwwqKYiBAm5ix7diz0g5Y87Q0wnF01l668A67n8z8H/ijTtpsuajp/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OhKRiqSA19KCDNZA5NyVJKsTQbD4gsZCXEXls1SlHnY=;
 b=bZoa6m4NqQIcbqFXMay6ZrdsXA7dACZHYxdXbcMZ7F1osLwANrQw6Tw0GIUyMMuEL7TEMdpRx5nnxaHFJBhYB96wrF4uhyW98W9aGuHqHyc0txg6qjSKSUliw4RlX58OUUWnjO2yM1vU6kegkxj1aoz7m7L/ASXmRncRCSEmK1AnDlDfgkDSkoBFipVA2T3gRrFy9xKQ0zbLGWNP49XHhTNibN6XjZ348pmGJgCXxau7QQKIcJd+kzgx+qhJCAIvNKqDoOS6gobNZ2zj7KUwWMYluDCqCQBmv+6fpVdRf/pqkIgjYpyOWIj1IF3fjgoWvzeOfVIB2xA1YnnL9fLxzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OhKRiqSA19KCDNZA5NyVJKsTQbD4gsZCXEXls1SlHnY=;
 b=pBuzp3qmqwtjABDihY4knXuPeORRlMM6NNK2qT0Z7DtZgETAuJCq7CepdP00Jq6VMExWHDUo4AiQbhwcI18OE0X/e5LKLKL5D8VGhzazZbf4QG0diSJccAZhG+++UiLqc/ovbvIPtPVM7/LxgEwuNfQ0dngsV3HKUSuDZ2TARpk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by PH7PR10MB5748.namprd10.prod.outlook.com (2603:10b6:510:131::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:17:15 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:17:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 32/34] scsi: sd: Fix sshdr use in cache_type_store
Date:   Tue,  5 Sep 2023 18:15:45 -0500
Message-Id: <20230905231547.83945-33-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0131.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::33) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|PH7PR10MB5748:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e8bf8d2-3f27-4a6e-26fb-08dbae662d8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U6vhW8NVn6gcZ9LBweKpWvXl5Pl1khEfM6qmhTL++e5jlOB5K904bnWqN7h3cO1TTC5h6/zzQ4kutogDMlKpq0EC8edggquo0vltB8WsLlYkEf4Myhxe1KEhzf7CpJ2S3mD4Pr6NAv8GCCwCCUmaMftBo+0gUaEjCQyHR3Yti4VTtdTMaIN8kxo31H7I+UT04eACk4twF4yDhgl9L++zCz/Q7velGRQy/sn7IBi2Jw0ufVBRLzIelq5c/qN6fJXB7JZf5JWNnGTxrMI1++J55xtzhZQM9Q4veet4EkwN7WD2VtaxwS5CppgXORuwEGt0WMZiD3t5iERBCT0xKaoNPt+6qCs1ClDRL/HA/3685TbWb4OyGE0yHiL+M5XCjTIzD/onq5itflKObibyfvolzbWZOcBz1HI7E2jooYAcT2HANT1eYe4rQ1gIwwPzrNQg68X/drU4Hd0FDBFRFCf+E8q/tkgWu9p0WXG6MWqBKCLWoxEEQ9PDbpes/sgrQXrL73aBTtMAXxisk650+OECSBiNmMO4BFsuonlfGCX1Xp6v+ZqmDzTVfn7u9ScdYJow
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(346002)(136003)(376002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(66556008)(316002)(66476007)(4326008)(8676002)(107886003)(66946007)(2616005)(8936002)(1076003)(6666004)(478600001)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HRtXC9h6WVGL//mwjqomJ7t0Vh7cMdtDa6y6BWvehYkefu7XaD3I+MrecTbi?=
 =?us-ascii?Q?81+mXn9OmMzYw8PaV/ujpGamUyPSRAp3BHvTvVUyGqHoP+sLaCj7JD30Irkp?=
 =?us-ascii?Q?lGPvMoZU7Pfq0Sys2ehyRBwYqkYECPX9aQ5p5ejqCID+VmoV8hwdP3bKLIIV?=
 =?us-ascii?Q?qwsmv1QY7ahCGEjq4HuBcvXR4ZlMIKYWEvT0dFX1dOrrmze5C+ewxVw9MvDl?=
 =?us-ascii?Q?5spHygNDbf2Y1N6EH9/XUlyZ9agA2b9VJJ49OUrMSgNSSqP2hMcYlT4dFQGg?=
 =?us-ascii?Q?CzJhmewN0mKFV8X9Uns15HKIQe5VUQtHzr6Asnyv22eT2c7eKcqOD49TDJjp?=
 =?us-ascii?Q?iXlxiw23KU4cAiYUaDg+6uwlibrG1DixkyzYK6UckRS+9gK0KqTiA3dm5zKT?=
 =?us-ascii?Q?cONzbXBKoSFDMGVyItNJ3abRCFNiUK/NsDh2KrsbYjyHL7Q8bOtjkvLMm6TQ?=
 =?us-ascii?Q?aGfXvuwbA7yNpe5lEN3ZrKrNRS7d0I4myVQkTlI8NhWL0BfO0WTYDS0ORdYg?=
 =?us-ascii?Q?Gh8rZQkozAgXhsFXpgr1p51yywlm/VVFtjbmAlMfPrypEemGKZxYtkquHPJj?=
 =?us-ascii?Q?DlwHKaRz0fsnoikYUEGw34hJIqm0SILzj7JnaCbnc5WtZC3yoFJex7aiMO1C?=
 =?us-ascii?Q?L4fCO9ysuPcFWyUvXBTIa6548nqHWpC1VApjqdNt2IZ68Uwthy8D1hr3rlQO?=
 =?us-ascii?Q?8JhfSBYJoaoyxunpJ1n1rSJ7XQCy0cEyhWb0R7TKPWubBwZoCdAdMIJM4/3M?=
 =?us-ascii?Q?8tgxMGq2ER1dkH1+QyQrewfjlgwzAH3FRYDqlII66A72ndgu9QuPVspuZAP5?=
 =?us-ascii?Q?8BPBZzjNUf3sQbOz64oyThF0uexbHQPnDPbLLMzr9Pf7eh6zNi8vm9Pchtg3?=
 =?us-ascii?Q?mbNBcRd3JTWnrtc7dGDTaP6VxLjajNTFcI4niFnFQAGpGPhcAnA+cLxqsRtJ?=
 =?us-ascii?Q?TAOyYBeTNprqjtGTPNtSHv+/LizGqERlbh84F7qK8GKp2/st8giiwDV77xxn?=
 =?us-ascii?Q?BLAF41pMzZkSs4tejLU7YvM/hFerIG3YlMK4HPTj+8BJ8gNKKfEOFVcBGCIK?=
 =?us-ascii?Q?vt9io8kDeY2IdpXmmIWK7fQpegvwoVFNePRd5Yy4WvRuAGz3nb1+OWRH8LBB?=
 =?us-ascii?Q?Wq3l+tH9PA5U2xl9cAH0iwOA6TjJq2DVQjkaAoyieDEI+i1aGyYiUUoYyNfq?=
 =?us-ascii?Q?VwCqHiutsHCRtHPXsOwLKQ6kooUJDD4kyE9W07Zp9zbzYiNNP7xad3H3PV7+?=
 =?us-ascii?Q?VbaTH4B957b7FoSfT0/vKCpd6KcV9hgrDQKpgW5yhFUAtXPngzv+NXJrenTa?=
 =?us-ascii?Q?lmqNSGUnPMeyDvklG4Nw/9yAfUY9f45mVFzrfsTqyVJv0da/sG74dHmlUZDe?=
 =?us-ascii?Q?X1XWbrUS72OtXC/dZY0Tigwdv3ekxpLFCNW3us3r8d+L3Q+HunE14Y3fELW2?=
 =?us-ascii?Q?6j1/UkVzFrFaush+RE+59oVq+2Rc9qII6sdtOF256pmLDLPmmngFyLHZtDlf?=
 =?us-ascii?Q?/SMpHobtJa3AMfePy7GRdlceWcB437xdFn0uNH46251v/d1K195Iq7E5TqMz?=
 =?us-ascii?Q?KJZnjdBE6pvSkn37WIHcbv1oJNlJt27ZoMSrj411eHCVAWdVYoN//D3yt0W0?=
 =?us-ascii?Q?yA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ls2tRBDOyNP9oijumVH60IQsSB9cUXERt07M7yh/y5QWg9vm4kEP/K13E5Z0eYwgfIyXFP4EtiOK5lxSJKiZ/tjGHUwNCax75iBVUkI+VsSteVbuuSFK9WNFeWQOvPRKyZJsnSDrWz7X0aix2+sSsHN6y6CURo+1NIjJAyv+8OCFIyBg7ybL80/aayxkhknMtZQt5gs5e/rowFLBKGdePwW+y6JgAmEjjKY/8CuARLm54DIZKOVN/Mtooy/NzXMmRfLF6G8K461OWQJll4Gb+wF2LWW96hYDDZHJBZ5vanV0cs0fi6T3ZcGrie8t3nujlu9KVRF7yiQJHJZxKxKpiFE4yC0ebalqXcLXxvcHwfJYg8Z5RQA5AJ9TKUvQ65aS3fB6EqPVoMbwfzVeeJxTSc4MNyPMeY7uJyVsdfGLZGRS6AZhzBGM8ew8n8ZJZmKrmneU/7Nh4FgPh1OPooEX6APX7jXNVg1UAbx74t8sKcijzYnouHZWY953o/WGMHoxPIhSXxfMshYXhW48fmL1vR/CweK6ixVL7ksxskS7w2hFsw4wLiBS1I2hctd2wigSawU4LcYSYNp8G34ynTLhSS2dcgJ+dJYmDk6ZTiiq3nONZHrV6q+jjglXqnJ5O90sYfVMdOD/885bMKxg18SKNu5UYVcHcW4JaJxv5ihqbWKZx+SxPxalzurCUjP6RpSmvsgFpeKmCZg47meRk8BnZTklXPlSdJ9q+oXkaB1E+BxIRfumCAadsKOo4YosCfn8icKrwX4zK9gD8Vwf7xm2WdvtjcNdsvc18/XueRuYVXMf2o9CSoF/78kHDsWe2Qo/RLTQDZY163C1qfPXoSr6XGtnHO0b95ssq9q7M1bmJSPV9o2tJ5QonaDzsjUH8o1N
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e8bf8d2-3f27-4a6e-26fb-08dbae662d8e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:47.8658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mmfkni3WfZyeVabhcy3OBpCxkiW7I6cAm+/A3YxIA8SuWLlBD6+LxDe3IH5bM8uTbcU6pIs9u4YXLR7p5MLYAoPPwHDGUx+/PrI0s5UlxGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5748
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309050201
X-Proofpoint-GUID: 7pFdp_Xw5wnac4dCXDJAyTSUMc_eUtGF
X-Proofpoint-ORIG-GUID: 7pFdp_Xw5wnac4dCXDJAyTSUMc_eUtGF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when we get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 781df1fefa84..a5c67129b0c3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -143,7 +143,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
 	static const char temp[] = "temporary ";
-	int len;
+	int len, ret;
 
 	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		/* no cache control on RBC devices; theoretically they
@@ -190,9 +190,10 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	 */
 	data.device_specific = 0;
 
-	if (scsi_mode_select(sdp, 1, sp, buffer_data, len, SD_TIMEOUT,
-			     sdkp->max_retries, &data, &sshdr)) {
-		if (scsi_sense_valid(&sshdr))
+	ret = scsi_mode_select(sdp, 1, sp, buffer_data, len, SD_TIMEOUT,
+			       sdkp->max_retries, &data, &sshdr);
+	if (ret) {
+		if (ret > 0 && scsi_sense_valid(&sshdr))
 			sd_print_sense_hdr(sdkp, &sshdr);
 		return -EINVAL;
 	}
-- 
2.34.1

