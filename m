Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A113C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 03:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 530DC61448
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 03:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236966AbhD2DUO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Apr 2021 23:20:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50234 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236925AbhD2DUL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Apr 2021 23:20:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T3FcIp176089;
        Thu, 29 Apr 2021 03:19:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=AwRUKpGGi68A3VPIgDq5tY0OCnPcpbwiP+L3CKShGE8=;
 b=K9t67b8xzN5a5lHkbqyatB73Yaqt/TOLqlbCfiNrk4NcPdn/SBGa37vVhr8+hQx6hfZP
 7CQY0N0o8Bndw0PO8jAOm4Pr6U6xamE9i2SDC4aIUW9p54I5wyBtHRrMbYu1w7+Mv+SY
 6H6P9i4qY3LQJQayDBNaK8+ujwn69VOyuNbaubrHTY7bivd/0aPe8NysHxgynHyejE58
 wysaS3TA8TzFd1Vsspp2WsRFjNMqlg7K64y1D/0TgNwPCmjvZVb/a1lTI2+mhX/Mj1Br
 emdeiJ59u0JQRtCC4NuNBpCiu6/FPzKkj9oNIH2FNtk8tdT/evSafIpU2pYrjtdoUmta mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 385aeq2w3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 03:19:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T3Ecsb018855;
        Thu, 29 Apr 2021 03:19:03 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by userp3020.oracle.com with ESMTP id 384w3vkmeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 03:19:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=agOQzDgvTTA1Vlo+N/HIJ8u1scGGotpsm3oC3NQC8FIFZiIALT4K3xAZ1jSjvAuMs3077G1PyMUJ81OpKNY9MLmjRxJLXcwTNQAHhjVX3rAW7JnUabG/JCg4JcHrMazeDTPgwz3IDS0GcCJ8agP9R8QbbjNw1Y1FgR0o2I51JVAkOmRKD64b9FvDQMrCRaHWtvAW2MJj6fyZABrInWwIWZntQS1APEESr3tKNljC178s1DL1iv0gcenW2Fz1eX9FAdVc5NJvhBCmSr7/QDsQOy9GUF4EHj0WYmXd2HWVBNvGOQLqQor/SwAJmPDRnCqy5ZmcC8Iasqrd2AG1xRcd1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwRUKpGGi68A3VPIgDq5tY0OCnPcpbwiP+L3CKShGE8=;
 b=NVYxoaZhYeNglQ5w/nK3ND0dGlUjH520LCdAUZ/ygfKfLLqqfZE1oD9los9mZcsILokunNWNnwG7FmMvxXeF4UvP6+Ug0qfHngIF8pDVKZLnrJZ6V1n0n8J9sCDh6oOpGvyKKN8BAFd/3Wlxg+zLkuBSoBoGkLdRJRcR8YEt9czoLDxLOOgff2Ku9sxWQbKNyq9n4hyEw9wzS0/UOEztuo77a5ncRgNKn5ozHUd0hZZAYkKsdbJnQqbA+exvJ7BzS6Q0fDCSqJLqJwhRjrKasCBoVY34A1xIt69ClqCpyH11mVm1YgWddD0EcShPlzv/hX4TrCKPwNXJWglrGyQ2Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwRUKpGGi68A3VPIgDq5tY0OCnPcpbwiP+L3CKShGE8=;
 b=lpKRw3ILzztN2AtBPQAI1DwpxOnG1NU9yxKUl8IjaK44p8BWIt69rDh5INhjInmRcCG9tT6l05RKlptGYNOEICZs19Bax1+w5fXKvve/6Odd+WoZeG3bCaezBNZHp8j+xREkMmn/lNpOpUdh4n7lAqgXYuD210zr8h0mvCJfQPo=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4486.namprd10.prod.outlook.com (2603:10b6:510:42::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Thu, 29 Apr
 2021 03:18:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4087.025; Thu, 29 Apr 2021
 03:18:59 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        loberman@redhat.com
Subject: Re: [PATCH 1/1] qla2xxx: Add marginal path support
Date:   Wed, 28 Apr 2021 23:18:50 -0400
Message-Id: <161966630052.16262.5218976136955589284.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210427050914.7270-1-njavali@marvell.com>
References: <20210427050914.7270-1-njavali@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR01CA0006.prod.exchangelabs.com (2603:10b6:805:b6::19)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR01CA0006.prod.exchangelabs.com (2603:10b6:805:b6::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Thu, 29 Apr 2021 03:18:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4ae387d-8110-4379-598d-08d90abd8785
X-MS-TrafficTypeDiagnostic: PH0PR10MB4486:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4486675B9E52F6ED6D04A3F98E5F9@PH0PR10MB4486.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qgds/oMX0srfco35DZjn8y3voijScOCuc5kA4obL5BrhZvuOc7svwRhgFjyWvaB73je1gSqysqIwgBOmSxyNgwBmRxw5EvxNY6BKiYE4qPX3APBhsJftm9AjqoeLX6htFPJTH5JaHlb1ZjxJ3fIgzyyVUEMXIhYGfrJ9pgE5PGbonO71kteAe1C4PGLh4nNCSQInQyj4cD6ULGsaZJ0CrszcgZJ81GrecaodNSklTULTl77LAsMMr9Gy5QYOsQ/vrfawQH2TxApinEDONGb0I7STvcyJfV45406zr3hTsCRlocXEJfqc56yF/S8c5UbFAaKtcKTBHOM06NJdjXTJoz+1FQm6YAjFzMsdRtu2M4ew3BqGU+4NzZ1AjqczMgt7uVzLhnqTko3wQXfYGRCFUToqJYzaECDQF1/HBT9d6YinUpmO49sUzCJUNQH2Z3WLM5VCbpCUgS2BM0DKFaCBSwAo2fXzngc5ckd5ykr7whphAygpGBh9nposeID+RxX+iO3e9EdzJx6HaIUeqTYJFxrmXt0chx3jUo1tTUBFY4cXKwdI/l49b1Mt5Pm8B9tfgynzYk9ruZGN0JOcBkfpHcU/8RBBfWDFlt8HjZKoOlOg0aG+fK73WfA1yA0dX6elfvy5tXNeG5PWYLrMxxv6Td860/U+jRwxIVTHvwMqJ+JG6wweJ+focsHBP78UiX69j2Zhe3x5gbT77Xnvx1fQ8IPcOA0bEqyEoGuemRxqkwI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(136003)(396003)(5660300002)(478600001)(186003)(38350700002)(16526019)(26005)(6666004)(38100700002)(52116002)(7696005)(966005)(8676002)(36756003)(2616005)(66556008)(4326008)(6916009)(103116003)(66476007)(6486002)(66946007)(316002)(86362001)(4744005)(956004)(2906002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TGlZbzdQUkVLUG1ZQTRZOURYKzFHUDBtQm9CRFpUM0JnTHY4Y1pZaVpxcHMx?=
 =?utf-8?B?cGQ5L0FTVlhuUUxscTdPajRud01Tb0ZzeWZialR5cEZ1YmF1S1lGbm94WEhJ?=
 =?utf-8?B?SWt4d3BlNm94aENSQmE0RzlTcXo3NTh3UDVKR2lTYm9KSjNCWmJBTU9XMkJm?=
 =?utf-8?B?U3pZa0M4SzlvcnZjbUJsZmJLaU9QNC9aSjNKUDdBakFoa2pUaHNBS1Nhblk2?=
 =?utf-8?B?WWl2cGxRU2hJcmxpK0Q5MnNYdmVIMUQ3OWs3YlNKR29OUjFCbW52VlY2WDVY?=
 =?utf-8?B?Snd5MW5OcS9nWFdSMXdZSG90aklUWHpBNEZrNnJMS3p6YWlBR0lVaVdFTVlS?=
 =?utf-8?B?Q0FHakZwaStoSU5YR1ByUjFWZFNrMk5vek9CdnZrTUNRWU5wcFhJSUNsRzlS?=
 =?utf-8?B?Umo2RVFRdjQ1cld4VG5GQUhsa3RScjNCeXk4ZmN3Y0xvc21XRnMvTklVbHAv?=
 =?utf-8?B?aE1lVkZrNXpDUkFDaHZvQlhINW5LTWlqZGVJUms1YTRMNzdrbDFxVThaT1pk?=
 =?utf-8?B?N24waEUzbWtHY3k4TFRVcUJIRHp0aURJMEFjQ3RCVDJ2Z3B6aldTRFFud3Fn?=
 =?utf-8?B?TFMwWG9zbzNSYmpqZXJ4dGRuNmE4MThhUG9RaTJtUXp3ZkNXQU5GRnpXY2tB?=
 =?utf-8?B?aE9xTFhRRUEvU2M4UXZiTkpIUG10SW8xWVJ3emlaUWl3ZjJuVlhFZkc4NGMr?=
 =?utf-8?B?WUtxaEo2WUFuZS91cEF6enJNU3FmZ0tHNXV1N1RzUTVoZ0pya1E2QXdmN1F4?=
 =?utf-8?B?OHhlM0ZScjgySGg5c3BFVytLT1gwcHFLeGNYQSs3ZWhyRWVNdlhZN0djTC8z?=
 =?utf-8?B?dWJOKy9FZmVsM0hIUGJhTEZnNDlMMzh6Q0NhNFY5aWNjeVdHWFFGcDhaY0Er?=
 =?utf-8?B?N2V6Q0V4SWxoWkF3QlU0cVR0alA3WjFvUUlYN2FNOTFHMDFqT25lQXRDcDdQ?=
 =?utf-8?B?NWhYR3ZyL0xRTVljK1M4M0hLRnZYcHcyYnpMa0o5RTdodjZkeG1vTC9qVVJF?=
 =?utf-8?B?MjRWSVlRRzBURG9XWUNCTklkQnlPanpxaHo2RS9JdzNqTFVINmxZUnQwcWFB?=
 =?utf-8?B?VHhUai9CNFZlQVBZZTIyY0VQRUtSVmU2TEdhRGZkWWhoMVh2SzAwQVNjekNL?=
 =?utf-8?B?LzAvZFFlQmMxdXZuRHY3WVA1VDVxSVJ3L1l6RSsyd2IyNzgrbUpQZzMzT0tW?=
 =?utf-8?B?bUV1M0FlZVpqR3FjY3YzcnZCTDJTZmlUbHBKMFRha3lwZERySFFNZlIya2FK?=
 =?utf-8?B?RWhBdUpMVDJMQ0dmVUV1SHU5RGdjRi9yL1ZhbEtiVWk5TVl4UEtiekZCOXJC?=
 =?utf-8?B?R3hia21WNEVad1VmcjBkekt3SGltTndnTGVkdXJMQWJtSnZzWDdJbTl6S2J0?=
 =?utf-8?B?czQzUkd2QUNLUVlRK3FGS1BrMGFYUWtkRkpsRERVR2N5Q0NkMDlGenVxUFM4?=
 =?utf-8?B?Zmh5WDFQOHRmZW5xZTBSM1F1SkFBWFFCWkp0M2k1VUJJQU9NN0h1anI0WnY3?=
 =?utf-8?B?ekMvdGxsSkluOGw5Mlk5clF4U1RVMnFiM0cxOXJHWUZ5cEljNHh3Z3JRWWRF?=
 =?utf-8?B?NGpSaWplL2diSEk0K1M3TVpBNGdqZDBNTEo2VUJiYVpUdmgzOUpGNDhmVTBo?=
 =?utf-8?B?Q01NN2lIRzZKZW55Vkpkb0s2eFNFV0VWdUlWbHpCM1JRVzZDa01RUVNZVWd1?=
 =?utf-8?B?MFpHdEFLQTZqYXRZV050NDdoSldLcjBmcUVVTXp0WFk5MWdIb3dvZEgvWjFi?=
 =?utf-8?Q?//496ViBfCw+fRU/NvKR6ZY3Hr0ZUIOW8lwrg2L?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4ae387d-8110-4379-598d-08d90abd8785
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 03:18:59.0188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0LPlCX9O0PKhuoj3ICaerBZoTRP8qjJZIEwn7NBWc+a2WFfL4zszkARgY20/YjjqUaIw8N/7TxokGN9nuztttKmenMAgHdFBsvk20yBmoz8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4486
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=967 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290024
X-Proofpoint-ORIG-GUID: 0rCltJeFXEto53U2wlyUY2aP3awLtlW2
X-Proofpoint-GUID: 0rCltJeFXEto53U2wlyUY2aP3awLtlW2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104290024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 26 Apr 2021 22:09:14 -0700, Nilesh Javali wrote:

> Added support for eh_should_retry_cmd callback in qla2xxx host template.

Applied to 5.13/scsi-fixes, thanks!

[1/1] qla2xxx: Add marginal path support
      https://git.kernel.org/mkp/scsi/c/000e68faefe6

-- 
Martin K. Petersen	Oracle Linux Engineering
