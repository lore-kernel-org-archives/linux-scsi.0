Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33FCCC6FD1F
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 22:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbjCIWeQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 17:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbjCIWd6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 17:33:58 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0925B7D9F;
        Thu,  9 Mar 2023 14:33:48 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329LwuuT021603;
        Thu, 9 Mar 2023 22:33:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=lEkjvXIvVVKtFXq44Da4HgdK01H81EVixFSopGxRgxs=;
 b=e68BOUDKgUK1tAbuYMgLtobOnMfUE5ZxRS6Ih2o4X2n0KxzQhuEYW1MOIGr+wRXzBJvZ
 7poFL5XgAHx52BrFBWwfhZOkY1BJgldChjPVn31ZmokpU33/nvaCekO3r0/TiLy4HgFH
 9PbefG/HeSJ1CZ4Jy14eeSYsa8q2RSzc5+CNnvNfnuwgV9cshWJN6oXEp3Q15V/nXWEL
 IOU0KUo271WYL0e8HrehDlKj5aG0bsjJiHLk8MD/m7R1Fj8rvq1zDSdJ1mEx2TdO/OGu
 nuYaffwO0lZOFt/x+QjS2dnFlCUmc5nI/sTxOg0x6BaZnlM8H0Y0GdEUZ6wO3keVdJnX KQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p41813uxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:25 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329Kf867007359;
        Thu, 9 Mar 2023 22:33:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g4hw9r6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVtwSTMWPF+/jvzde1K4dJHl6yN/9TtPNLRZkWqQVWI5dgMpbdBt4oIyZkcuLboIGi39IFEYLjJkyRn1nOps8Ew+tOG3QvLDFDmLqAU3pGOIkFc3G4aXnQbs8wvgGgM1CP7qzxvdepaWWQJZZXjv71ksh8GyVZCXTtOvdRKL16cUhw21ytg+riwD7rpCFnIDiLwZie1GRgdWGdGMNGMeczpnh1RsgRtOebiwM1ysyaG+/S2mvar4zy2hcw9dQ70GxTcEHyZFFivc1MDO9ztkCt23JwOUbXzQ+OlajKbD8JZbiarVb5SE0TCpJVUwFOexRYxmHKq4LpxRP4/KGJfLUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lEkjvXIvVVKtFXq44Da4HgdK01H81EVixFSopGxRgxs=;
 b=n8T+byqQsNyZqan6sA8FkVGsmK4+KiK0s8m4yuoCYXd0hu942fglSO5SnM/rEcK2cNWPZEuP8tHTYps/yy54ZB8hZNguGl2CLLuyzdB2Yv3osyYEkjGuZ/rvZ1Z/9jNY7aWB2lAWSi6Di7n9oRk/HlCHk7HpOMcA0rkuGnkfpz+W9Fd39RFonnbwVJpNBJ0PLCyOX0QHBZp9uQMuwOxr4QEqXZiWj/RpR3FAMJBCmk+qUmNPC/K5gAoCh3AcrKY+BZDn5ZxedeLzUp07lJNBBk4rjvS0dZjewbnbE/Wb0RQGmTcMEhn6PRbgHksiYZrvB2Ti5RroeN6sfrq4sL5gEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lEkjvXIvVVKtFXq44Da4HgdK01H81EVixFSopGxRgxs=;
 b=zitFp3JqNBNxsvklsQsM9L+FJrW6QmHbVqwz6+c7RaH7dzSwIiSZ9fGfEPd1hoVEeDDRrHNAFCWYGzTdm8mOIQp77K1V8+xNbL2PGPD+Mjivz28jdCRnujikWbSXucnBCPVIb81swwzz9T81exdIHUA67WoGd2tDVBnD8lLYtYg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6479.namprd10.prod.outlook.com (2603:10b6:510:22d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 22:33:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 22:33:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 00/18] target: TMF and recovery fixes
