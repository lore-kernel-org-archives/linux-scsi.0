Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E75C11F68
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3A0D61D51
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhF2ENK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 00:13:10 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53154 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232000AbhF2ENE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 00:13:04 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T45acR010457;
        Tue, 29 Jun 2021 04:10:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=vTNzeHAdB8wjTYZQUjTvh/LYi5sQG2GHOZ+Cuw7DAvc=;
 b=ueuKNgvogmUkXBm/+6UKyORHW0mlWsiAKDWxhl/vw5wu4twNc8mmD87GEOVpgBIjuD15
 JA1D8MJ8+SDEVqFXbJ6d6DGajqtO93Ej7zW73do8tIuVLe5LUzkNvfc+j/Riw5B8vZZd
 o4nboQ/Uoj43u43soJGj64cy+gaHusXIaIUwT0XLrwvMGZfXSl/3z5NI3tr7rb7JquIE
 Cw9AQPfwQ5C1QDoR7lKS05+xnjbxEjivv9EW6FN5llfLuTTgnjd2OgajgsBg5rXwq2PF
 sBXl4e3h32dQQjhLbDmbpAtgKQscQODnHt/oUhyXqj2dn0vYI3oXn3YOpyAyqr2gSRgW Kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39fpu2gcv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15T49rjX052345;
        Tue, 29 Jun 2021 04:10:28 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3020.oracle.com with ESMTP id 39ee0tv4n0-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nSQLB/ISrilEDz+fgcz+K8pn3iqdEXvxqSQdx+v2AWA4LKpPW21eLykqSIp2ttMp6IzR2laaaLerRXQkPfNSZ70/3ckPyOsjF8KZfxELygG/SJB4GNKwEvkpKNevKeypv1K5O4nVaNe4AVDKi/skasFUndGLofqDd7uCwzRz8JsV2fQ7VDgQyArbNyZtRRj58c4K49rmpkXd/URZXBb8LGBKWNvkqE+68NOvkUrz5GAcA1emlAYTYgLoQOuo9uRi6dldw7aCDd/HzV+eP3IQTxLiAIWJduVA3/SaRRN4WXHRDVncCcuTSmSCJ3o+Dcfi/sH2ThQIsX1Y2AnwJpc8LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTNzeHAdB8wjTYZQUjTvh/LYi5sQG2GHOZ+Cuw7DAvc=;
 b=PizwUUMxRX7glt/djZTEuoKwin19rjFwkAor9ZdcacdpHDlYkRIkJE3hs0UfFGPGFm+R1HTnWNSqvw60hcw89mFI+gXUXL/TtorIoJtfqvql6ujTeNIlQKPPBmRfW0qgiRAuL23U2EbrZPLgef42WHoWGaSceFseDJt6SCleCfy342jtd7O+WXBw0ZMfHJiYPsj7cgyuSWjrXb/m9zxULOxIXIKkGuFbcaQDSGgFAXwKTlLdyW6SL/l8miFlwiHbgfHD2mEDEZm0SGzbzr1T6cFEX7PvKQjltpgXljioAdTULKBVjernJt7ON+IMSNDGkszDtm3/eM+zD7A9UY9SUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTNzeHAdB8wjTYZQUjTvh/LYi5sQG2GHOZ+Cuw7DAvc=;
 b=MSLt4DoeSDjE/xW8yi1JtolrA9pb6sBydAJscARYgbnGU7Xy8EMoDs1ruFf9D/cAGxjO1Jo3u61e+tezHSMAyYhKjGKMg+HtKqLJ2zE0skJVbR7d/wlL9hYASX3WDnOxkyzjVoOazl82iMRZGn03rFpwtmKvKnvQfzEKmvmVU60=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5417.namprd10.prod.outlook.com (2603:10b6:510:e4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Tue, 29 Jun
 2021 04:10:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 04:10:26 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     YueHaibing <yuehaibing@huawei.com>, jejb@linux.ibm.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 -next] scsi: ufs: fix build warning without CONFIG_PM
