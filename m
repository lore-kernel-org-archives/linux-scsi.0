Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A0CC43381
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 02:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84F9964FB4
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 02:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhBEC5w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 21:57:52 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49940 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhBEC5t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 21:57:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1152sX5n045701;
        Fri, 5 Feb 2021 02:57:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=sI/G0LaTvhH4B/xO2CwfF61QIgr1UQhY7NaLR7lb6g8=;
 b=nxnO5E9Or6qv3KxeB2WviCiRcv6XfQlPpNS/qBCuImO4aTzu2shJNX5S9chcWsDC4dd1
 79MtZNS1VX5DDMu36t9kSnyhTjTTH9UcOvy2Wyzw5sqG7UZlmA8jssCuLuIKyI6dPkLX
 2nWiELZ1jQ0kNWHZ2XKQpOfqa93R+DelYPFsqKO36zTFGtc1dwn5p2x+p5l/qir5NYuB
 q3aIKo2mQtDuAAqBjc2uBw1wIOuMf+S1ewRXmJbsFOt7POZMWIaDJD994FhC0xHR3M8K
 v/OPlBSv2U6bvg0lIshYBFPcOfuNq5j/aqQBQGj6YhWJqdtr5vh+HXL/cEA7u5O2TxT3 Cw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36cxvratu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 02:57:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1152ohaf057048;
        Fri, 5 Feb 2021 02:57:00 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by userp3030.oracle.com with ESMTP id 36dhd2990u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 02:57:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R/EYEASBXZ098WXxEyF65crhPX65U3vbuHnVHdqUsUuqWkAKnsICeV6MLDrdGJJBrDiBl7knff541hXOcSrrqaJ/vz20/sdz9YEJOYeL4NUJ1YiztZmeFOmPIyFwba9kdlLmVG/NjSFpxbKYA+q8HF9Tzlc4SmatmO4a/ulp72toLPTwT8it3aUvDMvVAnfkqkFrWWznALZgCSt7WzJLBBkfTS1+QYJgp8dcGwtrquAxek6MamV5ZSR247NL6FFAC6dVvjao+Mi82Xou4PrjskDRBhj9jMEXe16q7pr0hhFnIM/cSWxLSmcyh2B/BiSHCzY1RRl01O5j+3z0vvWVHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sI/G0LaTvhH4B/xO2CwfF61QIgr1UQhY7NaLR7lb6g8=;
 b=Bawxd8v9VL85/j9n++kEMSexGPmOJeY7hRB19FexWnKx6hKj949ButXvh0MZ7xbS3ZuIAy4OZnNa0cMF9uvRfVF9WU2l6U9oL/2Ob+KGeM0O0pEAUZQmXCNZdn72xbn5Pz5a9gi+oMwneb3nb9hwvk9Uckay7x3JuUPIX875HsuCgRK4/y52GWKpj7rSfyaJcQNzaVhb/iqsm3MKitbt5xAK9XkP9bEtV58tQ6L4jqrNjYO6Y46QrfeRCKGnuiCkpZBgkJmSesJP5lD5Yk5h5CtDa8IfrGNqBgeTQH3mhpxnkiGJ0/sTGo8uzZsqNL1Rhauky5dB8w7+WSiqEle9uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sI/G0LaTvhH4B/xO2CwfF61QIgr1UQhY7NaLR7lb6g8=;
 b=xWrNqdw9OLtqP4lR7VGLm5WkFSKdskDSMa0OjdfFQozzZp8CXW352rTBrTZqXG+zXUyuNPQ4byGj6R18zMwnhXEws788yU+i5AkLl44YpcYMdg5vA0QcrJZL6h2FIeUltjgcY5kcjOd1TqyTPbQ48cQxl+vuU7u+9TEyYSscchA=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 5 Feb
 2021 02:56:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 02:56:58 +0000
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: Re: [PATCH v4 8/8] sd_zbc: clear zone resources for non-zoned case
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sg6bte6w.fsf@ca-mkp.ca.oracle.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
        <20210128044733.503606-9-damien.lemoal@wdc.com>
