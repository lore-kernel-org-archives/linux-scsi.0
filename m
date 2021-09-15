Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD984C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 03:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F70660EB6
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 03:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhIODkv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:40:51 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:31456 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232517AbhIODkr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 23:40:47 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18F2Wj1o018628;
        Wed, 15 Sep 2021 03:39:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Xj8lEy6YwoP/B7oz6g0m4e5i/4W1FK6O3+lCtlGbIUk=;
 b=X5C5tqF+n0itssXuB0spbmP0/lErpzYGipAu6SWPLsLRwb8Nh4igHdQM3S59GNJFD4OF
 dEOqCsZBwENtpUNW3hydAEUxpPLQyjN0ZMz+fgccLAALAWtWndjkSWmFblw3uYJPkRVa
 LWpH7etYNCvnO3TBJptFjsbNwaGoGIHeShGyElTv5yx9/Y/DWWz21ZcXiuu6QONtpetO
 1CWgsSyosuIVIRDGa+2OXSvrhCVD2GS0OZBc7R03nbVLTCq4HTcOYYVDztj8Hx6xuo4f
 3hVP9Q9BE5/Trcx5+w3EFhlkN2HJ4kPjFwUIuRYhJ0nky0B9wjhYY2enN9lzvWbgxa25 4g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Xj8lEy6YwoP/B7oz6g0m4e5i/4W1FK6O3+lCtlGbIUk=;
 b=J3pM52XwlZpF9G28LNZ/snCiL37Nh1O3Beaif7PDu3dvu6gu1/yIs3jJ+GAZNqi2FSbU
 ZYmY0CB21d3wyohzSo+CPc6BDvEp0JRwKUKv9ClriIrOxd1kUMItUgVckI2iENwgoRvD
 ydA+Irlb12n8/z95g0TY659H7NbtT6vsa0e4bIamDQQkO9/EluGTmL8sPf+4nAmQcHV4
 dF4u/IImFJyO/uMUCxXOrCAhWVnr7YtU9/tUPpZ/5LNAEX1EbNgIN0SDDVyJskgVl3hY
 x1Ab8JCNlFCyHlShPt3ro98ybzGMD7xRdifBotsE85JQ3ZeZII1RFHylZndAU/3eE2A1 OA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2kj5uv89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:39:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18F3UQZX061000;
        Wed, 15 Sep 2021 03:39:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by aserp3020.oracle.com with ESMTP id 3b0m97707a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:39:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ON6kDvcYe5st+SmNO1QKQUlLJdqSRVRHsJg9XB1xpwmUZAmSaBlOgke4Xu+FzC7+z0kBu8T6Dg0fMYqvimh/TG4tY6tdlyyY7OTG6P1x+X2mu4g8rJ5lVszSwZ0d2JazwhSK5dCJChpBY5UCsayeo8wI5s+wOXDxiCS3HmiCaN42sSSwULDgSaqWxAJiewq5uDXle585bQ/raTOq/SMWjSWyxCc3uEB2BwuHbYrGvw+A+QbIsj1PJLIkBaIYdKm11TdU+pH5Qq6wMvHdI5OJZV5aLf9YeiZzO2e5GteutmT5/JyDA77HK810XfQSRlmkKBPgAk/ZH/AcHIMoEKgqGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Xj8lEy6YwoP/B7oz6g0m4e5i/4W1FK6O3+lCtlGbIUk=;
 b=SQpCUV4nDfn3II18T7DmqY9Io9jhOFSKV1nzjdSc+yco/V7kVYRpcPBBT/CBCyUvnQ4IJQHdprlYlS0iwtA0jItSZ4gEJFDnrwZEaLf6LYHVF5jZNGNgTpc0fsM3UQ2L8uhn8yR7BCtwSiPKqkbn3N7EEDHFcJe1ryRc6WF/oXNLQ/zSgM7Ybrmx2k7gs+kX5pFne4fq4tC62flQC3NqCiV3i6/akHs2ENUM0/l0neymH7oL/9j015HPCjpheeciZIhJb9ilWdQ2fufME0jMUEv/VawltDAnEHDHaF6/57IWSfbcVbj/dyXd64pn9r036QsM8xZw8/sJ4zL2nb7sRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xj8lEy6YwoP/B7oz6g0m4e5i/4W1FK6O3+lCtlGbIUk=;
 b=WVw3yvuy0CNtgoSijEVLI4VnNqPGow26fueBryqKgVT0Jjz8HkaQfKPvEKYCl9yKiB8/2iyhdATtxUOrKGEBdFYElbvf3CO8ooij3sgtfJ4lLcHp+aqw9GqxNpDYVUk1VITYikF2cPPseSihDcKdI9nQyIk+zL1t/oB32WfBe7w=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 15 Sep
 2021 03:39:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Wed, 15 Sep 2021
 03:39:19 +0000
