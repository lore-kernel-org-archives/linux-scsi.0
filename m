Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA975C677F1
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Jan 2023 00:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjASAre (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 19:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjASAr1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 19:47:27 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD86F61D57
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2023 16:47:26 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30ILmjLE013638;
        Thu, 19 Jan 2023 00:47:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=zzlQC1QgTwpGhflt/i1ijNSKmKHgQ1XPeeA/68BRS3E=;
 b=lbBFvLLdVs29ulO7TB9+dDOdUbEch7RXSndcPH653ZQWzlITr8PCKAd3Xbm9nvKJFApd
 3g5EokJK67web/l8Mv8dcjkxZerXRe0rSV+t6ksrBmT6so5FgEJwqIpuyDW9U1cqgc74
 1yBDHDVCHYTXycd7nK5QZiqq5ikAwGjr8PstsaQgqZxfkxBXz43kAPwdrliTcGWCfGz0
 3acNHNSrhqdFzwK5uzTFg41A/jarIlyh1Zb1nIAVfvBO7uWnl0HWNAIHX1cleIO/9tvg
 VZgrlDoYXM7WmGuckgKVTDdbzoixrUBcoHeCJOUNU57GEdHZrluYAzYJ99lZ9d2aQHP+ TQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3medh3n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 00:47:15 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30IMFXsI029563;
        Thu, 19 Jan 2023 00:47:14 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n6quayj7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 00:47:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rrwm8k+RJZQPHHS1gS/prNzXeujz/SGU4xV0n8I9do71gRoe3yO374V3SH10HKySOc1FQ1pdN+bK6xC8JP81L5WM0QsIkkCMTy6BS2QAh9Pu6O5R7eNfSwg5xVie9yCtvLolUNyC9OANpFyxtr1yC5XnwtI6p2XRL7NT8I/J9OAYKB6wUbulJVDq2yGNdl7dOr/5ulg9Yk6wmdqR/HZdz95/eG9IctX/jA8RidkeYJlKLwbXDGYSPMkhTAMn5g09uXzb717k9frkCGW9C7vqBhi1UwFGzkjTX3GxVZ/wCqZ+j6wvgot42KvSlTLnk+tEdzfQcuVPie446lnaFUrDcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zzlQC1QgTwpGhflt/i1ijNSKmKHgQ1XPeeA/68BRS3E=;
 b=UmdvmLMRZih7YFlhk71i4z8LSx/AUt7tgHyVLMj5q4nWu0S2ik0Bi4m/JH/J2Ix9j8FkjvH8ePc1HASTTqCbXi/0IfyNZhf1e64CxFqsw9ovyQ8ybhXfKLJjZuuB+rNaYfCssuzxLO1eNENWVY8B4Go/YUoOjazKqXqsK4U3z0O1ab2/DWsuaFQzfiDDnQZ+3ljLyMhCgfhqWhJY88p8kgh4W/LWr/x5Kd6+QxsXLbMLodtE0AocbrfSIEeimnq9uvrMYEFKz+VT1BqbtAVeMMty+7QCrhNonQqX7cFP7xhExjj0ePLF/ECGFiXaiQBvJF+HjeAUqcBxMTg7ucKDKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zzlQC1QgTwpGhflt/i1ijNSKmKHgQ1XPeeA/68BRS3E=;
 b=kbcegPsmCXGABcMpKoeZoOlDkMuuCcW4PxXCHXA1X2oNhDHVJHoPDi3c1T74b+lFRM/tB3Kca7kMT+IcVDw8HCKPzHkPxDhxwStZBdcHD+96yQP+XWj17cgEw9xcG1sW1rsTTlzOkp5TPWGlkG1OjZ4UgSEsDlMziZ3yIHNZdLE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4267.namprd10.prod.outlook.com (2603:10b6:5:214::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 00:47:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%8]) with mapi id 15.20.6002.013; Thu, 19 Jan 2023
 00:47:12 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     dinghui@sangfor.com.cn, haowenchao22@gmail.com, lduncan@suse.com,
        cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: Re: [PATCH v2 0/2] scsi: iscsi: host ipaddress UAF fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsc7nyfa.fsf@ca-mkp.ca.oracle.com>