Date:   Thu, 04 Feb 2021 21:56:54 -0500
In-Reply-To: <20210128044733.503606-9-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Thu, 28 Jan 2021 13:47:33 +0900")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH2PR19CA0018.namprd19.prod.outlook.com
 (2603:10b6:610:4d::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH2PR19CA0018.namprd19.prod.outlook.com (2603:10b6:610:4d::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Fri, 5 Feb 2021 02:56:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e788f91-4d2b-4894-4fe8-08d8c981b41b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB466491D3909CDADB43C63E5E8EB29@PH0PR10MB4664.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lJhUgsnOq9NAGqe1KAWnCQPlEjf7SS9GnjKVEtBH5m6czHnqI+L2DkXZCejlo1nYFRGTY+9qHRCrGQGFSskF8iZdCbPSDxHQ6N6W3OVnNVTYQ6CPWot9i6qC5JltrV9YTlugf8UErQotqKuCAn/a0MU8928ewXtypNnDcbq1S0dTRofR9OTUkfV4x9lU2w6zt6SVAgkFMRNS4ll3IxiIlvS1xoBxUhRiWwYOInMhF0ZjhhCV2jl8g5PwkFhCW0rAbZHVDbg00s82zayUfpOihdpK+2i7lwavsE2DFukktvYbYaU89JDq/3pD/xK9NwG5AATkOpeUBz809WcOKPNLshcfkp1HK/wU+1eFMs4/Z4Zda9AXzZJDoLfzmvJJtfKSY1Iyvbl3fj0QgnD/33H9Wp4G/yAZ4Cs148tsxQsphux2thxMy/EwYBzW1RfXHLRN1mJDMvXiId+QJL63RkSfj15BTJtWwSpVxENZhtHWLn1K9iY3sjWZmwSgrjKkWR9+7yOOojEijEX/DNlSKT64Qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(396003)(39860400002)(366004)(52116002)(8676002)(4326008)(16526019)(55016002)(2906002)(478600001)(6916009)(5660300002)(6666004)(83380400001)(8936002)(7696005)(26005)(36916002)(66556008)(316002)(186003)(54906003)(66946007)(86362001)(956004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?taG6Q7XmWwJKiXrtabCB8NAZ4wgxCGGfSZsYALXUL8EUiPgQ2ER/gbYDck2b?=
 =?us-ascii?Q?HRGwyGgWtYNTJ/OpnRULi5877uJByGi9gpDzDO+MfDRW/LFu467mJJ9KpSsz?=
 =?us-ascii?Q?BWkWoBl5OZTI7ZRp2mJfMmRVVSpPYUg9UhnP31IBk7y9QBZRhHnjeoAW8Jrj?=
 =?us-ascii?Q?kYQgtc1PpeH3b9SJAZfv3yq6BCApDKpr5dN1XddZvm2VqYV0mumAS+pj+6pV?=
 =?us-ascii?Q?PhNLfBOy+LId3RSoejV6sNcsAP8ugLFrg/9kQPmy0y6VdbZ4CicceKiJFa7R?=
 =?us-ascii?Q?HxAYlRkYwvhvMYON0x/Opn4L0zlEgZCaapN5NZLUUw/Qrj5fpCN/Vg06UnXA?=
 =?us-ascii?Q?fi2HearV8ZYE9zpL7d2Q8JhTJ20ZHoZzCoUfu4484SxhxxAD8pStP6a7bQzm?=
 =?us-ascii?Q?xz769H7jHMi/25RpbpE7cAzwRI8QmlZOFPH04pNAFB/B+eS5i87E82gtXd8K?=
 =?us-ascii?Q?E6OSluNRe+s61846mGVC+Fv37OU9oBZuxCuyaBhdZpf6hq02XQTNKTuPxAK+?=
 =?us-ascii?Q?GsWCGvwq08IegojntzpKDNnx8fNTHLKZbA/Bgu1IxyEO0dECt1uVeyQCGlUD?=
 =?us-ascii?Q?0TAyBD7z+luRp1aN68oQJSHkfmnRx4NdKIed0V6GViGZAuJ0L5Scl3aHuBUw?=
 =?us-ascii?Q?Wv1lBaR+MWbR+wVej0SiLtDHOR2IKd+UDQF6zgGFly4PrjsLi5b+6/I8PhW6?=
 =?us-ascii?Q?MBsaRNK61UOlkvgLOBSWNrUjAiOD+RgoSdkwtpZy1vJllj3/BL1XNS+FBBMR?=
 =?us-ascii?Q?dZM07exREb/kHqoN0P5eIs6ZIk6sbV1tpNFNkT1Ubi9rWR7Mpc4gt8ORDzTz?=
 =?us-ascii?Q?mGzWXuUxIyauZOrSX0weUQOwlFGb6sok+kqjPJYpSpVWVy6vVFKS1YiSYC2s?=
 =?us-ascii?Q?lnyLesoJX7tSXprSgOS4eerlp9nWeBGvVn8VUJRpqJiIh1ygsbQe9Iu/9JwV?=
 =?us-ascii?Q?Myc3PS1tgZ/rRypFuMDJegy/c7tBwfuqVh5Scw7961NiwHJiKWAHldfTM/N8?=
 =?us-ascii?Q?mLavHDrJzr0SN7W0HCb3QB5W0W13GdWWWRLW7lsW4hFyma8W6ROtWoRYAb0k?=
 =?us-ascii?Q?g0E9B3iXXimeNxrjoGEk9pNfFhPXw4GIKQSqZjSi5YiC9YH1Vfs9A5cRc0yo?=
 =?us-ascii?Q?Ml7+0dcwmbXsj0KsVyIVh+qcoq9qQDDt7md8Qj/wE+QdLJ861bJ/BRiZm6oY?=
 =?us-ascii?Q?fcUYoEMWgDItqR5ECrESa1cxdOm9wLjuwa3sGFEPdip8EPcvrBCmMx1Jm9Ds?=
 =?us-ascii?Q?tFzxMdDx5bBP2GyJRknhbh1yLPulePJA8b6py5qTHqTbdMeGuW1IEyYphx7a?=
 =?us-ascii?Q?g9WDI5E/Kl665SBfDQswJoyU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e788f91-4d2b-4894-4fe8-08d8c981b41b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 02:56:58.6321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vph3jD+26cwiWBDPxsvTMCaULAvKnla6LB66GkZbipBNoNLNjZJ7b+q6wH5GaB86Uay7hhWyJ4S74uKF7ySEFiN2HLNwZf6rjYwz+BhpTeE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4664
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9885 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102050018
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9885 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102050018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> For host-aware ZBC disk, setting the device zoned model to
> BLK_ZONED_HA using blk_queue_set_zoned() in
> sd_read_block_characteristics() may result in the block device
> effective zoned model to be "none" (BLK_ZONED_NONE) if partitions are
> present on the device. In this case, sd_zbc_read_zones() should not
> setup the zone related queue limits for the disk so that the device
> limits and configuration is consistent with a regular disk and
> resources not uselessly allocated (e.g. the zone write pointer
> tracking array for zone append emulation).
>
> Furthermore, if the disk zoned model changes at run time due to the
> creation of a partition by the user, the zone related resources can be
> released.
>
> Fix both problems by introducing the function sd_zbc_clear_zone_info()
> to reset the scsi disk zone information and free resources and by
> returning early in sd_zbc_read_zones() for a block device that has a
> zoned model equal to BLK_ZONED_NONE.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
