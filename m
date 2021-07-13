Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC13C07E9A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 01:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 785C16100B
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 01:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhGMBoK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 21:44:10 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:27438 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230182AbhGMBoJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Jul 2021 21:44:09 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16D1f3O2014077;
        Tue, 13 Jul 2021 01:41:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=f/23TJaTz2j9VONqQNb/VA21kGvGilzYxpI+cFrJIr4=;
 b=BaabCM+/BIE8kyHGcUeyM50smRDIFQLfXxV7Vroa2RnkBK6O35RYxBQ5+tsOUXIVZWc4
 JWZuFKup9YnLK8i8rZzrF/yMwftcSRoe40S8ukb3H4wz2/4KcUC0m/JuwHcg6GSQLUb1
 9rQoNBIgRxz5+R6auh7LhkqmxQLd2FcH2gT2/QBZGCwWdotOPhdT2uZTgtHFC0R5ntaQ
 zjUSbdkOVgflfDo0bBgfwDDSzaJ0zVArolx4XkEMtRQSZ2o/1I2muhdo29cu+tf+lFVe
 pRQtXt81J17JveufAM26h2JIXSHqAgJ6hJsN9DDfuQNi02/7CHR1ZwJeOi56+GcjzB2P hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rqkb178e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 01:41:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16D1eguG040184;
        Tue, 13 Jul 2021 01:40:55 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by aserp3020.oracle.com with ESMTP id 39q3c9b9e3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 01:40:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKipPwDQeyWt1lU5fwgp2o9NuYrpu8OmhAoraiql0wTQW8N1JvC/kBrElyjJ6of4gKbg7eeHodIbgkqnn3BN0Qq3g376oMerAdb1Xt2Y0PKQewfJztl044/oTBUmmPwA1dqWpm0O0iOMnclyECcAKgyxU4ZX9yTQxuligLOXXrzCw/owNShH+NoLPVwbnHHhc/jKJPJh4+BCNoh0h99FRcJByzyBjRITJTfoGNM0bRYU1mJJ8lKAvB2qUNo2H7gEvv/eirpe8lnz56yiOwRvPr+D2diAmLvJ0yY6qdIpeh+Ug5jIN7AOBRzPUDnQ+O0iS0aA52H5UdMTMmmePWfuuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/23TJaTz2j9VONqQNb/VA21kGvGilzYxpI+cFrJIr4=;
 b=di4m0TQ25Mm43It+FEHjZzWwJmiUC6BA9vEKeqKsmuOCgPSUh0OiUmX+xZlnVIwSW/COt+v7tXB188AAMJkeQCV5OF6P15dE0fewiFXifv6ObwAihinucX7kBhfJgzlkrDuu5LRE3PdyoEVjxrFzdchkRSYavVS+YDXHlnbSQJLOzMPzTbxpKfPEHdhzJnKxEIT++t5Y74bOqIcHEfK2OxE85bpVX1Os7Vh5Fs5KLRgnD7fgEOBF0eXkmJRLM4HtGe0sqd9Jw5rmbns/NnX74DTFbjH2EUZ2Rxv8esmBIhQOI5RVeMa+l6xq+XF605Jg+ESfEm6fPoUHA+WTLh2VBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/23TJaTz2j9VONqQNb/VA21kGvGilzYxpI+cFrJIr4=;
 b=ysSvQ6HeadtiCUqj0o07ZucGUZZv8x/AVilA9fzVTALNDxmPve2hkTMDCqSLGXZSef5wLfgT/9DIx9/4UV/uh+ELOWj1AIpKDoBhv4M0ploufli2DxtQMNNTJnQNy4rugieJlqwcrf6qFPfvg1EdYgI8p8s8VXUwVGOZ9p1sXWk=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by CO1PR10MB4561.namprd10.prod.outlook.com (2603:10b6:303:9d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Tue, 13 Jul
 2021 01:40:53 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%5]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 01:40:53 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v2 01/19] scsi: Fix the documentation of the
 scsi_execute() time parameter
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14kcz6lf6.fsf@ca-mkp.ca.oracle.com>
References: <20210709202638.9480-1-bvanassche@acm.org>
        <20210709202638.9480-3-bvanassche@acm.org>