Date:   Thu,  9 Mar 2023 16:32:54 -0600
Message-Id: <20230309223312.94595-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0233.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b217f74-963f-48eb-20c4-08db20ee45c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ERNhCFXfsbnur6X5ZOeyLEMii5cULGZ+h4BsJIBmdQWJaDfK5fXfp6ppXp3+YLrUXlB4lS5rHX0XU9nC2Jp6GfLoTU1tJTip9porK7eDA5nuAkXZriMe/k8+t5zIm5JAGJl0CFEeO66UkOO5KKELZG7v8xo6Fj/jv3e1fkhSAijqAkSUG9YdqWCY/M8+YQPU68xRWHB7SDJ3KeYoCUuSiBwMrnrfu5SatbYhMh33HsxymFOWT31YUcM56DvvYDHsMm5VkdKQ3p5Q764yWfpGNFWHIJKLeKGjPcs3PxRJzYzT9l4l5hwnuNsOWVKcWC9gMlNc3NLaMAAPRSR3mbj7kNdHwnAInkCGF8+C1lq40e3EiA4KZZpxIVn0sbMYG1JCPioqyXKUzX1iuNrcLsDXem7WFcuf1pGpPSNQN4OPYUtyEVgQ2OtSO+Kua9ocIFVM+LKo4I429+hHjzKLxHb7f9xUEoQwToJ5Uq4orbzAye3mm5JzMhRvrAe0rF9Bpr4ht5jw2/bb5X262E7hjB+aWoVJQA4hV6XQnhr7Le0HAh7cexuqEF++Aq/xQCgbVAZZwFtzI20H/FeN13Xk/5FsvhBEPm3+XVHo9TFv7wvN0J2nizj/OiMDkVsoXc1rVTKzzxMRazCfu1/cFlnAHH5ptg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199018)(2906002)(5660300002)(36756003)(66476007)(26005)(8936002)(66556008)(41300700001)(1076003)(8676002)(316002)(86362001)(478600001)(6486002)(66946007)(6666004)(6512007)(6506007)(38100700002)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mqCFqemFlDlRB8HjL33NlxEf72B82yRAiTn7OYKmJwojDcIB/IuE8PK0sfsr?=
 =?us-ascii?Q?ZUvyxPx3x+2DgLPpco520CZihSenrJpL7+nOn3zELX6ybfx1IQFDPUL2vU/q?=
 =?us-ascii?Q?AbVTduFWY+hdLYRgVKcsnijgCiNfAJRCCSPm7xC/5C4j3JZNz5e+SRjOY3id?=
 =?us-ascii?Q?lkmBE6aANJldzkT0obB+wEiLIO2WLhaUtZVxFtVMnp+LtWVEPBHkSsfsjIXT?=
 =?us-ascii?Q?zB0brhtmrd387fS+EGDKrCg/00dVSbV61L/zToqLGYKAU6e1cCGwyL0h1e2T?=
 =?us-ascii?Q?8VtXLRz4LkY/3X56WLJ/WkeISTuuex2BsO9V2SIr5bu5tbbeIwG7KhchzbwT?=
 =?us-ascii?Q?8dcQ1aexRUpLFFPgy96gyNEPZjU9vZQQq3CMUcuZogq7PVeiOJPI2IOqJRXE?=
 =?us-ascii?Q?QHFZgJIX6bl0zvzMaqJj3ZIwDAGzqf8FramiNqC/6g/ER4BpxU2Zwdqf5slZ?=
 =?us-ascii?Q?3L/eMOoPqMbz55IiBPaxIMvo1RjnMd7WhTntsfAVOuhCfTcR12nsXGorMRL1?=
 =?us-ascii?Q?XImrZYSOnauAw/iDW2fwgJET2QjoTiJyz05POFBeri3j7uXyrvARWrfSItsH?=
 =?us-ascii?Q?YRzJ9b+0LhlQq20CnByzHemdnolLR+gudUGgY0Rv5cDIMywD3ltieXPCnj69?=
 =?us-ascii?Q?aN55VI/VBDyYMNKMwCYfQFzow2N11s1UMd0+3YH+iNVtqt5C6JCLfjyhim74?=
 =?us-ascii?Q?JdW8nMq2WnGmVZpZZSKrlkbrlSsCzQNViZ0STK0io5Jb6Awpvt+JgdCUJi98?=
 =?us-ascii?Q?SDPjZRrU0CNzftxltvQOFGNX/a+71etCL5JC0NutVuMDpemOjWp1oCkQNBIj?=
 =?us-ascii?Q?z6eWIdYb6uxcAsnXjlR5b1mdzW0DITCdpBMk+qi/VSix0Eh4jE3yo4xCMrda?=
 =?us-ascii?Q?DKC3KX0zQ1xqKweaQf/HoEhiFy0KjE5U8IeOWVs7E84t+ZktczXhc8lD4bZr?=
 =?us-ascii?Q?huDDQKIGS5WdBNOvziAVSz3OYvlbqpSnig+i9k6pseM/ccIPuH2sPMqSgKAJ?=
 =?us-ascii?Q?+rBoitd2yv4R8GR2X6LGhtSuCLEcgM9QQufUTQl8Ol5G3NTV0HwHfcQKW617?=
 =?us-ascii?Q?rL8Dsno2Bi/aQM2tjXjXDUNQjZ2zeFjE7Vaqiop4faTptQ0QxDGHM9+3PXYN?=
 =?us-ascii?Q?DUtV0v2prGBXpOT51t7XvBJKuESEEAkKrRkuiocSYYIPRDZOHoURSLHLxBS/?=
 =?us-ascii?Q?Dx+bGj0UDEHCah9kwVihpGIISB/hjRqoA39Jq1/dsWHRZBEUbQfIq2QjGl5Z?=
 =?us-ascii?Q?eU92a8+3tbezFYsQPbn9E5ofbGABrBLH6mexCPYrJ93RvERtc+sR7GdY6nQP?=
 =?us-ascii?Q?/5iGIdhZvdfDS9GBZ2Q3xesWuiPllrQCoN7YEdzT3CP89mMMa3+u4eKQMIMJ?=
 =?us-ascii?Q?aTSWHZ+Omd5ugYhkqiyckHEG0i9RW2STOVLkQysO1s2qqXo5JIVxhjbkM0Mn?=
 =?us-ascii?Q?H9PDb1YNiiMxFZVTgVUm8puThdfaIdsizVZXfGnDl0+dDLr1AymzxHZ4lq6C?=
 =?us-ascii?Q?3o5xDgQqNfaMDBR5Jc3/M4zfXSuwJWRKfo4YfFYLQDeLFxNI9a4NWmxckh6W?=
 =?us-ascii?Q?a3mZPBpy3oCNmefR/aW+/jap+1VVg6GR9UxzZM8PmLGT/xecNzWR8pbPyVZQ?=
 =?us-ascii?Q?tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ep3oNiqVmQuKgOl/Q8nr+jtETfUH/89SWV77agWJf4p2cAFSSaut+FTeb5GfbtQ4dJul00QYKC5hAzKoYwTOn8EgqS+R6Enl3rOMnXlN3f7+7Pgg7/Tv0A3p9ftXVhFzNslecRl7qVS6IDRaVXdqUO5GqSHwqAkxYzyA6JhABeSonEfOou2R9xp3ubJAX9AiK5wV6C3Rcg0rfOw81yph5H2cCRJevBAKJEBABOjBKg3irsQkiC9oK301jPQtUM3S1JwjU2T6dXy51vk6nsByVRem8wTWvHbNM96BvW8R01bb/654fcGNAIb/joEyBk+8uNznhLOCBW7Kxj3ZgRK0QlfXK/x1D9l5JQf8mXnZHw3tVSlR1DTQizsrRE/MTdQXSpeWejRkQjhFIWYLnm23ZQKjg/+izpEA/iWIDxnA/Uud9quynu4GaQjEVxNzczyV1/2ySvBSmvlIP3lilMUM0VAcIzTNiQbMxsb/F/LAVWFu4FPxOLjoniGXDM+8CoTCS5S+7R+QogodTasbYFhI2IMKHFZ13croRfyVFtilgcu3tjDn/LIoJsTwsARzLTWeVb/Gj4he4QTsN5PuyJzptaowLYS/lJHFe8hWBQuHIwcP8eB93ogFLuwjoHTOVSInvXZItIFjdHlD0rsONb7ZWALgAOuIZdCp3gwf7WrMDoizkwvat8fzHtDo5NDwuSHaHp+sqzygdS3JpUrY/2RUUP7YRmhF6fowrCCbc9s2GEHdnHdh9cIlEVQw+lIUIMpN8e+7PIBxo1Eh/RaDYpGemM6cZscHybp8XJHPggplV+M27iubAMx6qeze/o31cLvgQ2DE25OFXlz92Ll7Oof3sXxO49MBcaCWBGjBtLskwId7NNIWFLQnqMjtXG+hJSGr
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b217f74-963f-48eb-20c4-08db20ee45c4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:33:14.9249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z4gjLoS1k7ZzSgcNWBp6e4nf2MErBH6rWIX4M523Aapjs5b7BZMYhi2qx96CYQVW8Bjrz9hwWEbq97PaSPE4PMjMSd49UAcyRsWdwqskaI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090180
X-Proofpoint-ORIG-GUID: eoDB-_AdO9n5prby3znKvPYD3xRQ8NQe
X-Proofpoint-GUID: eoDB-_AdO9n5prby3znKvPYD3xRQ8NQe
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches apply over Martin's 6.4 branches and Linus's tree.
They fix a couple regressions/bugs in iscsit that occur when there are
multiple sessions accessing the same se_device and TMRs are executing and
a connection is closed. And they fix some bugs in isert for the single
session case when there are TMRs executing and the connection is closed.
It also includes Dimitry's fix for cmd cleanup when ERL2 is used.

v4:
- Fix
[PATCH v3 07/14] scsi: target: Fix multiple LUN_RESET handling
so it doesn't add back the bug where resets can wait on each other
and deadlock.
- Updated
[PATCH v3 06/14] scsi: target: iscsit: Fix TAS handling during conn
so it handles the case where commands have passed the STOP checks and
have not yet hit them.
- Added patch to handle another hang found while testnig where we wait
on the free_compl but never drop a ref due to being in the wrong state.
v3:
- Drop patch "iscsit: Fix isert disconnect handling during login"
- Add patch to drop cmd lock in completion callout
- Add patch to clean up recovery commands earlier when ERL2 is used
- Add patch to handle use-after-free in isert
v2:
- Fix wait/stop use during login failures
- Add patches to support isert