References: <20230117193937.21244-1-michael.christie@oracle.com>
Date:   Wed, 18 Jan 2023 19:47:09 -0500
In-Reply-To: <20230117193937.21244-1-michael.christie@oracle.com> (Mike
        Christie's message of "Tue, 17 Jan 2023 13:39:35 -0600")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0241.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM6PR10MB4267:EE_
X-MS-Office365-Filtering-Correlation-Id: 39092331-fa94-479c-980f-08daf9b6b39d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vazbLOsJ7LMAgdkdpgDX0uLk7QhLC3CoPdCa4sq4Oz8xolqaBP2otF7XHa5pASRNiJ+6pwWjYLYybfXohE+mJbvoE9C6//iBDoPoEtxvYR6Pi5hDQLjNUBiC/06xqg56ALmHfBM+wHoDQ2V57gB6CXpKqgd/BbcX+ijHPzXEmKJSOvliCCJE5aHjPABS8cggCTd0Ojyqqtho4hzOvW8mK+O6KXIJIn9G0Mx0kXM5PaZA2QfY9MyipR2viBJpzMWk81o+IMtP28lVErPMD4Lg/cu06KBuRJ8nI0pObCso9A8XS/VXVdNPa4jSTjsfX+Jyf+/Rbng+JFtRKLsIGs9ucSJLnYd/0m9cieKHAr/74+QkoYB9D/8WJSeWS+n/1HTJniUeaGIwDyLarMp/fA6kdIM9dhEeirh7NawlGFtBKi1C1dtlZq+yMh6NiMFGM7l6xksDM8mVumMmbGi1aKsrt0yiT15ieZJ+Z9KVeyqTXSKplPcEIFd5l6sq1rtinobFAUGdPmVUszzu1f6Zi4WJNnE4GB7VEiO6iT6M9I0S3yKU2KNN/2itfs7h5R0aQilkK2xV/mYvv3W/wXEsR9UEeKR3dRvIkfsiYknrRHr5uXBpWcId8/z8zO+5qnbJKo3n6CQSpu3TpFXuRvJJFOFxVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(39860400002)(136003)(366004)(451199015)(38100700002)(86362001)(36916002)(6666004)(6506007)(186003)(6512007)(478600001)(26005)(6486002)(4744005)(8936002)(5660300002)(6862004)(2906002)(41300700001)(66946007)(8676002)(4326008)(6636002)(66476007)(66556008)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KNPSz5/X102IM5PdCulHSqnNkH5wnHtikZcV8N/wwS1cdXD2lcdUJBRYqIpi?=
 =?us-ascii?Q?1/TeUECAR7Q/7ajY+b9KVAIVHdrTDiEB1Y5crBxjTlbip4LvqQoGh4PbkP/B?=
 =?us-ascii?Q?U7AwWWV9sy5MPeowpH+VaQmj8PUyp/kuxLkmrdC+kDI9lLwIVlh0OSaJk/TE?=
 =?us-ascii?Q?r3bloRxFi/fA6rHN7Do2MPq9sZIZeHcvALTUvgU9fu12C8/pNU7h8ZpgK+ix?=
 =?us-ascii?Q?L73WV0Riuk6booKzOJeDUT2kgC+uuDKUVbJZ0tM6gkhgVGpWgY3SJCyFVTtq?=
 =?us-ascii?Q?MPiFSBnHipHYEfTNOcL+5F1vTgVvIsKDyf1v9U7ILwYvfS62fSC9JBBBvJyK?=
 =?us-ascii?Q?Ip343WuZWXrlwNzzz4vssvCrGiCloEN9sdn4/RBCa6hyQgoFY6h3pYT3ZKEz?=
 =?us-ascii?Q?YJY1bRbTt8RTX/hoVxMI2328TR9I7uhOiw6p0mHqtyzm2yIt7Nnep0uLtFqD?=
 =?us-ascii?Q?aa7b10/pPUNwjxn8hEoILLBLYNmAntbhqky3jH5RQdQ1sbUTGf7+xfNV2uv5?=
 =?us-ascii?Q?7nzFvGnU7Q9xWfr8TOD6DFYVxU0pxL5dnbE3NBXPvV0LpnerN5GKdf734/5Z?=
 =?us-ascii?Q?Tmjhgs4zJ5HP6I9nd6kLWNQaFh5NrkhvCEytGuF058DMubEEI5lSHqlgbcSS?=
 =?us-ascii?Q?jZlDnavFayt71vyAF9k6iy2AHoN79NX+OvvJyJ7IMk4aAMd8C86pT61Kw3bw?=
 =?us-ascii?Q?xPY7lnmABB6EIHadfVYKDUmweLfp5NyvGjRuNwWnO+fOYa3RNXl2VsbrksBt?=
 =?us-ascii?Q?KCKaQgBYxkIFytVFq9Se8sVJ1mgeO+qGu2LEnuXaZf2tWI31bSO24cTacS8M?=
 =?us-ascii?Q?mNZ0CgmlwS+SE/rlcHkQErFsTLD8WqKPd9V+9OXxILsZl0ygExnYyOT4M5sk?=
 =?us-ascii?Q?BIhd09XBvmZR/cxqt8Hrpwmk6f3Kjqfts/T2rZnSVW8qj/fGp4340B5LkrEn?=
 =?us-ascii?Q?0Sp3uIakoP/yPYcp+7qOscKYPgZ0lLe/i3S9oVq/Z9fMkjUs5D+omXPwU+sK?=
 =?us-ascii?Q?yO4kaTnZLct7CTjCPUiNYnBkIOCuZqMLj9vKIL3xi6NlXe50WZipPgdFPZRj?=
 =?us-ascii?Q?faORTcwhxmakPLUMB7xhov8c+vx+o5gj/oo6n0xeJS35mmYBVYESdBokfGRp?=
 =?us-ascii?Q?HP31aKqtcIuRaTDcL3ooJzI86SOMRz2PxQarKaQ7fx56RVWQ65MAaPyQ9tAJ?=
 =?us-ascii?Q?TiNoMYanhDZsE3Z7tF9jVJrNeKEyDTOu/sRGiud6vpqBNuz8fCvJkJjpdeVS?=
 =?us-ascii?Q?/jSn3Wr/hTkKRzuLIuWy57RgZsBExx/VogApF98/jg7AVTnp4ieC/cnKhbbH?=
 =?us-ascii?Q?ddXoOh/2QGhI58iKJBW5LKyfM5kBy4YTjWWiu/DGLhUNd1418NiBkm2tyBta?=
 =?us-ascii?Q?lEcqK1BqeyjLy4pK3gAPOejHVyQeUDZxg8GiJtP33Qxi8uhnhvIcn05SnDvv?=
 =?us-ascii?Q?Osf414vdr6Z1lRH8qK5CT/dU4Z5bPHlzsXfS8zO4ja/xnpPnVgYYNJTwvQNO?=
 =?us-ascii?Q?J2fNQGMvUGnVpPqZzml2B4+F4vIgY+zc6mrs1ea6eZcrj1jNlWOgqQY8Ps5O?=
 =?us-ascii?Q?yMq8Z3+ajoxZ/qnIhgMeDqJTqTbKHY+8faowbln2e56ScyAJAHKVFBKUotOO?=
 =?us-ascii?Q?QA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: uIYCLQdau4a1UMaq3DmljZFeCfDhQFDwktutImddIUjm5ypSmX3iQ9ES6n2t5u7yYqYqoTZQVMPzhST4gdGvyEo2fIgux/kE1F4beqJsyrXv2571gbcKSbDCkcEtcoOxnZ+XZgjh+u4mzDox5MTOVY8fMnF0LHKh3u1v7I6TZReH1WjXPdSSVcZDLIn1sgtTG+vrsbdEgXpeyt3mD8fqQv5Gy8J5iO03O+T1f3AphkQxZUsuY/31Od4ezIkvX87XfPRXuVKAFk/YgUt/wT+J1XfCD8mn0NO4+q7jy5Ei2hFRVTZJ6AQqq+myXdY4RvYROdCXt75okG0n4u6CJ42qRGNBNpTgMiP7f3XHxY93WDbK5WPgsibfdxpthk4kGjFKaz8F01OPqt+8iYnj/vQs1mIzZ6UhB29ZjMz/9IA9su6QYXXpUJFrQ+axB/r/cDgsbsFzTo5ttG86eUpHMkLFKIq4XxO8AJthdSHVhzyzpORHNrmyjWVui7HEFFeu+Go2T2I956whzwq1SrRf33Coq7kyP9e2SrGNch2hoG+k12EGHHWo4fN9Y91CqMbfaD0tjUCD4l9TereSIBw4upnznJ0K/IaLH3pXuUtc8P24DpLCA8UzblPrA9af9L4+GpJoZ2cpoavlzRVTYg1wMvmu3Xs6PnTXIl3U9kZaOERHzfpiH/0l0JuvqU6rzZjXqJNpiDQq5OoIQ3HeU/SAqh58yGxGR633p0/9Q02YRf1WMA86MNN6JVQ5D8KgiAxGe0q7WUgr0O9GIso/SEJ6ocLWWQ43fjywiZJQ1YQHQx5ftL1hTtd69ub0QW69lmdzaF5/37GeakrLLflIHvunkeq1QhpuM4tM1GcGrCgYBO2LRYBWGnzs7Kr2akCr+55Cf5aFpXlVRGQ1WUyApQt7GyiJL5xxmQq6VIQP6GaLf2wRvtU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39092331-fa94-479c-980f-08daf9b6b39d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 00:47:12.0722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DzOKn0D70zQt7GctJ69lbUXSgAkb3fF161TPHSnPp6hiaFs/WBOtFzsTXSh8czcAfTxZA7EfnXBuqn+i++bUw/6p47dsa1YRrm6FtB8eVKU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4267
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=960 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301190001
X-Proofpoint-ORIG-GUID: pbBjnYeqROkgThFoOoXxJXridzp8A8r7
X-Proofpoint-GUID: pbBjnYeqROkgThFoOoXxJXridzp8A8r7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> The following patches made apply over Martin's or Linus's trees. They
> fix 2 use after free bugs caused by iscsi_tcp using the session's socket
> to export the local IP address on the iscsi host to emulate the host's
> local IP address.
>
> Note that the naming is not great because the libiscsi session removal
> and freeing functions are close to the iSCSI class's names. That will be
> fixed in a separate patch for the 6.3 or 6.4 kernel (depending on when
> this is merged) because it was a pretty big change fix up all the naming.

Applied to 6.2/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
