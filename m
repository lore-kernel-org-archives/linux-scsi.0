Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DDCEC433E9
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4696964E86
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhB0RHm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:07:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59270 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbhB0RCH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:02:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RH0QV5005424;
        Sat, 27 Feb 2021 17:00:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=07JY3KzmlsA2PeJId/YZiQz2bizROuYKAmend1Uxe0g=;
 b=uGLDOQVnbrLKAHJ/+PQUh8E6wjf2AzlgQ9NA9f16KQ0J7E3QtpPuvZn7SN7TmLSr9gaZ
 iRvXhmYyMxDSvAoQdqkF2c9SFOCja1skPFeqBkkvKraqFATPafuWj+Nq+oJjlfPsTrwT
 8UYmvj0pzZ55ZcR1Cqy3BluQ4qMJyeQSiq0ho7UxghE0vW0Xoet26AETT2+hukcd3zZd
 bc2fLPYBOfkD96pRx90B5iwFnmZbXpRWxZ2jrV3kac2mnbJPora6Hdh/xfmbH+K1hN0Q
 I38go9bPQqkuQbV6QbdquWLJ0JU//TxoVBuAdrR6sz/KU2PfF88ZYxrReWitjLx4M12r EA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36ye1m0qp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGslmg115709;
        Sat, 27 Feb 2021 17:00:26 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by aserp3030.oracle.com with ESMTP id 36yc4a7jaw-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mNYZ3Y+N7vKUUMWLo6RPXde0PH9WL9YBI15KHCM60gyxCFA9zh3zwnBx9+7mQ4hp5TL5RSiiNQksTu/f5/+WmLCMZ0aBoskIggmAdYrBK6cha1CBeljbTxte7xEzXCghaCi7czAGF9m6hrduLwXS0VIZh75AL4TTc4909nuyyHOzJwCAi1cT04Q19zB9fM/TDKlmjEPRcg4Dpmf8SSfrH+GpLh1kmgEAY6+igFKZyCXSRNO4Fm2EWSyF6Wc186tDu+yqFE2iG76FYQPmJ6d1QUA/fM9U79FkM7rikTn8EBXGRzBIsVmm1CHQT81kly3GzOUUdGYNzen+o00AhVdo5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07JY3KzmlsA2PeJId/YZiQz2bizROuYKAmend1Uxe0g=;
 b=CkTAH5sFmG1BLhjPImlN25O2Uzg5qL6ulfu+Jc2XcZmkhqexd3YDjSMW/7LKMnQoNDlcoBm75hEK4IOjAjiwP4IMCG9otCEeneLbdIA7hhUrkrYIf9utllQ1YFRgn+rtoinvRVXHn7CiHF4drBSQ93NPeFzuR4e/BMAquvlYneRbVnRiDio8bunqazbmeTjzrz2HTZi1kfJPRXyBI6LPDRi2tBMn5PnsWvPucBo3IulzV43Vr9ANCz2mXBMi0toM7TAiXbRytSYqr++IytaITJf/eenkaWRuvhCPdk8agV6GO6zzUPOLAHWDutRonarT8jCjWIs5uCAFiVVBAjyNLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07JY3KzmlsA2PeJId/YZiQz2bizROuYKAmend1Uxe0g=;
 b=k6qpttGAPf35uMjSRrNU51AW50ckA+YVlfJcpmqdg2tyXgG4iLmWjKGzFKXsZ9hmJNTC2tGQe/L4mZla7igFyjWXL0P1qdUMDFfc0bz8i1toAKp4PxW+iHrYeMdxD4EqJDC6pxUF3/NiVtZy08E5zMS+H2WI1FrPV7cOBBkcg18=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB3499.namprd10.prod.outlook.com (2603:10b6:5:178::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.22; Sat, 27 Feb
 2021 17:00:24 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 10/25] usb gadget: Convert to new submission API
