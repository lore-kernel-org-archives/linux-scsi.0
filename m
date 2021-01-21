Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8046C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 03:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84E362389A
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 03:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbhAUD5M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 22:57:12 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57212 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbhAUDij (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 22:38:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L3TXZE018633;
        Thu, 21 Jan 2021 03:37:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=VHZ8QioV3CZDv9xT3bOnXt9abrOBve+SWDIbkFBxPhw=;
 b=TAjewnga1JFzCTQqHjA3pjGXPMHpDkGHYy1rTUxdomeCNl8KtP+d2INHLsxjNPzUVFgH
 1MsOJ+nTS6iwZ+0F2HdVb+Nj9r1/jvkJjpktjkoFp9SpaNhfYr2Te8KBE7GJm3PnDuax
 ihVaZorjsKzIGiSqGlzsymEQPRoNhzIS2/6VhVvT0We4ZpiV0FKOSZAZHJx8J8fIDFuU
 4e/vZVqI3v2ZTi2HB7SonivHOh19TYwK2WrR84MRS1Hfr6U65/au2nLIYi7m85csoiuu
 tbR2InO1CIQcDdVuOTpzEgqbmyQrLT+ygdeGHflQ+/3d2rR4HAasQOD7WGJ+82EecZ7+ HQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3668qadcuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 03:37:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10L3UhSs161513;
        Thu, 21 Jan 2021 03:35:14 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2050.outbound.protection.outlook.com [104.47.38.50])
        by aserp3030.oracle.com with ESMTP id 3668qwagen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 03:35:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P9pYSX5Qkuzdt8qyNb5cKQJfXmoP25h3YsatlIEuVofgnAbxpIwG/7RN+s2qB5Cp449CUNHUnOYt2YWmQAkBD+Rx5rTq3Q7+EJV9k9ON7ZGSJBrzxKxgEivN8Qmbq//21EtwxiChhjbVXFbFZsaB2oGwiXWbvHXlzjbC4A3MdkGQPI34blHiLBIs7Ro152sTgfay2Uzkkl3xgwwpRDulF+/wxhFS/CKzgU7I/Y0PRQdxlxuBnngWN82BgoJLEEdAXDYVCQydVT52ob6wzELDyQM8iUO/oaXUFGVV3bFiclj2Ef8hU4YVl2O1QIQm2I4SOMaEdvzh8PtashqhCpHong==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHZ8QioV3CZDv9xT3bOnXt9abrOBve+SWDIbkFBxPhw=;
 b=Orh0fCS7VXCuMMp+Se8jwuNDlU+GYqF1XhGdBqHQfha9HcHf71SZdjEl+yWyMU6O4VzPKPJNYJQ425uzchTFaW49ajnUS4kt11ZErZGbfunXhzXhWq52O8q9wFmcvpLe3BbScT5Ci9aV5ZWR3XahDw1q+Ai0Qn1WKwZs78X0xv/Y3758KBkhogOwXaPZ71ZXR379s/RHa2bVGePDJTqFPgAh7PqG/lbvJWgbiD2CxcrgnLJI7Q5Ue/ftoJfinMqNZuiwuzrHwg80omfql5esh3Z8Ywx+dPRZgKMYFAPRq4hhEd5ViULpPj1bEIIktV2MEdzvYVteN/Ou1nB54zctwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VHZ8QioV3CZDv9xT3bOnXt9abrOBve+SWDIbkFBxPhw=;
 b=qb5repxgH5JWPF8om1fFNVYD5TWfOaybN2irwVdBtQLt0jt+5hjvvjvzQ6kFDavImNp8IFdxH2dluALyO8YnyDclE9Wi0nqSQ+vKk62gZ+p/QnW6tMQAhqG0p61aEiZz6x9+sZJquUaR/744XhEPlmjnEUhCzuivYsyTNDLQ7Ko=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4679.namprd10.prod.outlook.com (2603:10b6:510:3c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Thu, 21 Jan
 2021 03:35:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.013; Thu, 21 Jan 2021
 03:35:12 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Valdis=20Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: Fix typo in comment
Date:   Wed, 20 Jan 2021 22:35:05 -0500
Message-Id: <161120009453.28770.7632945408684435419.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <2921.1610694423@turing-police>
References: <2921.1610694423@turing-police>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: DM6PR03CA0076.namprd03.prod.outlook.com
 (2603:10b6:5:333::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by DM6PR03CA0076.namprd03.prod.outlook.com (2603:10b6:5:333::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Thu, 21 Jan 2021 03:35:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0a3551c-f342-4c7e-10af-08d8bdbd8f20
X-MS-TrafficTypeDiagnostic: PH0PR10MB4679:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB467909CB51458B785CEEE9B38EA19@PH0PR10MB4679.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IbheFcvQKDeC0ATy6o67LDdz9uQfMuMxmi4sSZza25wdDCTpBYfQ/UYA08UxLT3DceOPyGNyoe6Md81cV2/TR95rLYxYyz1eN1yeVxNF3ZKd/fckiuJYaHLdF8K6h3BBd2yiHylUeSM9p6D76yw+MgFFcr8dUgmfAXz1QICSprz+3ahz5QkorPvCKkGRd9rOUopWp7EVhVQo3FF4MdxbbJB1ay+tGhmIwBqrMRV3Rb3SY+khu5NAwisfj8R3WfQ0xexPG2fggicm0Vu1a37wYMDkZtxg5HraGVnT+dIxfxuz435iK3+n5/YMx0/yJbGSQXIQ/lhY0bzIHSC4hWSawBUSQEAgm5+v10pQTNBToWmH/eGr7j17aamfCNQT7nbFLV5976Jhx1akFsQFXR3NbkzRYKd1KcgQ+a4S4YwBtl/Lm5QR/siG1HhN09zwNBM/HRc+I7evc6BC/jygvRWaFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(396003)(136003)(39860400002)(86362001)(966005)(2616005)(186003)(558084003)(16526019)(956004)(36756003)(8936002)(2906002)(7696005)(52116002)(5660300002)(6486002)(6666004)(66476007)(66556008)(316002)(66946007)(103116003)(26005)(110136005)(4326008)(508600001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VVFuM29sVGlqNW5kdUM2R3RjdDE5R0tjcVBYeC9FY0Vjc0piL011UWEvNlpO?=
 =?utf-8?B?amR1VFlGV3EwSW9jbzdMUlR5VWJKVDlnQzhvKzZ0dmVOYXdCbGkyaGxoQVpw?=
 =?utf-8?B?dDFzTWc4SjZxU01DNk0rYjNUNDlzTmtyM2lQRnZPNWtTYnFwNHhHT3JnbHNO?=
 =?utf-8?B?NnJlRm0wYXBteTQvM2JqMEJLM0hFNkFkMVFtQTdvOFJlSC9McFpDRHRoVmpt?=
 =?utf-8?B?dTM5UlVwZW9VZk1KNXB6eXM4VUpuMHhGU0orQ0lFeld3TTE3V09zaUhPNlo2?=
 =?utf-8?B?MzRBRHBML3h4ZURtSUd0K2Z3TEI3NEFVZ3FXZHl1RnVBS0tuN3JvY09Hc3Ba?=
 =?utf-8?B?RDRPTUhCQ3NiT2N6RWVKNldVdDEyYU1DMkFVK0JCd1hvc1FJTGNnNDBoaGUz?=
 =?utf-8?B?NW5xZWlaLzNzTldtWU8vb200cFU3TkVhNEZFWGFvVE9WanBWSUJlYVRnbVJJ?=
 =?utf-8?B?cEViSnlXR2F5MTJJK2VLN3R2ZnVQakRBdWh1a1FjdWFxZDhibHFkL0NPK1VF?=
 =?utf-8?B?eWc0Z2dHZFZ1LzRZcFk3SVZLV3A3NlpYbk50Vm9ZdjJ3amtDNnVrektmUEJx?=
 =?utf-8?B?bWZaKzJpTEhBNnh5eFEvZnlJRnhYd280OEg2RGg1czdpWXZEazJvYUJ4Vzdh?=
 =?utf-8?B?UGRhcmpIcVJ3bHoxcWRzZmx4Q1ppdGQxdi8xR1ptZ1d0czJPSnl3TFBYQ0pQ?=
 =?utf-8?B?SGZLVGNpeU5XcUVLY0x2U2NidzN4b01ndzNTbFgveWVmQ1doQWZsRkRyemQ5?=
 =?utf-8?B?eUJuaUUwbFczTnBBTTJ2a2o2UlJZN0MvVVVJc29OT2YzZ1ZZMndUd01FdldL?=
 =?utf-8?B?WUN0K0FFS0NSdDg3eU9ld3liNFhnTE14Wmo2ekNnamU1NHJGQ0hjMjl1UVZv?=
 =?utf-8?B?VHdWeVkxYysvN3MrNDMwSGdiempFR2FZQW9oL3hNNFVhbEpZMXhtd2NFekQ4?=
 =?utf-8?B?eXZybm5XbnRQSVcyUEJRdUVmNnFobG5Rc1p6aU1IVWZ4YStEb3ludmlPand2?=
 =?utf-8?B?VzB6MkZNOTFJejloclF4M3NRMnByOGFFYm1OQXpvVkhLSUtJYmgvNHpKYVRt?=
 =?utf-8?B?QStpOWJRSXhEa294dWMybVdYZjFKN1pyYjd5WmlGaWVPMWtjTkdsZWhhUkZM?=
 =?utf-8?B?TUVLdEwyWDdrODhuRXFwYlZhSmZUSjNpMWJyeW0ydnNZUFRtVGEydis4cnZz?=
 =?utf-8?B?SDk5QlUwRFBCWEltajF1c1NuSHluUXpxVDYvYlg2WkkzNU5raEM2b2ZuUlIw?=
 =?utf-8?B?Rm13cllpVkRXc0VPM2lkb3lzQmV5Z0VER0ZGd3A0SGRING1kZlRQWkNYYnRr?=
 =?utf-8?Q?WgpslZh0OpPCc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a3551c-f342-4c7e-10af-08d8bdbd8f20
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 03:35:12.3006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cMzuL9C6Hj1ufMMymOBA9h24aVu4fbiP3kKFd3itp8oxLW+W8qEhxwBSvn0bIiibhOQWzrJ7QF/4YeY2QgFcUVCYWwJfDE0HS6XnOsCckd0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4679
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 mlxlogscore=967 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9870 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1011 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 15 Jan 2021 02:07:03 -0500, Valdis Klētnieks wrote:

> Correct the spelling of Nagle's name in a comment.

Applied to 5.11/scsi-fixes, thanks!

[1/1] scsi: target: iscsi: Fix typo in comment
      https://git.kernel.org/mkp/scsi/c/389102a3515b

-- 
Martin K. Petersen	Oracle Linux Engineering
