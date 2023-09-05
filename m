Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10DF3CCF9E1
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235535AbjIEXTf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241210AbjIEXTe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:19:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77493CDE
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:19:31 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385KnmDB009395;
        Tue, 5 Sep 2023 23:17:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=W5IcfVcpivrbnwC+my+4qfZmIaqo79uJ46GgISj5Ee8=;
 b=n7qyJh49Rmu1lD0iZWG9YFoCiFk+M1X8Gw4Z0b50WbZLwtN/UAnXnCvsGMcYLwzXDhyc
 1XWPfgb94f3sS7eVeZPu8465XAD6o7l9KyIO2YmzgbhvqPp5FZiKSXJ4MaqDmDAVCmB/
 ol04b/FevIDM0X6GuW3zz2Hf2ZrZz3Bclc3Dq1Mc+I5kxzCAAfcsIo0Nkynn9tmlshKi
 bKsHD8joUYUa9xLESDdm4veF+yNsdgwYqrAJvBYhzO/fiX0eBN3SR0vHEV+XP5RTGyrQ
 U/rLg2ebPzlgH6dGMaIeftp5U0u0nt6MLF9XsEV4soaW3T5b3GUIztZuNLa6l5r65b5C kw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxbq3894p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:17:18 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385LwVYl028173;
        Tue, 5 Sep 2023 23:17:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5e4hn-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:17:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U0ROEgrwzrrlpyYjBpuxOAafo8DxxCFL6u7zLgi0ch96fGdfZGWYP8LGt0UKf/oB0TnG/dS0OuWQnZ+B1rc/7ynsi/HyoTnyIDESj1gXaWQ33LeU/PUNcGrvStHzbKp+x6oM4gtXR6s7k3j8497VNmI53KdxuXTyowrvrFKDxUNGA2bYTXnHaZdvyR3Xw/WhFTd+7bXOcnhnC5ZHHmkCGX4k4ZeBIv/6N13/A9u+weIhc+pUAnTTEUdQvD+pSXDdWacWI0D4ifCNFkTtEFSpM0nKT04McbmjkB/57loBGYyzisv06GFf6Aamb3Il+vmseLOVAz3xxtfYxSaw8K1MqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W5IcfVcpivrbnwC+my+4qfZmIaqo79uJ46GgISj5Ee8=;
 b=Yg5k7pZjIsfVm7CRYkGa41mESivaz3he8XWRlCJUl8pY0Svfspos8tNxLIJcvE569R0Bj0IUQMFozgYvEXMqiN+kcz9NrL7rIi9R1QL6lRhb2AGIBiXtca6f2UPWMQWONcOEKDER7v3E2LVdMu30uNnzMEshLjP29nEHDp7Hnpyc0uSLRAhty8IPpmMI8oz/t6U33ulduYqdwvtoEKLWa4/DnCV2uJZ17PBO1zNIfpz3ujQZKBeL4i96B76OWC9NY1bWvMKe+roUH19TP7cwXZ1IoAKbocqc/5usAuW66zsOW14zPHXKd1rK/C7Ovm4w1Qe1jlv/YNmBZu5Z6e9XLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W5IcfVcpivrbnwC+my+4qfZmIaqo79uJ46GgISj5Ee8=;
 b=yAQ9/k8A+knOffj9X4NZ4h3WD37J+AuwBcQoCtMnjBs61s4Bs7n/spi86je7ECPIpvg4JdKlSThCD/NJ02jX/seCt3RBqQ3spheTXMJzDT45Uy/zGALO8WM1ab81Wh+5SS6qkvDzw9oCbcgKia1IaKLMd9fNk6rHy62rkg65Teo=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by PH7PR10MB5748.namprd10.prod.outlook.com (2603:10b6:510:131::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:17:16 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:17:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 33/34] scsi: sr: Fix sshdr use in sr_get_events
Date:   Tue,  5 Sep 2023 18:15:46 -0500
Message-Id: <20230905231547.83945-34-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0038.namprd03.prod.outlook.com
 (2603:10b6:5:100::15) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|PH7PR10MB5748:EE_
