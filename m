Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19BDAC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E29CD61107
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbhIVEHR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:07:17 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:5366 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229495AbhIVEHQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:07:16 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M23Znv013571;
        Wed, 22 Sep 2021 04:05:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=0Bu0UlzF6z/2OIiTo6TD6RSesFd5Z4QrYKFzvl00New=;
 b=wcy6cj8RQLhxCI3SdGQWnJ77+moqYdZhLKGCiVGmBjR3xyJ96G+z1NgOiHogjPS385mq
 v08uwkGz9lKgyHQG10z4Ep7cJ5gENP2TrZn69YxvnrhxHGnazHRjg8B69/jJGovNUyPS
 vL9f9BhleoboTObEQ1lWVe5IwFpuIZaKzZvXH6sZDZCqgHmj34IBl2d1av27J4HcFe1m
 vK83zwRC+CNxBmwF09Qn7oZFiErK66AGtRL/qHZZ8ZD0u4yFr/IBaHtzgwPhcjsSvphV
 FWPSM5G2ylwplReQPSXlMMSd2jyv30PTu22MUK3vQMCXV99zGNUYAMbW/vV4hx2HyL0K 1w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4s17gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:05:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M45Zq1033820;
        Wed, 22 Sep 2021 04:05:44 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by userp3030.oracle.com with ESMTP id 3b7q5mba5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:05:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kv16XjGav9lFqZ/y5db58P+RNZXw5QQtgPct0KJoG4HltCLxQvgnj5yEe8ga0UNUjW5o5Q5h8BSnqWFEHmhIVqCIVSIHUJ5WzAjwCWivSmBY8XFQGklNV3weCd0JpIKQ0VTAmC86qDmNN2RkjsFZiy4R+imLd58XaAzWmm1Gc2+32ddgL2VdwpClkvLHrG7ugu+oFnEBCGC4OqxVzI6+9UuAXyuEi+C7Z5Vk5AhfEh6/LsOFSb8wEORp/0Ss/x2riIu0SpLXycteVs1Lq57LzXkFIZUU2dkL7vhgzB47NZngVAYl8d9p7JyQqcG2GnsRy2dXfXmHpU0xtOPaDkesUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=0Bu0UlzF6z/2OIiTo6TD6RSesFd5Z4QrYKFzvl00New=;
 b=ZLjIR98UsXJCgMDg2WWVhI4JqGZbfoUIlNGaJrWMQd4TE8StIhaUw+yu8FPM4nCaFIIa2dnzk4knyREmTzvdmwS+HmGxeZaJ2eZBXMuEMVsO+T7mV96USy2+y7Wrqx9+9dQFbTMG3DKej0Iv/4+jI2MImNiVxTwm1aQ8qFyHVt7+yHmTkUW10gsCDtYn+Yq29n46oLrOafgpIDQJdPJlL90BEpAK/FTGllpAKic+Cye9GWK7BpHqepWsEa8fg2AKHBG7RkolSuAEXKgJz+zh6shOGXghjSjGkoBCfkdvIqF7WmN6aa0O3QOFUTSO2s44QvQh1jKpSjopzV/srD450w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Bu0UlzF6z/2OIiTo6TD6RSesFd5Z4QrYKFzvl00New=;
 b=StgaCa807Y0DTLqnKTL0C4bbq2PjU64bIte+ZD+v9Ed2sobzovX7fYdWXeMbMLcsgjjEPQJTqtOohXzRfMDIxhCwmDKoSn+nirugBLR7A/qFFXQsBX8rBiIHPfS9jqcPbAwmbdy9Bxi1TOiRJt2ARj/NhJY1nQ9b+UosM2KdNmo=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5644.namprd10.prod.outlook.com (2603:10b6:510:fb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 04:05:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:05:39 +0000
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 0/3] efct fixes & improvements
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ee9hp854.fsf@ca-mkp.ca.oracle.com>
References: <20210914105539.6942-1-d.bogdanov@yadro.com>
Date:   Wed, 22 Sep 2021 00:05:36 -0400
In-Reply-To: <20210914105539.6942-1-d.bogdanov@yadro.com> (Dmitry Bogdanov's
        message of "Tue, 14 Sep 2021 13:55:36 +0300")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0051.namprd08.prod.outlook.com
 (2603:10b6:a03:117::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.33) by BYAPR08CA0051.namprd08.prod.outlook.com (2603:10b6:a03:117::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 04:05:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd9534f5-5048-4185-9846-08d97d7e3cdb
X-MS-TrafficTypeDiagnostic: PH0PR10MB5644:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5644855A8AF5699F55E543478EA29@PH0PR10MB5644.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wCWRnwp+bCWHkqfnSP1jpYydB9HdydqvqUUqNLZ1hNEn4XRWUmxNSVCAbHCt6xfPgap/MAl1HWFo4z4oVYoKUA4J8/G5rKS0Qmr3ktzv8Pixzsgyt5ixWojDoetwSsV0bDBWVY33PoObrA2sCwCKJA51ICoiT+HSJO+a0bRDuERJijc13Onh5ajfRIT1F3IZGtA02yQA4hySn6Qt/Zl6kEXjA4TxPW58cokRjrdDywnte9bpY67Xxwk9A7rB8gCktSmBRvEwIzXUzJbsfAf5bi/M1VjaL9ozi2W2p/65Icxcu1qEL1mvtNDuCutH+c/E1CqY3NXGogW4syHFxcNzRE96UOvn2goeby3+0h8llpzaTNguxkjF+q1YQz1Q2+Er56OxjVx8CxBwvuRz690FuX/g4HPSiZ3ySzTSSQM26VKkC/TFZQCX03/lO6IRXZypDn6wEkvtKD9jSAgi3HnOGbKN6U6cqn5uFmhQtcqN0UeNfCGr3Qon/eZTH4ZG3l7vcOTpL0dHujBGCrJSUUoRjbwgbMyEpDZYvuv8Rl/6IJ382NIXNbrNOoMt0qnFzNsHPLuLGPOZWmTTnNWIauhhXSVABlHY5ArTuUxLFL13yaBcrbdObmj6kxr1Ft1PuL00wIJib1S4+MO1/hGzsZ29354W0rGs+u7GwSQpkopzk80bo6HgxryucuDrzS8uvHqN5fbNU/CfX2zltVbgKICUIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36916002)(66476007)(52116002)(8676002)(8936002)(66556008)(7696005)(508600001)(66946007)(5660300002)(55016002)(956004)(86362001)(186003)(2906002)(558084003)(26005)(4326008)(316002)(54906003)(6916009)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iiZBlzD4Do2uRoNiTzio1ud/CGy/z/BHmRtaz6FG9pwP34iuqlXmzuui0NQy?=
 =?us-ascii?Q?7sssGt+uIeouRvRxqKwsew7aAVx9NPirgT73SK6ho9VDP9vxPLOFEtjUPIIw?=
 =?us-ascii?Q?yCKixrziny5iDwf0c6lA2/Ip2L2Qzs373GcgfNWg+GBRyGnLF7UlVO/AiUWr?=
 =?us-ascii?Q?t+fE5H5Im+NNAa4P4F1XgJuh2S8UoSLPt2OISxQMV0TiWLaNxaboEBmY6C0J?=
 =?us-ascii?Q?kpd4a6Bpf6vJf90lJDRZISxuUPGUZRG9ks4sgiE/T8/8ndsCOcty9A5SMaqQ?=
 =?us-ascii?Q?HaRc36hgHk7NCUW/nG6xxUA9rF6Rh3zx54Rhpv1NJW29p82sAd79o0jVA94F?=
 =?us-ascii?Q?ZR3x3hzCguRYY52UTjWrCN7uAXOM96/7jiyTQXqBdt6nBVPihYniq7fjuFK/?=
 =?us-ascii?Q?W0sLEkm9uJ/uDFQ2TFBpLIzuvjeNcVtkKPDYC5+vlT3yoU1yAtTNhLWbAAn4?=
 =?us-ascii?Q?cG+qiX5sFMlHxbFoD+UYBb+BD3mIXmn0IKl8Ci9gLgpRlHXCElcmadU0ZSoy?=
 =?us-ascii?Q?FK8DFi2RAEfkUud1syq0j8h4SuDqRLS8BB5B9lLmO6iY9hUCjmGpVPwbVKL6?=
 =?us-ascii?Q?MnjDX3fnadSevpD/jtLA1p3MD/pp7nh1N7doLEkceGnnaUb1pbXX04Axzl5z?=
 =?us-ascii?Q?A7tCbSJv9aaWWtKc0XNo73KQ5BgMMUbOswYfZ+ARR4UA+lNvg8F9BANNzwVe?=
 =?us-ascii?Q?OPI1ilHmbzi6feHRjl3v0URGZ1hzbgCJlvsr/s2t7b53wUT5rXs+IKer1zHG?=
 =?us-ascii?Q?WNeA9YnfRjhwpw15f4zPolBWBM9GnxTOXy5jujhq9u6CaySUNpoaOjWO2h+v?=
 =?us-ascii?Q?QpWH6fXrM4Zl6zDmQ0anbW0WQqHTPBYPGCq3obRy1RcQmwg+EEQchtOdsmNV?=
 =?us-ascii?Q?/CFtbOd05egVjxHekAtrZWZOdE//D5AvZfXgDgyc82sBqUaKa0pnlSL+L9is?=
 =?us-ascii?Q?8tfRLTwOdnSwSis/nu7/ZkrrmoDa+QK1qZXGF5Oc7gavFfVfSSXeo4yuNFSq?=
 =?us-ascii?Q?tN52Zlre8HGf5tGl3H2/DB45hHCipx+DVfy4EOZ67BDv3wuqUOctEw04RDis?=
 =?us-ascii?Q?a66wrtgoXoNjRfmnC7a2tiO+poCJr8R8uZvcWMLRn+JN3zhb42tdtCn2uQqW?=
 =?us-ascii?Q?1MqQzM8kgZhj0l4GzjkC73BsZ/0iacX6GNTgQqgdoSnzFwQFIAY96S60Peyo?=
 =?us-ascii?Q?zd26Opd1vQDRGr67/T6ruw+iy7SUFS1LM1FXapJZSJ0hg+/9wFfAhfvkMsQ5?=
 =?us-ascii?Q?MKPO3ggQXKj1NHK3h5ALbdgGwquLvD9Nmel12rRC4ZscL/V5njBTJx6OaqPK?=
 =?us-ascii?Q?6leq2HzzqNG6QUqN8rwXEgaa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd9534f5-5048-4185-9846-08d97d7e3cdb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:05:39.1335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j3fRlAjq4Vl6me5O6BIjAlAd4SHZdgZsD/4QCrJsgSm5NKcUrJBBphZ/9QJC4xxrDnyn2ErUfDjXxXvJltWHJrlDWyVnggTaQI0ezyDHzMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5644
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=763
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220026
X-Proofpoint-GUID: LdLejf5ysNwBKZ_cnz2v6ahScNY0xNih
X-Proofpoint-ORIG-GUID: LdLejf5ysNwBKZ_cnz2v6ahScNY0xNih
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dmitry,

> This patchset contains fixes of some isues that were found during
> evaluation of Emulex HBA as a target.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
