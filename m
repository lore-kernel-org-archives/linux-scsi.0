Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C585C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 22:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3423B611EE
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 22:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbhKEWNu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Nov 2021 18:13:50 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:17922 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230088AbhKEWNr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2021 18:13:47 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5LffTO014245;
        Fri, 5 Nov 2021 22:11:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=fb1hHqKgjs6q92C2AOHWKd9+vkNZTvbWkKUDF7A2LPQ=;
 b=VAd4nq1GNTQM9dlDaQNVl9DR/XJTTlcmrz07uqKv0zc8bLprIy+VMiEfnW11CNz/GK9k
 QJ4LiCg8eqbFHvMGZW7iuhggBhaOV3srY4fjZCq2MJYcXRMmSfzD0F0OtISewAqOMfaG
 zP9/eOe7fH8ig6YM7x3vBZO7FMDmYEgWtNIpdekbNKnlYPqSndSbMRV9pbcHE4AOK/xx
 LSbeLK2243EDosRLgqLM6uUx8mOrV49moaFVYjFV+sz9QSV4CqXi71dE2CeFqMAjYxDn
 KIn0oPPreqdfu8mrg77XS9/KYV+HFd4OYV0+ce0xuB6GiA8YepaTnCfjIlC6xP89qY/7 Pw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7bw1s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 22:11:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A5M1Bto064362;
        Fri, 5 Nov 2021 22:11:01 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3030.oracle.com with ESMTP id 3c4t5dkemt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 22:11:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WcgPM04hn+tttZbigyEXSJ9CKuDOgHM94cqi7aG+5X6NT3Xlwqs5DToUQO/JQyBz+YX5RH9p1u2BlxBN9PY3fcDvYNe9cWhLfp6+5mUsAZchHCYTg4ndAaU4XIpR4Z5RchIJRkxuERu2mH7UsnQs8m9Zzg5FWOSnXWpp5f74PlrbL2G7oVXR54uB28O3DckQoVwKPVsnOvRotYHZzekaS0zWkEWLeSXJFRqpN0d7S3soP3LVDJJV9K6nXJc9wxcrMc+Yr7LhHVmnEea1Gm00Whs6ZDRTaVvUfbdtdUoLwXL+/YtYhczZ7Is1KmGJipd0pCnf4sS5HDW2NpyWGj7hEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fb1hHqKgjs6q92C2AOHWKd9+vkNZTvbWkKUDF7A2LPQ=;
 b=FvccLvzGB4MNFEoMXqB9tIdMc/Zvxl8Td0CGZyr6oDTKiHe4CoQfUINKmxWtuHu0WrqWmpJpulD05yN3bjWj10RUuf+NBjXVOhfIDjlUTwcP0JHBhX2MmvHotK+bewmHw/aA77/6Q3B/yu7CE0CYG5ASe2xJ1rfNAFnsbVA/APO6LFNjBm6+FyIhfdVslZKDfGy7CWcwXO/FbaCQ6EdNvtU3ppyaukkGvoDws7av8uzAIo6YoKMfTHLxr8qRhVUk4y1lzO31mR2n8Olb6GTlrhvwagFN6DXaUTw7IHEeigPY+Z18phZ19+oGzhwjMLqvQcZ35Pf61qT4K9PaUjD1Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fb1hHqKgjs6q92C2AOHWKd9+vkNZTvbWkKUDF7A2LPQ=;
 b=ECL2LN9S9wcv8qEye7ol79QWumm3ekfHm1VdruIA96ke2rra9XkUczdi79RYMMY2cSHGlpDtX9BxCyLH8xxFd8g2q4zvrc2d/8VUr1tDx7+0NDu2ZTfnusGPbzhY+AyK79Ug9jU94cwuKH7ONUSZ2UZ8BW3/WbtW4bZNaK+eKfQ=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2588.namprd10.prod.outlook.com (2603:10b6:5:ba::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.13; Fri, 5 Nov 2021 22:10:58 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 22:10:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH V2 0/2] scsi: fix hang when device state is set via sysfs
