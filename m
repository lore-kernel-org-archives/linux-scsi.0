Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08287C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 03:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242738AbiCHDbD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 22:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbiCHDbC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 22:31:02 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBF1636B;
        Mon,  7 Mar 2022 19:30:07 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2281bSFb028214;
        Tue, 8 Mar 2022 03:30:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=GV/e09AQIQOxFAWTM6BhLRiVtryNl6KrqQLDZbOQ/Yg=;
 b=zkCc05zBPX1Xfd19tQrIrV1tebAtofNTeI94B2T0bJKBOz2RV8R5fkx00MdSH7ww5zNK
 KRwMsy0Qmm7E5YUkBOLaLOOs6OPCA7L9/nU1dcDoal7r4U6En1zDUPCvAwB4Ka+Q4sRN
 Xn3IVobg6hwi+68C8t7KJe0K3UQv9NTwCrCvGFOUOD8kvkMEBlHJuHyEm+/5rtrMnbTg
 hRuiwNXktKjHgx1aKFtRQwv08qP8EDwJnkBeh+amCgQye0kEMqaevrSxTICNESQXWiSw
 zXxs/15W0msXm+aNOH9o7Bj4BoZlC6wQvM109AIm2nj5YouknjVtzlxabUBKtkP6hXf8 KA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxn2dtak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 03:30:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2283Qb5F042543;
        Tue, 8 Mar 2022 03:30:00 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3030.oracle.com with ESMTP id 3ekvyu792t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 03:30:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kf/rEKVWtz4jgjpe1N5vHm9bit60YAyVS+dMMG0sq/Xpu/qZpCCqXH8Gb3tgn+0Qy7bcapNddMGZkXftvMnZq42lHDRBGmpxWLotItYl0xUUDLvYj4tMI8w/qDp42DsPA0ueasrt+ij1AXxgILZEN8Vu/EiuS00POIvW5/Cn49pIOGmcHrmcp4ddjtoQkfGZaukRfMDeMAUAO4JlO7qej5Px9VphOoVU5OsZiXchvc0ZkL1Bk1m00oKFUUV9Ao5ucTtn4HUqiWL7Y1kgzLajvq5gLFhEFNQ+rOZrfKi/7SNrUzkHNLZ5sxrrqFwTPBo2KkVwnS0CZPVlIjnnWkjmmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GV/e09AQIQOxFAWTM6BhLRiVtryNl6KrqQLDZbOQ/Yg=;
 b=ALcWkVEGKdvM5m0UZL4vNsIK27a+bmESDDlGghg1KN0kQwUuoATScjiTurfcvyE8xGjcQS6ZB/Qdkh2qtL/nFIJTJoYg37nEyfQdwO9BmhsOpNYeuScYUbiY/i59My9b5BpKaxwHqMPhnyj8pPPF3MgkeWKLVMlBYnwGE93feAG20PSP7KojgL+FK3nlBcVU1mhGAdclxjlm3Hwut6dOmFXWArSuj5mTaPIXbevMok4SPzcwF7FHl1VLEUo1MTuI8rXlPpmweHLNzlpuEKj/jlpHuXkDl6GJQ1RFRHhgTZ4uFDrDjANl37hfzypYdB2ZQ/H09S8nT0+lGkk0GRDL8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GV/e09AQIQOxFAWTM6BhLRiVtryNl6KrqQLDZbOQ/Yg=;
 b=oMX6NnPGWrYq3UIan0RqjQzBTUvvomiEddSEP7c5A48eGQbyvAgcU9QsvOas+Sj8IJDoBTo6Dtf/ZOI+UDFuf3lOt4oOaEpJxiVLwNRW1bP0DKGoft6NxfI3Gfa3byYXbQqXgzqDCdEB5HQ4E3x0iCsBEb2fVCSYk5kgKrM3c0o=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by SA1PR10MB5758.namprd10.prod.outlook.com (2603:10b6:806:23f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Tue, 8 Mar
 2022 03:29:58 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d%3]) with mapi id 15.20.5038.026; Tue, 8 Mar 2022
 03:29:58 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 07/14] sd: make use of ->free_disk to simplify refcounting
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsntp1gk.fsf@ca-mkp.ca.oracle.com>
References: <20220304160331.399757-1-hch@lst.de>
        <20220304160331.399757-8-hch@lst.de>
