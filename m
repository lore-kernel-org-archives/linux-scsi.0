Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13FE7C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 15:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbiECP32 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 11:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238623AbiECP3T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 11:29:19 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7219192A1
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 08:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651591546; x=1683127546;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=R+QuggHMaR2KZ4uHlZrnvEEvvcaqI9V/D1Q6CCHi0bTP0t6k18mLalvR
   ra3utPt1Zo9MAweqVhcwuSSDjEnIWMiNPzHIy63Zmql1uzCjilnTMEGQ8
   l1Mxwj1baBfFmfOMh2ekBDQQJm4mg8JCU1goiQ0f3vpIPPkZpH/w8SeWQ
   0XNzpL20E4gEdI8mZdFsraqIPG739Fj3gMZt6GXQvpL6/18n8DVdkPw31
   tPny1bGMJTH62lGN+R54Z4KGDv5/PNChwi8zlkXGmPbdKJR4mYdIqCi5T
   E2xO6HrXL4lHG39YxG34tuYSIh3DXqJcMiXGTSctemAyPtXyZ0x0vqqhL
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,195,1647273600"; 
   d="scan'208";a="200310147"
Received: from mail-mw2nam12lp2045.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.45])
  by ob1.hgst.iphmx.com with ESMTP; 03 May 2022 23:25:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JC1WShhDE6akuWP/foomsYN8JdlKxKC/3lyh/HQOCt+JnpaHfxpGSZpJT/3NHWv4yQ4WojoaYG9yygk0EJoFv2xWGAbLm6E8MhdoPQ08xTJVn0bPeNvaZD07CauS9Qr5Z3P1G4xlnKaAMwlDJjfh48+48do5I+JmAXhIIZ16eHGYEsrbkkIORcEQscvZZbkydUUPyep3kkNRXBa0NnhXpGEKb3T6KFOvPu9dNwOYIWWHrLNqlHNickl/l2c41iQy/wMK0q0FeQiknaZpN/9cwnsvYSgw2tn/HlUZLBzLTmkfTXfq96SDY7wHQ21N9qJuICZYBz7PqeBAvAbuC+I6GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=RzLO9ot9J9xlm7E59Nnz4zm9OaKu14oMzqApw54jQ3vHSbh+21ziEbx0pazrsE+BOqctVfXPOl2epU/F0sxORKP93LqwOpgbvvdWrX9LBq4iIoMMFYo0Ns508L/eonfl4d2hWFLJawhC2U7Mqz9v57Y78fnDD0+qOP2mLbkDV62p+32gnPqD5KphTpBdUX7q44u+2LzI18kkVyYgK6mawCjuABWMlKutpsuiWRI05izYiPZkRAAYw+O34KFFH+/i3Fzhdp7oitigUpFFKUIWSACpIu0HklXwm+XiGsbay8421VFhXL6rzHG65K8U+FhLeaZ8LlLQFfr7D15ev1mUOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=myRGbEDSsXYj3XwnXz7xCZXYaabNvzgLwdrGsub5ZJTWO4+nWN5mdU2OIa3FOmk0XlhvziXNBaJfZLEGsnBkk1jvRKYeidhS0Hc/sn6jxw9EQMIy77ssSiMnWyx1fYZKYv/J14b3XlA+yYr2Bqp7eN0A9mlvorphP0RL3r+gZCI=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BY5PR04MB6424.namprd04.prod.outlook.com (2603:10b6:a03:1e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 15:25:41 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12%3]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 15:25:41 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 16/24] aic79xx: do not reference scsi command when
 resetting device
Thread-Topic: [PATCH 16/24] aic79xx: do not reference scsi command when
 resetting device
