Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F3BC433C1
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 03:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9855A61A2A
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 03:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhCZDev (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 23:34:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55398 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbhCZDes (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2021 23:34:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q3QJwO135108;
        Fri, 26 Mar 2021 03:34:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=tfvFp5AG9HnwJAAJxLg65PNIzSHF7VNN+EGr4Ilkjf8=;
 b=Avu1KYCVH1kRX5PzyN9sZGTnKyw16U2WqmXbxjmERZq9Jb11GTLzVX21TkrWYwsUvmsN
 KZQgL6iBPjgxWIVDDXVvapDUQiinDH+LwNibT5/bvAv5pcY5riv4W0eyZCNUDpgRVp9K
 yHRrmQEZf/197HZMDa3cT2YLAWtdx9nGIblOHIsVw2GbsEaVN3BADDvfvQ8qX7GWMVVp
 9AQWTpxcv8dQ28Rt0owR/7PW5oi+07mMMmytM6/CsbvhKmCLnZmF5CZUx2Z3o0Q/QTmy
 iy6ZtA2Z7eq6vcyAiElkBwErD0EXxcw3EhPOeCV6/hGNJaZSXm7l/ILTglGy+riWrevM TA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37h13e8qqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 03:34:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q3PBdt162385;
        Fri, 26 Mar 2021 03:34:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by userp3030.oracle.com with ESMTP id 37h13x53bf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 03:34:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVeu1v0Ykaa92z6kfGgg67cL/BUJLfUOw2IUBWxGrtdJQZxt0v5yS9E/lGr5YzccvCZW0mLQweL0iIjz8W50sQQ9w4IiAba95IJWeqRK/qLx6Li0BYTW0+qtAe7qsPh5LDyW3zcJ+RcJFqZNqLOpdQI01dNNw2ObV6/9Xn5Yh8dOnWkXg/eUuQcuKhR5KQioSyFGnI3S1liz+7Tc2pDJNPib5ESVkUhkUBAb7s5HEe0fp8W9QDO7UQ3Nm0uygyXY9FlDzbMcu+lXeh+YPrnEQctmSySLCLzLdtF20taMEknq27T0Kat1xw+M+3EkyCgS9T4Eksco71M5wAj/rwQu2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tfvFp5AG9HnwJAAJxLg65PNIzSHF7VNN+EGr4Ilkjf8=;
 b=GKQNebsg15w/MPu6U/JmGqkbqyutXlfapGWJmrvhpBXkza1Iy//dQz7H8Q6hMLTibNSiclZq3a/zXxs0RTJbbID1KSmBRYrRkpcY9hBiRW1gqfRWlQGlDWdoKQn/3heNZWwQrmx7RxNOda8LRXLeO96efK5Eo5KYpuyiy8xt0qaE0tEU5JbgUdguzuzq2CwW0xOutXTKnbBWlTeaDy96FRbs1FICScwwRqc3919Ja0EKHHAXURTon8TGY9T8H3N0MPnDOqcfAv5wZnAUH5XKvtJRz/HABHgB36luvcOghm1cOyCpkvzIS7sKBxB+34Ol+EtH46kwHjXmrOdSsDbaKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tfvFp5AG9HnwJAAJxLg65PNIzSHF7VNN+EGr4Ilkjf8=;
 b=nqADl1b6v+JO9f+46Ew0UBxK3Pqo+T9k0CGnOLH2KbPYGVzZXf0XuYfXC28+mkS1g5ZOU7vtb6EVYVI1dYoKzuLX9Pei7iXEi6+yKcvI7XdMzOxBCGOIKRS+9DEmr+WpgP2KLPy4xfftHiqPNw1CHpHh7JYMMWp9AlZwZJsY4pE=
Authentication-Results: embeddedor.com; dkim=none (message not signed)
 header.d=none;embeddedor.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5402.namprd10.prod.outlook.com (2603:10b6:510:e2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Fri, 26 Mar
 2021 03:34:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.025; Fri, 26 Mar 2021
 03:34:29 +0000
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: aacraid: Replace one-element array with
 flexible-array member
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6qqk68h.fsf@ca-mkp.ca.oracle.com>
References: <20210304203822.GA102218@embeddedor>
        <yq135wkm410.fsf@ca-mkp.ca.oracle.com>
        <668e3f30-1ffb-31e3-231b-705489993885@embeddedor.com>
Date:   Thu, 25 Mar 2021 23:34:27 -0400
In-Reply-To: <668e3f30-1ffb-31e3-231b-705489993885@embeddedor.com> (Gustavo
        A. R. Silva's message of "Wed, 24 Mar 2021 19:46:35 -0500")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY3PR05CA0030.namprd05.prod.outlook.com
 (2603:10b6:a03:254::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY3PR05CA0030.namprd05.prod.outlook.com (2603:10b6:a03:254::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.16 via Frontend Transport; Fri, 26 Mar 2021 03:34:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9d92572-e27a-4815-113e-08d8f008103f
X-MS-TrafficTypeDiagnostic: PH0PR10MB5402:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB540266460FA698871633444A8E619@PH0PR10MB5402.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QV71SXBWZt3ExBhnz3LX2jwKMp6ibyDyAN8m3NrswvkPLxZHs2hW5I7kiRjepd7RlQ4d34J3fjyKQkso2zljhEUvi+RwsvfpVC8DGdeigc8TQTt/zL986FxhIo++7cqzJyA4w5Ckhk2gvQodr/fJPh8bxLzlwVqeI8fleALZt4voqjKXOWOlt2rOBydXnITOKkcjN0cdw4X8tpeDSI+rhliSBfz+u9mMeTeH3nlqu7qq+gVf8O8se3R1sSPgTEg2FnxxCj6yhC/ICI1JfPbHBGFsWyke4nK7bZ7XesQXJGY2c1mUteen4Le/q/12VFS2bwxDAjqUJpVYHc2weVCnoOmdilOCdk8X9sL+bMJlUEGl/45bGbzUe4iI3uUEucvvoJcYi79PMDCPeXvuqAt3HxaDJWdq2b2e8sH5DxoAfLQTfmH0zHnl+klJhPdaiI5Em3NbPl2fFazX5e9A3w1y6CaatbqTy06XhEA4peqcb/Jp3WS/dWU6G4uq0bfA/mQAglj8o0Kaa7l+gsfjurYrqK+d1ws8q4sejDtpWmjYz3wXvg9E2jkGZ6MfJu9rkraY9ZglwBjrSaaHAoUU1MIVWJXZy3Bfqpj0n6hqoGsZ2JW+9+76vMo5ksGD1dKAMEnd7wr1JZxtPvAb3wPUrf0b8ao1EiQ7G0EZ1U3vblKMzK4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(396003)(136003)(366004)(26005)(38100700001)(186003)(316002)(36916002)(16526019)(478600001)(7696005)(2906002)(52116002)(54906003)(83380400001)(86362001)(66946007)(956004)(66556008)(8936002)(4326008)(6916009)(5660300002)(55016002)(8676002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gXsuPILv1ch+v813vMRquH1nZYLjG43MuFmR90sj0U/KWv+vr2AS3jvNRqBo?=
 =?us-ascii?Q?z/7VgTikJuj3YFSH8vypXI/2Uzgf7wQ1J3pZq0e68W8Sn98pAV7HHkdgVqcW?=
 =?us-ascii?Q?UzbloMk0pKLQwmZ6i/rzHj3xQKCEoEOzW14ULjj1GK/xvSd0lAZi88rtdovz?=
 =?us-ascii?Q?2fT+jRFaozPuIFPNjk3m02i3vDqn9ZJRqkhgR24t0k5fxsJ09VFHXGnPz4qw?=
 =?us-ascii?Q?sm7MxWSshedz8pZZbwT3kE/atYpM7qrIA/3jSq51AcPJ8WSrIkJh/nvYdhYp?=
 =?us-ascii?Q?6on58ysWz8xmfZxNq/uouY05yCWg/WEi6Td8m5Wu/Zr4gyXRjMWf9MwgxQtf?=
 =?us-ascii?Q?CkdFDnScNpVa2jAdqJGPZV55nw+Pft/UUpg9zlW8xp/GGEBIeYAE/t1oIhed?=
 =?us-ascii?Q?PTVg6FdvH2Ai4p95Y8ongGfZa/LeLT5f3BRYxHuPHJ7trq+6iXVzJfJhrHvA?=
 =?us-ascii?Q?DZW9k0gZIO6EU99pADmQb1gJIpM8uvgtaWYDw2M3JaVUam2AZ4ninw+1yObf?=
 =?us-ascii?Q?1WMSZAVQ002Y9HUkNtsXdNSyIF620qsMf8woO66nHOmKuGALtr+xJPDLyoJm?=
 =?us-ascii?Q?79qnADooFggkIHAHqAPY0fxtPVczP1rGkiMqFbeWnAXCG3aKX74Rw3Wd/amb?=
 =?us-ascii?Q?wZwGRkGwlQLa/doWdZiqzk+ZMbJIR4UtndXcFqiik0p//WwpAVALv2ZNokja?=
 =?us-ascii?Q?nL8tLdaxtPMb9dRU6WWRt/jtL5LBsB0R4sJBSHttac/x0a5WWxKt+CHfRzjm?=
 =?us-ascii?Q?5lpMe6zsvXoIryHGfyju2dglhZJ1tzfuBt7BlMWMiD2Y/ZhSybUFfrXT83On?=
 =?us-ascii?Q?UP+U8naETFBcwR+j15vt8RuYNOVKKneeaPx1bcwCL56w/lcOBuDs4sgOg4gT?=
 =?us-ascii?Q?RDsR9X0imAVINuUnbGI69m1aXf6oISohu7Fy4PkPgP5FNslrmdRjbpw9aupS?=
 =?us-ascii?Q?dRqsBeCP829IxqcbFlWrPDMOaULKL8SxDDEZQyK1aR3/UmY+pOkd9YteGijg?=
 =?us-ascii?Q?mxOdwCLHQTo3gihBk2aaccSOCiA7xoLMF3nZUK+Hw9tNAIR36BQ7M7Qp0EWT?=
 =?us-ascii?Q?blp03rqomEhL0j4lWbV1az2/ZWwMQ4Ey6TdzBYDxNH9zM6jodtEFNe39B4kI?=
 =?us-ascii?Q?XhWBHkayr/PHWjiD9MkbLaB6BLiEHSCv7qKUTfqEPZ1e6xsRbq398hebekP/?=
 =?us-ascii?Q?rg7LeZwgeyVYTrF7Y94BB/GTsnX1ws4lpMFtdejkFs94ibEfY4lcJSNGJ/kt?=
 =?us-ascii?Q?5frn1ZaYO3sAYxeuXsk9GpinEf0ZAujf8fuNQ03RZuxS2yPB0qCV4CXpIYhp?=
 =?us-ascii?Q?yyv2LWrketIC2LGq3yY79d+P?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d92572-e27a-4815-113e-08d8f008103f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 03:34:29.7003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Wq7GkQfYaN8otWdswpv0BDlM+7BfqOxLpKVNSp5J9HtScPx3HsJW4IFfRWkANOJ7Zh+g2CE/SPGkw6bCYcJ/VbKViCTYLdG9iETSp9ddpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5402
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260023
X-Proofpoint-ORIG-GUID: LwhDs8p2mqNm9U-2Y52pkEB5ESFpQfwg
X-Proofpoint-GUID: LwhDs8p2mqNm9U-2Y52pkEB5ESFpQfwg
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Gustavo,

> Precisely this sort of confusion is one of the things we want to avoid
> by using flexible-array members instead of one-element arrays.

Ah, you're right!

Now that I look at it again I also don't think that was the issue that
originally caused concern.

@@ -4020,7 +4020,8 @@ static int aac_convert_sgraw2(struct aac_raw_io2 *rio2, int pages, int nseg, int
 		}
 	}
 	sge[pos] = rio2->sge[nseg-1];
-	memcpy(&rio2->sge[1], &sge[1], (nseg_new-1)*sizeof(struct sge_ieee1212));
+	memcpy(&rio2->sge[1], &sge[1],
+	       flex_array_size(rio2, sge, nseg_new - 1));
 
 	kfree(sge);
 	rio2->sgeCnt = cpu_to_le32(nseg_new);

I find it counter-intuitive to use the type of the destination array to
size the amount of source data to copy. "Are source and destination same
type? Does flex_array_size() do the right thing given the ->sge[1]
destination offset?". It wasn't immediately obvious. To me, "copy this
many scatterlist entries" in the original is much more readable.

That said, this whole function makes my head hurt!

-- 
Martin K. Petersen	Oracle Linux Engineering
