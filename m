Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE86CC433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DDF464E2E
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235362AbhCANDa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 08:03:30 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:51771 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235379AbhCANDY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 08:03:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614603804; x=1646139804;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=RzpTgB07eSOnqsokvMMbJv80I+w9kBa19uxZLiWqz3Mg8ScfgA66liyu
   kXwonzyvIb61UBqbtq+gWxc6kMJ0TFZpOQiMMe8MRT8Da2F7pMFT3AA/2
   rRX7CDr7OqMVUTfpGjJYjteHsTvlcqXBjtUiyzgHrUWHDfkJDUKenuus4
   jA6XmsRPQfs6xArTU2dnTbKut4nh+mCuha6/iYOTPMK71H83l7kvFcW3K
   +hJcObqrLTX6PjEmQs3uqqppgADdrjrI9e6jSduF+jrFz1xUPF2oN3RsL
   VAXz9ny+rXoOy8lrq7rC8LgoUt+Q6gp9hB0LZjQ1nvyWJusj1rNvFC6my
   g==;
IronPort-SDR: vvR7+Cyp2s3bTJ3siMjVR5VHtutfBNzuati2sQTnkJOeOOlJuCame6i6mGkPlW49ChurRHimIf
 lb3o5N7wLLrZwHC+LElGuBtaqRdzlfY/142aYTbyDJVdkQVR6qB/zB59oQDDiMntFaPlUjvy1B
 bY3f6dD8YnJWPZ8oZ7QRrYm4AYAuaw0Jd12EZoBmENun4b3lEzfqfZcwWX3uy+zCy0LrBYUGM3
 T4s5/hW2lLPHeFe1dJ31uaOK3szbAYMMEz8GCs6Be0ecCFcoxIwAF41K4RqAoPdWi1FM562Ii6
 YEA=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="162231686"
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 21:02:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J6tY1CNDDX2+aWwiymT1o/IanEkE3+9xnozbXkg2gD7Rb/zKxURSQup1K6MT2cdtTNk56xHHxz4dl61KNWVma8koiglLI0ReJmaUq4SXkgD9t/6z6Sin3EEzP9URzzA+F1X36g7FCU14yW1nLrXM52l1tcw3QxxNpC5eTYofcVaWqhVgXLEpSPC36pYPmx4r410Q0VVhkLS1dRwhXml6F6R+2v0trfIBBd6zyJgH8y/lWw7lV8JWJEP46wlQJYnWqGS0mCVCeZ6G5/2aikmdmiKTErbrVKaR06fgmlRk8s5okpPi9IEu6jphJfAvU55w/iZ3bEZ8yDHjCc18Qh7y7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=KOzGGHsWjHN9iDZfW4XfZBvHBzXO88oYdXtfJAgNflQ6Lk4twanQGMLPlt+A58N+3ZhVCSM1gazMCV1gpndrLJ0xw/r5vI3YpSSkyHCk/12krmvbAGH8XnIEd/pnxNcziCGhcOyvnO1O6Y471FXXUaqYmwYEjlHuNANx5+nhi+z8itwLyfRJKuMLlzkmoiL4I4JVq6KMx64KgwJDE229rZ+POb7/VyUWu4OHwE4H/0TuAzwTEdMM+UvfMfMSkHs332jgUQAYEJIm5YbkxWoKrYuFSvQsNDKfhG2RG+gm4b8uOwjNRN1uEPJERa0d/U18618cAcPh7fj40ZaULNNADQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=aZLg5ZeOenVOVdjc9KnK+u7naXsysNOCvnY4RtC+kzlNvmCu8yBS9vsnCxQWDae/lwHXTxSb4/evxtatRsBeVf3XR3ZKpZvAqtVSo9XlQUVE92JUTRDsdG7e5JV54Nf8cXbrUzUot5G9kU1fxZm2t1R5EV5q7aLf5W7BI/DpFgc=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 1 Mar
 2021 13:02:41 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 13:02:41 +0000
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
Subject: Re: [PATCH 22/23] target/pr: remove the memset with declare-init
Thread-Topic: [PATCH 22/23] target/pr: remove the memset with declare-init
Thread-Index: AQHXDZdg6A7I69GdqUGEwVa3Pq+9zg==
Date:   Mon, 1 Mar 2021 13:02:41 +0000
Message-ID: <PH0PR04MB74169C2DC82C73793942A5649B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-23-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d9f8a06e-a098-406a-4e6c-08d8dcb24c63
x-ms-traffictypediagnostic: PH0PR04MB7605:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB760574D479DC44B9988D202F9B9A9@PH0PR04MB7605.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d44NpB1L8L4I47DQ4ltjjtAT5BjRVPMyG1T7Plcl5Shjzk0hi0Gpzt+PyPptfo69Tno8Av9EMrRdymf6EJ9Eo5zl7KPbx2nwGJ6PJFC5G9AqAR74Atd6HEEQvJ1fmKe7+kAdSkd4S9vyKr11h1BypKzukyX7wgRvd2vReunEaSFlGXg9g961tym5LkaPDXqu/4sYwNZ9iJQIIpzmrsye46PuQB/eJIum84eWlYDxeTDOVXO9I/SnpIli5Uo29O5sQyQo9F5sV3uubyu1Wxf3syENl8Xo9VbuIx9rSE1RcyrbPzTfMX6yERlxEtCV93xx2ctU82pnIrm7nqOPjDdTjS+BD/+7a6oC1gOl4VJOjx9J4CV3h0b3Yaq2OdAUJRoRFwIPx+ZSPEOxc5z3DS9CM2BH7IOFX38SJ2aS2ZoptA+D3MJB0MNqV1WTLOz1DvWd5NSVq7JOGyDRUe202wJ5izLoMR63GnXGBDBxCRF4YlseQCpDM47g3JL1FoMkaggEjrL4aNJktTfGM2iaz909cw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(54906003)(8676002)(110136005)(66476007)(66556008)(66446008)(64756008)(66946007)(8936002)(2906002)(7696005)(71200400001)(4326008)(316002)(478600001)(5660300002)(52536014)(19618925003)(6506007)(86362001)(558084003)(91956017)(186003)(9686003)(55016002)(76116006)(33656002)(26005)(4270600006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?EYwu9vtQE/dxwcNOecHB3jVDYskRqQ+NkIdHF2Q5iD+EC8IxK4ZjK1aRafJe?=
 =?us-ascii?Q?ObCTNhF82jolfLzaelhsrgsD07J1scfQkR9hzmJriuYwcavTJt4q02Y7g2cx?=
 =?us-ascii?Q?25F1D9XneKB/k/xhrVKxSx/2XAHuuApjuA/gDv169QF3xdr7aBiSlS2LoeEU?=
 =?us-ascii?Q?Na/QFaEyGy8Ee3RJxI4hxzJsNuS/pQh5jFvaSjHKFLxamYgpVMSBGlkgRslh?=
 =?us-ascii?Q?70XxIE50svxyIXZ/VGsO2qTyV2No0kjNqKTNoF1ZNQlJ9x4tHvVRKaRJE3/d?=
 =?us-ascii?Q?DI9Pwwbi9j1+RGj9UTfb/Q2dpXbDm4zRG8/M3J4Xqjxeafj+uVqyTrJC/bA0?=
 =?us-ascii?Q?alRstjqb1PkUy6yGRlXsxpd8LSo6Y1V7vTyJcANE5RYkGCXnLrFIJbYjmajc?=
 =?us-ascii?Q?8TZ1UxP6FrRNeR9wmHhkDPkWsZhD/JiANqiHnYhDwwkmQjCQheXnG6mHGJWF?=
 =?us-ascii?Q?xWmSB2hOLS90LwTppc92yE6jgvN3v1YZyIXyiyiRC6Q2sRopAqSJ5dFy3eMC?=
 =?us-ascii?Q?DYONAjfgCbsQBPNXAWbAveyr/NzkMfW5fELID87P5udVLqTba8/Ybp6wNTdF?=
 =?us-ascii?Q?tP4P4xwpiP2+tQefvk8PqmVpGbFAi/ipIUwgJX1yK0PFYDPKt/ELTJoeJa9o?=
 =?us-ascii?Q?UUatUxd56/3Ot4jSB0NSPCx3cJ07q53pGw/W7Kqj9y82+NROFEM94kCgZPTS?=
 =?us-ascii?Q?tcpQvTvwYXSmrxm91S9qdE10na5COI+Z396i+u1kAXJ5P/XAvFUsopweIQuD?=
 =?us-ascii?Q?YARFFQtsh5g2BikRvDUM9I0XS723UUi/kbUJoneIfN6PEJAoqxPT+8i+94a1?=
 =?us-ascii?Q?rmMkubo9485S53XHCZUBi87NOkEMsuhBoZV8fpsZcO9cTHJTNNek4RpEcNYi?=
 =?us-ascii?Q?uz2iPHso/S728UJK9saAFVoFLHZaaFy3K1F5JWby8XYBbEUVotNjUZuVFCJh?=
 =?us-ascii?Q?Zep1szXVgKgNO9uaft7Z6s5CtKdw06YT+Jq7LA2/LxK4CexoRU5Ai52TISIQ?=
 =?us-ascii?Q?OmaHtzBKpbK7iwUQrrlEoVElJoElH1MPOT6tuOBivrqvotxutSRn8Yo2Wuq1?=
 =?us-ascii?Q?+XKDPhwymvIqP3Xx0FG+MtkMMecBu80auYsPqdwlWI13dM4WNuh/8/5MS8I7?=
 =?us-ascii?Q?HKg9otwxAhQS3peQiV6BG9mtTmA/a8mB+lKoYuUlQ+TkQ1NQDwQlvrEQ/GwM?=
 =?us-ascii?Q?YAHUYhm37ClaYINpMRDFIU8/O+rylUc8wZmAr0zGmSFgP1pKsTx8prUOicQD?=
 =?us-ascii?Q?rNxrgAjTuWA2Qbc0gzfWXbeUCndizvVylXys3ZT+ea0jzDJGYu2Y3pkUfi5i?=
 =?us-ascii?Q?qWwWJkOLmdx/ETa4+8iObdI+qaN7D2l7t6DvoqNfIakmiA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9f8a06e-a098-406a-4e6c-08d8dcb24c63
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 13:02:41.5835
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WRHeVmZakgaXf9OImq3x9urcuNUvKoyzH16cEpTYww3Gqb8y+lguoxD/boI/fr1R/ftEEdqSreCx/Vj5g8rQexWMLrE0ubrZuea2t2IzIOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
