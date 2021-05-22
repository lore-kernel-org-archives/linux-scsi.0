Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B5EC4707E
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77AF860E08
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhEVEnJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 00:43:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58052 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhEVEnJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 00:43:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4Zkip056500;
        Sat, 22 May 2021 04:41:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Ld77v9kDwhvIRB3hbjpkCZGzGNGRx68Ux2wBTzmVLgM=;
 b=EB8sz2xWKDuIDlNgxw/o80dexkkq0L1+/s7ju3H2NnIhXBAQgWVxBtio1GZnfc5ml9Or
 W8gTMjZ3PbP47r6TKmbe2M4EU96NMW4LEcdHmhjlTEzwiMlrnSmgxWSYqDw8C0bjVW2Y
 rxuiOX8d5v3uaAIjJJ0J6WDkJwMipk7TKo6DjNwyKoBRb6NnNc4AQ/zwMpyTIytZB1Gz
 nDvhN0Fd5tzOJs5r1cau+G/F6Y7z3zglRoxyE3s5j8g0GOfsVos0ZQtVbt7iPa/AMQ3h
 XFhA7XUo1VQQCK4tqw8i3G6X5BbPH/tCMxjVJ+FW68DkTi/2H/EZLZGvKSDQU0YTNIUJ 4Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38pswn818r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:41:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4Zjik168565;
        Sat, 22 May 2021 04:41:43 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by userp3020.oracle.com with ESMTP id 38ps9j33ty-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:41:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OeBYFlexb4Do+ktATCN/8KyfbCV33KGirivUzV9Gj8+0mXyeydOEBVk+0ZlmebLOLaUV/nE+l+3pCEii8jc8QnckCu7tJnkHQEFi1fzkABZjhxszGjOwcKitxqzUSxjxU2dTMT/WJjv73pynAQ4pJjeGrxv1mIe6FZlFBJ6rupJJKZ+LwKemcyvr6SS3+XDAq1ks8InwTmdmrXnMH0qaofk77kOBUdNNl2BKzLcTdIajE/yLvjQRkogzvfOEgDIwE/he4YQlrUat791RNK6lNPH7Zf4QPzO5W1Zl/tOEI3ntfHkMn04M3dDMKulBuXzdOAcJuj582/NFtkBDEnYUWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ld77v9kDwhvIRB3hbjpkCZGzGNGRx68Ux2wBTzmVLgM=;
 b=Pe3AmbY7eHxF+bu/2FaUOiVZJG3/orScuBmH8KbVv6f3ap+S4MW3eEJkW+bgL8VIIyvQhmW1b3dLLhZQi3THg25evSHEPUQO8kpnzcf2o9lRcxh9/jUe7sqiCIfMnaLzHeteRDBMHQGRjdcQV8I96aMWXOFHmhS1heq9KfbLH5zJzIet0pzs7MXQz5yKYM/Oskto8i9sk52/v837oXJesI4ab0HzNheap0u+9mPMkYW/JQvEd1PhASXIyHJbgGYyydcqQFFNg1xep52yN83afo5o3PWIZk2+/sO3OKHi+KBMYm1yWureNuCu6hiAA1AXgEtUB/0AgL56pIUphb3HQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ld77v9kDwhvIRB3hbjpkCZGzGNGRx68Ux2wBTzmVLgM=;
 b=hv4z62ouUwAFqsqnT5K2jPi46HnEcaOt8lhWLpssNgwTGsgzfp+eyz5WaMM0nG4uI/HMLT6ZpGY2cbi4uEtIXS5RDi/6Hm/R28INuS0zrXExXkMy8ieqBDFHsPSkzhSQxJiD3l0MWcz3Oww4ZtUAQ8rgXmD0p1fO3rkNly4IwSY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5481.namprd10.prod.outlook.com (2603:10b6:510:ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 22 May
 2021 04:41:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 04:41:41 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux@yadro.com
Subject: Re: [PATCH 0/2] scsi: target: Introduce the version descriptors
Date:   Sat, 22 May 2021 00:41:32 -0400
Message-Id: <162165846771.5888.41881242206633196.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210513192804.1252142-1-k.shelekhin@yadro.com>
References: <20210513192804.1252142-1-k.shelekhin@yadro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR11CA0019.namprd11.prod.outlook.com
 (2603:10b6:806:d3::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0019.namprd11.prod.outlook.com (2603:10b6:806:d3::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.33 via Frontend Transport; Sat, 22 May 2021 04:41:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97cdf5c4-5a65-41c0-365d-08d91cdbe4ba
X-MS-TrafficTypeDiagnostic: PH0PR10MB5481:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54819E14AE5F501F2908E91C8E289@PH0PR10MB5481.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J0S+91IJnbPj3+iIY6nH6u/8/fsMlLdkz2peDDu23ZgSNVNM/ecOmkM+3/y5rZB3splrw8tYZgP6iK0dtqklxYhyNCrw6uTS72hOQjwPnewideHJtNrOdM7iCoG6JlGnu8SAkLhF8u0j0lC7FkMRQLomuUokGoD1jhDYUi33WvnNtgjUC4JzF5uXLMQBnERYFkDq9DNhcOxvjAwmr5K33jXt93Szr6YU2GmWtR3XMVK/YIqTc5H8iMxKErpM+f6JO4/EHKsOnJ2W7/4hlN+I8GTpxy2m7z19yw23A5bgEV9/bZBrqujw+QdWGXYDjqVlo+KXM6cXldIVrBpdTVOKJOyBcgqaOKvmF0c3ZTSkA9YOqEapK01QdVZdYXy4CHOnIkuk91nQv0J2Z0m8iXzz7NkvMUA3Dxe1aP11mh76iSwaDLx6UnPJroiyd3VI9fVqJv2UChKdmp4PPt0cTUOjvVibEz25nOCRXgoXH8B6xI03BSiPmFbYCPoletxG/+tATcF03o7OxeMWQkPdyUxbjcJnT4or1KmIm/VpeUFsZR/ZzU7TlezjnXdWlrEZEeg9HsxfAGl/FB9p1MSEy4ZQ43j0yDcUcRIL+VDUa7C4HSNJwz/gA82K4LUNPIX7XSXpj9tsvtVz2lECX4Fr0YzPhmxl+YOsdQnvRM6wfv9BHsrWFZH31+Or8hGPfh47vi+3s0bIjsOnjtJ7tT4Bwh4v7HSAguKeSHeQE/9pUb+UkCGbmnABig9FBluDLWdbt31A61lVHKCx6Q+rF0EqCjIivw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(6486002)(6666004)(52116002)(956004)(4744005)(7696005)(66476007)(16526019)(316002)(186003)(8676002)(38100700002)(38350700002)(66556008)(66946007)(8936002)(110136005)(5660300002)(2906002)(26005)(103116003)(478600001)(966005)(2616005)(86362001)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bFl1OFBZTXpqZUJCTE1QS1lTbkFsTVNHMzNCV3VFUzZJeHE3U0ROV1lHRXYy?=
 =?utf-8?B?WmJKOVFuNXBMMVhOMlFJS0g1c0Q3OTVLNEtEVUlxc3ViVXJtMEZiUjhCeERQ?=
 =?utf-8?B?eFlieFBlbzlSbVVyV3g5SU1KcTJIaE83Qkw4eEM0c3NuRExxUG9VdHJrZisv?=
 =?utf-8?B?dEQ1YmlRQksrRFpGc2lmUWFDQ2wyK1FmOTM1bk5mNzFROE9OZ043MFRZeXFW?=
 =?utf-8?B?Z1JoZUdRNkxidHJ2MEVZRWNlZk82L1dVWVNoM3NrR3NCK25NSWFFV3pqUEhj?=
 =?utf-8?B?WlhvNkhIWFJmUGpMZ3lnaWFuZjZkSjJNZVFMSXVhOGtWM3ZmaWZvaVNUVVdI?=
 =?utf-8?B?VWIzWTFZQ1hyTzNTY2I0RFp0RzkxRzF5SFFLTFh4eCtCU1d4N3BmL2cxL1g1?=
 =?utf-8?B?V1Y1NFRsMEVvWWhBYWkyU05FNlpWTFZuVFVNaFdyMWtuQzZCTDAzd3A4azJP?=
 =?utf-8?B?VFRWb0hURDhTR1FiTGxiWWFvVUxxUjJRVUxYS3lkSUpmWGhzS29hc2w4VnBJ?=
 =?utf-8?B?Ymt0UlZsazJwUjhZNFd0TjR6eTZuNGd2bkNzRUZKb1RVWVgxbzlvWjh2U3Fn?=
 =?utf-8?B?N1lMd25NdHgrWUNEeHFGMXlnLzlINGJYSVNlQjNzazArWFdTSXE5N290OCt4?=
 =?utf-8?B?RXkzdldEUEVEdmM5QXdOcjdQNFo1ZnM1NnF0QmhLdTV5RzlvNmJ1UjVtT2xq?=
 =?utf-8?B?RGZESDVRYmdaTmp6TktQWktURi8ybTV2R085Z1pBUE5Ga0VCY2VheWhNdFBH?=
 =?utf-8?B?bmpiOHFyKy9RV00rMEY5QlFBS2pkOU9WaENOeUUvOElaMzM1a0lYei9lOUZw?=
 =?utf-8?B?Zjc1NHVURTFpTVpIaDRJR1JRZ1hYRmM1cmx3bmhBRytaUzJ4WUlxY01DODFi?=
 =?utf-8?B?L1VMbThVT09JdmwyRTZGL0owckFBWEVWSlZqcEkwOWdEQmhSdC9DUkxPc0pW?=
 =?utf-8?B?T2wvZUsrbzZqejFUOUtvNUtxek1hTUliVWRmNjVESzBzS205MXVkekY1MVlr?=
 =?utf-8?B?emUyeDYvY0ZMMGFWTEl0ZTJKaW5YZGZsdER1Rkc2YktNNWV6bDE1a0tDV3RE?=
 =?utf-8?B?NDEwZE83djkwSDVMekF6Q0tYcnlMUVNENFlaRVU0bEZ0OVJHYTBJdnVJZTZW?=
 =?utf-8?B?SmRybm5Ed3ZsN0N3SGprL0NjM09wUWo3MmFTelNmWXdlaDRhZDl0alpNd2Q1?=
 =?utf-8?B?TWthOGdsSDFKb1Z6T1BHbVNLYVQxS3dDQXQ1Z3dON25YTExobklMT2FBNSt0?=
 =?utf-8?B?bGpUeHYzeWdNbkZSVERHZy9UQ3dnYTZQRi9uc0dYRnB5ZXRBMnFLWXlLWlFk?=
 =?utf-8?B?NFpMQ0sva3lFbVkvVDk3YU9tUzdNK1ZtUTR6SjN0Q05IQTdXK2pTTDkveWgr?=
 =?utf-8?B?QjZBNDBEdmNYUmFiN0hZZEU5cXRIdUlVVEhtY3ovVHhNdTV4djRpVmZya0lw?=
 =?utf-8?B?ZksyOGp2SW1HY3ZwM2JkZTd6MW1Tb0pGMDBjUE56bURJS1lkQWhWZTMvTFlN?=
 =?utf-8?B?K1dTRWpPWkdWVWU2MUYrLzlJL3JETWRmTEpiQmtQeDVaY3VIVEhJQnpxV0h1?=
 =?utf-8?B?S1BpSUdPNHAzRWtXdkRZK3RFQTlxZmRzeE9lUkF6RWc3b1J1TCszOXcrYXlH?=
 =?utf-8?B?bWtPMU9wVVhpNmU2Yk95YkhSMzIvTUZIVXBwZ3JZUktBMlNrck5POFJYMG03?=
 =?utf-8?B?d21TN1hiVkRkWmY5Ykt3UjlEb0loQk1KSGFzL0FPY3FGRWlablphMlUvYUJa?=
 =?utf-8?Q?q9iW0/J6Rzs+hS2DN4hNMSIlEqA0OoGrt5qtWZQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97cdf5c4-5a65-41c0-365d-08d91cdbe4ba
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 04:41:41.2421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HcejPSWC4RvLyIy45fpp7GQ4Fk+LwlsCz34CiZitQdY+7TtIfhEguG95OvCeVYYUcUBlDlcQlV7Dz18OkbY89A6FnK24MyOm62u89kp1Q2Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5481
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=677 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
X-Proofpoint-GUID: 7lUrda-YhhL0RPj1iFp2dR06qYUNh9mq
X-Proofpoint-ORIG-GUID: 7lUrda-YhhL0RPj1iFp2dR06qYUNh9mq
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=856 lowpriorityscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 13 May 2021 22:28:02 +0300, Konstantin Shelekhin wrote:

> This patch series adds the VERSION DESCRIPTOR fields to the standard INQUIRY
> data. The SCSI primary command set standard bumped to SPC-4 for consistency
> since the version descriptor values for SBC-3 and some other standards are not
> defined in SPC-3.
> 
> While not essential for normal operation, the version descriptors values are
> often queried as an additional sanity check. For example, Windows Server
> requires proper SCSI transport protocol standard during the iSCSI qualification
> tests.
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/2] scsi: target: Bump INQUIRY VERSION to SPC-4
      https://git.kernel.org/mkp/scsi/c/64ae33ef7486
[2/2] scsi: target: Add the VERSION DESCRIPTOR fields to the INQUIRY data
      https://git.kernel.org/mkp/scsi/c/b790a56d66ea

-- 
Martin K. Petersen	Oracle Linux Engineering
