Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D40C4320A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 11:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FA8960F38
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 11:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbhGZKxI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 06:53:08 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:61341 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbhGZKxI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jul 2021 06:53:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627299216; x=1658835216;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=JfeQhn1s4/aaJfUcZTjXfn2u73n4X4GrWG24lxOeR5E=;
  b=GEzTBR1XfF79QabMj4QnvSGLGITrXWH7PIfmAq/yxJXfuTpxsA4cBGur
   ssNBbbpEducf8VpWw3FWnF4DL+slc9V9mSxej/R49wU/bJBizPxenAi59
   ECW6dh3SIdaO++dZgFWIrABm6eCLfC/S5vsYS4PK4mXkJUX2SRlMrYdEp
   HqOKYebkh4MZXTEVAZJT+wU+T1aqFJm/EIqB5SViSP7hEwXQO59CMI4lt
   xbQC/YtOxxFrzLjPuf4a7xDIRN6mGj0mHQ0oUbnLh9SfI1jdOYxS8z8a3
   EtRT6424LeOG0tPLB4bqk8j7IF42SZAsJSFgGL/LgjPLuBQwo/JZ7Z9H/
   w==;
X-IronPort-AV: E=Sophos;i="5.84,270,1620662400"; 
   d="scan'208";a="287054552"
Received: from mail-dm6nam12lp2175.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.175])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jul 2021 19:33:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSgnSBwEcrS9ZuOHJzPoFyH+KbUj0O23o3aZtIENV/pLuM6173FfB429E+/klUMfy4Z1Oqjg24zt7GEUNVOB8AwHi5iauV6F1adl7NI3zqIoxCtDa+JbIG7ji1dLA8AicgqsEkEvIOyFOlbywHwtvG4G26OEc7p/8q1tXQ41LXyuIW7nO7UEBIDYCL5t7op6HkG19nPjisdI6JobEywDItlPJ5T1jCJOSJ5DlhHr7t69o7h+P1bsy+KNSwGFPdXhA2h85sS8BRM77Z3pqFbhJvQ4C71MKSHBB5W/kMsmDYWhOgxVcKQQcNkGz5q39XStnsejFMD1Mr5ZHZN0L2x0hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02oX/M4TFFIVTJMG+6BPHHCNL1/lJAz+aLbo6bzEGpg=;
 b=POh+uFmyqbqEEPsmt1dFQxyH4ZqiHETNBzr+6zbypVNi7C4ePVDy9yPp0JkHFY5YRV+fWZ7QZE1Ki3kOvHq/9swF+Q0jGx45IqEBhIouhsx3uIAXt+s5Rz2DMNUm6xOAcSTo1Sc2Zmu80osMw80wxTtP+MH9xE3bmE8f1b1ZsVFQMrg+6ovNesqPKScWOJSbk2X8GDf41cj2knwgHqlhCrK/5gjsDv9slETBkyr27zLQ1xgm4hSQHH0OotSIYkEa5G4Ame3ab/Nj3Q9BzPC8UEPQqLisV6H/+1hl44DuJHVvn66mSOxZdNh1vHNxzwEEyc1wT+F7mJPeKmBy9sXk7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02oX/M4TFFIVTJMG+6BPHHCNL1/lJAz+aLbo6bzEGpg=;
 b=HHIfcaPgIkUvzX4tAJNzrmn2kvHxpMc8zGns1db5NjvhFNotFLbfpXhG+XNhYlJ7wOjJry+AAPAAbMcFds6/dMGGECXc/eUb9KRxf/7M7hh8vavaO/+ZoMYHLD3kw9qXjHaQ6nKldcpt5XzUiHAqEn+Bg39v5qWTOBTbJW9jaQw=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6762.namprd04.prod.outlook.com (2603:10b6:5:24f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Mon, 26 Jul
 2021 11:33:35 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::44e6:14cc:4aab:3028]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::44e6:14cc:4aab:3028%8]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 11:33:35 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] block: Add concurrent positioning ranges support
Thread-Topic: [PATCH v3 1/4] block: Add concurrent positioning ranges support
Thread-Index: AQHXgb7rfkYo5fvxW0aRSzaXyXSWfA==
Date:   Mon, 26 Jul 2021 11:33:35 +0000
Message-ID: <DM6PR04MB7081B7619AAD7EB4236DACA8E7E89@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210726013806.84815-1-damien.lemoal@wdc.com>
 <20210726013806.84815-2-damien.lemoal@wdc.com>
 <751621a5-a35b-c799-439c-8982433a6be5@suse.de>
 <DM6PR04MB7081141B64D9501BDA876433E7E89@DM6PR04MB7081.namprd04.prod.outlook.com>
 <0ec2ea13-208f-1a5e-7b11-37317b5e56b8@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e19204c-8a45-42f4-8c11-08d95029348b
