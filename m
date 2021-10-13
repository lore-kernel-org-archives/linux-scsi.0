Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0906C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 08:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0530610CB
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 08:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238554AbhJMI2P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 04:28:15 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:12816 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233015AbhJMI2O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Oct 2021 04:28:14 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19D70U40013092;
        Wed, 13 Oct 2021 08:26:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=RCVIoxbQ8VUzVjR2k+51IMmH/PFwgVZ8mMgImXXmLhs=;
 b=rutqxC1zgoZrrHQvnbdduLHk6BNWYzAWLhRAvQHCXbM+MgH76FpMpkeZynq18BLAW1at
 BzfAi4kqThqCSgWyJShc+Pn0kHoCY1uWXckS3acOhh5O6cgR4gYzY0OUNGm/VCb6n8Nr
 1VqtgnV6t9C0U4kz97T+u0qJ/8gtJBwibtv9Yl4TFHxQ0JAbnJ65M1YkMKjTMCj1kyHr
 5aHCyqkofPr24E0t7JDYJZ5ncmXUmo53FnVsQvEGx1db7k0xS2btK55eYML7hzGZtvLI
 AZsrKYR1cVzAij1cCEgiV1gC8PfGxF5IfsAMvWBUyQKekJiM8ziKEqZiX74qHRUQH3XH +g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbmta52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 08:26:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19D8KR01070555;
        Wed, 13 Oct 2021 08:26:03 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by aserp3030.oracle.com with ESMTP id 3bkyxt32gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 08:26:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=igqicnFUL3zBAmVTDxSSklWXbCdqFgANkGLao+CrLFoBYoMv1c4glYAJawS+tK79ea7Hu4586U6+myavinlhsn1LFq4EdD17rbn3q7LdKDw12VKH8E0GLhtieD5eJktStDztrslQJJ6J3IUmbt7OR0hNyxOoFty3SWwwCXtLDOUajdizTl5owZQrstpIbWujDOkurQin3iJCg31k4dI2z4k+6NdUaG1+ByXMKas6KBAfGjTcECpb2yKzzYH+Rlg2Dv0njxRUKVVOsjOtMVFkCcsLiHdsxX+HdvIckszAcPVbJYoluL7I8yJ87nxj0uiR41eqJq686ixgzGWL13lA0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RCVIoxbQ8VUzVjR2k+51IMmH/PFwgVZ8mMgImXXmLhs=;
 b=UVDK/Q6RVlKx1R5onbBljGSZfs1f4l9hj7F5vzvLkow6NdB/R+lgs0IdBJHrEWbO+k/rfLhZxoZxOElGLJTHctmNJCidNnP+zQAvCkFFLKItYmdk5ifDF8ttXXZY1bEod0Ad2Lz7+4GXtgdp95himLIBkSBEGBrrRcknhvuBSuLHzgziUm0UEJkQK+UAQuQ/YPwehsUjzeOkl35Miwzyf7V6xpqFCf7tuBPiq49eURdvljyiT9MJOrfhS+KUGXrQzEkMXUWsU+7m5pe9ZfMItNR+zwgTVZuZFevQN17rRqyYw59h+mZWvPD7eXqQ3PGgdZtOGFcy4cBmdgovJ5g/xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RCVIoxbQ8VUzVjR2k+51IMmH/PFwgVZ8mMgImXXmLhs=;
 b=wvS0QG3hTFTBZMGFTDVGP2CfeGT/nC3M1zhC6oJn5hOJ/fDFrvOst/q1fkBHydD217dRA0Z/MDVkQ42mXzfEP+M1s2tgmJPUDk8Y4oAYSEVBj4d7hUSWwIFhosumX8tBnhW51I80kr5PNu39RYUY0Cb33Fx2dVEy5LsSfFhH4BU=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4484.namprd10.prod.outlook.com
 (2603:10b6:303:90::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Wed, 13 Oct
 2021 08:26:00 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4587.027; Wed, 13 Oct 2021
 08:26:00 +0000
Date:   Wed, 13 Oct 2021 11:25:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        kernel-janitors@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH] scsi: mpi3mr: clean up mpi3mr_print_ioc_info()
Message-ID: <20211013082541.GH8429@kadam>
References: <20210916132605.GF25094@kili>
 <163407081305.28503.18198344074370197576.b4-ty@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163407081305.28503.18198344074370197576.b4-ty@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0002.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::7)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNAP275CA0002.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24 via Frontend Transport; Wed, 13 Oct 2021 08:25:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c137c00-0a5b-478f-95a3-08d98e23166b
