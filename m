Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78660C433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Apr 2022 07:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238556AbiDCHfx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Apr 2022 03:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234372AbiDCHfw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Apr 2022 03:35:52 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88677340F0
        for <linux-scsi@vger.kernel.org>; Sun,  3 Apr 2022 00:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648971238; x=1680507238;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RV8T0drALquCY7CsSlzaJO+SuoLe3v24/Ch8HfeQk6s=;
  b=io9psEsUUBReuLUr2jgIi/kUPEToitoNDPIXFJud/JwoHNX2eGra3kGB
   U5ldRWaTmU0++TC1PgV02sjzow+5+QuT9SMT6S5z/KJjB2fSlirzfydir
   XuV+DnZVUv/fkcGDIx8onP+4faX0tnIJ/jl1XoAQ4aIAmPOtxcBy/RzlP
   JDYnL8LbNch8bZm6rFru+TrGHKCHoeyrlm853GUhwQ1JYokOxsgjHMKo9
   XEvPR+ZdA2BJ1jxOxCgS1EFqS/yPaM9OZm4VQg5Ezg8kcFtCihV8rGllq
   qNbmxtyjQiXc1nJb2EiuBLjPMqTNhOgAkbbX0g3r952VZL0u7Xxhgtyfl
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,231,1643644800"; 
   d="scan'208";a="308905728"
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
  by ob1.hgst.iphmx.com with ESMTP; 03 Apr 2022 15:33:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S49K7YG0NKjUtBzUMZYjL/9b8NX5uGBlFElhmQAo9SUzm6hxZYtmd5fhkBdzONNMZFFDUznk3Qga5FK5rm9lhAbESEBYp0DtyZxeENhek0lSz72UlRxCU2VZw81oFMMG8vlV6YwgOF1ugBvOhjEEw2Sq25d9P1bNq5G+RakKxE1TMLg7YwDhNkCeVyDuUO7dqUMP7TpvV466Le6QUwH5CIe4hwo8L60pOHClb8tpatCSgVBFcSg03blk9k2Og0eYItUVcCmOXsEIO7HmOUCktjOqvcErA7YNRdRZXHk6CU5Ay8A9TrzMuLc7b5Ipao5pt7OrLKRWEmfkCry5HOpbIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RV8T0drALquCY7CsSlzaJO+SuoLe3v24/Ch8HfeQk6s=;
 b=MiR6BLTLNyGNrE56g9ZToDkyl4TXhLICaGqAAsIQmUjBSDdPLicE9dyL+jveVHdrff4T6ryIguSIOXk90gmIMpXtCs64pbtr4t3qHEhUSG9nNBpO6XcEaznJcHsPeNPO0YPjTSBblyLs7hjEJBdoxMaTLYirhLvVYEDGVOc/PnmowPr5xFnMrLVprPkqKOgmdRVs4dXR1TCY8c9ebyarFMY4c9KsBnY/8XnkqpzlxDJnPh46XzGvkOUlN8N8RyjYYBbrYjH82a4vvp4LjdEzsrsqiqcAG7hwpuQdIMhXbrAy/LvNkwy8a9Rq6dDRrmtryi2t7EyTe+R/bersmuKF6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RV8T0drALquCY7CsSlzaJO+SuoLe3v24/Ch8HfeQk6s=;
 b=QjPsTjUYMVF+mLpALoBeGj/Nqy843Fw0Gs45XcIHHKH8hiuqqxSgRgecGlLDI3AG4pn4OlMt3LcLqRwzv6XvR+M7VK83QVQVCF5ZS6w5Ql5jfawoZexvdm1l2QgdBg+e400yU4bR2d9MKv27dy/MxQd3eHGHVvEcG/tBy01d+18=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5785.namprd04.prod.outlook.com (2603:10b6:5:161::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.30; Sun, 3 Apr 2022 07:33:54 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.031; Sun, 3 Apr 2022
 07:33:54 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Peter Wang <peter.wang@mediatek.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 18/29] scsi: ufs: Remove paths from source code comments
