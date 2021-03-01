Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60950C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 230E164EAE
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235218AbhCAM7d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 07:59:33 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:48451 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235178AbhCAM7V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 07:59:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614603561; x=1646139561;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=gxABmUhVOwr5SOpv9RHBQW/FwiL6mafRCyQtE1RhwVpXbh35ihG6QI+B
   kXvsik+dbexZ9Ypnc6HUFptgcK2RHkx/rrSoMkOvfotFXZ9XxgxSPwZj0
   GPTr8XTLZDf+QO7PRLjgqGwM4aeuMr9RF1Va0nixIFIOQkJeYia5L6S3p
   8hyaz2jxn8bo7Yxkq7+YVNWBp27re/xxjZ4im7G888gPDAGIZ63ntYABn
   x84fcVVauOzBl5xnflBvLBR4yk1oQzeQ/uVl4aWN9euc2taDhSvP3KmP6
   6EMi8dVI+ymr4FHBvvBHz6d+bjWE2kuym1aK89o7pljJQelHuM6IY1Uu3
   A==;
IronPort-SDR: BcA9N9TS+SFSiUAvJuF8O2E+ASoTJWHVGm6v5P/nyFxogbyLK8Y5oyQBK7Y7I+XSzztmZMNH9c
 ccEjUPl9X1OrlS3dLNi06wPEhCKtTdi+CC5OvfsqYhSfhe1HRrFxH2KTQQJT7oXPZxrDw5GGYr
 xcAV3DC2I4kUmuuQTZ5iHrOdKLE2naDWMATxS5rW034OPlFsC6b+O4KK2enlBGYL97zJO6shFC
 jVnUpWsXG3Oi14+J6+0UnhUialm0Sq08WC3MCnEjCZhLsMdWCKAOD3ynoC7AMpg+U7bytLHKYr
 UwE=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="161052604"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 20:58:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OyYkqTOfBCTjGCF70BgWOCHf0Fg0dnY7wMtMVUtvtPZSLjkVxUvz16ytT6o43nCQByTxN5o/phorNpkHYvBEY7n2NJghM6l6ZnMDcgXvtopbdbeRzbHCgOv2Io/35/QMuwqrhI1pqluSpaDKdNQNHbmpAsHJvaDsZegyqwMrtlHvyc1QrE/IYje48uWsItP5cT7ERWJi/8oL37r/AsPcjO0IxZRa+D3VrafbdSgUgi1vzWzMxhXCRFz+g1AcEuAk/EkU3Pp/b2MnJFYM8R6GG0Sm2DHDkz4DuxAkybCu2VoxkPT9CtpnncZT8arpjetUg4los1B8C8Kr5eljYyFTRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=Zc+Eh+Rj4NapHMXEoYwgzBP9d9z49/iKmNx8VzKdwf196mnMaOHA7En1NeSpAdbiIhEZk75sgcAOvGGZgnwpDKZ8/6sdTzcehunlfvGig2xb5k7Yuo3+mov7jZD1INxSlN8+uJchyLsa1+byk/J60vdEwJGdrtb8rH8zj4vQDllTLXHWkP6hW1iNV1U7I/mRwEQ1UCDLIalUZBwDW1BG7QtZdNq4EanNQf/jW2X61Hi9seOa+5ZJ+EYCYc2njlHImxeiG3kYgDJv1TlSd36iXc4R8/yvIn7HPRucYt7SruV74ktIgULcfutEBabIBbF4ik0zquSe1BmEY2X4I/ccBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=jJR6S5VoO6C0ByZjazsRqA7R/tLNk6NTRbSPPe8Y9NAglj8kOR04CUgHWndGY+EJA2OC24zHbdBJfs0wnsYw6SoURao6gqHHE4RoNNjPgc8U9g5E0kFHthHfdVkLmEtJUAN+epA0WdrqiP/xOvNkkGCKUjk2g02PRH/SijDZvnw=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7237.namprd04.prod.outlook.com (2603:10b6:510:a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Mon, 1 Mar
 2021 12:58:28 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 12:58:28 +0000
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
Subject: Re: [PATCH 10/23] target/iscsi: remove unsed macro TEXT_LEN
Thread-Topic: [PATCH 10/23] target/iscsi: remove unsed macro TEXT_LEN
Thread-Index: AQHXDZcIdRGGtV8hm0u7tzWs0ORqFA==
Date:   Mon, 1 Mar 2021 12:58:27 +0000
Message-ID: <PH0PR04MB74162AD51413F9DFD0558AE69B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-11-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cfbdfaf6-3aad-4467-add6-08d8dcb1b52f
x-ms-traffictypediagnostic: PH0PR04MB7237:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7237B51A99695896021086539B9A9@PH0PR04MB7237.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hETy+Z3VWqhWrgnPnqgZkKZOSzF6bkbVmAoJkPWnrmyXJSv2KJ4uObYMSRyPCX5IU5B00yE5PzooQ5+igZEUzPbK57THMZuQ4xIGAlBi9sa8t0PyQUPmc/4f+2Eeuq3bWzcDTXkY8is7zUBdxTacf8ADoVoVFTwgj/8+5J1WF5iucEF72I2N0LMENEtpymYq+5e97ge/jNajKtmY9Rjy1fWhl3/OSSdl6m67kWFGIPvq3cvSM5Tl7B1tRF9Mqu7ApSs+WiuU084dBEW6YXcoV0dKIOIbKzAMJxznFBpE5Nuiya2FL2ms7etw8R0+TQ+JP1l0SAh8z9KZZ2f7L4sNDQzNdTjew6Z3wjg3KnlevaXRaK8CE9iweCm6qos2akd97F3zNuJJV9/jxfSFQm+i+U7oJ1scd6XOP9RNIeT2fQ0pq6sZWVbz99drgbCFZy+3NRCuZooRQLqT4wy13b4tBYaRzSszvwix3Z2eWmUVy4XVqRA1PkrhpQ3e1OVyTEM1lJYU09e7FCLKeITbHk710g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(136003)(39860400002)(4270600006)(71200400001)(7696005)(54906003)(478600001)(26005)(558084003)(186003)(316002)(110136005)(19618925003)(4326008)(52536014)(33656002)(5660300002)(66476007)(66556008)(76116006)(66446008)(8676002)(8936002)(66946007)(55016002)(86362001)(91956017)(9686003)(6506007)(2906002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?CFB5Gc2iVKftXYqeOEyiYH+Zd+SH5Lfr3bzHXPdfiKlMJZYAKq4RhWfuv2+2?=
 =?us-ascii?Q?53OaVmG2mYvYUKzJuLG7KuGFPcoELrLRloxjLBKcNtiJ22bfIJ0srpRfQywh?=
 =?us-ascii?Q?IsphLwYjHNXyIAdgA10kFbMzWzoKufL+qEQVWjUAO4knTkssyGXFFE+963yu?=
 =?us-ascii?Q?Nt4f68oc0p4w+cmduPGYoIUB/TYd7ekQn3Ly+LMe45TUWzutxO9jW+63hjsk?=
 =?us-ascii?Q?401DCzEO0/286DstmYBVbCWrYzQ2tO2VSJSxv2loZJsz1UuTEXJSOKms+dDS?=
 =?us-ascii?Q?HtW2d6ozzdkMML2gyNOGzVCxRP+HI+24n3SxVCuDyS7QEBP0+cld88SSZE6k?=
 =?us-ascii?Q?lF7X88QpdLJgspwyhC8XTZz2BnOAcNxrl+8Q2jgCcpXCZPJD3Y5zXVJHgbTC?=
 =?us-ascii?Q?mPsAqK4tjSmbrnBKSGGdruDXtj8tdQ8G4wPVq3zZ0wy/oXvanGGZUMWcwH7L?=
 =?us-ascii?Q?no85nA4PGVLws2bDugU7+2fN4OhAPQTYYTNnpFOZIpSUlfLxZDARPopNccN1?=
 =?us-ascii?Q?K5wZ30VO8lMwmDsVmQgGguWKIBIMyw7qN+frxw8syQFd2Q6o8yeFBTVMq1D+?=
 =?us-ascii?Q?cLIf7gghktxzrn3p8Dh/9RZBZ3nx7NtgP43bHFp02TbsB5aps9+qB8SOlMAC?=
 =?us-ascii?Q?CTT2gxqBHmDSXDP3ZyZZvUvmDuqy87Y1kcne/tfwFoo+/4h2o6yfplF8Pv2t?=
 =?us-ascii?Q?lZMZE+5SbGxvivC6C+MI59UJ0s3Cu8rZhHE+B8j3oZ+h/Hg7UjhjN4iEZ8s3?=
 =?us-ascii?Q?p98P+M0Pulr9hCLYnrd3UbJQlQ2kWyLFdLA313KflNo1pwb2W8TxInPNgGvV?=
 =?us-ascii?Q?52+khHnGgBYqCq7hpbzu9Rl8Ao3uk9brIl+YlySFN4AEd30bfEgVjgIUouiL?=
 =?us-ascii?Q?7FSoSOQDnZ4SI1wPYzhsS2ojOfzHqHY9eLGkxpAeXyk9NcjNmL1qH2kUU249?=
 =?us-ascii?Q?P2fsRqpt7dIpdMiHXb8qazNf8sNAdE2lXHj+1Psx/vEt381haFkezmRtSis8?=
 =?us-ascii?Q?m7uK5WzPzbA8ZE+7r4S1LlsTa9FQAMOPvDSVLEKxv3HW22NNsWJVJ35zrbl2?=
 =?us-ascii?Q?b90mZZkGLf3IAWRlUeyf0Isvag+lnSN0X9vU9mHtVD/eTs1svSTBaKx8T1an?=
 =?us-ascii?Q?SQp/pAyGxZATpoRyifVWAqnJZn3U6xvRyDBkjSCaA/JG4lFHXoKY21XeZidu?=
 =?us-ascii?Q?5iw6TDwI3zeOmaHIvlFIHRmzhOet384Oc3XVjQv0Z3FNHF5MgUjhQo4lEptE?=
 =?us-ascii?Q?xUoYAbPjoeen3sXBmWV1dlSjRb4gdUohQRgdGjLoHUFdzkCZdFmkk3OlqGU1?=
 =?us-ascii?Q?4uv45t0F1sky2664WWhCTc0xH9HUBUoC2Cso8iaWQrmgaw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfbdfaf6-3aad-4467-add6-08d8dcb1b52f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 12:58:27.8425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /YDWDgG+sr5eoNfqgl726+K6XQaoMY8aZVcH9VlVnreHfHTWLIFh+Htn6ohVjbmZNQZKdRgXoIimn//6PbGN1tZ9Aa303C+Y4/PH9HE4JEs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7237
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
