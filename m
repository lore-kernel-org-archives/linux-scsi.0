Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E49C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F31120709
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:38:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbhA0FiB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 00:38:01 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36162 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238697AbhA0Ez2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 23:55:28 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4j92G092662;
        Wed, 27 Jan 2021 04:54:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=GxoViX7EE5vyWLBXL9U7bZt4KL7OBMFp09m/18iBy2I=;
 b=RRzSY2iqrPg4B6UoHlBLtEOzW8Z62SsO05GbjMMhoh+Clgr7TMfIAcC4D7e4r03rs1CL
 Rzh9wUorh9s76HCdQM5L6lhQdCk/NaSUfIVoHQ7NyKT4wMgkk8nKZxdv5h1R2pKx7mOO
 Pm1STbMbIWWkkMXGs/Q/Hr1E8MBiprNTzRcD97tlFpXv4zSV0SWs0k1pp7q6g9fBP8C5
 TifPDzQSPSe5nIklEzwkFmX/cP8OJqvaCSJ1oyZF73FVbkK9lAZKWc+aP+XMLy3I04O7
 15OAFH4VMtN2i7MiZCuDHvozlLUz/3se/iEBV16ZhVEZYEKfFORdCNZnvv3sc7SFh7IA oQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 3689aanbav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:54:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4p6Rr188980;
        Wed, 27 Jan 2021 04:54:39 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3030.oracle.com with ESMTP id 368wcnsk3q-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:54:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hbi0T+QQmuUiQBTaEwA2ctUjjAFPhrtfXbhZTHrsORHFeQlLmdA4RVw3M/Azg9uIImmn22jLUWgT7WaklJ0bbrzqs8ez/IGP1g8P9FIN1sBFqJ+PEdguzZF8VVA7Uh0b7oieB8IHCUOc1DNIv70q7CFDhjViwj58xOsKhwQc3rsKmp4uGzo6JjJohqdDcQpHri3KU/zD+FOJNgIi11/lL5SRNCosD32W2yRX8F7M10SkOUbKyJt79EmOOfE7lYP/dNWtXbWE2lqM/CnGtIXmYPeSjkk9BQJmZuXzkuRKbrbpqBFIN032ST947Eo0KlGA35UbKumaeVILmBj7KRh6rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxoViX7EE5vyWLBXL9U7bZt4KL7OBMFp09m/18iBy2I=;
 b=Of5k31NKa+2QJE6br+N5mfa1gSY+i5cZ6FLjKvC2cnGtAv/0410apoHJmgGen4vNyWcwy0AfTZckZhRPTUWgvcnU7KZrKXmMJLwM/abdyU6ZGxySGZg09W8nQhXQhxOwGrHLLaYphMUvcH9IL+36CDbINqg6S0ZLx6liqARr7/yDBRMb0EFD/kTuA2EuXCTHA13bTUthRm4TlIXa6Hy4CZWWiFNCqlcWk4u7+Yx5tVeJGWhSGojmioDocML4Qym5qvK+A66ZsxrVt+AYYgpHIzCo29uWK2C586mxWJaR1TpIZBr6+QLpzoFMgjwcPhhsQ7zrprOStwhVLeVOKDdqog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxoViX7EE5vyWLBXL9U7bZt4KL7OBMFp09m/18iBy2I=;
 b=MdzTKuZB5Mbb5AE8XF7aRPVsMjTQ8NiA0kVOT7yOCoYssNeakIP62GERwaeROMvEVOEc/IxIfr4pKxTZlfBDO/YKZltw9HkxYyXZB/FOrB4p4rcpjg2BrkG5rADS8/z4iSIpbXdz7ptizOxsuBjn2Rx1Tmp/HzoaMjjG/8U5pdk=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4584.namprd10.prod.outlook.com (2603:10b6:510:37::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 04:54:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 04:54:38 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     njavali@marvell.com, Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: Re: [PATCH] scsi: qla2xxx: Assign boolean values to a bool variable
Date:   Tue, 26 Jan 2021 23:54:20 -0500
Message-Id: <161172309262.28139.584469221917900330.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1611127919-56551-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1611127919-56551-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 04:54:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b84c5da-7815-44cc-e86f-08d8c27fa63f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4584D90521CD0B08F1B3B0C88EBB9@PH0PR10MB4584.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /keJVRMuFS86aEnIOz90HbubI8n2JeogACKjZCUnjXDJ7xUWukoINAluJaQ5c5k+f6zxXBH7/Hc0Z3H0JFc8EesWYYE+E3ObijWHIlMUYzYYK9u4pWbyr2Seq7VZ8UV21ruZRFyPM6XT4MLAzCCLOj8kectUEVr1jyqpu4ZjNIa3oAXWJ16jnA0H7ZImvzpu9E7F/8LOhr9O65smOJKpe3IrKQtm7uInkGebNObH04lDwuYnSEnPOZTR6Ia536f73J2vkMNKqwmsBOFFqniRtmq7YqUrtVKOazyh8BLmfzJtxNH2mfWsh17bvuIQV0XkQs6goNUaSLq7Yykx+7DPVevpLAwepeVKMWiRpU9q9OWj5Nakr47PMI03RjzIRKHWjQc6k9Y6HwjMu+1Ee8AnlqKDN/cSVD93CUJErS229YvYvi0J6Xz+XU5hKga9OIczAkZospEuS8MtyA/xpfbwOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39860400002)(376002)(8676002)(66946007)(103116003)(6666004)(16526019)(4744005)(26005)(86362001)(186003)(36756003)(83380400001)(2906002)(6916009)(2616005)(8936002)(5660300002)(4326008)(66556008)(66476007)(52116002)(7696005)(478600001)(956004)(966005)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VUZMMTVtRzNFSU1tSUkxWWNpZFJGU25NOHNud0kzREt1WUFpNlFMcXZlV3Va?=
 =?utf-8?B?MTFZUUZWd0o5WHQ1QUhxSFAwdGZEQlJQd1ZlVVV5azFvRXB2d1ZXc2pmUUhi?=
 =?utf-8?B?QkJzbm5TRi9kMXdQMW5RYkFlRjU3dTFQbktBaGIrOXhoTzBxWWl2NDVnTmsv?=
 =?utf-8?B?c3BRb1UremlxQUp2eFl2bzlneldzUVl6M3ZxVEV6T0xBNkE5Y3ZCbzNuYkxD?=
 =?utf-8?B?YUJJdWhqRTVxRUFHYTN3OTdkNm0vdmlkVXREWXdveXlrY0lmbFZSanVDby92?=
 =?utf-8?B?VFN2VU1qR3lOb1pZQ3hmRm02cVErRlZUZzhLWlBUblRFRGJBcjdIc0g3YXl0?=
 =?utf-8?B?NGdjbzJGRXJmeFNRaEU3ZUdteGIvVGZxZ05hYnNyckEvcGlHODVPaHhxZDg5?=
 =?utf-8?B?OGxYSWhqQ2hTYTZ4ZEk1bDVCWjVVLzNQZ2UzbXAxSmI3ckpDd2wydzVRMy9z?=
 =?utf-8?B?SUpMWi9WSkxSUzVTOGpaN1J5SHh1MG54V0lDYzlmT00rQXdPbjdsQXJRUkhF?=
 =?utf-8?B?QklRNkwvY1NKZ3ZtOEFYKy9qUGN1VWdBaDlRY21ka1gzbDNXNDJ6bzNScEd6?=
 =?utf-8?B?cEEvU1dGNHNXTVBHLzFkcjU3bkR2MnBtWWtIUnZodWI5aythdkxqZHU3K3FE?=
 =?utf-8?B?aFluNUd4T0ZjSWR2aThxN21aZU4vcGkrYWU3U2I2OU5RN3Z5aWZnMEVYYkR6?=
 =?utf-8?B?M1htakhRdTBFMU95TytseGthY0VlVGJHWVRENThoVnRESGg3Y3NEeWovNTM4?=
 =?utf-8?B?cjB3VnhNbHNJUnpHVzVYOWpmbThFcHpSY1ZVcXQraFRRaUd3dUQ3RldEc25l?=
 =?utf-8?B?dFdSeC9QQWRYb00vRTVUL0xvUUd6aHErdWhuSUVzSEt5cUhLMjIzbkRFVjR0?=
 =?utf-8?B?WU9CTllmOTF6N1NBaHZkaThuQWN2WjZKYjY1VTl2OFR4N1RuT3N6WENFVTFM?=
 =?utf-8?B?K3VkSUVmZ3ZxQlpFTlZ1UjV5d3Irdmw0RnRIUnpOdkVMZkVkKzhYc0xsNnBL?=
 =?utf-8?B?OEw3NHp6c0Z2NlVSVitPUVNjcUJtamxEb1c2Vmd1cHQ3amZwVkJaV1huSXdP?=
 =?utf-8?B?Nm51Y2NadDd0blloNFBUWGFSY1laTU5lNUNMZldZZDhWSi9HOGFWQWlVNDJk?=
 =?utf-8?B?QnZIQ1U2NURKVkNMQ25oU0hzSE5aMk04dVJGeldOOHhCYVFrUjBhM1JxWTJE?=
 =?utf-8?B?bjc3OEFSemI0WmdYYWxnWkJsU2hmTHNUdTRIcGt6Sm9yMllUVWppSHdzT3Rl?=
 =?utf-8?B?NWlRVXN4M3BKMmJtOTVORGt6UWVBaTdiZldGMUdOYVo3b0dBRTMyOUQrWmZE?=
 =?utf-8?B?TlVsSmV5SlQvNlR6S2dLd1Zjcnc5aDdNbE53UVNTUUFOR1h4dFF2QkpiR3BY?=
 =?utf-8?B?UlRpTFJVc0pKU1pZcG1mblpiK3BFWjg4bEMvdHBFMzg0WHBpK29DOXR1OW51?=
 =?utf-8?Q?ySOzZ/v5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b84c5da-7815-44cc-e86f-08d8c27fa63f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 04:54:38.1046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cnpn3P+9FkrmvCPq4ZQhZO4n/1n9x3aJ//8qRZ/pgw5kR5YiPyNtkAsBhQwpjuFvOEM/s9JnXG4zzWQ4FPSqubX2BIDtGk6uLW4tnN8P8DE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4584
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270027
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 20 Jan 2021 15:31:59 +0800, Jiapeng Zhong wrote:

> Fix the following coccicheck warnings:
> 
> ./drivers/scsi/qla2xxx/qla_isr.c:780:2-18: WARNING: Assignment
> of 0/1 to bool variable.

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Assign boolean values to a bool variable
      https://git.kernel.org/mkp/scsi/c/71311be1cd3e

-- 
Martin K. Petersen	Oracle Linux Engineering
