Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70581C47083
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 05:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EE6E61375
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 05:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhFBFrT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 01:47:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60888 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbhFBFrP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 01:47:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1525guuT104213;
        Wed, 2 Jun 2021 05:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=5FyKtOAMt/fbA5SXcZpj0MflseX6tsLZ/9pubqe+yxY=;
 b=G4dsh+DWT12SA0yXTsAWmWwqBWPoH7kCSKzpAEJpeezwsoWganF8wqFiR3RDPsplgzq8
 ZeHwn+bHpVywsjWnQVXM4breTWbLsF2la/Yg5WDr3xhOWQMY4PgWVS8FDMlIYHTA7lnp
 Cgt5WNHt5+0FoSnQwRinATyQ5atnM63tmYGFhafSv0dVrCBByjGgbr5o/AU2uPx9Qjdr
 SWbrvlaUIv1SEBNGVYrYAKiUBCtEW7jBW4+n3PCwkk8SlMCBMFFdv95C4GUmwFMJ7DyQ
 yE8I1nvfXZVJfztiSZdmxYSOMfdYoGDXnmg2WXXegcJiQJrSIPDN5LctYQ/KpruPDJgQ Cw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38ue8pfc32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 05:45:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1525eb3C069828;
        Wed, 2 Jun 2021 05:45:30 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3020.oracle.com with ESMTP id 38x1bck5bk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 05:45:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gYnSz1rNZ0gvbZ3fYH0I24H8NIrzMJnbT/Qseey3scpLFNxkfjlocF/w2thOd5CuES0Z6GpCSiljKWUUxRIHbPrCT/vp8aivlS6IFWB2vNZOb83rev5favbZoTgLUwVIm92nsiUPlRwqC0SQcEon3av5KZYrzCo0lObwsY98gvdBOTv0hhekM70+iwamaZcpOA+XspYD0X0mQ3KnKObhq/vu4h2CZlOQBHt4XsENVXGvjRSRw9ls2h8RI42lYuqMJjtWpPM8KLQdIUBH93e51ufQITpLiDf3jdDvCT3JYb0P8zXmXi1rkMXFThfQ9ONAgYrWiz4UtE4b45DyPD6Q1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5FyKtOAMt/fbA5SXcZpj0MflseX6tsLZ/9pubqe+yxY=;
 b=NmZuKN9LmG4bC8CNkFP7E+gTTc8zCyiZla7Wd6P34tc9dMhb+299PnLT1edYkz1x9uwPvVblziR6uOeT8IbTqaf3cui412bVY1xEwm6/eTuatquxVQdgZmdihbwER9MANVT8xqnAdM0N2a/S/p8yet62vAGZD+LthA37x8d/zhCXl9bQf9BHFHSmvmaVc7Mpuip9D3sepV+FgQhPTMU+HHXI7mLMec7LzI/HEYIsiMsFJdo4Xci7l/9/TXgbkkXVELmtaXg7E99WPaUZud3Lb+NrPfBe+hwL+OWPd9UoGXSTR/eKVzaRqZEvc5JOr2B5fHBcaxRc2zKyC2j8pZjT1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5FyKtOAMt/fbA5SXcZpj0MflseX6tsLZ/9pubqe+yxY=;
 b=nt84sbKAROx30zm36XcIlxWd5hZ2S5vh82wagyIfeTYeIuaSTrgRYx7Dn0AYg3kuvHlhqxNltYzgMiafaSGjzGeOAmQYXqwD5jwrlMRSjWf1iO+qVT8gwcs/61BgK9BgMayGBlMiiCDQDJtgXW15IBL8uz/ly32VrtdxSSxhwsM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5418.namprd10.prod.outlook.com (2603:10b6:510:e5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 05:45:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 05:45:26 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: scsi_devinfo: Add blacklist entry for HPE OPEN-V
Date:   Wed,  2 Jun 2021 01:45:18 -0400
Message-Id: <162261189570.29465.1760005845701099431.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210601175214.25719-1-emilne@redhat.com>
References: <20210601175214.25719-1-emilne@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR13CA0033.namprd13.prod.outlook.com
 (2603:10b6:806:22::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR13CA0033.namprd13.prod.outlook.com (2603:10b6:806:22::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11 via Frontend Transport; Wed, 2 Jun 2021 05:45:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6346688b-1979-472f-1e12-08d925899f2c
X-MS-TrafficTypeDiagnostic: PH0PR10MB5418:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54188FE16CC7D840DD0B4A4E8E3D9@PH0PR10MB5418.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qozv4n/jO6cY5njBvwNpq7qudC4RSXyGpnQdnuk1I/MvhFiYcsZPs3fNK0SxETJv+HDR2+/4RPcXA8GzD/pEnm7Fe5/mvYlHn1fuVZjee3F/kAgWx2RTlp43+iFy3LEpZnfEgqAQhXCdETOX6DawakLPBM7mK0rbKUWSCYg+V3oiInImmIVo7AquRp91TSrdUNDHUMQCxWc5aJCWj3DicaVwk4XZg4dFiMFdWtoRHWRZHf6lgtgKdvFghuO39UBzhJyoMf6kPAFb6cKIc+AgkdGuh6leBQpp2PhtMykhmFZPrm+VVaD/zj0HGHPNSl0Q4RpgMVlaG9n30j+i5BqZHhT0jX/e6jhj0C5PzJjNNcTXVL9CVxFcf8Jb6VcaGVM5NpxARovGI5AAsQB1p+DEf0vRAHNNqfmsEppFvzlNQkuiE6S9GwbRIWIjQWstNymO9Lp4ikUzu9sIBZtZBXhnJCueSrrTJHjfLl0U/cktljn+I9l3gPR4PgO+SQaQ1Mm9TYc70jC1t2xDKDyfXNKJwDwV8cuj0eBCBfYzCGbOF21Ey/gjLqjmIhF5fW4NN4mVg+VVZnVF+OtnEZbGjAa3xKnxmWB+Pmz35sJhtJqhCaXJyJhiVIbZ/kg7Uc68zAhNf2Kpk66WUw8oGZ4DXhSVJY6RLGAboWAMPQn/Fs1qK3jQxxbdjyhlwgJjg7LhKRQi4NNaKfwilua4vVf8s6h7hib9yf2QgSCItu8gFck1Hq+1yPHbwgb+NZCRn/JhRroPAUT/VG1DbDBDGXqGi+SbJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(366004)(346002)(39860400002)(956004)(2616005)(6916009)(8676002)(966005)(478600001)(316002)(6486002)(107886003)(86362001)(6666004)(4326008)(38100700002)(38350700002)(7696005)(52116002)(186003)(103116003)(16526019)(26005)(5660300002)(2906002)(4744005)(36756003)(66476007)(66556008)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NkxOSWhEN042enhERjIxelV0clF1dzlvMy9jTC9ReHE2dkE3Y1loZjFpV3hM?=
 =?utf-8?B?WVdtdUJXVUdKZzNRYTBtSm9Ec0s0dUhSamxGQlR1dlNLdGxhREF5TDR3bjB0?=
 =?utf-8?B?NHZ0ZlY1RHBTeFlsNFpOMjVkK0RDcmhSakEzNVlBM1Q0Y1JITG5sZy93K2RM?=
 =?utf-8?B?US9sb3A0U2ExZVNOUXZON05oUERmWmtvVThhMzU3dS9rSm5leEdWRGRjeStx?=
 =?utf-8?B?N0E1aUQ4c29vem5Id2lqRTczZUF4RTkvd052N1pyYy9CczhDT3lycG53Uncw?=
 =?utf-8?B?L3VuTGFNQzRUeFo4WmV4VmthcS9wdXR0c0oxZE42VHhkYStOY29BNTRJR2Rj?=
 =?utf-8?B?eVFqVDd3VHpscHZjWU5hdnY3WDU0RjZKWTdyQkZmNk5GSGJib1IwYmhSV0Uw?=
 =?utf-8?B?YlM2QldMZDQ3WEgvK1BvNmZQS2daODJSYVZCWk9uamRJemVEbkN6eGJYTFpY?=
 =?utf-8?B?dEN3TnlNQ1ZkREZjc2c0c0pTR0NTbDh2VnhyY3hGK3loYmROM25FV3Fpcmp1?=
 =?utf-8?B?bERXTUdNbUs5UjNwNE96Q2QxeUdCNjZHWlloSFRRNTBqdEpxSVRaVi9WVVlT?=
 =?utf-8?B?dWN1S1gzZTdBTDVqVUpjcmVQbjlMRU1kZTVZUWlFbkNUNHh3ZUpxTCtMZ1Iz?=
 =?utf-8?B?a0s1c0t0QVRUaTFnZlVOTFRxdVB3Uk5DeGdEQW5oY2NFU0R6KzRlZy82OEZk?=
 =?utf-8?B?UkQ5Q3liTmNmMHI3MW10WGpXNC8rUzl6TkU3aC9qSFF3SkUxN3hmMzFicDRO?=
 =?utf-8?B?ZHhSRkl3QnkyckRsTitVSllWUTFsSEJXV2x0OHNlNU15ODl3T0Q5ckFtUUZp?=
 =?utf-8?B?Rm0zNlMrUmFaVTJ2R2VwMTdodWFTVTFlRE1GV24yamh6dzY3VFEreE9Fa1ZF?=
 =?utf-8?B?RzdvNFNSdFpneC9nemgwc09Hb205bHVWWTBieUF3R2g4Q2h1V25hOU8zZFZO?=
 =?utf-8?B?M1FRS2hyWGFwSXllUGRMRjA4S2grT2JydGhBOXZMdkxySmQ3Z1diNExHeTdE?=
 =?utf-8?B?ajlVYXA5Z01hRjVzWFRlbVcyb0pOTm9ZZEd5NlJ6anYvcWovRlQ2dXozOWtl?=
 =?utf-8?B?SDRtd1BTMUs2K0lRaWx1cVhqbVMzejliSy9hNVoyc205U0hjcHdjS2ZmY01V?=
 =?utf-8?B?MXFOMG5USzJFN0UrY2FYcEFjN2s4dWVIeGNpZVV0WGs0RDFEQ3dmQ3N0RHh6?=
 =?utf-8?B?L3RMNmZjcTBBalFvcEdtSFpaRVRGaUFRcUk1aEd1NU1vQWZ2Y0pzSkNzZDdi?=
 =?utf-8?B?M1BIWE9KYVhIdG1rOEhQR3MzdjlxL2pqRUZ0ZGkrV1hINEhxczFHNjdEdHdZ?=
 =?utf-8?B?SXFkZjd5ODRoZXl4K2NaQ2VZRXQxWi95b3pGOUduVXdCZVJpc0VhZXVWWmMx?=
 =?utf-8?B?ODBDMklKR1BYSzkvZGJwZzA0dEZtSlcwZDJJMXNpamRSblJLOVFzMkNFSEl4?=
 =?utf-8?B?cXlBOG9yQWp2emc4dkx1L3NqRDBIS0paOXZxeTR4UU9HcGpqNzVnVzUwbVFi?=
 =?utf-8?B?RVdPUWdiTjdkYkdSbGh3bzNicWVYQXlteFVtaENJcWViekVuMk9VUkNoNXUr?=
 =?utf-8?B?ZVZEZm04RURhS0sxTFBPZVRJenN3RUhOcG4wUzYyNXdEb3RDV2JjcEI0ODFW?=
 =?utf-8?B?cUxzeTVYUlVqNUYrVG1zZFNmMEJ0Y1EweGJNRFRGRzZ5SFhxcUZWYmk2amNk?=
 =?utf-8?B?am9KaEpjT0JuY0hRSmNoVzZvOWMxeHJ4V0dtMGN5TlZhWHBwcnBkZzhFN2hV?=
 =?utf-8?Q?Aucbppr07lq5WLF6oJlHVYMktNxYSafnftKlFH2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6346688b-1979-472f-1e12-08d925899f2c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 05:45:26.2653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /XdO2Ag62VbFrsNZWZ7GgIzuxXEh5j5bOwiRU4I6HfimY2whCHiormqHUcP+qdKW050UL1IHMBd4vOxf5hcQnurCSvdhnBJf7zFCgFVA9dQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5418
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020036
X-Proofpoint-GUID: e2zzxGoncBMIjPYEKWSN7SUUq6HstJ5Z
X-Proofpoint-ORIG-GUID: e2zzxGoncBMIjPYEKWSN7SUUq6HstJ5Z
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020036
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 1 Jun 2021 13:52:14 -0400, Ewan D. Milne wrote:

> Apparently some arrays are now returning "HPE" as the vendor.

Applied to 5.13/scsi-fixes, thanks!

[1/1] scsi: scsi_devinfo: Add blacklist entry for HPE OPEN-V
      https://git.kernel.org/mkp/scsi/c/e57f5cd99ca6

-- 
Martin K. Petersen	Oracle Linux Engineering