Date:   Mon, 07 Mar 2022 22:29:55 -0500
In-Reply-To: <20220304160331.399757-8-hch@lst.de> (Christoph Hellwig's message
        of "Fri, 4 Mar 2022 17:03:24 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0032.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::7) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65f4673d-45be-4006-f620-08da00b3ec0d
X-MS-TrafficTypeDiagnostic: SA1PR10MB5758:EE_
X-Microsoft-Antispam-PRVS: <SA1PR10MB57583540AC076C64BBB013538E099@SA1PR10MB5758.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Morns9mxquGZnqmMiXb8mv1r/GSbFh1FdcZRwyhMvxlCFtPvAuNgN/cSVzUYNSKDKkG4FLRJA0omdT/yPyUh8XtOQPey/CZ2wb9RZKjSg9p4vou9v4xlqFlDB5RTGbSQJsHFBAq7AppM26SfSCCSIb0xcIY+JoGW/kWVCpalYkhG7pnprpYqOxTkpHjWk52MLHzWzLQ2BhznYyjufS2tvEaEJwtbYixPxlJNOm2UsIAJXeIgdat45f7ONmhFUu5+2nW0Rat6NJ25D0rcoorPJ3IhXGDQXJrwlOkrGuw/46aeORtfBqXEL+8LHzJDGst/CD2I5Md3RqKPMLxlhy5XCVtZdtRcCGcBqbwZF8CP8uf+0d2Dc5yhk10ib7Miq74eEPsnQixNxG7PojodjGn5z0pYl4g8Ovr6oWdKzcvOcXdexmalymcWi7x+h/hQ0Nbs/ED6xa7/9kvjrVGcMBjKh+Q4FBMZdGIl28Ge2F/SG3wzIE92hx4G/A0MXu2o4VNOCcNWHrEYUr9lrSn1Q23BamsVL8TErGHU4ZIuk7ZzoPOqEeZ2ILRCpRmJt+MzLARtEKHE1bNQkfS2i9heZsX/y4nj36+kHzdtC+eJfk3HpRcBjJv4sgKyfsbZgDdqfb2lezP67Ikz6Jk5Hog4OxFbivdLvo/Z7zpDv9pPBbU5Ob8XC+T55/mQsFwkPC0AlcqIKzwWGyEO/hqGbUnkZQkag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(86362001)(54906003)(6666004)(8676002)(6512007)(6486002)(186003)(26005)(508600001)(36916002)(66946007)(2906002)(4326008)(66556008)(52116002)(4744005)(8936002)(38350700002)(38100700002)(5660300002)(316002)(66476007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jh+bcsm5L5iAqB6+UvItC8rIyAR7yREA/N9xujgTV+BEH0OCYQvS+wQKWflh?=
 =?us-ascii?Q?BODYjg0ucGu1QfNb3gg052gtOyBJ6Tp0ruY3RITqPi2Ox1tCnvTWHXhb3d0d?=
 =?us-ascii?Q?9iE2CprDuLBY7VmmBwBK88u3XqpHwNV+lFF02h7lZsuJlRg+NRpfOX3qZjG3?=
 =?us-ascii?Q?2bofOeO14xwv/DpE9u+47L1Lfb8e5BCRCJ2gPpNwPgBH+e0pPBaqGln9Y8si?=
 =?us-ascii?Q?RWLWd0iWE6I3wAmzfmdDXh2WIqAbmqcJ7d2IpJCE1fYD2UvcGiXocfEP6bRf?=
 =?us-ascii?Q?RC1lLfZDzcRacAOv+nU7ReBMjmjeLw2HGIW6un9oZ7MRwFehwGPD0D7nMNFY?=
 =?us-ascii?Q?OKaAX0uHJR9tEArV5mem+0U2uColHLFim1LcZrroeeGz3vPQf4HpBiertSEB?=
 =?us-ascii?Q?zkGuGWib5fW3AvjGFxC85KSs+vhj1iY3YiwReC0mgKD2b10YFO95Twb9c4+4?=
 =?us-ascii?Q?zZmj6ZAoYue/cAdtoOMx9boHApOhR+sS9sCxWrSrc2pF2h18RMtRabrq6QsZ?=
 =?us-ascii?Q?eocq1Mqrnup1QZkjy14QtmZn6CeCskbAGZt7F7bUryfE8kWU9afNAvuC4JAt?=
 =?us-ascii?Q?+3lvACa51cnFhk6q0OwSFgT2wsOKPWyKUD3qA/r7EtveXbAbbG1ov4DZUTLK?=
 =?us-ascii?Q?MTMdeS1Mt4ECuWPWVU7Hugip8TFwSaX094arqIe+aspoM8eRRSaVmdLezR+B?=
 =?us-ascii?Q?mEO+UUtM9x1HowizTlXatYGahSIX4HSU0H3NamgArii9PzabgBqgHa6UyVyD?=
 =?us-ascii?Q?BxDQxV03XspawNnB5qcpYhDIPugZrzloZL2+RGS9a2RApGHT2e83o3sU3Mgl?=
 =?us-ascii?Q?n7D7wjM3cFc37DDc9JO17u/81PUts9t2q0bxWdGD5l5Uz6dQUqgBw8cuaFAO?=
 =?us-ascii?Q?lj5PKWTdsuU8lEBlm56hnO6DLC1lGYiOkxzfB99iF7Ya/25a5Qw9pDNT2HEr?=
 =?us-ascii?Q?pgMTXv1nJF15kDeYNrKK0T4Eh621j4vi7YYpoHyBNvUKQwaEgGZUnAQUOwhV?=
 =?us-ascii?Q?hrG2qcDWEfz/HGGE8kB8PhQRnJtAm9XOYIMg0nGO7fDLU+HSDrhZuyEQZsPD?=
 =?us-ascii?Q?ASJRLfN8d7Kg2wm9tyui8iUTmNsx73aCdYYzk/O05mdGDW+1X6UzpaTsoADF?=
 =?us-ascii?Q?EiqmNHm8xzYZ97EJl20BRLvIGETh2cnIKBY/bSRLBwRUcmPcN3ryPOnTnqc5?=
 =?us-ascii?Q?pN06HogcGRwuMR7k/X1O8nkJF9gtRULqQXWBYVAk/i30BgyovNd8ObYP0jQ4?=
 =?us-ascii?Q?qb8JfHCcl4808Z0VfSujDSOwfcbcjEQuurbK3hTo/ONXMNQjWtsJiYgl0L+F?=
 =?us-ascii?Q?EoyfM4rV4K6nyhRpBjTKmmGcVeReNZJ6+gkRpghXsJL8/UsjmzL39U8TxPJA?=
 =?us-ascii?Q?Sc2RLrrZUltEGPatL+0Nrhvm7kKR8EZdGY3WK1x3uu2eaoB5mic5Dl5YuA0u?=
 =?us-ascii?Q?a+rfFeYw6CinsGGe5EA3KQiSSn/3hZ44IsH3G8JxzlZFcWDdxM0bTXUs2hoR?=
 =?us-ascii?Q?bQp6H/zKrk0amrGgxCPFBYjP1eXZzdTL/pDJfecuQhG5sG/vWbJSrvXipcMB?=
 =?us-ascii?Q?cfwq9O+iJIXOy4u4LvbKoE2MAMWbTkudpzxQzdMsEwdyZjIdZG7VHkFqMB3g?=
 =?us-ascii?Q?wGuo9v26wLcKaBPKMXNVcQDt2sY2ISrqjFbeO2n6vOhO2bA0rMxl11m4FF29?=
 =?us-ascii?Q?diuYRA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65f4673d-45be-4006-f620-08da00b3ec0d
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 03:29:58.6923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MZwX59zXLLxExVBa/wnInQtH+i//JqAr7h0ANeSs0RHCPp7rVvexPiuTrmfr8jWQF9oCG0tqkC2c4zKQ/rrQBM8doej9XC7ABMdrgxG9y8s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5758
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=842 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203080008
X-Proofpoint-ORIG-GUID: mtAmSyb-W6tsG6M0qf_D5WEJU_SEH_Mm
X-Proofpoint-GUID: mtAmSyb-W6tsG6M0qf_D5WEJU_SEH_Mm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> Implement the ->free_disk method to to put struct scsi_disk when the
> last gendisk reference count goes away.  This removes the need to
> clear ->private_data and thus freeze the queue on unbind.

Looks fine.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
