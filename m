Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C30F6EB64DD
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbjGKVqj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbjGKVqg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:46:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52231704
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:46:35 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BIDBrS010948;
        Tue, 11 Jul 2023 21:46:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=iQ0IQZqvJ1rjm9pk/VyxIDGiaRZFZ8XkHdPjzGMcPKY=;
 b=iZLu2EfudntDogUEL8k5ct+KD+fpJHsmGqGpxZhAoIxc+csEwMmVkgKBhhtpu1FxCQVs
 UpJlaUg1SAkTTXl3EOBXCQ6xrO/RSKJtB/CBrWq4ekOYSYX1xChoLg5+E2qQwSQ69EiU
 u2Em6P+yUwe8EG5lGYV+WCuA5wTvBijoeqIUs1F4cy+055ghOfcssgwExDGkGmY2Jl5Z
 IiGPDw8CMMf7pejFMrxiCQrhOlCC/hm4tA1lG4gcjN3Xt3rqzjYclWv7QH0iMJIqftL4
 bmGxHemrM592mbFq9eIUZ7RMzz086faxhxTaDw9+t6B0nFK4r1np6J3OEpIC55eDDjPn IA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrfj63wt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:27 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BJvGQL007159;
        Tue, 11 Jul 2023 21:46:26 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx85h0pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhmQuIT3Ht9n36ZPcn8WR4rbJ+eW5WrNMPLibzMgeLoGdCfbRyoK3B+0evrwAoT0BZQ78CVBZNAcIC+awwhangY8kmlP7k3cVuLBGVo+kk4pXgt3Td36iR7kkKx/31HVUzhR8ofhA/NvfJl5wu+xssGJ7yfODzpu7VXuCpc8LKDOnM323FFMEWu4lRY5P6YJ6BwP9bUENfBuI/zxkaq4XvKP37MyNYXp7OAqgql1EGql1m+jEkA37KGoBd1moKrI5I1g5cItB8Pd6Q46ppMLmE5LW4/QGSqBPFanG1Juuh0rEYXNfKYxvN8n/ei1naChrYIRPwPu87UNXspTr7YUzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iQ0IQZqvJ1rjm9pk/VyxIDGiaRZFZ8XkHdPjzGMcPKY=;
 b=RLpbSfd5N11oT9o1tcYYv+tOaaTxjieokRmOUY7MQZWfowSsKIlwplnBYjZoLF0sktMk7ivHTR4xA7YEVhi/Ihe/qjaL3aWnITgHsi/tgkTQQOFj/QVsqrKGrck6OO9o0cACanC/zTTBKRuYGyFlIauGWXkBsLfRU1yPc0JhZQSOvE9lBgvIOKGodlgaGNjSHQKuE6bMDWVY2Ia9/Bwk1w3S80cZuI1rsEKYHdtV887r5ONF0ZAl1yUx/v2x+pZU5jUSUh9KvmDt3o45tT9tBSp22gdYZk21Nua9wPqSK4RDnsKZVC6FXrUcTTr5sXJldj35a3dt/9WavRBYBKe/EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iQ0IQZqvJ1rjm9pk/VyxIDGiaRZFZ8XkHdPjzGMcPKY=;
 b=OVM9/oNI42fS2zAT5c5aHvOSv3d3HBqtEr+JMh+EnvwGWg2oBZoIS60ZygDiEaDkDt4kZ1YGRWUztSWdYKXskZ0TTMxCHYbQYS2mNqLqXF22Sni1L4b4s54HbwwSOITVr9wu62cS4fzGxYoYmKMbFQDenlmf1VzINLXsaVq4mC4=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CO1PR10MB4450.namprd10.prod.outlook.com (2603:10b6:303:93::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Tue, 11 Jul
 2023 21:46:24 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:46:23 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH v9 00/33] scsi: Allow scsi_execute users to control retries
Date:   Tue, 11 Jul 2023 16:45:47 -0500
Message-Id: <20230711214620.87232-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0065.namprd02.prod.outlook.com
 (2603:10b6:5:177::42) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CO1PR10MB4450:EE_
