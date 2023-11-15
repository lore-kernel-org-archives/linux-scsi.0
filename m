Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B72C2BB3F
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Nov 2023 15:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbjKOPwo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Nov 2023 10:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbjKOPwX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2023 10:52:23 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9B026B5
        for <linux-scsi@vger.kernel.org>; Wed, 15 Nov 2023 07:51:39 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AFFd2eh022018;
        Wed, 15 Nov 2023 15:51:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=ERioMimqVrnPTf7IAqyridk50/KLjmXcdzCruaX0yHQ=;
 b=Z1AXRnyIkIF6oeBWmZwHogKDDlmDw05Ppij2QV3pJ9T+xUwxglakQtTgVTPFaLEIEDrB
 4GuqJY3Xaolsv1KB1N7laHTuqVYHwq61hBnlf6iaPf11nUkqtEtsjLzhVoJpzpu/djGS
 LJAvgp2/HnJHpTs7BORlaErl8iXw7yMNU+lMA0nFFeM8ekZuZzlQvSEDgjMmTp4pBlq7
 gT0GCiguNeP0V5xhCmEAJfbyX0BDzkqbp4HU4Vzyu0S0OEVvQDJgzKaJXU6wz6RBFYie
 VKFmE7rC9eEOxU/I5qsPmn5yOBl8PA43xVOh4hbDR+ik6nxGcDLLqFPmn21+uoOf+d1w lg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2qd8u20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Nov 2023 15:51:32 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AFFMGYV013195;
        Wed, 15 Nov 2023 15:51:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxq19deg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Nov 2023 15:51:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jXEImzennM+JQ+E6iw80xzlCp3O7zsd4Xkzm7ohfe5Te9Dome2m4LcE00v5+N0BGBNvRjuA2xrTTPSexCeAVIam9N/ijybBtvMKf1TSDiWfoWCqLAqY7bpZWek2yKxtDLWfsuu5HTs58bHFoZ8ahabLzORaiVhBzPPrb5u3eIWpNyeQlhKLDfqZdvNhbX53sXVkcceIp8YIE58pO+27Dp+CjdM7we4EWoZzA2iYsThcNjf0OuQ4GEHbcZNwzs6RhSMZ2eEpRZ2RxTDbfu2CC0T2UagcQdSAz60tzClHtRTlySolVhPWN/fgqE6qT3jMI5LCQ5DsHlgjB0OW4gr6CIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ERioMimqVrnPTf7IAqyridk50/KLjmXcdzCruaX0yHQ=;
 b=Mk37dwrSlZ9W+iGBsoTrN3YfQjXoxxui+ZAoRGJa2Nu6c5AzLYRL7x9dU4TscUBI26jRTRR0Q0yk+CuYWFcmqA+7dwft5k62UXsfH/csnHJZxHhyESh1/A0tR/kiLQsxtHNy7xfirNvReprd37BUPk9UYeqcp0GtIrAWsIXb+gZBZI6+hfPZIwIczABsoVJITKc2b/OtGtrMah7WW4Ref1E9UL6PV1fWcHM0ssYsjCnF9IecL3zCUlZTLk/xwLwOwF+zuzs0D6OAyvfWwcSyhQwmwL1apnEtEP04HMR03sq6cZceShR0fgb9+17TnKt0r9i4DwEzVAuhFzV0uJZRUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERioMimqVrnPTf7IAqyridk50/KLjmXcdzCruaX0yHQ=;
 b=ZFF+6VOj8mGUMOQkzTIjTcWAbcwhGF8jX3L+HvcluJSIamUha5TdZmtRu5YXitDgYssHKBqglRXMSqiC/W6gvJc/oPT2UEXWX+692cJB0t975YlBdDHnyF6OeLqeRzBJqmSrEuCuwU/lA1MU0Rk74WLyJ2V0fRrMaAJ8JiAwwiE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY8PR10MB6561.namprd10.prod.outlook.com (2603:10b6:930:5b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.20; Wed, 15 Nov
 2023 15:51:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::abe0:e274:435c:5660]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::abe0:e274:435c:5660%4]) with mapi id 15.20.6977.018; Wed, 15 Nov 2023
 15:51:29 +0000
To:     Tomas Henzl <thenzl@redhat.com>
Cc:     linux-scsi@vger.kernel.org, sreekanth.reddy@broadcom.com,
        ranjan.kumar@broadcom.com, sathya.prakash@broadcom.com
