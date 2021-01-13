Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8735BC4332B
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 06:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 645F623120
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 06:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbhAMGJL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 01:09:11 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44264 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbhAMGJK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 01:09:10 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D665Rd162336;
        Wed, 13 Jan 2021 06:07:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=EQU98xn4cwwKBjPum85tihvSUj40NptwmG5Ha0Tsd68=;
 b=RhLrA/uASgYJ/KLzeEPfbwiTCZWqVNH5La555Wbpl7Bes+0eh2jhwecULUX3yRH9f714
 fBzogf4/3ujGyb2eda6StWiPreclKxtm0X14vrIBbQfXgiLbVrC2/YmNYxZ8AFeE2ldJ
 TueGVyONj+CGG4Ot7pHwH1zJQzmtvYuXo53I42e2xURqsC/Lsfx/DjjCNdX9niB00EsJ
 /t2JNWAFCXOLu5C+UZNfQP0hmJY8RL9O1pg1GNY8quD+3w+kSsI6jiUZkVwVQNDCK+U+
 zEtYpb/RHYbzA7GJ46qpLPAyx8n4SgSuecz5/rJ4ipvzw37PQxq05PeFM45m73oLRg1W gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 360kvk1nay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 06:07:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D665pw195476;
        Wed, 13 Jan 2021 06:07:47 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by aserp3030.oracle.com with ESMTP id 360kf01fga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 06:07:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7U96RLsMhyrB/RM4DB7cj3/1u3beeUlFs0RnuNa5w15d7+8dBj+Ah9xPTk2Ef+bvz+fR5plO3q6k1+xqoVZU1s77ihO2DqGfXk1cQIfz9XCfO3aGhcrogx4sWdIqrWtwW37wf1DOCjXRe8qYjz2oPJNJOQMhEDviTirBSt2MxRyi7M+yAGjhhlW3NhOMXNU8C4R8uvaotLf4bJ5RYOVLJ1+bKOIRXNqj70iLubMWfTey38/gI18cDzorAFLm3iuH8oEskcZjBOM6DOrBB/+k8HaLEiSBE87lnObEz/f+7WW6wUMgIX1s0DUr/A8fmNyGuDWxIE6S2iDnrrylhoqpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQU98xn4cwwKBjPum85tihvSUj40NptwmG5Ha0Tsd68=;
 b=ADJQ+xSHj9mxwLGxFvibgvGntAbe9rhnt64Mj6uZCi2gp2QLPcjjl9u+thfIbeMJ0S360hCl4FKVpYTHQzmpEhqKd+eGkwUbaCevRoWQjirD2whm0bz9AnG9jdJFx+Q5hdxwKzeT3Pa88yyt5pA6spYhz23Yv5bbicIZhdtoIGpGMJnvXeRYHwuwei9WdvnZSqxAWB7H1IEV+3BNTHQHh3phUC61Jd/lbkWEdBX5M9amHDHOwO/KG3S+u/KUOsUAdVgujeKwrcAgVuBJ/cORUeXUFyIezJafzDcvYXjHvhTaYgc6wC5G/FdlWxakibCPvzJ49P+9LTpkNj3+OtLlAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQU98xn4cwwKBjPum85tihvSUj40NptwmG5Ha0Tsd68=;
 b=Z1+l1HEoLigUejNMTCdOsTglxqHLZDBnuVWVHibm1ZgKZ7VHIZHGBO+biFltguojUCSmgPOOuwzx6gqYILyIA9Uy3kJ0PgodFSQ4Yh4PBgET8HQx+9Z1k6+jige4h0aKzOJt8xg3qB+PzP8dQYATETBsQd12ar0QdIhPc0dVXxs=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4567.namprd10.prod.outlook.com (2603:10b6:510:33::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 13 Jan
 2021 06:07:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.009; Wed, 13 Jan 2021
 06:07:44 +0000
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>,
        chenxiang <chenxiang66@hisilicon.com>
Subject: Re: About scsi device queue depth
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eeip1j4u.fsf@ca-mkp.ca.oracle.com>
References: <9ff894da-cf2c-9094-2690-1973cc57835a@huawei.com>
        <d784f7ff4f61a81c4c9df96decc6b7f6d884c616.camel@linux.ibm.com>
Date:   Wed, 13 Jan 2021 01:07:41 -0500
In-Reply-To: <d784f7ff4f61a81c4c9df96decc6b7f6d884c616.camel@linux.ibm.com>
        (James Bottomley's message of "Mon, 11 Jan 2021 08:40:31 -0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR10CA0028.namprd10.prod.outlook.com
 (2603:10b6:806:a7::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR10CA0028.namprd10.prod.outlook.com (2603:10b6:806:a7::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Wed, 13 Jan 2021 06:07:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c42bc92-db1b-4f11-1ef2-08d8b7898b23
X-MS-TrafficTypeDiagnostic: PH0PR10MB4567:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4567B6FC78080F534D149BFE8EA90@PH0PR10MB4567.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iwek/muYmS+E3tMW8fPKdWU5QJ5hXEFqmHlsZS2tqSn9L6oGVFScxwrPpX8mwS2Y/ruTIcS5FZUXMqKSSUkZl4nqOeXQ8BinsaWQmmeRlgtPk2G+9hkgOju9twai6Vs6c1lQuzZ4cY/mzrbfQZ4EEkbamkc8mU+Ubyul15S7HqO3ynewuCiqMT02a/XnsNWJ8FjidOlM19XgNiIuA8GrMaL8Bz+3dpB8jjEPz7eyiAeB4Pn+jrbv610tjwcwxWlrcon5FsS49ogdDbkWF/+mtufH+LIwH/nrIf+T1NsAzoYNhVDXNbbEAVSodo+TVoXOWP+fVy33SGfuFovXsssWFt5i/e6550vC1TUxcmgUbCCeHJik3a57+r/+e3MYrr0PZFgDD5yCQQ5q2ZOHcWikSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(366004)(136003)(376002)(396003)(346002)(2906002)(6916009)(55016002)(16526019)(4744005)(8676002)(36916002)(5660300002)(8936002)(66476007)(66556008)(52116002)(7696005)(86362001)(7416002)(186003)(54906003)(956004)(316002)(26005)(4326008)(66946007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SJ+JuOOzzFNw2PQYpzwBSflg2vg6IcFGtzzbNZKvk2DfUBVV41RCfMAo9SwP?=
 =?us-ascii?Q?Mdv3Sf51xEqMQca/NnhzxInqMC73hBEzfIN3HU9Wfxz7C8EuC/U+Mi0g7r1A?=
 =?us-ascii?Q?AhmQhfA8MtKy4Mwc+6yvzSwDMSSH5e8muMuNicWK0ANvVCPNPe64akyolk8e?=
 =?us-ascii?Q?jItWx4Gn4eAjSFFw+A8jnnXSEaEOjXr/U3sQVEQsJ4zvMQH9B3mDpJN2eY1T?=
 =?us-ascii?Q?LqWCOFGpgVMMkpVd7ORNDJDAToTa5A8rGDTi2Gf1kEAzh8X7vWiKkTgMmfRz?=
 =?us-ascii?Q?bmJKZUYlyS8PeEHIPrjNvl3FcEAI8GlaBNxEO/kZuKAK3kXQZzMDf+Fhx+IU?=
 =?us-ascii?Q?Qm81Le9EQ2LCeEPizfQ8uGsiynDmx1KdwyNe1zlNHUH39uTCjEnTpYKyETd3?=
 =?us-ascii?Q?k94KZzUBCS5DfnQjcV+0pQngzOtWuu7nyMYviDUx0jd6+2Xj2rNzSiUSJNIh?=
 =?us-ascii?Q?ROBWi9BJCKtTAErRHmdeoGia4NFlo5SprfwagbHDBFG7nXmzsiwjCSuhKd9s?=
 =?us-ascii?Q?ynqQMBSXyYzV0mhUkAF0kufCDdDukkqaXiiU41FvWPEUbxUSohXDKZ6UBEkX?=
 =?us-ascii?Q?gOgSdmCMOeWuQIMz5tXlUXv5TykJKtu+0FIhSFbLDG0NY1orqL4WUSt3V9yd?=
 =?us-ascii?Q?5nQ0o9CUPFNSXlAvjVhqSnSWhk1c4hhLe+4PJtzGhJU4rPWQhoXlwlC4wfuy?=
 =?us-ascii?Q?JFPnkb8hRWu/a5kuMseTOh8yVNnR9XvvQY8hHqWcAeBaxz/1AhbQal3dmdjM?=
 =?us-ascii?Q?H/pJ4HJhoJ5lbd7C44m8XPPrm4VMOhmj3cK+J0tyoEgq7CPIxJC9qzxx5ru9?=
 =?us-ascii?Q?PBG6orZqCoy0SpPyDpbH03RplQHkpvZZIQ6V32i6B+42nMnHaR2OUQqpQopC?=
 =?us-ascii?Q?alHTJZaTpZzrHjgeUmsVAJdjUn13F/o2S6bTewbozaS6feEm2TAZB50o9oL2?=
 =?us-ascii?Q?X7q2g0QM0ocz4aiofrOnrJaumsqXYKGn9MEy5nO7Fa0KAVdojJD+qJSS1NlW?=
 =?us-ascii?Q?T3S5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 06:07:44.5025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c42bc92-db1b-4f11-1ef2-08d8b7898b23
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a5q6eM0adUNUmrVzA4SH/BtCUd+gmntvyqFCPvvnGJxm5z3kCsc/9aA5Wbb9g2ucZAprMlaz/Sh0dS5LXGm5wPOrRCTBFf4OXvIMI72aNWE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4567
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1031 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130037
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> A co-operative device can help you find the optimal by returning
> QUEUE_FULL when it's fully occupied so we have a mechanism to track
> the queue full returns and change the depth interactively.

Many disk drives and SSDs only return QF/TSF when they are out of actual
command slots (so typically 255). There is often a watertight barrier
between the transport-specific command processing and the media
management code. Very sad.

So while the exponential backoff approach works great for disk arrays,
it's hit or miss with drives. And it's really hard to come up with a
good heuristic since the optimal queue depth is highly workload and
device-specific.

We had a few folks looking at managing write queue depth based on
completion latency a couple of years ago but it didn't come to fruition.

-- 
Martin K. Petersen	Oracle Linux Engineering