x-ms-traffictypediagnostic: DM6PR04MB6762:
x-microsoft-antispam-prvs: <DM6PR04MB6762A1A939F5E94FF8AAEDB2E7E89@DM6PR04MB6762.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pTunEe3rZPn7qdek0jCNlbT+Qf49zT6lpHZciO7tyKI2umJOVnKtOyCCHHZp/n853w0cJw5J2lf6V6aV990myVxRbzyZRaG71znGDL/1C3/2tWgjo3VDSXY/JOZJ1urauooRoL6rfzqwoeMS64248Z9koxGdeAma7TI+0NP2TKq+CjdAKAkx1hOe/TIGRcrYrzjWcF8+fpjgPv6aYFalmBjWvCCi7LjRv6Gvf/Lw7490ppw9sgOTBozZFRfe0lP8iqmrRcVP1ZoW4TFmxojk8iLZpd0HPPuRl2OwJeFys+xJV12ulfwP4F1DlNDOzbv1IeCMbca3QSQeUWHgxug6BpcuduOBl6dP375tgAea2NJ/hHAsRR7on2jTT9/x8nMJD0nhroJZWmZpkFU70b904ZM1Wox5TSKIUXPts2yS5D6SM14HUPVFAQDL1o+RVW0PXiA9t97EMa5yfEooq0l+dL+k0HsZaQkgDEHZ11n9aseI8r0u5T6EPHMFHYJXRhsHzVQdgkXceiAVxxRN2gWVFmpM++eaosgdU02765l6UVhaRkme3CKoMbyELjD2ZyBPlFGRBs2oALG+TbglKkzLCbvr+b7q0nFlyMMwPAzKYbC4h1baZ89VIJlRDHME9H7jGMnSk0UiU+x2VeZUwT0mPQk1t+eCGmoMzT6xsQmWRZnNsv4DjJde6evuoQ/hD1kgeesttb2XP69FZpHcEtZohA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(53546011)(71200400001)(9686003)(33656002)(66446008)(66556008)(66946007)(86362001)(508600001)(8936002)(38100700002)(52536014)(5660300002)(186003)(91956017)(76116006)(7696005)(66476007)(122000001)(2906002)(64756008)(83380400001)(8676002)(110136005)(316002)(55016002)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XYYl4yzyEq4XEY4rmxUGGQeQ0h3ZSXMTTzldclaoyA8smFdvpGFc6j74JWIi?=
 =?us-ascii?Q?LDuuuMMK/bnySolbQGjwj5ss6LYclUK5y8xcToXoltVuLGWECdx+oBFgezOE?=
 =?us-ascii?Q?lCM/cGXzQMTrosjSQL1TP33Q8RwQ8XRoFcu9aa0yizWWCcANs+qygaxpC0dV?=
 =?us-ascii?Q?YHro73v524GjOwTcrOKbIn/t9KbD4f3WqcngLTAa3Aj5z5b2zSAb8I6hGg7z?=
 =?us-ascii?Q?nXfg+frMnAeWEIJfazihJ2f5Qt8ObTtPzd9Zpx1QXJJnnmgId7dR1sZbctYl?=
 =?us-ascii?Q?usuTcTG+mkDWWoz30jty9RwXaY2dh/pKcJuvIB2fd+3+sfDAKr5PvKSAXXDY?=
 =?us-ascii?Q?Y0Oh99z0TLTUxdy28mPJY8/gQE9v+/pPg8jGCk+/MqePVXPGtb1KtQKlF/ni?=
 =?us-ascii?Q?dhhWQ4jQAwEtoX2onKHPw/w0HqxpGp1T0H7q4zMt3kZP/rOOp8Z2h/5PngHa?=
 =?us-ascii?Q?beovuNA4cYnhhMlzurEby71oz4iDkmz++5+OoNf1kOn0iBDpRo8u/MM9SYhA?=
 =?us-ascii?Q?raeb4h02tM9lrMkqYbwCXvhlec/G0Cnt2VUAMWsZo+VxYFkw/rmOqiAPlnMA?=
 =?us-ascii?Q?nh3LDvnmSXvCXsRZ0U3EeXhNGY+K1ljt2s10/UHftwaaBRxrvxpxybZIzbeg?=
 =?us-ascii?Q?Cp7o4rG0x2Rv17fKbLSFZbVIXA1iWTaJMCU/qf83zOonGM1D1S8rNBwsHV9f?=
 =?us-ascii?Q?s8aNMxysOdsMedqxyJ+lxkAs1VN8O4D+QS8cX2pdi26NXFn9PahHLktu6A5Q?=
 =?us-ascii?Q?Q90TT7GF8HzBQc18t4D2UyLMpPSJiRLgWsM4J6mkH9HRk8e39HULci7r0fbw?=
 =?us-ascii?Q?276gvRjOZL58mbFSRIsMBI8cFCUTw0yeya5wGIhMEA1JQLRiZxk8qdMjfLGp?=
 =?us-ascii?Q?LtEnp8M1ngpwfuvo93tCaSBZlrbMu4odvonGex7mT8yk7Pj5xb7oM6ztcWfl?=
 =?us-ascii?Q?SqvVg7FA0l7WD9ZOxvfN/Ev5jUC2g6bDdlM7daPg5O+C9S1w8cI3oNgX6TxR?=
 =?us-ascii?Q?dCg9EAjXXDtCBwxMAE9Bj4I4dGhnz03/q8zMRe9lppK84CXluHlimvXBk+hI?=
 =?us-ascii?Q?6X3E/0kbDPXRlTcL7H8AY2ih27c/4dnzsZz+wYFVLG7h1YHt7BUH6TLJkB1u?=
 =?us-ascii?Q?LJ1CoebIcyScIVcX8pN7kFhRkmM4T80nSqnH6Svg7oAWHeDUfQdqIOIVUhW0?=
 =?us-ascii?Q?NuzCStvFWimFuoYUQ1/iauK0btpoylgsFcGMwHqBD5n3+uoAnTH/6/QQB4P8?=
 =?us-ascii?Q?/FUfMVtPbTk+BL4PaEojjF1d6gnole+Rrc3wR+ch2QWDwlF1Q41WImbKvZPk?=
 =?us-ascii?Q?ayHWmRYeWxGGxCYU+/HtJDx0DfKFlPcPPm1uXO2Rd0FCwklccB/sbL1IkVX/?=
 =?us-ascii?Q?cP3sp/beA8k+2PwNl8Z8KBMXebqlLSAiP2s5DOwGEfYjZdat9g=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e19204c-8a45-42f4-8c11-08d95029348b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2021 11:33:35.4241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gm08DYiwPWj7+pwNDcO0ejDcMdLHk5G/laWLY1WWPCpvalPL2mTBz1KxYqp0P5vit38Sfg0/mLiNEmlQPRyG0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6762
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/07/26 17:47, Hannes Reinecke wrote:=0A=
> On 7/26/21 10:30 AM, Damien Le Moal wrote:=0A=
>> On 2021/07/26 16:34, Hannes Reinecke wrote:=0A=
> [ .. ]=0A=
>>> In principle it looks good, but what would be the appropriate action=0A=
>>> when invalid ranges are being detected during revalidation?=0A=
>>> The current code will leave the original ones intact, but I guess that'=
s=0A=
>>> questionable as the current settings are most likely invalid.=0A=
>>=0A=
>> Nope. In that case, the old ranges are removed. In blk_queue_set_cranges=
(),=0A=
>> there is:=0A=
>>=0A=
>> +		if (!blk_check_ranges(disk, cr)) {=0A=
>> +			kfree(cr);=0A=
>> +			cr =3D NULL;=0A=
>> +			goto reg;=0A=
>> +		}=0A=
>>=0A=
>> So for incorrect ranges, we will register "NULL", so no ranges. The old =
ranges=0A=
>> are gone.=0A=
>>=0A=
> =0A=
> Right. So that's the first concern addressed.=0A=
=0A=
Not that at the scsi layer, if there is an error retrieving the ranges=0A=
informations, blk_queue_set_cranges(q, NULL) is called, so the same happen:=
 the=0A=
