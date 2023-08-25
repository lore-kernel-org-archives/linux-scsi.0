Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F4D8C3DA6F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 02:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237208AbjHYCiH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 22:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241215AbjHYCiB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 22:38:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D1B1FC4
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 19:37:31 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37P2S68j003966;
        Fri, 25 Aug 2023 02:36:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=o4Vfcw0YetPvyQdY+vekVvHRpWwMw24FnLychJUv0ow=;
 b=2xv0vAgwQctaT/Q1HhRkeg1l407wNPVo2LtZrBEIFLz1EmAESmgmm/UjaDY0r/bf4dv4
 p5d/04NHNYIpg4kvcfxf3fTKy++Alo6KWigpPse7crqD2/dX95Hhoqx/1fuOdO+P7tty
 6vYZZr6E3S1TRJKkTiPsomsp2wBwXjF/hdaPxTy872TWcJ3vhm7BD5ZCKTKA4ApaQtor
 +6G/RzZL/EA/P9NdTIPZV2449tZmqDgwuG39crvOeGj6yAYZ//zi2rf+co6LpxBb5zZo
 EVo0b+VCYO3u3dapB2PSQ4RxwKb6eEyWhvkL+9paHTmvsgSz/JsPxZqj0ol/sdzcJ8Nd tQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn1yxne9c-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 02:36:28 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37P10a02033220;
        Fri, 25 Aug 2023 02:11:51 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1yx9chd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 02:11:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4jwt1WVNewKW68JxPHfH3JAY1fWtbKnGigou2jOc0VZX10D2+hfaKbRV3giCrgikup1WOlfYzqoPdq5iU0xwNQMgJA4dIRrwPiI8jnjgujTcDUzd+YykE6ga7k04nyrBQCaSb4IO5Tr1y5H8HKsoroUaHXg+fd0+s6Ne1Lq/XU5iMl2HNSgvfUmEmWHgPbnG2Pny1FRJZ04RweWECrE5ND9nqiXDi91pwS6LibwHfZZXk9cA4ybhcrwskYC44ir+AtsF0fTHf3fW5rYS0PW+NZ//yhYBjM4pZtRDIhUifxiVJ3Sd8JF0PWFxVbIzuZ0EegfG0ADOanUwhiaP9CDAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4Vfcw0YetPvyQdY+vekVvHRpWwMw24FnLychJUv0ow=;
 b=gbjiT0DvsIkm0Gat9pc7OydK7DVVFljgcjzgH2YgH17CVlvlMotFimIyTXdeKwIbUCo5hXktgM14qS2Y8r7k7WzI1zvzbtT0VsjpJxvVOlszYMS7Z2Qm676FJkjoJnWJVTAUaoS6AHsX6yWJhGbkm0W836wvN1NJNT5e6L3u2lZjbLPOVi9zemeu2PAirC2FvdJaXQWuUJTXlvFbbeiZsRxDNUkwSG2e24F4ttbbQD+9P1D8PFChmJ7ZXyLqL5J8QgJ8R52ncgt8EJq/C/epyEJ+YHUB9KkoN6y/DZTe8FDiT+pxzOzSubXotSMsVx97G1H/TPC1JQ0ZqAOQ6pKkYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4Vfcw0YetPvyQdY+vekVvHRpWwMw24FnLychJUv0ow=;
 b=vZ9sWpmHQpvDED8Jz13wJl2aevRWVCqoEJHJl7Fx5HHhFeI/aEuSkoYhtr4roOaN5s6ZXuT7UzDpq9Jp/KcyNNj8lFLBepWqdVmH3u679oepYjdwUHrXfPWTm+GpK+h0LfLFK0CzdhssqdgE4VU5rHzziOYVGFlp3DXDsNmhERw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN2PR10MB4381.namprd10.prod.outlook.com (2603:10b6:208:1d3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Fri, 25 Aug
 2023 02:11:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.027; Fri, 25 Aug 2023
 02:11:49 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Don Brace <don.brace@microchip.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v2] scsi: core: Improve type safety of scsi_rescan_device()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1cyzb3m7f.fsf@ca-mkp.ca.oracle.com>
