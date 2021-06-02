Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65516C47080
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 02:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38B8E613CC
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 02:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhFBCqd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 22:46:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56624 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbhFBCqd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 22:46:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1522hsnc021403;
        Wed, 2 Jun 2021 02:44:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=rF0c9snxY769fc+M/d2m5tXbDeDTEGbMqES584l2y74=;
 b=MA4CV9a1wx1yssiAu2HfoIgjg3XA3g8IxeJQhA7ej9rF3+w99VDzTYUjPSvBRl5je2OY
 nw+IpzKnOfqdORxKCTr1OUJpouf5A6HFV7sIXqZZLq+T7dkzXyLfJMSPkwXlaSDfVhtT
 VGj/l0wCXtbXjVIFItlZMrJr/adJjbtVGNxVk+jV0+FDx9SsuH0tf/OWWEJZ4UyC3I8o
 +SyWK+CvWH/EBIeZv6qfZRpYacQ5e1QRkqJhgukcLKpi78TbMzNj0ZiMH3nAO4VCT3et
 HXQDzU5EhCDYF6SADUTIQwe0nkiPSZ5BYiFUbloYXnnuM6ihgiCD6WFhA5F4Hkn2/NtO rA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 38udjmq6k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 02:44:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1522iTlX145674;
        Wed, 2 Jun 2021 02:44:42 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2176.outbound.protection.outlook.com [104.47.73.176])
        by aserp3030.oracle.com with ESMTP id 38ubndnqyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 02:44:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gYt6iFkAWbZAEjwJmVE1FwRvO8JibTiddK+JDwmQ88B4/6C2mkrqvuCyucGCv8OM3EfzglZAeFA6/j0jEexPwF4NysDCW2CNxLDrKuPlxRu7+uL9WrqUTA19N4xBOjuCnrorvaSIxMUG6yXXtl2qPW42WC6gvDMQyKDK5Q8qhypbCfU4fSRYy72pjsFJmlg8Gfn7N5jiGOW6WBSVcVf6Et2ZAewQeTEC9Mlq6k6rq6lB+LNbcmFiXfz7qTaIu1qPxdsV1rR2WvUuEnARsEtFo6htKtae4osXtrVsAItuPkRQswPTIpU8u7k+dVzJCMx6Zfi4u9RkhzlANBXZmy1MiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rF0c9snxY769fc+M/d2m5tXbDeDTEGbMqES584l2y74=;
 b=h5mFaLACUdvD0/kQwyDJUFOzDBJeoMg+bonfU+UKC8w7TsAjLac17fr4S3OlR68tUAivZbIqERpPzcB16JCz/yqyVtHsV11VFIQrXPsgMNmjiYEhA/LFLPSMGlsz5DYzbdZYcHy2dWvopkFZbrAqSTiw32rVUwD/PO9JoQSpmZqIOO286LdcCsrhteSGM2/aPri1OcIQOfMbDzLVdGPenwkdiQVOHvsMyKG3cXxKBtCzBMog2YbZZEM6Ry2HY0nQBgJnRr67sbVW50cxlyvmtp5wVUQXJAac/PcjDiz8RWZAxJwC5fxFM3XmMkCIEa5h8ctWWYVAZKs/j9mnJWYPFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rF0c9snxY769fc+M/d2m5tXbDeDTEGbMqES584l2y74=;
 b=rHwhEMUqHLBeKsOJ4Jn+iFRIb4P2fEGDxqVZ8HndJQaXNItlVPE+x1ly00RULsSOG3/fgz0n0VjS/rQtD+7/5DZNuRsw7s2vr5lcLx5rhv7NNHEd0hkog8+ZfE26OEPud7MtDBvxZ6WgMdU0S1LqPRdnb17Jerx87NHuLtInTo8=
Authentication-Results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Wed, 2 Jun
 2021 02:44:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 02:44:40 +0000
To:     Alice <alice.chao@mediatek.com>
Cc:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <jonathan.hsu@mediatek.com>,
        <powen.kao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>
