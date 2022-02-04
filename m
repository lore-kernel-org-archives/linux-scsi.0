Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F25C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Feb 2022 03:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356847AbiBDDpL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Feb 2022 22:45:11 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20360 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232345AbiBDDpK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2022 22:45:10 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2141ctnd012482;
        Fri, 4 Feb 2022 03:44:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=wIeHDwSnq8mU0jXev2VjDL363UAlPShlwi+r0+Kr8bo=;
 b=mHYW2e4PYkTh1gvmiPpcSDNmyQzooZiCejlLzw3XQ3+Nhe9w60/lDiDlb/6agUOVNhSs
 spKUl5GRA05DGhNKmlthX20KjLzWphzvCwa35f9pf+uVd6uXYPXUsWIKcbJYpQIAHCEt
 797vVlO2PhviA5Ja5AOM/rgeY/4V4I6HWardEaBcuDbsktHZd9eftGvRRt6EWD10RdNn
 JweZOKWo3yseyEzKIIARQKFru+Ndb9h2gdQsmcU9ZJ7cDV+jLKbvz+MBXcq9BPT/X7g4
 W/dIRHbwffOq4lz614ObfEWFd5/MpuIVyRp8+VSYR84eyoTPO9Pp84Z9H7i5cRIB/5Km AQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e0hevsk0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Feb 2022 03:44:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2143fpTD011217;
        Fri, 4 Feb 2022 03:44:58 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2175.outbound.protection.outlook.com [104.47.73.175])
        by aserp3030.oracle.com with ESMTP id 3dvummstpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Feb 2022 03:44:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OErLmPYoxjr3As7LsRYU8GCZ5zSFiKlz0yGTID1nP/QITG+Qofa/DrcZKVnSNYAtsOI85jmk8ah7g0JJOqZzXVHeJ4OUlQjKYQRvRoHlEDGoLjkMvKGgAox1nTw8ilrH4DiuCqKRJ/aEdEgzOqeM5fxhivLdh2xgEIXkpNptjismTcMKABb0Vu5qE9Y20UEqqxM4RbprxIgzJr5RhS+UTEX2bBF0uFWU4ewABcLGYXMsSq54Q4V0e4gbc8fZAdWh+VPzFzYm2e7hACTWk545dPjlmW8zWSfW6PSylI7BSM0WCza1iZ3l9g/Vrn1KjG34qXj8UGTtKrnekT0hroz1cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wIeHDwSnq8mU0jXev2VjDL363UAlPShlwi+r0+Kr8bo=;
 b=Du5wBWpl8OGRuOAYMq7A5fRf9mM5rtiuYnzHp8yEWT+t2yJn90bPpAHmxPAArs0jmqd95o+/A57/grTrhAn6fiXVM/CLSSodh4VcDP2mmE+7W7f18oQ4sVt6jFVqh2vNNHO9gUl+3CSHajHvx6cjozrMKOzF2vkBdexxT6BEA+XtYfpwdsNfEkltixXubr/NLDDzXx01KxrcXv31BR3IVj2z/NCpJZtuatwQ/WXg864RFaLLUVlPAP4xDg3k6iN84NFfGfFOevmAqc+dpLZtN5b5BVlMTKH/gLEab4z90mecSY61OXIrjSVxOpNOcXkr51vxDmaGyW671oKAyom2Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wIeHDwSnq8mU0jXev2VjDL363UAlPShlwi+r0+Kr8bo=;
 b=k5Gy8ahEh8VNU0B3NpHHeh4MsAPxg9qbgcHpVkYTsyh6sNKpAdG3wCkGDk2eqN7VV4TGBp9pGeK/CwSKUjTYaN7U8Q5vhIpPAD+OmoZracZrIMz6T3231eyp0+nTld8b/3EDLKbqkdIquvn0pa7qERHrOGrYNT9IrbMQtsR/0Fw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (20.182.127.76) by
 SN6PR10MB3008.namprd10.prod.outlook.com (52.135.126.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.21; Fri, 4 Feb 2022 03:44:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2d45:d1bd:ebb9:48d1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2d45:d1bd:ebb9:48d1%4]) with mapi id 15.20.4951.014; Fri, 4 Feb 2022
 03:44:56 +0000
