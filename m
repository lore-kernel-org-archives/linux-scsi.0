Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E0EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4CF160F44
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238979AbhINDp1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:45:27 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:36206 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238424AbhINDp0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:45:26 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DNXjsC006606;
        Tue, 14 Sep 2021 03:44:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=t7n5sv/DnwJBGC1LTFuG92JcltiC2Pedu4YKDIVKpwA=;
 b=GlJJsWo0rrtZpnpq/zcxz4WMI2qmfa9xwk6AvEZJVjvNNHJFL+SRRfyu9zAHArxwiXaV
 rVgOdrNlKgvgG+LfdYUs4ScIPMr7XI1l58ZPiSfCHzRXJIHlL67bUY2AWXuOTitFs9jm
 tq6ly3j4uYI8EfuDQR8HIY98PyfeAcDYpxhnSQEjDUNwtEBAeZwPIXdZBVKjzKx/DYrV
 lH8SDbBmy34+xaZxHNEH3mUJhcuISCVgbgny2BlMuCPCpRfsaYWsBcag2bGzGQrg0jze
 fV9gC4v6JdAjEJDLn+6CTCspD87khyWp9YIeOO52qC15NmzbFSBUBJm5fPZe6p7IaW1S 7w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=t7n5sv/DnwJBGC1LTFuG92JcltiC2Pedu4YKDIVKpwA=;
 b=fv74FZLobvQd/ozCPlTHht2kGL8LkKwwS+lPQfTbR7f1RxjepMJHP8z4K19jeq9sfLl1
 /pEKaTpmKtMjR2CitNuXhWGi241PC8vjy945hZ7alu9jRk+MYDo29feqQPgWL6ZmWESE
 SShWafM+JSYg38AjCrAoq/KxzT7zT9AwJ6g+cAuo4voBUU8aUAfcJqycUgNEK3vhuIJU
 pG59VJ5KwNt+0HS4NzGU25geP4G/f7P5XRJhadvhf0uHI+IMRS5ho3bdqy+6PXGkwX/n
 mPU5qJgAj5uNBV4ocozxVKsB4AamYNohhIMAPndJGxxWTHNkwD9+4LiwnD7B/hfGK9sG Fw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k9rw0k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3f7as097745;
        Tue, 14 Sep 2021 03:44:05 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 3b0hjuespt-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BpHlK53h1ozBfBBeulWBkoNo+oZiXb4H6rWnNpBmAPnfhYx7dhgJF2Fycuot4x7qwN96EZHIB6Y7nQ2SQ2lLv00xtC0UEvLWGIblHsRMvXMhmPzjF+/swU99FyEtV2aP3TTfAQgpSSya0Ixs+dcuxkKc37mO9KTeFFUY877PAkS/8ByqD+z8ynRbQgPTEV8eBYemLCYBv1dHeSVn+ox8/4GBPrAE1dQBhTAdlIHvGJyPcTJNCPw4oxpSQiEzAh6AM1cH9FsdObOngrATSh+2pfKNXcaGNCpKlStAxopKiaifJWfpmgcdFg2JkUHDD3cEusLHK7BKHzsQ11M1LU39bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=t7n5sv/DnwJBGC1LTFuG92JcltiC2Pedu4YKDIVKpwA=;
 b=djxuBqVKJ4R5iJv4In/kIjBNcsbZsTpaOfGxn3uqQq9Ds8LKI5Bb9fmEW9NMWlg6RLbRyhKovxcF2PcwNm1+i8aIUjDk0nH3XOXEozF1+PNFzVIfVdaz0Okd4ilWXBSo0CAGYYwZipnO+VhfjLApTNkkM1ma+nFZewALGOsO+D8shqKyvC/rM5d37lyLeTc8G2pOuXhvwziBXU34h7egCR+OhZtC5gkdE+3clea1t/vWbSSx7289zOUfiCYgt8qyu19TCbNvpY87eBiR0rh3+jqqbBwmQ9SEt6yce95pICKmhW6QJx6yNnFrXW2GRZDoYhF/al0BQmARlFDY7RRwTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7n5sv/DnwJBGC1LTFuG92JcltiC2Pedu4YKDIVKpwA=;
 b=fteSBAuCpJ0dc6NlbxmbWTAMc2LMjbi7Cpagnm0G7FQj8FLl0Z8zvRk/5/BhswEHMTlhtlvBFd0TBUpsQFQSgp4Vp337euXDZePD5N45tLDt3vOcFgcQLmLDizNKu77XO+VV59xcvQqHnU6jZjXMPigDuv2mgAcut3xdIlp6K18=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 03:44:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:44:04 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        CGEL <cgel.zte@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Zeal Robot <zealci@zte.com.cn>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        jing yangyang <jing.yangyang@zte.com.cn>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        linux-kernel@vger.kernel.org, megaraidlinux.pdl@broadcom.com
