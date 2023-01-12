Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C618DC67871
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 03:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbjALDJm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 22:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236063AbjALDI7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 22:08:59 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B615A4914A;
        Wed, 11 Jan 2023 19:08:58 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30BLE9YM017450;
        Thu, 12 Jan 2023 03:08:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=CDFOGU0n6KyHZRAj+Dk3rsU7TJ8ELlh2alMmYWeg33k=;
 b=mi9icYtL4T4irZm6FbsZLUeG3qC+gLEAl0WdP19CNagGja5zZgc5SMW+dnbtIpu1OK8x
 MjPHHigNExKshJv/qYWnFkZ8xzOzImgXpt0olAbceIlEy4z7ZFhM954Rv0Uqqr1tYwHN
 6Op5tIRwKgH76avkpD8T7HAMtPCEuuTrzTn3gEQOsKbssvWRZA4vqeH5QOPnb3FLioBp
 d+gtHhc7+oDjwIN90brqUYY54p4/JSf8GuySkbBzWEMv/7/WZLSg+lk5BesFtbt7SeEP
 2QlS0JCFEf8ZnTM9tTI4eKYGEXnL7NcBU3bMqMLycyBE5gd7YrvPitPhjuKJkDy/quJG WA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n22x00upb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:50 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30C0f0YF034176;
        Thu, 12 Jan 2023 03:08:50 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4fuxp5-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LPQ4azu0JC8D/Y3t5qEXjWLP7RQZ+vr5pKIxscdBsCTm4AHvIoUA3HJPQaUDgW4XbnWG/sMoN65Sa2Y6iFC2pdS+uWcyR2CjoE3iFeX5VguvapwsvvemGpupU5MH8EiUxKnGBFJYGY3tmZDyyowyr5rTadodrGU0cCi3Aed68OMv6xnefrzbDVaL6XX5pN5kDqVj0CNqf2eOhSMv8y+tJqD+JPYlwzqVk5LOtk/ov5Zh9NfR9wUam3fsvgZ6RgBNyVPoqBXSBC+x9tuPJWp9Vb7CLoSUXoqdq2E1Gb/X1l484Su/KUpz/4KxqBOq5eQFwDHkyfyLQbpGyJoCeO6bDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDFOGU0n6KyHZRAj+Dk3rsU7TJ8ELlh2alMmYWeg33k=;
 b=AL5Mp8ncBSFqoy+NtYTyNCy7TfucsI16NRkmXWy6gaUFqVSAS7khUsVYPsDRFUx4wI5ROrBIrfEbhVJMlbkw4j9rasDoCnhRBiLKeMXyNHZWTV+c3bEMxaiARR0yTZL7m2bzD6NMEHWj11/ttuCuAwqD8trQHOMcAa/p7aBMoia2H7Ztf2AA3dAFftNpyXEU9A8cLv0PlQxqDyBt5zmpjEp0fW6Af4PZN0Ce14MxCLDo9Pqt1tUQSqxTlVL8QzME8zWz7qOF8ba3amcNni4+hJt7bMnp4tIjOB3ZE9737Oq1c+RA3NleEeks8WTqxQOxRnUwyrpvGAU6eQqo4B7pxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CDFOGU0n6KyHZRAj+Dk3rsU7TJ8ELlh2alMmYWeg33k=;
 b=SHyb4ILal5rJv6ZTbMqK5KWQXhbRN/c2LBsN6x8LxBIj+huit0rfsn006yIlHlN36ZF3UJJFQuyCUqaLhTICS8trMiU83Fvuctla/fNM3DHp/+Wlt8i0e9y4WpKfEeBbwWaSI+NlconQDjZvl0ejQBzeKoSyouXaAgHOUG8uGl4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN7PR10MB6595.namprd10.prod.outlook.com (2603:10b6:806:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 03:08:46 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Thu, 12 Jan 2023
 03:08:46 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 07/13] scsi: target: Fix multiple LUN_RESET handling
