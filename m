Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A1EC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 00:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiESAfm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 20:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbiESAfg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 20:35:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADF3D9EAA
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 17:35:34 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IMIlnO007800;
        Thu, 19 May 2022 00:35:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=0CgNi9CrcXKT/Vl1f/b20qS1e5AD5lSoE2RLqB47y/U=;
 b=zWUdpK2EkveyuIndHZbqSBIydC3OjTeIBKZX0NovBjKEsSZ4R9MSZhsGzuQfxsCLk5VF
 3Vl8aOA/O5LHuB+dtXyMugBOQ3fcMZeofeeXUJElbUNu6CwvZTNOO+fN/iyS1ja26CR1
 uXO8rKK2nik81P7cHqrPaZOA0mx9TsJ4TvGLjKqKU9LJgOpzBppfYClG0oMM5fffhoFE
 ZdBwsFhXlxUUY0KRtkFHvQRutKXQcyiklsZyCc1xhH5/8dAD0GCzOVBMWrCI5lloqETF
 58JZuO0MaODc4SshvEOt8KJl3qDiBM7rZSeFLGY5a2iw+c6NLmaNoiTvUVYdkz4K7sqx 4A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22ucajj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:27 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24J0U2SH020228;
        Thu, 19 May 2022 00:35:26 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22va9pcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8m++u2J+ffH8gD1Mwbtp3vT1/+0WpFhP0vR+zfTXiXbMststewzVHO+rD2hZdq850F5WAmfH3xdC5m87NXwQtGxHMSMcHTUKvqhK5Js+IifHzG1vDCWs+btAdKTdjVmghA/jDyrWAqpSTQwLvcloHwcDKdwOyxhuOf5ujLtSLqVc1kUwPvDPn+0rU8oh2EbM7eOp8JoxQCfUWB3WalqGD0BeneOeO5keYDxOjCpwCiCf5IhQD2jgO7NvH4XQmzs+2C/9uXFPDt4C3jRxWCfBzluxPRzghGbpXMQExLccw7ZdgU1tkJLuPR6//SKye7Bki1nUcKOoJzIrpELeQR7GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0CgNi9CrcXKT/Vl1f/b20qS1e5AD5lSoE2RLqB47y/U=;
 b=Cyjjw5dq888tPg3++N7cgw2QxynkVys0O7m0ujlMF4MeTiJ3obWprFloBLKSPrfB6GYqaa1qnN6MqKnQZlERiSgaZL2wqTxCdSSfIv7uSe5Vz/jKgKGslvxiTd+6auZIkFtll9kqZ3ktkg2/SdTkdgxDeApSQFRp90lWsCmLffdZwpvD6knXMLPNY4Gs0qpvwY1uLo72oYc0Eokq9XB3fztb5l8e8gumzxsnNGLKtoPy7FbKb9if+6VVPohtuimYTy0KhU9sMmXg6kEZNOOgd0UfDDwWq5ObplFM5Szo3lgSiCRND78IHh5DYCpofS9bi3f7LUIPH6GHWLVkR7fsxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0CgNi9CrcXKT/Vl1f/b20qS1e5AD5lSoE2RLqB47y/U=;
 b=iJPpY3KpbJLD6uGuXYCOjI4TqU+8sMIJH8KotgppKz5ziMi0FqvW/CbMwsTgRj3CjiR8KmbOiWVr9h+Lst/rLLzCHdxMDBLkS0jGKPWA0Dpmc/hJ8yF/N57qOgg8zrry9y40lNBq3Rwfm0W19ki4LtA7Y5MC1zdWydR0eneTYn4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3020.namprd10.prod.outlook.com (2603:10b6:5:67::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Thu, 19 May 2022 00:35:25 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Thu, 19 May 2022
 00:35:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: [PATCH V2 00/13] scsi fixes, perf improvements and cleanups
Date:   Wed, 18 May 2022 19:35:05 -0500
Message-Id: <20220519003518.34187-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efa9c55b-90be-4d02-2330-08da392f7714
X-MS-TrafficTypeDiagnostic: DM6PR10MB3020:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3020AF47565108F0F7998B36F1D09@DM6PR10MB3020.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: msfmxPdAAwZSyYXevvquTS6LjaMfz7xLJOXaqh88kreBinoUKi1SOZLpprB8BaCJT6d+8ubltTWix7GQfPoYrUETGnkuEMMM9/GjScNmB6ufo2TgL/2fU+OsZyQeBL6wvE+T2+S96DA6wC+hFFrBUlpPWzQn7dpaxcpNyIIJ3ibtvP8gtQGhREkVNMwqve8frTSiOf/UjGWhr2pU+Dv2ZWUZpSav5JVG53MBzCLi3ZX37XozwAQpi6ILGyIx6MVxmyUPkr+DARYcUJAS8yAem5n9bMhJzk1kFu5ehAkXJiprpV3gBIl4hQc6WHLaF7pA88/m16asz0jPMONTidDIkrjgOFgWo4lOSAJJG/k+5N7HWcZMt5Br4jrFjrjY+Vmanj59iU1Yaf7TSmrAmQtOqqTwuRO2XkI9gODVFW1Y2VJrZemAhZwJK5u5fJHr3w6SN41U/p195+T73yxnc+2/kwPU6fGTOTEBDLzMHETnJpsXNjm9yj/oYC+FvEqCc+8Zje/2KRfq2dFnxGQCd74tpz12/Qtc7f7l+IYRb9DPXiH1WMuaDFwHhoEEhuTIX3W7rjx3r+zi7MW7AV8qbIkhRMwpPqPP4vgrjgHGqZ8r9DYitdFzbd/HcwXwTIJh1pNnnzpG+sGNzoxn7eHE9MrPSx11l/bVlZKEZIayyTpLGim/owRRnj3h70/QkTde1zaCBOCpbf4KENtoPLPD1Yg1ZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(186003)(66556008)(1076003)(52116002)(2616005)(2906002)(6512007)(36756003)(26005)(8936002)(66476007)(38100700002)(86362001)(66946007)(5660300002)(8676002)(6666004)(38350700002)(508600001)(558084003)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G4iZwGPy0ItXSc+zwSiL0ucrUMBPs7+7kdgseP2WDjOXWHLAsSoqNKqeJLqi?=
 =?us-ascii?Q?TwuEUUG3uIXqe3EUmp8JMS2FE3ildLIAH6nvNHXPI+BZNSuNcAVLhwczMeZ4?=
 =?us-ascii?Q?UKmYRk3SJwuwIeK5c2y4arbvGtbNUwH7cewn+Fy0Y2OUexmUINZa49joxxBr?=
 =?us-ascii?Q?x4KnOFkkOpJ+Wfx0qhoI106hUVg9n9DcYbHyqsZEHeafjovDG2JGW8SeBQsR?=
 =?us-ascii?Q?V2K6vcHN6Y8ObtezReCcY3B11OssWMOSb0LeadNs1dHJNgjSj1z88gn8uznM?=
 =?us-ascii?Q?rJjiQYNa0wESBAw+yO/Ro7qiFeQd8yNhppAfzpOyZS+K2EYA++dkOmfi6ZbM?=
 =?us-ascii?Q?p9dG0Vr944WUMQmYvRu5I9s4F+EgxXcdTu3NSab1C5CLtmigQancvpmN7jQ6?=
 =?us-ascii?Q?kABm/+N0joQL/IkFslw9+shyQbaUw78TGV7gW5w0nnzmPt5dAw4c6UnA0Es6?=
 =?us-ascii?Q?zjMfSYAsxghUlbBuI4tli+WbU5P128LwvjiTVAzMRZXyawiN60zzQyIjAfNy?=
 =?us-ascii?Q?MEvRW9NcgfeVXdLglicMxXBBkyqnk8S6UJLLHQTaBpi7O15WHgeoRYPkCL0o?=
 =?us-ascii?Q?KO1mvB8mqwnyiF38D0roECkKnJUKGFUK3XXJr+dO/lrJ5TnnBOtpTnaQPqzz?=
 =?us-ascii?Q?HTipXLPf3ZXQhdJr3+yi0YwJ4cvv0zHgO2d/rAN1Y/Xt7KhR2KmmQ9vrjncM?=
 =?us-ascii?Q?G8wl64HhCIFiY83F8vkPAunX34nFvhUMk91M4mcLQZ7qFmZus3qjecSvdkNz?=
 =?us-ascii?Q?fdH7yUCJ0hzK6Q1WeA5NU2Vez7wcChwil0UpX6gLjBTBNcgQvwD/jbqCG0zG?=
 =?us-ascii?Q?8fJokyrQE43QWqKwVON1Py4VYI2pdLaW+eofKnd7VZomU+hwT53GMBSJRV69?=
 =?us-ascii?Q?9k5UEenpPUnrMNgRhWJVTqvc+ika9DwwrwTYIDyZDUllpVUu5bMg5ejwQYs9?=
 =?us-ascii?Q?733Ro7uxm/VjaofJfEKcP0w/OH1ld1YZ89VkykM/6nR3KejY1wQ385pTh7Kz?=
 =?us-ascii?Q?NtcbXjgWQGw/anhpRWZZbLGvjDI4oO/MK50mB2B8kBQen0AbzFxPZB8I39Hr?=
 =?us-ascii?Q?e3HcC/lL0ZM1R9/drUSHk2Y2OBZphmoYJpR3ADYuWZOKJzAgFXC9D7+2zduu?=
 =?us-ascii?Q?mPhX//A82rIpnPMQK3yPzjT1SiBRiML/RrYZFO9gTNrwW2+vxSlblnvZorCN?=
 =?us-ascii?Q?cdYsNiuCvFlAy5rfYIUNXRJA6rhBgkBigrOCH/VTvQEebvjiqSRicXouQYLb?=
 =?us-ascii?Q?xDhsF9PM5qX+OruRoJmWLZmj8Widi4olTHVpKLwQ/XlPyanq3u+0PlR8frrN?=
 =?us-ascii?Q?YrZJA/aF+IrwHtoiaLvYDHKYsto5Jrr9aJ1NfALkdysKREUQKFsF6h+J4Xr1?=
 =?us-ascii?Q?g9x7Sf2dEOguWCtoq0RNC+En9ohlZAzSPTe3GSJzOuJ4vHo4ttb1yUiJsh2W?=
 =?us-ascii?Q?kYLryeDv8x1NIQBRiV5VI6gyln3fZ48ssU1VVNpvbXEuVU67Hm7ZdPWsVzML?=
 =?us-ascii?Q?AwdclBhn74WjwPgOD+uawAVIMGLAvTJPBahBF5sX7givxIkdbMQoKyjONCYM?=
 =?us-ascii?Q?Yrm7yT8L/Gd8+DslnG+QoivKZApLz4jwks79RB/CwNrjrNdlJTxgAQmiidex?=
 =?us-ascii?Q?kEd5E4oLfCyNe+XjCbVHtVmNfQtacR6f+h15kyBqKz5+GpZ9L+GWuqzfVi1x?=
 =?us-ascii?Q?ETab7BhKANrMifkCyhJTUicjI31EHgdk3G9wnhoDveAeed3Rs4sA2pu5kxwU?=
 =?us-ascii?Q?FHYIgcao3q9xukOPTpQxyxCmBcII2U8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efa9c55b-90be-4d02-2330-08da392f7714
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 00:35:25.1963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ySqeJ7R99+l+JBR2kDPzDZlizQ1tC6LdtvbYkIRWFHcBGE98Aprst801ICEk5XdVoyBSFjcGf0GxB2hTtnttWK6apUh/yK1G81Llfr6j/zA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3020
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_06:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=927 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205190002
X-Proofpoint-GUID: T5kJPY9rcGkTEOVE4Vsik-SY1wl6p3sK
X-Proofpoint-ORIG-GUID: T5kJPY9rcGkTEOVE4Vsik-SY1wl6p3sK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over Linus/Martin's tree fixes a qedi boot
regression during shutdown, improve read performance when using multiple
sessions, and do some cleanup.

V2
- Fix checkpatch errors about incorrect commit format and code style.


