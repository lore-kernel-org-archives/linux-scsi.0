Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC4D2C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7491B23B08
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbhAOEL0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 23:11:26 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52924 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbhAOELZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 23:11:25 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F44Auf022508;
        Fri, 15 Jan 2021 04:10:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=HOpOFQGUoC26m60D7E18saMIdQNUkRoOVt4YJ5bp38g=;
 b=C9NiXFceJ07KAhtfliN9bMa+meIBdkV4pX3SnLmo1TzLgo7VTO4b8qhQU0dwO69IZWu6
 RsuwlzAQK55wzRdeIcHX8obOeKnwZAGUHW/fTzd2ONnu0eKLDeHWOc1QuikGMqpSr9RE
 gL2hd2NVeA8Uo574UnB4fFJjg24qztJVamR3+lt5yNRwJeRO9Eondq3XRilpX+pwWykW
 aXDZziPVcWxSjxZJeNACbnK75ftqooFfiI8EEJzJwnrOK5BDkXPVnaA4KezKo2Z0/Ddo
 GsgkL7tnoRxCYtYduVANOWG2/hJCtp//78V/7+uvqKsiGkannVij8clwWe7o+t3G40rG NA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 360kg239bs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:10:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F45kkU018735;
        Fri, 15 Jan 2021 04:08:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by aserp3020.oracle.com with ESMTP id 360keaqqn4-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rsbk1X64GApf+u8mCVhklW1T66w4ESqbemnNVBQx/S3IBHYusBa4YXXX/w+EFxSNivAH5Xb+U7t43jqCMCvBvFGqvCHiL53je8mM8LJFTwXg4mVAH44zCb818VxTAfwhVnYi48iZa/np+L8qrfg5X7HjGC0i/AsDcc8aEs4k4iovf6fowUiAXGF+ENn/NHbVsxceT3UY9jJLsTTbnlsOrRZwxvyK5YPhDILYXArN/Wb6+DDCwdH7DgrduMDxhYr11ZQ3T6MYgpsrFZmz0kXvbgQaEVjj73b2vr8Z+DPubyHomc/E4WJsFvWTILWszBjBdFWHyWoAsYHcPtYsCPIn0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HOpOFQGUoC26m60D7E18saMIdQNUkRoOVt4YJ5bp38g=;
 b=KtKLC1eZ0El/idR3DdaKCFnd7TTFlkbYtwcpx0/hQkwTchXAKoP17bwuhoFa/c/i2RZP/dU+R01mu4njY9iY7nYYvvSeHJUkiId/p22qfBlgylma5I6eflYTURGt8KGDNNE952dk30cd64u6yhhdLZ7CBNK7VosGRVMcaRkfzutAtU2JqDOaPNxttTirX/y67sN/2MBKqqL9sGASx0ARNYJOhAq8mZKbN84gcTzKL7YiK0IaR8v2pnej0d8yX/CN9evQEFrqNhYLYdG8LLAFXTA2LP0RvfmWq4CwhrOrm6StOO/o8hZE2tyMLM3spnaImxDv2as6AOvzO7orKiW+eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HOpOFQGUoC26m60D7E18saMIdQNUkRoOVt4YJ5bp38g=;
 b=LAfumaciTvvBUghAzRmQ0eylTzV6P6K5ydduQUC/w0xGCYQGGPGZIsl00vApxCt1cwr0BHfqYzJpKWAGzp2KoN8PtSLhcxULeEN/Tdkd0kA1oJGyqFy6XsIXxrZU+oBWtopt7fzl5G77GgWRXfik7RB0y81rWsrN9h0TN59dzfA=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 15 Jan
 2021 04:08:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 04:08:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, YANG LI <abaci-bugfix@linux.alibaba.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        dick.kennedy@broadcom.com, linux-scsi@vger.kernel.org,
        james.smart@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: style: Simplify bool comparison
