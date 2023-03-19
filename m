Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E977AC6FD1F
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Mar 2023 15:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbjCSPsi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Mar 2023 11:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjCSPsh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Mar 2023 11:48:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CB1199C5;
        Sun, 19 Mar 2023 08:48:34 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32JAbniY007500;
        Sun, 19 Mar 2023 15:48:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=jc+DcRtgoWcf7EiGfkE5u26xvptH/cUaHTgE5NbU2+U=;
 b=S5RE1eQZ84412pwG82TQpmTQAf0Vd0kwCBNcel/Ddeb8WvHYcuPKLrmTaC9r2dMnKjwf
 fvFJm9y2L8IrFFqCdD2hmisdoCVkHOnW0xZlhggQ5PR40HMNVI5ObFmYHSnI/JJ7eSS3
 bQDngTMnkFfIv99AgXkZkgwXLpdhfOW2CA1///ZTcwXe3OBYat5RFgE0of5aTmROLWeu
 g68UhfQlIVIj7iOJDwlicChY14YNuYPhFR1+QO+JxhYoOije56SjuQm4SRxivegbyCC8
 wJcxrLYuf+uGDWNhxbv3fxmV0esikeGvUJeSN3ax1s1qYchptS9IgF27NsLcBzFV47pt 9w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd5bc9uvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Mar 2023 15:48:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32JBJghr030373;
        Sun, 19 Mar 2023 15:48:28 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pd3rasx5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Mar 2023 15:48:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KCV29/Yk7w0Dd761zk67kd2Z2FoQDBAypHSoCUW9A+O0OHC1sitmlltzJSi1+qnSl0IThP9dNpD601CgXoXpDAToBrNow4CRrNxL0LDWh6v1lNrKx4tVNn5lb0e6BZjd9zBsronNtwjUMjAhPQxvMxB5yUZn6E6QLD59fte0wmDFW1l7tLg5VgJvjnGA7JgCsr0oAd44mgOkfgnkAWfusSCT+qGSgtpCzaWVsZw0NL+pfh43YbKfvNhxcSOMuQQCkwX0H3YecLSe3umKliAriS2eUeI1yjuBpnzVKG54xEcpoMd5dIvkrfmm7K7MGmVF7efukaEsQDuhx0av1e++TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jc+DcRtgoWcf7EiGfkE5u26xvptH/cUaHTgE5NbU2+U=;
 b=Mjo1W3wPiyKzEHt1PM7+r7nsyLBI73sakXhtQsQker9cdKxySlX5SYyhDtqx+NS7se1agKOhq+anmQO+korz66JXQjSjt5PiFfECglqKSdDje+BJxpiMn750f/0MJWJf7sB55PcTnYA1VynCfPVMimNfVjHhaapCg7k5b6WzIyQNIaq+g0oUzUVFZDhHZ3dT+QtIOVI7xKrVov92w6G5lsa5d2fii+C6gi3AcIZOwC5lQo5Hk+WS5cYxcY2OEaDgl6hEKz1OR4w8/Dngj153aqH013zZ3eUjeEON4Hxc+Tir+pCphD4mmJF82invlxS8BP9pEX6X+yy8Vi0e2E0egQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jc+DcRtgoWcf7EiGfkE5u26xvptH/cUaHTgE5NbU2+U=;
 b=fuuQZ5oETy+2JspgktR283xCx7GJDV2sDwHqm8PVPWG8xntTRteDNmlm+gjhBzde/31yosd9BuuAT+rY2c7wy8FQ11W00oytCaoplfvY+2iAzr3bQjLM5gfsWFlnlLzcwXuuxYlPQbGSrVcNy3OoRx9QXHIKZo+EUfmsioDQe8I=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB6327.namprd10.prod.outlook.com (2603:10b6:a03:44d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Sun, 19 Mar
 2023 15:48:23 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.037; Sun, 19 Mar 2023
 15:48:26 +0000
Message-ID: <b6606537-5200-041b-3157-2e81ef6ac3be@oracle.com>
Date:   Sun, 19 Mar 2023 10:48:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 3/5] vhost-scsi: Remove vhost_scsi_mutex from port
 link/unlink
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
References: <20230223001949.2884-1-michael.christie@oracle.com>
 <20230223001949.2884-4-michael.christie@oracle.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230223001949.2884-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR18CA0019.namprd18.prod.outlook.com
 (2603:10b6:5:15b::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB6327:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b2940a9-fc2d-4d5a-0faf-08db28916067
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q4Vw5DP/Y+RWzIvF4IU+jE0NetFEEyXOTdxme2rjjOpBbVIMYkOpc6ugMM8ABk07QQ0ZULKl9YEVezYsyiLDP3F0r9rxRL4x2kmSIiL4AJbMsIGMXilwXGWzLVsjlFx0U0M96NaQTNtGalLSV1eWjfKI2DA4pHEgEopleZghixyoPmTYSpQBwbJg2wIu5UAWzlQwB/n9QZEnP+fSosTdas2EebPtpHsMFr/DzkPUKCe9BXEJ1/US/k4hpT0h1+H4fujMGpg4kIXyyG2FqSCCZL0O+a+lghig5bqABLkwQVDKMInyI1uQzA4Sh/2Fb/3aobyBFmJHZWBYC6tVIY69Yy7kiKa22J37ejOEPFqWva5oE7jznuFwa63IzvbWJqQpQ6IDnhYsXOSrbVz2rV/xGkYzUSiv5o5t4vASqUdVUc/4+7lvoboxWPKk4EjNQhDIWZYPki51hHguShgoOQL9DTsGs5iAqrosrj/Rmb93M9Uy/TRU4+XiT+H3XLD5UvHQAoW0TMAmmCixiAg/2s4L3DYDuLtT6lhKs+ybyt3DnL33DKvv3j+ZPPj2iV1JiLX1i2Hxa1Lr7kO/K6/qIPtbymD/xequmEH7/xM82A0//uzlneOeIvSWu2L3/JlcrQEZJRajsNGyvihKbQmSrV8L1yG/W21caXWf/SJN0Bloz1sF27g2vTn5AUm3aaTbJUvJrUhtpuso6r422Pqjb1XWosj4ihcRMyO43+oiiRdjn0A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199018)(316002)(6486002)(86362001)(31696002)(2616005)(38100700002)(478600001)(53546011)(6506007)(186003)(26005)(36756003)(6512007)(2906002)(4744005)(41300700001)(31686004)(8936002)(8676002)(5660300002)(66556008)(66476007)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2ExZFd1ZmFPZUJkT09EVUF1RThQaFhZbTd2M1NSRjRzNlN6R3ZqOFoyODll?=
 =?utf-8?B?NmM5T1Nxd20weWcvalhxUE5LZ0prNVZkeTI4TWRSckV3eUFaS0lPdXNXc0d3?=
 =?utf-8?B?MFJVOVRzZXlMK3dUdlR5N1JpdHNwUmdhcDNHWmhzaTNyam9pMTRYSlV4SEhm?=
 =?utf-8?B?L2F3aGZXUkdvSGNjMk80bEgwWkV3SnpmVENPRll2VDVjeDBVcmYvQzZOSWc5?=
 =?utf-8?B?Mkxob2M4cXc5ZmI5alZWa25GbXFKdmJXYXlIL1hTYkhYOXZxYkpaSjIvZUox?=
 =?utf-8?B?MkZRSG5RR0U4eVMvUGRqM2ZrNFE5eDFXYVhUQ3Nac1ZVRmRsWHE2d1paRjhT?=
 =?utf-8?B?YWRlZ05WM21WNkNaNjMyelZaUmpPQnFtVzQzYUM3K3pUczNRNDdoYkRxWHk1?=
 =?utf-8?B?MTV5eHBNU3BmY3BiVUNYVlZqNDFocFo5dlJESU5oNUlDdGc5ZzNEUnRsa1F0?=
 =?utf-8?B?d0lzWWxyRitPZDA1ek5Kdk10QWhHMHpvV1VMR0V0eTRKaVZGcEljVVFreXhK?=
 =?utf-8?B?M1pFL3FzQVZscHdiOXNPQlBFR2JvVDJOa2FjWW10SnFrR1ZuS0xyc2kxeGVR?=
 =?utf-8?B?UDNjOWlzUjNabkQ2MmVEQWpRQVBuTXVQQldIY2RnRHdJTkt3RCs0YktURGVH?=
 =?utf-8?B?RmhmYlZubWJOejdLRUMrc3djRVdkWVhvUzJibnJsZEltVXBoK3BhVjdHUkht?=
 =?utf-8?B?b0pVcDNlbjUyZmNibFd5amF0d0dRdFlqZWM0cU8zYUJmZG9ISjREY1dWc2pp?=
 =?utf-8?B?VGY4a1BNdWh1S2RtU0drQUtVamFiQkVqT1hQb3ExUUZXRnBBN3FITHFIZ1cv?=
 =?utf-8?B?SitoUkdUekx2UG1LdWRGMnB0SWtVMTc1OUxkK01zZ3ZsbjBySDg4NklJN2hm?=
 =?utf-8?B?Um9tMWFYeG84NjhRS2E3MnAyUEQ2S0NqdmxQVGgzY1lqaWhFdGdNMGRlY29n?=
 =?utf-8?B?OVpYeURhL1FhdDIxNDJBVGdxWXlMMUZwN3MxSjZTV0RDeFdCSGJLNWNDVmdl?=
 =?utf-8?B?eWFEYmJoL3NsOHFsd2hIZjlyakVzTzREZnYreHlmZzFkTFlwWU4vQ3hJMmlT?=
 =?utf-8?B?cFUxOWJuTUNpbXdaS3lIV0kxcWkybWtlLzNoVE9LQ0EzWWtHeW1tVDUxTGxR?=
 =?utf-8?B?cmVJTUlWY0xUeGpGeGxaSzR2VUhTY3pteUVybmhnVWJRV25KcEorY1AvTmUr?=
 =?utf-8?B?R3VUTExGUkVGT2lnUzhiUmlvUngrbEtoT25mc3BYVDZjZWZhbCtnVzU1RUZP?=
 =?utf-8?B?Vk1RZDNWSDZnMDlCVTFNY1FZRzV3RHU0aDhUdWFyclBsN1JwcHBIb04xL2RI?=
 =?utf-8?B?ZWErVHJwejNvbDFabmxiMHpFRlVNZG5GeThRSFdZc2tydFgxQjFuVnpVUk1J?=
 =?utf-8?B?dGlobjhMRDJhMHVrNzFEWUd1a1RCSGZRUmVoelRINWQ3SVU2cXh0VHE1MzZq?=
 =?utf-8?B?Z2dtcEJUVGhUQXdDcG1wd3hrVmpVMUo1YVJ1TEVSVTBGcm1YNEk2cmx4TjBI?=
 =?utf-8?B?djlWVGxvcHpvZFdOOFhHL1BqOGRGWjVLc2NaTFVpWHlqOGplT2V4bGdSNmJ4?=
 =?utf-8?B?YmhFWnVpdm5VM3hQTWtjMlhBYU0vNmJhQlRVS2o4RkhzYmV2Yy9kYmVWdmVV?=
 =?utf-8?B?MmNEcHY5SjRub0ViMkl1NGZWRGtXVzdsODNJOU1RSEs1R21nQXNBQWd6K3Zj?=
 =?utf-8?B?cDdrQ1VtRjhSWE1ibHF2S0Y2Z3djNXRjdzBYd1ltTWZ6aEZEN0VHSThHNG10?=
 =?utf-8?B?c0NtSkM2Qzc3VWRlNXlwWjJRSkJaWG15WS9MY3R4UGJMdVdFVE1SS0N5OGlT?=
 =?utf-8?B?VnA3dFpsWTNoWDVXS3d4bGZiaTBZTjAvbUpIaVVPWU5aQjVUZ25zK1g2YW9h?=
 =?utf-8?B?RVB5TmlxMEFuQUpJOTMvUENXYWhGQ054clpDaDVrY1lJcFkvVGtMMzF4aHp3?=
 =?utf-8?B?MC9McDZOZUR0R2pOcHFRV2NWY3BYLzVETGE2UTJKRXNGekJXSnNpUWZCU1V3?=
 =?utf-8?B?MW9zV1pDRWRDcCttb3JCRnd5alR2L2hNMFJ2elZ2RFk3ZTZIWTh5SXdiaU5L?=
 =?utf-8?B?MWEzME5uN0ZtaHFlZDBnakR6dkF0NkE1ZUxscVg1T3ZkZ0xpckdTM1hXZENN?=
 =?utf-8?B?THloT1MrdUc4amt1MFZRMlRsbEZKTmpEdWpDUWw5S3MySk4yZG94ZnhRTjRu?=
 =?utf-8?B?UGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 4U9IQmpQ5aSmKjqkRlBMtrCh4XHlKIYvMaXmuZT4zljlYRTkbs8IbgcvKRCh/fciPHpjbh6H45qRp2MGPdS+730tGFSSpyLPwlChOkhJhZbIfqmhoj4NFUsutk4CFQsmzgz3XYDRASeUJ3OEUztzKPGtkUy6KtXX/deg+Q1tzWEzEXqs72iJQhKDNAUDuLzBofzqNTKOFH4SuyrkI7qrdfyFxTc1aW00d3L5UPyVvCZkZA1NBnzk/xEu++Wcv6yGTfpeiMWEIRRD8aeYoXrxsJtnLfn91HwqTd8CDTSoXIxKvbtK5KeGmgud8M6JhSpkRJqfLh/QV8YKDDDOkG1rOvq4vouauzZ8L1eObrWab8k96a6sw6P12iwhEnBPl8rjdaHA3oQb6nnPhtOa6UE5HCyejx3QxhMotTwVqd36WNiD/oFgPAyTbzUD3fpDwvF49eYy4joWg5ESf/QSA+nijpE+Jc4AOCr+/x5Ot+ZRzZW5cCiAYa3PrYNm6JLxA69cKJXsYWCAoLQMGkmJFJrYdRPxqbi7u2Q7O/Efl4cF6Orh/OG4TtadvDgxDf0iZAA8Cnptj/dF9MC7kTLD7+VY0njXlIfRIruaS5+AoAfz3X7OBFEnwFh+I8GxpowPo0sZmlnr2+SxfDKx42d0f/5TaQqEnLKEF9jXdYfnMTTL1hs0QKOc9rk+zF66jlNvu+9nOeSRbXPYxVmN2wIHTXiBZkIlkPgsT30DejOKmQm/woN7tdcYMyDXeTFb4LqbkZF5R0Fb1PJDNi6wPUg+oUjSp5qO+SPUEV6rZdBG+S4o2moxEuP7Q04SLjin9oMJx2cl8+qxj2Ia5aGYg5FcxOXfu2NN7yw8r0Hy36AAzjKiHUk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b2940a9-fc2d-4d5a-0faf-08db28916067
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2023 15:48:25.8605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BgGoEeNb253AQRHajDP9XnDUXdsLWS4RVru1nV9cah81Ll2uxlduMH2B+y8s1a01U4JqoQsWKyOPu1zka+q7hd1Jjjvy9rimhS/Frd8qb54=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6327
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-19_07,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=811 mlxscore=0 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303190134
X-Proofpoint-ORIG-GUID: HNr8OjwNWCiKMzusfvRALXHdH6RCHI1E
X-Proofpoint-GUID: HNr8OjwNWCiKMzusfvRALXHdH6RCHI1E
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/22/23 6:19 PM, Mike Christie wrote:
> We don't need the vhost_scsi_mutex in vhost_scsi_port_link and
> vhost_scsi_port_unlink because LIO has a refcount on the se_tpg for us,
> so it can't be removed while these functions are called. This removes the
> vhost_scsi_mutex from those functions to avoid cases where we are adding
> or removing LUNs to vhost-deviceA but are stuck waiting on the
> vhost_scsi_mutex because we are running vhost_scsi_clear_endpoint on
> vhost-deviceB and it's stuck in vhost_scsi_flush waiting for a flakey
> physical device.

I'm going to self Nack these patches. This patch has a bug where we can
leak vhost_scsi_tmf structs. It's ok to drop the vhost_scsi_mutex use but
in vhost_scsi_port_unlink it needs to be replaced with the device->mutex
or we need to flush the tmf/VHOST_SCSI_VQ_CTL queue to make sure outstanding
tmfs are freed.

