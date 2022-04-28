Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91759C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Apr 2022 02:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238683AbiD1CFA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Apr 2022 22:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241197AbiD1CEw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2022 22:04:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444BE60AB8
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 19:01:40 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RNER2N003700;
        Thu, 28 Apr 2022 02:01:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=R8ObWYPtMG03CPRLeZWCygFRl5ddYWjw8vgW6fL6rIo=;
 b=NQNFZEwB3/0hlXrOAETsxVXt4ekJktjCcnbLWHE7+AzqlSMZEuDseNFyGQPBfKl/DNsG
 dH4u6nAl7p+vIYeLS4dw7uTFJmgwvGsY6ZHvj3sdkhfTIqJKDPRJ68mZddgXHm5vpieV
 W4f6FQh6TEPOUV/xYDuvsML3hSabG2QBdB6Yr3A4Bpn6/BTuNswr5KLw46YWiZkxET+S
 9yp8T3059phHw5uaOCXNDuEeDMijZaEaeSC99hZ7HmiDKGAM/MfpTakNf7GIIUoS0IU2
 yQ0s2Cn2/mFeC9r5qS5Oz8nlW0ZhhlRsWIy9s3nrQjPHFtOooZti1S9IX2T8VvVPWFh3 TQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmbb4ta3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 02:01:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23S1u9KU035146;
        Thu, 28 Apr 2022 02:01:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w5srre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 02:01:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ikhf2u60g8kRckseNnxKmtVjiEBdc/iE1wxtZgINbZtFOpvHSaYftYY/Tk2yqFIjjXBh7Qkub2Ksk/I2YkFDydB1YcvNkwNkqBCjrEzeThdii21varobbe6yGa1QpeRqWhcPRKTbJYi/a1TwA2gkaFBj5UjNLs8TAYPXgHPxhjYzGMYgn6hZ1TzbHDy3Tcszae3R3o2T+QmeuVMsSqDZCwxH6n1wIy59jzQeNBSPp6LDEpJHmg+1uBIJx0AAU02Bd2FW2JE6dzdrycX7EvHfjdpZ5xRHkW+UWLo0p+uGTP5wfiUgjeCoiIWsWulFf4skDAMOv8tg6qBHAIz4RHyYuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R8ObWYPtMG03CPRLeZWCygFRl5ddYWjw8vgW6fL6rIo=;
 b=ThlvHCMRCGxYCcuxNMMZ5h9QWBxChS/qf2mshOmvfSGXnCN7C06aXqbba3c9CwWlyrkKT+MEMhMia8Bu0quC3kkSAyT1AdLBHWSRGMw5Ph/DguXPTQACVQ9aB86J99QbkbpKpgFzn1BoJjrxDT7eGS/Lft7gUnTExLlhgmpajTpfckDwmpUyKE6u/ebQWOBpf2zdvrFw1ukn9eSAlqTpM5vBvsgR0un+XQaNRYoYMLUKfW6CikIWU2+KesOiqeIU0NQTsf7cv/EcOVw04o9kMpfUJ41NCfHwJnN2YIX+tiyJAaHLxb9duOqY/IJQQGVf6WrLt9GyQ6xXOJpL4jEoQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8ObWYPtMG03CPRLeZWCygFRl5ddYWjw8vgW6fL6rIo=;
 b=PHiTM7Rr9FEizcmMyEN/Tg6p8GJJhR6YT+x4JCrEIsavt9ajbOlPqtYJsvjxwZGAFWAGwBUEtXxYElBMw4rwMF2t07Dt92m2fLszKgeinUhE1t0yQ6Kl5NmIFCxAQOF6mL2a24ui0Ia8xzdVAP544Z4NhR+Bzf6JADg36h4XgAw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH0PR10MB4891.namprd10.prod.outlook.com (2603:10b6:610:c1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 28 Apr
 2022 02:01:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5186.021; Thu, 28 Apr 2022
 02:01:36 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org,
        Nigel Kirkland <nigel.kirkland@broadcom.com>
Subject: Re: [PATCH] lpfc: Fix additional reference counting in
 lpfc_bsg_rport_els()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14k2eklu8.fsf@ca-mkp.ca.oracle.com>
References: <20220427222158.57867-1-jsmart2021@gmail.com>
Date:   Wed, 27 Apr 2022 22:01:34 -0400
In-Reply-To: <20220427222158.57867-1-jsmart2021@gmail.com> (James Smart's
        message of "Wed, 27 Apr 2022 15:21:58 -0700")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0052.namprd03.prod.outlook.com
 (2603:10b6:5:3b5::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22f79cd3-5d0a-4257-1660-08da28bb068a
X-MS-TrafficTypeDiagnostic: CH0PR10MB4891:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB48917BAE12F5F1270767E0818EFD9@CH0PR10MB4891.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6BFaGH/lSm7qke8ojVgndVjEBICUBPUHzPvKWSRIKE1IgYuP4Lv5JqWxF0XxkT+CNeHXEW2Y8oqBcR5DAaKKxdsvLLyxYTbBKR7SqtAphsqn8f7Q0oZX/OUEGdUCR9vXXWcBmy+f7NzcoEa+IcBuN4L7aEmyteSSkOBI1XXxioJunKthoqK2AL8lDGL6Dl61h2LlyU3zoUusfGQICUraWdLkejVZfIThwDdI/ZREL8ZHLIub270JzUJjeeTO1kj5Z+YBN/o/UDhoXHcUgwpG8JlQaa1BxyAPp0ugnUESeBeZJTFghuULPZT1VxeAP+q08mxYr2VsDUbz0/oHMLRJykL4qpO5nsn1gujfsaMG8cJz3T8DIqkq1vG8nHwbxMsknYmZGPkH4Dn47iE7CyUK3RtLhimCIQVInOcMj6J8B4YPEL0b7JztQ/fIEihxZ48YwrJP3RNaOvbH5bz5YXTwVnTwjnxjIxNet2L+FM+U/UqfcOElWvxEJKVr3UhwxxdGJ3pYUKc82185ojP1R4tMyrA9SWVqhU4hMmBZpM5vSaFNTlvLsI2WEmhOu6uS9n9uNUvuoad09GAiXSy4661XArb+IGOFq90RNnsaOAJJgKLCI6GusuI3RjpfPKwGQH6kPoRh6kv3EN3hmDjLBZM9ucUXvGgSxrNhnuuFXlgsLeCD+7+NlzheL1lZKDIiHmhtXhDZr2nDgtfkuXOl/IP/bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(8676002)(6506007)(66476007)(5660300002)(4326008)(2906002)(186003)(26005)(86362001)(508600001)(6486002)(316002)(38100700002)(38350700002)(36916002)(52116002)(66556008)(66946007)(6916009)(6512007)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DtuSTW0jfSx2s+WQpuU0SyMUv+8IYpBHxw84WEfd/T/I4sf/2sYGMq53jE5N?=
 =?us-ascii?Q?oAOOGNzwjzg1RactquDSmVyWAQcvi5IVCwQKj194OgovGplkdnmrSpGAYltH?=
 =?us-ascii?Q?f4xNRZgKTMH8dqBCTKld8X7RH8bh7ctLX+kDHMfNe8wr1uy+MFu1U6O5EU5M?=
 =?us-ascii?Q?AnNH8LqXFN3HxugJ9l1NRIGUKfRPhekoLeY2SDbhs0X4yD2KeIyEswoRhP1H?=
 =?us-ascii?Q?vYBjvhRqXB7GBYrz2sTk+dwQVLFGzzX0C+1d4q1FIEpvtnpXYi0ucmxO1CO3?=
 =?us-ascii?Q?v3xOy9/hViUgRMDQIlkAZbnH5trE9h5K9yMgS8/SzWBXH77etvm6HrZibHWp?=
 =?us-ascii?Q?fySjLa8N7ZDWiur1rLvxIBqG8b0ADEWHUvfFaQmp7rSLVD8WcsKsbA1cRMxz?=
 =?us-ascii?Q?lvtkmqveXPW2tNaXETAc9M4jFHDzDx50dp7aDofABOLR2KgUxg46bjX932hJ?=
 =?us-ascii?Q?BTKfZmIig31GEKARN1M+JqeZKyMNX6pmA8vmQHYNuEBkUTkVlARhtyUshYRS?=
 =?us-ascii?Q?LlpQ1jBu74TI+nzuSO41b2ZZP7Ki8Zc7XR8b4Jn87gIamYdzdhoQ3zKr3uOu?=
 =?us-ascii?Q?r3vqf+xFCdMdXBAgBXqpE2JDzVLbKNaXqEKZlUnXgLE8DuG8RJT5LeJ1O5Kg?=
 =?us-ascii?Q?BuGyOP7QfvyG4YFqhKKt+NFIeOH9oZKP8mvYdMPdXrAiMU7QbysDZwV31Q98?=
 =?us-ascii?Q?aluRw0ZD/CTzsshB/cDyyXTM9ghERY/6oC6fFzZ75KcSZaD/NOr42EuA8OEo?=
 =?us-ascii?Q?dLmg6/sTtHfbcD/x6a8dCqbtg3XmPiCeyaTvQ+mS/e5kqS26fNk33PA3tA4E?=
 =?us-ascii?Q?JeXEahFS9wuDxFXNPerIP4z6cdbCQQ7JsCNlqwyLf2xdHRvW9S068FqVI9RP?=
 =?us-ascii?Q?5s7DT60e8eYKFOsCb0RqxPgQAc3oztVeB/+1uBUdjvTuoAh+KuKPEGNIDb04?=
 =?us-ascii?Q?5iSxMTTnj5yyqaNcgRHfIc2I6I1VbBUJQMpwIkCHARHhpecxP4RfzSzobFWo?=
 =?us-ascii?Q?mTm8ypaxoBLL8V2q3bumxtWrQUdvNNxTdd3TrsxcBIZlGaZAUa5X2ElvmMS/?=
 =?us-ascii?Q?HFdCFIJ77FpKpqmEzbNGCjvoRxKhQR37zWP61zxQBORJn7/MeSQxNMk430cR?=
 =?us-ascii?Q?MLhnRR/GFOSowylFpat7s+ia8xcvnPShqtRv+aZXTal8xMuuocmpNITCeNZz?=
 =?us-ascii?Q?tmie61OnDcnhU6YIfvTSsn+xpOKbmOwRvWNqc86pnQi4N40jjD8KRvSRVg0N?=
 =?us-ascii?Q?7qgLHuJYN7gkq1ObReksrTOa0o/l0vk6jGLExqSeWemxo1Ulr+Nm/na9ISew?=
 =?us-ascii?Q?E0priAXl0zoj8PUZtjpb+3spiahRE/O8dqEBDpouBgx5zzXb6thO4jO5rMx5?=
 =?us-ascii?Q?ST3aN2YwjVYzRNmcnZliQFRDcPCl4lxC+iSw1azM2SZjz2LgO1Z7meyyZifl?=
 =?us-ascii?Q?zCvRo4JVbXMFzkc6k++TcO83w8tLzHfBUA8pN1AsGAyD8UlH6aO7VA5YutFj?=
 =?us-ascii?Q?YuOWX/413ykVKqHsMkI3tIh7FELf6q7RhVrRCy14kn75uJSTSaZZkgwDcjhk?=
 =?us-ascii?Q?C/cufRfTVsypH2e0QWcWeqL/H5liUDJJ+Fw4ndObsy2hMnSVlLX8nUSgDnD8?=
 =?us-ascii?Q?CIfRIqqPz0jav1wSh5nV3JnS4SI0xTOhWz8PEDMD+ynXRSr5yo/tqu1ZahL7?=
 =?us-ascii?Q?pMHDs1/BhKjwGqZH3LDMgUMOGlKQEprgVuzgYWoJLKCcEUh94cOZgPSNKYBv?=
 =?us-ascii?Q?wdShcU1pARCAAsZG7DyeoCSATjXl9H8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22f79cd3-5d0a-4257-1660-08da28bb068a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 02:01:36.1148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /4vrCODwIun0Bmj9+Bf5rngYiwYR08zZLxVB0AgC3wL0bXPUQxKZCydF6y3SLpr3U3Q0sIHrc4A85gQJhQIlKfpu5+UyGXo2dUncNfmWRP0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4891
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-27_04:2022-04-27,2022-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=742
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280009
X-Proofpoint-ORIG-GUID: 3X5DEDlBxo4QiNJELRBi9xxF7aPIGzIo
X-Proofpoint-GUID: 3X5DEDlBxo4QiNJELRBi9xxF7aPIGzIo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Code inspection has found an additional reference is taken in
> lpfc_bsg_rport_els(). Results in the ndlp not being freed thus is
> leaked.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
