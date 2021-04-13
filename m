Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07CACC43600
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF73161221
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344746AbhDMFte (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 01:49:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51036 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344716AbhDMFtA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 01:49:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5hvpY053585;
        Tue, 13 Apr 2021 05:48:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=7wLPp6EniXWkaY+ZG0dTi72s6oiOlzme0ALQagHnqz8=;
 b=Uqr2oaVjyfaMTt/DE/+Z7xmHb0vFiej0GVbvsgApLtjLWzhkJ7876mF90Y7UgfnYrQj9
 9Ew0pKqxMzux/zNzREhG7Wdu3z3grN6mAoOuRb4YZBNuG3YG6YwMah5hqWy7ooz+tuJk
 VcbVn6a43t0HqEWL/08D8jtpUZPmqKQBZ5TcUxxiF+IFbvFGdCHfglt4hP49DhI5M7Oa
 p1foek10cOmwA7rGIOmiOeBJcWZsuOyogC6ju6PKcdUWbmQ9U002cpuEPdqyfbAzMtR1
 f8HrdpjTp5c/sM/3AtAYuFpXpiIufd7dNklVrI+NUp042l9agRdDHnspd8B7VWUymQt8 FQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37u3erdut0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5kRqS137301;
        Tue, 13 Apr 2021 05:48:36 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2055.outbound.protection.outlook.com [104.47.44.55])
        by aserp3030.oracle.com with ESMTP id 37unkp3meb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X9UrFd/Yi/yvvOJn+a/YVVT4R5slaeT29xJXa70rEpAfTimIFeta4FqlByv40ICd+QjUh3/A/4ENgTxpRjYmLAAVgKkOFHh8I+J+B1lN9qFVtvk3Udf2zZ9GvpY2PA3Q8wjwDO+oICs6XeFEu3v5nLO1pRwnnqhMOyR+A0h5VrAtmdm6BpgZECiJ27+b0naeBUjjfpF+hPHun7XPng4WQ2YwlbzyAImLv2rntMJX/yMgoCt+z7obm/8LSgrary/kpWxFtdc8jAVAeXiM5Z9k+tt8frPBpQtgvj2uvxGN7fEfGmx+rmx1Ympw84L3rPdGJdAmPO41kg+edkG6zDLw1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wLPp6EniXWkaY+ZG0dTi72s6oiOlzme0ALQagHnqz8=;
 b=d3hOLpsun3OHY+UmDGyaDp7iBVKA/WDjZg33XvSt5jUNJU/++kx5evmy5U8NVTyaxZeNp0v4de3nxjGicKtmsI8ayIjBos9O8XttRNvlsPmbmF/b+ZoxnbS8H8y4WHlKmYXukcbPGC6tQQaKf4K+SRqaExCdlBNlQgCWuTMOMsR870d/WKbB3RyYIfsCiPVld4pM2Q1Cx5DDNLpPlod2fnNxr8mwwNwMr/AmodcQrXP46pHKggQ2HWI/BddSK4tfQZ18yhZbhm44K867/mybgl8+ywKUTrMbWoRaOl4RbGeXNA32J5MCkRJtammcrIBRNu6RjAKL7wXUXEbCADVAdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wLPp6EniXWkaY+ZG0dTi72s6oiOlzme0ALQagHnqz8=;
 b=u9m7c09mU+xGfkGm/SlEzZDZU6IoOQ6qHbVDCL5WAxKqQw0nJJSEaYDoqp1HztVe+NQJJeEJxyL5uBVCZ3GlViT7vQqDENy+xm/M9lh2zn2PwiZVa2XH+S8o3usirFL45gkTOo3l07l8S4HkhhIeHti2SsALQrfKSGWDRXmS6zo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4486.namprd10.prod.outlook.com (2603:10b6:510:42::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 05:48:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 05:48:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: fnic: remove unnecessary spin_lock_init() and INIT_LIST_HEAD()
Date:   Tue, 13 Apr 2021 01:48:20 -0400
Message-Id: <161828336218.27813.18428149269069154371.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330125911.1050879-1-yangyingliang@huawei.com>
References: <20210330125911.1050879-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: BY5PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR03CA0008.namprd03.prod.outlook.com (2603:10b6:a03:1e0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 13 Apr 2021 05:48:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcb0e3b2-e89c-4340-aee8-08d8fe3fc772
X-MS-TrafficTypeDiagnostic: PH0PR10MB4486:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB448685AAA2B67966757D1DA68E4F9@PH0PR10MB4486.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7hFtBieNevs1KBdI6PEvqrUPfYRX85O/yeCBNjdDFYXWcPuVcS4NJ7q/YzAaHISPAh/GmxyUWWut6rvGuVap0+ADokxVn38huaErScH90fsuLoNWes1weAEIQUTaX01L0cz+0F7av7SyXztLZRmr874JbDDCaNrKlO1D0uU2NnRMyCONgozOWQlOf75D8rmLqeJboP1Qw04uHwYXmRtcjU05tKLPxxKyflnnlrhcVThtZQTtYaUR+hQfVm1JBp/l9V+jD4WMIaHeIs4ZZs9ikzKlN/R4R6Uyz8hkLYiuz0gJLsTgCzDEcwJuTfoWpyTW7E/h1nLWONxiEtevqjzhr83KC2cEwLEMevQ5+wVZWDGKscM0s7nAyisQB8IrN1HugfyqTv8TRZOsPJ9je7kT0vtaNs9jTB4IzaogkBWzRviGxQY6MbE+eYmXv8slL48UrT+Cqlatjv2HvYNyP14Lq9Q9X3Tt0zAbLE3kj+k7kpoYXsNqlJoFbsep5tdfmEp7uWfJjDM2yMBs3rG1yOfDWq5u1gLa433h+9rUolIwDxZnpQulxgkTJre+QiWEnq0aa28kngBkRWE47ZNfzclEt0/Fp0M9dx7/TYPHXlRXWYFw+n9vOdtlyl4+eRtGJahXUSRxKbwMwHvpJPxOPqFanBgWeSOa+MkqPos7nhCWRM0eVSbIJOphA2gbqj6xtVW2AOHdZ9eGLlVmhOZt2QSR1uTNIPVM8jhjEpAzbfxnCFY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(39860400002)(366004)(376002)(103116003)(38350700002)(36756003)(966005)(16526019)(2906002)(26005)(66476007)(86362001)(83380400001)(186003)(478600001)(66556008)(66946007)(6666004)(4744005)(5660300002)(8936002)(2616005)(956004)(38100700002)(7696005)(316002)(6486002)(107886003)(52116002)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UEdJZ2k0MXM5b1J2ajRMY2hud2YyMGZSWHgveUJFNjlrNW0rK2U1TTNBYkxO?=
 =?utf-8?B?R2M1MS9HaEIxdXZDL0ZXZzBzaks0ZTNoYkZUclFsVGhFSW1PTGlKaHpDZ3RI?=
 =?utf-8?B?dlhiUDFwT1psVUxzVEtTV1djdnNuTzVoTC9HSnNaSlNzNzNpckRQNkFKc1ZO?=
 =?utf-8?B?VjlTT1V6TkNhUk8weEwvTUJkNml0YmVqZitFUTFrcFBXOHRxVDREVjFyRFhG?=
 =?utf-8?B?dGhRMjM2b1ZXdmFzNW50NnZmcUU1ZmpKMWE5MmRCWUhBNldCSUlJK05zYzdS?=
 =?utf-8?B?K1Q5ejVvNDRmeXI5ejJmdjZSTlFoK0pkVW52aXZNODVBWkFZYXp0UG8yUUJ0?=
 =?utf-8?B?bGluYVVwRXpCeW1CWnJOUkN3U01rSTRGZ2NXYkV4TXprYVlQa0VjWGxudVho?=
 =?utf-8?B?YlF2RmVFbS9VTTdWQllQcVhpOURFMXRTdFNzdUZXSUlrTjQ0ckxNZDlrNEFK?=
 =?utf-8?B?amsxNVNQcHlLUUNHajhkZVVHM1Fac0xjWk1XK01RZzM0NUdWUmV2UE42c1B5?=
 =?utf-8?B?YUhyMG9haHNjMjdWdzJFME1Ma3lvU2JXT0FzQzhWVUlqemZlYXA3SDZPSVZG?=
 =?utf-8?B?MUt0WkdkbktqWE56bzZBdUFMTTgxMHM2c3VVUHI2eC9jbi90VUxVdkgzbUpM?=
 =?utf-8?B?NWxjcEV1T1d5b0dhN21DYVpCbXVpZVZTYzRsTWo5SEFLdEtLQ2FUamRIWnNX?=
 =?utf-8?B?dUJuMkhXQjZpK1ErdWdvaFNFNWZtcXdWQTd1ZkNjaVdvRVJEanJtOHhWOVlH?=
 =?utf-8?B?VHIvWVUzSmhOMjBGcXdxdzk0c3dYSzB3aGIyV3hBclB5QkQ1L3BrblRiazlT?=
 =?utf-8?B?eFROSk9qWUJGTHdPZGFrUGZiZS8zVW5NeDdUUENVNGpxcVh3eWxKVXJPZ2hz?=
 =?utf-8?B?amVYbFdwa2FsV2tHK2J3ay8xZXFYVEhhUTlRN1o5QWc2ZEZOSnZieUlYNU5C?=
 =?utf-8?B?dkxpaGgwVGIvc0ZhUXlOMGFQZVdRUVBwWFBXR1JMb1ptT09Qb2c0T0gxeWtn?=
 =?utf-8?B?cjVvZk5FWXZsalRjeW9EUEdTV0R3aUJaQ3F1Y0lRYTFyd1NHRm5yQnJUY3Ey?=
 =?utf-8?B?S0VmV1hCb09pNEQyWW53eXE0YWRXbW5lYnoxVWVXem4zS3haUHNKQmdoQnY0?=
 =?utf-8?B?ZEVubEhKVkRvL1ozVmtHT25yKytVdzNMS002aVoxT3RHaEdlalExR0NXaHNx?=
 =?utf-8?B?VE15ZmJzSTl0cDhzZFRvSkZyOWp5ZzdlV1RxeGNDSVExSDFHZkdFdUtFNVVo?=
 =?utf-8?B?S0Nwc1hZa1RocnpVN1pORUxZZVZiUms0dnJwaVJWWVdiaEZEODhjd3R6MHc1?=
 =?utf-8?B?b0VDOEVleE13YklTNXY0YWFKZGZPdjUzZjdiU2FhNjFIL1J6U3BKc2RTbURI?=
 =?utf-8?B?Y2VRc2lsTUhLbGQ3K2VlUDNDZ2tkOGVUTmV3a1ova3M0a0VWWEVnN1ZhRVVY?=
 =?utf-8?B?SEFFVzBEWkUxM0g2VGgwNmdzWXlaVjR0OExxTVJ1QStycERFWGNIekJlTk9v?=
 =?utf-8?B?SWljWXNrMmlYNHJiWVRSOEp1cG91RzZXTDZBNWZzTzNIQnUzQXVmWHRtczVP?=
 =?utf-8?B?OTBVYWY0QnNudjFiejRtNUxsWnlOT2IzclRiOEo0dW5VcWh5RmdOUWJ2eG50?=
 =?utf-8?B?N2FtaERoN1hSMVJNc040VmVJRWJqSmtKVlVDNWxTbjZKQmhSSkY3V054OFM1?=
 =?utf-8?B?eXk2RVpzbTN6aDVRaEZkbndsMjJrdk1iRFFyRzk4N29YRmtCRmM2ZFRob1hq?=
 =?utf-8?Q?l68BKOo55tIfFadMZC7bk65r0WouuO7Yb0HLx9l?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcb0e3b2-e89c-4340-aee8-08d8fe3fc772
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 05:48:35.7353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 26VauLF/ncxEqDXL9XKyHseSjXbdDx8zuZkTUh51vux7xaxtnv47e4i5xAqb5v3XxerbtETbL38mbL6sCcpB7q2H9yiknNoByac6SUmQNb4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4486
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130039
X-Proofpoint-ORIG-GUID: cWWCBuuDoVvKsO3ynnkgyDdjV8MIE8wg
X-Proofpoint-GUID: cWWCBuuDoVvKsO3ynnkgyDdjV8MIE8wg
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1011
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130039
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 30 Mar 2021 20:59:11 +0800, Yang Yingliang wrote:

> The spinlock and list head of fnic_list is initialized statically.
> It is unnecessary to initialize by spin_lock_init() and INIT_LIST_HEAD().

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: fnic: remove unnecessary spin_lock_init() and INIT_LIST_HEAD()
      https://git.kernel.org/mkp/scsi/c/aa6f2fccd711

-- 
Martin K. Petersen	Oracle Linux Engineering