X-MS-Office365-Filtering-Correlation-Id: bafbdd8b-da97-4346-a516-08db82584519
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5aAvRwfp/HmHKlisllHr8TXO7xsY+x83TLjdNp/NHGskbl7Ji59JUTr6E04cYg8OO23fq8Wwx+xo19ZzgyyYs3gTLTRRUQ1kf7LP9O5nkt5/H0uFzsOawW9Rbq7wmQaE+WcStIKgQRR7q68D2GFggJYjv7I/pUcSz6XdeIVsLf5cSi/i3F8C0/vrvsOJc7qUi5g54jGvAVLn6Aam/k6Uww1XXMeh5rX5A3ocEKycexkp5I206hlzE1toh+0KwZ/Zm/nZk0MmANyotlnJNQD2Bay44C/XifFMhL0ADyOTMRKct86JEoN08VeEOumpPd3zD9XZLeUicUf8GEk/wXTp2s+zamexOsEc8KFVrUVEQz0FfywAQ5EpiR/zWDdyL3w3EvYsmmMQ2lq1WtRXx4PKWFalib/ThXNogEN5+PYIIoakPJ8viujXWvFvDTGmTzSVNwm802h2P2p1C1FgB/z21el/cUftkIt/+eh58IrG9T6kMJZ31WZ1JB1HCh96mN2OKcb19EOSdjjmy+lUT8Z1QAhndW1vKL7pQThP1l11u3uN/8EHdvN8lLbjWYMQKFKe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(83380400001)(2616005)(38100700002)(36756003)(86362001)(478600001)(186003)(26005)(1076003)(6512007)(6486002)(6666004)(5660300002)(8936002)(66946007)(66556008)(66476007)(8676002)(2906002)(41300700001)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dGPbeFIursgiy4pjsuTuBJVLvXXnHx5xnEASyG8Jm6VyGPVtdTRVn/6TTsKz?=
 =?us-ascii?Q?MAzBj/RrZeRKC8YDh0fN4PbjdWI6+oGmi2vvnnPFFtLhvwn79QqQguPNWu3L?=
 =?us-ascii?Q?06SW0UGPr/+A10hWiUAQyxg7VuYcZaZ6luYjN5Gmyc4f9qI2S93z6S1s7FuE?=
 =?us-ascii?Q?BKDJ323XhJ/ea+8DRE3C5NhaPAVo8Ho2MWPyfplMszviAJQ+fx3kGzXOjH9J?=
 =?us-ascii?Q?W8u/bKKkYM+voi/ifRttYQ/z0ifmPw4Plr6b+LuwSk5wVU/N7bW7T+M59XVl?=
 =?us-ascii?Q?FIAtHfLhA1lyen4C0KbVRF3NgsCgLeWbxvGyCt5crqk69bR3HrohkEW/Y0Xu?=
 =?us-ascii?Q?jYCJJu8oniukpEfzocY8pnfH9C9qhrsYAb0LB/f7RN2jDNv14GkfncR+7m1b?=
 =?us-ascii?Q?/L2XGJ1DHspX49X6sDovVMqzmEY2pYrIGz9apff3xA7SvQkO7WKZryhgGInU?=
 =?us-ascii?Q?GO595NTOUXsDMRrUIqJPF1XIV+bUJg52CMzYXNmqVEbRyPpYuV0XXqnMXaMa?=
 =?us-ascii?Q?hIdcijVTbzQjlYneRsR6flT3b6QMEkHQk29sWozbBPEhLwQbKDBdrhhcfd1u?=
 =?us-ascii?Q?kqg1E8htxCvzeGSgZxYCDsa3esfUF+3runx1UJqiG/2ObxkVf+BNKTikgxZ/?=
 =?us-ascii?Q?MqnclSParzb6OrSQUCIkf+MhlDEtUfDKYJnp/qA/fHN04sfpDnA1CakKT+NV?=
 =?us-ascii?Q?iKpCS0AxMk0PCjLJLPyVAMTvpurLfJzLkzjRjte5dGpcYRNbTIukO8dTRA2C?=
 =?us-ascii?Q?wGqociX21Y5a4+VsOnVeYcBU7WIOl2Ue6SF1KKaanXLBe21NQobARg0l6yHD?=
 =?us-ascii?Q?m+gEDAvfl+sXk9VUVqNhUy5Ep+mFYQwMEVUmItXdvWepSn3QJJKdhev/SpKT?=
 =?us-ascii?Q?ovukaeLa7clGhtEI99jjEF1KL5Wd3VKFuHLpumgWIUbVNlH0TPD7M9mZQGwg?=
 =?us-ascii?Q?NFg5aprH/qCol/tj1ZTVB0B+bVVqwrINshgPVwmjHMVA6d4buUYRniZrtk11?=
 =?us-ascii?Q?9XkAp6X7yybeRv18ROheLHuPQUz6/GzZgLpuwjnR2LFsZQDScHjghjzAoR4z?=
 =?us-ascii?Q?rwkDrmtVONwEAPpIyQjClmCdCdmvI+Kk0fu/Ps6ZAd0Opokwjhq1cx5pOOuo?=
 =?us-ascii?Q?ZLwXiWz8biILCHlAs6571Q10MPWIRM9ji9dpu3K2mHur1CjlurTj8BQLNJi1?=
 =?us-ascii?Q?dFbpnlTu91hfCXh0N4ErKvnKKBUIyJETDQ7jtXFI2doT8tEtnWqEVXt3bjga?=
 =?us-ascii?Q?AZz6GdzJU009CZ/KahpZPgpapIMvt7kH6TDye4AmqxdfWkHDcT7l+M2izrng?=
 =?us-ascii?Q?wz4ulbJM7YL3wGA+xcVhP2buKcP2e3gG7gpC1pjEmeLGAHrqAW3VV/vKuEa2?=
 =?us-ascii?Q?+G+OO0lVaYMwWfeVZR2gzec2VzJAFXJTglJK2hu/MNw/Vu+CaqMssd6/ZY78?=
 =?us-ascii?Q?GqAlm1qBL0Ua34dY47jpOcFkxHEG0iabxo3pQ8N0NV/pfZ67eTRInOBRnpMu?=
 =?us-ascii?Q?b5gO8uLT9E0LouNISQGKzNUQRTXE63lG4A7yAQXpiXXUuRCHXaTCXiypWGPV?=
 =?us-ascii?Q?WTS67EpEO7pvtUkA4+8i7r8YPr3cOSUkq68Y+AE99GNuwEXdm7tdvnlDP+1H?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: o2+ctTFh5epPyhQ3FsjnVVWA/uLbA1VkISGGP3jAjn4U8Zd2cD6XgnYaDDb2MB2zryPnzDVGVCmAK+DQ+ng64IAIZBAUNCjCnfNtI63AP/9mbDJxWZBePDLr6W/coPjHHDCwTkzYr9xU+8aYKfxJhiQU2IIILCXWTjqOEP9b+9Mw59H7z0J0Wp8IT8I0p0dIk6/6snhEHRS4C5iCkRElOmQ7/OMwLbrMp0wbOTDIq36jG9IBw7TZXN+ztvTL1KOZ4NPE19F55bEFEIzW7eZuZdQf+yaLYsS3xo8EV6pOJ4DU0jWE0WZPqNkedeZJWxALqONjLWgSOZeJyAWxgs/jCw4DY6r0PTG6Kf+3wIumdX4tUOodyivPYwUcyvDNldY+TBJvPbKUNCHdMlU2fGDHKISV2c9teEXyOsk3yL8qCDFHIq8oXIuPNvc9ImXqoRSuwpTJv7AnvbO6C1HSnFNOEmEA8bzF+aJPjE/ivwbj1XzKHe5mlDKV7E4ev2+bPDbAU/0B4AdbUlHKoxk/2z2B0pgL+ESMuemGrUTzHn5vsQfWPu3DaQQbbo2yQDQ7RLsmWwPn6HfM32kT5XP5m64aWpr34rdvenhillI26nPHlDc7aQHrLQXvBtJ1r2n0gLdc9ygYgAXWeYdLsdeu5zj0LU0hiV3GEQv/+81qNwm0JFx2pGfU3/BHZOpGokhoETQVCNgFS4zK2IT8hY3uDjvP48bzePodbVoYH/BI/Bs8N+lccpB1STZMmf5YAFqVDbL6dLeQN2ARe10V3fWEa0yn6RwmWSM4xNeNwaao0JVE8ls23ZBDvOcgBPmWQHRHrp3C+hgdeYmAygR04CrbJKB6T5/4U3sjRBFbYrvmA4cFq2HPbbCBQLz0hOOyEqeCwrLZ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bafbdd8b-da97-4346-a516-08db82584519
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:46:23.8181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XEeqd5aPk4Ti+jeo4L1y3B1JKiN3WQgLRey8YzoKQ6xWLjnhI7wUTz60MRV3CSLULbYtnaoJCjbw+1Bg+a/CwIvIYYYYDimXE0LPwwzg5+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110198
X-Proofpoint-GUID: BFEv7AVUR3qVSAR2MMrv0AiUDNRb5XzS
X-Proofpoint-ORIG-GUID: BFEv7AVUR3qVSAR2MMrv0AiUDNRb5XzS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Martin's 6.6 scsi-queue branch.
They allow scsi_execute_cmd users to control exactly which errors are
retried, so we can reduce the sense/sshd handling they have to do and
have it one place.