To:     Muneendra Kumar <muneendra.kumar@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, hare@suse.de, jsmart2021@gmail.com,
        emilne@redhat.com, mkumar@redhat.com
Subject: Re: [PATCH scsi:fc] Update documentation of sysfs nodes for appid
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmtav76r.fsf@ca-mkp.ca.oracle.com>
References: <20210913015853.2086512-1-muneendra.kumar@broadcom.com>
Date:   Tue, 14 Sep 2021 23:39:17 -0400
In-Reply-To: <20210913015853.2086512-1-muneendra.kumar@broadcom.com>
        (Muneendra Kumar's message of "Sun, 12 Sep 2021 18:58:53 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0202.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.50) by SJ0PR03CA0202.namprd03.prod.outlook.com (2603:10b6:a03:2ef::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 15 Sep 2021 03:39:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7eb83b57-9327-49a7-fc2f-08d977fa6671
X-MS-TrafficTypeDiagnostic: PH0PR10MB4615:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4615F817587C66584DC907DE8EDB9@PH0PR10MB4615.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LFZqaYbqmmCr3tAJDdtTZ/reWyTFFPRUghXdgv9bM6nl8Dusd8FdQEXsvGVPZ3GQpCn6godxRTTbUig8/ksFLMZ25qWyIRVaFSbt0FaG4aa2dDmjoPVm4g3v0fQVDWrM7ME5uI2R/nIszu2PuI16UmJ9K3ocuMJ7FwVX8r6/mkvHwJVWlaaxMVCZOqDHE9smu0ETdqIdwHY0jDDFYphiRH+1oPtJjdkRfNLicQj+sKqKRj7xeDphOtNtZrp3JSoU02m9qu8BXGMnlDylpRXOe3dOcHHq3i6AwBDdFggDXU7iDm3un42giSvJJVLowfpYch9ktvKx61VSKu0CIo2LPpa3iuBR1uWCL1m1OvbWnfwAWcMHsOUNqWGaGoJV0d/xiiAauQvJGirTktKybvNOar/jYe/NuxJBfAWT3ffjzbPuF8wAKD/PE/DMnuwx9ElxazkK43jzcFGCYoIuiywVvO6TSYbA715ZOPeAclfv0BHK26wxzeNX7hlAO1J5DHxNK2vQKOpUHGlLbjHRbk/Tm47Eftl2IAyA9O0BZAClSSRc1aVXaXj5lCTXyF37rFODXixHkJrefPjFkC8/xerpIi9bvRkekCNvFLa71zjZzuxPA6QLLpAeLRVxoiD9Ps3lnHhcTFfBXzfzMqFyZV9Hj/im1eCOhokHusDYlyh0c/uffYYVEh6T5YTooCXAWna3Dg1weV/k6mMDg5dp97exfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(39860400002)(136003)(15650500001)(4326008)(2906002)(55016002)(83380400001)(86362001)(956004)(478600001)(52116002)(316002)(66476007)(66946007)(7696005)(66556008)(26005)(38100700002)(186003)(8676002)(38350700002)(558084003)(8936002)(6916009)(36916002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/VwXADeCv3qx1xcFCxJDLdI7lKADAH1gjzllcMLBxMmoQUaWW8+KKsH0vevT?=
 =?us-ascii?Q?NJTDgshQXcanLPjeddMTKwEVvBtrhnhaTYEsKQ4mUjQrLPmt7wCDfR0DLXbi?=
 =?us-ascii?Q?Im/MPhkBPFR2bfga3pbcP6BzHG8Q5md+9ITTXg7fn2eJwYy+TTWuGONx7M4W?=
 =?us-ascii?Q?CTn8gZMzxzysKjEFvOJian3GOWYNQLHgDLK+qo5iTa7MPGZ2iA3WS2E7BTW0?=
 =?us-ascii?Q?WQhSDcrRtw4WazHKmfSh2vvI7Zm6Qav4dSI9Rw6tzwa624mIhHCuuZFZ/lyU?=
 =?us-ascii?Q?UaYmA8YtqJcnMKuj2DCy7Qc/3bn/IkHjWXrSbBhZxWfFI9L00R5EQAZcIT4I?=
 =?us-ascii?Q?JjECPhN4jURnytZekLX9BNKK0bNbxX7PpafWCe8q8oXR89apqvX/ainvWcA7?=
 =?us-ascii?Q?18OZ3P1fepRW+Nh3edQ7ac4X5UEk5Au/JgDJEA7+letZV91nHko2UMc8tb5R?=
 =?us-ascii?Q?I1BdX3aGTqcwqyXkGor3uw1situq2/gdj4ljgQqLchMBZiOXdi/WOlu1N4oO?=
 =?us-ascii?Q?7OBQF2w7k64ltes/MT0HGC6r/89CQan8yfyANEBYERev1/U6USI3Uk85lgwq?=
 =?us-ascii?Q?sBLDILkbJexNEx6V+7EpTlCWdmt6DthYNA8FzCMkcN8JcRaU0Y/YknawVGbl?=
 =?us-ascii?Q?b92675jO69ThxFYcb/C59BU2h5pK8thjPmzYYPEAEjEhn5qGjBDofZWXe93I?=
 =?us-ascii?Q?1phQwjaS86zGDjntGqIB+mmebp0cOz3cnlpzVT4kBfuVp6RFBEoNYQD0PF54?=
 =?us-ascii?Q?8qAgdZRtR98AP5FD5MtjLKUpJLYmwBnv5U8UjxkOT31BCSG4AbOvqdflvHiU?=
 =?us-ascii?Q?sa5PCArXm/V1er7Z+wHDrI+2tUj2QzLxRy/oQoW0LIC6xeDZ/F/dvkc5KviT?=
 =?us-ascii?Q?SoDdhoYR788bSWygnb+1O80F78+/NxFpYyTEauISsuTkXy0ifsbClBic7v0j?=
 =?us-ascii?Q?isIQXn4IYv83Ab8uGIrFa1i179pvUI7brviluVVwH1gyZcvjEXd9/tqL5rya?=
 =?us-ascii?Q?KMDUHZgyFKm/lrRXZM7RrHhgWB2zLw3aBdY4xLLC7Y4wN861Y1u+yPVyBXkH?=
 =?us-ascii?Q?W0/aAD8txT0STa4pwL8P982iDl9ivW9000BiiHXxbDqfKz0c7Ubmwh4hWM/C?=
 =?us-ascii?Q?RFBDFJ78B96icrTu6E3h2SwzLjwGFTXOxS5FSnhj1AFIHQug9vwwoj73FqDv?=
 =?us-ascii?Q?kMbAqLO5MugJM75/syUQ44uKJGCmt77Fyjz1qua3TDm9AUN+HjtIz8ms/G6q?=
 =?us-ascii?Q?ZX4gRXwsvc7KHO2bMNEtFvpkAP7xY62l51Z43kznrHcQkg7jnvWUBpaTNKtV?=
 =?us-ascii?Q?MNKO5tWBdHTJ25XJxwNh6Lr3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eb83b57-9327-49a7-fc2f-08d977fa6671
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 03:39:19.5305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KbpzJMvM8r9cWfLtNKZ2H17pOdf4iFWQ/GNgjgLMj1ueeLfqq4xx+nKCaS+YAGRXoNQS7TnSd6zfc6b5eU/K3UtiRszdwHfYlVQdOYFNcsI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4615
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10107 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=837 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109150020
X-Proofpoint-ORIG-GUID: JF_hcNp1d2Ar04u9cQuR9ItxUl0NXRmr
X-Proofpoint-GUID: JF_hcNp1d2Ar04u9cQuR9ItxUl0NXRmr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Muneendra,

> Update documentation for sysfs node within
> /sys/class/fc/fc_udev_device/

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
