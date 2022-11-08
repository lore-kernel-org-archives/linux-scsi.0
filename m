Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE13C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 03:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbiKHDDb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Nov 2022 22:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbiKHDDa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2022 22:03:30 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE1C2AD7
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2022 19:03:28 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A80OUm6027229;
        Tue, 8 Nov 2022 03:03:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=CD+XQQnFi9V7zTjtM4H8JFhdwsv7eLZ08QGG6MZmjQY=;
 b=t+tjsvaMDfH2dUveOP/3JSRvyPJK4CaEIfuGayfOmVsVfP6CrfNhIaS1447d0w6h06/o
 bsliNYUzsb6DlCIi2QxTHiHgl65yC/Q24jsesrcaXRk1nSbbL4+GmPWjgSlbuTVz6S8Y
 bpZSqETNG4yUgM/NJsoJ6cV2yF9zVk0FBIu+4EHynQ17AzvvIDvlQaAo8kaA/6XIs3fE
 mWh5EuZTdttnyG3ErcATIWfIhAYf4f6yZPAV20sEfzXN9oHUGgykyuiahNduW1merngS
 BQkhuO2tSOdzcTavlW4ZG8ggAKVaqHOnwqtqkqjsOYdHaXV4AVXKS9WL9h3BHkqB7tAi Qg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngrenu6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Nov 2022 03:03:18 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A82bcpf003365;
        Tue, 8 Nov 2022 03:03:18 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctbpbp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Nov 2022 03:03:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fJJTn5gEB1B3C2A6ngZToRV9fXc2kB+h6yL9TLSphhNAjVBaVJbMfmeB3NKq+koxxbXFQrfIK3hAJEzylKfiOaXpiGWLwG9SyZWPhLPE71xu0GfPdOM47tRyQHVyX6b5h54UqfLhix8/WM78Y6LeGkKeaL4fmjVNGRVtwY2OoBKmMXTeNeZxMzCwIIEM2Fn8zfJefXPQJXsxYDaJe2RmUmaMCsXBqzpqGf2lYjhUNeNYRZGmo9786ZNMKN2KnpeZE5moc+RcAMGFrkT+MwSO8Zm6XHPOA901q7qeWqOrXaoaEk0FHlFEThBiF7fVIh6hhX0GBE7wr/pHEuFe86mEAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CD+XQQnFi9V7zTjtM4H8JFhdwsv7eLZ08QGG6MZmjQY=;
 b=GueguTZoSTnorP7p3QoFdJO4r+Q+stOA5umZ84t7s23fQJ+8YDB16HRct/3CjqpqrNsyy08RaHOjomczBfVbPEPackxU7/2Iy6lQt3St8OFgPj+tlcVbuaa1SQRy8fvhdStETvfvNKZsS4vmxmtUDnK9lqLJUymp5mNxh9prKlmGnBhP3ceNstuTnp7ddkzWp71/i0pJchE1SSZSuOAz8JLeKq7MLPIMcvjwj1Zve5Dnu0rFH6Mj78cvkwmTXu3yTbmq2lxmbCMCN0pmnb0WUu4glgAk1v6KdJWeQf5zslgA/9DPmB62sr8B3FgHUx7j3vzbbdVVuWw/n0/AH5k7ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CD+XQQnFi9V7zTjtM4H8JFhdwsv7eLZ08QGG6MZmjQY=;
 b=M9l0mdQr8AQABFMIdKReW6AAKjhCv94fBFZJH93ffa00GdM5ThEXwLEoVgAPLOscXSbnjhX/GE8n9FptU/LcUFOhRpxHmqBTUazsen7JOSel4JBjNJ85yMvc+jEhv54GzcK2+8FMqJhOFPMLfszEHh8MxCK0p2QW1pIVoljSEkc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4710.namprd10.prod.outlook.com (2603:10b6:510:3e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 03:03:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f77e:1a1a:38b3:8ff1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f77e:1a1a:38b3:8ff1%9]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 03:03:16 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: Re: [PATCH v2] scsi: ufs: Introduce ufshcd_abort_all()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wn86jggo.fsf@ca-mkp.ca.oracle.com>