X-MS-TrafficTypeDiagnostic: CO1PR10MB4484:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4484D02E0E440131E9BF39C68EB79@CO1PR10MB4484.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gdF3pVsfFsxq0EzGBmQE+t5MgtoJz6JjjKzaxrMjCLrXAeOY4Uj/9aQS+tAFMN8Z8aOkhKarL/Co0Pv7oUItedlJzv9NPIexc9gUQfsx38Dq3/Y/70Naus0zF5xQc7llet3IEpGOnWEX00ChmYoy5nPwc6lt/a/TXgmAkMixZza9zxqmatOK6TZRPlZSgEyZFJ4x8991f2ZA6jr0JornCQhGP2WwB6cm2SGWngn/z6r+bzg4viC0Jo2IZhyjFFeIotBQi8/7B6BzhGlXodoU+9tZeQAAzMoHRQ3WISm5fIEZw0+Eb/mC/VaPYW4aUrjcipmpdsY6daWauYTy7x4284EmqR8VuD8mf/Vt8BJV+/wETPX/DEB+0hekwqolgEXprfawsymh1al44fe1pmv1g8aBqhAQpflyGaELJmXGbBuVeqpDLVXeEznfXDMQsVE+cNhiFOZzpY92Coa8wsMauWPgSbwHPmgH1RzOkEp+gKq++n8UBvn3gzu9VsDQnrDLp1YUL10C9wOF2t0Fv5GRoCtdtsFAW+DS/FSOOiVUlVk0KbNn9qAGrNfXb1cXIwF4apqnHqaPpddO8LUWrKVr/FnJ8H2tlvWsBxAuvwJVA8ieDJPE15OgCbRAXKViSf+YxiN0bWw2G+/G05tyKhHueJVDAsu0IOckNCDNxXxv0wIGOobTLD6vor/nSLO6/nuhGFJdDMZBQS/G8P7Kni72UHeqYFg7ztxtqz5tU3qW3bVYV/QVd08vbtX6JiJca8OndD9bv4DyNnl210Tahsz4sSqXgJ8iZdwEVFOlsjq4Xv1oWBc4MU8wf+jjekRgIkuc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(66476007)(66946007)(9686003)(2906002)(6636002)(38350700002)(1076003)(38100700002)(86362001)(66556008)(966005)(55016002)(186003)(8936002)(26005)(508600001)(6666004)(33656002)(44832011)(6862004)(5660300002)(33716001)(6496006)(956004)(54906003)(9576002)(4326008)(52116002)(8676002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jFas33fUqzns9C17yT9FMG7q1+ZfS13+h9tw37B/ErWXyiEDwwNJ8JSw+KWm?=
 =?us-ascii?Q?CndEdUSxjrx78BftuSAcpfoK8YFvBtvlMxlUszBn83TcQOsI1TT6wmm0CxcS?=
 =?us-ascii?Q?gdYOHr+dsfquBo9TvJ048RPI3Tkxk78LN/ERRfuIESRSFH8GDYp3bgtQ4KoH?=
 =?us-ascii?Q?lxAxP8lQuHZhKje5lOP4mYyMgKlfcc4vsxxsoZucC28afse/SSqSvbccvoy1?=
 =?us-ascii?Q?7gkdeHyW+EmYX4DiElHF1waVRP5wuIuKZWb2VRdeENIEP6tEffhQEJej7Oah?=
 =?us-ascii?Q?b4ktsxHpXDd3nG/tPJ99pkuHg/cFZ8vMZM2EElU0phxLF9GDeiT/nYoQKC27?=
 =?us-ascii?Q?Wh6hhumb38IF0nO8USwC6S3dw30nYKLskRhsEzLcs6gbNzEuI5MsocQsDem8?=
 =?us-ascii?Q?54iHyYb1+fL4RuH6uSYFy2ZCPEbFO+czRtVjfxxIlTnb56vqDPWpy2PTioZp?=
 =?us-ascii?Q?QOFe6H72jaf2u/cSixCJULb/HS43ICkDlXPJPhUFetCH6S7NvkmmsacsMS2E?=
 =?us-ascii?Q?rwEpulN2PKYYDdtSpgV7AeSlPREq4aBWp0csXWV+mBq24JID2xk+f0vXsSCn?=
 =?us-ascii?Q?wUCH+mu11tvcgAgdJwXvGQ5LIoqqJcldNKfbg0aAO8fV2PHLMWHRt5iQQuaU?=
 =?us-ascii?Q?Rhr8KxDPOmucf76brZHKgL5VLt6DdEQP1EwOH+nhzYmw2MNlbY75Gm8dWgq5?=
 =?us-ascii?Q?HiFMi3JxBqr7MaF3uufvf/Suuoo7mddAyNxxFSXqfoyURY3HZMKBSuGh1tCn?=
 =?us-ascii?Q?dqJ9Yj3lPBHF0+kisgAn0dAkopUia3hB3+gt6wK1oCkyvU4doe0Fg2ZJ+7Hm?=
 =?us-ascii?Q?961IvJvyl3Eh2o/f4KI5O5dxUWD8XgfQ0VUxzp6H4Pst2aRgiB9/OcamMOs9?=
 =?us-ascii?Q?2EQWgkZz0eXpftVTxKz+njU4L5smNRb3HcP8bXDpUepTrySNGsdf66Z/q5Rt?=
 =?us-ascii?Q?iG0Z0onEBaWHpA8tutBsvFITqp1LFxppJrXBiV44WUjqgH5eghLcZ3CuU4Ph?=
 =?us-ascii?Q?2Wj0VJrYP19rtLHFSS2YmO9A2rBsJ0PC4Ymy4Aq9RXkz1nOA9frak8WJ92NT?=
 =?us-ascii?Q?5miTQafavUraM8+pvDzbJ+y0e0zdPAOOkiFM4mWufEtdiFGfO6DIPL+NP6ki?=
 =?us-ascii?Q?ipu/aGnuHnOJa1fbIaf9h1oUcFgANUkfxp6ZYKxMqTaFlDqX3lj6YzfKj9D7?=
 =?us-ascii?Q?4xta1KMYZGioJrqZtJvvQzFEC0+6CffuuT67zRrEbU5Y/WxkdPtz30h/lFfq?=
 =?us-ascii?Q?bXhvSicQRDVdPjp49PpoKGO6zSR6nfW4QWT9D97M9fhzQElawoY7imYWr2NM?=
 =?us-ascii?Q?6R7l4rWbMENn1X84Znv578fi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c137c00-0a5b-478f-95a3-08d98e23166b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 08:26:00.2863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lzvosAGaA80g/GcBdNiGdfC6hcJId31Mv0jAq4kgPHPy2NOdOHuBRkpH8+XDKK26m1JNjIWFyfrwkWPI2Kb9zVhJDBVr3bCt47AThuPNEzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4484
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=727 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110130056
X-Proofpoint-ORIG-GUID: niIOrehU-KWwHtdfLl2dUWKYrU6ameB7
X-Proofpoint-GUID: niIOrehU-KWwHtdfLl2dUWKYrU6ameB7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 12, 2021 at 04:35:08PM -0400, Martin K. Petersen wrote:
> On Thu, 16 Sep 2021 16:26:05 +0300, Dan Carpenter wrote:
> 
> > This function is more complicated than necessary.
> > 
> > If we change from scnprintf() to snprintf() that let's us remove the
> > if bytes_wrote < sizeof(protocol) checks.  Also we can use
> > bytes_wrote ? "," : "" to print the comma and remove the separate
> > if statement and the "is_string_nonempty" variable.
> > 
> > [...]
> 
> Applied to 5.16/scsi-queue, thanks!
> 
> [1/1] scsi: mpi3mr: clean up mpi3mr_print_ioc_info()
>       https://git.kernel.org/mkp/scsi/c/76a4f7cc5973

Martin, I'm really sorry.  I'm looking at this now and I'm so confused
what I was thinking.  Why would we change from scnprintf to snprintf?

I clearly intended to do the reverse change and move from snprintf() to
scnprintf().  But then the patch doesn't actually do that.  What the
heck???

This has already been applied.  I've can't believe I've messed up so
badly twice in a week.  :/

The patch doesn't introduce any bugs that weren't there in the original
but it's still horribly wrong.  I will send a fix that actually changes
it to scnprintf().

regards,
dan carpenter

