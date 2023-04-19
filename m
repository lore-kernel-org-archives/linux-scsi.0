Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FCA8C77B73
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Apr 2023 19:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjDSTN6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Apr 2023 15:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDSTN5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2023 15:13:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFFA46AA
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 12:13:56 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33JET2M6024238;
        Wed, 19 Apr 2023 19:13:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=CEXF0vDuFh6xO58SDNHpmvnf5AVbCn9T2zqBrRyTQZo=;
 b=PsDeAvFvRQXI4Ljs1S00gszWjeoPU7kwHqY9stsSUyda9FzWcjzl/gcaaH8PZdgJdrfw
 v6wFjIHDFOsn/eXWJSXJ4//tWLi7TDmathxxxpHt17Ji3fFvA+8QOtT/UlF71kV1Ypwe
 rb+3eQbsUyASkEbIZooMw4JHNZqYK73aJQAs6DOccQaVegUdIif+MG50xMdr89AscOPa
 Xk7nlhfvhV6900BQy162QrwH+BqUfrIx75s82KqdvfdbQXCG+R4V/GBpINlSt0RzOFKo
 oUo8s738atWFSLez8OZQ1Wsz2UxYCpJOAIqMjMeuUzNsit9s87RZPtwc0qf+/v9JVigM OQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q076906e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 19:13:49 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33JIrBU5037795;
        Wed, 19 Apr 2023 19:13:48 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjc7b9w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 19:13:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBvfryYYGt4LM195vlTDP9EUXLHvF9QZNcHWw201boR1O31LcN4vCa7RP71XRZxOled1iNnb4CJj6HowOQcG3l3nDigwhPXYjIAZ/pIfmye8bnGW0avC0KUDsdaUNzdNXmiymSWv9YIgcwgsDfE9C3TyfcvuXgQST+c7Zqg40dQbUphdvKLWYahpA1PYGiCO1taTLQgUbVjgYcj//DrgT+4dpFMhMOb/0XdMwj3A5oV+ctA0QEGU8sU6ayU3AdN97lS3j0Kelwc+D3D+AZt6IEVFq2yeeLl2XQuAL+IwnNgsjwc1tBF8PtZnTVgx88gjJcuRmjmbomiJYgkrlkdJPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CEXF0vDuFh6xO58SDNHpmvnf5AVbCn9T2zqBrRyTQZo=;
 b=mP+DEh1MEbHwg6TP4icXNQWRfGgdr/DSVpBYdmrCEyJ+0fUId0d41W6YOrjvwTm11RMmd0oie73vUwVdcZkNyISNoNZinqdlC2n9VyOz6lem5amooodEegxAs5Ir2NZqncYdqLJGg+4kQq5278QhMUWuWkWjEadFofYpZqqiNaGegiII09/znZ7roen+FcS8WG6dqHomh5ip3zz/oR79TCSyTKtNRbegT69dtGw/KvHajthSTnKyYTR/IIgGp1n1YuJgb+cu/fw0lFDXfeX0WFRIlkDn8ouRLGp6OK3zUehBNFUlawV6YSXST6DeN3LN6+P4URsLtnweGWuumo3V7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CEXF0vDuFh6xO58SDNHpmvnf5AVbCn9T2zqBrRyTQZo=;
 b=zx7dTfAC+BoTaxi5oZTimR32qzCYJ9yDSLehkQJFo1t4AM2feeY4yImaCgPJodw+eGItp3Rd6ootZ2sPjuXRTzcOzDNxH76Ta5vDhSLu8bH2ivcUV1gYwTTvkhkXYpt3u6OF+lBIgUloBD3ES98Aecoo065LYSqy2ZdM/TBeC9s=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB5122.namprd10.prod.outlook.com (2603:10b6:208:328::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 19:13:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%6]) with mapi id 15.20.6319.021; Wed, 19 Apr 2023
 19:13:46 +0000
To:     Brian King <brking@linux.vnet.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, damien.lemoal@opensource.wdc.com,
        john.g.garry@oracle.com, wenxiong@linux.ibm.com
Subject: Re: [PATCH] ipr: Remove SATA support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8hrofgh.fsf@ca-mkp.ca.oracle.com>
References: <20230412174015.114764-1-brking@linux.vnet.ibm.com>
        <yq1v8hspnww.fsf@ca-mkp.ca.oracle.com>
        <ed208a85-f66d-d70c-d3fb-12e66629863a@kernel.org>
        <yq1cz40ot8n.fsf@ca-mkp.ca.oracle.com>
        <f667d600-4eee-126e-c14f-60cd64109fae@linux.vnet.ibm.com>
