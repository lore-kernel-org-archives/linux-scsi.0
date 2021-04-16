Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDE8C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AC16610FB
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237946AbhDPCwM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:52:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53108 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235043AbhDPCwK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:52:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2p2gC165353;
        Fri, 16 Apr 2021 02:51:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=7F4PrxKeUznZCOfJ8MbWD0BzirAHge95RdD7/Qh3O54=;
 b=RA2lyXWNPoFkzb8FohHpsfCp2ZhmVXlzmLtL/lZaTyy4IbrcBWf9Bov60J/v/aH+WA/4
 zMJrwr3A/ERv11DksMjAXqV+8Mi2FEoycOWWisoLxMjfND7Z+FbOpfdTahzJfGezz1Sx
 LktdqmAd04byu/olxZbPbM3ZunaCC5l/JI/IC2MkneQ0Lwj9wEmF1coTYEcFvpP0e1O4
 E1U2IPQM8ZzPqK4agkLma7EHRgd2QlcROmSKx67fy6mzKg3Flm/jSKFWxd5Ow1KfNJPe
 WIgt1d6OGJ98CKXVFbVpaognNZvEv6O6wXkPpQkPsCZuLkffUF+8O0ucA1W6Gu1+A250 kg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37u3erqr1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2oeFh162577;
        Fri, 16 Apr 2021 02:51:37 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3030.oracle.com with ESMTP id 37unktgk4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hA4QLleL1dDNyjKrrBR21we+Ujatqs/B9OUhrUYU4ozt+wskwFmGjSLWD8A+OntpMf3b17KjDh8v5xhSvsACp4XJjnVEB7zxo7bzgqK+1v29+0nbh5PGuqC1DG2Lx7bkw7wihNme4CDSTkh2OTSJmnolNZL96V9VD6n3SYAHLBxb4PavRvUMbB21cEx0884e0T736oDynFLu1pffXX+xZaO98gpXxuIUYldC1vGtNlwG89gvIXy2ghok12FTnQjTxVhMQSzIOHTkFMFbOTEqUTjkCVqE3tX/dkIABr9wTzfW+J3FPaQ+HdxDRLVJgHuEIHB6/R+hN0sRULIo9Uyfjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7F4PrxKeUznZCOfJ8MbWD0BzirAHge95RdD7/Qh3O54=;
 b=mtb1allUWZyocZ9weqkyHCDmHf+IAxujTEQWTASmthrbcNpBT6ZZM62tiZspcDH5x0wwzFvKzLX8dthlexEfeURiGtknSvuk31z4TRigHrCgHrQUoKDQC1e7RO2ppJjsGLrq+TWVNo+8NHbMavi4+M7ZF4HbRkP5vmLFVzUsnbm7hwTW1AhwaSQX6YTH9QJmrv5XXCkSX228hcUSOtn1DyUQDKqKzHVVbRvY16nTC1BvdIj3mcicbxjG2/JvExdhzx/T/SHLix6zCQJ6kQ6SdgzC4bolHYIC0s4KLFukYhh7xLavsfx0+t91vuc2AT3zkS2jCTWIzsw9qZEW1C1dAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7F4PrxKeUznZCOfJ8MbWD0BzirAHge95RdD7/Qh3O54=;
 b=VUl4AM5DDYmMpWkmw+xH4UnrSjyVZ2bf7El+V+IB+TR4uAIQnA2VDbXs8xyOkFfy7hfBooPhW3PSzuRJR4WqZqCS4HjrXZrHzcrckxDNidAtuXTxA0gdbAfwew0rlm6YoDdlrwbwP/kiEVx0RjTsNuJB0innL0tA0oA5YeQPpfs=
Authentication-Results: cloud.ionos.com; dkim=none (message not signed)
 header.d=none;cloud.ionos.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 02:51:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:51:28 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>, linux-scsi@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Colin King <colin.king@canonical.com>,
        Viswas G <Viswas.G@microchip.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH][next] scsi: pm80xx: Fix potential infinite loop
