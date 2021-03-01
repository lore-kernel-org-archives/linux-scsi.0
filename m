Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74185C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 386B764E45
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235283AbhCANA3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 08:00:29 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:48451 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235272AbhCANAO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 08:00:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614603613; x=1646139613;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=ldCZHdIow51qT+Or0kGmP0UEOBzirGkfXVhDdRY92qb4+tWBHZzScfci
   9mJ5h5hKLPp0sFwHB3J6DpWgS09HBAxxKmAGoelrsU77Ar2A1rVduBDuu
   K6M9XLg8p2jH/+a9uWEsTMkuH9GESBQ7rzGM7VpRz8rLQo9mLlMUO0rgc
   JD4EuXSpGFYrXystCkgKNh2KR84oMLCBi+aWm3waWUOmnTUiBWwdDfP9R
   QDA6IAPxn7/JEFYsrV9VVEitBxlRvUHXdKm050HXW4XzhDLG99ZlWeexg
   oaUawTGi1br6fOJ0i/gz/0cx7ex+kv2zRWBQRot8J5g+dTheW5w4rUiry
   w==;
IronPort-SDR: Qy+IUgy8wKt0Xi60QN6BqsfzuW0Vnyko6XDpdTs/fiRN9v9M0V5qOwNj/23zlKMUO+HvODmoS/
 XeLtgAdrQyaUTlV2oDsH+ETMiiYbt/nG12tsdgepJPVqk+gg5y7cmjn+LYl/xiyKBOITt7fcsz
 NjKwuN9P5cGxUyd5CcvOUPbqQstvPrzAxI/l3PD7ZU41p2lq3+aJyNkll81Y0LSledNS642VMf
 4AZX1IJW3VRU/8opMxImTeCw5EX36MG4+b+/gYgsDS3CSEHU9zhziC5K9zG7x3L1LsJZtlXL1v
 2XQ=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="161052637"
