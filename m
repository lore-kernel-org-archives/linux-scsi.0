Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46500C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 04:04:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 237F06056B
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 04:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbhG0EEi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 00:04:38 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:60780 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234844AbhG0EEd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Jul 2021 00:04:33 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R41k37005409;
        Tue, 27 Jul 2021 04:04:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ytUYsWU+ZkIWMhmzWob+yHrs26ANrOtiw8XnS+5IOXI=;
 b=dPIGCYd6xVEdI61qY3gli8TiXx76B0Krth5rQNBaLx0Dy6iBPie+wUIJ4yME50Qarg3b
 n/TkTmKZkd0zleRTvcplsIFKoZeFqR2++e4YJ100LZZ3EYpPFtogqb25e5OYTESm9Y0/
 wK7S3ee3YBJAqvEvEjWkeJwIXUrzK70sqdylMf/tSUYv1YNxtTv7tddNVTsi4+E63aIE
 p+NxGRBArsbCCY67r5xhSA454uzbHzqLizkgLKlCgKpDClewNZdbrw6xqZHDQRddOI1j
 I1ZkNxWPrQmzO1+x6nG5gwAxfRw5sD3HPhAHo59amp1+9MHfpp03kXLJqy8JRw5t1U4h kQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ytUYsWU+ZkIWMhmzWob+yHrs26ANrOtiw8XnS+5IOXI=;
 b=n0CNgvm6/hU6q0ElVvaEou9aXdlKl39uvd0TyDnyEgwFTzo/hFdpb36kXfaYQ9zn21yF
 XU0K6CL3zeFgci2aG1MK3hdyTcTaZIk+Q1QaSOtqw0YBed6kIP74vJCzz/CgEkO4Ojxo
 vVGAbnjBVN7XE15R4r1pehynyuy2mTJkkqkCBncy0OIKHpqt+PoFtmQEAdL+4yUOpOQ2
 Ch8j5POOW9zI9b+440ZL8qe0MYplj0aK5CXot7hyMZlJLMCHfaLBJhhmr7wGX241AMUh
 bCjt/d1NLrbNlvKqwCj0fI/AY8XoRLEfWTGIAm6AobT8Cw6zLzuJS3aE+wjwTJ5Qh7TZ Qw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2356gnb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 04:04:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R41fUm121474;
        Tue, 27 Jul 2021 04:04:29 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by aserp3030.oracle.com with ESMTP id 3a2349ngyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 04:04:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLUj1l3KYNj2rZ2ibsNZjubVa5VYqeyLmUiilomib2eLhG5SmVy79EyCVL0YJ6V/IwYNsr7W5caXUKAPBJRRI7ly546MTYRDC9aczFJQekMw6+qNMQnAhln/WSO/dnAFyNmlT0r63IsQi78LRhQki17zKNcikMNLk1XZYRDobd972QbDM8haL3jjAdmVMpm1zuXYZ6N6sDSVB8aEbthbye4CkWmkk9frvZBDZ+GeUBECEWQ24XqmKejK4dlti0Zxz2yzDh90t5VnrZd8IyYDRHsXWzNXuEcOCbYrL3HljsJkiywP7JA5QHeCLAlteaNVOs7BB3txQeSzv6zm/jGcsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ytUYsWU+ZkIWMhmzWob+yHrs26ANrOtiw8XnS+5IOXI=;
 b=W4AkDEk1ojOTmMTOQgreJFNfHkK45sMr8+cJjdkyHZsUlyUaj9jpuIVwXN621xd0QX23Csr015oDgD7ARdKPf9Y1T9ciQDQ9a2UYdi8mIphBGqn3dy+4NnyicOXpbwCvxP1ULz/U988ogm88/jggD+xTFBVFOV1qnQckhQHDlC4nypic5BjSUG2scZTxx+YCQQ/3jXs27TpNS+i+PG5kSnc9ZXKpskEdOHP02CZ+gZplSShtjWkb47FWzWINIGOaoO3nowsseO/EUaOTVnPjhEMy/r9uEJNceVA1egK8WKq+qfO1zWYA6F2DYg8SW/NZwqXvw1eHlugnhTJH6hqhoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ytUYsWU+ZkIWMhmzWob+yHrs26ANrOtiw8XnS+5IOXI=;
 b=hAtjLRIOi8b99K9go7k4qMAbpWQzweDK/hLcXKRtz3yC4KcwMRTNcvbfv4DtUzKHKRwWkbCEaiqTncMhM8tMdVBDIL8pZdTwdrrt2WnRvvf/hh9mvMB2U6y4MbjJz4O7GS9CMLZColQ4abXEpAWMHNeVzekeLnOgwioYAFkVFSQ=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4631.namprd10.prod.outlook.com (2603:10b6:510:41::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Tue, 27 Jul
 2021 04:04:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 04:04:27 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v4 00/11] qla2xxx: Add EDIF support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnpcpfos.fsf@ca-mkp.ca.oracle.com>
