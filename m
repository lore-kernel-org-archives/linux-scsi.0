Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB1A8C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 02:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 767546140E
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 02:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbhEOCwH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 22:52:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51242 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbhEOCwF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 22:52:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F2nwpL060306;
        Sat, 15 May 2021 02:50:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=8fXLskbF4eagPNUCpke15u0Mt8M8gxKT6IKhVMd9K58=;
 b=pQEBTa4rCdzH5Nm57F3SiONyqkO2dT99/ozs2tEWHSUn6lRyhHDwNUC4B7UFVoLuJ/34
 zyizSeTGqMgUZZSOk7hLF/1edGa1uO97LwQMBw9U5D6UjEBiihaioQ6zgLkHMv9IIX3c
 d55bWZHcVOrm3K4OZNo2Gb1EUcWWl/LloKSjYC+Kaa/zrlZOI5tYz2x0V+ceMMiPKvy3
 nl1ptbvSfbhrGhX7G9PaykYpWnN8R6A+nSfVa+0mjCks6iDUjDJTBTEus2V84S2rvnZh
 WjiDxXL+WBbLHeENyj/Py8NZOzv537SbreXC49pQVskhb/DN+glHni32gAU+4P4xVuQ0 +A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 38gpnxwkx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 02:50:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F2noa7051569;
        Sat, 15 May 2021 02:50:28 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by userp3030.oracle.com with ESMTP id 38j3drapff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 02:50:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pi+QeqJ3xULZi1IFNHn4x5h+TP8aVk0engTCof/6dactIifIgKfI8Pk0Dm2ohpjwnFVnh4jjViy8l057lmbl0L12ezDs7zdomGZr8KNY7eCkCpoiflR7lDrINH/2n2IN2YnTIqBEWf+amb/mUicKlecq5oLMkL8Ad9/zm7bjQH8c4EqtTTzaBbigq7/neE0aEM062OMn6x2Axt5i9zOFamOIpXhIOQm5+8EInWk1HhOtIctbEjFP/e5gNwsEw6fzRk47HhT8/pwjiSA27Vf/i7cur4oaBPlk3qCZnSxb/Fefn0ZdakNYA5kiDN7QvFZsfv70Fqf4oDzByY2DhBjAHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8fXLskbF4eagPNUCpke15u0Mt8M8gxKT6IKhVMd9K58=;
 b=WsldQSdp1E9IPobCuaIWc0affbaHvsl4RF0AikYkIBMGf7oIy2vQuzFrz3BdJi01Nc++3FNiEm+1IkBhwBHkoQT4gcPYvh1gf2jzAjUfmxzvLJgvjBU7F/IBoz7KmPTxqhdmFKhh67n+FqVdJe2XLUb6luCY25ts+9PRE66Qx4/RPuhdWp/+rkZivgjgYoyEV7/OOkAdXElMopgq1KGkZYdTzwGEllVnLHgQgZ22nwLmhtiha3T3+luceePkgC5SjqZMRxyIM/kvZSUDbhVSx66MW7a6S+hbIb8BnJ2K06ih7FFIJab2VEag+xHorNG9V4rjpVJ5ecENygOUrMmmeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8fXLskbF4eagPNUCpke15u0Mt8M8gxKT6IKhVMd9K58=;
 b=B3bxYuQXV+5vko6kCFTu9JA0pLcm25oFRsl5uUywGR4KT93L2Je0cBYcSSZmI9UQUfgwKETDEfBoVZEsnh5y/6CpBfWXFhkWKtgeeq91v8sRQTrSASz8zgT3b6DQD2hkuP9FlnQXfmITbIYX7qRMDblhTT9tFj3FsKXBrtFoVj8=
