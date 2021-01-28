Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1013C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 11:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9270F64D92
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 11:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhA1Lef (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 06:34:35 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:36394 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbhA1Lec (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 06:34:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611833671; x=1643369671;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=XfsyKqmOR8/2kQ+hMNf9PypCwJ1NVgIxllqa6F2Ctyc=;
  b=pR1n8y2FBeUCqXVLskYY4KnPJ8VdFQOQXoIPYOD2NUR5Ow42dBkmKSMF
   tpGuCbAPKJJKRZxkPuZVbMC9hGMPcqOsMrBg8lrtcZcjqHfw6jXwdj+VH
   Y10IjT0mxf71I/osJ5P96AXzs+b8uGQFnNxYP5lMwWGaGpOtaXty39bG0
   M4hykSMGFXdFUMD7S1f3Jz1dm10oz0bgLRUpM+eWj3T9Ds9ApzQr7PIFz
   amWTYP9gbfHIHMZhsw+kg7KPhUxWTFQIjP+XjYG0byol9XMIluLz+zBXA
   GZvMh3J63nxTTBYIK2oo2BQCoSb24SCfWYvu1uaWpcw1FvHUNCpBl/OmZ
   A==;
IronPort-SDR: FsjxejGF8CQcH3sGY3cRWD4olXq3eqDf/eqWELqtGr5/ag1qy0/t5sR9+RfUzg4j21QZhmBajM
 wQMFYImW5Zga2ogT12u2CUoXv7sAVBP36Bgagb1Im3KDAzHYaN7EDuVcCpbNlptuDRSQpMcL3l
 jAxHQiOzcaBg6maUL8zOqFtbnzK01jg39Jt9SmlZNBekjVlVJmd+2N6I20UlHDyeY0JAgBR3JO
 4V+kTaztX01EzRTpfMv/PTlIqhy47wqzUBd+XmYtqTpqRwB7n5/1amkqioAPICEfdxcJISJKCF
 0Q0=
X-IronPort-AV: E=Sophos;i="5.79,382,1602518400"; 
   d="scan'208";a="162980281"
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.104])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 19:33:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGcKaA2gjaRGBu0bjhaYqriupfFUdEoc+KVp1+WrJhKhKCWevKGh7u3mRbDRIN8gKZn4lwLviJAwHa3lvOkX6g9U1UWU+7EltazAFp5w2A8yhNiXskOJYc2d8ijtNNDNlejL5Nm6jlu/pXOmAkCZtdo0coX1wt0swP8gDlerqRcX08yYWGhWbifLZbE+sKdFC6koMoFdICcuVWbeAIJfG4P3fLPZ7vBGSTB68Qw6obU/ZH2hkVE31p7TSQUZtf98PayPbZ/Uhz5Qsj5VnhNwSoHF6M81Q25VxKwF2ivJUoI+0OcGW95s1/A7L5bEKcp0yDVxgggCWmG5XRrppPuuRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XfsyKqmOR8/2kQ+hMNf9PypCwJ1NVgIxllqa6F2Ctyc=;
 b=KMlRpxEUlP1U9UfouzBJdM40eqmb5PtlKcpgiCmXdsozhLX21DjK4Nt5HyXt1tfGosSv11I2wJwE6E/ruhg6sFOnLwfyCmqeAmz3ltig0ZtuOhNtQ53LpgAWv/YMaPvWXyEi5tyQHVqSZxR9dByXUn98rbgMjQY2w3xt9xZFbakkIh9hl7uYf2p+JJsSCl1CL+wZ9AXqyBDQYm0HgE6lWvHpQwPwjHNj9YyJ9toncXcGEL7S/UOYzn1xI8B4SR/qA5VfCw6f5ZbRhECO+r0YcRwMXsRwdtdioRd9pKttPnYixWu+NAPTV4+iwFmgRMCeQyRWEN7ttu/sctKl3gnWlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XfsyKqmOR8/2kQ+hMNf9PypCwJ1NVgIxllqa6F2Ctyc=;
 b=ULzqm2SJA+xbblcXvJ7L2ynCNfldfYuwy3LpWS1rFuDQhvxgr6/HgqZeJCEsKDwZkHKo0p7SCFEPe/L5JubxcqOSe1dgy0jCz0tYm3UTmeCJW9Lh/M/DnC8LgGorutFr6GHoQ8qgaaugo8JLzUWkcJfVklAIg/6DjsZdrCXg8yY=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN2PR04MB2143.namprd04.prod.outlook.com
 (2603:10b6:804:e::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 28 Jan
 2021 11:33:17 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274%6]) with mapi id 15.20.3784.017; Thu, 28 Jan 2021
 11:33:17 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <Keith.Busch@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH v4 6/8] zonefs: use zone write granularity as block size
Thread-Topic: [PATCH v4 6/8] zonefs: use zone write granularity as block size
Thread-Index: AQHW9TEumR+KGCQzw06HLJi/7FIDyQ==
Date:   Thu, 28 Jan 2021 11:33:17 +0000
Message-ID: <SN4PR0401MB35986CEDD79C0EC4746D22E49BBA9@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
 <20210128044733.503606-7-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 01098e17-7079-4ca0-d086-08d8c3808209
