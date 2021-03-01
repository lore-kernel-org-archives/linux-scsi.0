Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3317CC433E9
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02F8864E66
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235375AbhCANCu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 08:02:50 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:51771 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235344AbhCANCa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 08:02:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614603751; x=1646139751;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=GB0xdpVYOEKMBko9JVIQYJw8+8o5cR3lhkW2DmyLUVK+O/vQ3yN2dd3u
   GWQmNKjkhMhNg/F9WvdAakkqQCbl2oxmxU7SY+bYmNvbN6iMc8LVxmrCp
   WrZsnxinL+j6UgtpYUZ8zFwte9JHJ+nQ+ZdwMJp/vGfjq/LVkK7+9iLsp
   /cI6aS8NUbeT4xl0AH/LBC8+nzfWIL6KUN9uBTaw0R8EmYazkQHgXNGln
   dKCZ/TdSihMNrV7JTswRhQDAqijCcylTZJJml4UwMxGdZrQudBlVI9TCY
   UOYm+vAoNql4u6ZoZND9lA8QRvc3YgSzqrzOXQfMxAKiJLfCYoGAjkm7N
   g==;
IronPort-SDR: Ha95NF06EnpY7d4ddGm3npI7yAzewLfLTfQyQeTn+cCpGH5bZ4fGR38L17z8FA6vkEXUuEH5c9
 c/WLY+pw5eg94rikYTWevGmvwofzxnFl26JvGknOpQPmxVOG13hK6VH7gg/BXUUi1eHMFhvTuX
 DZwVc8gn/cRghccbS8U81xkIV1ePgOafolParaB2GKTFsOFz5ox+m78bvRD9kJWEKLt2NxCKPR
 hXY/6vLnYau/jndnNOtB7x77Zj9ra/Ka1D0XN8yW4Wv/kw/513B2/St5i40S4D/e/fd+V/YyVg
 ghY=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="162231617"
