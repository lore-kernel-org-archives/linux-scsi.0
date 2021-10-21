Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A94C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:08:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79352611CB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhJUDK4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:10:56 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:27758 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230272AbhJUDKz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:10:55 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L1JxAC025798;
        Thu, 21 Oct 2021 03:08:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=jnhFskosjwpv/2rdrEAYyPbc6iT9u72Kh0qWpVDuCl8=;
 b=REvsQE5ajO6uS1KUFDoPXgirsWQZvNTGf1j/ELcuGFnzLx2NRVNqV8OF82F7854kCJrb
 7CJvYhugrVHrfjhUM299/jNEjho6YitaYKjZOair3ZEXwhNYPk1PBlHtUb/aWBD3dmqV
 r1YxsEcRej4WEyQYaaWtszz8o6igoQBijzyZR3Y/sYPuVWkdZe/jHavPYOzshd9W7qtH
 PhEoQxPAF+8FqgSwF3W3fwcsXQaqovFOY3m5e94ZQrN07VVcoKw2G+HdNdm8tBRGX3zS
 WuesIDJFcL+ohXVydZvXLVk7VXdH07m28b92oUQmRBsIiSyxOx/AUd1J9BT2kvpDRfbC gg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btrfm24xe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:08:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L2pDxw060420;
        Thu, 21 Oct 2021 03:08:33 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by aserp3020.oracle.com with ESMTP id 3bqpj820t1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:08:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYA6zo4UyM8tUPxvnssr1s8dv+RW+ZQVgIcdb2QXyp6FQjQBzEhJVmiILXVnuIYO7jXl/4ukbb7YZkIlxIrZAngLQXtWL3g2Hu0tJ64WpBnwRuqz4lTFCHgo65PGaqpM75ia7fVAfVtiLlvS5uiLz6oWGxz/h9cKrt/cP6rM2Ml0tiNPyMFI2K8hBxor0DipCS+9+jcKuh3yniVITKxHaSmNFi6+4z4j6RTOR2nHVmWXsDWAtdnh3jHPLlzt8BZuFYWtjRrS3r9cnGJjEaU5sjcgd0L3PDwdIHoJYYHpDzARuS+EtjRpgI1Sa3FGuEaZq72JfNv30O+J5TbPT7S0Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jnhFskosjwpv/2rdrEAYyPbc6iT9u72Kh0qWpVDuCl8=;
 b=Ac8Q01CpwSSu0O5dFJA4Dci+lT/B6XVhGpCRY1x6o3fhBoGVoWlZxnd9xguZDh343uUL7bBn+dodtgml1ofNh9XtCWURFBf7luYYuHwdZ/5OtZmA3lvAlWMLaK8idIEMT9xqdOyobp9dxdb3K1Vdn0TWL2Qx9/hi8B00LGI1+nDI5uvvwdzk36MadTUkcRgb4/O/MKWgudV9TgZrIZ0Vik1ue6rFwVKUggudkuZK8BbYFsc/+Sq7Wka2+T0+M96e4ueHiDMdtfF+K7u9fVBV5iA96PhSUjHIyxUcqM1F73ZtZa/pVXU8SaFoCd0k0D0u/l4uJqZzuwIcy6wHPEq8cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jnhFskosjwpv/2rdrEAYyPbc6iT9u72Kh0qWpVDuCl8=;
 b=gPMh2kwfgxDB3lDl/hcoNomeimw+FDu9ebOj6Cejv5lClFkz4g4qP/NCaSD+pEXXDsKbeonw7SNbUACNKmeVBiZs1eN9Jr9Mc+9xDSH4VEXOyLgdgL3a0HubLTwnrOIYtklbPxCjNe0pR/vF9BCGbssozxLVtcIjRORuoCha844=
