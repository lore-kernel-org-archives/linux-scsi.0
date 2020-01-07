Return-Path: <SRS0=hsTv=24=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A66DC33C99
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 08:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 508EB2077B
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 08:21:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="LNc1GFeE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgAGIVz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jan 2020 03:21:55 -0500
Received: from mail-mw2nam12on2083.outbound.protection.outlook.com ([40.107.244.83]:10069
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726485AbgAGIVy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Jan 2020 03:21:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MftLr5Q4E6e6FwDy2aMj3A2FAoLzZVLh8yeOU1c43GVBzTPFRvz6amsHu5Bsjn0L0CzVcDY3bGV31CnJ4agz5nbUG2AWj5ayNs4JxSBFFRhiQ1av/fspzmCpzWO80JckIFdorYSSDJSiLzVF/Zoeh+7WXMD9uyx4Y2YqIvbq2IMjvPZAVc36bpwMsDDVaslIP8DJz0y5KGii4q5zurMN6DLm4H/xWU4kshqy6pF6VnWWoQ0rYDssSoZ5zLDyqKN7J/6kArbxkOC0LT2SBf+CL8YMxKtg2pTo51YWcdP2YylYD4hTwGpO/nxrzPzcylgbDPNmr1JeFWuCA52VjFSSmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTDomqYrN/WvPtLGjg+YTjp+hmq3bXyMaVRmPL8Oag4=;
 b=iwBfjzJEao4UTK9KwkHirGH6Bc0loBVKCDtJyqE+LyVgOi3sMyGtn1660I3E88Y/pecutmsGeQn4vA2Ms+SayfPFnfZCyYILa6bd3LbnENc9RbHJPFGTQdnOBvpBoEiWMYp0+PS/lUuiNIr372qTrBhj2ac5ir2UK5yP3VvoenwjrwgbhM9fckwCIlH9LR3RRbUtj+aBkiv9wt/XhuvirnFzc0jPXqJIC6JbLm3ANhL3l08R+aNwty19w2qcLXPICyskNHsUVNtDXN7DPeX2sAODNANpaRoJCbmAjoRG9ZoB2C5v7wKVzftb7FidwxlQ/RY9OkH+CEmTXqtnEZdPmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTDomqYrN/WvPtLGjg+YTjp+hmq3bXyMaVRmPL8Oag4=;
 b=LNc1GFeETufYEfEmwsgnoBqcG+KPFSJiVTXLMz2ETDfN0HVYuEM/7zBlvlsWj9NmLpG7rAgrzYUaQdVqWMc1bnb2pC6iMQxBXMkjnOur2MnTTJav2RMf0Et3bfR4odL6lqpt89H8mmiT8fZ2fXCiLq8YRVaH8ES5B/PeHLzrD+I=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4161.namprd08.prod.outlook.com (52.132.222.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.10; Tue, 7 Jan 2020 08:21:49 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2602.016; Tue, 7 Jan 2020
 08:21:49 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [EXT] [PATCH v2 1/2] scsi: ufs: pass device information to
 apply_dev_quirks
Thread-Topic: [EXT] [PATCH v2 1/2] scsi: ufs: pass device information to
 apply_dev_quirks
Thread-Index: AQHVxCgTBRnpUOS0L0KUX1EO/93sDKfe3j+g
Date:   Tue, 7 Jan 2020 08:21:49 +0000
Message-ID: <BN7PR08MB5684CE7F0A63F42FD75DC956DB3F0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1578270431-9873-1-git-send-email-stanley.chu@mediatek.com>
 <1578270431-9873-2-git-send-email-stanley.chu@mediatek.com>
In-Reply-To: <1578270431-9873-2-git-send-email-stanley.chu@mediatek.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWJlNzc0NWMzLTMxMjYtMTFlYS04Yjg3LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxiZTc3NDVjNS0zMTI2LTExZWEtOGI4Ny1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjI2MCIgdD0iMTMyMjI4NTg5MDcyNDM2NzIzIiBoPSJIVmdheW94U0l0MFNHNDlOWnhYSXcxNkRtTGM9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7501044-ed05-4d17-3acc-08d7934aa4e2
x-ms-traffictypediagnostic: BN7PR08MB4161:|BN7PR08MB4161:|BN7PR08MB4161:
x-microsoft-antispam-prvs: <BN7PR08MB4161360B9094B0C45E2F0F2ADB3F0@BN7PR08MB4161.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(366004)(396003)(346002)(199004)(189003)(5660300002)(2906002)(86362001)(558084003)(8936002)(7696005)(316002)(81166006)(81156014)(52536014)(55016002)(9686003)(66946007)(55236004)(6506007)(33656002)(478600001)(76116006)(66446008)(66556008)(66476007)(64756008)(186003)(54906003)(7416002)(110136005)(71200400001)(4326008)(26005)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4161;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T2QJcEwxaXupX997mnRYsQ13prKsRh91oY9abxHX1swmbFvSItYoF3PhlBAzOBzkI5i1AXBpc8y7vpBPjuqa/54MGiLhKtSsworgggrfdyIo38UiRX8EhgHP7ym96aiQZC6XYmKXQzwhOOvdoKz/0uWmAPmF9cG45swrgsUEUmegAJxFbM510O/FGwru9edVAoHSdT3R3FCd/HLLNob7wU6fbzbQYjQfKSoOmOFcg0ljxLxMJIyyXwqyH1rvRByKR5BV4ib8Ld+GPzBrDkHD2Khp8OFa100tOjMBFYzDSoJ3xFK21bfFN0+8icXAe2o/d0wpb35qSBfRMPWTtnLYh4h4E6Sro45iwzsFBC5+ySr23sCjrvomEpQmH5kkoM8yPvMDSUtEuWekQwKmHZnp8kWdfcIVn5WgCMLOO5V1+3UdGhEkSi3J+6w+TP/5G78S
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7501044-ed05-4d17-3acc-08d7934aa4e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 08:21:49.7470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ve5N0OXz5W37k6RuGE8caKMq/+NqxzQvYdngIlNp942onjX5G3JXmHHIW7ve8WbceEC6J1MH3HuWiz3h5kiPOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4161
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
