Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E72C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Apr 2022 09:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350503AbiDDJOq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Apr 2022 05:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240647AbiDDJOp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2022 05:14:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB343B29D
        for <linux-scsi@vger.kernel.org>; Mon,  4 Apr 2022 02:12:48 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2347lBlh017389;
        Mon, 4 Apr 2022 09:12:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=WOgNCQKsPKnGREmDy/fpv7PCq5hv1L2b/Arr6x6i8lg=;
 b=kfNUu1TfIt+h6NYctZjZabxCH84uAOOjluf4hud/20HtyWhgJN9WEI2TKSy3UOQMjuN0
 JdLsoNu8Urz+8y3/tJDSZ63T5tUjFA7nf8aLJ6BcgptUTLW0s/FZPDA9+owE/ITTWHmN
 xFAz2he6cdboKvvIitUsq8mOHPaBGSk9isQkQcXf3B1wjl4yijt8unBTUx5V5Ac/8J8t
 JFehNy8nijoQeXgozu6axaGhKvF6QHtRfixammIKzSdGE4CU9Mju5yQ74+k1QXZh20KR
 sAWz+hf6wMXxa+OGtTylcPjDlMk0Prqr3ShJ7KbyRITimayfYbEaGxINzJ42hzi7LfSA eg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1t2jyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Apr 2022 09:12:34 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23497UIN003601;
        Mon, 4 Apr 2022 09:12:34 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx209ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Apr 2022 09:12:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kq+HG3Ur5VYAPzFwFsXb7C40mD4nS06pE0+hNJh9bXyt6GtthnIhIK+TK7YIXqxLKUWbrY2Htvt0THGIhg1URdIOUrGpBjnSA12wFptNoYUnUXszWADgqACVPyoh+MzvuoFuE4oxvZKHFCisp6vL2YjaoMsylDHV+yW0ZHItV9LKMViPmUk/QfQ/e9knQaf9WfVlIeH8b8JYM40z16bJdGm6PxbmUS0/PMSkKznqCO0pfTznDILl8K9tEy8x1hSyyBaeV55NVF6DJA7W+wnn1Z61FAdGy22BJ+XgusV3YHVQaUZiXUZLJTWUicDnO/WTTlozFNpLdK2IwFKQpv/bSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WOgNCQKsPKnGREmDy/fpv7PCq5hv1L2b/Arr6x6i8lg=;
 b=IYAHwXjhzQd1vK1ELVD52OKH9FVDAdCBIZ+pN1RetC1ay9n6gCPLBdgynakx0oYd38V2BVfwQAQF8+c2lwEBt2k863e8sRhRTbqE7yoRuarjm2X76JJVJcpZEVK9aL7hy+yLqWvrfMUfMszzT5JR9r87KalChKOtT9dI+bM9k1+KoSqZWlSfGixolOT4TSzEVchFDB/RZMbLCoHbnY7cCR1cb9TFBBT4KVDaNheuW3reJz3Fgfwo3jpyxd6AIQTcdmItUZrxXLva23lE38hOEbbXsTeo6teeKzpar0xE31Ovb4UOEFb+42111XS5ZW2xRCS63iWqXkP07rko/n7ISw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOgNCQKsPKnGREmDy/fpv7PCq5hv1L2b/Arr6x6i8lg=;
 b=snpDN8Z6a89uTmTZCGQmargbov1uWjrD0HAsMlEiFtjiX7nEIFVWQhklbWyivKv96RT7pJ9ewMjKrnUgJ1Ptg6sU28KzTp6uVCdMBK7UWthL7dTwjxN9jCKU8JZ3mAom7FkFkGIdrfW9QnP3t5Ds3yh+ICDX/dyA6Pzz+L02FBE=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN7PR10MB2449.namprd10.prod.outlook.com
 (2603:10b6:406:cd::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Mon, 4 Apr
 2022 09:12:31 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d4e7:ee60:f060:e20c]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d4e7:ee60:f060:e20c%7]) with mapi id 15.20.5081.025; Mon, 4 Apr 2022
 09:12:31 +0000
