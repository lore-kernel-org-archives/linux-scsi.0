Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952CDC74A4B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 22:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbjCIWeY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 17:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjCIWeG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 17:34:06 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586F4F4D98;
        Thu,  9 Mar 2023 14:33:51 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329Lwu0k021600;
        Thu, 9 Mar 2023 22:33:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=FEuO2chkVB8QsG+h9DSCpAFchCsFrl9T4A9jOLSVaXs=;
 b=E0qE1AydX8+pxu62CzXLLiy1dt904+Onfp0rpQFaW/Bup3N4P6pMU54A/u7t7YCq1FSp
 WXkbwjrqzOtdLl/38OUltdOzztcV4V88TitCE3aPESELeyatSt9oC1q32OmNc7FVPWTH
 MZYcZoEQhqPyoXFo+9cTCJxmWTyFFQatPuuQRAkPcCNoqUnzMiSRisggyHF9oix63Rfr
 cRz/aJ0IjMuGB84Sig2QRehkJgdaQb09vaxvEt4CwZ734yOHtTc/3G2zPW7G9d38ZSnE
 SYeb4PLOkNo7h3NX7maZnKYe/SpmlaMJepajemHGiJhTUxx+WAdrjUA9NP8dFokdah8C wQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p41813uy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:36 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329MEWBA036526;
        Thu, 9 Mar 2023 22:33:35 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g47nhdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bh9PKPLm805ra27y2iiZqHUStnowd/KLs6uUTYfuAoaigVS+tuaWvZ6Y1DFnijzO0g5eNWMWuLqLmYFVGz+6DIWrSqal3Q+1hZTEG/2L8MOsujUJqXMWE4My3lGdGf5QU5PWu7drfuda4fzjocVuEfdExAJ5yvpbE5bUFsAyNKl8P9x7p8Nw0RbtgXmStIsNjg1rBu8KGaCuaOttfWsLVDgSxlTTRFfyIwDCtM7mYZh6cPpbXdIwmuC23vXkvaZMr7KuGvN6KaOh19tK5EqG8eIwbUNx9r7WXUAK6GBMcYor2P9ziyq6Ji4V3WNC/3rXQxOUQ97y4SRYmKDD2uVexg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FEuO2chkVB8QsG+h9DSCpAFchCsFrl9T4A9jOLSVaXs=;
 b=Lzq7kXEb7tQ5V1mmgcAT/bjDpnqve9SgR2aVNZ0lW8dDlZqAo5ncbP0kIUy5a62H/ueMtJgKK17Murd1nZ7mgTkOSyD/uO1qu3ey1LkGGx7f2dqRzAtULA5QADrp0PMctfONzmggiC68MjqH4Hvslc3qzu3ful06tWV+59UHozoPAWS6pXyGbS86B1sPVdclxTyO614MhMk8+vPJfTPHY2ebXYogx2ok0Wf6e/hobPxQEPAXeMkR/D+zCuR8XUi3Xzg0llBLgfEu2F2nh9bgZ0B+lhiYjMlcu/EIWZHTwfXuzBLbLIh97TsMx3iRLl0QmM/ub58E1tBtJdj7m7ZXjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FEuO2chkVB8QsG+h9DSCpAFchCsFrl9T4A9jOLSVaXs=;
 b=L7tA5CwOqjsiFfs7InYCrm2oSTO8Td729IAMymY+7Gx9P36UoB8cVeJexrVZ/KokPlqBN6pwwwaaYLwirOyTVbn4UAMyZlUyl6ObPy1mffZPFEEE64YEbTef6inabmQiJb2JkUM7P/TIaitXo1SxT08Djhl6z1CvPNsWziWXmQ0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6479.namprd10.prod.outlook.com (2603:10b6:510:22d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 22:33:33 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 22:33:33 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 13/18] scsi: target: Fix multiple LUN_RESET handling
