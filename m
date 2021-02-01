Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67525C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 22:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34DAD64E93
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 22:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhBAWev (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 17:34:51 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:35376 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbhBAWes (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2021 17:34:48 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 111MTcHG103096;
        Mon, 1 Feb 2021 22:34:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ffgJfmkjVEDO+MRMGWqqfF6y9hlMXBZwo5FWctJv8/s=;
 b=0D5upzZghzZ8UeFF3KpMHZfiWVeBXe2aFJuDf3Slub58tAVFzo1v41szYA8ffQw8Y74t
 fhleFeWoIgn0anFFvJQzNQLUYnqtu9EiWOZZiVX2i6unnN2rdsfAnFXhzdMBdQWbnCXo
 v8IbZvU8wTWPWzQRnYmhJeBeJIGaa7J7VK5XYYqlu92RTvOYVArE3JoUlEYwqDDtdEWB
 SaAXS1gkawQFMgpBJYnUyzrjJfacHfC7NUzG4PZY+4mQ41RNbNxXcRQnPprsQzuYWeSX
 oGj9sWz5eSlVyZz/IX5TP9a3BcoScED/vfQ9Hcbn/DF8264e1KPK0ZTVIFk07Wt6pIXR bA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36cvyar448-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Feb 2021 22:34:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 111MVRRJ175714;
        Mon, 1 Feb 2021 22:33:59 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2053.outbound.protection.outlook.com [104.47.38.53])
        by aserp3030.oracle.com with ESMTP id 36dh1n22wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Feb 2021 22:33:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzC2anq6As2lre8Bffy24OVgUofNQuyXKcQsuA/8cw8944b/NrS6FHZD7f5JgLO9CPtxyGNjXOj/4rdCREcSL8M56tkHWHkYBh+bg+3fpjIQ5OvbTu7ntRVDE9KJL8kufyCxhYxEkXt6Aqyra98YWNCn4wYVmoHrDa9o9V60XqczEkmNe6Ra3B06hecl7d44GCX/Alw4fX2TwtCFT95+EBh9kkaAaMNdyWim/MjunHhoAdQYAU2BlzKSQUlb3qjV2/lGymcGYEMhCjW1E6Snz7JFHT1Vj39wPhU9JUKGA8bbeWMamWpnSWQykGy6VcdW9oXN8SyR4d8rO6gfvKDzkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffgJfmkjVEDO+MRMGWqqfF6y9hlMXBZwo5FWctJv8/s=;
 b=RR90Bql2OkS3oYyTwdX05eW9JH016i5ZHPo2GUdWxnNWL8nyIJi6rK728O65tF1XdIW3H0LBwrpU0OfsUxcTSNDP/Y2gvNMbdmiJsWaZEYaxcTeZhohl9KLK5tGEhMBgseqkNK4/yqz5HA1n4oN0s5CvMXl60y7fVI4VTLdYLnv+Pl93l8UpK/IGgFhjs1YZwPSjFwBob5MNyJJP0jOAomk6vUENUYVKHv/wlZrAcrsuicuopUHwf1O1MwrJ2LEF1hrbC06qBLmHAN7iWxTKnEK28lKGk9CGYxu3qHd9YcGcxzBOnEfSHR5YB4A3oAnMU7vPiEHP2U3BUqgFExgt6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffgJfmkjVEDO+MRMGWqqfF6y9hlMXBZwo5FWctJv8/s=;
 b=YSTBfSBgfn9SChe17+45TNYtGe6iS8jMi1ZaSj1t1cUt+BZ6Frr7Wv7wsrR7fPZIh/BPsLIlaVXPdP4RfElSRZBUjsa36EQ51RvcttWQL2ksVMA7C4ZEUcn/G6j2fXY0LsfMOdjwZ+A+sxX+v5E/r+bWI2M9cyj46AF4v0y342o=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4711.namprd10.prod.outlook.com (2603:10b6:510:3c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Mon, 1 Feb
 2021 22:33:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3805.026; Mon, 1 Feb 2021
 22:33:57 +0000
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V7 00/13] blk-mq/scsi: tracking device queue depth via
 sbitmap
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1im7bwiif.fsf@ca-mkp.ca.oracle.com>
References: <20210122023317.687987-1-ming.lei@redhat.com>
        <yq1a6sr1v87.fsf@ca-mkp.ca.oracle.com> <20210131115245.GA1979183@T590>
Date:   Mon, 01 Feb 2021 17:33:52 -0500
In-Reply-To: <20210131115245.GA1979183@T590> (Ming Lei's message of "Sun, 31
        Jan 2021 19:52:45 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH2PR08CA0010.namprd08.prod.outlook.com
 (2603:10b6:610:5a::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH2PR08CA0010.namprd08.prod.outlook.com (2603:10b6:610:5a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Mon, 1 Feb 2021 22:33:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8e409fb-97b5-48d7-4b37-08d8c70176de
X-MS-TrafficTypeDiagnostic: PH0PR10MB4711:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4711B5CF861D8AB2F31F84BE8EB69@PH0PR10MB4711.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U497ZGWlpk5yUbeiq+M9TNqI+W8lQF/4EaNus4NOH8lsSKvPODYZbfp891hJrFihP27hXjhjSEiC0W1F8YYp2zldupPpCVKM77VmesAD8a5gQ9KU4yjscsB8gqd9QzefSeVFVteoqBahV+1MCD35UDjq0KRBReSGYAe3SlyIEnE7416bbCiT8rXIbe4l4kD76mhAe/GynvY/IvjkZJQ8KzdImMvrSE0sCM308Tk07sN0Ju+U5cuKF3CwOFyQbjvUKh2odWZVE2e6QLTGUe9/57DLbFZJ1pa9b8UeHdQOATXWDPgRsqths4087Oip0JkY6h/YcT7UmrgYfUOJ/N1nhDkUW2U779CQGjC0dbhlb/UE92jnjk4xAjKhLYBbAHUEPWO6kMMepWkJj+RczhCCEVWdKK+PE8Lshutx9jXoeQlY09qkUSziQrCsQsgkvvhgqtjaJmIaZ8gZj9YoTEizI2M/e2dU4G9NTSEUQAxaSoSw96GEI6J52twvqoqsR8A4fDXqUPkz6frC9GOcIlVJKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(376002)(39860400002)(366004)(4744005)(5660300002)(186003)(6666004)(2906002)(86362001)(6916009)(16526019)(8936002)(7696005)(36916002)(52116002)(83380400001)(8676002)(316002)(26005)(66946007)(66556008)(66476007)(55016002)(478600001)(4326008)(54906003)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lFica6wWZcI5IJwtEpCQ0A3ivyDgo82ht1QlL5Qp0FmkTvsAECCWTuGAM67O?=
 =?us-ascii?Q?Agm1ABl/HcF0iXkoDmU7dXhMjgZi9PMTMCaXyDlsWdSRxyonZpKNj/EOONdL?=
 =?us-ascii?Q?qbFfYYTM4U03e94PE06Z5K5mSb+sVwBgW4AoitC4+pb32XsOJou51t3Woc7B?=
 =?us-ascii?Q?0z1gP1hQ+gkkfmZoR01qEPEEg66dJieJ/n+seZPH9Busq4gB2xtlquytgX2e?=
 =?us-ascii?Q?xd2AGYUeWRbTg6EhaF9sEk2uqQ0yotdCXpJy1WEM4DLQUNSoMQcsJq+5176u?=
 =?us-ascii?Q?TFwiGMJbxr7UM2LOJElqm+qDreaGl5lwky6VFXWWz22ijB/6Rx97gcLJk3kU?=
 =?us-ascii?Q?l9g1KD2S/wBmLJvewHGjhSMoUUbZdhmYteIQ5fNIgrHIgWmCqvEzhSMQ4O5a?=
 =?us-ascii?Q?qsQK9UyDtty1RkFuOPoJ7V7jAG5nSFmr6/ajp9Ij28+wg1NQ4q5OEvuFDqeK?=
 =?us-ascii?Q?7tcJy+QvrHhK9TkglzdfS11uEQbxPVsaDw/aQPdKATKDHfEf2MOA5LO2ynRx?=
 =?us-ascii?Q?sb0qIFEE5hD9O0p8rAs8C1uMtpqfMH8QgiBXW87xAJPDipF72EOdnOt+hACH?=
 =?us-ascii?Q?CMLKH6iiiFZoIixIscxqSbZd5Osx8evVfIhek7fhQ8jjEzi50kvI5wcvKAUZ?=
 =?us-ascii?Q?2VWuY9vC+QvX6HXPYLQ4qIQoiLJifZSnTjwwcnHb9WCkzocHUZiAE+4heblg?=
 =?us-ascii?Q?waJZwYhfoxmr5+FcJiATkZRJATLtUmg8JL+8Dnat3ysrkN78+yjZgF1NvawQ?=
 =?us-ascii?Q?oUdfF15BciFQfeBdHTgNiK3tbmNwheJQHR6PF559+7VT1tfi4CrZNU7bG5+K?=
 =?us-ascii?Q?xXZA53eldw4FcaRFaeOqiqUYoFehVsw0BRFwlm7HGEkotcKyFDV0zi6fZF3e?=
 =?us-ascii?Q?L47Ie4aTH0z8UAQwfiDBn6JBHE+7igDOtTxu8RhXPJYnRVP5nNw28BXAgSAq?=
 =?us-ascii?Q?rhGEUezONbRu6Omp9Np67vs479Q2xZgrrw/8g/3fq0xtbHKVDRfrdYlTgXYt?=
 =?us-ascii?Q?fxQqF31v+V96A6Ia3tlhFFrwGVVAXs6diXw697QXlYtYJ7v2NLZrirInSAPD?=
 =?us-ascii?Q?gk+3LpSu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8e409fb-97b5-48d7-4b37-08d8c70176de
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2021 22:33:57.7055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aWXtoVk/AOiDV/ZManaGw8pT6tLA1oZephjT4iglqBQJTFKCi62Dlez0Uywyzr1MIe/VP0BjDUrXicwPNSlOsKcwgP0j5LcwC964KGcJH7s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4711
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102010122
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ming,

> BTW, which tree are you based for applying this patchset?

5.12/scsi-queue

> I apply the patchset against for-5.12/block, and run it on kvm with
> 'megasas' device(LSI MegaRAID SAS 1078), looks it works well, and not
> see the hang issue.

I tried with for-5.12/block and it still breaks for me. Things work fine
up until:

scsi: core: Replace sdev->device_busy with sbitmap

After that patch is applied no disks are discovered on my SAS/FC hosts.

-- 
Martin K. Petersen	Oracle Linux Engineering