X-MS-Office365-Filtering-Correlation-Id: 06f7b1ce-1bb6-4086-5e49-08dbae662e81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hYkyqEoeMZ9Q2P51+ia9sKCK2hjEEV9GwO+iUT60/IEjmPfyolg8UjjAlLE1PuaQ19TZVWWUEodIqi1TXGfp7jCX8bVPGWJoP0UX+/ip8CxoUZ5HNYS9DsREYEyWnRQHwvCqdeaMDlaeSGNFOglmcDZedggMg07CT8hjjDFZXDc36HK4kG97aJpJoWLLmYHKGGlMw18VNDHGkKsYVf8yS80rvmGrXjx6YmiFxljQgtOnVxI+8hnDHPuC4FyA7QHZoeguqkqesg8d1pfSvUoUZyTk6prQqZP+urR1f4F9HMNnv9CEFeA1UQneW74Y66wIPj6QFl+gA/XIpcDj5RQC53Tzg/OHsMC2Ba/2ql5ZGCiOB6E3bxQnkQix1sBxv0eoz86kLabPALXbp/js6VNz/YqXUPS+NPJ91tzgrI1OevVJzgcR5S8m5VKHjrgCvHNaGfmlH4knL3QkmwM76mz5KrIBzCfLipEQ7tsp/cdkkIcLuNQpHRw7Ppi6+jJtcn2v1nG3ra7wpwqXPxwrwDBWFr48LOooEmfGdnth9+2cWpvvMqzWg/+4xaYqZXW0eFQo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(346002)(136003)(376002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(66556008)(316002)(66476007)(4326008)(8676002)(107886003)(66946007)(2616005)(8936002)(1076003)(6666004)(478600001)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DvbEr7pndSdRKuc/y4ViyUVGkfWLMXZXJ4bknmtDyVDATYBxnYhtbHWos5VM?=
 =?us-ascii?Q?stXkKzy8+q71PZGou8OsmF90EARhmBKjfBt5pQrmmpEMt5Ccyq8cxL8m4goL?=
 =?us-ascii?Q?tbe81yUW8pLCgRstQiekBK44ta2MRsba5zhY29EnRaX3X1jlT9o08rj3SA6o?=
 =?us-ascii?Q?Ii+IWkkPv6SO/yRI3UDiuXeJmKQehYQahh0rjdSVZ6rMEc2nUNP01FbIWURK?=
 =?us-ascii?Q?nlM3zxz5pQrP7IfKauJiY8mxgrFpwtg1ypI7Ki4rdUH6tEGfi8+1MhMSSH39?=
 =?us-ascii?Q?9/FYMaASeEbTFNih53T23vmmWUO16IhFsbfIhdQEtak9z09NdN2apdMPFMWL?=
 =?us-ascii?Q?1bDwZJrnh290zjf82gFHuCko9FbPcEi1KluylO7/5bOysfXzxkDyMwy9dvKZ?=
 =?us-ascii?Q?MnlwSDx76GCngPtLhagt+2d3ffMQcIrbe0wKMPh45+fVAMlctOfUzv75neh9?=
 =?us-ascii?Q?ZNl+/GgjlU6BRH6IzU6AfyQpk8qfk113lXrrhytC9b7gn1+yd0SZB8mD1HZK?=
 =?us-ascii?Q?X06ZLLaMFhShUburh5FTzMHkJha+aJMp2JHwR8xKeN8WK3mpAPzWe1zGYmK7?=
 =?us-ascii?Q?yD1c4iSRuIpA4mPbbfFadzkgtx2ZWENFqNtB76q0G9rRSy0mU7g+tvaOKxNM?=
 =?us-ascii?Q?DWuKU+IN12z76qh62M7Jy2dpq7q0mlltv588kBISwM/jHqp5gczQ/Dk+egdS?=
 =?us-ascii?Q?YMw3KVAcIyWye5fGT1wqszK4MrTUpIdxzdx7YveB9g94gq7ZAx3iMuOEOKX0?=
 =?us-ascii?Q?+XJkq7M+6Bd9flofVcIssXixvrwhTi9I8Yr7rlFXU0bWjo7aRUYFwrEJmZHo?=
 =?us-ascii?Q?lP6GevZ5Ic7lmnUGojKsPJjfggtNWWMNhdYeBoonucNts8eI/MaXEQ0PVYsf?=
 =?us-ascii?Q?cSSbJgNtTcXj8fP54AuD4VhpW7D2RfPBsoplM2ct+0FoFzZMSHctC/QYuk8U?=
 =?us-ascii?Q?Bo8DDFQYXwvbH/c+hIS1y7QWngsTZsZ2jw2ULgvsZF8OvOVEtXbaEG86SwJi?=
 =?us-ascii?Q?y5tfq+58wCbLu96JNSvWSOc7mHFtuQ+IjoRn9ZZo3+R5BC9GoBObb+YzS+PB?=
 =?us-ascii?Q?WplX2maw+vxS+t9gS6IecFP1jtl9o/B8pEVgDcgn/qrFPpGUI1rfB0d/U9Ul?=
 =?us-ascii?Q?9KSjONMAe3Bs8okFq2k3dVddjiLE0k/+GSKqNqpj9XvEzVggDDUxA0vz2ayr?=
 =?us-ascii?Q?pZlBezOBluA/mEePQYzkieaTyS4n8QpjMeGThYumH9rdaDgyCzMhS87cPQsu?=
 =?us-ascii?Q?TcIZdqDj306mdmFfUercY0oZN0ypjZAKHZSyWDvJh5nIJ4Deqd54jHDmEW62?=
 =?us-ascii?Q?M4W7dhd68C4YcqamZwYIPCfuciSjLU/HaQIjt80nx8UK7uFOOViaZkh34PXM?=
 =?us-ascii?Q?mLfCwjKoXTCcbjyJU5yVJrVUujJ4GK2YmdKOrxxh3FuwRvn9KnM5SHh1iTg2?=
 =?us-ascii?Q?eUwJ9bgWu62wQJr+ccvId0Oze4IbQsgXft3Jp7YMMm1eJcAo2cXe5Lt+seQ2?=
 =?us-ascii?Q?H8wVO6F8di3oGlCO52qC3gZD1cwV4LnIsIu4OVFUj6o71bLj3SqjnJQbqbHW?=
 =?us-ascii?Q?KFBVzgRJXcCHWrX4fX3GtT+l1/ZDpTGwgLyK+9zrLouR0k924vLougaPGUdh?=
 =?us-ascii?Q?Ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: N4WKwIJm5eibFGyNO3Ln11C5ETij8V0WomTuap+oCc5V3ghiYXrtL5+fCHQAdbOvUkdk68SDeTD/jUIQSwOiGd9d/iCX+YHR1xi+ScdvijA+P+95CJShzpbnNeQ5LQk3KiWGGLWa3W8SqHyuRB5zAYJE20Pz+Dl7J98X/oAGY1gyH2+NaTV+F9wYVuX+Nyze4RCcqBk82jkeoU4Du7odvOhZ5bUkK0r78m+sqx0Y/qVZL0V8TY4DoXhwoT5QbRw7p2NRxPYNbk+SMd153C1Zm7Ompn1S9KjLta2xjdVvFM5x7q5kN0VapuvYiwNBMGGddEJSeTFE/DnN7SbH5UYByKWeBqOdbRKvF+I8XnbRNCkKtrMctBGlVVxTg2aO7HCfqb0mIt+4u/aRfGm0FBI4dZLwDWxVJCvt9oMer2Samo8cthI9fbp1L2q2nzmkyQTF3VPdtEArjKRBjh+5VYNj+uun/NrEDQW0WoOw+VWqqp4EqYeZuky94rJyklxylrHL+ttOzosrz5GEYHHIUpItKBGYLsCIb2GhVLvtq8kjOVg2wcuvhF5Y7qjb9XQFsEjR86QO5Ev5azZ03j3k0LEIqXp7wkQa3bXLptp0P7GAbqjM86y9BwUgiVixz1QLHFTkf7kbTDlD5k6J8P/0annb3ucDg9Gw7gQS1EScxa2VM9v1cPpb+8TddcYdAAcnd3uVjI3ttQnHC8UiFz53FTvyajiQpBLdODZMz9P0tbz3IUybwPBIKr4Z0bZJ1WyHFiJ/wmI+OaC56m+DKiiJbNNHBu08nbDD9DBVjiAM4oOcIlI/W55tVaClh/zor8tm92OWaduxQV5/tCihEC4EOQJg7gXr0EQDghEcJZqtNPtcwJDvG4Ixc7orPqpoKQkYAcen
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06f7b1ce-1bb6-4086-5e49-08dbae662e81
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:49.4312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DN4f3GN1eRHSkhKNelTTsqPuGdJOfS84WphGzRIP7mVhGaBuIXjgNBdTGUZR8cDfpMA7qGlDniYjlsNjarY/BzUhXG6+ly+vWEXqEz0zGaE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5748
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309050201
X-Proofpoint-GUID: mLvQzdA4921LTgQDwMnmKiN_iR9Hko2F
X-Proofpoint-ORIG-GUID: mLvQzdA4921LTgQDwMnmKiN_iR9Hko2F
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
 drivers/scsi/sr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 100480f5bc2c..a1889709c84c 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -177,7 +177,8 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 
 	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, sizeof(buf),
 				  SR_TIMEOUT, MAX_RETRIES, &exec_args);
-	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == UNIT_ATTENTION)
+	if (result > 0 && scsi_sense_valid(&sshdr) &&
+	    sshdr.sense_key == UNIT_ATTENTION)
 		return DISK_EVENT_MEDIA_CHANGE;
 
 	if (result || be16_to_cpu(eh->data_len) < sizeof(*med))
-- 
2.34.1

