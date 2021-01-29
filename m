Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57011C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 19:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A6FA64E0C
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 19:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhA2TEa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 14:04:30 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54492 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbhA2TD5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2021 14:03:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TJ06Y1087014;
        Fri, 29 Jan 2021 19:02:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=4Wst6stBm1jC6qeQ1gAJrUR8X64eD1pCoDipE8166QY=;
 b=iCvluePeAJw33UYs79dfFCL/rmZpVl1X+iw/QBzpJBv/6MLhHtbORJdv22yju7AcDAuk
 FF5h/PfFrqTPwmWFkpO8BbEByCSqXJFRpphBdwkFs6z80BE/nXqOZGqpa5RsT5uRG7zt
 lwiatBS9DsohSiTadqCm72X2dqCEWsGqAa1G9ljnoDH3hbiUKDsUwA8ZXEwHV6pBWwi/
 YL129MPqGWd+JRRmBw/hv/vSV+cuOGqulcU1sDO/kNGhCqwY/nsiRhmNWK9ifnfUXVBE
 coClgv9fRdACtUj7PWGCaoeuKIT7TkfalO/iowX2K0kBsMZB8S+jz2kW3c3Am+t4rpv8 wA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 368b7rauv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 19:02:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TJ1Gb8088711;
        Fri, 29 Jan 2021 19:02:05 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by aserp3030.oracle.com with ESMTP id 368wcsknjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 19:02:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kt8GBAO4rf1gDOOPWE0D/rVvMtTePrGr+nobXJ43yd1X/7ItFGRSezMs6061xeO+ojQfR+tGeEJzV8DZ3n6nxb1olXoIdeD+9ZFz6tGTiC9m2E1R8idm1iOiRqe1Socf4XqgNtTEY1z6G/Yt3fW8UqWneo4xkv4waCsvuuK8OcfiPRgZV2YtiiNcepd7LjagzqYA+6AOGTf+LP2i9ki7c7q9LXD6fqCCce1mVDpT9aOkkQtxhor4qqZZ9zpMg8Vp5C8jxVOphiDr6gQUTX4tlT0kYVJt4tveTn7fMA6P2iVVwBHNMumHO8suR9fhWbrLDCxEq9t1PMVkTvnuKeDNKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Wst6stBm1jC6qeQ1gAJrUR8X64eD1pCoDipE8166QY=;
 b=fUa84+FOMBX4HuqECR9z9MuSX04kWJyj48LSvXA6M+sqKc//lkh7zUa41OZPq5DzK2mdVTvTyjHtkwcvL8qxl+XRr7I4/DDWroQpFDs87sStcsDKYDXV9gAOnB/ugXGb6ijLrSCbkFC6ECKKhP8e7ICsGYjP3DwK58/F03IZKUxkBQriaS+xf7ha5Z2qHLsR6kKbkwd6SxC7KW3F+Qgt3EpVBxDDyDXWZtnM3X8yO5LUTdG953ojP8GFxFYs9De7ItKV3dUlTgRMWuekTnjSk8RBu489j8Tq+uykcvrtiirVllllYEpQzVjHZ65QQBhG6rGp5+uIZZ/IdjLRIiG92w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Wst6stBm1jC6qeQ1gAJrUR8X64eD1pCoDipE8166QY=;
 b=IYp/kObgRurfB0tNYgn2irys5UCjR4hV9kqycjUvj0gfrBtLh/xetF391FOZBVrl0nxeqG7jA5uvPriKfO1QqTglkOPec7ZOF1puphwSgouAI3ijHlbQfjtHYbyLrUh1xy5TD3QhCe4KhhKx4IoEz87160alxVvOpBqrUrHBN90=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4677.namprd10.prod.outlook.com (2603:10b6:510:3d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 19:02:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3805.021; Fri, 29 Jan 2021
 19:02:02 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: qla2xxx: fix some memory corruption
Date:   Fri, 29 Jan 2021 14:01:49 -0500
Message-Id: <161194526370.12948.16367434867317799791.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <YA6E0geUlL9Hs04A@mwanda>
References: <YA6E0geUlL9Hs04A@mwanda>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: CH2PR10CA0021.namprd10.prod.outlook.com
 (2603:10b6:610:4c::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by CH2PR10CA0021.namprd10.prod.outlook.com (2603:10b6:610:4c::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Fri, 29 Jan 2021 19:02:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84c4f86c-18ef-4ab2-510d-08d8c4885ca8
X-MS-TrafficTypeDiagnostic: PH0PR10MB4677:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4677583DA6B04D98F9C5260E8EB99@PH0PR10MB4677.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Yc+Ij/poqhrUvjZn8NS+bTCMbEJCA1o6iHDYPSY6I5U58upHSpPODEwgXH4lbClYTxjnKOP2pySOjGI3L/VKpYc5Gz1680vc/Ptg/hwfagTXycBgqDtOT6No6lrj4nnRCdqeP24EHvkCGZGzN4lLZkejSLluCFLLR8wFrTkmSDdAiK4zWl6Padc/XjxW48dni2kfuvacaptNMPZZVZl1qMQmWq/eCVa3YfHRlp1hp9FLKOCZDHcUD4hKbki3oPQ2PRIrjFjG/oRPQB5wLcTi2PsiaEiCCggK0HrhKh7kI2QoUyHmOwLbfOKudfhFP1RDIjQAEhSX3x+mUghZQrdqCDZNenjcxROk48H/FsBhhnivydxyuMfSM4KD/1MZK/kthNKFUfw+6pA4f+SA5xt8CYtPg0/WxNI4zWlEJJmIGLNmRdiC5oNDuer4HSsXWMySYs/RtU+nXnMCzKEQhgml4Po4WXhPAaY/N7uEElsaP4eBm01tcIhnnmwPNviwSgSWAvFpC2X+3HPnkOig3rQkrUJqgeDdF66/LX9iHy9Cvl63Ui6kNC1yX2rTMhEUvAxeZ8r/T9yEPAqFCRxDaw8qAvcIHzZRo56Hk1yiCOAUpo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(396003)(136003)(956004)(66476007)(2616005)(26005)(52116002)(66946007)(316002)(4744005)(103116003)(66556008)(5660300002)(16526019)(186003)(36756003)(7696005)(110136005)(478600001)(86362001)(54906003)(6636002)(6486002)(2906002)(6666004)(966005)(8676002)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dys4Z240SFdIOEcvOTU4MmtwcXBCOGhiT3VIK2Y1TFdBT1lrLzQrZmd6U1Nm?=
 =?utf-8?B?K2g1SW1Zd1ZmcWRvQ2NMV1RVaTVjQ2pxQ0wxbzluRjBqclBqVkgzNHJFTGJv?=
 =?utf-8?B?OXczZXUybGRaaEdZdVJzdWZyNGsxTzdPS1BMUFUzYURJZVYrbXUwR2pCS2Vv?=
 =?utf-8?B?S0l6T2N1dW9qbVhGUFF5Q1l6cjJpVnFGbll5NzAvbzZVaUFCNlkxemo4SzFG?=
 =?utf-8?B?N0VwcGRFTHR4bGNuTjY0UlcwZFRiMGxHbW1EaFZ0MzM5QlU1b3dtdTBBMzRn?=
 =?utf-8?B?VUJoc1FTN3dTdmN3bHhXOEUxSHdRYi8yUHdQQzhYSDRFQXRXSnZtVXo4Z05a?=
 =?utf-8?B?bWdXbHdpdUNldjdUWXIrbVpydFFhUDEwM3oyWVJjWTI0cmJQUmd0SmpKT1l0?=
 =?utf-8?B?S2g2OStFSHJUdFlCY3Y4K2cvZm84VDV6aE00TXhTcmpRKzdINVBNVGVmRzV0?=
 =?utf-8?B?U05zUEpkK0I5RmdDTWZhNmlRTHBEMVBLOWdJWGxJWUh6SUlTWkRQc3lXMHRk?=
 =?utf-8?B?SFpJbnJEQTNVeW9TL29FS0EvakdhckNOcUZTZGIvQVRvRnE1NWFtS3V0TVFF?=
 =?utf-8?B?RkxtOUwrVFVYbVFHRExkaXF3WW1LN2tXQU50MkhhTWphdCtFbEVSU1djaWRo?=
 =?utf-8?B?NlN4OGYzN0d4ek83WHFTcExIaUdNUVdiaHl4eXArelEyaitMYkNLMnJpU1lH?=
 =?utf-8?B?ek1TdjhDem9kczRiczlsektxRVVuNFI5WEowSTFBUjBvd0djeEM5VlVlQTN5?=
 =?utf-8?B?dlphbU5Ga1NtL3NrTUZ0UnI0cTJId1h1ZHo1WVcvVU1IQUV3QXdpV3kxOEFY?=
 =?utf-8?B?VUJxZE9hN0F3NHJWemRnZi8xR3dQTDJkcWhxV0NFNVJFRUtRS3RUbXE3YXc2?=
 =?utf-8?B?SFRCanFpcC9WVEtFMjdyNGU2bThkVVdMd2szMXJXOXl4UkZRUkpsY2JmZUdR?=
 =?utf-8?B?ckE0TDl3ZDd5Y05IVmRGRWJjbERHNkJJOFBnWXoxY3lLM3N4NzJpNTVDZ1Ns?=
 =?utf-8?B?L2NEdFBneGNTNElSd0dsMHZvTWRVWjJ1TGZleG5rU3ZPV3JxOU96WkJBajl5?=
 =?utf-8?B?dmxtbUlUY2E4T2NxbnRMOWNUdFI0L1F0MTlGMXFrN0tsMlAxMzNzQk1xZTRu?=
 =?utf-8?B?d2dPcXNXdm5PV3MvR0poOWN5eEY0bHJtanZHbjl6TTBQUGdORGhOWk1kaWNO?=
 =?utf-8?B?QWt2bTdFR0FBaEFhTkh6S1duc2g5NXo3Rjh4R0twd0l6SnkvckdSbm1oZXdW?=
 =?utf-8?B?SFptMVJsUzIrRHhMNjlxa0FkNjZiMHVrNUl4Q1RPQWZCOStNaktTa0UyMFhk?=
 =?utf-8?B?UjMzVy9HWWsrTTcvbHhPMStPOXJKS1hicldKTGRMKzBJeERiMEk4d2Vndmxi?=
 =?utf-8?B?TnphQzFNbytuYjI1ZVBESUcvZm1hV1l5QTZPYjJGMGNoc0gxSHE3N09oOEtV?=
 =?utf-8?Q?6xzUf6RI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84c4f86c-18ef-4ab2-510d-08d8c4885ca8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 19:02:02.4744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i7des7FYDd2JlqHDtfqDabFIO+YVDD9THERe8BEDI3+SpuDZxQehh5TshNy/loDrdQ4nQaGHI4ZvKAKNf1RmKythj4dm5d1zuW2iG6nhDqE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4677
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290092
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290092
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 25 Jan 2021 11:44:02 +0300, Dan Carpenter wrote:

> This was supposed to be "data" instead of "&data".  The current code
> will corrupt the stack.

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: qla2xxx: fix some memory corruption
      https://git.kernel.org/mkp/scsi/c/bc2b4e680231

-- 
Martin K. Petersen	Oracle Linux Engineering
