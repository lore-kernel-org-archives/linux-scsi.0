Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED0FC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 13:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC544207F9
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 13:36:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="On2ryyEH";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ll1Y8E7u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgETNgg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 09:36:36 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:5447 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgETNgg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2020 09:36:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589981798; x=1621517798;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=On2ryyEHSJZ6h7qti1HpHbvpfdeHsUCXxVD3cSuS9iOW0NAkFQwmRJqx
   zGB7x+IncIYotdJRq30gNkGJmGg36Ykb4A6dI7SSFsM+7uxNKdOvL2nem
   cHr/qdipgjo1D7oPlBwRHBjO5nAIOtfN8FSNN09F/X1KgyCCbbRF5RC5n
   FESVwoAkKyYSLFjuXVA9m6zP72Nlo3WqkSUXC9KW9oYCyuSpFrgxKH8XN
   IAfVQX0zevLtdp+eG+uuSqAb9+YzRYT4+adw1eY/q/59X9vDfybmxmAlF
   AGqkvWm0LrVf8IiJcwPqPEF8mLydwZGWh0LWOGWAhyDn/IBhQlCVR2EEf
   w==;
IronPort-SDR: JjOObmsNQuQsvCn5bPW7v5bmOnfNpUWL2uB+WQdO3wXrwjertpWq5uUhshCdgdhLqq+8FfD1+E
 9Gg6eU0x5IPntnFG00k72xynf85LY7R4UknbBwOcwMEzaIHV9G+Rq57nLm9WGXvJZGA/rNq2f6
 qaaPKzgJHz4R2eSmzxOXtM3sRTo+brISDz876HtIKJacF0b355MXu8UrtRWUUoovVcsmordeks
 8J7mGv1eI+gFB1lvtUbSEJp18o9YAmCvgnk/Hd1lW/KfGKmlxY8Wiv/pdUcIeaUwZmHFtyW5/O
 X/U=
X-IronPort-AV: E=Sophos;i="5.73,414,1583164800"; 
   d="scan'208";a="240874370"
Received: from mail-bn8nam12lp2169.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.169])
  by ob1.hgst.iphmx.com with ESMTP; 20 May 2020 21:36:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1SnXSyWgL2l7Ig8N7HToOC3yta9HJDBgYs55gXZaub/abed1nh86iZX0AZUF5076IJ/oX48gr5yLXjM8ITQcgZBodZlh6Zgg9NXl5xU1eY+q+0+RiCsxGhtTISAOavktNk2w2zATdLkUTCgTL9lHISWcyadWVl7t296KJVZZ2R2lh7NHvddO+yVReJuyVJDfFMY1kD5/5vCopBflEIezMsFAPFLJp7Igc9yMZNO2/PJnEeF3F05xkaOlol4OMZrjnKGS+97XPVl12JaV3XQRodX6VfZz0/Z3tjY0E3fsplPSI/vyohM93vcLBJy49Q1+GKVYPpWXmdhkE90ikYvGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=Usw59uIyTblt+nmk5OppOZDpIxGvzs6aT3MkhD8RgNO/raF/6xXmqPaiElS5aYXNSXTu2KPAW+F+mwNlZnpjhCX8juglcSfB3qT+dIerIMQAYCnK1chyI8taY4vmAhIo/p9a3fmT+qns2LNOJTDhokQnD9Pwl6tFZ0Z7Q0BbiQJoqXrt85cyOHNZdraTZJrSF/84Sa38tYx71BDygPX3oHjV5jms/RQfFpMYo2E+x73k9jY2ph4c1VNiq10HvcTUMCWDqrTbToJehNhBonoxACHJfhVfO59s+3PrvZItRvOQF4LudZo0YALE/Ymd47yNBBbWdgbnNPwgKGGxlauPyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=ll1Y8E7uXvu+u2SGFs6DN9T2yNcx+KiouN8V31LM1leFeAmrYXsCjCvJ1Q9dgwXHU59CnyfZ00FO4TkbHdS9qBaYHJpANprYwZfLfPm+mP4m/v6cTMW2mdFIf/8ZJjFuKkv9g3UQ31CuytCncRM13rL545UeOO5Iat6z5OsPtXw=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3517.namprd04.prod.outlook.com
 (2603:10b6:803:45::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25; Wed, 20 May
 2020 13:36:33 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::9854:2bc6:1ad2:f655]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::9854:2bc6:1ad2:f655%4]) with mapi id 15.20.3000.034; Wed, 20 May 2020
 13:36:32 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Daniel Wagner <dwagner@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Arun Easi <aeasi@marvell.com>, Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH] qla2xxx: Remove return value from qla_nvme_ls()
