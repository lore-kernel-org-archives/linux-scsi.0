Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A3B5C63777
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 07:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B591820B80
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 07:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388206AbgLCH2j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 02:28:39 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:39916 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388202AbgLCH2i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 02:28:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1606980517; x=1638516517;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xns4Y9pHSsoPS1zlMGhe8Kd07vxUDPf2MdOfyN/HrVQ=;
  b=OD4PZqzdUPIjUmho3LKGbiUWVQ4h/gCPGM4Oy+JYm5a3pHhX4MKdvNlq
   4Ib+vaQvcq8lr7zuQ4DNJ/Rrptuh98Rv6ur6FLeSH7zhoMh7jdhJMW2gp
   qMWf+jPdh3usKS+H5/yWlqIfmVku21aRvsnAM+0mAOS+atangALLYA0/k
   sxtbHGOM7ZcPmQqg/kuWqPJRFAiDkFG/mbkHFJvx6kfVHlF09RC6oiskN
   pMPYkfS7e7OlW1lqs0ldqkiwz/4QnL261ktP1nHsgo9I3EtkLEjX4bFRc
   A5G9CCZyxlQ6QTE5lnJCGH3Nhg5h7xUky9en2i3mcdNID/v9mMxqxm4eI
   g==;
IronPort-SDR: lzEJgRdXxaU4aFViYLSgbqSfRMyi/DcqpbB5vSreNJrnALSmHPGw1+bHCTCojsmFuptdOKEzNL
 g5wL6xxuY488Qbt+2QXNE33HR50C0H05WGg98x7EpCkrH/QLFHjT+KvDJAlPOmksJe8DG5/+t+
 ujMfLEs44cdbTi+otexMhtjd/Dm1p8Yicm5oEo2ANgvAcQuaKq50MKMOeWdx1tebI81cCXt6vy
 nB4l9D6OTcm6we08YSCQXw10tXWv0W5VfyJrow/lONd5xe5mBO+pzannZtMgRkFDaTHaP4pTGE
 KlA=
X-IronPort-AV: E=Sophos;i="5.78,388,1599494400"; 
   d="scan'208";a="154181850"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 03 Dec 2020 15:27:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ipkiK5xKwePG3IErYNGla0ywYP7dDYa9f1mcyFStHU98iQPw7ymT8cAZZB55wOTHUrFYYtJn8AtkGrgB1wc3iBsnJPg2RtdsrA/9g5Ob2swptNJ6sOUb6rcmqnCXVUCv8sOBXixHJHhPq30sbUEBKoDjY0MyBapxcsBvj/JVJmPuLZD9KHYtd8BGuYB4OEyeUg5/eiCFNJJQBzLAuSQyIYfuDD6YyytKco/fqviBWEeIyuMhCaqaBWUEujjYi5UzMpKBs6WwwJG1XnhpgPU4wOvm1bodLkKHzB8Ge3QFoo1mdbicPoOQay9maRMOEZ3T6WChqW7Zuq5KCGprzIJPkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xns4Y9pHSsoPS1zlMGhe8Kd07vxUDPf2MdOfyN/HrVQ=;
 b=ob6YxjizqkrdlVwA90zM8CqnSSNVUgJk2VorAyWxPlVcQ5kJgGINvfan4qKbbJiB98yS7WDJv4Qq5ln0sEu9aNnjw1gf79ASCuP0E4IVUxsRiwZFJtDJloHBFy3Xgz4j7x5Xy+xtw9K/yvgiY86p3i4wK66b4eF3yPiVXQ16v6oyGTnuGAlaY65EjU0dHbDJdI8OLVXfzkjm6Uv285K2KGBvoPplMJd+uY4I7dUng+joCPjG54MbbfYq2VOeScD3iQDMU3+BNJM8W2OG+y7Mo8zSNUxXZgcDmHfqt6MVoRZiPmXIyc6MeZxGUp+dA+mge6zJlpAsrEUQKz/3uAohEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xns4Y9pHSsoPS1zlMGhe8Kd07vxUDPf2MdOfyN/HrVQ=;
 b=kuIONMoBukAKIAL1hp4o+OJL2lGuz4927uWECdcmnCPRt8KbxkGXedYS6GQogRoM6EhOBc2Q62wA20RU19tu7GWFGa8gdFwdbv+z+kBOvYdIsv86OCAS9SCnWsx9uXXSTnjByZXRG98DiyIvSxlQB7cSe7O3i3sDvQ4Cecug7us=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4025.namprd04.prod.outlook.com (2603:10b6:5:b0::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.21; Thu, 3 Dec 2020 07:27:28 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3632.019; Thu, 3 Dec 2020
 07:27:28 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] scsi: ufs: Keep device power on only
 fWriteBoosterBufferFlushDuringHibernate == 1
Thread-Topic: [PATCH 2/3] scsi: ufs: Keep device power on only
 fWriteBoosterBufferFlushDuringHibernate == 1
Thread-Index: AQHWx0S43WodiAJh60uyT+kBS7g50qnkYW5wgACaOBA=
Date:   Thu, 3 Dec 2020 07:27:28 +0000
Message-ID: <DM6PR04MB6575B7ECCEA7335B2CFC2AC4FCF20@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201130181143.5739-1-huobean@gmail.com>
 <20201130181143.5739-3-huobean@gmail.com>
 <BY5PR04MB6599826730BD3FB0E547E60587F30@BY5PR04MB6599.namprd04.prod.outlook.com>