The patches allow scsi_execute_cmd users to pass in an array of failures
which they want retried/failed and also specify how many times they want
them retried. If we hit an error that the user did not specify then we drop
down to the default behavior. This allows us to remove almost all the
retry logic from scsi_execute_cmd users. We just have the special cases
where we want to retry with a difference size command or sleep between
retries.

v9:
- Drop spi_execute changes from [PATCH] scsi: spi: Fix sshdr use
- Change git commit message for sshdr use fixes to try and make it
more clear when we need to check and when we can check.

v8:
- Rebase.
- Saw the discussion about the possible bug where callers are
accessing the sshdr when it's not setup, so I added some patches
for that since I was going over the same code.

v7:
- Rebase against scsi_execute_cmd patchset.

v6:
- Fix kunit build when it's built as a module but scsi is not.
- Drop [PATCH 17/35] scsi: ufshcd: Convert to scsi_exec_req because
  that driver no longer uses scsi_execute.
- Convert ufshcd to use the scsi_failures struct because it now just does
  direct retries and does not do it's own deadline timing.
- Add back memset in read_capacity_16.
- Remove memset in get_sectorsize and replace with { } to init buf.

v5:
- Fix spelling (made sure I ran checkpatch strict)
- Drop SCMD_FAILURE_NONE
- Rename SCMD_FAILURE_ANY
- Fix media_not_present handling where it was being retried instead of
failed.
- Fix ILLEGAL_REQUEST handling in read_capacity_16 so it was not retried.
- Fix coding style, spelling and and naming convention in kunit and added
  more tests to handle cases like the media_not_present one where we want
  to force failures instead of retries.
- Drop cxlflash patch because it actually checked it's internal state before
  performing a retry which we currently do not support.

v4:
- Redefine cmd definitions if the cmd is touched.
- Fix up coding style issues.
- Use sam_status enum.
- Move failures initialization to scsi_initialize_rq
(also fixes KASAN error).
- Add kunit test.
- Add function comments.

v3:
- Use a for loop in scsi_check_passthrough
- Fix result handling/testing.
- Fix scsi_status_is_good handling.
- make __scsi_exec_req take a const arg
- Fix formatting in patch 24

v2:
- Rename scsi_prep_sense
- Change scsi_check_passthrough's loop and added some fixes
- Modified scsi_execute* so it uses a struct to pass in args





