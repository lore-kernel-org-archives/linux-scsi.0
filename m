Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A190DC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Dec 2022 20:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiL1Ul1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Dec 2022 15:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiL1UlZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Dec 2022 15:41:25 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8EC10C2
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2022 12:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1672260084; x=1703796084;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=evRAtayQgeC02bC/KMf3QIOSETHo/LafMwoDQTTgj+U=;
  b=mFGbOQZ67JjxI8tlUQq+oXsyVHj1YGHGzzxP8VCJDG6RmFQd9PgilV3L
   ebujk2mCTxhCa4XEm/xmH7K6LmEiiC3r6xUdDOXDlVuTHSqh3cRCtBYPj
   qOAS20swLErlGtVO1D3bAwLkIBPkdO/hQC8zadRF2y8MS7jQl2IqIYDdS
   X79yUhl1VXyXud1melRN0n60gfINKnGl8cJCpAw6r1RXlSSS8RAB0XG8u
   P+Gk88HdDpL2vXwZvpN0ePiIvN5539+7gN6TR0Nv74/qhyPJ5fkbfw29m
   XCxXzURwEccbNYNEdAbxxd48zSc6tkovazFOjOOutXo626olF9m9zgrAj
   w==;
X-IronPort-AV: E=Sophos;i="5.96,281,1665417600"; 
   d="scan'208";a="224719891"
Received: from mail-dm6nam12lp2170.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.170])
  by ob1.hgst.iphmx.com with ESMTP; 29 Dec 2022 04:41:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNxs34n1jq6Vp8NW4qh0bJwUo9nLZIQP66D/VktMoRtfMsAjPSPX+i9is40cVwSsBygCLdslgWNq05wlXT7owxhOmF75EkTPyAAzYzSZnbF9Lv1tUJS1uk+JmYIn/3EVJA/kWJ7lF3sAGfq4tvtBHTpKIgD+Qx8MkHPBcIFXItthF/A5L504EWBLXp52afhjkhlskY5utGs2XTzib+TrZHBICjPgBCnggWAzNqFDwCqdJvb8nWrDI8w7ht9NSU/0Q1JFEVYZgQiIM7eEk0hkXuoykbl0aYaAKEKN2jvfU69J+gBUUEwuZy4jJyyseJhkFRtxz3PaIdOw6YwOOdtdFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9HL2z6uB6Ljqd9QH/VxnAWvGgC3Gm4HLVdB9b2Q8U6Q=;
 b=eBI/wtpwtWpIGxImgB40/Bro7TMLB97B5zgKcsQukjp8Uw6jakior5xXVd7GPL2s85kdgf0/WVqIpifVoWbVT6oswl0MfVBWKL2bJC1o5w6GwvFNcnsM4u8SIZho1xuJNBOT4XFFI30o27tyKOPjXe4tMCwH+IRs4i/YwtlTDUr0aRBhCWhGC0xgsjutcwfzW22IOZBTv0fTAeTkZNWfqlVN0b2fLO4K+9Zsff6lkdEr5vE/SeIVV9Q52AdBMxjE4ICbu86hfmut/763xEk4iUR6k9Eg+EbsY+6iQ47Hx40d+e76I/1CKnYv6X+k/mIW1ww9045/Cb1VHsjlKdR+Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9HL2z6uB6Ljqd9QH/VxnAWvGgC3Gm4HLVdB9b2Q8U6Q=;
 b=cTmf/wgae7RQUtGKQpabGpArcEIFvS48DQQdj43cL8JYqc8VFj8UKOo0A+TfsIeXU70DSN2JbhLtJW7f4nWSm8WXaenAwUVNsLL33lpcn3l6WGVxGYCOLkroTjVORbntPei3V63VhhyiDGHwZhF0eh54G9Dp7/aisIS1eQJnRT4=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BYAPR04MB5095.namprd04.prod.outlook.com (2603:10b6:a03:4f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Wed, 28 Dec
 2022 20:41:17 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::a65a:f2ad:4c7b:3164]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::a65a:f2ad:4c7b:3164%4]) with mapi id 15.20.5944.016; Wed, 28 Dec 2022
 20:41:17 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 11/25] scsi: move get_scsi_ml_byte() to scsi_priv.h
Thread-Topic: [PATCH 11/25] scsi: move get_scsi_ml_byte() to scsi_priv.h
Thread-Index: AQHZCvRnEGSJHjnZ006NN6aDgUkK0q5kq+WAgB83qAA=
Date:   Wed, 28 Dec 2022 20:41:17 +0000
Message-ID: <Y6yp7G5WEWOwe+DB@x1-carbon>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
 <20221208105947.2399894-12-niklas.cassel@wdc.com>
 <598b6852-06f6-af3f-57a9-63cee9865b99@oracle.com>