Date:   Tue, 29 Jun 2021 00:10:12 -0400
Message-Id: <162493961197.16549.18425442612444713958.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617031326.36908-1-yuehaibing@huawei.com>
References: <20210617031326.36908-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:806:6f::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR12CA0029.namprd12.prod.outlook.com (2603:10b6:806:6f::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Tue, 29 Jun 2021 04:10:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c81fcdd-10eb-40c4-2ba6-08d93ab3d311
X-MS-TrafficTypeDiagnostic: PH0PR10MB5417:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54175288E9B1E069D34DDD7E8E029@PH0PR10MB5417.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:119;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qReNKfLa6MagyC787mZUwbsByZ9zhalXhqcU6ZPmVlU7HfD8s37QqU3U7UhyHvK+/bjV4CH8m633+91R4csuJEKjHLP1KpSj/lpDlmo2PBnK5FYR82Fr+zTD8D3OaeIHOhqzdPnUUB9cOg5snMqKP4yjX+/klo5OlfFS62KDWkr9fnFy103y4ttFX5txXUuAeZqgJbA3W1JeqPn8MG7CA41l4fpyzRGvhOSj6yofD4Go4eBXx0I2Zy3YbdYPL27vTkQbt42s5HUYTZznMIqnHaraITj7s6yFWtPX05KmSaHWJHaUPTfVwTY9TSWmYzLK8VNH/lbPZdBRlmFRx3TdrQB7EgQ8rGqGlMu63iKkMxyPpTNlw3nZe4te6MW6CUGJnHAI6wBnFdo6489p7ZMQ1XN+mZCahmsWYkIr+43modIiOpXJLSIWSyLwCspHQ+HT9Pp6skUtIqaGPv6TE/vYXQLxAJElB7TMV142dEHZPad4ilXEc46p9jpHTQuHU7MFMvQjEosgwVAoYLd+mQJmYduZYWLA5BieBtkxbnG78nTCFtjbJBQwqjydEfeD8Q67dL5Sj0riIiY7Kvem7JEYPkt4WQY0jBcTOeeyqUmeKwAtOah9mxBH1MybS85aHWS0y4YK0JON6RhVZIgks0HbQ9DzQ86S0453OyNhkifP4GOuzeRyCdDuGtEIEJop5J6ftTgyjKpNMKiPZXi4rda3VSjFYauqyCdldziAY+sSCwzuCp8wMGzqif22X82fkEzLOf4iVXl5xAdpG3nAlGMjbUCe+D1TupNTe6Mk6V30jhUxOa+LWtSPwY5f9oAmcZknz3ABh4Z+xN7wEzBHFttwPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(346002)(396003)(966005)(103116003)(36756003)(478600001)(6486002)(83380400001)(7696005)(8936002)(52116002)(8676002)(4744005)(66476007)(66556008)(316002)(66946007)(26005)(186003)(86362001)(16526019)(6666004)(956004)(38100700002)(2906002)(2616005)(38350700002)(5660300002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjZWRW55bXZpYm43R2ZqOVJ5RkdrWUVRZnFqMnNIVTZoQnBtcnhVWGVHRlJR?=
 =?utf-8?B?dUFqMTM5NmIzZ2k2Wk1Ob1YxV3dsa0tZR09GaTd2VHZzcEdMcUVNQ2xNc3Jj?=
 =?utf-8?B?R0ZxOGZPZzNSdzM1Q1ZoemhzMENoV3NXQmJiTjNka3pUZFFVSS8rWThGYmxt?=
 =?utf-8?B?eFplbUgwYUkzZWt4SUE4b2xaaVJFOTE0MFNsaXlzZTNEdnFtOWNuczVDNlBH?=
 =?utf-8?B?TVJoaEk2dlV4RWtOMnhaQ24xRGJpbmhBQnpPVmRQZGs3Q3ptNnJSVjUraXlk?=
 =?utf-8?B?NjAzS3RDMkdCQ1QzaDBJVWtFcWVFbUk3MytBWjVLbDRVUnBxVHAyaHhPNkxS?=
 =?utf-8?B?by9aRUpIcTBXN0RxR1lqbmQveGV6TnExc0xlVTU4ZG9saHlmYlpUdnhSbUFF?=
 =?utf-8?B?STRKQmlrT1A2OFFhM09nN0Noam00NXh1YS9HbTZFRWVBYW9nZSt5YWU5amJj?=
 =?utf-8?B?OUFzSi9rM3gxdWxUSHJRSGhXR25vcVIzSHc2ZXppeVhBZ2dtRkM2T1N6UVN1?=
 =?utf-8?B?bDRmSmlaeENpMG5oWmh0eHN3Z2JuczVJbThmenRBYVFpamNKY1RKYlpQRHFZ?=
 =?utf-8?B?Ukp3TDNJZnVXZ2JBQUpoenpmZDl2ODJuckl2TlcwMW5ZV0lKbDRzZktpQW9t?=
 =?utf-8?B?ZERIbnZXaXdLVkZVMzZZaWJRb3d6SDVidUIwUm5WNTVCMkoya2JkdU1oZy9l?=
 =?utf-8?B?bmltRjdaM3M0cDlnYVJKVkd6MVphMnhHNDRqU3ptRWRXcitkYmM5QldDWjV6?=
 =?utf-8?B?MlBkRFBVV3N5dUFCZmpxR1dYSG9GenZqc0RxbnFWN3RkRUdJaDN3dGErSGwz?=
 =?utf-8?B?T3hBeGphdDJhYmk2RHk4QTdBVVVWYWxWZit0Zmp6dWxQaHJmdi8xempBV3hy?=
 =?utf-8?B?U2pJUHhZcHAzdnIxbmtucmhEdVNqQUNxQy9zRG5FNnhjM3dvOW1RcXpURUJP?=
 =?utf-8?B?clNxY09MUVVHMG56cmNqdjRZWW1iNkxoZVlWNXRPOUNsaWFJTktWOEJ2STdY?=
 =?utf-8?B?RzR6MmpPeXhsamZENVBJekVOT3REZWI3VUZralRHRGVOT2hNVVQ1UEYvQkJu?=
 =?utf-8?B?ckdMQkJCVUw0aUgrUzBEMUd2YjUyTVozbUhyUE1BQTgxVGhRR1Jvb2xyUmox?=
 =?utf-8?B?VWlNSlZIeEdwc0pNb1NyWU1OdFFGT0Q3Z1lIZUIzSUFJMnEyeWx2NlFNK1BO?=
 =?utf-8?B?SXNBT2FuRXJuSkxodkFzMWc2RzF0Rkp0RXhWN2pjWndLdEZjZkZ2K0lPMUl2?=
 =?utf-8?B?MDhPZEFlZklMWk5JdUx1UDd5aXNKQVEvakZYL3NPMHJDUnlwT3NCUUlvWXhw?=
 =?utf-8?B?OTdzR0pnZ3ZFS0RERWtuaHBnSDBtOVdsQm1ISG81a2U4YnZVNjBpMm5xMFFk?=
 =?utf-8?B?MFArOVh0S0pyc3MweUhESFllSW5CbnRURUxzdGRCZW93ZXhoaTJhdnhvTFdI?=
 =?utf-8?B?YjF4NGNvOVM1eXZLL21FaGVyTU9aYndRM0FPV01rais0eUR2NXQ5WGJpQ3Bh?=
 =?utf-8?B?TCt0MlIrbE9SZFVKYlJJSnhudmlPMC9xeG5aY2RFMlY3TXQ2STZ6QmVWTU5S?=
 =?utf-8?B?Z09wWUdGYVBTUzRjQmlZSkoxMWxFZUhsMlNkUzhjRndWYjJ1UTRZTytmWlQz?=
 =?utf-8?B?OVZqbEtEeWg2YmRNMmZNNkZ5Uzkxbjh5cDYzejNOM1lxd1JXWUtHMkF1UzJI?=
 =?utf-8?B?ZGNHU2ViNkdHbFFmM1pqc3BTSkVqR0NsNWlqbEtFdGwzMC80NDgyM3FwM2JX?=
 =?utf-8?Q?JTXeL0ew/BHFPMNe/VYR83BASi2EqEstAMxNXIK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c81fcdd-10eb-40c4-2ba6-08d93ab3d311
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 04:10:26.5953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m0hoBpsRJDNWlzehpUqeVksgWQ0VeSEKa6z4SF5micQiwUdtymwMOJTY9NsMcP+pKrNhVV/bouPe1GJZOqjmt/BxGcvjvPFwITeJLsufokg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5417
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10029 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106290029
X-Proofpoint-GUID: c0-w1pqVBk2b26geuibe8mMYZatkh5Hv
X-Proofpoint-ORIG-GUID: c0-w1pqVBk2b26geuibe8mMYZatkh5Hv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 17 Jun 2021 11:13:26 +0800, YueHaibing wrote:

> drivers/scsi/ufs/ufshcd.c:9770:12: warning: ‘ufshcd_rpmb_resume’ defined but not used [-Wunused-function]
>  static int ufshcd_rpmb_resume(struct device *dev)
>             ^~~~~~~~~~~~~~~~~~
> drivers/scsi/ufs/ufshcd.c:9037:12: warning: ‘ufshcd_wl_runtime_resume’ defined but not used [-Wunused-function]
>  static int ufshcd_wl_runtime_resume(struct device *dev)
>             ^~~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/ufs/ufshcd.c:9017:12: warning: ‘ufshcd_wl_runtime_suspend’ defined but not used [-Wunused-function]
>  static int ufshcd_wl_runtime_suspend(struct device *dev)
>             ^~~~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: ufs: fix build warning without CONFIG_PM
      https://git.kernel.org/mkp/scsi/c/75d645a61cf9

-- 
Martin K. Petersen	Oracle Linux Engineering
