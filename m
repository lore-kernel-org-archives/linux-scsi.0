Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7BEDC2B9F7
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B703A61437
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhEZEJV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:09:21 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51692 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbhEZEJU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 00:09:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q3wgZU183659;
        Wed, 26 May 2021 04:07:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=3vEvKvfRN423j8xDgObdqWze19ryj5J9bE7I3YuZTyw=;
 b=g4RbliIgu9MRhFan9AMXcoSryMEVnGZdJ6P9MNV74oXwdBDTy0V+G/AeEj7H855paORR
 TyPYto4lchLAgRr/oBQgkIK0DXVMTb7xQ4LEx6dnRM+K9tjgZVJSHtNhDs6fnN4TsO9z
 FK1n4kB5LXjyQkxTGuasd66pPT//dAgscC+wkOkLI4UR/zsi1ovjv4zd5ZTEwEZ+m6fe
 57uOJnHArgddFDDtFQfmIg21OHqK3s+OE4svTX/4IsvTlnkkfyX7wS1OsYediEBfyZKy
 TewuJU+O8FSsTyaC1OBjkrHx/I8v5BjgFVUavoYIJVgCrWKmBHdl1Lejg0ot1xa+q8Fb Ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38pqfcften-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q46EFo028041;
        Wed, 26 May 2021 04:07:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by userp3020.oracle.com with ESMTP id 38qbqsvdad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bBUXucebVyhnEQ5h+T3d7zcgKI4rQtjpRfFmc7ZVFkR+gMMFTCVb3qU6M/Yvtzd6U2xELlhRJTpU11a7yCBrf+Jyv2Hfe220yjMJWyd7nYRaOxR0ZLGcZGhiaASTn1Rrj157sGlhHH6IpU40FGBoRhJRw4Xpg2I1+Ae8L8nS0YiOz42V5somwUbakRPGjr+xE+QkdoGM5voaT3QYEHKLbpqXonqEHVwvL08wmLUTT1cPg9lntlXj7351DrJVNEAfWi3zaYpRVIjO0ZqXTVVuQuHbe7omFYsU0hqTsaepp/N9dGzgz9Dd0UJPfgnLkr1p9tXBCx6IL1NC/Ifqw9w3AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3vEvKvfRN423j8xDgObdqWze19ryj5J9bE7I3YuZTyw=;
 b=indSTWPtlH1d1MenNAYOVGo2pPYaSqD/AOief0ZB2NgmQqhapjcPAG/V3FdMhCO8T6x903s06UuVn46Z1JdmIRPyESPgUMUeHm7e4MRbHM6eJLy1K4eGmV2gpwa1yekeIhMnQQZazND0S0nwdm3NKwds6ZTf0aT38D5xSmksIIP0jOKt+n42/Y6f/y29v7Raimt6xZbTWxhonU+uG49A0mPbAcl1eKdT1guM0nnnIyRaxxMkhhkrLsPNskiTodCZaR+Qs686hEU9DnVYtCKREP6oVYma5a0BfTldJIRBY3cjLrlyXAqsZtPHI3xIibnqT2xldliPj52XfH2wXI/wPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3vEvKvfRN423j8xDgObdqWze19ryj5J9bE7I3YuZTyw=;
 b=if4tKIVYr9REwe3yWqAORUIYwzRWFbSnUgNuOuT/hwJ9zbqqQ7nx92KWzXHKamUKrX+OajpbnPufJgGbDix5HTCMqpmKd+TIlWzSdEikojjyK60NjQ5z2UAhJKsErXkWNEn50v9sA72Wqu1Yt6d3ANgwdV+fTj3FDJGyAVmDODU=
