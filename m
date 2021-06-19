Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE8BC48BDF
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AEEA6108D
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbhFSCGS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 22:06:18 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20748 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229475AbhFSCGR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 22:06:17 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J1uM3V007770;
        Sat, 19 Jun 2021 02:04:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=uYWyBS3exZzwuyhaSIJ+MRPdJHKaAzeryqDUBTqKfnk=;
 b=N7QoDdochmbr39c2hyewgG9OvB2fO1C53lrS0ziVZdUQ02wF3ThtZzBESGQsLp5/ZmtT
 3/a6NkFNmLEoLCbKvAOX2yiuMvDEio9JacO010fGsHy6qxAecfPqCwUxbu/Tsu8Leo95
 5uCvsfk5Pm3XR0xzDoCL5ebkffQJHm3Q3mggIqWjxfHQ+QzTWdEUJCHH1nWkhw7Cf8N2
 TdfWjdlFwDh5jsZZcixFEjU4piaZV7kRu433drWMtb4sw1g+oOX9ffBdKw157f+hHRxI
 rIgnv1iLo8fTz3TvcDhrxoGEZJd7CReITYENoryN/SoB/ou1jkhmX0XMDMn+Ak4X6dTS eg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3990488gqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:04:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15J21O85160378;
        Sat, 19 Jun 2021 02:03:59 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by aserp3030.oracle.com with ESMTP id 3996ma12ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:03:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N3+QUlx5+nDb20SVyOjbOSvYQRR2EY0sv7wShRoXaqXBO09jLsmsPcoltIa72vYTFOGWg0LcS/5+TMRWFx2UhHA9lpL7UBQrd3/n8Ucydz1Tfsw2s/DfMtf672ZfdkyK12icMNoC4PUI76sTZXfxLR+SyF47crQTvAtEnPNbbaj7W4+Mtzo2b08gyrAlLeGSfX+/oGEvortK8cOowgo4OMm+QvcZwBAF/xm00p8YHOgl+qiOalRWBF0g9plSBiJ11/pTKvUqwCTM0xWaI+qT+v3cYDRD4f9Zaxb+R7ji4eEClWQYJbAMGrOacuLb6/h+9WTh7KluKUxLHOXPADh1sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uYWyBS3exZzwuyhaSIJ+MRPdJHKaAzeryqDUBTqKfnk=;
 b=icxWfDY8+EBBl+XGB7qhSS0wUUTC/A71nwPp8ANLCnfoD0oDzLmgecBS1NfuIbRO1HgUYdm+np+TEd/FHeFj3BmI5cj5SHp9eu2Ou2q7ODl6fIXibFc1QKbJD16euPuVhFNBZGLXKUQ8FbBbODMWQpmk390FsMeu4v15xctv0ELJNuTh0L35AY54VIW84pHjRJD4bjxf14FdmW0bXpDWYerGMX76xJ1TuT2ECNDQOWgN8EliAZe3gB3dBN1I8WsEs7UtB3M6BqjeYEriJHZr7Uix1ziuNxaehPIrLzCZdR4YovsaiI6V8SNv5t40CIG+BH/BcxMJ/25xrZBXcC4F3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uYWyBS3exZzwuyhaSIJ+MRPdJHKaAzeryqDUBTqKfnk=;
 b=ZzKPTdDfgUoHVVcVG1dsV2rAtSLbswYUSN34/9fWSSKQr5rT871+tM0IYvcHlyuMAzIJpqL1SYOuHOPUiSQbYeJFKgkx2p8MwhQYcH3nuiCUWv2Xvm3srBp9/K9s6BvorWIBoNfYLgVqJQ/xBhZmUZROgXEMCPiLAIuD0MowLqI=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1245.namprd10.prod.outlook.com (2603:10b6:301:9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Sat, 19 Jun
 2021 02:03:57 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%4]) with mapi id 15.20.4242.021; Sat, 19 Jun 2021
 02:03:57 +0000
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
Subject: Re: [PATCH -next resend] scsi: mpi3mr: Fix error return code in
 mpi3mr_init_ioc()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czsi1ugt.fsf@ca-mkp.ca.oracle.com>
