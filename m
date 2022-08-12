Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D2DC25B06
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 01:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236131AbiHLBAo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 21:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbiHLBAm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 21:00:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC8B6BD48
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 18:00:41 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BN5YPm023656;
        Fri, 12 Aug 2022 01:00:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=z4UU1JYvylhqLcYzO/whiT2cXJ7UEKhsS1riVss1HRA=;
 b=zUGfvHHN7FMWA/WdXOpQqFxLpPPhkzcCOI+0VFd4/sh2+y5TXhc7fNj0sNQYkorLt2fM
 6i3d5J3o6ppjKj04SGHuVC9ag0ixdxOY+MazzNW7sjwRsuJDTa6AJDkEfMdIyffGklei
 utl5Y3mXBoH1Yw+yJrHsDoUQfblX32bpjdlaVYeEl9p1mjjRTlXTUK2xzwg9nWDL15rg
 80XYrmhMsbla266TzfkZ0WMKAeriYgQmlgGnRzB9rA5P93KWW83gX91jyZpMDVzCxGYj
 BUdtVze89qZrdueZ/FmU1cN8mIowfZ6BI2UlotdHt9RCfDn56ODDvqrV5RRjiMBfdIgG +g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqbpbpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:33 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27BNeHNe040773;
        Fri, 12 Aug 2022 01:00:32 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqhd9qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FlOsukiEpTY8M9wH6POFwbIXkDoSMaRFuyk1qztNKFlB20i/wVbIRMj89oA7+twyeXUWdy6ork6RZdkwAppOgUdz/Dp7+wOcsjcTG1Y/+LETkPe1+5zBxoEMyyQAScycgjyYOw1VlRiPT4rNUi2uY6favezFMWyNwQmV8uQzhCoe8Qtao5nB8yqvgEOSFMEVVfbg8gGhRnd6g7LDliCeDYD5g0GVYJrvEdsfqnYdWsh8lHtjCGUe4EMvYLVRZctBOLp0EGfFl2Ivz2fP3k09VjMypcvmpO/dmumQM0JAsAp7bCMmClbPatag/2GKuz5kc+qXdfBnRPYh33uW+218EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4UU1JYvylhqLcYzO/whiT2cXJ7UEKhsS1riVss1HRA=;
 b=Arr/wr80Zh1HEDIoIMBZqzJWU1jP+Ub55P64U1pYY2WTIQ2OzoHO3rW8xsvfEIFubdNSIKPVRZPE2ZIxkGacf6i2CwZRfYP3LkC66AitMgW4fwA3n82+F8+tBHQ9f4oGozd96uIOeEsI+BX1FUC1XufpzB55jfO+fq3SSu6zuzP7mOrEX5xNu2P1MqMdNn6Q26Q5Wpi7jzMvTkKdOm9uk4ZBP+1BTLUogJCX8qgkdwWoZPD3OBIixgQWTFvvtXj8QPuOnYBXXr0cRPXyne63qnhcPgEcjlczDptkZBscpNXCU6tL/fkipv/uYa9Ng0MVUZCJQd74jdqJF9FtbWcO4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4UU1JYvylhqLcYzO/whiT2cXJ7UEKhsS1riVss1HRA=;
 b=ifgC6SpZJgU4YtAgCv3VQi8Q4XkSto+erk12HFthPoC3C/VGn/Nh6hXeX94UAiUvIQ96MtIO+9RjVJebcUm+LbKpUJUOMO2Cr66AZ8MwlrV/ChnAIVvfgfh6krDQtXupwC6qkIwE21Rx+4csF7vFnEE+/76qwJpzviyqSekcosQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5386.namprd10.prod.outlook.com (2603:10b6:610:dd::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Fri, 12 Aug 2022 01:00:30 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.024; Fri, 12 Aug 2022
 01:00:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH v2 00/10] scsi: Fix internal host code use