Authentication-Results: HansenPartnership.com; dkim=none (message not signed)
 header.d=none;HansenPartnership.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4549.namprd10.prod.outlook.com (2603:10b6:510:37::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Wed, 26 May
 2021 04:07:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:07:40 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ching Huang <ching2048@areca.com.tw>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi: arcmsr: update driver version to v1.50.00.05-20210429
Date:   Wed, 26 May 2021 00:07:18 -0400
Message-Id: <162200196241.11962.658715928890972764.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <d0c6dc6431f0e46db6583dc0d04d7983b420d4da.camel@areca.com.tw>
References: <d0c6dc6431f0e46db6583dc0d04d7983b420d4da.camel@areca.com.tw>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Wed, 26 May 2021 04:07:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f286e1b7-39c7-4ba0-2148-08d91ffbcdc4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4549C4C412697ED827CD3FAD8E249@PH0PR10MB4549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VceWRgQfJkhcJfjmXqwpZ7OPrlgl12VqHtA2opaNNqk9Fx0Gqxnh1HGLAfCNEO2zQHNcHPlJa3IOLuY1Y8iC+TgYfjB1CMYgbE1+ZjIFW7pmkFUiBF59oYdHBQnoQ/tG4/xQD59m2YYnLE6fglq8yH2fDV4k7xo6kptBXFxn7t4MKT2t06jhEvOrf7EhANPZEw+F42ArZI/ljauY9KfkBK8l+RO6/yKjJ+2VeDdUZA6yQtCAb4u1FRiEI8GjeeU4ng0fn9rcqpyfDcQGbYuCVjOGOGmD6JEIoNfS2Uo65OH/m+e+qeI5vG0PVN/XcY3v3xtZbzaeecn+COhAZRAAc/GU0SxqZs0pkqLUWzc3nW3+Hj+eVzB2QW/F1TsHJFM0k0qFLaRhAit2965Us8jsFmzgkHkz0bDM8Ouj8Vhsx7cTeWhM0iAvFCwr0UambPtPHfa39Oh/QpLOrPe9sXpT/Gd6+89wGeZ8MSSQj2Nmfr0G0oz99M2M6sMgsgtX/IoXRNoZNI5dcHHwhdRS8lLkstCsvnLh28Dgfwfz3AEqi02pLnBa7tXcUOKAS4DuDBVKye1pQ3/L1uff4IRaCOODfDM5x0BGUCOhKI/gtW1dF3iQ/pS4YsygO9nCbhpHKpoDXklY6EBdwmsyN7yL3ZDG75McydZyEW1q9oyO+6n2Qwgykitrg0xuIs26iJuCvbFMxkhrSN6mh96JBv+F2K2tVNCXfy4dTCbZ03D5CPd3E94wdAttmIQPN/uusnmq+X5YT3phg5wjfRlBmT2cPPnNog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39860400002)(376002)(136003)(478600001)(66556008)(38350700002)(2616005)(110136005)(38100700002)(86362001)(103116003)(52116002)(66476007)(83380400001)(66946007)(4326008)(956004)(5660300002)(107886003)(15650500001)(6666004)(26005)(558084003)(36756003)(966005)(316002)(7696005)(186003)(2906002)(6486002)(16526019)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S254OC8yc1RaSlZ6NzF2UWpIL20vN0NJd3lITWtRQnhiZlhBbEY5bGJQZVlY?=
 =?utf-8?B?dEhpeEUyUEpycEJzS1VSZjNNL1VFZmpzVW1QdE9va3BpMXcyM1pTNkJacmwr?=
 =?utf-8?B?Q1d1dWdtT0xySEhTRzkweU5Ebit6TjZia3ZhcHdNYmZVTmtvRmFrZ3VmNHRE?=
 =?utf-8?B?b2lTNi90Z01zT3hXUGIyeWFvTkpLNGQwNEtNMkZMdXoydEpFNm9EWFgwaWJm?=
 =?utf-8?B?SktBRzZXU21abW1uUGtEa3hwZ0VpTHZMbnJxWXpHM08vZEFUN3U1azliVEpa?=
 =?utf-8?B?WHo2MW9BbnR2YlVuUFQ0SGVMVnVMTGM3SUVmUStRampMU3E2ZnByVGV4SHg0?=
 =?utf-8?B?aUpyV1ArT1oxRVpVbnl4K1doeXltWk0zSnpTUmNCV0tMa3hscmV3ZGpCZHQv?=
 =?utf-8?B?cEYraEJXVEpsemNDZlp1eDJuakEwM3FSYWk4RkNUcUorN09nMlJITGZXN2Ns?=
 =?utf-8?B?Ui9HeHpnSEk5Wkh0R0ZLV1k1bGFFb0luNWZCbmFaMW03ekVWWEIvL0hwSVBB?=
 =?utf-8?B?My9hZ1NZcjJpZ3o3NGVwcjVKa012WFo4c1B5bHl4c3dVYk1TTmxoZm1qUG9L?=
 =?utf-8?B?RUcxZFFMU1hQcWZHdGdBeGMxYUpGbVlXSHdySWR1MHhRNEZVTDBoUlgxUEtp?=
 =?utf-8?B?eSthb0I2NERUby9kcWNPajdFRnNHMTVCM2lqTzhraUVUS0hNY2tmUXpFUmwz?=
 =?utf-8?B?R0s2c2p1Sk1mWUM2eDc1ZDhoOXVwejRZUEdWRkZvRUFwTFlXelQ2NFpUbC9F?=
 =?utf-8?B?ZVhUemhzazRTV3pzakgxNENmUjVnVEtDcTc2ZUFxSTVVYzhKa3NPcERRQWpH?=
 =?utf-8?B?ZnNIWVhpL0QyYlBYSWk4VHJMbUZ2TVN0V0tYeWgzQ3BRSktuckVVazhQSFlT?=
 =?utf-8?B?amFCMnF4WDkwVDUrVGJIbFIrbzdHcVA2V3dLSFdiOUZKM2I1T0VLTkxjNDlB?=
 =?utf-8?B?Vno2aDd0S2hYQTJ4UE9GOVpEQm5SVFZVN2xhSGtJamppRXNGQ215dUxCQ2JE?=
 =?utf-8?B?NnY0bXZsNWVaOFJoSFNlRk1QdCtGNmZKY201d3cxTUh3NzRuL1p1N3k0b3pL?=
 =?utf-8?B?RDdySkNBTXdUYTBvdjRXd0k1MlhrZUR4NWJEYkZxRWlmOVp0YUR6Wm1acVZ5?=
 =?utf-8?B?N0tYbEYwL3FWSC94UkxVV25kWjREZCtVZktRZUJ1TTBRYVhnVFFGYmQ3WTBa?=
 =?utf-8?B?TUJBa3BxQUlocHlPOFF0Ykx4UFNsVFVJdVRRRkRqMVR0RGRZYlMxNjBZWVVD?=
 =?utf-8?B?NlFNY3Y1bFc0SjlVVEVlWVJneThHT2dZcmZzOVNEbUM4RFExZSttNTdLNFk0?=
 =?utf-8?B?SGRReFR1K2JocCs5bXhrb25Yd0dZN2lZcnBoRTFtWmhCTUVDRGFpalZmclRn?=
 =?utf-8?B?QW9qK2ZWODdmS1VXbTV2eTcrVnF0VCtxMXNJRmYvaThnNkZPQnJCc3JTa0VS?=
 =?utf-8?B?ZWx6dWgwcWdxNDNhMzJoVDNQMHNrMFN4TGo0L2syZXRmbDA2bElLbmVNcHVk?=
 =?utf-8?B?UEoxQk41RmY0SnNQbXRQMzRlZkpJcThYS0xhZzg5dzgrVGFZSzk1ZWJFb0lH?=
 =?utf-8?B?QXZrUCtEV2RsZjZZZU1TNmhpanlNWlJheGJmVzBZa2kxd0tGUnE5b09SeEJK?=
 =?utf-8?B?UG44U0wxY1BvN01LSXRuMEVCb0lXQXRBellpSEVwSjBBRVViZUxNbGhxMUZy?=
 =?utf-8?B?RnhlRkZyZHlCNzhxWjE2STJUNVlYTksxaDhrT3lBYWR0cWcxMzhWTTNCY245?=
 =?utf-8?Q?30eckngiDzdmBVkPvgPvYe27ePjX1jDgtT3lNnQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f286e1b7-39c7-4ba0-2148-08d91ffbcdc4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:07:40.1351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dPKokMLEbk7daL+4E6EdiXJlk89i2g6yEXwrzTogalEIADSP2yZ3F7h9ezPdhw3v5mhsT1K6V3dDzVmFlgsVSfTgVML+O3s8AG5fBr/INps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260026
X-Proofpoint-ORIG-GUID: kAUQmJKzxpsf9_aBZeYJpt77rSLF2Bua
X-Proofpoint-GUID: kAUQmJKzxpsf9_aBZeYJpt77rSLF2Bua
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 20 May 2021 15:13:49 +0800, ching Huang wrote:

> Update driver version to v1.50.00.05-20210429.

Applied to 5.14/scsi-queue, thanks!

[2/2] scsi: arcmsr: update driver version to v1.50.00.05-20210429
      https://git.kernel.org/mkp/scsi/c/8e060b310f8f

-- 
Martin K. Petersen	Oracle Linux Engineering
