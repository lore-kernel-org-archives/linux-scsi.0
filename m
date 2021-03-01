Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3646C43331
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9184064E5C
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235206AbhCAMw7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 07:52:59 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:25039 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbhCAMw5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 07:52:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614603176; x=1646139176;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=aessUOYy0FhMcbJR0TeRV4PoytKOTxvApfSCH/ulSOQ=;
  b=WojSL+sHhB6WUnUglO39brqk8KKiaJjLw8BQGo2E+eYpABrTZR3BvjHf
   q1ClVBYT6KUykMtPwTUNH5MA0/Wr8HErwuvpY5JvTgMC5YBCxF/jq89fg
   kYa9jxB3J5XFUCPswEtnmpt0D/x2EkgIfovnrNXdKoXfs59Q04klSzbSv
   9tL189MI/LPUx800D9/5unDO4s14ckb/umZ2BSrwNd+QVYi3OT7JqkfPx
   yJlM/3gzFfzwmAdfoFKEcp0o4PqoS5Dm3MR4CFUMazoORILTf37oQeUsz
   K/4cuHElsVN7Fj7IfscsjZumUkXe7Gl1zhDVgdWarhR3/FQd08uKt+bjp
   A==;
IronPort-SDR: zmkEGK9VVtOl2ZgL6WvfkkBZBkEQlO9JMZktxUrQexrTMcwPr3NnmiyWxPSmKAwI8+GJuVqQi8
 l8NgvWS61AYEBoxVEnPaLU4pqbD0f3P48Xte9MEjuYVA8FJa9cngFx3km53iKx8vzP7ceO2/JW
 2s5EbszEv1PG1FZywLvWKDMCvMxanEC0JsBjS9XLTSJ+Emls0Vw73IckvaAu6xA+i/QEKWiI/a
 pe8J2cnNFmPX5bHX3p3zdtydYpdNfyu7go96tJjrFbDVRDhdq034c4maT+bNSzVwECYPcJoL3W
 1lY=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="271660124"
