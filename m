Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89992C47095
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 03:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7348661278
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 03:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhFHDHm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 23:07:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40048 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbhFHDHj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 23:07:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15833wu6000779;
        Tue, 8 Jun 2021 03:05:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=B7JDhn2Heai68yV2gSpcwVfvqHghvSOtOg3JqFcOB+Y=;
 b=SNbp20Lvkui97y66jvMwbu2FUpj1JxHJy+rbz9fISHns79xvMb/yh57qImarUjDnbF7v
 yzqptIxRLeTAv+waOwiQGgim6xrAZYVWp7cG7XjJ3WzaevTruQvXBmuDurFr12uHVVpj
 v8hDcTWoC5g2LdAJF32JW95n4PK+rTs80SJCXav1QPYc55Q3RdFmDpbjbIBxv+pXkN5E
 IEHfXtq3mOreulh1m3VVrIF25yB1/Y8NzM5uF+Y7Csz5kO13ZTYAkajNAkQpD/igM4Qf
 FvlmTl+8Evr/Gkj7h46VhOrxoHgw6DlXfMvw9qFRdY/Es3gMgegatV05XCMf3s7GwKHv DA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 39017ncjmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 03:05:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15834pCV084953;
        Tue, 8 Jun 2021 03:05:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3030.oracle.com with ESMTP id 38yyaahxw5-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 03:05:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cE+zfHp4dBHXmpQWFl8AvTr/bWzi5mBnZaDRyth/T5pGTGx8E5dhPq0nFT4YM4k49g69blIhzaqrHvcM/X3ohJJoh22ug1n27AFk+7F4qYsFsRHTduSju2vn1dEpNVeT/6h+r7Xy1vD78FacwAXW06AsCID12LpJZo977EDayHMSDVNcW+OdcXkU/u9ep3lNSkf3JwSiir7yjYUEEF6N/JZHl2sDLNLKCsE83ZDQpHELRyADyL+iZ9pDqtNDION7fl7/QgquYIq1aOAGcdpqsUzd71MKeznOMmjMC+M7MOiDlnCF82FWeJKunIEAsKRqA93pkSyFVFUgEAjzE5C3tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7JDhn2Heai68yV2gSpcwVfvqHghvSOtOg3JqFcOB+Y=;
 b=fBz1hlV5aK49jXWjDOZZ22vSiuqSIA0j3jt+U7zt7hILildDF15gzCXCdIHoEg4aFbeHGJHpbx4gZ/m70jeBJIqbc37utiV/RaKfViE7Ztp9TtUa/rppRqufmk0PFou7HW9qhCSk4X1HLVP6kipUvFtKDra4UoktO5/JpXwjsQ8AYy5NaL+WceCyTfsaLrbd/UCBEQJ/xBw+2Q+jHlREoXm22kpbDsA/B4rgO/wywHbbUh9xjOVwHiIMJ2yiWpx6BQmCIzLr34HfSoF5cDQAzJGRosBswr7zOo868LyBJTnE9CORtvhTQL80ipzpEUsYQi8DIyj8fTNVWRIiJPH57Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7JDhn2Heai68yV2gSpcwVfvqHghvSOtOg3JqFcOB+Y=;
 b=Wxe+BTFstf//7pc/1vkpGZZCNskvAUgpa/6o+5VBUbOb7l9v0wcE+ga9fMNaF/j1xtxTFbOIVlCXFEYhP5Tes0qQt2mWTUsTOGX4H1+1bUYYt6E28B+AEm+v0HPAolGRijBBmzTZ5qWSPhJS/YDaJA3sfhMaRqxqyj0QHRetQSw=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4470.namprd10.prod.outlook.com (2603:10b6:510:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 03:05:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:05:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <njavali@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qla2xxx: Log PCI address in qla_nvme_unregister_remote_port()
