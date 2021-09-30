Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48882C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 02:04:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29E9F61875
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 02:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343517AbhI3CGR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 22:06:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:44914 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232383AbhI3CGQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 22:06:16 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18U0AoEJ017456;
        Thu, 30 Sep 2021 02:04:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=hM1KFc4YBcnFoCYMUehLB4L81PvLukhaNyjIOeV+iug=;
 b=KvniXIIhOikdsfro5IhnN5eNDozp6gtnd6NS3a9eDiYea+2OA0YOKFFYkVq/V/bTq0iC
 Vn1Gk4tQxCwNTf3I5jGCnPzJO4kyVbe9NZVea4ecFTk/U6fYnLvl9Xuq5xV0BT+5s2WN
 LOCbQeeq7Jr57Nyst83hv/Kg7WrtfBxW15SVMDT8XhdaMmGVcUiNaayW+VrupUJvCpCX
 SCKBFhWv5FhjxjNw/r4PKt4k38xapH+YJ3IYAb0siO0qOrmtJCDYOzkyll6j7mTSTW2i
 a+fuub5VvUA5kIPB+EQJF7EvKJPZuiwrYVZPae4Xcu2/nOL6I0NKXgvZ0+17g8JS7mBs ZA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcg3hswrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 02:04:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18U20UQe108324;
        Thu, 30 Sep 2021 02:04:32 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2044.outbound.protection.outlook.com [104.47.56.44])
        by userp3030.oracle.com with ESMTP id 3bc3bkv6f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 02:04:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRO7HX4uyw4yLCwueHr0eDPlfTknRLeDxv+00uGt63vVluOTRZaD+10VJamB+FYohyELw4AuGgh3DJo4gaS2tRMYFCSBe4eO6nZs5hNUfA/plK72iGwLEY13+fjfFZhF87UqHsLjJSoALkni0KlQWugl51O/d4KLaApzvODCo0xY+ecBLca8Xv2kVA/y/hEgoJpZikORG60WCrrPgIfSI+wrcelIyXr20jbkIjUzBsCZTVV5hvjk+Z5EHXyvHgcDeBFZKHdB5mRWnqR5ts+JPuRON1Pf/OeqhWRv+yxJLXK46oJjsfARJijKQdHWyyVRdH9jfpT2NUhUolci1DiBRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=hM1KFc4YBcnFoCYMUehLB4L81PvLukhaNyjIOeV+iug=;
 b=U26Dr5WsmvP43/01wi4a4lkaZDXEoq7Mj/lSQOqpgVBrM9Dxxqigu1Bd+vt9LkyiD/+g4b3C1ckXo/3YnjEWUlPip3+9PRLXl2+ou/nRw29syvKfF2G36Dh5ZU1LUKY5GGzmWHOZxNad/DCZTlIxWxuBgW3lLjKZMUOc3AB1GI5PEIKGFvNMgh8SQmIkZp4lKCHeS97XHpQS7On0OxYy9VfufDeR3B1k9/TGIlfa5YCXpqC1DVfuOus/W1MikyI/355UXctjMxGlaLQobcB4vhAUWBWvSl8N5Mn82lxi8doo0cUPG3folynUdI+8QRvDJerbK3VFhg5dWs9Lb6Eaqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hM1KFc4YBcnFoCYMUehLB4L81PvLukhaNyjIOeV+iug=;
 b=rjGYZeaN8q9VxvbP2RaPnfJJlFQ9Z5LHvnU//rs8m7chx8BEAuT26hmhq3dFRre4/vjcFgtuwITti8LWn3Ro2xw+UqVIIj7Qa7ADq03yw25oObFmX545BwDXE9PlCA3Gu+P93E2PosaeZO/sGVm0hoATrqaXWLWLwJOxYCO+MK4=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB4909.namprd10.prod.outlook.com (2603:10b6:5:3b0::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.14; Thu, 30 Sep 2021 02:04:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4544.023; Thu, 30 Sep 2021
 02:04:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 0/5] target: fixes and perf improvements