Subject: Re: [PATCH linux-next] scsi: megaraid: fix Coccinelle warnings
Date:   Mon, 13 Sep 2021 23:43:42 -0400
Message-Id: <163159094721.20733.1482965968566785712.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210820030805.12383-1-jing.yangyang@zte.com.cn>
References: <20210820030805.12383-1-jing.yangyang@zte.com.cn>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 03:44:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f979201a-9b94-4edf-b49c-08d97731e5bb
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4502AFE0CF974595AE0923EC8EDA9@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xdX88drl+CwGBsSwal5Gr1WUcDdGuYOjCpUIaiW9sEFPsw0HcYDQ1LNhPRcE3zKhdxki9QNRcnYqqoVHZNs3FVqqtar+1LFGn3nt8j2H2afVQYAHNepuDXLFNhglukVlz9Roye7yTWTiqInw6L38/JfiralSsXnkdY5J+p22MX2Q/ufaAG6aD2iaEvffb2RMCcJ8amCHXz7trFWqaQ8/jddkLxVPdBYSspbQ3dXe/svtEAvLWQVO8R7etfyKJaWpxe6to16nwVZKNcg6SwlzKwnVtTG4PoJbAkd3yYXxHqsrPWd3hsoM+RTmbylImLSi/+y+s2GHUCad7wVZK6FnzCwe3NNZZ8yjjABFJ5z2DIUbbPH3M4AhKMFmgTbEhn25/E3ZbdhLbPF3zXhWVDmiGrFxVRQJHEh4MbkxEdBOZTQd4tnp11pmvCbZSM/T8lG0cbZYsSjZVPFpdZ0GozFMwny166S4ZdZmupHQ97qWnCNJ5ow5pyo+Ejsx3ttnt4uGJou6ZrlcvffqzTDKfVUhgsbYYiDuRdsB5tEDo6N57dGBRraDpsa8y2ZIdZB3y8aGZr1ySFyyGR7PfRuQ7JI8tb0WAHTQqwh1ew4D/AMVPQzLjpkkBOFOO+moQ8/qD0ImA9f0syBGz3hqzjoWLRIiRlbvezaASbOmFhVwZ242HZ8zR0wf7yCNJMeAF9IPvFHnnR07UZcPkDL9cdoOah45I528bmK1SM2G1rT91J0EyzzgPyyP9SwgnY++nh9osRMx6L43mWq67Y4Ab6tmeAflHDCgSrwPAvPQRBTbN7R/aH8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(316002)(86362001)(110136005)(38100700002)(2906002)(956004)(8676002)(7416002)(36756003)(54906003)(8936002)(66556008)(66476007)(478600001)(38350700002)(66946007)(6666004)(83380400001)(6486002)(2616005)(26005)(4744005)(4326008)(186003)(7696005)(52116002)(103116003)(5660300002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVlUWXROMHhMY3JUQXg0anIxODBjSStBZUtjVXpwZ01mSmFRRmZFeDhuYUxa?=
 =?utf-8?B?cHdzQnRhbkQvcGcybStZdkRUNEY0TDBqRk5YQ05pK0dybkRpQllSOCt2L2Vv?=
 =?utf-8?B?L2dEcGE5STRsOFdlcDBzeFcrVU8venRFVnMwSHFjK1NDNkxEL3FzNThmaG9x?=
 =?utf-8?B?a0N4NUZpaXkrKzQwNlVEaEF1R25NRkhyTEhEWklqRWtnckdreWhIa1gzY2Uz?=
 =?utf-8?B?b3kxd3JETFB2dmY2d3JQRjZzdWhSWk03dnhzQ2JNQi95V2twVVpSbVh2Tnlu?=
 =?utf-8?B?dDE1Uk5idmtxbGFVaWdOQ0drQmRlRnlRRFFnc3JTMzRHUjBYQkFnYjdmcWVT?=
 =?utf-8?B?WHlYTmkwKzd2SXkvNXVQaEtNcXU1elVvcjhiejdlc1VVNjhSNHZOSGxnUUcr?=
 =?utf-8?B?Z2JzViszdDBTdCtYSG9NRkpmQ2pLdEJHOHdYWFpNZzJKSEpuR1ZtNG9tZWV0?=
 =?utf-8?B?RThpVVJmRzNOTVJ2dE0ydGtBdXBxVkhYd3Q3dkMrQTlLVUF4a1RHTC82NDB3?=
 =?utf-8?B?aGsxQnJkb3hzQ2xlaE9uZ3JrbjJCcWhudHAxQy92UktVM0hqdmpxTXA2VE0z?=
 =?utf-8?B?bTg5THl1aldKdkR4dEFKYVVudS9qOVJTUmtLK0lFVE1LeTVSVmF0UEJCQUlQ?=
 =?utf-8?B?SzBlY1RYd3dJR2dQeitrdnB2Q3l6NmpnMkNYWTE4M0phR2JjL3YrVmRtbEN6?=
 =?utf-8?B?M1dQRkpVc3dWMHQyaDEvd05YbkxZNUY5ZkpmQmh1Q2F1YjhJSnduUnRoRGQ0?=
 =?utf-8?B?NkkrUUtNNlAvVFp0OGlyR1hwNFB1Z2t4dWUzNENaR05sQzBVbXRDZ2JmM0FG?=
 =?utf-8?B?dVFRcWZROHJ1L0cyVWVoNVB1OE5oTVFYZkppbkNUM0MrL0NTSGRQNkovM1JB?=
 =?utf-8?B?SEhYMTdNR3ZMMk8vTkV1YVBXNnhIRW12dTRmUkpERklSUmgwdUEwQ0t5RC9w?=
 =?utf-8?B?aXVETnk4dFZIVXNxM043eStoalR3cWZqbXFPbTBOY3BNeHh0Rk13TmxUQXpQ?=
 =?utf-8?B?b2tCVG9RTkwzYVZaMk1Ob240Unl0M21iclpyRmszQ3kvOUNsMnZLU0cxQjI4?=
 =?utf-8?B?OWtsQ1NWUWl6bjExNVlqN1FVbk5qSVJBZUZCT0hETjRNYU00cWdtNDBvd04v?=
 =?utf-8?B?U091dWMvYlZFazhzL3ZOU0JYRXp2TkVPRHFGaW1ESUNOSnYvL1B5L2lHTkVE?=
 =?utf-8?B?S2hkUTFWNHVleTlqcTYvekpTQ2E4K1orVGdzelN6RWtqQmRQTkZmd1lKTFlS?=
 =?utf-8?B?MFB4Vld4SWd0UEJ2Qy9jV0VJWFRPY3I4V3k1NUpQVy9iMjR6anZxOW16TGpF?=
 =?utf-8?B?elZ3Z21TYU5RVDBCbWFDR3FHOTBhdmRJM0QyNWlTbVpzMlhwN1hBTlB3QmRp?=
 =?utf-8?B?SGZJWlh2eTB4QnF2aDc3UHpJNXZJZG9RZDBpVDc0em1raDhNMUZNZFhISUpM?=
 =?utf-8?B?OTNlQWNTbjY3RkhablRnZ2lmRXlOeEpDWm5nTERFdWF4VWsrWC96OEUvSVph?=
 =?utf-8?B?dHRNK08rQ2wrVVNzTlV3bTR0M2dldWc5NnR5Qm9CZ3o4M0YvNmdURklnQUVz?=
 =?utf-8?B?YVByaU5pbElERnYvOUNjcnNtSnRsSkwyS3IrN3JrVUZQU0VjQU1YVnFNVDll?=
 =?utf-8?B?dTlpT0RVUXZTNkdRajV1RUUrdXVuVlRIdWFUK1p4c01vRmhzV1ZISEpqdXoy?=
 =?utf-8?B?OXozZk1pLzRWMjcvK25yaGJMMGppazJhbGJnU2Z4aCtYa29VRzRSWnFaNHlI?=
 =?utf-8?Q?xWh89rAxq9fsT6M5JWjgLcQ/hk4Mdgp6VuUiYt2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f979201a-9b94-4edf-b49c-08d97731e5bb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:44:04.2864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0y0UFgTZgqV75Yza5dSeqH9U/o5SAnJMaOK+kb37DdB7adQKLMB7kP7UxWZr2a0r1RwhYuoKMEVCXvTofAWB/pZMHTQsP/omFLNVjEX/Ki4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140019
X-Proofpoint-ORIG-GUID: eEKf5qaL8c3AeaGaL0If4Qx-q_VdFOco
X-Proofpoint-GUID: eEKf5qaL8c3AeaGaL0If4Qx-q_VdFOco
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 19 Aug 2021 20:08:05 -0700, CGEL wrote:

> From: jing yangyang <jing.yangyang@zte.com.cn>
> 
> WARNING !A || A && B is equivalent to !A || B
> 
> This issue was detected with the help of Coccinelle.
> 
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: megaraid: fix Coccinelle warnings
      https://git.kernel.org/mkp/scsi/c/17dfd54d391e

-- 
Martin K. Petersen	Oracle Linux Engineering
