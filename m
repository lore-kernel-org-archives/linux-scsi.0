Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E052C43461
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBF72610E7
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbhDBDyn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 23:54:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58380 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234038AbhDBDyj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 23:54:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323sJxf180071;
        Fri, 2 Apr 2021 03:54:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=tbO4f2NQyswnR8AS8SKFhqMO3cvazF9jEvlHl1pT+mo=;
 b=fVKIq3wijLYOT09TFPZlenL/2C71vUhLER+Ynt9RLrLDMywE8CyfLw03lEqKwqnM80h5
 mCKCATwnz02xGooHDaoH6/7SP992/8va5Dh0lWc6hHqruyorKuLFsHcnznlXokQc2Pag
 DCzT0qHlHnalTqK9PT1CIoNoEY81q4ok7/HvtFEWWW3HcG95bprcyogm+HYS78mVcXns
 os79euJBM5QZzW+MwzgjQ70q8NW0Nk5H55DZJN6a95okf8ez4BaQvpfP0XGjbenGvg26
 i8rox34Aj/VnEtKiKPNQn/gOQbj9qbWtxMCvrBWZPDYDFDTXhvwpKpnXyBj/Jy3hgyaH 3Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37n30sbm7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323pdIs101592;
        Fri, 2 Apr 2021 03:54:30 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3030.oracle.com with ESMTP id 37n2atmxdq-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XVPkyHVakAqVJb/xPr7fXBuM8SWmbl8zF85nBDytWVhaJLIAvTf+/3w59PYhxJ158ZG863XCkQ18th+4D1EWUOe8d7oHN7NI1ryIfnnNVKJDkxKIK9XgwSHHSijhixQHrD48j2OWMtXFKFgWDfdj/Ab1TodWzl4Ng2WkXiegL/ITqVcC63wOTpPv2CRco5En/MQ3zqCj8MTz2qcUzMOeHOn732iyfBzZU5XKs4XCOyRJSgAsS3S9iYELrrVgDnjimIyjefPqv0qK336KWk86AKhayZRZsMPRvNbvTX89VCgH5BWEi05QuLJLW503JFeRDXMTZRShPZO+EHVCQhWBrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbO4f2NQyswnR8AS8SKFhqMO3cvazF9jEvlHl1pT+mo=;
 b=SzN2Co5z0lXc0XZBEqHDV9tiI60H3qoczYsNWO24LxCvomfNjSNpVAC8rwYJ4LfPmB9fZ3aAWT8OTeQW2qF0PibW8sBE1FWF5mMxhSuofC7Yb/Fm07fabR3p7BEguOTqdJx1DJaqj3x0cLMLakQjQqGsjXL4PoZBHxonC2fvjJS/uHZZtLZq/J5dNO60mCGclmEo79H4d1+m/hcUGYr0flpU/kEb9LGeMxIJTJ7vydBe8XeTZ4CMTpTy0+01w00rjtN3fC/ONZVqzpl8eUPFwpl+m9HclnkrcdGYhjz3vJZnN8dDsMuPwo8hYuavId7dYe31B51MyQmqg7CDZum/JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbO4f2NQyswnR8AS8SKFhqMO3cvazF9jEvlHl1pT+mo=;
 b=OmebitBmX/lv4flZTXE9fTY9N5XyKsd8pEosE+/GSkr6WOc/L113h90UjbiD6C12avP3vTHahNCTHNsbqPBIG6pwyejZyzbExg6vgk65LDdO64H3WKKmQ5NQ+jHGhq8o6rxcumSE+wxLNyETc1uHBmUa0Mxnsxib9QHuCGFTLXk=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4711.namprd10.prod.outlook.com (2603:10b6:510:3c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 2 Apr
 2021 03:54:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 03:54:28 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Shixin Liu <liushixin2@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next 1/2] scsi: myrb: Make symbols DAC960_{LA/PG/PD/P}_privdata static