ranges set are removed and no range information will appear in sysfs.=0A=
=0A=
> =0A=
>>> I would vote for de-register the old ones and implement an error state=
=0A=
>>> (using an error pointer?); that would signal that there _are_ ranges,=
=0A=
>>> but we couldn't parse them properly.=0A=
>>> Hmm?=0A=
>>=0A=
>> With the current code, the information "there are ranges" will be comple=
tely=0A=
>> gone if the ranges are bad... dmesg will have a message about it, but th=
at's it.=0A=
>>=0A=
> So there will be no additional information in sysfs in case of incorrect =
=0A=
> ranges?=0A=
=0A=
Yep, there will be no queue/cranges directory. The drive will be the same a=
s a=0A=
single actuator one.=0A=
=0A=
> Hmm. Not sure if I like that, but then it might be the best option after =
=0A=
> all. So you can add my:=0A=
=0A=
Nothing much that we can do. If we fail to retrieve the ranges, or the rang=
es=0A=
are incorrect, access optimization by FS or scheduler is not really possibl=
e.=0A=
Note that the drive will still work. Only any eventual optimization will be=
=0A=
turned off.=0A=
=0A=
> Reviewed-by: Hannes Reinecke <hare@suse.de>=0A=
=0A=
Thanks !=0A=
=0A=
> =0A=
> Cheers,=0A=
> =0A=
> Hannes=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
