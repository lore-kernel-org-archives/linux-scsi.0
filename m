Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44005C6377D
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 18:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CE01631CB
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 18:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhGVR03 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 13:26:29 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:39482 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229716AbhGVR02 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jul 2021 13:26:28 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MI5qdA023217;
        Thu, 22 Jul 2021 18:06:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Ab6lNbODisIRaL7GiO+GRMlTVRKtdImzwv/A46BmRcs=;
 b=sWW/xQ7efhb4feU43fFAaFh71dDj//X8zsEN20HWQ4MHPCDMtLejLSuOqURLZ07wHCPV
 xxf+cuR92YoNq6tbli8oJltujbCyh6xv2f/wFLQcEy2nkkAIST9qk4JU40SO66JzaK+4
 RGa6she8G12dWH2XB6++DbjX3sE+X9ddSRi3/aeaOrHddgWHhQflr+bqKRS431B/WjA/
 agE0EkQGSJpw2Wb/zGenXLq2FbYIKweWG0V0cclElilRb0cPm3li4wqf5g/j1O6iLESR
 7nWaWU2ql1hRet3vXa9HKsaYg6P6lw2BT/oPzHqCq2juKTdq5iERErPEaF2n2yuBcME7 4w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Ab6lNbODisIRaL7GiO+GRMlTVRKtdImzwv/A46BmRcs=;
 b=vpTMbXSF1a+rfY4YFuAdhbYrInJpwpo3p4yXQD+VeY3LWFmGfDM2aAGORnm/8jHWc4jK
 A3w3qUzXgv6WL++yj3vqHPA++LNONPyiw3ta0/TFDL8JrjhS3fvZ6tBe9CupQ3KlAnq7
 wm5U+puPeU2DAGA5rqrU78jC1FqOQ/MgNXFDahy6zdZTexagvP8EloqVgNMl5YsX9maJ
 Q3uSLgbZ5G8OlG77tWehqVDIne+dpWX/0Nm2EDO2NF+lDo62VQV+V8ihaxuYXN0XNsFt
 raQgG2w9PFq185Lz1fneeZCZnBVkoYQL6txzrUxm3WyGzhfxvZC4kJi9uPlXDG3p4/z6 XQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39xc6bvcee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 18:06:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16MI6aGK023103;
        Thu, 22 Jul 2021 18:06:46 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3030.oracle.com with ESMTP id 39umb5chf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 18:06:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QUfavxxde+K2n1IaZ4M9t8J7rAqydVGoPDFvHtxOedcd/+B5L0/G402fh063sa4WbxIgfNRAGDrSh3y0hwLdc5jzpppDyLxHGcyv8r8x+P4kkdfBMFSeqIT8kzfWE5J19CW8sSjVbMUwJH+NTUbZpzNb0jCEYmoVAE1zrs8hH+vMe83A8FZAZBdSzPfsWx0PBf1MORM9pHMHDojBZPS/1Q6i63GhTGuezuvchl7bP29mJWH58Jo6ppYaY0C3nIrbnb4cKTVEkGukhudbujo2ptCpVQTqCQtZU1CwtXlheS/41lCkri8goE9uML95ua/LZ5t4wp7F/ICBX4LWQB1grA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ab6lNbODisIRaL7GiO+GRMlTVRKtdImzwv/A46BmRcs=;
 b=kDITyxyaG6a9SvLc/J1nf3nFCzwTazrTW92Ng5z3LOzkp7acu1Weo/N7PnyBhOr4LWOIbBXRQGqLJiGmi8ucK9DZDbhQDGcroXg4Js5zZSxLZ2/sLKPxm3UUjGeBIYlCYeVKNg8jb7Eb3VGkvl2rvWVTxSKFqDJ5eaIzY0VbWgQRHpXND7vzwasnqcCYgoNkPXIkQBoVP+4m3HgnJcf3sTptXLOJsRmY47FGICxL7Nv7MLJevA1c7JLrTQ/OA+fIDUaXsRSK92YCWB7cIrn14DP3UGEwRtCJ+2wiF28KRWIF+PKMd+KmRrdLVMzgqq86eIMlG4fgU7nhg8+VZ6mzUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ab6lNbODisIRaL7GiO+GRMlTVRKtdImzwv/A46BmRcs=;
 b=rz9hls5gEVbcAGMMUnmjEzkafVbc8GWQWbFXXpEDz4oxGJNsjT9f0QZqwL+/nw/xgPCPX9u53mTbiXrUWfWNT2+7Q688mWWzQVER/4okX9BylraCdRc9oR1ubagsqtt2wYEORxhFRo+x8ijdiT2oKiRng1VE/X0ne1kmwrErZak=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5404.namprd10.prod.outlook.com (2603:10b6:510:eb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Thu, 22 Jul
 2021 18:06:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4331.034; Thu, 22 Jul 2021
 18:06:43 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 18/24] scsi_ioctl: move all "block layer" SCSI ioctl
 handling to drivers/scsi
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1im12w7ik.fsf@ca-mkp.ca.oracle.com>
References: <20210712054816.4147559-1-hch@lst.de>
        <20210712054816.4147559-19-hch@lst.de>
