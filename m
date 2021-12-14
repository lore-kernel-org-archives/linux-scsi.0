Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94DA6C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 07:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhLNHFw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Dec 2021 02:05:52 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:10900 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231287AbhLNHFs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Dec 2021 02:05:48 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE2iC0O005519;
        Tue, 14 Dec 2021 07:05:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=wDh1wU1tCLa7ppl1eVOVJsP1NVNRtI0LbnR4WcR7gHY=;
 b=1DHItee3hwYqzCuEWJW45Ed5fA2fOuJRQx+THCZDSumyX/Lo6IlKxIW8ssOCFHL5pD6f
 uw9+GUWfrpHQzC5EGI2M5ANAte/jDjO7IvX2RQSf76i+nCzwP8AVEEo7YjpdV+pZ/Y8y
 UKEqeAeY5ll14ARHjs01rMEwSapO9nfkZiZNOSqZgxCrQ4ltVcedBJqNcy4K0BtDV0fl
 CqWALXTFnI2dXSVEQYDgpRf7/MdplpkACGxQIEn8tBEyAHjfgwp25endZoMSmASJYyaL
 yr0Fq4RWyL5bP7kEKqd/xPTjm/DzQPOGwsPzJf2+iyLzWSoGaBADRndbjRgb70lCqg5K Yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx56u2k75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 07:05:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE75Z3p068846;
        Tue, 14 Dec 2021 07:05:42 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2040.outbound.protection.outlook.com [104.47.73.40])
        by userp3030.oracle.com with ESMTP id 3cvh3wtywn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 07:05:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UEMcqgNx7csOyBkbJCYIr1+R9rOjHPe3qEOtbyUKL51eNBltpoVFsFAT+li6F09aJKy+YB3+yg+z+d1KljGsvx8UVfG39zouhIbV47V5rQm17mD6CWHyeppTvLLI6Ay8k3u2zSWFrGf9PDU1b/5M46/Y7UI3dRilkWnam9cbdqv+RWi+8o/eJ+nTpmZEo04lMSpTXbtwap+t8TIkg5vf9wI1E7/2+A6b8/6Bmba2X2MyAyYd2iR9VQ0RfB2Dk90dHJFKjDX8cQvMfJTEc0yoCg4oTw+n7a48/UtnzZL2B4m6kO+OUOz1vIxM8CWVCCwP+S7NJGnQjS5drRKMVED/Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDh1wU1tCLa7ppl1eVOVJsP1NVNRtI0LbnR4WcR7gHY=;
 b=KueInOtoeL0rYAZzEO+sutJLJmuNDKXBlg5gosaK2FsaVyeFdJLBaxnpLd06zGtskLo2Swg4jTUAdJDtw0aTWyvjfv6oyOJ7VEBb7TGwEA4N2sCHS13ewdrhxhY7hzsMDNM7GHNtoXtaUTvYoWDx+rB6Ofh8PqT3xRui5bnvMmxvq7J5Buz7wV+9oJ4lZEutaK/tbvdSCYDeHu4XOHgDVNKbyi4gGUZrihPS+/xpJJ2+VmcV9O0pNTHnnf6za2zUyW9G/i37tBlfZ2SCX0C9opJdTw4B3uF6VF0pbzh4D3jMOhospapp+kyMiqbnt1jvImnRtwXu1dqK9ijQcTrKug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDh1wU1tCLa7ppl1eVOVJsP1NVNRtI0LbnR4WcR7gHY=;
 b=KPc7HopoPKyio9inITRkvepMd857TcsEkKAVjjkGT2yhEyjjB0FZqJd0U9pL5AlJjtCKsPcAH0NbzvvSe6Doqjn5hj/zxPd8SVvYx8fG5UcwN9bZyeOuXlgmYPNRgkmVkOqgVY/Ceuecn+ITvi6iQkRwhZ608+zM6KJ7RV3J00Q=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW4PR10MB5680.namprd10.prod.outlook.com
 (2603:10b6:303:18e::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 07:05:40 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4755.028; Tue, 14 Dec 2021
 07:05:40 +0000
Date:   Tue, 14 Dec 2021 10:05:27 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: lpfc: Terminate string in
 lpfc_debugfs_nvmeio_trc_write()
Message-ID: <20211214070527.GA27934@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0050.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::19) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZR0P278CA0050.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 14 Dec 2021 07:05:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1a073b0-0f69-4cad-f0ed-08d9bed022f3
X-MS-TrafficTypeDiagnostic: MW4PR10MB5680:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB5680626AA1C424DEDBC2FF5C8E759@MW4PR10MB5680.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V8sDIITVWuzJ+UEKWxrh5oGDWq1VBpWg8D9hXBPOj1sfkUz3cxrY3rbESdFmlEiYdRxP/f0VIbJHhlSbKF+BmFWWFSJaPBzHDJbtosMQeBTOl0guKtekz/0ZGNCReBJgvEhidjcdWpPKNqMGNAmxhtgtQkJbT8RB0IHWvfkeZG7BlvUi9XnWFVNwEkqO9yBFgKe4AbwMx4HOFUEakcUwfDR1c7XpgtfqsuFGSSdAgjZwp0+mB8Mbxx65gQiqbL8XBvZp19NHSVQ4Qg+7uv1Lmh5nhR9PQ/XUUDH2mRABqEer8CaoYEHiYXZvebY4qDC0JD1L/vzj7w5AH6fPYj1rNeCaLK4TOH6yjrcxrlNGcP7zMwSOTzxBcn+WATuowqK23DhPj5o/28GzHk35o++EgKV6MQrF5zVqedvjQeE4jwD/wlq2mYRQencgVwpYcoVcODizct90Lg7X0zP40KnYM9QwzJS35uL+Nv4Ko7cRTBXyUpoZAsFJU2dbLrXY4ltYHnMhaM+lUCYQgMW9XFgv30VbtJm27ZGydZ7O88qmw+UXM9cGFAvILBCl+ZFom4Bgee2II1i3h4trp62Mf0bh9xbyiNzDy8BXL0lPsQgaw+KsBXOY+XLKlYG0DsmR+J7aYCeWAoy2ggvFKR3RxPiY0Fivcx6/V4keFqVW3S6Mwi+0iH4Kcw+L2cDA43ftL9WtBz3HOtv+DkAfvKM8B96fIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33716001)(66476007)(2906002)(1076003)(38100700002)(44832011)(66556008)(66946007)(83380400001)(9576002)(508600001)(316002)(54906003)(38350700002)(4326008)(86362001)(5660300002)(52116002)(186003)(26005)(4744005)(6666004)(110136005)(33656002)(956004)(9686003)(55016003)(6496006)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QGqc9GPgEXNOnvUGBVQlRyx7BSOwDp0njk3jJh7JTop4xEKvoMAhOXfWdIak?=
 =?us-ascii?Q?nvq7NxUwlnyyyi7rBp2ulu5eYeBrNshnZCwsVcittuSBrjOagrYj/Z3eg6B2?=
 =?us-ascii?Q?ZGWUdKSrrb16ByMGAV3PwG1NRYtFbQvTqGbwOv/9K8/3d2fSxBb/pWmSTKNN?=
 =?us-ascii?Q?YH6UhVG5l+DdZwn6K2XyYFXMttdTKGlGFLVv1HzdrEKcpUJRSury2w/hNHLT?=
 =?us-ascii?Q?90wVh4/1S5T+uEgUsaVKWYmte+u4K5ZoLq27HYbgD+NdSkf97TpYT51mzhF6?=
 =?us-ascii?Q?o/OpomN5GgTZvr4WpLhWIgf0qtt9vJ11GIRmhd/BerV6zxzUo6vryc1XgYQj?=
 =?us-ascii?Q?b8p+OuTBtW9xje68iZaLEdYEzFrYM6a3NHEHoqWfxXnPBwSZVXJqrtrZKjUB?=
 =?us-ascii?Q?c0HDf1dlm6Ad+Uxh9ZAkgI6dvyZbCAoWmMT9ussE9o4vTvFJPHkbSNggM6Dg?=
 =?us-ascii?Q?s54RlsDw77l1tgQ6ZrliVI11cWsuFECwMcSjzOgHqUDq2v2998enNqLTpXRS?=
 =?us-ascii?Q?z8IGnkLMonlLoH37XyqetXiJtEuGhngazArAUbnYxEcKKF3kBuFB83K66UVr?=
 =?us-ascii?Q?S/fB+Zvea6Klwp3RsZ7DbtK6T3eLXF/USZ39OzD/4HmSyVtc4m0fTIqXxoZp?=
 =?us-ascii?Q?/2rIzeSG0PzIfZaNDrFUiAwXgXPRZ77PXVpp3EadnlhoLnjaoCGEs/JmND0s?=
 =?us-ascii?Q?0hUtCD6tRzpFEw0lF1YkfDOtw9oc9Yg0j/6dQhEXFF6dExShDWatx4Ct7Itz?=
 =?us-ascii?Q?5H1W9BxKHFQRH4dOW4X2idPDIiT/WzaVvtJGO4WicCvc69yD3J0T8cRFY3/h?=
 =?us-ascii?Q?EgZFPULQtIQENwisX7qKa0cY1BjlFFJGb/Nl1HZoc8f7SGeSOTetpa3VqLhG?=
 =?us-ascii?Q?g5IrPb6izq6LHsErFf+ZiALg4SjrA/fhNJpI9dBbBm6W9HWcrm4XsvrJn1xR?=
 =?us-ascii?Q?fHocx9XoHeBRB8HVmHWiJAJ82cFYT1hEGcdw8VtTQtZ0hRUdcJYrhOzRX3XL?=
 =?us-ascii?Q?CIgQW/gnzCfdxJPR3K5a3FICbJvNWRvC+MAun63k1CHoEauKSZgkENi5saaQ?=
 =?us-ascii?Q?p79EKQIbMGjnN3KDEPgoK81GVWd65FdZK7EJkF11lhLxk6K39DvRoP54+eP0?=
 =?us-ascii?Q?eWr29/mG1FS6pp3o4IZNOR1mnks1WQj0toVtlJJtcFMuSXEmDMjufNk0D99Y?=
 =?us-ascii?Q?RJElra0uBhwAqziEz7pgsc4oY0XAtOLOP0V4f8KRnXZTAXJHWVrJ9KlYlS6Q?=
 =?us-ascii?Q?XZhcZq/gXkKkOcmDjoc6+Spyfe75VPuG04od8fGecwUAjRYN+lQYxH3GNxrY?=
 =?us-ascii?Q?wlb0MShHF65ffKluJ19eTYBPGPVuhCZG8hVGY0IVYebsLcBEmRpyOnEfVdFP?=
 =?us-ascii?Q?V0Nbp/UKJ0bquH3CtM/1t47B+pyszHK7b3gqZQPJL+uYuMYrs5KR8tyuFRX1?=
 =?us-ascii?Q?QyBTyINXWFZAgBkggcFhb0y+6uz9ww+eo5Imv+TXwEUmRnKIF6ciFOjmBCz/?=
 =?us-ascii?Q?9Fjizrx9JbG69/MXxFHKdbQ3F9ZOeqRYS2rfj1Q8ELk3/CApYBlYiJLOSyqH?=
 =?us-ascii?Q?vUBAKEh2fUdCeRY8Cm7W2s+fAofOHB0/ozG67TaqZYjoOBgBuLLregKtKnCg?=
 =?us-ascii?Q?deTBmlLBv7S5pIj7oAlM4KoeyG+mgLRstFb28IfhQvc7Snw6C8dorA6Gjbi2?=
 =?us-ascii?Q?sJtem88AWor+s6lazvRfrZcdwEI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1a073b0-0f69-4cad-f0ed-08d9bed022f3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 07:05:40.1561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U50kdnnfNfeRucJPln2uv1FKKGMuxgCLBMfR/MctoJVDZHhMjNimHjpVafdUbs2gmqnGHiiHtywmJuqRRfhdiuNlB+hi7zJmd5kQPXlkX9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5680
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140040
X-Proofpoint-ORIG-GUID: HT5TaVu2BCJgOcyvHrtuZU0YTnigM8OU
X-Proofpoint-GUID: HT5TaVu2BCJgOcyvHrtuZU0YTnigM8OU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The "mybuf" string comes from the user, so we need to ensure that it is
NUL terminated.

Fixes: bd2cdd5e400f ("scsi: lpfc: NVME Initiator: Add debugfs support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 21152c9a96ef..30fac2f6fb06 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -2954,8 +2954,8 @@ lpfc_debugfs_nvmeio_trc_write(struct file *file, const char __user *buf,
 	char mybuf[64];
 	char *pbuf;
 
-	if (nbytes > 64)
-		nbytes = 64;
+	if (nbytes > 63)
+		nbytes = 63;
 
 	memset(mybuf, 0, sizeof(mybuf));
 
-- 
2.20.1