Date:   Mon, 12 Jul 2021 21:40:49 -0400
In-Reply-To: <20210709202638.9480-3-bvanassche@acm.org> (Bart Van Assche's
        message of "Fri, 9 Jul 2021 13:26:20 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0058.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::33) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0058.namprd05.prod.outlook.com (2603:10b6:a03:33f::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.10 via Frontend Transport; Tue, 13 Jul 2021 01:40:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d427a997-9b54-46b6-f136-08d9459f4025
X-MS-TrafficTypeDiagnostic: CO1PR10MB4561:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB45616EB9AEF37DB67502B5138E149@CO1PR10MB4561.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /uyop+AVblporgNggkgvtedH/rkxHVmwKnkOxFdfMWmmPBFHLWen5Qrs5xngN9jlyqtuHO5XCC9N8y9zbu/+orFR7ahJK7I/VOCOfsX9EhqJFT2MyoPeDPLgNrN4kkg0MRu6V9F8p0CKsGN113VGu1UlJ/1qplucjcVhmvHoNYhfRHhE7qfxsIZS7w4Pvrl6QjxFyJi+npypUABuy8hDiGsyp0SXJAb9FtlTXBOu5p92nyOqcBE3dyELG9p8PNHItZFVtyft/ib6/effIYWH2Y708lua3gDSOqDMI/gcqXvEgDfsQNIU4CR7sMCfJw2SQdRdzm6hjdVvI4n5F8bQEj9RsPJo64dpfOzeGQnCLYayZ0/KRAVePc5si2wh4MioUnXWPUqXYWevq7ZFAGZtQR59wKL4BtECImtBOWTrrrIn3rVFh1c/JJXAbV/XXmoDTcSZDLHieSZcbZHlcvpvygCNxs5qkdT6Gy1GvZa5O9OZ7VhY8dSgVrSv6H7K6el27htuW6Ok86uhPHqaX+8R8oQOpX9O6n373wcLHXQIoLbZ282p5kHLi5EXr1UmFvyHiZNC9XOCTxKTYPLCGWIzp84OQcuHL5VazO028VhY/a+Nf9FBzUQfBs5greUhqgFreIDwvpMfBs5C1S+IrjgrTZoayPlIZkE5fSIrzCyjzTNaBGooCUOrdCCUU+r83QlYmwTnXmRzZlLNjRJHaWI28A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39860400002)(366004)(136003)(36916002)(7696005)(52116002)(5660300002)(55016002)(26005)(66946007)(2906002)(66556008)(66476007)(38100700002)(54906003)(4744005)(4326008)(83380400001)(38350700002)(316002)(6666004)(956004)(8936002)(86362001)(186003)(8676002)(478600001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K9/JREatK38OOWSYa+pgcoGj0ZhQtsmUr8Ti0QBFK7natTt00ov5rx1Te5kt?=
 =?us-ascii?Q?YF/BbirlzuGeVV/nOoRs+rtSK86lod2z0jyJf1MrYwlIJdaFv0BE+z0U4DoC?=
 =?us-ascii?Q?BzoepuMP1ZcUjEncD1egSIRtF6ztlKmn5SsJgYzayZG78trNnenkZFLwEIG/?=
 =?us-ascii?Q?o53ZqlmOaV2oPjmMXIqZ/630rZuQtcIFFmW3BiWSRXzG0exdDcQu8PljBVvE?=
 =?us-ascii?Q?nXhrazor999trzuVc4GNyr1tFGcA3NnFJ6yQVoXM7v1D4PdCR947aSuGZa36?=
 =?us-ascii?Q?Td/gD4ZOBX9ZZ/KwW/1VE3a2q/QKIZpeC7ch/rP5I9w2o2dWVENLUr/IGQVU?=
 =?us-ascii?Q?IJ5wXunpAnksbXA3L8TlpT1sMFpZ21+/H8OjWl6E8ak5jjdpYO7JwTDfa/0n?=
 =?us-ascii?Q?OctGE/eXnb4K81yy8BYX6wnJN0YRCMJkxFHzqC5faTuHnI87urlU1b2xaFYx?=
 =?us-ascii?Q?U2JeJngESMzvoirmXYvtczJ0PveX9TvNeXDs1WC72sFMB3aWJKXov6arux6u?=
 =?us-ascii?Q?c+RECYmoqHXAr2sgrN6oPr6lkkuw8UQf8E6cKEKCky/vttdjb27Z5zP6WgW/?=
 =?us-ascii?Q?HZ6Z0TlN7JS70Jc280K5Q9oRfwAEotxQNE0PMKNvxxLAfT8aSuVq9Yj9NQCq?=
 =?us-ascii?Q?Qe1nZ2F8OuQAaBl4js6MAzZTkkOe9kMHaUlo2uGbPr69QsnFFa2bL+7ZHxdy?=
 =?us-ascii?Q?bQCy9m7KFZSGve+Ub9RfRTpT52AkeIZ+7OEPVR532sGWn6qFZjRtOQL/6QLE?=
 =?us-ascii?Q?orm3bhvZQCHIyL4Mzc/b9XGBL9TOvGFUst5fnZwdfqAtnrUMo58DnDvTGxGu?=
 =?us-ascii?Q?TxksPqnEm49xrltLd5jtQFe9Eueo6q8pu/+9KFZAtGhRr+sPhuu13qClHUe2?=
 =?us-ascii?Q?Gvu3YkVopFoXhQkT41Xxn9pkmqQdjbtDo4VHFikgVKDUlCX+nEn+44mzNuuj?=
 =?us-ascii?Q?1cw8ms72NFHGz1m6PDFA04av5OCecfdBsANnUT0ngw4GvogGuSDcC5uOeBzA?=
 =?us-ascii?Q?PXHw3AmHD3Zt9BwzRBeQ2b+sqhjDovqCIeHkJPgtDc9kN5ruMYssvFPPvzew?=
 =?us-ascii?Q?fbZeKxoAJ5Abq2D6/calwK+Aw7lPVF7GmD922OZemqidw3s0srZJijG/I54g?=
 =?us-ascii?Q?YdoHEanpFk4IhDQZbUEhIeGtNtyQyY1FeOYNj0JGUt7W2JLACdGyh6Gt68JR?=
 =?us-ascii?Q?LSBPpwWCnPogFmljkJQpUs6RiEUzvf46Shjt6vpNjzGT+mnMHjnQpRdcGnWr?=
 =?us-ascii?Q?/YIc8ep2lJqZTrxIzmmSZhmSZ8FfMN4vjl5Sef9IOTc4GzNvReEELADTMI12?=
 =?us-ascii?Q?8k3iCPJWjVeWed5vqDgf5aCY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d427a997-9b54-46b6-f136-08d9459f4025
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 01:40:52.9175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PnyhHXkgbhu4QZvEuDRMZNx4xgF178i7wFfC/n6RwGvC3YpP4q6hbiIlMd7oGAEQW9XM6hNOKR9hf6R72d1Vqzbu9uDf+/xQH+vxRTpS+cI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4561
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10043 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107130008
X-Proofpoint-ORIG-GUID: erdOPaBrUE0h41epQpIOLbBBy1BL36If
X-Proofpoint-GUID: erdOPaBrUE0h41epQpIOLbBBy1BL36If
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> The unit of the scsi_execute() timeout parameter is 1/HZ seconds
> instead of one second, just like the timeouts used in the block
> layer. Fix the documentation header above the definition of the
> scsi_execute() macro.

Applied to 5.14/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