Date:   Mon,  7 Jun 2021 23:05:20 -0400
Message-Id: <162312149256.23851.7771027511451363406.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531122444.116655-1-dwagner@suse.de>
References: <20210531122444.116655-1-dwagner@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR01CA0023.prod.exchangelabs.com (2603:10b6:805:b6::36)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR01CA0023.prod.exchangelabs.com (2603:10b6:805:b6::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Tue, 8 Jun 2021 03:05:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6800c090-feaf-479a-db94-08d92a2a469f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4470D998A9B00A08EBD5AACF8E379@PH0PR10MB4470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yq3aNhS+wKSpvkRJzf3zEBpFfML4ctivWlCQAyQe9va1CiubdLsTm6rEXRBzxRzMU4YJ/yy+IMZaFK9aiwkGwunf+kungwI5UR35hLeO3Hm5iSDsfmXB4Pn/DAikc0bh1xwzFCVxSfA05IBnG72skEJaPnVcpPeogHz3X7aLLeSyaNOfPVH8eJJeBiF98glP9MqICZNr32ZIypyCkvr9eAkWrsLuj0bsKjL2SIzyJuA/6YE/ui1V2hkmYZlLRtJU2WtJfdEbpl7owlOWHZ3NAx9hznAxMHmOIdE9TYHYPPe3FvsCNXP26xbzQ0iklbTEWu4AQXIseCaP3CQ6SO+gnDctbXFhxF/RYzzhalFhQX5ydOltS+73jO9m9wkinz7wz42/er6/AQNzNrGbm6YJSmHin+KfsmXzHsMBx6mBJ7gh8kyMmE/IoDXDKV6h/wP1v42jRmFJvqgZ9THDoKtLc7sVjkoQjRgEk31WW0MYVE2WMdmHxK/6bpoXGKP6VtOv0hqgn6l0flsS6VFGQOGba5/womKq2tEACDTAfAwtU5tmZNuRNdIRlF71vSxy4SCuq9eYEsXCLUmEnUSDufCyf1xzo8Xmjg2etGjm1jkQUAGMlXZzRd5NxB4BVBJp9Gt3ON+xKeBilwk9Mo7J8TzjwQ9l5LoCwmY9saxawCkdifKb5TxKiWdZR2WxUAgx8cGQNxMQfKK4qdR78UdGRKHZ+ibIzy9MjTNbEdxd2aVIvKiwVPdWeGxoQhGZ86v3dsDgNdPSJEpwjZSAQ5Lmkkaa8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(136003)(396003)(376002)(103116003)(83380400001)(966005)(478600001)(52116002)(7696005)(8936002)(38350700002)(36756003)(8676002)(316002)(4744005)(2906002)(26005)(6486002)(5660300002)(956004)(2616005)(54906003)(66556008)(66476007)(6666004)(4326008)(66946007)(16526019)(186003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1RvaU0rNnBQZkVoU1Y5QUpyRHhrZUpyUldvZEozRVp0MTdLa3Z0Z0NKa3Fq?=
 =?utf-8?B?THh0Ri9OaE9ESWhVQW5mRDJZZmRNa2x3VFJIblFXL3lrK3VwOHBXWnJ0cUhU?=
 =?utf-8?B?elJnZlpuOWtjeGlIc3QwSDZ2eVpJQzVHajUyeXRTYjB2UEQzVlZMQ1lwNmw2?=
 =?utf-8?B?TTVYR1BSdVhHRWNGeVRDdFUrOG90dVl0SnQrcFM0ZUNLbjdHcEVrQWpqZFlt?=
 =?utf-8?B?OXRqTDhDZHJNOFdsMTVrYzY2MGhFK1R0bEZmMmw2aEdVaTRsN3VPQTVkSlVM?=
 =?utf-8?B?YzFpK05XaFFJYWR1enpJSmZlT0Vucm5ta2tmd01FeEpXR2FQcVNOS3Y5V1JQ?=
 =?utf-8?B?ZktEdzVuZmw2MWpmeFZOakVMQlpTS0s1SkZIN3RHY1RJVW5ZbjgyNmpYd2Zl?=
 =?utf-8?B?WkNDRmdPaDlHZjV2a0F0YlBuZFlTVHNRTi9xdFBqbStyMzJOTU1ZZVNwRWlR?=
 =?utf-8?B?QTUyaUpJVGZZSk1MZlFFMHBtM0R2NTVyQnpBWmlKQjRqQWdEeVY5dm5QcnNs?=
 =?utf-8?B?dnRzcTNKaGJ6V1pITlRoT2VYMnBnU2VoNG43a0xMTzc2bHNjZ204dCtTSndi?=
 =?utf-8?B?RDQ3WEtnR2dOektGMSs4TFFOWjVST3J1cmdUaHlxSHc2VW0xRVlRNjUzL1BB?=
 =?utf-8?B?b1ZTK0xJZFVCdm9HbmR3d1lBRWJKQlcrWk8ybmxoMFp0ZkwzZCtiNVFkR0ll?=
 =?utf-8?B?cHVDTWN3UFlUdUhUZTh4OVlOTHNJeGk1UThnMnd5dzQ5ekJiSXRqeDh4QWZx?=
 =?utf-8?B?UTdTRnBlU3U3cWJHenlFNjZpdjF2NW9lSmdTNUR6T0t4bkVPYXpsY3paaU5G?=
 =?utf-8?B?T21qWkJ5SFZwUzVNSC8yNk0yWVNGT0QwLzdwcTE5ZHhzRFV3UExFUmNrbkE3?=
 =?utf-8?B?Z1dHbnAyd3YvQ0cvTG90Z0pyT2h4N0szT05JQjVLU0VDSXpTdnFxcG5vem5m?=
 =?utf-8?B?Njl1R2VOSDJHK0xyclBpRnpRVjVKNjZKeGR1dC9QS21kMzlXa0hpMEJBQi9w?=
 =?utf-8?B?N0d1NTNVajlmUEMxRjhUc1U1aHo1TFJsV1pzNkZtSzgyOTJtS2RXc2E1dlJ2?=
 =?utf-8?B?SUdhWTFrUkxRc0IzSndsNmZHbk9GWFlWK0Iwa2x0S2Z2bDk5M0l6T2QreW1t?=
 =?utf-8?B?SUozMTJ0MUNPQmYwN2xyZk0wQUl2emg2RDF6a2tqbWhBUllmMU5LQ2ZJTEpo?=
 =?utf-8?B?REJlT1IvUDBNUUlpanlReXZTczVZTmN5bG42MkZ5VzlRd1lFK1J2UmV6V1Yv?=
 =?utf-8?B?aUZSTkU2UFlDTmNqdURiYXdPa1dqNFhWTHdJcFFld0k2VUVPK2FlTGtjc0xF?=
 =?utf-8?B?U2RseEtWbmVQbnlFa2ZUdzJveU1NRU45T2o5MG1naGRDVTlDZENmUDB5THkv?=
 =?utf-8?B?ay9tVnczSjY5WjgvcVllRkpTQVFvR1RzcFdDaXBwbUhwRThWeG52UUxDMmFO?=
 =?utf-8?B?Z2NiOXhNYUgvVkVFWkpwMnJBZ2pnR1l2Sll6K1lUNGpoSW5XdVF5L2cyMHpy?=
 =?utf-8?B?d3ltcm45My9iU01WVlRHMUNySGtzMDQyZlZmVEc4TGRPWVpnMkpjZGpBbFFE?=
 =?utf-8?B?aGdaVHpJTDFsNUhYMmNiZkdxNHh5M2xienlrazRIVE94a0NTUFFCVXBJSmd5?=
 =?utf-8?B?ZnZxWWxEbWYzemJxNkRLUW15cTVCYTlpSm1GQW93eUJtbzByZWthaFdOdjZu?=
 =?utf-8?B?bGc1ZW5WUUlKb0xyNWlhS0lXY1ZsWXd2UUw1bEtlUExJaGdBbE12Zy9VQlRL?=
 =?utf-8?Q?tGngng1TLn9NpUE8fOA3gTne3qwg0kD6Hc0hKug?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6800c090-feaf-479a-db94-08d92a2a469f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 03:05:31.3242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xRYoVJFfjo7SDHNiQYqezxxzOcsPfxaeeZQ2UB7Dr7DzIDsIlzrlgj4Fd7I6pGtEPsAXFOjyqa0zPPaaccRd6qG1eT4CZ0Kg1ziSvYsy3Yk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080019
X-Proofpoint-GUID: 02VIC5BTXDY213g82QB_-axEEerLtqQw
X-Proofpoint-ORIG-GUID: 02VIC5BTXDY213g82QB_-axEEerLtqQw
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 31 May 2021 14:24:44 +0200, Daniel Wagner wrote:

> Pass in fcport->vha to ql_log() in order to add the PCI address to the
> log.
> 
> Currently NULL is passed in which gives this confusing log entry:
> 
> > qla2xxx [0000:00:00.0]-2112: : qla_nvme_unregister_remote_port: unregister remoteport on 0000000009d6a2e9 50000973981648c7

Applied to 5.14/scsi-queue, thanks!

[1/1] qla2xxx: Log PCI address in qla_nvme_unregister_remote_port()
      https://git.kernel.org/mkp/scsi/c/27c707b14659

-- 
Martin K. Petersen	Oracle Linux Engineering