Date:   Wed, 19 Apr 2023 15:13:43 -0400
In-Reply-To: <f667d600-4eee-126e-c14f-60cd64109fae@linux.vnet.ibm.com> (Brian
        King's message of "Wed, 19 Apr 2023 13:58:20 -0500")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0089.namprd04.prod.outlook.com
 (2603:10b6:806:121::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BLAPR10MB5122:EE_
X-MS-Office365-Filtering-Correlation-Id: 054d94e9-3215-4440-f130-08db410a32a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zR9XrquhvVii66uwQoTpIR+4boqEZ5yM355YXSk8QndayOAWVVXzFH1pinK6/y9BGNdBquBBb4V/1OyS/cBPk6zctXc1G3cnsVV/hgHtnepR8kL8bpaC4CJYqtXqmFQZLCSJayK1f7WIhsRArCrmvuwUZsuX8NP1mJrnKP20EwhGuoZoiSNaNl/tRpLa9xXbTWNG1AO+HxYEE6wM4V8RgL1NEjQNzT38nKD2lAed5Dkc0Uxa75mSHaSw7AKGEVJrgRY3oR1BMQGst4WQxo2uEGFbA3WicUXlj/TBdeKDHera2mt3WJYSE0nTs3ciD4nv/jL4avhNcB5ZXoubqujqfyisptegvZSR0BU3MFQQQ2sU9T5+NPUhRXCRFqQwCf+JQ6bEL5lsSlSCCh05Kszntx1jRanVG+15yaqGOjYwrtSixrIgvJb4tP9eUNzP0D7PkWcEZ7Rx+21Id//lxwFgPraV0YTLZGz1tKlJ9r+c8LaXa7Bk1pr0VfJMViVPnmL4DLj3WqjCn7CGbIrCvEMG2G+laJ4qx623hKYTB/ovrRAvreuo0rmlb6AtGoiG51P/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(136003)(39860400002)(396003)(451199021)(2906002)(4744005)(8936002)(38100700002)(8676002)(5660300002)(86362001)(36916002)(6486002)(6506007)(6666004)(26005)(6512007)(54906003)(478600001)(186003)(316002)(4326008)(6916009)(66556008)(66476007)(66946007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B2trPetZTspEvIPN8v3V1yAmvm686O8F80P04NPzheCQEf7UXyifV+QObYl7?=
 =?us-ascii?Q?Xruab7RPFRfnAvHzAr/6rBCR431+w2yBY2+MyDWt9YXkisprMyiP3kT09A/r?=
 =?us-ascii?Q?R2jWaCCIuKuXf+hYsfszuDgCOrrSHdXV+RJBKj3uiv+lsaK1x92cdbdchAug?=
 =?us-ascii?Q?ER+h1H8AE44QzQlTXCWVusNYkpbFt87brU9IqiWxJ7rl/JKNWehMOahpeNRJ?=
 =?us-ascii?Q?aAF/9Gqm6DgtoDRMBahYfgHqG8z1xfNtnnpf0iHUSwd+gZB7NADN01rxFn7f?=
 =?us-ascii?Q?KuIDk0UV3iINzKpA6vC2A6XmfdOmDkQGb1zzByUM989nSqK5IQR4JhZ8oc1j?=
 =?us-ascii?Q?Ho9bV7kdhqIRy7H1maxP/nagpQU0rN7PxpbbrGzhXkQluWLWJYcPQSQ+1N3H?=
 =?us-ascii?Q?cHNesNxLXkTyB1fbXh//asH0X10md+Uoy5UXiVo6GpiGw+0nGNwx0X4eE1pX?=
 =?us-ascii?Q?uUWV4Dx1p/6YW0U6DGmIi6atmBvDuRqMCrBpJIm9EnmOK37gG3HGeK76IkRJ?=
 =?us-ascii?Q?vj9ZMmGN2O8qG+GTPFyTsiGkZXnTF8I22r1ND4669v30HLifQAZkuYZEOEXY?=
 =?us-ascii?Q?3uNkG4HopMgoOdFYqGMx235/ynJhZUKLCWd7BEmEAUiUNspwEMMe+6KxXRIw?=
 =?us-ascii?Q?Eeg0BYKkupNkPJnBQOWWKFnxL0urfSOqUQ3vbarVFD89/krduixkpv4Azm7Y?=
 =?us-ascii?Q?QK5OzIXdthBSxzV0NFju7oE7YYVp5OKjkvZdfNbNyu/w+kLfwU/T7yo1bCGF?=
 =?us-ascii?Q?duCyvteuOdBsHL2OatBSfyFsBLV5eIX/wx4jJFk/kykI4Mrvh06g5t0ZzTK4?=
 =?us-ascii?Q?Hm2Qm3IezR61N/ZZGb/obmK5KIY5nmOfNuGOBoeMan+/HJOmssryveOghxVn?=
 =?us-ascii?Q?DyKs1b5RFXjYrpdsk0G120ObscLn/Md+mSAmygh0nLxcB3sP5nqXrpQgkQgo?=
 =?us-ascii?Q?x7AnEHOyyaEV6dn8KF2J9vQqOKKBXBeCz2F34vcOPMaQ1DMKyQ5dCSgb/xj+?=
 =?us-ascii?Q?00f54c/5zJMfnuXIq8DLcn6HaXq3Y102+CfkuItFMFGZY+YqQrJExZyx1jO9?=
 =?us-ascii?Q?QE4fi/r/lBqoeTysgE0o/KP8yQ0ZHrBApAX18Utk+PlwC643JgzjOmIafHux?=
 =?us-ascii?Q?fWJ3o/e+YlRE9hojw73vyJc1Z0slSS/4Rr/YscYhImOUbQWKLzkn/Ry79gHo?=
 =?us-ascii?Q?D9f2z2VpkQtdoj3fvCl/bHYtt0012TiDfgrHzyDNIKdKcWdzTysIe+5+N8XC?=
 =?us-ascii?Q?/nWppzBuv88zFwoMxZCQ7JabIcjzgXCBoJGiubRtAuEFFUq9eaPN4u8Ej36i?=
 =?us-ascii?Q?+y6WQUqiICY/KJkdd33KDefDQpUZkumH+X974EP29y9owrfEbvU3HLiHnAt0?=
 =?us-ascii?Q?Vwk+HXAWA4s4pxyytTb+9WDgvY3Z0Bq4HKZsdlNZHF2MGv/9cMlmIuMAJi5u?=
 =?us-ascii?Q?crK7DNG/w+B4pM30LxPVGvvXsZTobpOaSEGSvCj/1jknBZOm/qT/zHy8J63G?=
 =?us-ascii?Q?NbWHZ7gWGnhx5JMid8dx7Op10npkye40mu/93wqCI3ndXzymgIb4rZ1ngOlB?=
 =?us-ascii?Q?5zlXPPFw+1FbLEpfq3fq2e8uwMLwOMg1GRGIXp97gTZ9agrlJJ2MHMaZJ+QA?=
 =?us-ascii?Q?5w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jw5tNjphyUYN8CBkKFJz7AdloW4sqyZaGgeDob42htjusCBPrnKTMkehwofnXTJ2bWXV9GYCnYU0Pd36iboWSWagKjUZgzLF0IuJa2WwRnXb4Ln5lIko5OoukObhT3g9GbJe+m4l8TfV0TBHLzTO3QgNeQHIVt2/COjJW/kXMu7/4wogRNO+BWH4fbvP3VL3iX27PcQrIWRFjCwR1VQ7CDXoWNsnVDjSSbU4iccWzJaqYeTcOs4TqgfwCVlW2pf8MYgsW3tyPhxA0RnUjetvaBva4NP8hcGqURsq55qHCRQIheu/3zIdYhmCGS0lbbL0QuHLVxQ+4r858rW3hD1Yqh9/2Hw5RYKYyxRqU5fxI5LgWN2kSSCfqalun3XwOzdmU9FL9rJwl7dalZhkb6PA4yw1m2RnGHtfy9ulypHk2n/6NqC8nzIReJnzQfnyXhpMywkkdkVVw2SKAFJEm8QsW13yddJ2OlvmQvJEg2h+DrPNoKmuACAotYFyj52Kt1BDP+N+DEH3mQ7z9ds3YkW/vXLw/42c3lhxOM9ATArm//cLTIsEctgnP6wG7rn3QDBFZ7JCR8kIFc/YjquFzevamFwOOAv6V3scRA9s/RW3BGAFPnIAJMJ/ecoerdsiJUOR8xGtrwj/R66pbs+Qn6EuYAHVIaD3jHXkMCRQiw3w5c935jHGYn/4WLBBGUwXWVvVUNf7h0A2b2yOOmfbxW6/ZvenzFF8fBhShO8H/saxQ3WwH1PnDJ8zvrGrLEZ6ZE20C4dZBEwf/ChS9ZYi/6jJDZBxUzlygEezKXh47jH9byPPovRR62XBgwHS8JiAgQBKII2CQd5YpfWJDZb0UbGNrpDiv/RDVim4uXRo/lOUuwoKn1TCFFrIw6Vyny+1Fi9XupLnUpRQCGFLwo+4YXb6Wsj2GRbz68PShKcf0hPJFXQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 054d94e9-3215-4440-f130-08db410a32a6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 19:13:45.9773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uYdO1fwVrATAFrlTS0/fIREgwebAh/7TIpJTCC76S9M0oUchINL+UGCO5xFyUmj5G0NtCxl4OXVtTxRHx+7gm5nF05gt1qpdFuuZ/2b7Hf0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5122
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_13,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=934 adultscore=0
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304190169
X-Proofpoint-ORIG-GUID: Hpd2XgvRSr1qITfE7oJOzzhAvRhWqg4a
X-Proofpoint-GUID: Hpd2XgvRSr1qITfE7oJOzzhAvRhWqg4a
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Brian,

> Since you've pulled this in, should I just send a new patch on top
> for just these minor build bot fixes?

v1 is still in staging so a complete v2 is fine. You can also do an
incremental patch and I'll just fold it into the original commit. Either
way is fine.

-- 
Martin K. Petersen	Oracle Linux Engineering
