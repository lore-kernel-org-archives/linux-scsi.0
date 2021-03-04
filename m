Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA95C43381
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 04:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D864564E90
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 04:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbhCDERO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 23:17:14 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:53604 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbhCDEQq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 23:16:46 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1243xDQH002038;
        Thu, 4 Mar 2021 04:15:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=4TVLboumDxCl1hii8j6FrpQcqRA3pEYhFLoBns5kVaQ=;
 b=OzgBXc9yGS2PyGgtfhDdCgBcMqEnseUR358W8PB1rCMvfhZRyngY7dg02IoPpU0BTKYx
 kgn1+lkVLcNAjumwrCD+0pLFeR0ozyLR+uqPHam1EDi520ypgaD55T1iwJc7U5UehgPR
 veslcf9dFMo8WsM74MQf3/ht0339loEy0yg0F7rTwXKwlrmmggNTn4JeXv0ibzAH5Bjp
 9nPNQx6azLQq9+1Yk8rb6zcp/nj7FmZEJs3IUQYjIQvDaxuNqql5hlyrm7nxEJMxHla2
 ihNQz+iGF0NN9sPs+qPdB6psCVgxzvw3g6SuxYmxZnBjlNHRjvZBkDhNshIShu2eUmj5 mQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36ybkbdtvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 04:15:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1243t6QM151029;
        Thu, 4 Mar 2021 04:15:55 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3030.oracle.com with ESMTP id 36yynrcqkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 04:15:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iHGWRZPnOuWoncG5vprQI00HWrskl+XX8ia0Da1GLFkaiLjkZuxutTNuvh5XVtcgi2H/cwIva617SWVmC9j480u0GI+Hns5Y7QKkGbd0kxP2LIbaVj8zKisnPCfKpSvmUWjByi0VyKgFU3NU2jMyZ2OFjsSo7+2hRTp+wf5faXr1Bm3hTd0+jRU+VaZj3ByF4yEbjBvWbZbUVFgGyZiARVntyisfih1yBfaFNWa1xVgEhBC31rUBsTSgqj6JCSBNwTwTYA1Fal7XK2T1gB9bDMy3c10+3MXY1gTavd1m2K92rH+QsQTF5CSEbc4hsaq+3iLFskpwvLbz8zfZe90ARQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4TVLboumDxCl1hii8j6FrpQcqRA3pEYhFLoBns5kVaQ=;
 b=Lm0jsJjjXwE+xVSygRt2vKW+A76W+MCE/nJz3Gqrd1ZiNOBX1nsXL61MXiSTdrwIARx0gWWSQU+VZ4kYQkY80W6IFYzjbXm4O5Oj4YhkSmhqF5Z1eF0Dk8PbWjvpJrdd7xsFLtFXnnsI5rMfdeGl/5dvIRMTl8tqfG6+2YHRTVlMRofJGIrodgyHNxjyAJ3AXuC1wGTIz/LMXMri8iKg1ZBHg5r+4DGT73RjB8WCyTmnR8xvRwNPrzxeCtJS2IxLA5m6A0zbvFzHSV/NsfkKqrYZYvKPAqE8hbz3OSeHeG3HHBCcKbZvxzo4sHBNgIAenG2CNBtINnTNs++xDPLdDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4TVLboumDxCl1hii8j6FrpQcqRA3pEYhFLoBns5kVaQ=;
 b=FGPYWrLvDQCF66wNxf4O85+wXK/94mdK7UbfBXM7tjK1gAc1xUSGI44RO912pnRJ+JulHFPS42eiTGbdOQRHQWnGtfCYbzqwK8kjaEq4bOsu/jM3REfgJQe6UDSVkYyLbp704UFqcSl0NdY76RRR2KTipsQ8Ieq6QGqWY0ejCmc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4552.namprd10.prod.outlook.com (2603:10b6:510:42::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Thu, 4 Mar
 2021 04:15:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3912.018; Thu, 4 Mar 2021
 04:15:53 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        Omar Sandoval <osandov@fb.com>
Subject: Re: [PATCH V8 00/13] blk-mq/scsi: tracking device queue depth via sbitmap
Date:   Wed,  3 Mar 2021 23:15:45 -0500
Message-Id: <161482822407.30323.15174925944376586972.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210207092029.1558550-1-ming.lei@redhat.com>
References: <20210207092029.1558550-1-ming.lei@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: BYAPR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by BYAPR03CA0011.namprd03.prod.outlook.com (2603:10b6:a02:a8::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 4 Mar 2021 04:15:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 506b89e9-429e-4a99-f157-08d8dec4337d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4552:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4552949DCEE7B6808090AA9C8E979@PH0PR10MB4552.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h+9jXbEtICEA61KpZJRrxeupBJXrfQcUtrIvZoN4kxkhrZFnKTpkFSIJgMVcEmQiwrtgtJLGpq2AbBVXYwm9qMmf8CoMjarrrYFuSJiRM1edJ9WionUJC/GpEzvieh6bQQSZ9RJXlF9XGwmqRUR51IKG8lrJ9ucw6xy+9cTmHAUMqdXUpJ79k3Ll5flxlwce2oXrqXTaGe59/ahF7rU+5tC81xDJB3R7jw88tHW7/lDtdbWqUtB43K4Rb2jaLBxgkkCLGPegxT/VVRaMcHo+7FQwIMe8dOS6N6YA22wVkxH6d1gTdwf5ciAI7ncTX2RkTaRwUzs0EJbzQkMPGApNvyuOGh+6QTzCaa8rCMXeYvxGZ2OC2C3dyg0jyy2zFwlBJ5edqhRs+AyYSGUTt5xVpUYZiyxEvLZAAQeT6twvfSCAaefrseRNfiFFHaTOpvdzhMjoWnv4AFsus0mchXmi8eN7jYKexaiDgii2J7abPCqTUJC3yO8+Zco0QxGUgd3gmsE8Grnd6wf9OYGB4E2dyxrD4ED9kWzs86oA6395NvjIuZ7fzt0ml5pCX+/SxlRNJxPe7hGBTnbLrSDnK2bL4Ntzqmt2QhaXUxjPWCs7yy8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(346002)(376002)(26005)(66946007)(6666004)(16526019)(316002)(6486002)(66476007)(478600001)(966005)(7696005)(66556008)(86362001)(2906002)(83380400001)(186003)(103116003)(956004)(2616005)(36756003)(8936002)(4326008)(54906003)(110136005)(8676002)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WUdON1hqTUk3TURpM05wRHRBd1JUKyt5ZzdXOFUzM0x1RkllZEYwRnplOS8y?=
 =?utf-8?B?ZkYwR2pBMUZrR05yYVN4L1lTMmxlYVFrK014L2QwK1FabmxnM0lFME9rdDBs?=
 =?utf-8?B?WllPeXdXWnByOGpjOFE4NEV2bkZSRTVIeXhOaXpKeFl6Q0NGSjAzcGpSK2tZ?=
 =?utf-8?B?TVY4SVJUdzZKOGk5aTNmQzhpS1dLM2tIVjBMRzBvclpudG4yaFg4ZzhDQ29K?=
 =?utf-8?B?c3NYak5wOC8zY3laS2dwS1diZWFIRHdpMm1qSWwxSUZPQXB3cFJ5aU5RejVH?=
 =?utf-8?B?VW5QOHlVd0x1eWlJYTJwMGtYWEQ2aWVoWlZjdDZ1a0RKblJ5SVoxaDRIMU55?=
 =?utf-8?B?cG5YUFFGcHA3NzlCa2VSK1RzbVh2N0VDeWdSSkM5dW9pK0lXZS94ZUJzSHhX?=
 =?utf-8?B?SitneExhamx1dlpRUDA5YU1zaU1DQnRjZnFGdWZNYUp5QTVVWkJrOXpUREZM?=
 =?utf-8?B?UGlTdFBrVVdUN3I0bVYxZEtaSlgyMUsva3RwVTZ1TTVuSFFjblVOTS92VXZn?=
 =?utf-8?B?MkF2My9zMkUwL3NkbXpDNmdUSHdtcURZakxGcng4dFRWeEMvOGVkU2hjWlhQ?=
 =?utf-8?B?eXFXRnB3MjRNQWJZaEZhWU83Y01Md3laSWRFSWhNQVJJWlN1TCtsZjBnVWk4?=
 =?utf-8?B?YW5TWlQycTNFakFhVU9PSCtTdkNFa1NNc1AvR2t3a2RnbFNKc2NMZGR0L3hY?=
 =?utf-8?B?UllLaExwbmRKbCtZaFM5anROQ0F4MFErVWs0U1I5eTRWZ1NLQ1VtYnpxZWhZ?=
 =?utf-8?B?emxaQ2F3VUNqU2JIQ2hhUHdOc3NsTjlHZnFJWlJCUUlQQmplampWV3Z1Qzhx?=
 =?utf-8?B?WnFBc0xSV1dCZXhLaFp0RSthTVAxTHNkRk80bUhreUpZSG82WUJKbUNVbk9y?=
 =?utf-8?B?dE5oeHBuNDZMb2pBdjZ6OW5tYkt1YlFhZ1lJZXlxcko5MlRrT1ExV2kwVXZo?=
 =?utf-8?B?eEsrckUwa3lXVnJwdm0vSnNhdStwSUxpWWlaSlJRMXcyRGoyUVduc1NJNDFz?=
 =?utf-8?B?Umk0Q3pUdmdWOFJCOVBKSTBnZDB2NnpOVW1hdVBYWlAvSTEzbHl0WDVqdzZm?=
 =?utf-8?B?dEozMHNCYzJRZzJFTlNleWU2ZDF1Um5Wc29ibEFEY01XalVWZnlGaDRudnht?=
 =?utf-8?B?Rm1SUmtabkxTMko3cit4bmc1TTBCbHNzVDBKZXhXK0pjOWw1T2tvNWFNVm50?=
 =?utf-8?B?aFMxa0E3STNqd0J0MjQ5Mno4TktmSTliSkFuSlFZTmloWGEzbGhlQXhXdlFh?=
 =?utf-8?B?WUg1YlVyUFgyU2p4Z3F5NjZzK3VVS2FNSE82Qmt1MmZ2QWxkc1c0N2hPR3di?=
 =?utf-8?B?c1JUSklQcVVNWklkWmdNQWdjRFRrbzU2Q2V4cG1lelhGUExHVkNNV0xkOGlB?=
 =?utf-8?B?Y3ZpNDhQSXJNNDgzbzQ5Qlc3cVZ3cGt6U2wxVTU3M1NjZGVIT2d4VmdPNTky?=
 =?utf-8?B?a3FJdkJaM045VmdxY1NzZFBFUU9VbC96Z1VnY3c4bjd3MHVqY05OUmkvRU94?=
 =?utf-8?B?Z2dHNDhadHpubXZia3lpcVoyd0pCYTNhK3FDYXhXRkw4NE9CaXdQZnQ3ZzFU?=
 =?utf-8?B?dGp3YTZUWEtNdi9hb0NSRG5UU3F6VEdxUjJISTlRRDVMMHM3QXhPUlR6OHAv?=
 =?utf-8?B?UlJRY2F6M2s3MkVwem9KdTNFWmE3UWZ3UEVXNGhKSnFaRi9mOE1FL3EvZVlT?=
 =?utf-8?B?aCtNVHd2NXFteHVrQm1sdmZTK2Y5Y0hjbnBNMmdzc2t1UGtiT0hTWVhoc3RT?=
 =?utf-8?Q?pWOsNjJZu3a9EAknwEcSXiWxtmx036tDeFAT73L?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 506b89e9-429e-4a99-f157-08d8dec4337d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2021 04:15:53.3445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IPgJScw5ASQ4SDjaSC055niyYhA2KEpnpEwVl64J2aWDUV+ERVoClj57mzupXzc3jD2/B0KsJVPBI9WskZDheRvBf/196gRP2kMe+UI728A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4552
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103040014
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103040014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 7 Feb 2021 17:20:16 +0800, Ming Lei wrote:

> scsi uses one global atomic variable to track queue depth for each
> LUN/request queue. This way can't scale well when there is lots of CPU
> cores and the disk is very fast. Broadcom guys has complained that their
> high end HBA can't reach top performance because .device_busy is
> operated in IO path.
> 
> Replace the atomic variable sdev->device_busy with sbitmap for
> tracking scsi device queue depth.
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[01/13] sbitmap: remove sbitmap_clear_bit_unlock
        https://git.kernel.org/mkp/scsi/c/46d2a5813454
[02/13] sbitmap: maintain allocation round_robin in sbitmap
        https://git.kernel.org/mkp/scsi/c/ed9eb92974bc
[03/13] sbitmap: add helpers for updating allocation hint
        https://git.kernel.org/mkp/scsi/c/a523156a9303
[04/13] sbitmap: move allocation hint into sbitmap
        https://git.kernel.org/mkp/scsi/c/30d4ee6f3a9d
[05/13] sbitmap: export sbitmap_weight
        https://git.kernel.org/mkp/scsi/c/d9ba7618bec3
[06/13] sbitmap: add helper of sbitmap_calculate_shift
        https://git.kernel.org/mkp/scsi/c/5d747419d20e
[07/13] blk-mq: add callbacks for storing & retrieving budget token
        https://git.kernel.org/mkp/scsi/c/9dda23635dbe
[08/13] blk-mq: return budget token from .get_budget callback
        https://git.kernel.org/mkp/scsi/c/cd4ef15a289a
[09/13] scsi: put hot fields of scsi_host_template into one cacheline
        https://git.kernel.org/mkp/scsi/c/a8474e7b28a0
[10/13] megaraid_sas: v2 replace sdev_busy with local counter
        https://git.kernel.org/mkp/scsi/c/d7afc2ed1447
[11/13] scsi: add scsi_device_busy() to read sdev->device_busy
        https://git.kernel.org/mkp/scsi/c/c300d1182331
[12/13] scsi: make sure sdev->queue_depth is <= max(shost->can_queue, 1024)
        https://git.kernel.org/mkp/scsi/c/b0a4b45dc841
[13/13] scsi: replace sdev->device_busy with sbitmap
        https://git.kernel.org/mkp/scsi/c/62b38e49fcf7

-- 
Martin K. Petersen	Oracle Linux Engineering
