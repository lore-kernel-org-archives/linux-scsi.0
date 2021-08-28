Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E350CC4320A
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAE3E6023E
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbhH1Cdc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 22:33:32 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:6140 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233196AbhH1Cd2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Aug 2021 22:33:28 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RLCgmk029003;
        Sat, 28 Aug 2021 02:32:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=fqf8OjToVHCb6xN+Mi+HKwUSrzaeFWEoM5r/eK1GvwM=;
 b=f+jJbt96Yrju+YxBHQ62lfUyxgK+Vb2EGbUE+iAdDf0g/wOgfgS6TFE2u8LZEL3yLnu0
 H/SwfGnd5R5Y8OI5GZ2wDbWkIwWiJuKXN+aCAjL4cjsexl/FmBbEVolo4yVU4Ahx6etA
 0iDpryDYylqbqSNCpVY+x5jGrt+gAiG1y4yvY0UqM6IfnOA7n1vw+vEniKoDDYKZgDl3
 oMMiFCUjzJFBmNaqY4Xr1kcU0k8byjPXMg+KDow1x7j5mAKeyhW/2/7OkpbyT4IWY8Hm
 ScUmi60oZAlkAyL/JexAJ29wyLgxRLnuuKzD9J2aEwpc0qUgMVQohK2fersj4afJEIV9 vQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=fqf8OjToVHCb6xN+Mi+HKwUSrzaeFWEoM5r/eK1GvwM=;
 b=rslt04SR7tqRg3piVQ1RkwMz+THtYf83TigGejWUXmsV5x0olzsO2+ELXWkD3W2nijVa
 sFhkwRePJX6+Kn8gCTEaQg/ZIGKPohHHUS5vb3EB/DaQgs+g01MbkownkABdqVKADHWu
 yHMbqUS22gUZOXdgP+4pVeJ1HRneX976cETsLLjPhKsvnMRJTcRuEcSTJETCeqnQm0PS
 9jWxPVlj51ZY4k1sWFof1ayt7gp5jsyvr5xUjnoOeqtMdVOOmfGA31rud86sQyr0/Fjj
 9RAiq0qYnyLhmXMN14wck/S9cSOhXHUgu5ltb2N5oNtdCnB1Wumuum01atFHBW6Du8DL Zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aq7s0r8m5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17S2FdZA147254;
        Sat, 28 Aug 2021 02:32:28 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3020.oracle.com with ESMTP id 3akb935rfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1FNhZb8Y+hN38n61zp3QsAdumBOvnewriChuWDyhyjfym4XIdNBs5ceJrLvCPZ/BpIHNY/f5Etqn+PnAnaGQ/7DZ1e9p/AKxnbuP/TpQw3qcb2WViY8rdDh155J1OrGun4RsT6rRe286MOgJPASnCbph6hEyqg/N/A1lsZcDlvn+pMBj8E0NvzLn+eKHu/JjpRF2ZqTeSmqaDLmNDfmZyo8DeXhs9ZVJ5u87tpyXUAifqpoXKlYdUnrEozSw29NdPsRkF3LFR4MG20HUbCgoOWj9FFUUVU9gk0kEFRGGVeUE8JEwytd4YguXKq/TjUNrIoj3LkQD+S4nH2Ww2Dbpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqf8OjToVHCb6xN+Mi+HKwUSrzaeFWEoM5r/eK1GvwM=;
 b=Kx4OFfEJF5k4n1Np8fO41NkW1H6djXK9MzJj0aRPAN1ElRJPAgJPVL3GIVnDLPLKRlnK1Hm6LihsPjt9AibtzVcuXiuRe7/Sg9KbORilPtQSl9EAhFSQtmslshboaDmLDeNZp/BRwReCQuQ6CYBGXVqIUU/23ZHOFThRvvqq0LpWxhCXXV/toI1GgMBJe2Ha6r3KFB8YPKbDO8ubVPu2YYz2joyZ1ihwQpInTjhVs2M3SEALFa8XeGzm+2p4rXQuughSKz4vIa31hc3FBJ67VUSUf8diRmD4+YZKgYZodlHRfYFGpCHzPfREOtEcEVhU3StAHtNoLIm7UQVSCkGvBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqf8OjToVHCb6xN+Mi+HKwUSrzaeFWEoM5r/eK1GvwM=;
 b=tZndmzhYSe8C/h2SuwL+9F0TFZFMMXSztkkyf11BH2/pSgrfhE2zIRsb3Dx1RDQ13Xif9jBy3m1my0NPvJ5RgjHdZ/cLH6n5sM1Mwo28aZ+K0/uWY4odM53Z+R1uJNDKwdtm05m2N0sAt0pcfxJiuk/4SDRmQ+xDOKaB+dfoSWQ=
