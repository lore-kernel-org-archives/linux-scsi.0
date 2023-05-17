Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 275CBC77B75
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 01:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbjEQBo5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 May 2023 21:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjEQBo4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 May 2023 21:44:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2D21BC3
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2023 18:44:55 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GJx1OX021181;
        Wed, 17 May 2023 01:44:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=dZXnHi0mIgIxdrLJYhoh9CN6b0mTTIsrriQkWNyeGps=;
 b=DJQQMzgZfxZA8/+ie034tsMqdOWQdw3JEZ4N8O0nMW4qIrUowQ9FHmOggfzJbIdDUlN1
 sih+7m+1bXr2+HshxNqHQOBEBh81hGR5NFbJdJLeblYtdCps0l55y/fCLhvXGy57FAv+
 FzPZIsfrZQzZ+4BG6fPZWLwWXonMkcYBT09mrnjRTEHj+uei+PueuVhCkyOiNijBxb5i
 MKjilzyDqe/dk/OZgg6SRK5rKTkSYOz+OP+W6n7X1stcPdgiLAt67QKBPqD0NYdLTyYR
 ZuUz7p598Xhl6k9DeB02zTFrVSxqoAqZVyv8Wv8IEpbauLbM77klItYBhZJMmr6iY6z5 Jg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj0ye4f1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 01:44:41 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34GNAB3d033921;
        Wed, 17 May 2023 01:44:40 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj105a67f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 01:44:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TffJDMa/rLSi7mWVYqv1pQxo6ONW0vbbwW7py0FcJQRjkaGYcqsLiL8bdPBVKaZ2mlEwkYrDP9CWiIhOS2Aec37pbgVl7dTYrwf+oLzr+/k5R6w6UuMd4pvDC45nVfj6Wd/x1Clbke0BXclZcPbNut3do2l4x8ainvrwjyOJmDTXXHMzxCxbrH4jBE0Bv7StbyDt6z620ZE7tRVwUpdBF8Gis9muB4RYHfOc9z0Nw6wJLg6tHtFGthxAGv6PbSc4LpKaOpeW2u5bVrpcKyJJgBCzfHIRf1O5uvKTRkDvs4SdbQd7rul4rrJT+19m1EpigVpWjTVEGxZ/4ZWcNlK9LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dZXnHi0mIgIxdrLJYhoh9CN6b0mTTIsrriQkWNyeGps=;
 b=Rsn/pUaZozBnv1E81jK46cd6K0j8B+Mc622GoVqVD2igEkQFh8qM4L46Iwtt4fe9U00AqyTjosuaTFIuAGwbo4u72+tOzUyPdNeA0Xvq+Jw0w2IRtOD15i4f/XmBiPdbg89ZwXx78hY/t7N2YkLP6jddBHxWdlPRKZa3qWApGXbeT+DvXtZuNO+PZZq5IvbBjL10lzKNEbHOH1uFcEW391kvcf2rnoKAj90+PPmtCO3WvYCQMIijg482GAeUh0M7vZbkqWIGXNoXOeEInBSm1sppaONMj8FbnvKkjqRSxVFK+C0mHvAsKP6Uv6KGGBn8rO81X5XSIU3mm72afX7J0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZXnHi0mIgIxdrLJYhoh9CN6b0mTTIsrriQkWNyeGps=;
 b=qBBMYSMmrBtsDUSRlo6L3RMcsiqOTz1DhEA6nMDfJhVGw+mHi8E1tMKx8IO7Ca887zKYwpUwqeLTLV6CvQFikvYpfc7JYRhWlSkuFiYXl21mVmDzLdaLcx9LUtpQjwfySYG2HNod0Eg3UC1eOkNaoxGD2yPtuU3e19j153GzEcg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH3PR10MB6857.namprd10.prod.outlook.com (2603:10b6:610:14a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Wed, 17 May
 2023 01:44:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 01:44:38 +0000
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>, John Garry <john.g.garry@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: Re: [PATCH v2] scsi: MAINTAINERS: Add a libsas entry
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17ct7u3yb.fsf@ca-mkp.ca.oracle.com>
References: <20230516110131.388634-1-yanaijie@huawei.com>
Date:   Tue, 16 May 2023 21:44:34 -0400
In-Reply-To: <20230516110131.388634-1-yanaijie@huawei.com> (Jason Yan's
        message of "Tue, 16 May 2023 19:01:31 +0800")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR12CA0032.namprd12.prod.outlook.com
 (2603:10b6:5:1c0::45) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH3PR10MB6857:EE_
X-MS-Office365-Filtering-Correlation-Id: 5901008e-beb7-4294-5f46-08db56784634
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dbP5MWhGXhwYc2CJPsl4oh7nA2F+bmpMoBiwid3vp9juMucQckh+WljHZIk46aKLwpSGkQVGXxOf0fofEKJhCFUn7YFFpPlXqEMeWhfbvbS1SYisPMazi7aPPQJ9mhqUBuuKj5AUYYHsIfQXqWIsGMe1CUQQFpbw0+sLGdiEWFD5aqKd0+QXscCQ/feCYwp2ar8neR89vB25GhcFYwLxDJMuHsu+KvS5zjrjDxhEKkkZj5HaEdvQcV4/c1fG9thXocyd/9OsFmqi7AKCexIWZTgrDpO3eL5BG64wVrvPP2iGc516gWXzkk0fgFWymx80rj26AuAxkSOivlfr7TNvmkP971EuR6/6hZgCmk75yNNnbi+OKGFNTupgPNpQhrUVmWh1rUn0QtPFQHlXEcEXsCj9h1DfXQjxpM1LIIp9VDek/ee3VIIqLESqpek/bgc5mYUGFIuiVMbTBK+1XuD/x0TNIeqIYS11TkhmKmOkeOgd4rDRylT6bBKD/CAynF0KP2Qk3/NNOfoQfc1RgGrIs+8jCqLsx530gq49AHDAfmxbj70djzHKU1OSqhKwAOuU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199021)(36916002)(6486002)(6512007)(6506007)(38100700002)(26005)(86362001)(54906003)(4744005)(2906002)(41300700001)(8676002)(5660300002)(8936002)(316002)(4326008)(6916009)(66476007)(66946007)(186003)(66556008)(478600001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?24sMUt0AVCBTwb23k3ZMyagyYIJzFUsjdGolnNXjq5mwxbJ1W2ecEwxoO/bq?=
 =?us-ascii?Q?RG0c0+d1qypk1nxt2m6pWYedD0NlTIJcU5+YnSEMH3wjigc1HTccdxizM1Lm?=
 =?us-ascii?Q?53Rh3w5g1F5nT36Z4edW750tl6euL95ihVq5AJSLjLggECCM+LtcMRmvNgbO?=
 =?us-ascii?Q?m8eUdeBVNd7NIrXIp8hJ4Ire7ePmgDA+24nh94Wz3k//yZJGUjIdwm+lYRJm?=
 =?us-ascii?Q?YNIvBktWGon41E8Xqnj+k29HiA0oeqKLaOPzezp6FNzWhgbtXxlV2R9/d4/S?=
 =?us-ascii?Q?O5RDsYaHTOWqg47UYVmqFrBvlhxs+NY3fSdHKB0dK88VMPRlXOZn3Ry2xKYQ?=
 =?us-ascii?Q?vVSFy2fhHD/JnaGiJl5VMfYVcPdOCKuPg85Fu8Tm7Ozdh4rpT1bMa84DMyvl?=
 =?us-ascii?Q?MWPDa4uaRzkEyS0G8OKChAD9gPQ0/Dq2uMVxQqSEXmpuYMGm/M0LIsBtRN8n?=
 =?us-ascii?Q?TOYGhxspItZqfgh1MrtAaPJ8o5M9FcfutpRlMlOCEeM8LGM0TNo9H3xV3uqb?=
 =?us-ascii?Q?phuxyqVNvm6nTFKGI5/cIy+e17JrxNAWAb8qkHbdpy4QjJIzHUsITWPJw7Yb?=
 =?us-ascii?Q?+TAtQlEflVLQDo/HoyiMMS/I9xGo5bXu/1d0BbQB9vpdN5h/TiUxTKtxnKn3?=
 =?us-ascii?Q?jJFkN5DpEjkyxYeHxmVxs3PmQ/8kuQr5VWrbn60aSxnN03C98K/wmlcnaGWl?=
 =?us-ascii?Q?ZekgjahL3YS3qSbeOyOv7LxJDuzT278m9l/fa2o6imp0v0LlZ5Hiq5u7dP46?=
 =?us-ascii?Q?OAUDwcpAhmDso7InMDv1r3Xt4C/B88IQF1kj3N4ChluUF+UuwcbKv045D6Tu?=
 =?us-ascii?Q?2vMszAqPgJ4lWWXYZix/f3xF0lxHkfKv0XVzRKRfctLfiMxe418hwmcvSzTx?=
 =?us-ascii?Q?k88Xd7Zbwj2PJ7BpO5YnzCTHjTd02kpGvb/KI6yhJycXfYAMPWyt+p7sTW4h?=
 =?us-ascii?Q?csj0apJEJ0x2ivRwGTarZbKL1kgjaxaMwXVMF6QxwEZ+PztSO7gEAT0pQjEs?=
 =?us-ascii?Q?fHYusmuHaVbbfmgGsc2F4zjQpY9Ni21uYXJay2GUc3YFRLJBa7mJ57xQfQTa?=
 =?us-ascii?Q?O5pKg7DhTKcRqZ79HjmNDYg4MpIahLg3OXuXPwNotHNTeK5SnuHgDx29mgk8?=
 =?us-ascii?Q?vvBWYZEceZy9COBxYKnTuaHZjAzhiMozrJgdqRZAv9tgKWPN+q36TDsYyFvl?=
 =?us-ascii?Q?Xcwgp9+8hfqM1ihZBqurxsoJE33J6co6vNjFy8p8aShRgrROx+jG46rQ3qm7?=
 =?us-ascii?Q?4tY2SZkZzXRu7jgDUqlW7d9yh0TEayOPf+NO0oJaQZkwb6tAG5nE9PM81ZY6?=
 =?us-ascii?Q?lch6RD80RnPjREyVWJF+hO5k40EbGPcBWUVbKzy1S7490EsZf+w0+9XEEc+G?=
 =?us-ascii?Q?ImXo10HGDsi9alHb9SpkzD9W7GETDP3Bd0HPNj9ZZp//62Mcd8Zj46jOn5MV?=
 =?us-ascii?Q?514EQzw/QOEpJ1Rxhh45zMMZLHJYd0lfv9Z4MkcdApznolsA4upc5yjyxlij?=
 =?us-ascii?Q?/VkP1O1Ic2bXT7J1SLUJIBX1fDQNU5iLe0m2VfG9WerJv8TYSDe1WfV2eVwI?=
 =?us-ascii?Q?6795QshQo04GnMqv6ZF2cr/fkbAn+OeZ6DiAT2SyzfZUMgzGRSb76x0ta9jU?=
 =?us-ascii?Q?Hg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: LTqAVdIpK38t9M8xkW06yoy5zXIo5YyUzjfohquPWFReMWpC8+4L14aJzTV0c9x2mm06C4ebPLlBkvubZcjXbz7pTP8n6xW3gwJhprcbTPtq33vqEoaiV8CmR93CUh2ecyRLTVMUHwmD4XVGvsTPu+vfNx4BQZtcmKUy/nQmUo8Fgksc/cMBjPji3i7sQXavPNuA4Be+IOTwqca57zjLpVJWBpPFRmQUKRPTpUvgpRNIy5jFjB5LRSLadlA3W2tO3xXpB5cohcV1GM4sORR7AwxGz1xCISjzyXqTs2zo6lgxM8FL3y0ulET2J6QRCXpvZXQRZyrsFkp5lsXPhO5HJkrirATpJWksLcLPpJ4XeoencIns+ZEzN1pgbw+6j4P7c/cVeVF7XNQbGbuuFMq46jqq0zjA3C0i+kSqjYJDMlds+ehhKcG6VJ+NzDzxwKOEVrXtPhMa25prrhZLi4LvNJGl3Pe/gwR7fAL6qMLDDFd2GhekqvYP797449s4lxEh504U4K1sy0bLrGogNHg2ZYkDpkcFRmnTA8mHTYif5L4P8VXombQ9bmG/YmmyNajPd9d+4s0MpinhYx6zVRPp+BdCsq2/r4Pg3lFMR/Z/VyFbvvgQ5VtIQefxTewQi5eQRj0Y4XJlY24k2F9jRstX1GTarQlhKy0NOpMutXvCNRGUL5QNPPoNZbvpbGHSKHEqqz9qSUQgcKRh69TkqLc43bxpHNllhur5IZKW5YVA7R1KBXVd1Iy/B7/UsUQZmsX8YJOi2Z+eZPARt5BGjTGCEthPX1nahR/7fc1R/bpupX2j5mVbI5IJTbpoyuCr5ttk+2aVeleEnDNsK76yXm5vl6CWarF/PCywv20sYE/Lwm7F1lsDyyTOhI+GyN5LoSIR
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5901008e-beb7-4294-5f46-08db56784634
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 01:44:37.8264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5/+w1j8GoFbEyBQEDNAehRR0SsxRSkKdCoe24GUXzgNAMxTR9j0rFMhTk6qB2xnzZOQ9zse+HTuh03W5mOZJ8ProlxqRtsGixHqNbqKtvlg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6857
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_14,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=980 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305170012
X-Proofpoint-ORIG-GUID: Fs1IcEy64CB1gqXybdxZ_aPQN8ccucRp
X-Proofpoint-GUID: Fs1IcEy64CB1gqXybdxZ_aPQN8ccucRp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> John has been reviewing libsas patches for years. And I have been
> contributing to libsas for years and I am interested in reviewing and
> testing libsas patches too. So add a libsas entry and add John and me
> as reviewer.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
