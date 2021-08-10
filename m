Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CFA5C43214
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 11:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FC3A60F25
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 11:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240031AbhHJLFJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 07:05:09 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:10216 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240023AbhHJLFH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2021 07:05:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628593486; x=1660129486;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=LbaREnCtYSN0OglWNwO+1hFk/pBwVFTO5sQWlBlXqy0=;
  b=gOnd68ETkHkBIa8AiWN6WNedO3pFvC1m6ZLTcrzCpc0XeeBtD3Lwx5UA
   Rc0tIVgsrYqo+/KjfDb1EkG2KerIRdhuKaS7tfwi/iSo1YDUuTWExxRm0
   IsbtBkHQ6pwrGXomBtN2NLyYatTrdkT/dlNtaM3Gd5hIwzpMDfKQbOKOd
   A6iEc9TwdTr7VTc+5k+mfKX5mcl2Vq0r6e7tDPSlc4RxFJd3I+QuO1HOb
   m93PQHBpJxagu47gLT2IQashwCKkO6HuxtP8Rb3gqE32kpwTJVqHh/bZW
   KhvqoO/ACYn608lq1SuMKkqDF1x2TkMgjWkd8WVlQXt4/maulSwqJZTW1
   w==;
X-IronPort-AV: E=Sophos;i="5.84,310,1620662400"; 
   d="scan'208";a="280626767"
Received: from mail-mw2nam12lp2047.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.47])
  by ob1.hgst.iphmx.com with ESMTP; 10 Aug 2021 19:04:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HhLqjYK7FwF+SFwnsspBtCbjkVP5vZhElf5I/i3gvLd3EheAOnqv9Njh0g/yoGmlJF37sse4AuMoL3uj2SAXyqtf8/iD7WvSr/tL7/uvI+1uhFmqjJYupkBm6o4J8iLXBcjoXIH1rQdZac0mH0RsteARBD5j46eoC96hKMHHnhfu69BIn9CkuW3ndsgmBESXtyxyKERtEbnZTbkCtRg62tYVBUkLtdfdtialdCik49rUhboI/WwPpd6E+bdxGlZ1lpFx3IO0aZwyhK2hGQZemUWXPLQmKof1iTUMJJonIYIb4YFhNiobHvwjwRsWyilFx6+0VuPRE5tUXZUIDMIRvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LbaREnCtYSN0OglWNwO+1hFk/pBwVFTO5sQWlBlXqy0=;
 b=QblpJY8g0OXNyz/vLxuH6d7EcF32s32xLJkZ/OX3mKJeXGQELwxbcXIVEJJgsUrkynGNQoGza1pzrdpt5XWSR/ILEp3LJO9dpgSzDDZqFKB6Pxvqc73nTCcvAu9HTIQ35fiy00IKNxJQCi+iHc9PhRQC40+i4+RM8Sh2qSM+lQltf4KPa7o5puFqAJ9PTmQt5O56O2JfpE9ubriNBHcU7DakIW/psRJI/ShX92FntCbwKdJf+QGGbOYR/OyFDfFX7uLooOgyYC+D4o05ANDW2FBkyFsouG1celq4UCbJbI2nj0pesmbhsFccsa1SDsLNvF9xTwfKKJ/yoveiPZ6kxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LbaREnCtYSN0OglWNwO+1hFk/pBwVFTO5sQWlBlXqy0=;
 b=FsUMt3GulA7OEShXq551htZF1RwuscvPqtGZ0Xfs+uzxwThxMD5l/TqarWtMPYOpCbXy2V6LPVBGvWNvkp5y03mcIdbthjiaIyhRU8wCb/hB+S5q1GSrPwxJnv15zLsC89/cn2vTTK4tGP7rRzsQDprEdov/+Oj4itO6q9IpiJc=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM5PR04MB0668.namprd04.prod.outlook.com (2603:10b6:3:f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Tue, 10 Aug
 2021 11:04:43 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%7]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 11:04:43 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "hch@infradead.org" <hch@infradead.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 4/4] doc: document sysfs queue/cranges attributes
