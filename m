Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DE4C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45E0A6161C
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhEKD1G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 23:27:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41690 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhEKD1C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 23:27:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3EXBY073584;
        Tue, 11 May 2021 03:25:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=kx25sdYwMojdQY8XbeqXAL8xkXLXXD25KJKK3ymgqjA=;
 b=cHVSjPtspmXHUW5twlnFhZZTa1Ijm6TMB3e7OnUzp7qhbFowSaKpAOhhTI8wMfgrRjMH
 snaEfnGXy/jjQiwcKK0uURo+2Dz8szkFKc6wkdx7twzaNdSOObokOgzOvkueocfLRCjE
 4+hqzPfEJDolqFgEUIA9wb7P4Vz/vGeKnkF1yxtmZLHEtwcXMKADdvsYsHQkNRxtEZ1o
 hafl26DArOadf9Dlo/YIbuDn+ib2yLTbzGkUU3ViU4y7hPP2vKmFv3kktxX3UKZhRoto
 kpov5JbU8qygXEZMh2OiMw0M/rUVU9szl6fHcPSccBGz+ZmhWQ/p4T+k4IDZmwdMdwuw gA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38djkmd7vp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3FvEA152680;
        Tue, 11 May 2021 03:25:51 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by userp3020.oracle.com with ESMTP id 38fh3w1u2k-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHfUWbMjDFb6NkuAUPc3KSQwuSBWomlDB/t5LyIF/AhL7a2f+F7uevdLMbv8ifTApAHyLX2ho/0rp+ByDiWyP+f48UvyHhhRAgStlxBrRHpCnJ7L2OjyMnixFAszpVeDytrhgMKx637jEdjxIA8SoBjl7wluI9D0K7jwwkPgVUkPcefWUOcPbOCapki2MdDlba8ZqkaMDP3GBRIPlqUGHZuhEasyS/6VBbcALbbaHc2p+KIOUxoGzki59Xjq664fNuroH3Q/5Re7jMnLXVpJnL3a1fWoAIyGt+0vECy+dEENmLtS8PyE8pgsOJqFEEiwDCkIckM6uFw+6sFy4M+fKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kx25sdYwMojdQY8XbeqXAL8xkXLXXD25KJKK3ymgqjA=;
 b=hg1tg28XOzwRKVCftR98JT7uFa/FnnSamNoq/dXb2xK8G/k3FQ29DK+mZL5UdmNbELB9t+cEEvGLaDrPLO/rGmW0/aZACAURYrwrwWDfEnF4J91kXToivTbv3EjMP+pQyH8IA3Kk9xhIvqJT9p+Cp7jvg8BMETRi7KdKDowBMzD7oLQdnph1F9VagL2Wm97MIL348r745ezr7l7AKBYjV01VX1BFjQeVQiYuur+l+vKfbJVy5/wub0/MBgmcNRcQslbg0HYO13ZGJc09qXwN61/Y0Rchyo+H0DE3jTvW0yl4a6O0qWmhQPOr6tYsRAyFDNQovq9mlpqFLRMC3mBmfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kx25sdYwMojdQY8XbeqXAL8xkXLXXD25KJKK3ymgqjA=;
 b=q2j3KyfsDzGEYaOfoB13F3/DqABbiC+Diiog//MmlKBUGMfVTc3qQS7VAW3+V1QSTqCB0FD5OeHM9j6sh+Wk3czMqjkm/aoNzWRl2YzByTMK34eJaD9YS1Ysobq5ptbPrIflVezbpMDlQqIvRGId807QSvH0U1OM8DCjJRhu/C8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Tue, 11 May
 2021 03:25:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 03:25:50 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: target: iscsi: Switch to kmemdup_nul()