Thread-Topic: [PATCH] qla2xxx: Remove return value from qla_nvme_ls()
Thread-Index: AQHWLqfAihUVpM5/1kufWzvEHFzEPQ==
Date:   Wed, 20 May 2020 13:36:32 +0000
Message-ID: <SN4PR0401MB3598A0E10BA0D94F3AA00CAF9BB60@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200520130819.90625-1-dwagner@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 872a47bd-1bf8-457f-c649-08d7fcc2cf59
x-ms-traffictypediagnostic: SN4PR0401MB3517:
x-microsoft-antispam-prvs: <SN4PR0401MB3517B1AB934B7221DBFB308E9BB60@SN4PR0401MB3517.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 04097B7F7F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0LJtwhZXqwBQ75avnIjUX0/12Ria5tipjrUHEIIfWNYnplT/nMHaV5fgeR6BeyDomWU5iCIyemGduw2X+BFlAIQNNCmMqUxqKLkhI0iqlkrk5k+3fOW6vzXAuts8YTzCM+bbnTAgpSJWYRg6nJWEBrpEcP2/C81Niukvm//zFEliIOGgie062RSyOkh863Pq3sQkQ3SrzD/A7kiDJ6zqI8wEx4RJlloMbk/Rb+u1fjRsbBq4NUB1oe/5rhDlBuEbrPNBcBuTDeDKQ8kJ4jEucK6tLhdsnnw/w8di75ILllP0sukDeAO1vs+lrC/UUVFyUaNXCithAw0c2qIYD9DqnkJ3B4GjAjW6esAc45K819+BkQrfp3lgh41hEf/HEiXpc/2BvB5PKDhlc48S/enXJbJJV7+CULAaCvKB1/fwMvOXWANPqfpLOa9MoSxnV2+F
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(346002)(136003)(396003)(9686003)(8936002)(71200400001)(66556008)(86362001)(64756008)(8676002)(558084003)(186003)(66446008)(26005)(6506007)(66476007)(4326008)(478600001)(76116006)(4270600006)(2906002)(7696005)(66946007)(5660300002)(52536014)(91956017)(19618925003)(316002)(54906003)(110136005)(55016002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: WpqR9A7CBaSHgF2MmVmgZ2iZVj62KO9Fi39Sm2UHg1yU2UQ4+oohGzymreQ9B2Qw/NOqK7uEKyjtlSRiJDL20Qz2eRDSHZDPtbnxx7PITtIEn30YkA4G1mef5OdSL8nqPrDTs8ktpCCeyPB21GCa8fnldV8xQsk2hUbdaq0WZC/nK/iNxTERGLZKevh/zj83PAiihkwYF5H910J/pX2m1PcmfxBnkPlc3m6a5b+GAWK1oMl7xjqT4Rqs0l80BGKa8UZWb3kYuHLLraLLWBFO4LJkcLG2Eu5xhzsQLs4afSlD74Ktl1hLv8WiofOdNaw5Nq4UxRt5UtkmUpaMiDR1ghlKTNWfGl6dVcuMeyMVdqXZfCyEII32tnUb/0oQIE0Hpt4wqRNQMAO4xzt9wE+ogcgnFO0bkQZ3184N+PLrkVh/avQqBzKTdbstnFMpUkRmWVlEIVvkymU9oHtEpKmtLzLlWk/zvbWxj8FoNbXSn3FBHd0U3eIJK4uOBCILczrS
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 872a47bd-1bf8-457f-c649-08d7fcc2cf59
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2020 13:36:32.7567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wpV4eGxEwPXmZcTXShvNTqOIfRhCa7mAFP5f3Wq6pTYhXxeQ5/h0REdrebE9MJkigqes7CnXyMrm5VOFRF9mQyU+0PsY7h0X0MOk3MsgBFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3517
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