References: <20210624052606.21613-1-njavali@marvell.com>
Date:   Tue, 27 Jul 2021 00:04:23 -0400
In-Reply-To: <20210624052606.21613-1-njavali@marvell.com> (Nilesh Javali's
        message of "Wed, 23 Jun 2021 22:25:55 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0078.namprd04.prod.outlook.com
 (2603:10b6:806:121::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7PR04CA0078.namprd04.prod.outlook.com (2603:10b6:806:121::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Tue, 27 Jul 2021 04:04:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 804bd9c1-c9bd-4657-68ab-08d950b3a0b0
X-MS-TrafficTypeDiagnostic: PH0PR10MB4631:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4631763F2078B44072F1D7CA8EE99@PH0PR10MB4631.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7sNdjsYK1sDroh08KebezuSgjvEHWZD1l8ewPYucnvUd4CnG8JkxizxZVo+o7GR6VjCT5DpHRtBV22Lnf6RV9oHg/NFqUAZ5N/5E0OIaWSJ67QzlLn9BnZEN8GEfhzMGdjArRsThEkeCDcY6oXzzwOe3JuZYVCPjO4wThHsAaCxALvqADBhjxLPl9x1GHIABUi2tATQQLWxa4DxvY3WVlh6i6OQEC/QOqD9CEVqFblTv/vW3kt7V0u5CyZHo4iIPtMquMHIbAxvGiqotJxXnWK/66VreUN3wt6HESso2FWYkwK/CKSCfNKYWOESnciXjOP95FMA19Tz1Nf9TGqM3zmkAbp206almP1f/1Y2a6RGxWnqPNRl8qru+B3mmkuLYhmfJajCh+qyGkMWteUWkaUnlP1Ave292jWJrm/SGZ4U5FU27oqlXq0xht2p+sBsuEhhk9y2VF+hacvAI90l/bWs08VhCkAsLZsV+Vn3+Njbq8iVJzJyGaqk4blujgV5W5t43QEtUqRh16HPn+7TsutOMwJaJ2FqF7+E88vxPv7gpqDDN1nSw5kH4dHjvnWJJXMV27odLc1K5iLl3bXSMtog42wmMA5AQXfC+rtDzcySHEV4+m3VmHhZ1A8EpSo7aL2S16PTuotS1w8zdjruGWcqwcNw4f/OcqwG9Q0bWt89TQS1KajoQiBNT3qoB4Wldc+d4ldPEzaDoEoej6fEtgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(39860400002)(136003)(396003)(7696005)(52116002)(36916002)(8936002)(558084003)(478600001)(186003)(2906002)(66946007)(55016002)(6916009)(316002)(8676002)(4326008)(66476007)(6666004)(86362001)(5660300002)(54906003)(38100700002)(66556008)(26005)(956004)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d3OhnTJUhdZU1IIYk4AAYOm2abFtAaWHX9t3ouXaGfeqRS/Qnt4rTsPMtP2N?=
 =?us-ascii?Q?tBXUCpXkZriZ3pqmnSZYe+NxqHKXyUTYVTvIKpuKxIu3nX5ppycMLj8dsir7?=
 =?us-ascii?Q?ISxUKWOj/ZRjeaWJGDp7ptqNcR84RLvmouHHC5V9bPgZ+rWXiWaQmgDAxct1?=
 =?us-ascii?Q?D1rYF5UdmJ+t6qnlzrxNpA9VWt2rweVfm6WMA4XiPDiN+Fk7zs42CPg6ccwy?=
 =?us-ascii?Q?vouPmz+ZsiUTwISeWiWVKcSVeEhLRHVBpjvUB04Y8poHyLHk5YJiFqUUwDG8?=
 =?us-ascii?Q?QtpibbPDeOeSLAbji2YRx4cfdG11EtcfgIGNxPDlT3ryh52TkHLB+3IpYnCV?=
 =?us-ascii?Q?BFzgbShMl5ao8Gl6TaLRTchzq3EZzWjlM/lYR0VCGFdZkPL9uWL8+0w6mro+?=
 =?us-ascii?Q?Itjr+cWjwfeV5eleHoj8Dqu6PQvd0BHBse7SURRPXwgspKZqt8xfV8bjxc6j?=
 =?us-ascii?Q?jxboMh2rGkMg4mJSDwfoBzrmUSphvh7fI/0pHZO6TClY8EshJFN/ctosdBHd?=
 =?us-ascii?Q?8PUJqGBdmTEkUeatWqlssm7XtdfZevMwbqtT8dXhanFwWx/mUJqhGJl1Ps0R?=
 =?us-ascii?Q?iTqK2YiFxkvmKsZGE1xRKO8UyKzxfnpp/d4Zy21RzBwgy3uhSKXKJQ6VxwaZ?=
 =?us-ascii?Q?GTxY8ki/PUVdXsB9+NZVR5NNlQ0tAMrp8ENA+eQGiCjbGWjR8zCuOfcA4bWQ?=
 =?us-ascii?Q?z0dctNhyQUOA3if75QOJwYlDBhQxRMSu2joVnBwm+ySKne+B00mO/RiGpGic?=
 =?us-ascii?Q?ez38nEnbm8wEXtvItIS0S1LUCbKjQqe4zyN2wEY+H2g2ZGM0kRCoV+f5BHYV?=
 =?us-ascii?Q?qIr3HlAv+BILQgIFleIeL2FXUShA/YRGLL5Leg2GxSbzUty0BBsOVfHcgy/b?=
 =?us-ascii?Q?DsQJQJs4VjwZR/QztASUP2oabRossmnE4imKpcxHy5POKTbNI5YbLLxATIc4?=
 =?us-ascii?Q?GAgZ3CPQOQwA9eZZwHwebsQmuDnt585rcRPEymqUqn8eGZDdmextUz5yB1wv?=
 =?us-ascii?Q?sOI+qWSY9VyvwROlI555W5KcaiA2SP8clZY5JbKmyoXG5ES8fxzl4I6ecE9E?=
 =?us-ascii?Q?jff5cxoDtJbJkurdh9Y3dG1rPSy3B34RMUV6fRoeFrp2TsGQVFQIxzVwMsdQ?=
 =?us-ascii?Q?35A6vcQFUMGBPqsXtjYvz5+BgYbvR0BD/2P78UHjkebkRqfr4ypGWwQ+wic9?=
 =?us-ascii?Q?wXi+9ZuLo4MoM1oc0dckiJD33f2M2ISnrrBcfZLk+K4XW+wRLyC1ytGD7i6L?=
 =?us-ascii?Q?wDdzr2psaaYihXdH5+Vk+wcP6r/vixM9+54Lt1mQPzLTt5MVQJc7KT6kpKz8?=
 =?us-ascii?Q?g7XCdnRlCnFOi97Va8lY2Uzy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 804bd9c1-c9bd-4657-68ab-08d950b3a0b0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 04:04:27.6353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: auJouubHS9LYIuMqZCXhNiL9SXMpTpBeByaoj2vXW5ZU/fLmHTLhOVq7wH/9rRdSyc28ghU7qp0A53dFT0LMsKTygHcN+nkaDUIgeIhR2A4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4631
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270022
X-Proofpoint-ORIG-GUID: wgJgaANcqG3aXLxCjUSQ6-nWo7Zr5_Bu
X-Proofpoint-GUID: wgJgaANcqG3aXLxCjUSQ6-nWo7Zr5_Bu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Please apply the EDIF support feature to the scsi tree at your
> earliest convenience.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
