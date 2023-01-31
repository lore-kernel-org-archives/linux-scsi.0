Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 285BFC61DA4
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Jan 2023 02:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjAaC6t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 21:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjAaC6s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 21:58:48 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E89A14485;
        Mon, 30 Jan 2023 18:58:46 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30UMhstK017386;
        Tue, 31 Jan 2023 02:58:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=dOtXQij2Ok2DGGTmCJaXl4brV8PPYB5ZwFoA+tapp9g=;
 b=AJdIXzwDFcrREK/MQg/k9LDF0zZJyOgE6hX5BqQQjlfhL5FG8ki8Em1WemaEZc5t26iX
 M2eF3C16Jig4BDpqueUM8eHsoBRe4vPOm9WX+hulCSTrk5xgPKDOQTJ9Mmx7Ed2UkX7E
 Oh12eRwijiLh2EruXRdMKriBm3RkHYnQg+H+wJj+p/g4HF7sVFlxLAWSFEnFbKTqdm/2
 dfd9g20qD+PxXzTGW+OtO6yl8FPlkp1wzZVIGWuGSe9VvGzBlHyhBTY6rSJFtns0E0Gy
 uvDQlrtdEUUFiqvXY6Cy6ES5OvFoSvj5NeXn3hVXQzH9S73XND+eNNFajyXDpuwJbVWl Rg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvrjvepm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 02:58:38 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30V04Z5l020493;
        Tue, 31 Jan 2023 02:58:38 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nct5bscd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 02:58:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0MRfIeXIdcJ3d8y8HI997qeRqPUZubLwL+ulcja1iX2upPrLfEvUe63S07lLjFzCDd2Ig4ArwdgQ0yCkTY8yM+7/EkU1AxXuK/lw6w0UomD9Wfbl8O7mkVOxHg6sZunp9xIyUQqpw2wdnlPIyds3ookLwY2J+Jz+Gkp85Q1CMQbkcdwnKINCv4nfQHooo3FqCgz2pdvcx4TslAi1zyHkY+/HZQ5pZAFY0+JDqFAn4HJ8Jm9xi0fqT8BWI/n6A+uFJPv8So+3xc/hmBiYfCrOujtAa3P4VeShvdPRaWaq0nNlN0M4gCcnAx8OfBqPDw3I3jdRh3YjM20ynRZQWtqbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dOtXQij2Ok2DGGTmCJaXl4brV8PPYB5ZwFoA+tapp9g=;
 b=arFc7/vkbNOs7S54gvrxVRsZlw2QYPQclbz3xBYEQlzM8zgOYOHyk3zDVNUfZP9xUK4sxUWokyVU+9yObNuALAJlw8q6oeTIVUBklZ7HVfH0b48BQWRezf1MSIy7ii0fmVpqjLjI7kjKxLOC3TxygeaxO28NgAnw+SjIcZBjiaJdi3dsp+VpKgl+m/6dapBBkrhOvQH5KDIpdwRW/CXvc65UGXM8VFnUN/IKJm4ffXGVj++NISG2rsHWXyTuKYYdLbo/XAk6W5yRHEEsP0QqfEBaC5GcY/K9kAzFS2f2fenjmi0Ofv2i2FdcN2nRKIH3sxKRta1L2MFVm9rC1ikOQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOtXQij2Ok2DGGTmCJaXl4brV8PPYB5ZwFoA+tapp9g=;
 b=uy6I7Fek5TkxTitsKjzv2/vk3msB5QF8tN1ewDEZjJXFBru8JTnF9+wuQMLeS23L1dhFyZ+v2d+TvV80kKcU7dAr1dzMEDaSZWgktlZwYZ0gZynZqSMIuHCBZxhra4RslSWBVg1inxhsaEB7B6qlEcO5CpebVIniuxw52BfEYFU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA0PR10MB6892.namprd10.prod.outlook.com (2603:10b6:208:430::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.19; Tue, 31 Jan
 2023 02:58:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%4]) with mapi id 15.20.6064.020; Tue, 31 Jan 2023
 02:58:35 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15ycne7rg.fsf@ca-mkp.ca.oracle.com>
