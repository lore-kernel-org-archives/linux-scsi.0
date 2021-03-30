Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F0B6C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49C3961987
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhC3Dzp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:55:45 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42590 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhC3DzM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:55:12 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3m0sg004478;
        Tue, 30 Mar 2021 03:55:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=bsTRYMNCuQQjKFWO0NDS+CwmMgeJAxFOZepEArMTBdQ=;
 b=Ze3G3ANLimnyQW1ogGXBgnZR15zEqpgC1gDGzKHrJvWXCttNe8dNju33t9Nsf5NoV/I8
 dfCjlk+QzKN9VYCsj1FI/zL8ktYxOXhgN9GxmZ0prGNzKPeAVD0XHMb10tx9ZvhIPSB5
 BawWYefzoN5t5BRWVKZjGOlEQGJ3nu/7jAom27VTN2mSOv92fEJMRdcFPMQJQDEFx8tM
 vqzrEKtsMGcO+MeXkgy1CekXu7nvnfGfp/spLNqgQ2QzUCWFd4Of8t8VXgzL3KIQhl8D
 cpd7K6nnxoTO6+6OSXtq9rRddlW1bzVlkrEdTBQ0k4tbflTGc1qCOsnZe5g8E+b4IJPs VQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37ht7bdq51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3iXHZ039539;
        Tue, 30 Mar 2021 03:55:03 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by userp3020.oracle.com with ESMTP id 37jefrkt4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNp3QQpal8y96n/Am+5ZVKjs/knIe/BC6/c/okf+IVo0/bru1uRZya3OWmOH8N+uD9ZWnXdcYZm3kRSdAZwSM9HwBI++yLXV9mhjwJeHgiq7cvSqd4h5wW+0U0cPv4YRRVYw0rl81LPp5D3KQ+a4VKaHBCJ6S6cSehOUZXSYx5dta987SMf7vJmMzDyDbfGlFxjnyv+VfFoQohpwFV91kEz6FG4XBUcreNmbeKCNWEBizGlyB1WJuz7BCjpss6YDYzLPXF18Vn+/TsdUX2FSE8TlIsPSPCvmtcR9da6XGyMGMalL/ZdqcqNnE+q3wr/oVrOmpSQWMEkHFwUhd7c/SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bsTRYMNCuQQjKFWO0NDS+CwmMgeJAxFOZepEArMTBdQ=;
 b=YrIviWs+W1SSghTEnayYRR4U+IF6YUPnAWvI2O0AbSfyz3auerDWNz0Dy3Ou2LPfxeaI9+HtXuMxn5jGsw1Ci1+2Gf72w7T1QCjngVpKulOyxL1HgSSkczdbCuCUo/VoK5fiFibPj5gzYHY2na6Rc4t3G1fzsJcagzDalzJ6EHV+qS1IIhK8exJP/D37YqWwLFopP8qQneon45t0z3uZ+hZDq9krjwGF5b6AQKeEL8KA8wb6MW5riwQ23qYrT1DmQ2pMYtu82bp07FVrOvackAFFrbDWOVkqssDkGzUaf3LAAsELAUOU8MA2z3oPyr5l/5H6hTYl4GQY8pYo+4YXng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bsTRYMNCuQQjKFWO0NDS+CwmMgeJAxFOZepEArMTBdQ=;
 b=WQJIuzoHcNLSZjkIrEVEz5mapDpUPn1PGFTKWJClgSWxe6iBnGRKweDXcxKBs1QlBhgnL7t+9EtZI8VcqmnrqiB0BOZwLw103duhSb0kXKlxO9jmHIdCsjIRVQ6jrgb5vNEGQDIXwwjcemmotxrFFooi3/5PDQxln0mdKbUUFN4=
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4758.namprd10.prod.outlook.com (2603:10b6:510:3c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:55:01 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:55:01 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, mdr@sgi.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla1280: fix warning comparing pointer to 0
Date:   Mon, 29 Mar 2021 23:54:36 -0400
Message-Id: <161707636880.29267.13219069022109115961.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <1615780159-94708-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1615780159-94708-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:55:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67ad1682-9288-49e4-39b7-08d8f32f980b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4758:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4758701F5321B4C1BB823CC28E7D9@PH0PR10MB4758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ld6B2mc/TnIGpxul3PsvuVHPgkqlgIWibebTwYL1T+cQx1Zgzrn8pjiRXI5nLOdDiShxWww9pr2ohf0p1eqfS1O6yOmU1ihkcN47wjoXDBp/pdsV3A7YhgxTCiyDPzXq4Pbx30t9CvC5aRIidYd3nnbd5p8vL1dz9X2wwXROmtsE6ffWJ8ULm2E8MMkAEq6u7kttVfPDlcHwWNlvJxdlUbkoVLKPYUgwYRDB2eXh7UPt3AARdnm1GQTHY/OmvQE9AJXw0p0nG8aqmo29U9dIIkiS4sC8+Nb0SMMIisHlYkA54jFN0cblZMiBXOCDGCfmjhEzdU9Pw6uLdOgoYLerbwCEze27OZ7TThUAaGWnotplpEU4vRzzrld4qtd2t4/Pcy73nqKFkbIrTQtMBp0TDCVQnMnu6+cGynZ9unVWK7/UkTwbyZygHCNXztZ2tpMGuG3xX0pJjIoyKOvbiSlu2gApKy+6SyBTy+bi9CQ7ntsfjsOxj7AEb2QSnnVO8448dm5wJK60lSZhVFk0kae9mLPqnW18aCgxBwKxg3rdFq7aESlmZUHJ1Spd968cP/f49wgYIp3AUozR8VgKOk0hmeKQf7p6i6FV6LbQt0qxzstL4Wvsj8pflwP6LnTa5MhZ3zqxAEYNonIp3C22/RgoaHkZM2NNVJIQ14Cq4Yel17/tbZx0bKqELilS1qAxjYMFwORlJzBnPVxuc+iFkNLgbf4genm500h5QPYhd8uEVUw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(376002)(136003)(39860400002)(2616005)(16526019)(8936002)(4744005)(956004)(6486002)(8676002)(966005)(4326008)(66946007)(66476007)(36756003)(86362001)(2906002)(103116003)(66556008)(52116002)(7696005)(186003)(26005)(478600001)(38100700001)(5660300002)(6666004)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dU5mN053N0MySVVCOU9BUm5DN2J2YkFaWlp4MnhuYzd0TTFaTGVjNG1IN3JO?=
 =?utf-8?B?S1k5TWM1blhlWUdNUW9kV084VFViR2RoQ25wMUx3VEpGdGxkTVNQem5jWTd4?=
 =?utf-8?B?RGJsRStCdVMwOWwrMG10UGEwM25CcmZkUkxVeENIVWJwZ0k4SDNYMEFvOURt?=
 =?utf-8?B?UlNtdmI3RWNDTFJzaEdFb3NsOVNlYkxIeFlvTFp4emY2cjYyQzBJQUR0T05X?=
 =?utf-8?B?ZEN1WVlsL3lJdzlZd2pGTDFPM2JQV3BMdE9jUEhGNUVSRnFPYll3dGd4dEVO?=
 =?utf-8?B?YkVqOVh2M0NRNkdmcy92ZEx6RWpnUm5DbFVPOHpSei9MTm91V08rejRyekNB?=
 =?utf-8?B?WDdLSEhQckZ5Mkt4bEhEaE8xRGdjSXBEbmRxemRnNmpTR0I3RDlGOUJYKzRV?=
 =?utf-8?B?cVFGSmhWbnhJMmR5T3ZZUGh0QUFBbk0xZzdNWk9Fd2tCRXdQYlYzRVFxcnVN?=
 =?utf-8?B?dGtNdHFKUUU2TWRONTNmeFVLRytLcER2VjloOHZoclNHK2ErQTNUNDVpU0J4?=
 =?utf-8?B?Y3B6UDkyVmdJLzhldHV6U1psTFRmOTA4WXI5V2daMFdXck1QdXlLK3FnM0g5?=
 =?utf-8?B?RzFNdkwrTCs5VjhMdWwyTGVMZHJFQzVhQVA3S0w3WkZseEN3QnBDUTFMN0Zk?=
 =?utf-8?B?L0lISmFFZDIxYmpFUzIrc1laK0lMUURmWHRISERuZWZuZ2xsWXdHOFZVMDJL?=
 =?utf-8?B?UlpHVUFJK3hmT2hmTitEUFp4dEwzQlVGb1lRdXMrYkZPcVc0TG9iQlFkWUEv?=
 =?utf-8?B?ZzVTRkQ3MjVMZFFFZW03TkRMMEZvR050d2ZROWFaaEk4YjNhc3AwYVk5SlFH?=
 =?utf-8?B?ZGFKQ292NU1XeE5nb0svQ1ZsWHdNbG1HT1dTTTZiQ1F5OWk4cU93akpzSHgv?=
 =?utf-8?B?ZDF6NCt4dWMzUXdmcTl3c01OTkx4NzRBN3lqL044eFR6MmhCQTJhME9kRFdP?=
 =?utf-8?B?WFpmWnRwWlAvRGM1S0FNU1VDMDNUclJjZWVYeXUzZ2JJektjVXFHZTdIdUx1?=
 =?utf-8?B?eUg2ZllGVVNzbUlsQmhackRZNE1iYlZaeS9OMk1ZMURTK0ZtWkgwMHR2eUpx?=
 =?utf-8?B?V0QwemhzVHY4ckdNcUVleWxXaEx3ZUR4K3BpVmFBaGlmSjNYZWVMbW5MODU0?=
 =?utf-8?B?MHBJMkV2aWg4U3hCRnpaK2VZNGxDclVNUGdtS0wySTdoWEE1VmRvb0tEMEd5?=
 =?utf-8?B?Q3JZNnhVVFFJMUNOTEdCNy9vWGhvczhUeS9obFc3bDV6MW9BOVQrL2xBc2xV?=
 =?utf-8?B?TDNnOWtzQTFnSXo0cVVtRU5sN3Nzb2FGcWpYMmZybVZoU1hWYmRhNmpDeTlK?=
 =?utf-8?B?Y1haZmhKQUg1K0FPQzJSclFPc0NwZkp4akZtR3VabVNvTGE4QlZvUzRLSGpu?=
 =?utf-8?B?anZ4YjViMU1HenZWNmRmYk85VHpHeUlOeUN2Tkd4dHp3em14aU9OZW9GZy93?=
 =?utf-8?B?cmZZUzNOMGpBdzVQeUZCQlNkUXQ5UUduOHNhWXdsNkZhSHdNa2JTNE0wbDE5?=
 =?utf-8?B?b0ZVR2NmOG1hNCs0WjlxVWpKY0lTYVZ4NTgyUjVtNU5zZXVuRG54aWZLMnlI?=
 =?utf-8?B?ZnNCbDZnUkdid1VQYWV4NFZYUEdaQnJvL2xkNmZRb0VPM2RMSUJhOVBWcUht?=
 =?utf-8?B?azBZd2FpYW5Hd05KbmgrZkRTNm5RYXFJVnl5SW1raHkyRURNSWpSYkx0WDI1?=
 =?utf-8?B?Slo1dEV0ZzFBOVV6KzA0dERwK1VvM0xpaW1zZVBib3FMYndSMnNBblBOL21s?=
 =?utf-8?Q?y95sU3kuK+208llsFG2/z5BAh7+Vy24n2dmpe86?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67ad1682-9288-49e4-39b7-08d8f32f980b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:55:01.4930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QqPFfNNYsMp+wX+QerX8S8FcX8xd80QZmcUyGouAdYnZpADulaQo79SSWQpT/7+a0xPTMup1enlyKQqYCa6E7KwzJqAf2qjg9WDAVLsu0Bg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300023
X-Proofpoint-GUID: DuHKphi4NWUwHuAFNVYZvAcz8PExSsSA
X-Proofpoint-ORIG-GUID: DuHKphi4NWUwHuAFNVYZvAcz8PExSsSA
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 clxscore=1011 mlxscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 15 Mar 2021 11:49:19 +0800, Jiapeng Chong wrote:

> Fix the following coccicheck warning:
> 
> ./drivers/scsi/qla1280.c:3057:37-38: WARNING comparing pointer to 0.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: qla1280: fix warning comparing pointer to 0
      https://git.kernel.org/mkp/scsi/c/3070c72155c5

-- 
Martin K. Petersen	Oracle Linux Engineering