Date:   Thu, 15 Apr 2021 22:51:06 -0400
Message-Id: <161853823944.16006.18266702142826369298.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210407135840.494747-1-colin.king@canonical.com>
References: <20210407135840.494747-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:6e::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0023.namprd11.prod.outlook.com (2603:10b6:806:6e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:51:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b98ddc06-da6b-4452-fb66-08d900828825
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45682767F34B17C9E87907EB8E4C9@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 74LFkSJpaD37br3Rk1wyHr7mnuz+5dwPhU8Z34AUrgPDnwaNwbSycJ/aiT/Zz3BwUwkMt0JQBA2xq7p5taTNterK2b9DYpVKYpIErpV5saWeESAg8cMHaL2/bDxAVEwIUJVuKKg9GIXTxlLfA9RuBiUh2LvP0SaCMzl9/K+/bMfAOK2f/qz2c2f+W2mNXG8hDcwlo1emb/hn9dqDL2xxvVnVCkRJTVHj4W+c9qN7TwYRb7AxKoptrtaWLukoMhIK4WMlq8iaftLxYsvqdCTuG09dnX7aAuUUJ7qR7LQEv8+FoC+heiKF+PS0xdYwZZ9e1uUXTm2cvt1Zzv+1w3+RUla37pWG3nXjAmQeIy23ODZm/2HfU9jyWuyTNXaUD09XBnEfcuT/PiBmS65PfTlS2gcw52nxqor5QOzNAZ4+Yhh79dr1WdWJT/aUXftwN4UPApMvbM3eaAmkh8+viksdt+9dFvdCfYZrUW3o5qyEjpzCoSuLV0vqYW8mkjEPztT++YHvBGP8qW4lPabZX3CZKsMSyZVZww7h81F4lN9VOG5sCCYTpRwIFhknk4qpNYYN3wPqsa+S7ZYw2evbtA4r04dqPp6RC7JzuJVd1O4wllJSQQXNHguZiDnjy5Lz6FL9PFdSCNe+s7YC7cq6jVCZlc5es0RzBOriyklMLURE2cBWGiXqAUbQCVtR8QTMnDb7wxgfP68YUR4hRoyfyj4l76A3+0vV1+33/u5b7O8k+H4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(376002)(346002)(136003)(316002)(103116003)(6486002)(5660300002)(478600001)(26005)(2616005)(956004)(8936002)(83380400001)(16526019)(66946007)(66556008)(66476007)(86362001)(4326008)(8676002)(186003)(110136005)(38100700002)(38350700002)(2906002)(36756003)(966005)(7696005)(6666004)(52116002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VkxyR2tUYW9GSlpoTThmcDdXem1CY294UDlYNEVGZ2QyTFlyaHBjTmxieU5j?=
 =?utf-8?B?MnBGQUpXWnhhUUtneXU2TVRGMnlLajMrQVZ5elIrbEk4RDdiYllpNjA3OE1T?=
 =?utf-8?B?SDEwYURPODcxT3pmaEZTRjlmTEU2UXRzWVpnRmcwbFhvOW5tcUpyZjZDbHJN?=
 =?utf-8?B?RE9QV1hKZEZmMyswMUZjRWpNNUdCamw5R1psS0t3aVliSytua1A1K1ZXOHJx?=
 =?utf-8?B?WVJUWGhxZE1tdGNkTXRUTWk3cFlCaEhCbVpsei95aEs5dUdSVkYraVA4RjFz?=
 =?utf-8?B?V2ZJLzBuY2JBcHQxNVJvWDFnd3BiYXlVaWNxMWMzMHgvOElyVWpGbDA3ZWtz?=
 =?utf-8?B?c1NjT3V5dW5GajVYZkNxdGtHdUVqdXpoOWN1cGVmanI0U1JBVi9xZEpFMTVx?=
 =?utf-8?B?UlNRMEZRWVNTaittajc5blZ5YjFadWx0VEV3dkFJcjB5ZnljM1lBeEQ3K0Zv?=
 =?utf-8?B?bnpxYWhkYURhajk1cXZjMnlQa3o0UFNlMkNKTWd3anNWVS9LMC8yQWhHSDJS?=
 =?utf-8?B?eTZ6ZUVJQ3AyTk5QcjEvQm1ZV3V2QzBibUFqUkNlUzJaek9iV0NsbWdkMmxn?=
 =?utf-8?B?cTU1SUFTOXNBYlY5cFlzb0psd0pEQUVKNUYxS3hJTm0xd2I0WE42VXV4M3VH?=
 =?utf-8?B?TzF6b3ZrKzU4REdZWEVOWmpma2JpTHZ3WkEyd3V0cWd6L1ZBYWprV2RtaWFa?=
 =?utf-8?B?OHgvem5yVjF0azR2QUtvY3RuejhjL21obHdaMGFDNlpUbm42ZDVUZmdudGNw?=
 =?utf-8?B?WDJUUUdlUy9IZ0Uwa3crZDUyRm90dFlYVUZ2djNGRUYxUEJJbXVJNm5rdHR6?=
 =?utf-8?B?Qml1ZHpQcE1QclNNcnhnTnA4WFhvTVBNb3loM1VzR1FzU0s5eUJNdUhWZWcv?=
 =?utf-8?B?RnpYVW0zaVZacVh1QWc4VExvMEx2VjREYWJRZE9oWE1SK21DSkoxVU94UTF6?=
 =?utf-8?B?R3h0R1NYcTRXcHJNY09XNWhFOUpKMFkxc3MxTWl6Nk51cS9ObGIwaDcwVHJB?=
 =?utf-8?B?UGw5dG9BNVFWY2dqTi9iYXpjazAvK3Q3WHpDMEFKZ1N6WHMwNG5Rc2JwZmw1?=
 =?utf-8?B?YW1ENzdaYzNBMHFFMUtOaWhaNTBuM2FKajFtVmROWmpwY2VXU3dGSFdVYUtY?=
 =?utf-8?B?NnNKVnZEU3huN2ZOOEVVRFJCcG5TdDhrdjBqMkR6YmRZZXhYQkxmWDhnMkF0?=
 =?utf-8?B?aTh5aDlIa1VRYnhvSWo1aEhQcjJvRFBPS0Z6dVMrYlcxc1F6SnpPQkdQZEtk?=
 =?utf-8?B?SVBveGF3S0UwMG1NQ1hIdVM3Uk5Bd1k0VmRBVnQyOWtuV0VyMDdIdndEYzl3?=
 =?utf-8?B?dXNOOCtNL3BGNVcxNXppblQ1Ny9Qd25tcFRWbStLK2hTWDB4cFc2dkIxZEts?=
 =?utf-8?B?NUo1Rk80eXFRdjhUMy94VmEyQkZzZTkvbDF2aVk5RkxNTnZVZGp6c0QvRnNM?=
 =?utf-8?B?S3VxakloM3dISW1iR3VDSnVHKytDcm5mZ3lPRFJubFB6dnZqK1Foa3pQM2E2?=
 =?utf-8?B?WXVhWWpld29ZeG9hbUs4NzZhcTE1dndEZkRXbE1rL0VwL2ZKUmduOXV1aW9m?=
 =?utf-8?B?MlB1Sld2a09sL1k4ak93cVlRUzN5dEI2SVVyeWpkaFAyY1loK3JTRWVDNlAr?=
 =?utf-8?B?WDRkMkcwOXl0TnFUQkplSWJzL1M3ejhSS1lZeUk3dHdJQUNPRGFlTGRSU1lv?=
 =?utf-8?B?N2hkeTJoQXQ3Nm0xeHdEdjYraXk0REVka2Jrc1lSUEpoNTRLKzQxdm42TEFn?=
 =?utf-8?Q?8Ny5IOGv4MUrxMedfOMbjt5bOYzXxDgXExemVod?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b98ddc06-da6b-4452-fb66-08d900828825
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:51:28.1844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2YDmBy+3GVVxg6nxNUrUhr5VY41NfHJZIBa+0OnbuxHnbkCaqgXN/G602a9o32EvYJZumWw1Rz8O7lWo9ds8ey9rg1Z3lrodsJu0xwjDH10=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160022
X-Proofpoint-ORIG-GUID: jaTbeBIxZ8WDD4bpBze75AHEWHEnJPJb
X-Proofpoint-GUID: jaTbeBIxZ8WDD4bpBze75AHEWHEnJPJb
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 7 Apr 2021 14:58:40 +0100, Colin King wrote:

> The for-loop iterates with a u8 loop counter i and compares this
> with the loop upper limit of pm8001_ha->max_q_num which is a u32
> type.  There is a potential infinite loop if pm8001_ha->max_q_num
> is larger than the u8 loop counter. Fix this by making the loop
> counter the same type as pm8001_ha->max_q_num.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: pm80xx: Fix potential infinite loop
      https://git.kernel.org/mkp/scsi/c/40fa7394a1ad

-- 
Martin K. Petersen	Oracle Linux Engineering
