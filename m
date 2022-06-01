Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1064C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jun 2022 07:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350210AbiFAHKM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jun 2022 03:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350192AbiFAHKL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2022 03:10:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250B668FAC;
        Wed,  1 Jun 2022 00:10:10 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24VNxOJr018543;
        Wed, 1 Jun 2022 07:09:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=4EyY/3M6M4JDpOBnxAZCwggbVNtSlSICXpAa5fFwuo0=;
 b=VH0k6bg2g+siE3qFAsXdPP8Jgrnn5hDCJ7xwfP5WPQBk4xKhCqV+fyzKpBiwd9/+MEqP
 m67wRZIQkuq8BwhxKyHODF6yCs6RNBm5r6i4d5mzywlbRFmpr8G+hWR5BUV4UUKprtK6
 LZbL2p4zHQuuONPxA/3LXj920nXRWO4OpkekMiAJjtfAHs3osvaaE+T2UXIv/cUDCCYj
 FFdHVrVSG86AhlP/sMiUQMWrVYLktFBQkJj4GDmNLoK6kKd+hii8gmqkhZ5HYYehv3An
 g8fRghXoowDLQQ9MAm/wVhynLeIq9a9KRISZIIeWv2YaVL3JjEECCXQ3PC+mb4hG+aOt hA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc7kpsnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jun 2022 07:09:56 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25175grU008745;
        Wed, 1 Jun 2022 07:09:55 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gc8kgskgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jun 2022 07:09:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GljggaKo9R8lXTiZBWpA0wdIgHKnaEofyvDmKxHtpLMyMlzEu0d//8mJCkAeR/VvLfwhmWRtKSwTjaAR9cSIi22C4nhyrriynSHjBoJpzn+yWuK75BccwmQWuuqMrIJYJr84FmNiw0jFw7EulwrQDgi037Q0C5p/4hPjzbNWgXLgrK+BI/lXibJJNc95U+KNORwplNlh6ggSZSh+kIRuCFmZ4w9uN1iSmzNGwLZ22Bw03dN278ZrSgz+CIlcj+RgFtNrfj4sxEATyrdvNp6WHuZDbe2dOW7xaQFGHp3pYc8GWET5SgX0JewslorYn6nKdGMSQUz4+80ujL403kHlwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4EyY/3M6M4JDpOBnxAZCwggbVNtSlSICXpAa5fFwuo0=;
 b=kXdE4ePsy5jg82KwbEaFNJaQrYfv3eT3kCzb+zjXPDBKfkG7Ke77ZCK+Yq9o1oeC8ebKGJMU5DSzf4jS3yDlGqm/xbLdECFuKYb2Pu5IkWIXfr5kyfPpzx+EbKzR08NPswVYHLy4uU3iHs3+dQi/ACsSJcmLJZkpChYHTEjlLPY+wu2484n7DedkiAt4zk+FmKvUC68MzWXaC8lUrwXiaWFApelo7BBM9uCYCtLyUlad2TcTvqWWtoySmXDpZRilkms0s3Yzk/6MZV/43Sz2Z4s4l3QARP3/PBsa8ygPPDMbKBzBKOFSTEAd8oUvngpG4zXP7cxloAdUPHBcxvNIog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4EyY/3M6M4JDpOBnxAZCwggbVNtSlSICXpAa5fFwuo0=;
 b=CqBNbw438RzscE9fGqS1uJyuusubK7I1by9Cu1DBS+VFfrOLDitqTDCo+Z8nG/6GXefg7+5TODGs1SU+dJi1x2c2X3UKfy7INccUEa0m0PoY1X2N8cSYIp4Qnn+0eU2JPcRVRsSRDmKL0S5wEcvxcF1ZKfaAHVNbYiUrijEMH1A=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1584.namprd10.prod.outlook.com
 (2603:10b6:300:29::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 1 Jun
 2022 07:09:53 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5293.019; Wed, 1 Jun 2022
 07:09:53 +0000
Date:   Wed, 1 Jun 2022 10:09:33 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: clean up ufshpb_check_hpb_reset_query()
Message-ID: <20220601070933.GA2168@kadam>
References: <YpXD4nLc4iCxpw91@kili>
 <DM6PR04MB65755C66140BDDF550DCE75AFCDF9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR04MB65755C66140BDDF550DCE75AFCDF9@DM6PR04MB6575.namprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0002.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::14)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58c62c8d-a86e-40b8-fe14-08da439db9c1
