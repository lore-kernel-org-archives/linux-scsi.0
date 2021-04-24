Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A240C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 21:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE362611ED
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 21:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbhDXVLt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 17:11:49 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53076 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229778AbhDXVLt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 24 Apr 2021 17:11:49 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13OLB7id023758;
        Sat, 24 Apr 2021 21:11:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=aSZ8jRFbrSwQw3tnTwxyXPSbRWYrPbet72WdpYGNJEs=;
 b=YbnM/R3/vZK4WbszAhaxFgU99vv7MV69cpAZ5Ni+PSY5u8v5JodBWH8HqxU6YMZ4EwX9
 ULdrjErg+TcxeNluolcv9mHZG6pg+YJVxQ8udkaWvzDm3kfs1FxzBEKmY+s4jFIkPrTD
 DQ218bhVRDFfoLgL9GlIjQoOuwDZ/alML6m3SOo2CAB97uTvt8q+ZlH12lU+A8espO+s
 eNsNCCaX5dU5Fi7ZONr75+6Jaaft/waFefhLwV5QaGOnKWY317MX4dkQrj9LcNUwCImg
 ZR8Ch/chZzHhnN5bmeQKA8fn5TiaMEjQHOJuW1XGyUbinXW/K6qNFa1lQIjAAE/mjFUo 2A== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 384b7806u8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 21:11:06 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 13OLB5X2161310;
        Sat, 24 Apr 2021 21:11:05 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3020.oracle.com with ESMTP id 384anj6ubv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 21:11:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lmWGDgVPmSTJkFW9WM1xH7x5tay7NdImz8HmrwxZgjaj2xcwiVCvxTCJr0Rw4+QFC//dNf9Q7k6XJVhtRddxhUYpHvL01901CcBzQxKSaiutnzsjfQPM7Ur559Ey55IDmfStlEgm1iYe6HfZ51rY26b9BTrTDRTsNqncQmhBdPZGI7sfLTLtmdDeZILBZn8lhw4Wry7IC2vvXoFSS4xQKba7VBCZ3sGl59+fRyV92AIilFyutS7yL8hT+btoHPEQk9MJu3FTqL6V+uxUgVffG3J0rHh/Z6kyZLMIl0Otmoty3stxlgObxLrgXAUdM2T+kNkHX0lLoiv/Acd/YT5Vxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aSZ8jRFbrSwQw3tnTwxyXPSbRWYrPbet72WdpYGNJEs=;
 b=c2v5WOH7PueJzvvzHSztrjWdRZUfLdEPnjccjqkiOsxNip3tFcLSn77NLd8ovckmCZntAElW4gDrVYnzloC4vq/clFqlKkjhWNA/BW6MYLKevsGkXjueelMPCiCtv25JtY4ROUQ3osy3KjkNTPl3KQYP2gnOOxg52i7BDThkj9h9hI5Q9plGm5XAXciCOcAO2xId8Ih4Lo/St/hnhaurEMj/h6Bk+th3MxXxHWQUS9h2nyvkbBI91tGjeh8Wv6TLPLi+VTolK5mm95t0vzT6h4oDFgzS/+YyipJOc7H/Fh/AFPFGN6WKm9rCu7WwiOxshQU11tmw3Kx2CVq10WHRYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aSZ8jRFbrSwQw3tnTwxyXPSbRWYrPbet72WdpYGNJEs=;
 b=DQQbCBiKptsSGgYcuIx+nVyr/cJvJ+9EZWBo/gWAh0CT8pslDguJWDqS4cYgKtqJ75qD6htBpLfROMKVQxdGf43W4PaFVO7Xct4zq1k6mkNuQh0eAV8dkOB0IB3cRXrpAumaJUtWuRbSbDCyoYBLoFGUbmwh6ne2Qj6xqClimXI=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2807.namprd10.prod.outlook.com (2603:10b6:a03:8e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 21:11:02 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 21:11:02 +0000
Subject: Re: [PATCH v8 25/31] elx: efct: LIO backend interface routines
From:   Mike Christie <michael.christie@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
References: <20210423233455.27243-1-jsmart2021@gmail.com>
 <20210423233455.27243-26-jsmart2021@gmail.com>
 <3d7836bd-04e6-e3b9-66c8-05c66a82d105@oracle.com>
Message-ID: <1fd66369-4916-0a45-7a8a-1ddb3717f2ef@oracle.com>
Date:   Sat, 24 Apr 2021 16:10:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <3d7836bd-04e6-e3b9-66c8-05c66a82d105@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0107.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DS7PR03CA0107.namprd03.prod.outlook.com (2603:10b6:5:3b7::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Sat, 24 Apr 2021 21:11:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ece61846-57ba-4381-a443-08d9076576dc
X-MS-TrafficTypeDiagnostic: BYAPR10MB2807:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2807EF821C07776F6DFE8AD9F1449@BYAPR10MB2807.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zVsROQ+rix7lBfYpDBqMl5qhgRF+tXiUOo7kijyIuVvnCfInthLBnZ19jPzid92pY+jDL1PkVQOIYZXj7bMa+7c5qfbaHSvqpbvogATaHya6Vs6+0JUlrCV+4sDITzYShbAIZGQFQp5HQheOy+cxMedAHDVMHg3lwTdeww9IaJcbmc9rK/KqFlY7+nDTsEkMIuHpGEWfgoD92JTEhBRYzTEpdXu1PJBCalxeitqY3T5P01fq5tTDnY+wnx4awJpcIups66dxprlA2fJaMW8gFNNoBgQdvmi5owXmiZC4c2jS0oQ1/IKua690r46z87e51BdZI52Ie9vI8E56CwZm3twGM07RczU4IZXXQRFRATUoepQJivShaoacm1rxg/tRABCYBwNGRIriPQeFDa8GO45z0IcKFuLR//MDrpfTeCm1q09g02agoQ+ZNfUN66AqLWQbdpPWfZxfirW0uMqn7SYJCHgQmxjIKoJ52uDBVQvyVNg2RL41zEZaczXdcw9XFtIIYwSz2VQShpOiLDuABd13KE90+7xdC2fDttBvgVxoowz35fJcjJwpqsXjmW61QDRbkNHvGCF/kfqQdMh/2s/IUTfoY2Vu7e63LSRSOqqBpNrgog8XSx8gLQVNCkEkq0/hJK5Rxrhaq6IxAyS84cJT6IzFKrXTwMoshvI+6XNV3uJ0G9ox90cXPZZc+ZHpv6EbKiZ39+aKUHbx+S0r4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(376002)(346002)(366004)(31696002)(2616005)(26005)(8676002)(316002)(36756003)(54906003)(478600001)(6706004)(8936002)(186003)(4744005)(86362001)(956004)(31686004)(16526019)(5660300002)(16576012)(38100700002)(66556008)(66946007)(6486002)(83380400001)(53546011)(66476007)(4326008)(2906002)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?U3czTll6MmQ5U0xobEc4UzJZdkVXQ0x5K0crc3dmM2RGWjNDWDBNZ0dqMXlt?=
 =?utf-8?B?TTArU09pUFNkTVJnSEwzak9lNFNSTFBOWG52b3VRNnF4R243OUMyS204dHRV?=
 =?utf-8?B?QTREY3BXcXNjaEtZb2Njek9NMEVuWEh2M3RPNVBBMFZ5dURYVVRjeG44SVdR?=
 =?utf-8?B?L09wTUYwWDdiKzBHRU8vazNFZmZZOW95UkhsV0srTzRGQ0Mxdkx1UStRelUr?=
 =?utf-8?B?bTdOOC9wald5eEpqRHJ2cjVFaDRaY1paRFFvQ1ZpMmZMN2Rmd3d1Y05vWnVo?=
 =?utf-8?B?NzlEMlVJWUdPNUdOVjJuUmp2QXpwdlA0Mm5DeHRGUFgraTVQaVNaUXZWLzZU?=
 =?utf-8?B?SjZiaWJFRFZQQzFsSVdWSytDYUdQU0thU3RjWm44eUt0VVYvTXk4eHc1amU2?=
 =?utf-8?B?NFdTL2FxMmc5S3NCUDY4cEdvcnpMVjI5eG52TWRJdmdXL1JETnVXQ0IyVVNS?=
 =?utf-8?B?bnJzT1BzbE9QQWprVkxVS3ZXZWNuZU1XMnU3am0ybURjdFFQdHZjYktFS1By?=
 =?utf-8?B?R1JKMDJMcVIzVUsxaHBHc2RTc1RYaW9DNHRBMkdJT3dIRTgzWVB0WjJlN2g4?=
 =?utf-8?B?T2FCb2pVRVVTbGtZdVJjOS9kMGZEY2twZG1ySTFtSmt4TklYdW9PaWxtM2pl?=
 =?utf-8?B?YVJtWmcrVmhUKzhVTTQzSHdoZ3BMdSs5QWZkbzJDMGNDWHN3NE8wbFdvZS9U?=
 =?utf-8?B?azM3RjVyTytJb21YRnMzMjVwZFY1QVNoR2pGVU4wZEhUL2pvRzAydkw2QWVK?=
 =?utf-8?B?RVgzMWp2clNFU3A4NmNnYnZ2SVk0S2RyOG9TTlQxdnplNVUrMnhCbEUzTzR0?=
 =?utf-8?B?dmFBdXZheU0wcGZOWUgxTkpsaG5RbU9FK0xwS0Q5Y3RmTElBRC81U081WVU0?=
 =?utf-8?B?Y1lSM01zYWxreGxqcVNpcWlNcUFGQStPaXFUKzh6OWhwUTI3Uzk4alhtcVc3?=
 =?utf-8?B?K2Ria2dTOVo0UCtuS3JhRWdKd2J5VVl4MlNyLzJiTytBbllxcWRLMlViMDg2?=
 =?utf-8?B?eUhtV21aelZvWVBFYzNoVGo5c0VXaWx4ZzVkL2JPd1hDTjEvSnlFUFZLMUta?=
 =?utf-8?B?SlZpMEpBS2JHM1B4TFptSjBieHptVXBoT3dKUkhjUit1RFJnR1ltVTkwV1Fa?=
 =?utf-8?B?bFpqRFdqdzNISGdQeDFPdEhSTzBMWnZaZTFGZlJTelZHcXoxcHlpaDVjQTdP?=
 =?utf-8?B?YmF4SG1WcHlheDh6RTRwR2FGY3d6Zks3K1p5WkVJNmU1NVNucnp0NWZKd1Ba?=
 =?utf-8?B?aHdtYk5hZ3g2eWpuZkxEQ2xQb3pkM2hxV3JQZGlCaktjb2RBOVlHZmovTk5X?=
 =?utf-8?B?bWZGQ2I5QUd6RGoyb1ZkTXlFTm9taHlnZWgweXVNaE44L2xwdnl1TjJUSjNX?=
 =?utf-8?B?bmppQWEra2ZSclh0cVZwTUhGcFNHS09Cb0JtR3F3SHhEQ2VnQyswRWt4b1o0?=
 =?utf-8?B?VU1DSm1jcHhaL2Z0am9Tb2drVHd2UVJFTmZMUGFmU3RsM3drZVczY1FCL3pB?=
 =?utf-8?B?cVVNWVRrd1dVeVFZdXpFM3I3Q29QRVBrVU9VdXB3VVpqZkxxWW53cEFYVjcx?=
 =?utf-8?B?cnVwaW0yN3hMY1NSK2RFeUVSajJMZ1pTL04xSFVzODB4V09IZEpWZTdTT1d1?=
 =?utf-8?B?ejZCUW5DRXNEbVc3bzlQYVcyeVU1dGY3NGVtbHlUYTJzOGtxVXpwbXRNU1hN?=
 =?utf-8?B?NlNidVB1Nk9uQlcyMTA1NVVoakNLbG9wT24xbmRvaXJGUG1UZzBYdEdXTkRy?=
 =?utf-8?Q?rO6paJm2+rf83in2z8SQ3VXxaOJ8YjNflZ3LZm4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ece61846-57ba-4381-a443-08d9076576dc
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 21:11:01.9107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RSBBG1693elaIUZYewHK9X+dJu9HEnAESlwh6Yb13QYVgVCMO7t/hdyuzTsDKlrGmnDTRdvYo9ppelZM2AV0rey0PpTkKNWaL8ojx7z0lcA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2807
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240163
X-Proofpoint-GUID: pcBlF5I9Bk3m-_NA-xefrRC4BIRZoE9c
X-Proofpoint-ORIG-GUID: pcBlF5I9Bk3m-_NA-xefrRC4BIRZoE9c
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/24/21 3:34 PM, Mike Christie wrote:
> Or could you have something like:
> 
> efct_dispatch_frame -> efct_dispatch_fcp_cmd -> efct_scsi_recv_cmd
> 
> running when this happening? Was there some place like here where
> efct_node->session was set to NULL and that's what we try to detect
> in efct_scsi_recv_cmd?

Oh yeah, I think if you can still have IO running from inside the
driver you want to move the target_remove_session call to _efct_tgt_node_free.

We will then handle the case where a cmd has passed efct_node_find and got a ref
to the efct_node but not yet reached target_init_cmd. When the cmd hits
target_init_cmd lio will return a failure, efct_dispatch_frame will drop its
ref, and then we will free the efct_node and lio session.
