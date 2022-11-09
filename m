Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D0CC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 03:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiKIDNi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 22:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiKIDNh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 22:13:37 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA6BBC3A;
        Tue,  8 Nov 2022 19:13:36 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A939TG4020837;
        Wed, 9 Nov 2022 03:11:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=hzxcAPouRFC81x8A9V1Lp6b2S4LrgVJFFaYGB+DTr/4=;
 b=lZFlWshGiPmI6QCHJ8jWS+aCA0i147OH1QGUEAHBH/m88Vrgmeb2ECoFx3QktxIArThO
 L/ko6UbSnKezbTN54lbDvv6TZvykI1i1P8ULj/5wngRT5YKTYn8+qdlOsI4/fEMPuYhA
 CJ6SfIsMPdrwNn50KHP4P/5ChC334FnLQS817vrt1puDwC+rjFwOr65K5re5IAcKYqL5
 cYCq4CaZFIUoWNhDtOybv4R1KcsvoXM+lnt+v4nQoE+ZldK8+Q8jSXLGPg6FwkZy5wPc
 DLVnKAimGeJChHc1De3Ud1xIpY1eXdRRhlw3k+JekmhyMTv/0FlnHesr9ryvtTw8mqvQ yg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kr416804e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 03:11:16 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A930NvU039953;
        Wed, 9 Nov 2022 03:11:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqgv3qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 03:11:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwuJ1xZ7LW+ZXY1VdakcNNSptK/iYLbzBFnY7qGMP/2pf6W1SDr1twgE6elRfL+4gpC4nWFOST4DoAdsTxzyfpK4RTra59ef/e2lXf+AW2z+rqjTfvT2BOYLR6WeUlaqraBo0qza+/HSfdLmeru8k07bUr+BT+nvtmoUKbFp76GE3dTSVwMRv8EBXX1Hv+AKHOodilczbM/9J4vYzdHbY2oR/0B8E81NqQhCi7aWglNhfCoEVwFWWoHsjIyEHscyqS2w+FjHbBxVdfA/1nCNS0HptyYKEx4sASvZm7SctRX8g0f5doe5vWUJr14+qsHoKtwVPIrC35f636Mt+48ZjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hzxcAPouRFC81x8A9V1Lp6b2S4LrgVJFFaYGB+DTr/4=;
 b=H+XM4rGWIqCRCO/UQtLt51V7IR2yxNwtbDF8O4VZ97iFkuahyy8jaVGSNNquCV185qL/yNTIHldDbTRp4lfz9EfJ+8HmcinO0kN59VV6QFJImEMAiqYF9NVkdxibOQNBZtR/gJnzozxuC0M3wFceniYcYHavBUl0T63J1K7vWn/Ie0ALR15f2iGQHmA55nOHLY3uoor0uUQ3nMxTkfu7Gk0x+VcWQvEI/0AH57krZC0q3nqOpH/yrj1DyRk33QkfylXAY/RNPrEu5cOVmEwM4KQB/AmIqu+OtidVgpWCrAxIfH93YZux7wFCyqdtFzcn6Rprm+MjMYgwu9E0aNAsHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hzxcAPouRFC81x8A9V1Lp6b2S4LrgVJFFaYGB+DTr/4=;
 b=XsIl5k955166wxrly3G/wc9HaIlInbFTZKJMIocCDRgdDdMAFIpQ8eMgtKnL6vkdlJ6QUBx5gtCSAypjz7xxNL0+yXnw8HxeAeHXpbpohBkj3+wdLEyTsGiJGStBwMRYwl3gK1GGiY5tqsdgk2zr6mSfXdBzXQdyCubZ3FUwTw4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB6033.namprd10.prod.outlook.com (2603:10b6:510:1ff::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.27; Wed, 9 Nov 2022 03:11:11 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 03:11:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     kbusch@kernel.org, axboe@fb.com, hch@lst.de, sagi@grimberg.me,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/3] scsi: Convert SCSI errors to PR_STS errors
