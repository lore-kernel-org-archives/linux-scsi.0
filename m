Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F5D0C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 03:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA023613CD
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 03:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbhDVDEF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 23:04:05 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51418 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbhDVDEE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 23:04:04 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13M30Oxj078013;
        Thu, 22 Apr 2021 03:03:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=p/L+k5rtCSn9ci01tOKp6WxkU4ASpPkuC4Zk6NQKaXo=;
 b=e/o0XgJTTOHbFhCHswwlHRdnLuvHkuSVi3ewvF1vmodILPdCLb9Gu5hxipuhRVQ6RVHW
 0Vl9MspLPjkkrRVUiLKVbDXJ6z3C7csHXX4kM2Iw35XJAyX9nzDQw+uhghEeRflKIosa
 vFDxqGM1E2LaShtjLNt8L0Vh6H6YRmvJVKzFnM2BTe9dHcjcnVOOSTibtcck/Bs/kvFv
 Q8uZGvhFiW9RfLWQP03YVCRdgkmP4tOlN+Ij9vEBcHmEmITTSbtHixrFFzNxIBIUB37p
 cwHMs94uN7CGD+RXjiciUdNs2caW2IT/IIbEQmEA2/iaELWAczEjgLXB1Su9uXIESFVC 8g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37yn6cc2nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 03:03:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13M30tiB173968;
        Thu, 22 Apr 2021 03:03:24 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2054.outbound.protection.outlook.com [104.47.45.54])
        by userp3030.oracle.com with ESMTP id 3809m1h8qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 03:03:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kGA69K+IzEtuSBsuZEernbY+Cqq4NSWlbuDmQ7oc2IaEVPU6N2ApOoFykOoUJXNEpcdJyIOENkQZYlIiQRo6IWOPtHqZ8uSWj/jlfjVkwb6J7lgL/NJnvuMjM9GIZ5+CngetSF4SNr+zoV8tSRiS+1loNQ16XvevWFO+RJMizw6lg+n1PmbKCCAe8eQVM6OSxnZymoYN3ctIse11F+dneadIWyNzHamg5TlfwQlSAGzxRkIj0HeQQrS1yc2JEX52COF6oMaTMMNXsaJ5OENAykI8x8daB2JOGrmdD15X6U11u9C7L3ZoV+syeaMhP35vu9XHxpOyrXTJOmFu6QRN9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/L+k5rtCSn9ci01tOKp6WxkU4ASpPkuC4Zk6NQKaXo=;
 b=Rwp73in33igt3cwPdrQfAzDNJ312Aene3Rklxx2FqqzcZP17+CuilPloQZDcgzkqvetwT44cSrHT7pYRF1Eg1MZqyzu1CP5z4uxD4MXIUVtYxW1RIUr4v3gbp81Ykg416audwP80FXF16sSPTUPiNBh5lD++uzUFtWr4VNlnk6SK6Z0unZ1topwHM/4HOt/O9uZ+ioOVJCFUBDG4lnnLKrPAZZ1I/kV+CSRYPSoG+P0MyOSsNPlr+ldhKqYYRyyree3sJHGAkxBb4fULHKzmUoSourLCADd6I+jbxXihSYV/jBNSiVNsiI8ABRGuYz+uCu2db9TFjryE/5/3zwG/bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/L+k5rtCSn9ci01tOKp6WxkU4ASpPkuC4Zk6NQKaXo=;
 b=jX9i7/tBBVVkAfvm5h5BJc/8/4SiNnnyHptiuBsuSzi8gZ0AXv3Hh4RAjdHV5WrM3ITOEYFCRx+3+C8p9tKygvAdd9YmeBkIUlbpDzbUajaym/iT/qt3TvG1oJ4ascavmnvEZZzzqcUT4MNoJQjMNaVFw1FIwBu/exi+stuIj8U=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5418.namprd10.prod.outlook.com (2603:10b6:510:e5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 03:03:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 03:03:22 +0000
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3][next] scsi: aacraid: Replace one-element array with
 flexible-array member
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18s5bt42e.fsf@ca-mkp.ca.oracle.com>
References: <20210421185611.GA105224@embeddedor>
Date:   Wed, 21 Apr 2021 23:03:19 -0400
In-Reply-To: <20210421185611.GA105224@embeddedor> (Gustavo A. R. Silva's
        message of "Wed, 21 Apr 2021 13:56:11 -0500")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR05CA0052.namprd05.prod.outlook.com
 (2603:10b6:a03:74::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR05CA0052.namprd05.prod.outlook.com (2603:10b6:a03:74::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Thu, 22 Apr 2021 03:03:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d32c6d3a-30ed-4dab-3a50-08d9053b3041
X-MS-TrafficTypeDiagnostic: PH0PR10MB5418:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5418F2CCF55160315D5A1BCD8E469@PH0PR10MB5418.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G1OELx3U58hMwulgC/XKErz7LhYeetr5ity6+9usV6Xh6c1upc6ZsX/GCXeX3iDzLbGLdvsr2lj/v9yGT7zURByMUWxwYBw0XvRphOgibkgzOMgapQXi7bf0vAKVwztswIQznfIQm77p1aZUcVVica7zKB1ZmZZkTHx6Wmlh4FgLPN6XqlDqC1ws0D86CsmLA3HLEYW6XPhrp0oS2J+zCLKfJbYQSPZZMrCi6fuATOxlLi45Stt3liUNi/yXDZ9NniPRXFC4qJV+fXm2/UJsi5Wf/duS2/MULXhpbdZRnqA2EeLB9gvuB9elWuBuMa8ZPQNNwveE3iR2eCcWLxaLFaZhb+xcl2y/HDDvJYgeLxQDvUcJrKF8bvhfVWseUIUJs1ESePAB5gZNISJJ/WPDymwGH3ZDtr4YpOj6b83U4rlLpvZ8hL58OOg0Oy8eAotU5DriHVbckEIvojyaP7JiJVNprlk4rF6LMAbwBS0H1GKE9qS+J7rQEhguwa3Cvr6rRdrJRSovfnXdxXSWlL8xLDVrUoVHgNIU81arEoxedW3FBZC/hsIIOarWqQqRoSjCTWPV4+QnlDVjjZM1sXT+J6yXFMF4VaEwpmZbIhACB6gFescoQM33JbdLUvtE5uhHG9mrACgg+Eo1+11jq6Nb6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(136003)(346002)(396003)(5660300002)(7696005)(558084003)(83380400001)(86362001)(54906003)(6916009)(316002)(66476007)(55016002)(186003)(16526019)(66556008)(66946007)(8676002)(4326008)(38100700002)(38350700002)(478600001)(26005)(36916002)(8936002)(52116002)(2906002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/U0foCCqnM1Bbb9iAt4RlTbGgLWIdouPY9H+xhNiPpZG0aUiG0ZskBtqgvHg?=
 =?us-ascii?Q?EL89uDySMQfl+N8aD4r/mvcd2S3ML9ttJaeeph/wT83PAPg/MoGH9SKif/++?=
 =?us-ascii?Q?4kg78I15cE0m4RgMBew7p0jHsFrv6f9wrpDvuiCYrgEMz0acn5SAmrQyuudu?=
 =?us-ascii?Q?a5jYyvOnt/sw7km+g4gVLF+QA91TLka/vVPlgOlf0BCeiCsnVc8uX2ndU85W?=
 =?us-ascii?Q?Lg2ZrzNjncHrR2WzQ53xiIg6ef80WSnYQhnyP1eH3yCzaeNlzq2bokKCj6X2?=
 =?us-ascii?Q?gP0S/F38bd4K18PsONtwgei7flCEKy0U1gpRT+1lyCuYwJlhSWS50TDvO15S?=
 =?us-ascii?Q?9+apNOgeGpvcWngD6z+tp6u/scq+5rD3CQJ0H0k0ZSDuDIxOAePT2O8NMilI?=
 =?us-ascii?Q?QoTQ8Tahv8dMdGgjUuJ46fCORRJ57it2GteMuBlc235r7vUpSYJS+YdeXMnL?=
 =?us-ascii?Q?453mPtri0k163X/y1VCPls+hZkYBoMsHqtJ8uftOdbFgrPt3hvl9M4XDE1D4?=
 =?us-ascii?Q?lupW8jWXuUEWJqhek/hIs4MnUK91syEnCPjM+GDAGJnbR/nj6ZNrNY6wxuLG?=
 =?us-ascii?Q?1UAQnS6WCxWYJpQW/F25lF6DLYISdxWtqpFK9p2sPtP0/ifbkh+P6H5KVFgQ?=
 =?us-ascii?Q?RwMDYlXJbqeuwqwFqzWTPY7xeTHzoTPc2IG0rZ7WfVaw4CsRwvf/OnISWM67?=
 =?us-ascii?Q?vb9yT9nPis5s6iPnkMkdz0dCBEzKZ0P35ngwi0IgtKiVxU0t4E0wB9EtLvv5?=
 =?us-ascii?Q?rBEWE0bSGMRpDkm7U91WQWlNhmqpNHpl8IPjqH2lXQVp6nEr1EL+Z+4F1Fez?=
 =?us-ascii?Q?NQvIRfnsqUSjnZnemdaMRqTIZsfKTB0HjEqFnfYnzeLakUTJEzoZ/Ls6qcfU?=
 =?us-ascii?Q?7H2ss7Pu3fIf/+ZepVfZbRoUVej57S2zboVMvbj0ksanYYAE/TuNokCREnXV?=
 =?us-ascii?Q?tueS103KteF6RqtuOnPiZNe6XnK3p+23bJidy/6rpQ87mEWP3Aog2QfoPF6U?=
 =?us-ascii?Q?RR5B6omtAPShUuk22zKMDMRwzV4P+6mFjfUceP5jnw/q8IzTeY259lt5VrPo?=
 =?us-ascii?Q?IwQiQRS1ETme1G2h/AGb2EGHOoEWzAMlRHx7V6Vmyu5DrevpsLQInTWtXIrE?=
 =?us-ascii?Q?bJUV7DpO6quxNEBVQ5yehsNv9em7TeFW10uD6qkMKa7RxP67uuKI4hD9j1yH?=
 =?us-ascii?Q?E5Z8vz7WfXn/Y26bwdFW/+9Z676qRJ3t7ZjmmmG4RPMr7SIxcuLhrnasioyx?=
 =?us-ascii?Q?Yo6i4QHR/H2JWjOWSB1vdAUVK315L90HHztdRk09qZ0lEsRUfg4agTZ0+mde?=
 =?us-ascii?Q?djs43qQRzSEaxJa/Avy/26v6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d32c6d3a-30ed-4dab-3a50-08d9053b3041
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 03:03:22.1352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tLZdPCqAhabz5jbQiKzAEsUaeMDeg21wzrGUqA2qOppZghQKzQVag8PMFj9FiXmVkxmHXDBh9REbP/fYUPJHjKSmclIZhri+a2/IkTopTRs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5418
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=729 spamscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220025
X-Proofpoint-GUID: rkmdX2Q_yspxqGmQCbO9q_Si3_nnJY1e
X-Proofpoint-ORIG-GUID: rkmdX2Q_yspxqGmQCbO9q_Si3_nnJY1e
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 mlxlogscore=918 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Gustavo!

> Changes in v3:
>  - Use (nseg_new-1)*sizeof(struct sge_ieee1212) to calculate
>    size in call to memcpy() in order to avoid any confusion.

The amended memcpy() hunk appears to be missing from the v3 patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