References: <20230124190308.127318-2-niklas.cassel@wdc.com>
        <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org>
        <731aeacc-74c0-396b-efa0-f9ae950566d8@opensource.wdc.com>
        <873e0213-94b5-0d81-a8aa-4671241e198c@acm.org>
        <4c345d8b-7efa-85c9-fe1c-1124ea5d9de6@opensource.wdc.com>
        <5066441f-e265-ed64-fa39-f77a931ab998@acm.org>
        <275993f1-f9e8-e7a8-e901-2f7d3a6bb501@opensource.wdc.com>
        <e8324901-7c18-153f-b47f-112a394832bd@acm.org>
        <Y9Gd0eI1t8V61yzO@x1-carbon>
        <86de1e78-0ff2-be70-f592-673bce76e5ac@opensource.wdc.com>
        <Y9KF5z/v0Qp5E4sI@x1-carbon>
        <7f0a2464-673a-f64a-4ebb-e599c3123a24@acm.org>
        <29b50dbd-76e9-cdce-4227-a22223850c9a@opensource.wdc.com>
        <c8ef76be-c285-c797-5bdb-3a960821048b@opensource.wdc.com>
        <ddc88fa1-5aaa-4123-e43b-18dc37f477e9@acm.org>
        <049a7e88-89d1-804f-a0b5-9e5d93d505f7@opensource.wdc.com>
        <b77d5e44-bc1e-7524-7e09-a609ba471dbc@acm.org>
        <4e803108-9526-6a75-f209-789a06ef52f9@opensource.wdc.com>
        <yq1r0veh2fa.fsf@ca-mkp.ca.oracle.com>
        <9547f182-4ec2-021c-5860-5cc2e3dc515a@acm.org>
