Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5C48C2B9F4
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 01:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 766AB6128C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 01:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhFWBV0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 21:21:26 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:19980 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229751AbhFWBVZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Jun 2021 21:21:25 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N1GJoh023250;
        Wed, 23 Jun 2021 01:19:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=0d+mpbntG73kqVr+GSVzT7PZZLLn1AOCoi9/QJZ+TMg=;
 b=ozgOHwc84AGGI0KtuXCYbAir7x0aY6s46iAEQDvC0Sc5WSOJH4Wv9eNK67W59JmWSKjT
 E+JOIQ483Y/jspvSlLU4ZhaYyxsKND/lCkX9QYnljL+lBCKb65MLIT+p6wXfNQN3ju91
 npS058JKeENyqP0p3b0NfNbu+UjxS2OAGssamxjgvbLmwNxSQBA/mOXz9QsWEdnzEC9J
 yj3a59d6tzZKJvZjOnxDTfjS6yTCVmKAtpyPaBrHWh9hGKohEBv+PmCfHPyJlI3j6hZg
 vmCBJ0nsLm8/QUgtVY8ZdcVqJKjzEjeH5aBqLBRWnDKfky0Uebzyda/omVSqscA0/R8n 4w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39bf94sk12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 01:19:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15N1FF86074230;
        Wed, 23 Jun 2021 01:18:59 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by userp3030.oracle.com with ESMTP id 3995px9gg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 01:18:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKpyeS5rFemARwjfY+3FGaqtNoxni8yJ3K9NMV29TtIkQBuGG3fVB2WdTVSN2Y8uudAPlj2XPtQBgEgEPWcR48NcDski6mEvpOfdWq6e7B6GCbTmc3Dw2h9G3EnHDaBDDQk/2N8zcTpoxXojBwKa4dxfbEEAGfH7hi9276AjAYbl01GNetDLwRRGt9fG/Pztt+E+e8opbNDebDY24jponZEOfioWyPrkImP71HmFqnoNSVA7QVApE0YoewwrSgc3SNTDRURCV6lW6MZoOmgpUxVioHu5mz+BoIXv3uvlWaLO2zhBZWLdQ4ESnmRIRpN0/5xR5bvX+pv/sEvMlAoz7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0d+mpbntG73kqVr+GSVzT7PZZLLn1AOCoi9/QJZ+TMg=;
 b=BHE/oa5l3sQdyBhSveFP6YPGreZTNGyY5UoOHu55IsuOSMqn25bnPrYMMK9SHc/MeUlnufuIYpd2T0xAl7ka2J5cDBDVjCEi3YCwpE9D0+T+cfMnR71RfkBmt7co4Hx7Ja7h1lhOKh812K4bHakZ0flhU8IRd6DoNLg58jrWLx5zN3GQSDpz7cUEen1P+0OdRU0Rkjcsu5yoO6kycVDQ1e/X2HvJsqHl30LE4tmoLAm4r6Byvpq4TNa5/7qtvzD6M2K1dtkCxfButlKBPXbYQGxaeOR20yP8o5hDNFZjBkaph+FcK6+S/b0AsEDmlrvbqyzMKNufXXIHg87OhMgQxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0d+mpbntG73kqVr+GSVzT7PZZLLn1AOCoi9/QJZ+TMg=;
 b=ArR+CE4KozJfiwCnvtu2mN71yyToKA/uS/pH/x9/n9t1LaGvdI4DWqIBEolQeabob6II4D16NI3nmg3a3aq9iGrAxxh+eLgUc+RBWz1dYZ64BtHVfpjVMq6hExdRunMuLsurVKWcrGborPh4xD2Zy0gnqb/2OBr/8szlwuezStk=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5467.namprd10.prod.outlook.com (2603:10b6:510:d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Wed, 23 Jun
 2021 01:18:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.024; Wed, 23 Jun 2021
 01:18:57 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Ed Tsai <ed.tsai@mediatek.com>
Subject: Re: [PATCH] scsi: Inline scsi_mq_alloc_queue()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmwds7ih.fsf@ca-mkp.ca.oracle.com>
References: <20210622024654.12543-1-bvanassche@acm.org>
Date:   Tue, 22 Jun 2021 21:18:54 -0400
In-Reply-To: <20210622024654.12543-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Mon, 21 Jun 2021 19:46:54 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR05CA0122.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0122.namprd05.prod.outlook.com (2603:10b6:a03:33d::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.9 via Frontend Transport; Wed, 23 Jun 2021 01:18:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da83adc6-5177-410b-e8f8-08d935e4df80
X-MS-TrafficTypeDiagnostic: PH0PR10MB5467:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB546736ECEF1E848BED8ABF7F8E089@PH0PR10MB5467.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P9nlPv82yW4RjpAqau2hk4xTpszbtADOZQJTTkBEFbePEeTMnfPpc/9fEr7aUppy+s0WipNMXrBBd963vngRo1cErDkalyBCfX5nmcfY8j45hZ8flkMgBIECfdxmabaIVKQ8JB+lPLubwCjqfYyPJ+RPlLoEHg3VjnLo1yFWkxQioGuHXzJG9+QNA+2RK5+amqmfZky33WoWAk91OK1+jVZ1HfedqXwCKKDb5E0nWyvT99Kex77W7ppFFjwOrEx6Wd+wkN8sfEXecv0z2wR2CRDBXd2N/IMzwapOQX/3PBZJELCKg8+mVhBstF4m/myuNcW8J53J1hmAKkZKIOsYckT6yacv/MU5zd9Nj8s3c56u8fAaFsJ3ctyMMhgBPyOqRHc93tNCRoldzeHhJguuFlygbCn/MpoGKUNhAmu0easnCkL7OVeZY21RN06GzH8zNBcqbjMMZriMTAjSLRAtiXvGwV/lSEXw8vwiacLRVCsmqNjf1UuiTlllIregnwx+R8bnQfsruXelCCi5t/BJpf/DBnLik9/Sj06UNrqX4CSAmLDcuW2JZbJUmoSkVR2ggv7XHUHIiW7CrBU+i/ZuKqYGxKXh1WZjAs1k+MRC1fOfWacIZVnAL9k8GKCMgWf5QznM8+ftdUiJxaEa82dFru3qPYxsyoXfUHq/lux06L4n/AlRIl1U326xvmFUIObngDZEqiQZiPbOEyqEGx/aYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(136003)(376002)(346002)(54906003)(316002)(36916002)(4326008)(558084003)(52116002)(7696005)(5660300002)(55016002)(956004)(66556008)(38100700002)(38350700002)(2906002)(6916009)(26005)(86362001)(186003)(8676002)(478600001)(8936002)(66946007)(66476007)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kY9u1HnER2eFG+Fu/KLvQgDLhN81lCgq2YleQYkFs4OUM6MXaaKSYpGk3B6N?=
 =?us-ascii?Q?ymnbQeIo5j4Zzstm4dcnGaIkQ0ruUcPEls8We5ltAcqCXpKy3Amc8ctUYjkc?=
 =?us-ascii?Q?3seAEdXcI/WsrPUFy+wucAd2Zo7U78oqXvcUfsuzTupdEmWJQI7Bq79xFTJ0?=
 =?us-ascii?Q?2Pzlv11B8JVygI/MXgjgLLQugut34yUSe7IwOjh+TfxEaQ7rD+jkhJ7hrKCP?=
 =?us-ascii?Q?grKAjpj/2YHNZn4mV5Ki5ZZ5UG5QNmmS36V20Awm3/HW7QpRxUNhCqS6RZJZ?=
 =?us-ascii?Q?Fh1cH1Ic5Xtf9vN4p+hcQfnkkENSTccepoZnOJ3DKGE2HlLyAKBa/DZYSsen?=
 =?us-ascii?Q?5O/MKFLeb4747ka4zrBObKPXd8uAm5PRPLkDQdddEXO5+9rdPEZKzLMALDd+?=
 =?us-ascii?Q?CvQ+L8x6OzT6whRosVuuFKDzusJDQyj7ajM7+g/47opBCZCTsMbqlKYOesXV?=
 =?us-ascii?Q?VLo2EXycjlLtUBC97OFRxLwRNe/EOQJHd7qHIE5uq+Fm4kqOZPXZjqM7EM0X?=
 =?us-ascii?Q?xcMHszt72f9ZZWQOxqyMqU9dvj7/r/pGcxVDX5Fp43lfZUYXSd1FcIqiwQDJ?=
 =?us-ascii?Q?X6YaEBrQ0y+B7h6fNED4BkOYVcbtV0p0rTTlseGNtEWdvaJgRCx1f9HoNtKs?=
 =?us-ascii?Q?w/AwWZt4QFS/P55ZV8x1r+5gtAJRe3MnGqmBM6nBMNhDH4C8oug5O7MEdMTI?=
 =?us-ascii?Q?8SBIOMrR9iMj2Y3SSgm0Z/z7ZT5miNO8fqcTV+yVMZgF7hh4G5F7AApFeSkR?=
 =?us-ascii?Q?mI+f8YZ69Sq3CS+1V9n4kVTqo4yXoYcoadeinn8N5Cmd9K3iuX6k2+iEbo4N?=
 =?us-ascii?Q?Gu4gyuYnnx3c1MUIlD17hzFrYQtatVxQeyzvQsOk4+bDir10lN+wP10Z5z9z?=
 =?us-ascii?Q?LqbyNfB6y9LjvHpX/SfPvxfQFmCWblKGvVNN/rAbcUhNnru5fY+Y1kd9PY7b?=
 =?us-ascii?Q?JZYb3RocUeJyMHwCX1ESyrn3adUqRQWGHp8D0DFqVR/R0yoU82vMO+0y1l8H?=
 =?us-ascii?Q?x7RGMj6DwW4Y82XAAPiq1tpMwC7pHm7ZB2VeqmujpnZxRJOcFmou0eeRtDhG?=
 =?us-ascii?Q?SmKnO6q+ysBF7x4lVsBcGavuMcH0gQKybRkRUn53pPw/8gnELSBtDonkXSUC?=
 =?us-ascii?Q?WZf4n7aNGNRJRlwTLWEbXjM8tHPEvKsrmNIp0i/k5HAHycpbxjN78UQy9aGT?=
 =?us-ascii?Q?u5CvAa/1X+pBm5NCTrFfn6v3m5gWbfjrjjwyH2s1CV84kdG+G+7HZnBhUGWn?=
 =?us-ascii?Q?Cmr+8D0+xkmmV8KQ7fuQMLWAHAXMJrlB1z47dKxnZAeQR5dhzhADsR127w6E?=
 =?us-ascii?Q?dIS83coQCRhht6AIS+sFVGQ4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da83adc6-5177-410b-e8f8-08d935e4df80
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 01:18:56.9124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bD6+ucs+pSIiUo5QKxe99rdZsQ5RPl6MyFfuvalHV9DMI4Z8zcX3PzjZU0IRuxnFVSNyLv/3w3hAhsvrYkYdrTuBm39c/sj4ipkTVm04BhI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5467
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10023 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106230004
X-Proofpoint-ORIG-GUID: HgrgZEeGswB4ek7Dr4ay5foOVcLSSjI4
X-Proofpoint-GUID: HgrgZEeGswB4ek7Dr4ay5foOVcLSSjI4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Since scsi_mq_alloc_queue() only has one caller, inline it. This
> change was suggested by Christoph Hellwig.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