References: <20221031183433.2443554-1-bvanassche@acm.org>
Date:   Mon, 07 Nov 2022 22:03:13 -0500
In-Reply-To: <20221031183433.2443554-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Mon, 31 Oct 2022 11:34:21 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR01CA0031.prod.exchangelabs.com (2603:10b6:805:b6::44)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB4710:EE_
X-MS-Office365-Filtering-Correlation-Id: 3626df03-fe29-4253-7ca1-08dac135c7f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sPL90ysrl3ZsNyQQc9mJLRo9O/oLl1TI6I9BWBT1Hp6sVDv6FRPbknYHif8sj1OkcPd9W1HAGqMxaxLksRBwwsXmG0i6unQTZbGSBknHYxDn1VnaNaCKlqMNxbjMXXPLrqpv3gZbnPG2/4smJKOtDJnMyh5tDyy2QavbxNbFYKs74M7T7zzad4jg1Vl3bdr/84zQE3KAxbCXRvSbz9DOG82lZdsPX/u+6tpGP+1VMUqkZPGOYapR1uMu32VczJ/XPxXKMx59ot2fzWsoa9QOcW/q7A3oO0PThUvksTmfDgFSpZJW6mfVf4iQedXcuW3eUyY0Ol8KfHBNYXn/OWErAsroXrt9IgWm272OkooWRKOEfG8YhxmCNreaPEK+3/2WsGtnAO0TmEOMzXG+4A7VU7HhrsKHn9GwqPv7JvtUk6P/snezrG24YbJ4Hm++EsPvVFtQjXVS/HE+oOmcJF23ToXS9OvwomB2PuUwYug1eFYhAbF96EeXXfD8MDRIUB0vs/pSvXuOdTyEPHuffaOsD9s4NFuRfgieXuiXfDgBZWYEZO4Ytx/3V/7q/VBoc1ymcPqsVrUogF5m5ptXC8UYx1psCouhxw9B8mNrJwatXXMEEuM2xEfSKUclReR8b1mJUF6b1FcIgXbqB2sEW9eCQyKcmez6M2+BH6ckWNatPNJ7us6dWqMzbyXaARUyLXC1H22I4CcgEKwO3b2vQgprZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199015)(26005)(186003)(6666004)(6506007)(36916002)(6512007)(2906002)(4744005)(54906003)(6916009)(478600001)(6486002)(41300700001)(5660300002)(8936002)(4326008)(316002)(38100700002)(66556008)(66946007)(66476007)(8676002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y7o/0VN2+DaVfquseq5uJvsSFYC3KA2MlMix5Ktn0WtcI9oVDHh9ElHSvckz?=
 =?us-ascii?Q?ze8Z+jwVVQSffwwDRz/PkISrslUQ3zDMKO0Kv1crOuGpKLa+jcXdbfBOk2zP?=
 =?us-ascii?Q?2HOhOvR1zXuH/PSMhPMNykCgcY4B9gDUqcGN4vbVI46sJ5TMiZthltc4pai2?=
 =?us-ascii?Q?o6eLFWbUL3LTnmSXePUqWj92L+mX9KKbxVeIE76mLGHZX9s9PhpYbnfbzllX?=
 =?us-ascii?Q?1MfCrHmgFJiKKTV/gVwZdiCnHM0H1o4V7QdDnqXQVFPXdaem0eukVKsmmTKI?=
 =?us-ascii?Q?ss2YAG9k+UqgncTKtmkP7o9eicK0FMLnmoiNNcvtqafHCml1oTf2bMjLwsAI?=
 =?us-ascii?Q?6LOxpNgH0Ys6GxguxAsAkA3DmpjkBpNfa7iyeSh5+QRpQ+ed/YHi/NSCFYOT?=
 =?us-ascii?Q?z3pKYe85NjxslJ3FOEkgZRFnxIpuNcgqmyOEiVJ7x+fWpy3jZAh67AOPSLa3?=
 =?us-ascii?Q?CJz8Uj9LWzDHF1sCp7HctKXowsAoDD1+ksQq9z9y4L4rF6jyzt+Lak+8cGOo?=
 =?us-ascii?Q?NYstDWRmGW1/mFOlrl9HHzwupwCOGdCnSbB+kkkm4GCQcnsdcAzG8WezXtLd?=
 =?us-ascii?Q?F9+aV+oq3fjaMbNcH4gQ++wPd5ovhYskt6FCjpCjMIbHTpUbOHCeUjuGYf9o?=
 =?us-ascii?Q?jMAE54KD9z/XOHDRLSIR+sWRH+C9CroBmAquzksllTqyBFiV8SZGhcH6OLr5?=
 =?us-ascii?Q?mwqTD8NIypKXKOHW5pRcpBzSWceX6u+13ByaGFRD9SWqVV7dXVD6RkdYjqFP?=
 =?us-ascii?Q?lM5A/51m+SYtZOzuklYSwJDNn5Lr2gN7AQqly4OHGsu0QL8A9nTx9udmpepP?=
 =?us-ascii?Q?LTVaw0/WPqah2XD4QR7E4TugFAkc5RdAWDk/X+0+rQdiEuVleTDuTkAMQp1N?=
 =?us-ascii?Q?V8pU9dcPo0s2kCshMKnTmRJTL6nHjh7an0z/Vt/ThDCx6ENsDiWn0UPF5c8G?=
 =?us-ascii?Q?3m0PIvk5y6Ni6PxdqCvsSxzfg5kqnWfC6kasNjX7h7g3+QvAkJq5VjVfqx0w?=
 =?us-ascii?Q?Jh9VnFAF0h/4TQ/sjCh6pIPtbSTWXpoa2elYg2trhyQQwOKkM+GW9UTMgSBp?=
 =?us-ascii?Q?JHnS9sE5xmvZCsVEgTn236c60VV6rXMYyRuuqrPbJRSngkskhU1SpnJxc9dw?=
 =?us-ascii?Q?lnybj06d563ZZjEHemkukNHnh1qXS7X8a0dwTQHRbqy30k+T8fMCZqxBrKpW?=
 =?us-ascii?Q?4B0LhdDnpSsFX0Fp9GNMha+0q2QBNQEiGDv+EZIJlqIv9tLzsrQ48t/AE7qr?=
 =?us-ascii?Q?jzkGrolQ/AjD2RLCPVneEcJu5cMAV6lEqAqI2yvLK1tdX1cZ8cueDoywtgzs?=
 =?us-ascii?Q?9iSnV0eSiVzswJ+fC0isucXw4bxx5+YRY7q7X94xQH7xpLtMOg7TlE5Ki9FE?=
 =?us-ascii?Q?0Qz1w1MlZ5BGxuNWbmPgHu1y9P6LkgIS5YvrL/yNr1b3flKqY3wY5a7Ff4/d?=
 =?us-ascii?Q?gbLIwzaMbTKtp3em53pYK2dC952jnQn9myNDhvBumOc31spmMQ31TRoOa8Wc?=
 =?us-ascii?Q?gGEWL2Ht9PBfAdXuhDfW6G+DmHp4zRQC1tIyRfaF4PeRYdA34+4+KAFX7rE3?=
 =?us-ascii?Q?j6a69dfDNyU/3aOWpDImJOj7rK0eZO+q93X7EVu7vXR31bL8NRPapvWA5/dH?=
 =?us-ascii?Q?yw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3626df03-fe29-4253-7ca1-08dac135c7f0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 03:03:15.9606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MtEQjaXpuUIq9DjZiYiVerN4eX5/e3xsgKrUkbRIDpStrjMDEzEidCXUMWTd6PioDOqkyS/JGwo9rqlC5985qU26RhiXFEDlyQzRktf4Enc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4710
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=614
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211080014
X-Proofpoint-ORIG-GUID: vWEW_D5SQMZJ82GwlRwwbUzPwoAB5fRJ
X-Proofpoint-GUID: vWEW_D5SQMZJ82GwlRwwbUzPwoAB5fRJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Move the code for aborting all SCSI commands and TMFs into a new
> function.  This patch makes the ufshcd_err_handler() easier to
> read. Except for adding more logging, this patch does not change any
> functionality.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