Date:   Thu, 22 Jul 2021 14:06:40 -0400
In-Reply-To: <20210712054816.4147559-19-hch@lst.de> (Christoph Hellwig's
        message of "Mon, 12 Jul 2021 07:48:10 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:806:f2::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7PR04CA0030.namprd04.prod.outlook.com (2603:10b6:806:f2::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 18:06:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e71682d7-94c2-4b34-f86e-08d94d3b7668
X-MS-TrafficTypeDiagnostic: PH0PR10MB5404:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5404795445F66F0F6EF63C5E8EE49@PH0PR10MB5404.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N8dcZ6ByFw4l0kCEfzuFH80f8BZRLVcDfh5Fg3V/i+Mer7gb1IJ1703AXg8BxAywAxQa5/OHfVre0bmKMeLInBeTPNRoNLm71zx2SUf9GZ7mnnuDc7iWI9s3Ok0ydUtsHYh5CNj9EJs5sAtB5BmRkOOF8ULja0TSGjKR+4LS/L5Gt7eDw559eNsKD+5XOUSHZax8nsjlMFvZreKMlF+vayRBkKyEadMppiOskJ4bG0tBx31hvxwghzkalIQ49TaTKN5VIZ70UWBdQet2dwW/ASoOOQd73DnvDtIhd4a+jpsjqd06tVj7m3VoBMpCo0y5w1ouw6it4YhlfcWLKbQIq8kRDkPFuRW9Euhd3KOzt6MP6MkHfyc4V+0IJh0yCrKhWaoGgCjLFITXmjpQMyGvp7+6xnXsIcc30PF4M8rENgPaX4Gw8PXYU5cIdvZI7P3Ye7NAljNRNt2bKh/FkUW+xlhMlVmCn9pDshG7MRTEfWKoB0gWMRIpWloeJbZYV2Tn0esJyJ6a8sJlwo6xcW1J/GcUMcprZZiwZrBOX5UYFkmscBPzNF04iBKoUtbwS7XsqRgCfEuc37jvOxXHFEV6U+PQMdHm/yMCZFHy3xZfseHP3jqLAROdm9xP02BJ6m05mDwaST66DPMqzXfbeoIxcJ50o1D2yuoi3XdpKJTpFsTL66yxiNX63vJXoNXDrJ+gidettoZ7lwXhuIr9/UdsrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(346002)(396003)(136003)(186003)(83380400001)(26005)(54906003)(7696005)(52116002)(38100700002)(36916002)(38350700002)(86362001)(2906002)(8676002)(4326008)(55016002)(4744005)(6916009)(5660300002)(66946007)(316002)(478600001)(66556008)(66476007)(956004)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fY6wb2t6jQGMqruUo8OtwijaDY12raBGteiUBj4gfrWWF/0oUl4Fazf2Jkjz?=
 =?us-ascii?Q?amc0r9wVX0AUqtKY9541zvJm6aUYa8qxMJjjqPE+36Nw5KTRFTdbHdNvjR7N?=
 =?us-ascii?Q?O1JOZcoR0zMtodPzyOvTxEFuh7TgK9SEgSNBTV8nscuXDAszEuox9glCX7XQ?=
 =?us-ascii?Q?i1EvjjpW7lQG526JWr7Y/Cg23V8IbZeOHv8M4WcDjv/IWLT+XGClySIKuXGc?=
 =?us-ascii?Q?dPOZ7jkuTblnIgNkOzuQ5Pwxpd3D5Q4VCXICdiiqItk3AtYG4ETAqCIvynsM?=
 =?us-ascii?Q?KjAX0c5e4S5RAW2nrjt8NLqU9y6DfOYRytox4lqmD0hQOlwgOJAnL7JegtTm?=
 =?us-ascii?Q?W5d/lHdogFdqrFV71xA158xU8fFeBw8gM4xMrUqtUo+954h64sKPSYTNJwon?=
 =?us-ascii?Q?pZeM75boXpaVGQMWOmsbUYCiiEN4mmlWgCMR8bzWxhTAP2Eoc7pDCsaAxcE2?=
 =?us-ascii?Q?cePsR99khDZHCdLr46I+CmVgtOMfJFq40xQS0Kk36RIkX7C+IjwC5A7jutqo?=
 =?us-ascii?Q?BIrRfYIQHHhP8jYDe8rmX0ePYRPif6dYTmaQpdieKvFw7oZDPAOJTZFpe57/?=
 =?us-ascii?Q?CPcABdQvN4lSIZ7Ju3byX+NB8BJXutlNLVkRdfiiT/C6mKkxGlDkOchMK8yG?=
 =?us-ascii?Q?QcdIKmxXbZfNsRbvFDSI6MtV0f7ilRhTV2U0XH03gvf5FtJZ/FgH84EdYt16?=
 =?us-ascii?Q?5bQV3cI9PMFTF8QEnHSy42/UEDRAE4ljPvaq7wdSSTmprN9KlRjaeYUUgwrA?=
 =?us-ascii?Q?bigq396eYBVW1a3njFE3aPl20PqMEktOzPlxxCNjCdMW8Lkj4sKD9XvyX2yS?=
 =?us-ascii?Q?ZFxA3E0kQIiRGSEvq9YIcXy/1b1LBJU36iiqtpPC/dysWVXF05ZOk5NoSKam?=
 =?us-ascii?Q?aI9mt7zPXWIcIo8ZSMP1QtHisZ+ZgjDJu+Yylt94KtPX/K+gGZXAdkc4+OWg?=
 =?us-ascii?Q?LHgCw/ZY36mIFL5rSIM3p8hlAWCzxeYCeEWarC/Q37IWs8sWje2Gsg92w3bl?=
 =?us-ascii?Q?07u4j5Bph8UhyteIrB0bcBbHWcfMuMJZ4NvDfT5UgLntXKVHJ1wGeWXoucK2?=
 =?us-ascii?Q?R9iFOYIR9E6lUVOZzi2p6ObghGykPsgS/uEKyjoPWwStwy92Q7TjXdFwKDsM?=
 =?us-ascii?Q?k0Row/Sm1coU0/CcM561zDUmPPuHOb7lIDpLqDVhvvS14NDYIQBc1RuoPz4P?=
 =?us-ascii?Q?2o5IATKMSoPEmN6+W8PHEn/VcfYa32sjn364TMO8PI+HgIfAOW7Fs5ris8zX?=
 =?us-ascii?Q?N/IGb/NQ1Il6l5rdv/gcSdKLu7627X8vsIV5mBXLTaX8oQPi0Oecow60yTDv?=
 =?us-ascii?Q?kAH1n91rQqOYCM1o58t55B7x?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e71682d7-94c2-4b34-f86e-08d94d3b7668
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 18:06:43.5860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I5V15GLxXqI6oeYdFvfMhDq9h2IuFVYBAjvfhucmMhfsFu3ypUCewXh/dtJDYpTqK+n9Xz6MgCCVy0uYE0A/hNkCKz8bmNs3RmoT9MKdaso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5404
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10053 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=791 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107220118
X-Proofpoint-GUID: 5dgAIRotVAi7NKImBPec7Nvh5dyCxDMN
X-Proofpoint-ORIG-GUID: 5dgAIRotVAi7NKImBPec7Nvh5dyCxDMN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> Merge the ioctl handling in block/scsi_ioctl.c into its only caller in
> drivers/scsi/scsi_ioctl.c.

> +static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
> +			     struct sg_io_hdr *hdr, fmode_t mode)

[...]

> +static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
> +				 struct bio *bio)
> +{

Another couple of peculiar naming vestiges. These probably shouldn't
have a "blk_" prefix now that they are under SCSI. Since they are
internal to scsi_ioctl.c I propose you either drop the prefix completely
or make it "scsi_".

-- 
Martin K. Petersen	Oracle Linux Engineering
