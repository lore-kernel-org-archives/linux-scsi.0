Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C1AC6370B
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 03:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiLHDKR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Dec 2022 22:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLHDKP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2022 22:10:15 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C26073F71;
        Wed,  7 Dec 2022 19:10:11 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B7NNsac028378;
        Thu, 8 Dec 2022 03:10:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=uavj5SoDwxwUUIMCyTVK8JQQtYtQXNbl6QdQ6UO3y3U=;
 b=fv9aLemQVS446lJGFORitHJQ4z0ySQvUKcGj3ibkYA5uCh4gLCYzOtx7oK/xEKAWb7Y0
 51b2HJ4pm4i348q+X3akMY4TydKELKWe/XmEh9ooBNmXpwXgy3VFBUImbptauOqi58Ku
 zqiA7FJwo3Loe0UOvqgDKczWor7sDOVnYznwnH1VILGz15x4Dy1VV18H7JS1WRn/px6x
 hHISv2D0TYg0OWjqLdo/zYVayaqGf+2PEk0BzCDvUkNDCjJvb2u/O6v3fw9jqR5jQeLA
 46zOwFd5GCrGv1VW4sxgdcEhfVtkTbE19bJ8Kpn5go7bRbiX7lMTbBn0IhaV5h9WLLJN Sg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maud71wu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 03:10:09 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B82NLAl017144;
        Thu, 8 Dec 2022 03:10:07 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa5yv0jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 03:10:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=icwvSBk/XRGi2/yt7ZcoCe3A/MBvmHzVyvfStVe+7Yfsw6s4StXpkxPSu5xF0+O3WLZ0R6A+ujB+8l81q/zShiRdvfODPfs3QlQz7vzoGZQclxFH7xe7E+pHZLbKi1YoZFdYrvCJgqofL8NXaIc8NUgl37i0NIQljarobgEoPmm01SZEfRDI2Bhs6iKmGzQkcU8z+BIf6g3uC54wJkwF0cv2vLKLmmQlgEOPe3ILrv+T4GyJ7FzcAzW1VKXce+Oz9rE/OAGK3eWF/8CjPGwGw2AhBj/JVny62oWztXAb/MMnUancfXwYjd2ZyVHEY9rpX4TYxqdmu5B4qbrOC7Z8oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uavj5SoDwxwUUIMCyTVK8JQQtYtQXNbl6QdQ6UO3y3U=;
 b=DZI39JFRfq+xuos5X+nm72fkqmTkHDspxPkxLbH/r2+km26ZkDzRxQOnW84vzHfI9ch96eA+DGc9cY7KVD3Fh3wLGXjHrgw4/fyGQHDhU0E5hVm029I9LQnI6KSr5axL0cXGUyI4TnnaBU7n+QrWAddvzcq6oEcYbw6/Yto14CHLTKKCC+hEG8/InHylOOgQFxvkCl3+6jO4UflA0PyqDhGURhERcMHShuPU0bQC7q92djmbsf2ybx9qHtQ4Bs/JfrPrmta/A5FLPmL8rZWHHFoxeiPwp5ws/r/RbW6iaBRAonEtkkaEuA92jSg2GgEKhTS1J0FNNTgumnZo80s/uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uavj5SoDwxwUUIMCyTVK8JQQtYtQXNbl6QdQ6UO3y3U=;
 b=L+DTv0nb/7uIY4UNgSrFuVD9fGdvDBGokcN6PLtm5YOAJOcpajkUAOnxNAVM31YJlak8RSter2Kx/q+YRYYkk7CnkgNvxKZUcyAhrjrgpRQSabr1Q7z3AvPF2zlRrPhpjHsZoSyateOkNHhtznbR/F51v+RaEh4d2zMQqfC9L5Y=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5132.namprd10.prod.outlook.com (2603:10b6:610:c2::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Thu, 8 Dec 2022 03:10:06 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 03:10:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 0/7] scsi target task management fixes
