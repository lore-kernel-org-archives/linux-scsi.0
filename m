Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5313C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 03:41:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244993AbiCODmW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Mar 2022 23:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239264AbiCODmV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2022 23:42:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CD647393;
        Mon, 14 Mar 2022 20:41:07 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22F3WUBk021992;
        Tue, 15 Mar 2022 03:41:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=F+YHFlKDRasSy+BGwHQCK6PvL24q/+9qFrHWf04XAEM=;
 b=Uzj5wtrXQJwV9Dk6Hgt/ax2FFPPg5DHRCLXOpq8TOX40Ay6iM/5oe842cwqJfsSPE16u
 j8nvUp6jX4Tsu8X18PBeIoyjXM/BKCKR1s8edRp1SmTvDumzUbdxnmk6kHuoRPpQ7HDw
 xz2R7chx2u/5/uefSyFOx5CiFhhUUCil+PzDBBI/Dr282/nNH9OKyRi10P3bGbirJRqs
 2mXKFnEnHuxHgE4qJB8ubDH9vOgj6yBE3DDeu21wK9gkvWQJIX4ZukIoAJp7RZZ0aMtJ
 AHK8ha29eI3v3ZKiPiul2DztKMaO2v9XvizRjgFj3qPhJwnkhz15tXzRyB0ObSfS+xuh tA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et60r9v1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 03:41:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22F3Vtv5011726;
        Tue, 15 Mar 2022 03:40:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by aserp3020.oracle.com with ESMTP id 3et64jky3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 03:40:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wk/cpHldufkNWT120dwSgKxEVaiIwT5/bVMZOCsrLLLw4Gi5QSuyFoNsWGXJxW1wNAucPdVDTdq9Wq15hJSRewp/mLjaWfZQx3ag5Frl9oDJBXtXTvd+S9zDfwbnZMSuiXzyt4PY5VR/u6z10e1yCIonbtnxsLG78/+ItQacFnltUtFluuNBn1cxRyPfgcKvLEPODyaRWSBp4C1L1e/X3BgvwAnUgS7sIml4xIdVYhfFvrrZZdjWdhawptBBJjnXpkYggQ6PMJygh9Ktyr3diNG9IJgcjzahYLniV29v7fB6pJLwAc3/xbWpdFrBUPwobZIJm9oUycSjP2O+z7TH7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+YHFlKDRasSy+BGwHQCK6PvL24q/+9qFrHWf04XAEM=;
 b=hgwlrCgAvlisHoKgzaXDOPU1LyU8Di03GfDUQQGAVPSGeV2/g6oY6hhnJYKxgLGHLn2fNsnzC/bzfLEL8XLMvn5MonC0QSyK2TPaYYRUp7n9T3VGRu9EtXnVOCxcOYhxEM4VfgrhejfP9OE4vnyGS/Gu/kr3uRON92q++uDptXcfcfFPtgocHU0Yemfqenq7AaWyEhWHJFRpxYO9AJkt0LF7XponW7haQ6ryK53iI8v7RfRtE9A9PXrNq3x5B+9UXCcPxbFEKNjyQjbnXyGX+lMvn0Fy6TDiS0uQcw8+dn5ewWftXkNTMO3WVmHYDOHvXogssEFbZuip6nCyNNyRNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+YHFlKDRasSy+BGwHQCK6PvL24q/+9qFrHWf04XAEM=;
 b=DFe5FSfNTq4kBXA85PfalE7G0ipNB45hOQY1zPdtLk8syprUxsEQsYWFS+/QvkW72aJGhfKHrglzPSg5WZoVGq8PlhihteGEFpZDmsg4K/Bo6JtVITpXGztMy5Ja6yddm0BnNeL92IG0wKs4/UH/lgqFrRL5B1uCi1Q6QBi9puk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BL0PR10MB2883.namprd10.prod.outlook.com (2603:10b6:208:73::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Tue, 15 Mar
 2022 03:40:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5061.029; Tue, 15 Mar 2022
 03:40:57 +0000
To:     mingzhe.zou@easystack.cn
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, zoumingzhe@qq.com
Subject: Re: [PATCH v3] target: add iscsi/cpus_allowed_list in configfs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfrjdgvy.fsf@ca-mkp.ca.oracle.com>
References: <20220125083821.18225-1-mingzhe.zou@easystack.cn>
        <20220301075500.14266-1-mingzhe.zou@easystack.cn>
Date:   Mon, 14 Mar 2022 23:40:55 -0400
In-Reply-To: <20220301075500.14266-1-mingzhe.zou@easystack.cn> (mingzhe zou's
        message of "Tue, 1 Mar 2022 15:55:00 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0259.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9dc3c7c3-25a2-4f5e-ecac-08da06359dbb
X-MS-TrafficTypeDiagnostic: BL0PR10MB2883:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB2883156711E3315C422BA8648E109@BL0PR10MB2883.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XdxiA5PEgtwcVj/HpX4HDhd0QkfHftMtXMWzrReuQovuYzIhMpcybUCWeTzushKQW+8Z9bXHSihwadkTdVOe4P+A0Lw93zFFmyngK8JVc+bUDtzlpsgDN36xhcGyUatjrvzngXW05Jgft1ZZkEq44ZTY7u5ELjcWkiW08NEhb3bR21sm3yU43WdX2Wca+2KLRKakDyTvMfNIHkY3n8o841UtbBLXjxGmZoOmTAcSJ7jGjZrSEVFAVLLsMcfnPzqB3JO3ValHhc8UjhlWUNL8wj5iC0m0G7LaJkkdiceP0QJjyvnANVLTOEfZVnt2MiLF05XgBGwf652oyyI610liZMztMJz/c4dxYJtTlSttVItaXhNc+ysf65k+PsP0mlWVfobDk7k0ITJjr2zTvq/JnXhuFrLCZHwBK4rr1yd8ailwyQvegnCjyyN+pIk99+8HjPtGuxoWNwtNyvT3UH/BhfaplYnHF4vECxosJA6SXpxZdIsEmNARmLVUe6CDwjKUDdA2QAFNtbigjSMMZj6L4X9ze59TPTl+5GDc5yiEQSz1rG1xm12+Ih4ycAnNNgarOyX1LK7ZEMslXUWiAvmdNUH57ngfVZ0X1lvHJOhGqcHwV2x90W4K41eAY4lyV/15RFbbRjVBaSC4BLpPgMV5WI7FgsEuBeP4vXBik6/Zqml6IoTSczzX+FXBEnOb4YZ0e1zMklDMFLoniB7QjVUCJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(6506007)(52116002)(36916002)(8676002)(6512007)(66946007)(66476007)(86362001)(4326008)(66556008)(6486002)(4744005)(38100700002)(6916009)(38350700002)(2906002)(508600001)(83380400001)(5660300002)(26005)(186003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XycrM0tx11yDttV7OCSf/g0Gxd8+p45enQEnWXmN9EmxxVPHPYUAeSW8yHOl?=
 =?us-ascii?Q?nZnGOwbrJ6uLz/FypKrkQ+4L/S3qcjZkfHoe1ePrCoLShhlKJO3mM7PkbwE1?=
 =?us-ascii?Q?JzykRbeeJFxgpLTvVYcMrnBpKXmhso3KJ+62QelkX3uNJ3bn0FVYj4BORJAo?=
 =?us-ascii?Q?Z/R7wH58aNkkr+PYNNCuCCKSEi9gwm1ysshn1duP/mh63WP4J/aHxvEqNjA+?=
 =?us-ascii?Q?dSLeArE3RljEmJ2iGkEAJr66XAGuiX9IuEsb0Zq8ev0uSKI16A1bYDO8XMHh?=
 =?us-ascii?Q?YfmEvcHsTW356CThmE6WPxIyE+QgywI8lItsCa7KbKF/bLBEYx2RhrDZrq9I?=
 =?us-ascii?Q?wbWw0glvFO9MfVnCxZf1hSynd6kJTWk7WWkiJ7FtWPzIfTRbViVrbNSg686e?=
 =?us-ascii?Q?kUdBg6TYTi9PfIdwqD7GgT6vc3Ivb7MNqEPpFI1nxbwdes3OKsZjgs3QQAA6?=
 =?us-ascii?Q?0Egwrt1sTmPb+XQEf8Vuu5eAVrvc5kbshJ2N+36tja+INDkGqNfPB1vJBKaY?=
 =?us-ascii?Q?5NBJd7EpWv/lLSA8GHqmuPghw4fBxpw9ZChcUxCmaoB2yqwcofvNTYq3pwxj?=
 =?us-ascii?Q?KFla11sYGeeDyCgF0MZzVV9Z94/sbEdaeVjudyALKAad9e6eN/2Cti4TxHJw?=
 =?us-ascii?Q?V6J/hOQdYXUE7cdpyxYbRA+eLQzyjdFHjN6cfWp80gMWkFD8QPWKFavPn6s4?=
 =?us-ascii?Q?sMdCovvi2Kylc+8Qsp3tquNbcP1ZYfe1remRYUOwE3pEBQ+iwhX5TzGllOhf?=
 =?us-ascii?Q?QPwm4R1WjRA54agpRoHuRY2/fhl/hf0kzbh/2U/C8QzsCWmWBrrbfuuS/900?=
 =?us-ascii?Q?pRilwF538lMDdedQrzdSQW/GTwU7AbxuheofsLzneopqUBLN2gnVp+mmGilD?=
 =?us-ascii?Q?gaJFkV/EcMBExPpBZ4AVR/2EKGP3EIlXkYaHb8Ca1yUr1IWCPOqVw0dJ7pXl?=
 =?us-ascii?Q?rppSUIB/Dkcy3+Ij/T1Ib3iyCAmnFpQeWUub6TavQF5XMvFq7TUqdCZHbjol?=
 =?us-ascii?Q?P3eDfJLrCjDAwCqUyw+FsD5pa/SUjNgcYj7kDWyjp4CHr+lf2zuTsJSIAbh0?=
 =?us-ascii?Q?yBasCdud3OlOMc/kCHqJtYe1Kn5jhdEQRyCOUaHXeg1Gtx5u4Fo+MjUQiqlM?=
 =?us-ascii?Q?y06YVr4mCv4NPIAvcf/OwcZ2EdqxISorPXqfDWM1Exe4ark/9H59BfTQwc24?=
 =?us-ascii?Q?knXR8wZP1YcNLC1Fv8nFnYIMy1867VsBKY/WlNLYy3Xd6wApSXnisx248aKz?=
 =?us-ascii?Q?FboemsQHM7aW6sIl8N0NS9wH6tOeJUGHVZ2/npI9eEO3GCfhSR0Fahc+787Q?=
 =?us-ascii?Q?Kpz0eCyXvSG2m2urh9jViPbtrgdBfdF6Rr//Hbbb/xS3aLXdE04dl8xzRFHM?=
 =?us-ascii?Q?udw5W05SkPwISZWoFWdyaJZNvIKXoU39172ueMpbzr4K+/CxvZGSM00wrBLn?=
 =?us-ascii?Q?J4en9PDJXfRCbK30T+dVaYsqgf0cqwsMWKrw+M/9Ib+TKcmpGJZGMw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dc3c7c3-25a2-4f5e-ecac-08da06359dbb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 03:40:57.6812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QccE0lFf4t7ylB2A55P4SLgkruH2ESwK5n+kSi1T2M1VtlD0TF4XaKyXO/sEKkqrUZW7qKvZNUbRwmvVqg/dTksK0r+JG28VbJuZiAbRUZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2883
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10286 signatures=693139
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=607 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150020
X-Proofpoint-GUID: TF8MgvTbCSOKlm-qFB5iFnsMg0WUgR9g
X-Proofpoint-ORIG-GUID: TF8MgvTbCSOKlm-qFB5iFnsMg0WUgR9g
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mingzhe,

> The RX/TX threads for iSCSI connection can be scheduled to any online
> cpus, and will not be rescheduled.
>
> If bind other heavy load threads with iSCSI connection RX/TX thread to
> the same cpu, the iSCSI performance will be worse.
>
> This patch add iscsi/cpus_allowed_list in configfs. The available cpus
> set of iSCSI connection RX/TX threads is allowed_cpus &
> online_cpus. If it is modified, all RX/TX threads will be rescheduled.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
