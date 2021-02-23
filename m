Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0871C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 03:26:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6123264E57
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 03:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhBWD0d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:26:33 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43230 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhBWD0b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2021 22:26:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N3Aukq140152;
        Tue, 23 Feb 2021 03:25:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=BI7j/Qadjd728YLQ95wco5nLbOR0WTHdBaKMhcsg4c8=;
 b=J6EArwJhLej9MR7oIXY0rdcc2n9/K/aE1uofxSSDIQxjA3AZcyHUUtEsteS2Cxr2o2Hv
 9J4t1uU+MofyOjNtolIPh/dhp1osbGbKl6GOPiTI2KPqarF+LBRjvQJVckg6CSDlIVo3
 NSS1JulPvMp+IKkl8GED/wPIwzHRnRbCn+5sa4FQom+InWl21zGmuWceQvihTIi3JLIT
 iq6xGugeHoKVZqEPqCwLp5ZXtpGLlptDI9zFFunzZcMLA2q7Mew1JhfH5intFk29kuUT
 Hry8E65UdWGRNlqw/UpeKvSf7TDmk2vJjjJjVTCSbk0XZNP8GYSlIAIyAW3YJHFY2w4Q vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36tsuqwser-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 03:25:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N3AYCk102267;
        Tue, 23 Feb 2021 03:25:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by aserp3020.oracle.com with ESMTP id 36ucaxtjhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 03:25:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=esb/74PGNkB8pWipzpxgpytZMAM2TeFK1tiI1221wCSfipb3fGEWcWjsam7ip+lS1RZzCua/DqAXraJ1kwJNbs+AO6mOGuKg5qfn5Rj9kaxgqm0k09gY/Dowhfik16R6bu4YYf+D4ucsSNPyyNkNLuygfTIYReFSV0MXn4QFeqn4J3zLbOy/x4Arx4Q/UFN1EHh5OKgnh2lS3CW9B3HtDf9iOav9LgjUY/WdK5fUIOx2o1C+mFly0X/Bt80mT4lNWgBmJSnNzFrX8zsqkSlc1q7GVXpaHh5EapZ78osAxwZnvejZvihLW3sC+rfASnfyyviTU07WL1UbMVJfxDHIXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BI7j/Qadjd728YLQ95wco5nLbOR0WTHdBaKMhcsg4c8=;
 b=hmbvA1PsksDomsHxJgYKBJk+uJck/3KFsbbynAj9Ypl8zDTMhp/RzPxO4lpqsk755nFdA6uyvIEL1YzL56WmZRLSG0MgFgiiFu3UKOe88srJ3Xp+z5FLbrMJlhpdoqUHTKydJ5ouYvAAovRr+7l4LuLeqzC+8jcKW9///ymoHuzO/7H49Awc3tb2qbkMTV9vnpL/Vfh73/YgZ87GwIiGl+BMayGJuCyH2sw+kkmdoLvAJ4LiQSbS1yvk2EXxzOqUpeKHAKjSuL4K9WI8kZ/pR3uOjyXmWli9LpqST7chfm3WS187YfyJ+YRzjfTa8uZQ+qddGdkU8mNx868n8/LEag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BI7j/Qadjd728YLQ95wco5nLbOR0WTHdBaKMhcsg4c8=;
 b=pWeA87MmiDfcRqOowdVckeYfvJ9Zovro5bQKVjtoCtx23AIzCa1tATGbRTC3fxVTJCiv66474YdtnJOexscsaLUggpZbNMped5f1RiMp009/Ghk1zF6aS7EwI3uBOd8Z1TA5+YPuszvk461ikkIrKHlgnIwbj/0DJMm63zLq+FQ=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4471.namprd10.prod.outlook.com (2603:10b6:510:38::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Tue, 23 Feb
 2021 03:25:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 03:25:44 +0000
To:     Avri Altman <avri.altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com
Subject: Re: [PATCH] scsi: ufs: Fix a duplicate dev quirk number
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dmzh3db.fsf@ca-mkp.ca.oracle.com>
References: <20210211104638.292499-1-avri.altman@wdc.com>
Date:   Mon, 22 Feb 2021 22:25:41 -0500
In-Reply-To: <20210211104638.292499-1-avri.altman@wdc.com> (Avri Altman's
        message of "Thu, 11 Feb 2021 12:46:38 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR13CA0076.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR13CA0076.namprd13.prod.outlook.com (2603:10b6:a03:2c4::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.10 via Frontend Transport; Tue, 23 Feb 2021 03:25:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2d037f0-1378-4719-262c-08d8d7aab420
X-MS-TrafficTypeDiagnostic: PH0PR10MB4471:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4471C1132501360FD59D265A8E809@PH0PR10MB4471.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Mjs3doTf77LysRN44dGe63nxXAVH1UQHPGFiaH0iEdQWj5JcnorUjc1MoUTVWCrb7FsSmyymIW/eSpqi6jfZ2aObNxHoOwB+jQb4sRDyRt7CCGOaFmRGh61WNRAjtHORTBhnyqzkW+tKpaMRfbIwtdUNQF1zKvvxRSb5QFPrg1DpCq3Vnl0yMcLzQb/yXcKusD36MyICsI89xRbrmnGRkxhpvs0DTGk9bS5bovZqu5E9+g0q74K2eLhbY0MKMz8rPJUC4jnC74dvm8TwkJYfKezZJzR/IDTdWFwG/AClQw9cW016wRCfxoCtyBUAeMJhDYSyYHBtPCtZ9xZNZqBwrYUj+4fmo7MGw8W+W03WhRdlDbNJh2BGa0J+jG47wnXmvZ1BIAqOqdz1LfASxq7hdplH2LOfltKlUUkHq0F5PNhXtf853eqlOxoemwNuOOFyr96h0d/KD+9d+dIWlgaBoYzsp5QqVb7NZNLjs9GWBiGA8VmsElZ341zsmrND9O2z5T1o2jvOa/Vkx9M8Nm6bA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(346002)(396003)(376002)(6916009)(7696005)(478600001)(16526019)(956004)(8936002)(36916002)(2906002)(52116002)(66476007)(66556008)(66946007)(5660300002)(86362001)(558084003)(26005)(8676002)(4326008)(186003)(54906003)(55016002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?z4lFZAyuraTm3vH838BxQ7p97665J1Rj6lr6zKZ0ltxo4ns59nghatZyr+HZ?=
 =?us-ascii?Q?/9Jwa8vd2m8aXISGGOhuWwW1q4P6LCfyQZ9Rb4hMRSZgSkJtmD8QWaJgrrHe?=
 =?us-ascii?Q?2s5tayxyeNbjTk19UfT8XqL6ZZ3R9PcyZpFb+/HcGpq7AzUPbobf+lnP6aiu?=
 =?us-ascii?Q?9YrkcsqF3lbxkLu8usdDfOANNwsTJyev17iEkRZNJzzwzUOT230WupU+x5KE?=
 =?us-ascii?Q?Uy6guYhFbHamgRluYZo46O5cV5RXYg1Ugm1LZn7X59LGmK+bN7C9oPcloJJw?=
 =?us-ascii?Q?Mpzg7cBobqsvHISG29vx4k3lVm9YYV0XZ1D0UDmCo7lou4M6QcbMioEGn68s?=
 =?us-ascii?Q?Tj3kpKw+aDYhJzz/b+E8TdrZoHhSTNJaE6KxC8mu5aFQoIYEfRBrGDAGtEU7?=
 =?us-ascii?Q?4JyThFhVGmypXZIaVSXFNoTJ42+PKPFsLydzbg6I+t0isJRthP/+hAUrj+JJ?=
 =?us-ascii?Q?Sl4NUsDRJ0BBq9KsCprA9QMQKwyS+IjaneqsIln06WMcp7p6cONgjTlzyaKb?=
 =?us-ascii?Q?Xa5zIiEskJdBCfoiK34kNLtyTTchIrUVsAst9sHSqhWts0hyorSO278WaRF1?=
 =?us-ascii?Q?sznDXu7f4rNUEqfVDoO3gBwVcCiZIyos+lhLMpL/SNmwWuzMti9XdMcdw2N8?=
 =?us-ascii?Q?yf5pCRc7j0vI0gdkl0IUJENBtikL4nSpIq6Wj7LXqbKJOC9AOCwfy077Ws6x?=
 =?us-ascii?Q?SntLGsyze/XMzwrNDg8VzGOKAgDCiIgwTeiRHaaOUyKwUZ/kJ2IN9dRTSMzV?=
 =?us-ascii?Q?/0YWQXie/xhEaFgIcE10RD6WLWk5OMOi/Gx2xbi3aJ00gSSonoEnGLDiLO8L?=
 =?us-ascii?Q?BA8vYTQCpiWUdtSe/MPs8RsZrbLp4N+omT9H/nE5GAIXqqWQ+Lt3iBDqq19F?=
 =?us-ascii?Q?34iMSW9C0eCrM4eX3wjH0QhJ41VDTJl43askwUPv0YaCC45moWzqbELxM1r1?=
 =?us-ascii?Q?ny1gxrfxhm4Mmr7IZy5fSPFszS0V6LmjpV6WMEAMAIUeyNt7uf5eVHJZGVr6?=
 =?us-ascii?Q?V5t+il9uaeKZvb7NsEJoN25d1wlUFiO7UQctb5g5vkwjhttb4U1aplNa9eJ2?=
 =?us-ascii?Q?C6FT8yIAF6o9g0YG2EYIsDrMNPKuAfv9PLorrw7NAx4UUMugV/OLLutm/CMi?=
 =?us-ascii?Q?az7SidHxCiYLODmLFUjTNF95FFn84n1HHQBXzqAMKOzH+bAFoMsqbhYHYHOm?=
 =?us-ascii?Q?hx3kS1k/N/jhKwm49rOWmAzLwwodeii9U8qkZcaoWgzq51l3syvpG8Vvf4sn?=
 =?us-ascii?Q?uVgbknmROmLo6y1mz1+NM67QkP46arK1NAvZKaazBuszihmk66xvwTaOHzYe?=
 =?us-ascii?Q?vC/X7+PTSq6GwqwE+/9jwpeU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2d037f0-1378-4719-262c-08d8d7aab420
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 03:25:44.0537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 60ClvMGFgXHBXZjsS//2KXJdmeCi71Bqqsb6KvNVCLDSBW38/R3XYRBg+5wLVeIfci8+V5KCRw0fL48nimVs5ycOeLO1e2oyjnfsLr02zOU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4471
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230026
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Avri,

> fixes: 2b2bfc8aa519 (scsi: ufs: Introduce a quirk to allow only
> page-aligned sg entries)

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
