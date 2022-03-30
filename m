Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE2C9C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Mar 2022 03:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242280AbiC3Dbd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 23:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241623AbiC3Dbc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 23:31:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358AD2AE2D
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 20:29:48 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22U3OrAb016969;
        Wed, 30 Mar 2022 03:29:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=jnkrzWKHWrgIvsg5Q5m7KoK7Qf0ooAWaGNy3TvfEN5I=;
 b=DuxUzyudPg97Mo9+DBTMQ3tVm83zbuSvkK/ZRJfISJ7/8qZX7yyR40HYLCa8DLK1+QxO
 ha9gDWxDduhZjIyTv8+9fFALNjY2GyfurtxDoAHSusQQHhB4IvzH53KsQcLu9AewgXl1
 CgTKB7x1PHyAsI40r7hyyk/WJbcLUnD/hcjlfWwx9T+RDSHVQe50ZhhpdG+cBFVTxPf0
 qU4gpoONwq35l20sDiFT47zR4F7Ai16ZJJQRIMh2NAScJrS2H+J11xL2+Vtt9d20Dbrc
 EY3fi/7kpdFRZttdph4Dq5mx111q3v/spl4v5TUy3G13Oix+HRdDQQc2BnjmOkNfspAN Fw== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1uctrcs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 03:29:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22U3IvKR125886;
        Wed, 30 Mar 2022 03:29:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3030.oracle.com with ESMTP id 3f1rv8e7q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 03:29:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=diksw33xt3khF9eTk3BC1WdOk6BTEIQ+J6fVnghdSeZGGltwaskSJfb0XrM6GBQkvuY+y2KXyPoaWIJWyutrhoLpEZT7Pggc2xr3Ce+dMm/Ei1oVQQ+t6yzVLzFa8uNXbzvIxGQMvDpRqNV2Qul1hhJ87t96yzuyTtaAUx7nEaF94qUK9GPP4NogSBMCIZkh4QB46DnAH8COShkNFVR2kwug6E/M1Hp8ezGetSkhfzNwxtqGyh9GowEbd6yXVTKlWdd/3pohTD2gHj3dNyCoyVgRo5fhhvj0lfOvgtvGMpyHizB7QqfwmlUnMGMKwzoQLqbrMhXrMtVDOYNUSm18kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jnkrzWKHWrgIvsg5Q5m7KoK7Qf0ooAWaGNy3TvfEN5I=;
 b=R4sQyFk3/u8xQFCDfPGbF3LilPrbsyQvDfX5NEqyGW8VmTVyes69E9hderH4L03rtJe25UhqzcdHswd0qHUu/sNm4buVPsiDWCkFIP7WiwiLATdEtKA0elSzUn82sCx+ckpuUjn+OCDdc+ZynQUSpdY13hxzvC3e89Zp4retR3HGrZPRrk5QpRNx4pSQhZcHvQ3QZ009GyYA5x/F5tjEEfDeyhIQo417kZia/MkE2r3XMFZcWqs6cqeGGveDHZ+90Rk6EeDOF5xDtQyMlj89J6HTMV5dEOR3eZu/kJrz0x9q2yC07H5aYNC0SY8x9/lf0aJKeg52+8QgaekEocAcgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jnkrzWKHWrgIvsg5Q5m7KoK7Qf0ooAWaGNy3TvfEN5I=;
 b=rJNO0tIoACxn4ntCJwjqGdMCtIq9AXx6CnDS0Vz2IJihF7TgpiXPeAzevmIy785EaTKTqbUuns7+BzD8ha+NlRAT/t8ITCIj+z5VXM/cNlCcFUjrcAk+QpCAwIXyyjnabSm1nTgNHtH3Z/M6GKTMZPnkOvj6WQylX2z9IK8zMm0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN4PR10MB5575.namprd10.prod.outlook.com (2603:10b6:806:206::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Wed, 30 Mar
 2022 03:29:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5102.023; Wed, 30 Mar 2022
 03:29:36 +0000
To:     Tomas Henzl <thenzl@redhat.com>
Cc:     linux-scsi@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH] scsi_logging: fix a BUG
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17d8cw224.fsf@ca-mkp.ca.oracle.com>
References: <20220324134603.28463-1-thenzl@redhat.com>
Date:   Tue, 29 Mar 2022 23:29:33 -0400
In-Reply-To: <20220324134603.28463-1-thenzl@redhat.com> (Tomas Henzl's message
        of "Thu, 24 Mar 2022 14:46:03 +0100")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:5:40::42) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12ac2bb1-050f-4503-96cc-08da11fd83b6