Date:   Sat, 27 Feb 2021 10:59:51 -0600
Message-Id: <20210227170006.5077-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210227170006.5077-1-michael.christie@oracle.com>
References: <20210227170006.5077-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:610:b1::32) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81df6ec2-c2fd-4dad-b175-08d8db412cba
X-MS-TrafficTypeDiagnostic: DM6PR10MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB349961D7989F814344D14471F19C9@DM6PR10MB3499.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N4v2iqDjHn5pxJREBk+AJlorynjxKokRZ1ErmU1luKvsETIGq6kqpOAJ2qC8ysVjPLU+hopoWg2UzHQWGulPKAiMJFta+J5ZRdib5rlooGNy12h8ZYMQertVWfXkY35rBVYKfkgL9DWXk73VfCky4za/JkblePkhBMuLZFlAIfQI9JmuxLmJuCw6wM1j8M62MpF8hJgnWaMs6I07vKjYw9NMg/iMq6p4JHOV7B9ShRYTLNNveEo5ErfNBCTus5B6bFwNos2c+a53f3THMOy4FpTIWECRs76+PH0k+N1PBSWf4VM1weds9cHbIXiQXsoW0mselZ2xVCdFP4rxxb5bsr1URHGm3Wvw6YBrApAwPBFabFa/bAw/khYoAlf1tgkVRqlQ8H6cH5l9n4Tzv6/6hViDh84PnE56TuFl/plNBM2Kq3axOt/SL1uUYyAwxf2b/3P0LnQlu0sSAP3NlXq30rnzUF/4ba7WDtVcCXIRljBTpV0tU+VWpfSwgnC4ipXhzFKHDwPwkcQtbD/OebILTF/815jRA9e6FfNt0iAopdtq+Y2Coupb7DEa+lknmbRgrOX2986s9k7dG9BaC4KOWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(6666004)(956004)(36756003)(316002)(6512007)(86362001)(69590400012)(6506007)(1076003)(8936002)(83380400001)(2616005)(478600001)(2906002)(4326008)(186003)(16526019)(66556008)(5660300002)(66946007)(6486002)(66476007)(54906003)(8676002)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yB+kmK9y2YVV+pI7tpNI+6XCetQviTZCsFg4KqzJ3dNudnTqVj2aIGMZ0L1A?=
 =?us-ascii?Q?FzfvhxjUIvtkXGSsdFe+4BVSIvgVGptf/kMjpnu0iTuZ8L8jtxj1sr0gC5Gl?=
 =?us-ascii?Q?4HlxvOS+aRuk2/OeuBwaSceyWqaMjyM88h5Hp/+KFbsF12hmvh4oz+e5ssVo?=
 =?us-ascii?Q?ZacKDhiRwC1zL/TzJn/E//N/cHqLX/j/aKcuibXrV0dcD4Qa/vOCAqC0Bucr?=
 =?us-ascii?Q?vSbKe3WzwPEl36u8C5Jy/i9t5DK3+6PrNo8Wm0ei0Oygz6zYRz3RvLi4N3sv?=
 =?us-ascii?Q?h0qnxdDpJJgc98tBi6xLghCBahw5gXKj00z/h7E0kXevIRve28yyDiZ5eYSa?=
 =?us-ascii?Q?cbOLTXtx4BAsMw9cL02QmnbOfbnLjYKK4f00n3/Kk9B8cwnocAGl5Vbxql2R?=
 =?us-ascii?Q?B5BeFpjjMM0Xhofmre4bHzdtjdt2iRxOEiT4/+xKOwExQHwWIWOZq/DRhLeb?=
 =?us-ascii?Q?SJC7nBsLuhltPwThwCuVFiW1n9YAHzJh74ow5lgC3Gsaac80Lee+blrKky7Y?=
 =?us-ascii?Q?RY5DrK/JnSExW6kd163TA/s4P3iB9Mr5fX8dL3z/B1wCfJhpObF4xAJGeplY?=
 =?us-ascii?Q?ORGgqcV0IwZRs+xFQ/6Ogm01SbSMd2U12STDCIcM8P/ORBKMo/m7mJOZMtgo?=
 =?us-ascii?Q?wJbZBRMgQT65bBw4Y+xAx1gE+AErO987CVNBO3oOQPBR8HAeHIZeHSq+IhLX?=
 =?us-ascii?Q?fI16I038o8WgUr6evLvN7rNMaknW2qepGNE35VaqfhBsnOAqgIrdtzatrKRz?=
 =?us-ascii?Q?GYbuOy4um8QPVwV2weyA/zNmO72xjlH3m54cd9IspvuMBG9R/dKGC1E5Osbw?=
 =?us-ascii?Q?UmsYFhGSm5xLBQy5C2vFwsbd91ttzMt7Ilh7sSYOdNgixzLE3A/O/ZeK6ph9?=
 =?us-ascii?Q?jD19+P8GLUUBHRqiXGZ0YsEF2CR1v1dEjQ5VLgs7gjmxrgw5WdPsD3/1zIJz?=
 =?us-ascii?Q?rLQ/fapsph5meBM/Xl/983IQbn9y2L/hT1/Z5RN0rmQS1TfB/3veXqlnmjZC?=
 =?us-ascii?Q?2hikB5TPWFN//5CgLgZ+zzgh/hEA8kVewRHZ1liTufMAuGQ8vkx5l3AVn+uK?=
 =?us-ascii?Q?TpubG8ZAuelbO2e1B/sS5S0Tv+Qi/1+/e/z4R36MUQ6+uwcVevA7KX6yVv0r?=
 =?us-ascii?Q?P0nvx96kOONblaRhY+PJh7skVZua0D+8BVaqoxsltS5SdlryVkPYO5+mTolt?=
 =?us-ascii?Q?2Zts9xeQ28tn/FLlch3Tzs5WRthjVNU6zSr7h6hEXtBkqdxL5JrMyox9SoQr?=
 =?us-ascii?Q?jpa6R2Xn50083lF7bjHV5tfsl3KBWv4XtabWLE8Hl02JwOmYwdTBt4JibYt8?=
 =?us-ascii?Q?Lo5/Mdv2hgrsntaMXoChbE12?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81df6ec2-c2fd-4dad-b175-08d8db412cba
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:24.4803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: knIkyA9BgnAQ6Dv7/H4mAtdS/hrNRdQNwntVZcGp7SOrlOCsC+Tn0b/kcTdCiU92PN02Xf5UP8KoI2V7t/vz7cEf1YdmhnaNlo5dMs/ZPLU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3499
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270145
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0
 mlxscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd is now only for simple drivers that do their
