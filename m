Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB6BC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FE2623A58
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbhAOEJZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 23:09:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51506 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbhAOEJY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 23:09:24 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F43wiw055358;
        Fri, 15 Jan 2021 04:08:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=z+JbpC1JWZB/0Sw85u4Z7xXy/BD+u09i3l9kk7+XyJ4=;
 b=FfFpFuePG5+Ouo0YNdXq4Bjh3gMVuyAOA4eq4Bnp8J/l1VyjtHUw+gkZ6tnHXLZkAe0k
 BpJnY3l146G9CzoqPlYMgVCEsc02E9Wt5MZiNtX7X50QVuO935bZu7BfeeEPdld6yNy2
 vt/mk5pAASlS48qCY1XFFK4XouOKEC742XU63xnp+bROHmPuBZCVQN9m2TBrOpCJacNy
 VVORTwpDFnI0wtfj11jDeORAM9TSxAvF/w1D6/VnPmDPUeQ6XqZZ0MlnhQj5CQmi0bTq
 ChiuttHKfRG2q9uvx5hyob7+D7TbdSrfv+BNDkza1btzzYp2zAwcp+GRWC1A6TNI8Huw 0A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 360kd037w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F45kkS018735;
        Fri, 15 Jan 2021 04:08:36 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by aserp3020.oracle.com with ESMTP id 360keaqqn4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CM9ZTpfmIBlSKBblgravGSBumffFZknNt1B8TWCTBH6uAV+WJ1TLNBiyVsiEt5yNcbT/1EbTdNB3VywLw/upMDbKF/jnrXp7CzTuKOkX6Nug2KtBZ9XD/KaRCfrl+IfQ4zQaEkCHC2AY14Tco9OruXELOyivUhqSqqUNiVsp52V5WimEIVROwWDLddgNwtz78xmiJO6VG/zWafZUfT0WWqrZf31OS6lTIn2+r3UzwrqvHVpkrn5IUgIX2gxBDaC0R3sHd8HFBlGVce11hyL5sHf0t2usLjHvuJHlJOWEBaUyeYJxvaho6uMWNFQ67R7XDs9ovPOBi/J5ySVxZ8U0sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+JbpC1JWZB/0Sw85u4Z7xXy/BD+u09i3l9kk7+XyJ4=;
 b=WrdBGyMdDbW4wUcDt6QUx6rj2qduSfWiVHrt88MRbjDffp6ALoYuU+zTR5b7UnbjPLjkojN1HLn/EK1UQImAVNTHR3PHGuFpVD30x8wyq9bEMcywr8VsjAvaN2IFmXavZVfnTAZv/xtl2JW6achqGkpCQnEkEvEnItGhM3x4BrqTx8h0yM9iXrsU6Hzn2uGcaqtM46E9PqJ/dMFtkuHfy2TCzAvPBxLcN5TpUzMvNbD15lECUJiIPjx9J81EtMlz0mcrKNaPR4AJgDTAFlhlGepU+ztyjV2v+9SxJUWaXCHsQ7ik3fJtmyiQGuYWl4wYf/j8mlzNL4J+64L9ePlo9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+JbpC1JWZB/0Sw85u4Z7xXy/BD+u09i3l9kk7+XyJ4=;
 b=t06CYh2gw79Db9E03YIZ1/z8QdKFv+95KWOMYWrDXleVGpxSI1+4HMCEr1o0Ce8mIEekaoAxOaAax8EUHj723bePfGBw8H/aPZfyNDrKrLufgiPkuyreJG5/gMwqapj9kgpVsMvbezhEdgMT5yyK6RZqTMa0BppczM7SGp4jwSk=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 15 Jan
 2021 04:08:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 04:08:34 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, YANG LI <abaci-bugfix@linux.alibaba.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        intel-linux-scu@intel.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, artur.paszkiewicz@intel.com