x-ms-traffictypediagnostic: SN2PR04MB2143:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN2PR04MB2143817A6DF727AA787CA6E19BBA9@SN2PR04MB2143.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FDGPvet0mkOU+ZR035wn3mbPOYOlfT1DulNLyLXYV2kD3YdGR913X3c//FhR2hHIyacWHpPd9VtfQ7WIIWv2F89RLg94RE5GCz7f80mbfLU7AdVaRlSeDoH1mqgCyB7mRAAYXKji2LKW0HBclIxjKxadIactsjKX28VNqECrfBHQD0h5Dg0FEra1JRi0RPjgIAptlW+eIM04+WqIpUilFHKFotUxXCZM0vYXNWHjIlkjAt2TIzcFnCfnObUzEbuMmmAL6VGPtLc2HuYnOycsPXcX6JNIm4tHUzNg/fnLdHIexB3jYCugkEWWUq+df/Cb8gfMyTpUwnzTPuWogiia0DqiajNt6vfZH/f9trzqN/iBYvIEzOnhMdh2hTvXElaYz3C0ewgvPQlxoVIVoRSdBWA6OD78McnZ141bkQhKm6RET82TMdpb09Vtr+NvbfpfvC8Ba7CLz9v6q71gHRkStBwem5SLxwWCSvfxhJJWHfybaVoinc7m57gaEWJSYFWWUnxdKGFT4w8YnND5iUuzCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(396003)(376002)(136003)(6506007)(33656002)(478600001)(64756008)(110136005)(316002)(2906002)(558084003)(4270600006)(7696005)(8936002)(55016002)(9686003)(4326008)(8676002)(54906003)(86362001)(66476007)(5660300002)(52536014)(66446008)(91956017)(26005)(186003)(71200400001)(66946007)(66556008)(76116006)(19618925003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?w9reN8RI3BRlb3U2dWQyGu0bhXd26VJd6dlypTFEm6oUx0jT9RSuMY3yIFEI?=
 =?us-ascii?Q?vRNPe8Xl1KEnmkK8lkOHmEdJq3eNQjJTwCI5udU1UqoKxYdPFOefl60RhmCm?=
 =?us-ascii?Q?in3DENxhwPohsz/MUcTp7fJ+vS1iIHnyETUaialZDdn0HTu/XEHQrRnfa4nR?=
 =?us-ascii?Q?9LQOiBSdXSbhZCt7PWY7v0zKC06uIHo8+p5dyKYU2eww+M5qXDiibR5wNpk9?=
 =?us-ascii?Q?mZsbjkmcybLP38c+ubUpcGupJ+I0E6RVI4lUxr466PblhyplcvMGrtIX/+RE?=
 =?us-ascii?Q?SyXZpPTL61bB35201R1TquqCCP2tynXpT0EhRnxF90ajYJ8JgcgCZDSDY4Q4?=
 =?us-ascii?Q?3CEblYNWFsOmAVcKY1O9POtVh/Ejtpc+55C3yDfYiR8wXCAHFxooUWQvBZT2?=
 =?us-ascii?Q?6Rkbia/ghKWzWGGgyPbyY5tfiW69chJ3BlEXnR+GgojyO8a3Pf2iURmwtqe7?=
 =?us-ascii?Q?cFlsHOO4ia++dNsqkFXppHpfMTbkrWd6DW39fKKqOYJDRXyX42imFdjv3qKt?=
 =?us-ascii?Q?UAoUWCEqwvoWmCfrY6fx85EmdP2pch15n9yRMOlgKJBv03Js3CKy+vTcTKo7?=
 =?us-ascii?Q?jzm9TNhXIwL+Eqyvy5wSY1bB1peBtlUQNVP37r8ESvIhdhH7SgF4kSCcvoGB?=
 =?us-ascii?Q?EfULBBivmr5WZvDpywjmeYv+DMh93kVDeqZBsXk8WzDVeKTq3ibW/zrnpNvz?=
 =?us-ascii?Q?notDJEPiHyZCHbquOSzQRz6MDYyhsSMVcm/rKQHTFM4O0UierKiiWDYi4YQw?=
 =?us-ascii?Q?IlHu9xiDJbtQQxy6AAyv/cn9LJMR1HafJ7wO0EiPqpsNyRHe6AwZylf34Oqf?=
 =?us-ascii?Q?wFhF08x0s7i5tJnNJThRs1ZK7HIN4JFHgVOzL2esvDHYS4vQ4m82Y+xiKXSG?=
 =?us-ascii?Q?rvk7vDx2cxKqsyc6nHZMe29QxQOf2tWoig85OTQhRbT33N64VLKyT4WtxMwe?=
 =?us-ascii?Q?BCXvhI6e5W8drVKnkLM1W+GGmEPtDjY8HmEKEZOspoFjHF7D2vYeuI9+xXXV?=
 =?us-ascii?Q?20zaqIaRFbKEWyeAn9Ab6d0Ga3gV1bHVAGD8705yPaFRUkLEonBeJfwQ37zc?=
 =?us-ascii?Q?7AO5C1B7oyCI9jx8QIiWypMKBZZbzw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01098e17-7079-4ca0-d086-08d8c3808209
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 11:33:17.6677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RFh8W6Ra/8a7FfQ/rnDA7RnabikH/7nz3dV4FV1PdRBnOzcf2jQZrNEAi+7mnsen44zJFHIoSnuJgIjm++BdptuRH67wf3IiaVjFO7OMCnc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR04MB2143
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johanness.thumshirn@wdc.com>=0A=
