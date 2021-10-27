Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F21C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 03:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5F8B610F8
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 03:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239151AbhJ0Dkh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 23:40:37 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:63536 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239135AbhJ0Dkg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 23:40:36 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R0mqBQ014970;
        Wed, 27 Oct 2021 03:38:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=isE74Mrk9/F5Kk2M9XUB7OOIJ7xwmAyhVmbzNZpUPnc=;
 b=hCbb+ZzB2j2G/zxo975Q0HuRyCwPD2B2eySMAO8+X8gB0n7yyRU1YOUzHfDKjhf30lvr
 R9ebVOhr5p4w++O9i3rkv28ft/VKt23iCWommD+1k8HjQsxTFeVi/0NkIT3c7P2dE8lU
 mEZmzwVum3yXn83CfKTGDilVdKa1Iud8KhtgaROTdSMMtn2tT+aOvwTGD4bYeBwustx8
 Br9BuWIeaRT4aC/P0+SSDoOMgwoe+ymhWnAdfNXEedYovGyoZOiwlkVjIc/acjqneiIj
 eh+g2z0n7NcsD4BlJZnJuRsZTLxckdeehj59W5Db9+CrJzAueKPFdIQI//BcggdEou9c bQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fj0esk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 03:38:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19R3VFPE075503;
        Wed, 27 Oct 2021 03:38:09 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by aserp3030.oracle.com with ESMTP id 3bx4g99jwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 03:38:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hhWce8czuLkbT4mQWhQ6fRripiBmwNmI3k59d6RrEwDfAnPbByfmBNVOVi2QfLacTVl18BGFTvgocwr0G2wCTLaAK2li3BKJblC94W6N/DZjPIaX+Oi/jNPvsm5fXGHhTNXRJJw9pmlbawC9Qu2o796gHQmYgudGliWf44DrbOK2GkEnS8z37dbRjznBCAGN+YOfXtvwL5GsaXvRvJwF8wxfAo04+QkuvOsuMxazWq+PUybrWeE8Df5mI7QL9K7cPKj2sIIhGf6aqf4rAnB69qHTYiqmI9nAmttMKUkUYD57BAPjJH07CG7D+UUQJ6+iBLsBJe8OuJPoML0zlNdi8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=isE74Mrk9/F5Kk2M9XUB7OOIJ7xwmAyhVmbzNZpUPnc=;
 b=SwhPGEi00eSIuY4NFM6AKgMHlK6ce5Dv+UZZBEpVS5DIerBHBHGelqXIWHKi75mheIMWH88JPKbxjvhxv1F4bGEMxsXPnr21UBaKc8RXHUMeV3E2Ih6QHemNh67AERZ7x1llJNA9sdhi6jHZZCEnqi/gQ5DJNqK900pGlbO9b9cxel1edL4maO+MHQxnyYj9oGfjKHmUpeL6yz9ID5EqexD+3JO0K3WrikFQCeYtfLQc0P+/5FLF88aFrEEjTiETnNB9qh6hXTlBZK1mQ4Xvg9s+evqJYj7QbG/WLLyq8KuKRCJtDCkwPSogT7tRJNknYjVruDS6ZRC0Ka1HUJFWuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=isE74Mrk9/F5Kk2M9XUB7OOIJ7xwmAyhVmbzNZpUPnc=;
 b=bQpqQKa86a+TLUJPa8+5Z1sUzcfhtlVkcrncneVbve+ydPArDwAvINX5tJthNeY5/kBEWIIXk4XWsy2sAcBRk5qdT5hi6dvh3p0ESTioF+dgYwEjZXKswxNeosbaDQg7ygc+YSYjsv+KYbQQl7Pm0aVPoeKkyeUMlK9GCMqS7dM=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5450.namprd10.prod.outlook.com (2603:10b6:510:ee::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 03:38:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4649.014; Wed, 27 Oct 2021
 03:38:07 +0000
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        Steve Hagan <steve.hagan@broadcom.com>,
        mpi3mr-drvr-developers <mpi3mr-linuxdrv.pdl@broadcom.com>
Subject: Re: [PATCH 2/7] miscdevice: adding support for MPI3MR_MINOR(243)
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fssn16rp.fsf@ca-mkp.ca.oracle.com>
References: <20210921184600.64427-1-kashyap.desai@broadcom.com>
        <20210921184600.64427-3-kashyap.desai@broadcom.com>
        <yq1h7dw6qsx.fsf@ca-mkp.ca.oracle.com>
        <9e544200d3c6e879ed1f655f0f1ab0db@mail.gmail.com>
Date:   Tue, 26 Oct 2021 23:38:04 -0400
In-Reply-To: <9e544200d3c6e879ed1f655f0f1ab0db@mail.gmail.com> (Kashyap
        Desai's message of "Tue, 26 Oct 2021 16:46:11 +0530")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0104.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::45) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.42) by BYAPR11CA0104.namprd11.prod.outlook.com (2603:10b6:a03:f4::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 27 Oct 2021 03:38:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68d4e617-5449-4f51-5499-08d998fb30a3
X-MS-TrafficTypeDiagnostic: PH0PR10MB5450:
X-Microsoft-Antispam-PRVS: <PH0PR10MB5450AE0689DB5B987614B80F8E859@PH0PR10MB5450.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ylZcblqQl/IT3CscxC9IksugaWtGYcA+egZa1qlJ4W8Q2rHGmySnqKTOO2nUOGif0lKmzpDo5fXYsYpJS4unFrNdJ1xDbyI9WL3qJG+uCIIJGPR4D/6I4tTg8EKkLihxzTGWZzCbqWI2lnhHsOu/L7o5nB6lHLtutpchr6/AYHU0hXNjwBcGvyAwcYctsPC4J1NT3Nt3QHgkWvRoUVyQfJWwfvhlPp4X8KyLfy/I0APkaQFJONf1T2KVTNDuizY6Hj7JrOZsPLtXEv3RSQWOJVP/PC/iJWT6AoAWKSfgl7Ga5OBpJ7TWgBJHEZruJZ503otlo7bbs+/xNh5ehPGi2cKng8UHAAGLX3ZFs8CBMrEix2IZXDgnagoj8h6tSr1iO4Nc+EZI5cQSJ3d9XTjA8G59XQwuOX1JyRjmzIcIqLk4nneWiVR8CW3rcrrOmbMbpSb8H0H7jQcJ1umWGTYOI0W9QVmt7B/b1xxX7v9Ld/+0gt8YGbLPoPROHc90GKliTLvFfhOB78Xoahuwl5ghB/bK+Y1r1pm0XWxIi9D/WfEytCXHCSiHQYXGkED3caMhG0gi8aUkexCjzd9MSQfaHJODl+jmuOqD+NPMEPDd9IA5CG78e65QydyJ18WRs8WbqoTGaFseA451uFDnVwrMpl5IkNrJ+iCheDcgh72c1TwZZCZple4E4R8cX1dfdT2Iz7QzquMqdQ37dNvpYnHFNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(83380400001)(5660300002)(2906002)(26005)(54906003)(6916009)(8676002)(508600001)(316002)(55016002)(4744005)(956004)(66946007)(186003)(52116002)(66476007)(4326008)(38100700002)(38350700002)(36916002)(8936002)(7696005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?85ZaCMhPNrKLtecT3qWQQylTq0h8k9/Cde9TD5+xvMsoBwwcwTmqH+2/gLxs?=
 =?us-ascii?Q?3QmFWIFLgO3DimNJoB8HGS44372UeqQmx1qYNc63phv99Y9z4s/Z6N1M5+nx?=
 =?us-ascii?Q?7RFcifaf2z5W/FVPxgtgLncdMwH2zIXV441x5/HatoQrRfp65LEDaSDyO5lJ?=
 =?us-ascii?Q?VUkzGvdaWRcrp9A3L/DcqIo53dLPXfIPozUfD7fwLxuY56CbNZMQyUhPMECl?=
 =?us-ascii?Q?XPqXZ8me6MQEaRs27iCKaj1w8QaviOfpZPIn9zZHPs3zxqlYzFlukhSVCF0e?=
 =?us-ascii?Q?z6IbdlyV+nUHtCMVlU2BrzHyCryp4QZpTSJniPw9BB5h11ieJCvM7hHuWQzz?=
 =?us-ascii?Q?ZtaiCSr+v/wne5rENWPlFiPupX1eqF8LKsIr1yuGehscvH58bHOErppHjJng?=
 =?us-ascii?Q?b0/PSkfq2xtJ07YmSI+clKFmQxTBziPQdQje3pSe+2nJZp/US6XtFSBFvvXA?=
 =?us-ascii?Q?C2aAqTHmopEyLD6ZYgziz/vHh8vdrCzL2KD9Vvpf0gBAi6izd1huBOp43wze?=
 =?us-ascii?Q?nC5sr5752AChTJvdlWibAJs14l4M4weoGHHArsSOjJgCpg6Ada8CTwaCd+FI?=
 =?us-ascii?Q?1qFApHKyYSkTOlkoaLYoUjd/TqF+nYFxvCLQnmiU0hSU7RQhXXKXMjO+MA/0?=
 =?us-ascii?Q?c1QNfVmaw6a6nE6QmaMiZLYaSTWXNyG05q2sN78C1Uk5YqCx6QB41XtqB2mA?=
 =?us-ascii?Q?6lr1HhlfC1zvVBUQviKQIcULGY35UoAO0B6L+ztoCWsXUzY7ciqPU/DTScuP?=
 =?us-ascii?Q?5NXH9dTKOSHjN05ilygtgJUI9oQwIqKiqn3cfcXA6La5s0h1uC3fS2l9w8jX?=
 =?us-ascii?Q?u+OcB23HPcpgwrEJ+sQw+G9T+yQy03u0mI5QHFyvZbVslD7DLGJDjbMLNpos?=
 =?us-ascii?Q?O5TSQIhY5gqdjyWO1Ca3K5r4hs3ANPI6MWPtwcx3KLNXb0PdnQfq8ae2sOqc?=
 =?us-ascii?Q?OGMVGLzN2yZlccULqtfY7uioYB/ZUirXjCayiYU6rZZaOoljARn+kxB0MODQ?=
 =?us-ascii?Q?A8NCBIhisn2WCVp+/DjdPYWg22GFRqCq6IA0O72RMUlFdUANblVYuIu8h20T?=
 =?us-ascii?Q?yAxvttkrL5DNKkUJ9ktYcJs604ocVgSxkQjjrRQZLKLiUQv2h+ZIgNmf8D7/?=
 =?us-ascii?Q?0/uTGemIBlnp+IJ8Uhu9X95Il01T8kZORGjuLRMhlWdik8nwvJ34Wg7EIgE7?=
 =?us-ascii?Q?lzFoBcmERI6a9EZi24K4LM//MUW5c1IYHPsu9VIPI7NnCTcICmufWkLVDr33?=
 =?us-ascii?Q?VQ9DY6a2T7djALsQedbHO7OatwA97+ENt62y02ZDTFPwPJ3F8h9/bMzmFvx/?=
 =?us-ascii?Q?z3tHqFkf5TO9ulLHVLuUhDBQk5SEFeLLqWqhL6IYnLKkSYjL1GZDuYsmJorz?=
 =?us-ascii?Q?Uk5X51z9f+DobkEOyHKnyr56KHzVh42OXSYkjp6RgNxhZUpTFyoxPt4XnEpp?=
 =?us-ascii?Q?6OfcfEua6qpYAnGfdzDc/cpn4CcFDcheA5RdJPoXf1bOHvQVqgsvOpLskOuJ?=
 =?us-ascii?Q?3ehMrE/w4nNu8ldqgSo1PSLzpibn9EgA3rL189TnGX55KC1ohB2O9uXGI6CT?=
 =?us-ascii?Q?35wg4h/WEDcZM+NeJ17Hgd6QXiNmq9uI1sFUTaVxe59uNcSR/3I60JdethYq?=
 =?us-ascii?Q?w4FbjlOHEeHwqA8AktfO/Pp1wLw7JvwLZdITRdZv+h3oDaG+OCI2zuCI58AA?=
 =?us-ascii?Q?1sZAww=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68d4e617-5449-4f51-5499-08d998fb30a3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 03:38:07.2906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xlLUuP099SXPNCoNuCx6bhhOzOGG9ZveoZSnnI4lg7ule3llQSfnAcYhLqnNXjY/Ygc+bb12Sg6pd8MtJfCzxD/u0JzvIyzjN4t6JmZs+Vw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5450
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10149 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110270018
X-Proofpoint-GUID: 0AkU9YPmtFc1oozqqgk5sa9c-yhjCYy2
X-Proofpoint-ORIG-GUID: 0AkU9YPmtFc1oozqqgk5sa9c-yhjCYy2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Kashyap,

> Immediately dropping ioctl support will create lots of issues for
> Development/Test (within a org + OEM testing).  How about accepting
> updated ioctl patch-set after reviewed-by tag (which will not use
> static MAJOR number) for time being ?

If we were to introduce an ioctl interface for mpi3mr we would never be
able to deprecate it without breaking existing applications.

While I appreciate that it is inconvenient to have to update your
tooling, this is the only chance we have to get the interface right.

-- 
Martin K. Petersen	Oracle Linux Engineering