Date:   Thu,  9 Mar 2023 16:33:07 -0600
Message-Id: <20230309223312.94595-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230309223312.94595-1-michael.christie@oracle.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR05CA0065.namprd05.prod.outlook.com
 (2603:10b6:5:335::34) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b97d753-5eb2-47b9-edb0-08db20ee50d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zwTPidWK8VzXz7yADJq7KN6tVoqHTXcORpvEqUTFBDV/SoO66npeUeKfPz6ZqfMyJp4ont2OU6YbKMXUhZGbM0U+/OM0z3BeIjitTH5Mz5JP2rGPg2wD2EYp0RGk394DDcknh07JSad+40WIi1ErDMPnWZy7W6mBsk+1VmhRYpQwaXBMaM4MDc+HkvoskWVPJlK1OHI95UKwvKaygc8GeZld1ilGJH6xLlkxM2Px/UIE6BAl2/lCDZWh3nObfwD3lqQZhdgwsIO9cNQlEbBtucQXWqqVmdZqT68laUQU+afXqF9nTwb/nJrUFHWjWOTgmMydD6bkU8p2PiL2QxYoZDIYu6jEeT8X2ddGX97Lyxl2q7ANm+orKipveOE/n2I2gIWQpcDyby36SgOh19RLBUWVYwaE0N1/HOOBLRrUJMu8nKqko5NnsH3GgrVbn3L5pU9vkTLPtCX+tiBvF034qaiULL5CEHTQKSajs/fieCDjKfOyiEEolN+tX68c7sFP/1rlrksVY6Zg4Q07BXJoOqf8RR5SL0AmHRpH22rDIc3xA5RtPlv0TPQwWKiVgRc5PCAfa13HCw8XZ1IGpfbVOFCS6sgTLH+dUIH4ilIPv3znVebbn7vG57wS4MRW95my5KuPNeYrIVBc64rdG8HOzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199018)(2906002)(5660300002)(36756003)(66476007)(26005)(8936002)(4326008)(66556008)(41300700001)(1076003)(8676002)(316002)(86362001)(478600001)(6486002)(66946007)(6666004)(6512007)(107886003)(6506007)(38100700002)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IJTNDbwNP/RsR+fWl/qj5l1UBOpFudu0wG1NYdPxu0ZopIiq3LPu7n8WYbVE?=
 =?us-ascii?Q?UUIREjw2689kdU29ZlNhQlRUI2cwBUjihNCedwEsNtZFvRhnV9rzbeq2zoF1?=
 =?us-ascii?Q?A7Nc7s36NfdX0vVrWFxZ4NO89okjGZCyzuxiIcK1cCriZFqmlgVO+3CO2o1y?=
 =?us-ascii?Q?6x6U+Njd34wsc0NkRyV4TDZzsLIrIURyZSzlS+QOhjXVMZgqnUiu/9cJbhze?=
 =?us-ascii?Q?ipA6HIYCdvp/tvhK5gCy1G/8xOo6+wwMa7dMWAXexOb4cpoPc58hnM6M3+OT?=
 =?us-ascii?Q?jRioCRHhKkuX+0naOZfULKhn5Lb5EcPze4fYpaiJjDWHoekgWuUlxFTF8JuX?=
 =?us-ascii?Q?6m+jDsGZBYWFqNHix/2XjwBzedjMloWG6waXKgI2wzcXL8aRolW8hW21h7Df?=
 =?us-ascii?Q?rhyvsnbG2evbqx4RF0FvJjJo6JecCMcj3OOzcjs6cFnXI4yyxsEeRuxEH4hy?=
 =?us-ascii?Q?nDKlBMQJ2MxqGALjPl8JjB67JzIyQ/Bl3HuQwsz9Gci486H1xU5YwfphNeg9?=
 =?us-ascii?Q?EY/3be6O8VK3+lCQDk6qe6SzS2ZNd29TwD6I1SZEALKnCl1hHi6Bn9OIwCCb?=
 =?us-ascii?Q?Wjuqfkds4hK/MYBYaZI3u2Dkolh+esqkK/FeXqbNWt3TjaKYIOgcRV/qFjCs?=
 =?us-ascii?Q?MEU3znzG5XS/+Q0A5V57M0aA5vNGB4EHPgPCijO96LEUKmfT99ZT9NIP0d40?=
 =?us-ascii?Q?4/8Uf5dyXensb+EBvbrtSYwuHm6Q85W5umrtr5dUwBYAfyAXcQyHla163TJA?=
 =?us-ascii?Q?vSB6Ur1ECJduMvU+K5pvBAFbXk/qsoYCF5/g1AYGKVjCsjXXYQHLz4lKdm7v?=
 =?us-ascii?Q?0aaGlk1yNUt8hpBOBrJtHA00iosQwhhEMGW7PxcXX2WBAzbB81c1T3LDPjzg?=
 =?us-ascii?Q?p57d9yN7q6sdVrTuZbaid6FYkT4DtOsbdmZ6lP2WWd/QB/DT6XYKBzB3D9RP?=
 =?us-ascii?Q?dQeClHscMNr4QqoGBf6CXRQwzTGlSBl12guXdO8Wa4fbo+m/GNuLGOhGJDn3?=
 =?us-ascii?Q?A5gp8fdXljfVGi3QEQHbyrsvXNB8mEYQ9hCTMErtgz3yuww9rH3NSnRbnU2Y?=
 =?us-ascii?Q?z5NdfBVCvw6AN5yuUzKlApzZExfKmpAF9yuBE3JT9mlyZLSrR6NUVuWiriqA?=
 =?us-ascii?Q?DZI5eQ2a35Afx8TD5fzNf8XCpF5RGVt+IyLxDaahbbNVu+K68aausxATBTEy?=
 =?us-ascii?Q?b36NEfrZPr26UaMUdKNV929ZfNc+WTL61aTZz7/q+8EgRCoO3kwL/AKAmAr0?=
 =?us-ascii?Q?iSHc6kWUbEY85mJ5EHcfnzrcBslw6aCe50LiKYqFnWFGydkL7ipZlNbEAyzb?=
 =?us-ascii?Q?2okTWEq7j9gCuTNeE5itWMspvezx/UT2VNIaOlMEn7p3m3yUS3DLLf4Cachn?=
 =?us-ascii?Q?DgGWHd1scH9yuOP6ZVpewyhgeiDzmMFef6TzbmqRCMHd5Nd5FGCf/YKOuog8?=
 =?us-ascii?Q?nUgdPPULdipQ+fHr6Gl/WR56fHFbhu1UIV/7T0GiMwwZlZmJCLXm35XKF+O8?=
 =?us-ascii?Q?0uFMlB8hDQsdpa3sVnBGqyxIJ+1szaRKRt4lSjEm++VcHsoOTrAa77tMRP4K?=
 =?us-ascii?Q?h5PXV9qJeymDr5YYEBl5VdyDsyT+OCHUwkiv0xaL/EA5060GYMzMVz8VFYQu?=
 =?us-ascii?Q?lQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Nl/hiKjI8pUGk4XmHVdy2nDDiUuDvmvdZz3o7USV1g95spZM1WtdaQqbJXoqOpeTfo48vBNl3/SQySXu29/wKzZ2JWUd2UKLqUMUrR9SPD2gLWklNnuGVrcDHRvZF4oN6eeeFfiC6UGFUKvKXq8PCuEDrl6bPQ2YUojcMKL1ueTiBNTqDmmFQEzZZ0eL47PDJ7h7sNRB9bGjk0rX0+8CETBjI0qRlhHnM+cjPcmzAcP4tYACUyIacm2dCh6XCfXL14iA+eKyEaqnPx/kLMwt2oqSb7qH4gu62zFAuNlFZjsw/H12BWDsMuyIveseWjrU4Rf2B/UpZ6jQd0mwFXkD1EM3h2x9ngKHbht6kdNDBEMDqI5e/lSMhYUxX2KoYibVstqFZOCr2rKDhJogmeeFbIuWbmkhBSCPUpezi4s9i35hkOGx6PTTZRoGh2/Yry1Ua1nO3qIMVyF94ZvqZ112g0qkYRjGGi7XCCBz+LA4mVD+2U0SKaBLRex/V6ID+IeCrg1EqJo69Fu4pDeNgWv/dcnZbhoEGp6XiUY3UAkIZSYrgPUCvtntIa9QNcgICDfAz7gPkS39YiJFjmSgYhZx7K4pJ889ZIAMW8WKF9dmpnOzXLaFOXxzCuIjkYDO7RzURLWjhAYGch3CfzoWR8viJgeq5i0YTd3g5n2h2NicB2rs+1zuO7BdVVPPbNNvcdO/mFDEJqyWsONfPNSLig/M41a2S2LCzaKBjM8lWqZ7PCCbywWqJ+S2yziYFXV0KVHY7qwAbKE82eWL3/lrGPjCt/lAmFIEDyGQDp9/WIaIoZfymMOLtFDVUDPCc9Iua16nOAZjufNa+MJ326IA0p8G+3dRPxGpqPQpARbjQqTbfjXMNIyBzexPy+5a7Et6m7to
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b97d753-5eb2-47b9-edb0-08db20ee50d1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:33:33.4703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vwyt+rFXovJIHZKHHGQMIbkQ3BRL8DTarJR/kf+NStpLq9VKjvhYtdBm0eAsVjXhGYZTyCU0QuE8stcBCrXA2jhzh8Yu3+6rnFMWQbBuJZ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090180
X-Proofpoint-ORIG-GUID: rrP4gQGhgdCUSu8-UoQDDjaCHN261Zrm
X-Proofpoint-GUID: rrP4gQGhgdCUSu8-UoQDDjaCHN261Zrm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes a bug where an initiator thinks a LUN_RESET has cleaned
up running commands when it hasn't. The bug was added in:

commit 51ec502a3266 ("target: Delete tmr from list before processing")

The problem occurs when:

1. We have N IO cmds running in the target layer spread over 2 sessions.
2. The initiator sends a LUN_RESET for each session.
3. session1's LUN_RESET loops over all the running commands from both
sessions and moves them to its local drain_task_list.
4. session2's LUN_RESET does not see the LUN_RESET from session1 because
the commit above has it remove itself. session2 also does not see any
commands since the other reset moved them off the state lists.
5. sessions2's LUN_RESET will then complete with a successful response.
6. sessions2's inititor believes the running commands on its session are
now cleaned up due to the successful response and cleans up the running
commands from its side. It then restarts them.
7. The commands do eventually complete on the backend and the target
starts to return aborted task statuses for them. The initiator will
either throw a invalid ITT error or might accidentally lookup a new task
if the ITT has been reallocated already.

This fixes the bug by reverting the patch, and also serializes the
execution of LUN_RESETs and Preempt and Aborts. The latter is necessary
because it turns out the commit accidentally fixed a bug where if there
are 2 LUN RESETs executing they can see each other on the dev_tmr_list,
put the other one on their local drain list, then end up waiting on each
other resulting in a deadlock.

Fixes: 51ec502a3266 ("target: Delete tmr from list before processing")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_device.c    | 15 ++++++--
 drivers/target/target_core_tmr.c       | 15 ++++----
 drivers/target/target_core_transport.c | 50 ++++++++++++++++++++++++--
 include/target/target_core_base.h      |  5 ++-
 4 files changed, 74 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index f6e58410ec3f..c9f75ed1566b 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -179,7 +179,16 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd)
 	se_tmr->tmr_dev = rcu_dereference_raw(se_lun->lun_se_dev);
 
 	spin_lock_irqsave(&se_tmr->tmr_dev->se_tmr_lock, flags);
