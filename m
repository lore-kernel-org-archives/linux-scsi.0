Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5977C48BCF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 03:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D85E61375
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 03:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhFJDQ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 23:16:27 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:25132 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229986AbhFJDQY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 23:16:24 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15A3CDsW007984;
        Thu, 10 Jun 2021 03:14:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=DiyyIugOI90UiCAK7T4Hk6TpP7D3fgrSQ03OHxn1vU8=;
 b=CggQlvn1iwn30MQzDe1KEsz64oBgxpjTO1OIO/CoNpeY5ZsdoCywWIt3Xv9WaBQlhViN
 zDfdqkZAQRX1C9V0xcb1KJ4rWmzKErEuXCVr9emfsgWnvaQwmxRCwouiWbTiHcMSoMBA
 bVl63d8PAqYn4odQwNuAEw5Zyt3nW+oM/BoK5T1wl0pKJozEpP5+dU744lEIGz3LAFQk
 BZawbH9wfmvYrApTmox8Hx+GVRE0Zo58+XFligsGIWJ/yk2Qglp3RvQb7uv51LHraiYP
 3yXGYSYpD8xFtO+ypkqoTSvnDURCIewRVvGcl2qG8/9pPZplLwWbBGfMmALZQDtJXOQf qA== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 392jmw0gkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 03:14:22 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15A3BqES029851;
        Thu, 10 Jun 2021 03:14:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by aserp3030.oracle.com with ESMTP id 38yyac6mmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 03:14:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYMgTxJLSApoW78hejEEr04VJSPoJroAg7/fekycGC8MzXk6nYplo6ol7u36pYd8EtbIrXNVsyEFMkChT3UyqMuLn9yneURAoTuimReMC1q8XpNW30mwWIgb6VEeqxQ618Gfcw7VV+0GvAuqEC3CLgufDK1cAm0QvPIq7PWUrSSJRLl6KKOGKbQNUX5nwUh1/QYxgXw+t0jzWkU1ykFosTwRhPCHdSZ/X5fgqgui6/zKL9hynip1UCGAFiLPkdeEuzkdFDrobCr618rl84nywr4yPonnojymc/9cAc+ZnW7wp6bZfmmJYx4gOvLCZWGAjBmXhzCDaVl9ahimDXDQfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DiyyIugOI90UiCAK7T4Hk6TpP7D3fgrSQ03OHxn1vU8=;
 b=Bx5nANVswHWd/PR6jQoLPMUI6xcTCCfQdyaAfZ9GWX0w0T5QVd/sHLLMVYBdPcKd3+z8ehfgQMYkmi8eQBw5M/eoCsw7mGnSWt8h6GWKnfUsGnP+5VtCrEkt8v4Owpoky2CYK3EF6D2YDn3T58NJynLLRUukRiubU5fGyJeUj3jvY4bHpAP7A/HC18EgiPuvF1zygTHX//o3wOxeCYwB4EaTxcc3DB1V0yjwkNOQUjl84bEUqyByKVTvhYyzVLNz/YPpeSWYJERo9zCYWq4J2fMQVQqfCjpMuSJFx2KkjBEPo/U2k8e46SidILkibesU4sJblTwLwqQZv3VbUqO6og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DiyyIugOI90UiCAK7T4Hk6TpP7D3fgrSQ03OHxn1vU8=;
 b=lqbGEqrN4A2F5HV6L82pvx109CrY550aODKieu/hu3T4jeisAcXKAOq4bcxVkJgWBwKVLCqSn8E555rnabmYiBJH5ZO4k0k/skOs9h2BHg8Jye5WbfZ8Fb7D5MkmvT031y4Lrvpw7xurjlP2HryaDw6CBsYNXwKgT2sj2hiUdXE=