Subject: Re: [PATCH v2] mpt3sas: suppress a warning in debug kernel
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1cywb10ct.fsf@ca-mkp.ca.oracle.com>
References: <20231019153706.7967-1-thenzl@redhat.com>
Date:   Wed, 15 Nov 2023 10:51:27 -0500
In-Reply-To: <20231019153706.7967-1-thenzl@redhat.com> (Tomas Henzl's message
        of "Thu, 19 Oct 2023 17:37:06 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0053.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY8PR10MB6561:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b4d4898-6e40-4b11-dacf-08dbe5f2bb90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wrwONHNyP4quSoPKeQjocNcbvTDOxi2GlfDmxICaLFJQopUQzkIME7IOaudj7hz9tmpwr5j8SUSS7rDpAlfbzbC4x83NbUNcyH4y9iSp37cIKQDyxDJebLqdyDe+YAuroo6nxZmLz0hvUZkzGcr1F/TXORNUAIPqKKtywaSyPJjy5XMs3Fyffj0Ijgcyn4stkpHDfCO6mpn7MXU3+9MTBnuDQqkr592AvoUxVyMbV7/+gEVDyxAhrvwJ47ZyC9eIvzQk0pdVWDTtD7jLWDsMQ0koyEeIS8XfwODgXdOx2QoQ1ufoT7ur0Q1V19rIL4idOJlwFhhccueTwqhhebl46ZwOYjOzHMr8W2bB42zfD7mS8sCR+C7qEK+aRugyEV6+msjXWL2MW0/ZjRc9xFgZcj2uwRnac33Cy6bOwJmkgD+8D1yZNx4hTD3he+hOqSSXdJofeqyhXnHts1OXjb9gq21GuXePEdhoS3sLs+zP7uXc/eC4pLvMnXgTP6h1lMyftjvdXG7wOhqdgTa60KLzoLIe1kM8Tero793weXHsNagMo40LTmL11a451O2eEJrt6osJxl3j1G29efcWhLjPxm1Eu+AzrNWF93VL4oDwtF7z0EY9bDve1QAbnWWkaWA/F7/x7gCvE2NA+1D9YdOOmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(346002)(396003)(376002)(230273577357003)(230173577357003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(38100700002)(83380400001)(66946007)(8676002)(8936002)(4326008)(66476007)(4744005)(66556008)(41300700001)(26005)(6512007)(6506007)(36916002)(478600001)(6486002)(2906002)(6916009)(316002)(5660300002)(86362001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9amw7+Oyb3C1elrq3NqmXM3LtJs7Up0iDcxWL4bxw+HfIWVMCbIcnzZXeymU?=
 =?us-ascii?Q?HnGPqdiS+j0GPxNErI9OgAElD3ZfFeZcGdf8FnlIqhx4CivyRECwNgO+KUYP?=
 =?us-ascii?Q?Jp2BotDC6l8g2Pv8fjDhq5aFSNKu5xRArIfR5+h5yUGtF9jh+AmzGyXXdcBl?=
 =?us-ascii?Q?JnwlovQv9BulzBrI+GDwjRjWsBWKr3HNrpuamQkSBK7hYgaPbkr3b0dJpD7z?=
 =?us-ascii?Q?QPPBqfYO6QoV0RU1y6tqknezVMP/axKUMrV8iIKrmDEoDk8awv/6i4Nr3b8q?=
 =?us-ascii?Q?HpcE7YCQAnXyxpC05j3gKgA6PFkxZg+eKy7w/fH3ipeHiKJ3pEATdMK9E60i?=
 =?us-ascii?Q?7d+KcbJ8Fx3yP6VphdRjkpzQuDpgttA0QM/9x+7FQPL6zcmizmhrHw2blspV?=
 =?us-ascii?Q?dwzxvEvRTbp6CmgJ85U2jGM1l/SwKxg4fkNPlnNfEIroaWykHbqYQjEhq4He?=
 =?us-ascii?Q?YtHUPl3qPIqzgk8XIEqIQM/M26M8y2hm0yNDOyJwsMI8AXYjfFND1rRP2HPW?=
 =?us-ascii?Q?cD/zEydoQ4ni2pSqzaUnvRkLEd2ko0ifvBfPkCSNKO/NjkpGBMIfGe2+RGLc?=
 =?us-ascii?Q?WpAvgR3cxrrNO7akYne16p6q8BnNHOjUAWJGeSLrsVbjEu6Qn5EqpEaTvArF?=
 =?us-ascii?Q?zYSDa5Pic/KVHBwFMT2IHiShROpWpZ0qbpMbhz+/U2L0zcGzDlMl3jtqhw0y?=
 =?us-ascii?Q?GPKyt4iPnX9dld49moW4FaL3si5WV5OnjUw8WgmNBKfp6lZ9j6kHcPpM84mY?=
 =?us-ascii?Q?WwQBrgYDA0p6kAsJyYYZI6xC5nEdj5RItOgBbQZCwAFZ7rHs+LoXLaFjmRN7?=
 =?us-ascii?Q?BqQhr6tzktAWA6oTDCbDp3Sd/uAlha7dfKFRt+Yi3gtM/MuobsbdJhzU3WwO?=
 =?us-ascii?Q?9rRi+AklgJuOD/c17rIw9vXwNjtIGaMBroSVN1ARwdYq8FL43VqWC3G15COI?=
 =?us-ascii?Q?YoVcHfrqF5sCIOQv8TPDe2Yiur0WHI6AKxXNEIcKaKgjRpqbeLa8GbvGtgjv?=
 =?us-ascii?Q?/OxPfb+I83kHQoNSLK3hcBpyyEc4zKw3cO284MG5wnhN9zhdRQFonswpHkWD?=
 =?us-ascii?Q?eL1h3Cwzc8AS6Vnm1btkkFrdqqxLhTrubL8nl7EdHk4U53BAUdmDNsiJ1vnH?=
 =?us-ascii?Q?QbQx0p4qs1GOEDzUTqGWn0W3w9rQp1em+6fWVaSBaKu0k+E+no2Ks5Hg3FaB?=
 =?us-ascii?Q?9Jp0Wvp0Dj9Wf6NIK143CK3pANb5t06RP5b6x65Z59z98GWzEVNfSVfo9hdx?=
 =?us-ascii?Q?tClR4txKc6YePfy5ZFWqOf5pEFt7sCl7P67q0NyopAd1IxBh+Q+/P7TtaFG6?=
 =?us-ascii?Q?pYzdjKacqEjwZCAZTv3oL1fkFNP3qd+GQ9ERhKNDx7ohXyicJKi3fAS/hd/v?=
 =?us-ascii?Q?cFM09fyGQuqdRjM+ixi4JQATwOQdkJ7leYAJQ57dfwR1NujjerLHfc+TLzPq?=
 =?us-ascii?Q?qyh5zC6pWYjx/VAS673+LoIIxY9QSX1p7bmNZC5KY/YHNFEeINNIlZLG6iCB?=
 =?us-ascii?Q?1czg5d5TUQgA7oei8GNncxIbpqizgOjbhqmK/BE4IXCTK/bqxzZpodWDIYmd?=
 =?us-ascii?Q?NIg6hoMqAiyZpg6lQSeKfh5jas28Qe4m09GTGyarWCeQhbh4+OtSUUL+lwFT?=
 =?us-ascii?Q?kw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 2wlPGR3gKY0Rus7Mey1qaxt21JQHKjqvjR0YArOlU/TJgLR2b69LE6JBT54tmcs8rtZCTnLrS7M8YNECjTIL3lLhXV7DS/Mn1kP7CSlQoQpK6DpsyuEsrLOdW9i6MFVBqrDghbHkeRlC1rfUurgscrWH5h5ormZfh2QEKPN9hLnvdl27fvI8Dzm++DzcPxmJLkGMw8LYSlr2fdwxpzikfusT96yWr3hRpmsAag3uZ4F34H92pnK82KMMKs1ORRU98oD3YJavQjlfGWSfLQWuTvV/NFnf934HMdcMk8Dfng83rDoHd32a8q7hmA2FeiH+9sQ9zMP4cJCiTjqB41RDvF4uFA5CMBp59/McyBOTMKBQwuoNLnoc4AFfEcavXk5SZXfkOUkV7FuBAr7fGozduikQHUejleaTJL01bQ0XZqXDt4ZGIew7Yn17TM/vrtNY3l5dgsEsfZJOREbpYmw+so/63maSoo5/xBkp5npePfa6+ELo7jJ+DePSE4BH1wMqRRbEalYGq235fAsasexz6I/lHixXA5vY6o8cLys0elL+oXSkQhVG/lQBS7d+16d7UBqidwHHaHV1oaoH9JUHyvtBeBc/ddgfxPCg6CPhGaIQtYMazbX9tcIbmYT4MHQejfzwA7ad6Rjuz/6hsqk1xvkJoxf/V7s+PA43Bp/ilx+iJXJMUL3dqCg+XK4/u/cWkEQFMEHviiswKVeTxa2J11HaclipZm+HD6w2MOJMMBbmlKbsmac5zP8eaETP3CtF/Zn+p9C60T+2MswtuDp4Y3JAvQP62DGdhKm6js/zsDjGCQxZCkAPmSawaCzCI9pXb6mx4bCHqvjwkvc8yWkVwA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b4d4898-6e40-4b11-dacf-08dbe5f2bb90
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2023 15:51:29.6307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F2sTbNaWufDCo8u7A3mNrxbJZKoa7iocfeOIJBjY/xuqmfqz17K9eCGglVf2GmuIY9E6Nt+mRz8HIOAPTtjXVxdi5qiHaVjQHLXoc9CXSng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6561
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-15_14,2023-11-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=889 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311150121
X-Proofpoint-ORIG-GUID: 52fyF3wI4_4ck0U3kHEghKwJRDbQPkTZ
X-Proofpoint-GUID: 52fyF3wI4_4ck0U3kHEghKwJRDbQPkTZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tomas,

> The mpt3sas_ctl_exit should be called after communication with the
> controller stops but in currently it may cause false warnings about
> not released memory. Fix it by leaving mpt3sas_ctl_exit handle misc
> driver release per driver and release DMA in mpt3sas_ctl_release per
> ioc.

Applied to 6.8/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