-	list_add_tail(&se_tmr->tmr_list, &se_tmr->tmr_dev->dev_tmr_list);
+	switch (se_tmr->function) {
+	case TMR_ABORT_TASK:
+		list_add_tail(&se_tmr->tmr_list,
+			      &se_tmr->tmr_dev->generic_tmr_list);
+		break;
+	case TMR_LUN_RESET:
+		list_add_tail(&se_tmr->tmr_list,
+			      &se_tmr->tmr_dev->lun_reset_tmr_list);
+		break;
+	}
 	spin_unlock_irqrestore(&se_tmr->tmr_dev->se_tmr_lock, flags);
 
 	return 0;
@@ -761,7 +770,8 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	dev->hba_index = hba->hba_index;
 
 	INIT_LIST_HEAD(&dev->dev_sep_list);
-	INIT_LIST_HEAD(&dev->dev_tmr_list);
+	INIT_LIST_HEAD(&dev->generic_tmr_list);
+	INIT_LIST_HEAD(&dev->lun_reset_tmr_list);
 	INIT_LIST_HEAD(&dev->delayed_cmd_list);
 	INIT_LIST_HEAD(&dev->qf_cmd_list);
 	spin_lock_init(&dev->delayed_cmd_lock);
@@ -782,6 +792,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	spin_lock_init(&dev->t10_alua.lba_map_lock);
 
 	INIT_WORK(&dev->delayed_cmd_work, target_do_delayed_work);
