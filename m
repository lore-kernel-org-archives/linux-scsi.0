Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C935C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 11 May 2022 02:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238350AbiEKCLn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 May 2022 22:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233994AbiEKCLm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2022 22:11:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A655B8CB1B
        for <linux-scsi@vger.kernel.org>; Tue, 10 May 2022 19:11:41 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24ALgdbE022574;
        Wed, 11 May 2022 02:11:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=AsDjcDjfBbOh/Rd3zSlsnLHKYJB0Kn7VK0dbzxZepqs=;
 b=qCH2kTmKN1bEA0bTqdFX9/PKcdrUFIDpm+oidNYSBROnhhev4FUQTwX/VBbnmEf/IJB5
 Mp6IEx0eWlKhYgYRaF3OI4PQa8Y0xi43qrub5rPzXvsW5ezz2nmiIEhzltHJCambA3BF
 gxoVX7Yp8XG+2metlYOb2RwAuyFSJOzBjBKFK/zOIDOvsnkFzrUYzLtKyYVXd7e742Pl
 HAjxt52OJm1CgYalcqhWkuV08y5EaGJNlX0oVgGqlCnuASbCGkWX0IERqbYJv3JgfBF4
 npNzISgHznKipbekiiC8JS5KEgldxhv6k/uywbDszNhQ8L/sGPSv5sOzZOhnySa1jdw6 EA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwhatgcen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 02:11:40 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24B2B8KF016765;
        Wed, 11 May 2022 02:11:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fyg6e7d4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 02:11:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRIucMrtXCD2YoMV4bSigyoPm9weio1MkjZU3tZNZ3jj5HnWEuvn9c49mtbs2S3WGaoqnOPLN5y2/NVOoeZNtgoX7itVFsrD0Lb5BEb7dgmpmRZNM7JXhgPkF6efaI+LSIZ5fHtXkGq4glwjj8hKhUX0+MI8ItPNs4/rMS8K6ADUHWwTCLyz/CY6u0Cqng1o5RnfeUAbUlbJRO4q/cKFBKxHbEnQT+vFG8V3CSf+i7vRDfIFc/d9KYymHpK3is7ejp4fY6cijv+fYTRpjAYsM42CfPBs5u5UCyq6F6YyZheov59tRW1sqxswOH6lhL82LF9+/nOXqT39BFFGzHSznQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AsDjcDjfBbOh/Rd3zSlsnLHKYJB0Kn7VK0dbzxZepqs=;
 b=aa07v8Qa2oJAelbPOdiZtYJ51vsGKKIVtKGXZlWScAPRZrdoHzaecaKljFZorXempsGk4vP5DuPzGeaiPWFdFwQazXN3+Gq2vSIjjGrjixe3IqxpqpzH1v0KAfZUyx3u4OW8oXMBvvQ0PEIAxb8FGWmwyltDntkp0udG4s4t2Jh3mysYhT0XmVO9ZFq2EjjrUZG1R5HjV8cwAEZ5T0bHG76EDYrLAOYA0FswUFSP95ztBOsNkGtbtnHSNXulsFeMCL/sW5lXLjivUaiaWdsHtbjpodtlkc1sqfeLO9tvGGXFxo/W5z8gb8QY6ip2RFyzO09k42z2wuGsTDbJJD7kGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AsDjcDjfBbOh/Rd3zSlsnLHKYJB0Kn7VK0dbzxZepqs=;
 b=MbUn2weWBFl540uoWbxUA+LZXsRmVXtW4Qv86jhuKEwjW5764BPE0V09dHLj7TY8qUI0H3eTQf4Q1IU6/2XsaqYvCcc1Jx7gvKx4vEG9bRTS576/z/41I6RH/j30ubn4Psp2Wp4aKcLzx9UazQ79QibkVdoVBfizjiau+xQqRuA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN2PR10MB3407.namprd10.prod.outlook.com (2603:10b6:208:123::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Wed, 11 May
 2022 02:11:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 02:11:37 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 00/12] lpfc: Update lpfc to revision 14.2.0.3
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zgjoyg1c.fsf@ca-mkp.ca.oracle.com>
References: <20220506035519.50908-1-jsmart2021@gmail.com>
Date:   Tue, 10 May 2022 22:11:35 -0400
In-Reply-To: <20220506035519.50908-1-jsmart2021@gmail.com> (James Smart's
        message of "Thu, 5 May 2022 20:55:07 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0064.namprd03.prod.outlook.com
 (2603:10b6:208:329::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16e16563-adb5-4131-9ef8-08da32f39466
X-MS-TrafficTypeDiagnostic: MN2PR10MB3407:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3407D91622637316C2819B1F8EC89@MN2PR10MB3407.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D5p33oCRyJB0rN2BC3ndQZIfbVUHdD97cTcfdUeGmIev0Ccn7RHXtnYniISA0dlYD5VhBMYOnqD8V4O0PsS++Vz9JlurJFC4M54kRqRZ2ukdTc7+xE/LaPfFT6Yg42GB4cH06jS1IkFNEKSRbUNFRdjU59BH/RkfdVyfCLt4XFmtz2v9LPd7Kl4n30jjBWrZZJC5MFAbrq+uKAL7gz8JLh20A1i6XtAaJ3JM05A4KansPnDlVnyJ2YBFS4INU/pMojQDG83IpH5gDMP1gQtTN2rcGWRezmORqCIQmelYevGC9/MVFdZ7w8c+uzR6sPyo/RSXH09iqZ0GB5jHoh8aRo1J+obm4GyrdXBj5XOOm5GNMBbga9I1loF0mOG7x7ijU5XhP70iQA/B3r1YyPYZzu11ftCVpY5img27L9tzR8keVVbX+NqB7UtMzi6jgso9j5OSJAcz1KlKNoB4kASRIPscAThknavG5hRHRx0siuTc+J0NbIECcXQy22oSFRiSU6Inp2LunhOV/Vo14kVCiFlqu+0W6DQb/YA6CXCUfCVEl9ImOckcfiud/3rcsx51fqVJQdSaxovbrKFJzy2NI/UDZjuJvxP/Iam9oQfBTqbIyBTluM981//k1H1ro+lxu9ysAv/Yylj2gvH6JGLPZUgRIBfaQqku48Aj8iOwOUBi0KI1TM/RV2Ag3mOeDsgzgmbj+g352DCIqlVJSm3hsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(508600001)(8936002)(15650500001)(8676002)(52116002)(66556008)(2906002)(66946007)(66476007)(83380400001)(6916009)(36916002)(4326008)(558084003)(6506007)(86362001)(316002)(5660300002)(6486002)(38350700002)(38100700002)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JhqB5HYLRvrh8ijumWH72bx820x2ijsTWi8/KOHe+1UqleUaBsb9Hc9XWCGe?=
 =?us-ascii?Q?TdngueFwidsnfS89l+kCOV5FXiZgh/nlXewWzzhVRsZ5gBUVonvoeGJID5Xx?=
 =?us-ascii?Q?Y2n3g4Kfxjcxzlc9IFNr1TmLmDxUdKD3s67PeDpX32F9lC2j4KMFOhMB0bAB?=
 =?us-ascii?Q?wEFoAo1FkiJZqyHrJh+V/LgrNvtkJocpCk0Gj8S6qBxYi6krrrhlq8ENuxaq?=
 =?us-ascii?Q?pVub4EEimcjJA3qXwaawTBaK41ijkMJfbeUUYJvNnYdvliM3nprIRt96NmjU?=
 =?us-ascii?Q?AGwmsBSKPYJZgwnpCqq2heuxLesm+/t4fapcVtZx62MQJJS8/yIjSe5Jlrfd?=
 =?us-ascii?Q?Wmc4qEeYSmeCMA1SV9Is9Hi9t6CbjcPssgvBwSN2lqVpReeMHH7gAO+emJ/R?=
 =?us-ascii?Q?ROrXaBXCj6FfOXEFj9a+Fo79K9/k11IhKMwFySFfJyH95orjlmVxCgwZGyNU?=
 =?us-ascii?Q?bl5WYZyjCBke/51LK4bzjBv/gxdUozyqOcy83hrusJHM9wCqRb4T2qpx81ZP?=
 =?us-ascii?Q?gj33qH32DwdGIoo5PMXgkc3NJOE0yvwu6OggipT60ky6Gb3e0dYiqmCkeDkp?=
 =?us-ascii?Q?0593aHWtXkSy6ysUNdMlJek9d1dPgq8NY1Otn0pH2ZxPXYzUHCH8fTcZBEvv?=
 =?us-ascii?Q?ge8JERhNBBTbIlZC02jn45U/E5NUgPhLZIjHWHzVehOMIqENKhU5rFiLkiKd?=
 =?us-ascii?Q?5iVDY+hI0TikiLwF3fvueLUxBhGhEv/n71oXQLoylLWjhFDaE/635vHpPa5E?=
 =?us-ascii?Q?N9iEzGqdbf0k3QdkDyrgwsKhSz0izr5TN3plfgFVT5oWa3BbW8DHg1wZ6kxL?=
 =?us-ascii?Q?L8jOLxscAqrwbL8nNhaA3sAyAsf9fHKidO25+j6E9H6x+lXr4gHpFkEvvKkv?=
 =?us-ascii?Q?MYAMC7v0O7RFjlztsqVLaJIKh8w4h8UYaY4u7wxCQI8KXyRUOBwSOPDYiUwX?=
 =?us-ascii?Q?b31kVPpbyYcMKk/pD5lwQO+39Oah1F6qhEymhPyRO9fwu8eTMTFq3TiLz0ki?=
 =?us-ascii?Q?bfIeDkevzVFS0pE4QvQ/fMfcrkRqLYYUbZZvVDfKotwxTROH+gD9wB+usI6A?=
 =?us-ascii?Q?ohepBmPCb759k8NBdKvCyOPgtvp8gYKqwyfvECLgHAOB31WceKBb2umEkoA+?=
 =?us-ascii?Q?ZF2UDvZtdE6sMq9RNQ4CiFaXRVCq4p9tpNFO/XjDtPRSosBdOkb7V0puMJ1s?=
 =?us-ascii?Q?N7GEu0KVPcs620nArfNU/t44xWSnB6vmMkS3wo81fGNW+620blQ5fhU7mNi8?=
 =?us-ascii?Q?aLJ6iCFdGDSJw1UCJnSD/BQw/tGfWCD65iiEbntWCKBtGjxJRNghiIosnN70?=
 =?us-ascii?Q?BEW9DAATF7FkYDEKBVyuLCwfLUsNvdEol7HIpwksjeKBl0+UoyfAtnZCwVnU?=
 =?us-ascii?Q?CHIwMVmOBKki6vWvSyVZfUgcblpne4sT/Emrem33qyXqfQgxYCAHLGU5XmpH?=
 =?us-ascii?Q?a2g4nb9yFpBFKs7aHHg1V38sPMXAIZAxv3BlLiQW7HiNXkdGqHgtvm21lTbe?=
 =?us-ascii?Q?IlEc0wm6/NwfEDETbceH+nHR5aSSwDwWGG4UIQ0kIo1NaI/ByE6OKiVLl1En?=
 =?us-ascii?Q?74WrvxYcjOVSJZoldie6WELqX379N7f1rc/KeegMI9D5N89ilN12N6+kqcCc?=
 =?us-ascii?Q?1DMSaV6ZW8uVy6OuAdrgCaqCEZsOTdnpprYHuoDbYLHvkQOjd9D7THwthOog?=
 =?us-ascii?Q?PyyP1eaHeb50T1hR4Y3eQFKpRWyqDgLeckadSUVHUHAXKFBWscOVGZRwmTtG?=
 =?us-ascii?Q?yPjzqGc8n3u6L7Z3YoZ/GnCsRazY/H0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16e16563-adb5-4131-9ef8-08da32f39466
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 02:11:37.5791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PqShtfzbyCSzflnKzIk0Pcozb1Dynim8FEgnIANTrDsmaZZhmBI/wzQ+BtZWM2h3uyN12w7KTsjJgXo7PYJ3ieipzEKbh1OtOKvb/C0bOf8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3407
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_07:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=724 malwarescore=0
 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205110009
X-Proofpoint-GUID: NeBWkMjLODSYuo1-SEteffhyBuCGiovJ
X-Proofpoint-ORIG-GUID: NeBWkMjLODSYuo1-SEteffhyBuCGiovJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Update lpfc to revision 14.2.0.3

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
