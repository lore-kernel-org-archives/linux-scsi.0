Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73E61C61DA4
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Feb 2023 17:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbjBVREx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Feb 2023 12:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbjBVREw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2023 12:04:52 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0E83B0F5
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2023 09:04:51 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31MGTkew001028;
        Wed, 22 Feb 2023 17:04:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=ctmiZ+/D0VgJe7pn6+lL41Up7bSf4TfQby7SBzDUklE=;
 b=rsffq8oiz/NbfIfDBEXGE9T/IewNgpHqv0Sq3JmRXsi+QZPp3NUU+uiUY5zS17EjPtll
 TDPJcxvuBmGdNtPCoD3s/pzqA6+voKBPpFDcf0T+/oqn4q8uBH4+HPb/QaoL1BOFiiqj
 in8nxL1gH1KoOIRv72g8Ix/h4gW1W7gEJiwNQ0GO9IaQFhm+zQRzt23GSSxeON0HFt/2
 z2ek+RN03O6WoSNQq4wWowYDqiW/NiGJUUOj9gp9Q+NEWRkMKgbk0krBJbKtQd7mDp0Y
 /ra7hxVANYbz6TQebVfVwyNBn/y9GhKTq+ZXgA5Elajux2k05IZ2pU+AgAJXxMzTSoVX 5Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntpja8d5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 17:04:23 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31MFhisU031210;
        Wed, 22 Feb 2023 17:04:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn46tr4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 17:04:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YWl4S5EhKo3OJBz1iEE7Zv8hkcp1jJzH7t6QBzm1LkJk44Hw1pDn8uN/A/WrUKF2b+KwFMNAiwGLSHuh7MALn7fivUnnwqfq5gqNIPkmFiPRxwI/fRl13UVxt1S+20fRZliEQsbecSF1myMLV1CzdgAGmA1DeEmbl6nLq3Zyld5GhXUcAk8MOXVtI/6Cm/Q7kXwPKg5VcaXvs3LquZNgsZLcJVdA6ZF+ly29e7z+5nP6I5ykbE0h6mkPBIxXPXZdtAc35nm5WTT53ONZ9EH34AAI+4mO/b2F9mHeLblxH+tAjICHVV2fKV6Z4tks+TRuMZdipvInhN/YizvEX/S+XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ctmiZ+/D0VgJe7pn6+lL41Up7bSf4TfQby7SBzDUklE=;
 b=ef9wklrqZdHUIHda9CRpvlyus3ESO8PeRZYy89CBn34nRjwW4B34OlmUTlBGydYiW2BLbcUA95rLmgt+Tt5xsXr5F+NS2NSE8TzPWUmkMdfIlJVsQpLjZ8A2nDYEFJMOd5ztSeoBgl0p/zFz8kIN2Hrzohid2uFo+L8KblvXOa12g7rMLmGBz3iBca7R/QlkRg8qER6a2JD2wdkggiVA18DaW8xw2TYe/161BeedoM5CxNnxvH1ZUNQ4yO3gbH2RUMdQSzbdwn2wRLhjujXofu+KpbRqyvemWug9iaCGjKosd/N3NWfpS1OhTZoU2/2tI9oQx7pwDjYzobQ8CXUvlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctmiZ+/D0VgJe7pn6+lL41Up7bSf4TfQby7SBzDUklE=;
 b=aIgChLUYBVaOsFi5s2IvfhdOtmrWAbRTv/lYzkmv/JCqBMA0nLdjlNx/oIcf59umceKQur28EJ5NEfL4x22UMjENUB8wabiJP1T62aIVj1d/uKjLDATmAs+uyWMcEa2jfjJrLEtyfn0EXFZHcR/L/Ib23Gc9Mvn0L8AqSXXhamI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH2PR10MB4168.namprd10.prod.outlook.com (2603:10b6:610:79::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.17; Wed, 22 Feb
 2023 17:04:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%7]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 17:04:20 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Bikash Hazarika <bhazarika@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        Shreyas Deodhar <sdeodhar@marvell.com>,
        Shreya Jeurkar <sjeurkar@marvell.com>,
        Jeetendra Sonar <jsonar@marvell.com>
Subject: Re: [EXT] Re: [PATCH v2] nvme-fc: initialize nvme fc ctrl ops
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o7ploei6.fsf@ca-mkp.ca.oracle.com>
References: <20230221095708.29094-1-njavali@marvell.com>
        <20230221173521.GA13772@lst.de>
        <CO6PR18MB4500B97E46D7749B2D957836AFAA9@CO6PR18MB4500.namprd18.prod.outlook.com>