Date:   Wed, 29 Sep 2021 21:04:17 -0500
Message-Id: <20210930020422.92578-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0159.namprd07.prod.outlook.com
 (2603:10b6:3:ee::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM5PR07CA0159.namprd07.prod.outlook.com (2603:10b6:3:ee::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Thu, 30 Sep 2021 02:04:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4688b001-84a9-4499-e595-08d983b6a3f2
X-MS-TrafficTypeDiagnostic: DS7PR10MB4909:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DS7PR10MB4909244D4EACC41DAD639695F1AA9@DS7PR10MB4909.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xy3JNJBZ/3tbcfQjDwyidgWw6qw2ix1fWCEqS7akPZH/H0M+vHF4VPRgGreWdi/15OLXeeF0XOwNg3joeprIGVCJS1bg9fWccYP+FKoURnaT82CqkEq2EMB4ffeAMawToD4CEJSahx5/BloYT5X8fypk/nOKkoWzEl+U/4P6rFrLXyvun/mYSLrSe/El463enqDTQQdISsmWzxkuqDO3nmIinHwwskK4mZJTu5jH9l60JhXxX/k/YWYt+AEdYXFklHBfuZAfP+8ov66j/6+Sll+AsGzeu5eVHeewGDqg+86QeWuftAh3uLUs4y9bS2oBGZBBf5HxZKejQU2t+C3xPIltlRLc/giWZzKdTjeJ5HjdyqGor9qb3Z8fqcgYWLz/avmPdoNOX0KJj3UEt0lCESIpoyzcYguqYJej0Ic2+e9r3LlW4eqaxlPNB/gFViXFunQwpZ6V6UcGuGvn7aN1azIb0IX/vPlJA9NTLbhSCNiWE+rwR8qjQEC/GRn0B53s6BR+/23Fdo/vPm8po2N9Vid8wu8Q4hVj5GoJ1Q0vJH6ShmO6IWa1ArkXK0AIB6PDkgvWkFf9sgFXwkOOEbyPhebBXisQU3/UuRyOk860ybJzBC27pdlbDafTa5ETn8Z5PZSpLqyAzuuBgLNsYJgmjZongfH39t3JvGlOAOJKxLh4rnRG0zZq1VmOX5ibMiF+MKw9s2DdeDgO8EZmQYY6TA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(956004)(38100700002)(38350700002)(6512007)(6666004)(6486002)(8936002)(83380400001)(316002)(6506007)(66476007)(1076003)(508600001)(4744005)(2906002)(26005)(66946007)(52116002)(5660300002)(8676002)(86362001)(186003)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aqH5WJg1qkFpPfMPVMfa4nyBdE97qpRHmn0s8Ufj1aY73vAvKs3rpKKVdTSX?=
 =?us-ascii?Q?aZcdvx0VnogQsZEEyHJIO/sZECeFwR9J6Ccc1NSByiV1d0R/fwZ146tPp4X1?=
 =?us-ascii?Q?l3iyM7Y0fTeGQV+P5gA9pf0p2jEJ3EMzX9+EuUnsx4T/llnZbjwWsRdAS8MS?=
 =?us-ascii?Q?O+96Fe0/C5adikxX0rs4/kfoGv4FKmpag+f1MhwmlYFeP8Mk6a0PXZC8cD7R?=
 =?us-ascii?Q?VMWHfULkXZkU6eiO8VSo3huqmegOMigkuhqe9salIMF5Xi2ULpbIvavYZymk?=
 =?us-ascii?Q?JgxeKjatZpmpSANHoolnq7xv4xuM1YLZ5PZpMWhwRm+LnHBiCuKzy6WRW94+?=
 =?us-ascii?Q?J68sdgpwDrDs8x4+FCcwXHpsaBAFkr1BIWCpzyHLXQJfQ8uDCAFbwtZC+of1?=
 =?us-ascii?Q?dZJxaRE6XJuHT5SmzdSf6DzVhPmlv3NmgS2KtKiFOtxRaB2wfidHus7RX3bn?=
 =?us-ascii?Q?z2qllqtbPQACNlzLmSGjwxDuY3Hmipu1La0EQFleBkzttFcQY/38RHeSTqKH?=
 =?us-ascii?Q?bnSlgIwg7BxyCRnhH3AFX72UlMf4+VKwu5gJXcIeTLMhAFjXsSX5CI9Y24fD?=
 =?us-ascii?Q?C7Pf3OJV5YrX2abG0NE4r/4lKQv6/vbVq8JWEcvnRm+ZDu4wvgkIJy9fG5KP?=
 =?us-ascii?Q?TNCcj5cbFedncb3JnceW2PqLJ6Qfz07pSldAeN7/cgw5cEqAEAb8Ti/OumGE?=
 =?us-ascii?Q?VbIGZOCAz6cQs+gup/n4Wsr6sTVk5xP/xD9y7fZvwdmburN2SzpXxnYkJPWj?=
 =?us-ascii?Q?IrIq1Gm02rK2uRWkgZBFg8ZyJdoorlQhV+OWRepf4fLQT5Cn1ErCHBYFZcK0?=
 =?us-ascii?Q?Za0plgmlAa4bchiEPCh3mQZSh5DpNbc9Bp0OcYkvdtRW5frXVYVHfzyeE4ex?=
 =?us-ascii?Q?n7FPXnuUOrKNMauloSF1sukxQAEr27E3CLrGKMQcAymiAbrTlA8IH5eZJvKl?=
 =?us-ascii?Q?U6vTlkfu4+6ehkTzqW1FKydOo+4fLaVxId6jW9ufVxfLzMYWviUdOh1dCgz2?=
 =?us-ascii?Q?k9CEhocSx+tX+62i0AbytIrb2mvPHvS/1/y4ZPevn9m1NWnVAIcagltCLauK?=
 =?us-ascii?Q?h1exLYK+LpSzbol0cqrLUFX4icCxDjNFw5DV6ur4uoLyG7h8qfKSByMOK6tq?=
 =?us-ascii?Q?sosYN18VEzFGk3xBecObud+jPWb8di31KJ4Bn5i+aYGEASWwtebrEZ5vIwGy?=
 =?us-ascii?Q?k+6kjo/DePAyP+eagCUM1oi1QfWLySZ/efT629qztMZUA//GEIYCc5cUSG9O?=
 =?us-ascii?Q?uQ/cYISxJq+Sx4OWSOb1rIieix30APUzdOA/MxZag5Q508KCsret3KcUUMmM?=
 =?us-ascii?Q?tHXrKmOuhAq1DQUjJtWHNwM8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4688b001-84a9-4499-e595-08d983b6a3f2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 02:04:30.9366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +88uFtAW1v6MXLK8aKBrK/dETs0dwfXE5VC9NCKWfxCVDHj6H8/rqXoYgkG7Q15UlwxFfQyX8R+WkX7Zt0tmdGj8rez+Ftje7F7XT3FKAr0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4909
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10122 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109300009
X-Proofpoint-GUID: 83wjTu23VDMdDJZFkhueigDjQ8ZU3jXA
X-Proofpoint-ORIG-GUID: 83wjTu23VDMdDJZFkhueigDjQ8ZU3jXA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches apply to Martin's staging tree or Linus's tree.
The patches main goal is to take the locks out of the main IO path but
for the case of ordered cmds they also fix a handfull of bugs.

For the locks we currently have:

1. lun_tg_pt_gp_lock
2. delayed_cmd_lock
3. dev_reservation_lock

and this set takes out 1 and 2. With them removed a simple fio:

fio --filename=/dev/sdb  --direct=1 --rw=randrw --bs=4k \
--ioengine=libaio --iodepth=64  --numjobs=$NUM_QUEUES

can increase IOPs by up to 30% (from a max of 1.4M to 2M) when using
multiple queues and vhost-scsi with the multiple vhost thread patches or
tcm loop with nr_hw_queues set.

Note: I normally hit a ceiling of 1.4M IOPs with around 8 queues but with
the patches I hit a ceiling at around 16 queues and 2M IOPs.

If I cheat and set emulate_pr=0 so the reservation lock is removed then
it scales nicely and you can continue to add a job and queue per CPU (at
least up to 20 CPUs which is when I run out of CPUs).