Date:   Thu, 14 Jan 2021 23:08:19 -0500
Message-Id: <161068333185.18181.16717481903918902976.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1610439893-64872-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1610439893-64872-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN4PR0501CA0139.namprd05.prod.outlook.com
 (2603:10b6:803:2c::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN4PR0501CA0139.namprd05.prod.outlook.com (2603:10b6:803:2c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Fri, 15 Jan 2021 04:08:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 023f8279-05f0-4f8f-e509-08d8b90b3aba
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4568192BA23276E22343B7078EA70@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RoanxfVXVh6s1udg1XlnQ/Cf0pwvzdMG6CAbR1Qcx3uMIiuftcT78uO/W2GvGPVMRWR9+voXJM+RidJI0QrNVv6yjSHNBs5QmnIl88VIQcLq0jYhhv7dM8L/8TnlI5SQnGVoTTbmkH8O044BtEw9bFFwIVoLhq6wdjd21qj76NnhLGO0GT88NsPOfb3CT9161/2GBLwOc9gL6+I9oqz/Zv6hwRyiGhvO1+xHl/5eJEmCw3voxMQcc/5YOYhTvRcP7oPVVOC8n9oLsrT5BrLW3JQj8XCDJxB6Ou/cUwqMYDdE6sCnj4MyV4V4Hoi3TKc/LPH7vY4MhXn0CUEU1QKmmnvYVcd4EcstEu4DgYfbi6eNx6fyAdcFXTmSC+Gy0n0ll6m03B7fHK5YOGN8nykVvaqUYa91BaQ0DODlZPY24v9z9ao0PqfzHQL3gV74aT9id5+J3kBT8x8h4QHHcmVkBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39850400004)(36756003)(6666004)(316002)(4326008)(83380400001)(6486002)(8936002)(2906002)(86362001)(7696005)(52116002)(8676002)(103116003)(966005)(26005)(66946007)(4744005)(66556008)(478600001)(66476007)(186003)(5660300002)(16526019)(6916009)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aGxsbzBLMjRIZ2Z3eTJ3WEtIeXl0emZJMmVYaFhGeHA5VjREMERCNkllVzBR?=
 =?utf-8?B?eFkyNnBYeE1JRWN4bkxEcjJyT0QwaDJLUVBEM0IyemExNVFnYWt3MXd2cDht?=
 =?utf-8?B?Si82YkFmNXNQekdLamNMb0plbjlyVCsvOThmdkR2bVNHN0o4dEE2NHpxZ3ow?=
 =?utf-8?B?RGQ4TVVOd3RnUlk5UnpvZi9KUXN6S2w3WWhRbjJCdVVMRTdId0tkSzlOWUFj?=
 =?utf-8?B?dlVYS3ZPL1l2enl2RlFWOURRaWh2Q1FRd3BuSlRYVDMvNGVaY2J1SEY4aEU1?=
 =?utf-8?B?NmNUWXQvRFdsbCtvczBnVlpQcUo3MVdWWnBGeWpuQTFkc3RFNTNMSUtiSVpX?=
 =?utf-8?B?bWZYNHc4MDdIR2E4QnRpZUtUTnk5MG1WUGFCSUpkcXJKTWNFSU5ONGd4dmt5?=
 =?utf-8?B?NStidjVpWDVyWnVWSUFkMTRWZGJrZTVDQ3YwTGtjc2VtcytxQytxQ3dZUXUw?=
 =?utf-8?B?UEwyemc0ZkZjaXUxNTJpaHYrK1N1cFZUWHQ1dk1kS0sxVjNSVmxwUndRbzRs?=
 =?utf-8?B?WDlaeEZPZ1VyVTR3NlRaV1RKSTNpaW1ySkZKSG4xZFlLYUNxcGZqUnlhK2dm?=
 =?utf-8?B?OTdiU0UxWXlINzFBNG1ZQWgwQkJSTlNpRE55bGpCeGpqQngweDVHL2NxTDla?=
 =?utf-8?B?YzRlM1RHbmt2SDVzaWRDVG9UYXBaeVBIT3hjdG1CUnFVSUw1WlBNNFEvL05Z?=
 =?utf-8?B?WStnOE5xZWtyTVpjWmk0NEFZZGhsV2hvOGFGNXFHS0dSUHMreUdiQTB5aUhQ?=
 =?utf-8?B?S0JMeFJVbUpvdWVIMS9DUzQ3SmZrNXNxMndDUDVwb0xuMG92YjYzbDU4WVNi?=
 =?utf-8?B?d2ZXSW04cjI2MU5UNFk5NUc2c3pzTUh2SDNsTG12TnZxcWRUenlyaEVVSlIw?=
 =?utf-8?B?SFV6cU94RVJpUTByMnI4UVhwYnl6QmhDeG45ZS9KaWR2KzVWUkpQbndpbEc5?=
 =?utf-8?B?NktpOXV0S3M4MEZiQk40YXRiV2hLT1FXWkRLMDhzbDBqSmF6Y2kxY2p6R1VM?=
 =?utf-8?B?ZVFJTnJCYW41K0Z3V3ZFbUFxcll6ZVYzZnovcDdMUDM5amRrcVBMSEFmZEFt?=
 =?utf-8?B?RHBTY3NPSmJkSTJtdXF0RUtsb2o2WmlPUjUxRHNleG5mbEZPUjZtM244bytD?=
 =?utf-8?B?N01OUFFlT2VIQUo1NkRKMVJsTENEODh1dUVYaEExU2d5NnI3UnRKSi9DUnZy?=
 =?utf-8?B?R0dpK1BaQ0NTOXFDYk4yS2w5S0FKZkZjcVZSb2ZTTlpSQnh2WnBHbXBNeWty?=
 =?utf-8?B?LzMxbm5OOGFQd3JJNGZPN0hITERaenFWa0M4cktib2hHbTBpNEc1SElMaHdv?=
 =?utf-8?Q?G8o+czD2nDvkA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 023f8279-05f0-4f8f-e509-08d8b90b3aba
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 04:08:35.5693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qn7jJEMwmzdGBFa2lP0JdDK9G5dtPfR/kw/zs9nI0xg/Mvc0eHwks1A3rxmhxcZVVMT8RFuxfkXCy8dZzVh2vmO7HuSf+ZpaiVy++hsELHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 12 Jan 2021 16:24:53 +0800, YANG LI wrote:

> Fix the following coccicheck warning:
> ./drivers/scsi/lpfc/lpfc_bsg.c:5392:5-29: WARNING: Comparison to bool

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: lpfc: style: Simplify bool comparison
      https://git.kernel.org/mkp/scsi/c/af0c94afc0c4

-- 
Martin K. Petersen	Oracle Linux Engineering