Date:   Thu, 11 Aug 2022 20:00:17 -0500
Message-Id: <20220812010027.8251-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0073.namprd03.prod.outlook.com
 (2603:10b6:610:cc::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9b0ecd9-96c7-43fa-9811-08da7bfe0cd4
X-MS-TrafficTypeDiagnostic: CH0PR10MB5386:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cAx4ouqT5kuLXQgYJ2rfizK08uJ2ILEu/dd6gHyFkPxVtjSAXUTZ7hkAhJF9uLALvNsjVkftqqGEGO0gCUhlAh/Q+8eL3yh67/YiknhUE/cq+/0PkTELwcgmQFp43spa98AansGdzSDcAbwTa7ijUWQbHxt5a4HpNyoTg1rdeUrOQ+CMtgjk2wU5gCdJEa9DSKvtxmN/AoYU2BJiMyrACi0o4Wmnlzhjj3xQI8iRoKmeEEwrvPNICzDqfeItTBH1+nW3ukiWyMatlPhC3mW/G8r266sm6qpt1y+ViqeeFhJXHz27QGTAmYLMaJVp3I6sYQ2uEM52RyBCOaPVNflgp9vJawZ4ABnvvD0AeNooxDmyoxROJkb1GAAQlJffI/q3sWSWZ0VNi/uYKvmjbYYsRfqSMBR0yC45/W8CdH8lUTpEiz5HvMoPeN7vGp+Yqt+Jelc1JjDxIrnZqivkdwJ/2ihqJE4GI+0+8B+cRM2qrWQxOoGLsIoZhwI/wIvB1IKXtES0C37yZytCScoItkPTNBTu/yD18NnjOyMp6LR0HLUz3Z3KHKfewaUrwQwpBHEfxgmrPi008eVklBkvBF11TRJdMCoXz5MFnEHh+RAvoWCMSxRo9NcmcZZLBacPC/Ob9V09Iz0m7NeDnJzMRgQmtAVc3oWRyAGMolWwykzbmnZBHDiKwCMjMJQMVEpnaEhqCZUrRFIoH6/gPhk2N6YxqGTzlXTBm/vUaN3PEvmLpOA3S5OjOqsf0+asyVFwtXKcuEq0atiJgfQg1zWRUS52suYUDCPaWHrmItJExDv/SrY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(346002)(376002)(396003)(366004)(921005)(2906002)(38100700002)(83380400001)(316002)(8936002)(8676002)(1076003)(66556008)(6512007)(7416002)(186003)(6486002)(2616005)(478600001)(41300700001)(86362001)(6506007)(36756003)(6666004)(66946007)(26005)(5660300002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0HK4um2u95aD6Ika+8Di1WeZRdXNOTiueeDyzA7Hh1fMuwb0b19++zEzuK5+?=
 =?us-ascii?Q?HDtLw7ZbUJkM2bzM0NeLisGPjksDbxVDG/KFDJoJEz5B1oUrxrAa0YROlTm2?=
 =?us-ascii?Q?Fa7nfBtDcPKHTqTEA8TsePtGFgwNnyv15mibBt65d84gna4zZhkL6NC1/21R?=
 =?us-ascii?Q?+Z4SetidkI29OQJOI5YD2YzSSmSxWd3p3SIl7dO2el6yk8EZYpt+PJxfMYyL?=
 =?us-ascii?Q?6ODWthrWNDwDxPQpikTpE8oc4IPGO7Q7cKYXRf3gxHBZZuQkcxADHnODYbsU?=
 =?us-ascii?Q?QoP6ZMP2g2wUWbzy/G3qC2Y1sBb5+7q98y91n7acKL4TS7XuyVGxVRl4gPVL?=
 =?us-ascii?Q?HYOsRBu3lhPeSniJX8ASMoNOhetKU/CDR8+rq2iN+6rQV0XXp87WlWao0166?=
 =?us-ascii?Q?nMZ0s/OINlCGsdu2MQxJiHulJ1lfGpifveU7TtUHxRgB/tmPSI4v36HAXWY7?=
 =?us-ascii?Q?Mdxrd2RMYDwZWpIPLlF+WJQvglQvFSN/jeuBpKj7MlJ4gFwS6TxI4WsVMpHd?=
 =?us-ascii?Q?L0N+tmKDLNehIKcfgJYd3t3dzGbKKfImt7RAdqvMF990WZqsyWXl1GqlEirk?=
 =?us-ascii?Q?5ENqt4bzPlVpRQsYXQIiN/AFyq41apELBh6souxbFSwMjpBOHcUfabjcF7KK?=
 =?us-ascii?Q?qw/W6OSy3buMCk68ZNj/Hs/Axc5hO5HEtRaLbdjVTwPWsJ+vdok4WJ1CpDpi?=
 =?us-ascii?Q?lU92bnjrg896RQEx3dLhgdn6yNgHQMw0T1/XS19wxZLFEWcOXk4VBB+rD5SX?=
 =?us-ascii?Q?qQbF1X62xQyHFdN7QLFQU5W5h6cY7OPngMlOvmZC2NzlfQ1FIsKFT+0VHBMS?=
 =?us-ascii?Q?y4fRfulveYAu8h+qujPqKXic4Ex38CWg8QySdZYRh1YaLrAiAmyOescPcWzt?=
 =?us-ascii?Q?FqCySF1+LYDLS+nBbhOil7vrKBjpHmEvQjSTCt7DZpC2lnAyJ08SOyZAQoQj?=
 =?us-ascii?Q?5oyq/s36ei98mCkhloLe3pCUJgZwnX6orHarZDnLXuTcdvZOHaRM36zUGtLN?=
 =?us-ascii?Q?cjZmU9Kb2i6CbC3lSnmXo7otOxDNsYDaycrZMflj09CxuDiLPRbjznF9nB2s?=
 =?us-ascii?Q?8mhRhD8OVsJ6oI2iXt1snHCBDE1Wq+C9jVKZiU9JHNc1CGc9uQAodDNDclrb?=
 =?us-ascii?Q?PpJLGtuMPlR8GMXU38GD+Qa9WckN70hn5MDiRkHH/W4uBoFr9kY/vr9cXBuL?=
 =?us-ascii?Q?AtZ3zL3gcurPQC5yF1006RS/vfIZE+V6+gn8OSm65g5W/CcfC4Roc0Cgvjzs?=
 =?us-ascii?Q?P7Cpld+E59aaPVCUFvVrD/GdWB01/SwlZKoKTMISmb6/GttFPyvNfDhhOmn6?=
 =?us-ascii?Q?s9zGcP9nH22CpR+N56/QMm3Yea/SrDVfNeGthUU1R18ZRRXYtfT4+rzF72ne?=
 =?us-ascii?Q?TwZsJ2PQ7kHRCl1sG7L96wH/1sOosZd2zN5xpYqCshrwM2w8QhnE47bckmAu?=
 =?us-ascii?Q?IImBmv+F+627rmOs71ZuXmIg9ShYOt2q7/j3cHfFlbaxIdtcB5eDW+8swUj9?=
 =?us-ascii?Q?3trfVHSYVcLXjqgynnNXDjAzxTPgT9aOnvNqW6OInG+J+PAQ7bYYJwuiYcA9?=
 =?us-ascii?Q?9YRJ0hR+Km+GE9dXQj2D+9At1RpSG/uN1quUFmwTLpDXkUl+aRitgXkVjWs0?=
 =?us-ascii?Q?/w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b0ecd9-96c7-43fa-9811-08da7bfe0cd4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 01:00:29.4921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DDKjf8uDGot/KqgbXWQlcRZgRwkLFACFopYXl+AkcN3WecY6Tml/peaUChBo7U6VjNOSp+OfnCPEz5I/iX26bh2hbpeUfP3/iCcQGN6Gl5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5386
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_14,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208120000
X-Proofpoint-GUID: NyGdsukFEFOC1O2pxWSQvPRe_-rUY4ir
X-Proofpoint-ORIG-GUID: NyGdsukFEFOC1O2pxWSQvPRe_-rUY4ir
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over Martin's 5.20 staging branch fix an issue
where we intended the host codes:

DID_TARGET_FAILURE
DID_NEXUS_FAILURE
DID_ALLOC_FAILURE
DID_MEDIUM_ERROR

to be internal to scsi-ml and used to tell the completion path what type
of error it was without having to re-parse the sense, host codes and
status. But at some point drivers started using them and the driver
writers never updated scsi-ml, so we now have the bugs:

1. scsi_result_to_blk_status clears those codes, so they are not
propagated upwards. SG IO/passthrough users will then not see an error
and think a command was successful.

2. The SCSI error handler runs because scsi_decide_disposition has no
case statements for them and we return FAILED.

This patchset converts the drivers to stop using these codes, and then
moves them to scsi_priv.h in a new error byte so they can only be used
by scsi-ml.

v2:
- Rename SPACE_ALLOC to NOSPC
- Fix up email subject formatting
- Drop part of xen patch that removed zen definitions.