Date:   Mon, 30 Jan 2023 21:58:33 -0500
In-Reply-To: <9547f182-4ec2-021c-5860-5cc2e3dc515a@acm.org> (Bart Van Assche's
        message of "Mon, 30 Jan 2023 11:13:22 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SA1P222CA0024.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA0PR10MB6892:EE_
X-MS-Office365-Filtering-Correlation-Id: 733a31a5-079e-490a-d2aa-08db03370b72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oX+m8ve8ygNJkurIhnx8q4RTtjrwQGRoGzMjue+NoDt5XTZ019dmiWgKvs9Af+TBOw9XwKrqzOz2pTTYBSE+m/lO0HOnvK/Kr4hHOG4h3/yyNH3YYsGuPOPpNpqxCdsUDPIeJlWqYJ7za21Z8ZahgQA9EbL4zmeMIMxKbGfuiefW8AmoIrV+cdLRWUKX+DHQa891y9+An/R1C+MOWISvncycbU/x2LsE+9mqjnpMH9zUoJt/R4SAS9/07U7KNON0eC3nPAUhj9xetynLU1mt8me01AWwJzZXmAx/CRDvyBumdWZy1+D/kdwzJOOyZCLyfyetNkpfwSR5WT6LYouvo4H0/H8xVtpQh8Q9qUs/lOZ/ctSHYCgEpQiQHo6FF2H7Z0R9KuwdAAIGoxa89R9wdrVesMqKY2x+hJiSw5lW9ldS2PLcbLje7dkuAbsx6a7UT8nX/kLgOmdaOKutwDRsitXGji4qq368LyXddRqjiv+wkApm4/ExN9lz7n1Ybl+Yv/nYKIe45ujfH+WFcOSYLF0uT2RgVBNVydU2rqxIpUdBew5ZHqJT12HTEsLJLcrPdeIUAtcDdWHtm4rbx4/uIbcMAwMtx81U2qNdd31fpsL6/VhfdJo7jDZHKNTD0Lz9JIadDj+3DhQiNwMdsgrVAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199018)(86362001)(41300700001)(83380400001)(38100700002)(316002)(54906003)(4326008)(26005)(6916009)(6506007)(66476007)(66946007)(66556008)(186003)(6512007)(36916002)(478600001)(6486002)(8676002)(7416002)(4744005)(2906002)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CKRd7UCrPhiTyxXUXsvmJy7Ur3dysPyoJLNs5TzyQ4ooRap323LZdiKTLZ5L?=
 =?us-ascii?Q?EYoq2B71feEg6MsCg1gdtv53BDLosRdUj7penm2w6vl0d/49RNdCBKE/Iv8q?=
 =?us-ascii?Q?xIlAUorHbxXX3YJUFQraKdPS7ZzyS63hm9VBSlUX84pZisFHXGzq7/kHOtBd?=
 =?us-ascii?Q?QjiF4wbNyYl6CrgBpls4V67Vhh4LFeHFum9faYwyJPIMv6Mrt3pq5mF1IDR4?=
 =?us-ascii?Q?qHFWh0LJ90L/RlTvtKRHUXiGTR/lHdejkI1BJyaXUGIRb60uoK8CYs0SlzE6?=
 =?us-ascii?Q?alZ3AECl2VZ+J7tYmW44auhlfsLPNWHbz5OuMsjomvIQtAmxAGrZs7puuIPO?=
 =?us-ascii?Q?3VabJ82+WglOYF4L90a5zKI7/7Y47PxVBnR439VBURp2h94jaAwHRWHAMozM?=
 =?us-ascii?Q?1jlV0f/u36GBoXmzapYC1792I/ELt7EWF0pENhxhsWXR4axyGxTskr0q8VCE?=
 =?us-ascii?Q?uqUE0AQMsaaob3pBxmAcXdluZlAK2NslhUs1tQSwNyOvjbNIxf9XtHirvk5i?=
 =?us-ascii?Q?KPjMz/6qfESckjqEqdWncaT6NhlfRKOobFmJcN7xwXaJYBSWvwlRBPrlU3es?=
 =?us-ascii?Q?PLkXQuhX1ULFTwnjBuT/4YZ5IgfEgl//0xT7QbglHyxn3i4Lf2zfi6uuruVf?=
 =?us-ascii?Q?7LIHv3raA7UG0uP88A2E35iCwtEFJC4jKmA9p0LBeecloFEinR5hgnJ3DeBW?=
 =?us-ascii?Q?Qv2RkUDLE+0UVQ35TXpyv5LPeuOqKbnPRiJGmLAHCH6Jc4ctlylLnU+qDC+h?=
 =?us-ascii?Q?PCKRhBLkp3hxMqaYjRqRwbgpOdUCECHLnaHTtNDR00o3ur9Pczk32KACQ2Ia?=
 =?us-ascii?Q?wmea2c5KOw6zMjYhjOcvOYRHZX9TnBxu0GQ1yXz4ydTaSL1dDQSLwp/8wY3/?=
 =?us-ascii?Q?48lv3QFv261M+R99GEXg7oU4LKrqUOIyaVvXR+LU/75gObi/IUDI3vVPmUHV?=
 =?us-ascii?Q?6gLt9HHAwdqdTrE4H85OzSUeamPbMwfCOhjY1WYD3jA6R4WKfDGKoBlUVUQ1?=
 =?us-ascii?Q?izcAaqS6zEvjcJtYskl17KFzv+SIOCfQTAoyJVuQQpkooSClQSCYkfL8xlXh?=
 =?us-ascii?Q?7Tb3M878T3aYtSUwGYf57c8jX8cYpL4fTJ4UT/mqMAeGm55V5sHgZVuKKsIL?=
 =?us-ascii?Q?XNOaXJVq3jube1OyP8vlu/2O1xwazDyUZXxJPOWDoQM0Uuw6/2Ahp3dsMWIP?=
 =?us-ascii?Q?hdsTAj8Gccy+YgHL5vyFt0BlEKGiVcLni1LLggNfokay4FyZH/a4Ap7X3l4o?=
 =?us-ascii?Q?MZRrhY+xJc/7/T60KED37B9zTCcFNYKeDw7M4NCbIFlMVxdDwmNmjkr7BcBE?=
 =?us-ascii?Q?e0OG0Ou0RRzhSKdyGJrvUlTn2nJxAZmEfECKsRl7r9ZLYJvun5h86n2P+/4Z?=
 =?us-ascii?Q?TyfEpJFFujKXqkrj9XpRDCLCv6N85R8C8E/5x8ZCM5zsVlX2qFR4hGPnzH4o?=
 =?us-ascii?Q?fszoY8NRmaJdSUfHXEGm2eviB3Rma3iMB4NHyGT8esH0mot+zPXToM8TxRZl?=
 =?us-ascii?Q?F4UINfzs5AvyO7CxCpUmEN+/bkXN+nPSPiI9Ap7t8ROBbusXRyFCtsTy04Vb?=
 =?us-ascii?Q?SGZK0KhIVPfAiPZro8raIgFaTfArB4R4DPER03nz6dIeZGrNFq2If9k8CG/k?=
 =?us-ascii?Q?oA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?7pTaSrYwAMMQXdty3yNLwgbm6SdvlHy8eIHIx2KESJupeW5zDcFOnLHmdqU1?=
 =?us-ascii?Q?yhQRyh19No8nUw12Fz8y0bld5gty0NmFbhk9j2cSuRxqHawdiCZeVB2Euery?=
 =?us-ascii?Q?il/CHmzmaks/EDRKp9BMzSKXY4zUEBJtrmfp+RMjvPnPJPMdWnZDljcKDB/m?=
 =?us-ascii?Q?octEpICVqpqVeAszC4SnZCGt/SRsFURgA0XsKsoaOGy4TSKELMipRrBHj7SI?=
 =?us-ascii?Q?u/qE55MKUVoiuAwKjUl2q/1113we0ZqWr7ZoDBzq/oV9FTAIwJ0/kAnHe9JP?=
 =?us-ascii?Q?CXXcTXCxdkybIPXzTmJyYqmKvcewdQjhbq079eplg5Yf2kE/T43axPx/jR4R?=
 =?us-ascii?Q?sLt8PqrV+E769ky5XbE/4DP/HDsTrVpl5RIatYotzULh9WZidNoTnUr9Z2aY?=
 =?us-ascii?Q?ohwSc8DJc+F573dWLECCyn8pAXl6e/96cm9nGDT5z05Em7knIdWEu1KIjjaM?=
 =?us-ascii?Q?G9lKJJNGWXG2+/jqqMJdth0xEUB94PuZQd9o42CcrKE7aUuVOiVhYUDU9ERI?=
 =?us-ascii?Q?sqQkPB/KwjK+kawi85/CASPC31Kbl/bJU8Jl8Hfn4Z8+IytA1JDnVMt6bSNH?=
 =?us-ascii?Q?6sf8EmQaFG1Eoz/NHm9s33jXLVpFR7FUah8YSXItYnrDejv3jQQwFbfVCHoF?=
 =?us-ascii?Q?bQySivoSdLuaXL9tZn5GPRKRrfg7AGFC+9iq+v2IZfIc1jPVUy/N6FyhLbVD?=
 =?us-ascii?Q?9HftEpAMe37mo46HTm1GdtA9n5HJ3vEEkF0nLSpwobhYkgODtnxCvs0NHCS4?=
 =?us-ascii?Q?l+tydl690Nlfai7E+LcjAm3MlAgfzrv99RsPF/gsfBTJtUb3Yr+zVJFjICbF?=
 =?us-ascii?Q?lbkAbYfB5IYk5p3zUaehMEqXYBQbFykuwVGpIRbvnXnlx45ssVO4SADG1xH8?=
 =?us-ascii?Q?UlU8ArNXkZXjE2zfDbtbOGzzfoY3p5tIN+aa8NuMHOqw5h4szZgLzP5HOlaH?=
 =?us-ascii?Q?i1FP3ZlqKPLJbsj0wqxsNQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 733a31a5-079e-490a-d2aa-08db03370b72
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 02:58:35.5572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sBrsqEHvKJ47TY5E/DVxtt5JcOkXQ9dNuQYvPxJGefAG8T5kTWxvMRlpTz/6eqCzc6f8fbZpcLZIb4j892XgHbvc2c1GD31OJNG4vlGQASk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6892
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-30_19,2023-01-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=849
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301310025
X-Proofpoint-GUID: r6DElsLgI_Sv-khfUJ-Oy5_oMuDqMQ1d
X-Proofpoint-ORIG-GUID: r6DElsLgI_Sv-khfUJ-Oy5_oMuDqMQ1d
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Bart!

> My understanding is that ionice uses the ioprio_set() system call and
> hence only affects foreground I/O but not page cache writeback. This
> is why I introduced the ioprio rq-qos policy (block/blk-ioprio.c). How
> about not adding CDL support in ioprio_set() and only supporting
> configuration of CDL via the v2 cgroup mechanism?

I suspect applications that care about CDL would probably not go through
the page cache. But I don't have a problem supporting cgroups at all.

Longer term, for the applications that I'm aware of that care about
this, we'd probably want to be able to specify things on a per-I/O basis
via io_uring, though.

-- 
Martin K. Petersen	Oracle Linux Engineering
