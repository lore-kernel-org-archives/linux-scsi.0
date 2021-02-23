Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1E5C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 03:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3919164E57
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 03:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhBWDXU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:23:20 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37168 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbhBWDXT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2021 22:23:19 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N3Aqph101231;
        Tue, 23 Feb 2021 03:22:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=BsS1LG88RmxZ0NgZ9StwUIbZOYkKiw7kMthFcDkOPyE=;
 b=YLzzlhs7d0Q7nCJIsxyadVLObHgx1ENXRSlfyBnZpMW2Mw9vOHimMRLG3CZ/Li9WwQ7d
 tHhfPhQEJGR4KT6PFeP9Sw00uRjVHIv5LD21Dcw0RxLXab7y73NQzZ5NFxt9RpgowEHg
 bJQcWptBQl1ztyVA3hkY7dv4W/Bn3HZL0n7Z1UPX6RJugyUq17MAI59KqpdenYhSbt5x
 Mive7d4XGnOKz3DZqD3aQhw/KRgs+5iFr6mmwsijPW9Lky/nx5kVXQLq2Ks+UfQisi7u
 xd+Hs43izMCHe99J5pNlxDtai0bsLs/wljE3lW0Ucj6CNe7XsBZW2HNBJLA9NIPmHDgW Tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36ttcm5r65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 03:22:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N3A8wo057474;
        Tue, 23 Feb 2021 03:22:36 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by userp3020.oracle.com with ESMTP id 36uc6r5exj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 03:22:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bUCzjCpRoJ6aHtv0MenMSFBm/1roy8hfUk6hRxUv2rtLct/J5uehhOnBykDkAp+yffbF4pqWD+Ji4xsXpP/Y24SPwKHrWiinetK/u8xF2M+FYWzm4Bg3HRrJxc82L05qUNVE8EcR8zDcWqGVvKfQVP+pPl8Zmx7ADpmFL1zgDtcJ6Yi0mL3qC7dnlayJeaJ/Bc9njwDBWPVckguoGQzfYkZ/TE2AnlqC75hHQQ+CrkOkxqhEEzKd8bvhDxuM90ZX2/q1Rfp56xxaOa70KXGlbA8umwy7Xm9v66INQtMqB8mrmP1va1SWtSTlyFM18+IKHYJeLkv3LbEbsdICrZ24rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BsS1LG88RmxZ0NgZ9StwUIbZOYkKiw7kMthFcDkOPyE=;
 b=IVqvkMnqul62V4Kp7PDnBqvSVeSydSstqLV5xX3irwdvuB8sC5YA64hbaadDKwwdclpiyBuvGm8vyAWbKJq6GVpKURfGpqDXVUMlLCk5zlIXX9s8M5G977ZK2+17Ihw7Wdi+YQzJ06cqU06Lw0e+GgLt0pDFvwgbG0/94dTReQyyr5e9mT7wGoqoJQtBQDlsWfRS8GzOLHlrtsWQoCgbR1HJnu0Vl5SaSxx6p2T4CXXTUK+6Hd6QOGoYjB4Q0ClBQp2AYNSmo4iGA/YQ8yZmHFOp0Uup75m8t9ynnbKOTQk3xjyx+FJcfXPt16G+qrMWed0PXEX1UD6Qplr5f4xhPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BsS1LG88RmxZ0NgZ9StwUIbZOYkKiw7kMthFcDkOPyE=;
 b=SrKf6ydKmiNUlrdEurVBF7dsrDiiw4uZzPgYZxj5hijyKrHjaZfzM1e2+AW2Q4z35dpUHReH/KxO/qVhHzX04kMOOCaYwzx5rniNMi9ybm9djvv7mVfnutnJPnc+k7x5Tx3/rfwczqtJlKiZFyJzDsrlbyBi1ve8oXjXUR+cUSY=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Tue, 23 Feb
 2021 03:22:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 03:22:34 +0000
