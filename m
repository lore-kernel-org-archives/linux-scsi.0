Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F87C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 02:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07A4164ECE
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 02:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhBZCXY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 21:23:24 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:46870 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhBZCXV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2021 21:23:21 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2InqC064217;
        Fri, 26 Feb 2021 02:22:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=zsC0Zc6pdtTzfqMhNevRgX/L/0WXR4o7j2Sh0dVmLP0=;
 b=rVUo8gtoq6bsSw/GLSFeFMULb0kQ1q4LvrW6yBXvT5AO17robBFDPgwTkHZyNopY5T3B
 vMxwEs8d39xAO49nT4SHyiaOD2gSf4xRevM5jgNVi1PbiJ++gbJczYLNke1ZLOAt9sOC
 vo+V0jFKPAuOjU51d/IKdZqcqHYXePzj3a4Y2H03yaVrO9/3fu83bQ6CrPcZ0oC/fHd9
 Wzb60VDNZLWqb0HMfuXQktYmLbOFF2SO2ea/D+O1czKpP9vYL98unKRSCD2HLkB1c+kG
 smd1KMyGP7a8fNHQ71KvJkhRRk8IxLO/8lWrO0ChADa9klpLitB/ZM9RF8nQZ4Z1CwWS mA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36vr62avqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 02:22:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2KkqP083315;
        Fri, 26 Feb 2021 02:22:31 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by aserp3020.oracle.com with ESMTP id 36ucb2ufxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 02:22:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GPaBdNheLDWkd/VSw6/Y9OVZchMxPGBZfPYJ17LRrKraEKgi9thNIyFk1yW7Lcgyj6R3Y5h2vV/Bn/bLMMJ7HCj2pattMT1epFGgD8dKntRCiIs7LOljSG5baPHSJKyCUPufY2wBpuROcRSPZuurgZkhtzPGT+imuIQP6fblLd/KVzdzmzhsJq7/Eqgq3PQyiJn8JFLxgkRWUNjd4pgqpnPi6MSHSKrYO7eQ9PrwlX4bE9EJYV6TVgfiiTX3DTQxoMPkZ1ZW40RndkSd60CPZdPdMZxjM73EyXavFF5jgg69mu1imvKcqMBc8JPFCuEwsYYABmyhuqPhUv2RsJ2NJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zsC0Zc6pdtTzfqMhNevRgX/L/0WXR4o7j2Sh0dVmLP0=;
 b=WZhSurVZhxB0xCYpqU2RQ9FIMW8yYrOQadqrs8sEMHZr0Iljpaq9tHbR8wN8l7KYCuOuNfEJg6LlRcVWTXRorLDz7PhRprQqFtpmh5B0F0tlm9PIHYyNfBa1fmsjXqNlO4YERL4syZ+zda6Dst+WfXHNAGIzU0CgX8/TA2OD2BfLXWhQEqdStFw9b8BVQwhrJbX/WnqMnDHucSGsyXxA4u4HhUcKOnRuB7eYtoXcsV3LHn/jBQVUXK2UuY/a0OVRkqVpawIJr0dnFEvENi/BvCMTZBD2NJxt4cV7+ep+NPHOGA8Oh3o+vREysASJqgh15PPxmYbIvhfHtC6SQw4STg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zsC0Zc6pdtTzfqMhNevRgX/L/0WXR4o7j2Sh0dVmLP0=;
 b=bZU0ta0WY9m5P3Xs7ZMtHrY92DB26mWPnLdEdUHcavG7a9QAdgteNRKYkpTw/HA7f/Vb2hu2tUbTRAmdRcSGiUdLsIf8f+0XQLUWKUNt4eNLybXKwFMoA7pFnEDLBw60XqRL59x1Bl8Z0VzyWjLyU4a5j9t70rWozYREACR+I9I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4696.namprd10.prod.outlook.com (2603:10b6:510:3d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Fri, 26 Feb
 2021 02:22:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3890.020; Fri, 26 Feb 2021
 02:22:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.com, Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        rdunlap@infradead.org
Subject: Re: [PATCH] drivers: scsi: aic7xxx: Fix the spelling verson to version in the file aic79xx.h
Date:   Thu, 25 Feb 2021 21:22:12 -0500
Message-Id: <161430583250.29974.454442041779784428.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210209143146.3987352-1-unixbhaskar@gmail.com>
References: <20210209143146.3987352-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN7PR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:806:120::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN7PR04CA0031.namprd04.prod.outlook.com (2603:10b6:806:120::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Fri, 26 Feb 2021 02:22:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a69afbf-47cb-4313-8775-08d8d9fd5dbb
X-MS-TrafficTypeDiagnostic: PH0PR10MB4696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4696D9F1A3BAC6EACB10EFAE8E9D9@PH0PR10MB4696.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZRV87+OU44s4Rtl287Ygy1CIAcj9KSn643Tb+htW1euV/e/Lmo8tsSHOwrzJgJRW0hi1pXh9qfabv24RB3GiLkIjVlpD+2RlD+Q2OqBAbY5a1dulD/iEmHctlwWt/jiGqEuVHboiVI5OGlYotlUfJaHPhU5HL+uJb6CfZfm38IqOKwgi81jPczv02vp0xBpe5PELw+b1uxUgTAS4ybmxttUAx7UMq4UXL8a4saFrXtewpmAbBzAuS0KDOPlOwhAZtFhfbUeG2blB45UzTvXIcOjjxyK15Lfz+W14f8LavCcsW61GtT2AWLXHcZk2yxUjaE/X35dK7kkCPABYvUjQRCNAqeLodiAb1q41TCsxTv98QMvZt4dWfg7uDQD0/VmUfeliuJZlPSavMmluF0xNCTl64Z00oscui30RAjAupsLZKJSCbVfesUiyYBZd6A/7anzoQgzidpVBsZ6PLu0wIlGFyU+2EIM53G8A+rQJlaJ0fdse7SaexrZr04k/n/RGcyC5bVuP9wBAxxYc2yyvWiFfQJWLewAxlK85oESKm+mZA2lGfRABNktK3NKzRkHJru7N4mnuF6RrjLCstFVan8HT4ZrH2qkxT/RO8KDCEZw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(346002)(136003)(376002)(36756003)(8676002)(2906002)(7696005)(52116002)(2616005)(956004)(966005)(103116003)(8936002)(558084003)(478600001)(26005)(316002)(6666004)(5660300002)(66556008)(66476007)(66946007)(4326008)(86362001)(186003)(16526019)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Tk8wdHgyVWlPbTQ1RHhJK3RWd2VsdHFYc0NNR05jMjVkbytRMGdYa1o1akFX?=
 =?utf-8?B?Q3ROTEV2K2hBUVg3U3FicktGcnV6a2x4aERMUmRlSGp1dkJNQlVoUUxkZm5T?=
 =?utf-8?B?cFhETnBjSmUrVzM0TzlFdnVlT0VHZnBMZzVKd250Nmc2ZE1qR0lOYURrM3M1?=
 =?utf-8?B?WUlXaGY5Z0c2V1U1VzgyTldrWGxaWUhxOGhvVTRCVHdVY2VaZ3R4cm8zcnNu?=
 =?utf-8?B?NktPb2l1aWNjL3RrL29qR1NiYllUOWdPZkVCcUtXRDFmaXdMZ2xHZktwaHo0?=
 =?utf-8?B?V0I5ZDBub3lFVCt4NElGOFRLSjg4N2J5SHA0bXVpd2xsK1gzbmY2am56MDhU?=
 =?utf-8?B?dnpaYkhJRm1KcnlpV3E3NmhkVWNpS3ZPeFA1aFA5RnlDcXM0R1hFTDFaaFU5?=
 =?utf-8?B?SGJsUnF3cGFrS29NN0l1WmRIQXRueHY5ZGt5TnZNREI5MDlNRGM1WHlFV1BE?=
 =?utf-8?B?OU9HSXB6aGxxeFpscHpRcE56T3QvTDQ3MFhPUXd1c2Z1MjNZNEZEd3RjREE4?=
 =?utf-8?B?ZVNxa0xsVDRsbFN0WG01cXBNZ3BtWWJPMG40dHRPUGYwVTVNSDBpWmJjRXBi?=
 =?utf-8?B?cHZlNWFJTFFUcmFyS2NRTVRzeFlZS2RYTUI1SktqVTQ3UFFQVzd6bFQyVG0z?=
 =?utf-8?B?UmordmRMczJEbEVGZDdkcnFxUXUxc1BMbnMvMGYySEMzbU9oa0N1aXQ0Wjlo?=
 =?utf-8?B?OVNVczc0SGMweTdQVWZXS05YTmpWcHRoa2NFVVhVSUhVZkxLVTdFVzZxd3N3?=
 =?utf-8?B?c3RpUWxrQlhMNCtaZDNZS0cybGw3RUw3ZGtVQ1FqbXpOcVE3bnJWOHR5WWRa?=
 =?utf-8?B?RlI1VFNwYU1tMnp0S1diUkhKQ01iZ29GNGJIRXZDampmWVBVZWE4amxtVSty?=
 =?utf-8?B?MVRucElxUjk2Tk9ITU1JWDJwMWYxWDJ3Z1hiWFdaUXMyTGJ0VDBhR1FReStv?=
 =?utf-8?B?MWp5WUhoNXZZWGIyUGo1RjVNcUFyOGh1aHZWaEgwMXJBclFUUXhCd2h4S2RZ?=
 =?utf-8?B?WlRrODFSRXNWUXJxU3NoUE05d3hxMHZ0K2ZUTDRnOHlWTFBxTDlweTE2a0xY?=
 =?utf-8?B?UmdFZkloTGxlb21WeXA4RXFDa0tOeWZScTVvY1JkeXBDU0NXdGxFbCtyU1ZM?=
 =?utf-8?B?b1VkZ2RkYzQvMnBrVzJKd0RuYW83Q0QzVGUxRXNZanozcFdxTllqTXY0TVRU?=
 =?utf-8?B?cGxHWFR6YldrSmE0NXZ0VkJQS25YazhuemwrbTc0R3ZmQVNreFVKMEhkSmc4?=
 =?utf-8?B?VWVHQ1NmSVNnc2tKYi81TU5EUVp6S215M0ZCNTVDSnV5YWdOc255V3RISmlS?=
 =?utf-8?B?aVBsNG9QcXF6RVdWaFNlWFNHUmRFUEQ3Z2c3ZjBXeEJJWmF5Q253eUdvQWVC?=
 =?utf-8?B?WjNSa3dqRy9ValRlbms2TDVneFA4RG5YaVVTQUpQcWJJUTdRUUpzUnlLTndE?=
 =?utf-8?B?VFBhVHpGWnFpb0JrdnZBQnRRY2xrUEdUdGptVUxmVHJodWovUW9OTkZMUmdL?=
 =?utf-8?B?THl3Z21uaHY0ZEZNVFhJcVFRTTZRblRmcHFhV05mbGlQa1Nid2poNU5hMFlO?=
 =?utf-8?B?NWhocGpuV2Y0bGNVckMrK3YrL1I2NFl3K2prcVNrRVBhY3ArUjZwaE1pWTY2?=
 =?utf-8?B?bzFaZkk3aVRzR004QjJZalBSaUd3MmRlRWFIUEtNYWVYdEdTM09xRktucHFm?=
 =?utf-8?B?d0tMSmgvem1hRkdtRHk4bWFTSGFYMm5JNG5RNkRXaXVxeUFMN2tRWDJ3cUV2?=
 =?utf-8?Q?G71+UOBxcT3ud/F/i/h3ixO11GaPIiqjKqwdUrc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a69afbf-47cb-4313-8775-08d8d9fd5dbb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 02:22:29.7729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S9Yd8hZJDySXj7dONsEXR7KdSGsAgknT9cQ33FBMNFImjE5LaSueTHOHLigs98DyMPHyN/Xd5X+NLyKe1yBWj/zhkb6SEnK2ruKzCG6dsbc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4696
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260017
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 9 Feb 2021 20:01:46 +0530, Bhaskar Chowdhury wrote:

> s/verson/version/

Applied to 5.12/scsi-queue, thanks!

[1/1] drivers: scsi: aic7xxx: Fix the spelling verson to version in the file aic79xx.h
      https://git.kernel.org/mkp/scsi/c/1f9f22acbb5d

-- 
Martin K. Petersen	Oracle Linux Engineering