Received: from mail-dm6nam11lp2176.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.176])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 20:59:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XPUAZpaCGNQdVkiVjdm4df35Fm2J42iI4NB89w6/+8LMgQjoF7tdiaLznwybgCE+h3qfxw7TyoB///kOICNV+2YfMNMRsrnsyiL6CrbkQCmn5DOHwyM8tN/ujq8qHuYDA9oDg1iFkcXqV65VGikQc/0/Rz+RjDPYHzj20KPB1UlKGwlczmhgz5tpbMmRiPe9WYtlQ6B1tVX9nvzdHof0kWLko8bRg5Uc/q0BNNfItjExjaytcjPXFrsu435wecULQmOAiYQRF67/K66lpINivSPICou7zPxPla3QCN0cuP2/lj0VpTxgmqtIDQaiFNAdZXCDMkV15gP1YMFPZs98WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=k2VcdO0nxX6np8CZrZ0sZLIiRPZlz/ogkBLfxZKKSrpq4DlUUbtI6grCQ99kzOwHZtC/GmQKFpF52bqduEecvBDExCmZkdjfOmpoAXTKhlYs0tL40yPh2yuOGgTKpYFPf+jLNGGYbKR+E484PB6B1OFWu9RGdYZoG3gLDJAUGywNVbJ+X3xCp8hybArK3khJ3FYNwJ/TOYOtxDPI5/BEOpmKiIezo9le6XvOtL9/33K0KyOLwQmX8bLzjCoyl5SnUkXAuUtwwZeG4u7eU/5Fvhl/UulstGMKmIxXtxM8Q/s8KwrNANrSUjfb07TZM0QjFPEAJMPqaN46vlfMwJ+/MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=fPq15HeKD1gZB0lAKyMRcj5Dwt8YdIX4HdcwtroABLRwMgS8Ib6py0dFr+ztMEmrEI8WNP7zPAsvjOcYWKG6lzEURT95aFm93Mne6NhCABQt/Z3VId4wiOXzDa4Crx8Ml0/Ljbp+4wDFWxOEtbDIcwCyRm/oH4lv11oXfiRQdrI=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7237.namprd04.prod.outlook.com (2603:10b6:510:a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Mon, 1 Mar
 2021 12:59:23 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 12:59:23 +0000
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
Subject: Re: [PATCH 12/23] target/iscsi: remove the memset with declare-init
Thread-Topic: [PATCH 12/23] target/iscsi: remove the memset with declare-init
Thread-Index: AQHXDZcIPyTt1fX3VEqi+fsf/9GrQw==
Date:   Mon, 1 Mar 2021 12:59:23 +0000
Message-ID: <PH0PR04MB741665ACBBC0ABC89D4C44479B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-13-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b01a9747-594c-45e0-ac85-08d8dcb1d676
x-ms-traffictypediagnostic: PH0PR04MB7237:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB723776BC4B9D740E5AE2A8239B9A9@PH0PR04MB7237.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OuJjr3zPm4bwvhEwmidru1G4mGzoS7Q2ZB7sFFomZNpMoTMHZ76koM+WPRrfTPL9sVIkqBEgx++FKzv/uQqjWUzsgE/ptXvk+pTPIIsvg9THAc2AjOA5RxX1OGoHgoO1qXbc4+zvo3f5B54mcDCZ5is6a3lKXUIixCWWP5TIPSweHP2IaepUJ2mMMuThJdLok/HO6Rk3nu3Kht8t9zMzEF4dmENlN02/vZBsQpkOKQeG1ScLFamPeWt8hPcuQocWKSlpN3lB/A2cAyp5SuH0Sx8fR6elTqihLDCC0/d0zpkXe0YlhyLTd4o2vXOOxuSzPZKX4qTKUeNZ6zOUnmpf7g/WxSm2FoiAgXaHigjqdkWgT59OdMlqvFU5nFmQ5iSX0rdAsqF94HKeQUwM0u9IHEBfufr2iNBWnYGjl02I0ZFeOqXr5TqpbXwwauyFVRZqA7EoONRkV/tX+nsRDDKsoa71zORR1fSAPapQDQNY03g6NmKKKg5QqSAR99HkpDZQPTdnl3lmJsr0tooGhHeCWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(136003)(39860400002)(4270600006)(71200400001)(7696005)(54906003)(478600001)(26005)(558084003)(186003)(316002)(110136005)(19618925003)(4326008)(52536014)(33656002)(5660300002)(66476007)(66556008)(76116006)(66446008)(8676002)(8936002)(66946007)(55016002)(86362001)(91956017)(9686003)(6506007)(2906002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?C7eNb378V9VKZKuV350A2CFBP6xU+g2F8ZaJXYsYxULDYpI0jbRKl4i3p3bY?=
 =?us-ascii?Q?aIdYPx9f6keWbMaCkaw9tuNb1UYl3rX5aGlS8UUEyk8KheEgL/u1yHgTonYD?=
 =?us-ascii?Q?nJKv2lB64Xylvh375k+sqqQ2qVYP7S662XhKNlzWcHGlJeK4YPwItNcHthqw?=
 =?us-ascii?Q?dImOAL0ZRgrUDgcpk4H8POujEDR88vEfQXPqBljkANcRYo65s77iuxI1TX8X?=
 =?us-ascii?Q?pjkrZPRWnFcHz4hQ2qLpeq+k+JdsXVFuWp9c3Hb+BK80tMOEjRnBikFMFrHE?=
 =?us-ascii?Q?uSA/ZPubzLXvI5o5IH11b6v3gytTRez1Wy0k7sO/zcMnCpTWeNbhNy1C8/Wk?=
 =?us-ascii?Q?laKBdnciKnthpRIMKxw5R3MdvmBpF11rzneDEcbZIlcjPVi4+GUrsg4Q9d4T?=
 =?us-ascii?Q?KhmwBoNR7E4qYPnWx9t6ZA0bk10Vt3R1qde8QSdeXfcTIi3LdUtWr2BTN/M4?=
 =?us-ascii?Q?y98sSoRWdTvzCDINqfDtuHPVR1K80qaD4VGAMQZrq6HlY4MwjNuddiO0J1lD?=
 =?us-ascii?Q?By9JmVbG3sA0XWESUNcgoVMMGMrSj9O2V+/b+LW+a+NwCJzPTl4p7F1LVoV6?=
 =?us-ascii?Q?iU6kLl8M7I41rVfz7TLWE3HfTUQCF2syDsZhEJBD7EHeU2y9BuJ49PxPYMzb?=
 =?us-ascii?Q?weMwRYOk9Ydn/j1lRQbX4H74HQ8thJl5+wQF0jRvsyirnGzNfq/mQ0MHmott?=
 =?us-ascii?Q?9E52zp0hHRGx69xsBu8pWxW65dkxkvKxwaG0ElvvxwlCL9r5vTCx0/vEaHs9?=
 =?us-ascii?Q?8TI1+8zcUTQk9TfOGda9JGiXW0R3qw7fj2KrYO346R6sFDZcabLcNumBJ+Gs?=
 =?us-ascii?Q?3cHzuROdg8GLuzKCiBJ0XuTvh9c4SZ6exa92mFExs1rehiw/MSl+e9B4Q7gB?=
 =?us-ascii?Q?RUBpEPHTrcV8+nBkPcdMRnBYHyjR91S4lK2aXmZRPdIYHr+NmcD0BwUFStQC?=
 =?us-ascii?Q?I0Us36Ixbqi4LOc1DRWRg5ss1g1o8Cw4k0D4k7Vt0GMne9cbtqtKczxPILWq?=
 =?us-ascii?Q?DCsl8jxc047GKy92roeHCdM9nOHl53gXlacHQ8Fn4a3PYNzM+5JKPPYMrlk0?=
 =?us-ascii?Q?8fPKz9ZpOCpbySNF2A0Mvu4gfHCmo2xF54EnoOtojDS+tihM0Ysw5YhhAKOF?=
 =?us-ascii?Q?s+mOLTIZkoT2iwu/ml5KMFMsiMco1MfXyGlkhbi2JB2KEXRV8TcgiO8XKhMO?=
 =?us-ascii?Q?nuzGL6D0BL/xeuK2lKb7HANAU72hBrq0X0WMKS+PG7rpdmCF7dJczQtjSp4L?=
 =?us-ascii?Q?+l9mPpFsWYc+rkXjDJgFe2fIX+f0SnT5t493Dzg3V2kDrnFLIwHyFvzXaA1V?=
 =?us-ascii?Q?GeeMNihNYfLlNPUuG2jXg8uQTExWScYpXwZuux9Ez6SZ8Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b01a9747-594c-45e0-ac85-08d8dcb1d676
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 12:59:23.6736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lGkdrSQQWH9zjBopIxGMn0ZEQmlbX9ZAtgNpTGNj7Zla9UsWuYNXwae+Xmd4aw0TB5rV9gilYR4PA/UQP4g+hbfztkADYhtiQVPxIFwBB8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7237
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
