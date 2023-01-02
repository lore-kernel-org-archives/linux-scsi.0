Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8BFAC53210
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Jan 2023 13:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbjABNG7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Jan 2023 08:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjABNG6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jan 2023 08:06:58 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E187F2AE3
        for <linux-scsi@vger.kernel.org>; Mon,  2 Jan 2023 05:06:56 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3020dV0v019411;
        Mon, 2 Jan 2023 13:06:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=9hTucQ8HEV/moank+TK3OUsSkh2v2ShGSgXKwFPnCfc=;
 b=EHnbCVPVsDoRzN3i3UQW6EJEoDDWg4S4nHGKJmTb6qCeQZVPpI81KuouNBbtr/3siczH
 t+056paePmIt0ec8jMNEqiSGt3CBTwdfTirGbUpHJU0lPpfU0v+GJTguxICtQuyKv/6r
 8gnmsQNd+y768EVKJTOqfDK33p7pLjG1ARAzuBOO31cgV1D2SPPmfp2LD9vgB+7BO+UL
 XukEh9tfMjLQeF01ZRkblYkSKasQz+q5RsggA+KCkn7nDGr4gJlX0SQCLfZ1NSPbiQfL
 XnVoq9/O9zzwH+N7nlh0LEPai046ji1ka6Jy6ur+ZHPcpy2a4tUr+P57PzfXas+YNjB6 /g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mtcpt2aqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Jan 2023 13:06:47 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 302CrAq0032925;
        Mon, 2 Jan 2023 13:06:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mtbh3qx19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Jan 2023 13:06:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7sVktkm0wNx7DipNsRg+YyVAeSpBB+g4u0nmYj2L7eyC04rXyxoxM7gmXxrCiWnIBFhDCuArw26jey1ktKMqbjDl+D1v3nrQb6WmlZLTCwRmoYawi3x0wRFILMWdORurNq22IrOXwznck+5DPXeOwKC9HTzf5Vh8eF8witb3o5DscjMPwzCX1hjs+UPDBZsix5Lw0KXaje0XU/77byg/GV2P8ts4uNeFTLTEQsXaBAiQ5gjaAzC++kcZDTG7NDcQVVJBkL09tNot/6wIRsfzltiR8lVbOxmtAA6Fz+0f7vkIrLWJ5gOeBqmpRiHJAwbBg/ncyQeHMTcHhRiiuqeHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9hTucQ8HEV/moank+TK3OUsSkh2v2ShGSgXKwFPnCfc=;
 b=LKpfAoTQYZa+6ZTDM3ufQUzDggXPCdFe9EGY90/o4Ve9NrkyP0t+X5oya4yWIY4wquU86vJGP7KqjJHHb3nH+1kjmNujE8sJJDhg148P0ott53uhnIwZhlKvEug8vZ2zONEQyjsVfGp5n4h3a1+USHH5LQOgcDvcH9gH80Qm+1WPqBFXrlaIlI6vxJWAQfmtyKxTPvKcWTl5iCLeXxyZ+OBsyZpoAwUGvo6DZmDmMRKnD8AkLpfeoTS5+6NFhfGwLqRGQzdDm4QEJDd+lVO4X7Nvk+25gWb/KYRAotkP7rICkd92Qnn+JeFykg4d8KvHaHWANq7nsvlGOJLiwt6Qkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hTucQ8HEV/moank+TK3OUsSkh2v2ShGSgXKwFPnCfc=;
 b=rnCzpt1nUvsJ/Sx1vGoAPOwKIbt760YDZsDdqH1mfHV6IxnF5Vxi3pLL23+X1153pWuGFlka5UN2OTweBwkBVlUus2GjBtFITQwbci7WV4dwZx1uhdgTqGkp9Pz2MDseZBpM3VVGyYnkBfLv0v6wW1jtE5nYl4UBRrvqDecSJz4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4421.namprd10.prod.outlook.com (2603:10b6:510:33::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Mon, 2 Jan
 2023 13:06:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::25bc:7f6f:954:ca22]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::25bc:7f6f:954:ca22%2]) with mapi id 15.20.5944.019; Mon, 2 Jan 2023
 13:06:44 +0000