Date:   Mon, 4 Apr 2022 12:12:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "zdi-disclosures@trendmicro.com" <zdi-disclosures@trendmicro.com>
Cc:     "security@kernel.org" <security@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        linux-scsi@vger.kernel.org
Subject: Re: ZDI-CAN-17016: New Vulnerability Report
Message-ID: <20220404091211.GA12805@kadam>
References: <DM5PR0102MB34776506CDCC1E2FFCF78C4580E09@DM5PR0102MB3477.prod.exchangelabs.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR0102MB34776506CDCC1E2FFCF78C4580E09@DM5PR0102MB3477.prod.exchangelabs.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0048.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::11)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9135e2d2-a927-492d-8e0f-08da161b3f90
X-MS-TrafficTypeDiagnostic: BN7PR10MB2449:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB24492B8F863919064E4DEE618EE59@BN7PR10MB2449.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VJRrtToKVBEtcEyubB5IucWpbfNG0WjuOqmEAcO4W+UDqCNwRqtbmY4zMym1pAAhYXXbrJ7FFB8l88MPl1DwCCvrzR63KcvE20DoUanaCSBOIErSHec+ggy4u2LWFE0V+UeYiaNz/rB3cuzKvsFSHLeVOTOk2JdEyMPJoi3E1QnqbimF4vENtpmTecWg1UkCWcIL4yU59jLnE1zbJMlxueKYyldk8haadxiygT7adN/1Ncq0D40qNhRjsqzw1fk0tGR98DWU4bODlYAenvJIvO4F9LwzDAauP+tK51Rlp42gwdH8jWI+Y49Wn6kpLm0pN9fZhNgpVipkPf9yX4wcXiQWoicK07qot0A5FLDo521TKz9sVPsVTuD9hHhQf98R6KKg7iDet1Eam45PLhwtVmvXVvakHHdnvZR+2yKBRQgONYQ4CsH5x0FUb6dFzmtTMBCECs2shtrY1qoqKcSWt+vQ/ps6XXStYOPB/XIjX5ACuQKfJQrHGQng+eVMh5Hhc2U2EXdzEotGW66SbulZNc6U8W0mjv4NYzC5QqlQfaKn/AP25NA8SmB0CgyS2Vy3Qqr2FWxz/qQ8iZZ+k3hmlwgaIid6PwxXvpKWaAHqi4kuRWlojMmDq9ApETeqWd0YR9KC9uJOMHQBkDsKKw9yFOQq1xx2eUivnJuRXo9QkGo1UbVWjgRSX8RavXEQeCs7a9z8JcktMGAkQpgckoMEx9SYwBhhFKZT5pa1Vykc5LJYUjrPMzPRbLLxEj2xwxolvp9WG4fM1/Ib+PcQeVy8P6DRgGl7sEnlMZedd8njf6M6YODHUaljqR52MrY9J9/ySd/cdxj7YAGcHhG3RzUg2qSQ626UpA2zkpY0vHzEIME=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(4326008)(33716001)(8936002)(66476007)(9686003)(5660300002)(966005)(66556008)(6512007)(44832011)(6506007)(508600001)(52116002)(33656002)(66946007)(6486002)(6916009)(6666004)(83380400001)(2906002)(316002)(1076003)(26005)(8676002)(186003)(54906003)(86362001)(38350700002)(38100700002)(574254001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3+pc0wHJeirsJKy4WothzQweVkadZp2refJxLLodTV4T3f9Qv+IW+65EHPIT?=
 =?us-ascii?Q?B/T/JLS/Vc12Q5e3Jk8xPXIM190cVHyVzEfEGgvdN1viVPVDR2fv5g76t2+S?=
 =?us-ascii?Q?fz/0UZOh8Dlnfi/e/8jYk2pKYRq2yvz82eis4bZxf2xk3zeFRAGWLALmQKnz?=
 =?us-ascii?Q?fCKCc8gvggPWj6SYDOOXzR5S4cqaB+utYMlyVu3OUItjZfpYLxKx1x/bXBmI?=
 =?us-ascii?Q?VEBkPFdZzzFTIS9TWU7EofZhHuwiamJxl9UUAwVuY7u6ieXPQzW1n7BVCA4w?=
 =?us-ascii?Q?KaueEoHOvrgjMdIO9XNqO/eXdfSAepNNMOK51bIc3Hwl4sg5EjBLH9PKQSGV?=
 =?us-ascii?Q?fNVmLWUkRM8LEfoiBY+0ZEeb1riOQ5ZdZVeVrPR7l+c/H0kOZYH3QqbwPbFJ?=
 =?us-ascii?Q?dDIJGBlA5c9fxlc38DfNnXmXHOtwNb154r9pUBHp5ISgP/DZySS7tqR+YkiQ?=
 =?us-ascii?Q?zh2zsuotWPIF4OGxl/rE3CqvNJ1zbnAExtUjXTbw+VWt/496pvjadKpPNhrs?=
 =?us-ascii?Q?oHv6cbAed6OX8OhTcBZf6K/9QtOvz0lkz295GoijBT0FcwHiNotEn1lejNgb?=
 =?us-ascii?Q?uz7TdXmNyVGvJ1zsC9ZaVeys9VMH+NHzyLLcxEk3/mZc+xDsQffuAupC01tq?=
 =?us-ascii?Q?gaKRhc/Bnwmj39LsOJ7Db5cx/ZmNxaOZIdjzIgjah7NCWQQXgaKsMSrbeIK3?=
 =?us-ascii?Q?v0lALz9X+h4pYBEU2xSXkaRWxBhrPFok1Ac+GV2xaX8PAIJ92IqcUtLtUAcg?=
 =?us-ascii?Q?XurLz/P8BUycwwxygqDO6KOl8Yvu+42GMK/Ud/4SV0goshfUtvnqBz1QLkWJ?=
 =?us-ascii?Q?c0tqyYMcrNjeadZ1/aBK0ZUd8/w4mppOPWFCAua0yuZdUpUhuDxBy6XP1G/E?=
 =?us-ascii?Q?0gydOhHU5p768f+kY03g0Dl4Xp7G5X5Swv58MmNkrnoZPH+ha7nA5OEtLLH6?=
 =?us-ascii?Q?WvqHGw0ogKaI4zE+s7EVSzCZo0biBKdUPBMIc7VlHJ8rJkeJczeYW7KVj0A/?=
 =?us-ascii?Q?RDy8dkSSn117fhsqeFLp7rPrdJiF2padRWsaGMEW7i7ZDelEZEkSGPTWJw8q?=
 =?us-ascii?Q?qwc2zVcjz+qJjuPT2QPzJnCyOC8IdZYM6oBzvANSm1VszIiB7A2z0YKgwfN8?=
 =?us-ascii?Q?6MW2tVj0kxK6dRn1xbWblb4vhSm3SMBykL1pxkCZRJaIzS2v0MtDkAPOVoVz?=
 =?us-ascii?Q?yvvtmprnfhGq8oLLB4tts6xbut9EMTIFkbLutwew1vL41/4RSmbluyFsv1Uc?=
 =?us-ascii?Q?oLjY4AyjALSHbv2MW+QuVy+XK9BiVewmzVL2iTPvcTtdEsbt0gmIm6Ldu6FE?=
 =?us-ascii?Q?vhygNC6lxYXejATn3QKgkC+RcGZ5L4v5NRvuUl2/pSC+b+cWc3nhJxoLHTUF?=
 =?us-ascii?Q?Sos9iBbStZ01rZHh5cMAihD/Zn4rOWGbIh8bvDLEVe1AioVO+6qiAayOmHYB?=
 =?us-ascii?Q?/Q26BebBfjmgt9ckGyjNO/9xnGI8es6yRY8P8ItRafEIPxDgqzcUYTu7lTqJ?=
 =?us-ascii?Q?5Pt5Hs31ON4Y7cyvmsvn5bXvtPVKdL+zWsrBtlMP5bwqHy0XcLSd+4TiB7Wn?=
 =?us-ascii?Q?DmyotincRNS5odJJz6ZCz/7yW6xVivww5uPtVuTS5dxLxQUHuBBP6wa2qApY?=
 =?us-ascii?Q?iCSFofD9aoYYo/2gDpLjfCJjtxwWvvo3pSSlADI4npGyP6KnHGyMEJ02Qdje?=
 =?us-ascii?Q?sSqpY8KFnDsS8l0kpMVpZl8zBerkyHmPdLbIAbzUuBcSq+OicqnuNjrkNbEe?=
 =?us-ascii?Q?yewj8Fi4gXKHe4ngySia8sgnAwUAXZE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9135e2d2-a927-492d-8e0f-08da161b3f90
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2022 09:12:31.6618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U3b13DND3DV1O2K/+KLyLoyeYxvrqpczrVISKjtgcwappOLpOpo0ytvASCEoQs1Oc+6gBwABcoVu46Y2/3eH7VuSI2c5kp1zUKO7CVDfYfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2449
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-04_03:2022-03-30,2022-04-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204040051
X-Proofpoint-ORIG-GUID: JkQpGcmBv8Lm4O6OluPSb4eEhKoQWoDg
X-Proofpoint-GUID: JkQpGcmBv8Lm4O6OluPSb4eEhKoQWoDg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a valid double copy bug.  I think/hope that /dev/dpt_i2o can
only be opened by root so I'm going to CC the public lists.

Last week we deleted the PMCRAID_PASSTHROUGH_IOCTL ioctl in commit
f16aa285e618 ("scsi: pmcraid: Remove the PMCRAID_PASSTHROUGH_IOCTL ioctl
implementation").  The temptation is to delete I2OUSRCMD as well.

regards,
dan carpenter

On Fri, Apr 01, 2022 at 01:11:18PM +0000, zdi-disclosures@trendmicro.com wrote:
> ZDI-CAN-17016: Linux Kernel DPT I2O Controller Time-Of-Check Time-Of-Use Information Disclosure Vulnerability
> 
> -- CVSS -----------------------------------------
> 
> 6.7: AV:L/AC:L/PR:H/UI:N/S:C/C:H/I:N/A:L
> 
> -- ABSTRACT -------------------------------------
> 
> Trend Micro's Zero Day Initiative has identified a vulnerability affecting the following products:
> Linux - Kernel
> 
> -- VULNERABILITY DETAILS ------------------------
> * Version tested:5.16.14
> * Installer file:linux-5.16.14.tar.xz
> * Platform tested:ubuntu 21.10 amd64
> 
> ---
> 
> ### Analysis
> 
> ```
> double fetch bug exist in the function adpt_i2o_passthru of DPT I2O controller
> it leads to copy the OOB memory to ring3
> ps. we didn't have the real hardware for testing, the POC is written based on modified DPT I2O controller
> ```
> 
> ~~~C++
> static int adpt_i2o_passthru(adpt_hba* pHba, u32 __user *arg)
> {
> ...
>         /* Copy in the user's I2O command */
>         if(copy_from_user(msg, user_msg, size)) {
>                 return -EFAULT;
>         }
> ...
>         sg_offset = (msg[0]>>4)&0xf;
>         msg[2] = 0x40000000; // IOCTL context
>         msg[3] = adpt_ioctl_to_context(pHba, reply);
>         if (msg[3] == (u32)-1) {
>                 rcode = -EBUSY;
>                 goto free;
>         }
> ...
>         if(sg_offset) {
>                 // TODO add 64 bit API
>                 struct sg_simple_element *sg =  (struct sg_simple_element*) (msg+sg_offset);
>                 sg_count = (size - sg_offset*4) / sizeof(struct sg_simple_element);
>                 if (sg_count > pHba->sg_tablesize){
>                         printk(KERN_DEBUG"%s:IOCTL SG List too large (%u)\n", pHba->name,sg_count);
>                         rcode = -EINVAL;
>                         goto free;
>                 }
> 
>                 for(i = 0; i < sg_count; i++) {
>                         int sg_size;
> 
>                         if (!(sg[i].flag_count & 0x10000000 /*I2O_SGL_FLAGS_SIMPLE_ADDRESS_ELEMENT*/)) {
>                                 printk(KERN_DEBUG"%s:Bad SG element %d - not simple (%x)\n",pHba->name,i,  sg[i].flag_count);
>                                 rcode = -EINVAL;
>                                 goto cleanup;
>                         }
>                         sg_size = sg[i].flag_count & 0xffffff;
>                         /* Allocate memory for the transfer */
>                         p = dma_alloc_coherent(&pHba->pDev->dev, sg_size, &addr, GFP_KERNEL);                                   <--- (1) allocate buffer with the 1st fetched size
>                         if(!p) {
>                                 printk(KERN_DEBUG"%s: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
>                                                 pHba->name,sg_size,i,sg_count);
>                                 rcode = -ENOMEM;
>                                 goto cleanup;
>                         }
>                         sg_list[sg_index++] = p; // sglist indexed with input frame, not our internal frame.
>                         /* Copy in the user's SG buffer if necessary */
>                         if(sg[i].flag_count & 0x04000000 /*I2O_SGL_FLAGS_DIR*/) {
>                                 // sg_simple_element API is 32 bit
>                                 if (copy_from_user(p,(void __user *)(ulong)sg[i].addr_bus, sg_size)) {
>                                         printk(KERN_DEBUG"%s: Could not copy SG buf %d FROM user\n",pHba->name,i);
>                                         rcode = -EFAULT;
>                                         goto cleanup;
>                                 }
>                         }
>                         /* sg_simple_element API is 32 bit, but addr < 4GB */
>                         sg[i].addr_bus = addr;
>                 }
>         }
> ...
> 
>         if(sg_offset) {
> ...
>                 /* Copy in the user's I2O command */
>                 if (copy_from_user (msg, user_msg, size)) {
>                         rcode = -EFAULT;
>                         goto cleanup;
>                 }
>                 sg_count = (size - sg_offset*4) / sizeof(struct sg_simple_element);
> 
>                 // TODO add 64 bit API
>                 sg       = (struct sg_simple_element*)(msg + sg_offset);
>                 for (j = 0; j < sg_count; j++) {
>                         /* Copy out the SG list to user's buffer if necessary */
>                         if(! (sg[j].flag_count & 0x4000000 /*I2O_SGL_FLAGS_DIR*/)) {
>                                 sg_size = sg[j].flag_count & 0xffffff;
>                                 // sg_simple_element API is 32 bit
>                                 if (copy_to_user((void __user *)(ulong)sg[j].addr_bus,sg_list[j], sg_size)) {           <--- (2) copy with the 2nd fetched size
>                                         printk(KERN_WARNING"%s: Could not copy %p TO user %x\n",pHba->name, sg_list[j], sg[j].addr_bus);
>                                         rcode = -EFAULT;
>                                         goto cleanup;
>                                 }
>                         }
>                 }
>         }
> ...
> }
> ~~~
> 
> 
> 
> debug log
> ```
> (gdb) u drivers/scsi/dpt_i2o.c:1748
> adpt_i2o_passthru (pHba=<optimized out>, arg=<optimized out>) at drivers/scsi/dpt_i2o.c:1748
> 1748                            if(sg[i].flag_count & 0x04000000 /*I2O_SGL_FLAGS_DIR*/) {
> (gdb) p/x sg[i].flag_count
> $4 = 0x14000010
> (gdb) p/x sg_size
> $5 = 0x10
> (gdb) l
> 1743                                    rcode = -ENOMEM;
> 1744                                    goto cleanup;
> 1745                            }
> 1746                            sg_list[sg_index++] = p; // sglist indexed with input frame, not our internal frame.
> 1747                            /* Copy in the user's SG buffer if necessary */
> 1748                            if(sg[i].flag_count & 0x04000000 /*I2O_SGL_FLAGS_DIR*/) {
> 1749                                    // sg_simple_element API is 32 bit
> 1750                                    if (copy_from_user(p,(void __user *)(ulong)sg[i].addr_bus, sg_size)) {
> 1751                                            printk(KERN_DEBUG"%s: Could not copy SG buf %d FROM user\n",pHba->name,i);
> 1752                                            rcode = -EFAULT;
> (gdb) bt
> #0  adpt_i2o_passthru (pHba=<optimized out>, arg=<optimized out>) at drivers/scsi/dpt_i2o.c:1748
> #1  0xffffffffc00045c8 in adpt_ioctl (cmd=17484, arg=94117499510944, file=<optimized out>, inode=<optimized out>, inode=<optimized out>) at drivers/scsi/dpt_i2o.c:2006
> #2  0xffffffffc00053ce in adpt_unlocked_ioctl (file=<optimized out>, cmd=17484, arg=94117499510944) at drivers/scsi/dpt_i2o.c:2066
> #3  0xffffffff816207a2 in ?? ()
> #4  0x0000000000000000 in ?? ()
> (gdb) u drivers/scsi/dpt_i2o.c:1815
> adpt_i2o_passthru (pHba=<optimized out>, arg=<optimized out>) at drivers/scsi/dpt_i2o.c:1815
> 1815                            if(! (sg[j].flag_count & 0x4000000 /*I2O_SGL_FLAGS_DIR*/)) {
> (gdb) l
> 1810
> 1811                    // TODO add 64 bit API
> 1812                    sg       = (struct sg_simple_element*)(msg + sg_offset);
> 1813                    for (j = 0; j < sg_count; j++) {
> 1814                            /* Copy out the SG list to user's buffer if necessary */
> 1815                            if(! (sg[j].flag_count & 0x4000000 /*I2O_SGL_FLAGS_DIR*/)) {
> 1816                                    sg_size = sg[j].flag_count & 0xffffff;
> 1817                                    // sg_simple_element API is 32 bit
> 1818                                    if (copy_to_user((void __user *)(ulong)sg[j].addr_bus,sg_list[j], sg_size)) {
> 1819                                            printk(KERN_WARNING"%s: Could not copy %p TO user %x\n",pHba->name, sg_list[j], sg[j].addr_bus);
> (gdb) p/x sg[j].flag_count
> $6 = 0x10002000
> (gdb) u drivers/scsi/dpt_i2o.c:1816
> adpt_i2o_passthru (pHba=<optimized out>, arg=<optimized out>) at drivers/scsi/dpt_i2o.c:1818
> 1818                                    if (copy_to_user((void __user *)(ulong)sg[j].addr_bus,sg_list[j], sg_size)) {
> (gdb) p/x sg_size
> $7 = 0x2000
> (gdb) x/10xg sg_list[j]
> 0xffff8880066d6560:     0x4141414141414141      0x4141414141414141                      // OOB read 0x2000-0x10 bytes
> 0xffff8880066d6570:     0xb000007000000122      0x0000000000000000
> 0xffff8880066d6580:     0xffff888006798000      0xffff8880066d6540
> 0xffff8880066d6590:     0xe020000700000001      0x0000000000000000
> 0xffff8880066d65a0:     0xffff88800e6dc400      0xa180005900000120
> (gdb) bt
> #0  adpt_i2o_passthru (pHba=<optimized out>, arg=<optimized out>) at drivers/scsi/dpt_i2o.c:1818
> #1  0xffffffffc00045c8 in adpt_ioctl (cmd=17484, arg=94117499510944, file=<optimized out>, inode=<optimized out>, inode=<optimized out>) at drivers/scsi/dpt_i2o.c:2006
> #2  0xffffffffc00053ce in adpt_unlocked_ioctl (file=<optimized out>, cmd=17484, arg=94117499510944) at drivers/scsi/dpt_i2o.c:2066
> #3  0xffffffff816207a2 in ?? ()
> #4  0x0000000000000000 in ?? ()
> (gdb)
> ```
> 
> 
> -- CREDIT ---------------------------------------
> This vulnerability was discovered by:
> Lucas Leong (@_wmliang_) and Reno Robert of Trend Micro Zero Day Initiative
> 
> -- FURTHER DETAILS ------------------------------
> 
> If supporting files were contained with this report they are provided within a password protected ZIP file. The password is the ZDI candidate number in the form: ZDI-CAN-XXXX where XXXX is the ID number.
> 
> Please confirm receipt of this report. We expect all vendors to remediate ZDI vulnerabilities within 120 days of the reported date. If you are ready to release a patch at any point leading up to the deadline, please coordinate with us so that we may release our advisory detailing the issue. If the 120-day deadline is reached and no patch has been made available we will release a limited public advisory with our own mitigations, so that the public can protect themselves in the absence of a patch. Please keep us updated regarding the status of this issue and feel free to contact us at any time:
> 
> Zero Day Initiative
> zdi-disclosures@trendmicro.com
> 
> The PGP key used for all ZDI vendor communications is available from:
> 
>   http://www.zerodayinitiative.com/documents/disclosures-pgp-key.asc 
> 
> -- INFORMATION ABOUT THE ZDI --------------------
> Established by TippingPoint and acquired by Trend Micro, the Zero Day Initiative (ZDI) neither re-sells vulnerability details nor exploit code. Instead, upon notifying the affected product vendor, the ZDI provides its Trend Micro TippingPoint customers with zero day protection through its intrusion prevention technology. Explicit details regarding the specifics of the vulnerability are not exposed to any parties until an official vendor patch is publicly available.
> 
> Please contact us for further details or refer to:
> 
>   http://www.zerodayinitiative.com 
> 
> -- DISCLOSURE POLICY ----------------------------
> 
> Our vulnerability disclosure policy is available online at:
> 
>   http://www.zerodayinitiative.com/advisories/disclosure_policy/ 
> 
> TREND MICRO EMAIL NOTICE
> 
> The information contained in this email and any attachments is confidential and may be subject to copyright or other intellectual property protection. If you are not the intended recipient, you are not authorized to use or disclose this information, and we request that you notify us by reply mail or telephone and delete the original message from your mail system.
> 
> For details about what personal information we collect and why, please see our Privacy Notice on our website at: Read privacy policy<http://www.trendmicro.com/privacy >
