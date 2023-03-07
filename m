Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D7A6C61DA4
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 02:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjCGCBZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 21:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjCGCBY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 21:01:24 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404A235278
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 18:01:23 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326NwomR003479;
        Tue, 7 Mar 2023 02:00:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=Xth1LLdGz0+Qj6VgWaxMS346x0VC5A5o2t23/AKAIJo=;
 b=j4ECMMuVmX6AX6ucjxp4aAXPOA2RBWmqx1u4fup5PX/zIdBholZQoKFMKMa4AD1k9n3n
 3Bl0MgkNEyXybezMKlIL7QKVX+AIbCyjbzQ1gUj9qNOCTRdVf2k+/0FbDhGUSsKgTFO6
 SgBC6IbibCr4fOOjVZ4am5V8f/UNKWbDGsTHeVzPA6VV1sKoOHIErIqvc97DPN+XnYfg
 e01F+cWLTc+0Msdm0dOeKRgU5ie0OtbkLGq7U0sk3RjlavKfYjxXwIeg6QJk8y+JjOKX
 UzxFlZK166Vp4m7dNCAGZ55SAmSIN4t8lYQrbRJK3dE1dnuA/wi7OWQh3RuliwZJ371b +A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p417ccea7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 02:00:48 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3271TWpm011190;
        Tue, 7 Mar 2023 02:00:48 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p4u2h3ttm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 02:00:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXHPbODwhkXXpN0b1Yi4ZvR4nVHtMvKkPh1dyKblbXt8+MVA1YpsTMYvRUgaPR/Ae7AM0Zf2uDZPkXKVKNdvO02pJYiy9XvckUmR5Mi0vAaojh9BVVmeCQs8WHUyxJUkw7Vau5qbs9Q4ZKX+PpQeNSfeArv3l61lmhkRLl0ut6QVJLyr+HuB+Nu/J2SQ1IG9ymK1U51Q4nhvu+EXD8N6Y+BdSVvawMGRQnhwkI+MRpYVN/vzWNqKyXdj2+UpmkTV2w8mXyrGE0ykJAY+1SEVrZY4pPQkYWhG7wKmXK6d7HbsE2RlNCfgxz9ajjHAOzUfuusy8iYIvN5v0TyRHpovFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xth1LLdGz0+Qj6VgWaxMS346x0VC5A5o2t23/AKAIJo=;
 b=Nq00FxPY+DfBikkqQ5yz6R2c+AUYXTM8lYK3xUqXztvWrZpI5PnV8UGyXyUDtKRqf+Yn1hQbOlhFhn96xyy56o03u1n3kfku1WyFuiDDJMNbKITLqiyMvM+IxAcg/jyYAEXZ43/Ov6U5XxCKnCO1rDAiD6G6PhMryFxjwFShvvO4ioeHj4Ou7ZYZYBH9LRV0BYXdphxIZOncUfFXB8vPr+jhpcVY6iYptm0mHgzbY4XTtFPbPIim5HMGRyqwmwsK1O1MviPQx9AGBBXdO556Y3slMIb1MlJ2dQdzrQxQ4XPl64K+SCji09fdbXxkaDpMJOf6Z/P9WGV0poxks1EYyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xth1LLdGz0+Qj6VgWaxMS346x0VC5A5o2t23/AKAIJo=;
 b=fDjUMfXAJrFnrzyzySnJMqsJyiY2wI7C2NAg3pYzYAgeouYYU8s8Y1GEl72nsz1JZMP9WzIDJyPK3y0XZimxsl22yyE04xvj03+Mt//A9VR+D8Z56TFfEwpaom8ji3MOzOJZoCeZA4kmlk566jpz3DxQc5P0ooyoNDoqjOayuS4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 02:00:45 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 02:00:45 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Viresh Kumar <vireshk@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mikael Pettersson <mikpelinux@gmail.com>
Subject: Re: [PATCH 04/81] ata: Declare SCSI host templates const
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bkl5migf.fsf@ca-mkp.ca.oracle.com>
References: <20230304003103.2572793-1-bvanassche@acm.org>
        <20230304003103.2572793-5-bvanassche@acm.org>
