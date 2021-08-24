Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E10EFC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5184610A4
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbhHXDMz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 23:12:55 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:35114 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234100AbhHXDLU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 23:11:20 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O0xGh0011536;
        Tue, 24 Aug 2021 03:10:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=kyajq8uvdmb14fKsUEDNShrxW1werYGoD97mVFLW2/s=;
 b=choxq6QejBsxtWyzdUu3RrIejoi3letOnpqKh/neqOXuh2Lphlmjnae65lqJfQtLjrZL
 d5lVB5ZzzwWpUiNsyeXzqLLgK0FtJWY6b9PoR6D13zoyODF/9Ub1tr7rnwJpPndXB51c
 YsXD0qdNXIb49/P5/9aENkoI3i4Wzxt3rrlml7rHGW/TsoVKlrrQ5RHPFvkrSH6nfLX+
 UmyCGKSMe230qP1L8I342B/TONRuFHXzQpJRZvf+SzyKLr91JSpF4idhm65qFzLzSliW
 9NzosAkYi/xyf8h8SQy/1T/V9gJwVJUGJ73sj+wgfKJxtD8RyvEQMDCC7eLywKuNwyzE lA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=kyajq8uvdmb14fKsUEDNShrxW1werYGoD97mVFLW2/s=;
 b=AARLIf9RF4htVNizsyblrFQg1D/n3EmJ8QgL/auoKVGNS5wUpn8pQl2YIhLia+9qw4CK
 foe2JgQV5HR768VT1SXB5Ut9j5WQURR54n4ODuZXlj50lGozLPq0KRvg9aMxmO7aN7f1
 Smong6/SKg1N85IJ7g0SHUjrUKmjAasjo5dEyUvn2udFqL42lDEN02TD2DMJ2wysWH3l
 /XAW+YDAtJna3IxFoCWSJJkg7t7jNRaufPFo0ZpO1amHCZ5WLKXtGGg/2u5vmX9rAA9Z
 +vhvSw0DErMZbGdKLJrfmiSmt+yglaB+BQOZQhs+NmLxYWl+z3D9lAPH/IBg2nBBfGmK fg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akwfm3577-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:10:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17O35IMZ012483;
        Tue, 24 Aug 2021 03:10:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3030.oracle.com with ESMTP id 3ajqhdsvm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:10:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HpTMjr5BVAjeatC8hCkwnqVcc3Ps1gM/NF5/MoqWGrSR+bBMItxlCqDcij4wUselMxOfKwDoCy8lOEIF6ZfUtuN67rl4hzC1fYvDr3HLTMhdkxlRC7F0MYYnio9wkkjsYqOgShRrcB45XxytIXxjAFlsjbjr7+Z3u9fXwPd/i05ZIerkKaUFLgECZiYMo69xN2wN8x7LQftO0HFEnJKAk9o5NI+FH5yL/xOyGx+Dh1IaHWsaGcvy9chFmJTaAYXiF25TGiPfhkR+lLbmqV6vHdPKjwLFY43vKuk8O0956HiEF+I81otgYz10iBXfjOMyVR+kDGJyqRNedFge80WftA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyajq8uvdmb14fKsUEDNShrxW1werYGoD97mVFLW2/s=;
 b=AyQAzAYpa13Zz2kz4CHFZHbDfX+31yz5k6VBCtc4yOfaRFJINtT6kk+02zbkVUTL731sksnyn82r8LBZA/DO36f8OZFugD1jgyL2+NV04MMQJ4PVUIM9PZ4xsNTkQwS2kwoKWoy4KZCbJ2PQbvPM7ama0Gjl7faJTNYCrDAjsw+V8sbMOPSFwMzFpNbBqIhlhEwkC9aWn64OiAIvGPatYbeebABO/qMMyktw973imj5kvl5D7h6ARWc+i6VKxagfnyJUIcQwUJQQCCjTCL+8aVFVrncgWYaC/Zju/V6VJCLatr2mJQLKYG8yhnlB+HfigD7rmIWyFrJdArJfV3gmdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyajq8uvdmb14fKsUEDNShrxW1werYGoD97mVFLW2/s=;
 b=oWqU7mcZNlTFoGeIvMTR4b5h2yZBmLeKQs52KroEuitf1QpMm6i9cirOAxkQdgjz0wWs4Xu7X0LjiMwcRwv1vbyHiNOkjkq86xmtWG3LKfH+4hfMj05XoxyVtvuUQzWbBhetJnQj0KXAvjEJteZG23DByjVE2xp9ah+ICDyZfgM=