own sync during shutdown and do not use target_stop_session. It
will never return a failure, so we can remove that code from
the driver.

Note:
Before these patches target_submit_cmd would never return an
error for usb since it does not use target_stop_session. If
it did then we would have hit a refcount error here:

    transport_send_check_condition_and_sense(se_cmd,
                             TCM_UNSUPPORTED_SCSI_OPCODE, 1);
    transport_generic_free_cmd(&cmd->se_cmd, 0);

transport_send_check_condition_and_sense calls queue_status
and the driver can sometimes do transport_generic_free_cmd from
there via uasp_status_data_cmpl. In that case, the above
transport_generic_free_cmd would then hit a refcount error.

So that other use of the above error path in the driver is also
probably wrong, but someone with the hardware needs to fix that.

Cc: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/usb/gadget/function/f_tcm.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index dcce6e2605f5..7acb507946e6 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1058,11 +1058,9 @@ static void usbg_cmd_work(struct work_struct *work)
 		goto out;
 	}
 
-	if (target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess, cmd->cmd_buf,
-			      cmd->sense_iu.sense, cmd->unpacked_lun, 0,
-			      cmd->prio_attr, dir, flags) < 0)
-		goto out;
-
+	target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess, cmd->cmd_buf,
+			  cmd->sense_iu.sense, cmd->unpacked_lun, 0,
+			  cmd->prio_attr, dir, flags);
 	return;
 
 out:
@@ -1189,11 +1187,9 @@ static void bot_cmd_work(struct work_struct *work)
 		goto out;
 	}
 
-	if (target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
-			cmd->cmd_buf, cmd->sense_iu.sense, cmd->unpacked_lun,
-			cmd->data_len, cmd->prio_attr, dir, 0) < 0)
-		goto out;
-
+	target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
+			  cmd->cmd_buf, cmd->sense_iu.sense, cmd->unpacked_lun,
+			  cmd->data_len, cmd->prio_attr, dir, 0);
 	return;
 
 out:
-- 
2.25.1

