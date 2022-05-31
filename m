Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12CB5C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 07:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244516AbiEaHaN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 03:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244525AbiEaH36 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 03:29:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891A4939A8;
        Tue, 31 May 2022 00:29:57 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24V11hU9019288;
        Tue, 31 May 2022 07:29:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=WRJ7gVoOS2lJAM/1dtCehdfHgaaGNUWwa3v4t36H2DQ=;
 b=npe624ETvJEPf9snP7sRQBDvAKF3M1Gc94o51MFYcxnfZo4NAgT5/v7eq9wXYcS6uUTR
 kafg17qWocq5pyvL6uzZNDL+hc+oIvrZqa+eTG2hHr7loJIOxl0jlDPDVzgiTip3Wc+L
 wS1kGY+gMYPh5wzq+0k7v+vs0fngKfVOr2A0WV49z3JULtrGWbSeqRdP7SGsy56ANtk4
 xz4bu5Zv6plnGsBl44a7VlP6IeT1bMfw2ni5Z8fMiiUqaGjYZvulnejGmVfQE/jdoa5h
 kY5eSLXMJlqfXjG6Sc4bpH96yE0+puH6Jpwbfen+aEe0QaW6joDdneQxjkXZa/QiiUSv IQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbcahm9ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 07:29:52 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24V7A694002115;
        Tue, 31 May 2022 07:29:51 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8p1awd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 07:29:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNMzLCYUp9uBE3fFCi6BCO39qdYJgWS2rxJytWQA6yTG0JZ1nvqydzcSAIZFbaGOoCOFtWYMDGCaU2dq+RLqb9Xe4drktzF55y5HK/Twrcsilg3FG/pMn4FThP125u+HBFvevG8MVlXpXVDcAdDjZw9DqnSAlyWdGXSOT4edwN4tFdf38rfzn8ttu2Fon9yk7KnGrmaq75kQ3uLxgeU0k2ABsKu6kAwnQRIl58pAmcwWGpl2w75fRpRmzu0kuY02l1SOoeQY4VdXF+bbmekrVbxXg4/cmtzlPyIxl73WF2a2YJvT0euBPZSRjIAi3ySQjgnx3VRYUpExkkMzQzDhow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WRJ7gVoOS2lJAM/1dtCehdfHgaaGNUWwa3v4t36H2DQ=;
 b=OUTWYhDwy3uplMub/2WexvA5qtKNvjQzD4yY/t68ouj/H19FrYMLACom8S8Vxd0D4yKsL2O0HXU2n76M2Fiwlu3xJLClyBYicJfSRjqj9cOchlpCpT1I4gzcS+HblZw6gv9pViviJVCjESiaDoyEGdmSj9nr7my+R58upubLmXZdnkOtOh46sHAlhcHKQlxEsgHyjPKDqLN+PlwOjhYulFP1ZS1Cnum7HT/fhG9f/6JTX5WSN+8SutkQrU0dwDy4V6FYUSMcB2M9MNfRx+CwwBU0HCLImlEb/T2I/frb4R2hzGDMSCCa9+Y+sfiBGpCiIgVAjblQUsyALiGYGhRdDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRJ7gVoOS2lJAM/1dtCehdfHgaaGNUWwa3v4t36H2DQ=;
 b=veK0MYKLd8KiTRunfXM4uzMzHOBwo0FaZ7mfsu4wqyej3yiK5vTiGzcViwzm9p0gWiEGiBx5/eYDlS02750kW277+cckjOZ73xbIMKmFly66imWgTbBiN0gn8yAHLUKEh2ZDZdHMqeXC4tv3fsUdYdwy/96AAs5/HfzAZwp6L1g=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM5PR1001MB2204.namprd10.prod.outlook.com
 (2603:10b6:4:2e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Tue, 31 May
 2022 07:29:49 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5293.019; Tue, 31 May 2022
 07:29:49 +0000
Date:   Tue, 31 May 2022 10:29:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: ufs: clean up ufshpb_check_hpb_reset_query()
Message-ID: <YpXD4nLc4iCxpw91@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0111.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::8) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 841a959f-5ecd-460c-4995-08da42d75800
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2204:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB220415CF32051935B88EB7518EDC9@DM5PR1001MB2204.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d+g6nvWhb2rMMt+imTO45tjweC9Kvw9jWsmbvMhXoIG9Jen6rTnvMpRZ/Z2h4XSVhCmhYqvaDv+lDszpjj+G+dF5ZtZl4+ygsdlinBpsEvKtz3dK2H+PJUK27PaAej1CIg7aal4cfBBIf7I4x2KauJgzcySllizPUXRbKt88hLFCnolIQgXACSYALBgzfFiYEZhpBSJ4f73Ux9GvpRIqJcBPkNRc3zlombZ68nLIxFqPRpSUyzlfA/gJLk8KvKugmg1Ok2M1mu4Sjsyzq/fE8zsmFDHOVcoczKO/FjM6CaQz6FmAlb0EkrnxTBVHbcMDzfjYFdHZEIXoSuL4u9SXp7OOXIE0RiKaQOhOYNQ7INUK00QAjXidfARFiZPjNMiCIvZRQHCatIxOLbOJkJPZVOVXMVmvVQfNdcOej+9VdbDMsd/2d5yHgSVulAJZ53pKQpuEtEzj8ydyb71gM+zyC3nXkgRyvsfQBstsFZ6AkzVwD0O88D6UMhzXPeoXQE7xFM9rO2VmNixAxMC+VzffXxCeeOl6fukj31HUHN3dxvQF3WwNs4HzTS24/CVlLYsslEKhRJl5jOkXOmYGQGC7GWXmVWKiV6sb/Mq8mq1WnOkhiDwC8p48Ed9y+cYmnLcbfmkYZv85a2N2BCLDybcMW0JegrChl8AEHedVWHYvH8Id4Z0r3ydKUPeuJSlYpErPA4SV0e/yPX16QhJcxNxh8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(44832011)(186003)(5660300002)(508600001)(83380400001)(6486002)(6666004)(316002)(6506007)(66946007)(4744005)(86362001)(33716001)(8936002)(2906002)(66476007)(66556008)(8676002)(26005)(52116002)(110136005)(38350700002)(38100700002)(9686003)(6512007)(54906003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?la8wL9wkMepAZN5tZIiYJUeJ93n4TWP7M91wHWVpMGv3HdtWx3IVDQj5mdAC?=
 =?us-ascii?Q?jQ186PmPRElpqcvBcNJwEBufQVgjeVxwBIN5CO4Qxa/RTP8oczq004vq/0R0?=
 =?us-ascii?Q?eD6BDZwzyVihIo1QxZPeoNQ2uM71xib1H86yeNNr11UOKEIOMJsAari31fWe?=
 =?us-ascii?Q?yHMQsdxzLRfgQrLgfF7pv/UWtSsG7zGMgUkE+HCcTQ01YLCXLI+E2SXbUYA4?=
 =?us-ascii?Q?ztYhl4Niwy/ECR+3+kEhPlmF/ZRxYa3srIg/+yWNbotU2ugV2xRfzZeBMMxr?=
 =?us-ascii?Q?QnLTnS8+/7xwVrSEM3Qijy4TRmzszf0EA76ODrS1qP6f1QPQf+QUaqZVWTRB?=
 =?us-ascii?Q?oW8oA2dG8+CK9CVwE6gvOvLWljCvnbt1Jn8pdKubI7O20Oi+RAiuVK5+AND1?=
 =?us-ascii?Q?HzwugI6PyILinaqRbezVrSds9/L0F+vjS+EKTbASuws50kjyjNZKLDyqHm5p?=
 =?us-ascii?Q?/10DDpwctBU8xkznM6fselTvb/Y+LTE5p8KScdLDA/mYKNJJYiMkUcLB8RxZ?=
 =?us-ascii?Q?d6YlKzXVkwu9Cf4EK1x/87o0HLK8ywuo6M3Ym4UmT3qmqXXE2oUPh2xfoqwf?=
 =?us-ascii?Q?7YhoocMUvYIt8MIEK4RlGZpF5SpgYolrnGt8VzbPuSIeAI3ZZOOEOAu2wlFZ?=
 =?us-ascii?Q?QvKKXCBJU7V2co7/MwkF8UGlF7pb2JsnZ/yb5iN+vnd2cJHPKrpF8P1jYP9B?=
 =?us-ascii?Q?QPnpGT4xD0npiJOWQG20SkNaooDZCdCtpsAZr/S3BnEx0WlJUz+9JLztaYnS?=
 =?us-ascii?Q?wf4Y2hGlgSg4zwGhwAK58mAvCa3c0NV8qhrM0KnWV2iIGviuVsVTroDuAI4J?=
 =?us-ascii?Q?XDNhu2EWFYpIYXcvjmt7/kprO5mNsgsMFeU2H7XwxmD5RqF6CXvPyrhYK+Su?=
 =?us-ascii?Q?j+Up6S0Lrh/dH+/uL4NNBxF8c7M6oZWsjrs2gLy0WHyMVoDxkjAIoMMaBfCQ?=
 =?us-ascii?Q?KFFGeKAL4h2mPGPpGXRKDLra3apUzqjx9y13URZQjPQSdWoDapvWRoLVQJ8u?=
 =?us-ascii?Q?c9ase37n1WKqkkRXEOiDKbxUkJXbbTeXvatoBErTDkiq6aQT0aiLUbW6kdVm?=
 =?us-ascii?Q?Wd7ewClHhT3dk2yPCST+fhMw3gcfesFHj0JbLfwtIIu8VFlfOfgg/2d1YdmK?=
 =?us-ascii?Q?KMDafk+JTERDSWkT0ByAfd/4LYWec8oLfbH9E38kHwGvNqXUY0zZlXe9OI4z?=
 =?us-ascii?Q?FQs+TLTMpVlV6FS8k+DwywtwflFyDtv+LSj5hqB9MVS5r6EyjndJ97S5wSex?=
 =?us-ascii?Q?pT+vxobaPJanxR0wgc8+RgjCfInZuiotcDHhL+CNMlbSW115NTQAn8bjZeAC?=
 =?us-ascii?Q?FIEd/P9K0PgylKlXWSbUTBNLVyZeLMOcu/Lsrs9pCvlgSO1ZDs+dhpMt+PQl?=
 =?us-ascii?Q?VJtIr5A3DTulr5GPvvZiUr7o2S2ZUqKhDYyPHJobagYX+USZiVGykKVxcOaw?=
 =?us-ascii?Q?ZdQJSST3VdoHaz7WCo5gHjG55L6S6M/VGTsrt3huC1mGmQynVBNOOer1AUQH?=
 =?us-ascii?Q?JE3ym8i+eZ72ORaeE39ECOEb8b5WiXbXsAHQl1ANBrZ7pjmflFhbOciIJQtO?=
 =?us-ascii?Q?uJyk1WVoGmqqh4NFi6vF3w2RIhHPAA9NKBWDreOptl1VBZC5P/zgCIyuMlmo?=
 =?us-ascii?Q?K4SQX4OXF+61najXDFOpV8MnR3C/4pEfKjke5e9Z9CiVDChesMcBN7/WRg5H?=
 =?us-ascii?Q?4b+eF6MBboFJb1NW6dk+qqDfQSVyE3RzqIYrkmdT5zSrz2yYeFlWPvLqgnq0?=
 =?us-ascii?Q?7bu1HF7y2KW6LDV0Iwp8knP2joXKZuY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 841a959f-5ecd-460c-4995-08da42d75800
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 07:29:49.1130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZ9f110hjojePetE/uX0ccjINsskyuuUNAFvdi9armLCoDPjpnFwSEiQdcw5DyfRHp7QAM3fgdGS0cEmVCXVmu3k9aq3olf5X9vrA/GeVZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2204
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-05-31_02:2022-05-30,2022-05-31 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205310037
X-Proofpoint-ORIG-GUID: yybVq4gQqMmgL2hvlrYKHC-pP6MxvGuD
X-Proofpoint-GUID: yybVq4gQqMmgL2hvlrYKHC-pP6MxvGuD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Smatch complains that the if (flag_res) is not required:

    drivers/ufs/core/ufshpb.c:2306 ufshpb_check_hpb_reset_query()
    warn: duplicate check 'flag_res' (previous on line 2301)

Re-write the "if (flag_res)" checking to be more clear.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/ufs/core/ufshpb.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufshpb.c b/drivers/ufs/core/ufshpb.c
index fb122eaed28b..95b501b824df 100644
--- a/drivers/ufs/core/ufshpb.c
+++ b/drivers/ufs/core/ufshpb.c
@@ -2299,17 +2299,15 @@ static bool ufshpb_check_hpb_reset_query(struct ufs_hba *hba)
 		}
 
 		if (!flag_res)
-			goto out;
+			return false;
 
 		usleep_range(1000, 1100);
 	}
-	if (flag_res) {
-		dev_err(hba->dev,
-			"%s fHpbReset was not cleared by the device\n",
-			__func__);
-	}
-out:
-	return flag_res;
+
+	dev_err(hba->dev,
+		"%s fHpbReset was not cleared by the device\n",
+		__func__);
+	return true;
 }
 
 /**
-- 
2.35.1

