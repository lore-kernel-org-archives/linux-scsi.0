Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 295F5C00144
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 23:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbiHAXp7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 19:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbiHAXp6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 19:45:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BA346D8A
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 16:45:57 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271NZV93020543;
        Mon, 1 Aug 2022 23:45:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=qxvwR4gqEW0Hg3JyZZlm1ILUW/WhD7X2mELhSRIkcq0=;
 b=Q7PPVXCxLpwU0yi2iXJhIe+y858bcBU+swgZRNPh6NrHYcFlD0AFVhd6AQ7N/qag0vZS
 vpSaF57op0BFMTeEV/AmoE9B/p9O8MHGo8RWHQB/vClyzNdJhSrMfudOWGSf8+uhdO9I
 yR62IZwZCyitrkY9do+4WZSrAwbU/yYemfFnhE/PciYgoMURsMoVFydz3AZYKGmpeDxH
 +6ki9xf6HnDJHLyh5fz7LFphWC6ZMjtcAnaUNgQGASKiJvt+XeYKZDaGvEgU5jAAO0Lh
 LlyVkdALAIjXZr7Sj2WgudeRsMUWee0orfvoJ+Fx4yrpcm27xL6WGf/PeAEM52sOtjZN ZQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmw6td7e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 23:45:53 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 271MpcWJ010784;
        Mon, 1 Aug 2022 23:45:52 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu31quyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 23:45:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKX4ZTovo8zc3pVrU+JH/6WaAkWF4zemuVN9W50t+zT30XoAchakEqRzc7Mo3uvIpQNiRgVVOaQdOLbTku6GMkKpB0RjqaacwgcOCjIN0uHOxel2bZYvSYlxFfUewKOXR+58MdNwTsadk8VChH9HKuoR/wEl/q7v8xFN4eF5EBb+SqVAkgphQen3iFu4V/KaDZAal2EqCkwmakcKOMsRSOZIGoEia2ir/mvVq9TXi5Nzq6IYmDRPCYAbc1+nmrOn2JSijNyc45fSlK3qZYRiHggsWDPT65hBHEyzBn81m5gr0XhaL7ayDCvs1GF8aegws6fpTtmUhKL9R36l/qfyrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qxvwR4gqEW0Hg3JyZZlm1ILUW/WhD7X2mELhSRIkcq0=;
 b=Knk3K48nTqU9AswQ850pBLMNRXdUW2uDKvFO6h4aQbwghxyV/vu9hSra85dY/ivMDIw/ridfxCZB4dDh9HNtMnt36OpJBqJKaQI1oXxgxyqmVsHTLgnMO++jPlRvY2iIhUOnfuhlLufj8L63qg+MU02T4GLYE/vDcpvqIgwr5BRsOJNTE74Nr1o8BT55eyS5FDrswWCxU6RlaulYrCT1x6bSw3sceYs/CMr4lg2RgGSwO5WQ2juzSWZ4aaBRHFoRdHZOOUZWMeGbi3Yn95ohIfZm/UrpW9b29kwQiF8oER72e6pn/eiZBt9wBzjKRRLHCxvk+gsfHQssiO6Y7kNBmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxvwR4gqEW0Hg3JyZZlm1ILUW/WhD7X2mELhSRIkcq0=;
 b=T42e56oxxsZeen2Y11zbGH8RMH2KLXgQ+/Dm2MYXVM7lwdrKbJKfhuoZ9b0ELQnkMAQAYNH2UHem/qMi9Zom5sc4jrP1kKdaAbXIscaMo5pkO7HJs0L/6KOKdYe437AS/SZhzn2bsKB3csZYZzr3QsnWtkNNHzY7P1deWe/p9ic=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB4913.namprd10.prod.outlook.com (2603:10b6:208:307::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Mon, 1 Aug
 2022 23:45:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 23:45:50 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v5 0/4] Call blk_mq_free_tag_set() earlier
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17d3r4jfh.fsf@ca-mkp.ca.oracle.com>
References: <20220728221851.1822295-1-bvanassche@acm.org>
Date:   Mon, 01 Aug 2022 19:45:46 -0400
In-Reply-To: <20220728221851.1822295-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 28 Jul 2022 15:18:47 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0235.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4461768e-dd19-4ba4-9a3c-08da7417f6cc
X-MS-TrafficTypeDiagnostic: BLAPR10MB4913:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OFgYSDsuehnpB8wi4IVN3SfzQozfM0yFJjFUCzQhU7WoJAo1sMi2CERDVVtRINIaIb+GYpVRTIRU9+1txFCMnq9bqNzX1gekyPCZQ02zhuKSHkEMXFABj5XNJLZt3YkR653dOw8WMdvF3KR2ZKV4f9LJ/Es/khUujnPX8T/2i9N2K82lvKevUEah4L/DFfaksIkIoq7CZUprzdzdn2+SzGYhb6GmRijm5Vslu9KybxrqmmroB/WHxuGfuzZWgpLziAmmTkpUx8my9PWm/4bzRaMpulijIdIVHTRmhPOUk/ljo1JjWtlOEjySkz6YtrSUZI9VRI4IMd/I5mKyGbb/NEiLH81cjcgmNtWGi5qbbbMDNv+UusO5PdPic9tTf6+v63v1T6P15EEz93Sk0bvygNf/5rtvX7Qu2LkV4z5ROSLriwfzcFyM7xyU+QwHiANHmqzSBSE6+JrNhJR1adKPszbXrQ8Pn7E7lk2JGddzjMQ3jyd2b/hrHJGr4O48+MeYyOEC50MfR6b9K2JH6vnsi7VxbpmZQDiKkCzecu1VLv4aG+Q+rlNMAz2vbODpsgWFKlrXOX5dT1eaTAvx0MSeE3+RdeXtT3h/DBe5iWIdxJ1/qiqEtci9v3ssRlCxA4o0VtS7GmO6kD9EEB2gVTpLFpRcTbqPP0o5akC4sk1H0Uq1HzZeNRaC4txE9rEvYbLbwFCsl8aaBei643BGHW01mWGRAt6ebQKzHKkJ4KXnpJusVdpjA/gOK4WMvPAtSkBv+7FG14abzGtM9eBLmWhk8bJzVfxVJWidfnwD7bkn3+exPhC+KWwqxoiOLJrMvxRD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(136003)(366004)(376002)(39860400002)(66556008)(5660300002)(6916009)(478600001)(316002)(66476007)(54906003)(66946007)(6486002)(8936002)(4326008)(8676002)(6666004)(26005)(36916002)(52116002)(2906002)(41300700001)(186003)(6506007)(6512007)(86362001)(83380400001)(38100700002)(38350700002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1f3rmzGhOonJEGVOdpK1snOdSw8v+ZVXLaE7npsOsNXMwzBu9ObuXSJOFFh5?=
 =?us-ascii?Q?Gjhdt7B1k0RYwLcHv9B7iq7VcvxlrY8nSHjDoFFGCYKSqO1Ygeg43pL188Lm?=
 =?us-ascii?Q?rz9CEfzWgs6AHekps+Z1xPODpAUs96EdL+Zz9opJljYCUqhHsZJOiRXZpR6Q?=
 =?us-ascii?Q?wzSnm3ahPyfeDM0YVSERaBOrZXHcQd+D3oXXW3Zl5eCQlKi6wuc1CmGXA0GP?=
 =?us-ascii?Q?dJ2rXl5Z6zwFU+xDgRLWFQgre1kllWQGn/kdVDdDSXO2Feh+poao0sbz9Itu?=
 =?us-ascii?Q?UnlM8RbiWv/dVaGfJf9433ZAiVqUtftHwadE8WcpcbHKPMfEjs+1Q7xGGb4f?=
 =?us-ascii?Q?4F8OjvVUNCfSkJNFJt0YvIKFa99BgcShfJRpgI8v0WX785SxTt3u2XC8gHy0?=
 =?us-ascii?Q?azvyk/MJsRQOuQIgvYrdiWYmhpI6hXfKJhMY6JCuAKBE075GfkME8dV2tqoE?=
 =?us-ascii?Q?X1g44g2PsiXeOHm/JI5syOIEzw1cFqbbKCwBJtuUEXOdlNLljtzLTzoK/561?=
 =?us-ascii?Q?q6b5oE5FiMTRIpgdx6qXLuONlfJP+HHUDqZbBLknoEr+C2+MeedZm8GzOxUs?=
 =?us-ascii?Q?KLgZAPZHV3Poe0DiNl3NZrsKzLYUbr4ukgKm614OIDIEenYlJ2F6phh18gLN?=
 =?us-ascii?Q?+q5PIdj7JjPLo2su6o2V5RH+SMy16UW6SFxsP8M1k2jyBVtsSA09B4I+XAMf?=
 =?us-ascii?Q?28uJ7bLcC2SwxZCZL+FL8WNcq+IP7BAjgYHUh2Rsw7OK4Egxer4lpUW0Xd0c?=
 =?us-ascii?Q?SIgvUPF842shkaf8JV0nJM6R15T9SPCClp/s0y8KYYlq3YxcBUVnSwT0g1ja?=
 =?us-ascii?Q?g3n3ejFZk8UqP1MAN+rJwF2dOl4+7KAd3M29X1u+/YKLw/60jFW0aLcZojgS?=
 =?us-ascii?Q?j3521RmqRFjSIsdTjmzWT8fk6rXIulDbYno3Bhfz02TzxE7FTJOPsKjjW/QO?=
 =?us-ascii?Q?2dOd0iPZANBweG5IJEfqHekpwVL6GocEQxnS2P/4MphTZapATbhVyv5kNkWp?=
 =?us-ascii?Q?OJmc/1V9KTg8lNg0orSYTusSnqFXr+oXgGFivGmahpy8SbsHwi+NWCJ3sYlK?=
 =?us-ascii?Q?uK7gSSlZRsVzSTLe2X83HOC3uk8jXfDH+GdejNcH40fB1UNoeeLYc3S4ztca?=
 =?us-ascii?Q?4xlAUj1E/tLUCLBV6iWNNDg7pI+bLeFVUQxL0C56gn0vMU9wFZygetnrB3Sm?=
 =?us-ascii?Q?b4JeHAiX+4sUWXoc8A0Tw+i2y06ibzc3XvNXDwcGEb+6IXhdtH5AS1h989VM?=
 =?us-ascii?Q?U1uV3sU1F1TAw45G7xOfVhauhWXmPEczvbQ63DgSRvs7uCwmiANDTu5oZnZH?=
 =?us-ascii?Q?+UUSWTyJ5A9dyfKue6mlSpjxK2drv4FRyNk6KSLR20s5VA0pe1CN5xG1hi0H?=
 =?us-ascii?Q?3DnEotXiZ5t9dP5ggLAibqVNaafrcuNHhAnoru/RLMmyO6Wx8KcOADqW6hjh?=
 =?us-ascii?Q?PRbUtF9XOiOreQbCy7y+FKpZxtEq1hcQG4RAOepqC7z5+D4XoOEBbx295YWs?=
 =?us-ascii?Q?I/R4KecMvGDTLx+Huji9+iVeDkhFpHb6ZaBJFntYcC2XubuazwMwAhekqfax?=
 =?us-ascii?Q?SZ/7X8LAEYLdLmi5Vc7oltCuKPjYz5IhaniC5SxZ+misijcGKnW0gYaK1T7F?=
 =?us-ascii?Q?Dg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4461768e-dd19-4ba4-9a3c-08da7417f6cc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 23:45:50.1426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3WhBnnicioG7JGxw2GI5bkqQqb+YpKrzjXZsr8xjkkWyGGmgRU4upLzxau2/4ArZZ7MEVVuPuawghkOHvUcgkuF7hbqt57R4oVz0ztIc2mA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4913
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_12,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=724
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208010118
X-Proofpoint-GUID: or2-3_3srEvIwsHBjrukOOw8SJdaYvK9
X-Proofpoint-ORIG-GUID: or2-3_3srEvIwsHBjrukOOw8SJdaYvK9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This patch series fixes a recently reported use-after-free in the SRP
> driver.  Please consider this patch series for kernel v5.20.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
