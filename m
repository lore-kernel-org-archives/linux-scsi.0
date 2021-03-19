Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52858C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 02:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27BFD61580
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 02:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhCSCfR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 22:35:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34716 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbhCSCel (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 22:34:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J2YSth147438;
        Fri, 19 Mar 2021 02:34:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=buG9q4VDja/Xk3LfotX4M3rTD5gvGWptbNF8jRa4yn4=;
 b=LJK7unjtX5zOGHT1qRJmzkLPJPGOxXgJUUKFRWdL4dSGXIEerPKJqQivZWdCM2T21tA0
 jOhiZBGHNcv/tlJ2mNG4y9EkKr/TobO4xQzfzinLfVk61VXgt5uNMHONxyqTouMmkS4q
 tbkxFNTdnmJx1o6Mhnr7pvLeingicMJ/w5jVAZS2ylmfCOW6OhR6f5AA6dU9m5y0Y/gy
 3lZ4fn5nX3vrY4Kx9GEYERTBQOS63GzbeJshyB0xNST9DDDDDXOGWYVlzhuSzBSyN2Ry
 QaVBk6MOXzrF0OS4WLCqt4KUv2yifZVtmpDtcC6o+09E5Rit9YpPqOETvlQP8G/dwnJ5 fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37a4ekxc29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 02:34:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J2PfVY033087;
        Fri, 19 Mar 2021 02:34:28 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3020.oracle.com with ESMTP id 37cf2b7hm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 02:34:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OuugCctjUtMvuzWryC59Tvl9XBSQPIrthzwDvq1EmtMRlLnRCImKk/IN/KA8UFL4hshjcoJ9tUtaJOKQW9gIAPNIw7oBclfQ6opU3QcJZyBX5DYcFZiLyw54a78M6NNEVOiYNmpl/n/40pH/a87IBiCX1MvbMlItt7H1AAZXngJH7h74DlUzROe1SBfD1zySM3YVPaqRZn6Kmmb/QDFoQbgAVM8g+PdQdPvizdEisauyPXPOSBxD+Y/wE+uxUYjPxELEiCUAPBMpYyeTR9Nv0iSOswRPxPJ2jJ+jH6A+MRVSzrCmd2RL/emJyCLPijq+IaWpjj++MpiK8SRPtDyK0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=buG9q4VDja/Xk3LfotX4M3rTD5gvGWptbNF8jRa4yn4=;
 b=aO0JyMuJvkKDkZsi660g231wo77WciFr1EhXJoTvpsiadEtnwqEiFiwaI8olsK9MReVaMthW1xN9eUBw7sIen/Wp/9yVMRf/X6RPUsnnrenBbhz6XHOYaskPlfjMm1keWFNWtlJmPXEou5EOdLAbnPn8c9uelW5G8bherSrOMfTGPbzLRUhpQMMX3cGyYjtBf0oZYkTjbw56Yy3c+YjZ5x3NATZMa9MnBCiNsAnRYhsLFAVQUB5vPj0jOlxS9/l0YrytAE1vlw8bYLOVi/Axo99KHC/GXrwKhxV3COyxZUR6yUmFuhtc4fawtrRX0QYXAmlEoRlJLH4OxBHD7q1ZNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=buG9q4VDja/Xk3LfotX4M3rTD5gvGWptbNF8jRa4yn4=;
 b=d8cbPHgZQuyCuRxmCkpB5Vyz2iZAazzbj9nXDIdQjVWDKKWc2QuYM3bhmSo4dO33WZyUuYlW/V06EVq+rEBFgxoOBuFjT6AI/ZIg3c2bdpcV8jmh6TGhcYwOtiPBhhvFZadCZJYrDudx35PCVMu9hREclic26WTvcW5C6F75eg4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4488.namprd10.prod.outlook.com (2603:10b6:510:35::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 02:34:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 02:34:26 +0000
To:     Yue Hu <zbestahu@gmail.com>
Cc:     avri.altman@wdc.com, alim.akhtar@samsung.com,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyue2@yulong.com, zbestahu@163.com
Subject: Re: [PATCH v3] scsi: ufs: Tidy up WB configuration code
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7l7q3bu.fsf@ca-mkp.ca.oracle.com>
References: <20210318095536.2048-1-zbestahu@gmail.com>
Date:   Thu, 18 Mar 2021 22:34:22 -0400
In-Reply-To: <20210318095536.2048-1-zbestahu@gmail.com> (Yue Hu's message of
        "Thu, 18 Mar 2021 17:55:36 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::46) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR05CA0033.namprd05.prod.outlook.com (2603:10b6:a03:c0::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Fri, 19 Mar 2021 02:34:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d32bd945-b6e0-4d6e-7a22-08d8ea7f838b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4488:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4488D74652EE4D1BF5026F398E689@PH0PR10MB4488.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PtyeH1gcsVHKcobIJvUq82N1nRVCLLRLcC5FD6MxmV+7Ukl46fi13xrIHqYeCzYg/pW+BjAYZAh5ZD086r9LxdlYC0zd7BQBDYkrW50nxH5cX0ZFxsnQ6eRwN3KvYXcKCO3PPmSUjbnu6FpHDBmSc92byR0jQnlVMZVfeM9Hwv8XAP3vYW1lHaz0z86MG3J401LB2VMoMY0jR1q+jUIgqKDZimv/ENYJhoecZ+hqVcP5R19wBd8CAJqKbYoekxOx4PcT50JmqybbD1oqfXKjoWA09QTFGQBQYDVDlaCROc1CKwjISvB8TEi6QyINGQpZAwGCbAVf4sp/qpcg/4D2Inb4LYAZDEAYlG1agu7ze3tgDwxRYY+725qHY75xfhZXNSDt/RIodXXaKNmnIDCR1Nw7i5oJRFj+/T4JKIviD1+2LxcGr+5LwI0NC4NDjUncE56qFYcQUter4Y+iC413rI/dI1UgTuhzjpxLd3A2/RfeD42PbDwZ20aOhNoG73UjY1qeGXwwl/wd4cB8eU27fgxT1deENDHkiKD/Dw8NC0GqfGkzIvGllf3QGx7iapWydn5sk8HLM4RZ3kLRZZ6fETjwz0kpRx+eBejXpE6sGrlT16t5hNxkuBS71sz0Z02XpYbXrKozx9esMFxRgwZXxuY+Tzg336r/Q7M/198UGL4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(346002)(136003)(376002)(2906002)(4326008)(8936002)(55016002)(66946007)(66556008)(6916009)(8676002)(38100700001)(478600001)(66476007)(956004)(7696005)(4744005)(26005)(186003)(5660300002)(36916002)(52116002)(86362001)(6666004)(16526019)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gctdk5EkM9q39SCOTJvX5tMWH0sm92NjpipN/jp8Sgcdaugaf5tLj+NmKq+4?=
 =?us-ascii?Q?xROIWdc8b+LWbBo0uRlwHDl/Xr5kMrJxQa//8mMO/Y7KNQ4mQIUaUh2R0kNH?=
 =?us-ascii?Q?Hoq4YGBv84G9bkRSmpz96pVM/ybdCMEKy/XRe7oCDy5XWWb3i3/Zxg79IuXc?=
 =?us-ascii?Q?CIbvnrwcAhtqGtqh4J3faOUjYKXkW9KptL6AxKcLcfmJOFXWP5Sxg77Ku9MF?=
 =?us-ascii?Q?QjTRlKwCnZCYB6N1/5U/dwsS3hrYVHMZefzRumK4Cg4ZEr3XVzMFJAPM6tLJ?=
 =?us-ascii?Q?+VfDw+pFVnl0CSGbdR9PcmJpdCEEMcsL2eKcqzsD4wA7LD+e1UftewKdhWsn?=
 =?us-ascii?Q?nof9qCTw5agKxZCe7OBiVFemyajwHMyVjaNCL9SSaRAOHYhiJxiNJTtNiOIL?=
 =?us-ascii?Q?CFQegO6oGT7Ro+iMvsDoINY2bNcpF2rt8R76eTAMFB8+t4XjTUKGMffMIcOO?=
 =?us-ascii?Q?lVrErT+AMktf33y30UxXg5ECvFaKgv6PXSLP3kT3NK8a/cYZjMOYgwFF0Ead?=
 =?us-ascii?Q?eqKDZZAhZH+IMOgHQqUnzeRziwCyPWyqc2ypsHA9/3xu9RZk3RlfsXi3Dukk?=
 =?us-ascii?Q?hznFGYImx/hnRbBlf9n6UA+iefco1M7kG42O/OJlhQaEAB5jHioF3nHtDwre?=
 =?us-ascii?Q?BuYiHnmEk8CGFN1mT3rK3QrImTVSopIG4wzk8l9Js9Ud6Vr7piL7a8E1kvO9?=
 =?us-ascii?Q?ngVM8WWbYoX/tobzQlYrWvgUAWERkXTfkvaqzQJeEKiw6npcYAD8lEXx/bx2?=
 =?us-ascii?Q?Eegx8sqZ9oppLY5FZShI0njfIFmdmZC/lP+8cAbZ+K77nxfGARiwHnlCya8C?=
 =?us-ascii?Q?xTg3tUsDIoOECb/1xz/wS+vVw08Kyj6D6TtAFIaPY9eRgtexTCO/y8Vlmg1Y?=
 =?us-ascii?Q?yi/NssJ8WCYyCuX4Jtw1Wr/BurxoSCm7spoDE61cDEZ73Tn8lIUJLhYjJhJj?=
 =?us-ascii?Q?XgKkBbF3faSA5umYBAqOhHYU6/ZfFp39N2hg2DPmMq/pnIUmm97Fp0aL+TPO?=
 =?us-ascii?Q?oacE+8HDYrg2/o0Fg+qMz8QwHfK7dw8EhOLwZtmYmir9jbj8llXbZcWJcN6Z?=
 =?us-ascii?Q?omOwhRY3ysYFtehyuonJV7JOwnHI5nX3Y3NEsN/+RXfgpMvNqtDbKWKcYxsx?=
 =?us-ascii?Q?UGsSW0thwga1zO7t9dkMd672aFXi7SUaTWQj0g+ogp+EzWxUpTQkTfwbX0Yq?=
 =?us-ascii?Q?WmiR9KBBKRmt0T0y7GggcCmqA3CeesZH7Bs+k+IZGPMQfj4g4ZdB3V1xN5Nd?=
 =?us-ascii?Q?bd7eDFszO/48Ik1Xn4dl/G/fR2w8sGir+aRNnjweOCMx5dov0HLqiwwKFEXs?=
 =?us-ascii?Q?JhqxpX1PNAeaJegb8+6Ta44p?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d32bd945-b6e0-4d6e-7a22-08d8ea7f838b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 02:34:26.2852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kddoAZiOj7ybqCzcDm0yoV4+vZJMnh7LNz0xZW94eGJAGzEeeg86JzkgjESWe0jVPXUAVnYwbbqEzhr1ypuf9OAg30/aDQNFGDORJ/8cNjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4488
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190016
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Yue,

> There are similar code implementations for WB configuration in
> ufshcd_wb_{ctrl, toggle_flush_during_h8, toggle_flush}. We can extract
> the part to create a new helper with a flag parameter to reduce code
> duplication.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
