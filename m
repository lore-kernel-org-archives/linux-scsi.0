Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22461C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 03:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243538AbiCHDP2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 22:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiCHDP1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 22:15:27 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E128DFF4;
        Mon,  7 Mar 2022 19:14:31 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2281lYDY002094;
        Tue, 8 Mar 2022 03:14:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=03Irp9XbzslalP3GJonsU8zzxq5GNvBwksrb4CcDbvk=;
 b=cCO6zFEkd6NqoyJSPHC2ivq5JCKdKTm3HIE29jpyn7ndJkvna/m4Q2HuD3dVvsHRZoTl
 o1Ym4F5WlzOvHPyKMthpKQhdfZOqWOkhLaSclC90+JaUZ2MbgjnaASGrpFXCGqWAUKkm
 xDi+pqBuZ0WUTSQQDAaFe7yBSRsL8ijQQlT0bka8EPndUmJDDHJIg2mRj+XvPlnbShHe
 F/jtcK0t3+t8rO+QeJqwLGu7DxmQ87cTE1r/p343oCV13wf3WHUOSKLzyxveQ7dZd9Ik
 wblQ4y4v0+fKRyl3kbilXP2+eZ3QlfaWfYlo63L/MOOAc+Bdou2EGfN8X0amEzml1iso fA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyfsdq7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 03:14:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2283Bevg045029;
        Tue, 8 Mar 2022 03:14:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by aserp3030.oracle.com with ESMTP id 3ekwwbhsbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 03:14:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=muGrPQG9lrKdqnA4+GFUEZH7Slu2TNZLSR2k0drU/eVG1YZG4TrXQktxxtNiDwzxn5rtRsekLrvxGd+d9dOeEXlSZVdY78NQOW62nv+Tup8Fk2GUE14uCNwO0JWFL6BCFVyMxqOyniNnEBz8xyXnTHc7WnMHVQGA1A0ZeNRE1RzGdvdpOwmij17zzUw3pw6CFJtfXWnFPlSjculkCHPwWFxxl0o2FrzcQcRvuUZTqKXlARbAwyn/Zb+5wGmbnpB4wGghRhkd6kFehtseRcxF5ETf4/lYyK4UTnb/pZeiRo8x4+5N6zrG/d19t5T2TXI0D0vEJv5DXYuuuui2SXj0EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=03Irp9XbzslalP3GJonsU8zzxq5GNvBwksrb4CcDbvk=;
 b=B7eWh2T/2r6U8E53IHsd+u0nzXrj3EsAN4C7oqIvZfcy6Mci+drIVP0wuoKHfmDT+oJOSEnxhrSlmIe0/q4q3xKSkQqIWDW/6wewRel3nmt0KRT28+1UdFlu+Y/ihf32AMwJ2DtyVUE2i6gRemIevQk7F7/lv6oXc6TTKQg9lYAYoiyoXUS/eNhHp9xoPT2BkUCMYV7NYfTXhd+uK1ae1bhQ8Wokv2vgRFF4WgAt4njsmxGdmZLRc5OmT8p6aQfYv4HAGMmUB6VSj/bmCfzoz/83ynKDYx0sg0xKF/Ri1+ZDX4JGG4DYpccXcYLTqcL26z6oqSIVupv2278UBotV3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03Irp9XbzslalP3GJonsU8zzxq5GNvBwksrb4CcDbvk=;
 b=h4bDsbZFOWxkZ3h9Lub7NpvfR7OywitXNBqNp37w/+Yqy9796qTNUj3VQM2XKreh1JKHWsiWWiV8QHpOrHxf/O0zIbqoTayiAvbPlYAZKTKZJMj2VDPbJuig4SJszhq63aTBdJVvFapb6hcyI58al00GshxnMlFKBaOiYdew48s=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR1001MB2255.namprd10.prod.outlook.com (2603:10b6:301:2f::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.23; Tue, 8 Mar
 2022 03:14:21 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d%3]) with mapi id 15.20.5038.026; Tue, 8 Mar 2022
 03:14:20 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 02/14] blk-mq: handle already freed tags gracefully in
 blk_mq_free_rqs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18rtlqgp3.fsf@ca-mkp.ca.oracle.com>
