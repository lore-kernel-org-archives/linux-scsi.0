Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE83FC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 10:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D56B861053
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 10:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhKDKuc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 06:50:32 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:25506 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231245AbhKDKub (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 06:50:31 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A49i7pE030982;
        Thu, 4 Nov 2021 10:47:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=UXeCnZ8J5qOjP0hrh/nx14w+noPOuwPFsjfltPRiKyQ=;
 b=wvOsZE2Ij2hqs/61/P7JxekIUnktfIKO7jyRH0WastXxYUDcQKBB/c4MTXp3Od5BLIQl
 xZK99Wfvh0wIGGNX8eN9KEvFS3w2xvOeAeaxRA9xe2WfmtbsGTHjXDTl4dmx9ou9aD5K
 D/4lnIbnQE7RoBctKQLmU7Mx9d09E/x+ELJ6hrkXfMf/8v90Y4DWq9Zj6PoESiU4e+qg
 by/M8T29hAzPCQKK1JA31Z6M1PtvhMmoZtFrmXidD3GGNy3ntUtHlUXKOLLPgbYapDOe
 1HWOJL3x5t6o5ecxitubktTyCtuPN2UxTiNLAsElHbMtMGI9s9ctDl7Hb54noTnZy+7E fg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3ju70ck9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 10:47:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A4AfhkS085035;
        Thu, 4 Nov 2021 10:47:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by aserp3030.oracle.com with ESMTP id 3c3pg014t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 10:47:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=na8pzLsqRNmW5YrkXpeomNYMQtJE11D60UBTcL/FjAQA+NpVvrCU4Ts3cPhrXwuKx8Qpi1mpf5qRbbJf7SwVCG3/34HFFBsSEQA67CDkCpeRP/paBb3QIzXr+C9sgKwMiHab7F7gx5of6e3fEkf+CM507NDNgTIJvw/5AlUeeamSJd+1V4W1ehe6u3m/7RXDBJeK7UrnZC6kJ2IUq5pUy0peJ9JtzKGCyC4RVNanppOEiR+ms/n+AwPf91u211ggnBJmj3LaGo55n2sA5YeYfvflc9KbO26qJpXOp5XuwuqxZxdDczmDvXRemrX73BUmOldo4rGDR8HCRzvulHOkTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UXeCnZ8J5qOjP0hrh/nx14w+noPOuwPFsjfltPRiKyQ=;
 b=VxAlgqWefp5sMRlZMddnChZosCQsK3YFbzEy7IR0u+Jb0WJ4cw+eCec/sWIfyHYulXPDyK+yrgx6Tvz2vBg7NcAQA/k6RrV/QVVznXmQ0xqqHjXkjjoiN8YncFWI8Wv0Z/s2DoXHmjlLgk9egJnKq9KBOH4+XkFFp5yZOiE8FuPcIv+94pXZV8UR2/2303UO4G+LuwpOSkajePyouSz1clX5BZ6Gnn0QNBXK74sHHtfDVrKGbbLlN0mgPKZV1tQWjaRMF/KTC39XeklIokOfRkuArcn3Q81vL8SGppjgCDXU665zZuQJwg53JRK2JtVy97eWwyharj1W/EcUKm3Kkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UXeCnZ8J5qOjP0hrh/nx14w+noPOuwPFsjfltPRiKyQ=;
 b=tQpaKLfAnEuYy2JbKPLV/b67OPieRTf0pTePBUn+L8SZiOOWa321S8zNkRkEOgDg1/TJE8gn/pZrfQs/TAX7J74ua5P0yshA8Jq87XGxrEhz9wjKnMXzevDuz7UUxrULT3Lx8GKnT7u/T72+fRkKU0Jgqn0EzNqt3ONwdOV7xVg=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1886.namprd10.prod.outlook.com
 (2603:10b6:300:10e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.18; Thu, 4 Nov
 2021 10:47:48 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 10:47:48 +0000
Date:   Thu, 4 Nov 2021 13:47:27 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_debug: fix return checks for kcalloc
Message-ID: <20211104104727.GA3164@kadam>
References: <1635966102-29320-1-git-send-email-george.kennedy@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1635966102-29320-1-git-send-email-george.kennedy@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0016.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::28)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNXP275CA0016.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 10:47:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e46fc55-612e-4aca-4c7b-08d99f808a46
X-MS-TrafficTypeDiagnostic: MWHPR10MB1886:
X-Microsoft-Antispam-PRVS: <MWHPR10MB188613C35F05B103A80EA0748E8D9@MWHPR10MB1886.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 42Wj5zVgBbbyeoH5+bjdbO7tjjnr6Th/ENfqX0g3YqKXX2en08YYg3B6BV8m9ML+f/l0Fc+Mi3SGIgg2Abd3R9n6mV/Nn03iTOO6C7rtkbtPou/t4sFaDdLriN8UFYW2ejbZGNdQ6yx4dWNiTo5hCkkrOOhPv1x19xzdi870ZJHjU7dJf9RL8wFfn51TbNkDqQzMPNOuES3faxyQrV5g4CH1L2eu+reJ8adAij74rYawrdhf/u8oyu+9lT0YYEF+4OdjkvX96Nkir47A4IeYtYQapGv9enkt6p0SBcRXMV9EkteQySMeU47592PlBUDddycQgSWSfJ0eHwpWg/bf5ECpCD4BY+1CPjFGWjf0pVYObR3gU4/Qt8liY/S8QLEazyIfuXTaiMJJnP5asq80PVakhRguLwC7RxNUFUVyW2GKdgezrGfw+pc17m26y+cZJMu8uJyIHBFgrgPnQBLakSk/rcI0UECE6OMu8i3ZSNAYhbFW+yNx7uyk8fXsv9dKBAjmcwO2BYkGS74d+FzkjzFxOmH1YqXGXkhs0dnyQqMbN9YNBmPzBQb1YjvvPDCbojZx1qFye1vHXXiuGSqeyN5IIpk4w4r2JDcgOqPUx/bPN8uf81PPb4gUGAYPcbrI/EVOvu0kQ28kCEbI7+jodDe8sk/jbXWNbCLj8G2u813QiUHVoPRlhYI1lJ51mUj/lEUJnQ7FvvfZTwgzKzo6Bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(38100700002)(86362001)(6862004)(6666004)(55016002)(38350700002)(44832011)(33716001)(83380400001)(8676002)(33656002)(956004)(6636002)(9576002)(8936002)(508600001)(9686003)(1076003)(316002)(5660300002)(186003)(26005)(66476007)(66556008)(66946007)(52116002)(6496006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PtaNMFfTnbQ3uTWlTN450FGHRTM+X+6Z/AVrVehi4P05vYZpvDMQ8qe3iROG?=
 =?us-ascii?Q?A9lUmbP7EGAQmg1RLwC8F0IGeqaKRbWaABMMhyXgIUckDBNez5wYokdbEHOm?=
 =?us-ascii?Q?1B3xewNKdr0gB2qpf5XjLUzfmR6sJkiVo6GOv3rS2ixGDjNPv/9AUZ6BQC4j?=
 =?us-ascii?Q?/6+seueQ/d94/jKobxjXulAcAsRly9hj+RPzePU3LSj2TiXhIwlfq3p/1sdm?=
 =?us-ascii?Q?9Ku3vuAdsJKCuU0vbA535Y/2iPZm2MMbbglqJSWVQjytqQnNTztR+DYqyt+7?=
 =?us-ascii?Q?il6jPpyhQajDz1viHWWOPZC2ETeFBL7VNcvwru0DiJ2ysjqz9ovfe+OuGmq4?=
 =?us-ascii?Q?xkKhCGl8KhFyrEcyLzMEnWRk1b0zSxS5UoYfieU4jw1IgcpEM2KHaGA4+6WR?=
 =?us-ascii?Q?a0iMU+tE24qkNJIh61pZ7msLvQmsfl4AWl2wopU1FnZqKGpMroftGw8f6Hzl?=
 =?us-ascii?Q?3BqcGoxq80w0ShOFdfhtlOfevAIG+dASderyJnK7zrKGTRgVIeEbNXvBjRM8?=
 =?us-ascii?Q?F7CBc1BJUGQgP+L8KswBKlxzpMchFUPo6aBYVRWJhLG9O/wf8GIuXeBCJH9V?=
 =?us-ascii?Q?sCJcb7qe9FUe9cDabHYHw/H3g+lWTaAEh9OUB/JFRVS7bYITsPBJrLDnrk8a?=
 =?us-ascii?Q?Jk+ty5fnVyEl9vz52PTrbLfOcx66R+lKREKDiaLHz1SdwUJbVvV8CzGbkf5G?=
 =?us-ascii?Q?T26X+MNCimSTFhgrnHWzXOx2iWDgDDZaPmHmEe/sw9kakflBuZ4T3e0OMQ24?=
 =?us-ascii?Q?h5Xsh7aAXcouyV3ZuJXhfy3xjxy+I7VzLRz+78k1CoGePiW20OStKSxHRzc9?=
 =?us-ascii?Q?wqsx9wUO/JqqzRUPhsKolyJfKMQicQY0wV5Yb9Mctfwvmgw5VrtFLuyrBf5x?=
 =?us-ascii?Q?1v96Oh7XERVYj47mONsnZB9HaSNOLyCtkKOn2/g0rymJLbnjcMrY1/XpvfMr?=
 =?us-ascii?Q?KLZsS3rxISzMg1zxBXCXmE2DzfePX84dJIG64fsUG9bNf7BEyvtkxRhUkQAI?=
 =?us-ascii?Q?++VTcP4WmnrhvqFTjLycHNkf5jo4tEfyYLLYLbiOZ8Zq3nBlkqly1WWbz69g?=
 =?us-ascii?Q?/WyNLd6APLT/AYAZHb1a7gH2IGcptz8lHxorrCsIYWdD45v3fEyEDsN8iw8N?=
 =?us-ascii?Q?d06gj9JuPm8B3IHL+MwVZq6Fjd/pS5p2PFwaaFxVG+RGG76HES59DrdMRBJD?=
 =?us-ascii?Q?mniwnitaxITFK3qBkc2VrqM6irpe5Zc5HKrdQh2BXX9DTRbjiIAKBHYyQx6u?=
 =?us-ascii?Q?4I+SKa8/rfoM3iNRFRafoAizGjrMhdYBSB6YWgmunwUwcZi/r0+rSWNHJTdD?=
 =?us-ascii?Q?4sSuF3uhub6deJAeVASVNHB3EBH62JeWKlMLhSRe8kMbz9SMDSkn/HWIaDxq?=
 =?us-ascii?Q?lF81RpmK1Pmt1ZQ0el+oHv+y8MOB4VqX8tUDC3pBA9t1jmXT1xn7+DGEWYN1?=
 =?us-ascii?Q?KMHOpQ5DW4VcXKh7SkjBCNCrMzdz9Vp0W7AbfqXvMUmxuFnOt3/l49B5L2cx?=
 =?us-ascii?Q?CjirLnCRf6EiwHh9B79fbAz8DN0LXpi0/vwLNrbGaQKUo29oHbD4N8GUL7bd?=
 =?us-ascii?Q?bO9ujksls8zFyczA3Fssi59T4lduD9RanEIP1XloXgStZBCYV+wbKXav0y63?=
 =?us-ascii?Q?HHwAHtep4nZsUnPum/EM4H7oGnBOkd3AQCIv9nqSp2j8rgmX9zMDu4s+zmEu?=
 =?us-ascii?Q?xGr8MyGUmpSpnoJ5qRPdTKoYfeA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e46fc55-612e-4aca-4c7b-08d99f808a46
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 10:47:47.9184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hNa8KlwxPwKVZYw/44XzloDLvtZxBvF7r1kRKJirZowbeWcuLQY6xbEOto3VzKUT5KjDxFkSVH1Cse1++TBvSBmFKGZyzcJInwVDXALhB0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1886
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10157 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040043
X-Proofpoint-GUID: tr-ECLsGJ_gVI1rTF47mZM_cf6pghRYD
X-Proofpoint-ORIG-GUID: tr-ECLsGJ_gVI1rTF47mZM_cf6pghRYD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch isn't right.  It has no effect on run time.

On Wed, Nov 03, 2021 at 02:01:42PM -0500, George Kennedy wrote:
> Change return checks from kcalloc() to now check for NULL and
> ZERO_SIZE_PTR using the ZERO_OR_NULL_PTR macro or the following
> crash can occur if ZERO_SIZE_PTR indicator is returned.

ZERO_SIZE_PTR is when you allocate a zero bytes successfully.  It's
quite useful because you can do:

	p = kmalloc(bytes, GFP_KERNEL);

	for (i = 0; i < bytes; i++)
		printk("%d\n", p[i]);

The for loop works.  Zero bytes now like normal thing instead of needing
to be handled as a special case.

The IS_ERR_OR_NULL() check treats ZERO_SIZE_PTR as a valid pointer.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 40b473e..222e985 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3909,7 +3909,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
>  		return ret;
>  	dnum = 2 * num;
>  	arr = kcalloc(lb_size, dnum, GFP_ATOMIC);
> -	if (NULL == arr) {
> +	if (ZERO_OR_NULL_PTR(arr)) {

kcalloc() only returns NULL on error.  This check is Yoda code but
besides the style issue it's fine.

>  		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
>  				INSUFF_RES_ASCQ);
>  		return check_condition_result;
> @@ -4265,7 +4265,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>  		return ret;
>  
>  	arr = kcalloc(lb_size, vnum, GFP_ATOMIC);
> -	if (!arr) {

The rest of these are correct.  This patch doesn't fix a bug...

regards,
dan carpenter