Subject: Re: [PATCH] isci: style: remove the unneeded variable: "status".
Date:   Thu, 14 Jan 2021 23:08:18 -0500
Message-Id: <161068333183.18181.7869993200164278107.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1609311860-102820-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1609311860-102820-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN4PR0501CA0139.namprd05.prod.outlook.com
 (2603:10b6:803:2c::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN4PR0501CA0139.namprd05.prod.outlook.com (2603:10b6:803:2c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Fri, 15 Jan 2021 04:08:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c410152c-b4f3-42e3-bbfb-08d8b90b39bc
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45683360AD99E409B854F67E8EA70@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U4mwL6bHFhhFHQBiKInlhISZ8cUnYOkSTjbXC5GOD6WdncqVRjREMsNSS8veQDqiuu33Pn1t4diYkBDwQOxXlUPdetel10jTPEms+OLnH4OiwWuhnDjEiTVYmrJ4Y3GWMgOFAX7mtlNNmaJ6KgAjRY6zqP00XCgILQnIvvfb++dAZa0lzW5RJJ0I5keftVIwv6a5bCNAq3GRPxRuT1YVv9dqZa1bUUJE+YtsfvPpYTNPo2467j8JHLIGYiXhB8gN01kRzAZP7C4gQRn1ZeyhxXklq7isytOq5Y7L9E/hQRXVLvCSJdAXH+TOl85P9EdId1cQ4jnbYxuqI+moExokgW18SYNd7MQwG0vmyMSkZs6yFerOkN9pZPK5RXOjEyB9EtiUbd2JlTVUwumS9cIlA/4oL7V0heTTP4J2XqxvQqQLvmyY/OXZlRtP21L/G04zuccdt/lArZTtDlkCqyN3+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39850400004)(36756003)(6666004)(316002)(4326008)(83380400001)(6486002)(8936002)(2906002)(86362001)(7696005)(52116002)(8676002)(103116003)(966005)(26005)(66946007)(4744005)(66556008)(478600001)(66476007)(186003)(5660300002)(16526019)(6916009)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cWVVbHZHRVFRM1hxRFgxc3dxU25Ld0Y5VWJNQjRnMS9aQlpTNER2SUlyRDZE?=
 =?utf-8?B?MWpLeXBHVjhlVDh5TVRoajBtRmR5S1JLOUpXVU5HSEhNTkNvdHgwdEhFYWFq?=
 =?utf-8?B?U0cxQVRYbjlRejdmRFZ2bWprK0hPcFBwUXVSNVJLYm5qTU9DRWc1NjA2TTVv?=
 =?utf-8?B?Wk1XNWZwWTF0WUR5eWtHTi9iajFQNGVweGU1bVdoSmxUdXkxdFVvWU1vT09H?=
 =?utf-8?B?aFdBR2d3Qzd4amgzT0hMSldmakE0YXQrQlloUVFKOVltUXRFQlNUVDVZeHRI?=
 =?utf-8?B?RnEzZTdCVWFpK2xwY2pESHZRaXM5QThMQ2g3UCtZWVhyY1Q5cVhuSnZNTU5k?=
 =?utf-8?B?QVJHOUlzMHBTWGYvVWpsdWlncXdwT3Y0a2xuK2NjaXo5MEdGdFF3cjhiYVo0?=
 =?utf-8?B?Yi8vQTNpUnB1eFEvSDMwTFp2SFFaNmpKZWt1dFF6WVV3enlHcHpDOVFadVFq?=
 =?utf-8?B?dEEzOFV1T3ErbDNwN2pDUGM1WFRrV2lzaWFucWc3VGUxK1VlajMyRmd0eVM2?=
 =?utf-8?B?aURSMy84MXcyckpMNTIzT3MzOFZQcTBmL2hPekZuU0wxeS9ybzJCUWgyWHBz?=
 =?utf-8?B?Yjc0UkJJUmxrZzhYeXNPSnVJenlYbFhvbSsrRFRESm1MbWpIYnkvNVNSY0cx?=
 =?utf-8?B?cWh2bVZGR2IyU2gwV2dSVDMwUWR5a2lMQVVoeXBGUmRyTU9sR2I4Ym5NSURn?=
 =?utf-8?B?MVMwY1lrUVIrNlQzSklxYVR3Sm1XamE5YWFXR0owSC9MQy9EbVpZdjJSVFlj?=
 =?utf-8?B?UHErUDZnajhYbGdWelk3S1A5MXhzVytMUnBuUTlXVmNYbXZEY05RVUJJb1BK?=
 =?utf-8?B?ZUY0UXBnNmlTSHplckl4R2lKVkozLzBkdjlmbUh5Y28zc0JEQTJoVEE0Ykkw?=
 =?utf-8?B?NkR2TkhZRTRPcFhjWk5ST2d3alhFejNpRDMrR3cya3UwRVhseE9qVUJTNW9w?=
 =?utf-8?B?TlBKWjkySzBYVU1tK2IzWUh2U2E0Mnlma29GZWhzV012NE41YU54SU9rZi9k?=
 =?utf-8?B?dUdhT3pTY2FTVnErbTVpakVTNU9ac3VzSk4xdWREenFvVk1rS0h3bWMwOUNi?=
 =?utf-8?B?ZWo2Y2kwOUlIWXU0cHpySHVSd3RjdUdHaXVuOWQ5cjJCcUc5Qm9YbWY3QURK?=
 =?utf-8?B?d1dCOEV5aUovOEFYUFRpNDdoWDhOUzBxVFBya2lvb0F6eHJqOG1UWTV6aG5C?=
 =?utf-8?B?TWN6d3BGek0vUFBDdVVWdnhrS1NLV3lZendpdmNacDVqWnJlOE43UnNzSEtH?=
 =?utf-8?B?QWNNU2J4MzNQS0x6MWZEdFd1U0xVOEpSWnZoMnRVSXpIbFhlL0U5SWxUNlZL?=
 =?utf-8?Q?KpahzuQZDtBQY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c410152c-b4f3-42e3-bbfb-08d8b90b39bc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 04:08:33.9703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ottSFreHjdLaF1uiAxvmByxRhgi7iZQacEO4AqEnFJAs2DJcv0FO5TzV1QrjmsvK4ymkJlqvDVBX0gATx9StfvDgwOshJYM0jyBGFndEAw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=931 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 30 Dec 2020 15:04:20 +0800, YANG LI wrote:

> The variable 'status' is being initialized with SCI_SUCCESS and never
> update later with a new value. The initialization is redundant and can
> be removed.

Applied to 5.12/scsi-queue, thanks!

[1/1] isci: style: remove the unneeded variable: "status".
      https://git.kernel.org/mkp/scsi/c/dc0bfdb563c8

-- 
Martin K. Petersen	Oracle Linux Engineering
