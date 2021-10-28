Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86BBCC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 03:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 698A761167
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 03:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhJ1Dbq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 23:31:46 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18932 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229788AbhJ1Dbo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 23:31:44 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19S1ABxl021063;
        Thu, 28 Oct 2021 03:29:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=9kIpFbvehRT+3ml0bc7edKRwLmmTUmNLS2+XTrCouuc=;
 b=mR+wo4jfJbUZU2DD49i0vwZoi6aaPvyPIJoM1a2Y4vLWiKqGZmACK1jhvtbjm3hkHaxQ
 cw2/eYCniX3IeomQLi12FliDXtM6xTIxJLyqCZSRvdhCZXC9cv2dF6ffb9Er8vySpgoq
 SCkp7Rb7LfPMkT2nb31RGHoL7NeiB9KrjijYCdCaDhmeXvg4kZx5bGXlPwnfTIFvvGly
 XJVW5XzzfBPezx+hS13W2MALUHEeNiucFj0jwjOYpdVqWHiCmoa2WtbO6PVHukTZLm1U
 9BF359slO0RzMPMDSFLcBNtaCE4ChLMN+LXb/3d/yK4+JWbYsiAf6scIVHijcqHGPs99 2Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3byhy9g8x2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 03:29:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19S3Fjm6149337;
        Thu, 28 Oct 2021 03:29:13 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2042.outbound.protection.outlook.com [104.47.74.42])
        by aserp3020.oracle.com with ESMTP id 3bx4gdp5fd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 03:29:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SqO0vlyvsIAaRcD67bOBNTXxjyEtGHPaa9qVnY2fgBXrtCDt2M/j4wDS+PNtInWj3hc510dzBc9JDqLN2csd8UVwSZbKNCWrQtrMCcMqROSwAF6zugYG5UCzcD5Rwb2tFZM2pFGPZ/L3hwiTyxAIn85vSwFfh/iDGgXCpWvMQ/VqWZQFkfHohVrauovx/En2ekexlWcaKQCIKa4+ATcCbOUbUBwt1CHCQxrxvtUaEQXu1YFOWRr7YWqd1I5Knh7l4cVesFGvNGvDIaSjulkuR5RB6woMAxr4ZKuYW4HWNupKe/3SAeIcfrsq/3Bc59X3qidTsJ4C27dvsezY9+QC0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9kIpFbvehRT+3ml0bc7edKRwLmmTUmNLS2+XTrCouuc=;
 b=WenmVBOmawrV0zI+ax+JZMkmZBL9XHnhAumCVRKLewfDfIYXyAM47PKGslitdZJPpL9sBdJ407g5p6FlC6Xr6qdR082+PpvZbrAO/MxQi9q70Za318uurxkwWb7qdphDk7OoM/CjC3x3Q6BGR1h5c0sx1/NTa28QgyMGOTrXFu7p5dnxriDhwPgqxBIX6sS+rdlL+S3yPcrs7XO7iPpLL1+inchu+28Mp7pU2Vd8Wqv6JVbxAq+iJfJMsGbuRhnA0+J4/dUmHs8tM1GIo3QhgVeh18mbScnDhV3eoCloAIo/QdE9OLHhyp6AZ6E0RSiv2QbDGtuNc/ev1gnzBlkFGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kIpFbvehRT+3ml0bc7edKRwLmmTUmNLS2+XTrCouuc=;
 b=znozIccoNoOICChmidocC24Xo/+ujv37UmiHRoGImFFhzPJJ83E4ue6DFvMFnULh4iw1TI/X663U950UXh+5LrjXPOojKOl/YsS4jwLsZA+hei9Zq9sMYtSC2xWvmZgA5AideHUmGVUNjKlbL1bjPExJSQs1zbhhQyl03jM5Yes=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4630.namprd10.prod.outlook.com (2603:10b6:510:33::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Thu, 28 Oct
 2021 03:29:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4649.015; Thu, 28 Oct 2021
 03:29:11 +0000
To:     "Ewan D. Milne" <emilne@redhat.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] scsi: core: avoid leaving shost->last_reset with
 stale value if EH does not run
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfwlygts.fsf@ca-mkp.ca.oracle.com>
References: <20211025143952.17128-1-emilne@redhat.com>
        <20211025143952.17128-2-emilne@redhat.com>