Authentication-Results: micron.com; dkim=none (message not signed)
 header.d=none;micron.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sat, 28 Aug
 2021 02:32:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.027; Sat, 28 Aug 2021
 02:32:26 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     beanhuo@micron.com, cang@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Daejun Park <daejun7.park@samsung.com>, avri.altman@wdc.com,
        Keoseong Park <keosung.park@samsung.com>, jejb@linux.ibm.com,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: ufshpb: Fix typo in comments
Date:   Fri, 27 Aug 2021 22:32:06 -0400
Message-Id: <163011776502.12104.2359083933539808369.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1891546521.01629282781634.JavaMail.epsvc@epcpadp4>
References: <CGME20210818094139epcms2p745d70390a0e328f3ecc3b266f092c9f7@epcms2p7> <1891546521.01629282781634.JavaMail.epsvc@epcpadp4>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0025.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR17CA0025.namprd17.prod.outlook.com (2603:10b6:a03:1b8::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Sat, 28 Aug 2021 02:32:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43cd8862-0e72-4ed9-32a4-08d969cc12db
X-MS-TrafficTypeDiagnostic: PH0PR10MB5515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55150FC1B3338189D39FD03A8EC99@PH0PR10MB5515.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f8BwInjHB1b9eJpvCfgaq14+WAuE+EWJKJLigOHIVi/F/Flxn3PSRyHyoW39cSPuf/BPfF7Oc1Ywy4XqA8OKGGXMsAm3RF039XfuPuhzLHL6dHbZDfm+tRiAkxY7Jl1Ax2C+3vcH9Rlrd9/c6sgmExSdMkHNZGAypIUXSu0rIqBZApSKcUGK1u2pHq+5eJNFfRHCn+jqzpyAG9X9wvXmEywmutqRKz8QTZDbzbnpif971ZlTMEIEhtvKDKZtMsgeQIS9C3WTR1mlnh0T6Hf+l6D1ZzAMFjp/Vo2tE/JuxsRs4sjWyMKge4p2BMIqOiQVSOxL4I+mzaU8UaNLPYTwf/ngRijyTAPWhc2fVB3Lyw0kHYX/0pxeQ1C/R1MS+JGrIPlg03fwjidcPxvtt7HqgrtjMYTNNdnE9e5SPlgYx94kH2m+VOaAFN9F7t4ucVDtA/LhxoV8To30GajLkPHDyO0PyybIdND38uyzNF2W0qJi8pLlu+u12/cyp22Y5IeOc3Lb2g6YsuFbQOQR+qhPrrJsoRRRGB4Wnk3cY5ToGqV77pdiDz+OxykpoVy7syGDr8h2WCp5lFh7ZWgO7cU2tvl9xpPBPF6NAyeZjTKrpgBq/F4cYx0JhalLZtfsz/phJ76JhpQXpnhfhhN1vc38+yaymhKBpQtYdWrFq+hg5/qscgDLjshLB8FSWy3apaCwbzJxtusaGLIGG5immHWiZdQcU2WoBkv5JkbSgNfmV+aKx67++yx3UtTrZPY8ho8g781hfm5ObIOv+d7L5XELuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(966005)(5660300002)(558084003)(2906002)(508600001)(52116002)(38350700002)(38100700002)(4326008)(110136005)(7696005)(316002)(36756003)(186003)(956004)(2616005)(6486002)(26005)(8936002)(66556008)(107886003)(103116003)(66476007)(66946007)(8676002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1FhMVFwYXFmVzVaNlBpdmVQbGFEZ1IzdEhYSXY5WVdyU0ZQVSs5V3krN1pn?=
 =?utf-8?B?RHQyOU1UMnN6N3BqQlZyMFlQeGdPOXliVDYzV0ZGdUJQRjhUbm01WFRua09J?=
 =?utf-8?B?ZnhXN1l1cm5YeUhkTkY3Y0g4R09NMnNEeHFzVmNBVG1qcjBDdzJZeEw0WVZN?=
 =?utf-8?B?Z1lCSlZSaUJuZEtyMEdFSnQ1TlR3RnM4NWtQdXhmaGFneWhjb2JiTEZsaHRq?=
 =?utf-8?B?b200c1dzT0xlckxPYzdBZzhpQXNrbkwyb1UvT1BiMTFKTS9LK2xkbmFNWHpv?=
 =?utf-8?B?YlYwK0sreTBmL1F1Ui9uMGJtVjFncXZBaEJlUVFSU0dHQ3BNS0RFT0ZCZ2tT?=
 =?utf-8?B?ckMwN3NrQTgxY1Q1d0M0Q3dzRG0wVmNZeDNJVFMzTjk5ekN6TCtqaWlNVXFL?=
 =?utf-8?B?SzV0akcvcStDY0NhSVFKQlp1NHYwMnpycm0vc2d3TGZUVXU4eUlQU1JNaFFK?=
 =?utf-8?B?dlFXckRHWjFmQXcxU1dMRFhqNVV4WEwrUzA4dHhqK2lBdUkyTmRqeG5kMURC?=
 =?utf-8?B?ZUhjNDZacFNtQjI3RUs1ZXJnTG9HUHBueXlsN200S1RrWkp3bldsYU4wVzNu?=
 =?utf-8?B?Z1Y2dlFsRURhUitGWTMvS1pXR1ozWmVuSHhnYXJNK3pna0JjcU12ZGhpUkdI?=
 =?utf-8?B?dEtPUlNVTXY1TitHMERHZ0dXbnk0Zmpsd25hbzU5dWh0M0hzNGxNcmU4MTNu?=
 =?utf-8?B?OXAvRktwNGVrOU5ZYm5leFZmQUVRWWE4S29HdVNsazI0SyszUzh1eVhUMUxP?=
 =?utf-8?B?K1JqVHVKU3ZrTzdudlFDNGxCSHUzR3NCeURSRVRETkl1cGhPMXZEVFRSMi9t?=
 =?utf-8?B?Mm9OZ0dQRzNGR1FqdDVBZlBNazdHeTdkaTJNd3A3SUc1TFpDejhsMVlsNndO?=
 =?utf-8?B?Zmp2TTFUbkFPNGg5OE1wU0kyYXZYYS9NQ05JaGFSbHlmUStqZlZxN0kxQ3JB?=
 =?utf-8?B?ZkhPZ1VBbFNWc3lkMXhxRjJLV0VuTnVvT3FDekM1Zzl2TXBNaXFwRk1FejZu?=
 =?utf-8?B?bUJiamxOWlNLQzZMSlpKK3k2b0NZNmxqeEdLa1JoYk51L3h6RzJROGJXeGpz?=
 =?utf-8?B?TVlJVVkxbmo3VzNkSzV0TEtjazRVUytZeUNwTjlLU1E0b3FpN2ZFcDNBTWlV?=
 =?utf-8?B?YU9MZmx5ZXhuV2RHT2JIOEtLWWIrZ1krbUJYcjlRK0trb2l0Ykt2R2J0cGpu?=
 =?utf-8?B?dmxGTmFaemkySllHbVdaYlY2Zktuc2J2U2ovNGhxVzFpSDh1SXMrM3MzQ3lH?=
 =?utf-8?B?TnkzRzhVOGlTTjZNMTU3M08zbUR0SFA4eHVFejBzNXhGTU90YWk1cUNRRzVJ?=
 =?utf-8?B?d09VTHUwaHVaVVFKTDhQUUwvV0hIemhBcGFta1czRWd4SktjeXljK1hBd0cw?=
 =?utf-8?B?TEtDbUNPTVp4VXlLVS95MjdhZG5XUm5Bb3o5UHBDK0czOUJhMzFYaGJPWWpn?=
 =?utf-8?B?NnRGMnVqZHFBWFo2OUpsQ1dOTWo0ZC81ek96ZzFRYyt6NGI4VEFjdUVMQktM?=
 =?utf-8?B?TkFDSDFIZTdhY3ZXK29pVVlzdmZDdVB4Unc2T3dWOGxHTGZqc2Q3NDZLb0N0?=
 =?utf-8?B?eVhZT0hTOU40K09nQ1RuSjZxVUxqbXlhQ3c5RndwM09tZkI2N3VVOU9qODVK?=
 =?utf-8?B?TUhzTGpYK3paUHc4a1VqSGlhNlVtWVRNeDVzZEttTC9JdWVDTm51WVVCcWRZ?=
 =?utf-8?B?OHV6Rkc1OWdocXh5SzVHNzB5dEpFNE1iVnpySlhFRHVremlrN0lTYU92V2ZQ?=
 =?utf-8?Q?+e6lz26Nu6+dff461E6W7CfxLaP5vzaP4O/Kwmh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43cd8862-0e72-4ed9-32a4-08d969cc12db
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2021 02:32:26.2705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zJXtVPFLyPtO9xB0zGkqIH6oNWmJkmOt1grX34rejaa56momh6vKbAHO/2gkigcKuu0MBU/u5AhnbJu3FRP6FEkuTzEGNV5mMSiTzblre48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5515
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108280012
X-Proofpoint-GUID: 5BZiqdQnp4KXOecT9QasWl3IwD2P6SP_
X-Proofpoint-ORIG-GUID: 5BZiqdQnp4KXOecT9QasWl3IwD2P6SP_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 18 Aug 2021 18:41:39 +0900, Keoseong Park wrote:

> Change "allcation" to "allocation"
> 
> 
> 
> 

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: ufs: ufshpb: Fix typo in comments
      https://git.kernel.org/mkp/scsi/c/922ad26ebeaa

-- 
Martin K. Petersen	Oracle Linux Engineering