Thread-Index: AQHYXm0YC3u+z1hrjU2cgXTkC3irPA==
Date:   Tue, 3 May 2022 15:25:41 +0000
Message-ID: <PH0PR04MB74161B685B66284B5B6E52DF9BC09@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-17-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98481910-d3c8-4f11-c779-08da2d192f43
x-ms-traffictypediagnostic: BY5PR04MB6424:EE_
x-microsoft-antispam-prvs: <BY5PR04MB64249D66674D78C974E5C2439BC09@BY5PR04MB6424.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QPYqovyrbe4olySsBRo0ptnarAEF71AGfDvNE4FsxTogh5aup1uMTQNVT8c0npBSfbPHaro4WPg631mOgJtPPnIRexk2bZRS/boixLnuoOIoOl1v0DBRX8OBYkj8sC+TTNcuGmaFPN+eX/32/jxwLpH/DAckoWsWRACpNm/JUoOYbAPlJYLqrm16YuzaXWFCDL7bTnDL+VK5e/YJK97pzNkCqPV8iKjnFfphtzXxURjHwBUEB6ZcMAF/v//CEB8/Gl7UWPVP7HtlhYPy2N0n20GACF7sX/ZwuT/PVjmcpqpE96jIlHKYXM3UFDg5BxJi68q5hcIZ2MZy/jstVrb2KtX5iw1xF6ZmGRAKQScpE1wIA4S72QlBu0YuzF9CYufrioWvFj2B8Ivs/CG8+uJagPKmcX8s7ckPdtj5A4m69KgUoB07vXRXCb9g4K9tw8oz42RATGJUeSJ12wZIY0QrLSSHD11m6biaC+orIVoYWFablHlAQtOd5oN91UsbnzQur7bcFnQ6t2GbAIzNJ9KtuVp/Rgrn3QGUa262CXCSatoudmPyGNmSIUozzBFzd41dJziKFBa020NbZxXbjq4yvUs9EINjbv4gSQ7cXoBslkHD2ndybGzt1G9zHAVQij2Wx5b7sh6juVF0nJO9jjTUDAU7lqQadRaRKvmNfJlMtCyeSRaHHVnGRGqiy17OmYvs7wsD5l7MUfL/QUPDFaRHYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(19618925003)(86362001)(55016003)(6506007)(2906002)(26005)(4270600006)(9686003)(38070700005)(508600001)(38100700002)(52536014)(8936002)(122000001)(71200400001)(82960400001)(7696005)(5660300002)(8676002)(76116006)(4326008)(66446008)(64756008)(66946007)(558084003)(66556008)(66476007)(33656002)(186003)(316002)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UdLd55a5ItKVTCf4tBG6mRb22uRAzlg4IYJXib6ftU1Nvx2A9KYAYMqw+eOW?=
 =?us-ascii?Q?uwWyQFVrRrhgTHI2OMojBKRzD3a5HPQYna7XmmnGbeKfEIRjzdqo1a3toX1S?=
 =?us-ascii?Q?K6qitzPHfBXUxBkGX8T7B2jXVOSo10XLHTpQDxRWerjqWOHe/4xIvmIr7yuy?=
 =?us-ascii?Q?q2Eb2Garyd0ImOgr57cN8Qxm0hCoGySrXIynWoFKW0kpnCPvAcsvUdymoTx9?=
 =?us-ascii?Q?fEefrffDrDC1s5LnQaHXf42l/bndwv92kXEtF81gIqiAiD/VichJlK+2J3m+?=
 =?us-ascii?Q?P3oYPBo15cxWVXIFzReosfWRzbmkX5keqBZE9jUk0ZqPhgQRpYWW52hz3+GR?=
 =?us-ascii?Q?TMlS/sdeaWkRX7i0P9HS9dbuBn+6/podfjTmHfmT7RftqJPrqehrvbG4lzuN?=
 =?us-ascii?Q?Mgpap28tQpTryt4hLR1uUe4z1nxZCa4Ef0lIrRrvYP9KXtiwh4FK3+wCKJ1l?=
 =?us-ascii?Q?j98A2HrWtPlZXvBidBoyuuU9eznT2SaWnfLUWBE8C/zDdeqr1ITeYnFlZE+b?=
 =?us-ascii?Q?94UytbrxGwlkaDjAm5UCQr9o+TFGeUYxU4gkT/ONsqLcn6syGMx2S3+kp8jE?=
 =?us-ascii?Q?nQCp7ZH+Pyt0cPEWYkcTtfkSazaEQ0MYyZl46L2HSvV7bnoZfXl/+TS+g94N?=
 =?us-ascii?Q?COUY/pOPLZ0NrnW20F9Gw9LvcCHV3zrlobq/8l4NKpm7YxdFKvwGbQHX0+5L?=
 =?us-ascii?Q?URQssorN9g27bJEnzjXOOeKnFTcJqKBWGjyLI9XTpz0k+m8Jote/s8HuFYVP?=
 =?us-ascii?Q?pW/xAZpv80NzMkvBednZBZ7GfDqzARcjjBwru8QxTjhO8BNLNXnDzf6lxov/?=
 =?us-ascii?Q?GI+ky3Nh6xpavoV4jPQHfkolNZcyavh4/oRxGhkdNyTiCthfmi57QEdiJn68?=
 =?us-ascii?Q?B0s4msxvB40ZsLSBOQMF7CSAOoAOT0eRKxr7scn5RYTGmHum00j2oKviFMmc?=
 =?us-ascii?Q?uwp9yT5Ff2wAFYyJQXAiNrRybLz8P6Z26FMf1gH5eoUOtUCI5fRNL20jPY/L?=
 =?us-ascii?Q?a76NRqUERLYdkdZkJClBYQT4BBil6UUA3xYHA0I7YT+yUHpt/nk5XrPzRxDM?=
 =?us-ascii?Q?MIh/1DwPEqAI0BoBWofOlDaApnjFmAyhdS9OGNC84Wu4xcBAh4pbDRoFS1Hd?=
 =?us-ascii?Q?jxU1+RTaSz3c6OWs6dHqycdCkRFOsgcexfxjw/m5nn55NDcLX6aN8W+yGG0u?=
 =?us-ascii?Q?Bmc5E7rDB14SwPIa/gwqk5UCbhiwlP8ZtaJZ9T4eD9O67xuVet39rCGixVco?=
 =?us-ascii?Q?i+vPo77F0N6uK4Y3ZnlO2+VupL5g2O7upM9Lcp/0sFtmrshYF2ksrvIIGe64?=
 =?us-ascii?Q?yQuZ2lKAjY8RmhoN7p3MLXkMrnr1ZOLGXxn0rtHXGHmbGs/jAinzQmEbv53Y?=
 =?us-ascii?Q?2kCu9G0ObvVa1olQu6LRk/cgPtX0kxs0gHq3q8A0XbsC4M5/Lp7Qy0YYS2Oc?=
 =?us-ascii?Q?8OihDwE5W870j3EAxCD0e3IEajNxsyQucGfgERU5budhCnthbL7PELi5fmGQ?=
 =?us-ascii?Q?eAho/h75dn+jeWI9IlKlwWMb+CDtb54T+QD/7gyWzNtWqb1TNix5wbjDEtEp?=
 =?us-ascii?Q?Oe6rG2rFpEWwAXel9mbrtEc7MvLXaOb5j/AJGX6jdLFBOId9WwgmrQflOZyg?=
 =?us-ascii?Q?m/Ml+s4LQ0KzUVxIg9t+9d04eFGPmtHrFPQriwol2m4tdgFiH7NJtbLnclvE?=
 =?us-ascii?Q?XCvD4SlDI3UkyxoCCH3Racs4cQRg+VdDcURyoVJNZ6GCpLNwcGz7kCNFG+0s?=
 =?us-ascii?Q?yTOEuTPTGNwvX3enj6D1qpzqNgx7Byk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98481910-d3c8-4f11-c779-08da2d192f43
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2022 15:25:41.6589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1U2JJaw+pk7s5LCvyGQJrygwbMTVju8XTCig0ZDQj1R8X0//+AH5aWY/HQ1qfINMvjnhw/fCorNzIOVoRk/MtkPD/g2+k+gPsDtaH9ZuISA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6424
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