To:     Martin Wilck <mwilck@suse.com>
Cc:     martin.petersen@oracle.com, Christoph Hellwig <hch@infradead.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] mpt3sas: Remove usage of dma_get_required_mask api
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tu192iur.fsf@ca-mkp.ca.oracle.com>
References: <20221028091655.17741-1-sreekanth.reddy@broadcom.com>
        <20221028091655.17741-2-sreekanth.reddy@broadcom.com>
        <Y15lk+CPsjJ801iY@infradead.org>
        <181536c494aa39ca78b190396a97072448739411.camel@suse.com>
Date:   Mon, 02 Jan 2023 08:06:41 -0500
In-Reply-To: <181536c494aa39ca78b190396a97072448739411.camel@suse.com> (Martin
        Wilck's message of "Mon, 02 Jan 2023 12:17:25 +0100")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB4421:EE_
X-MS-Office365-Filtering-Correlation-Id: 113c8002-fceb-488b-e910-08daecc23248
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xP+BdANgw1VkWwXHY6L3yfltGVv5oxM2rVp8nJZqe02e/PRYzWj8W78X/y/ZmARUwXAUJ3BmaO+sgVyhEjlcWGnEr3Xf6CSUlvNBeESXf/B1DcaEHc9+eoFSkwya80BIu/2HjwOVOyYXiQP9VcwQtVog5LH9t3VdDQjsrDACWaKzDiJz9kp7w+Z9IuLZ3H4XBzDOX1iLC2vAc1KMYaVktY9jfGwuUJtpvGYXi/1a5RtKsz53eujPtixJs6I224nfgRJSmLTe3FGAGBY2GrtW74FbicFdF8qcMIVu0FbPieh6KjqlXxMT+FWEz4+0L6hyHSffMz6gSkthvArkxMfeJsB0iejZzQP1hlmpBLb5XhMW2WfY8lcgaTccUIco32jKagj3TyEp5DZy4uARd/w6CTlekuDq+u5ly6+RWDIxZpTzr19pZqbRedcd65+0EEpA8Yp0ZJdAKFnLiq78siw8iOakDMAQkbPydnwQnXOlPEdQ0nR/zgg33rETJow6NtKPA1shd1/S45FkvpGFxvtxvhFM97gws2bQsJnQB7GkMO1Ydyjz2gji9GfNTeASsaFNS0mewFSTz2BuVukRI7Ckyj2txR1TMiC4xnwErYg0rOrLtc+LEpNQqQr3SoQ4uKHYzvHnkauA0aSTVceO/ea6xNHEFtvIQDuuCunWWIMX7sJWQ3bCaQY9mGg2t0Ta3YJImXIhWhaq5wtEc82vpjNo6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199015)(83380400001)(86362001)(38100700002)(2906002)(8936002)(41300700001)(5660300002)(478600001)(6506007)(6666004)(26005)(186003)(316002)(6512007)(4326008)(66476007)(8676002)(66946007)(66556008)(6486002)(36916002)(54906003)(6916009)(558084003)(22166006)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?soAFIFGHaldsEGuEregbXiHcPMT8yIsBt6YHY2P2SkluFSYpLnidK50XgSPs?=
 =?us-ascii?Q?ORZw+bILbhA9wA/orgutE5rbe4cOUht1316/DcRGDh+5//Pt6J0TDm5+3EHu?=
 =?us-ascii?Q?PTxtFNVvWtJPKz7tdea1Az7AuRJReBK4le0RzTJRKd73CcN0mp20/2750Nml?=
 =?us-ascii?Q?88d5UHQP8k82qCqVtJiLxpwprcNl39D4gUDZvNSPuNY/6iHms/kcycs9YDVs?=
 =?us-ascii?Q?filHqbyWQpw/nIzDnfH+o3qOGPoVwzUiTgN2CKl7JHUvnmbsgoGVr8cP5U5Q?=
 =?us-ascii?Q?O4CriWk6oa9RaQt57Y3wVSL2pGgr4lobFRZ24DqBmF8eVkBrCi6ogJ/DHRXa?=
 =?us-ascii?Q?WkKFG9FKhQWZBuUji1Z73ekGniLqbEFHFF4X6FmEskWIneJYzQ9CLOursjGN?=
 =?us-ascii?Q?tC6MGyVKq8lnVPUbtDqrF/jxIcKdTYXBh8LGLTupoZ8BZsbyPd385mDFUAHa?=
 =?us-ascii?Q?oo6fP+R66IXQpHA/T935nA+McHw5Wu5mZCKIi22QS+jtvacty5kiYfp2DlOv?=
 =?us-ascii?Q?kazI9h1J71KfoZ5nNfUW3QdsK8h27kHhud+FbI3TLmEkse5Nn3U5Siyup/Ck?=
 =?us-ascii?Q?kT3qRQNWvg/bjoQW7P8I29DttBy5c/SVayz6eyNvWtUl9RJrq687hYiNCjGr?=
 =?us-ascii?Q?WCBhz3WYz0kdADF8TEWFGyLpuwxmX5fJcG/C993Jhmp+7lDXP16YgzXNIsJ+?=
 =?us-ascii?Q?d9tVMVO3ERDoF/GGE3gnz8qEmIL6CFkqtHysQqEY0A9nw0ek1OrLyDvyRPxX?=
 =?us-ascii?Q?JAv4wegQq9c/UoE2vJDhcKaOgRQixqM/8HfG3w2TleBLC1S+8DfoOvRh5AQf?=
 =?us-ascii?Q?uF41AqQuL6+unNtoDKMzn0/0fokcicw620urLTRuoBW2V7JiuBYQVr8yi9UZ?=
 =?us-ascii?Q?rbGs+4KljXjYxjZyW55dY/BXNf/CTs1TvWe7elYxDcqUPh8k0j3tr1wsuEty?=
 =?us-ascii?Q?KZDD30s69fj9ASwTQ6IWPrAs8IXuqS83blwrHYO9TV/QQ8+0Vf3J0qdsAQZO?=
 =?us-ascii?Q?dCkrRtsyBB8YYWrCt926WNscUwHbl1gMFN7qD7XiNUc5Un31TRBOdu7pA7Uy?=
 =?us-ascii?Q?JGrCVYIyV3xivTeptVK1990Cp8/BFMbYZgwGp+H1EzIaKn+OS/uxbEZhvXcS?=
 =?us-ascii?Q?GYz7gzpr8FV/HfWZDB846nUjIdaW4cci+t7Qpr5Xf3YE41XluRTgRbB4n9lJ?=
 =?us-ascii?Q?cGcer52V9Pa8TgOR8Ts6TElUwThNfLCkOLtNB2lNOVLjgzzct7c///x8DyN/?=
 =?us-ascii?Q?SN7svon4YidzdCY7WeUEYSJAwjDwtlPvrC/Mwk/krjQxlQ2sthXDRVxJA7np?=
 =?us-ascii?Q?jxQPMuYVgtPLNOZ/39No0H80q4Ohlayk7zzJWL0ApnJuRsEcdqWxgqPQZ9RN?=
 =?us-ascii?Q?YEn3+AsKlw7NPoJ7ZaQz9cngyb6R+DzVIFDHQkxgQFEsS6oFURvBwurQB1WA?=
 =?us-ascii?Q?AKoywgjm3hJf9cDD7Okz+qhaYyPdN9ExrF8Rlomrt4dHM0k8N/w5vXj2l7wC?=
 =?us-ascii?Q?ZnSR0MpgIMoQI16aFbkjok2lhP5KVtFZErBjEg8y1Euf+jEbT/mRBMvIZwKI?=
 =?us-ascii?Q?8G23B5Ycbw0guabYHGsh0BqRe+5ETtAdjNiJqsLTJxFJ7cUccLAy0Kjoyyn7?=
 =?us-ascii?Q?pQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 113c8002-fceb-488b-e910-08daecc23248
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2023 13:06:43.9670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DsUoE9iva7jloEDdF8z0PaUjORzCcrpVBfD1ftcgQViFqTVFYgQkUhIoINP17/PD5Z0wi+SKoNiA9yPip8bZa1/nJ/vTCUIt0zorycWWg1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4421
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-02_08,2022-12-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=516 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301020119
X-Proofpoint-ORIG-GUID: ui7Vui1nDHgi4RUUhi9YZaOwMGg9O_LC
X-Proofpoint-GUID: ui7Vui1nDHgi4RUUhi9YZaOwMGg9O_LC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Martin,

> is anything blocking mainline inclusion of this patch?

I applied these to 6.2/scsi-fixes last week. The patches have been
sitting in a topic branch for a bit due to the three-way conflict
between fixes, queue, and upstream.

-- 
Martin K. Petersen	Oracle Linux Engineering