Thread-Topic: [PATCH v3 4/4] doc: document sysfs queue/cranges attributes
Thread-Index: AQHXgb7vPpxOSpGKb0+IT3aKVVl58A==
Date:   Tue, 10 Aug 2021 11:04:43 +0000
Message-ID: <DM6PR04MB708111B30543090C836A310FE7F79@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210726013806.84815-1-damien.lemoal@wdc.com>
 <20210726013806.84815-5-damien.lemoal@wdc.com>
 <YRI4d39W1LMov/UZ@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: becf6153-dd73-4e38-dc3f-08d95beea876
x-ms-traffictypediagnostic: DM5PR04MB0668:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <DM5PR04MB0668FD85F97E28D64E446687E7F79@DM5PR04MB0668.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NP0LGYXMHdYNZvttuRJKgJ3PigmNvdKXYzPlQtSna9uCOQNooWQjtTHRqv7QjQHWDQfLv7SR2lehUKVgTtizudBQWeNM2BRHA7+AdKY5Pn9gCDSAKa9POf0O183yXNhVn26NKmZ4yps4JsoIPk4qbQemJqzaqCsXtmwv3dXTHTd4VhNuBSRTXmJVLCgGCP3IgEeo+kYlTc43e8GF450oWpE/kn9/O9+joO6T9KyfyaNc36SB9+NOAE59HAU0cOerb2zpk+S9Xr3XG4lPlEHE8y8S15RwGKDesZJPlBvf5EWBAydDQhkkLRf4QpyOKMXMgjWeyh7aOdEHZgV6z9q+te8GxqvoBP2D+VkC0GBxoEejgo9S6Ulmo8e2uNumEBYPYC1gbQIewbdDWbscShxOMbKLmUbgFfT0/F39foluWEtusFexpfFmxP+om8TW9lDSNWKornWjpm8Op9iFiGJcyHKS8x4t20U3ISVwy4Q4vhmCnUSYhW7i+vbBH0NmUt/xzLP8UyqsFI56EoNO/wVJXrxBu5nTajsVZsTWqACQJtczTGaKoXCeXbQxogz6yZMHfRZ4oVq49V0mKjH8JgJFltx+CfFU7c+tEOzB8+vW98WjKvRj1ZlFO/qfDDb3BsydHPF87Gajfx77P5qt5npwxjPzmskWlxb3qDi7Ex7qQmqC6+8J8LYKBo7XmCxxaLUOlLaCn4kSuYbnkkV5GYG5ZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(366004)(346002)(376002)(76116006)(66946007)(91956017)(83380400001)(186003)(52536014)(66446008)(64756008)(66556008)(4326008)(86362001)(66476007)(33656002)(38070700005)(38100700002)(122000001)(2906002)(6916009)(53546011)(54906003)(7696005)(9686003)(4744005)(8936002)(6506007)(5660300002)(8676002)(55016002)(71200400001)(316002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?idAazhOHyMu/Y3vWWR3AVA79uLlhm0iEfnw/b/DC7TTCsqwWSFRc/CHkD/o5?=
 =?us-ascii?Q?i7pH36IfT2rMVN7nBxeH6tsYJleXcVW078wn4dlxerWa3oZBvck7cpF8S+87?=
 =?us-ascii?Q?QdDYTTqlqScK31V/9ZRyuiLG36cn1vfteBcERfKhnmClvwu4IYbVdMBzncb2?=
 =?us-ascii?Q?hzN5UgadR6GlPnqyz8iQSCz2v0l5kRt8XsUw+mp0FMW0gC5+/mb+j1vVp4MW?=
 =?us-ascii?Q?OmKaJfEEkNsfV6/NdjKVewedOdr0UwlzE2uA/tbpY+Wkf7YrSEBZ7sNb/kyI?=
 =?us-ascii?Q?A8jqRUbBVOhv2DgS+t0DEtpH2hc83wA0lDa8G90Oc5W4KumKs26e+Wn8NtfS?=
 =?us-ascii?Q?aQxRNvLTFj8MIumGvfiXip3lWksGIbXGWtD6aN5VA7oehTP5dQJjCm6Gj16J?=
 =?us-ascii?Q?7sIA2XOXNeGMyOlroWboYg/ifBPW0K1A/a8jat3oMkjJ/pxsYM+rvJIcYL17?=
 =?us-ascii?Q?pY0D7zmzNyLh9nioodxwJobMiyBKStdDJjhGkPhAaDvFMCiKV9mG0P0BrrYO?=
 =?us-ascii?Q?x1F4wXtnZCcWG1LMxbfgXJ0ljuEL/Sv4xxH0B5deuFOxlpQDpBG7pgPjerY3?=
 =?us-ascii?Q?1YcL9QqqNoPUM2M5w/DePRR9XG5A4VTzWoLbWGzCcEa9SPTTd3d5YQEP8eXk?=
 =?us-ascii?Q?RLwtfHF6kZ283+tXXxm6rVm98QBl4hDu3ZIVVNWZCOqIqec6Nyudj8pt/aC5?=
 =?us-ascii?Q?k5bYUk5801j+rpX5PhFKYBx42vSka73gD33mv8khsPvOb1uslE3974cPS+LY?=
 =?us-ascii?Q?wH3AmIiNZyRuytUg2FYTIB5wnZrwAUmMuOOUSdZkIQf2f80jrdiio41w7k9V?=
 =?us-ascii?Q?sBc40jPlgp96qvxmQMh/0YOV18san5sskUHngnm8fFyouR1sdWkqxKhjE1Xm?=
 =?us-ascii?Q?kGAWc/5mV6hpxK8dtoqrcW7AURdVCbAuKJ06cc/O2DZdMmJmYiz60LVgo60E?=
 =?us-ascii?Q?8qa73BH5Uo30jb4xpFOKrmNxpJqgXZcEWBbs9jHowjZvwGk9WA7YI8hfEIfQ?=
 =?us-ascii?Q?0HyBxyBJE9+CEVb6mwL6QxezuaTkQlPZxcK7JKoEucdw3KvJ2idweSy4YBRQ?=
 =?us-ascii?Q?zquNXZAuYU8Vv2SySEc38ySl5nNNobk/dUVEe6GKnFWviO3ZMa9K95qDEK15?=
 =?us-ascii?Q?ESq2glkThOy4iTO1NH71Z6z41mZBYvncGNitD+ALgIaMlIxrRVl2pidZnHek?=
 =?us-ascii?Q?2feToqhoDM/Y4807QuhSAahNItjTBbU/Tnbi7twKc3wKD4X0xf7j8qZ0eM3G?=
 =?us-ascii?Q?tHEyy0emP++gWI0tBdm8DOPQY/xKl9NUuAMBqELQrDkMIg24HLHeMMbcerlS?=
 =?us-ascii?Q?0kqMFkk/JDY4HWOs2EgH+LS2rhOa6RppsxRhkz6lNEO9Ny0P3d4TmhVkCgpn?=
 =?us-ascii?Q?qjpEB259LeIq9WNNWybPRInwPGQaCN90gtn+oTmA2oL/5CVS7g=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: becf6153-dd73-4e38-dc3f-08d95beea876
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 11:04:43.4211
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C2EGON4L5L2JAS+kiaQFcalUMyX6XguhHlTahX+CCnSoFBQ9/Flz/lx15Wq5BY5C2QF9vQJVz3baV7cqzV0vfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0668
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/10 17:28, Christoph Hellwig wrote:=0A=
> On Mon, Jul 26, 2021 at 10:38:06AM +0900, Damien Le Moal wrote:=0A=
>> Update the file Documentation/block/queue-sysfs.rst to add a description=
=0A=
>> of a device queue sysfs entries related to concurrent sector ranges=0A=
>> (e.g. concurrent positioning ranges for multi-actuator hard-disks).=0A=
>>=0A=
>> While at it, also fix a typo in this file introduction paragraph.=0A=
> =0A=
> That should really be a separate patch.=0A=
=0A=
OK. Will split that part out in a different patch (and cc stable maybe).=0A=
=0A=
> =0A=
> Otherwise looks good:=0A=
> =0A=
> Reviewed-by: Christoph Hellwig <hch@lst.de>=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
