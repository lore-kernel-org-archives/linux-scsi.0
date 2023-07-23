Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5032EC41513
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Jul 2023 20:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjGWUgk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Jul 2023 16:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjGWUgj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jul 2023 16:36:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F199E47;
        Sun, 23 Jul 2023 13:36:38 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NItDKb009974;
        Sun, 23 Jul 2023 20:36:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=WyaUU/aM868WFuxu3ILOJ3XkY84Gubl8kiqL+CCfa4M=;
 b=p42JWA/Piz+RBdhLMr2YmNashgJAGvbLl3njpYNy5FX705OgLOv8PuoPe7VN7Vkj40ZI
 VbN9oRFyouzycSWPHJ8v0/eW8o5SgYDx9Ty9zxK0iqF6SBYBwTxjwnUZEhry7G8lZUMf
 In5GFb77kQHLwNQzHe8GANpH4xfVc99UBX4/YY2LYDHwQkLh5yZJ3YKIDMT0b1BBKQ7H
 i+s7lAfpjzOXjL25zz3pDSUDD3sz7lNTyeZEp++H7H3D+b+ib4C0oUNRO5PmHmUjD7X/
 B85z2lO/+Oa0jrVLDfM0JZf9CbFxyRNLDqztW2Z/wsK2a1RS/qjpMQy6IyapMvwlUG/C /A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s061c1j17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jul 2023 20:36:19 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36NFGKbU028215;
        Sun, 23 Jul 2023 20:36:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j8y310-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jul 2023 20:36:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkbVTa/BcNsiaeo0Z4WU6COVnBLMfmLZpDCK30z0UcXv19U3oa8fqEEm61m2w/7gwT/9Uj9YqLREQZo2gNVKI0LWMuZ2N6pRPnUoh2FZTX2iN/sH2oqekZvKZJTIaMtvxO1DL58j30ywA56YxWp+Ndoj/zZ02SJYzVo/oXeQK5shQ9OqfduDWsM/IfjleuAfcT8N8xZ5ZEUx5Ngw3RrsliUaX56IsXnMYp3YnUYHZNHMpwOo1fIUgBrS/QmKnAv5+cxwTGmrRNPML7Dq4xn2u3fKoaATKoWPhx9JnVL2r5hsnjGfVnpa+obqhFGGJm3cfdQ8ZjnaLilxhgWi8XUkjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WyaUU/aM868WFuxu3ILOJ3XkY84Gubl8kiqL+CCfa4M=;
 b=SvDPL/QqHfCwf3q911XCo8QwRAhdHfrKJKiwiE5IoWjicL1DQQm6ycQ+wKeD3qBhu2Y4nAX7eQ3B39ifH3ztJ9QftqznK/wk8FFhzrx9SnG4gwdYrc6RZy4IzZCpM2gnNF9lmLTQjVGAZTULA4CF6OkjFaNNK0iiNrbtxHHJhPVeNsxcTqUE5VQQBKTmPSGg6BhH3lnswEkBfcSl4lvm4k5E/uzDBxcLSfJSBChJSrFsDkwZkcqhMVqS806GB55QZAe+5hCnbdGCj5klI7+JcsirG4QvF/mdiVAxANIU82fmXnkgTbBUDJevktYg706KHuZ0oEcxDPQ9fh+Ic5XL5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WyaUU/aM868WFuxu3ILOJ3XkY84Gubl8kiqL+CCfa4M=;
 b=aVH4HlwkIxDVVPDTjeoMx3fJh3yeGxFSmvmYWuPwmk3rFnn2+cd561RME1wbYRJp1fvnogs3e1gbN2e+LOZrJAd7jnSMjuVannQfP1wFmgbRyUYNCpyPSZ0TRKFWaRxLKcOnS6rrIoM913pYXaKcVN66mw7UGf0z3b3lVx5BAow=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by PH7PR10MB6309.namprd10.prod.outlook.com (2603:10b6:510:1b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.30; Sun, 23 Jul
 2023 20:36:15 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::f82a:5d0:624d:9536]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::f82a:5d0:624d:9536%7]) with mapi id 15.20.6609.030; Sun, 23 Jul 2023
 20:36:15 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        Douglas Gilbert <dgilbert@interlog.com>,
        stable@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        John Garry <john.g.garry@oracle.com>,
        Benjamin Block <bblock@linux.ibm.com>
Subject: Re: [PATCH 1/3] scsi: core: Fix the scsi_set_resid() documentation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1edky4b7v.fsf@ca-mkp.ca.oracle.com>
References: <20230721160154.874010-1-bvanassche@acm.org>
        <20230721160154.874010-2-bvanassche@acm.org>
Date:   Sun, 23 Jul 2023 16:36:12 -0400
In-Reply-To: <20230721160154.874010-2-bvanassche@acm.org> (Bart Van Assche's
        message of "Fri, 21 Jul 2023 09:01:32 -0700")
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0309.namprd03.prod.outlook.com
 (2603:10b6:610:118::30) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|PH7PR10MB6309:EE_
