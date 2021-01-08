Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 496F1C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 03:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C6DD236F9
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 03:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbhAHDs6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 22:48:58 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57364 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbhAHDs5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 22:48:57 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1083T1n6009584;
        Fri, 8 Jan 2021 03:48:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=OIeuYWU6Xf8gjVWn/SrC9+EJ53PTIp3iI/3ebwYLeRw=;
 b=ZFEuWZWg5EYi2B2nKcMk5xf/UNicgNRBl/n4T5OtS5qiRoXYhAdOVFLYhwV9yTUmh/4x
 DJBj8DQnhujlQHPunZVudVFpOaNprY8Rz2uXUYiNvDaJniCxWDPQOoheLLUaTc3DEhl7
 j6If95nhS0IAJ4xO6Rmy/PlC8cDvRgwH5sNBrlg7DUrulX0O5kZPYiP2rKfs6R/UgmS0
 wG/IDUh8XcxZ1ehk296eexsT9O8OXc39QjVinKDYCosgt8edaT6C2aEji4mBa6hbrG8Y
 Cz5ZAeVjBfPGsrMz/6bkQwNXxnPET2ljKny4hLT+13CUTnuAoZ6vRgfF0YdjRfQu8fgf xQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35wepmfbj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 03:48:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1083UUjn146276;
        Fri, 8 Jan 2021 03:46:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by userp3020.oracle.com with ESMTP id 35w3qurnx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 03:46:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fdZvYAOZYjMmnRAczFZFlIefSpi88sEHhbBd+qYgnijezhmJUO3F6ZtXIaAXe/H5RliDC5UFSDmapDD4PDIw8wP1LzrwgXowayxLbQ5Yr3P0nmy+Arz86SaSDfXShcS6MtwhgPIXKh5w5BG5DIpQRUGvQ5b46SStkXif0E4QjAGDKjxYCfwX9vQ52omYEP+tbEpqeZiK8VJQKoqx+V6QbAo5AtC1RQ0inDs1YdilYpXK0oc833QKe6KjyxdU36eWDV7sTBMNxbpbRjy0DXoq7GsfruvjVulAZaPeT7S1pIUiTGJVr8QUrxqcLN5Ie3WDUVJktOw+Y+E8Px9YVRfg7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIeuYWU6Xf8gjVWn/SrC9+EJ53PTIp3iI/3ebwYLeRw=;
 b=Q5yEBcCPuAoP55dt0rZvBJJxY4xTZ280e5FWrJ/6goIUY4NXkcMXEV0sG+Y+5JTXdMHZWxhMQZqw3tCsNwH0Wcemc9O0cnQx8+GYbret75FC7StIqsIPxIXTur3sg7y7bojxvnIAOTV3XVokdsj/thtWN3TlFxWOPZKa9eooX/kacDziyx6w9gOnkzkkdNXot69/MvePO9T61HQBwk8BEcZNN4PJHXmdVb/YEG7hIsfc961yRmH5SnZ1aDGlXtnUQY54KuDlHDAEa4GP+Ynh9laHASf3Z8OgfbQ4L/TNx+uc6AHFZ59GrEjZPvzeoLJvE5DMpAY0kzqaEvqAdkr+jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIeuYWU6Xf8gjVWn/SrC9+EJ53PTIp3iI/3ebwYLeRw=;
 b=UjdEyGRp+dU2/xcJg3ZGwkXn7y6yUlwktrJgTswROrloqw7XDkljpdgeUwvcnBz/s5aRucbdw4qVNobOA8fuA72vqlNCsooX0pkoOhUN8UN1kilYqJbQeZvb5m+qOTxGEEedp2gJ/qzgoRcqMrrtklDjEHMp7toDadFynHfZoj8=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4437.namprd10.prod.outlook.com (2603:10b6:510:3a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 8 Jan
 2021 03:46:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3742.006; Fri, 8 Jan 2021
 03:46:03 +0000
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH V4] scsi: ufs-debugfs: Add error counters
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2h4ay6r.fsf@ca-mkp.ca.oracle.com>
References: <20210107072538.21782-1-adrian.hunter@intel.com>
Date:   Thu, 07 Jan 2021 22:46:00 -0500
In-Reply-To: <20210107072538.21782-1-adrian.hunter@intel.com> (Adrian Hunter's
        message of "Thu, 7 Jan 2021 09:25:38 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY5PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY5PR04CA0018.namprd04.prod.outlook.com (2603:10b6:a03:1d0::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Fri, 8 Jan 2021 03:46:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a094f1a-d7d5-4c7e-8fb3-08d8b387ebce
X-MS-TrafficTypeDiagnostic: PH0PR10MB4437:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4437733C616B1A96CA3302188EAE0@PH0PR10MB4437.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Cdu3D6HP+GpBwgRgn14332tZoWif1jBDRRuZCmnqWB+ppvZ6P755T5VBafQhmCkxK/DT2bZr/16U8OZlPOYFqynBTYyEnxlsDa1OtUFYtP7NiRGJbtLdelI045elTC/2I1yW1VvvmOI3n8kWFADveJMOPImE1wIVk2A7PwLA0kA21lqkjRhfGVeOXprtW+hpJifU5++CulWcXC92V1+bNYzOejG8v6khbsyB650+Cku+kdV18oZl04nD7R4ItQMvKDarNNJTtFuCZX0rtRVZuHfTyuNiOjxHXWFT5uksZBXHiYrnYOvmgNBXG8E1Y4RyW+xt9orepYa9WEXYAY5/+J3+jvAzSnnQpe0ddOqUvAA8cZHsSc8kWi1M+mjyzZ2OaOMHUEphEXbzajZzuA4fA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(39850400004)(396003)(346002)(4326008)(5660300002)(8936002)(66556008)(8676002)(66476007)(6916009)(66946007)(36916002)(54906003)(86362001)(16526019)(478600001)(186003)(4744005)(316002)(83380400001)(2906002)(956004)(52116002)(7696005)(26005)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HjyioYnNoOE7lpwcRifOggNPzag+SVIG06HA+ie3g6kNH9egQerCjRfip31e?=
 =?us-ascii?Q?jHIy1uoN9imxWt/ozn3yMmJrJ5IBx8rkRmLHKesPqE51bXKDbEQnz2yfzijp?=
 =?us-ascii?Q?8UC+BqNxGBzFqrOrvPcW5kQczBnzNFrBhF4LOAPlvj51It2rQ2Bzb081Ayq2?=
 =?us-ascii?Q?I8P8o1y+j8sBmVJd1cVc2djWFn74GsUH9U9FTzhCFdnn20NyHxSwiiqmR6CP?=
 =?us-ascii?Q?MN1vV9NR23uIKF5MhOJJ7DZUdDh9U/NwPcWMPxW8gz7Gmw5Sp3iEP/Kwidft?=
 =?us-ascii?Q?07sG9AKDEGk2tAfHgKnTL4trnIUXHy3wf1kKZDNowf54QJ5SE0keqQIVIVQv?=
 =?us-ascii?Q?bR1rx93RZVj4LAq8wsH98DvE4jHXqnA920bHezmXwQdh4J8Pp7g5wgtDu0+y?=
 =?us-ascii?Q?qgvl2km4Dr/lJj29W690oEgi3a6mysThZfd68vMX0CmuZ+bX/68NNBT0EdsJ?=
 =?us-ascii?Q?B1CFOxYOr7TRLGJvP21y9BSop1FgWcOlQ0dUPuTuCKqFDKQu1CW8FEDhxLBT?=
 =?us-ascii?Q?HraJiYpp9U1Hwc4D/D+X2wLHv5Q/pUQ0TsQrvp+DwbC9l2OcTMO9akuyfxm4?=
 =?us-ascii?Q?QjorKCV4i96c2x0Jm6Y84kSR8tniAJ8mXTk/z/snlgmrgW6klsy0bE+NAAqo?=
 =?us-ascii?Q?oZEsY98kaSX+TWq5ACMBKjGLf1uDX3cOZuDey5Ldu3iVZECa60GmT8yG3gN/?=
 =?us-ascii?Q?sJfnImz/rH7HsnqGIg65SHxgmw5SJQ7FW164cYAp66eINrqAorpZUdJM3D7W?=
 =?us-ascii?Q?28g3NKDIgqi9QJ3R39seMGloU8m1t4Ch3wlZJCz6448VBuz/YTFgykrqn1K1?=
 =?us-ascii?Q?5V4baaRrWtbDcDFhGqs32gnehkU4/OlshMPWgKCYP+YArrVxd7/gPg7m7Di8?=
 =?us-ascii?Q?Bg+/+IT9iZ6PQx44twnFtEE1ZJwAHQ3c9WYXq13a6z4S9iq+KWfZtZBJu1G9?=
 =?us-ascii?Q?fakaT7782U94FnL8FeT7y7y4M9OXCpk6zRjfszGqGCY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2021 03:46:03.0387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a094f1a-d7d5-4c7e-8fb3-08d8b387ebce
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JA0w3RCu1aAbxpXt1jsGYOIvLIRsCqd/xvZK5lQfSt7AUeJzvzo2X/mRzphHgGBALaX6ML9VcTqI7n0aicVgrblqVjrpd6x7wkqsYCgB6dc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4437
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Adrian,

> People testing have a need to know how many errors might be occurring
> over time. Add error counters and expose them via debugfs.
>
> A module initcall is used to create a debugfs root directory for
> ufshcd-related items. In the case that modules are built-in, then
> initialization is done in link order, so move ufshcd-core to the top
> of the Makefile.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