References: <20220304160331.399757-1-hch@lst.de>
        <20220304160331.399757-3-hch@lst.de>
Date:   Mon, 07 Mar 2022 22:14:18 -0500
In-Reply-To: <20220304160331.399757-3-hch@lst.de> (Christoph Hellwig's message
        of "Fri, 4 Mar 2022 17:03:19 +0100")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:a03:74::21) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64925526-fd5e-47bb-ff1a-08da00b1bd15
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2255:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2255D7B4532808A3BDE580FE8E099@MWHPR1001MB2255.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n5Nt+KyDQKVeQ8oEAhPZhS8QkVxZpZn+pGEzYgF3D8MypJPgLLb1GTcn9LlmpqhBG/U1oFcfqovJZy9Z/LeJMEepvL4RTowkENElDwavhiHVpY4oov1iFlQ/Fh+kE9sD24lACqwZjiLyLMzvM5eoAS5+Gz92lfbHxTTwdYIUCFrbZreFsoprsZUJIil1vZ2nQ5C0dX1fj891qmkv7pe4HQbK8wmS6eKmHAqZDHsUOO5myauY5zk+/f/zf9d9FYchFg/1W+BrbXLY+S8xJWUYpFh3zJpWrPMGLvI9OlSwM/y6TWMkQ8V3KsarNoA95VootYxI7qgVW9bY65w8oxOyy3Xgv2Smrv8ob1XXood2Jeul0+fqXhI0L1DMPm4fD40YZFAXzLUsvr46+3lfKiz+rwBJFdO7sruQUsnBHafe7vBp/5IzBn+/VWr40ruOl3Iey2KJzDymVNjag8EtcMJ7DDBiwgCx2uqPi8T8NFOZEZMhmuUyDCzLw8s0WBJRn23s2LLfG3TOTTSdaoblZZhGRMqpfnPtHa3lbzafm3bJ5mTXm3FlomVOWwJEXIPeHwKqGjM9X43FxEZMPG0rrI5avTD3ZmCJURBX7c53L3UpVNYpv/gFvcGzWkwKci7hJh0D+CuEfM5FMo6fiy+IebHDpGIG9B7aBbKnK13VwtveniecnOOE6potD1uRMqalhOuY9zyr0Mi9fzwgfXZlNrelYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(186003)(86362001)(26005)(316002)(38100700002)(38350700002)(8936002)(6916009)(66476007)(54906003)(4326008)(8676002)(66556008)(66946007)(508600001)(6506007)(36916002)(2906002)(558084003)(6486002)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tFRHIOwlkfIhhI59+5bfi4p/+S5Pypks13jPmWoZzCsZK+3tLPchW4rgGt4N?=
 =?us-ascii?Q?m2FMViwGOfLK6C43LykToO91oGC98wIjVImTo3YJnc2z6mPG7LFhTXHkrN3N?=
 =?us-ascii?Q?pspEOTlUCh7ROU8Y0qCt9At8ekaNBRhyHmLHga/iZk1m8z6/QGBX9jufb3GY?=
 =?us-ascii?Q?iN8PobA4YtbEKlk06rgjAQBW5Bt0dlwoUSoRQWR5QrOqm713tKJK0n31vJZO?=
 =?us-ascii?Q?aGQ3B2wSap2XKkXRUzrekMfNiAECNiIBv8fNyyyGQ7wQs2ByV59+ioa05zvd?=
 =?us-ascii?Q?KGGD0aCZ6AezkNS7COksHJrvg/8qgoPaWATHCktUQMQXLFor1ieRbURTi5ce?=
 =?us-ascii?Q?Owm6DVFrfnDt7fxFy7DJd5yMlncXH5W3djvsic9sZUqvs1EGW8C0E8ILS/zl?=
 =?us-ascii?Q?7h1BMXOLGd69YQ5rGrvMZHCoufW+ygvmqE15lE5v24yKf6xC28y1whvyl52F?=
 =?us-ascii?Q?NikjyrAAArwjxIOSOXvwKGxq6H4noZPbqZhqDtxyPyIOpfzo6nAzliLFjRkd?=
 =?us-ascii?Q?NBWpCnwstlOgTJvPmw4UWuxE+Im9KE0v2wY3C5rfn4g8Oa4kCTXkQjYzkowb?=
 =?us-ascii?Q?lcd3pShqSlNvT4i9aorKeqt4jQbPO/GKxrQIFFEKCbNJ5XcJD8b676zYB7gD?=
 =?us-ascii?Q?wcWdUVUo+uI0WM6ylbkw2aMS3i8ku7Blx4UNOyS9tftxibwWp8enhVxuthpM?=
 =?us-ascii?Q?pYeL0EKqe379JtP640Sg7Oxeww2NmeBLnM2agggoQSeLjEcIocFiFXWbnVzy?=
 =?us-ascii?Q?FCVPb/T421Fx0azJiUiS58NeWxT/aMaXFjcXi0BwPlaSB4zT/8eTK1Wivt/a?=
 =?us-ascii?Q?AVXEVqp6qjftd1qVMrr9PwEGRi5i2dQiQV413OW2Ur17zYpBXUeosuCPtfzR?=
 =?us-ascii?Q?44TGwSO62huTV+6cZXOPQBxKhmM5//my4KFAiHiUdJ7bXICKmgmBu9sbx77o?=
 =?us-ascii?Q?RAQy00RCranmCSwauifOIiGlBtaQVLZ35OOxbJMCqt8rT7QNMAjhkqgGvGbY?=
 =?us-ascii?Q?G919OWr8hOo9ahFrb74vZKUg3Zonf243654+DXLuYw1VuMegl+40QzUyM0+y?=
 =?us-ascii?Q?RT9GBTe3NtuVunKyQyEhry5HS3MAiJhVBFLwz1RyOVTkNXvQSz6JvnHAHK//?=
 =?us-ascii?Q?ONkPj/WAHvI9hnRcQ404mZdaeUq13PbOq50YZp2pKxPREosWpBG57qFJB1Xe?=
 =?us-ascii?Q?HuMUEDN9jvxvwBUKSs0q8J1d+PTDNl5BghDLlHmsoaTLBnn+/1Qha5SqAEWB?=
 =?us-ascii?Q?jPtDpfvf1gR6EPCj4ys4NihUMEjSSKKhn6YzhHN5eXQV9sIPqyUA+v99Ffz4?=
 =?us-ascii?Q?ihCFJlW82uVA2LDICw76i3p4KmfznFObGh4EjJjOaDkygJXsznJTHU+wkhwa?=
 =?us-ascii?Q?bkRIqIl6kWI146mAaOuIsa42NhsARRor2PSjEJq7zreUEjnuY4ui6bVgJWz1?=
 =?us-ascii?Q?7GmjaxtegJteLODncSJUjeGLV2MKZWHudLoa8RFi3yH+6MXnEt9shva4oY45?=
 =?us-ascii?Q?izSn12uqUuMLLKfEMovezTZrvs71HCmn0+oj5+YOFq3ONLfE8ExRHmRmFX1E?=
 =?us-ascii?Q?cxegqGV+uqgpNgKBh0uPzGhzKS0WHe+TfQrTJGUJuk2/NTR8dX0Q0xsUGMAS?=
 =?us-ascii?Q?CxV4kJkv6RH1x5brEd+a6H8J098wofTF6TZ7p6KcEjqofInZn1toqbr36/vz?=
 =?us-ascii?Q?IhgZ8w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64925526-fd5e-47bb-ff1a-08da00b1bd15
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 03:14:20.9132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qlQEzUW8pPdEDe8IUxTKY+4lffPVb0qgIDE2+weefzu1gu1t/mRBUoPRm2KU9Dm22gShUXBgn+II1o67gkokAe/7PGuGaKmDQQMVxG8YiHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2255
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203080006
X-Proofpoint-GUID: 6blF8bNt-rzSXLGMY-yp0f7J4mbk_GEK
X-Proofpoint-ORIG-GUID: 6blF8bNt-rzSXLGMY-yp0f7J4mbk_GEK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> To simplify further changes allow for double calling blk_mq_free_rqs
> on a queue.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
