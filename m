Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F342BC43461
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4F6E6117A
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238384AbhDPCwZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:52:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56530 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238277AbhDPCwQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:52:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2pgkI044417;
        Fri, 16 Apr 2021 02:51:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/4MM/M3xoDcqNkkTejsPtQejHJNxjEDTFCryKEZjnHU=;
 b=t8qEzclAouSPUvl/uTkpt4Yirv953J8jZxrGY7NUxfh40czJRQBT8sz6Y05xx1qXxEWg
 lDuIrOYNZCnJEaEGQpp7qIW8ljKvUsIz49vdW5gDaI+iEEKNEHt00TXmLMsJtFZK+8Fa
 +wJAcrvIQgalCbBuG1bLtkhjBFrNjWvTam+UFyNGhrVn7CboQzej+kgl2HGcOGQ2ccGY
 UGSJNPvFggNldaj8NohrhcS+Ht5Vb7k2dnF+iM9NBIfNc9xSfoeRInywUOQ/xvGpZxwE
 lTePEmJXFXq0BtRb6OvjOFcgT0tfmBbNz++jVFq1SfhrvhA8Lkof5zvffXJrHVDVul5+ IA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37u4nnqp1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2oWJQ160451;
        Fri, 16 Apr 2021 02:51:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3030.oracle.com with ESMTP id 37uny1xe80-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DD5BcmFwe7e0Um7uxf9A48lhp/APZJm1P3ituYxdTVec/98NGIrQq1j5LrzhCJlu5/7PFau3n42JD66ErkKFH8AKeaFeIXkYE+lcIZfmgIKfHN72a7wV6X372AvPji8RREDi9k3ZUPLdnWg9E+bMvObHgItqMXtxAVPWRqkXocFYyc7cfOstpie+cMHcNnR6nfK7KhVwYkPg5hiXW2OXL6sIk+VEFTwN9p/M3jXdXUTfAGLjybM64yrmGh1ZAlCaOOLH5lAdDNju0WDc407C05ezhHoPs8BK4/GBFENw1WeHUtKvzM20q/7sYrKz+kZxu/7uNbScttNPYv9cw/6UyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4MM/M3xoDcqNkkTejsPtQejHJNxjEDTFCryKEZjnHU=;
 b=OgC9hOVKyLhOWr4juxhwCRR45eUH0zeB9FNL5lha/hWjga3zAjj2MkhvPFahWEISyTCGfMLuGMq6jlFehb9CFNXNcWqQLY1g6gcAcjruAVoD8A+OE1BiucpA/m0S9idRGFY7wTpKVSs5i9bgL2G5nM7oDBn1F188gPZAuQUpWYNmpPPFXf9Bqx+KabhBWNYQ5/mqqshtjs38JQgnY2W9Bniu5VEG0QuBNuJHwXQaBkt7zUwSWQFMqAopKWBgGar50v4H52eQanLROuJVgoQczqhq8Irf3/V4kru0n6FPQDsbqhLuNHF4HbBaSjNZClVC+bGAv++F9K2ZG28+tTB7fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4MM/M3xoDcqNkkTejsPtQejHJNxjEDTFCryKEZjnHU=;
 b=dmrk7ACvB0hqP7NNrIQ9w5LKBsA+lUbJM98/O4DIRjzUXWH6XV5fDziQOJeur0nRHnZhNCJcxqWpZtCTEK5HkCq//QgrI3RAASu7jG3ePDLHoA3sr+tp6gIYlbf3aMtkFtcTSqMde6DnTiSvstrJmgaFPoW/8fHeECzFcJrAyrc=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5466.namprd10.prod.outlook.com (2603:10b6:510:e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 02:51:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:51:40 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufshcd-pltfrm: fix deferred probing