Date:   Mon, 10 May 2021 23:25:34 -0400
Message-Id: <162070348782.27567.18217960019739448581.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210402092517.2445595-1-yangyingliang@huawei.com>
References: <20210402092517.2445595-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0501CA0144.namprd05.prod.outlook.com
 (2603:10b6:803:2c::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0144.namprd05.prod.outlook.com (2603:10b6:803:2c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.20 via Frontend Transport; Tue, 11 May 2021 03:25:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ae90218-0102-415e-729f-08d9142c79b2
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4408F97C6FF17FFE2995EB1A8E539@PH0PR10MB4408.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rhN4wnHLy5Wh+zgeRvuicOeaVm++/lzVSUZ1RG/FrS/GfBIEfSRFyUGhmxDjQL6GiyCg0j/14CF2tqMgJq3o7rSDuqBzXoBgl5CpCRPlmOY55RDY4Bm0iCB1wlinxiMot0ce1blbPkf+TfL3qBSF578GgP1yI/l2Aaw1vyYrNFq0OlgVaozpHUWdELCB+/L4Bp5wt54J6sDiwRvGxF04a2hncmlyNQwlbaaYoUJLnSRJ7qChY0CT+ssu7R3TGUg3EVV8tDWAc17RTq1eDqLulcTEMBR+PVjghMva47ViAOAdhfFOgYvsKt8b2zMBoLmUTKdET8agi2TaTo5/UBtniCkmg2IKZpPbJfKIBlSyM+vki5wWixqJmx7z9q1nm/ari1b6k14LU96cLG7g2wGHWelyqGSskxZ3dMvvX1VJVgp/FmMJnqUwQBxv/NQjQNDaQh+S2PztHtFCDcbf0/y6L+px5XO9FoeYZ83DlvS9nYUUSNJsp08fU40YR6YrSrZKyoFOSjVSnsd2lI8zR2u3d9Gk2LY/eJAR6d8mhCQivIIH+8S28cEW4vw2VAuawjuUI+JF4WQN2amXfEVdTS9joT1r1p7Lkg7+8HhcwYr5s3uG4iPJZ0SjppT0HcnrhuUEirijKaXndPmG1BBi52HzvPVeBpPxGOK3eQE96aHqxWRJnoi8B57KQXxJCg7+3MWRV4/E7l1z8hd0t2RF8gFyKcuYrzIJsTKSUeVYxSyP214=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(346002)(366004)(39860400002)(66556008)(6486002)(107886003)(5660300002)(66476007)(16526019)(2616005)(38350700002)(38100700002)(6666004)(478600001)(186003)(66946007)(36756003)(2906002)(4744005)(956004)(103116003)(26005)(4326008)(316002)(966005)(8936002)(8676002)(86362001)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YjdZUnZRSEpIZ2VDcU9Dd0poVkJPcWhVdlJvOG5zdlB2bkFhV3FrSmdSd3Rx?=
 =?utf-8?B?bnlPMGxnNk1EOFI3RlhMcFlKdExNYXB2K1VhZG9KdzQ0cERaMUVySUVrN1di?=
 =?utf-8?B?dUFzRktPb0V3eGRsRHVpanh0bXN2WXRnVkUvakl5b0pRN3VOdi9TdEl6a2lN?=
 =?utf-8?B?cHdUZHBJMjF5anV5MEE3ZWdHd3ZZMTRCb3piaWlxWWFNQ1h0clNDZEFMU0pD?=
 =?utf-8?B?VlJqbGRuZ1h1dnFwYmU1Z200WWhFRCtoS2V5Sit4TTRHbkVBdWlDdnRCNG1W?=
 =?utf-8?B?ZmpzQ1lOTFcyOG1ydlpvaE9qajhhdmJFSjFqTytlb3ZCanBneGJSaHdFVHpY?=
 =?utf-8?B?Z0toT3RoNWZoUHNlZlZUQ3E1djI3NWtBaWFteS8ybVlBWmlVcXpzaWdnalVp?=
 =?utf-8?B?dDhwV3lmVWY0N2FIRTZHZEtjY1ZVdjhWVDRPWHlYd1NwTXJhYys4azRNbXpU?=
 =?utf-8?B?WjZqUWg2c294WXpQczNHZWdQZFhFNEs0SEFmdkhpTEdHVkR5Mi9lSE5IaHg2?=
 =?utf-8?B?K1FRWld0TXk5UmpJK0l4Q3hzVDFHaE5tK3cvTkdXRG1QVGwxaWJDbHIyV2VS?=
 =?utf-8?B?UnNmWW5MSTBsYWhxVHZXOE5JQ3R0UlBxQ2lreG5DV0VDT0RkNWVWQ0I2U2Q4?=
 =?utf-8?B?SXdGdU5lYzJYcjZiUkhrTU5UNWl3MDAvTjRXMFFVVGE3eFVMVzlsTWJORDlH?=
 =?utf-8?B?bkx5eDBVT0tiN0xVdXovUkltSzRyZXUrbkQxZjY4eWNQcFQ3UXE5eHRGSnpR?=
 =?utf-8?B?VW5yaUhOeXk3Yi9oTmtTYVdxSEpPRW90ekF4MENmUUptcHM5Q3RudDRYS2hN?=
 =?utf-8?B?Ni9sL0huV1hMVlVaVTB6OTZjcmYwd2NyKzNaWUFYd3Q5WnFQYlE1VUdoQllQ?=
 =?utf-8?B?VWtCZkpKMldPQUptRGZwa0paaXpvZSt2c09kWURIejhBK0RtSDFCOUF1NEpl?=
 =?utf-8?B?dGpDb0l0bWhqdWxoL01BUkk5YmNqUmlaL0Rickc1cEozYllXNGtyYWxlenlv?=
 =?utf-8?B?NTFla1dYbHV4ZGtWY0lBWThENFM3QjZqYVB1Ty9ob3Q5dWQrelpZa1NTWVZK?=
 =?utf-8?B?Q29RMkpQM3ZkRHpSbW5QUHNoMGpGdVp2OWJER3BHNStEdGZKZUE2SWRDSVUx?=
 =?utf-8?B?MlNsSXQrMCtCNk5JdlBEZDROZzNUTmhFV3lTVWtqdWk2aHRBd09rYkJIWnhG?=
 =?utf-8?B?enIwUkY0MVZCSTU1R3ZYK3NaSG84UU9pTjBoQjcydGNMQkxpZzc2eDR3aHZq?=
 =?utf-8?B?dVBkaEc3clZocnhiSWxmQ2MvRzhiS1YyS2k0YVVwYWJIOHVVSHhtVURHaVAw?=
 =?utf-8?B?VFl2UndyNjdsSnZDbzlHeTRJZ2dTL0JURjd3M2JSZVpCOHhOVlFsUDJ3Y2xY?=
 =?utf-8?B?aStPNmo3VHZENFBSUnZFUkp2RXJsS2ljeWdCNUdpbVN1NlFkaTFrKytKK2NG?=
 =?utf-8?B?MUxSSGFiQzQ3Tis4MGJmSTcrMDRCaG5peFpxdDI0b2xXQkFJNnl2dXRSVU45?=
 =?utf-8?B?aXpsZVRMWGd0RFlVNzRORGtFc3JWMmZvTmUrdDJIeXBiNlVMcEtTYkxJbkZK?=
 =?utf-8?B?Nlc2M2RramphaEZqZkVuZFRWRHlNNXpnbU1yd3dZNWJqS3JSRmlrTHROR0hY?=
 =?utf-8?B?dlYvRjgxRUMyRzhDY1MzcHBhUzdHZHZEdTVyTk83NWljQnhuR012aDRiOGhu?=
 =?utf-8?B?OFp5QlNCNy9OS1lLWWdOMlhnZnNNTG8xbU1XeUI4YzVuTXkxNG5oazVvM2lx?=
 =?utf-8?Q?UmDMnJHP8srCeBIkzCEmEWeeAmmUslZY516w4UX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ae90218-0102-415e-729f-08d9142c79b2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 03:25:50.4033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qpqLEaHhNYcNyUPRO8L9gEcolXBVDBV4omumkVuf8TcXpqEgBIaDILTyVeYxvBb4u8ooOBFprOyRocpUk5j+KsKcAYMtMe6bMKpBVCVXHOg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
X-Proofpoint-GUID: OnL27KCsZltancbK9hCaZ-6TENWIqupV
X-Proofpoint-ORIG-GUID: OnL27KCsZltancbK9hCaZ-6TENWIqupV
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 suspectscore=0 clxscore=1011 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2 Apr 2021 17:25:17 +0800, Yang Yingliang wrote:

> Use kmemdup_nul() helper instead of open-coding to
> simplify the code.

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: target: iscsi: Switch to kmemdup_nul()
      https://git.kernel.org/mkp/scsi/c/6235bef6f990

-- 
Martin K. Petersen	Oracle Linux Engineering