Received: from mail-mw2nam12lp2040.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.40])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 21:01:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zj7zDEguiFvuuLjPp/frdU3XNftUM3NTWY/e4rh238Y07Sqb3CFpVOLJvquie8DBNvf6X/jJqS3qfpGDl6CzBwi9Ki+1sCOSk6Is9YU966lJ0hrEagUxFZHqpmjLaWYOq+RkAprsMVrXK1+M4DTFVHAd+ZhBa7Uz2gJZp8O8+U1/GxYtTjv2B3rEMgGZK8He3EM2yeJkwFgfv3Nw8QrwMAXh93Z5hBfwgokuvi2e+xK9v79r0gW+5W9pLYe4pcXv9crQwCquSD0E+HxRlThnDdNNNQJ0ZruaukvlJeh2BYSDZ0561MKYfVEP1Ik7FdBIixH1Yh5iHDnfTQHUppbsww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=Gh8ZuVE0DqRIDloA6Be1Xcz8zFzxYyL/qtLPIMUtzsMVC+3IP9yrFOJEnCbY3wthf0AM7o9ue7S5lGNbREJhWoRUj9a4QdgzvDpPkol7KSCqaOv1BpGZcPlV3robNPVkXHgds0A5KvsIl5TBlpcV4w2GnI/Dc7Zzdy73EyI0Tis1SC9egXGV6edF2wUkKF63idCgGcxYkKdyauKH4TFPIFocZCln5x5/VqJyVSsZF5t7H2q1l1WevybdToSc9NMqg0i/i6pYSoIgk47cnDT8RK4zeJgkz3kT4c1uIyCh5M7WGjFePhm5wye5wbZ77DIXfW5rOUVWQLvl+m2UAoSBtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=y0oZrcrytgA8nzdyLFpwACLPL6nALHFDHz0cW/vkPOyniFdiB6Ybj9TtnglQBTcMExexlV2djRihxz/STFtm9a9JlBNV/yCqdRu9ItQyNjjGv2HZmVlQy9ubScE6Hus/pQgvn+wOXFjtZRi7PG8JnIyZoT4T554/TCIjT8bh4Fg=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 1 Mar
 2021 13:01:47 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 13:01:47 +0000
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
Subject: Re: [PATCH 20/23] target/pr: remove the memset with declare-init
Thread-Topic: [PATCH 20/23] target/pr: remove the memset with declare-init
Thread-Index: AQHXDZdUTULcFYs6406Hl2VXEtlbpw==
Date:   Mon, 1 Mar 2021 13:01:47 +0000
Message-ID: <PH0PR04MB741634EF6D717995CCD6D56D9B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-21-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b7bbdb1e-0681-4f23-b801-08d8dcb22c4e
x-ms-traffictypediagnostic: PH0PR04MB7605:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7605D7351F8BD0725C72F2389B9A9@PH0PR04MB7605.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lUpVjw331EZ/x4HpWW++kUGdWSmtO/jtRQ0BpvKzmE1n5YbKputdFt3HqeRc7zkgcRGHS+UMqAOJvZWIbGntwHd4yGjeW8aPnwx3D1HHZAoWFwGbbYpHEnakaFTqs0xGKPJhNGagcgIVwVYRxZQFFy/erg4nWV2PxIryZNXGsL1viXAandJl0mR9pSDxDsuL9/evp7mIU1xUk2T0IzqyAq+BfXXcpwxkYmDBIyXHFRpToiaa9zqguXL5EbZ3T5u76AJ6MFSXSXZqDgM4TClLzC3gqu1cya9t2g+Zq4m63laziZipnjPsLvRb2itqhoHQQxcKhXeCZmHLgfB/A8jhCz6ESp9jVV4mkLv34UmwhCVcJeJy0esThRMp2hIpyPsLKGc19XgP89UDJ6PMI6rvBiCGTVcgPYNDWMnZ3rc54bJRlJycOZhx6d5lGnMhTqCp1qCpl/dFN40Jom+JUs+FeHGEHGmhbU/DE6MIMxKJ0YTmz5il4ayvHJcmZ4ONpxUo47S3Sj8wNYNjBVl2ISkU/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(54906003)(8676002)(110136005)(66476007)(66556008)(66446008)(64756008)(66946007)(8936002)(2906002)(7696005)(71200400001)(4326008)(316002)(478600001)(5660300002)(52536014)(19618925003)(6506007)(86362001)(558084003)(91956017)(186003)(9686003)(55016002)(76116006)(33656002)(26005)(4270600006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Fd1QqrYhW5H+xE9mh9yOvLmyjUpSwIFQxfT4LxwqJI14sRhSQK9ylZ4o5IbL?=
 =?us-ascii?Q?XHCM6Ckg/fNMfaXnk8QbJ9shH0zy4tF4d5xggIQ9fcp+7LcJerjZP1+Qo6XQ?=
 =?us-ascii?Q?KO5Ug8/aPSuYJdfX0NxlMj5arQ7wtk5OStgAp2DxhKtKz8p6nCWOSLDuvVYt?=
 =?us-ascii?Q?u5ca1xRkDvjt3bc48KeuSb17+KUqdKQbasluox4qDJQtwjvbi3ekmQ0CoWQI?=
 =?us-ascii?Q?Ii744dOqkIyLqxzw7o80/18lT+2QP0uz60T6aBkAL3gFL0SqOZl0heTyH+Oe?=
 =?us-ascii?Q?qIppbJKXoeVVZyZQyV68T/Oi0K/nDi1VBIEPjzA/+8qyZKE9wOxjaieS0Ur6?=
 =?us-ascii?Q?Ru6qkPEFDppNbmSLZhI+L1EoD6SChVsJDPlLP6sd7GKizEGIkMRyza7H9DXn?=
 =?us-ascii?Q?wDBmNfnkcd7RO32FgqfwxJHLPSdFBJsbFRSas+cYQIoz44XsrsKJNZLyo7Cp?=
 =?us-ascii?Q?+zd19waJGwx/P+pzb9xvmmxRlKUhCW5jz+TzYQAVhiQyt8OhKAm3Hl08yTTW?=
 =?us-ascii?Q?jAbN23+wZ0wlOcnDst70Wy8ggP19eD2lkxXcHbJyrXkqPIcUbCzn7MZEt+29?=
 =?us-ascii?Q?FkFTXyA18MP7cR6EeiFztFbGAyi+rLVVsGSm5jZXNFjt957bnku/XS521lOJ?=
 =?us-ascii?Q?qvPgof2a85soCMGYSGc+I2U93cmFa106wX+olCbiTy3wxZUcwhNmNrHmkI7E?=
 =?us-ascii?Q?NsTg4YngNeB19JMmH5k3nr/Fj488VSmsCpcLAQQzXFbSxQ/OWDy7SnWDevP/?=
 =?us-ascii?Q?3wTD7k8uGxfGiTq0Z7chjwBA8s1fHgcA0f3U3tbGRmiSdboqtOg6PCZML9Ot?=
 =?us-ascii?Q?mvdzj5XYnMPu/vJg+AHr7XcfcL4BdKYNwNHLgVZpKJ7PdMDkJpZXHCFa+9oS?=
 =?us-ascii?Q?ngzwkval2pk7Yj1gsmRn4ehiNegzVvt7Uf6w36DdxjUX2ll538fDFYsm0SsY?=
 =?us-ascii?Q?x086Gpp7MmiC76Si8JxGHgQBwmRpJEUpJG+2WP3ASFRhHk9ve3bOZaX4+G+0?=
 =?us-ascii?Q?1dwapM7ktH2iy//CCJB44DP25fFHM9ZvxJ9CmCsCyMR0DtxHeKf/9wdRIP7Q?=
 =?us-ascii?Q?awsveChqQk8nNV0Of0CVo1l2k1Vmk1bpuFpHUetTp/8qjnNhLdoP69c9LNtU?=
 =?us-ascii?Q?AHhITwTSt4t+xq9u6vxHIDccgihjfkLlZ55iWj8RRaJpgyOJtbIDRgfLDLwD?=
 =?us-ascii?Q?N6vHPRUeCCqW1OpZ/DrBY/ZrlkwzrcywbaR1zWxObWQLXYQZHwCgN8HlunxD?=
 =?us-ascii?Q?iTTuRBn9pqXvIjwNyii0L3LKi72Y+f+X/YO0njaWWoJjasqUgwNP1P9VzNZX?=
 =?us-ascii?Q?TulHVtr04P0S3kqDKp5/m9l14fkaHecVnE13m02iPeXEPw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7bbdb1e-0681-4f23-b801-08d8dcb22c4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 13:01:47.7376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gAFQDvvJDT4kZ+4/5CGGNMcf8yuaUNqwJzsLrwenyaWHY7kbWCKtnhfIGCKBNadTUVmTiVZkuuKFR9Xh87WXZc0vCsNS/xToO0lpsfjG+8g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
