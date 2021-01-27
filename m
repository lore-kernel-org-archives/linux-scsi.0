Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A982C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:41:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2C5420709
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235452AbhA0Fig (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 00:38:36 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36480 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238667AbhA0Ezv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 23:55:51 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4kGp2093348;
        Wed, 27 Jan 2021 04:54:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=QvQ9w24b2vwdbajfemZyldzLrSkAk5KqZ9V5KS8ivy0=;
 b=q2jpbJLzGm9sJbgbqDctSV7MLPDB4y6RGUxpoj0minmL8UcrBvB4zViOlsDwjeLqyYXX
 mXS0aAZTCDGekrKN2o4eYOOkTBY0mRAS+Ti/T3bbBTIV45kwcPrTNje8T8ESRGiGGhCp
 VRAxy+HhJAqSjb74H1lDcTvP+4pZVUXDqp1QS4+tpA8ruZlG1RgP+Ei6uhp4hAsN8Dti
 47AauAqtHMKOKQgipioaBSvPLJ6J0tP8IYVSdc+htiPdrdewcJ1Z392K8/nlK+GL6UNq
 IINgvMdN6rez+SuOrLs+APsgTvGjnUkgksn02pTMVErtFu/d15ESdICTmZtVrT8Oz3gB fg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 3689aanbb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:54:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4o8Mm088816;
        Wed, 27 Jan 2021 04:54:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by userp3030.oracle.com with ESMTP id 368wqxb8v9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:54:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nyb93oXxHQnUMdidvyVWclklqFqAqguqQh72sh1zABSfStoCPea5jJHqYNYm8V1QQ5j2oG/7awQshicUe3W21AWeDQRovlG/bRHFitKBrP03CnvNiIzIcEqexZ127JLGZJksPdZkKyFMAMJvQRj8iL5YCnZlU7e5xayIzr3qYo4Lgr7R5u5wgQS/F45OneSo1tMTcrhGh6HIA6LNnMCx4Ar9dBAcJ6UiqdBNoqNzZNyUzVWhkVOwA9Qs6RUBsYAa2c1edIvaDnKPpLY7L2oH+sD+GBu3/lxyKpmYHGj8HRU0xfKgAaPNzlckQN2KRWij1lp9vlfUKlHaOtfbC8WZUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvQ9w24b2vwdbajfemZyldzLrSkAk5KqZ9V5KS8ivy0=;
 b=RdH3u5Bsmb3RBKtEnEM7KNKbr2PMw+RlcMh+yxYnU3M04JbS+DAm0GtG3A9+TDl94exg0DuaMRlXAj439m6YaUCXdASAiPBJr1IetPucI/fYdUBMIvCcdoFGSaWUP+wLll8EoLX7Y/fLgtDMgKAOlHZf63hmi3+4824tQtL+SUo1YKcEWlJ6aGIvPwdnvjpDELo9ZIDXW0g8Z+jeqhMfoys3tokFcyDxuLOTpmzg/0DilTlHDE/CB7lwMGXVsIsWWvz1uBSDo93pARAt+213u9NQ2SECfU8bUG7F7HLgid6RGBxogylxnl4dURzLPIoS/UW8lATYDfE2rEFSgGcDBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvQ9w24b2vwdbajfemZyldzLrSkAk5KqZ9V5KS8ivy0=;
 b=w2V15G19AC9KIj2DNzoWdXxG1upH/JbpP6iuYyHYVuNyk3gH3F6SPgyB5OBvmCGSL7YmCu7SwL2mbbuphABc5RLHjS7yi68EkW2nNyMkq1p7XGgj5CczAlhX/i9qvuWTVdTOcOyCH9bO/xs6Ch2ak92gt7ojexojzTv2XxYcJc8=
Authentication-Results: exactcode.com; dkim=none (message not signed)
 header.d=none;exactcode.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4584.namprd10.prod.outlook.com (2603:10b6:510:37::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 04:54:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 04:54:49 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Rene Rebe <rene@exactcode.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] fix qla1280 printk regression
Date:   Tue, 26 Jan 2021 23:54:27 -0500
Message-Id: <161172309264.28139.4207816497740194279.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210.223944.388095546873159172.rene@exactcode.com>
References: <20201210.223944.388095546873159172.rene@exactcode.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 04:54:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e7adf95-f5a7-42b8-aa5f-08d8c27fad3d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4584B9794EE3CB0FFD7D392D8EBB9@PH0PR10MB4584.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:234;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y0Dh4r8Is6KnW3qEHy5nmXhBizxAYdl9O6FhIIshniNIx0fbTAfPszw5UgYBOxarT1JHUOlCxF2rPrOjl6ebBYF2nAUiTof033F52AqOk9IG4mLiP2DThQPwYUdCTeB/77WHL62ti4ehseJ6xez9TmG1HJwvY4LLRq9LTi7SeTQp5WHMjawwN8ldtO+4/yOfk05H1hpK/ZfnlCHezHxOpBMxUf7v8iUgwNiwtUAY55lZehOoULkBOiE5fPpB9D06w5wUb/koBEaH/u0n84qYYPxiPK1q8Or+BobsepCIPafkB/EEQRw9GkAbhcUXv/Sm4kfWNsG9n0kq8X568GUEXtaIHqBBCDmF/9mmm5dARR6RL/VQchXMLgCVxWZj3Q7eKYE7z2sLG3xH63cu/IIBHmOMJnmDW16rPc4kkDEH8fwbEawEtBcYLEm6TKkGibtuoYDyCHb57cZEnGKABuiIPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39860400002)(376002)(8676002)(66946007)(103116003)(6666004)(16526019)(4744005)(26005)(86362001)(186003)(36756003)(2906002)(2616005)(8936002)(5660300002)(4326008)(66556008)(54906003)(66476007)(52116002)(7696005)(478600001)(956004)(966005)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NG9ERTBkaEpjbDI1K3RhU3lubSs0MjNmbTJjZnpEbi9veGYxUWZlVERMSmtG?=
 =?utf-8?B?YkpZU0Q0Z05WOGgzRXRQK2V2dXVlTkZWOWp0L3dZaTRsN1QrU2prVGJrZS9T?=
 =?utf-8?B?WWRwTkFVRFkxTEczTFY1RnFTV1BTQmpUNDgrbDc2VDAwamxkb2F3eFdlMjJn?=
 =?utf-8?B?Zm5Ec1ZaNDhXN2k0c21pdHl3TGpvNjNxalQ3L3dBeFFqaEdGcWtOWTVpazNu?=
 =?utf-8?B?QTZtbnFXUzQ2cEpwclZtRnNkQW5aa2NQSzZWNkRVeTBYVlJLRk9yREw3cHRr?=
 =?utf-8?B?eEJteVVlSmhDK3Y0Z2pIQ0Q0NlJzM2ZyOVczMnBhb0FWUFVaQUIwSlpEOW9E?=
 =?utf-8?B?TlpuaEE2Y0VueWs1d1c5b1VucjFZMDRxTmtPN1hiVEV6cktCYzdRY045Mmgx?=
 =?utf-8?B?ZzAwTzBsV3pEcU4yR3hSSFk5OXlBZGExUlR6MFEvZzdGVUhwbGlKNGdFN0hQ?=
 =?utf-8?B?WmFSS0ljY3ovNkx0QkI4SkhBV3AvSVd5SXEwbjNTV1JSSW1mbWlQK2VkQURs?=
 =?utf-8?B?VWljN1FEWklFMjd4eEZoajBacDMyY01udTZlVHVZR01lREtiektIdzc1ZjAr?=
 =?utf-8?B?Wjk4WGJPVnYydk5sTmVBZW0zQ2FhV3EzOWJybUYwbmhqbHFNNlVYZTFqYXR2?=
 =?utf-8?B?UnRXY1VYSk5LN2FZT0J2TlpzNDNuZmM1aXR4ZytTMVhycWRLQVcvSWhYSExt?=
 =?utf-8?B?RXY5azZZKzRjaHRxQWZBM1ZheWpjUGg1NDJEUUlqNGxPRzM5OFJpMnFFb1Bj?=
 =?utf-8?B?bGp1aW05bXQxVjFYclN1UVhBUzFKZ2hiU0M4WFoxaFJrNTR5SE42UHhZNy9C?=
 =?utf-8?B?dU1YUFZJQU9UUjgvREtmbXhEcGxHNUVhY3JHaG1Uc3JjQVM4TXRlNEl6TXY4?=
 =?utf-8?B?ODdWM1d0VkFEYTJHMnNqek9lUkk4bVIrMjlERTN0d1JpcHBUWTFDZVFiUmc3?=
 =?utf-8?B?UzR3TlZ4VzZZU1dBRGZKdUpoaExkbTQvQ2ZuUWEyWG5mVlZHN3NRUEsyTTJK?=
 =?utf-8?B?LzBBOVI1OFY5aCs3cXNCODZIMXFER2VOdWQyY29yOG1Jam9mVEN6eXVEZTA0?=
 =?utf-8?B?MFN5OFFTSzNCTWhHR3pVMGpuV0QvU2l5bitrSTNaNXd1NVBuYzRBc2V2d0Vn?=
 =?utf-8?B?MjR2QmVVVm9Oc00vdGIwQzVjWUFWMVZ2TnhPQkt2V3ZEN1RwN2dvYUcwdjZr?=
 =?utf-8?B?WCtJMnVyaFBlTXQ4MEVKYkNtdjh0MXpvVWRBUEdGRmhDNGhmTXRTOXVZWHJH?=
 =?utf-8?B?MDgzNHJHK0NlNGdMK3pQR1VjcWxVeWg5bEhaTzFNcU11SUtkVzhqbkpEZ0Uw?=
 =?utf-8?B?bFlVNmlUajIxbU5ScDJnTGtZaFcybjBBYUI5Rms2bHlCWEYyWU4yaEcwSEU2?=
 =?utf-8?B?Z2JuR1hreDQyeG5tQnFnTWtDeWx2Wld5dDZwN2NoeVNXa1cvNzVDL2k4RmJU?=
 =?utf-8?Q?WI0CaClm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e7adf95-f5a7-42b8-aa5f-08d8c27fad3d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 04:54:49.8519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wr95wwMvyaPtNt0Cno0kaj8b0/sNVV4UJw8kEELQTYU5RAfPw+XlcpuEW8RJGm39g+IrxCH8xX99ZtGf87i1kKuv9YkgrfAk1gTiSYZtrHY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4584
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270027
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 10 Dec 2020 22:39:44 +0100 (CET), Rene Rebe wrote:

> Since Linus Torvalds reinstated KERN_CONT in commit 4bcc595 in 2015,
> the qla1280 scsi driver printed a rather ugly and screen real estate
> wasting multi-line per device status glibberish during boot.
> Fix this by adding KERN_CONT as needed.
> 
> Tested on my Sgi Octane: https://youtu.be/Lfqe1SYR2jk

Applied to 5.12/scsi-queue, thanks!

[1/1] fix qla1280 printk regression
      https://git.kernel.org/mkp/scsi/c/cd9df0c21636

-- 
Martin K. Petersen	Oracle Linux Engineering
