Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E280DC2B9F4
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 01:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B77F261378
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 01:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFWBx3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 21:53:29 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:26820 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229769AbhFWBx2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Jun 2021 21:53:28 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N1fTtx017718;
        Wed, 23 Jun 2021 01:50:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=aegnKOLJRi3CdnxXmBCafGyTNDi5w2fImvRMPHR8aJY=;
 b=lA57fq45cmQf+jKAlwUhBg9mgjhh9xlDyPUuWDhbn9lpU8IE0yKlyEKIKYWMGDYAiC4X
 rP8juho1dHlmOzycyZnB0+jhMSLUyfcKm/TJlgfkNZLccxPqBqfV/Ps/nujFb/VOq2Fn
 uD1jDDYvdNqRpALbdeXr3UxntE4E0G9kqhHYug0pGKPI587+ei4PtzKnyusjwNKQmNlI
 Q+VY+2PnfOOK09qq3GIDGKJ6vNX0XJiFThQrwl3CTbscU+DYiGDRTGAy6E3jafO/wcL7
 WFAOcoJjip6qkqZk47KlghCsIlKN3bfUaPo4rghFcWibjpHbC9ihnGrE6A2bX79CgZq/ Ig== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39as86vag4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 01:50:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15N1jXfa146957;
        Wed, 23 Jun 2021 01:50:52 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by aserp3020.oracle.com with ESMTP id 3998d8d1h8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 01:50:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mmRXmyviDHbxMA2QPxy5qlv9jb8XlL8HUfN85sQGBWU2SnO2HIaIFXUOxARH1EvjhF7SYvyKebzDrvGBA13monDxLG4Z9E7LFJUMuO0bABUCHwjvaOQGYeU3wMfJrix7dJj4iXzZ1mm03CNsAU6OLndOyY/avpd0hjB+xihCzx0dpp8hGxXthwxCUtvKG7WbH6licNo/o41NMOfUmfo03gzzKawMiVxzZkAZHC87zq03zXWrI93OcC1xRHMIBqTXWvzvIldmTwos3X143ivFgBkj6maes9VfDEUc6NI5ms7HxJTU9kC5Hiuh4bbqZLPrG4GTvGABVh67kVE4ZwHpGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aegnKOLJRi3CdnxXmBCafGyTNDi5w2fImvRMPHR8aJY=;
 b=jEoW3GrP6Bly964SuCALrbz2wXwz/gchiuRmDdGy82F2D754vMlVcq+7Z3e+jGtFG8QPbGp/I/ficfs83oVjvQzVqM5LVMHLz60TMdJoQXRtBhGWApJpPHeJh0z1NYkWdcUgd0kliSTCE7mwnIbGdX8BYA3Fb9MWjCjQU5f8QDKDiMzmHDzkHgaK5PHGwaNcYcHnoeS+yq1sIpRMnp21i6H3ATouSrscbgKivSsYJMQDC8iEZQkl5u4tuiE/D3pz3QGJ1bNeZO5QjKoirkOaWRlLyMkwnnUOm6+XwZc5X8bhsBRyd8FJgHUrVyQugAbNa6EXx0eGvQr2aDzU/F88IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aegnKOLJRi3CdnxXmBCafGyTNDi5w2fImvRMPHR8aJY=;
 b=ZQjgmN+EE1WZUARu2yqlLTy7sjTWMWKa72l/mrIT7wTbmKUvNvOXqI1v8p8DuFL73jCGiAYNpR0/VGFM8YUsiG6kVJszxAk+bQF5VUJ78c+/csiJmgEweoInc0mJn0ghyItrhxIok5Cgg0qUvpXuBXnjLjYpkSR5vBLXunMmsJQ=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1295.namprd10.prod.outlook.com (2603:10b6:300:1e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Wed, 23 Jun
 2021 01:50:49 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%4]) with mapi id 15.20.4242.024; Wed, 23 Jun 2021
 01:50:49 +0000
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCHv2] virtio_scsi: do not overwrite SCSI status
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eects61b.fsf@ca-mkp.ca.oracle.com>
References: <20210622091153.29231-1-hare@suse.de>
Date:   Tue, 22 Jun 2021 21:50:45 -0400
In-Reply-To: <20210622091153.29231-1-hare@suse.de> (Hannes Reinecke's message
        of "Tue, 22 Jun 2021 11:11:53 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY5PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::15) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:1e0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Wed, 23 Jun 2021 01:50:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2cf6d8d-758b-4842-0799-08d935e95324
X-MS-TrafficTypeDiagnostic: MWHPR10MB1295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1295070A6A2C43C919F8CE8A8E089@MWHPR10MB1295.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M8KVlp+zm9ArO9llLY4Xe0Yxymwr0pYLz7Fsk1vaGI2COYqd4B4Z9/GK/IK+x+o/Cx1hDyFPSGeuJs3qTUvqZqcgOlyfuRmuEXUSBdf+j393LTrO9eIOsnoRFZPnYEIsNC3v+m39Auhl2RaTsoKI/CNV01Uibgs9l0FUr4YBy0q8tUfciP2wLfUY96v7E3iBYAE4IL4rAvZEdQUwPyEyn/hotbALQQb+/A/lM1wFkVz5/SF6wfRHNoV4E1PC+fsFy/ZKY9btiPICqf87BXZHnpV37j1CNyzGLTGcpBUSnBv48HABHvk8kTCqFmrDkjxuZf86yq0bsLWGA03OcxbWBkQ1tgU+2jcNU292u1C924VSniDzmy7i+T06q0gWflZkxb7i4vLKBwnx+nmgFvH2ZVn63RwXX95OyAo9O94/avJSCGH4DySSu9IuvUf1oiCGYhSnqI44z3D9fNuoneaD2BCXWjf2xKTVLslQU5N2ZDoxjUnxLEmQsP3PVCCzHsSwIPMBr4EKuhKnFM+aFj9M53ee0iPr8i9+SlnuFGgBLW9ZmdCq1rIcTNZ3h8if0XBWVrjIFTNffkSHkIny5QFZ/UL2u4N2ESv7TxPaZgV+HWfppbacIE0bmHp9VpXtfW4Vbai2oj6X+IsF1yZwo2g/aDR5YxOWzV8AdTqXN4vLDl4IyPrIDL4CkT/GxfHvjcteGjRCxOTKQkn5CmyVdSz3ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(366004)(396003)(38350700002)(86362001)(8676002)(6916009)(26005)(38100700002)(4326008)(54906003)(558084003)(55016002)(186003)(6666004)(316002)(478600001)(7696005)(52116002)(2906002)(66556008)(8936002)(36916002)(956004)(66476007)(5660300002)(16526019)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CAp1sdbO8C3bZcfpQmucaDRodv2YWstkWjSt/hv4yNPZbdgTMpWx946Bj0Cd?=
 =?us-ascii?Q?MGeSmLXdO7Rrfw8rMP838l1Atu7GXnWd5Opk/3WTN/dPL6WhlrnFwJHHnyFl?=
 =?us-ascii?Q?93dJxCG1QJ0BTs/W2XXfjw1byn/Cjfnfpy+bUO40meeZ6BvWNcKUT3LXTba9?=
 =?us-ascii?Q?lIpwM9auH+NC47sbFwI9MhKvtGakI9fO7z5zUgk6+sK9am/F0k3NwIEZZiHq?=
 =?us-ascii?Q?6ANHXo6xKydWY838bEXDCj70oZtXQuhn4giLwdLSGxDUVV1e1ntt5X37t4L9?=
 =?us-ascii?Q?XTat841P9i0KtNdG8eIKoAkp5WsBPYZxYhTMtGqxTUNu+E53JDgXXck5wSgT?=
 =?us-ascii?Q?4ovFFuydW9/B5bk2+qRaQ2vF1nSHijdsQOvXhJZg0iokr1jyKq+Kyvul3uDx?=
 =?us-ascii?Q?7xsYgeZF64R1u37Pi00ul29HQolDHWMwnoDhT9cyAbUcAFooanAb24g493dK?=
 =?us-ascii?Q?tcNB0uNHEE4ZSncKpPmrozF0lLffvRxQi9rS1ZKNR6niEoeFz+Ce2RFV8Rop?=
 =?us-ascii?Q?I94Vko66+0MzoQISBE6Vbr8RAyKm0kmKlNoItkelQQLBvPClhDKNDIrCmOwj?=
 =?us-ascii?Q?+CJk8p/bFIuYaG/d7z4obVGFqsTOIgjKpJXr+8lTaV1ympJqU8tTIGxwS0nR?=
 =?us-ascii?Q?s2PPAsOqB0NLKj5AaAGydkcqkj8WnChRd/DBjsCBoG5U5hl3wqeRMN82l2Hp?=
 =?us-ascii?Q?dk3ToxQeFab7YAQdsW4Dw6QKmOT15caPShiB4q5ZsXab6dwwjEnCLHRH/oSu?=
 =?us-ascii?Q?zBOWIrm/X2HY79pMOBAEqk7Tmu6f329dLP0PGdFFzFJLrEgIsVhF7otquBcw?=
 =?us-ascii?Q?FJaBiBNzn7XXr+9QZnGNmlFuKuLlPsxelZ2MjLzcEjSR/0HJlmMYLZh+U4az?=
 =?us-ascii?Q?6nvSzCZ7A0IWYEhoaiTE0nZEDovGgA5WnQ40cSeAJwF9MfRYpQ/9EQQTAwIU?=
 =?us-ascii?Q?ak3gvgbLWH8UTLUeZ7vcvdxYYhpd5+PPG8n3IqyHFTAyx8GgY9ffknHBb1HC?=
 =?us-ascii?Q?lD4aibT4TDm0XVYGmIzhOeuOBajLdqJozWIbV+JC/F3Q75KuJ/2dYSH/owyR?=
 =?us-ascii?Q?2N85DtaChUPh1ZwVg1+DcRkO0X73YHta9Szda3v2grq3G/OvjBG4JtnYKySs?=
 =?us-ascii?Q?dck6Mn631Wl8aTlLHz5EDnU+KcvFR+hkmzHODOI+LVCdts8AcxxlCCyZOTdg?=
 =?us-ascii?Q?L8CSRqOcFvpKHMjoKnlDl2mhjjxSZM9Gs1WnxbLHSWxiIWy5JZrGUlCFn0bz?=
 =?us-ascii?Q?/h/uuS3o52yx1wJugIEX1ojBv9OVIV8ZfCLclMM67sqov+JBh2gEfSlM+sBW?=
 =?us-ascii?Q?xaDgyPPMTsrx4iQuDyXTXb0a?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2cf6d8d-758b-4842-0799-08d935e95324
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 01:50:49.0009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A1WDT58bTZHP90b8IhMsWtinRe/kXmxfcLnBjcekT0EZnY/UqgKkk+8epNbXrjzn9HrePH0Yin1p/6REVBSZwUq6AxHBVIeWjyUpKQlOnGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1295
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10023 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=921 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106230006
X-Proofpoint-ORIG-GUID: yDrctChXM68ysyVS3hSZj6bnbyhB8_-d
X-Proofpoint-GUID: yDrctChXM68ysyVS3hSZj6bnbyhB8_-d
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> When a sense code is present we should not override the scsi status;
> the driver already sets it based on the response from the hypervisor.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
