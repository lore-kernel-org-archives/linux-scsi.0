Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10ADAC4338F
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 02:14:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E35F56101D
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 02:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbhHCCOU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 22:14:20 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:59048 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233304AbhHCCOR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 22:14:17 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1732CJ8v032039;
        Tue, 3 Aug 2021 02:14:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=xccZKHcvTu4aMUkmVdK2waAYYzYg6OnfhuWfIdFWqvs=;
 b=nz4xiRF3xJqC+GpT0ZoRF0ZepSODcQzYkWNjGnsDZ9CPaMF/A7koZK899a1SkJ5dAV+R
 Cz70nVDPygIeekBmP1WHytGeE/zjdgHEqvtNcTgs/R6mmUSwxMzRSt7pg21Y2ElX9OKD
 4ATfve/M5z1N+CTGE8aHmh54wPSbRx0V39h0ItftI+hIaUTE1XOzqIy0iiwFrmWFHXCe
 0s6npGW7g6mw68veony5UQTvJj+MKOuCFbTkR+LNBGDscKpqswBB8qqLUeg0PeozcRae
 mCEDlOMx9bl7R6uv3f66Qp3mRDc4cQ9l2ESUjn0/yuhHJlJJYe6TGif9YCs5yI7Wj5Lf ww== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=xccZKHcvTu4aMUkmVdK2waAYYzYg6OnfhuWfIdFWqvs=;
 b=siaix+IpuWfVt+4Vh0X5tvPOUG+YTQznEsYhyCR+VtaAYIx0NYyX68MsRRytnrW7B/LC
 cq5TeGBTuiY6zkOxByJL8C69HTrEgD4J1US47o21wvhKt8T+2TA84wLOY/1hnbCWpPTG
 j0cYG5FIhTAiNwSUBrGMvbSNFz6w/Ck4cuv/j+onayQomsSDoOKakpSRDUpHQZ2vKlEd
 TElxNPu+I30p4ep+F3er87vJ4M3KoLwOPyufFZhHx6JApCVJ6wQ40ezt8B4KaERA30JM
 gbXjBjWhU+7MWh9SAYXTEvmT0Yrxfc/GMtJ6n97nQ/QRaD+LOxNua2lnEY7mifse+Das 1Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a6gqd9p1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Aug 2021 02:14:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17329qcP078993;
        Tue, 3 Aug 2021 02:14:03 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by aserp3020.oracle.com with ESMTP id 3a4xb5w0vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Aug 2021 02:14:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iGyFMwYH33+1bgvaOwcwIo/+otokpYFnLOw6yuuSuBvkzgrE2yJVaujxqSR/B4+TlC2j4djeH91qW7NMVHueMK623d00SJWxIkzg0ElHZAX6yX8TX2uPRdA114vM8jAI24jXQ7XxiHy/2UxqWNoMX9qCJi/gV7BaGc1Gy3q9i2hCL/NVAFUUFGPNe7TQoVFkEnkiiWY8QmbWff3fJPX6LUeM1e+zQ+KFf1Kjn37altmbheV72YSVhv00A88ldCpetwosqUn4lSKrD2lW1PkctwTaacyqGv/r2GXTN0R4BE3WVbI6pbULdlbPweXoe5fLzj+9mm9+hGKO0owI+cK8vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xccZKHcvTu4aMUkmVdK2waAYYzYg6OnfhuWfIdFWqvs=;
 b=km7kOuARK+hsc2c8dvcLDmBZaY+o3r9yIG0Z0QStMUO5NKg/UbdEzK26QjA7GQ2cnoX7eTUWiO/RGsSn50uhEaoqbszlbpZGotk1iHp3g8u7+QyV4fM6h05dwQuZSl2Q0ilTeEWdha+kYmudVeW9SARg5D1bBwQNnYk9jLVXY6cvVKRDup/dYSdN9bXJ1TCN6qUOguQpgSyZpWJEaDNlki32xAIWAdGoYpgUSJu3Qs4Y8JEyWLHL/OALXAsxyw0jjY4mvkQ/pu0QbM4U4n7uDTV4wvL6VE10kircvR0QbJqsL5Zg7K7z3BTiLO2AjtwUu5S8hX2Cn1QQJ1y53zgnWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xccZKHcvTu4aMUkmVdK2waAYYzYg6OnfhuWfIdFWqvs=;
 b=K6J6xMe2XOlEFQrdVZA84Tk+Q8QDwX2+7o4QxlNR3hwEZA6ozIwr6IG96BcsWNC8Tb4Cdym7pEGURIU5FwL0k+iu+pjnBCSGI745Y1/OdYBI+UFOFTeagSoHNhIXOk+Gb9APQnuRRabQZweAtTLwsiOwUpEd1JxZKlNZtfIxZm0=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4632.namprd10.prod.outlook.com (2603:10b6:510:34::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Tue, 3 Aug
 2021 02:14:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 02:14:01 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH v3 00/18] UFS patches for kernel v5.15
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135rrl1gi.fsf@ca-mkp.ca.oracle.com>
References: <20210722033439.26550-1-bvanassche@acm.org>
Date:   Mon, 02 Aug 2021 22:13:59 -0400
In-Reply-To: <20210722033439.26550-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 21 Jul 2021 20:34:21 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0012.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR07CA0012.namprd07.prod.outlook.com (2603:10b6:a02:bc::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Tue, 3 Aug 2021 02:14:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 676eac90-eea1-4f18-55bf-08d956245c4d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4632:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46327AF7827E949B4CA6E4CF8EF09@PH0PR10MB4632.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l3BVTFg8mIxqm/1cvXP646O7g5JPHGNpt0f+h7rXWushuAhG4Qvn4yHBOFSO3TBZ20CW/ZfeYEvNdhywsyGT6kcbqBHxU5kxWdQdR2x3hrG2NqQpb8ugyllRD3Mdg6pQgiF7uxeNRZrNj8vrbaSZOadluNdxBvX5ScbAagCpOv8Ed1rnqGydYrnpKSMHmdEoJQFgcgevrpXd43PA4+02R04TcCIrwZeDLsbzfQMK0g/lXqqPXzL6FlVejQs9QN4eaE7Eguq7KqhG+RYU4p5Gl05MQQjujas8zT9CCobxKEEEFpFFZKgrBReLmvD+Yx9o4h/2E7PwM5oIwGSP3etIRipgsF3mvvacLBHVhPSw06EMouCeE+6UmlkSAtnzyCEjueZzWAvvm6Dcze6hcgsZ7gY9n6Z4ItgJSKA5oNMiDIF4iMk8Wb7adV/CvVJKSoSlmmftHIQmB/ajIii+FkV7BVz2AB58KjpzDLlxJr3I/e1KNBNlpafR5JPJVUWseQDwCTsaMNTD5GQd/safaJe7EGmZbBAeHyX+z4r8Ep89/UmwqsGaC4izu5NFrITfrl9jZNlK9Mu3MhXtnXXuD+/Hxtx5fU7md6Wkk/5h2rd0upAD7FtaVdjlWpNTDQW9exhCaheoKkyQKZRTMnSXYoiQn14UJeJxaeGCf2Y96FF3R+OFg+EXUGiHdzhHEvxEbZSOAyfGOgWyr22euU15kdPQOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(39860400002)(396003)(376002)(66476007)(66946007)(66556008)(186003)(55016002)(86362001)(5660300002)(956004)(52116002)(8676002)(6916009)(7696005)(8936002)(36916002)(4326008)(54906003)(478600001)(316002)(2906002)(558084003)(26005)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PPK86wm2CVt5DpNPwhNn0NxObScKGAwx6UFBGiXGWPm9QE/51gjik707eQgv?=
 =?us-ascii?Q?ya0ddzLpa1dCVom2BJlZYJBUAaCL6i6mDTCGKxmBBDzM8+j3O5xJKTkRryWV?=
 =?us-ascii?Q?kvSw6fHFvWpwoME+I8AGj4SlWZWCWCn/pU66fXX36nOJ6meSAveSTRFcoMVg?=
 =?us-ascii?Q?aNgOatUFk8nBND2Ag4DQ6doMU5uU5AEbyR+Kt4qZZJJxgrWxZKdNS+VAAZoT?=
 =?us-ascii?Q?cUgh1XCZ2ot3iY5GdHZ0X8yETnGjJeBXdgzIzV6vhJHhnJw9BjF1jnjZlYi/?=
 =?us-ascii?Q?mTL2DXYj70LCyKsUVxgE3J+F2psZv1fTIgpEkld1Xk+OK8E/T+0r+M+YlmrF?=
 =?us-ascii?Q?RFxO4gCXr1YhA5LDziKyQHKVSj6YS4nciwFR8Bq6u7biDAiWZMvT/yn4rj11?=
 =?us-ascii?Q?UQZ0CWBvuNZsrHWrK3ngZTR8fkzsyl484B00RqWvRSUtJtHKrt7DVCq8wB/w?=
 =?us-ascii?Q?J46axQ3Qo+LzKEpb5ohhe5CWdg8PO4ntjs9nTjusAwMWnaFweEkdnwrmk6kS?=
 =?us-ascii?Q?vM32ftEIhF7XupG/GOmL+vKMZ4XHNYZc5PnYSMj0pQF/bejUXjprYW7qDgIV?=
 =?us-ascii?Q?TwmcqKIqAQkzW6xyiBWsd08miHcinMVwiI184veEhCC4B324IXxKrLWgOobl?=
 =?us-ascii?Q?iLFRZGAu/XWckfGex9xY9nq6ShS3KW7LCupIP51STq8LiXeWnYXKK0Td6a+S?=
 =?us-ascii?Q?yfSuhg433v448Rey5Bv3oqvovhMe+DbQqPyEEMcVmQLvV5qCljGnBnVCYAJz?=
 =?us-ascii?Q?ZeICHYXbuYtPKdbvbkKY4dMozcrj/xWrOEqNkzSoD16lCEtbDx8yjkxXBQ7e?=
 =?us-ascii?Q?ucZ+A2no6IMbv61axyP/38ZDNmH7QA4m/71LZ0yWNv2F5gVDoAPKrNIawQk+?=
 =?us-ascii?Q?Dlh6HuVPkMRiD790tIii6xvEIKC9ZVBI3DHLdPDfc5xr8VLactRAsVRgKEi2?=
 =?us-ascii?Q?VhTkxuzuvuftnpRSi1b0GQjJIWMQgbIxbKhTbjFIAkvFyDpGzND8+r7g1a+7?=
 =?us-ascii?Q?CiXHW/Pv8QJ8iK/k4MfOJ+s6syGIRx9bCAqPEOCmxWnhfNVRZ4fXZ8CVE9Ak?=
 =?us-ascii?Q?N2PADJL5wCQ5UM/9MbUdLovLs9NDhxG02QzxK/YZtP1U76GE5TCn6yEB5mxl?=
 =?us-ascii?Q?nUz0UJhkIG2F7y5Xo/ZI0rL6kQHb4UtNkq0Fm9y/HpIfUxYdj9Zpp5/cUusY?=
 =?us-ascii?Q?nQJM336ltQ/wVOC9d4iZj8CyAg2hocgkgx79FAqjsk/WLNT8or2XAhjqpf/x?=
 =?us-ascii?Q?VzbRRsk1wJcUXoIoxtADtSezo6q2HCnvo2JXNjPVVUI6DgtCDm5y7GTA8B8j?=
 =?us-ascii?Q?YFLMftyV5yfRDf2cQhJfLyjm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 676eac90-eea1-4f18-55bf-08d956245c4d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 02:14:01.8612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nae0cyZKxdCTOMGuztXCgrzuwgQpAFRFkdBFgbzSy4C/vM+cdDI8KMA8Ul7QI+IUrfpNoON6UMqQB/QvXHFmBjuZUpE+h/drvZe+XjFSyrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4632
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10064 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=990 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108030010
X-Proofpoint-ORIG-GUID: BT1VH4pgtKl_7JMtzmFcpWl4b2KNcxbd
X-Proofpoint-GUID: BT1VH4pgtKl_7JMtzmFcpWl4b2KNcxbd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Please consider the patches in this series for kernel v5.15.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