Authentication-Results: 163.com; dkim=none (message not signed)
 header.d=none;163.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5483.namprd10.prod.outlook.com (2603:10b6:510:ee::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Thu, 10 Jun
 2021 03:14:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.022; Thu, 10 Jun 2021
 03:14:19 +0000
To:     lijian_8010a29@163.com
Cc:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Subject: Re: [PATCH] scsi: lpfc: lpfc_hbadisc: deleted these repeated words
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8cefm2x.fsf@ca-mkp.ca.oracle.com>
References: <20210609070113.443914-1-lijian_8010a29@163.com>
Date:   Wed, 09 Jun 2021 23:14:16 -0400
In-Reply-To: <20210609070113.443914-1-lijian_8010a29@163.com> (lijian's
        message of "Wed, 9 Jun 2021 15:01:13 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN7PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:806:f2::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7PR04CA0022.namprd04.prod.outlook.com (2603:10b6:806:f2::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 03:14:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fbf48d4-645d-43ca-4006-08d92bbdd66f
X-MS-TrafficTypeDiagnostic: PH0PR10MB5483:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54833E29AB62A0C1948B39898E359@PH0PR10MB5483.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l0Mr0mayQ6rs/VZYgLe3wrVc5U5odvnUsii9smaVZdVEWs8G3udISBfufuKAPLIkhqUnBZlYb/4oe1aa9KnheYfVtIeRPKg9frt4jMrwJJXo3IEpw/mNw8vh59V1NV7cWTcyy8G6xVoJh39X8dBlFU9N5pjWf6eHtAhLBdTBQanKDBajjuH56jKP9lL9hXhqsy+yKYpHM3TlziWridadkRLlThRVO0Zp/PK9Di5hYTw0a5UTnmOdc4zQy1v0RhCSLJiKeDzi0lj2w/EHmYGaGVt5UEeB5JNEofiTJjK0a6+A2/Tb7LckZ30kFyWLKgbX88apEIhGa22UPA4NzOIotGu1MERCsp8Wl61IVN7UWvXV4tCElSKXJcdcejovQkcvLMsruSiQPGn4gSfRDZ0RzNatRlj1jZN/MWZ/kxX7nEujBiyG9dL3RoRWGl0vSYRgo1H7OeenWx/+vp45Bq1EnyqcGX7UD1AIXL8kDZcnQEvKowcVM8aazUkpHjwLPZmMUJDubaa+uaOAO9jlFJL8xdEX3by4yw3ooMaOQ5i83NF/lSYvRhEjelnL9WcCdO+BLEQsj4gHX+z5qAKt1Vj6lyL1SvI74mmRSUkEj4t3Z7/H+nSiK5T1EPWTZZxp/9CtkmSLrtZA2VMNun88CJ1YPUPERJ3GEUFgC6WjaF1dXeE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(366004)(396003)(136003)(4744005)(4326008)(6916009)(83380400001)(956004)(316002)(86362001)(478600001)(8676002)(6666004)(2906002)(36916002)(26005)(7696005)(52116002)(55016002)(38100700002)(8936002)(38350700002)(66946007)(186003)(16526019)(66476007)(66556008)(5660300002)(1491003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WVnXb089o2c6U3RONJ5GeCXuWon6qvVVzKZItJdkiDl0541pXheViWXWheN8?=
 =?us-ascii?Q?8G3IZYTScUyQFMqv9IRkLFQBwfYR6JSxOw4y7m09+uWzPlaAZvI8Yt2hd386?=
 =?us-ascii?Q?hftt1Ow+qlcQVFjFh8mKlRcaU9SiXeyrr6FSolH4P5ZATih89JbSCDbWm9+c?=
 =?us-ascii?Q?7YwZbLOs/al1iNIW/+hh1LmOlvXH2PvgIA3IrmMHDueyguUPIzE8mLyDrD2t?=
 =?us-ascii?Q?Ik4IrlKqrfTPA7G0rcVj6ZygF835EkFtFvvxl1A+AIubWMBJyJlqboVu+Z5m?=
 =?us-ascii?Q?PIPbgwvVeT2osbjjLuBTh17EdJVybTqoNnB6je7YgPQJgDAgcgrVY4SHAPev?=
 =?us-ascii?Q?hf43vuIcYFUMyZJTxOonnx6g6UGHegk11sWItjRK5LoGqlh+2xJDcoxb8KsI?=
 =?us-ascii?Q?gqvh7Gn9qxbvoVwIT5YhpW57l0lyvpuSRuM0tYbXpbq4Kk/1j3yhEkx2Tw63?=
 =?us-ascii?Q?gG+ebvPiO7W5win1nE5XpBJKCZqCyDZ39VxTYB20cY0oAQoP/BlzADbMH8Qj?=
 =?us-ascii?Q?wkrVVwCiLQO77qv6RxlNJf1D7/+/8N4i1fsnmxmZyswjBLl4+uIvpxOFqTvN?=
 =?us-ascii?Q?h6WoWL8o0W5HDP8yY3CEaSx3xJ+PAzzs8OtdVe1LJdn7rgkwHL/qnTg5P3Ku?=
 =?us-ascii?Q?920grigXxAVhWhIgcEMauKFVta3Q6kIuq3XatUaBSnez1Fh9zpa+RhyIO05m?=
 =?us-ascii?Q?5a9fdNXHdBde/aQEhP7w9Bh9XTXwrBvaNFJjei+PN3KHVyMFXgbNOHOfceu8?=
 =?us-ascii?Q?eXzzkbhK50pcFx0NDXFLVDpuI26Rq1TIQOiEp+dn1ua3WGK1iCkWAoAQDU7I?=
 =?us-ascii?Q?1FEFo5prea8z/h/5S1s6A5ZvCtk11MbbOu3PCZhET0u39k9row6MDX1GUgQu?=
 =?us-ascii?Q?C+WvRv9ir8P3k+N1xK07lbiJ0Cffc0SZC/xaJ/M9AtdVETR3C9pfWAhtJtjp?=
 =?us-ascii?Q?dUEBZJHzV5CfMbtL8V+uPmTL2CFqheA+Ena3jhguMrHdp6w8/0uqQvWSpuCp?=
 =?us-ascii?Q?T23vCdR4sIr2lt4s4tzZGU5P2eT3w3A5gmXDEbIVX2b3fQDUY/F59iqm72hK?=
 =?us-ascii?Q?Dspw5ZjzCBUs2PA/iK2RqYuiWrCeLEV/95KqsON2+tgGvzKVYz1yeb5ZsjZb?=
 =?us-ascii?Q?LnILEKy4IT3uzFgnN7Hj32iq+16s2QNH4mECkrxjnk/LUIRFY7hrnZLR1EUQ?=
 =?us-ascii?Q?9Qwm+9z8ma94/TpqUtb6bRMNqNjXshlSE6cM0NfX/43tKzfu1U5FXGWbs+NY?=
 =?us-ascii?Q?g2XPcGx7XPMqZJQ6B6dZk2JilaCKIYQXvpzFSPCUIjJcj/QPx21/RELgZcc9?=
 =?us-ascii?Q?w1iqX7UmLE3kwo0Vg6zcqPcX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fbf48d4-645d-43ca-4006-08d92bbdd66f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 03:14:19.7995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h5VKcfWQR8nD8YrPUDudaW2P2isaLp9TV6wiocpH+gbF0k8X8RRIWWF+h/YzK7ukBFg8aIxARZGn0nzoEH6eQutlXywPUoo/f2wLSRFJtiE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5483
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100019
X-Proofpoint-GUID: LqLwkU_JWd2A9UjZHQnZfr5sTEiLIuQF
X-Proofpoint-ORIG-GUID: LqLwkU_JWd2A9UjZHQnZfr5sTEiLIuQF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


lijian_8010a29@163.com,

> @@ -2138,7 +2138,7 @@ static void lpfc_sli4_fcf_pri_list_del(struct lpfc_hba *phba,
>   * @phba: pointer to lpfc hba data structure.
>   * @fcf_index: the index of the fcf record to update
>   * This routine acquires the hbalock and then set the LPFC_FCF_FLOGI_FAILED
> - * flag so the the round robin slection for the particular priority level
> + * flag so the round robin slection for the particular priority level

Another typo.

-- 
Martin K. Petersen	Oracle Linux Engineering