In-Reply-To: <598b6852-06f6-af3f-57a9-63cee9865b99@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BYAPR04MB5095:EE_
x-ms-office365-filtering-correlation-id: 987b98c7-c1f7-4a39-1cc5-08dae913debf
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /XX9geFjxkdr+El7BFWaMYxCfc4u6bjAMbgtA23Dy+lEpEzOKPAl/YzFMh8xraLDjqh6JIIkCMrRNDb6o5Pb2zBmoKDvzKipuCW4Fun2iZO3jQm5Ah2PCETSQfzrXeAHJf/rDtJYYL0G7NenIj/syd4Q6LuHfG7IQqwEUrnxonqdMDf/Ih9472jdfIXmnyZg8YYyiK60RSmQS883U/K2Lusc2KSjAz41xGC5EVbiMWq2oQyVf5hgia5kaaMtRRTRhhPKYJ9trWN3XUOgEe+M2j/dcQXEzbLkRfBeK2PfQrX2SLjDtSfUTEGTkGGqBmWYgrb3FjfTXWmPKwx8ovulAmO3nG/dXvRNbPCRd373/GzIYIE+lDMmu95/jv1aX9TVJVDW2gchcKwvkEQjM0Nm6S+aBjpmMaQpH0lbtMXclvaaxDoaoVndod6J5Ne8HtNMoDEMxsYC5nfvFIyNmF4TbshYrBe5LxCvdIyZ1FxPSjTVqup7URKWl+ktq1aMnrgtXVn0FZUzL082ncsN++oyQB8Xbv/mC7bfIX4WDHxa6/3yLig+30Lj0ihDtL4ilWYg87a1wr7uaiClu0OW/gVE//ZPcwYT8L+hoTADbsjH6nYzK+x0uiiHIiMXGlgxoyuJTvePtSPLZXp5i/4B5xh+wGDo5TyjYF3EeA6Uvu/AtUCZr3b6XEfYN5OfByonS8EaEQI7UIkIWS8z1pj9WlKzHPMje4MN5HFi/yjiQymyiZ4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(39860400002)(376002)(366004)(346002)(396003)(136003)(451199015)(86362001)(316002)(6916009)(2906002)(38100700002)(9686003)(186003)(53546011)(6506007)(6512007)(26005)(6486002)(478600001)(71200400001)(41300700001)(122000001)(54906003)(33716001)(8676002)(64756008)(4326008)(83380400001)(8936002)(66446008)(66476007)(76116006)(66556008)(66946007)(91956017)(5660300002)(82960400001)(38070700005)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hQj/UkB+/5eeHpZKrFJuYhM/8PksoztYNGM3hCZ8dCLIjWVYPxKwSZbZe3c3?=
 =?us-ascii?Q?d8dHTV6USBVf7VjBU5JTqyKGX9WUdQeFI4BnPcYuLkswBg/NCV/4mNtltx93?=
 =?us-ascii?Q?v69JCZiST670/nxaxX6XXxBwoRUOxJCZnEwUufLSHwzLy3k0Wsmbj3+aJFdh?=
 =?us-ascii?Q?5K6mZXy+tJZbvTy0uF1fsE0SGL7tizHh3UY3gYkbfQLVyWhHaSC7Q993TFUc?=
 =?us-ascii?Q?pHlbJEKA8gv13pQRUyXkqt6smFlSRqEQ2pPfHaTtieiWXlQTH9nwQ57OaSKR?=
 =?us-ascii?Q?xwrRDbXeRmBkHAwsokOHEm4z8B7cMnLnXXCHTQyyYmCwuldEf/AqVw1cwZ+D?=
 =?us-ascii?Q?VlkgFqEQUt2s1QbaLJNfHJFr32ihcm/JFLWdZYTz1UbhIxh1EN6jZwtRCBR3?=
 =?us-ascii?Q?Xn7dkCgyq9Af+WQBtxO5A0a4aTDBdZg+Trb6Ys76rGZqjNiVPDXdnsnir8qH?=
 =?us-ascii?Q?CfJnD1FAdRrooWEsW+jV1TVWIi8oh0GpxX7jpG5HX+7E3CSVay2LryrMOWGU?=
 =?us-ascii?Q?Iz65XYy39JlR7rz7aGoZnlDCThSmlGECGciMTId7YS90Nd6PRcPfG2AF1tOV?=
 =?us-ascii?Q?zlU8HapyD85kKOoutHaQ+g6MLTfnu84YZ3pBxPgJh0GM4MWhIyyRlClWzE6e?=
 =?us-ascii?Q?XbcxYtdR62HMK5ssWFbSmlF4UU9YEtpukwe6Qfbk3wN0uIFJ1mE19RHpUJa+?=
 =?us-ascii?Q?Eywph5IjdHCv8MES9Ebs/H76ztiM6SgD06PFsWBmP3yRWaLZACEocroMcPUy?=
 =?us-ascii?Q?Q5iITXTedTeEvNVdrABKbhZewswQJQikTg28ilrIBX5hkuHWA/0EhZHB2nrj?=
 =?us-ascii?Q?wD7FzbRpVhQ88/B085tTApsbYZ3R4gXNohsOdEGP2GQTvFVP/fQ6rLy9umDM?=
 =?us-ascii?Q?lGQH3eIhMe9cc/ETodoisgmxLrt6pEu1OB9Ui02vKHjTuLzW14SRy4vNG9Ja?=
 =?us-ascii?Q?JBf7JGXN3TzzBOasPnsUJq8Fwsls/A596jYe/tqRewQwXgOc/HQVh4VSGm6o?=
 =?us-ascii?Q?Dt0rhNy6SgNxMhR8U07ERG+LwWntTmHpiqqG9SxT7J6Z5JZJhxT50S7PJqMl?=
 =?us-ascii?Q?8Xk20apYOdG9y5s22I2Gii4p6/u4qMDv9KjJYv5jfwXE/DE3Wwgm3ezmB/bY?=
 =?us-ascii?Q?5BfsRSDW/rLSorIFoIEpZ5PY3UhUYk+pZWHRuY68/eYE+wH5O/GHVbRhjVhr?=
 =?us-ascii?Q?QLEtKKl1USxGO+J7DrG6uWvSu8MZOGcW05QIBb7jXZFs8O353z04nwcortjh?=
 =?us-ascii?Q?LWGoNhBS7fDCYQN0iXxW/X3nqmcy8sP5JlLez1869ajUgb+wdgenEGDbP2op?=
 =?us-ascii?Q?38OKW61ZXbNYbhJtFFu4OY9aWh5Ochm6yj+ZiA57WbWznbiFyLCaAfOcE1PZ?=
 =?us-ascii?Q?OwdQfLCg08n5yFfE4zAiYRHoLlZkHerNF2wmjjcuBrEPwvXyTVxQeNMAQOxQ?=
 =?us-ascii?Q?BhV5YxwHmeJiCcdlakxR0eeZRLjy5dxQa1DcGneOS7NRhAAp1mO8VlqnJfVx?=
 =?us-ascii?Q?EFQuF0/Juw2XIY/vTFmFc6u4NzYg71muwqPsKtufsMBV1hvPkwIeFcDG4orG?=
 =?us-ascii?Q?A3oLzJWyueMI+h4d1AKRkI01I9+WrJpKFWSCA9H6DVPEwe4WWkezBfQ/pCTC?=
 =?us-ascii?Q?SQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B01427E152557D4491C51538A5F60B75@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 987b98c7-c1f7-4a39-1cc5-08dae913debf
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Dec 2022 20:41:17.6438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yq5E/vOs0B4QsGErJrcARbKfUDHLVNZImIS1huShundccTe+Y2FjxGFmdRkHSe+2E1VxHdrqE7Nxen2jHrwuRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5095
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Dec 08, 2022 at 05:58:01PM -0600, Mike Christie wrote:
> On 12/8/22 4:59 AM, Niklas Cassel wrote:
> > Move get_scsi_ml_byte() to scsi_priv.h since both scsi_lib.c and
> > scsi_error.c will need to use this helper in a follow-up patch.
> >=20
> > Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> > ---
> >  drivers/scsi/scsi_lib.c  | 5 -----
> >  drivers/scsi/scsi_priv.h | 5 +++++
> >  2 files changed, 5 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 9ed1ebcb7443..d243ebc5ad54 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -579,11 +579,6 @@ static bool scsi_end_request(struct request *req, =
blk_status_t error,
> >  	return false;
> >  }
> > =20
> > -static inline u8 get_scsi_ml_byte(int result)
> > -{
> > -	return (result >> 8) & 0xff;
> > -}
> > -
> >  /**
> >   * scsi_result_to_blk_status - translate a SCSI result code into blk_s=
tatus_t
> >   * @result:	scsi error code
> > diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> > index 96284a0e13fe..4f97e126c6fb 100644
> > --- a/drivers/scsi/scsi_priv.h
> > +++ b/drivers/scsi/scsi_priv.h
> > @@ -29,6 +29,11 @@ enum scsi_ml_status {
> >  	SCSIML_STAT_TGT_FAILURE		=3D 0x04,	/* Permanent target failure */
> >  };
> > =20
> > +static inline u8 get_scsi_ml_byte(int result)
> > +{
> > +	return (result >> 8) & 0xff;
> > +}
> > +
>=20
> I made a mistake in the naming of this function. The get_* functions take=
 a
> scsi_cmnd. The ones without the "get_" prefix take the scsi_cmnd->result.
>=20
> Could you rename it to scsi_ml_byte() when you move it so the mistake doe=
s not
> get used in multiple places?

Hello Mike,

In scsi.h we have:
#define status_byte(result) (result & 0xff)
#define host_byte(result)   (((result) >> 16) & 0xff)

In scsi_cmnd.h we have:
static inline u8 get_status_byte(struct scsi_cmnd *cmd)
static inline u8 get_host_byte(struct scsi_cmnd *cmd)

So I see your point.


I understand that you intentionally didn't put the ML byte getter in scsi.h=
,
as you intentionally didn't want a LLDD to be able to get the SCSI ML byte.

However, isn't the important thing that that a LLDD can't *set* the SCSI ML
byte?
Does it really matter if a LLDD can *get* the SCSI ML byte?

If you think that it is fine that a LLD can get the SCSI ML byte,
then perhaps we should move the getter to scsi.h instead, such that
it is defined together with the other getters (which lacks a get_ prefix).


Kind regards,
Niklas=
