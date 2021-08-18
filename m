Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F6CAC432BE
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 02:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7447C61056
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 02:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236663AbhHRCZZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 22:25:25 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:17808 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236471AbhHRCZZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 22:25:25 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17I2AxUi009712;
        Wed, 18 Aug 2021 02:24:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=umBZmtQfnYeHBTUhliQnfC82Ss5siJ/leWeaGBKlqos=;
 b=UPF7QgDnk+m332pU94uivUQrabqcjrZBYuGx/zTbMo5ivE3lLUdkCwOsknqL+gONXoMC
 Z+KtrJJtWz0RTGRKEUzB8IBXXV12h5H+HL0HWKoqOebxgB5Q05a9+hb61CAxRHwJb8mh
 2KMCUMIdpWAsaP+jJRDXCnG0/2jv6be0a7Em3TxNpahzUqavAtSLf7rjn07hIW41QAbk
 LoSDHwn/R4KPo0KYtFqeqq3VSj9/O8viDUitrcUszxUOmtmuJC/oFOVcvGeSx3DSmniN
 FJvDgfEbi2806bOByuVvkpZGJTMCVlutLHsktLz8K6q2qzViY72ezp0md5axoriFyo/r eQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=umBZmtQfnYeHBTUhliQnfC82Ss5siJ/leWeaGBKlqos=;
 b=o7gPqaQuB5r07O3LtcL7iVsu4MDdWBOcTjUPa34P6DCgiIjv3G4odBg9G3E0AynU63xy
 BFWJahUZP2pDntvCt6QtbsPWomcATbkTDnMl0t9H6OSgyJvztNkI3EVj/wOXqsSpH1u2
 ZlVOWuTn3fgW8k6TYCJzChZXlDT7MPW4s2OIXn++8kGjZATMTyaT3wS+hmgZVbRrcSf3
 q8fwgshUMcAY4crMg432anicaOM1w/sfVrvf5vYIzxUwg6sCf02i6VptONvmv37jZpMA
 5pKvqxt5DbTK4+flnISR3ZzqmXZKRqUpkfZdrm6WQnFtQ5faliSl/V7tWGk/BfEVEpXo Jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3agdnf1psm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 02:24:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17I2AuWM150391;
        Wed, 18 Aug 2021 02:24:48 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2049.outbound.protection.outlook.com [104.47.56.49])
        by aserp3030.oracle.com with ESMTP id 3ae3vgmkpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 02:24:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6yKR4KdKptWF5e/oAhVV6NRO/h3Ptq12zSyMTX7e0RsFvyvUUkK8CuG+J36ooRZy9GRW5VAYZSq4Qgz3Cy1IznclnNmdrreY70aL1MTMC2BwbDa8nXIyOmng0riZvhQM1c0TDackNqUM11n3FSHcUenGcrxl2ubKigSwt8sJrDS4gRbylZy9/AaNdBnESIxSGk8IAkliq7uFns8+la7IQOysJRvJzmx+tYk/oc5tBwqCsEAgIzJdrVXAinbb5aue4VK3UG9SIun6wK/Hz1SzPulKFGMJUA/a5MzQzhHPYY2lM1w86LVwo4AvZZQL5BxOPQnxluhmgLn8yjnZ3FeDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=umBZmtQfnYeHBTUhliQnfC82Ss5siJ/leWeaGBKlqos=;
 b=YZYJypP1u4puDyfYW1VkD2qQSjSXVludtmfFoQi9JM1ysjX1pbh3Q+HE2QOPR1Rg1Wv/vPcGmLsz0qTDwuKmhTFksGQkgtjXt5o2zXmYpeKruAolb6iuvW2CAGWt92p9CfVUrtcS1UP5Jm2s17N1QnzMbZCYyO132CGbQiATXqYgj2uh3h4pdNze/3EW1N7yF+CTbdj0uuL3o88syjzcTF7ELH6HV6ylvjhnJpLLBycMcibqP6l8xH4h0aYZfw63SyHGtPAA5nBhyeqaLSyKHAWN720o6uf5hynTnrrdli8dqmBI3rWK4Tn9Ag08Ht15SiG1g8DlVRRFE/x//s/9ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=umBZmtQfnYeHBTUhliQnfC82Ss5siJ/leWeaGBKlqos=;
 b=JhpfDor80ua4RKuudLEz8+RImYGLqLqyATfkz4O0Zmyiy1V7z/m4SmVKAGawJ3rzt6847rP7a+i9BSHPz+1n5pWKhrNSu7jjuR14eC5gRMgdNTzZQ/1GC6bE/s7+6U8XBgyDyXlziPW/5OeQWZJBq/9GSrGwvrMb/iA/BFksEPY=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4533.namprd10.prod.outlook.com (2603:10b6:510:39::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 02:24:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 02:24:47 +0000
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v5 0/5] Initial support for multi-actuator HDDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsv7mrrf.fsf@ca-mkp.ca.oracle.com>
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
        <yq18s11qqfk.fsf@ca-mkp.ca.oracle.com>
        <DM6PR04MB7081F31C7933E6C50E10CBB3E7FE9@DM6PR04MB7081.namprd04.prod.outlook.com>
