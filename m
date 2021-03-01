Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59400C433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EF9164EDB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbhCANB1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 08:01:27 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:25672 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235228AbhCANBP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 08:01:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614603675; x=1646139675;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=iw9DYUv6GbEe5j+kNTMo3hv4T6ig4fOc2Ux6u1TMx+OHkbonqZIlNOCr
   RPDg6P+WUaAdAsiKHOmJo1h4AadvHcgAhqq47ZAS0OSPR5OHEgEY7fcFB
   hFKYIqFWSkUnTh7vvpwt8hiqMgIuRIjCPpHbURwckLr5qRSL3lTNzaTGR
   N4cffUPjaHRiKXnhzvpZrsAKTFgykzJpYYpeBnYHZ0mcI+cYZLd2wWvdW
   AZ/e4WvmT7KDpJMNpVzZ7wN2u8I5YAW2lsd7hq5TS3vJ/NU8TURZkfS3b
   oiofYpMxCaUmGJDEfhLnORUczOLjs5V/iLQwvqLwyGwzVossDOexIXce3
   g==;
IronPort-SDR: I+lbIWYUED6f8SUxJvAVyVbEn42jceWcHREZkHZGr21lxIROk8D4m3PM/V6lc+1rLgKc/myXa8
 2thzRBHe2faI4WTCL/zpDbv8FcFNFbjqoguqEx51AISNFQl5XUFLjHU+Gq/GoQuXjJvJ4oeIqf
 EZQowi/ZgHloOvXENEGiHjS7ovMjyeywg7leppFdjuXXT5sae+iq4D/cc/zDBMKtVJVDHomo4S
 cLwkPej+gAF3tWlH4zD9JEFFynjcyWfbWi7MWtr2wM8riH3ehsSMiMVKSe2BzEQ3RzSJaReIhr
 LEc=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="271660554"
