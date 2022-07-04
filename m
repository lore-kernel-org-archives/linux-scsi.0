Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE54C43334
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 13:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbiGDNOx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 09:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234154AbiGDNOj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 09:14:39 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0316DEC2;
        Mon,  4 Jul 2022 06:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656940476; x=1688476476;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=nOuIz3/mJK4SnOMQSObGEfTzXPhm9JWtbI6JU7KDs/b8c0P+7opvCs33
   9l4H1vV5fMLWC3lxl4RhTyw8i0YdX8dnqeJF58/b8AzCRmOy6zy2QCxRW
   8fOC2M7ijelWyaGJ+m5p8G5M4KTktxHcKNJNbJ5ldAB+0zrLsfoVPsQwJ
   GzkGHu+0agHNizQXcZ8J7/ukaOA+5USSMCvn0IlAvCJqPlQTqkdL0iYjX
   /CYWcm7r9Pf98kHnCm4OPUZbw13/u23Jzmw7uxCJ00juZCI67UIs8V3rg
   A+QIZokxKMdrSzr7W7FiLmwsiBdaqeISPO2JkT4LXVQj0S+f/cNnusxmK
   w==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; 
   d="scan'208";a="316885756"
Received: from mail-dm6nam11lp2177.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.177])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:14:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jv/z9UVLz4sU2w9663QYEmCk7VmQMjALJweMCTTFbwisf1F+HO4lKfzoa7kVnPMqJlxGF0Y6VfShUkSx+wbBnWNo7cJpfUx1b3orpS9q4n1bvNqNxgZkpCefcY4jPsQzZwkJPqnkW/lLd4sh2dXCN89U/yAvtwiQIpuah2vzIvR4C8Dq9OhJp4s005lKwkC2L+u9Cezv3PkUH0+RUa0Z4lfh/I91kIT554Ii9mwRgpAXq8mOj/JFEm66kLMxE+kMtZgrAI84Ob/PQd1lWDH+KSpPy378gI4RpV2E9vjd1FfV1WD4EXQcpiDNTo3WqfTFhwLiX5vRov7MCPt3bU1gbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=aht0G7hp53+j1/STPjpSNHQGPdpMF4UJbv9vnuK/fhwvqxE6ennXqNiIbaRAf3F6cqtU+IWKqrqnvrtIF8DeOtvDUGqRW+GWL9LbpQuDvu9NJ6Voyw94Ly0cFPpsNEmDxxHxA8K5Lq1E1CPy7eFRSnT0BW7Pl0nj6GFjhFT17wNSgrpUIKAVGYV6KobWWuIWox5AlzYavZrAzgwJoH2cuPXM1xgrERMGxKKI6f2v51Tqte6Il2maHjbO3ycHXwbCvzRldMHUp+ifLxqS20jrXeDohmxqK6uPidLvQqBrOSQK+8ZfAH3WGoq4xuIwo0evh0g7+UD2EzeyMEEINlW2VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=AJsa4kGKOHnlk3pM2YYlnlTnx/pbFixqdT+7PWPZzl+oWgL5KUpew4TfFVAgeXSgQVZ2zF7DrvoaDu8j5HTf3/RwEgkOK3HzeIGCwFuq3edJA+96vDe5EC6j4uL1JjNWviougCIA4C3OeDFeLXX2mkMA0Nf3cnfrogFiKngDj6Q=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BL0PR04MB5025.namprd04.prod.outlook.com (2603:10b6:208:5c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Mon, 4 Jul
 2022 13:14:34 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:14:34 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 04/17] block: simplify blk_mq_plug