Date:   Thu, 15 Apr 2021 22:51:18 -0400
Message-Id: <161853823944.16006.3850189187105087960.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <420364ca-614a-45e3-4e35-0e0653c7bc53@omprussia.ru>
References: <420364ca-614a-45e3-4e35-0e0653c7bc53@omprussia.ru>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:6e::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0023.namprd11.prod.outlook.com (2603:10b6:806:6e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:51:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a717ffc-b362-49e2-2b60-08d900828f5d
X-MS-TrafficTypeDiagnostic: PH0PR10MB5466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54668465F90ED2A7FE20D7F58E4C9@PH0PR10MB5466.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z626zUAH8bvAqzpxmOyligw4zk8xTXoc9LP5W/mCvJFah7qFoT8ArGRAIvwuXWHRMrOzBx5khmp0WkyNhdAqYlS29Q0zzBDltptJz28sxbtf6NKblZ8OQrEu8uUmHXrmtcvYhIDyI2NYEj7T81ThgxZp0leAuA43uuRpIwPs6IqEHoaHqaUJf99mWWj8Jk6pFylShS3xDDcTy9HGUyycFq3YoqqnobyBx40J1GZUGU7MIznRE/L4aFKU9Pg2LtdU1ZlahTBjHEhcD5gbnZitLq5fZYUnhdADqmJzkqZ+4ylcJVxblhzAi6QHcN98ZpcmfbW0XrgTv3GrXngZT7zyOzeD6stKPl1t4jEM7+jOcZd+0iKyitq2HZqGWJukwF2hsjrRSqzffKspLMhJdVPpWEnYtA/HLR0k5holjvi5e0iz+ZDjake1I9gjbEgoXalcsw3ALF6SmY9pRn3LYueJSh26/kRmUINX9AF0sNZgMXA6BOWdwXuxRbERNSAYmHgLOOP8spXIfeUg2v7iy23VdaVMpenHFk7D1qkOj4PqSLENB9tDRE8HDgiDpZFS1ZMbJJQXtF+PXkEwRqnY12RFEpmYpUS9BmcsGcp0zJlaOomH/KNhXRUAiHhdCboVtWoo0aimFS/ywBjH/ZzAoRySst5d4WZXRBYCFo0NmboEoHF4HKK1iPLojRr6KzbNP98n9SREIahBX17KNKOz/MQ/Q4BsiSepC+v+WOxhpZVA1BM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(346002)(136003)(7696005)(2906002)(36756003)(956004)(4326008)(6486002)(6666004)(5660300002)(2616005)(103116003)(52116002)(966005)(508600001)(107886003)(316002)(83380400001)(66476007)(186003)(110136005)(16526019)(66946007)(4744005)(66556008)(8936002)(38100700002)(8676002)(86362001)(26005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q1A0dnJaZFFDN3RCRlVuYnBJWndFVGRpS2RDUGdWbmdzbUlhbEh5d2JpdnFG?=
 =?utf-8?B?ZW9oQW83bi9EOXo5VGh2alFRS2hqZGl3VlZCZ2JwNkVyWGg5NERiYU5oNGV5?=
 =?utf-8?B?eXkrV3JXNFhkZFFkZkx3NWw2NkNORnJsMkJBbVgvemFvclZPN2FqR1N6dWFo?=
 =?utf-8?B?OW5jcXlidHg5R1M5bFF0YjQ2WUljZUhuZmZMaUxjaVdGUEJua2VSN3ZWaFVB?=
 =?utf-8?B?N1dPVmZTdnhLcHRndnJiOFE3K1kwU2JwSjNIanBoai9LZ1FGZm5WU1VWYVhH?=
 =?utf-8?B?dmFvRXJjd3pTOWxGYmlnZGwxRlpBQUhQL2MvbUQ5aDQyKythQWFHSmRmRmwr?=
 =?utf-8?B?aWFONUNuOUVMU1VFTnNEaXRJRCtZNjVxNWJlMmJrOGhEZDlqSllRV2FEWXRU?=
 =?utf-8?B?ekkxTEJoOFk0YlhPcWU2VjNBTHNhMWxtWVB1MWVYUGtCL0Iwa2UzZy9hOVQ3?=
 =?utf-8?B?dHZSSXRNVHRlK0tjazJzYVE4NW5CaDNaNnRNSkpHKzlVQ0ppb3NFMWRwVnd0?=
 =?utf-8?B?MEJ1dUprNkZISWc4dmZpbUtISWhGUGtRQnlJd1FBUGlRRGpUdVZjSzk2bW84?=
 =?utf-8?B?K3dPcmsxMTJHQmxuRzRqSVlGcllRYll6OGYxSGRQNU55VHpNUytqSnhlZTFW?=
 =?utf-8?B?NEUvTXBnQ0o4czF0Y05sRTdCSlFnRENpa2hCYkk3V001WkVsbER1eC83dEVI?=
 =?utf-8?B?cVN4ZVkwNUZFVVJZU1loU3kyNTltZWZWM2Z0dEEzODZTVkpNeXVVQkV3NFRQ?=
 =?utf-8?B?OXZselI0dkF4RnhEMVJOZUpqemwvMGk3V3o5VnpCWlZ6MjFJN3g2ZklVZDI4?=
 =?utf-8?B?Q3JhZ1hYNTJ4OTRqTEJRb3hGcnNQNStjTnhlem9xWW9EOG9LUHVBS3JuZGhG?=
 =?utf-8?B?QndaSk0rbHQ0cWwvTmVHcVhkdDZndnRNZmltNXJRN3RsWTV2YjZZbThKQWh5?=
 =?utf-8?B?WFdCS3ZhTlhwc0hacWpLR1REbDBJQ1VseUx6UXF3YkhEMCtRM3hVeVpFcUpF?=
 =?utf-8?B?Nm9rVkRCUElRbDdoNUFORjV4Z0JnRE84anlrOXNlaW5DOXU2RzJHS3RMZjI3?=
 =?utf-8?B?OXg4cm5sczBiWVozeXJuTGlTaHA0QTg2WjRvbDBTMXFFbG54WkpMNlY1NGQw?=
 =?utf-8?B?bTQyUC9NVzdOZzlGRCsrbVBkN1VESDFZcmFhS2w2SkZHSzJHVVJKVno2TnZm?=
 =?utf-8?B?dEcxQkJUdU43TEtTalJCSTkvbVc2dXhmYjZrdmlTa0FaeUpvVWV0WDk3MUE3?=
 =?utf-8?B?WHJwL05WVTR0ZmQxRkxtRG1KcHVramFZbnpPYklXWWtJR3FKWGlRUFEycUZY?=
 =?utf-8?B?aHlPQkdtY2pseWpZRjNTZkV4MktBMXJFWkJTZWllWTREQSs2Z2UySU9iOHU3?=
 =?utf-8?B?U1paT0g2cm5oSnlPcCtKLzdTQkVwWGp5WXdqYk5nZVdkVEVqeFJEenQ1emMx?=
 =?utf-8?B?dWZNQ0x3R3M5M3ArOHlMS1NTdXNMWFZPMkV4MlJiclJTOEQ0V1hZVFZnY0dt?=
 =?utf-8?B?TjdiT3RnZE4rR3ZYWXNOOGdoRnNXZ29PaXluWG9ndzNHSTBKTHB0UmhQUEVa?=
 =?utf-8?B?WFExbUlnTU1MY1RacVdEVUN6V0cwbXlhVm9uaWUrLzBWdzFoYSs0V0JPZXI0?=
 =?utf-8?B?YXhZZ3g0SHNxYi9rS2VFL0NadWlZL3lwemtUQmlNMHJIemxSeTRoeVlmYjhv?=
 =?utf-8?B?eFEyUDQ2N2pnT3Aycm5namR3eG02Mms4MFhFeENiT2ZMdVFrT2lSQU8wdEJz?=
 =?utf-8?Q?UIRqd4RRy1JZ33UNs0Bzx3yW8RO7xczkr7QVurx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a717ffc-b362-49e2-2b60-08d900828f5d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:51:40.2394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F9M9RYLkoNZICNi58KOiefPiurNUF84eyLSoWwt7bcn2XnnCuyXAzJZAa3rXxVLv1lpTPlynACkg5KhyVxF/9lIuSt0iMDyqYq+U9LbcjxY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5466
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160022
X-Proofpoint-ORIG-GUID: UIZUPi_n_fmuOuYzwiHrUuyy9mnEO5v3
X-Proofpoint-GUID: UIZUPi_n_fmuOuYzwiHrUuyy9mnEO5v3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 29 Mar 2021 23:50:58 +0300, Sergey Shtylyov wrote:

> The driver overrides the error codes returned by platform_get_irq() to
> -ENODEV, so if it returns -EPROBE_DEFER, the driver would fail the probe
> permanently instead of the deferred probing.  Propagate the error code
> upstream, as it should have been done from the start...

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: ufshcd-pltfrm: fix deferred probing
      https://git.kernel.org/mkp/scsi/c/339c9b63cc7c

-- 
Martin K. Petersen	Oracle Linux Engineering
