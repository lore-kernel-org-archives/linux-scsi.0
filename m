Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF58EB64D9
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 01:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237966AbjFOB4G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 21:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237931AbjFOB4E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 21:56:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13FE137
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 18:56:03 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35EK7DVv011669;
        Thu, 15 Jun 2023 01:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=shrGmbpG+wml9AB44MXuk72fkwCenjSut0oDn2NaxZQ=;
 b=PNoSxu8NA4NGOlf3sKgrcDOmnZpuCZhqCH8AgjR37kDI14WnejxvRvT+y3ueMOV5S9Ww
 Iu8DuBFUTnne9sR8J8qTW4oflDfR7mp99MvXYpMg+6QIZ5CCt+0x/TefTKobn8sn4ImM
 ea0Lb5lzA2NB2LYQw6u9m1h+X7YI17Artp///Vm8EvCtqjLE5KwvsTd/fsaoIXZNvL27
 JH2oZsXt7E5/nHnnUDlFMcn4BYplZbDfAlhqSwWUZCK3ZaWvmCofWo1kNtrUI3+HCXf0
 TZluH49BN9L8QbT+lHWUrKWlAI08CjJgOpq/dPmf17njXMRgVDrhFbs4eHT+QoHjrthQ Yw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4gsu0t2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 01:55:56 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35F0EweF009044;
        Thu, 15 Jun 2023 01:55:55 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm6kehv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 01:55:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXrVc+5pvMcSQawWes3Pg3UuPA7z6R/qgx2tFx66g+ERpOO1rsSIgqxpX3jRKqbTWypl/+ZEyZP/Hr26DADU5kzFC15QHnNWXUkUI/EKFE9Irz9rCyKRSKyoLEQu7pOWvRXpFSE7sy1PKJTaKnhr6ihwaGegrdWhtV+ERStWspO3K/k2kkM1We5ddCQNBOkj+U+cqOrRHJcbalUFP1EszgYNJR43dVGXqX7ZRIEO9UiRcpHsCYTkarHbqqY21nqL8O60xqCGJfl+FgBOMUmHrxo7izy13CNJ1q/v+6nBCcipIsK2k7WWV09qrHrFRxVD0wiZWVR3Obgr73bd90X09Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=shrGmbpG+wml9AB44MXuk72fkwCenjSut0oDn2NaxZQ=;
 b=NcTHLu0liAG6t2hM6hQP4b9/0UNGwwPbRQjPm/2u1qh6ot3KSCW/D2mTN8ELDHG4CP6mx+LTgzDrthQqtHewb+tFg6gr5ebReNyR87D6mS61sMBXaDMBfpWoyMP/4rZwwrJj97nMFknewj6r8eYDpVLcxHGkZ5XPXnfQDn8jStcsED4A2c7MSJauNlXDg0Zp3Hd8UJexWoDo+ZcWW+8W88JAGcuzpmFWo8oVgJmFL+RwiQI5a/NwBLAGXc19WlfVINC7kFVgLYAuzwafMs62Ktyaa1kTosnXLScngqK8kZ7gE/DFRgyEPwIzJ/NALqVTCk0Rt3SAjw3VM4lYix5yWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=shrGmbpG+wml9AB44MXuk72fkwCenjSut0oDn2NaxZQ=;
 b=mjGihDabLYIqTToi/rLDrMbOdR8ZJ3fqYWPHaSFV5iklTWt6uC9hQJ/VkV+r2hBNgadRBeDc0mf5mjnBhxXq2V1Fu3E6V1rGftzjdjetaxo/gmtiDmPzJ78WpUWBYak3MsKynNscZMibvH7DrOobBBAjAaoU15QkTQOKFbUUuEA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB6027.namprd10.prod.outlook.com (2603:10b6:208:389::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Thu, 15 Jun
 2023 01:55:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0%7]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 01:55:52 +0000
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Add support for Intel Arrow Lake
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfatv68x.fsf@ca-mkp.ca.oracle.com>
References: <20230613170327.61186-1-adrian.hunter@intel.com>
Date:   Wed, 14 Jun 2023 21:55:47 -0400
In-Reply-To: <20230613170327.61186-1-adrian.hunter@intel.com> (Adrian Hunter's
        message of "Tue, 13 Jun 2023 20:03:27 +0300")
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0074.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB6027:EE_
X-MS-Office365-Filtering-Correlation-Id: 6481576b-3eb7-435d-f3e4-08db6d43a66a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ueZHP3pNfRRzA0s5z5rGCI7yDArE9xs8O441ZpwmqQ8Gr4+QbVVHK6VIYUF1qkItKbuQqBxlToGKCm3D+9G7FnxkbAGlL9u2xnGKeD0pTDSAmuU1QCsBLWywAIBZMGHfQHzqjROS+9rr2eO9OOpU8pNuh6WrnZKdeVF+5A1j+f2dguelpjUWz1d3Jre14EjKbubb3/CU3S1Ak8bD9wCbv5qAHnB66bD0JdG2nTkRAc3DG3NOMyxhj7xB+GY+mQHIY8cCeGJ/MKIarPnovouDk+Bwndnc6cRLlVbPyNymNkT8tOkkOEYWQ4cJgq2v0g/xmaqmaLLUw+qn/uWfftpIZMN4OAxlb5m0nRyjPpNdnR4+ajzfUCu3CR2PGGpQzvKt585lWNOc14ahEJsOdQdI8+iBvlyEfbne/xGThZOwcU7Uws5phXKqpG38wa+WLm+5NuzEaxYIy/+PDobWgYbXEg/pidaPTDbVkbiHEqVhqc/PqDzVgLN4hApWjtEl1jwtMS0x/pYuUz1h2Y2NZhoMkXUIxFkaAF+okYhQKqz+VCtEAEi6ub83nCRmWCbhyZC0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(136003)(346002)(366004)(396003)(451199021)(5660300002)(4326008)(558084003)(6506007)(6512007)(66556008)(66476007)(26005)(186003)(8936002)(86362001)(478600001)(8676002)(36916002)(54906003)(2906002)(6916009)(316002)(66946007)(6666004)(38100700002)(6486002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kaq+Fc2PqAgLOTWsEef5mzZnkx9BoK6kYkQIgPZJKgPXrWWpFJK1PNFHhgSV?=
 =?us-ascii?Q?D7hQoLJEpAqRVBIPHfibIVoRZy/TGTd3Xa6NDCrXIWXOntRBa0oKI2tCCUuI?=
 =?us-ascii?Q?N2g9ODr1XJxdDYEeqQ2UNt7N2//ORNYNnJ4JbwnNBHb1MiP2qJxO7Lc2AL3u?=
 =?us-ascii?Q?zCEfeVBHPIA/01QZTSw97/6b8aOQpiLqQnqy4D3npPZPrnOQdANXQLTX++JW?=
 =?us-ascii?Q?0UCGpSThs5ZkJe2mOHbOzk58T08JNSwFVa9nZuYQDSS1pkMTXq8RdTMtPy1Q?=
 =?us-ascii?Q?s3OV17WtlltTOugK7ztf+HJS0jzyJgBJESXLnE8dVQpoKvFRwEivCoX0X/gH?=
 =?us-ascii?Q?232DL/sSNraPDVBro8KT2K4CFA34gTH9IbWaendJ8Ma3y7m0fU6jQX+L2M+0?=
 =?us-ascii?Q?wuB+ConJ13pikFD1xn/V+Run7K1YhyMj21IgNQvVYg9mAgLoEVrHuC84jDCG?=
 =?us-ascii?Q?F7+xjDoYNMsmx5Y52imP6bFBRHLF4Ogmu8wPQt91Oy1qpQPrBcgTkb+YSpRM?=
 =?us-ascii?Q?T0AC1bdeBeCwyalwhbZuNs7psRxq8qTTPcqqF4kOEAUywYxs39+GOOIK+pGk?=
 =?us-ascii?Q?wlKWsPtXH924n5HSrhEaeViTz3aAS/g+tjpqYZn9hLb7lNjZbUxvWEXwwqej?=
 =?us-ascii?Q?LZYW4FT6coNzjjljvuvu/HrI6ePYcVpfi7uxiT3NDZNKOlfTmX7vtbrYMBTD?=
 =?us-ascii?Q?QnFUJLhuJRioZkXpym5cdwYzVAnHNc5Ggkkg0Lx5SDJ1ZIiQsPrv7vMR+1Bx?=
 =?us-ascii?Q?K9vi63fFlRJxVAxoL9gMwgZDrrlMEFk9szrk+frZVzKeAIDDpesjSELpTaOV?=
 =?us-ascii?Q?iyu2/HFNVGtgXMsKjauQ7aceoLcvHe5tNvz9+7+/7WccAHg7wuKUiObVSAX8?=
 =?us-ascii?Q?Wr/I8tUMBXdTmxKKf3U6PUEO+1R/hz6vi9IS1tnFKc7/D9DjHR8f0HgKxInv?=
 =?us-ascii?Q?oleyDNzyiYr50M0IMbARVIjvsq+0fz9fvWGb131JNXeXHwel6BweEh2Tp/Zr?=
 =?us-ascii?Q?4jbROUTvmQOSIMaJoi5l7lxp4IiJWVUsQfnL9ZVkxOIedefR/oruJvKZX0dw?=
 =?us-ascii?Q?fLFKOiMsjl9LY5LfQ6J3n587VWtwb2SRtyGSif+LKKYdx+6DgzyV2D27BZIw?=
 =?us-ascii?Q?wHObMqmFr6XRgaXDF+1tlpxYKDvD/dQTTdFr15C6ObWPt4KUHQIx5AiQeaBi?=
 =?us-ascii?Q?Xzv/itTyAycK3F/vWNjBVQlRBM+A62T06ncbUxZi5PMoTwZtJqBsCFOH93a+?=
 =?us-ascii?Q?wUHT5DqKLgHSBmkD93WPnqCthdjwFmdbVnjSsQUTrxSxdTp+6Hnv+Ye9gDT+?=
 =?us-ascii?Q?nUFeKsiMDbiefTOnYDmwhCOgIuOfMmuBOh/uDltkiy1HYecdKujwr15LFlq1?=
 =?us-ascii?Q?qWb5mBtNXzRFVM5Hde0uD1cEKDRBIJm4TEL8r6oh6Jkf8n8EBHZh1ylvgmOH?=
 =?us-ascii?Q?xWJmTZoeM5+TbKc9DE0yEpQGBFV8XFOlUftXaIwpSi9VAsGSXdMrh8RJbZqH?=
 =?us-ascii?Q?fiSucF6Cbi1ljq2EPOmgVuxHIVUWHfvDq/MHsP1fa/1j/7g0kYD5eZoEwKtq?=
 =?us-ascii?Q?THj9et97Hr7Bd7OpOj+dmQx01nfsaIOl8Uk1mQWJCktG274wQFL6rvXg2tmu?=
 =?us-ascii?Q?ZA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Mo2POqWduK+DDRIQZaNK6dFbVXRfTdwm59QFhv0SlN83zokyCxgBLzN2TBkh2TCmQpNtBcsb5+xk1+vi6mfoBpiCbPV+tZaquNuqDLoWmXmxAiZNn+rXmsCJ3Ib5REBw0BmFoZez7s6Jkj6AzyZkCMiYw/Tey5H1hujG2Mp3g7ci0adbHSiQTEwxfP0xA6+Mxf0mNVkmkO2Uh/PelL/4QvNueNH31//XmFGyVrh/UabLra39wTzVWiRAvwfYsSga7Qi4MN1zSGAk6vX1iXG3K6WmRhi8CBXOPf2Hm3AM9q2cRlrEiFspzPaapeCTA+ZyD9xaFsenF6GyFxZItfTOgxCs4gQ1QPHaKr9xPChSWW8Xn736zn3G+lX8fPcSdYhz2ySPp3OhRPBF33AerwZmO0yGuhARrXJE5hECZ3AgPJrmiGM8VqculGbSIuYQaA1mvM3sgcuiOz98C+I4RthEeSQudY74ciBFvPvQxwEuRBhj+UFjy6FOzE5JL/n+QsJCUgmmww6Mio7OD+Dtt4/eM8goovO49uPdeQLTZNNDHLB3f9gxn+YMonqqU5eUucXHSx+MuFD4Y2MWry18MoGgVFkMJLPMB3l8zYX5TwehnaLttmkCEIsTGBj5BLPqf3BhORUut7J7bxTLn1vUs7LM2VmU1dX+Xda3dKdEx9VKRtaJt5ysMEXVwNShnlJK4/awSDSECa2h/yJdbthTFWod7CF+FoGvxjdEs78IRdMsJoOUdwRpcTzkXt1ZpZmJVJqmb5hSovvzbf+tMFVs/ehL/E4Si8RJRJ4vMOgwRy/HdKFOu5PpgydTFLeG82M1B2if9UaXzDGQllgF9l2waUK2GYlQu43rzvr5hCGXBuL+h/WqTfDRChd9fd9nsvBZyOVWcxImYzhZ/B09BbXZw6e8Ng==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6481576b-3eb7-435d-f3e4-08db6d43a66a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 01:55:52.6274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xhWUhgPOFFtmKW+vJ+HTqZFTrsS2CD0+S3EQ1YOCCfex9StXUfEIfMJ/rNqCgTSiTlYKdHgeIT2GMkuu/UmA2knORAVyQkBmcZN3/swZouA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6027
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_14,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=926 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306150015
X-Proofpoint-GUID: 4AhFBFCKuoQfz0d2zOOiyUzKQIpC1tZ7
X-Proofpoint-ORIG-GUID: 4AhFBFCKuoQfz0d2zOOiyUzKQIpC1tZ7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Adrian,

> Add PCI ID to support Intel Arrow Lake, same as MTL.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