Received: from mail-sn1nam02lp2051.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.51])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 20:51:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EMMgELuRnDgN2rGpfZHka1SU05I75rifUnzaOXEbQGmyaQU+Wi8qYVF3gvpxq8seIz34yF6z/ttf6W9Fi88Xi2uXO5RjfW0PXevIrUcRZ7hPBLneO/G0ndVHaP1lWD+cvBRpLdV75g4FoDh7KWX0L+i+uWtrjq8EGqRKMhwzf3Z6wO/k/KmTvIUx89JA1jvwaLCHbdwfdIsP72tPhorHaQV56F1jhj10QgYPtmYh+epR44/U4firx1JSjAe3HKPA+d6PLTEvJvkcgrOhdlIA2Xnam8MP2+eL8sCPe3uWepV217LYad1cStEEInzi2dBDJdQcRVloQN+kcqsTDgDHkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aessUOYy0FhMcbJR0TeRV4PoytKOTxvApfSCH/ulSOQ=;
 b=lYadkQdfCAezBxnIHsgOYtUde1aQsiKURphirq1FuNkP5O9vPu//pWHBviSz5sUCIFuNs5QKDxTh/G8R7tWdb9uvJF1+P7DQMlciID1hn7yfXiP7o9FQbIMSFqNI7XkSDaatrC10iTGMhNzIHPuh6mkscBz8euUt0e3eUeAbI/SseSyLHZYjLyZG9aVYjaIijQH1xl8KH+d/7pkw/lPzuWHYcce+B2h8T4Gn9JcFPP9dxlSWjcqWCaQFsdVJk5s88ra+IrpPrHIh7EXj7ZJarca6Jr/NW8F3nHN12RvmGDXzzs3ArXij0PJtljTfS3vk48xOSBGn6E5KAbfQk4VvDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aessUOYy0FhMcbJR0TeRV4PoytKOTxvApfSCH/ulSOQ=;
 b=mwcXUwsw0qNK56YEZUOcXz+s2rUn4ICdCbo+JYee3GXDAJxHy1qf0D80xY67F1rcRID2SaOMRZRX9+M3zV0l60aWYNNGB/9flWygrBoK/aCPsqNDcfdmf3RxhCxI38b95utzx9uRmFWIsKUpxgAWp3z5U4na/WcxPiel6aAIxmM=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7349.namprd04.prod.outlook.com (2603:10b6:510:c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Mon, 1 Mar
 2021 12:51:47 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 12:51:47 +0000
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
Subject: Re: [PATCH 05/23] target/sbc: get rid of the warning in cmp & write
Thread-Topic: [PATCH 05/23] target/sbc: get rid of the warning in cmp & write
Thread-Index: AQHXDZblsITZFw4uwUm1PNlRCqJ7Bw==
Date:   Mon, 1 Mar 2021 12:51:47 +0000
Message-ID: <PH0PR04MB74167C7A3F2DE0EF74EBAC059B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-6-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c46ad531-866f-4652-570f-08d8dcb0c667
x-ms-traffictypediagnostic: PH0PR04MB7349:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7349B014F10FBAB3C68E94F49B9A9@PH0PR04MB7349.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C1xpr07UqQIa9kYQbtLAVdJu8V9ROmgj+qUftHMTJnkE6cdGx7hdrwWjSmH0zVsrqhixp2eW3qFU68p6x7/gB0Jrs0gGY2R19ayGsldP+cJ4L9OyEOXTSGS9GBgZdR7ochc3FPDlsJ1t7bEqFODolKcqbjjyaxTYwfrnaNCYWf1ZM8HyDIckZTfgbjUGkmWqyfYrTqtjfA4cuoqQNO8cY2bQDmS0gOk2O20HZb2lyeNhX8GP0dE28A20YujWtXidlwf0+WZ0nHvKt5fzgefMi5sPdtkY04ydjS8QdsLSwG6X5wma913yjjUfR8dMhHpnUvZBpou7zUFSjzxK7Kl2zxk89tnsLA0a8ih5JumKRhqHfSa/KW6bLksaTnlP/BGFjKOhPmp+qkZYLnxtcsIInsL/ndEFOV1ubNR+IJK5A7U7p5/vTOUphiG40UcCn6L9n8QtcqMBDdq0vuIKxUuEoTJjaqZUbu6o6+x0SPorEhZaJOADOsNNgXhDyG2+IbU8Sa5RUJ+pd/zdtp6vmWKWWuq43LEpmEonKri4hsOyscmwhew8jgEiZo1b8teSW5ux
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(8936002)(8676002)(478600001)(5660300002)(19618925003)(4326008)(6506007)(55016002)(9686003)(66446008)(54906003)(110136005)(558084003)(64756008)(7696005)(86362001)(52536014)(26005)(76116006)(33656002)(66946007)(66476007)(4270600006)(316002)(71200400001)(2906002)(66556008)(186003)(26583001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?5G2tEPTMQ88O9yPMyckT4bdm6CJi2vg7Ii+WNiSo+Y7XY7G0zbZqrR9FrgjW?=
 =?us-ascii?Q?IJJecJoMG9/HI2tmD65zpkYJzBlKLE9x1nQSEnElY6eruMRRB2Q259dEmDh9?=
 =?us-ascii?Q?n8zSmTYSzMzwDs0Osj1bP8ConpAStQP2cDwB2LtIq7foS8gHje7AbMz7k9pA?=
 =?us-ascii?Q?Yr0wil89qouqpSGyU0SkA5zIaKd625CGen3Xwc+xrhluAlxV/ih1EfwCqyf/?=
 =?us-ascii?Q?pN0EPOzwWuW93PsZ4z9E58EwkJvg2cY6Dj3qW2SpM7f8jR/wUGsdbdjg5lF7?=
 =?us-ascii?Q?hKa0EIp992y0tgwVZ9f58ulgk7MTd1hVlValywqydm1QCra4p0aborRO4Bvr?=
 =?us-ascii?Q?xQLQbykD49hGYz0ZrWF/wTsaH0XC2MXbwzYDQYxVcrn05nSfAvVr7ur3RJCK?=
 =?us-ascii?Q?vRsZSoP7tKSibb7kPTHDJ9pA+ThvqIC3DyeqlsE/vlgwBDBJkaUCZ8Z7amda?=
 =?us-ascii?Q?tXdHQpnq1MTln/0lfYt4hzO/pEdveL+j3CWIfmDG64FKJL1GmrO1v8Dsnls9?=
 =?us-ascii?Q?UeekTHuAhe9hMVJ1tQqkqaVMAfFLIdASevXkMOJGJ593s5uA1p1reTaSSwKn?=
 =?us-ascii?Q?jMsgQWnRqhq+Z72C58xiIfgQ+McGQ1x/3Ixr7PxLag6GE/59d8XmiQt42z+s?=
 =?us-ascii?Q?GYK1ODRqSxbmlPpDG88eGoGAJKnImSN917Rb899MvADg4rYq6sy/edPOSQfF?=
 =?us-ascii?Q?WzY9IQMIDCO1dvh5ndtMY8jeMmRtZU1AQaDQ9XG8/IQ6lI9whh14R2wBS4NN?=
 =?us-ascii?Q?bAxZkcAoWcNpsLkzeWdgi0OFI/tl1c/tr383IOJKl9oynacbXx8/4GZyQN5e?=
 =?us-ascii?Q?4EzMVZnqUhXnVdAkmRebeC8ovKa4spemn17MpkyO+amPH2LrCl1Bqx+2wSsN?=
 =?us-ascii?Q?q3DcLgrhnzY/H6s/fOiNrJqMCH0Z/lsrfeiSV9y+eFxRcR/yc4OWNjoHhYt+?=
 =?us-ascii?Q?jpffZnm33ChCgh7PiyVnIYKxMJCSH5J6QWF5JxEn1mQtrh6+13fMLFYJCqqU?=
 =?us-ascii?Q?3eCFPWMZsyI2IbO8HaIQCRCQBP6pz/dE7LWq5kVnGwj2AlwToR6x3WRG7kKa?=
 =?us-ascii?Q?D7uD99BmcayiMf34xqEGz04gdw4afCGLkd7ZOve8CzSMohhFI8ftYf70xiUD?=
 =?us-ascii?Q?yTx8cOt3w6xV9MX7gHUlbBkq3NYHne7/XksPF0nTvuIlVqBkj+Wg9OAEChW/?=
 =?us-ascii?Q?aB63BKpLNzZqLnX38znX0ov4zGRUm2l/cdPruyfDjGVqGehGcxa+W3uARl9N?=
 =?us-ascii?Q?3RyRmAV8W2jSILmfzZWw3ls50Sh9U2oan+o3DE2PmBi16KMk9tfmrNEu9Ime?=
 =?us-ascii?Q?+95NJGSb4p0tVBkW22FOU849VJrbUnqe+6pqKq7WwefdRg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c46ad531-866f-4652-570f-08d8dcb0c667
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 12:51:47.2557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eNzln1rijsFPbjidhXZgu+tKhB2YjsvbUMwmfzZQ+QcSNud2t8dNbsXFz5nVCt+FccO5OGriZWCKOjvBhSqhg5e1qHo6EfeFXMN/oUcy7uQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7349
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Oops,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