Date:   Wed,  7 Dec 2022 21:09:55 -0600
Message-Id: <20221208031002.106700-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR02CA0019.namprd02.prod.outlook.com
 (2603:10b6:610:4e::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB5132:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bfa878e-268e-4735-e490-08dad8c9b472
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HX6Afj24Y7LmfpuLt5pPDn9PZPXCxc/Gu8upDfA7QovC0KNKQxuiiztRYxknUVs3xu5WxtDnt3UgKvl5XnmQ4RnBy5E1f3bDdjzQwnjKpYRIbI9zIwlHDWJ+akkpReEbF09qtJZobMmcZeS9hX77PtzQ8U3jZAg4I0NIK1Ij01S7fG2LP4e8s6vSz19U+ZrPd+VHzwC8u4rcKXGhPusZIMnK6SSUcjhAkNAZPhxXW6vJv6doInz5KrDxLktEjRe2dA1fk8Rj3mivD/8RTAzrZHVepNJJcmAD9B/h5+Md0SBuPfRixjA6nyZNwEN0dfN40CNFdIpXFuUUbge4apRrru1CtMDkuUIGYumB2okvxConxE1ZKaNWCFRURsV6ZCJO5cU7mh/G918bOi3D1h2Z/7DgSsZyC5ExKFynhS7i4bZ0D1J7zinvJi1L1cP1KYxHkN27ftVya5aQiBZzR7+LoXDMtExZg78i1/bOk6hErvAamjCRrb0MRMsIiyKMsSXuMsx8kY7SNYYuUEqO6YD3+ngRC9gVSMROsIqpoBFwGn1HUN6pspqIMXHCr+GifY8npkfZTjFsP3Fc36gmMVVbyuAEM8qwBzRenzXorcHea8ESXCgbK46s52uoUNP7EXNnHdej6QGjrtcn2DqOUryihQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(396003)(376002)(39860400002)(451199015)(38100700002)(8676002)(86362001)(83380400001)(558084003)(66946007)(41300700001)(2906002)(8936002)(66556008)(66476007)(6506007)(478600001)(6512007)(26005)(6666004)(186003)(2616005)(316002)(1076003)(6486002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KIKE5OVzLuFHfO3bOnjAWsoX/Rl9CL9EAx1QqgLdWgV1jTMCOXzroRwBupQo?=
 =?us-ascii?Q?S53krUHZYRzKqRH1s3c1kiTZC1flazelUIZ21C8FNra6gU3wiDbMAW7FXKFh?=
 =?us-ascii?Q?UOfvHItLVch4L2oYY9g7LaxB0nBNUauAShG/cznyJ1cdc7jjuec3184lBWL6?=
 =?us-ascii?Q?GBGbwufKobAfyGJKG1JK8gaWOJoAsGVSxyED0hBVBKQulD62nielPjaD4c2c?=
 =?us-ascii?Q?8ti0ubxlj5kjoMrt0NcbYKIdUNqTWm42QQrNQV36+7mGfrk0XWXUMYCJ6KDY?=
 =?us-ascii?Q?SoXrMDrFAb1ScYqIkpDwik2Mzk8gcGr4lz5qR7L12iwlEW2RllRSluIt7Mur?=
 =?us-ascii?Q?73GJjZOESqVJYdBAoclBhpXKvLyiMnRO/Kpu6cxjGFAMZjL5W+IoIUh2U5dF?=
 =?us-ascii?Q?VGM9TjGcqsZiKX08f8uSs54KHBcwzmbV4RUIHF5zk73N9iNGuUKoZWjNjWTW?=
 =?us-ascii?Q?SG6qAcbYQqAp+h3+QLAwYTcZsndpKSalZJ3X264jlcCqXAE/uJUOcazfE7je?=
 =?us-ascii?Q?Emp7s0UxJThHG7BnmvXItBSS7Cgs/gvrXD68dfJh7doIuKXd+FIkvG5NSxHi?=
 =?us-ascii?Q?f1rZxNWt85YG4ADvmkjFRmPt77/N6eZv2VLy5j1G5yBwuC5hR/CWCDg3VQys?=
 =?us-ascii?Q?aPf9bDUx/mr8YcEuyDMrg/BNrUr/By9gSvam1cdJo5bLPD2ZvWAVb7cif60E?=
 =?us-ascii?Q?6DvyPdKjlYK4FZK/D6iyMk8+nnHJpLj6BAkmO1XUt4cYPmZGLQHfIO/2cVEL?=
 =?us-ascii?Q?VdVRCmt6huclZSbVz0TeUWFAPqPW0CFCxTiVUbzAN7sEzBtvSVrAmXuIkAFh?=
 =?us-ascii?Q?Z+Tge43kuehYi8GUapNrLw2WRlTZVnzCqvqfX3JzYXE7d5LygE53xAUp3bHX?=
 =?us-ascii?Q?7RkvbjQjgN/Rk/oHMyYFchbstaSPsxnsgiTT0lTzk6zIOnukDSokTE7KhehN?=
 =?us-ascii?Q?tc53lhJdGXqDGS+NpX0SpYHcUni7PF822K09UpJajs5efRzeAheuJyCxjVQf?=
 =?us-ascii?Q?WMWUrwN3O6TpR3lGlteezC6VdChPHM9wo6FMtYPVQfNETeDJRmbWQ5Pe44Yo?=
 =?us-ascii?Q?bdMDRrRXsmnHTXxkfF05G9RT6HC2N8Zo9UP9cHHVov+OZCcPBEToyr6f6NjW?=
 =?us-ascii?Q?CEu3Gs4jyxQpVa9mneFbQy6FZLnzmx4MgLFyK4O0lloX0y7kiFc1XcRi9xMq?=
 =?us-ascii?Q?MPn+4+8RfAUV9nMa63pa7+B8bbTRlNJNZBvSqpPXmnFxYjY6Q+Rt+Qd9ghdK?=
 =?us-ascii?Q?9m0Gq6lEcI+jXgRUAtg5VgaBDfcvxxIXNApDmvTc7sG2Q3RiXM8UiK6HyGGX?=
 =?us-ascii?Q?HT6GbG0FolEHMhrasU9oc/NJAWE+w9WEaFULvNmw1SFiHEyc1qp2n58gusQV?=
 =?us-ascii?Q?2IBov5sRkiOnSKOsZhHZwi1qIDFZqwfgEf1ywv7a1CO1XC+2jztphv2Ska0j?=
 =?us-ascii?Q?BP5Dya7bVUI+TZYYLRfdMRzjphk7ZdSCs+koeREPQgfBKBuM7jqrYeTWPuet?=
 =?us-ascii?Q?U12HJSbw2TF0ljBU/rD9q9cXlhR9Sl8EQeD3ODrVXTt4JGAOXJJ4PaOUn+Ri?=
 =?us-ascii?Q?aH673ewOTEnX07JEQtcek7PwydOMvLjvm9Fi7KUg7aVkL0xzz/vbeNsJLveV?=
 =?us-ascii?Q?sQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bfa878e-268e-4735-e490-08dad8c9b472
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 03:10:05.5675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mb0sOCzQxCHS0V1+chh+mh+7YPVXRZU+OIr4rPJSToAV8jy9lpd0mDU5CjV8wxyoknguLVBaP8hxwO6w5AkfUPwkgh/4BvWIe4JzcGhokJs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5132
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-07_11,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212080024
X-Proofpoint-GUID: tK6UYBh29vs_AgNq6BnwZSrZK8_i8WoG
X-Proofpoint-ORIG-GUID: tK6UYBh29vs_AgNq6BnwZSrZK8_i8WoG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Martin's 6.2 queue branch due to
conflicts with the xcopy fixup patches. The patches fix a couple
regressions hit when there are multiple sessions accessing the same
se_device and those sessions are sending task management functions.



