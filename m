Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182C7C11F66
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 03:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F065861CA5
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 03:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbhF2DDn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Jun 2021 23:03:43 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:30922 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231849AbhF2DDn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Jun 2021 23:03:43 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T2qBGj011434;
        Tue, 29 Jun 2021 03:01:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=PoXLLDn/jgp7yPn6kSoIWwofoWFJBPKocVTTLDIjeg0=;
 b=KiSAoUYWJyZycgyXBZOiTqxJJ7LugGMukAjedlUPPmLsHdYJ+qfNAo1F9g/g1sQwY/dW
 orE/BucGxaS2XP+BUwFWkkmN5W7xhtKe3RhDwjQVloZuk3tmrbUyFNYzPhkw4nJ53y2A
 Ax5o2DOtNd60vkLq7x1liG6775bNof9aNo2QnA2kSASTpLSKyRScZpugu6TZPuccfblo
 IQ4AHC0KI/kCTWFKQZ5IKLlzC7v9TETGB8G42nb9BLuKMX7wClxqArx8iKuaYeCkSfJv
 x3GWYRjrt9H/Qy3m1psYy4YTc5CCU+appRoWoxn/lKB3T8dl3wRpaW0oBDez23oRoFEf 8g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f7uu2aku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 03:01:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15T2xpgx083766;
        Tue, 29 Jun 2021 03:01:14 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by userp3020.oracle.com with ESMTP id 39ee0tr2qa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 03:01:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfNqwxs+PEyiaMY+PAIu2E1LD/J7+Zc2hUZXNvefs5yAfYUfQqjH7OaRKkEyNmrlXeGEi/cEULPHFu3SGCsvakS+Jsh1FV20nVMDahkW9u3N/sS1Kdb4aWrDevSmpFyDymbRT4gCIRdqvSwD+AgIlJ4pPXpUcJi5Js96cxWj1WCdFiAi/qGR9muaLpjDTtUclYjGGnjkU7Paep37UyaEQ7pvBm/Txsikw7EMpLUujHbyuRoC6xAmOqlNRABmTgKT5n9a/TjdR4odtuqLHFvR7Piw+zuXn9v7IPy/EmGgL6GX7KSYTMCrl3T3+sa0adeMAJ/YcHSNt4WOjJYmsO1DYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PoXLLDn/jgp7yPn6kSoIWwofoWFJBPKocVTTLDIjeg0=;
 b=ZXpJtkcwWtYyafywHVD0rS5p+1poqC+c6P8nkMFaKfJyMEAtq/dKMt8Ic/U8SpZF3o7ppbW3bRoeEbSnXTpUlefN/K/U3zcqAuhlUpbSMLOvySD048Pq+mlptGpjWRt2IRv88Vmh93Ie9XFUjpotGtX3zopink6IiccV0xoGdTqXQ+rRp7/PGt4uH3b9Bvkpnq9T7DjaiSG6yHKTWsuqpzxkeQTkzCsuUGY2fxp/0+49P+1ynvT9lf+9K1NKayMr0OD6U/lBYe3uGLIQuZtO9EL6v9jZEQ5BFgAXQ2EusyDczh8XW6K6agLi2jkd3J8iZtFaWzkN5HtCWimUBLz94Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PoXLLDn/jgp7yPn6kSoIWwofoWFJBPKocVTTLDIjeg0=;
 b=pKqnq0/gyzZ21db51w2jwj4UByYJVZgfrTYEKnujOCPylheD58Uo7LDMoQbGLnCbzRXCRGRB790CaG5mjVUv0x8zU6xIrXNENqmB9l55gPttwnvCFveEdgePBZ8ad2CyI076SoB1j2pXbC/jjQCUhl7TWnBreOLQEItsARTBFTw=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4440.namprd10.prod.outlook.com (2603:10b6:510:35::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Tue, 29 Jun
 2021 03:01:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 03:01:12 +0000
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH] scsi: target: fix prot handling in WRITE SAME 32
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8bpl6re.fsf@ca-mkp.ca.oracle.com>
References: <20210616095632.16775-1-d.bogdanov@yadro.com>
Date:   Mon, 28 Jun 2021 23:01:09 -0400
In-Reply-To: <20210616095632.16775-1-d.bogdanov@yadro.com> (Dmitry Bogdanov's
        message of "Wed, 16 Jun 2021 12:56:32 +0300")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0201CA0058.namprd02.prod.outlook.com
 (2603:10b6:803:20::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0201CA0058.namprd02.prod.outlook.com (2603:10b6:803:20::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20 via Frontend Transport; Tue, 29 Jun 2021 03:01:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb4f294e-f381-430d-340b-08d93aaa273f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4440:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4440B4B66CA0A2BEEB577FBC8E029@PH0PR10MB4440.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s00+QYeZHnrYn++Qmb2zhLyWEZjsG5F8pMWHeSELHaBCTsp1LTK+fDNP5fYYU7g2pZGk9YTMaimDU9nWj+KgP6091nnflIpv9OE+NUVyUCwAD0slHVsabDk+bGAa5Chh+CBWQU5OGiRNrCl9tcXY808O9Au1u3Lgyhf2vKL7frcQ6mr3zljQaSEtcZ+Bl9gLLAWAvEDu7nSR1aKFF1rVcDmed1N3mCnsodaBRig5Ge20c1spQ88oqLtuJrDhuQJnWFGB/QHLc0kX5B7HcC+BMx9U2bfOkKXw2/vHoEKb9C0v4B12Qnz4nCM9XxySJWs4k841dzO28+KNkDNCqbtDdI2LRgnToutzuV1Hz/IdK0ON6iI2HNO9iP3uUdZzsLrtqPWB6c5+NGu+k5XEaQaQo26w3G/s3KqH+ua6hBm9CQmZGGwpawMUwRlme/BmxpwPMHob0zWcA70ouEiXWCgWD/DU05yh3eklgPteUPVzCmhe7gFYAkS+qL1PdUJUw21pngTQEHHccACUtFCP1kGyDRUa6BjNIqx1BmDMeMkriV1ImhmATgXZYrmK2ef8eKRkPkEywSnorKBnzsDzoLuU0mrJZ1Upe+I6nNLdamzjXp1r8io4eoCki8EVqaQowlzPZjW143pWEY8dv/hoyZFPE0x94H0/77Y7o8sOMOfN1fUzAq6Fl+K10SLE9yCavWwQdiQnZb7s8YPlaItyCCyMaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(39860400002)(346002)(366004)(54906003)(316002)(6666004)(956004)(83380400001)(478600001)(38100700002)(2906002)(38350700002)(4326008)(7696005)(66476007)(86362001)(66946007)(52116002)(36916002)(6916009)(5660300002)(26005)(186003)(4744005)(8936002)(8676002)(16526019)(66556008)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7sutTJFgUQOjRF87sAGDMuREL4PLLuANrkrb9Yx4sQ1lHzlGse89dTbRIJwS?=
 =?us-ascii?Q?+eut9vYLO+/QlCj8UTEGxtkSE+Fl9bXcUdTGw26XuI/6ZhgmjIDeTyie8dwZ?=
 =?us-ascii?Q?2wfCVmM5Onf1wQKqsRGYPB7YuIfpqu1tOX+3Yy6Q7vEy4B1Pv7gwTsn9PJuA?=
 =?us-ascii?Q?CZgzXvXGvBT260XL+mi5N0c+xkZyCnpaHPBcHnJ1WaDZt1DLNPrNLgELYVo2?=
 =?us-ascii?Q?Ti4F9W6imCerTr8hGsAVx5R9KJt5enLTnw+AFHoxWEctYoLewA5JQJlrV1BN?=
 =?us-ascii?Q?ieNgEaS6e7zqp8f0P0qH5LL2svVgY3z+RWS1R88dF9WJQXBKR8loBMB5lld8?=
 =?us-ascii?Q?TFVR+MD8yWwxP4jp6+/+v3zKi9SxZzbDoU0JdArNtcynIOCgCAKhxhYN47iP?=
 =?us-ascii?Q?0UT951UGf1lsLZaxKlUDXJezWEaAATfVDiutSFoAItsZdZHUmVCOR59ryXva?=
 =?us-ascii?Q?yJb59bsmO/NoHOBFrfqPMAMUVKr+TxlKv+CND7vGYI6U3AIyQHl6E9OsxH8S?=
 =?us-ascii?Q?IyPM1wzBtryufR6R8adKimNYIlOh35wRCETcYkF9kKoS5bVCT5xmjUKV6RXT?=
 =?us-ascii?Q?ZWH9evEvGJDDdcdnnQjpMhnXYvbF9v76J3qSoaeW9/jkXMCRAXho+vU9Zt00?=
 =?us-ascii?Q?0r5tDACDCqoMLw1z61tGIs9wJ7GRqoGrxniFVlqe+ClK/HB+0tbETccu2mvY?=
 =?us-ascii?Q?MZvk57CaXwrKXCoYh0xXFy5P9rHnKP2wdJ65P0JABAFgc55O/YJ5V0nmfuRd?=
 =?us-ascii?Q?vbFK2iMjAHHgkbWhbBAqRfeTStZ5ZbDBqrVHh4XRSzD2LjThdQl2iXb05EM7?=
 =?us-ascii?Q?JlbYqd3RxvregGjEQSL7kOigJcAnMFgACqx/ZvEzWQR/PJ+iYyPSecnSY77Z?=
 =?us-ascii?Q?r1wvUMf7eebt7UOWlct+vcTxvrYFkJEGBtmq43Vx04CkMlr96c91hJ5KDzq4?=
 =?us-ascii?Q?I9mSmSZKgF6/hAE/HQjgQ5RceN1q/IcdO63xEgR3ZSA21dMVwKIK3wIPT4DI?=
 =?us-ascii?Q?00dgcRvpmb34P7WJOLBLCuCpF78MofV4upCE8dhDNwYiXsLiWa/+BHNYwKHT?=
 =?us-ascii?Q?te93GX35s83cumLZzeZFClwo3PXlwXkuCIQYcR64ndBlPZrYs5cD+Zv6sZzY?=
 =?us-ascii?Q?lqTje4boWu6MiZ/G7o68ZZfaZ7KwUgWAhlDufwY03ETFHg81S4gTFdngWrVg?=
 =?us-ascii?Q?YhI9BDFQ7qffMpyeyS/RP552/rtVO+SuPA2PP3+dC40MsSfgX1QcOnndF+vw?=
 =?us-ascii?Q?VyIWv+nZrpfLuToLPXDm8w71383MbP8vqbMtvT7196Ag63ycCMg0+gsPFGLY?=
 =?us-ascii?Q?7WZeraK1sMaCZwzg/xjTkDJm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb4f294e-f381-430d-340b-08d93aaa273f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 03:01:12.7796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3N3CoqLLjcV3eNmzRbw/8+bg+7TXJfz1TBN8rZmZ7U+tkYuZL3KuLpoZJXl282a77XpIVLkRTFvkFQ9FPmg5rDnyr6j8yoSOHu3OfKcLq+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4440
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10029 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106290020
X-Proofpoint-ORIG-GUID: nWiBbjmOVH_wSxKD3FEgumbMVJjZLM-y
X-Proofpoint-GUID: nWiBbjmOVH_wSxKD3FEgumbMVJjZLM-y
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dmitry,

> WRITE SAME 32 command handling reads WRPROTECT at the wrong offset
> in 1st octet instead of 10th octet.

Instead of twiddling all these offsets I think it would be cleaner to
turn the sbc_setup_write_same() flags[] into an 'unsigned char
protect'. And then fix up sbc_check_prot() to take 'protect' as argument
instead of the full CDB and indexing into that.

Another option would be passing the index but since cdb[0] is only used
for a rare error message I'm not sure it's worth it.

-- 
Martin K. Petersen	Oracle Linux Engineering