Subject: Re: [PATCH v2 0/2] scsi: ufs-mediatek: Disable HCI before HW reset
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8cpq92w.fsf@ca-mkp.ca.oracle.com>
References: <20210528033624.12170-1-alice.chao@mediatek.com>
Date:   Tue, 01 Jun 2021 22:44:34 -0400
In-Reply-To: <20210528033624.12170-1-alice.chao@mediatek.com> (Alice's message
        of "Fri, 28 May 2021 11:36:20 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR13CA0178.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR13CA0178.namprd13.prod.outlook.com (2603:10b6:a03:2c7::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.9 via Frontend Transport; Wed, 2 Jun 2021 02:44:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f58db76f-07da-489f-7229-08d925705e5a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4744:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4744F69B542004B581BD85918E3D9@PH0PR10MB4744.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: usmjOCSeQbPaZSRkRonMmQ55Zq6yRAaXYEpJLaIik75RNON8nyADPukFL2/49Uc2TjsLG62X9keT24nClsJZD0FMdo1vs2aybTlsFBSYyJzKidaftBG4RYw7lfJs0VUmcobKFyUeWUeDQ+3zddYGMtisZjQfWdPQOPUZAz8udJS1y9x4i+9OM+zEhNljE6GwjSmgsU0fseX3WlPd0+4rlFWMtMYYWb/rJEIvhTbaRxD3Rdj90n6y+GZ+NzikAcdF2xJ1EeJZBW47r6ANv/9VOzZUZ0zSB4OreAoGvnCRXTw4uc5jjqht07zm790w5IThe3EWmWs7gBkYRjycmj+mdu8e3y7yB4x1m5x1yXjzObpqrXIOWDbqxShCATm816SweHsm4zIDqSQreYAC6Lp32/We7qUMqZMVpkWLp59KUuSU6tkFzUmYoantn6rSMvcw8nobX3DV2DouOW8lNSn4HNHQylA1e7B1q8AEZZlXEeQ0bfgJzVf0qicPvPNV8xllpZZAW6GHnWgM1PF8TGtwW0vBQ7oYILXc1iRp6LQdER5jPgfj+XWaN2jamaUV5p2oJFHe2xqWQ0kN2FkfpLp7uZwQt56dn9pAIryoNtmoBvw5vyXMZruuOcGdBHWWUiJJ3f793FG9Zlznlg6v/H/gqUJviSRXxcYLmU7KFuxUCjE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(346002)(376002)(39860400002)(316002)(5660300002)(2906002)(54906003)(478600001)(8936002)(7696005)(36916002)(66476007)(4326008)(38100700002)(52116002)(7416002)(38350700002)(6916009)(6666004)(8676002)(558084003)(55016002)(16526019)(956004)(66946007)(66556008)(26005)(86362001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?e1cVTt/h057jM6HqS4R2xTPoYiiNUoJHkpspmIgZDcdlOUmTUKoHd2BEJW8v?=
 =?us-ascii?Q?RYf8bz8i7h4Of3TtFu/CV1gDmfwiodGMYi0R6aBOJoLgqDgZcNATyd4U0Ivz?=
 =?us-ascii?Q?1EF3jEg5eZc2V9i9n3P4Pq21yXeZhQ/pGAa5Hun19O6J5aKW5OV1aJ5Mxt7M?=
 =?us-ascii?Q?oREGJl6b78+PJJoCrlFewfUsyBWhizGvUybuqJrQ1sBS0tqZS4SJr/5HNPC/?=
 =?us-ascii?Q?dda1pMTNuuZYjIz8YmLfWEKhwG/yvq1KCZGWGOUa3njKx5LmGETwy4PDSAX1?=
 =?us-ascii?Q?ENnQIXavZZhwcQSw0YZUnc9p9/R9RxqosSJmIWDCfbh1QxYBf6FYgDaErNa6?=
 =?us-ascii?Q?U9+Ytu+FEzfZ3H71FY/EOlPHdVbQXQHXVXmJT/ir77wbvZdNaWS0R8RDTUzU?=
 =?us-ascii?Q?b8NKfQf3XVxby1i+eQx94/IqdP0K4ItjHZ3magUoY0zct4VmX9Ylg06GJeup?=
 =?us-ascii?Q?6fwCrJ+VyTDTVmQ1UJINb8JlHrHy9VspKNBtXhtgiq5ALVnlCSsJUGfB142x?=
 =?us-ascii?Q?ohAR/fJqZN4G+MeKuWheDwwpYI/YXxWpUSxwa5FHUCzNkkSAndPjURhpFb3Q?=
 =?us-ascii?Q?0B7pPyaUUfdVxCB7akM89K/y9yTbNJjW/3Cw1KNhx0pJ0pQEyCCcgrLuNHFO?=
 =?us-ascii?Q?lh6bf8S3UeMYBZPDVjNHJFqZElyTBb903OsfyR8V7nMRP/TFoYc3H7bcdkg7?=
 =?us-ascii?Q?4NIg3X06Ya6Hb9XiiYbQMVAzVap5xkQJwjARz4sp+bzwHYcSE3S6q1+hugvy?=
 =?us-ascii?Q?Da5Tv86l8uv7Bzu+VUxmK/h/uf46PtXYtAM+pffkg8nisxKEmdTHvoqLqGWw?=
 =?us-ascii?Q?CK6Q0PqmxFOmOT3LFRSUcpAt2nDL3U3Ide6kKGIc0RzsUp3HHhN8VPqS+wb2?=
 =?us-ascii?Q?8wizVDF0pAqYaqMThWG22WHRAnJOlQgjhfnM1ABbLrDk+NknoOA+tgaCrROr?=
 =?us-ascii?Q?bpWPjeNO3yPmAyH894kOjxY5THJvgvj91cUzMb+egftvnzm86YfEmOXswcdz?=
 =?us-ascii?Q?t1sZVhrBdIZl+eHIQmjMS1AGpJJheWzn2OdUQ671zxaeps8wEQukzjL/3mMM?=
 =?us-ascii?Q?1WR7xsNp53xxjOBO68zvDIF89XCVjNRk//Wt18BxdF1nTFjYu5eieilZL8ll?=
 =?us-ascii?Q?cUUyxtkx2s85/U88fB2cb7tiOI89thnw7ofJBowu/UKPYYsHKlYQZqBLgaDJ?=
 =?us-ascii?Q?7qMVPHKN40uLgsGt5M4YCVofjM7r3QepDEPe5YTmiDNNe5rT9xlOmJOoJPvY?=
 =?us-ascii?Q?hb8OCib/Sqcv0zZoq85Xeyu2xKu35lX3D0Pqm/hEW2/azVWRLb/V23Po0IGT?=
 =?us-ascii?Q?NLjGk0CKE101tvr9GBcwacMq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f58db76f-07da-489f-7229-08d925705e5a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 02:44:40.0122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a0JA37/qijL+s6h6wmS6N2J4nMBYYe6zeGKGIDbGRau+63Nlo0sWRgRknubFjaR4AoiU6Xn38hQIi7bNdjqipURJHDG8pKu9wQ6+6wjPfg0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=899 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020015
X-Proofpoint-GUID: NtuZNoDwTWpVoBsZElyg5WXNnYftYugj
X-Proofpoint-ORIG-GUID: NtuZNoDwTWpVoBsZElyg5WXNnYftYugj
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Alice,

> This series changes the hw reset timing to avoid potential issues in
> MediaTek platform.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
