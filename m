Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E21FC3DA79
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 20:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbiL2UTY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 15:19:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbiL2UTW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 15:19:22 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096F214D05
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 12:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1672345161; x=1703881161;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mwC1XLw3ca+lSKj+XxT0EEsKke6mmx/Gj9vTLaOvS/k=;
  b=BpatUqIojifgHFmVAiaP08ls/4wVFWOnuARQlvv5qNWokFfmbz5QDKxW
   ny42tiL99nyf2P3CkaOiawA1FX0kwSzPu0mLW5jDt1ILzUydCactcCAwp
   /1ph2QNtdaNHEummQ0048o6SZUhzcvjm/THM9EMsa7Uz5FshYtkpia9CP
   G+cZ/blNFGE80Em1NWkEHlcxLw26G5c6gj+8Hz0XfBRXkXcYq2sMOliu9
   M5x8D5HIWcJOeKQ1/6fuJp4l+SFA8SK4F3e363JQvaSirqfyLoTn4+ooC
   YrqIUi0mnEdGsFQf0mHm87QHK6WaYPk4R+dDcHGlmo9RJNjL26cFpXp56
   A==;
X-IronPort-AV: E=Sophos;i="5.96,285,1665417600"; 
   d="scan'208";a="219841706"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 30 Dec 2022 04:19:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/xHMoSQav6Bdk4wrflqe7o5skThhSqzoiAdbWN47+LgdwrPjCbn7T/eTlAkyiNI32H6sPeraSP/vVsWLF/LCBsGUR8M6ueDau3JE6oyONYFs8xuvTFf+vjbxRXMsV48ldq1uiL52/gdU5wMZ4sdbTUwKuBPHdslydyimCUsVLvDB4xFhr7PvMPJkvBaKsgFNoOMFYJzf2+8HxEnOXCsDdfRKqsbd6J26voIDJSisCrRTgRlL3AyV4vEIZK0wTX6cx8yUKVK8xgyAK8Lmt+Y4C3wK6OXAWg6418vespMBmrVhjplBYiI0TqrdqqDFRGvxx1jCNzvzy5PQrrWH/0OqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QIK7qJV6vnwCV0XD683oVT3imeY8am3ws5hcJ5knBVo=;
 b=OnAhWKdOFZYn0dOfcbYcUWzh0aiX1CSHCYc+qnpJyzjg+JB1HEI174urwdr5lUz+vJwK9Tf635gYlFg6ap7HNXcZ8fIAGjkxe3rXVPfc/6SBKIxAGGbGchj80FrouFJZSkBRn8kkcmRSPLZM4koUKb989EIsccYvX4KVvVPknsAqInP64I690xnDc5cukaA7i7xeHwpRHo0QTpkxqs6Q4aMIcJabA9oISmoipEjcWpNC1cL7dtn0F91mmAPGnsB4CBxXhEsY2IJSRLMzSzH/XNr7BQBHdoIL7rp8VZGTxwfbg+VwX+m61vl1Y03WxqmHNRVX/tv1jf6lX8Tj1onvcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QIK7qJV6vnwCV0XD683oVT3imeY8am3ws5hcJ5knBVo=;
 b=P8uDK6vxjWi7DOdmlVdU9WFJAwa/eXF9zaxxKMdvl9rWbMOfubJtOs7Q2dmfFxLWxh4yoc7fIwa4RDscvWpW5VKExlkY6R+oVs1En4rVKZpqPgeQPWNq1cpIiQ+Rdr8OXMO5ckk3w97RNxdYri1RQMPdT+/0UNQAtz15liOCU3I=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BYAPR04MB6053.namprd04.prod.outlook.com (2603:10b6:a03:f0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 20:19:17 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::a65a:f2ad:4c7b:3164]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::a65a:f2ad:4c7b:3164%4]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 20:19:17 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 11/25] scsi: move get_scsi_ml_byte() to scsi_priv.h
Thread-Topic: [PATCH 11/25] scsi: move get_scsi_ml_byte() to scsi_priv.h
Thread-Index: AQHZCvRnEGSJHjnZ006NN6aDgUkK0q5kq+WAgB83qACAAXTcgIAAF1MA
Date:   Thu, 29 Dec 2022 20:19:17 +0000
Message-ID: <Y632RMabE9ansMyy@x1-carbon>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
 <20221208105947.2399894-12-niklas.cassel@wdc.com>
 <598b6852-06f6-af3f-57a9-63cee9865b99@oracle.com>
 <Y6yp7G5WEWOwe+DB@x1-carbon>
 <8319d269-42b5-80ef-f103-ae9537d4f6b2@oracle.com>