Date:   Wed, 27 Oct 2021 23:29:10 -0400
In-Reply-To: <20211025143952.17128-2-emilne@redhat.com> (Ewan D. Milne's
        message of "Mon, 25 Oct 2021 10:39:51 -0400")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:208:d4::43) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.21) by MN2PR04CA0030.namprd04.prod.outlook.com (2603:10b6:208:d4::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Thu, 28 Oct 2021 03:29:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c875b48-f4ac-48dc-1ca9-08d999c31c06
X-MS-TrafficTypeDiagnostic: PH0PR10MB4630:
X-Microsoft-Antispam-PRVS: <PH0PR10MB4630277C67269408E22250CA8E869@PH0PR10MB4630.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /z/CT+3bfATS2MTtkNrk+wKk0SAoMLtppsNNoVkEhL/YjsbqRrQEFxrBtP9Fgn4HKDkuCUvJOfEXA5t5IO3dcRKShJxB60MbjkTVdhVTHpNvO8QjJZwLny7BT4tjfudHJ3Yj+c2A5yW/rWT3q9aQFLdIXk0Gzp19bhkywBf7MA1QXoF81GBVlVYnq5UcZ6H0Jkeq+Zi/6NDa/G18n91lcYNaIsAOH3OUdgNf+qitkyrRoy+e5sB6DPaus+rp6gzGbxh4FSgZTpAeuobShosJNPoMsMCuHbcGcaxePEfTINwhWGTGmGtwR868X54SAEF+8SdhNYthky37+PrXrCCvLwUvsWSLJJBhGJWr7og33PdPBQNZKN9lgP65GkUC/46Zwxcl9HPYp3gPCTuIklf5OIu8TC9BnvSuqenWHkE/nUpbApfWXbkAUC2cngx3a8OZgaHN9iuzZ0DCO1QHCusMnlG9qgkDIq8OPQRVfGYZo1+OvpFUrowFVP9xMPcrtIkpdSXlNJfs2xfa+818Icm94bGJU2dXtRDz99+xduPPOsdW7EeBaBHWNEU1l9ky8A/3K5Z1/lnnOoKVN9fGd2/qCDZBLtMXvrdubhB+INV4WYj8Ciya2IEdpXoWEa08yzzHIggryCTOlH+UhG7kLGfXjFg1+JHQ4KYxI0yTvTc75L3qOas5qFd/jMWUrSWJmknbisxIho+1okECXcY8/kkgrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(4326008)(5660300002)(186003)(8936002)(316002)(83380400001)(2906002)(26005)(36916002)(66556008)(66946007)(7696005)(52116002)(6916009)(86362001)(55016002)(508600001)(38100700002)(956004)(38350700002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t+CCehwk8xLeWH449r7KMPe0ynZQzNXXpVHLimyYu+nMH5yPFB4bwte0OMSP?=
 =?us-ascii?Q?2lkFkDfj/tPNOZGD6PgCpoghztO/1JmC6z6+Auh8p/DJ1pB2mQISwtMEy2vj?=
 =?us-ascii?Q?QlJNTOjkkPSbxFqngjFDSlweLResrthx+zs8YyTcsYExs1juumKpJzxTV+EZ?=
 =?us-ascii?Q?ONPvx18TUfPxIEOX8I9/X3CTb1TPxTXLpKiMYTHk1kT9+n5SruSc0TPi2pI4?=
 =?us-ascii?Q?d3E7rG+a4RhhO4C30xEvQUP93ytV9VZh86RHV2q1nZuqlHpGKRItXH/rldsU?=
 =?us-ascii?Q?L0Hz4zkm52qk7DurTCtqLeh5r4nxkPQhdPkmoWf/dxzlQz59gz2GYhaUB2xm?=
 =?us-ascii?Q?McLDnrM48KlmL3c+no8vqwWM/MpK/bxXB2dQZgDAzcb0vRhx3qrupfnIYL09?=
 =?us-ascii?Q?IGtVkJFIIMHWb2S84AOf9SYZ43rwHjzvNXO8yU4hSi8EfVxWlAkssS6gKjJD?=
 =?us-ascii?Q?CXym2H6Q66tM9gSSB+4a8sJwIeh7VSGdWB3vrg0esK3q3qA7ynSHX0wZB7uZ?=
 =?us-ascii?Q?bo+NurmQxTKSzGIOQYCni/0KJanpwAOPayMV84wuVh06WOTF2MSQ0I+DgcRo?=
 =?us-ascii?Q?ASltkzgt4GU0Qzu62TBGMlX3JI+gdzPIweqbEGfpXDsTkan9qAYO3V+bNcsv?=
 =?us-ascii?Q?+tTFVUE1PbBmCcCiinYVTRxk2pvZeCQK6s+Nm3pMgFyyxXNOu99WxMgSiDuD?=
 =?us-ascii?Q?quXsQZWAdD/7JuM+9s/QVsVq69ZC62NL9LxbBW+90t+nwLQlsr8c1S/oMFEp?=
 =?us-ascii?Q?C5sN378PrIK4EDpRdvuUnMZhSsXGJx7FkZ/IycmVGPMNW/jLwYn82m3nAZyP?=
 =?us-ascii?Q?WYtCB08Ksh3TC60zfa9CSG1MgMZo0sPBRUQl5bNCBXkwPhy7JTICP8koe6WU?=
 =?us-ascii?Q?py3r1xfOSTAUl6O1CR3Hb/YLGG2Z4jJeU2ResINPO/vd8abtNNyuSkn6L7Mz?=
 =?us-ascii?Q?v+Hg2u8F60iiTyaqznIcJ1fJh1nzmerqoUuzRCZvJO7K61Ttyfzu8fx58UE9?=
 =?us-ascii?Q?ykd8DZQFb1G6o3gFO1Kmud4WYIwtx+QHQTtWv3Uhi9mt6Y38vn0yPyP2h0mR?=
 =?us-ascii?Q?4TfpZw5Mkobo2MUdv+q6/PQoMXhD0GKLo0TfyF4i+CyBz3x55ChzMCcv14Dw?=
 =?us-ascii?Q?MbaDzy22xQyFY0KDFsDztkKnq1nuCyIRj7N0a2VCyb3nNApmjxQUIYtDNX7X?=
 =?us-ascii?Q?J0hF9NvA/cLIHa5cxRnfsDX6rFRmGov0fmMgnioAgHpTx4nMHTzcOj7pnqPA?=
 =?us-ascii?Q?H7wAnBkmUB/JBdGDfNhmMSsetKLVAXopUkDs+PmYCNBiQh/+UUEJz5nwznfC?=
 =?us-ascii?Q?/qDGVajPVmDa51xmjL08/2AE1cASasSv2w42w8ez0xOScUqD8/XXZkmtK7mN?=
 =?us-ascii?Q?7YGKrt40I+OUK/3Kx9jhhhDPyTB8AOEGsKJVyBvGyLHgbB/l6Tpl0EZT3zia?=
 =?us-ascii?Q?DZ3oXdrBwOTWGdsa+NhfbyQuAOZ5hsrxcT/rPy3arG4l7GdqRo7gqf1Eg4pc?=
 =?us-ascii?Q?pnmnO2AZPgAVYuLhlGkxSX2VFTXhpYJEQaFjc0ERYlGP1SKGEqLK+/qk2RTr?=
 =?us-ascii?Q?9r783vzs2FkIbI3MbKB4TD92/M6KboqgvxKh4HKK4JMntS2va3vFQve+Y1vB?=
 =?us-ascii?Q?PRi4nVjhRjOXgb7XBdziGWTj0atpKV+AwsAtwnUV60nohZficsjKHIgTCtgL?=
 =?us-ascii?Q?8aFhIA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c875b48-f4ac-48dc-1ca9-08d999c31c06
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 03:29:11.8685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WG4tllJz1C7rp6YJWFZ/hSGAZ818WgJLdZTPPeFQNPX4W03JIYS+kxJxXm+GQEBGAeAICBJxjOiOBPikUKweAOQq3vpZ/QWZS/PJ3Fpspys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4630
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10150 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110280014
X-Proofpoint-ORIG-GUID: WEci-nx9QvCEFK3DjCtbrU22W9jmSkp_
X-Proofpoint-GUID: WEci-nx9QvCEFK3DjCtbrU22W9jmSkp_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ewan,

No particular objections to the functional change, although I would
appreciate if Hannes would have a look.

> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index b6c86cc..9f4001e 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -151,9 +151,11 @@ scmd_eh_abort_handler(struct work_struct *work)
>  	struct scsi_cmnd *scmd =
>  		container_of(work, struct scsi_cmnd, abort_work.work);
>  	struct scsi_device *sdev = scmd->device;
> +	struct Scsi_Host *shost = sdev->host;
>  	enum scsi_disposition rtn;
> +	unsigned long flags;
>  
> -	if (scsi_host_eh_past_deadline(sdev->host)) {
> +	if (scsi_host_eh_past_deadline(shost)) {
>  		SCSI_LOG_ERROR_RECOVERY(3,
>  			scmd_printk(KERN_INFO, scmd,
>  				    "eh timeout, not aborting\n"));

Changing sdev->host to shost makes this patch harder to review and
creates unnecessary churn for a stable fix. Maybe postpone that
particular cleanup?

> @@ -175,12 +177,42 @@ scmd_eh_abort_handler(struct work_struct *work)
>  				SCSI_LOG_ERROR_RECOVERY(3,
>  					scmd_printk(KERN_WARNING, scmd,
>  						    "retry aborted command\n"));
> +
> +				spin_lock_irqsave(shost->host_lock, flags);
> +				list_del_init(&scmd->eh_entry);
> +
> +				/*
> +				 * If the abort succeeds, and there is no further
> +				 * EH action, clear the ->last_reset time.
> +				 */
> +				if (list_empty(&shost->eh_abort_list) &&
> +				    list_empty(&shost->eh_cmd_q))
> +					if (shost->eh_deadline != -1)
> +						shost->last_reset = 0;
> +
> +				spin_unlock_irqrestore(shost->host_lock, flags);
> +

Perhaps you could introduce a scsi_host_clear_last_reset() helper to
avoid duplicating this code?

-- 
Martin K. Petersen	Oracle Linux Engineering