Date:   Mon, 06 Mar 2023 21:00:42 -0500
In-Reply-To: <20230304003103.2572793-5-bvanassche@acm.org> (Bart Van Assche's
        message of "Fri, 3 Mar 2023 16:29:46 -0800")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR10CA0017.namprd10.prod.outlook.com
 (2603:10b6:208:120::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: 77ea517a-5817-4057-0225-08db1eafc34b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: At5TcdIUZQDQx5hL/C9Lee/hloHYvP3Ck8b0x2TPWfXPd1iHrTTx7D9mqynh4Kn6CT+Pxsl8cVJlkFphkZYyavvWD5cBGLGIEmllqpyr72SHnQpBuRcEtO6+XQKe2wYk5xlhPEyRn9ZM6PCYV6GI7B+7jP//w6/KM/5ekU+JlXqWekzE8LLbOLQu4+o/egDW2aJAxdkwALETp1U7WhjUlGu76bhjlKO27kZ5kFxjc0LzObWKaeWMrSBET4Jfi0Gb9gy2ENSsAwUf7QH9UD9AUkh75CaYSIjiDUkc3aMwc+Im1l7yQX6rgyQprZQWZGQx69vcWGQpwJ3e2WLoHwxUF3NAKmxtCmffu6P7LYXgcj9IM79gZm8qEvUMoGu5m7I4+vb9a+O4Kx/NFXeJ+g6AbzT7dqMp+js/UWy9jKpyz7CC/gMSXeXmlFuNQCzGvkpUiUGzeuWW7oohWWKnIIxQ6hx06EhIxWHC7mTfAp/MWJkJ+Lnze/YmbTZghfeNLjbIxDy5oZBqkyuv4W//QBB1rdewfzkoRP7mKbO0FSLWWUcKNgQpx5AyWaivk+YHegrSn9lQfYnnEbpyplwPh6U1tyqYXyQIQI6VD7dTA6G6C3XK37J1tovpjmUfthXor8BwKf7XTu/3SPZgOPPVd/rwNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199018)(86362001)(26005)(8676002)(36916002)(66946007)(66476007)(66556008)(41300700001)(5660300002)(4326008)(478600001)(54906003)(6486002)(6916009)(316002)(7416002)(4744005)(8936002)(2906002)(38100700002)(6506007)(6666004)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FvVzbtSKXjmVIK8yPanzfZw1QGhfjgkVMNVXhbHJjufCCnUecZPfs4X+5e0Y?=
 =?us-ascii?Q?X5ZTj21/9M499osyGX1Zl1JZptlFKG2oJZqlGGnnafenVYNus3J1NNZQurg2?=
 =?us-ascii?Q?OFdBI0SpIa3fbcgzPu526mN7aaXaHZQo8etUxGIqgSx/aOoBmM4ZKkAzOeFt?=
 =?us-ascii?Q?slpyzqGvamHpcIIDH6gUNoOQzgDF1gQm+dZ1ujRaWnYqP2JXL8tDFB+aP10A?=
 =?us-ascii?Q?c/RpO3Pdeo18FJW7Lz7eYUor7FwtLp6ODshBlB70z3KaeQ0/cIQ0lFrSnt6B?=
 =?us-ascii?Q?INoP2qUT+2C5efzr0i+i9GwRP8nkJxvwQFS0xpyormG3GUsVR64aYSWMb2f0?=
 =?us-ascii?Q?g8ZG1mmXrOjZGfhUolmq3hN4bdD4oSxVPw1bKAg1rGpLKJYNeje7PxPTbSZc?=
 =?us-ascii?Q?IK4CwhsGtzm92yY6b72cWl2aPRuPp4qujgNdGxWLUUgAh3AnpnspNiHT/kE4?=
 =?us-ascii?Q?7x4znsO/LEiLaJcgbiBK6Ow1s0tLJJ85UlNgv4q7S2dneaPvgTMTZk6g1hrE?=
 =?us-ascii?Q?hm5Qp2+EBkqOP11chTtlvBZ62E8rLIlr7VnKFMc83KqQUaq5hiepwUfREZLb?=
 =?us-ascii?Q?AK6r2cBq+k9jaDMJV+8s7y3LORWh0hQNK8R6DnvrazNyG3QyC93xMGRtutVp?=
 =?us-ascii?Q?OCmWexps2tzEZA5qGEXzjzZeFxX9EtRLFNJc+4m9WnuENpS+QR/cq80HDg4A?=
 =?us-ascii?Q?zCTye6XFFQehQYgGr0AdLjKJdHq3xgzfpNFpNvzqg1qY/96XyCaITvmFAgX1?=
 =?us-ascii?Q?o8XmIgZHVxI1KK4qBg+bDMz2Ah14144nGSP0CAV6RajjvTrTNsJzIepLVZhN?=
 =?us-ascii?Q?8BCdrSADg8yNaCyJBOGTASZofZfOEQQqo4f+8VOOOjm1dYJ7UbzENA+9SNBX?=
 =?us-ascii?Q?lEYxlbwYOk0WGBlTL87w9KrZZapcMU1vCBy554G+d0MpS7bd558DqAgzyAZf?=
 =?us-ascii?Q?0yfjT1OvZ4w53Mns52aY+MrIjerBeHAlleclvEMm2EK7QsV7rj7hWr0OgZQQ?=
 =?us-ascii?Q?jH0Su1jbtMsCb8UhkU+vnIipiPitmmMJBTwWIcHRoDyZQtIYHKPIlt6ZorS7?=
 =?us-ascii?Q?Um60FGXyeLgioDAnupPRaujkIKL6NKnXrNObuoFK08HBk6SfJHklzThKPdTb?=
 =?us-ascii?Q?BFmzqBayv3x2kw+8Zpdtc3LkAcIkDX9AgRlo4fHElBeNnRF3//GXgc6/SelD?=
 =?us-ascii?Q?Ky+ocZfZUBL8Cd9RtIYLmE/3RoPHG4mQIYJhUld2fsKGO3Xl1rnIa41MHfKT?=
 =?us-ascii?Q?tdXqtxlxhZ6QpbQh5B62XBCoeb5suQTCnpoV27fzXx6EIad07PzdeEdTCg6w?=
 =?us-ascii?Q?zTwj41M2TsUZe8okYlvNt5Z1gbe9RLTwyJaULhqlJQtqu3b7idBzVgDr28Wz?=
 =?us-ascii?Q?yjUF5gzzg3ZkOwFZ9YvpPdCDI3mVd/Q4lOIKPkZPyTdsG64b1D9kNBQswqcD?=
 =?us-ascii?Q?3CejvRkzx4bCFT3KPGBvOVpj2dVC/IOKcAkWGe/WYwGokWV1YE3YGj0QSNQW?=
 =?us-ascii?Q?XNk1vbunGSsVR84d+1qLTPtwzrXsZmQ08+8A7ateernrKYPGMZyTJ4P9fCtq?=
 =?us-ascii?Q?B9tPIxxEOYlpK54K+56NhChD1byTT/HpNZK8Y/9NLgbb1bPxv10BR4ecHmid?=
 =?us-ascii?Q?cQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?YBl7X4fM5TQF1culZkCIZch6IHI4DMtZ6kf+4Zq5aCqvybLRqNKzEuodFIse?=
 =?us-ascii?Q?yjfzx/lHdq55yuh5yEhIuT0ctFV8ve2TVHgaT96zKVHCXrH0ji/asHScQ9/x?=
 =?us-ascii?Q?8lORez4EVQHlcyvRVuOGSpnZSjrvLwnd6aAMa9E8CSIBpAhBypEjo0ePBas1?=
 =?us-ascii?Q?oqmzs+VJb3S1mo2F/luFzpbfzMjpSPWe1olWvEd6HGX3j6xbardjNhy0PfAE?=
 =?us-ascii?Q?1hTt2nGHay9FWqAavM91SQ3dFaD8f5WruMajaYk1fhHIZ93o948dzFqLFYxn?=
 =?us-ascii?Q?3N/8YyZAc9ak+VZ0grJDh+ldKEuuBEXZlv4WvibtByR/Nl765ZGTu/VfoexD?=
 =?us-ascii?Q?HdGr+XSe+CTI4cYGdZLEgEm6yzvvVai+S2IgRLZGVM5xxdERfMFPjQ6bplsY?=
 =?us-ascii?Q?YnYdvD3//oglX9CDc8tOToy9lkSTBJQyA5l9QLfqmJBArexdi3zbBypg95+v?=
 =?us-ascii?Q?bDzAWmO5/96yI5gxrCEPmltnS8GQeWWuu7IObgS7//qAJiKXRoKg8TeQkoIn?=
 =?us-ascii?Q?JXtY/0QBUTd/g1EfTypA+5/YFJdf482Jc4kHx6VJcvHMv7RDfjvzOMwLmB9m?=
 =?us-ascii?Q?LPamIyciBgUiT9NG4XgETo0kUHsk+5WaGK/PAehAfNsyWN8poQXXfVn1AJZ9?=
 =?us-ascii?Q?GHW1jsunrJMiJR6QXrXH0wvXYLN0Y7oS+fyqov68X+9IAg8CCsm9rsgN08mv?=
 =?us-ascii?Q?QKM3liAsD9J1xv8uHTNc0NPfBcoOv+ElYGOXMYmqzvQtqP/1jISqKaWwUB9I?=
 =?us-ascii?Q?DqHepgDOHjnE2LDQ+y0kZu3HugDuN5uVaSFPegSuqTn7u66vxvAL00u1xyEp?=
 =?us-ascii?Q?+Oi7b2+idRSsp2zVevrMX4PpDj0N2W+ytcv0uD6R6Tqj4IZmpuO5l+Pda1RA?=
 =?us-ascii?Q?c8XX+F91JHwJWRrYJ+2839ivN/QlY+XVYwhDSana+pfPrNC0LaDcDmGDNJHZ?=
 =?us-ascii?Q?yBlwGfr5coOwTautF1r2NuvnlYSVGs53iwSbNPLCb9HazWw1OY0AE/38aK4L?=
 =?us-ascii?Q?2z0gCRI9o9mS1tdCvQ3eLE5O3/7IVR9nWAL4JuOKdf/aYdzEiWt3DpeDB6D2?=
 =?us-ascii?Q?8b8ebvoXN6iAzezUrS9k/1/PaBg/3CwLaKn34yztm2bQ92NLqwaQFVTzCaAh?=
 =?us-ascii?Q?8n+uv5GL7+wmC6GUqRP4M3hH5Gag4ScX99YStRzvT62+VNCWif4vfht/cIds?=
 =?us-ascii?Q?0orGqSHiHgVco3b6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77ea517a-5817-4057-0225-08db1eafc34b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 02:00:44.9514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4kjW1sverm5wEoEMAl+OG7/3QgzVG9LSItnObYYbEBy40SI8TcEhg4ckIAXzOoQyBm4hFKMCV9cMbOlPz7+dNlqKWB3glAH2xqjeX/egaUM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_14,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=958 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070016
X-Proofpoint-GUID: BdzuxnOQunzevGaAZsLoFszoDhOV34fh
X-Proofpoint-ORIG-GUID: BdzuxnOQunzevGaAZsLoFszoDhOV34fh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Bart!

> Make it explicit that ATA host templates are not modified.

>  drivers/ata/pata_atiixp.c       |   2 +-
>  drivers/ata/pata_atp867x.c      |   2 +-
>  drivers/ata/pata_bk3710.c       | 380 ++++++++++++++++++++++++++++++++
   ^^^^^^^^^^^^^^^^^^^^^^^^^
Don't believe you meant to add this...
>  drivers/ata/pata_buddha.c       |   2 +-
>  drivers/ata/pata_cmd640.c       |   2 +-

-- 
Martin K. Petersen	Oracle Linux Engineering