Received: from mail-bn7nam10lp2101.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.101])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 21:00:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KTcULmEENGv1MZqNppUlEdtiMZyDBJnGyi99iMRewUyKuYq9L9IL191fYPxZeWsS1zB4edqqqUUdeTDm6yWOeZW7SfqzgUZP2jprN3OvQ0hJgH0fwoTNP66pN9EJZd96MjwpGr/IeNs1Irr9M3gBRoR9GlLHYAg+KjaeBLcXnagdBGC4TI7v71D7RZWgOi/zNVNWLQKacL/W3Tx62UbDOGwuPBNXb+BvasYiH9agdctPsHJ71CpJ0c3t7EAkSyMSX776+qz0E6mpgAZhxQKk5Z9DVZhW7zktkw4LLCTML4WW5+VOBQ0MvlAuOWAG+xT8lFCcwocEC/CCX1tiW/JHLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=KW1sitnJGArrKsjj1qhA37D96+l5hr/PpYKlpnyARTEMCXAepGI9Dmx022uVBogcWMmXL8A4oZNW7ye/SJe1o67T6VFSY43duHDWumMgfsIvOg4UAU6opdRVY2zLWJWvRY+u9BjcFQry1QJGHeV9TBm2nsUayGsACQmyEkaXySBBYc2rTKajFTsEDXigcm/Ht7A/XjKZrM/HAYJpG0rMY4C/vTH6qHANIf6d3KMEDOlY6mhhxWBOAJKSyvCRt6/YcybLGtgTw6HAyQZdSR/eub5waIR6WxwdQwjx/ZlKvxVSKQFW3SBj0Z8I1vTsb3nMUGoQZ3hFh4lgpATt/MqT4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=twJ7VRAqocsk5x7Qx7uk44zvmx/nI9PJl9NFGLZI/Dafa3rdLh6K3JelxjNZKAdqL/orEVtm96KlUhmcNs29WNrdZPranakZCK92CEDVm6XzNv8ORi8kuYQFmR48t5olWvsQ4LxIOD80xvdjZO9v8dsF+ciZMy2Ajfe8wUIhpzU=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7318.namprd04.prod.outlook.com (2603:10b6:510:19::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 1 Mar
 2021 13:00:06 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 13:00:06 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hare@suse.de" <hare@suse.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "mlombard@redhat.com" <mlombard@redhat.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "houpu@bytedance.com" <houpu@bytedance.com>
Subject: Re: [PATCH 15/23] target/configfs: remove the memset with
 declare-init
Thread-Topic: [PATCH 15/23] target/configfs: remove the memset with
 declare-init
Thread-Index: AQHXDZdUNH28OeU0L0aX1XNz4OfFAg==
Date:   Mon, 1 Mar 2021 13:00:06 +0000
Message-ID: <PH0PR04MB741696A51C2B7FFC9517CB8C9B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-16-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ad39812c-5e14-4c2e-8e12-08d8dcb1f023
x-ms-traffictypediagnostic: PH0PR04MB7318:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7318F6AF5D010E50FD8C1DCA9B9A9@PH0PR04MB7318.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h2FfswNA8fTXcw2STMmtFmdnGeo2QmUuZAtvkb9TF9UncXh7xxBvecjkx/YL10bXG5CM0ey+BqG7/Tniw6FJh4AeYNsbzN/nyjHjFl5Am7Q48xZehx2mAyquw6dtkYSUh77DrtQx9opexBK77CZg8sAS963MwvpUsuAO508vEcQxd37uQe2nSyrlSC4yMr7D0qxYH4fOdKvLxjZ4r4kiyETxtO20bSjIfsW3usYCCaubRBIW/H9OSL0I6jVP6iB6Kb77KDhG5TFIvK4m9EInXzatwnDqbPFkB9Lfx4rx7unidROg8lzI4lSLLY5zFI3Qy0mjwoHHhvqdnm5wccvFkLEOkTOguvY1DYdrejmKTw2hOeWw4gYHQvDjgiJUNS2rqnkN6IPoGzzTLtZ4rFdgdtOPGZdzQiEbWyBAIlgDxRLIGQD//1AgDQyUwSEVr/7Duq27NrnC3/YIG6Ux8EtYl3+4/Rfsk+G/ySZra3HLmnNDcYSegJ4R+lYRODTkRtogH/5rBHoIbo5K9VtJRms0ng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(316002)(5660300002)(558084003)(52536014)(86362001)(54906003)(478600001)(71200400001)(4326008)(110136005)(66476007)(66446008)(26005)(66946007)(6506007)(55016002)(64756008)(8936002)(8676002)(19618925003)(7696005)(33656002)(4270600006)(2906002)(66556008)(76116006)(9686003)(91956017)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?xiMGGZXMRTzS6IAm197bGI5eUkGXNXmZvwMUkmvr4XAyG9vOY8Am2jwRuLcK?=
 =?us-ascii?Q?ay6HN7xM8ovV1E94+OK+QFKtf8M+JtnakDWlkK5PAlEX1G/xlx7/HP/HIEQn?=
 =?us-ascii?Q?4ABZXmBrOGNB/uI+3cO5kDPyIZUdtmACKhSeif9uhutQPo8lb4iADOBMrUpW?=
 =?us-ascii?Q?575yB2nxsPM7daegoo6OeYuoCI/5b5tctBnY2FKkm+9/pwjH/TYoxMLzESCK?=
 =?us-ascii?Q?O1GJCBQidVmxem23Lb3b8GhhjdesLMVPq4dMYANxsQcrWaO+lbcpegHxIz6D?=
 =?us-ascii?Q?mpDPCFFdFGenPflJZo/WTKAqc1KPdPrsKU1VuS25/B+J0wzK9LdVjcdTCzgG?=
 =?us-ascii?Q?xS1Pj6jxNtuog3f6hDA6VuGT53ZLRY5bF6gPQn8FohTIlxzyuBXJducGdJZZ?=
 =?us-ascii?Q?N2O6gLYswourG6vFIuF06oPzRQRcJQOAEjWMdqvew3zYVxAdQWP33gLOdGis?=
 =?us-ascii?Q?EHrDbiVdvJKWerVOxnxXcGLjOL6UN9UiqH0E8mv00D+mJnNV7XeB6lFPCao6?=
 =?us-ascii?Q?8SbTRqjKPziGbi0AnebxqhcB82z3QBrwl39NxMJHPud+5OfoNtN8wwbu+ddW?=
 =?us-ascii?Q?UCI7TL/LeEy0E/H8QkOH6bQcTEBhEnPCagjp0gp2bdFZHznQJu6o8+BSBuLy?=
 =?us-ascii?Q?VHiM/xQrGjpmqwkFJd7mI14akY30r/jukD5dZui8tOSjJOXFAm/sSAJ/XPra?=
 =?us-ascii?Q?EJQVWdZKAtdGC2Hpl/12yufyLxADf1P/PtJAsqpdQtXNRztVD4Y1W2VFZdFg?=
 =?us-ascii?Q?D/zSTc/TVJpG2b+2AtcDrfcxR3S5LvMhe4l989s5yj+rWLRKgrFTRLgLBQB6?=
 =?us-ascii?Q?b6/Q2ic3aGFMSt83rBhQLrNxSuwB5LRg5BDUDFYiuMKI0tf1xh5bIGe7WDmK?=
 =?us-ascii?Q?WQCX4aOXTS1i54/TuL2I7qQO7SA3a+3uofahIyWhdpAhMzR2WL+kVjMKfAYs?=
 =?us-ascii?Q?yo5v32bgJNu4OJVDpWjWzmPrFNg3z4bv+s8vC7uPJj+H69KsAaPT7iLMeIRe?=
 =?us-ascii?Q?hNPj49liu+TxnF/0BKPkMe6nuQ58HtWeNwvkjzDUilwVOQQ1n02VVwkXgq42?=
 =?us-ascii?Q?8unAqP1UJ+eNYGcI6YwpLvs0c0DfXRyfTwK0uCwjnq3mPKfibXYPctVxNd8s?=
 =?us-ascii?Q?nZB2mhkEKUJkKyHYmQMneB+VlthgKjipR6fvB/Y+y4h8NWjkaAE+giSGN8v6?=
 =?us-ascii?Q?LsQIlFCmbueeC3LBJ7tKYfC9KAxAzUjKdQ0yaCrLJg951STGsMh42oWQMNar?=
 =?us-ascii?Q?0BIg6OKA4LHwvHkIxQ1ItP/KcGjWkEkp81UKSRZMCtJMuTIILqzqn4E6qS1D?=
 =?us-ascii?Q?vq0fsrgr8Y0qvPS/lggaIS4Hm4QEEW/6NF+8mKm2wU69zQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad39812c-5e14-4c2e-8e12-08d8dcb1f023
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 13:00:06.8073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VZOTQGFMhnTya04qwZVVWl543xluX/OfXRMBW6f8Hn9TnOM4eZVopAJmz88zsPWBv4Lmq7VAandNp+ceh1N9jLxKwUVJttdfzYeYtABhsXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7318
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