Thread-Topic: [PATCH 18/29] scsi: ufs: Remove paths from source code comments
Thread-Index: AQHYRU/rp0VCD3JIRkaBItqajwWOF6zdz1XQ
Date:   Sun, 3 Apr 2022 07:33:54 +0000
Message-ID: <DM6PR04MB65750E21407F54C7FD00C276FCE29@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-19-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-19-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd00411b-b811-48e3-6ac6-08da15444e61
x-ms-traffictypediagnostic: DM6PR04MB5785:EE_
x-microsoft-antispam-prvs: <DM6PR04MB5785DD91B22BD92424B567B1FCE29@DM6PR04MB5785.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F/Pqm1z16sA7aAMV3pZ3M5uJz3VRs6Ze4MvtQ24KcpWT5f4o7hy20jCJF+vhC7VWJ3oA6dNtZhAy2/tow4pQ/a8IoOE7PjANxpwdqyFplpq83+vWCGOOGpLl4wjK0uUZo0AM+BAG0Tw+LVtjmRaEYOCFYpJ/3L5uHvCXwgAvmhTUGzPF0KAvEJLRw6snsLxsifpieg1CJLrUDLf53NsGuSZCgFOkPy2PsM98kBTH5hWjJOffOHoYlTqRdZvp4PUPkBxACXKb9JnngKKHUSKw4dME2VSwRqnGafNUYYoAhXJzNZB+rBSdWZmu1twJ/6SUOKw1HJ+w4A58spWW8mede5R/JojiQaxItLYfOgQ7aN8XkkCdogZZK2hiIvlokBbepKiyBBdqrGJtYSEgRNvszpGUG+AikXMnEoa80n7unUZ13dkyftMLpgKni0Rx927JMgJhLNTfT+NFY7HPat/+MybvyuNzm0yud/mm4KqVT1d6U6K8eZCH09IVv9dkf56Gmwr2DT+sHtgSv32OrEPV73IA6MMalJwxmQ9vY/Pd7aULSC5nPNf11dGcSJ/mY3lh3Nd8f4zRoTsXsYV1UvckZgyclXOumqg3/HWIEZSxg3vAiNGLw5DIx4ngmuRWvAP9+/+oMksaqOwdtAQL+9la6BvSb9WKs3+t/447zCnq3MmsuGJHaber39dC68O03Blmi6Ko7JPDV8XnR9g7wWq3hg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(316002)(64756008)(66446008)(26005)(110136005)(38070700005)(186003)(38100700002)(66946007)(66476007)(9686003)(76116006)(558084003)(71200400001)(54906003)(508600001)(33656002)(86362001)(7416002)(8936002)(5660300002)(52536014)(2906002)(55016003)(6506007)(8676002)(82960400001)(7696005)(122000001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hP6J20uu/WVz83m/FWumzfVQRIt7I3L2vMZoM/LrD3ye6aXXcFGz95zxLOwQ?=
 =?us-ascii?Q?qahGi5y6SQ+C8uEm1HvUawfPD2B/7FR9e/ZJHY7cPXRiNR4Nt0GEbRV4Vdud?=
 =?us-ascii?Q?BCxPcRSY0iH34oGDxxpyQcXvwqvpKoE+jyLYi+jW1uCxb6DGI23icsk9jQyX?=
 =?us-ascii?Q?QDNiPFstEr4amyVYzuSiVJOjVqTD302LfcuOgyCNnfCeqyofxVsgxWBwrqYH?=
 =?us-ascii?Q?3URDjujQiE9Ysb+SihX9LWUioPQW+kz24gxSbIetbuDjoezEo4OLZS+a8qOl?=
 =?us-ascii?Q?DYM+dTF/SfsyvjS0HhIFuKwr4n48weaVQW9td2ZElHmEWtjnXPuMwl31llGj?=
 =?us-ascii?Q?+hFzztnNjzm27pbdInak4sEu+Cix1UyX4ZGoC2NdIS/3sXf6/YuB10d8guUo?=
 =?us-ascii?Q?QQMtynmFYkex79gjHLneGwlFY01jKU2dyaO9XbmmFGUo7kfiNrBfHTwS0QHQ?=
 =?us-ascii?Q?I1YTVikFFUmIzYP/jnkHJ3+l2UTQpUiRXRfykLwc1Jbst6zZvJvOdvla35OW?=
 =?us-ascii?Q?fW6un/D462BVV3eYGKcIm/Mg7iYoia/oOgIZ4mb2Zc+9xw+vpe90Ks9wvEZ+?=
 =?us-ascii?Q?o92Gr5tFtLKiJ9K+CfwWgPeXaJBZ4jOjupfAWlnZLZWfsW5rmhj7or4X1DOV?=
 =?us-ascii?Q?NdFx/CLCXxU6J7VRbDdHKnuUlpgwq6iY5hCo4TULeqtCN5lv+tJX2X2bqake?=
 =?us-ascii?Q?cjJdws9GJYORjIOnircjlJHjwDTWxZtg7PSzZtRhfCqzKYYpvXYhtvc4/+6R?=
 =?us-ascii?Q?lP80pwX9Ubi8go1YoPh8bywljLTni2OpM89F/SEjfjX+JJCHCS/ERg5BWluE?=
 =?us-ascii?Q?EwYd4FKQUfMA9FRqcQPVu5GlhjthLcLu4ZxwMaNtKEUpXe0t97wkeMqvKR0r?=
 =?us-ascii?Q?LHEqLKNtYYxYdcUd0i+cLmx+f10R1pwVWmFTDPW5B67Gphw4WvIchaOqTEVM?=
 =?us-ascii?Q?qnOFu7JzzCRs7BgAXqcWwVs0HmMg/98a3oM/3G0bv47+U/yhmY2puN3zlQet?=
 =?us-ascii?Q?/OgSBc1IYk9lr1SFdB9TnurJHmffNQHdPyrd2aNwD5CZDlnmNDi56GkvcynO?=
 =?us-ascii?Q?BCFxutYF9+WRw6SuEW6VKlubbZc9GaWGD7pqyrfirOZcgKPUj+CdCeFv1xrF?=
 =?us-ascii?Q?DwizQMOSCTDltsVyxmp3Q31pYej1NizdlpIXyX6Y9mKHyB4Hwlo6QzrZ03R/?=
 =?us-ascii?Q?fuRC3+hXHkuxjgEzPpjQ72z73W3ySmyqO7kwS1YitRZa5szlc8G3EAXHwAh7?=
 =?us-ascii?Q?Rt/ifXQwg2Qd+lAYPmdfFosbm/fH6RRD/3+AiTzXQQoFiZNFg6u1SClsgs6P?=
 =?us-ascii?Q?6TExhtePTlwNcxax/NU8vaRHTO8pLHS85GlrJFBw7ghftwxUMgnTdVjbA78o?=
 =?us-ascii?Q?p19Ovfkv+WStn7iyX2S1QYLqUux7Ej3tCLvUkyrObKwEPicooBrrfG9xrab4?=
 =?us-ascii?Q?eckBrMEc+o3mM8SJ56H0Qzxif6SVpsg9GN5vJz5WYfB90e3bjjEhIa3zlIoG?=
 =?us-ascii?Q?IQqp5oFgkj+AVunfoCrcOAKEjtqyHnqky+0SzafryCXRMO1EORKz87neTAs7?=
 =?us-ascii?Q?Eo6mjqhxE8v97MKuS/eAdGLJFC4/ztKstRQi7P4ZsPcqwGR398e5btUtjmXA?=
 =?us-ascii?Q?4DmioSTi/w6jjjePTaFqamBLkDhbbmj/NWjgxmKmsrtiKvyntoFQtALq9pZh?=
 =?us-ascii?Q?/CUfDc1j+pf3K5Sww0/9Iukkjt0KbXcO40nZIunATsMgKnEtSDqbG+Qjbv7e?=
 =?us-ascii?Q?s4/egbB1wQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd00411b-b811-48e3-6ac6-08da15444e61
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2022 07:33:54.1918
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W1UmebW09lT6OHh3r8CXd7tN5Ymzip6Glo4FsQDw59RyRgHl5M5HO0l1P3lqaWhk68F30EeH5ZiS+yvwhBsnyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5785
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Since specifying the path in a source file is redundant, remove the paths=
 from
> source code comments.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
