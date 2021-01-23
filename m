Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E05CBC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 02:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E41A23B6A
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 02:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbhAWCeZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 21:34:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47752 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbhAWCeW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 21:34:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N2U4U1066629;
        Sat, 23 Jan 2021 02:33:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=y3pKAj4XuN5rnL5xxJDOyMvuDYnMG0Gu+d9gJS4TXAM=;
 b=uQFbE5spgayUYpWQlaI5QN7BZVPP6TlhxN2loXQUWa4sBHwZLWGUXOUgT+HcIQLHKaWc
 OD9IEoBdFFIZtYo6BvR7gzB84crTfktV10RJrDa/1XpE3EGlisd3+FGYHq3+vk2Wi1XH
 I4ozieStCSOPolp2A31rJM8/EigLWQdMcsPmGyohI76A8sGYuqMom37OGSsfN39vfbPX
 p7fBIHo13jt8bckl276oSAncoO8uLnof6Q3hkVXj8Npff4gEoTl78UENyDvmBgHHkx5M
 gyqFjZzHDJOkcLSHucuoOulx+cPRYPyoAwxREDHpKm1tT9PWUsNWlPmfuAUJvL4TcMqn 7g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3668qn6vxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 02:33:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N2UpE2032659;
        Sat, 23 Jan 2021 02:33:03 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3030.oracle.com with ESMTP id 3689u8t5wv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 02:33:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yc1Sfaz5bio6SHDN60QeULSkbdtQP/JyMG/SP5fjyI+jOP4DZBRq6Xs5RYVfBWFTE1XK5e+IVK5c3x6qI1AQ+2AvM9/2oXXPSohh5/XJ9MXjyYg7STkt3QIyZHT6CVm/rS6TfwdQR/KoqokYo+6FZVWaUT7onnhDVlvF6NEM2wHWajt3pyqE7xHkXbWdjybL0JHzWQ2uWMGs+OwLi5FoRH8OIpZOfaS94i7vyqzmqQkRS72Aibs4MxwHAqv0YjQTmVr0kmoSZ/xwgTPzYGjsqVTYrtJZKz/qklnEUUH/JeryDVgnvqIzeyxw+Ew1wCwwUKtDdkO5l4p75P5kRVT0tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y3pKAj4XuN5rnL5xxJDOyMvuDYnMG0Gu+d9gJS4TXAM=;
 b=mcDGN5MxedbJb951JXXXA6xxMwMnYolV8F4mhEEuUrrov54sDFMmLrN32evMbBkcLevrgPbEr4+uakPnTPFuy1V/Su1pgekPf4xLYxYC3aw2Irv5zOLrvNS2umGzKjRkU93AE41RY0yH60uwfVq49A/oJw+cP+YMu8J1lR6dtRbcHm+KYL62CrCCFPFKf1Eur1sdImdAZunX7WqGXyOKaZ3EHThNzdaNV3mBi6zGYWSAQO4+IZlYqhfnTTS0ppXn4UXGBJA5l/nwrjdoLo8F8a18cqeyu36rpCN9CNQcJwBM+c/Nff4RtGZ/7jAZ1qAL4ZqMo+fBaAxuUJcEKNpFYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y3pKAj4XuN5rnL5xxJDOyMvuDYnMG0Gu+d9gJS4TXAM=;
 b=Ls9UUgrr/cVgRjNty2clcKK2nxpGeuJBJKbnM6UpaoOFHvtpZn05oHx2A9aU2TnqiidixQ+W34yOFvcwz881ZaAkGccKYGztV/TESM6LkKtlf2xPMC3NBxLU2qinlyKTN//KgAm7fAjJvgp5UQz+IclrUz6BPmsXFtEdfYNvxLE=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4504.namprd10.prod.outlook.com (2603:10b6:510:42::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Sat, 23 Jan
 2021 02:33:01 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 02:33:01 +0000
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
Subject: Re: [PATCH v3 00/19] scsi: libsas: Remove in_interrupt() check
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20210118100955.1761652-1-a.darwish@linutronix.de> (Ahmed
        S. Darwish's message of "Mon, 18 Jan 2021 11:09:36 +0100")
Organization: Oracle Corporation
Message-ID: <yq11reccrj0.fsf@ca-mkp.ca.oracle.com>
References: <20210118100955.1761652-1-a.darwish@linutronix.de>
Date:   Fri, 22 Jan 2021 21:32:59 -0500
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR03CA0058.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0058.namprd03.prod.outlook.com (2603:10b6:a03:33e::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Sat, 23 Jan 2021 02:33:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 244dcf8e-c878-438b-bf8a-08d8bf473443
X-MS-TrafficTypeDiagnostic: PH0PR10MB4504:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4504B069A8AD2E7412C417D68EBF9@PH0PR10MB4504.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4R7ErOUw8VoMH88O1FEvjcnTiNs1yUwFOts6pPXVZ8eWT5Iyi5LkOfyf1bkY3+QGXPqH3w3Kg7gBHic69XJiaUIeF9+zI/x+vlJt2FaOMQMAhg348g1gkhL/U16vtjxQ8HCsx+Idagd+zjh7nwhk4QGre73xy0TbTX7rvwsRPJH10B/odZ8UwQQt1279uM3z1lrAnXvgJ36uELAMM34SajRIMvl1HV1YaNTwij8wmoyrvxxzP+dJAy4pnU8+b59laHpEVjA1YA0hp08xQwGeH59NsiyzkfMB44v9gKM53wML67pY3Qd6yQQFBMAot10wPkIq8bpaS0jEmb3KFobo0HRV8OiQoMhgflrBoqxQzNwpFbyjaC+Nmd4aWO7VfxhNl3O7cCr+l1pgUVXRZPX3Yg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(376002)(346002)(136003)(8936002)(66556008)(8676002)(4326008)(52116002)(66476007)(36916002)(7696005)(86362001)(66946007)(55016002)(7416002)(316002)(2906002)(16526019)(478600001)(186003)(54906003)(26005)(5660300002)(956004)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mmahbjnNwS3zrDQpAXTpg47sehv0pHfmSaUYw9bFp+b7xByQPpPNhFszRlUI?=
 =?us-ascii?Q?/60pdCshp0AOBOZ11yYP60SFHAdeOqDjCNUKalTrKZZt6gA80ULPg1lp+Yri?=
 =?us-ascii?Q?RmipCoU7yoW373CRpMWkUjk+Y//qJVJxb6lnnq6C92zD0FXzJ3NGg6IFzN+O?=
 =?us-ascii?Q?95Z4mPfRqH5dUMZY1WqPB8YxaW6x4qfDmDQK6x/yypDOBNAhXR5Wq/F8JvVV?=
 =?us-ascii?Q?51c74RksZxgHHyDusxZefkl10+EZR9ATwkA6QiIIy+PpTNO1mjipIqtPu9k1?=
 =?us-ascii?Q?lXKy/idrwWEUCAqSXi/aE9DQXhM3agSeWBKNpn2XRz0ICxh0lZEvQh5D9prA?=
 =?us-ascii?Q?IOddqsgZee9vb6lPuAWOSkfSCUl1uaj/B80REOxpi/UsvWqza34R6TZ0XpTo?=
 =?us-ascii?Q?Oh8g0P7/mpiybeoyi5af5vdI3dkZIXz0hhSIWN4Bweqrq5S9RiiNiCpiNY7c?=
 =?us-ascii?Q?rcYhYXMVWHAUy9gsGGLyfej+aq233HBuZhy6N+N7MKYuIgsr7fYB5ti3ZQoe?=
 =?us-ascii?Q?qQ1V2f9ercOiqIuLf74S0Bb1Gp6XUj2REOWde+xTrpwTYfg7TDWnZhu9B+ll?=
 =?us-ascii?Q?UpktFQnN84JCdrnSJdGWRcipZZZeH9jYR17KBMGtfdcp4Kl897g6JH70cNfL?=
 =?us-ascii?Q?S7m3TOD+9j0mDkP1w810wPm5pNLW3O2Tw5R/oMqd1Z3e2JKjjdbN1uFOj3ka?=
 =?us-ascii?Q?VP9QNWdDZn35Rhl+i7VNz8s9PN9B9lDWGCS10ChxceRYxwU82vRSnorQdYfY?=
 =?us-ascii?Q?6hoj8n09+0puvzx9LQhRI/t8g1lcAGn/orqiPaQuedui2Lo5FU4/qWaQ0Ytc?=
 =?us-ascii?Q?RPw/e+u+mkhMMgzFyPCztn/Rhhw8902iKGTz8KOdMN8gIEd3hvRtc/tCa5l+?=
 =?us-ascii?Q?DoDeoR7pCNwf2B+/CqyeiziXyescEGR+F1w0NonYoHxfo4vhAkPo9CF+RNj7?=
 =?us-ascii?Q?TKspcoQzMm72AAzaUEl3Dt46gNVlkzFxSRkv8uMMLGGZPH2KfLk81R7/rtnu?=
 =?us-ascii?Q?3GI1F7yLU8AiMUw0iNYVQIYjR0mREmabGE0UTwa8g9VJm81yn4XVT2BnT5Oc?=
 =?us-ascii?Q?n5N8JUcu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 244dcf8e-c878-438b-bf8a-08d8bf473443
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 02:33:01.4438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sod49kDYq/f1OVFtQAYRwthvASCD4Fnu0oImyz2mg5p5OBofp9/QwGfHfLhGOrjCiDGziutOmPoqXVW6OqqmO2CeYMd/oI6Ejwe9y0P/ic4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4504
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230013
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230013
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ahmed,

> Ahmed S. Darwish (18):
>   Documentation: scsi: libsas: Remove notify_ha_event()
>   scsi: libsas: Introduce a _gfp() variant of event notifiers
>   scsi: mvsas: Pass gfp_t flags to libsas event notifiers
>   scsi: isci: port: link down: Pass gfp_t flags
>   scsi: isci: port: link up: Pass gfp_t flags
>   scsi: isci: port: broadcast change: Pass gfp_t flags
>   scsi: libsas: Pass gfp_t flags to event notifiers
>   scsi: pm80xx: Pass gfp_t flags to libsas event notifiers
>   scsi: aic94xx: Pass gfp_t flags to libsas event notifiers
>   scsi: hisi_sas: Pass gfp_t flags to libsas event notifiers
>   scsi: libsas: event notifiers API: Add gfp_t flags parameter
>   scsi: hisi_sas: Switch back to original libsas event notifiers
>   scsi: aic94xx: Switch back to original libsas event notifiers
>   scsi: pm80xx: Switch back to original libsas event notifiers
>   scsi: libsas: Switch back to original event notifiers API
>   scsi: isci: Switch back to original libsas event notifiers
>   scsi: mvsas: Switch back to original libsas event notifiers
>   scsi: libsas: Remove temporarily-added _gfp() API variants
>
> John Garry (1):
>   scsi: libsas and users: Remove notifier indirection

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