References: <20210603151653.711020-1-yangyingliang@huawei.com>
Date:   Fri, 18 Jun 2021 22:03:53 -0400
In-Reply-To: <20210603151653.711020-1-yangyingliang@huawei.com> (Yang
        Yingliang's message of "Thu, 3 Jun 2021 23:16:53 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR03CA0221.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::16) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0221.namprd03.prod.outlook.com (2603:10b6:a03:39f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Sat, 19 Jun 2021 02:03:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fc3a915-5458-4fca-0755-08d932c67f53
X-MS-TrafficTypeDiagnostic: MWHPR10MB1245:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB12452613B019C07E15BBCDEF8E0C9@MWHPR10MB1245.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WL+6OdM9Mua09vKi2y69RDRbCQCss7mEoPA667qO3q6AFNCBDAoPdNuPIIeS3f/xvVen3qL6xZS4WxJOcTV772shTM3siAITyicjUyTttqVRMpYt8pZyvJ2jt1oYQ0ZNAEi0u3ZNd/56NtreoQclMTBcFSNDNLQPIbO2KoIj2KosBEEhbWisnsKjoRFwlrT6w8KOmbgHeSCpihGB7jcoEf17UniHa+jHHwvEA0DL1JXKH4EQA3xBk9nhsoYHsz1Neqhf6+WfL038iZ/yEo2cnie5sV4o6JUngE6xtFxkFVCZf0NCQf2H/ey65WKf8n7K81GqQ/zg0eBWF3psN+TIyPlWdmXnZQy870qkQ/Eni8tSdr1cOO4CtV3r+TITyQCxEFJ15/3JEnwbr6SOOJipsvjsj23RCSrJgqLxZx/7QtphpJyszX2BIywTxNSemCL+YMQ+8dh3tzexuUoDVTob+L20kTlHQVnnjB/HzdyK1XZ/mJI8B0kj3t/hKUxNTGpp5VzTjtnftjA0kJVTYetGglgg8Q4TdvqEn2wv8YwdHACIXeOAjGo0vYATnkLBkP6n2Lio8Vl9kEnRcSIUxYHp7rNLHzT3OIZbBIGPEFG+zGePt9rkvGU1lkJZBQ/LfbwQNCgCJG7dpdo/khdImouDoILv5kQ1aeRqKR9UNLFqXbUeuctwLgeYa3BNpFmUW7kq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(376002)(396003)(136003)(956004)(26005)(6666004)(316002)(107886003)(8676002)(186003)(66946007)(66556008)(66476007)(54906003)(16526019)(38100700002)(38350700002)(6916009)(8936002)(4326008)(5660300002)(86362001)(558084003)(55016002)(52116002)(7696005)(36916002)(2906002)(478600001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b0y3hKGNxgcCp1Fk0ko+Py3d+n6fp0oQhuPfDrylkF2trICO3HOAqmmKLByf?=
 =?us-ascii?Q?VM/CldNr2362BemEZNo1GLKqXT1A5+297tr+7wFO0SBBnnJ/M6L0Ozp9EHN8?=
 =?us-ascii?Q?uFPsYoTMnczbI8cOsEEIwGLHo9oybGGBJ3prndMpY1WGGGpMz5UllE4HthAK?=
 =?us-ascii?Q?yvZDSZIqfhlPRVJUivixpj7pd7yef+T3ZagENG1S5gmQljwlNUDGd+Fu2cdE?=
 =?us-ascii?Q?Rj8rnoJAIFsn+13IhW98TnrWXWwR0z18tn3bWT+5II73kuyaAq9ZE0GbYXKW?=
 =?us-ascii?Q?8Q96QZaqW5UVmiK5g/nOABb8VEtT22XFEBW5/RZ/0Rp0+kg/77n2udP37Rbq?=
 =?us-ascii?Q?UEclPxDnmLevBGawypISw1857F7ki9z1HpTLw5F48J+ZH8Me54cw0LaObqzP?=
 =?us-ascii?Q?7O48fqJVXVEHLnQ5VJwMzWFU4RRht80Y48/rcsBlsTdZX3OaPjSl/mghi0L8?=
 =?us-ascii?Q?btq3JQiCwexCjR34jr9qtr1ct65UD6o2fEJyw27fXXCFg8hQWLLoki4zI7tT?=
 =?us-ascii?Q?BhWpBpKhjITUzlwYFj4QBg4qgoVNd0RrXWjEeYITpQsfDGrc0R1iKmnw86EG?=
 =?us-ascii?Q?y/gq10IR9dmyZvG93lanKU0vTWrorkZhLNyXHLOm7fTrdirHenNoUNg1K4QS?=
 =?us-ascii?Q?P2z9hXzYzGu0LVt4zPQeCIuejUEqzSRfgfnoufn4pluBylLFMy8YB/vkcM61?=
 =?us-ascii?Q?ig7kOuEUlhlm0hGcc3h50exjPhkd6D4nm6or56jqM7xKgJQiuONuGGwllwfA?=
 =?us-ascii?Q?b0s1f1lHr0o7jJdooeNnqxNOR1CUkj+ceiNLw0vvTA6yxSa2X5qMOTwwigJZ?=
 =?us-ascii?Q?Ov/65CFo1Q4SDDJhw7TYHFqMKaFXl36EIxyddn8wqP1xJcZXOsNWH7SQ9g+c?=
 =?us-ascii?Q?T/BnY6eSVEfP4vIG1uqeG7roMXlAsYZKWNiXw1WPb5NR/cJYv4e6VbMFqLy+?=
 =?us-ascii?Q?9EvnsUMfidT+94dZYC14TZzGbERFZmAYUgqSVcAYe9DAlwBnAqqhzwaj2H+f?=
 =?us-ascii?Q?xxEV0PeqQJLVD/qBJBRhwXJ5URU/z7UYQQG9rZvsDGS+7vpVVbkSskANB/vP?=
 =?us-ascii?Q?G5ibUw1ai5BaBgUKIYt7aRAe8J2MuKUupp8h41S/vuZQHjowNDGxkVg8ECtA?=
 =?us-ascii?Q?fiVDIa6kCKKNP4rQbUaVI1eNvM04rlSANUcM6HaqhtTeAZ6qHRytlQc53pjV?=
 =?us-ascii?Q?JOMNmMKP+EkfwssHl8wbE9/EMeeeazFF0iBN6zP3VLzpuergXWP0TtGzBQqz?=
 =?us-ascii?Q?Iqx/NS1p2qdsC05feAWJAZJ7hk6hXLuK8s8D0YNRXrrPe9EyiK33xOSjN/yb?=
 =?us-ascii?Q?Hf6b/Suveg/AfaV1HtXXmZnd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fc3a915-5458-4fca-0755-08d932c67f53
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 02:03:57.1632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0TOmuK9I3x2yOjxQl3925T5sSzGLSPrSPSmT+OuO8CFoZJM5UI0VnwOmatljnVhaD8k0V3jLhJDUrEIFNw4+bhPrPuW3DD60abcSi4EQV/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1245
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106190008
X-Proofpoint-ORIG-GUID: 3idL_msXAzkvbwhVZ_vqdX4hZCLByZyR
X-Proofpoint-GUID: 3idL_msXAzkvbwhVZ_vqdX4hZCLByZyR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Yang,

> Fix to return a negative error code from the error handling case
> instead of 0, as done elsewhere in this function.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