X-MS-TrafficTypeDiagnostic: SN4PR10MB5575:EE_
X-Microsoft-Antispam-PRVS: <SN4PR10MB557505E9B40D02EC1DFE05CB8E1F9@SN4PR10MB5575.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I77z6ZPcA8Dq32Vo0LRMvS0LlpgvPbwDJwCvUeKoSg9CeeuIBcWd/2dL99QymH3csf3wjuVjQyZCAunZPrFYKB3+gkfFDM3b9WFAnLuUVYnJXfIJvrCCzlvkD3TBWZT16lUsukGySd2x2xyo2VRCByVap5W1SDgoY9Pj4bGdHh/YmSwLZy+yxCgU1ki1HM0Vrhmb3HntH4OkrIVx+GX8w3kPM8+7JP+EUduB3f7xoA1IhHj5Y+/JAmVzKQ9zmlqtKdMDwV+TRdx8upfhwGj315bejs0vpAb9dOI+VgRbPMon4e3Qduqa7V5jdUGxxOXoSlweDy/cj7P5jRNATRKN0/gYlJMdxCMCAfHLMXpMQPeDfQ3e3v37LQ+ll1BM34dS5BwBkLLiGS4ucqYULydHOaj4qJTTeweCgO5bPCnudZk46VKo3dI9V988kXKyDLeI5AiuGW6vNKQwsapKzDfVGS5M1pIlXUWr+pg5v71Z9B8sahDjgrMKRfWt3jYHDjGVu59Z4gyRbgVNRBXE2ecA6YW72uyDJDjqNvuhi41gNteT+3gPXKZkZfLhkv0D4Slzkv6Bx8V3E/Xzo7IZh8kTOJ5bvDj3n8NuQ6V+5P7utXBx/R4Xol4vqllk4Hc+8+SPhD+EUOheW7AemIGOlt+kMxtLoHwHX9R+rEeExpXdBxHI4xKUdiYrBWVv+obFN4yFsefAdsjBsIR4trmVy2RkVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(5660300002)(66556008)(316002)(66476007)(86362001)(6916009)(8936002)(26005)(4326008)(186003)(8676002)(6666004)(36916002)(83380400001)(6512007)(6506007)(52116002)(558084003)(2906002)(508600001)(38350700002)(6486002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?amjupNDZ3QhY0EYHbwqY+I2CSO+PN94HWmzucQR1zUDpQjGaFSwws9Ds7VWC?=
 =?us-ascii?Q?YtwByjLp5SttjEEyZMIVFN54esJSZUaEPvCyJM8hR+ORNzIWf97BFEjXS3zl?=
 =?us-ascii?Q?+DuPY2mU1EEzWMjqXy6aVOAcrenEjzstioinkxWYilBbOEBLIbyVUVSFNLL+?=
 =?us-ascii?Q?sacvOVWB+rI48eRIYugel6WYe84BBNnAoAjsEhmjYa3Bd1+2wHvMEhpmEAwc?=
 =?us-ascii?Q?iW/hGdQFJs6yafcjNJT4ar7+w+Sm/Xwkkbo9j2+sCHPloWC3QnptQ/lAW/WB?=
 =?us-ascii?Q?ixa1FPL1ZT+M8mHUHEVmOuYcOtygWJZ06PsY7uYNmUVvHIIFX5BeASCQ1Z+u?=
 =?us-ascii?Q?96zmZeIUeiAYougibEWkQ39FCPnO+L3INUzkGkbNTSlgkxzmMl9pwxtozQD1?=
 =?us-ascii?Q?UVSpfmJ84OFKS6zWiZSVArnAlPnnVCLs1yMcwmSK9od3RaeftyTxFf4SiZXr?=
 =?us-ascii?Q?yhqZCboCzhZYObnogGq3mPQlHUvrj0LHIvX3RyCuLApJXX/1JyEHi2lzSXSH?=
 =?us-ascii?Q?qgomVd2DTkwjMMpOXv6A0wEzyNMDX9h85aqY6NbTJE4kB/Fu3HH/KB0HhDzn?=
 =?us-ascii?Q?4Z8eoEqwkjhW6GzkLkCvczkrhgVaBVSLcKPKysCKPe3eGGlHSlRZPJm2a8RM?=
 =?us-ascii?Q?vVPqOMtvcpzgBPb6XHXHFEK04cGdIhnfpUL7DeGWoM72cyEVwtiAm5BX0YDi?=
 =?us-ascii?Q?xABnkmMV+BL2+la8LVGF19YYrmZH5suHlk6gi3lWnNvPR0J2EqWKKZzNqGoK?=
 =?us-ascii?Q?IAlBZohp/eL1BVPRTAZmy4TdQrjDPH3+3I/SH+mR+EEbLtaApol2QT59JwdM?=
 =?us-ascii?Q?DoHwVfh8BZaVNiL8Y/RkOlHGVMzggM32yD2Xt2MH0RgLmszMUV9hIQov/wXG?=
 =?us-ascii?Q?IE+biD0EnFecw0cB4PbMfAAb1KQnaGxd1pPJkUm0Hqy7m3K/tW0d5cAVY0XA?=
 =?us-ascii?Q?iyMl1npHsHnU4mN6qzlb01qmFDkXbwIs2DOt8FGLK9fpwk0i4x/kivGjATlb?=
 =?us-ascii?Q?x4T8Bdn4tiMVsCoEd9HcpY5PW5nbXlRpAdR4Ktml28i9j6rGDOUxRkhqeyzS?=
 =?us-ascii?Q?2vMMdW6k+PySh9v06mCoIyIIYNYuo2Y0S4RaQTdb3QdCTdA4syWYjFhnsioL?=
 =?us-ascii?Q?ChHkJ8js6DuI7cr5JqcA2kP5LK7+97xmW1rMwj8NF5zTT1S13K9qdjGtO6Tq?=
 =?us-ascii?Q?w5DD575JOjRggVuJ8oymcJlvHqgDe/C3r1PJ9Hlwypw1YabYcEy0d/g/IdKI?=
 =?us-ascii?Q?Y6vHOQyzo61seM23HnxG/23e+ZpPdG59xgQuXqprqsZ3Zae4jUDMAIQO0Kmd?=
 =?us-ascii?Q?MIQQY7beUOLz3R1QhaXJ++L5sU3410honGcjWOy1vQAjFoEnDn3AXCFTgMOT?=
 =?us-ascii?Q?EsqBP1uOJvlQD46MyCWYloW391ofKUPr9MMvy6U//ZFjcWGm8A+L8xlSGDCD?=
 =?us-ascii?Q?Ese2Slf1HCzMKZhfxYTUmL4+ehX8hFsI8c5nnmw9zlJYSnse2PyVbb28zbe6?=
 =?us-ascii?Q?GcXvDcA765O4poIUhYjhug8FigREixIPrwjLgNrSG+TzsRqbjw+ipogncjzn?=
 =?us-ascii?Q?Vv05DO8Djz93u/xKBrnXhsvyGyYTJvN9T6I7MmlR9cCo3IraBdJl3U3y3xyu?=
 =?us-ascii?Q?tZLhjcW7us80m1YxyGbh7Zw33fNITLc4/jINGqgveUSAwNqK17NMUJoDCY87?=
 =?us-ascii?Q?yQbesJ4CKwAN7zF4bFWRf7G6bFCvzDrjLv6BVDam+D2HM2johmJzFFmMFqHg?=
 =?us-ascii?Q?efztMWMuUyjAxQiwZWUlNK1i4gbdRZI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12ac2bb1-050f-4503-96cc-08da11fd83b6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 03:29:36.1619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ccDj6YqH3wqlDCGGIwmW4xRgRl6exXqugLmNur5xREvAR0sKw+5F7MtE1HxocmwzELJd9E5p2KTxowibTTu6Zv0+mE6blhKon1qM+dXCfKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5575
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=658 spamscore=0
 adultscore=0 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203300014
X-Proofpoint-ORIG-GUID: MLHWiyGa_8cX4oV-ZlI0Wz6kBzV0nMaS
X-Proofpoint-GUID: MLHWiyGa_8cX4oV-ZlI0Wz6kBzV0nMaS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tomas,

> The request_queue may be NULL in a request, for example when it comes
> from scsi_ioctl_reset.  Check it before before use.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