Authentication-Results: stackframe.org; dkim=none (message not signed)
 header.d=none;stackframe.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4583.namprd10.prod.outlook.com (2603:10b6:510:43::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Thu, 21 Oct
 2021 03:08:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4628.018; Thu, 21 Oct 2021
 03:08:32 +0000
To:     Sven Schnelle <svens@stackframe.org>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        Helge Deller <deller@gmx.de>
Subject: Re: [PATCH] mpt3sas: add NULL check in _base_fault_reset_work()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r4f84er.fsf@ca-mkp.ca.oracle.com>
References: <20211019191208.6546-1-svens@stackframe.org>
Date:   Wed, 20 Oct 2021 23:08:29 -0400
In-Reply-To: <20211019191208.6546-1-svens@stackframe.org> (Sven Schnelle's
        message of "Tue, 19 Oct 2021 21:12:08 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR01CA0029.prod.exchangelabs.com (2603:10b6:805:b6::42)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.45) by SN6PR01CA0029.prod.exchangelabs.com (2603:10b6:805:b6::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend Transport; Thu, 21 Oct 2021 03:08:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7133dad9-59f3-4bf0-ca14-08d994401017
X-MS-TrafficTypeDiagnostic: PH0PR10MB4583:
X-Microsoft-Antispam-PRVS: <PH0PR10MB4583D28126D52549E8DE0DA68EBF9@PH0PR10MB4583.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tsu5Lfity6JZ30tMwHg1bm2ZAkNDk/klrBwbir6RkTgpXRMmrepRLPVfQhduNjx89IAVMAVEtLcI08a1ZlBohGTKEQMaWUoeBoarT49JaWrYZafqylbcnspo131t67xzdJxDOuAiflA3vIMnJV5NNcQERZZEvpIY0ztlA2RCTgezKFSS85wjyXeVB9F+mNo79os0zID9GS7TYIvEyemYl7BAa+zXF86zYvKmBMT55ZgUmIEro/GZMBDViFuUQzvIt5KQx7Jfhm/3LHdOiYkR8RX3tR6Pp7TJdcSt8uqm5HSBUaIRnTrY5BwQkbEECC3J+i+37/RuHrlUTRQqeFi7xGZuUAIZ/WZj9FGyDRtF49N5R96COc0/0Rg4UU1gbVY32Y3UXmT3GrNWFmqY/XmCauB0Nb9h48P3d7F9a4cKk8MUPnVy4CprXBYoKoalrtrVFY2A1VN+2vsmUaw4l4yMJWRDvz8JmHAHpHzxviIHxhd8YATnWoUtWVMfWUExzq4KG5S3i6pRArEqfwflPOW7V2sIts1k/0Hgw4TESsGnWbmhFgwPcGl6jlcW7BhFjw4Hn14pJ486n7iGumB9BFqpWzXCeUBue9RNYWsYHxONg5uWuSS0OGNWpfTd/wZGhhnJuji0T6V3G0nKcwbcGxLKsuSrML3zq4+ry5WUnR+YZ11mXpLOL7cRbEgiaes+AMRSbyXEEsGnSlpMj8zTLsk0GvNzOgUZsPbA6o4cstHA0FI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36916002)(956004)(7696005)(55016002)(52116002)(66556008)(2906002)(6916009)(66946007)(66476007)(86362001)(4744005)(5660300002)(4326008)(38350700002)(186003)(8676002)(26005)(38100700002)(316002)(8936002)(54906003)(508600001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?41n7bt/C8Cp4n/+l7LACbXjMbv34d8grLyfLN4rW+AEnJbzMEnq/HO7grnmR?=
 =?us-ascii?Q?KZ6xfT6gQ7dxhthMQ/KQ8K01+oyvVcabXXXTDzf6z6zAfacu80MYNwwzz8Tj?=
 =?us-ascii?Q?dm7X+PRxWR7DJ6HQjYXE2kY/7Jo/HHxfjpaPBPjbV71erXlicf0oiyb+GaFX?=
 =?us-ascii?Q?9jGMAFT+l3dyM0iz/9HT0cuHmqrDD7KlSBeyH4uM9rg3gFzBcr2cCkTUmog6?=
 =?us-ascii?Q?XZk+K7nqZ0FNDG2jIj5GKZlkXlKFSXiwLp76PVP0bpvCeiBDZn/WBnS/1d9l?=
 =?us-ascii?Q?Lv0ad6iya1WDjP7L4O/pnDAHSF1s1P6N2Mqz1mNwvDmrFJVK5nMDpC8Pg+my?=
 =?us-ascii?Q?Bmew+z0WvAn7CZGzREpRBBew+z+G4QWvLXlQ25iqMp9ZkS5rrEKNxGVDjeI4?=
 =?us-ascii?Q?hILxpWG4+p1uSyKZXtACDkLmvPVlwQF9Fn71i+y6BjQM2P3f4DISFfyQLbwu?=
 =?us-ascii?Q?GUc3E35xULTmNcNZOoZpWrRoKgoJs4Z3AS0tTEQCfaA+CmdoAPbRj2WDytsa?=
 =?us-ascii?Q?PWhXPlF2+pFEJjVgSnkvUWDglrXTOGT8f3CMRmRPRRJUKbvVj1CXhdjn7SgL?=
 =?us-ascii?Q?fIEr6wduquRM2VTx30FtWvVGWD7FHr75PqQTWEQ8p2yy2SIxI1BFPPXoh/jx?=
 =?us-ascii?Q?v0HKc/7HIGnRo7S5pgYU+PgZuBDlB8PmkZFegG8F+JTzMJfN0etnOdqDcyRC?=
 =?us-ascii?Q?yZdUAPJPMj8FQDmRbj2IOjRq+VHQ43gOtvLgN3P7lrQgbpFAmXPt0GZ4p7EL?=
 =?us-ascii?Q?ekko2aqmmr8N1bSQKyv85EzamtdQQxe0uWrmq+9K6V2xNRTvoxlW7fw9Hy8B?=
 =?us-ascii?Q?IemEPmOOrzjAD0R1Rr1AwONOMz08u/d+fFtdNyS4nmQbyhgiGEa/X3V3ZGYd?=
 =?us-ascii?Q?BCDA7G7pccPsbWuPspNW5KaWI57yi2vI/PCPdImKANy+OLwTlv+m1Xeaf7jA?=
 =?us-ascii?Q?xkCf1WrLpgKHKv+uS/EHaNtCsqG7SIO5m+hVSMOtblMfdHnubyniC7xGA28i?=
 =?us-ascii?Q?DRZMk8hKj1vqdZXHVC28sD8kJEXn1cHSQFGsJuUtKOODkVynb/KkQKkug/LO?=
 =?us-ascii?Q?BLyv9n6RsSMY4t4ezKO1IQPgIXjIVvm8Cw9/qSWlDtEkQGKdJgYIiJhs7SGE?=
 =?us-ascii?Q?tVC6gbhtE6Y42ZKxOKnsZ0CKdomygw0d8nfFVHlEsPaV54keabg09Dn9vL1g?=
 =?us-ascii?Q?yOjjoPpHmZ+k8TK6Gyqp9o6AZcFB/wXsyXsNHdXnJosGkpCiPnTVmYfHDkew?=
 =?us-ascii?Q?m9yxZXF4KuxVvKkGbGp2rwyXEHA5SJiPJNLatJaa5cJZIFUDAV+Si/zsrQAm?=
 =?us-ascii?Q?kODUXD1phiV7ARjoAR9TJ4dgfRBUUcEsx/UguurQh6LXa7s6sDDc5Y2cyJAC?=
 =?us-ascii?Q?S725VXizr6A9KYUEeOocuCssY/rarXc0CfY14xpWqV0IJlXS0jJIYJjTtmnm?=
 =?us-ascii?Q?YFS3XWwrZPe4VvP82yutdbBn8obo8K9v?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7133dad9-59f3-4bf0-ca14-08d994401017
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2021 03:08:32.0578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: martin.petersen@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4583
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=951 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210011
X-Proofpoint-GUID: dbQvhxFNqGF3DnvwCo_ric3Ez80qIkxf
X-Proofpoint-ORIG-GUID: dbQvhxFNqGF3DnvwCo_ric3Ez80qIkxf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sven,

> My HP C8000 (an PA-RISC based system) crashed with an HPMC. That
> triggered the HPMC handler in the kernel, and i got a crash in
> _base_fault_reset_work() from mpt3sas. It looks like this function
> calls ioc->schedule_dead_ioc_flush_running_cmds() without checking
> whether there's actually a function set, so it dereferences a NULL
> pointer on that system. The c8000 actually uses the mptspi driver
> instead of mpt3sas which doesn't seem to set this handler.

I'm not sure how you end up in the mpt3sas driver if your system uses
mptspi!?

Can you please send us the HPMC and the output of lspci?

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
