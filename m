Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E26C7EE2D
	for <linux-scsi@archiver.kernel.org>; Wed, 31 May 2023 15:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbjEaPUZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 May 2023 11:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbjEaPT6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2023 11:19:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3EEC0;
        Wed, 31 May 2023 08:19:57 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VERVre027743;
        Wed, 31 May 2023 15:19:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=0li6mCcF0f8x8siCqzssTwE/hGzFr+m1no3UfLjFY0k=;
 b=WYlgjyyof5moElnJFc5PVLREiMnWk/IAhIjn4wKfPOaiBohmPkgLS1CpX7trZXVIifdt
 AnEe8EA4i20jmWJ8bARiU5D6s63jXEYFj3lpI60P3XXptjegeYtHW3d5XeDGQMvjJ3wX
 WOOgcUCTWXN1pnEjt3atjAc8SZVMhtywWlOkLOyw79LF21ODopdixcmGW8/4wm2bmalv
 flnvfcKkEa0ofRUj09o1EKGQxMXQcpwMYCbvg8oTFUPZa+0LVTkgdAqMikbc6N4iXZAC
 q6RfuxcROohcs/O1fX2KzzsVb2Ee5BwHNfs5Aw7+y+aEstRiRop8Xvo1CZrvWxUTZJ0c Dg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhwwe2jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 15:19:53 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34VEJ0mo029993;
        Wed, 31 May 2023 15:19:51 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a6fenc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 15:19:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KY/zRgq4kdWAFk765mtmmL5ubeJmVjx5Blr2TXOoxyGr3y3pV6V4WRS/FnD2+aMk2N9dVNmj1FxgNLfuVdGDRKDS+xzLLZ6vxKTe2zW6elFOw64aVh86QnoMYGiIsrvWB2J91d6VimaKqyQD7r7biY1P561VkKpXHY2ZvDD0Bydm9t5cIow85gBLPqhInZzDKo+fVvgJeYnPb/woyq+/xvK1XCn1cmlagkTQn+woH5Vqh1jRn+JyWAgcOxQ6gcB1q9/8HQFxqrX/9N6TQkMZy4Uz5aRV/izvGtq94qvQVo7BDolsNZZ5oJuqeO3AhxwHeBtZuAk59nY8TFjwtyaiGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0li6mCcF0f8x8siCqzssTwE/hGzFr+m1no3UfLjFY0k=;
 b=ZfFBf8RxLPK34m4Fv/LW3Y2nteaL5qGAhXyABy64PiUkFGOjHKpSkuKzbcxohgp7D9k6qfliywVOj//ds17ArdToom7ufUj+W6OVzr24RaVm1k/oFoK7dpXdH550JFw23qmjENAHRF4mTPf+0oGgb4DkwplEU8kXD61tSYnauxelkS9z/eqDapRM7qJhAvdrmF5hfxS4ORs6Hae8q1MhvIXK2noSXO0yRLa+SFd+t/Lf8h05xEzAHhFcoDXTibmLq1jSV4oLGNaR1F5VBRfQiIOINrAeOkDZXCoA1RXmBZ9QWdfA7HqaZ9hxlci95n85QmQ30rP+osF7O05rYTGd+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0li6mCcF0f8x8siCqzssTwE/hGzFr+m1no3UfLjFY0k=;
 b=WTLEbV+jHDSXCeJocqIXashqfkC8M5j70p/+oZ+XgA5vsnFrySwvM7/vscLPxkDWlkhk4Dx8sf3dv3jMOQJqdsWU7kufVvi5bRfE3vNDpKnWpsjN1CPLbOU+BAyaUIfqhflZPQixsAZDr8JMo2RWQBy6w72NVuxWvl/zgsIKLrQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA1PR10MB7791.namprd10.prod.outlook.com (2603:10b6:806:3a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 15:19:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 15:19:49 +0000
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: fix end of loop test
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wn0ofrzr.fsf@ca-mkp.ca.oracle.com>
References: <cea5a62f-b873-4347-8f8e-c67527ced8d2@kili.mountain>
Date:   Wed, 31 May 2023 11:19:47 -0400
In-Reply-To: <cea5a62f-b873-4347-8f8e-c67527ced8d2@kili.mountain> (Dan
        Carpenter's message of "Mon, 22 May 2023 14:09:17 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SA1PR02CA0019.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA1PR10MB7791:EE_
X-MS-Office365-Filtering-Correlation-Id: 74b6079a-b7f1-4467-03cd-08db61ea7980
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C0FhAoz7obrA/bey6iF3aP6LLNG5W2IYgU0nqGf+KYyU1zF/lbXXd6yJtJlMIe910COiZGzq0NxGZFVNl1Wc8tM+7SbU0MqVgSflOXpSLrq2Ef2aH4I3Vig/v0RHZtBh0mlTonZJ68yOEZymqoLKw8r5ho795DWZ3BhULJLrJ23fvWenGbtyC3kW2CsUwZcxxf1DT7ascAczEWAQxn5gFzWCDar+ul9N3XUhGt+M9pGezKQIrabAYyUDPXwfMv29dIBIzsbhSk377e58mbO9GG+/lHzjYw+T+jQNxaa08yC7IxNr02fJPlQtsG0+slEcRERZHJ35Rg/vsp3+or2jZwBJvSxg94gBKMRS176Kl9qKX2K2MLXjih7aF8BGryilDQhZW4K9d3/DLX6GhDjSi0ipHoCXEMINtO+xK2VhrB9sS3606kKweHL286zux9eq182LliWfq311IviaVAkBnxdkudwnCsDZ5aFEVaRSw5GLib10Apv0B5V4k0Top97EZBctcgyqmgJnK6gjvjpV6Oc5cxzDmejaBu+mLbZ6bUtsuDuPWsSfXZAzp5qpl9lN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(346002)(366004)(376002)(136003)(451199021)(38100700002)(83380400001)(41300700001)(36916002)(6512007)(6506007)(26005)(6486002)(186003)(54906003)(8676002)(478600001)(66946007)(66476007)(66556008)(6916009)(4326008)(316002)(5660300002)(8936002)(86362001)(2906002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p9+JdaIRDl5sCCtMMc8ZlG07GU7a2cgpMbVNJ204VycAiHE/ZxW4UiaZwhNK?=
 =?us-ascii?Q?T/zagH+61t0S3eZfHz0xEnGgx16rF/I1zxkAhOHD5mMt8fkhCdH+tN2RMuxp?=
 =?us-ascii?Q?waFsEDE/sQ7RefX6p0NKzYnJCN0QKLU7YChkPm7dIdSuOK4/Un304dwWIaAH?=
 =?us-ascii?Q?ljQwU4rUipqbT+HES2cyvyrO7OWKco48ZLOFvoGEW5onqNLS8Nklm+GVkZjo?=
 =?us-ascii?Q?6/rhtOthz+MXMnASGQ6jHJgZGb6aTj8I+lriJMj6TUBMUUJf0Q6ZShpBGSPS?=
 =?us-ascii?Q?v22KNnsOYVWNnmXzYnFf+Edjsj8ytQ+okARMKouXvW9HrUaDmgrjC2kqwfRh?=
 =?us-ascii?Q?i8H+8J1Kry7WZoZ3gfRY2zEQLhScL9lW/2npGVHx1VMUJ2rFzG3ohXsmh7Rb?=
 =?us-ascii?Q?18FoKPX56aens87bRbiXrBEq9C4I1ckg5M/HMdDk0vLtH7CDQ3Cw628GJ55v?=
 =?us-ascii?Q?4O316E140ZV+c6HGxFi9FkciB6u4sxrnyKNKX4yMELG4PheGmqTBgQkY+fDf?=
 =?us-ascii?Q?HGdKSkuH+p9SB9XqjAcjPdP4ZRtNKMLIjVQg7jgw2gujXSWZ8PDxTOeel2dp?=
 =?us-ascii?Q?VhITP9cKM1b3fT5nNR6lyRoTg4lEMkTas0n/ctNs5xfF9eAi+j11nnw5LFfp?=
 =?us-ascii?Q?x/ZvyjcVhFVChDfPy399gGUJmROFHp0/lCzH8yy2/Bxp1uHPS16oTGQKFfG1?=
 =?us-ascii?Q?GabGLXU5YAezj21RzoC+vyW5vEmxYDUyAEQQ3InqRLP3+gXDydlmXiwOsPBI?=
 =?us-ascii?Q?50UlTxZQYIpwEs9mfWOIvRtWITREyKSHb4KRBazlKFxpQCj9AvQ0SSQX/0Ym?=
 =?us-ascii?Q?nznFqAvIdDIlcWh3VLGnsecs4zpqi1ofpvIO8SKeoMXiYojtK7SPJQJqqJI+?=
 =?us-ascii?Q?MxZsnkl4sr8JxIqCW67EUPSB7DN2VhsDw9e/EiWETnCD5opPWvhkLeZmpFXn?=
 =?us-ascii?Q?OSPCmTjQbt1EfXBAnn9qAby7ybesVSSet3thwGQ8QkLlTr07D+EWyyx/kUeV?=
 =?us-ascii?Q?KvFr/PYL5rb5YDO5X+fdqRnTt8fWDXibMMwcpAwlNCfykoviMSM8KlCSI04M?=
 =?us-ascii?Q?anFeSbbLycc+m9rz6zNpJ42sttHSI5TcxRUg6Eym9BnaQr8kwHrBWcAqlRe8?=
 =?us-ascii?Q?9eev5orOhdclcOMirH3wfl9TSF4ll+ZZRmva4BOwZc6j9/g6LNUMTuQoAFL1?=
 =?us-ascii?Q?iL9dUBTU/cXsA31VO1knMgpt/mRI3remxF4UCxnAIqo43egx0VoFCkz2rUW3?=
 =?us-ascii?Q?dMxepy2deY2oqfTf02cjt1/lkQxO4TUuVyH3OuZ7OMBbAY2BB2e3QYSaGLWy?=
 =?us-ascii?Q?v2WM7hUBxf7dKjZieSJ4q223fgUjx05sTgjq6cmOfhg69q4RKP5KlLARL6yz?=
 =?us-ascii?Q?UYBhScl64c7zhow23I6RhDI+KPsrQK72BWQiiV94ymXRKj/sAKkP5RDQojAT?=
 =?us-ascii?Q?A0H5Np2KC/gLAfu+5etIuByFjr6NeFIV9vLBjvHR88z+C7AA3JLFSbZALBU8?=
 =?us-ascii?Q?ga4MvV68CvcaaFBBuhjErCyhgwJsXnwwBcRY5ka1FGkwqxoY2aHNIc5JIN4x?=
 =?us-ascii?Q?rx8prH5V32b+jRK/szUUNpElp/L/EmuV7rQgo1vk8bAB4pbBBtEVWFbVjGeY?=
 =?us-ascii?Q?/A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +DxgpAS6tcapf+WRgP4oW2f5rATBXAjRG9XtthCD8RKleHldwplWGgNEDE77JrvO9WP24Va+6P6zmfgSqsx7DZZiKQm0qER40ptB9loY/w1PNVRx1cTTV9MHpUMxI1l8uBvJzJpI20y2NP5zBmSpBHUPA/wm/Cozflizibpc28l605KtIZFtI7yVQZfqaOlZj626KKBxUB3gXcfoVoyKTrvSPrMvv7pGOtVJTu0zyneRi/wxdQcOws8xUBjQ1t+NoVHEUGKnyD0nPcrgMzCo5d0lZr3I1UcDTE5106BGo/OC+kqA+z5EJXxC4gEwxc5x7wKuZteXYHrdyNymLUxPvJ6olQrb/2gA0UyRD2veUljUNkusJmqBVto4Ym40zoAunBSDQiZl/rTTfuVqxLz1PIN5+eEzRTKKAzd95I3LPGbBrvckqENrCGFVE0J6PzrK6FVjV5vFdAFDuhGlesRmGNizirzFbCSBCEH5ufDgIe9tFh+vjrxZ8s58MGs+ReaoKYhGtMygVFF9XAK1uhn8RSt4JC7gknnRhPv27yrJR9m86ORpR8x23xgSgl+WRNkEJjeH8nR3WM0RKrK2GtFYfFYQ73qCYfgBf5f3q1k02EfX4pVOhJCh08RPI9UNEzoRzvxEZl7ov3dzrIOEzhyjPasHXfOke+XqRSQBMepzNZfww4OVGVJ8T39vStvsp67nKQkkxHR48s9Hj7DnLWRl41B0YxFyUZQ//CTZHxqpvNYv/sczI4wbt2RJBnyvHkbkpsoR8vAUjMtx4gi/dDSHeolgfNqniFvbg1BLi72+X9fU9+y+qmQkm40NsL5tcZCtjg/QsyaygBYs4sTADEWfiuKZ5eZmskP8LAhgG2sjfm8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74b6079a-b7f1-4467-03cd-08db61ea7980
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 15:19:49.3042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SOi03sEGIirfvzrqCgxQEn5DqaKdJJp3R1pVMQDvL5w1emx+Xlhvgjo2AaCyOtpwprdCcyPuklOr6JWqYGP1a7OZ1xo1cfBEli/8cpJDXM8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7791
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_10,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=704 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305310130
X-Proofpoint-ORIG-GUID: XNfxb7NyyLRLaZuCX1ihSCK2zv0XZc46
X-Proofpoint-GUID: XNfxb7NyyLRLaZuCX1ihSCK2zv0XZc46
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> This loop will exit successfully when "found" is false or in the
> failure case it times out with "wait_iter" set to -1. The test for
> timeouts is impossible as is.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
