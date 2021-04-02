Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B523CC43460
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C091610E7
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbhDBDye (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 23:54:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58344 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233863AbhDBDyd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 23:54:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323rZHS179651;
        Fri, 2 Apr 2021 03:54:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=18OqIuBiVO7nirDlPkXGN0IlH2a7Muq/YsX3akVgpFE=;
 b=bsn/rxCJF1l2B+8Ny30vgbSEbbZgZkA6egg19SSo1IhheEL5hT0NG6Gbokl/exYv16W3
 XLlHuMDUY2cYi1m34vsgj8uGxxXXiphW6lrQv2FP2RR2XAa6kfgbIPd+N5eIqKJ69q46
 jMsVaUtgn2H0A8yvbFu8qn2qCW1XFvhcArCoQ9oMe04uctNISdWTT9uU36x0hqYPAw7s
 3CWk2/JcPvIHEuILg+sqCaQII6Jr2Q9hUmwemRK8PuRs46HcYPZsiAULwdrVxaIpsqtM
 JRw6FKLjjCdU9+ajAncSCE1bmekXKI6LQlE+IDuUHAOfBQQHJryHrUYJboonrAVyKKqc Cw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37n30sbm7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323pdIr101592;
        Fri, 2 Apr 2021 03:54:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3030.oracle.com with ESMTP id 37n2atmxdq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AJf1sjxzQCqgVeNwKmBpuf7iH4FQMsYpXGSVXsVWNL03s53ZVVUtg+/h8wm5t2M6D18yioF5wLUCW3wUtRk4kifrCdVVeYcaVbjKHAO2awwA1EJV44GjZ+sy1ZOhCGZo8xh+leeH1julUSqaOjO3sjDgpqEZ0m87P3vndUciZu+9oSDXqQPi0UbAunXE6NGacJ15T0cDPXJ45knuJ3bwtauhmBMsnoge+aIWjrwj4M8ddJvu7yzkQA+mpCqCpPnZEju3iDy8XxaFio71F6JpMzdsvj0pKSTE0h9iaYyWTqRcVOLytQRDxb+p+m6fEPm9F6PA2MO22gKhKmue51YNwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18OqIuBiVO7nirDlPkXGN0IlH2a7Muq/YsX3akVgpFE=;
 b=dxD0fVWMHKWmkd2yflAGpFnjcaXNVzRYhyZNrtPqoo7YNvYoFeqa5I2JezwOgpEZF1knrQ+MdgxtFwq8Cv1SQuG/ynPO4CXuD+uNUIsHPgkVNqzy5oRKcTqhaQKpi8TQ1poGjLqvUwCTJ7g5Aa2uEU9HMYc1yE03/cuGd7KHjyDJVLAMIuYNvYq6orw23fdZW8mqwh0B5ap3CoA+kLFXObXFeUkZ/vVntEPe/+UsJKVfN3R3Z9Qfmsnh4kpPFN9OI7EUFQVlxQ/IjwgBoM0RRfq1KA0MQmJ+bqBjnKOzE9+Na981ZBy07sanQQ+t3dkQYMPCgr6iE1923IKLGKbLLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18OqIuBiVO7nirDlPkXGN0IlH2a7Muq/YsX3akVgpFE=;
 b=qIG0ejczkAn2O6ecUbjH9s0qSRZFhfdE80ZasXgjsjwGO+q83dW7qkLA2mTJ8fyPTXaU31pYqQ9CRILcYZN19fUzbprc747T47TCGaFL0GiLSawPSYvLhE4LIMaBxMhS3FwiyKMkUieIiCysunAVKbwvdMcPwR6VAkMltn2wNN4=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4711.namprd10.prod.outlook.com (2603:10b6:510:3c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 2 Apr
 2021 03:54:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 03:54:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     lduncan@suse.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Fix fnic driver to remove bogus ratelimit messages.
Date:   Thu,  1 Apr 2021 23:54:15 -0400
Message-Id: <161733541350.7418.14816303435957139451.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210323172756.5743-1-lduncan@suse.com>
References: <20210323172756.5743-1-lduncan@suse.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:806:a7::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR10CA0007.namprd10.prod.outlook.com (2603:10b6:806:a7::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Fri, 2 Apr 2021 03:54:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7163a1a8-c39b-44a2-ff7d-08d8f58b031e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4711:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB471177209FB2426B387B1BEC8E7A9@PH0PR10MB4711.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZWrYgBgkXuuHCZ9hRDbMs2C+g4SPfcV0NoLVJb8CzuvXF/1wldatzDNJuxGlWRMR/mLcLgYCJ4GGwZyyRa9685wGttJ1ohKgYNy+CR3kDEWfJ897WIDoI3bqQxh2+Ejl5TX+nRtMMLWfQoCtst2MvEfR9ocdIf7JSZXWPoq7PJmGzBtKdgowiBVii17l3pkw0+hio2z9BlamO+kaop7XIYQZiqiePi7bO29UvnQtkBdbMSmj4JUfmBC6wgy/F5cx+TNKpTvuy8P/zLZd+cEsoinSlqinb4aOnmJ/Fypzy9xw7uMYzP4EFaOmUuEtY6qL+6BgReRAvoFJcfG+NY9Bp2PfiuxxJdNRmFofSrbBZcNx4VlUelnPwi6Wj8zus+f0fwCy5C3jMOgW2kRmH8LBzfsXcgONYpJQJUUIC+KLPdk152DyZZPexEgk3cDgv6yNSZJpwk6kfFshP+7nlEYZbj/Kx4RH7VcjlR8BFsu0j6y3OKHGuV90y4Ck5mEzFRGFzAavvGAbNkIoMoTrIfXqMGH2Q5LiChud1M42hMyh8FPLUI1tqiYNS1a9PQmFO33bDKS2ZzdZBQ7shMp6OPhbcC9OOgFviyyRFa+s3Em6jsQC1KBKjxKrfKYYEuirhGc3l7HkPYQn9YU0IqaUrAmz+vv9BtaglnIhUptwEU1Boeu9+DrjXDHt3p7W9oV6+aWWwhUUZF5gDSWWii9AmGtNLYsqHoXC5uSmya1FzbgxfF8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(376002)(136003)(38100700001)(4326008)(316002)(5660300002)(478600001)(966005)(86362001)(66946007)(66556008)(66476007)(186003)(956004)(107886003)(103116003)(8676002)(6666004)(8936002)(6486002)(36756003)(15650500001)(2906002)(4744005)(7696005)(52116002)(83380400001)(2616005)(16526019)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SVFkTGIvaWh2dHhkNmJXdERqY3JmNmpkZjlPd0hmQk5NK0g2M0hMTDcxNXhm?=
 =?utf-8?B?cVpkb2hKeFZZVlc4SG1MMFI0TU1XbjVsZ3Z6UUJQdktpVnM5TU9FMlhjQytr?=
 =?utf-8?B?YnJPWlYxc0dNQ0RFMkwvL1lMa004SnRPUm1EeHhFQWhYOUNIN1RuS0VxV3RT?=
 =?utf-8?B?Q2dnS2puSGhaMzJ4RERDMmY4V0gvdDN5bWNZczM3RFBFN2YwT2IrTUR6Wk5W?=
 =?utf-8?B?Wkl0enJoeU1OMnpHYWdldU9PZStNcEFnOCtWVStJbVdyeUtLTy84VVY1YnRL?=
 =?utf-8?B?UkJ1NFJkdzN0V0RFYmZWNlVQbWtyZXpwN0Y3NFNFcWZTQUNtSTJ1TldLeThn?=
 =?utf-8?B?a3BCMjZGWFVTOC80NEtyejhYYlZPMmV5ZDBkZmtWbTZubzUxcFlKckhRMG5W?=
 =?utf-8?B?aS9lRmRqWlZqanNUeUhONXFpdGk2TFk0Z0FEMlA5NHNRMlEyNWxtR2hzd0FI?=
 =?utf-8?B?WkdNOVRRbm9pelRHOW1wSlFoMzQxaEp2Qmtpd0JSQnk3dEN5Ym5lNEQwSFFS?=
 =?utf-8?B?L2ZRS3g3QmdLZi9xc2xaa2o5enJDV2NweUFWU3pXVDZTL3lLalIxUHVzampa?=
 =?utf-8?B?VVErY1d3b0ovZHFQOGtPKzl5SitTVGowSFFKdklBdGo5M3JCcWMydStPTERY?=
 =?utf-8?B?aTBOKzFvVlRGaEVFS2NtaitBN1FueGd4UnZCbFZVL29DKytJRTRhZ01lcC9s?=
 =?utf-8?B?TW9ubk1BbG1JQ2RVVXpqcjlFMDlGR1FDcmM2NGp3aU1Ldk1ldWFIZ1pjZys1?=
 =?utf-8?B?Yi9OckRFMGxJUTdQczNCVUg5MnM5d29HclZkMUFKQkZxdDYzbDQ5STM5eisr?=
 =?utf-8?B?VTNsV0ZUL2drZkY1b0puUjIwZnpQRmlnZCtndWFmeHBESzArVWJXbDRxNmho?=
 =?utf-8?B?ZTE5dDllNVkvV2tCYUJadUNsRDFISkgvVkgvYzlJclNWK2p6a01KY3U1ajRU?=
 =?utf-8?B?ck9RNmQrNTcvWUFPTDVGazlQa0syOTliNFI1ZTd3aEdzY0h0T2NvTXFOWW0x?=
 =?utf-8?B?THF6Q3BWYU16Q0l3L08xY3ZRSFZUWG9IVmVMKzZyT2RaaGhxLy92blBNQWJi?=
 =?utf-8?B?azVjaUNKazZKVllyeUlnRHZBRVg4SjJCOXpvMGJDRFFqckhweDdub3FRV2tk?=
 =?utf-8?B?NVFoMHJtVlY3Skg0b29lWmxPZGpYSlRldHNUZDk2L2k2QnNDQ0V3R1EzQzRp?=
 =?utf-8?B?MDhXZWhjN1BCYkFJWTM0Qy90OElvaEZSRmtzWUpLOHR5cDRScGRTTGNPUnR5?=
 =?utf-8?B?SVRzT2o0eFhSR0xEUEFkdis1Y3JpS1BSUFNGOC8rYy9QclZweUVmUmZseHJt?=
 =?utf-8?B?WDFzODBNclV4ZVpDVzJLWVNYQWZQd3l4Z0pydHRQcXJFMko3RTRSN1dWRHZ5?=
 =?utf-8?B?M1hrMkVNYWgyOGxtRldKRjdxbGVTVGp1MmVEdjRLZUtVNlNMTFgzZHA2dXQ3?=
 =?utf-8?B?dFJEN2pYYlErR2pOZnBQSjhIMkVlL05zVFg3WVZkT2pSUkhIQk1yOVNyblJu?=
 =?utf-8?B?OUlUN2dlcmg3bCs0WWNYVTdnbXVkRFdaUkpCSnp0d1QyVGhTblpNclJBWWI4?=
 =?utf-8?B?c3pRYVJMcUNyWU5qT3lyNWFHclBKNTVwa25OYW5qZ1l3UjViY3VoY2tFZFRO?=
 =?utf-8?B?TDZNbDI2VzNYa0hTRlVYVE1sZXNpRjV6ZWphSFhsNVJ5YlozUS9IbTdxbkNW?=
 =?utf-8?B?NmVHTE1oRm5ENTV1R3c2elBPL3VUVFdUVmd1QVdFZVVJc2RZekJBRjNjaHd1?=
 =?utf-8?Q?g1cWRrIjwSgt0rLq31Vg9UVFq4ekzKswFb15+Be?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7163a1a8-c39b-44a2-ff7d-08d8f58b031e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 03:54:27.7853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uKD8h3Y4L7C3VFFsoZUTwjUZ66+JiomzosAGIp/6xghdIooMUwTIInXRrNHbPeQtsAlFslUN9WWk+DInDMmhF8Ozu1qPWRPgIL5m8Qi+/W0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4711
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
X-Proofpoint-GUID: WNgfT-sMsPt0gNOLzFhmrgSoGS5_aAVL
X-Proofpoint-ORIG-GUID: WNgfT-sMsPt0gNOLzFhmrgSoGS5_aAVL
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 spamscore=0
 clxscore=1015 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 23 Mar 2021 10:27:56 -0700, lduncan@suse.com wrote:

> Commit b43abcbbd5b1 ("scsi: fnic: Ratelimit printks to avoid
> looding when vlan is not set by the switch.i") added
> printk_ratelimit() in front of a couple of debug-mode
> messages, to reduce logging overrun when debugging the
> driver. The code:
> 
> >           if (printk_ratelimit())
> >                   FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
> >                             "Start VLAN Discovery\n");
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/1] Fix fnic driver to remove bogus ratelimit messages.
      https://git.kernel.org/mkp/scsi/c/d2478dd25691

-- 
Martin K. Petersen	Oracle Linux Engineering