Authentication-Results: hisilicon.com; dkim=none (message not signed)
 header.d=none;hisilicon.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.27; Sat, 15 May
 2021 02:50:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 02:50:24 +0000
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     <martin.petersen@oracle.com>, <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, <bvanassche@acm.org>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH] scsi: Fix a comment in function scsi_host_dev_release()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v97kaexm.fsf@ca-mkp.ca.oracle.com>
References: <1620646526-193154-1-git-send-email-chenxiang66@hisilicon.com>
Date:   Fri, 14 May 2021 22:50:21 -0400
In-Reply-To: <1620646526-193154-1-git-send-email-chenxiang66@hisilicon.com>
        (chenxiang's message of "Mon, 10 May 2021 19:35:26 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN1PR12CA0074.namprd12.prod.outlook.com
 (2603:10b6:802:20::45) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN1PR12CA0074.namprd12.prod.outlook.com (2603:10b6:802:20::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27 via Frontend Transport; Sat, 15 May 2021 02:50:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe416fc6-aa7d-46a9-db58-08d9174c3076
X-MS-TrafficTypeDiagnostic: PH0PR10MB4806:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4806F8295028E90A27A08B808E2F9@PH0PR10MB4806.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kQ++esMV7mhr0YJTDRjIYe3iYVUN5wsXDHFdTfgmp7aFGxCsKTu7iMCF/ZAiNw6Y6dttpwiXTbmVH6mXEhHESVASoTjT6xuLD93qRFZsRvx8WjUFg0QE2HGOxo/2y2mlfMn9m4vwYcdCHyGsMeUAeyzI61XhPPZpZdpJpnMRqM2ZUFk1jHGVX7RjjOYhRO0ouaxKH5GL+jp/3nMyp/2E3ZI72rPM6qp7ewTQiAPARR569qSq9N1WRD1QND+iuz/LmlTWmZl8QbsALaEvkDnUc1aQYxOrExL/8tqXYyJsb4Ef7TAa3PSrwKcnEkNjWRsw99a6Iz8/OZgvjpffWRQIoiihYI2Ucxs5G07q2fxzm492eIIee5vtCGgLZmQoEnJOR1DlRJPj2hHSUWGJpkSZyr3uFFRi0vOsHjH3lQ8UJ74A/wTLcGRjFeHwFSwYtS18FAPS/U+xbVLyWl0cyHovL0iR9buVWl2XgQARAlfo9m3Xk2Y2RL3dtzXU1cRVpfb7BtI1vrGsAnRTZEOBqplcC1vK91aIYURPuxt9wUdE6IAEgqufsB9qZCFWXktauGT58ctTWTRp2JuEsuDztE4vND/fIjfrjFOb7qrN7MuG99a8V2YLFU3rp4K3RkBtnnE57lFiFEddrww0ZbTu4vFr0D2AcvV4bMTrfQEjjqNYdZU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(39860400002)(366004)(52116002)(36916002)(478600001)(4326008)(6916009)(8936002)(26005)(8676002)(86362001)(38350700002)(38100700002)(956004)(55016002)(2906002)(4744005)(316002)(6666004)(16526019)(186003)(66476007)(66946007)(66556008)(54906003)(7696005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rBZhwKnPlamBy9zWoWwa6Jpjj4etW4LwrnmLS+tKNYBGHH0bV41yCM/nt1y7?=
 =?us-ascii?Q?k7VzVWs8j6EaBNPmvIQtEt8Qo+dHnQ/VCUZnAXVvQnDIyadKdby7qoN5p/uh?=
 =?us-ascii?Q?p0zjTSCZExjSDRsYfUC22z3lrrALZO+AHmVx+iovvGYubryq/eMi4gT6UDiv?=
 =?us-ascii?Q?z3sj8a9OJTABAFRSqEOTP0pn+qL3gGi3na37U+MibHoE1wVa/VQw+0tkT+if?=
 =?us-ascii?Q?Bn/jW8Hw0GXyhVdjYOthIJXoZmBySVi4Ot9EMOMbPo5GzqvyJvz97j2LQpac?=
 =?us-ascii?Q?upYHMUaR0521ALZ8HkeiaLNCq5JpMRWKLSdu+D28hsyZjZRkztLN4OSaALem?=
 =?us-ascii?Q?Q0hlQgkM1zyXrRw6mA3I8JsR6j/EHNIQNB8tN1p8cazDrPpeXDfLES1TT0Z8?=
 =?us-ascii?Q?6zEHSXIoMM1eoNSTq6mlMkMrJP+dkbBtZAj878rtbE8qV9qSqwF60tvDyOtV?=
 =?us-ascii?Q?dR+z4DUH2H8TVKOQkb7lVwcD8bZLt6mWCPwlQ4Axb03bQ+QG2oKGPxJCGWip?=
 =?us-ascii?Q?jaET+1iL8REC9bzkgKCrFqKztTOCneBd8rtMP3t3xnaRqs++tUNTsWp7Ph0Q?=
 =?us-ascii?Q?BoJ5xQs3ApIjyySoUTMpjztEtu1N4p+9bctRnFaNx3bqC4fN0rnR3Kq1c9Un?=
 =?us-ascii?Q?r5Bkjn5vREZEW18hnE/1hts1UWC3HFPJ2uKsVmfVRCsbv7tlWP2Az7f3W3fm?=
 =?us-ascii?Q?1BGy/CDcwPuHKXXmccJRTe+Oy0arQZA4rlyXT5KyTf42/eVmbLaz9tlNdjzl?=
 =?us-ascii?Q?0ALWaJtD86C/y4aNY/0ZTOXe5w9tty4QIfJFcDuOAPXYNsLXIhsuie8N3qxM?=
 =?us-ascii?Q?KiJxan4br92gXFmdfIFEVXZjBnOgq1oiFt7Q1kaKWF39FlLKuh7ScaFxw/n1?=
 =?us-ascii?Q?+Lkkgw88M2peShOly8wAKM4lny211aefMvAGLpI01thD24Z+IXOlzZODcBRX?=
 =?us-ascii?Q?LekGi+0/ZkNf+FAtSxEw8xnlg9C5mx1pOMnRkvK0pL+hkhkYKZvdtI1hu2p9?=
 =?us-ascii?Q?qRIB5cS2rplsYVHKHv07IdZkzceR5pmcSVdxXepzIoA/qo4sSYpxfhjhx5hO?=
 =?us-ascii?Q?iyJP8mYcjRF5MBhF3by6vCrA4L8UeZDKnekGqAvBh4lWpyx+uPpSbFUk0Kcr?=
 =?us-ascii?Q?0hTvGBwKdi5R9I0yG3kqabWr3agh09qTzttEboMYOwETBD3OnwYt28bqujDa?=
 =?us-ascii?Q?Czhc8xRdszluoqbwL8kgjFme9GGAxp18UL/7ZR+vw355FpAQSZ5TE9/tV9Ow?=
 =?us-ascii?Q?4Wa289kG1ywDxTvJwDfEm+YnHuruehpmN/9azq93wt/WUiZvy45W+PKL6Jo2?=
 =?us-ascii?Q?Awa5RXz3te5S45OPdAKXz91H?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe416fc6-aa7d-46a9-db58-08d9174c3076
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 02:50:24.8929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fRaMjKuqtKikL103nnet8JTR+7b1+/eVe8058/zlxxfmRhEk+e5e8UH5pPwMH9081sdGgu5G6pKqrxdC31AzkjHZGqo0RsE+rnGgSAATJwY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=979
 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150018
X-Proofpoint-GUID: 7_Vny_gaVMPjQ4PfbIMo-IFnm5ISoKq0
X-Proofpoint-ORIG-GUID: 7_Vny_gaVMPjQ4PfbIMo-IFnm5ISoKq0
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


chenxiang,

> After the patch (3be8828fc507 ("scsi: core: Avoid that ATA error
> handling can trigger a kernel hang or oops")), it uses rcu to
> scsi_cmnd instead of shost, so modify "shost->rcu" to "scmd->rcu" in a
> comment.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