X-MS-Office365-Filtering-Correlation-Id: a438b17a-498a-4403-84f7-08db8bbc75f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N2k1HrgkKj02SX07iYNMnWvMvnXMaVqbLgr/acU/TQYX9p4EXjGdqATuet05OzTe7qfCF8V9biODker0yjCliHyLsaizp65nGjR3NjMcln5Mxj5bf2l9uTzoOl/eJETME9jHFJ8oWP84nZ9Kbw9qBoflUoZ+wXIPVISoGOSsBY+5MqI5sJ1aML4yB5AA6BC7uzq4NW2YVswSy7UOd+q1zX6iny5fuv71xu4kt24kglXNV7VdQ+NkB+mcyTHAxGsYHyrQxroEOxDar6wKiuslT4biB0HOyyUq5cjfKDd3hsr/ArajDqpEosfSOgQLCsRJtf5UBLciYbsS8m7xfPoOS9HQ9V3UdI4+p4urBt9jwub+QsdgAbN09etC3uj7hwqMNcTTC59o7b+EBhU+C5Emj31019bRLfaw0JHjccP83hQ0nZEENMFyzNAsFLr2OXLFv8ui9qy5P/wibW0pfu1IaY7hArxO8fja+hSf5592/qQU6JHopihehR7ByDndbwl1sTWvlnR2GIsH/493XjE7r6yDDYsG7IJB9q/M719mcWI8JXszpBQODoZIdXuv5tHI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(376002)(39860400002)(136003)(451199021)(38100700002)(66946007)(8936002)(8676002)(5660300002)(54906003)(478600001)(6916009)(66556008)(66476007)(4326008)(316002)(41300700001)(186003)(26005)(6506007)(6486002)(6512007)(6666004)(36916002)(2906002)(4744005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?maZs2qMl9t3tN5Co+2sKH7a3ZUpudqt0VhwwNDquVVbFTvaFYhA/VOk85qTc?=
 =?us-ascii?Q?ZGWXEB971EK1AZA+XOvDzlK4AMQ1fgGbbf7LARBrAvDAk6kOF9x64eqLmnm2?=
 =?us-ascii?Q?K9xPjJutSxT+qFHmJoz7R6uaIvHglZ2jeU6rn/2CIvXKxDzMy3uNdhftIhmb?=
 =?us-ascii?Q?PBLVnPAT9ZDJ+xdW5u6hfmQLGDZ7WlwMz/YXvpKrf7CQJG1MHIZUljbU3Bd2?=
 =?us-ascii?Q?IeXOyAVNHYJFR0M4mNRtEmuRadv28Rq36QTyWFYI/ARnNklH4snIy8EGvLBa?=
 =?us-ascii?Q?4KmXfNH2I5fOyaYfkoBEBy4kMPAp+tezxV+Lr6SzYaHIq27OTjapB/06O0+P?=
 =?us-ascii?Q?uOU6Sn65/5vwlO0cf4ZKX4ikOqgS9+7qb23FxvopWpj9zezh9w+Pbbsy6kfx?=
 =?us-ascii?Q?JJ9UU8Kjmka9JAiAFRz8DiidBVsZA9CNwtVRhw6ahzl4+JfVCUlzetzbmQwv?=
 =?us-ascii?Q?mWy7WvV5WkUUegvSF1opjpX8jOzkIPoPmPBI3Du8AqsMK6QiINzybO7GLjKA?=
 =?us-ascii?Q?Gf55o9onmjyD3GLWIr+tpnA4emKDLZ6tZyxEadA6E6LopX5I89ZsyPPXN+Zg?=
 =?us-ascii?Q?lJjV9A3+UpPml4pB7BaWbcqN9TuDHOPxkmnJf0HSiUvygEOppUnMNvdofFex?=
 =?us-ascii?Q?7A7nl1I6FLHj7bG4jkeXp3/RB2vveV3FN2MAVhtvIFBuNCqY2smZk9eS1Sgl?=
 =?us-ascii?Q?w05CoIHkCTQi4YJ+Zn0gqc4NVBVgM4zecujGYcJK1tAZwPxWzdt4Il7b7j0f?=
 =?us-ascii?Q?/Ye2RwMcRZ58ny083RH06Hc1GykIwmuTf2cZv+sBo41oxorWqhOP3CT7jKkZ?=
 =?us-ascii?Q?iGozZ2YsOB8SmhluF0CYDKdDEU0QOZtT/ffp3BdEk27GniDMwpgKk1zb8JU4?=
 =?us-ascii?Q?zh572tdIjWVARmXzzVKBdoFUrzO0u+Hrwmq9qPr1Er8igqXOECnXy/ffDIRN?=
 =?us-ascii?Q?89WkzGyRGNigCDL+FCR09caja70F5Wdk0IiVF6Q7h3TBWnYlW7hCt2s1AErL?=
 =?us-ascii?Q?539kI6kWDV9Sph6uRavIuhGH5W45pjY2OVmHtyzc89mSvgRn0MAL66AezFRQ?=
 =?us-ascii?Q?IUBzeqHM7S5KVTb56oTKfOt/zhY1hdeIvk0uns0zTu7DAP93+nSkBkWVedRx?=
 =?us-ascii?Q?25F3qLbWhmi4i7ToHFPhheVwLJs7Zh5reXKV3yq/55j/NKIZuxoG34aBc28O?=
 =?us-ascii?Q?Iyt7TuFizApWahiwORQBff/JK5ZB8SbOdLnG4CIjXeJsI4Xxks8II8S6A4jo?=
 =?us-ascii?Q?xD9CHW1frsqW6UGi+s9dGJzkqTCS36D+Pu56PMiVPx3PeI9hJ8S07QK59NVu?=
 =?us-ascii?Q?mvEe+MJxh0eqdO/C/LbrnbGc+3oY0OQMmoe6SsUCkil7jqwsaBVxLRFiDKnW?=
 =?us-ascii?Q?fwV/k+HwVva2hnD2dJpCIVwl7Kty++6IXkEZrjr3YiDlOghY6njtPCZ8QARM?=
 =?us-ascii?Q?X/pyuJjPXXoSG4nGCPkMw9AoNZjbB6bZ4smp+ioAbWSg9yRHHYYLXALOTC+h?=
 =?us-ascii?Q?5uzLbVa4uoBLc/+5V/0iJ6u/Ks9DAWIoqXMi1Drr1RqKtO45e2xPPtUFMTJl?=
 =?us-ascii?Q?tjkppKPaobvXhWUbRW+RbreGPzwuqCofOWNM3Nu3q91U//Z+a1JlRBUOwhE2?=
 =?us-ascii?Q?7Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: bj6/uc8omJ6Cp7lPA2xfnUhEKYR2nEpX51N3MMnkSEnT7+2og2p2I5YyNjF/uoBDwhK6mbO6L8dOjNvEl5+PRyvsE7YxOLykDnXb6GZLmLdVrppQOI9cDWPgg9vl6o/+fJMtt7K2oS0mzRfFebk9eOsiVVfqLnw222m1AWUe9BTHquxYXmTUHVmAo1F5qQMoQoZ4lv8HkYa/QRp9R+o6HTfnCyDzauNrbdLYERqLIeI7DiuwQ0OI5x1sG2KOAjk2Vg8Y1lgZKx8HYRSGbbTutYwRIWl9t9GaqTUWhkGxNjfrUUMZw3ydn2USreK6TUyLi3ygfeDRxiGa58/ufvxQOvSM7tFjGvCg3QVCydhkQHCIPwDanmXUEEZtMY2FjFIklIF2OZhFMVFVliV9V3tmYxvcIr9J1dgxkmJvs6v2QuSRHZJKtTDz53MCzOf/djFp41L+2ugBtdE3Zq/Ou7ReGBw2ViwEZnGdsyIIuYEz+sVcAT5mmRyktYoeqX9Tebljd574GaU4TQF2tdj+UIHw8y16CtRoZCMcLZLJGDBk+UnYBU6EJU/mU8sUW6N0DScZEzVCo2i5txqcB7RFEQCUwJcAFiy4uLWr0Fw3o21aoulTq5nE3xatLPxHrfc+nhMDUShlkGwtDlACaf+OScT3i7suLmm//CR2BA+IPgkffyCtTQNHrJtOPLgMdQ/S2+s4Z6FeZhW91qiNulCkIGgg0NZ/aZbZ/t8YXAOie1W64m4wDuiDRiHZ5V5oWyg9h4zfwrXpJ1F8hN3bJtoCjoQwTwxeKHG8fnBVDrNqbkH/adFdNJUtpxHsBrYSidGf7M26gO2eoCRp7T4JJCQV+8V8ZIpxBXEZr0ElSmROAmdtmrbuT4LFzETxA5fkM7lAitUsXluZnedFwpcWnxD5/R8e+CMhYRpNwZA8iQ3tUgElesE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a438b17a-498a-4403-84f7-08db8bbc75f8
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2023 20:36:15.3204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F9/ZG3UlHgBbybkuyzWj2xQKfsAnZUI7TkVmGJFkWzldCinMCS0Rq8leE7hz6LZrSrvA8SSC76k6WoDfp+EyF0Egk2lYI4Z3k70ihaeLXhQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6309
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-23_08,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=932 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307230193
X-Proofpoint-ORIG-GUID: Fc1xz-MXATJj1D6f2NM_5JoMTAj4RKfA
X-Proofpoint-GUID: Fc1xz-MXATJj1D6f2NM_5JoMTAj4RKfA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Because scsi_finish_command() subtracts the residual from the buffer
> length, residual overflows must not be reported. Reflect this in the
> SCSI documentation. See also commit 9237f04e12cc ("scsi: core: Fix
> scsi_get/set_resid() interface")

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