Date:   Tue,  8 Nov 2022 21:11:05 -0600
Message-Id: <20221109031106.201324-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221109031106.201324-1-michael.christie@oracle.com>
References: <20221109031106.201324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:610:b3::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB6033:EE_
X-MS-Office365-Filtering-Correlation-Id: 44f41500-35b1-4707-74de-08dac2000e06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TjWGYDyqBehHJVrCV8g7KXA0RmOvedAMOkEI8xTcfZRNPlGZHtZqF3yRhpmZKxw+LfFXQiRt7lSoegodlbhka9VrTD3cmWdUBM5oLsEZbUioK4x4kkFfgWk88PRdejPIqUB/bD37B1Wx3X54OoRAHBgOFzVAmOGeKSLUVECPm68aAc3V4haFoq3rqme7tcuzgPtIm1FUj11Z/c1EzoTvY5UZYqHVzva46QbZh9Tx0c7rP5C5pMYV+sbSHzqEdIMdzXz/GA2nCcwoK072Q0EEi6i8nYuH2mY1qbYCXW7jb/t/9MDf10fqt9olpijVZvHLxegCRbQvFkTXpMfJOtgNCCA2jxKMSVs5zpqoEr93s7boGeFdy+pmm7agYp/+DHmdIX+xigNXCQoaxasIAqBkExOFkWQCcaRJrDyegvtI2AWKUh9CpK1iet/4gFSYraqPMYPZ2+6WaE28ijxQsTvMgRgoE7RGvpQsVhwpUgGkfafgfMzpps2gUdjNz9p+dPuijcmtRI1KutpAhuqVosTGma3wAi1sdlriArUPNoFZmhx8itNmMeM53u5ijGPxQJFMY3nISU2bEPIDv/171KweWTbO7ZTqj6MyzKFvOxbpUukAv1SQGvsc9g/ij7abMNmNsuv2YInq9RNSYE1u4Q7yl5iDLtechu51EEGmjpQtTQqnt1YloBXAQNLmV0j4ooeJxdaxlqJaVcU/gHexnDaC3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(396003)(346002)(366004)(376002)(451199015)(5660300002)(66476007)(66946007)(8936002)(66556008)(478600001)(41300700001)(36756003)(6486002)(86362001)(2906002)(83380400001)(186003)(6666004)(6512007)(26005)(107886003)(6506007)(2616005)(1076003)(316002)(4326008)(8676002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZRrrePaxYbxUdpmQSkdC7REvkrJFEvjj8hAT1MTidN2RbJdu9f6iucv7as1y?=
 =?us-ascii?Q?ug/MSsWH4Pjh4vUPnfcfHWMsD4Z2G26MN8SfDNOHMFpQKUSxuxM1PF4tl5pK?=
 =?us-ascii?Q?2cvfzvUKcHYhTIjrf2idKqByhlPYSif5AmAdcpiC+/Co9aFkOWx/SpLau+pV?=
 =?us-ascii?Q?efXv4m0Y+oiX1dz4LquCYFWMnXekb7Wl0VYoj8pAl5bNuUt6graJ5dI1ZKk9?=
 =?us-ascii?Q?RCZqkbMHd0PHlfzMUSxgsPGyIJaY4EdexylZHeF9ql5xlkmyUT5V79CIhq9X?=
 =?us-ascii?Q?prCMBJZRHJR2Ux3hjl2C1rAa1AiDskqdDdttVHkyWbgkswu4CJTrldhTMTfz?=
 =?us-ascii?Q?SUZhnIGJzcYZjmQzh+/5XZ4lU+ZMDOb/ItO4ec/9snqWDWWB9aa96AG/sptj?=
 =?us-ascii?Q?p93bXlVQiATDtV4R6Th8Eh27Hqfa4oNYni7QmXFAJxnF8a05Y2/rl4tIFOaS?=
 =?us-ascii?Q?evWZWWwf4Cvoh/x03jCBSOO28JyYGr82m2B1ooZ6ipCPoqXYLrIRG8l/uEvw?=
 =?us-ascii?Q?uYT8AMIGRvrDrNuyqK0UZsPj79VTz1HWeBchd8KuIWgOfxlyqSfRDNcgE6fj?=
 =?us-ascii?Q?lC/Juo+PoL2ASchdvpu9R+OuzwyyV2skl5HQY0wM4WQU/5M3hyXgvc9naNar?=
 =?us-ascii?Q?menS9gWzORSunQAO4zX2I5h45Fv+TUWvBQlDnojhhrN6GE1X5iH31m+hYltl?=
 =?us-ascii?Q?tH3hta92LieRknYnA2LLxG6oF5yA/zAazdmSb9eKEk+XzbPukvYR3H5TIUWJ?=
 =?us-ascii?Q?xQWtQQMlkXtMirokqmsnpscdZW/8vv6v3CVBW/XqbbnB6DCps6wjIUZN7d7p?=
 =?us-ascii?Q?y/MQsNjan23ZxHu/YVUtdJ5mhUxOT64hNr6gOtgRR3Gq+JhVjA7ebSDo74LJ?=
 =?us-ascii?Q?6+00RSVm/PaXy5OheGWUNClYQGCa1Et9WznYzuOxUTBWkOatxc4v4qL+DMM8?=
 =?us-ascii?Q?xPhRd6//2nVxUj5e3jfCHteqd1hOx0j7G0Kw5D+082zdFNjiUOF6sXbQhy0/?=
 =?us-ascii?Q?1z5u1ClpIagg7KWxGiXt5b9VQPj6FM/hVdBfcTmqULmjWNrUbGm0Lm593vRs?=
 =?us-ascii?Q?KbdeGBUVMVn/6NkJ8nUtbjNVnIy7TiHSZrq3s4y9flGUlD6uk5Do4WNcrxU9?=
 =?us-ascii?Q?Y7D8fN8/eFewnk1geQcJ0dmVk31LgNwh6ldLRA6HJMR12nzkz77Eg/5tZaOi?=
 =?us-ascii?Q?pIzWc2wFC/F+CBao31bwvsmiC/rM+/rnCrkoGG8TpExYWqYbwu7uAymzlcWy?=
 =?us-ascii?Q?BBKJy2LmA7vtqJJo/wX8e3OXljHdRxriE7zz1BNLFUmX6FWspTHmTHiTh1+G?=
 =?us-ascii?Q?tCp6DF1fnYN9t/h4vrs/Apl0DCmSw1mbIdm0wwrTJ/Ea1tcmBTjxVva3H/AC?=
 =?us-ascii?Q?j6yQAXzQbAvNMweG5kEUUJzZATI0WU/kKJgrfKGNL3jtlFeQ7WNnuxuP8lvV?=
 =?us-ascii?Q?X5myFll0HWI5Yc/Jm7GX4bFXc9hDBXXb/XVr3RUQu+ss8ZiV6FLjdmL7NuFh?=
 =?us-ascii?Q?dzW78AGhsyxEKclwgxMjXBpi5Tk+tDyK8fuyPWtwKzmgHO0q3MzvjrgRaAqk?=
 =?us-ascii?Q?TCHpwV1HVdWwzhYvihX7xDYV+wtOWsyNdh+rhPq4pCPfX0JfeVWh50d7idVx?=
 =?us-ascii?Q?pw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44f41500-35b1-4707-74de-08dac2000e06
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 03:11:11.8689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9RkNtnLME95uBuJjrKPLz0OSYbP0CB1ZeV93aULxLuUPIOQmfQfsrz9D/vlKHIKlpel+IF4s5SLBDvx+aRiDKfVO0vTT1xbqRfUCP1OvpCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6033
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211090021
X-Proofpoint-ORIG-GUID: O6hUZpcLG-9UDCPlksCEid2lhEIWtn3b
X-Proofpoint-GUID: O6hUZpcLG-9UDCPlksCEid2lhEIWtn3b
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This converts the SCSI errors we commonly see during PR handling to PT_STS
errors, so pr_ops callers can handle scsi and nvme errors without knowing
the device types.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index eb76ba055021..667477d1e4b7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1701,6 +1701,44 @@ static char sd_pr_type(enum pr_type type)
 	}
 };
 