Date:   Wed, 11 Jan 2023 21:08:26 -0600
Message-Id: <20230112030832.110143-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112030832.110143-1-michael.christie@oracle.com>
References: <20230112030832.110143-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:610:59::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN7PR10MB6595:EE_
X-MS-Office365-Filtering-Correlation-Id: b09d183f-f367-401c-3c6d-08daf44a51ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1cbC2xEVp0PMdgrcarYbZGl1NpN7iTqaEe218Ug78Oz24EInpiNbqMDNQHlIiaIPEsngEC4R99z9MiIbuP1x4IQYcFNyfFlTrvrjMeuvKlVdMAuMw/ZzIGs8l+UoIMzwIr7t40C7gHvU5jvN4S6Cn0RY1+1yfHrPAq/NS+Zl13LjKguClmMQiSOdtrDVMBsJU2v+yp03oCXMX93lFMmWjPlvWVRaftwYbacYPPojEbZLUNG6JvwzP82sB9+vBR+rWC+8USXHuYTn+EkG0inTOmNwi1Jo7jkAzt3Qgfqjy+ipZ2nak5OoqQPzrQtHDOAHv9nh0Fe3bpJPFPZ3uOuwSxYu+B9/LNY7FiEYHGQTvcwFIFleaBS7RIXUiYcvIAbmcLwpuPSw+xpVV1HB5u9fbqMR+pS86zc4DHf8SzvOSkBJXSg8jz1YWaORR+1GmoGsbzvZpHUg56cYZhcKkPl+n/Q2VTjITljjuO2zmo4RBmLtd/eNBfJZ3ySIrscQmt3jG3efqh2igMQPQxfb3GjV6Tzi4wrxyyCVLv32EziLypZBD6OSTJ9JxGM4nhSSnzKJKVCwYTV8GcczL+FnSukYr2cI//bzySBphHlytmXx3A4t2iA3RgVoRkuILF/DT/6aZa+p2tnXZZjDjyhM0PS+cw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(39860400002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(36756003)(2616005)(1076003)(6486002)(316002)(478600001)(107886003)(6506007)(6666004)(26005)(186003)(5660300002)(8936002)(6512007)(2906002)(8676002)(4326008)(41300700001)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dtj2LbG3bfyYQGKTmp6C0KcFfoJVKN/k3hx2PGUg87QpFBTXaSoGwzgnDngN?=
 =?us-ascii?Q?+f6m3MqixKiONSQcpA5Js6B+k6p33s8p8+6IZx6OONssqQl/feewQLYXED5t?=
 =?us-ascii?Q?CD63U2PKQ77lkrtQqYIngnZUdQFV3egRNvjqO1l67UHrTmaDoLS+TZKkKl8z?=
 =?us-ascii?Q?VlpRDu6H0mf7VAXozg6tsWn0TrXykSWm1Zdk2SFx/YepNVKIgjl4cF052E7j?=
 =?us-ascii?Q?eQHDaNDX7kw7Q+pVQzhByTwYK3JhhJMi1AEeoXpPmqFrbZK1OqtZeITXoRmN?=
 =?us-ascii?Q?jlNpwLYTUXyNMSgSukNGHL3TT6alN4MqUOCbrov/CyqE1xSPOctHVp4kF/1H?=
 =?us-ascii?Q?YFjRKFvnnxr4cUNS+Rbm1c00rj9yYBU8i8J+rvjlrFOFeK6BozsWqgoGu95Z?=
 =?us-ascii?Q?odOQskOp7tElmR1kypbeeq9T7ddm+21uLqVDaLfs0MRC5LewT8G2IWttjmYB?=
 =?us-ascii?Q?i3u7kS4KE3RpGc/eFpbVg0WF9/XTqpGd/B2a0fOi3GgIm1rIuOBQx70AjGAS?=
 =?us-ascii?Q?9686WDhB66TNdCjmRt3A2X2h2ZU/JicvpYL5zovjVA/XjXwesqJDBCbOlOcD?=
 =?us-ascii?Q?qlXyQNMgQfFRXBNrEG6wLaNWirzvVJFQFayLwJsjHdSyBedAw4o0zF1t3fNs?=
 =?us-ascii?Q?YNYHkxrKE0QWIR58agMU0e+JJdQhrEzR0Y+Yeuc03brLEu7IIlKIXXBjXFbD?=
 =?us-ascii?Q?KJv6Ua4DRRuDcJ5EnCUvb19m5rvFxCvGJdjm5qeBu5HFeTyBnHrWU61rXZx6?=
 =?us-ascii?Q?f1pJb2/jgP6h/rqBWNmEYNTtnioxqRRUrKS74XeImbaEvTwATlenXGD+k4e5?=
 =?us-ascii?Q?BY0CFDa4x8PIVTAxCMfKRz/KwA3oHmaZzhQmKMMPzWeNCkoFgcthYaKx1ifl?=
 =?us-ascii?Q?yCNW3s2/xSBO4knd4BxieV/vJhRGkWf3fA4U9Erh/Q7oqZ0vg+NDQnxLi2Rb?=
 =?us-ascii?Q?9Kx42579nB6jmkiksMdtmJI1Wt+3VcZSAycY/MRS8q5KfVFKMfF3yDhZIHMg?=
 =?us-ascii?Q?C69a9Q2AI07oUBhYQ0wrra7LvdE4+2qc6op2lraKQGxq3PO/fPywIUSkLbuK?=
 =?us-ascii?Q?Xa80cbfiezN+kCc0sZfTcFyrGTYpjC4MXYfugqTREWhMhdovNo/eRVGyhj1/?=
 =?us-ascii?Q?XLitNqOjVLd9rFfK/pCxLjAjgJkmy0RR2c4i6Do4zXQk56Mu4uRQhiSukP03?=
 =?us-ascii?Q?zu/5lxgxQnbYzw0kq1mPZOr0btKmSAY8BxWXuejAfPNMsIoumeiI8DFXU+5C?=
 =?us-ascii?Q?wRNrtK/gTm/whrXniV6kh8/EeH6pzmJ9pyQaEfnJOtKS2r+OxUPlht1/9nx/?=
 =?us-ascii?Q?/z4GH6aKytqWILzU6bzlTMX1d/XhEPEegn3XySsW+GqdiXJx/zqVBGsqmt/5?=
 =?us-ascii?Q?wCmSQeKLhgASRmxjyFexsKSND4GwFvwldl6eI2ZlVyUGPLF2RCCkoB8KMNqF?=
 =?us-ascii?Q?BYp+U0Z04bUhNqbmTvADel/Nc89a3o5cEGw2EnwWyLRNar3YTP+B3ScS0fTk?=
 =?us-ascii?Q?Q0o38zY+lyw5d+5+47OYQRSxm8jhQI5BPNzLpctL8rPIlynaOwaYla2R22dl?=
 =?us-ascii?Q?uDcVgYUkmOGAdTW0/IksmWDqaY5BD0vm3k/H7Jk3oxdzhuDSQydYK/W/J5qE?=
 =?us-ascii?Q?SA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: zldM+exm67iMDCINd+h704BG73+yVkwgfXjl0gIOaIWrPmqBT+fV5G53Y3cxdBOLP5cyMS/WH66eJJPUhhoz/gq8gSnxAesvDWyGO3WTZ7UAnO8l88Y8kIsWjQM0UHarE+EIUYUsb+b4ffN810lHt8fgccIv+hkvIScKwES2iZR/hktj/ERjWOAvYBARLFDNC1NfswFHFT4OnsU/qnHYh3rx4hbiatyt+5N4hsZgPywh4r9EbFhbTxnxI1uJ0ri1WPMAmbxWLvK9q1aYxnfgBcZmC9vD8RZ0GI9V6VjuV7th+2XZSwz3bMT5o/uGYqbJAO2Q81uU+XSFmqunqSbymlnJv0QAT2lQMvvEQbMv07OBKxm3NZhyFvrnefGb90wO63QgDw7tLkXS0iGGse0bkulZAN1QoXHtDriPzNQAYCLPiEvhhjGCVEpsghK4Uf85F3lLkP9NmH9aCvfsjc9IsqmJtf7dR95BUmrSMWG03bAZydS/tZP9l9MVondMkq28vilkVJ+OyIFlNJmSIx0kYuPzg/0YxI6BAaSwLBkrJg7KQivI1eSdchcVBNtRyFDFMDwMe3VusZxLO4L+jjNUDT5G5xpuspvVuio/6+mTto7YkOcMyONUPQybKeKEnPWaJwvgMjqay14sJtovrBj7NNe06MDQzVpI0ekh4Pyd9O+xGRr4TuL/zuEB6uld8SvSJ9qTlvSJia+T8yvvudYShhdN0cvMhP+QOSjmaXQ5DdyZkwZW9cm1qA2tcGRUM8+3ii8N4WrMCMIx+zcdZk7KV6HTBetfDFiwQgIlHxVQeuc01ZtFbYnbdm4G8YjdMK1rK3933cU+kFCWpD0WUBM8PQRx2ydvvLDOVNCHAJWFk/ICMnqDi43qD+MLgVRc0S1K
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b09d183f-f367-401c-3c6d-08daf44a51ee
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 03:08:46.7389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ruIzGM5XbkXKNUmlBcGsRRAacqsZpR+wyzgXTrm9MIDyJ3ys6Tm/vY3A0ASTA/V2sGim+0jHKHf6Jf1CT0WuJlrqRoyd7L/UQykdVV3BQuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6595
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_10,2023-01-11_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120019
X-Proofpoint-ORIG-GUID: 9yYfu4BxJla-ka27W2de938aPPgjE9ge
X-Proofpoint-GUID: 9yYfu4BxJla-ka27W2de938aPPgjE9ge
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes a bug where an initiator thinks a LUN_RESET has cleaned
up running commands when it hasn't. The bug was added in:

