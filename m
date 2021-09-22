Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3815C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B248611B0
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhIVEqm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:46:42 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4610 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231588AbhIVEqi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:46:38 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M1nCZY013119;
        Wed, 22 Sep 2021 04:45:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=NLyAefq2lFXIvTtu1xKRVItc0dPJfwGAo6eBoDLOPOU=;
 b=ajErofY4APw5alRJPWf0nI3Cy8aZmF3QdcTUXjfxEt0O+w0d96/tc7f1YWUDhq1o2yyl
 QfK3NH3//nUnmz1ewF4QhOCwLU1ahMIUABSPg/zrSM6vjWqUpz3xG1Kf73phPbNDHYLd
 QkfM08yz7poIS4Cv1RhOvGbiS1/265QIQ36w3o8PWmFMnQBGqZXS9XFFRuvrIY2rWHcb
 fARu4OpJENq/YtBeGzRxGyVw/t3rqgOmw9hYJfWz/sW3Yj4Vn4NuAfMHQfKiSQFknyC9
 nCcdC/BwYjwiqLeMDqS91denDdB3kvx920y7EkFWhhcvlRe2H+x8N6qXXoh4CsfDv+M/ bA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4qhc6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4ZZLl145589;
        Wed, 22 Sep 2021 04:45:05 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3030.oracle.com with ESMTP id 3b7q5mc79u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwE+42WxWE+3gdmlS8F1kFlWlcfDGrcM+UxMTTUoU3UCR8LewbnX580Z5+oIVCVSppot34lAWytNVZANWMA3zq+B/EWPbrpnPalODmpoMJub6h7kGcAKRFh3X/rt7/uXfLOmN+atwMu6TB7RGJsz/j1kyIGAPD+5F5E6ahwnvhTTCyXI7vPfU3TElcx/y/jnI9rChbBqsQge7uHo/UWkTno4gstsh9k/eD6snr2yhTHY7Yk+MSutJdykZRcKLpuF+cZERVqjOgBqtRyd1fQri3Rd37WY56SbY6bRCNL6uV9E0X/UEtLTppFRSuaFx4Ab8I1S5vsGlPG/Sp7+7TvueA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=NLyAefq2lFXIvTtu1xKRVItc0dPJfwGAo6eBoDLOPOU=;
 b=KLhNMd0etfGHbdOJatR7Gz3Z3sg47xuQ2/7FI+cind3lLqh/cv36Ez6F1ijOO77rYwMKkc3isvGz3BfqXsVjde51VKd93q/+ujHSY0fP5VwVCUwPZJlDAsJ9HTHHR8gohhmGWx/158h3/hOmazEl7IJrJbV2aej0kW54SowXpM+WyvQlnUmfF64zVsmROOXkfPPlV/hKoqnQgYqIS+4O5BdZwLEtY9km+MfqUgyOJQhGRsbHAlD6TL4ReOyj7zzyxuJXblBDu8IEIVKYAIDyXoKKFBfC4AtjSkBsCQ9gWVzu1k53Fehk+QbDW9OVJRJgG3QJg2fv5T3q1Sd12z6Aeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLyAefq2lFXIvTtu1xKRVItc0dPJfwGAo6eBoDLOPOU=;
 b=v10dqT1xc5jF0vIHDgcrcJ1awtwmqF7+wg8XlDuaFL7cZU4EidfyIahZ7xMbtyizjssaY/6PNyQDT3GEWqgDOClPiWUa+tUkUUf11GNjgCzxEhmOZ0jlrupFzNt3R3VGmZWmzYHHF/Ic6HC1xGwOshKf9pGw0KXludTdhhd0nqo=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4518.namprd10.prod.outlook.com (2603:10b6:510:38::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 04:45:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:45:03 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <james.smart@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: use correct scnprintf() limit
Date:   Wed, 22 Sep 2021 00:44:50 -0400
Message-Id: <163228551953.26896.1855242913010334315.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210916132331.GE25094@kili>
References: <20210916132331.GE25094@kili>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0050.namprd13.prod.outlook.com
 (2603:10b6:806:22::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR13CA0050.namprd13.prod.outlook.com (2603:10b6:806:22::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.7 via Frontend Transport; Wed, 22 Sep 2021 04:45:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6faad65e-442b-426a-eff5-08d97d83be0a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4518798CDDC2D5A4BBBD50F98EA29@PH0PR10MB4518.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0/G2Ea9oFe/aK9EpHCMrCwmWyQyrGsLkj4pKK+Iaa9hI78chrUlH2uJYQ8JqloR6ULsVUQS9tduAhF5GOBDRwR0ZXCR4bvvtWuFXsdhfOK46GIDfmmXk4OzrCRmbTxvNAn5/xyaDG4xw4YJO9a40ZCMT/3pcrKTvVcnKZlRoxr02J5VORTgO0v+C8Iuqa3410YKM9LqAJty0rKdllhqbfQ0SvdQJcB9KlhUsPdTa0Tdn5MRn+7epqKpcl9PRZZNQQvrKdEQDSxa2VvT1NxYtZ4/gcAIfFyfd6q1W/qC7+j7K1L+N9C2ZUREBo7vDrUEwtxDQUO/4h+/6IMLdKPLvO/8SDeCxzXN1vlECSyvaeEeGG1FDQearN/SRFA58u76PTrsZcdDItLJqOJ/VmCA2s/L+obuRc4S2WFOQFiZFB7VIgJ/lXjWxbDyxVqp5I6kuOZz1PWod+lxbhaZWkPSgNCIXvqN3mNchyqjADMmPlc/qN6cGsKoVxWVo4b01zULyiD2h+LRYP4ro2Ve0eRp47qLQQZHxEPJm25eRPwS051rNptjXYmTAcJ3lVPJbTO0PSIFG3YablDmWVFEYGgKJexwRh0U0sqGpwvtkPI/c1oMZi0dmF2pgzJkL9TFLTQL3AnPZ9aMz9ju3erzvWDJsJ2KthQO9Ucwohs8LoIy0FAlS9Ir7q0A91dKiE1/TqHUi5dQfIQ+0l0YOGDbVyptv7o5DnbXCcB4QcsEGvV/m1Zvf7yi+2ESdDz29MZhpydPg7qF5ITYIWplg3Tz1ReYtdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(186003)(2906002)(86362001)(66476007)(83380400001)(38100700002)(6636002)(316002)(103116003)(4326008)(7696005)(8676002)(52116002)(5660300002)(66556008)(54906003)(4744005)(6486002)(2616005)(966005)(8936002)(508600001)(6666004)(110136005)(956004)(38350700002)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SkxmSVFEM3B0bElDS0pzTnhGNklmeGFDTVpwL2JuVTZhSVo3VXdSc1ErUXBt?=
 =?utf-8?B?Lys1UExNeWFnNTVieUJHU1hON1g1TU5nVXNIMldwZzd5bkxtZE51NExYZnpq?=
 =?utf-8?B?VVExMEdXQ2oyQm5BVG5hYTAyWSt6cU5IdW4yZ1pSUTcvaGNJaGtYbkxrcjI4?=
 =?utf-8?B?N1FaaDdXWFpjNlFmRWFoT0ZhaDZjTG5FZnBnL3lCTWJaVVFCOEVmNnJZK1lG?=
 =?utf-8?B?WCtGZFgyclNOUnFnR3NNT0lvRlZkRTFZMnpZUklCZHo5Y25VYnZtK1ZZdVBZ?=
 =?utf-8?B?Y1NRVzZ4YUFlekhhUTlEWHU1VzhrYndpVFVwZ04rOUcyWWozSW1PNzVBZzNh?=
 =?utf-8?B?QVFWcjMxZGQ3MlIvWFErM0hLVjFkellNTWkrUzBaMlRpVFpHMXc0M3lhUUtR?=
 =?utf-8?B?Y3EvWGdBZVh0T3dvTVIySzJQZkcvczdVNEIrRVJlUjRFdTQvVytLZndRQW1L?=
 =?utf-8?B?SmdubWpacnA3a1FuMkFGWlhzU25HTlpkUTFQVkxTQ2JiTTIrWjk1N0hXMG5H?=
 =?utf-8?B?WHY1TTVRTlJRT3RRYjNBdnl3aEpQenREWlJQVmxGeXJjRkdUVjV4bG1aSHZZ?=
 =?utf-8?B?TzMyWW9iU29xSHNUNDZmWXNrSjJnc3doQ0hrVEFIZVh3OFNTSVQ4WFNzQTBL?=
 =?utf-8?B?WXd1YzVILy9QT2RrSDh6RHg1ZmlDZDBzRGdLYlpwQTJud0pJblQrb3VaeVE3?=
 =?utf-8?B?b0RIVFcxK0dqWW9WT2tCSlFySmM3TnlTM1RrYld0YzNvUnlTcFVJNndhVGky?=
 =?utf-8?B?aHlZbVY5MEdQMUZlcVJmOUE5L1VBZCtrUmJpMWZuenRQMXVCUHV5dTVtYjZL?=
 =?utf-8?B?UnlqU3J2ZFpvWDZtcklneEhqZEpKLzAzeWpPN3dDcUNlMlhxUzVuQzU2TVhi?=
 =?utf-8?B?UFA1UzBsQzZIc2J4MHNKTXd3VGRCTVFTcW55WE1xUlVydzlRS1ZOc2hWMlhW?=
 =?utf-8?B?Ri90enc0cVg4SVJSYnltZkZpV2xycXVxLzhJUlJhT2ZhS2U0ZG4yRTBPbWlQ?=
 =?utf-8?B?QlhJTjVMVnFUZklFYXl3NFkzV01nNVVkaHNVTVcrMFoxcStuRVVHQkJQdlBn?=
 =?utf-8?B?RzcxRkUzMkJJZzVaTzBMZldZVGY3NU9IdVZidjN0Wm1qaHEzVGo3Q29PcGY0?=
 =?utf-8?B?S1EveCsraEZQQXNKMVlkSE9KR3d6cDJ1UWVMeFRSelJsaUora3VGdU5GdGtq?=
 =?utf-8?B?Y2YxMThYY1BlbllIbGxkL0tGVHBUSStjN3NwTlhMbUw0YmU4UFFFN0NTRHBo?=
 =?utf-8?B?OTZhazk3dUk4MkVXYUl1bCttM24zYldWQm1nRkwrVzAyZE8wWDBXOGtqOVB4?=
 =?utf-8?B?WWl1YnB1elVEVUwzZUNOc0ZETEZxOFU2ZFlOeTNjdGVVUG1LZTZJQi82SUR2?=
 =?utf-8?B?U3MvMlpDb2VtaU9vZG42ODZPUVFlWEYvZUNpT2RIUGhHVWJwbjhIMm9URlNn?=
 =?utf-8?B?NkFWOU5jVi9uUU9sUTFFc3ZsQWFxYXZQNFlyU1Zud1YwSVV6eTBhM2xaeXBY?=
 =?utf-8?B?dzhHd2RUN1VuRzRwTkd0UmZtcEl6dzV4U1d6TG1VYktKU3hlU0tSQmFYQmVr?=
 =?utf-8?B?V3V1OXZvYVoxNi90UHpVWWM2WmY5ZEluU2NtZ2hvQ3dPWnhYRlgvUDhOY0ZF?=
 =?utf-8?B?VlFDOC9wd082a1o3RTNTL2VxcUswKzZWYzZNd3VNUktDUHhmR1pUNzJOeTRH?=
 =?utf-8?B?eWdpdUNHYWJrTmRJcGlLNmJ0QjJCRTZobXdNU0IzMnBQenhIdjFNS0U1bGRW?=
 =?utf-8?Q?EM98hyxpU10DBFfMj8xm7tbsq1ZysyJH7fF3c4j?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6faad65e-442b-426a-eff5-08d97d83be0a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:45:03.3933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gWgXTAefXcP3doh3jyjlXt0pRrAPF8zBazkwy4D8DdC3aOHIh/6MUzy3spD8NutNsEpjrnozpSzBdqgVVQZmnQZFF9TQQ/v8MYAMBELdMhk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4518
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220029
X-Proofpoint-ORIG-GUID: NZhO53Bl1rY8B_pgQhvlB7UTeAsMgDo6
X-Proofpoint-GUID: NZhO53Bl1rY8B_pgQhvlB7UTeAsMgDo6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 16 Sep 2021 16:23:31 +0300, Dan Carpenter wrote:

> The limit should be "PAGE_SIZE - len" instead of "PAGE_SIZE".
> We're not going to hit the limit so this fix will not affect runtime.
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: lpfc: use correct scnprintf() limit
      https://git.kernel.org/mkp/scsi/c/6dacc371b77f

-- 
Martin K. Petersen	Oracle Linux Engineering