In-Reply-To: <8319d269-42b5-80ef-f103-ae9537d4f6b2@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BYAPR04MB6053:EE_
x-ms-office365-filtering-correlation-id: 8ae2b8a8-0ed4-4acf-3267-08dae9d9f66b
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cEiyg/TM8JzvpFTr/CpvP50JAi3ZlwUoI/wrgyJzsR6rkIpIOwZDi0Lpqr7QdY2Li1Lgm9m7MCPxpnxmsq0zrRMbicgUuZaXSB/SIS4tXmLyJg6dwipAeCTrg9nCU6fkr4eIY/8s/eBLIGigx5WWUxHEDVAsOjLq3oSdDI+QzdvOGqaWKHDwinz95tcfjvl+6qYxKddjwqym/MgmacB5Xq+1tOVvjswU70aAegupoc3qDFFgXMWemBx+wfjqEiFfBxux73Gx80ZdUUB+cTd/LYQHfLOxxtSwkDaA1gHoKVLmtJbdjpwU9sqqB4aE+bonEWx4v690qfHrNbs96pLyzV9UxOdnT37xaDSnc1+WHd9UBdf6Gbe5oxSzsTCBzLXIQg3fWnoPAI7ErrGqsOt4SK6qBKTdbuFD2R5yVdrJdeSKGJd4x8ltfTXSG+nlV8EyyZTWREJmRBYhZ6cQufItKcH6OyvdB096wPS1Iw/LfnSa5WDPvzHCKmYrRorCgKfqmvI+PpGWsr1UtjONDkv8hnQsy6/n3G/cxvIltcKmKY9TZCst/1ErB1wK6VmW/bB+NlOCAJuju65F1LJZJ/CciYVAhG01m2YXfc9yMdKjp3AmyikX+uIZgua2LmZ3wl27Y92Sob7dbnWrDPGbol2Y/US2paJPteb0Du7x8cktwHH+MB7oWGb46iPBwRTmp0UJnhelNAELIQFUsRCoezpZ1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(136003)(346002)(376002)(396003)(366004)(451199015)(83380400001)(6486002)(71200400001)(9686003)(6512007)(26005)(478600001)(33716001)(53546011)(6506007)(38070700005)(86362001)(5660300002)(82960400001)(122000001)(4744005)(38100700002)(186003)(8936002)(66946007)(2906002)(316002)(54906003)(6916009)(66446008)(4326008)(76116006)(64756008)(8676002)(66556008)(66476007)(41300700001)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FnI/hj8Jm985lOF6cH7N/FiK05CevbXdPV/b54/hVG+8FxZqd2kBucxelmJM?=
 =?us-ascii?Q?sc/Xsv0YXnXoYoeC7sAMKlAvjo1sxHpXwKQtVSRgvY8eili1r5sebFAZ7kGA?=
 =?us-ascii?Q?8Wo54Sr2TkHCVuLNIRV14tazj4kDvRL93K03IMCa26NYzQZAMhsAd44lTCu1?=
 =?us-ascii?Q?vcCxpTpjpjMdPZro39jyGSnLP3JkPcYpIq6W716q9siTwNQUfyvj6DAUymkH?=
 =?us-ascii?Q?9Jr7xL7kctjYbPls5wJ8lTq7XfT8qC+GYq9GktVUXEPW1N3stC4lJ1QDoFQL?=
 =?us-ascii?Q?jfRc7LdSUx8UIP+CkZV8cRPBN67/udJ1EfKzj1qQkjEUR/GdNwmdziDi/y/2?=
 =?us-ascii?Q?+NcDfF+L8WS4VdqsgHunCl/0Oom8VuBbf7I4AeQC2RZz0S30N5ciddf+jzV/?=
 =?us-ascii?Q?dRqUJnTvEPRDRoEOPPL/3fZPy1Ox/InS/qobGgwrWx9BT1X2hNt3iek0iJWj?=
 =?us-ascii?Q?haIWRJeFouygNqRa8BGJ2VTgXg7CntIQVUeagx8cFXZmz3ne5MDEbk3irH2J?=
 =?us-ascii?Q?Cg8lmLWjIzf68CQA/sq/Q5amxYp12acylcjg/pWVBkTS+5yswwb6Fpu6rPyr?=
 =?us-ascii?Q?Bw8gYdrUdZt3h3ZxRa9J3KVsDlrwXDiy6s/tcfT9LAVsj7v1pSbsvRDauK1s?=
 =?us-ascii?Q?KeOvBcUzW5HZ9+BhEAacQH2i2LtbWDONk9YqXxRcn8GqC3+6E1K7rpNoDuXN?=
 =?us-ascii?Q?FHvXakvmA2Ujl7xoEktRN5YOcCla2S2P20gJg4UO2q1m/maqOYCz3nAWD6ze?=
 =?us-ascii?Q?4OlzJFKwkEKYCM9jbqKmrzSySHvL9MNkSNSslJq/znE1UFLC7fiHcNiFJGWh?=
 =?us-ascii?Q?lt1s3b7ROJQK7yFr3UHsd5SEohuFjN5trtXdX1bgoNvKBjv9jgNFEXmAWlYa?=
 =?us-ascii?Q?miPqCF1a/iJ3h6KpjegwujtuTzbzK5BJIUwXw4Pp1uTS0y+Z+y5pLojmffNm?=
 =?us-ascii?Q?7oZ6SD5fZutMLHkDVniSgh25qKKC6BsQmmzhj0KBAvaV79kIJA7XMJyxdBL7?=
 =?us-ascii?Q?ImOsLpjMvvB2VGGZr1SJcaVN8WYXAGwrACHWlHoVkPJk4vWQEwWUvng9ZEA/?=
 =?us-ascii?Q?2pIVuk+YzeN4Ztr0xnwVcxIXvSwVIzD8VDUkXTXfoHgJiDdNxgg/BYfGoP1J?=
 =?us-ascii?Q?ahwI4pmoeZ7mDu673AMRt/NvdTJ9ghK0HuTWrB8roxqW60fdinwaauMFd1dO?=
 =?us-ascii?Q?BJ32L4EM93zQ04PhDphx0jtCFuVuFz8yAX88Y89KQTok1Qxs4IhsMe/+pCO6?=
 =?us-ascii?Q?yBdIZ+19rB7P7FDp+AKmcggNFqXwQVCv0Zm4kbR2Hj6Oiieg5PT9UgBElc4I?=
 =?us-ascii?Q?4PWbwSslo7ErpDvopo5lvd3YG+v55g+vJ17Dg2FgrsIrIqOvyC9NkOdhLZdm?=
 =?us-ascii?Q?n9POSKz64dDJfF+3U9DgL6iKEfFMrqP0d/THKoXfnl6StPwh2MX6N2tqKPTN?=
 =?us-ascii?Q?L1z0P/0fb6F8SeaclJSjZ5o76+uPAsfAYxvNcgko+DmySkpbf/18sL2/7XM8?=
 =?us-ascii?Q?0CC6zZFOA0cLu/Xn8LsdOYuQPUIfTQYsPPUQbO21IyYm6tn8P5gtbWWFTczb?=
 =?us-ascii?Q?Ee1Edb+PgVL5+Vmhm0GXOKzobXFN8qC45ZJ6aDan2rBQxCJIKmstD+OEp1LU?=
 =?us-ascii?Q?8w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6C329CF3DEBAC245A91A261D5364C717@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ae2b8a8-0ed4-4acf-3267-08dae9d9f66b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Dec 2022 20:19:17.7116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WmAFMv07TYxsii+nNp4FzBt4Art5ZIKrfZRJ6pg1XJcEGrGhN6j1UV9V7cCa3se24owK8r8xT3X1XLma9rhELw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB6053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Dec 29, 2022 at 12:55:47PM -0600, Mike Christie wrote:
> On 12/28/22 2:41 PM, Niklas Cassel wrote:
> > I understand that you intentionally didn't put the ML byte getter in sc=
si.h,
> > as you intentionally didn't want a LLDD to be able to get the SCSI ML b=
yte.
> >=20
> > However, isn't the important thing that that a LLDD can't *set* the SCS=
I ML
> > byte?
> > Does it really matter if a LLDD can *get* the SCSI ML byte?
>=20
> We don't want LLDDs to get the ml byte and do something with it because I=
 think
> it's kind of just a hack to avoid parsing the result/sense multiple times=
, and
> the drivers have no need for accessing it.
>=20
> If you put it in scsi_cmnd.h they can still do:
>=20
> if (get_scsi_ml_byte(cmd))
> 	do something;
>=20
> which we don't want.
>=20

Ok, when I send a V2 of this patch, it will be identical to this patch,
with the exception that get_scsi_ml_byte() will be renamed to
scsi_ml_byte(). (Parameters will be the same.)


Kind regards,
Niklas=