In-Reply-To: <BY5PR04MB6599826730BD3FB0E547E60587F30@BY5PR04MB6599.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ca50db9a-901a-432d-8981-08d8975ce3af
x-ms-traffictypediagnostic: DM6PR04MB4025:
x-microsoft-antispam-prvs: <DM6PR04MB402551A979D2C0D582F17BFFFCF20@DM6PR04MB4025.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xWgpa9mT6qTJnX3mYjyk1RGGNzUKV94vb7H268F+AvhCuPylJZGP1sdCXFjZcLgmTtw6TDl0o5UByNu5wucGgc+K+qWy1NK+1R3X/yYtemM0vWuQtLPRxuFVpP0+FTEcAwHJ4CDlai5Cn4S8UjddEqPgMJNpl9nqx0qQUwXhTDoHlCaQrxSJ6xpEbegRGEJ8J4UX1pwTsSJ/KW+Wlv2N/eiiNv947asnWUFn91v54t3XAhTKZ68fHa8LXYH0IAEHLQXPeL8Rqma/4meMlQ20QAt0EG5BIKhqxJi8ce6Y9ovBwhTpVI45DbepoITIiVZlBPKMGKzOjNy9Uh9CIDUopEVGAPsACJG+3J7adxoZWvMABmg1dUcfrDk3ha8jhQZRl56aazFMXc8Y2fQqPzsfzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(346002)(136003)(366004)(66946007)(66556008)(54906003)(66476007)(55016002)(76116006)(9686003)(2906002)(316002)(71200400001)(86362001)(8676002)(110136005)(4326008)(8936002)(33656002)(5660300002)(64756008)(186003)(66446008)(7696005)(26005)(7416002)(52536014)(4744005)(6506007)(478600001)(145543001)(213903007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?HFa5gNuAlW0w36gWWTwq+ie7Dh1CwGJYLUZL+bH+MAYZodRmkEJ6IHVtXeGb?=
 =?us-ascii?Q?qEHHKevSCszkrtaaoJAB5L3X0wXnRY3fUcghrG+9yUOVKuiO+mU0V09qhwgb?=
 =?us-ascii?Q?sNHtwXgjTGswmo/0kgBzN+DRbEQsRubN2Lbo0GpApT/rDCCeqn9EelNY5i1J?=
 =?us-ascii?Q?/Z9Lt6y7Z06sepHrmKQD/nOP8aBaP05MU6E1hZUneg0lMZMiPyDTlxrqIB0S?=
 =?us-ascii?Q?6npweYVnPAYtzpSItCqxZiWQDhpqIVBiQ5B431iuHe9fXXfZQz71A5p6VFrs?=
 =?us-ascii?Q?c1dTzGzByxbYUUua4uTjxEQc8vAyB6SyzqFa8ucrXUcYcNkuQkZ5erzeymEY?=
 =?us-ascii?Q?72JqIYJUKyzwe02p5QZanX6UFNvARSjy6poiBbAiiw8TSGAj5QsGgR3DtVTe?=
 =?us-ascii?Q?HIGda+IkVQPCS6XLmXt/LV0sgqUO4BLqzWWrurNXA0NHXXy0WKumlKmImawo?=
 =?us-ascii?Q?qTbIBnCSDF1pC0a532FdTo8Vt7uWvZYtWVJGOpaU1D0/5jqUbNcXauX0Asvs?=
 =?us-ascii?Q?A9ZV17NKxKo3vOlOYNWQexGAtbOKiYEwF315RWgPlMiudOS6TBBpgSb8ZtkU?=
 =?us-ascii?Q?CUSHrxfdqCrg7fxLztq/DQNU9vZYzun0H5OYf+D3fkDreI+RVhyXCEQhpMEt?=
 =?us-ascii?Q?Mm3g/OgwxuQWqUCegvmqROU3cnJQ1I01TxLWCl3KWnivCbRzWy2pjnLVsBXT?=
 =?us-ascii?Q?vWfsQvvZdsEwW+Xr9wE8Sx6ixKQCVFUZILukcB58opsp1WgBS7BpTuoHmiqk?=
 =?us-ascii?Q?Q4t6JyI8GS8UwbwriPXYiFLZb9/ZSvT2CAHaZ39ezwe/1KDyNCa0U0MT+ZoN?=
 =?us-ascii?Q?tgauwXHB5Zy/jw85rVoLrsw6Zb1b+UX4frO4OR3YknNr0WX92i9HnwrKJQCM?=
 =?us-ascii?Q?DuYTd79FdeJ2VN+8kKo9EEb/z8hvETkCrVY75ifdTpdxZVYRxSJfRg88rw9Q?=
 =?us-ascii?Q?isJSTyrhDaoB8mI8G0iFMwV5GoZip1D30oQXZMYHHCU=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca50db9a-901a-432d-8981-08d8975ce3af
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 07:27:28.5075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fLvHSglSlBUf3TUlc5XiPzJNY8a4elRp0TaoDQ/6I1ruxNxvzBMZ2Hi3AQufBZhpSWAnNI7RpItEKjc5gI0Cpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> Keep device power mode as active power mode and VCC supply only if
> fWriteBoosterBufferFlushDuringHibernate setting 1 is successful.
Why would it fail?
Since UFSHCD_CAP_WB_EN is toggled off on ufshcd_wb_probe If the device does=
n't support wb,
The check ufshcd_is_wb_allowed should suffice, isn't it?

Thanks,
Avri