References: <20230822153043.4046244-1-bvanassche@acm.org>
Date:   Thu, 24 Aug 2023 22:11:47 -0400
In-Reply-To: <20230822153043.4046244-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Tue, 22 Aug 2023 08:30:41 -0700")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0153.namprd02.prod.outlook.com
 (2603:10b6:5:332::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN2PR10MB4381:EE_
X-MS-Office365-Filtering-Correlation-Id: d2565507-6f55-4712-b27b-08dba510a3ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TDNd2cy49DEx5F7PZmtQ5Pss8jmb7iXzqOyjbb8PCBqSKeAUS1zQKBN+zYIIxqSEVM5AFyX9Eddy00rpVcy0wq6C3c/mHxXxSf0rtL8EPp4Op9akQPzqWv+9KC490rvrSbtuiHqInPXvjqD6pRWHLdp/7g6mQWXC4nSwOIX7Kq0yUshP8of/6VNOwU71KGEPbWWfsC0yLa4a4lENI7aoXebYxATIgpg8JbmiCgqnFycOYl2we97kI+AugAigPJI7wz6qDPYQntneKZE0GsoBr4PZ+iUlXi8Ofox78j4YyOqmvOHJGukeSAAQhT7dYY2HUBCWy6Bo76jtRdbgngK+tQPAj9qLBC0tbfNXnofG4nj6bZWMPfsNW4/iePOlOrmsL15pnadEjWXYj+dBNTF+YlAkOauTZ1IZyGNnoBU4kYYV6sTusMxJyK7g+Lvtswhgu9W8zREQvhXK0RZDPn172cUSfYMzNPrZ1ffa70qoOKcf55Y3mYgzwbaFJjYqfAmXbRGWAVNhT6unu4xRs9FL7eOqn/XKMtVFyaN6ei0A2NqxUe8BaVNP7/HXvfuWHIBo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(346002)(366004)(136003)(186009)(1800799009)(451199024)(5660300002)(8676002)(8936002)(4326008)(4744005)(7416002)(26005)(38100700002)(66556008)(66946007)(54906003)(6916009)(66476007)(316002)(478600001)(41300700001)(6506007)(6512007)(2906002)(86362001)(36916002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xBr5rLnDZOYILk94XtCLgW4I09tJYWQ46tplSix3OQMDfkAoAruBcwwiD9ni?=
 =?us-ascii?Q?kM665jBoL3ilWVwRXvCUbb2efiZvZfeGwHQE+kFzh/vFIILBrgG4GKGP8DVi?=
 =?us-ascii?Q?ielVr6+Ws0zaNdyXb1plJKK8Jxry+Q/aLCuS68pCFf+M+p0z+518WcIO+sW4?=
 =?us-ascii?Q?A4/4xvI/Z7e5dGbM1pWCRr+ZwV0ZHclE62xojAo6dsvU8OZrIhcmSZb6NhW0?=
 =?us-ascii?Q?i5fNunOyv93iXQMnetuiZcds9aDWEgXkrDgNh28t8MkkytVwY9lnsp49VfEz?=
 =?us-ascii?Q?Le4oO1/T1cs6oscr+H4/rYBJzaR0k2kRRI6SE5f4f07Ydn6SHmiYdl+vafpJ?=
 =?us-ascii?Q?QlaZKFCW1U7v28QWz/5IiHbCW9gdNh7IewPXHkKeVts1nEQ69dSP52HdspLT?=
 =?us-ascii?Q?aDhGAjFTBMlx7+/lLC8VISwkK2IFTabp94VI+UrIkLxJMmGV5aAObRkb+doz?=
 =?us-ascii?Q?aAOdkmT8Avsr6gjccw56CWGxuamjwhYFTT0lA34lqUf/wSLk3I257FUemzht?=
 =?us-ascii?Q?9byDF4Gnvy0gHVzFOaseAr1qhk7pZsa9GfCsOd12DPZUITWl1Z691WOvysJk?=
 =?us-ascii?Q?8zklfNNfmkehegXawrlnAisn6SG0ftWfXvkbP6T4s3rP7gx4zNoxVPQzEwl8?=
 =?us-ascii?Q?MAe2ksRemDfRZY2vSiOtGe2SSguUM6G7X6Fr0zgykVeaktnPm/OHToC2E6Mg?=
 =?us-ascii?Q?saN5e7Ng9rZgkCoG1P+tYBM0qBrSAnDIk2iwcoB3RBNkONOZm+8Cgqt/EqC/?=
 =?us-ascii?Q?P/opxwfPp1kdS9ouHuc9JeJVeRdaIThpg+2oKujfqEkzdFZitVhhPNvUwxsR?=
 =?us-ascii?Q?9LxeG+JzNlE4dx1yjmnosWmZPpj95JNezAOTjjuAG1zk6bfYSDnTjrt1Jf32?=
 =?us-ascii?Q?C5EZq6LPUbxqBhlfqD6P/bX7hsvhR/JUGLkuAjo4hpBZwtwvXQG7kKkDcbf1?=
 =?us-ascii?Q?3h15NgsxlrJGLa6Fs0671OnVFcb9mkd3D9dDn5QfKqy3vcwpslRIypQE1fxb?=
 =?us-ascii?Q?pFWv4X5WTt8T3176kMxF4s7j+cWynKI8tGIY/Kz2Reqr/Y/LbsobCP5P7vFw?=
 =?us-ascii?Q?DAc1dyK78ujBaC6n4LOQzU1zAduvoNVFr+MUHfafO9BBBgTkLcXbjA2IUzMT?=
 =?us-ascii?Q?yi9bgKn3LPlj8tnt3D1yhmzaAustp2JcXgo1bbLZh3By++4PTtdzipr3Bekh?=
 =?us-ascii?Q?bFrjQqUVZH84OuL6+Jj16gEBb5b0UCsGTwhepOXMbgSkdwHrTrqtkUzNn97b?=
 =?us-ascii?Q?vMdccDgugPyVXWW4Tb8FmHUjaE/kggEKJizX5/kKtSPUVOUYONWHh04+XUGw?=
 =?us-ascii?Q?qLAms7p4PHzmbkqaxsr6/e1iSEQm56T4y6feu92fyVsj5/UYYAmo/5FELEl+?=
 =?us-ascii?Q?FkxtjPL7oXbkMG6q0Q2HncuF0DpPLBZeYhfykRMSu0q6u0IcqMcQzljyxVMn?=
 =?us-ascii?Q?kNf3alN8ZegK+eARSmqzdlBr9sDRRl1vIowp6MKLSPOO3eU/BSB+M+KKwQlO?=
 =?us-ascii?Q?VdMyVayIHqHX1QkrEw2gFpLedTJTNLX2pYBW7fqH7pIPmXAM9Fjkb8yN0PLn?=
 =?us-ascii?Q?hAz9A4YMCOX+/R9XU9DFmr9WcK2RYZ7G3n651+s+idgYz4iqJz2F6sb9vwvt?=
 =?us-ascii?Q?Mw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?nNrdmSqWysRmDuoFAH2vowy7klQi9bF4TGeaRvghcfIF+e+P6P6BnO+HdjjA?=
 =?us-ascii?Q?BbymBjISNSrwNa91JwnqeHnnFGXHeY0tYV9Y3wahfabq9tHfX1bVHdjZ/Nhx?=
 =?us-ascii?Q?Fuitg7pJogPChyxNdmBdqaD45CHsOFyP2rKdI7t2MSHdPXr+PQHNAjTuvkva?=
 =?us-ascii?Q?kYEAnpY4TEMDVTkPcEfjrTobvJ9Ezly96g+vu6vqkhko5K4f8fdO0s5JFLaf?=
 =?us-ascii?Q?XDyjB9fv0h/MsjZJJ0L+P3jlGfhGb5i5JXmTpM8Uj+f/ryWFW4Ju/jvhEIzi?=
 =?us-ascii?Q?GgWD4hLVdK5wEONWdGsoDNJ6ncPmQnJmFgpCO/9aJ1XSsGMQEtyrtZHn8o5s?=
 =?us-ascii?Q?sLz6mlVL4mzENXbj7gHr7TFXu4tl7xfbph9+VP3xdbI0jLEcHbJfPF4IvPIY?=
 =?us-ascii?Q?oROfQbv7HLqtFarva7TfZ39Qx1bvHA12iPLxl+NgWEAgZ01eyhlBncdNJwyX?=
 =?us-ascii?Q?BW800WDI+vmYm1Ux2vfptE5OK020gU/MxoDY4uUpZRByuIbMNxu9MjG8BuOG?=
 =?us-ascii?Q?chOj+p+DD5CXT6bc0TUmGv61/diiklkmDvlyPOkcQzsbHU55zWtOqpI9pYmQ?=
 =?us-ascii?Q?SpdyDwVGAhNgykjfwOP4WTSGk7F+a451C60m095T4S1RFisNT0BIt1u7j5qb?=
 =?us-ascii?Q?fS90FxvS7LEHuksNPfjN+KrStXWcKtpxEr9jCbLsUkLceRUBQV3hJtnIc/Zp?=
 =?us-ascii?Q?S4MoA0rwmLdkwn99ZZW+LH998CLB1nTkXxdG2OITTI96A557x2ay1Yi7QO3l?=
 =?us-ascii?Q?MAenrb/AGKyX3v2kJuuO7fk1Rbm5m6keSc6M9Ih6I0OvkmERDrIPJuSUr2Kr?=
 =?us-ascii?Q?y49tpiycgIpqxsWv5xYjjE+Q1lBvjnghk06UpeEi95J2qWz6yfsEPrzmAAYI?=
 =?us-ascii?Q?/Bb10q/g290SqtTuPb8qmckztUu3U4v71AxCvIQSx1hTzYezDCcOjpFW/jY6?=
 =?us-ascii?Q?OG4CYCBkZIlsZaPLgMYrxTBGJLV1fT5zyXukcL0v50MZHvbMCiqSAZZHZ8vp?=
 =?us-ascii?Q?UrHrwR58Bh4roVUo2dRrW2/Eyq3eiL7dd9LQnQgMJK2uYafuevie3qP4DLVY?=
 =?us-ascii?Q?rLJIZQ6D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2565507-6f55-4712-b27b-08dba510a3ee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2023 02:11:49.3460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KaTrSQH5YXPu4DN0gPRQrkcRx+v9hD1UTImOeecX8l6m7lsBhHkCRR6UiNAuWpQSRHBb06woZ87Dk2cN+Du5KcTF4i8GCZiZMMdhlxyqFmk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4381
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_01,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=937 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308250016
X-Proofpoint-GUID: 9q3fDAqRuKXHDB2lRJrd3gcVEyqUKHdN
X-Proofpoint-ORIG-GUID: 9q3fDAqRuKXHDB2lRJrd3gcVEyqUKHdN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Most callers of scsi_rescan_device() have the scsi_device pointer
> readily available. Pass a struct scsi_device pointer to
> scsi_rescan_device() instead of a struct device pointer. This change
> prevents that a pointer to another struct device would be passed
> accidentally to scsi_rescan_device().
>
> Remove the scsi_rescan_device() declaration from the scsi_priv.h
> header file since it duplicates the declaration in <scsi/scsi_host.h>.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