+	mutex_init(&dev->lun_reset_mutex);
 
 	dev->t10_wwn.t10_dev = dev;
 	/*
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 2b95b4550a63..88d2a7839876 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -184,13 +184,11 @@ static void core_tmr_drain_tmr_list(
 	unsigned long flags;
 	bool rc;
 	/*
-	 * Release all pending and outgoing TMRs aside from the received
-	 * LUN_RESET tmr..
+	 * Release all pending and outgoing TMRs except for LUN_RESETS.
 	 */
 	spin_lock_irqsave(&dev->se_tmr_lock, flags);
-	if (tmr)
-		list_del_init(&tmr->tmr_list);
-	list_for_each_entry_safe(tmr_p, tmr_pp, &dev->dev_tmr_list, tmr_list) {
+	list_for_each_entry_safe(tmr_p, tmr_pp, &dev->generic_tmr_list,
+				 tmr_list) {
 		cmd = tmr_p->task_cmd;
 		if (!cmd) {
 			pr_err("Unable to locate struct se_cmd for TMR\n");
@@ -379,14 +377,19 @@ int core_tmr_lun_reset(
 				tmr_nacl->initiatorname);
 		}
 	}
+
+	/* Serialize LUN RESET TMRs and preempt and aborts */
+	mutex_lock(&dev->lun_reset_mutex);
+
 	pr_debug("LUN_RESET: %s starting for [%s], tas: %d\n",
 		(preempt_and_abort_list) ? "Preempt" : "TMR",
 		dev->transport->name, tas);
-
 	core_tmr_drain_tmr_list(dev, tmr, preempt_and_abort_list);
 	core_tmr_drain_state_list(dev, prout_cmd, tmr_sess, tas,
 				preempt_and_abort_list);
 
+	mutex_unlock(&dev->lun_reset_mutex);
+
 	/*
 	 * Clear any legacy SPC-2 reservation when called during
 	 * LOGICAL UNIT RESET
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 1c23079a5d7f..3c732b1b5389 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3574,6 +3574,7 @@ static void target_tmr_work(struct work_struct *work)
 	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
 	struct se_device *dev = cmd->se_dev;
 	struct se_tmr_req *tmr = cmd->se_tmr_req;
+	bool sched_reset = false;
 	int ret;
 
 	if (cmd->transport_state & CMD_T_ABORTED)
@@ -3596,6 +3597,22 @@ static void target_tmr_work(struct work_struct *work)
 			target_dev_ua_allocate(dev, 0x29,
 					       ASCQ_29H_BUS_DEVICE_RESET_FUNCTION_OCCURRED);
 		}
+
+		/*
+		 * If this is the last reset the device can be freed after we
+		 * run transport_cmd_check_stop_to_fabric. Figure out if there
+		 * are other resets that need to be scheduled while we know we
+		 * have a refcount on the device.
+		 */
+		spin_lock_irq(&dev->se_tmr_lock);
+		if (list_first_entry(&dev->lun_reset_tmr_list,
+				     struct se_tmr_req, tmr_list) !=
+		    list_last_entry(&dev->lun_reset_tmr_list,
+				    struct se_tmr_req, tmr_list))
+			sched_reset = true;
+		else
+			dev->dev_flags &= ~DF_RESETTING_LUN;
+		spin_unlock_irq(&dev->se_tmr_lock);
 		break;
 	case TMR_TARGET_WARM_RESET:
 		tmr->response = TMR_FUNCTION_REJECTED;
@@ -3617,15 +3634,26 @@ static void target_tmr_work(struct work_struct *work)
 
 	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
+
+	if (!sched_reset)
+		return;
+
+	spin_lock_irq(&dev->se_tmr_lock);
+	tmr = list_first_entry(&dev->lun_reset_tmr_list, struct se_tmr_req,
+			       tmr_list);
+	spin_unlock_irq(&dev->se_tmr_lock);
+
+	INIT_WORK(&tmr->task_cmd->work, target_tmr_work);
+	schedule_work(&tmr->task_cmd->work);
 	return;
 
 aborted:
 	target_handle_abort(cmd);
 }
 