Date:   Tue, 17 Aug 2021 22:24:43 -0400
In-Reply-To: <DM6PR04MB7081F31C7933E6C50E10CBB3E7FE9@DM6PR04MB7081.namprd04.prod.outlook.com>
        (Damien Le Moal's message of "Tue, 17 Aug 2021 04:06:16 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:806:20::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR03CA0025.namprd03.prod.outlook.com (2603:10b6:806:20::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 02:24:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb77bf75-658b-4116-2e7a-08d961ef5945
X-MS-TrafficTypeDiagnostic: PH0PR10MB4533:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45333BBF57DA09D9B7E850768EFF9@PH0PR10MB4533.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dQs8o1FxH8fGC+brjQhMwMTYhtzx15ja0mLsMVas2i/ugZtBQYcBHOCOoyUACFnItURqdUGBBuPl+W0OOC5roMWeK1Zu/w04SUrXWK43FeecLF4VNN+lgxvgRyQRc/mWHFQ/bXjc/p5IE4m6CufTNp3sGfnndAycnDBXMvn2BwCv8yQHyXPxjfyWWAqCon72smWCoy26kULPPN3qqjQOu7+2BfXUOouAWb226CpQKo2jIyvpxl8GlnNh4e36MAS+12Td2m/DLkl3aGQDKoZSh0HFXGv9uVsBFmk5DGIQBL/5uQDmVJJIGXxCp2+KzTT8DL90jFXFC2i2Xf4mND2ypgfGTIjKQg593LA6CsBBxVaU30jliYOhFh58fplc5bBHDvDGNV4IGqEW8dGHQYLDuie6ywkGi3nxfoYeT0oIc6ToeEfMeh/xV29jA++FdncjYIJU5QabqxL+pa6ew7fttnDIkyFg10m6RgBszjQgbJSGKF2jhu2zZZ/PMMnp1GEFboZrmd70xQH+2PuDZdYax1cCHLQkPrTwKmsHEnQ/ByJmOaR6/rVXpUTach0sZl/RLvfh3Rp/KEassSoyVN/3BJQMm4woFT2B+BsvL0RX6awChXfPR8xYctTD0feikAoKO+kr5N5K8xxviiSFeuUGWWX5CtPehOVhANP91X+iZJxaZPzVypZWvccDBozJUS4KiyDyQkKUi9bCFwddT4jXXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(396003)(366004)(136003)(4326008)(2906002)(54906003)(36916002)(83380400001)(8936002)(5660300002)(52116002)(6666004)(55016002)(66556008)(66476007)(478600001)(956004)(6916009)(66946007)(7696005)(38100700002)(26005)(38350700002)(186003)(8676002)(316002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+CIxe3+sgbMPAd7kZBVlaK4wIsauhxuwP+hHN9UC3KexZrz1PubpsWPYObyD?=
 =?us-ascii?Q?IxleCmDX1dzpWvIi1Kg3GHi61x/glgH8d+/h48a4ue0k68CaZCtp2IevjkFL?=
 =?us-ascii?Q?C/7nR+znq/tyWs7GXhL5XDf21vA1RGsx2daxJGdRuaK8BJ4SKzGUy5g8dqUp?=
 =?us-ascii?Q?6DN30QiM+zXzS1+GyzZJ0DpklkprbHgUFGxuLetPhyB9hPPiXVq4c3egdpq9?=
 =?us-ascii?Q?s8T6TgEsJuZY/USOqzIWcIJl5tSynEtdxCcvvlPaOkn4CMhFQmNb1Fx2mHWL?=
 =?us-ascii?Q?n//gte6zF5ZzfS5KI5ffyBYcCsAJt50jlPXOW7uN5/RbTwFjLJWJjnccA15N?=
 =?us-ascii?Q?+klSs90EegiIPQnNzNvxT1vhmgH0qim72EJMmY8kaMjmzMKxYD6aFxK7Do2k?=
 =?us-ascii?Q?yHbeoSXiuZQnSKwrXR6R2p0Cy6Y67vAO8v85JhDFLJ3gyLKsaXQNJXnRi7pX?=
 =?us-ascii?Q?Qq3ovxALKwUueHcm3bBJCI8vi+FZ+1xczlUvgMKCfYjlfi8KRjmwhnlf5inE?=
 =?us-ascii?Q?LHBkwvyeySUKwzWKpmuncfxNhBZ32VSD67Lc4wQg43S+uFnqymQGPt6nvDLR?=
 =?us-ascii?Q?GX7GUYjGQZynMJ1KYI2pIaxg4Hg7qP8/YFLGa4epPVcwSI2zbn8BprKv4+s/?=
 =?us-ascii?Q?TI8RosnlSCiN2/IQRjlDlkipSZ/tD/bmDu2gqW9Q/PB0Aq7IqOkXXGcoqvmS?=
 =?us-ascii?Q?vnTMlGXb1yohIaVa4cByfrWQd4lUIAVmi1/NiOIkSC3c+7iSTWCAmX2t8Gja?=
 =?us-ascii?Q?nQTi9jrx8HMZcRkq51q1nwbaz5pRG12Sc4kvBDGUqdjIR0XohqhJIC9F6XUd?=
 =?us-ascii?Q?+ziFO3anxD+kKO9mV2A7mMkTH75XDLKBW15NyhUDKq3U8zaQJ9kIgo/ddOVz?=
 =?us-ascii?Q?eWHDAMw/Kz06MfiPBi43H6uRE8ZYdEEBdxLjFk7nioBj8+ZTxlWvzuxspMNl?=
 =?us-ascii?Q?Q+IdcFDOsEvt++WZ3KzTsue7+aE03tyPkGqtVEJIKnwMfew9tAwvjhGdAyH6?=
 =?us-ascii?Q?2/aGx5GXYck3lqjNgi1JIVemWPltQyJUuNvHDDIxPZ+tR6sWhpwQ1ZV5FXH2?=
 =?us-ascii?Q?jY+d48IHQjd8MbT0yFD3zseDP2x+qefCczv5UidEpugPIW7v0mPnnlBZk0Zt?=
 =?us-ascii?Q?GIioIhwaX1wkbx7OsqCyoRknKgsfwpsxVc1sRIQ5Fd+5tdtzdyQJqSLqOKH0?=
 =?us-ascii?Q?geAURZcGM7e6f61MojYroL4U66QthFnryvSQmZd91DxCJpeuD3FSYDMG1RGr?=
 =?us-ascii?Q?4C0vrx1WNDeqentdRCKjpWOna2YnF1B7Ka04U+NIRdHHkDHC20O7aDSoNxcb?=
 =?us-ascii?Q?HmanaNtL+hUe/Q03J3TAT7Ps?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb77bf75-658b-4116-2e7a-08d961ef5945
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 02:24:47.3495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ZUsrPf/H+TTMYLUmheJ9Ubwc+9T+m7Aka6J2ndf01abJadAOJgtntz+CnBJpjqyXInw7HT4TXh9GR2JOlmDXA8mzqKQ5oK8p1Tb6u6Ii34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4533
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10079 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108180013
X-Proofpoint-GUID: lrMN7lprp2shLgQw3I6FdHzL-HNILNL9
X-Proofpoint-ORIG-GUID: lrMN7lprp2shLgQw3I6FdHzL-HNILNL9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> With the single LUN approach, the fault domain does not really change
> from a regular device. The typical use in case of bad heads would be
> to replace the drive or reformat it at lower capacity with head
> depop. That could be avoided with dm-linear on top (one DM per
> actuator) though.

I was more thinking along the lines of btrfs making sure to place
dup metadata on different actuators or similar.

> The above point led me to this informational only implementation.
> Without optimization, we get the same as today. No changes in
> performance and use.  Better IOPS is gain for lucky workloads
> (typically random ones). Going forward, more reliable IOPS &
> throughput gains are possible with some additional changes.

Sure, but that means the ranges need to affect both I/O scheduling and
data placement. We need to make sure that the data placement interface
semantics are applicable to other types of media than multi actuator
drives. Filesystems shouldn't have to look at different queue limits if
they sit on top of dm-linear instead of sd. From an I/O scheduling
perspective I concur that device implementation details are pertinent.

-- 
Martin K. Petersen	Oracle Linux Engineering