X-MS-TrafficTypeDiagnostic: MWHPR10MB1584:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB15845430F60A82BB47B3537D8EDF9@MWHPR10MB1584.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZWsgN/kAbXFKi7qsmZ2o4bk4zCWY79ixlthStk5gLAFOzVTc3sNFmKfxhHHUTtp5eprVXF+KhmM3t/YeADz8Dy3rtuy7p4r3hCvJ86nlnH6tP59N7symb9KN84R9d+Piaf8iDKGQq7LZSZ5omf8REknQMk5jHXEPjK0y04QdOBtMaDgRQuT/5pCNKx4QJ1ch8YWWY68SScKMW54tgWs7cDbLelRbXrIIBzNtP+ePqWbSMiyGx6+BIiimK031aOWnVp1TkjTkAsW5FHtVfv1lBjejCM5YZno1MpDC6fo/HANHI7A/gVc7Ecxy9bR2xZeCu8TmcSYP6ZT0SxCzvuwbYsVzMLCh3pEBeKnbyi+JlcZLCkTqLC4CF7z8j0KW015wC+AkmjfTumyYu4gQ1opng/WKXxecdNhUZtxkbeGSEiXAxhm5k5DPlf5pFJpHPMtjUuS5VyQd9hCicUQO0L8fKkBPxTKZb17W7eXd73lhntsNKBoo6Yuy4Xn0O8bwRjdVwLDpS85+Fdruh+bho9vRBSQika9skwcVRGj0uwqZTESlJ/j3AsSSJ/YXUUncSZqWzBm15p/r8tAJEsALdaevvsqMwPF8v1OpyC6ZxEInjx8V8vzSRfNfVZUVaOowXaxcZ7ELiVhIePasVlW0yrTmOzOJGelAT1/y6nsjDf+5OOZ4jwgeuG4M8MW+BaijzFH1+OeiDy0Xb6RcKHfHwD7WDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(2906002)(316002)(33716001)(6916009)(6506007)(9686003)(8936002)(26005)(6512007)(52116002)(54906003)(83380400001)(66946007)(38100700002)(86362001)(38350700002)(5660300002)(66556008)(44832011)(66476007)(8676002)(508600001)(6486002)(33656002)(186003)(1076003)(6666004)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pA5uHzL4MSn9uWqON4w6KyU7g/JbwjVh27dwcn6+da7wyFrX/NbHVLriuL0p?=
 =?us-ascii?Q?51hdhdnP/O6rViUBvZxwuoi0N0p8OztNSC+hS/2rMIFUiQV8Op51rIkUuP0+?=
 =?us-ascii?Q?EA8m75ouahmJVkZoreV7u6lAEE1IYYJKA2qL4oNVIu5qisqHvIfgyWFp1dVU?=
 =?us-ascii?Q?YiZeORdr6FvBXt/FeLmjQRpvOm1PVTcDvJo2/uzaId2xOZHsa3xbKqD9g8CN?=
 =?us-ascii?Q?9httjWJShCA9c3DzkxeyGsx9MnJu+Kfmi6M7nMi19hgUrSsQkehjmalWWcV3?=
 =?us-ascii?Q?OXAX+ZOn38ww9r3bL78jFcLrT36MLK0CaiUmfEhIJPVVlGwKljDgbIv+Thxv?=
 =?us-ascii?Q?Sscyz2yraGXSOsvPx+sdR1dShkEdXHMwKSy3uoDKweYvSZonCxMSxMP+78E5?=
 =?us-ascii?Q?fugWoLCtALy/7w0dRnnvgcjOHxOOtx+GQHh9tXqYHrHyvZ/UHqvOOjt6eaAD?=
 =?us-ascii?Q?GjDPkRFIt7Rh8BlaYcyUdlIaRdaCFHC4p5+z0EZ+E1r7W3ax5bww+en7XUEV?=
 =?us-ascii?Q?lit8ldoZ13d6REIDsQ7v5951DvVwCj4HbzMd+cLDko4IcGYYU3Q8bZ90YrXG?=
 =?us-ascii?Q?Z0s60Ng2EEuWXSwcU0DpkKCXNNW5K/0HQmU5Cysy1E34YJ4HrRIzuhKWVKno?=
 =?us-ascii?Q?UtG2c9lRMotYwJvCQOqP1CElm7WBwr8zCY9gF/AyAS9VWuGFGculMRWPVVER?=
 =?us-ascii?Q?qKFz2P1xe8PR94bzR66ygL9kXEQ1oS8KAi2Q6m53XvXaNgeftqR3iLLGwjSp?=
 =?us-ascii?Q?KJDw7aqemyV7j5iRHXF3rZRDznRanvssDQE6ARad09TPYccE0OeZvF1HFBbU?=
 =?us-ascii?Q?u2hkfHgfr4MZ0GjBrn8QQhvROwtRCkQ9utejT/L7ZMXWkuHmYvICo5GXCD+p?=
 =?us-ascii?Q?irEYhUY9WQEqQx8tTPBm2cdzyICDGrIG9RWHofceqlRb8WvhoWF70hd5nLyf?=
 =?us-ascii?Q?YuwPmCr83sVmi9ruwjweMT3Mtp+yLcUOEiHWKVfM9IP+UBGytMp9Xe6UFNHr?=
 =?us-ascii?Q?JAJOipxK58xnVaGdLh3pn1VKW0c3jLaz6MzdASt9zWHKMworKZTpMh+33wZJ?=
 =?us-ascii?Q?5F/x/cumuv64HodRM+XDvTof5UbiBIx8LxLg4JoZb7CbmlfcMrSIAr8X30ex?=
 =?us-ascii?Q?5fwHqcDbKQqlwZXtt5LwCk8YUEVqHzUdcLM5yMJyaX3oWCPL897YO/WNofCr?=
 =?us-ascii?Q?wVc1YvgkW+e5JwKsQy/6Y00sVH5kAT6Faf/Y/G67lAuI+5DjaNR+3Mytindc?=
 =?us-ascii?Q?lx34B30lVTEtB7AAxmYKGM4I29UU+IYQikf1teIXGby/Zao4QFIl7SxwORG4?=
 =?us-ascii?Q?Im87oigGMixGgvExJ9YD2ytavlkR+dlHFfjz6Q35d+KFtSHZU3nHCWKa1mfL?=
 =?us-ascii?Q?SsNnl17GojXfyhQEMd1quvbkEnfufViK3FZT1j2psKdglbGqPtRzq/qdpcwm?=
 =?us-ascii?Q?AR6zvN+fgx6TeMrs+vPoDnAgwam9D4K7LXMv523b1NEpnHTgjWtUGIk6eriv?=
 =?us-ascii?Q?RHLz0BmO2hCjWZJReMMmqQIxfpvaWVaX7N0jpmSHWzhtMQD8KSkd7QtOU+OZ?=
 =?us-ascii?Q?yvxdWr9nMlfUv6BEh36hm4RZaqoQ4XnsvGHVD9cBJgqCMJRiUqkAzHiPELSL?=
 =?us-ascii?Q?7nJVIxH/135qC9RgGSRsQuO4DwdHsw27gnI+BU1WvfbYN27dv5Lk6DyjDZNQ?=
 =?us-ascii?Q?XcajZvtCPZ1cJL9CCN9G6chnkDQ3p/s5bDiwXNzTf2jsv0f2YGh6OVA0Q45v?=
 =?us-ascii?Q?aYmCSe/YxlMO3FB16FhJB4aGa6bTBpo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58c62c8d-a86e-40b8-fe14-08da439db9c1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 07:09:53.3646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eLNI6dG26IigwUMcyrDBcYQdZC8mfqeZaKpeA2xq7miymJGMOcCypFiJ+kj499H9Mlo4rQUAtotrt0TCNfjoRvIW8GijSFqXGoc5f+4Qvzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1584
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-01_02:2022-05-30,2022-06-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206010031
X-Proofpoint-GUID: FEebA57Gj6M5lk0cL4DSyvslpHoyfOOM
X-Proofpoint-ORIG-GUID: FEebA57Gj6M5lk0cL4DSyvslpHoyfOOM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 01, 2022 at 06:25:01AM +0000, Avri Altman wrote:
> > Smatch complains that the if (flag_res) is not required:
> > 
> >     drivers/ufs/core/ufshpb.c:2306 ufshpb_check_hpb_reset_query()
> >     warn: duplicate check 'flag_res' (previous on line 2301)
> > 
> > Re-write the "if (flag_res)" checking to be more clear.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> In HPB Reset, the Host set this flag as '1' to inform the device that host reset its L2P data.
> The Device resets flag as '0' when the device inactivated all region information.
> 0h: HPB reset completed or not started yet.
> 1h: HPB reset in progress.
> 
> Would make sense to me to contain this logic within this function,
> Instead of returning just the flag value.
> 
> Thanks,
> Avri

I am not sure I understand.

To be honest, this function is not beautiful at all.  With boolean
functions, the name should tell you what the return means.  Examples
are: if (!access_ok()), if (IS_ERR() etc.  In this case the return is
not clear from the name.

The second thing is that I really don't like returning true for failure
and returning false for success.  Returning zero and negatives is good
but with true/false it should be true == success.

So, yes, I wasn't super happy with this function either.  But I just
did a minimal clean up to make the returns more clear.  If you want to
drop this patch and write a more extensive one then I would be really
happy about that.

regards,
dan carpenter