Date:   Thu,  1 Apr 2021 23:54:16 -0400
Message-Id: <161733541352.7418.6173663161172853914.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210327073156.1786722-1-liushixin2@huawei.com>
References: <20210327073156.1786722-1-liushixin2@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:806:a7::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR10CA0007.namprd10.prod.outlook.com (2603:10b6:806:a7::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Fri, 2 Apr 2021 03:54:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2499efd-0087-46e7-3655-08d8f58b03d6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4711:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4711945A98BAB0FFFBD9DF138E7A9@PH0PR10MB4711.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DZ53Hl2slqSLlP3n2WqFnR4w/hogfjGLg2GNOQx16GoBII5fT55bUR0cdvVlKi4fjwKCYoIxTP26eGoTlaldDV2UpxnZfvZW3X4Qo0VQjwMBmrcX6YQzW5YSTAK9b3IKNhna/feJWRvbUZH1ktm1N8f59EwNe4ScFS10xPWLP48P/u4/6bHRROWQBue/wEJmcwKSNmoSwubaZJgc4MNo2kz2ZY9eSSiWaWOyieh+kZ4nP8FAjePwgc81avKc2rPGMchd3aMfWT1hfvX7BSIeO9xcYTmAJVyCBgrxriA/2NDuRC3AWu/kZyh1tzvgKlYCneDJLWKqgaCBVICMX9yJtUv9/jMLhH1IGYB1CEWbTK22Dj6DW1lrH4pDs/9QtRTCDjy4SEu494/V34CSYU4I1JhDXnCuj0W/1+qoFKBPIiGe0SySdYpqcuxiVhrwRHZNoCxNKiF3RrOl6bB7Jw3WjqohV8KGDbvwHzd/S2BcOdtqh25NKD2D7GFde12WoQb3jvrxHBh3W0A9WnYwBQjeoeu7EJoDZ0g3VwDcC1UQr4dgle3f5NzJDpeXnmiJI4cuYD1yMRrwa+kvHUrbXWueR0ouRVdyCq7SzS8y04bsjtntOJJSGwCUxmRfOzCeWgJZD/fy713HFBuNfIw0Dj5FZtNh2tPSj1Ba4RkFEzUbq9uXgxk+Xy/tXOmx1pmcK3GUcoJRLQ6h3IqToPr+jXgIImPUSo9k0K/qlW0eAgQQ4+8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(376002)(136003)(38100700001)(4326008)(316002)(5660300002)(478600001)(966005)(86362001)(66946007)(66556008)(66476007)(186003)(956004)(110136005)(103116003)(8676002)(6666004)(8936002)(6486002)(36756003)(2906002)(4744005)(7696005)(52116002)(2616005)(16526019)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?a0dmM05kaGZkRHVZVlJENW5iNTZwVy92VW04QnBlejVtUlRUZnU3YnpXNDVJ?=
 =?utf-8?B?MUF3dTcySm1sM0NFRU1ITkZTdkhOQTJHU3gzaHJXQTA1dEtYZ2hpRGE4OC9O?=
 =?utf-8?B?d1pSMS9sRVZrQkRKem1qbmhhN2pEQW51OHBZcmp5RGF0bWw0SUFpdGZIeSs0?=
 =?utf-8?B?UWpYRVFsTkd4R1UwU2R5ck1UR3J0UUY3OGdhWVZpMVZnSjk4SjdpTGY4TDRa?=
 =?utf-8?B?Z1JrN1lxdW5KV0Q3NEhyU1JBZHh1Z3lnY2hFN1Vic3B2N2JwTk5tZmUxekVB?=
 =?utf-8?B?WVN0NTV3a3M1d3ErR2JPSG5xS0E4RzByRENVWkhRWDNIZFNPaTM2VlN4OEpD?=
 =?utf-8?B?emZtUDVRWlpGUG53Uk9vSkFEY0gxczQ0VCtxMVhRL0NyTkRJT3FteVhJaU94?=
 =?utf-8?B?ZnM0R3BNblYzTGNUQ1J2ZXBQT29memZIOUxqU0hxMTN1WjlkNXVNZXV0UFVi?=
 =?utf-8?B?bzRYZ3dIK0RGd1JPSlFwZ0hBTXBMOHVyRnhVWWZ5RC9WeUpwMDhtS0hNOTNV?=
 =?utf-8?B?azRwMjB6bUNQaXNrQ01FWThlUlJxei92ZndxTGRNYjVTSCtsVnBWRE1VUStO?=
 =?utf-8?B?eXFvRmJMWFRITU5HSGdDYlJwb2tWZ0pRQ0JiWDVMcEVVV1VMMFk5emxzRlZO?=
 =?utf-8?B?Sm5WdGpZVWdkWWJ3eVQ3WjFma2FYemVkT001VWExWmpyVVZtNmEzZkYvclFi?=
 =?utf-8?B?d0hjMFBnN2cxZERFYWs5OFo0OXBPZ3pDeVZKdkJpVWErdnB4VXNSRFVqSGNP?=
 =?utf-8?B?VXZNRERDM3JEcTZZRG9hQWgweThzTkxoWXZNQ0VUanc1RVVDazFJYlduSXRq?=
 =?utf-8?B?TnRUekZwZG9MUGVxUUpuMHJUNWFBeXdrWlN6V1BXK1BKZEQ2ZVREb3Y1TGc2?=
 =?utf-8?B?aVFOOHBBWHJncVpjQzRid2VLNW5aTy9IWGdzWEJ2NUJIVXlaKytmcFQ4a20z?=
 =?utf-8?B?UFcrbXBza0FKTldoK3J4ZGkvZHYxczBjZExDeC9JdWJycEhnRFppNW5OM1JB?=
 =?utf-8?B?N2kveXhkeE9uSm12ZGVTU2ZBUWVYemQwanBBSUtMUUJMbTNSQy9nREdERmsy?=
 =?utf-8?B?WTBMSXM4QS9SdCtpaGxzRWs0WS9qNnRGM1Y2THlzYXdQMmJmd2taQ3czWmIy?=
 =?utf-8?B?cnBVNk5KRFJ4WFFoMkpyWlZCaFlsTnNQVUJQcVlDOExpZEwrU1VDQ0V3QytT?=
 =?utf-8?B?bGg1NUIwMVBjQll0OElQN2Y3dFJsRFV0UE1Bb1ZRL1FYblRzL0NEczRVL0ZE?=
 =?utf-8?B?RFJ6R2Fmc213RE9vd0dpRDIwaDVQVDRMcXh2MW9XdUtCNkFIQURORTBVUm91?=
 =?utf-8?B?dXdXRzgxMlM4Y0IwZFdMUFRHMG5NRmMrcHlFMjZLTjgzMmFicVJXNHZoc0Rs?=
 =?utf-8?B?b1V0UXQvaXprS1F2U3RsRjB0Wlh4dGlwUkdWK0g5N05BWUF1NU9yeUxYbWd4?=
 =?utf-8?B?MCs1N2l2VUNtUGtsRzdFMHhyRFpaQUNtakxoeUhGcjUzSjRzU01za0ZLZ1Rp?=
 =?utf-8?B?OGJuQXBxQnpRQ0dPdWp0UEl3VTZ6a2pYaGtZOWFoRTJSWjBGby9QTnFRcXlp?=
 =?utf-8?B?ZWNEMWt5VDNMTWp6REpxdnhZNmVXSmdTMEg5dzNxekhvejFDUTF3czVCMkxo?=
 =?utf-8?B?NXBtRDBOSEptQk1zLzE4MkI0S2loSW1lcHY3UUIrWnFMNTE3Z3VjMER1cUky?=
 =?utf-8?B?bE5TNDlMQlF4cmdwZS9XM0c5anoxVlU3azNMSzhSd1pRNmppNUR3ZTI2OHZR?=
 =?utf-8?Q?5G5dUVrnqXzhE91/IMALaISjj9z54KBNdmdSvQu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2499efd-0087-46e7-3655-08d8f58b03d6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 03:54:28.8097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dYFWTXfpxohClRwZcWYenKDdHDk/JlgQGgWdFReJ93B02EaQMxPWPdB2fv7koUpNGL5exMVdtY9bDOebHZK8odqm6U8McaGk1p2Wvcb0AsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4711
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
X-Proofpoint-GUID: Fh-RAvEcTTKiwCiQOnj9Zp114r7EMKnZ
X-Proofpoint-ORIG-GUID: Fh-RAvEcTTKiwCiQOnj9Zp114r7EMKnZ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 spamscore=0
 clxscore=1011 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 27 Mar 2021 15:31:56 +0800, Shixin Liu wrote:

> This symbol is not used outside of myrb.c, so we can marks it static.

Applied to 5.13/scsi-queue, thanks!

[1/2] scsi: myrb: Make symbols DAC960_{LA/PG/PD/P}_privdata static
      https://git.kernel.org/mkp/scsi/c/182ad87c95e7

-- 
Martin K. Petersen	Oracle Linux Engineering