To:     Aleksandr Miloserdov <a.miloserdov@yadro.com>
Cc:     <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <r.bolshakov@yadro.com>
Subject: Re: [PATCH 0/2] Fix target not properly truncating command data length
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1im6jh3iu.fsf@ca-mkp.ca.oracle.com>
References: <20210209072202.41154-1-a.miloserdov@yadro.com>
Date:   Mon, 22 Feb 2021 22:22:30 -0500
In-Reply-To: <20210209072202.41154-1-a.miloserdov@yadro.com> (Aleksandr
        Miloserdov's message of "Tue, 9 Feb 2021 10:22:00 +0300")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CY4PR08CA0045.namprd08.prod.outlook.com
 (2603:10b6:903:151::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CY4PR08CA0045.namprd08.prod.outlook.com (2603:10b6:903:151::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 23 Feb 2021 03:22:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 540ef252-ec9f-40f9-152f-08d8d7aa430b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4408BCCF2FC769DD16E240268E809@PH0PR10MB4408.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1smfh3F6qZZ9/3HxxqiW86PxLyxiKFdKt99GDYJTVACNmGXS9nYGwKzGZ1r1Iuf3C/KyKk0MlcT5uSIKleKLWXaRZ+AUkx6ZvkT2W74dR104EkdbYPPScBRgA5kgZA51kNOByNo0DwzR3nxb0EYV7vE2Sps4TaVi+LWmtk/1RIIxocJiVUvISEmqE4kxAGVQPCV/HailRQtwwQInxK3q9hGA/IkREKlhSqwElOJE+V0cLXjXoNg+mMILZpp2tAxEp2WB9PVT/jm41yL5s4P4xXFtwrNJBNC43ydLqq2yVBywezo6gdbOmJE75BMQIsmZPNRKFDkWMvX5K4WQWBJ+5Rk0rlqUl8knXcUnXoguAYBTRAFGW8yYPjfSTOzihYEbLRFZYZButbcmXXQvJuAACfIApLYsKAiRZ1khHPQE0ZZmUFpUJ5m7lIxtKhv19Xlub90fgUkLE16I2x/aalZQ/tW0vGWfvd/NA0kz3/I23CiWBvzQ+PvbmRc13h9NUPvv1uuWF/JFBwqIUAXOmNToRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(136003)(396003)(366004)(2906002)(83380400001)(316002)(8936002)(86362001)(478600001)(4744005)(8676002)(16526019)(186003)(956004)(6916009)(54906003)(55016002)(52116002)(26005)(36916002)(7696005)(5660300002)(66556008)(66946007)(66476007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6/65RFvkpMqVuS6kmZs64gzO1ODkr64PAfvkmu3EfcDmckIzcFIe1Ajpf9bG?=
 =?us-ascii?Q?mV76uhLi6bUXn8i0I9ksEQP2fc1hrahp6xJw6hNxShzPBAMZfy53WyjrdW/2?=
 =?us-ascii?Q?ELKxRQX1ro9+ul3DdgwgM5+F5EBtIFzAUSGghdst0j+pUD91gafCzdoV1fCS?=
 =?us-ascii?Q?bgwnL8k09EzO46Mj/jJqfU2VLdc8q2AWtS2BwatnWFtn3IelWfFFjzZB3wBv?=
 =?us-ascii?Q?77CSOw7u3zlfcPVIqOb3ZaKQa78XuJquPn8rZmt5UB/j2WqeNlNk5efOpYPy?=
 =?us-ascii?Q?V1pbhDpvCZ2UatPiRfGSnD6UaWPQZ2sPiHwwtmyCIe75sKtTImFOqfxDBMAc?=
 =?us-ascii?Q?tOIJujED2MR1oSHGIYG1cFQmWar128k9gj/lBxHRCialpU74F4G+DxVwUL+u?=
 =?us-ascii?Q?98DKaakVlNjBqvf7phMFir22Ya7Jltx2oGKbSpYmTcpcM6suUiQJzjKWpNQG?=
 =?us-ascii?Q?QebxhLLWnB0XJO4snkLNh4yVoFFDE87UW5QJZ9xRE0MeD3qqrPTSjPa8RFRY?=
 =?us-ascii?Q?LvOjpQg8RxRsTR9CFxvHlY7vRk4bfBmZ97YVM2tRNEfTdKsAXR7ramHmddIH?=
 =?us-ascii?Q?7BMqif3aREpsO5J+x2ki37UGYgncilfBNb1fXd00SewnaVlsCsRzZ2n5zsV+?=
 =?us-ascii?Q?cdI0paYx6IGEaZbtWNXe+v3ESECjn1ldKyVJ+mXUxZdVoFJaaAuaJqC5fGp2?=
 =?us-ascii?Q?JOYlCULDelVsz451+oAkYjk9+esg2RD4+q60Cn/k064uyumetJgum1hzMI15?=
 =?us-ascii?Q?gpHM0/W4nvw1wEnqzP4cCyvB0LfmRWKXW8S0m0Y/ehsZK1Hxg2i3luTRHPkl?=
 =?us-ascii?Q?3AsP3WydzvobrEIYBvH51iaAvb1RCGKOkQ2KfLSgcAVBgZcZb8/Kwy/2zyqH?=
 =?us-ascii?Q?wvMQlUJyJiZzgvX0GPtLjmQSSUeJ6Nagffyk+zBbYvyMSXDJa9TCGQqTHHp/?=
 =?us-ascii?Q?O2B/78E73fJkbKi+f85lD9/qmxLSh7Bgfd5YSQbHRVjU1YK5E9urikWCyeCY?=
 =?us-ascii?Q?ciH/EB2mOTVFjU3PMf4QDZSg52UBx9jGlkOW2hDyY5bOiWVB4hi/rREVsF8g?=
 =?us-ascii?Q?QsGtTYXeQr62783SPZpPG05milpbsLwNt+ReLGqT2MhADWOpsDiVa+z6Tmfg?=
 =?us-ascii?Q?5WIi2qxjqDtMAArew8IGfe1OqeDn6we0Pc3+qAJX7tBI171O4J6MwHx4BAt3?=
 =?us-ascii?Q?FbmBR1tLWv71MxEva7so9613PP1HtN7x/QgfrSq7YQVEPtc0y7DNJ8EKjcLK?=
 =?us-ascii?Q?MIucHiiBM1mawLSrlMB4fObMoSnBf/yURF33CFA4hu+H08kqlNhB+RxlwRjJ?=
 =?us-ascii?Q?X+olNwumfR0qwz/pK3HKNOhX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 540ef252-ec9f-40f9-152f-08d8d7aa430b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 03:22:34.3302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ApIh7wyBt5S+mfPhwRIZf61uoCpZuXNMOpsteajiIlIuls8EADjxckx7sWzm4BqEMha/bfB1A8eiXLpmI4eogNlqe8nRTEe4adk2U7nrNwU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230026
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 bulkscore=0 clxscore=1011
 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Aleksandr,

> SPC-5 (4.2.5.6 Allocation length) requires to terminate transfers to
> the Data In Buffer when the number of bytes or blocks specified by the
> ALLOCATION LENGTH field have been transferred or when all available
> data have been transferred, whichever is less.
>
> PERSISTENT RESERVE IN service actions in TCM don't follow the clause
> and return ALLOCATION LENGTH of data, even if actual number of data in
> reply is less (e.g. there are no reservation keys).
>
> That causes an underflow and a failure in libiscsi PrinReadKeys.Simple
> that expects Data In Buffer size equal to ADDITIONAL LENGTH + 8.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
