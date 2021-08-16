Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D1EBC4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 17:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3ACF60F41
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 17:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhHPRfH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 13:35:07 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:41078 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229590AbhHPRfH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 13:35:07 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GHWH1c027660;
        Mon, 16 Aug 2021 17:34:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Bmn6Pgx7f1+ue6hiFggK9HoACGUrMGEDMHqDfSD0AmQ=;
 b=aOtSlMrVbHuV7kOH7G763FsN1TCKryhE3J4WEIJci99cT8rNtdHcBLcPjhrQJ3AemC87
 BoENksbD/INJBuvN8D4Sv+KjCz0Tqa4ams7ftfdb3WopeIz8BlaO9YRSJODIuJkrfXfN
 98XL3baAhyWnuQKqmHBOW1nJ9L/8mvlGM0BKrAhUOD9J85As6W+L/6qw8oEHzIJV9iBT
 rEm2KnHpPygHFvmjObX+Ii43w+qXuRO2a8Sfl0F3g+RBpFCjN3ox6oEsQlmBroiS3Sla
 L2BBfkbJ1BjwWMvUzAxIf6f7Ii0mlmyRGAx/s/draqVKgp0pG77AUkDWdSf5TLwvimKy wg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Bmn6Pgx7f1+ue6hiFggK9HoACGUrMGEDMHqDfSD0AmQ=;
 b=J4MSdXj+4tbg2p4ALwHh68V/fzCMMQ2yBwc0xIXQHthKFb7LM2xRx7CRz2nlvELL/vMk
 p6psnkhaLxsP0X1sFq0f1mwGls1MoSX60SO4BCybbJ37yBqOjF/c+V4g8H+hbcyNu1Wr
 ipK3j01aD0PXctY/LyX5mSInG8BcNmoa3A2oo3q/F+/vIOVnL8GZqBeIlYamMwsx5Nnp
 lgv/JmyEbiGvl3kqc+BgX7lKRGkYy4g9lEYi+4HOAa62ndUxJce89YztZj3t2xU22oTB
 WcgKKMiB3YCfZBzJPSCQGEizASQKNN525XMkcIffcCa3n/HuW79Zc9aLVizYnCr46imP Dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afgmb9rv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 17:34:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17GHUiPO108864;
        Mon, 16 Aug 2021 17:34:17 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3020.oracle.com with ESMTP id 3ae5n630sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 17:34:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=imN2JFmUi8cAba/29w1fWe7JS6OJTd/FC5LEQafrs6a150Alohtoi8TFSKqICW+cEbgPOS9N3e7JCipmZVX+Wj/o2sD3p+6KtzusFQeuwKLAQQoKeM7uBg1S73+p2Ds8wuJhMcrOn0U/567kjCNcoifFjkjyVGMJbH91GKlrZHRMpQ+XnvCg6lSGzbox9pMVdLnZ3hCDKCewMY5SV0kNSdJUFerEJo+z7xRVRrEzBOXGxPf25208Z8vyl6lBT0ovRnBG940P9CHlmcl3Hn3lWRJi5Js2e9AlWFHaYOLtSDYCXiGWGzNeYf+eGKOLlhv0r0wT4u7NkBfMc4tnXn2blg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bmn6Pgx7f1+ue6hiFggK9HoACGUrMGEDMHqDfSD0AmQ=;
 b=VycmV9AHhjnWpHjXcGMuLSofC7Ebc0TysPAaPSUNJyYk59JtPtTn05xV+FOLlRgRe+yJawn/aBYdw8gNbVLUTPTXi3HjVyN7foIC+RozSs+/Cw+FifIdDhqPpVXW1LsstIydjetQVQ1rE9ROUNEM7KmGFMvO62xmQ6tYV3ENDqHidJvZ4OJv6Mubv7PMI5GtAnytair4O4nbJhSLeEQckLII84koDNsUyCZfJ1Hc8JN+SVsxmaZovyaK7lTDp84HKYjlDKiMJ4us53sruPnVMsAuxKqOBwqz824YiMX9CwsSD4IYvHlHYh73C7+lNOc52xEORDRiynArNvnEMiYcAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bmn6Pgx7f1+ue6hiFggK9HoACGUrMGEDMHqDfSD0AmQ=;
 b=qHw2JmLoEIkaDjl5hMHAwYV9DwN+BpqTUNT9FHpVt+2MTeool3K0i/wPJXnulC4GhSPa8Mw4I3KhmB0h5vh+ouqhRVlgNtfKve9opmZql2TMj76PcoLLCmVW3aICFxTzww9SY6nl6/r+jyTx2dhiB3RBaBGAtTfzPzTorD7LEJo=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4760.namprd10.prod.outlook.com (2603:10b6:510:3b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Mon, 16 Aug
 2021 17:34:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 17:34:15 +0000
To:     John Garry <john.garry@huawei.com>
Cc:     <satishkh@cisco.com>, <sebaddel@cisco.com>, <kartilak@cisco.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hare@suse.de>, <hch@lst.de>, <bvanassche@acm.org>
Subject: Re: [PATCH 0/3] Remove scsi_cmnd.tag
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14kbppa42.fsf@ca-mkp.ca.oracle.com>
References: <1628862553-179450-1-git-send-email-john.garry@huawei.com>
Date:   Mon, 16 Aug 2021 13:34:12 -0400
In-Reply-To: <1628862553-179450-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Fri, 13 Aug 2021 21:49:10 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0188.namprd05.prod.outlook.com
 (2603:10b6:a03:330::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0188.namprd05.prod.outlook.com (2603:10b6:a03:330::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Mon, 16 Aug 2021 17:34:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52b9e8bd-8662-4f2a-9f36-08d960dc1149
X-MS-TrafficTypeDiagnostic: PH0PR10MB4760:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4760ED96036283A55F79CCA38EFD9@PH0PR10MB4760.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 84VmwWtDVNlGNVRl7VjPWgIzrikbfGGfdbeoOYfWeMgU5VKld5tRRfOvOsMqe9YZxgGww232tRHmacFZ1yw328NaPU2Tfg+Ey/LmV8OGldz+DJ+2efjd+HKbdI35sXrphPbSnopT1yTajl9yo1Np3GlZhckwqNmmjLgKIVBA6zyNmFNZn2ZPMtHnV1y1mCpKRSYB2/7ZB6VhTDsVb+RBC2JjUee62GRv3In/lCVBzz/nM3httqGYVL1wrwbgA+08H0ihTvL4udhljX3zLv3CKM6VW2oLC2F5aJCfzRx20fQeaVDgOUq+Xw0vSEga8i4zgdFfiXv8mr+F1EY9N+jB8T83fcA4vxE6P6X5yWeSsfmp5V54O91raO8WdyLHdwEv5rGtE+FlnBk8XJMJYogxkT83xE9R4z/5gLSeZG5QNYXJogcTCAO9nQqRq/JDSie/sc0DLdaWqeSCKM1lnbKnIoyJ4Vk71DNfgZZcAC+2JgO5/gCCBfGH784V9rMwQp/tv4ZqlN/wnGPgYocV5S2wM47qc5zu106bjO2herE/2Kp5ewXaMmOWWOpTaUY28xgnueKmAg0XWOKg+Mmrj2Xm7wyPzB0b2mwyFuIE9RzCy8VdI2mEogWqNf04S+3/h+nnFEZ7OfwQ/ozflMMC9UhFFI9r/al9TXiSuxCezPZh1TAJS+clQ3Aji7oc8zOt573ixSD2YRuAlcjofWPI594emg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(136003)(39860400002)(366004)(186003)(7416002)(38100700002)(38350700002)(4326008)(8936002)(8676002)(86362001)(55016002)(36916002)(7696005)(52116002)(54906003)(66476007)(66556008)(558084003)(478600001)(66946007)(6916009)(316002)(2906002)(26005)(5660300002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DldhfN9sUqNhBhgeRJxeGaPFREccIUEv2TD+GziiXIeE/WI9cx+4x5YAgh0l?=
 =?us-ascii?Q?l/t3HM1XYKYbWqZF2MMrb94VtuenI2/8f/4W241JH0iO4CYCDNTiXngbdhzH?=
 =?us-ascii?Q?Ngf8O+enji4f7eacWzp+KZY/e5QaJmpW/lPzjwin1i3l6I5aLt92R3r5vUL3?=
 =?us-ascii?Q?TDdIpeYMK4JHM7AFoJG259MMThJAi4FITjfu8tECjDqwlo41vFQJ40BujufZ?=
 =?us-ascii?Q?ZGlKY5hiTFCXdVP57Y6IR3xN+5gQcJYkQWB4P6+VxIa7/DB2misZ5YB4dJFK?=
 =?us-ascii?Q?NCc9Eqtgwsk8Evez5mViDHQlFg+jsyUT3CbmqQLOcIl3qsF7ZOhsE/JhzE5t?=
 =?us-ascii?Q?gI6IVTrk3tY/dJv1DG2yGwxwKn1tHjDvjZ57eTRzWb1Iu1BZhy5llz/McGFy?=
 =?us-ascii?Q?gMmfBocs2NQtTGEfIw26XN+oNXRY+EYCGL+r1tcRc9aLOoMIwJnbxCJ7m55U?=
 =?us-ascii?Q?Axhcuy86QrMv3I5jR9OJT/X6JAZZWzNcxxc3yKouTeI+NMGzn9M5fYVAw3Id?=
 =?us-ascii?Q?MipGxjYhdCe/CBUfXH0K7hd9LhBY6EgIqHPjIX1djblU+4zNT7QcYOfkezCt?=
 =?us-ascii?Q?7b3nE3o36ybOzUXTSaIeBY+a9dpPy9VmHe0JSzp9OepMnnhiueORZ6mReSiG?=
 =?us-ascii?Q?m5EclKpfOcmAYyEVQtc/tQKpj/cZwHG1Lkjx7wOyfw7mSi68ZocUcjDLbZzn?=
 =?us-ascii?Q?qyFeH4DUTG/2Lv+j2+jsqx7dAPWYffy+QYZlt/NU56g+2fnmJBsy2DMf3UuK?=
 =?us-ascii?Q?v4y6qlPtJrpo7rguKf04Y8V+S1kW7IoDRKQpNe1xaJdODc+lGJ4ppRXkbp47?=
 =?us-ascii?Q?uM58foIUh2Ua58pOaR4g+F/YqSt0u8Qyd1deZlcFMF9b//CeFuzJitMAtvGG?=
 =?us-ascii?Q?G+bNq1Q9XqbXtnRy4XMrLWsslEdX0zN4jutJ1jTKgfN4220WeQSn3T5vdK+P?=
 =?us-ascii?Q?3Gk5z2gYBJErAr+h5GvMMWpQ+GTZDZ3doRCpABfMaXTtby24ODJZiHkn9Ea2?=
 =?us-ascii?Q?nIY979mrXcGo9o5spPKdvooAnxyL9cywImFhboTy5umR9IWEDMB4okZkCir8?=
 =?us-ascii?Q?HqtnImSu5CspjtKttTDDEdQkFORzkB9pjReiTc5As6Ztc4izaA2fDQJktXZ7?=
 =?us-ascii?Q?HjO3i0sw4yYhVziudoa7cYYZSBIbDyQO3HRXWJ6Qq3Ip4c1IBK9fjJeCswoA?=
 =?us-ascii?Q?lvI0aebNjyBxFYkUZsmAeI4HTjmIDN9dwbgX6MOjzwW9N7FN6UEG8vXa7DG2?=
 =?us-ascii?Q?2inV2wkHZJd/4aLkhU6H9KEbDehr4jHqltacmzFmwVsoHhMxzx70CRyr5sHw?=
 =?us-ascii?Q?dD9dLBfDr/8syPc8zN6Na1PT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52b9e8bd-8662-4f2a-9f36-08d960dc1149
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 17:34:15.0636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xyVx1y5NQycZhjvXzSxogsrUOqQ5in43HUFMqkaS4A9ERTeOydEkEoyXJx7J9DLtnSba1QG2dSkX/+3NpPFj0sV56due1Wg5LoP4DfzM2Qw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4760
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=927 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108160111
X-Proofpoint-ORIG-GUID: 13Y-kcto_g9NdUqKAlD58BLmTk9ocjDJ
X-Proofpoint-GUID: 13Y-kcto_g9NdUqKAlD58BLmTk9ocjDJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> There is no need for scsi_cmnd.tag, so remove it.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
