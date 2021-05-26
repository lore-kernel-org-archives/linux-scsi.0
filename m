Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A0B4C47082
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55CEC6143B
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbhEZEJz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:09:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40248 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbhEZEJd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 00:09:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q42R6g143569;
        Wed, 26 May 2021 04:07:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=2HqaYBlxcSjWCd4D2A9xlqaaAPRQ7Xu2uzHZyjQgfYY=;
 b=NzbTi22nHw5xslXR+sK/jVUX+y8rf6dvb1LYUwH3og2BHvS3+hWUBtyhuakGvHMsIWSK
 +MODISixfWV/c1iy5ogJ37aGOex2+vJuF1hwUvQsHmyC8+5oyFxGeC/GAdHrgDCslZCE
 dpwKD1+oBNvvUSqgLW29IrW+sq7mgm/EaS2D8Qyed+svZHHxUJnQZudjH+Ir4Y7FnheJ
 iHoTqbJHKmRoqBCe6YiRQk/7/RljU8QEEA9TWHaCj6KulIfDYcoPUMZcbKQG5tsDdWxU
 MDHcOwMYxEcl4YWkdv3mgrmgOIa/8HUzggqmmxCIKexTKLUBDWOQccJfYOopz99FNbSg mQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38ptkp7pyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q45I3p142537;
        Wed, 26 May 2021 04:07:50 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3030.oracle.com with ESMTP id 38pq2uvw7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlPK3XgPvDQwUTPxT+G+nnxBxAQdt+a7DK/2DrwFTANSj8rSBGqG3CUR7oHNGB9jgSDLgwmj0P0J7eXSHHdeJ/ADIUaISZcKv0nDcWB8RGKwq3xumkqrIPMPmiQVyHYl3x1cw6911TPeAuS1OtQTJdJUHyI+xXP3lCC5YAwypvy7FEe6WK+DsprpwH1dIWigrbhQ9KTguMEvWuhsrRoBWdWZKc9zd2+gG/AztrXG34syIzwanmnq9pkJc1FZkqLrvA4aPGwe5fQlLFOLR4Y/X8xEgt8cKPhMu1zKOOqB9h0dD5v+98WJZgAMynuv4wmzuQqSmaijC4P/LDmDweeXAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2HqaYBlxcSjWCd4D2A9xlqaaAPRQ7Xu2uzHZyjQgfYY=;
 b=DOU+Iqmn944LERSg2d+N9vKhmC/ZnI/+8w7HoNUB4Kp73oZkQ/4+Ck9BkwSRb2GeKnYrQngJH0+KoaHd6nEWj1ppX0wynD27k/if1PGeQQMNIUDUb0HNFAwIMgBgCEfTeN8Ckh3eqwDIFRXXJ5U8FDgn4ucyu5Kkvnp9jnIks0zTswaS14J9nPBUYp64p75Rwni5mWOvcre7R4Z+l+lfrWr8COPRr0fdOgOuo/VZSXP7SwaRtOSQDEuo5tG70HfX+V+HkLSAG0f4SzEfasKvVx0MCS9Jv4kHJufkw89NjSrWrXhUZ13NfCT6JrOv7wA8LeqFPGfxpcRj4UM09uilAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2HqaYBlxcSjWCd4D2A9xlqaaAPRQ7Xu2uzHZyjQgfYY=;
 b=b/BNN1t9lzLRS8ZGRLmbMvutcV1WkLMdC8vTUszbiIzJpUbXwLtYae2pd+KJyUd26eCXJRFVUWlRs2KXuoTDJ3Jq0Cd2WPRDYItGLPnGGyzmQR6ycerf+vt9IYX8YeX1Fwi81n581xJJuM9iKnhdHVYMmMRuVeUO5eWc+GLcWqo=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4469.namprd10.prod.outlook.com (2603:10b6:510:32::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 04:07:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:07:46 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, John Garry <john.garry@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        ming.lei@redhat.com
Subject: Re: [PATCH] scsi: core: Cap shost cmd_per_lun at can_queue
Date:   Wed, 26 May 2021 00:07:24 -0400
Message-Id: <162200196244.11962.7464376808951847410.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1621434662-173079-1-git-send-email-john.garry@huawei.com>
References: <1621434662-173079-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Wed, 26 May 2021 04:07:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d0a6085-ba97-47de-ec16-08d91ffbd1b0
X-MS-TrafficTypeDiagnostic: PH0PR10MB4469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44695B4041432378896462C08E249@PH0PR10MB4469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iFRlRe+xWTIit4Ogfz3QSeMLVk7XZiHUpMNTf2FGVXXFkOBaMUf08F+08U8WIU9GOnPk9qp95WmRMEmRfoP7DOPDlJr3HGM9okFBlP3BMvSRMEYhgXWH0Qgb7g18lxnWdfCNiWvxpCd7xrTIBlHdcicKj4ldHGfSZYQ2zK3BCstaIurI3Bin4DGTqi7SZMzyDit3QuxMPjPdLUHHdQKrQ2jC3zooWJojh+FHvkUlRtaF5bN+aRFJhm4axImBmCz53+DAxvcC20X2OaMRqHvUmVZtCMcm5rx11qbe7+dNX91fXB1izKdjNggPzxfJ3pyilrJwz6RnMkob2gr7mHbHmUcRNMoDgngd1yfzmzkR1pWX/aXDBjDcQNqdKPmh1zgOLfqBiQt4o0dUhhhJRG5XgE7pvZMZ30ciWVQyylljO6tFnI1LPvXPmGHn/+zjTWM4LfPvroHm0xTyGdvj9whj81hUK1WdWPv++CmKzIN5YPlp8O70R4s8OgXhMvHV1q8Xv1ufVUAuWYDls5i9g+mUTEzK5itAcMhbKLkI7Mxx1fyeZXDwAaWF63sPbQjOz/K0ZFsGEoMveojZJDr9j1WPuptDg97rDVDJCz6rWplMlp6wQuirAmBVFCM8ds8uGQ5I5UVQNk04BzzqniBygeEqx3K2l5fior53y/pEDx7hY7AusebtRQ0OOGthhd+IN3pkoUqamj/O0KiEEDQb0qouJ1csi7xHm/XVj1yCPQmMj8m5fy1ULjhc1I+QTJD4i3GYuOkMIsHyaJuFBBb9q+qECg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(316002)(16526019)(186003)(66946007)(4326008)(103116003)(26005)(2616005)(4744005)(8936002)(956004)(2906002)(66476007)(66556008)(7696005)(38350700002)(52116002)(38100700002)(5660300002)(8676002)(6486002)(86362001)(6666004)(83380400001)(478600001)(6916009)(966005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RmY3TGhjd2ZJUzNaK3NHcHRDM1V4TFljMDdGQm5ieVhJNWF5YmxmclA3QW1h?=
 =?utf-8?B?WUQ4a0c2Q05mK1Bna3pUdm5yNEZZV3BXVUJXbHNpemVKaWg3cTcvMHEvUlpX?=
 =?utf-8?B?YkhmR1c0NnlCUTRyaGZnbjVhRGJDN1VTeTBhSzFRV2FGcFUxalZSYzlDVUhL?=
 =?utf-8?B?Y2FHQVhsR3FjNEh4QlFsaDRXUWRHNGJsREpDQThQNWlwUG9Za29rZUh4SjBL?=
 =?utf-8?B?NmJDY2pEMnVKYXRwS2pMSWFORUNVZHYwS3VER2duMm44azlhMkcyQ3RUYmZh?=
 =?utf-8?B?QktNd3VrV050dEdHMUtKYW5xMnlXbHlzZW9ZeEhyZHZuOVRuK2prbDBYeGxp?=
 =?utf-8?B?YzdSd1VuM3FUNllFRGNWUzJwOWRlWnc2eVBwa1ZtWDhUcnRsdjMxYkZzYVFk?=
 =?utf-8?B?M0pDQjZGZGcwMStUeG5QZXdWUW5SYmZuZTFwUGZFMC8wa3ltREZqZUVtTDRM?=
 =?utf-8?B?VmJSbWZuU2Iyck8xM1dDY2o4dUJoM2daK2ppZncyc3NaVkFkRzVFSG9zUEx0?=
 =?utf-8?B?SFB6MGoremtLaXhDSnZQYVZkaGdxZ0ZlbUxLRElHYTQrWXFTcCtnbW9PN1VX?=
 =?utf-8?B?bnVkcVNIR3dhMDVIYXBTbklpVk93Tzl0bHFRWGlXMjRWYkwwNTdQUndmaUhS?=
 =?utf-8?B?Unl2R0pmTTc5VUtCT0RsY29nN0t5bzdDNTVWcHd2MGJwYUFWbWRZdnpQZEJz?=
 =?utf-8?B?VW0xSmpjVjRLQ2hpSlRGTkZQZW8wSkowMVB1b1RQYytVL0xUWFFuVDh1VEdN?=
 =?utf-8?B?RHlZdDYyYWQ4Z09kbTk0OVc5SjBEOVB1V0Z3Nlh6aUc1cmtHcmU1UEl6TjFx?=
 =?utf-8?B?YURDNXcrQ211eXp6TnR4VGVEWEg0OVVPY2Z6QU1VSzZkSjgyVXE1WUJYMzhr?=
 =?utf-8?B?R0JNMHViemhXR1diUktTbm9ibCt2dWNPVFgvVUR2TjJveE5Oa2ZJS0xzQWlP?=
 =?utf-8?B?My9rV0NyNmpubHFuaFlLbW1mOTE4cjhsdDdUOU5zS1FlWGR2eGlITkpGSGI3?=
 =?utf-8?B?b0RsalJuV0d1bDlMMnc4aGsvS0d6dS8zbDdVZFo2MEhod0k5NVFOU3dPRzZN?=
 =?utf-8?B?ZVlQZjVxb3JOOTZIU3cxN3ZBM3ZUNS82Nmc2NkM0SlltUFIrVHg0dGkwTzNQ?=
 =?utf-8?B?ZTBwekJjZTd5VzBqWStsbzhkZExTTXhkZU1SRllJTHIvWW1kSXR5UGtKRVJ3?=
 =?utf-8?B?cjRaa2FnL2dHV0RyZlo1bUlmNEswcDBaYWJUbkNUUEUzckVFclFhVTNaQ05P?=
 =?utf-8?B?aXpWUFhhV1ltcVZtbEY0eUFLK1BUMWFSbGJkRTdEcnoreXBZNVFIVk55MEgx?=
 =?utf-8?B?UTF3c0Q0dWpEZU9hZnJidmpxSHJ0MFhlbXBEOU56V1U2c0FTaVNoQ1RCKzhG?=
 =?utf-8?B?K25TTXJDZ1Vsa1RHUHhzaDFSMElTWjkwVTlJbVVNbGVFZnphb2dYd3hSRFU3?=
 =?utf-8?B?UlpEbytBMGhMTUZhU3MxMEZuOU9Id1FKSkdoditDL2pwMDFBUmg4cmNWRUhm?=
 =?utf-8?B?TktWRlB5dDZjK3ZYaXFnUVVYZzZrSnVpb1BXUDNjZUUwRlNEZWdSN3NQRHJV?=
 =?utf-8?B?c3B0b0l6NTRIdEw3SXo2dG42N2E0TVR5aHR5MHM4QjA1cm5KNU1JYUpIbDdQ?=
 =?utf-8?B?SGlJVXZSUFdsTDQ1QXJTbUlJMVBUdnNnVmVRbmk4T2Ntb3A2VFFCUnhFK2dN?=
 =?utf-8?B?ZHZyelN2TXRqVElEVk9VdXRiUC9BRHZxZi9KWXFramE0QzE0c3N1WjVWbFdP?=
 =?utf-8?Q?0y8LOr7IKUlYYxJGvs6NMuLx1qd/QKJ3h+pWvE6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d0a6085-ba97-47de-ec16-08d91ffbd1b0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:07:46.6683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jmahQ04IDof0jivhjNoIgM3jL+6+z7wwHlyY5oJIh3iB4wLxYAT7+jeceCCNrsmx/Ar9fMmjCghWc+97+8G12xr/JnKkEM5P0sP/Bcg7KSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260026
X-Proofpoint-GUID: wVLVCo89lHL9BesYJI2k0Y02jOghtzi4
X-Proofpoint-ORIG-GUID: wVLVCo89lHL9BesYJI2k0Y02jOghtzi4
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 19 May 2021 22:31:02 +0800, John Garry wrote:

> Function sdev_store_queue_depth() enforces that the sdev queue depth cannot
> exceed Shost.can_queue.
> 
> The sdev initial value comes from shost cmd_per_lun.
> 
> However, the LLDD may still set cmd_per_lun > can_queue, which leads to an
> initial sdev queue depth greater than can_queue.
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: core: Cap shost cmd_per_lun at can_queue
      https://git.kernel.org/mkp/scsi/c/ea2f0f77538c

-- 
Martin K. Petersen	Oracle Linux Engineering