-int transport_generic_handle_tmr(
-	struct se_cmd *cmd)
+int transport_generic_handle_tmr(struct se_cmd *cmd)
 {
+	struct se_device *dev = cmd->se_dev;
 	unsigned long flags;
 	bool aborted = false;
 
@@ -3646,8 +3674,26 @@ int transport_generic_handle_tmr(
 		return 0;
 	}
 
+	spin_lock_irqsave(&dev->se_tmr_lock, flags);
+	if (cmd->se_tmr_req->function == TMR_LUN_RESET) {
+		/*
+		 * We only allow one reset to execute at a time to prevent
+		 * one reset waiting on another, and to make sure one reset
+		 * does not claim all the cmds causing the other reset to
+		 * return early.
+		 */
+		if (dev->dev_flags & DF_RESETTING_LUN) {
+			spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
+			goto done;
+		}
+
+		dev->dev_flags |= DF_RESETTING_LUN;
+	}
+	spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
+
 	INIT_WORK(&cmd->work, target_tmr_work);
 	schedule_work(&cmd->work);
+done:
 	return 0;
 }
 EXPORT_SYMBOL(transport_generic_handle_tmr);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index bd299790e99c..0a5b51f8e5e8 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -804,6 +804,7 @@ struct se_device {
 #define DF_USING_UDEV_PATH			0x00000008
 #define DF_USING_ALIAS				0x00000010
 #define DF_READ_ONLY				0x00000020
+#define DF_RESETTING_LUN			0x00000040
 	u8			transport_flags;
 	/* Physical device queue depth */
 	u32			queue_depth;
@@ -840,7 +841,8 @@ struct se_device {
 	/* Used for SPC-3 Persistent Reservations */
 	struct t10_pr_registration *dev_pr_res_holder;
 	struct list_head	dev_sep_list;
-	struct list_head	dev_tmr_list;
+	struct list_head	generic_tmr_list;
+	struct list_head	lun_reset_tmr_list;
 	struct work_struct	qf_work_queue;
 	struct work_struct	delayed_cmd_work;
 	struct list_head	delayed_cmd_list;
@@ -872,6 +874,7 @@ struct se_device {
 	struct rcu_head		rcu_head;
 	int			queue_cnt;
 	struct se_device_queue	*queues;
+	struct mutex		lun_reset_mutex;
 };
 
 struct target_opcode_descriptor {
-- 
2.31.1