To:     "Ivanov, Dmitry (HPC)" <dmitry.ivanov2@hpe.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@acm.org>,
        "Lyashkov, Alexey" <alexey.lyashkov@hpe.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/1] t10-pi bio split fix
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tudfz49v.fsf@ca-mkp.ca.oracle.com>
References: <SJ0PR84MB18220278F9CA4C597E2467E8C2279@SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM>
Date:   Thu, 03 Feb 2022 22:44:54 -0500
In-Reply-To: <SJ0PR84MB18220278F9CA4C597E2467E8C2279@SJ0PR84MB1822.NAMPRD84.PROD.OUTLOOK.COM>
        (Dmitry Ivanov's message of "Wed, 2 Feb 2022 17:42:26 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0241.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88fc92ae-18e3-4a3e-851f-08d9e790b5f3
X-MS-TrafficTypeDiagnostic: SN6PR10MB3008:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB30089F397E2FC20CE157A93F8E299@SN6PR10MB3008.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XEZv1gj1co6fM3ZDgdKgaWZXg2zirrT3zYFPh0M2B8pkJMSsnxA83CJQkeG+EqJur97HQQfRRirE+fy5NHj7hVCtYMNlyaNr9fsAcAqUqCw/vle6aQ5ax8Y6SC+qM1YOCJIXSfI873ooWCqPPGikjCswQd4Nybl3OTAXKnSESgU+MSP7j997rXZMCVOkMipHAebbVtrYBWt+im97M/4ePcMl8umgWrE0Y5QEVs1HV2McMSDpaG5KqRZQ88elywdTmexDZaN1RNJgnEUKiZb1qTjUgwmgnMdm4Lco9AFFWtreg05SC9AjPdQxvpeZElaNLJ8JvgQRH0NZmmGAZLB3lB19wBwl1uIMtWuvz6aTfjisdUFOBO2Tccb64wBq9Lm9EehJdx6w3Ivu6/LmNC7S0vsQeTL2qzmoZbM9KXOWYfUDIE/hnNuUV6312GsaIxIjSVahh3/lA1EvMjS497kWeMdon2JH3BvDXLlCM4mmoMjnYzpuOfuMqZ2u5fekAGn4uVQC773TNiSSiMF/KySjRn+0avQ9c3i+btoZcDzSZ1Nv+5bDY+kHeIWebvl3/R50AT2KaEzM3NC5hLhGzIYX52fqoYIalZR7r0eOvzxmGWxUQIWVVhyqM5Es43+yV/1rin6pQOis8SANC+d35YE7X6D455lW/r264rN9eW0XN7i0XkPWwGTcHS0NX0GpIxG7ZNNFjdbeBcs1yYgcSCe4uA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(52116002)(4744005)(7416002)(6506007)(2906002)(38350700002)(186003)(6486002)(36916002)(508600001)(38100700002)(26005)(316002)(66556008)(6916009)(66476007)(296002)(4326008)(6512007)(66946007)(8676002)(86362001)(8936002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OHaZDkpH01i/N9qt+kYru0mQKRGXi6soVHn9+WvGr9NYvzJ/ga+QFiGygVTo?=
 =?us-ascii?Q?rMQf8j1wD5SSPcUz+GzqqA6LdVnkYwwIV+/jkb7t6HqjiSQ31NG5RSvGgz3j?=
 =?us-ascii?Q?xgap029/rIA3dOZVOwquPKuaRUVlia+7N/u4qXh+zK+HczduONz8EmzvGWZt?=
 =?us-ascii?Q?2OAY3KQK0cjKrlJi0kai7tMRrA6gdxebH4hAey8l7JFqYyURjwxxrd52FJvo?=
 =?us-ascii?Q?29DnSFPjjVZ4Ld1cfxVMX6p1kiha9yTVnVdhnRyKEV2ZD88M2AuS7pBkSsMc?=
 =?us-ascii?Q?lIg9kw/3nvl7FlIisgHTviTsAxBTqxUCfeAn68OjkhHpCuEgcA91Vclr4QsV?=
 =?us-ascii?Q?+SB+6pNDxyXdcDUfe1x7rrqqYBfGqdNrcmAESgd2sJjDVxZQoSaGYGh/wS6q?=
 =?us-ascii?Q?i2lpm/D9/cXO0h0cK9RODMIRvHWHtvrDEs2Mul95eFTKwfn7QiNrpa+6Nej3?=
 =?us-ascii?Q?ozwPxfDm06JOrpiQvj8OYwwZ5h+vuGBghTAaptQzn+y04w92RagnMO19lllE?=
 =?us-ascii?Q?3VwNJRoxOAtYfUDzRipXvnV7DCJYWPGekINj7FUy/d7oRQ/zIVJ23omj41OE?=
 =?us-ascii?Q?yPasGaosIHCC5RzoR5VXUhb9Y5WaSovBh8tos4CnSo41FjH9Xck6r3uQI4yB?=
 =?us-ascii?Q?B66xb5szjTXW6DuYhnMnzQsdmdoABuEzQ0wC6C1yXTd/fdozfHZ4tPSkdkbA?=
 =?us-ascii?Q?xvb5H0DnFDDDaIUU+fsOhQKJxfvo4EtK1wDfLTx7f6ot5MvT/KaOujlmY18U?=
 =?us-ascii?Q?BA2M5IQ/1H5gNDNB6xurLsxF1Pe2ZpHi8tL+u9+s06RewcESLUfCd9UJ1Qi6?=
 =?us-ascii?Q?leiQ0K5ZrQCESflt8DhE5aR7Vhs7VcECmQKks4Iy2SRuGNax/2c0zl8rfXJX?=
 =?us-ascii?Q?/iWHVSyTDDu4ToHVnWr2Y7Nmuwj8ToZ+rfkTf1UCuQMWiSCC5L/TNUxaBOJn?=
 =?us-ascii?Q?h1E1Js1UCcr2CIZ9+6Wf3CfvHyqz21Cz0bHQ0F1lb4x5cdTG4ZBCeKPEsmzT?=
 =?us-ascii?Q?Ica0PAA31/iHW5PaDJMses+e8rbIZQcyovQ/F1/yyWOOCm2R/KisKtqKhvsy?=
 =?us-ascii?Q?jzGEv3S/qcbnON0vSMEc+PmZWU3LFmK++EVDwgT6YQYIwZOItZODoVK50T/N?=
 =?us-ascii?Q?esxZAUibqjFo88wJoV/cMfQoeyeGEUuymgng1hxQH5FkkOC5I3MYdUdL0UZd?=
 =?us-ascii?Q?vbQ3q1Mr4lFNxUH/LeG6ejiVhLy6Y8fnjaTG2/Xy/caTlm8WgbujbP9jrWN/?=
 =?us-ascii?Q?jjtf/I0XV4WlerKOgV0gMseHwKvfxuvJA0rzsLJI8i+tddQZnMy1iCryMQC8?=
 =?us-ascii?Q?QqrxKk9PNXWIy54plYLC/AN77DBoUN1p2CYDFY509/tE7GRrRxiAnfdXAUY8?=
 =?us-ascii?Q?r2aIsHlrrBQAvpdGq5PfLCYysgjMxOTtjsynl8c6lrl21FGM0jHQYiqMLpWA?=
 =?us-ascii?Q?fm1F4+wTAuH8qf1R07psXJZy5JcIhGxg5PeJsFFEhgH+DlSUHP0erb9FMczn?=
 =?us-ascii?Q?xetlIItQJfzgosTUtM64Es4G+22QXVnlxLQfCGv8aP8zpzvIr9Hm4TPLklCU?=
 =?us-ascii?Q?XiyvDrLKxgMKRUHs/2EkBi/YKjd6LImiixHSYiyhp0esOXixX+gvbwGWwrAD?=
 =?us-ascii?Q?Fu4zTA51QcsX5DrzWSEfo58Z9eC9LnMUCUpLBpJ2PTT1RyeUJAwQ3LwhayGm?=
 =?us-ascii?Q?YrpC9w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88fc92ae-18e3-4a3e-851f-08d9e790b5f3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2022 03:44:56.4682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nsi62GA1Z5HZ2/yJplGRwWRQGMH+9ExMvCJFYkbMPKsyqOMRnb/iKd4Qb3X8SLUJpCv+wlKN7f9x+aPYNkBsNQDf+SyhIVQglgjOanANzbc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3008
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10247 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202040016
X-Proofpoint-GUID: Ok4uAX5fbBFiwUeLkIDfNdAQLr6HwpMK
X-Proofpoint-ORIG-GUID: Ok4uAX5fbBFiwUeLkIDfNdAQLr6HwpMK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dmitry,

> My only concern is dm_crypt target which operates on bip_iter directly
> with the code copy-pasted from bio_integrity_advance:
>
> static int dm_crypt_integrity_io_alloc(struct dm_crypt_io *io, struct bio *bio)
> {
> 	struct bio_integrity_payload *bip;
> 	unsigned int tag_len;
> 	int ret;
>
> 	if (!bio_sectors(bio) || !io->cc->on_disk_tag_size)
> 		return 0;
>
> 	bip = bio_integrity_alloc(bio, GFP_NOIO, 1);
> 	if (IS_ERR(bip))
> 		return PTR_ERR(bip);
>
> 	tag_len = io->cc->on_disk_tag_size * (bio_sectors(bio) >> io->cc->sector_shift);
>
> 	bip->bip_iter.bi_size = tag_len;
> 	bip->bip_iter.bi_sector = io->cc->start + io->sector;
>                ^^^
>
> 	ret = bio_integrity_add_page(bio, virt_to_page(io->integrity_metadata),
> 				     tag_len, offset_in_page(io->integrity_metadata));
> ...
> }

I copied Milan and Mike who are more familiar with the dm-drypt internals.

-- 
Martin K. Petersen	Oracle Linux Engineering
