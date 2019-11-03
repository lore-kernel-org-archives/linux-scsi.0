Return-Path: <SRS0=nNaJ=Y3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A0FCA9ED0
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Nov 2019 21:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA66321A4A
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Nov 2019 21:16:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="Q5gxXNDk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbfKCVQq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Nov 2019 16:16:46 -0500
Received: from mail-eopbgr750041.outbound.protection.outlook.com ([40.107.75.41]:24134
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726502AbfKCVQp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 3 Nov 2019 16:16:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lo0jtouvNL08Swg43uFPPSyic3l3i5u9dB9TtCb3KQd7JbAt4NIJ5I/Qo2hnI34e1gjACJ5A5ih1FWsYMUt50bWUIc5UnZvV5kswQvbAvmoqPZsHN6QXCdA+AENKnqUqQBi4NZkQkEMIZgjJ2mx2An5wYLtrtq9AtfrMsFb0TDySVkpFklgt+7tI/J07J62ZH8Qo6MFblAG1oVjOsow0Gorfy8XwKRXZ48vM6RkYtmFuFZR0ryOxIVbko5er4CgBC9qYWMHuMqANfLRIfZ/vtGtt5JEAbnypEqpSYessU2mUGlOHBqXJ8B9nyew1XLwV/rAPP3rcvZYJ32X9COR3ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DbYlxaoipZm/RgSHS9xtFg0oAYDlgSdbZDtG7zfbNIw=;
 b=P2x2wA0wecX7gzBZ/pw7xx7bjD8fpjjqgZLOewRtjMveBoeIA//ReLeKi5Goxrn6jSOg7mtx8ux+PRUna1fV8ZBqqstz8Fp/qIvcaZ4sWWoWtYIVaVfAbr6vmXvZWCSsveSVE7f1GMce5ResiRaxGrm0ueB2IdOtmy/7A5fOqhCTxeGNAtT0xne3sAxCzke5Ei32PlKrLUqInbg8w8JGfi7CFnBwlzJxorsprq+fMrNNksVy97Z0mPW4Wncbhi9zCQiDbcg7i8V+TS1fsIOJ2MCAJTlx82nkJje0vl/yvIr0D/MQMPJiQNVW+sKP7ie5sUrf63U3s1OjIhhnCj85UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DbYlxaoipZm/RgSHS9xtFg0oAYDlgSdbZDtG7zfbNIw=;
 b=Q5gxXNDkhuEP21PGR4LoABQ+5X84GpDWB/RgInzrKEc6JN+qTSt/Bb3WaNjKU9uD35ursQQciGVji9HRn1TJU3Er9t99pwc+WPspw6Nm542h0V2TMSyzELfSRzGp5ysLNdQxkppXCvWA0R6cQNe/26O3ncCKhCPXU26MgubSVD8=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4051.namprd08.prod.outlook.com (52.132.216.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Sun, 3 Nov 2019 21:16:43 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2408.024; Sun, 3 Nov 2019
 21:16:42 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v3 1/5] scsi: Adjust DBD setting in mode sense for
 caching mode page per LLD
Thread-Topic: [EXT] [PATCH v3 1/5] scsi: Adjust DBD setting in mode sense for
 caching mode page per LLD
Thread-Index: AQHVkTqkSoxGAaqBckaMW9KrVMJbHqd58LlQ
Date:   Sun, 3 Nov 2019 21:16:42 +0000
Message-ID: <BN7PR08MB5684F5BD90CB3FC3FE5AB032DB7C0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1572670898-750-1-git-send-email-cang@codeaurora.org>
 <1572670898-750-2-git-send-email-cang@codeaurora.org>
In-Reply-To: <1572670898-750-2-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTM5ODAzNDkzLWZlN2YtMTFlOS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFwzOTgwMzQ5NC1mZTdmLTExZTktOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjIyMSIgdD0iMTMyMTcyODk0MDAwODI3ODQ2IiBoPSJuREtTRHVZZ0NCWEx1dGh1bi9jTGNOY2ZUdW89IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.80.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31c03b9f-5b02-4f91-0eb8-08d760a31fb1
x-ms-traffictypediagnostic: BN7PR08MB4051:|BN7PR08MB4051:|BN7PR08MB4051:
x-microsoft-antispam-prvs: <BN7PR08MB4051CAF926DE2639E72B1525DB7C0@BN7PR08MB4051.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 0210479ED8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(189003)(199004)(2906002)(55016002)(110136005)(186003)(54906003)(102836004)(6246003)(81166006)(55236004)(256004)(25786009)(6436002)(7416002)(316002)(6506007)(7696005)(66556008)(7736002)(558084003)(76176011)(66476007)(64756008)(71190400001)(305945005)(8936002)(71200400001)(66446008)(76116006)(66946007)(6116002)(3846002)(81156014)(8676002)(99286004)(4326008)(446003)(11346002)(86362001)(14454004)(66066001)(478600001)(26005)(2501003)(74316002)(476003)(486006)(5660300002)(52536014)(33656002)(9686003)(229853002)(2201001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4051;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U+vjyec17WdbzQUAdBDV09et/wVZfwzEZHE+fYzvDBFW+bneqqVOJpzXLj5BAdwthOrClFE6PZDP1hssHVv5rNAW9syuwkD28KXDDvbrF/8kQbLissQdYYKAZER6yLveO6X3cj5tUMp0zmr6wMg+L+Fk08Wh4hzpX0PQCDraoFZ3DTeFYELbjRogg6FgK3BeOW4hsXMJ1U6EQQOqtiZsyxiL/SfJafH/dPzCfHm/ITncEJYNMnbcwnhnGIQAjj0CMlG2+EXkBUMBvapl9KdQKFiwAoAaJ1NvH63QiWjTNtZUk718FlnH60V13/mlN49WFocus9TaAIuAauJovVDf1weWXWSUaIb8PoJR1lswahLNcDsUMXTTlTVgwF1KTNQEemTS2AX0PePGTOo0ba4SBZdrn5vktKflisqEAIUIgIRFt1JtPWA1uT5XeNak+kpJ
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31c03b9f-5b02-4f91-0eb8-08d760a31fb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2019 21:16:42.1309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: js/7eavpYRuPifzef5suNo/qp3uno0J1UMRsEMtcHM/2IP3Wjgg4ZPL6uuKSecgKwbOuvtMtDmxnuRwAGAFjNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4051
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>

