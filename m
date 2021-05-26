Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A22CC2B9F7
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41E3761090
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhEZEKC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:10:02 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:4774 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232495AbhEZEJh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 May 2021 00:09:37 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14Q474f0019220;
        Wed, 26 May 2021 04:07:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=9joXBPvLng3A4X8Qs87ZXdKzfnfzg+7zdHO83QXZJn8=;
 b=NHCdmUX9/iMHSynrnk/vcx72/lNomqCkPP/EzcqkEX2HitOG21YwNjmJ4c+kyU0lvauH
 /KhdY1/iigjBVGWHnyPFFEtxyA/EmyM6vmhZSWeZq1UhY0JsTTrIcf6+6ctyLsy4/jt4
 n0hge6ZB/y/TtPvvKS2IXyx6h+Gn3DxOgSfHyfz5PzZ22c1yShUuWz5HsJxLYc8I9k4N
 EjXk2qTMIZVM3lod+EmrzEW9+qjaXsW2gXbd20+jvQuSa7B7UgkJW08tEFXl45J3611P
 EvZwut7RXX3owsDdY/0SM14P3Oo3tFoDtFlfwr5rt8FETurGNQwbyDvbt9HmxqjRRlyf wA== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 38r7wert4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:59 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14Q47wG6187413;
        Wed, 26 May 2021 04:07:58 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by aserp3020.oracle.com with ESMTP id 38rehbs0hf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MyY4bXeTqcpZXLsRHaWfiY9XoV6trob/rYiaDoCw/xCTxes2ibct56hW0cjY70K/eZXDNmEkym2p3zX/yKqVJieHmW0YfTqLPC3IzV2qHfzZer6y0vtAN8AxsBjgpzJx2Y4TGzJnCruUHVsdSbkJqmy93GVBaFdUcEtXTsd+7sfRNq9xo6EDFKdwtQdmG1Cr5Z0lR4TqkPJgpoDokHCAiha6lZALDS2K/MNELumQ99HAC5VV8OQXCjEh6OqqfNAQiPpDeStoRkgq/xuxfrxkx2SqV8SVyAS4URZcmweJ92wg6ckAn3Fx75ouU2IVynXucVCRt3TMH2XNRIsYFGMhjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9joXBPvLng3A4X8Qs87ZXdKzfnfzg+7zdHO83QXZJn8=;
 b=BFwSzr83TyGKiyyqIOSDK4bGOSUNVGYFcBXeGWhycmX5pso87eoU0oXtl9dUJEcW9Bek1x3m7e/+CHMCCelfa7Ok4bosXC7Ksj5bEmM3m8rIbfcvhcy8mdtEmzqfFnrQRuihy0Ca8TW6GroKvAo6dc5doIH0Mt7kGWGHQ1PDZ2uZBnyp2imnz8QQDNNKtvzmmSHf2Pb64NdFXvHOW4yHUdIJOneeSRoHvISD41TDhZqvhL684zmIwjt/qaRO97uw2uHCu5OR9IUgpUWnjE5lFR8vUVfLHyaDt+BbsWtjUz19CVSXdbHrkgzYF2vtOYDrZkTQal8v2lUHZMuXpsC1Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9joXBPvLng3A4X8Qs87ZXdKzfnfzg+7zdHO83QXZJn8=;
 b=iiP9sB9OE5vPr994hHy6wVM8x7Eg1+qZYH742A3d+0PfoO80V3wy7TtZAaZwogl8irQuX9VHEWSUn+FmvCghdC7GKOnNFK8JFoHr5uRhsxpT4G5qZT6M7EXJyBWAGMWzqjFkzqdxschLaLIRs+RxTuaARC2Mhj9vJMMSuEkd/cI=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4469.namprd10.prod.outlook.com (2603:10b6:510:32::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 04:07:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:07:57 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, zuoqilin1@163.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        zuoqilin <zuoqilin@yulong.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: Fix typo
Date:   Wed, 26 May 2021 00:07:34 -0400
Message-Id: <162200196242.11962.17040467232891611292.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210521082808.1925-1-zuoqilin1@163.com>
References: <20210521082808.1925-1-zuoqilin1@163.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Wed, 26 May 2021 04:07:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24b249d6-fac3-47fe-9ad7-08d91ffbd7da
X-MS-TrafficTypeDiagnostic: PH0PR10MB4469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4469C3256133BEBE28FA2DE48E249@PH0PR10MB4469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q+/F5U7rgauvoOKqvkuyNu2v6VzIIEGOuOsxVzprPwNGZEU020+RySrBmamRbI3lW9BS5yRMz+EW5WvgBZmuIBOpERaV/jjhnLYdInEXyceqJOPf/j5vcL5n3E29hb3YHuhpR1xfVT94epOoiMllfsTCXbCK1/QLk6ZvPJOuMhco+LBufVj2YQ6s4bXgPyIu56VFQHNRfePjQ6Q+1+b11yeOpSDZQkwzKihmW6LWiED9hNMrZT5qsTxv9Ph4obVLHxseCqmg5FtAtEcOXeqkL4Q2mXJATw8BmHauFqCiPjMpz6N2P0xPl7w2HSTdhhzFCSg/rmM6HKhPc35fPE1Arcerrjmgr9rUhcypxdR3SOcG/lXU4BmWn1dhZ7rs9qrGW0fwMDsQso80XpumTZNCKs2C84htwwfyPPT2jXFYFk/q1AGmE/93Qw2ZVb4LK9sAQeYjRtkmZbDuBhof6DKejampdiVcDPyWTce6o8xbQHD6Yvm1+fYqTHlm1jIIviZ1+dliy5fxb8fsJcF1ZBV/XJLmrAFFJ5tZZFG1fLSJqycWn9dSc6RwuX65FADKWRZFFNZQab9rStvv0NxIDXC0pHcvb5KK7PmRls0RIsxDIeXyDT2/cr1Th871+31ZPhQ9u9uG8+etDG3XLwJ8JrS/Hkxy8lPHgBt3yLdssX8VibNZ35JETQT/R4qyhLixds0zYikms1w3ru3WQQqiv5iZqeML4BKB+0JAaGuzBFZ5JiRA0NcLnU5I0lv4I6T5/RNv0qRmKVRfjVTiWMX8t7GRpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(316002)(16526019)(54906003)(186003)(66946007)(4326008)(103116003)(26005)(2616005)(8936002)(956004)(2906002)(66476007)(66556008)(7696005)(38350700002)(52116002)(38100700002)(5660300002)(8676002)(6486002)(86362001)(6666004)(558084003)(478600001)(966005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SXYwcUdlRW1wY1pzeW1aUGU0WGJjZlZNM3RsT1prMjdhVzczZGZTR3p1ZVEx?=
 =?utf-8?B?WTZSc3h0S0EvNU9iVHpWMkUvZmtOVTB4bVdBUmEvYy94dWRadmNZeUNJejdm?=
 =?utf-8?B?OHBTa2svQ0I5VytFNlVDL1VuRGVBWUxJd2JaUTZBejJHYXJQdUlocEIvdUFN?=
 =?utf-8?B?M0ZVb3BUTDFQRERBSllJSzl3dEYrN0duK2VXelgrZXhCeENjRXFiM21XaTJR?=
 =?utf-8?B?bkVuQVBZZzMwYW51b21qT2s4ZXRuU3RWNUY0VytrM0d1MnZnSjhLMmcxUncw?=
 =?utf-8?B?dFl4MGRRdkdBbEVRY2ZnMnphUFViTWRwNTk1aFhXWTkzYjVHNHhkdllNSWdV?=
 =?utf-8?B?YWhpZkd2YmtUaG4yV1I2Mktwc2owVjlza0g5TUFOSjBxVUhnQmpCOFVnYUp6?=
 =?utf-8?B?VTh2czNyMDNCOFRmbkRNV2k1VzEybU5vVDdmWlhhd3dBZm1id2Z1UVlrYTFU?=
 =?utf-8?B?TUc0UGpFVEkzWUllT0Q1ZlVXc1ZGUkY2SEhKb0Y1eTRMWTdvSFp4bVNqWHZZ?=
 =?utf-8?B?eFR2Z011Y2FSanJSd0hYZ2c2Qzh4VU5lL2g5WHl5QzJNQ1hIN0Zxekw4UjdX?=
 =?utf-8?B?NkhobnFvTjhOQVMvV2pUU2l5OUt6SGhYYitKcmJJeWRwQWNrL1RrR1VhcGhX?=
 =?utf-8?B?OFFDUWZuL0NwNHpnakdUZmgyWFFJNkpkVHRaMEIzbkFmYzZNb1VERG8vQU1O?=
 =?utf-8?B?eFRtMXlNRVhEYjMrdUgrRFZ2Q2Nwd3c1WGxDa2RJNE5xbVJiVGdrMW9QaTQr?=
 =?utf-8?B?T0RveEUwY3IrRnlUMzAwOU9JVUtUTGRjbnNvYVlkUXlLQklnYzVESG1tZlFn?=
 =?utf-8?B?OFU4L3c0R0NJZG1jelFwWFpIQ2NGVjBKejZvaUI5RkM0UHR3ZVZYNWdDbUZj?=
 =?utf-8?B?OFQ5MjZ5MWFDQmQrZWVqN1lGZTlWK1REU21jam51U3NlMXljNzEvUkluSDdR?=
 =?utf-8?B?emQ1bmYrSkJlTXZleWxqOUNuSnBGVTdialkzTzdZZUg2MFFJbjkrajB1c3Rh?=
 =?utf-8?B?d3R1b2NWOGVvZzVVNS8rWGZ2TzZ6bnRSa1hlRkxMdFQyTkIwSjlMUXA3bjYy?=
 =?utf-8?B?ZWZWM0xVZFQ3SGlkbGdFYUlDcVNrcHVZWUdnQ0g0eEQ4cVBSbHJFdFBxRkRY?=
 =?utf-8?B?Y3k0KzV2N2c4Z1g5OVNpUGJoOXZucy9jb0RORGxlSXVFVjZBOHI5U1VUUzZq?=
 =?utf-8?B?T040SEhNUlNzVXgweE5VTmlydmt6OC9kcVEzOGNtditEa1VyQUJ6RGhUODNs?=
 =?utf-8?B?Qlg0SEEwYkYzWXRMY29qd2VESHhLVUJGUkU0WXRyd3N4c2xLanN2UTdRTW1x?=
 =?utf-8?B?VU92ZGhpT0ppdUdEaTBsY2NXdXgwY25pVkpObm5wRXN2THZ1TU1ubVNuSHNG?=
 =?utf-8?B?Zk0rbkRFT0NEb01kS2J4dlg1RkFneUZqeEhtS0pwSkswamNVZ295blNnQjZq?=
 =?utf-8?B?NVBkWU1ndmFPeUNWMDIrN2lJbUhCWmsxcXhLaFN2NEQrLzM0RjZ5dm5zS21u?=
 =?utf-8?B?QzJ3VmRra2tnN2JTdzNhTVY1THNkVjk5bEpMa3RHZndqUG5Pckd6ekFkTVRU?=
 =?utf-8?B?WGh3WXJQUmJnbEQ1ZFphSFhmclkydlpZVnFWU012dmpISnkxTE1sUmRONU13?=
 =?utf-8?B?bUpGNmVITTE1eEt1TTdpVkhVNUduNVVwWndLWjF6KzVFNE1DK0FrRXU0NVVi?=
 =?utf-8?B?ZFVzR3VzS2lrc3QrZitibHRXUGxEazBvanlvU3I1VWRnWXVNMVE2TDQvZ3ht?=
 =?utf-8?Q?Ye/2JI6Qc2QH60Km8uJcF33lnxeEgJQTmf8R9nu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24b249d6-fac3-47fe-9ad7-08d91ffbd7da
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:07:57.0625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4zgNX4rI/Bruys0NaqW3oRrgp70rdo+TK1/GF3H92kwmQayx3XCGkn8jhbsqz34ZDyr1hZoB3f4YSqgkG+rxkkCn6jNKJDymbs9jHM/fXww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=977 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260026
X-Proofpoint-ORIG-GUID: 2X9PS08x2VBmje-kNEf2LehDGipA7Y0v
X-Proofpoint-GUID: 2X9PS08x2VBmje-kNEf2LehDGipA7Y0v
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 21 May 2021 16:28:08 +0800, zuoqilin1@163.com wrote:

> Change "avaibale" and "avaible" to "available".

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: Fix typo
      https://git.kernel.org/mkp/scsi/c/2d535031eb2e

-- 
Martin K. Petersen	Oracle Linux Engineering