Date:   Wed, 22 Feb 2023 12:04:14 -0500
In-Reply-To: <CO6PR18MB4500B97E46D7749B2D957836AFAA9@CO6PR18MB4500.namprd18.prod.outlook.com>
        (Nilesh Javali's message of "Wed, 22 Feb 2023 05:59:54 +0000")
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0418.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH2PR10MB4168:EE_
X-MS-Office365-Filtering-Correlation-Id: edb8daff-343c-408b-d4b8-08db14f6d692
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qb0N24jVxwziIxx6NJdzxa/P1UTFWp9Ve5qihnZUMvGLb00eBa0VyMpqaiW4Zc/HDasjC3UYXPMxJecBjLBpK4aayT3kGrdfTPUiiZRWWbLTxKdtHwhcmPMzbfXwEcQ+UfFksGRenRkPbRLEX6M9ztVpk+Tt8223cNDWx7f1k/SEeRK4/MeuV4zcsuimN793WNZ0QbBBdsUEwXx+xtKQvtajc0T4VDrAxFGOPLbOjo8j3Pw3spoIChl1XOslkKl6J8f+uu1hh6abHTT9M4oHiMxLnGlFRUib1AachRyHYYnfMq9AvUG1ooGo/AbDqcbN+g5QiO6h4Tvr5hqZ2naw1YFbM6E8VpXTxTFohzOVCMv8b6QsBWSBUJfnCp7DJq9uBDWNJv6Tk82da3W0Y9G3lRQdHLbtmGV+Da8DXJYWXkoxolaGgjYL2YMv45fM6NF8alfSpTomxx214wbzBEWeMnLyL7A/8K69RPbLwjBWFquQBjLBoN0B+femacC0WjB+j029jYqauuY7GcBxpcUpK28HadWpa0Abq+oJBD0vsIKhfK8YSod8BA6VGnrDHdcxJq4qA5xMNmhPVegTBpg1vJMmFNObrRKt8DsaoBhcXNF2gSJc+nNfieUSu0hg8FLTfs8KFP1phzEgHOR6xmyH8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(346002)(396003)(376002)(136003)(451199018)(38100700002)(41300700001)(8676002)(6916009)(8936002)(66946007)(66476007)(4326008)(66556008)(6506007)(36916002)(478600001)(6666004)(54906003)(6486002)(83380400001)(316002)(2906002)(86362001)(5660300002)(4744005)(186003)(26005)(7416002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dPrieTUXzfL9W1ZeimIgjiHTIIOL5mECJA3eo4MFhGe5MA3+/OPDE9OwqWFJ?=
 =?us-ascii?Q?4rnO6is4caGU8NEdolwfhlLk3bqEwKB90MI5B7og+rc8tIEwrV9PqE31hNWB?=
 =?us-ascii?Q?mKCvu0L2Z+enbfOsxzD9GCgJZvqJTels6n8W6YtRD/00sn1bYoW8eGZcz/ey?=
 =?us-ascii?Q?6fi4cD2IBju4VLaIBW4xmEn0J1ZKoLYCJIuK7VJJfmvKQOxJBKiTZ3Z51oW6?=
 =?us-ascii?Q?Nq5hpxPVf+wfKNFEIGNzDIgz2PW/KkMc2i//80j6DL1JYtEArvIeVFte8Xkx?=
 =?us-ascii?Q?kb9LZAsiy4I7zaOMKsVQVdDwppvfPTx/wwOu9Ij3fLZF5R8GyguM6SCipIzE?=
 =?us-ascii?Q?AvnyzkCk5AYFsRW9ctIuwApHRJDq70JTaBG4j/vrSMTs3RxHkP/X6cNBKj0T?=
 =?us-ascii?Q?+VrlPVhX4MhybNAYMyzpA3AunDfch9cvti6kIcKJwT2Uw5FbDnrPurUVM7YA?=
 =?us-ascii?Q?OcojIff/sFH3z/wVm/bSvAjgbOOEYB3ZLq+9cE2PJ2sxSXKGVb1lpimI3UH8?=
 =?us-ascii?Q?cEhVpms7j2/eRuGilmhdS/Viw4rn7WA86aJTcmfn+GO+WqWGwr0d5EWAtiTh?=
 =?us-ascii?Q?gblTON74XSl8M7zUrdJbzsm2z6okxIVz/B3sgcFyMXV64SaogCgIvitF8SwL?=
 =?us-ascii?Q?ZleSxN66YdmMyMdqgUx3dlhW9hKDw8Y/Cvd4dyRiZ3q2LaGhfuES6Ui5+STo?=
 =?us-ascii?Q?gF3enylK1YzKVdosOHIDqrKpYfmQrGjfM8+G/9M7qIsL/wMxwOJ7mW0oszVZ?=
 =?us-ascii?Q?xAJWNoL0PC3ZgD2mGT0C6oP8f57aKhfRfx74D91noUTkplInNo+7kAI/R9eV?=
 =?us-ascii?Q?RIohGCdUK2YDSN7J7Ty5h30zfFCqRR12++P2dj4sOy5m5C9rGQHcdqGCOh1l?=
 =?us-ascii?Q?3SSu2zYS/l6jr7rCJX3zLIJOUVtgLl89TO+a0CR4tMnjX/MZg6RkQAnuXL06?=
 =?us-ascii?Q?DRooTkIT+X4tk08NJdSJE2eKrQKxuQbpcDEh1qfdlmXyRW50gtpBmr8HbZFE?=
 =?us-ascii?Q?85K5wYoMURlgeHOqgTiImSDg0tSNuztf71xZaJz7roy4+v4/ve0ZrbxGxews?=
 =?us-ascii?Q?PbM2aENTkhQxp45T4FrK+pdRLUgCdVwaAjVLJAJS/rGmv88ObxhHqmYl0Mq2?=
 =?us-ascii?Q?KUwfI4sx+l+dnE/Eb26gq0l3URfIs3Z4mhVy2DCUl+7/1mrL+Vft9rBPBJsV?=
 =?us-ascii?Q?VOQPN/ic+4UAt9C8yIxf82jTJpSQkmw2wW9rF7jIbRtvBPlA486t87Umhg+h?=
 =?us-ascii?Q?DqO4H1OTSMdieyBHG2jKAmf6/62V9M8aP/ajdxD8LwcKuw09jqAgFJ5ttNEg?=
 =?us-ascii?Q?4Xxc0/Ht7S1MQ5bAyJvEOo/YXfogydK44el5oMmJEulVwC4GQA5tYrhFDy+X?=
 =?us-ascii?Q?meCEA6OLDEL377xF7bRodbDQDqLEpO+MIL12wgYvwS1M3GgreF//WOaN6tAp?=
 =?us-ascii?Q?lv/VTcHY5MCxxFq4m1HRxxMCA0ntcohNbJuq5BDXhznl1+4TzGrQWjv9U0Ju?=
 =?us-ascii?Q?RAMNAdD9oL8PMD90mZIGdEQS0rWQwnoH4wdNS7prTtVx9TT9BafQDc0IOgm9?=
 =?us-ascii?Q?h36QU+t6S6v6M9neAkcgk8mcUdbKDxCr2nYC2fcqvDJZVnjIY8bSdxu7WlYh?=
 =?us-ascii?Q?SQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: DUxbcEi3o9aufBbwKRnmjihRo1SCBwsSGB7akQIcnLjM8/CAYhXqYC1KCCAvArVgzcRjKjmufEXp7TifXvl/i8zxEA1c813W1pDTM0yn3OQUWO1UTb7Q8ig0LeDvkfRfMuxz34HAGUq49SJJzxpU/mcJLdn9Z/Qc1T4RznMxzk+G3SSvy3udYqj9plhheX1PqnCARkeIKhI6RCayLOEXLaU1C6ZbqprbsBKQO34/XPnZQwMWDorKDXL9tPKkmYLKcZ867gtcN7APb5Kx2pZxIQVAdc7duOhS6PYS/kumxw1daTI8jANACvdvPS6P3C/fh8dfmeExJSWNWtThAejz79ZIJfkqEwT2/fwu3lEU5UTfA7iINVBU4CNBmgMTjnJXN2mVm0eg0AhK19b9Sv3RIx9vRRuZ6IHk6XN87SXbWEARvaXnZyUuD1hEY9wQUvFBcOIzToLzDpb9mX4mn+GGJOJTTXrSfGYX1QN7FgYywTn2vd70pDZuLiPb4hWGq4XBzY9jzzCbt7F/cDoy/6dySCBgfuy5vt0kXGZQ9FgmWYwAxQYyV0YfqhaicrZCB/a/XNZ48EK+xwmXz8zikgtwRGtnJ/T+axsa0fjuRYzp5+og4zCOCY72nSQou2RWqE8kuvlBtlpVbJCn179bq4FwJYC1HBLUbBBQl3d5o4SLPW31ioLQy0C9CmmEn9uTHfyJAtA4FuXM5JKC9BwLvac+OjSJhquP+JaQLtqYve+hTbE3/awzL3a2k+YEueMG3bT2/pRbo/58tovFa3Cs/LSUqIUUjL55Jrwt1l5bawsVKaiKsri0zWh2DcXtXd4WkMFm9eCqGilNUMwdr+53RR/2Iy6ilXTHSC+cW/pgWIvSyrBd+4DQpYAdlZYmRlyJjMrl
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edb8daff-343c-408b-d4b8-08db14f6d692
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 17:04:19.9545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MzWWG72MNNegdw/TNX8k8tL++gtewpXTK9QNCpIWpn8L8D6VFW6EU5/tuClWr/36cFl0MaXLqd7hwSwvONtrF3FwzrDzBL/uf8L/76mQowc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4168
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_06,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=852 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302220149
X-Proofpoint-ORIG-GUID: S_3lyl_IW593RDBh-Ee02ZJQavw3Hon8
X-Proofpoint-GUID: S_3lyl_IW593RDBh-Ee02ZJQavw3Hon8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Nilesh!

> The 6.3/scsi-staging or 6.3/scsi-queue branches are still at
> 6.2.0-rc1.  That could be the reason we hit the NVMe discovery NULL
> pointer dereference issue.  Any plans to pull the below commit to
> 6.3/scsi-staging or 6.3/scsi-queue branches.  Or am I missing
> something here.

Except in very rare circumstances, the SCSI submission trees stay at
-rc1 forever. I generally don't bring in stuff from other trees to avoid
problems if those trees subsequently have to rebase.

It sounds like you should be testing either linux-next or maybe a local
ephemeral integration branch featuring the various topic areas that are
important to you (SCSI fixes + staging, block, NVMe).

-- 
Martin K. Petersen	Oracle Linux Engineering
