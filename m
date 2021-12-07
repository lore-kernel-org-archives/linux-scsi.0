Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF82C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 03:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbhLGDXZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 22:23:25 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:42154 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233757AbhLGDXY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 22:23:24 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5CTh004499;
        Tue, 7 Dec 2021 03:19:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=79MhZhD0AVzchWXoIVIrwRg+k/NKvhMmuIKsTCVx2os=;
 b=v8e0KEDKuwg4xKQibbZ06F9wWWBlClO+Lx91oQv2Ws5JYT2ArBKZ6PWAtlUyR81zhsbl
 f5oXQF7e3BSGkQKhSuEVRciIAHkJq/pkjk87un3Af9enlAcKt++Rv/PbKbSABswpsxDU
 u+BSOhcXul9Deg0AW3Kownu+16SACITccDwYeK7huqBVVjqXOiXDCEfkgqIQP/kviszy
 rncfe5+P9yK0CPbCgIXSBXUYfEOwdOh+FXGTFCbuZN8ixUxhg/dMNAphAHsqghv5GFNa
 BoGHbLweOMryYEdnkCBgzzWtn0O19FDxtopXARaW5Ko/0t3/h4WtkPwwxnOdCA5m5w1N Uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csdfjby4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 03:19:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B73BAnW096357;
        Tue, 7 Dec 2021 03:19:50 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3030.oracle.com with ESMTP id 3cqwewyvwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 03:19:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6hckvHRPoq+JtlkAFPCEVTeYDNHV//5K3KxbeCxXUA70/ZEgenqBHzRQkGJhmeqqXdTw+q9WbyQs8iKPHDcGSCMoAUHKTs4Nx9rWp/EkInBKh1dAyprjIlgwnFu0o1Z09GTjNHrqyx3sImTFbPGDYnJnc8hTgqceja5Wqk4TtljdYLIRWmvcjM2eWFO4LWZ+Vnp0dPyqL2SkPo1Sc0GhBEMfD5oI08Qbjjl5fUlRVhgy3IT9MXfXuWHW35GMGjL6SD7s93fHJdij4r2U2AMdx5lukgwupxPtTv5LbS0fYjLwm/a3eySxSUxmhsTrwVQuJCX4zQqKd/cKwY8UhgvtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79MhZhD0AVzchWXoIVIrwRg+k/NKvhMmuIKsTCVx2os=;
 b=DQ2d54z3pHZWTvscVdh15aKrX5TW21qL3SXZdsxlS0hb6cYinrvf92/j6KpmQxT5NLQMD8SHMaS6XPF/qpW+UZVD9nWveEUNBrDqKJm6y39mom6MpEDl88hA+eUOizAC3cg89dU7ZOaOfCFddmdK49FGQAylezZn7SfKOXtXwBI7abDTG0N2nxhKXsvVCyvux/CUpIQBgEn/QJNQHifYzLyTj9EaoqOYCVzYvWU2d3ZvLGBwzC8W39ecQyVBJ8MRSvtg1wF4dV/5DWORV0V7RsH6j/E6RsbjNaLVRh+dHV5ZGt21t2XlEAtvWfUlALLvs1F3BioKSpUjS5/9L5AdKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79MhZhD0AVzchWXoIVIrwRg+k/NKvhMmuIKsTCVx2os=;
 b=NAqXdB3Nt4zTThu6X8Bnc4ncJs6SkvHeeJibpuF73Vbbq+cOrnttDnJ8rOofTYA3u5UVLn2XVYlIr7b7TlwH8wwdcCQEcS7L1M/wEGQmz9ifPRo1AS36Ff0hV/WJHjW9LyoOvFCMibufqehhrk0/Qo3cjZjUi7JX/KHyIRWrXHQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Tue, 7 Dec
 2021 03:19:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e%6]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 03:19:47 +0000
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-scsi@vger.kernel.org,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] scsi/be2iscsi: Remove non existing maintainer.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r2pumns.fsf@ca-mkp.ca.oracle.com>
References: <20211202201141.cytqe73ish6oa356@linutronix.de>
Date:   Mon, 06 Dec 2021 22:19:45 -0500
In-Reply-To: <20211202201141.cytqe73ish6oa356@linutronix.de> (Sebastian
        Andrzej Siewior's message of "Thu, 2 Dec 2021 21:11:41 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:805:de::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.2) by SN6PR05CA0019.namprd05.prod.outlook.com (2603:10b6:805:de::32) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 7 Dec 2021 03:19:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 143a1929-70cc-4d13-c0b3-08d9b9306c4e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4774:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4774416FDF50FF32D63B56E48E6E9@PH0PR10MB4774.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qNw1mvfBkUybRrPC9yZ2nlAigtWLQZM4w7GZv9LdEuDeiCcLqXE/vPtWCkj+HtmQ9ieAgWG94LKrW3N7eCXT9+/BLl3S3++yPYxjR9Ss09kp/00XZuMvebluBlsDe/rmwmxAeSX8aJQQI5nBfoVi3bBjcFChKMPd5dn0R9MhzjI0PjN2SDm5TCqzkRFUYUaC3NIIhiiQ4sXF3AcmFT/KactIhZGzWWtIDzQTF/wyXHaf1rQKJzYS/l8H5MiLRnKYY285WxDWTtC5sO20rLAAeRtNfXdshZqgDdZK3VQ9rJHUu4PQsmQakxaLipcOnEoHlKvZ9Kyztxzj42x4aLDCr8eswXTSN7JlDPd4WCagQf20MLRr3/OuqPmKzaPlh2R/Zue5vm7R7sK2VLsqLsk3Eipl2zgLQXKBZKZFQVkGGFMuoSQilVZNrEZEM8poKjlWwtkteXvtveyruuF/XK+tgVzKQDGIaFdxL6kdnVDOMZvcYDiBmdy1d3ojRLeVJPURo80offu9pKK4M29cngJt/+SAGq8qzlNCf6awk2HORBemWvI/nH/DQ9gLuHPXXq7qa8izPwvg20+e9UZBC09dxin1H/GTedPnyV82SUj2IJb3I6AhKHJB6cxEJEfCpmmqY2rdztiU4WvGVVpd6BUVkMVAhzEN95/mYchOhXJwWT7DHAwffeewztXNBwFYIUA6t5I9OcYzXcHijj/aAWMV8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(558084003)(86362001)(55016003)(316002)(52116002)(54906003)(2906002)(8936002)(4326008)(36916002)(8676002)(7696005)(5660300002)(66476007)(6916009)(26005)(66946007)(66556008)(508600001)(186003)(956004)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IITDh+WxZYZPBUGMWwmJA/L6cYmddBhducRdnmEmFscOExoAIqTGVQG/j7Yd?=
 =?us-ascii?Q?ZmSYaazBshhwxgbNrb5Byyj94tZGG6wHF7Ui6okqqRLc/7xUnOP/OAPXn/+a?=
 =?us-ascii?Q?rCkRPsgUYhBADImyJzEOUZDwHvYJB1JIpgKhL0oMoQmbYpe8o2DevYcwpqMH?=
 =?us-ascii?Q?tKCI97UpZCie6+b5P12hp+L14lUcnjISSasinkgBdKxfSfPn2ysOxbRvs19e?=
 =?us-ascii?Q?X8Qxjti+caFJILyPMwoWlDOquMYT0HSdRnQCDTQiOZ58K655bVZPBiPItlrj?=
 =?us-ascii?Q?cUAaT9wryNGjJPnfYNIr1JS/gE2sZVxaYzwPOlJjo/Q1ogdBWJuHUbxgvxrh?=
 =?us-ascii?Q?qzRAR7rcemOwlHWrIKzcgnMJ+UFMGvEtF9vHRMNUHJZyhacmKWruAKdR/lZA?=
 =?us-ascii?Q?tM1Aqdzs0RgwXBTk+i+LTfnEFCwIQBARyJUiEjTkkRdBrvJMYDXfKy91XibW?=
 =?us-ascii?Q?k8ybtSdwzTSjI0pxH78vJjJ8KJ4koUft4a5VZhBNGdv0KP4BHN37zUkEXZJk?=
 =?us-ascii?Q?q/paj1teuSAj0cz8iG/UcyxLwOWlo1xZG1FyRwcOZPKgPGjSv34USJAmAggk?=
 =?us-ascii?Q?5W4R5UX4Mc0XedN+r6U3m0kl6tNmdLqTnoIghSQeW0HIOH0l/vwQ2qrCgfjy?=
 =?us-ascii?Q?KzMZBcL7I6QjozYtI46WsszMHJuwkbKw1tghgEeC4XL+zrN9/n6rhwHHC9bW?=
 =?us-ascii?Q?pPP4MBgHriR/CnsYDKUEBKJEr5JiJcu7h7tTboGchqNxqFfOx9J0nZXs201S?=
 =?us-ascii?Q?1xPvnX4hpRQTu/DAP3d2Lg3PLauY8WWK9s7Y/TP8ZpuQEaGxhACqYQgXvEsM?=
 =?us-ascii?Q?ltRPbsaih73XJapmihoXolMd+ESkFDBb9n2wLYl5d/hz1Ywa5J5ReoCjRlrP?=
 =?us-ascii?Q?1Va+/3llIe7usITJGg9JJDKWHmEADnY3KHeMn0+1/qMgI7vQM/btYvEc3o4V?=
 =?us-ascii?Q?/gihwdEXfywTFbynVcFIaXUIY7XCoeKf4KutgnjDp/Njk+mfcrZuQ7qnskSw?=
 =?us-ascii?Q?/sAK0192UQ5fDgor10UO8iGe8ziE0UcK6LQS4KlZM4vrpfRwrdvaQ0gVNWFn?=
 =?us-ascii?Q?j2Xm4Ulo9xF1dcoqXR3DLT+Lzs6MRiptmSmjTv719/4d6yIgzn46Hxm2Yqux?=
 =?us-ascii?Q?qD86Iaee9Jz62OysqvCzcwMhFRKd+/sHHCpeBL+S7Gk44IwYQEcEjgwt/R7R?=
 =?us-ascii?Q?4jrC8fP0RL/nqdPqX3FpQwaoSMV2w1lgWeYJoECdNLRqji/xAy3R84igbBsP?=
 =?us-ascii?Q?sLGJtzCA/VKWVXmGGqfEWlv5aglddJbwF/LKFNqljiKdtWg0aNMoDhx+9bW8?=
 =?us-ascii?Q?niUOWWO3SuzByvA9Unqcc0I5MMLBAtKu4KKhiozflJmXHqhw5ummSlvKTOIn?=
 =?us-ascii?Q?+NeXT5gWN/pOExwhONmkwGuhY85lVmsAG0j00W5X4GxL9uA7VRg5/s2zfRpw?=
 =?us-ascii?Q?yiDON3u2iIEtTDDGg3CWlzG7hFiEi12fnl7CP0kht9j4/qxzFtJaC+lgEKna?=
 =?us-ascii?Q?szqd4YNRoNu2gSxX83AcRTSpM6UnbiAJsilYlRpp5Nmk0oGcLDw1bq4Fze/C?=
 =?us-ascii?Q?zfrxjbQdcSjjnfk62ewiZoukxzDr3EEOW2Iu/gPQhIhWm0OcJiZFwUWcjulk?=
 =?us-ascii?Q?YQk5ibFePI/f8CQ3LxUwiHo4sGifP4V8XZa8wsviu/qExg9+7kpFCczv10nM?=
 =?us-ascii?Q?BB5riw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 143a1929-70cc-4d13-c0b3-08d9b9306c4e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 03:19:47.7554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PbELeB/kEtISpoKBNXdUoujrZrAuiXwMLapu5HnVRgdmGxDQY8nnPXgFW8eEfd3jz+OhqT8HZ8t21zV3m2Mrnlfxa5e6lIMnqS5VCtfxeuM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxlogscore=817 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070019
X-Proofpoint-GUID: 38CZH0jRAd3-Adzi-i4TXHwjIIedJBmd
X-Proofpoint-ORIG-GUID: 38CZH0jRAd3-Adzi-i4TXHwjIIedJBmd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sebastian,

> The email address of
>    Subbu Seetharaman <subbu.seetharaman@broadcom.com>
>    Jitendra Bhivare <jitendra.bhivare@broadcom.com>
>
> is no longer working.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
