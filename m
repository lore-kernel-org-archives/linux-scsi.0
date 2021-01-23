Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD65C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 03:11:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1AA023B1B
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 03:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbhAWDK6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 22:10:58 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33430 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbhAWDK4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 22:10:56 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N3A4bG036126;
        Sat, 23 Jan 2021 03:10:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=sgr4Ua+oB8Fb9dAT8DG+Z3B4QZHv6xXtFHKfwQttZeU=;
 b=gYQhB/zJ1TACAWVidAiG0YEzSdNLXjLUxjMMSgs9HO+QyhmxSDQLSMzzRaKDeNKNHtu1
 inGp5maa4ZETNDNh0O+Ve5zCo22v3yuGhrtfwd08hF7LWpWmHWwIrs1ME7ZmAFNeUzPn
 qUT2uVvak3l4KFaWjnJujFGkM983G6LwrFbJ4R8CtDMf4i6P/wd4Pnd/vz0dvkX6EL2x
 mQolI5uquLOT7fZJm+PznYzrCHsEBvIXHdIgkPKUMG7fC8DgPgsqGtLVWosIBpfPNng7
 DHkVA+ANpzFRurMIOnGIXnAEiv2JtswCu40Xu15dPzvJ9xt+a/D2jdgAPxOQx6YUyKuW Nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 368b7qg1ha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 03:10:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N30oZ0111194;
        Sat, 23 Jan 2021 03:10:03 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3030.oracle.com with ESMTP id 3689u8tthg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 03:10:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMySuHaFL/haH2emLekqZDF/5/6PJhlysKQ3wvhbdHgTslTg+1kCf34yWytxk54THXcU9nZ+VOoHhzlTul/uLkGGa1GGOyTgF1peAvt+rg5yX76v/ygwfHpWaO4LPd4ejzjAAjgSOzEWdnv/gJ1bkza7NvtZpaQGESGtzpfS0o84lfYlNvl16nds28k5rM2sIHyo+oQkZwqKqhrzir9NpobjRp39JiTfB4XypIYKssH4+OSae5KEvpLMlOvsjvtwMXmlERC9+IzP8F9Uv+0+C6LOTp2vsNWG+YCiwEXhDl8DMtsOvSM/J+T3ovb6XVnARJ/RWsLbpHF4h951FK+h5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sgr4Ua+oB8Fb9dAT8DG+Z3B4QZHv6xXtFHKfwQttZeU=;
 b=lOwhK0YbrEFhn83VkINiBk153I2kz8E7KEo9Kym26kqNglwav9P1uxXGDGOByzYjazO7rtXDpqRhDXygoLfHXtJyFPBrO5tvneyFdyFPVHP49eUhpw7TWX+cFp8wC70Mdmv867eY7NDQkwWmMyVf9N5NYj99Se0goaukFJatS5vVqWKVUgWu478vAmMqZ5UBt4zvAMcSQMnkRPMRcOyF1o/x+Z2bGWcWt+rTVigL/2NvaCSklyc3sTeQlBd5pixAsfR9JDgS4+JJb1Zgv+lEww4wVyDYbOyUk1/j277ihgjcqjbNB3VKOQY+/lUZqOR/hspB9VGIyAVEQ4HAyOJy5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sgr4Ua+oB8Fb9dAT8DG+Z3B4QZHv6xXtFHKfwQttZeU=;
 b=N55YgBqIA/HpvLKUVvjie8XLpTCEYxzj9aOmzeS1xANrTrTM8U3Ns22fVNlGeMVhyh5kd39Uvdj5ODx1vuBSLQtfWpIWiMvaYMEk/HAOrc1n2nmYgCyYLOwPSlln2304BFf72dxiByT7wjzAiP3JfsnI+AEBDQgwq5gD/gNLdfQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4711.namprd10.prod.outlook.com (2603:10b6:510:3c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sat, 23 Jan
 2021 03:10:01 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 03:10:00 +0000
To:     "Ewan D. Milne" <emilne@redhat.com>
Cc:     Martin Kepplinger <martin.kepplinger@puri.sm>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, dgilbert@interlog.com,
        bvanassche@acm.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi_logging: print cdb into new line after opcode
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtx09wpa.fsf@ca-mkp.ca.oracle.com>
References: <20210122083918.901-1-martin.kepplinger@puri.sm>
        <c0c7b4cde76c9b15aad9fa213dcaeb75295763fd.camel@redhat.com>
Date:   Fri, 22 Jan 2021 22:09:57 -0500
In-Reply-To: <c0c7b4cde76c9b15aad9fa213dcaeb75295763fd.camel@redhat.com> (Ewan
        D. Milne's message of "Fri, 22 Jan 2021 14:52:56 -0500")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH0PR04CA0110.namprd04.prod.outlook.com
 (2603:10b6:610:75::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH0PR04CA0110.namprd04.prod.outlook.com (2603:10b6:610:75::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Sat, 23 Jan 2021 03:10:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b28a3421-e4e7-412e-94e0-08d8bf4c5f1c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4711:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB471107B73B525A384B8511078EBF9@PH0PR10MB4711.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LzwCVhA4E6lHaLpuyM22vkNbGrufMsFTypAIKW9LXCFlzp6jU5gI1pQIOuzEm4zjqBetaDZhUCQ+XAG+xDGFWSkem2LbU8S9CZFEjTHoGn+QlUxLSOoOUEiZmXkZ72CurkjSxx0RFvFMHveZZrzBIyg82YGaBxKOdNo/u+ejEN5GyXGs30JI5HQpcl0VNxTjum3GqcNf2ukF8TeP7gn8skG2sWMVAs0Uidm2eQqJsDNanr7r+lKItYBXz8AxB6HJ6LDBss6T8AebCZMRKYsGJbj/HHyJFvQnFMRQiYI3UqpKKnPzmmsVXNRvehHOSZcEJQysv34w9h5OQrrVuP9T9duy4aM6+d8d4da70dqIVEpOWxlk5EOuiGn1qNvm1dIabVbQB3FSDf/5ilWLYnPTkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(136003)(346002)(366004)(396003)(66556008)(5660300002)(16526019)(26005)(6916009)(83380400001)(6666004)(4744005)(186003)(8676002)(66476007)(66946007)(8936002)(956004)(7696005)(4326008)(86362001)(55016002)(52116002)(316002)(36916002)(2906002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?n3vJ8BX8vqVYSbxHxM0osM5GIWQLv/a+gfqnk46/freh7mV2+Tu2iZyzqa/4?=
 =?us-ascii?Q?SSDCB8qVSjkA03ySWIzaowtlUUjHUoF3CBZ0TdePmTTZ8FzMCE6p/+9jS2Y2?=
 =?us-ascii?Q?lE+Bq7Pppjeo2xe7AGzF3LmUKZ+tbQQIwKKIdadGZLmJpPby7Ev+RvMfUdCa?=
 =?us-ascii?Q?s5CdM7/kH+hBDitI7+PWVhq98IOp7qgMlskz9i8ZT8hawfeg0fOxPR4vt2HF?=
 =?us-ascii?Q?VS6R9h+xwbzb5deCh8VTjEzRXO3YlJAODY5dfbID4FPyHf3NrlcCI5HaRxtF?=
 =?us-ascii?Q?82qtpnS6cGMCm96i9Jgiu3zHXpQ++K33saEMi/9c1GVflgVYvId8cIK3M89h?=
 =?us-ascii?Q?ziAwo3BthQw2SwcnnE0mSEP6XMQOun2AMtuJEt/6OfdT9GZVsZYmT7pZXpEV?=
 =?us-ascii?Q?YGTZY7jzDKFSQI1NLUVPQnsqsBbUX4rUZ4HLp6HZe1kwRH9JUmbODZGGR7ns?=
 =?us-ascii?Q?sQqAqzQSQuz4MOFaO8nfKad7TfZ8UUqbeyIzt6HzVjI3ZUQcm0qgSX1njlBf?=
 =?us-ascii?Q?UNbjGIuluL6WliSjsqsXJbdzhsPXK3+Og3Nj1uc7ayM0h+7UN0Xox/Htw3sv?=
 =?us-ascii?Q?KetNJ/goiZxEqIgWe3xfDN7roVDILZdGlG+x8WaIZgEJOye4H8O6Eb22pMXa?=
 =?us-ascii?Q?iFYKLd1YV1p9pGoB6nfmFXzHo9Pt278BU+XabrBdNK55bAhQejOgj5R3do9B?=
 =?us-ascii?Q?6bi1naYA0yXa2AtaSxw0ysoW45pfTOsz6UtgOYMlaYy6IQcZFFKo5Y/L+RCt?=
 =?us-ascii?Q?FZ5iO2xrGj58zlL/Td+aXZRXu9eB9jp7K/5kaouS69x1IhGpRANiBmRfY5Mm?=
 =?us-ascii?Q?9Yu+VP6uz+HTofsr/QyAfK9MQfKh9M0iqcCCWAXVJ2bT1RUGbaw+vYm4ceu6?=
 =?us-ascii?Q?5Nd1E/9n+sZNInE+e3FCaJhNmDDyN5raPYbkd5lW67lKaO3ars/NneQs1jGt?=
 =?us-ascii?Q?mmCRO1QkfhsEYusUwXFYjTOkOTDDh1jYthiuNIYTFy2uW30DqAC7A1QKFapm?=
 =?us-ascii?Q?6gXS3LL264BcVEYmMayM/zAAFvYy/t+XNBsSuoEDMPk3WN31byI57WO4QbZp?=
 =?us-ascii?Q?tVZKQ7pn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b28a3421-e4e7-412e-94e0-08d8bf4c5f1c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 03:10:00.7929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bdvu1nck2cJaIUdQMuWM2NtewLq8bkv+RZIVX/vIuGZCmvA5OYvpgRljd10jvxGQ3a0JvSMY3cdQ2RKclKic1/y8yUyuCxjfC/JX+Ug35Gc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4711
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230017
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ewan,

>> sd 0:0:0:0: [sda] tag#0 CDB: opcode=0x28 28 00 00 00 60 40 00 00 01
>> 00
>> 
>> Print the cdb into a new line in any case, not only when cmd_len is
>> greater than 16. The above example error will then read:
>> 
>> sd 0:0:0:0: [sda] tag#0 CDB: opcode=0x28
>> 28 00 01 c0 09 00 00 00 08 00
>
> I'd rather we not change this.

I agree. While the current format is suboptimal, there are lots of
things out there parsing these error messages.

-- 
Martin K. Petersen	Oracle Linux Engineering