+static enum pr_status sd_scsi_to_block_pr_err(struct scsi_sense_hdr *sshdr,
+					      int result)
+{
+	enum pr_status sts = PR_STS_IOERR;
+
+	switch host_byte(result) {
+	case DID_TRANSPORT_MARGINAL:
+	case DID_TRANSPORT_DISRUPTED:
+	case DID_BUS_BUSY:
+		sts = PR_STS_RETRY_PATH_FAILURE;
+		goto done;
+	case DID_NO_CONNECT:
+		sts = PR_STS_PATH_FAILED;
+		goto done;
+	case DID_TRANSPORT_FAILFAST:
+		sts = PR_STS_PATH_FAST_FAILED;
+		goto done;
+	}
+
+	switch (__get_status_byte(result)) {
+	case SAM_STAT_RESERVATION_CONFLICT:
+		sts = PR_STS_RESERVATION_CONFLICT;
+		goto done;
+	case SAM_STAT_CHECK_CONDITION:
+		if (!scsi_sense_valid(sshdr))
+			goto done;
+
+		if (sshdr->sense_key == ILLEGAL_REQUEST &&
+		    (sshdr->asc == 0x26 || sshdr->asc == 0x24)) {
+			sts = PR_STS_OP_INVALID;
+			goto done;
+		}
+	}
+
+done:
+	return sts;
+}
+
 static int sd_pr_command(struct block_device *bdev, u8 sa,
 		u64 key, u64 sa_key, u8 type, u8 flags)
 {
@@ -1729,7 +1767,10 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 		scsi_print_sense_hdr(sdev, NULL, &sshdr);
 	}
 
-	return result;
+	if (result <= 0)
+		return result;
+
+	return sd_scsi_to_block_pr_err(&sshdr, result);
 }
 
 static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
-- 
2.25.1