commit 51ec502a3266 ("target: Delete tmr from list before processing")

The problem occurs when:

1. We have N IO cmds running in the target layer spread over 2 sessions.
2. The initiator sends a LUN_RESET for each session.
3. session1's LUN_RESET loops over all the running commands from both
sessions and moves them to its local drain_task_list.
4. session2's LUN_RESET does not see the LUN_RESET from session1 because
the commit above has it remove itself. session2 also does not see any
commands since the other reset moved them off the state lists.
5. sessions2's LUN_RESET will then complete with a successful response.
6. sessions2's inititor believes the running commands on its session are
now cleaned up due to the successful response and cleans up the running
commands from its side. It then restarts them.
7. The commands do eventually complete on the backend and the target
starts to return aborted task statuses for them. The initiator will
either throw a invalid ITT error or might accidentally lookup a new task
if the ITT has been reallocated already.

This fixes the bug by reverting the patch.

Fixes: 51ec502a3266 ("target: Delete tmr from list before processing")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_tmr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index bac111456fa1..ba2a2c18dae9 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -188,9 +188,10 @@ static void core_tmr_drain_tmr_list(
 	 * LUN_RESET tmr..
 	 */
 	spin_lock_irqsave(&dev->se_tmr_lock, flags);
-	if (tmr)
-		list_del_init(&tmr->tmr_list);
 	list_for_each_entry_safe(tmr_p, tmr_pp, &dev->dev_tmr_list, tmr_list) {
+		if (tmr_p == tmr)
+			continue;
+
 		cmd = tmr_p->task_cmd;
 		if (!cmd) {
 			pr_err("Unable to locate struct se_cmd for TMR\n");
-- 
2.31.1

