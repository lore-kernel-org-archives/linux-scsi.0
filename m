Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFC65C19F2D
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 03:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237086AbiHDDlT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 23:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiHDDlQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 23:41:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9196B3E767
        for <linux-scsi@vger.kernel.org>; Wed,  3 Aug 2022 20:41:15 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2741iIKQ017622;
        Thu, 4 Aug 2022 03:41:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=yQlj2iU1w0ab89y3jIU2VsAVbSHQoMlLV7ZDY0xggNM=;
 b=mPm0wZmWkofLXPtvIAjJomQ7eJr8tmZ+kBy8Yo5H6iI2VWWOT0+p+IZYn9dnS4RklraP
 Mmo0ts8VeQMki5Fvf03hEw8SYJjudUMSEgb7Ec+xROApAjhDf2G6W4jHmUFhorFjKtq0
 mqnl2i5C8si6xrJvX7WthtMJ8cyjXJwyA0TAPBoJOew0NS/SH4oYYEcNFUNpyDk/5W1W
 s7qOA9xvpmQOcsz+SUPPSPO5Q+IV9uGzh9XZivBQChehfTZi9PfIdyH9Wb0YpzYGCNbX
 KG88pgUbcV+NiCG7ZbIFJNkSG0K4MflGeLaoOzvCDwXjbmgs6l/xXCPob3c38NoHLrlS bw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmvh9ucvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:06 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274007mE006766;
        Thu, 4 Aug 2022 03:41:05 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu33m5me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITGnj9cjXCAYjI7+MG4ieepU0hQVF1jaiwr4Vab8DulCoh4C1RHxb3iZXFrLyelmHJBSsQNQyTdnvrKnjAdVeUGpNEQkZx6z+PWCwRlkTJMdqnATOaa5ykm8ipVoLUnBNYCeeUYGr61JVtN5NAExpTlhMPYnMb0wtdtmZrQJbnrVBZJkzH2LN8rbvTYVdT4ovgnHtVil3e1AsWsAqHH1XrU5YXc7dNpJfNE/+Gi1Ma/vLomLyulzI1CO0h6kG+ZirEywmvwhFsd/2Hpm43f3lYD35W9pQdQBVrHXAwAeaqRYXbu1Y+20enadyHERddJZ1UXXxYxKqRGZ7P0lDF9vEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yQlj2iU1w0ab89y3jIU2VsAVbSHQoMlLV7ZDY0xggNM=;
 b=CfQnWDYEXBmIs2hT0Blyp3IAXaUHsih2PFU6ZOGiQiyPRYCuzgAL4FqKbf8pTApekd0PhXB5fs5+E7O0beNEKVkBLJEf0jpaV3fHbbytoS1wuV+DvI2K0wpnRYBwoz2+UGkL+YnPHvymjxGEW7y2k4IZrQg8wzL3P/r4W38DkNVhy7hbcN6/hA2uKrjjcKn6kFwdVrF9YvrROamlOlo9q1MgwYsj/lGvWSR+n6PuO5bZh5k91JzkZ2nq7zCO0vaK7KHpcOPOLMSg4z7FYKd5zMsB+2GGAuYJI+/+4drVRVDfGCEfpW+FwgzbGcleH/Gbx/DUsfOKiqMAcXgB+4kQoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yQlj2iU1w0ab89y3jIU2VsAVbSHQoMlLV7ZDY0xggNM=;
 b=mhB5na9ECO3Vqg0F4oRV9XKt1JB+ZbKl+GTPtv1gY+84yhn4vfXWCiZoPPv/+b2JQ2EduY7hRnWP/ozNt9RWOmNo1qSPCB2aCkS+4cTykQ1SiJJu4cmqAd0Wg9FBIIpSIdNlH0ZrbrbWaRRymSDh0d4uQ2jK6cofjfZuLBiMCgY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM4PR10MB6037.namprd10.prod.outlook.com (2603:10b6:8:bb::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Thu, 4 Aug 2022 03:41:03 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 03:41:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, manoj@linux.ibm.com, mrochs@linux.ibm.com,
        ukrishn@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [PATCH 00/10] scsi: Fix internal host code use
Date:   Wed,  3 Aug 2022 22:40:50 -0500
Message-Id: <20220804034100.121125-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0067.namprd03.prod.outlook.com
 (2603:10b6:610:cc::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3db7bf5-9fd8-44f3-3316-08da75cb2781
X-MS-TrafficTypeDiagnostic: DM4PR10MB6037:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uepKXXnDf8fVZy/h6YSmgXi9AMItqLuMiheRTFGSLM78vMshBrXnGY9VsMMZsjR1XTBtbwd/lDijNV3XVwlTNpJor1MjyXuGdclbQry4eWIYRYURHCFzFHbKXQYEB6iICHczxxehhrLReGW1V0RHGtuR7jJ+oLBkersvbVCHzRMZqpbPf0KQtWFkNh8+nh8qDCropsQ+Wcb416FAzOzDuHGahVpkppZfHgSz3dWbSRidOGA3Cw1WbDuchDUdVbMvdr4TqUVHrx8FayzY5BT879uTr7dWOqOh+u5PWG7mpfkXQzmCfeciZYx3BkSDQXWCFCXCRrlaiLKERMuSQMvd4sy9RzG6Z/i489Av+rnOKwQr5pPma0J7zvIU1AnPl2VIIowcGH9WGxZxVuGDnXVgE4Zrd0or4p36ZI+BZ1ROS+NaZ37WcNyhIVP7I9nYef6kOKhOq3Y9xo5+lhRumLKdIWRSw2KVtKszuTAIy79BvB8kZMStKLdNK12q3d3GzxHfoh3Kr4GM0lRuSHeymkDsPRjpv/+Bkhbs5Qw4v+c8NoSGRt5Vf8QYMLKLXwqRBQxq0/1E8/k4X0c7r8B1vFg3Kbu4BqlhMUl1vjfHCiJPA5DwBtZ+0qIWzwe2JVZi14vbNNymNN7zDXqB3Ajf1w/LmkqbtDvPM6NU2vxKSrKe2vKl0+3oVuhALOc5FXeUGl/rYF0TQJBsY00B5J3abzd0tNH6al62lTBfETDjIByqjaDs+awDLr5rq4mKEJFZHJOjejh8MtRq633z1LKR8hgnkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(346002)(366004)(396003)(136003)(1076003)(186003)(2616005)(41300700001)(6666004)(4744005)(6506007)(7416002)(36756003)(2906002)(5660300002)(478600001)(6486002)(66946007)(8676002)(86362001)(66476007)(8936002)(38100700002)(66556008)(921005)(83380400001)(6512007)(316002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qfb/drg5U73cQnTQWeQZ5AWDBG2SXYTdr6Io1pkaHsnU12f4QPW8GWx4Ki6f?=
 =?us-ascii?Q?Zp44InoGehOHSXviHELo77lvyZzteqH5/ANmN3f4taKNOS9TFTzD3EZ708ge?=
 =?us-ascii?Q?eOjGRPy2ew+vkIpEVAsF+YhhUWBv86QA+SO4GHThbM5SWz0jsZaG1y0E7/RS?=
 =?us-ascii?Q?5rqQmWgCx6HKlxMrEphuvjirJm9o//OvPOaKdlw+QBxJpKhx3UikTu4gUY7M?=
 =?us-ascii?Q?vxp1koXq/H5NwvLfyfE15iAK8angoDHWThhDaDS1mqQ8wYtAm2Lu4QacBeJw?=
 =?us-ascii?Q?HVKXhenIT4wXfMdgaJIeeR/70HPaPLLqh4Z23TRsaQ9Sb44ZymkE5Er2FH+E?=
 =?us-ascii?Q?8PjyM07m6QEinsgFUS/iRf85tTnK1yWY4WyngY4WG0cHPC7ARgxczrGBlvlF?=
 =?us-ascii?Q?jShRGf3MkCkfTMzCV7sWZgYx5ciaYjru/ZcTQ23/SdkF5av0yiiuV4eKiWdl?=
 =?us-ascii?Q?Fy/auPTvAYuzBNOrdIIrPWvYiuTbIkAuWl7L+wreSC5dUQ5MtdagjxljcstF?=
 =?us-ascii?Q?Xr0fXCZ2NGTva1v66+fKyqqCbRXSU0/RnQaLBvf4BB7JFECk3Fo+WosAAFn+?=
 =?us-ascii?Q?VxzDD4mM2eQtaqsUCiEEl4fH0EkSAwLSqeWVYaQKMMRbVylUbcfYwD87Sx32?=
 =?us-ascii?Q?lqXgVxysDMl/mOQfk7xHQtCNBhFWw0519muRTAb0ocG0Xc4jQehSHE58k/Z5?=
 =?us-ascii?Q?h/sMAUJYvkQ9NZXR89/iDMWWForZ+fm+OYcEih/Vp922z7yyvgQt2/QRy1M9?=
 =?us-ascii?Q?Atl2mRhjroq8k69KCIpjGzbKiBOd7bL2yQ2DAxn2dBZ4g67aSVUkNecXrIce?=
 =?us-ascii?Q?vdGuS2BLOVujt0TxXkA+QLmMttfuoyt1QTVmUVnzlBk6hxVD4+Jx8HkCCyiY?=
 =?us-ascii?Q?NxayNaxwKnPJ14DpFvEkGiqUKxgE9NfBsvx9nFVB5TNIek+EL6YjAjgTThsN?=
 =?us-ascii?Q?ndMkhZfkaQRc41QWcjrvbrd/D3BJYk2DfIhxfL7JhE0ckOwc1g8W7eX9Ra1p?=
 =?us-ascii?Q?EAZApI72ykBPoM7COaDhRi/GvisSdS9SvNrefIbDAdMq+s/XTWt2gSWJRgKb?=
 =?us-ascii?Q?gmyHvDTLb33H+vTuuJlBQi5xy0jQ7WTeu61RAO2pHJJvSPW52GRITy0FiLfl?=
 =?us-ascii?Q?1smCJ2qAwT7LK0bGfvPFZg23fnPlsY/oRQPj+DvgQ1nydzIEcmGuTeM8qsjA?=
 =?us-ascii?Q?2IUbNmhbycbebhc24wqY2yiIuRcZggfyUXHEPNYC9ZZdlsXfySr35VNUZe7p?=
 =?us-ascii?Q?9v4wDN0b86V8Khn1M8O6jzAv62r/bYmOpC075aVJKzXoIJ81FcMLiT3RnANY?=
 =?us-ascii?Q?F5W0NGU3gc45WRfn6v/UImOyCrWou7R8lVXkATvgbQKAy7s7hFdI/TpuPeAK?=
 =?us-ascii?Q?OFvTFu3KwyIguscZ64klpt+Wlo//6mD2DlpGfU+hnkBmDoDsARBwalRDKjEq?=
 =?us-ascii?Q?e+5kg5lPWi1Ou3mmQVJUk17VrqTZAMO3iTKtymCR1K/PWwxBo8W8HhB2L5yL?=
 =?us-ascii?Q?ZEQSMPIPDnDKLpunt4Jm8hm8+WxMBpNUMhtq2eBgeAXX5+nd3kG2a3FHse1v?=
 =?us-ascii?Q?I3knx9R2KwTxWVlorVOd1PlyVexhOvmUlyjPpF3PJY/YD0l5aEZebLPUho7a?=
 =?us-ascii?Q?PQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3db7bf5-9fd8-44f3-3316-08da75cb2781
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 03:41:02.8717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oa5+RxEaH1djxJ+wQcagt2D0+Qtn3RDwOHU1s8trUbEPRvFweLHro8TQo7ckE8JP6q7Z4nEk5QK/lxQKXkhbRT60K/FFRMzIHJ78QqVZsKo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6037
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_07,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040015
X-Proofpoint-ORIG-GUID: vqS95gnIyibpPgYCIPLlHtjj3s5icPGV
X-Proofpoint-GUID: vqS95gnIyibpPgYCIPLlHtjj3s5icPGV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over Martin's 5.20 staging branch fix an issue
where we probably intended the host codes:

DID_TARGET_FAILURE
DID_NEXUS_FAILURE
DID_ALLOC_FAILURE
DID_MEDIUM_ERROR

to be internal to scsi-ml, but at some point drivers started using them
and the driver writers never updated scsi-ml.

The problem with drivers using them to tell scsi-ml there was an error
is:

1. scsi_result_to_blk_status clears those codes, so they are not
propagated upwards. SG IO/passthrough users will then not see an error
and think a command was successful.

2. The SCSI error handler runs because scsi_decide_disposition has no
case statements for them and we return FAILED.

This patchset converts the drivers to stop using these codes, and then
moves them to scsi_priv.h in a new error byte so they can only be used
by scsi-ml.