Thread-Topic: [PATCH 04/17] block: simplify blk_mq_plug
Thread-Index: AQHYj6PxNMKrtjSBwEeUhT2vx7qbmQ==
Date:   Mon, 4 Jul 2022 13:14:34 +0000
Message-ID: <PH0PR04MB7416AACE534DF0F2D5ADB1BA9BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-5-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b956711-aa39-4545-a7bf-08da5dbf238d
x-ms-traffictypediagnostic: BL0PR04MB5025:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R5ql6jEzwPQzrcyQRYggOrX4zA2bTWoZ1gtMlbqfbavyzsFbr6ZKFzeNxth5qE7eDaqSTu+AEmtFX3e7L4crIGQ4CcK9LZ6MnfHx63cwNwsZL+pxsNac+QfzAW03fKkBVc70sGt7i7O9gkIYLrszLBWBGxdUnt4b+FlPgHhUdU8tnfm1neiUwMilzrbNf5/kBzJc7Jh2gUlNQWQ/eLx3yK8iN7Z7fHrLfwrNAv/8GuoTfaV5YnoltzWAWoBLD6vbNaTmyLq45pVaxaz1jrE54YcI0UyA2PlFl+fseG8VqhhKgJq/GJzSUWOTq+qWviyLjVHqhhrVU8nQSJTRKUbk7PUKQe4wumP8lc90sDJ45CeLqGwHjpKYjdGQal08/KFCcBrCNrxkwumljweQ06YxsmYdcV1m29feIQsGtOno6snUTiVmX26H7Clbko3aJKrMNxmpgiaKUaAOh0nypG7qoegAC8kKFOvelUL/yLTCwU/Q+2AbbN4rYK3HcMCzcsOmzHKdPpgKNwNP3WGfYtR9Aot038K80PhPrdVg+yLz03KGzNjPR6IPKl8M9uuv8sV/V3k6evtJX/5RBu9Kf+mVDOPVPrgkExuz7eNnKiqSpkYdNI8qhTF7HzsMX5BX+iektcVBg7Y6J0sg6jX0vzF8jqk5jYnII+Ok/CUmAlTKSgpV6LuOMi34Gg3LIOvZC5J5YKwdaSWkW4kGKNCyDcaM3YQJdLKNNBpOhiN3LbCgdiog96QL4gpqr2xfdjuJy5WwkAP3jS/LoPcNAEYaLOgk5kl1Btd96v/tYpDNdErZTDduKPRQ5/mczFK6jeoE+jcB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(2906002)(5660300002)(8936002)(82960400001)(55016003)(52536014)(19618925003)(122000001)(186003)(33656002)(4270600006)(558084003)(76116006)(71200400001)(478600001)(91956017)(86362001)(8676002)(66476007)(64756008)(66556008)(54906003)(316002)(6506007)(66446008)(110136005)(38100700002)(7696005)(4326008)(41300700001)(38070700005)(66946007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gjPINWDEd+tw0Y7BuRwNLepVVgeai2BTlAZNDHwHVN5BIn5hoVvwPX3RiJgm?=
 =?us-ascii?Q?vBhTxCNpHKu6kzyaZ2baGP/F6viI39i35jbSvwmleTVTnihis+WqyK2d8Mwv?=
 =?us-ascii?Q?xlUPGSQD+jYSTSFK1Lch/6oLnFAoRQ399Apjco8s2H0O2xu6mNYdeivO5swf?=
 =?us-ascii?Q?iiluOG/Caj+6IoA/SXrNQ0IyPc3sBChhnzClYAbYe+zFpflnC2cinmMA9Ul4?=
 =?us-ascii?Q?z3ih8CZaqL5+OYasM/mvi7J5RSqC6mP0nrfkwli6kKhLd6ZVqdya+nFgHfCR?=
 =?us-ascii?Q?kDKVLWGndNY69hthFmp6pZYZxaPEczgV8xdRneFynPZNZ9PUlGW0+1b2X3C7?=
 =?us-ascii?Q?Jhy3Yygox/KnYlrMS34P1EXHm4bc+10+Gh4kkfYnYmClSQqXrHgtpam7URwz?=
 =?us-ascii?Q?q1J/0T2ZIuumj4ZGZKEP+x64OSpEmm0XsGQ+R4OWgz2FJ3ae9IEOoC/KukCN?=
 =?us-ascii?Q?n/ntzl6dg4Zk0ubODRhWBwXGugi4RzhJTfHXzp/QBLQXGQlzkW0PP58u98uH?=
 =?us-ascii?Q?x31Mjry9d5C1p3fPme6JU+LivW/TnAbLuusKL9jMPIyehYPA0GieOrglOzwo?=
 =?us-ascii?Q?Itc4JnPCh7nLKyaqo3jQa5CVg0pNDV4bya4Vp86ps2Ra1jC7ZcjCkmjp286P?=
 =?us-ascii?Q?nrn1gQOQSIy2COTelBcDGTZEw/SDqHPDmugZqSv0xnwfn9ytIHyMYw0EN2eZ?=
 =?us-ascii?Q?qY/u20/b2qpvaL+HyRNHYtyXyksivFy2VNUWbT09OFrnCobiQcjlT/H1+DKU?=
 =?us-ascii?Q?hatOhY3ub980g8AgssoNZr/TQyEVMftRmAdemLxkZ4o/1+Tbt7HhgngGI1xW?=
 =?us-ascii?Q?MaYqk+9pp7A6btCzgdXjBY8ugBo7ZIgbPxAOioQpSDl5bQTNqLT/MdpMxSam?=
 =?us-ascii?Q?IsklIzfWQgjkc/MBy0M2tRTDWoZo9yUGJWI/1A8VpF2kvPqs7ZmNltObKICT?=
 =?us-ascii?Q?Gw9R8HZk8PM6O+Y1PP23gGw9CeL1xhclQnRz9IY/G9Amt9Jc0NhvCr9VV8y8?=
 =?us-ascii?Q?EoxKEXJCYTkbaJN5v6AmJV/eyiToKT9biS7wKqSrTdkDV3z1zUgijM6AArC7?=
 =?us-ascii?Q?BFOvk0MfsOh95yk9+yeQkttFMoGlj6RIvKOsyCXl+bEu5PyDneIDxMAoobsf?=
 =?us-ascii?Q?6EePj3Zr7iefzajaI+/q3q6MZd7HLkIQZ39eZoLJatzF0laiuxblVm7CGfSq?=
 =?us-ascii?Q?/9ULKUU4vj7cDukcuV/uoJ8Hytdt1QnxSE/8vKPt1OQcbvDNPFamUZauJCDw?=
 =?us-ascii?Q?XTh2JjU7xnK1lNZrHQd6U4TBsL2/oizQYhdGGQME40dHu5I24vGVlbY9dOVf?=
 =?us-ascii?Q?/15VPhB8b7AtREPAQJUgMRrH9p+D8qdg1SfC8+lT87qJOX50elHNgfgF78Ao?=
 =?us-ascii?Q?1pIGUomKfgGSbsZxoTQEmZV4+qUiojyrhE/MQN7pb7JGjo4bwIyGNI4Xgw6c?=
 =?us-ascii?Q?+1A+hypMZJcOPnlCDBhr2aNSTqsb6GxrlVyLH8LcUB4AtLA4pzgtP36KmIBa?=
 =?us-ascii?Q?BLtMh4Ds8rR0GZ/l+KKxS3Dqp0ma2nmGxB1fJWnphx8oIFyb/sHlb/DkJNZx?=
 =?us-ascii?Q?OVaD4Ykkf7g6f4ESzB2zYJiE2jUBLDPxcWbjqsrRpKUtrccyO9C1YxlMbJY8?=
 =?us-ascii?Q?gQ91MGoQ/LaVMj7RwEu+Fq/q6GW+2yYdXol6PJO1ZmBsjS/3CRikUisTPUWx?=
 =?us-ascii?Q?MfcyldU1JYyRuUfmdcqC8zJGTWs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b956711-aa39-4545-a7bf-08da5dbf238d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:14:34.2813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cs4bV6/sLhyRgyNITjOPl/VSgVLwYGhx0t7kdC5/IMfrE9vz8P7ErE1NvCtSqkJTEPg9/xLsCjebkIICJrKvu9QO9aD/Y3rsNWUfFG3JI4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB5025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