Authentication-Results: arista.com; dkim=none (message not signed)
 header.d=none;arista.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5516.namprd10.prod.outlook.com (2603:10b6:510:10c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 03:10:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 03:10:19 +0000
To:     Kevin Mitchell <kevmitch@arista.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] lkdtm: update block layer crashpoints
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsuzfshq.fsf@ca-mkp.ca.oracle.com>
References: <20210819022940.561875-1-kevmitch@arista.com>
Date:   Mon, 23 Aug 2021 23:10:15 -0400
In-Reply-To: <20210819022940.561875-1-kevmitch@arista.com> (Kevin Mitchell's
        message of "Wed, 18 Aug 2021 19:29:38 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0061.namprd11.prod.outlook.com
 (2603:10b6:806:d2::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0061.namprd11.prod.outlook.com (2603:10b6:806:d2::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 03:10:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d3cd530-8106-428b-85e3-08d966acb440
X-MS-TrafficTypeDiagnostic: PH0PR10MB5516:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55163CCE46037573180C021D8EC59@PH0PR10MB5516.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:608;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i/BP5zonFBC+RW0Z7TFS4F3OHo5FNBCkstTEmAWRdwz+8sn9OTdOlGag22+nzWfMUwQhWdr8DfiCXOuPjddN9g2oR8g7Fo1eLddrYssqfnfxWkmjN4b6mO/0ojHzvNAZDEfAj+AxWk/8BBjLifrZvUzJ8UCmzCpVEpJIfcC9f/WWzFgLKW0TeslQ2bgABPMSxubmpcsavvukk7VcAPikC3295UlcJ74QcEEVAnRvsRDB3GsR8AQjSPmG1mHKs0YRv4fmxEWaGT3qxXWW+3xHKCJW0dbf7naD1UP92qBXXRRHys9AqaoEnVCmE35/XCqjR60kFh3z9mNDQZaolc0/81zpn6ROaz77sO93csdCqkJ0Lj0+Njs6XDJU3UmH3TMnsyEtQV934HdWJXI/Dxog9ByuaLLwH6QLePlN296NgFMPnOxZwvfYe6e8DphRUg2oUoeU84ufIA3mxhzvSdkm+e7RyzFXupPJ4H0BYPlw6MYFxtsMzFXVdvjCezgcIi4rANWMmvnw6BaFMK82aXg6nBSy20BW2FvqFXsiMoV7rHsO3bGbet3Q65RbebCDhBlmAzASfzWAtETsoFjQpEEZwrYQUl6WjJ1I9AqviLLh2v/nFfVy9ky+zmfeQJnxPUroiJOXN+12eZhF2FyUrNBQIsclwxtwZSdmDjYpt4BQe4d2xp3stWVBrsCPRlTVn6idu/jLeTqjAR5PZAPXvaMNXcWhgQ12a9QeDDyNouxc40erpCsrVjnhOTzRUChreOVXu8APnFBsvhVOzHxBHXyq5eOlCeS0sVRXf4/l5ySzeJo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(7416002)(86362001)(54906003)(316002)(6666004)(508600001)(8936002)(66556008)(956004)(66476007)(52116002)(6916009)(4744005)(66946007)(8676002)(36916002)(55016002)(7696005)(4326008)(83380400001)(15650500001)(38100700002)(38350700002)(966005)(26005)(186003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+TP+Nemf/rhm+KBjh/7nbFAY4iABvMLpxOhe7+Kaf9k33VaaHGRKZ42meBKt?=
 =?us-ascii?Q?TJeW2nBAaTopxaaoQde9OzQURaOfxt9RHeh0xEJhcMmKCalntM4ASCgsVrQZ?=
 =?us-ascii?Q?vJFoWJlE9JRQmUNesz+F1XPAbrQebJs5yZqxieH/NkLS+YG8LrbgsEGBVP9o?=
 =?us-ascii?Q?Snafr5y9SP197n489v4qnuY05MeqI3T1fOiyo7O8fVwqgB9fj4eahlSuygn8?=
 =?us-ascii?Q?SZn+ZltlELwomo5qnflAkWmt0EYd+EyYX0S175FpHST/z4aChWCku0eLA2AE?=
 =?us-ascii?Q?63Wkc9kInpKsH+zDY8D3Bm1Y89zIF2trYHKFpugelmkKjovGaGmbKXkSaunc?=
 =?us-ascii?Q?b2AQt+dkWQODs1TLHBynCwkW3OkAIPRTWJGXd8PZdmdHxdD4H7kmDKOMkvhh?=
 =?us-ascii?Q?UtHoS8IreenMW6K/OluafuuOHylrHYw4ndDJIEUdnjHo8rKHDq2veCE6nP11?=
 =?us-ascii?Q?8bSSdBGmjluLlA1bqmAiALtlV5PqgCaMc0h/0B886ftA/W3o7v1ISyKD9JPv?=
 =?us-ascii?Q?0au5aw4xWiVPPwI7qYxP61dUsveuxUuJKtaugeMSD0jNyc6FdRTYEXzh2qJU?=
 =?us-ascii?Q?GmHvhj4QO4L+WOHfpT3gPsrFJsUo4EsQxDs7xumo23yIUmJbVRAnqpNG7gWT?=
 =?us-ascii?Q?KC3yEXTxPAd5eTmaCm5XNgqQl5afrrhkytyeh5w+Q1qL/Ox/NHDPQIX6UzgH?=
 =?us-ascii?Q?pgddnNU1w4qj0b7WuQ3oEXjSlf4vL7hNiJHP9K0oWX+Zx6DhVCv2mSdATTxD?=
 =?us-ascii?Q?jQ30Thk3Ie8zKJvW4zn6hajnfgGR48ouUl43qpYrRg6B649926RNITXFBgxL?=
 =?us-ascii?Q?RCPTsvlTCpxWBCs2WO72WKR+WX/SxLZpIi89QDTNZ/lN1e1RuBDteyzrIXqb?=
 =?us-ascii?Q?48x1RICJb3/O+NEFs/Q1NvwKebDKtx6YevY16iyQUiM5GvYaCdLWnp3268KB?=
 =?us-ascii?Q?eucjbvYnDPF9P8Y81do+EWNyrzoVZ0FphRAqaAaRqytpiGA27PJQHBM6FDtq?=
 =?us-ascii?Q?TGfLcfmZM8kHs1fCbWQ8njwwHDBDSyCSxI/kB/CVtzPRthQ7Dr0GHXoNNVdA?=
 =?us-ascii?Q?qahB2A6hKicaJXxms8hmeXNS5rcHAH4rDh5e0oHVwKVnNxn+B7N8t5JeMotd?=
 =?us-ascii?Q?1U2mi98rx6ERTEhmc5U4Wu1OiklUfPXIS58lUL27BLoaQCVoM+qwQC7VU4Ve?=
 =?us-ascii?Q?IWo1aa9kBRKPI9KO1BSC37pN8+KRz/+Qe4t92Kzk6a05rfEhcZGUowtVt+uk?=
 =?us-ascii?Q?BgPqn126UhqI2prEC5tFXlFwIdqBlM+uRtE3xc7M3j7fJHcD/8fiY/C1tsia?=
 =?us-ascii?Q?JeRlK8VMLVOb5GAYjPEheSMW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d3cd530-8106-428b-85e3-08d966acb440
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 03:10:19.4987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MPFryRx1OVudzdZpMt+ado/3UG1R+zuM7P2ASUaKSRsCzUl1PuSpJQ+3FfxNMRO6wJ61oARVOLguNAaRnl00Z3gTHlunsMjF1M1O77s9VjY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5516
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240018
X-Proofpoint-ORIG-GUID: p4RfKNQeE-c0_TFPdLT0Z7qQbgFDsign
X-Proofpoint-GUID: p4RfKNQeE-c0_TFPdLT0Z7qQbgFDsign
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Kevin,

> This is v2 of https://lkml.org/lkml/2021/8/16/1497.
>
> These patches update the lkdtm crashpoints in the block layer that
> have been moved or removed.  In response to feedback, I've renamed the
> SCSI_DISPATCH_CMD crashpoint to SCSI_QUEUE_RQ to correspond to the new
> function that it hooks into. I have also added a commit to remove
> IDE_CORE_CP.

These look good to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