Date:   Fri,  5 Nov 2021 17:10:46 -0500
Message-Id: <20211105221048.6541-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM3PR11CA0011.namprd11.prod.outlook.com
 (2603:10b6:0:54::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM3PR11CA0011.namprd11.prod.outlook.com (2603:10b6:0:54::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Fri, 5 Nov 2021 22:10:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1de04dc0-7deb-44b7-8c8f-08d9a0a9243b
X-MS-TrafficTypeDiagnostic: DM6PR10MB2588:
X-Microsoft-Antispam-PRVS: <DM6PR10MB25885AE52A95502C5E534E47F18E9@DM6PR10MB2588.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5LfrlXvq0CEANcmh6uBbAG5ZLpQcZm4TqCGqe+vdEuY8UHyDRt3qcQRgkMvwuPCcXYDQw47dV/uGZwbSqMl/K54uetkJMXsiVwwbnS5o0Ic89z5Zy1ImlXhAlPqb7xdy4vSyMXF2o63ydhYfTNQvpbJSSoZ083PNXG8eO0CKOrO6UrzGHWQQh279TpqJjpd8SsX7s9Duh5L61qDbk0eps/oWUqfFe6yXo+Z+pX/tb37+gofT570C2xQzwP+jF7XSIdH2qLzfHhu323MWnX4MVzQzr0h8D++ucmWUukXHwv8ZT2fEqHV6OqFMFDqmXYbeOaHlcalAMT8rKPRdkR4AeTsFuNcvjHjrStUsxGegSAK3U9rQ6dbPB1RyOGLt0jhWfXoqqp9C/vdY9I9i5/EAe7B2IotRYyLhtBEs6pBo/RwIWH52c1Nfee9ixRFRbVTIfBdhUx3g0QeK8gnewMqj6M2s/2K0n0MGND7DSzlQGNvZlsJslfXPF3TZ+DcXoAtzqD6huMYNkx2hAegIvfKHPpGzqAJBa4WwA46bSr4NJyk2Le7lW1NpG4i4sk18djD/4rW4/wEA5Sl+YJoayGitxHBrXWwYzmmz6yRysoFgeuI7il+hAAk8sBBYO5RPh9jiXY/nAM9E47ykW3BUt11Dfp9uos0r6JHHYeiXS95uQ8gOFP9X99rwR3nfoP0i4MQdBFE7bmP/5b6hbuamEVKiKJo0PFr2p99LoMaJwJ0WOaTln2hKFAK/gCmwGONXniH4n0B/crPP6QQmxfdtcsDHtURqWwjytFwwtdHPCnfULZA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(1076003)(6666004)(186003)(26005)(316002)(86362001)(8936002)(6486002)(6512007)(8676002)(508600001)(52116002)(966005)(956004)(66476007)(66556008)(66946007)(2616005)(5660300002)(2906002)(6506007)(38350700002)(38100700002)(4744005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J84vyVt4TURy8+OW3f9P1h1vHN/1gTUCA8KBp2lcQAijqToDwpF5Kge6/Ebx?=
 =?us-ascii?Q?dtA60OmK7cdCoCWu/7f3BAmG1Ikf8SiGxk+gCIz8k4ohFu4kbL62yfXNXmHd?=
 =?us-ascii?Q?FPGXAMSKy7q8CqL5exrjhloh/cJT7Fcei9UjIi/5aQQ9K18aC5Yz/cK4IADQ?=
 =?us-ascii?Q?uoBtYUJCsQAvmNUtvcMRwrbCy63lo0oB4Sd02o1dREjEHPZvx9oGN+zzl/90?=
 =?us-ascii?Q?IiXCk3XJ5fBVv8kREeOlZOOSCuFbCNvy2t9QSKsAcj7iKa0/Si1IZ5Md52L2?=
 =?us-ascii?Q?65ZBJ3ygDAapnjo3VY/VDdfO7YHQT7gsB7wl8B1x4VU8RTgIpZuBnLQaxzFL?=
 =?us-ascii?Q?qdbpa68bQ2/yIXdVfvvMb/VO2Ysdv+wT49/ljbPMNTjVZDMXd1jnSxEMvlVj?=
 =?us-ascii?Q?VrtQESMQAIlR2P8YQT95u6+aiLa8Es9fzGMH/O3DpDnNyTvkmhW0fUN8e9yM?=
 =?us-ascii?Q?dAfpcVlwI4td3agnOMCDrysesvPLyzcjuQkuZtgxnybfY3sRqX3eFvDKIVFY?=
 =?us-ascii?Q?H/5sGAoFiCs/55odrzVPFj2A/Pv9WwoUbl4dAOZuKzkihtjMwvEJaIdRE3V7?=
 =?us-ascii?Q?6A7mA6OoW/sw7lQoGOvDjFTqOYPKdy9DKXVBWkDvpl3VyOyRwLPweswI1eRW?=
 =?us-ascii?Q?qzcVvE4+fTln5Uecz0Aiag4e0OR8Yg+VDVnE+/1ZWuOHmLCXP6RS/EVyuoxh?=
 =?us-ascii?Q?eSPzMVa4AzVlP3U6WZFk8lBTm0VrcBcSFJOVrjvWDy3WblltinSQNHnihFKw?=
 =?us-ascii?Q?4LdkKgRwzsFJ+kWsF7uuIRPSFuKkCK7UZ7v72obgHAWdEdrbFeKrUB5u1PPn?=
 =?us-ascii?Q?54LQfKH0GfqAuNLWrfvAwyYtgeYmhAxknYSyybfmcqAUt4S5LK8vSY5agKWe?=
 =?us-ascii?Q?F57x2k0XuciLmBDylXJIgLXdOhNW24Yqr/N+HIBYS8+ijLRDO/yCiq+WebqV?=
 =?us-ascii?Q?xvYYJnX9u/nYAVmfCp8Q6Aqfvd4LxQrkQdPeOrjOv7oMJeKi+IzoBUdAEtPh?=
 =?us-ascii?Q?hhl99jJWV2GA61y0dP0gveVnkZfIKuBLI/RzAKqR3UBE3J1YcjSDgRvRB/IF?=
 =?us-ascii?Q?h31DuVEhYkL+9tWY+Lw6MbkuzLEoaktaKDXI0Mquat/aKw3HJ9OVTc89hpBh?=
 =?us-ascii?Q?riErCBnojAYzchScjnI9XcH4Kdt21/R4aHiD1IMZoVed4lfzgtpLh6jxr7T8?=
 =?us-ascii?Q?2f9uSigJXiFZmulyV4WyZcjIky3FXALWK+XkQokD1n/byzcXGbV2T5CaD1uu?=
 =?us-ascii?Q?e6/nAxbWVumlxKXkKJ5iUtQv3mB+lUoa9EUauJ0jOp1Dg16rg3wrL+25EtcQ?=
 =?us-ascii?Q?HihvH9qSRbnmP1HNq+Z47Fyde7nBmY6ifij0iNSkeblcWyYLUzN4Kie6cvp8?=
 =?us-ascii?Q?meqWu67cHZoCjdti45sihf/r4Zy/dQw6im0R8jkF8Sx60qKUJwLO83Z1yef6?=
 =?us-ascii?Q?vAEEKjy1nrVdNgftmN1uTRkTT9xyj/DO+nfE/047cPWdEvyIgfBAK+v8Aljx?=
 =?us-ascii?Q?hQfPwSiyex8AB+32d4U24DcBKEzIHqbKOE659QaJwW88+VnXl2xNNhM//EVV?=
 =?us-ascii?Q?jwQSdCsSyq+cUNpQCuughiDPUI1NU46AfWowt7OLAPmFYRzkhACxNVBxVgQc?=
 =?us-ascii?Q?xQsaV9Yya2u1Q7fYGUGKnyVnf8+qTH4ymNxp6aDwvZsU+Gufxq4wGISqj4IO?=
 =?us-ascii?Q?zRC2Sw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de04dc0-7deb-44b7-8c8f-08d9a0a9243b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 22:10:56.9114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wjeLTqWYykQJXm7eWzQgB8gePA8lPZiiwk1gPecmc07jG3C6jMxMiH/tmc0nRmDxHDVUFnp32BdJTVXougARvGtasW3N+9wl03UWo9q+HMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2588
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10159 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050119
X-Proofpoint-GUID: cGQuzD16Erapc-pySUo6KfD9DYx6JUDY
X-Proofpoint-ORIG-GUID: cGQuzD16Erapc-pySUo6KfD9DYx6JUDY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches fix an issue where during iscsi recovery we deadlock
due to iscsid calling into sysfs to set the device state to running, but
the scsi error handler is also just finishing up.

My first attempt was here:

https://patchwork.kernel.org/project/linux-scsi/patch/20211006043117.11121-1-michael.christie@oracle.com/

But the problem with that patch is that iscsid can still get stuck.

This version 2 of the patchset allows the transport class to always
set the device state to running after the iscsi layer has done a relogin.
It then relies on a check in the second patch where if the transport class
has already set the state to running, iscsid write to the state sysfs
file returns without doing a rescan. I think this is hacky, but I'm not
sure how else to fix the issue without breaking iscsid or the users of
the new rescan behavior.



