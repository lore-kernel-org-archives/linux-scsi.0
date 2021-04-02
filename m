Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC659C43461
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9910E610E7
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbhDBDyh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 23:54:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58358 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbhDBDyg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 23:54:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323r2OG179265;
        Fri, 2 Apr 2021 03:54:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=+uruwojBKdzyITX6opzA8PCH3VH2SUOHWbnDHbQ9mIk=;
 b=Kmjw2y6SRbf1d710ZvbFaJFsSujmYM/VNVXdOlQWBfKp6EGM3gfO9ctzfyLPyZF4U/XK
 uD8HLW59D6crGzBnOT4yQv4MKw67wVzKX0jrbFmT9tGUpnv/Q2EYNk0R3dwRmWxYTJ5l
 36UmgtTmOoPUv4b9TiKs7mhM5ExwCv/mKDqeEtOhZRx03oxNx/ISZgZourD4RvQjEj8X
 8Lt9WMNO3AqlSoKjufgVhEEChGDdkseKGSBztjBWh/Zrbd7zJAbFSDUSQm/Wo2ywDC84
 sg5TzJaII5jB41Rq4OetnEz5aEPfxGV48Ycu0e4AlhndJrt2Im/liPyqDxBiy+4Js11T cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37n30sbm7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323pdIq101592;
        Fri, 2 Apr 2021 03:54:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3030.oracle.com with ESMTP id 37n2atmxdq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFOlDsyxq2TPKkuJF/fczJDANZfuhcp9bkYT2qZ+skd76z6DAr52/n3d0n9IHdltCCFd0MZMVPd3kXHJ1d5bq4xhM7fFctf3rgiS862OCK7u8qaGRmzgJiV08pNm7LMAOfJRvlrZOILfVjCajux2Hf0ngeq9i9mUeSNBHKUrxrjUP9rcC+peedorTO8MJ+6YE8m7bEwmGTMSdkQzaK40sbvtKrESfRdG6O5jWrZxaj1v9MnXN/iWMrQ9C77NTM1I5gv9460tqfApBWuWctlBEXKOw24HnNQYgRu/4mfi8GQMQYh+sFiB26ibSD1JJRgDEmRCl4AdpfE4Erg/jeBu7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+uruwojBKdzyITX6opzA8PCH3VH2SUOHWbnDHbQ9mIk=;
 b=UAkyliuft7EVrYzRHWSlV9lVZP8qCSFQMpmLLbCeZTe9jmJWCJ9kSElt/zmNawFU30Bo8kHT4jD0/CsDvHPrtwyTdwpj8ZF80YcYMM6heYNHZep4SADDjUzVOI91xNUdP+d9jpqzajUxRtcUoiJpfLt3FzOJId9+Omjx94c2kRsnnDUJ/vN9kRTH2braSb7v5tSnDYt5rkw8suabGGzAvq240vNxb/ddhjGyFTBpXx0xR9+fIr1aWKrCMwPIesFhj7kAknXKm4aCPcF6TwEPQA8SoWk1Tuj/z2XlWGl4cxDuLkj3f8sXRWBw82ks0sn4KymBUw8/vaMmhBlh7gV3pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+uruwojBKdzyITX6opzA8PCH3VH2SUOHWbnDHbQ9mIk=;
 b=JXZWRZLOfCx8seqVp2sfW4EGKgn2KnH0F5RVN3G78nNJ4MPiYQr2oxRcuIjZTN3qEuu/03x2cypKoTCWx4ZjBjCWVzG6v55aeGn2fFgjMfDVeD/d5LYpbsYTx8/1+Mx4PY6638bRHMnWbFjMft51rB2jYnhppCRKo6Zn0zI0qqg=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4711.namprd10.prod.outlook.com (2603:10b6:510:3c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 2 Apr
 2021 03:54:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 03:54:26 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Nilesh Javali <njavali@marvell.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        Manish Rangankar <mrangankar@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qedi: emove redundant assignment to variable err
Date:   Thu,  1 Apr 2021 23:54:14 -0400
Message-Id: <161733541351.7418.462773833395989932.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210327230650.25803-1-colin.king@canonical.com>
References: <20210327230650.25803-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:806:a7::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR10CA0007.namprd10.prod.outlook.com (2603:10b6:806:a7::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Fri, 2 Apr 2021 03:54:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f09aece5-0af1-4bf2-0f0c-08d8f58b02ad
X-MS-TrafficTypeDiagnostic: PH0PR10MB4711:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4711877D24EF8E50C508868E8E7A9@PH0PR10MB4711.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kqVm6SKOLJS9J972ewtrbynfULli+L3AM6L442HCi5ZY/uAy6ZTBju1I7Jyc9jBOT+DFcRdAW11a6IE3kklByAAjuR8jLQ0XryNmN45H+1ZD7NwWZmdMT9mWu8wBHCHnMAF2D+Uo0S8wLVHwnyKX6RSJHzWaRE3SYRFRo25s+lrB4wmwDDL7bXWgq97sd0d4nqX56NRlnAlXZOIB1sR3jX/929/4BDi6F31cZLtiELO7xj/EFGQivAvqpOu+rHmQk/j1iiLrAE1rKzEBjiawpnnmMZdXGeCD1iocwS54tXWxjczZUjZCWQpdGyvTJtsW0F9oyN7LynQwcwVkzukSkdBJAyY+kAOu+tTzKQLosny0gCvyMGlViREPcdfuT2nIOTt0njhHj5cx5o2rCvWN1Oxgu0eLPQGnqpT4x6/zoeSSP8h5Ddqiaba2Um5bYdx32eTQB84opafxrDAAtbPj7pk6Ly+HCS3UQbsteD0q9lDSApmKx1ZYEJAZqO80O9EE18+YgQL7UloLPtlHSd8HkzPyj8sCYv9IdOxGTaq8cB/FhSBgaQHfWyw9KQSwClR54eok0roz8EAGA5GNKDpo6kCgGezE83HfgqhNLAPz/EzqccZ6y3MGn4Xr15S13IgUQJ/7oOD4gJ4U4C0DS9wZxw/86Zs0GdOpYypqVt8NXD/TqyJ8T5DDBlsfsclSlibacYW7BLciFEFjbHtWdmL20YzBdXYbXnT1Fx6yQZ8+/GI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(376002)(136003)(38100700001)(4326008)(316002)(5660300002)(478600001)(966005)(86362001)(66946007)(66556008)(66476007)(186003)(956004)(110136005)(103116003)(8676002)(6666004)(8936002)(6486002)(36756003)(2906002)(4744005)(7696005)(52116002)(83380400001)(2616005)(16526019)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MW5xK0NNSjNrSGRTSU9Va1MxUnFwd1lBbFB5VjhvMjVPaENkS21OWFIvaEZV?=
 =?utf-8?B?aGwzMWtBQVpyZGZHT3hWZHliTTY5MFhhSFpvL1ROVVFFVUpjcjQ4L01hRW1q?=
 =?utf-8?B?RjZUWi9ySktZRk02SFpSZExDcHlHTHRWcFRZeVdXSk52SStZNExraXVGVzJF?=
 =?utf-8?B?b3Q3aU1ZVVVGbVo0UFpQYitTRFRBelhHd0VxTFJRV1hnY1llYzVKclB3aFdr?=
 =?utf-8?B?SWVLQVpqaUdqdmtGMmZKUU5pTk9LWm5zZzRlREE5WURSKzdvSC84MFJOcDQr?=
 =?utf-8?B?TEVEb2V0QjV6a2QvZzlQNU5BTUdWdGZRRjZKc0NPNVUwc21BbGlHdXFmTFZW?=
 =?utf-8?B?UXg1L2FsZmZGOHRwZVJSWm1aOFp4QXBEaElPQ3A3dGxHQS9UNzZFT3RVa3k0?=
 =?utf-8?B?UTZhN2FxTWdmckJ0d0pqWmxpTzQvdmhpWTBCbUpPVlJBN1ZyeVZLZ2hjRklC?=
 =?utf-8?B?UnFxc1l0VkRIcUozQnpWTjVkc2g4bnB1OGsycy8zTExsODZtN3RNMGxqakwx?=
 =?utf-8?B?MWUzMjhIYUZMNG5jOWJNZlcyNDVhTFM2RHREcERwMlRDd1FyZ1d0TEJLWlhu?=
 =?utf-8?B?Ylo5RWgxQ3RHT2FNWW9YeVpVQmxCNHRIbHdrSS91SFFnN2w4Skl0VUdzUHhk?=
 =?utf-8?B?eXVjb1VLQWlSY1h6Vnp2blBOMGhkd3ROQjFhYmV2cTd2QTd2NHBPb2JGS0hO?=
 =?utf-8?B?Qm1QMHN5cW5WK05FWlVIdmc0UHpqdW1QVW9BT2lCMWUvdWtVQkJJOXg1Z1NH?=
 =?utf-8?B?U29XbEFEbnpiMCtWa2FiR05jMXkzOWRaWmhoNW95bnkzdCt0OHhabWtGKytW?=
 =?utf-8?B?M09LT3ZLbmUxQVVjK0Z1Y2Y3NUFYeWpGTTFrbzhsemNmMDFKM1dzdDREOXBa?=
 =?utf-8?B?MWY0enhybWcvWk9ncXhFZmNDOUw3clVVc0QzdmhVMXVTQjFYQmVmeHRhSnVQ?=
 =?utf-8?B?bGpDckM0UlNlQUIrTEp2R2ZaN2tacEFpQ2tYYzFNbWZBRDZUUVhDOWE2WDhX?=
 =?utf-8?B?QVN6YjlacHNNSUVzeEppWkpHYW11cW5ZLzYyaG1WcncxQW9RekhYNDhUUWls?=
 =?utf-8?B?d2JzcnZ2SlVFUDV5YmtLZnVVSHBzYVplV21hVUVDd0Y5SlZUblRSV2JXOFNW?=
 =?utf-8?B?M0xyUHBRNFY2NDRWSXVsSTRLYXd1WVJDd0RnaitUUW1XSWJjQzdKQ0RBRG55?=
 =?utf-8?B?SXJzclVKR2NJM2o5MjdZTGxIVlhZMnNsSzMvN2ZqZURYU2xGUzJtQkJRUVdr?=
 =?utf-8?B?ZklYNmRNWXFiR0FaYkJMV0pHU29JVGM2S01mMldLQnlaYWQ5OERScFlVQTJG?=
 =?utf-8?B?am1RZ0gvZG83L3pCRXNvclpYc1JtWENLZngvTHpyWmNXclNQRDN3TmlreDE2?=
 =?utf-8?B?ZnRieGxnc2ZJeVpjR2FVWktEOHZtQ09HQnJHTnF4YkRmelYzRmEzYjRYeGMx?=
 =?utf-8?B?MXNudHdudkRDYmJzNTJQVk5hSkNuMzJNRkE2ZXRUSjhrUDJSemQ2TkFubEhC?=
 =?utf-8?B?Y3BrREt1bTU2Vk14TFd0cDA3NXFSTlEzNFo4eVdhUGlaMU5lY01DVXRnbGky?=
 =?utf-8?B?djlESTJrekhkRWdXWE5mRm5mRERldFBObUxxd2xYc3c4QTk3ckdSa2FzT21p?=
 =?utf-8?B?ZVNNNFM5K3Z4YjNVWXoyZ0swdE4vMmpVWStOVzRjQmR4NXRSNlAyb3N5d3Qx?=
 =?utf-8?B?ckE2TGx2STBqMGE0Q3p3OGNwMzdOb1dRSnVBYkxoYUxQVTYzVDVFaCt3N3FJ?=
 =?utf-8?Q?nC5rg3bng1f4t3Rrd2h93v5WujqK1FJ4mXMA4uV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f09aece5-0af1-4bf2-0f0c-08d8f58b02ad
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 03:54:26.8563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AKLJHedXS+X/Y78jgWMnrIwQRtVgkNw5aQ8Yd61KHFTDweezfPzD6X8wEwHjQZ1cLCM8rHlaI7N+GKY+bcdXTh+QdGvfSSjnXh+iv+hL4XA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4711
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
X-Proofpoint-GUID: 1LJd1IQFj0Hyjys2HKzoqT1dTVdclxog
X-Proofpoint-ORIG-GUID: 1LJd1IQFj0Hyjys2HKzoqT1dTVdclxog
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 spamscore=0
 clxscore=1015 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 27 Mar 2021 23:06:50 +0000, Colin King wrote:

> variable err is assigned -ENOMEM followed by an error return path
> via label err_udev that does not access the variable and returns
> with the -ENOMEM error return code. The assignment to err is
> redundant and can be removed.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: qedi: emove redundant assignment to variable err
      https://git.kernel.org/mkp/scsi/c/8dc602529681

-- 
Martin K. Petersen	Oracle Linux Engineering
