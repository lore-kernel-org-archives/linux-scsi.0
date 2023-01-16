Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4163DC63797
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Jan 2023 12:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbjAPMnr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Jan 2023 07:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjAPMnq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2023 07:43:46 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AD91E29B;
        Mon, 16 Jan 2023 04:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673873023; x=1705409023;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6qmHgEAxB3GNc4NkZypRNfqbFJz+fXNaN8GHW7+rARU=;
  b=cz1HYu3z+vWHnNwwZTrY+56Pw9q6Zd1XCPIxmnapU3vyyO6Ffxh7vKNI
   6OcszAeY+CjkewC19TCo4ZzAQzXd9Zxwae2Mml/TVf0thimwyRS7rogAR
   5Tojiv0GNR43U+YSKZcOwHRWf21nkIvliTobT51Ojfj57hOV4+oMm+4XY
   34Sa6BYxNPc9PDC7ia3o6FE1PbAOCH6jX5+F8AVnN2tXV1LrrX1QP+1ae
   0jqdUIYVjxNe6+M3X1SRbRHa0htLiSH7XFU1p9GLNCAhqgIWzEBXNDW/h
   jnQQ98LLApuu4Y5TuGx1rCe3PHLFdv23tIu+bVDlRvCxZ8XjM5Ur5F4xG
   g==;
X-IronPort-AV: E=Sophos;i="5.97,221,1669046400"; 
   d="scan'208";a="325229513"
Received: from mail-mw2nam12lp2040.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.40])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jan 2023 20:43:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bjAtKqiFWZtvfpn9RICqBhnWzVFxLW2TX50cCcSmSLjKJ1rQFZqpbwZ3afXpp+CDKd9k6VBhVzbLc69MVkoVyi0FpY9aefXNDfJA8ifLcwjINXDuAUIOTmgf+mDAozrFxJedSXs9y2Sv4vyNg8TcWFmjKKjA45CQX95hskxKsm22l8exycad5Pd+NGKEWy8FjoqXat19MRqjmz3RKDtcsbsrnAqTldEeg7WK+e88Z05JbCCvYMUY63TgyawURT9X7qEiLD1H/Detq3vJRofUFBaumjpxVGPrL62Qw6HsJbm2QqeBwpFRtC6LDgApeaRFqpvDz74mGy71j7ASqZ9kXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mTusqcJ6yeLBWUvI2yvRLp30BGhmPorl0qOUOXejF8c=;
 b=dRpwKLUywzJ20z2+0z4ghzJUkEybMkTlKY01Qt0A+XZ135BngoI/CYpg82Btg5+0JMQr29EPldyKaauuYjrEC2/Ztf2XoPiyShowMv5wb6pLT//4Ejsgpd+XXgHyQTzqeG9d1ZjIHEThDJIdlOOoqYfXwajCq2CTItocqBYE4Jnp3+l3UnhEy4iK3IedTn23YhdDwbIEUEUEBQrhhxXq6zKBVvO+QaKhXrCN+AmP7r9Bdu3lhtagIY8bocXIslAKMEgPfsbhttl15q9Jp9+tRMXq2GfT6+YI9TeuKTS0B8JIoOxUqqt//dEP/smh84sU2O12nggNlMsp/wxkYyc5+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mTusqcJ6yeLBWUvI2yvRLp30BGhmPorl0qOUOXejF8c=;
 b=l2kDcaUkpzn9g/EkOl/FRDJOhuNsPz19i8AuYtp86TE5Sm/Km+9KHB3k58AMneo1S3tW5OfCG1WcaLYzXmGSzCVy0TueYx9klK9gZXHwW703m7q78oj4mw4c85r44mghZhiNNEfUeWepj97ymXqXl2XNTZtKxK1IpPYh/gxmbIs=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CO6PR04MB7587.namprd04.prod.outlook.com (2603:10b6:303:a0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 12:43:38 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::a65a:f2ad:4c7b:3164]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::a65a:f2ad:4c7b:3164%4]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 12:43:38 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Hannes Reinecke <hare@suse.de>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH v2 03/18] scsi: core: allow libata to complete successful
 commands via EH
Thread-Topic: [PATCH v2 03/18] scsi: core: allow libata to complete successful
 commands via EH
Thread-Index: AQHZJo7J1YXgijN+zEaKn1ZIIGbkta6b/EmAgAUG5gA=
Date:   Mon, 16 Jan 2023 12:43:38 +0000
Message-ID: <Y8VGeFSKuIr0nwC3@x1-carbon>
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
 <20230112140412.667308-4-niklas.cassel@wdc.com>
 <ab23c5dd-3a61-452c-52c9-43b6b18f2c8e@suse.de>
In-Reply-To: <ab23c5dd-3a61-452c-52c9-43b6b18f2c8e@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CO6PR04MB7587:EE_
x-ms-office365-filtering-correlation-id: 8570f8f9-6967-4d1f-59f6-08daf7bf4a45
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i1PeMIgzhOp3fcTkFzQliLmCZbWGNGt/DVinFnlmDyuQTjksq2Z0OzU4lEndOTT1JZCLjJjqglscHqAdG7voMtCXgDfZ+A0NTt1d8siYQQlmAw8/x3BeFhb1NPOrJbps0WrD/nikMetd0zQXBxt1zUfFB/GG3O6kUvJWxY/AXFGCNJQcxnJ+baOV/rSePourizM00DmNcLeEOgYsrjv8IU2P3ZfSpyD4oaMuyxsGedv2R+r6xAkadlOYPIYD4rkcvbqRR7PubTr73cL92TEeCh3BcbH6LApkByjpwYUMW39Zj09rHykux62UySY0HbZ0rVCerQVS7rNiHeKqfbMMv7Kq4E9bBfewpAV6HPyeY2ALK67Kk5lvFcPmjFBiHr5pLnJd/ea0EdC4TGTaVHSy0hBSiKBfmxg9P+AcFCz/JW4szOXcFzr/qBoH7JlSJyOzI+VfM759rMT7xGwJBbr7RQyfl09sz8NDPYIJ4ADE9SrNB88iX9zQdyPdYYTh0XhAcavZgrwCCrZcZxk13RNBef0gvstj2QYCF2n0RtuWmbsmEfpzF0sdWFG4ahE1wceLsZQ4RiXs2l28Qowi8vLL1xzBmL5Bs+O0g3JLkXOy5EJn7Dh+BBLeRauVw6e35cA+LPK8avVXhP4v1RNLP9fLH9M0L5yXov6MeLVHd73H7ilNcMSFQl5maJ5uxibG96VvVgXu3LsSn+cApcOScqLu/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199015)(82960400001)(83380400001)(122000001)(38070700005)(86362001)(38100700002)(4326008)(2906002)(5660300002)(8936002)(6916009)(76116006)(66946007)(66446008)(66476007)(64756008)(8676002)(66556008)(41300700001)(91956017)(33716001)(9686003)(186003)(6506007)(26005)(6512007)(53546011)(316002)(54906003)(478600001)(6486002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+7ez1rt8pXwTTowsna3bKGNYn6Nb/qfd+/QBDuscZbEEoGA88sb4Xso2pMzC?=
 =?us-ascii?Q?NwpnRWmiNT373zCfaf0sjX6sIqtQ7bXZlQG/VQUlplyZM042DW15W+cUkqsV?=
 =?us-ascii?Q?YDv1jPZRPXULjqMvfzzk3t1TKVa35qBuz+OpgEez+6WAN+Dow7vik0PdrJfv?=
 =?us-ascii?Q?BtrIvkDuTU9lQalhEV57nGg0YsMfum4bbsvpoPxfldMO30Ja0XGj9swvbFkl?=
 =?us-ascii?Q?AJJ2WpYkYXPmogDK+hNTgFUctIha0+NqsKO7Ix7Nrbga2PNlu3QJKCAT3jUy?=
 =?us-ascii?Q?aaZeh2x4JOTL/gveLQUmkuaC71m7BPbD4PYCOUGzUNO9R8+piTbb0zw+YXHA?=
 =?us-ascii?Q?fAmmlmROfQ63j0a70dhkCa45RzYALSW3JITwxvroH54CoxT3QpDJdny6iLJ/?=
 =?us-ascii?Q?oscDJadlqxuBnNGoOFxi9iPbARGfAruJMuJ0mBlGlEslUQZuj6XbHdhcN0cG?=
 =?us-ascii?Q?6Hnf40Y0r1ojDp07uS3wddpDDvmfE8tbyxDZlM5v+VyClQkux5Cjtm0KrAk+?=
 =?us-ascii?Q?kASdkx/m5u9U2LV61MiMQZo5q/dGO0isGD1Y0pHiKLNeRx/aSAr4ZCDA3QEj?=
 =?us-ascii?Q?q0hNtXbK8hnGIw3yr7FjhXli+7xuVnzsXWT4wyhKlQLUmQbR5Xdemshwk3ac?=
 =?us-ascii?Q?XTQZWyVd5/evEWFkO9pcQPf6/EmXb8GYdieLRqu7K64XvOhvmcwSkTBsOCut?=
 =?us-ascii?Q?h2TlukM4hCU0tmhLv95FY4crxSKXP4HxTVZEEd0omW+hY3PfH/C7lf94Oopy?=
 =?us-ascii?Q?nmOqIhZMYTl6GPFMwhjwXS5Hnx16YUueZdCCfpFsNJo9Lry5jphb3IT92m1v?=
 =?us-ascii?Q?Lvyg5tnQWjdtw/N3UYL/Xcy1UOjz4MpOHsZ9IRDHMdU/CH4sOPNgoWFFl4no?=
 =?us-ascii?Q?eI9wjwOqhbm6Ou+1asfEs/RjFRK3pUgKsWl4L6F41jrB/WilUbQ/7Qu9TjG5?=
 =?us-ascii?Q?jJyUJIt2kKzZF5/naf6j8CziaXEYrLTLaqNUxCplDYipBoL1D737moXEl/8a?=
 =?us-ascii?Q?+lZlsxbYlKl6auegpyDMLkuL/3QqUaTNSJkq+owj9+KrONRhAFsONxsHbiuf?=
 =?us-ascii?Q?VWVU+jS6a20WMkri38g1JZMM3zOqOcdXqV5z4v9hhZEHhREMb6WZU/ACSEoi?=
 =?us-ascii?Q?JVMb+YVBCZB02paY/5h4FmR3QIZZTiNdN6uqi4EltJtxv5Dqy9yKHpFyck9J?=
 =?us-ascii?Q?Y79a745sKVlDnLvye5pnJ/tfRvtaf4ilvyzkhcddozyYWG9js0K5YtzYsffY?=
 =?us-ascii?Q?fI3Y4UVccr31uhOKFBXWewvWz1hMhTO4qhBNb12Y7SjPSP5FWj7VxCQeLGJS?=
 =?us-ascii?Q?NTIki31B8n4RY00cs3eVXJUe3U57UcNIB4/reNC96UfkVwAOY2LWj234f3PA?=
 =?us-ascii?Q?puz9Swt8el+M3DXqoVNd6kRVPRG7c0wFaL6WLOpU1AEeP/vmc+CDJKz5iV88?=
 =?us-ascii?Q?L4NdTl6a3B9mT8i/+AmwiE99nxS9QrQj/3XDFrCsyNbUPKTZuqW7vcp2+D0T?=
 =?us-ascii?Q?mjSMMtNDUwD3dIbTQzPx3SKHAwHUCQJPYwHd9EalP4bsTxhE1017aDx36hzR?=
 =?us-ascii?Q?XL4d414JdNLqzADgSfLzNSGpO+MdrTPqQAaETWcapPMn27Qw0WFiXWePEA55?=
 =?us-ascii?Q?Ng=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <43C1E84C8463264FA1CC488A3D6DB5D8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: OdtRBUkhYMntH8tWL0XNy5pC0/zYRWt+quGsYKacd7suTe+PTSsuV1mARE0cojqqyGrB0qLHi5tFW8gD+6Djg35dBAbRE8gNp41G9uiylTGijh20zB65DBA4gA/YEt3fFCM5Sb0K8+s2rmvduHL3d3SV12QqwNj4OCbBjDkgbDo6KZNAwFroXpTvk7jjswmodF/LqLtCcSxV50fkYC70DavQUjuaIZQIyp+bxThxm/2bvMWmZDmCBQPTLdMo3QiWO0hFywxY9lJCKHrm/cbNo5FhfFnxaTObRnbhQF7EW9/kyierf8ercv+rHIEE6z2u1CtFT1vhlHyyQbrBUNXNOl18A2L1/nuIsdi42vr/D61Y14TGdxNV/ZKqv5qm7T1Nsk6QV+GLfjq3GETbZq87eu05Nb/PjRgRedhQkwqyNYYHl2j1cdXEAlCJlb1I+S/wQbizppO74o6un66CAmKJlVyujyuuZmi9kfyrOOItf9M79O8Foo4blY//O0B7KTp1znHpOea9cufzU8agjX1OMS8T+5/44U1iPiFsopWvHU/SUc9czl5d7+VzZjGF+gXBUPur+a2au/HA/+EDneJ3qoSP9YNakgeSO2Dz4b3f6qCrVAY62is+Vbtx+NJG36Ih5xrXTXA+SGlOkNi4sxyOMDkleiq2IHcmjBZFxuvp497Tpwn2K0ayNtWinV8w6AonRjDl1rBz4edSuEbDaNYvviDJhMU9/MT8S1pA6jFuRAWo16fRkG2rIT5wi1alT4oNqXPoKRe/UgUwSyKf1QSlvFR407rMU0uTnn6LJDUtJnkFOdfPEAzLpRT6eMLDKDk8aWUUjNDE7WYV0lNxcpL1ntXoh7rldvkNfIJrXkq/N10niTFz0+TkzSBqopAlTFZd
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8570f8f9-6967-4d1f-59f6-08daf7bf4a45
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 12:43:38.2750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nfMIBPnZUzyep6pp9dz0Pe9pc00Uij/rrLnJUEjmI/ely91XDWCrQwlAoLjOkLDinyv9V5OODLee/o7OzIXMyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7587
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jan 13, 2023 at 08:57:37AM +0100, Hannes Reinecke wrote:
> On 1/12/23 15:03, Niklas Cassel wrote:
> > In SCSI, we get the sense data as part of the completion, for ATA
> > however, we need to fetch the sense data as an extra step. For an
> > aborted ATA command the sense data is fetched via libata's
> > ->eh_strategy_handler().
> >=20
> > For Command Duration Limits policy 0xD:
> > The device shall complete the command without error with the additional
> > sense code set to DATA CURRENTLY UNAVAILABLE.
> >=20
> > In order to handle this policy in libata, we intend to send a successfu=
l
> > command via SCSI EH, and let libata's ->eh_strategy_handler() fetch the
> > sense data for the good command. This is similar to how we handle an
> > aborted ATA command, just that we need to read the Successful NCQ
> > Commands log instead of the NCQ Command Error log.
> >=20
> > When we get a SATA completion with successful commands, ATA_SENSE will
> > be set, indicating that some commands in the completion have sense data=
.
> >=20
> > The sense_valid bitmask in the Sense Data for Successful NCQ Commands
> > log will inform exactly which commands that had sense data, which might
> > be a subset of all the commands that was completed in the same
> > completion. (Yet all will have ATA_SENSE set, since the status is per
> > completion.)
> >=20
> > The successful commands that have e.g. a "DATA CURRENTLY UNAVAILABLE"
> > sense data will have a SCSI ML byte set, so scsi_eh_flush_done_q() will
> > not set the scmd->result to DID_TIME_OUT for these commands. However,
> > the successful commands that did not have sense data, must not get thei=
r
> > result marked as DID_TIME_OUT by SCSI EH.
> >=20
> > Add a new flag SCMD_EH_SUCCESS_CMD, which tells SCSI EH to not mark a
> > command as DID_TIME_OUT, even if it has scmd->result =3D=3D SAM_STAT_GO=
OD.
> >=20
> > This will be used by libata in a follow-up patch.
> >=20
> > Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> > ---
> >   drivers/scsi/scsi_error.c | 3 ++-
> >   include/scsi/scsi_cmnd.h  | 5 +++++
> >   2 files changed, 7 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> > index 2aa2c2aee6e7..51aa5c1e31b5 100644
> > --- a/drivers/scsi/scsi_error.c
> > +++ b/drivers/scsi/scsi_error.c
> > @@ -2165,7 +2165,8 @@ void scsi_eh_flush_done_q(struct list_head *done_=
q)
> >   			 * scsi_eh_get_sense), scmd->result is already
> >   			 * set, do not set DID_TIME_OUT.
> >   			 */
> > -			if (!scmd->result)
> > +			if (!scmd->result &&
> > +			    !(scmd->flags & SCMD_EH_SUCCESS_CMD))
> >   				scmd->result |=3D (DID_TIME_OUT << 16);
> >   			SCSI_LOG_ERROR_RECOVERY(3,
> >   				scmd_printk(KERN_INFO, scmd,
> Wouldn't it be better to use '!scmd->result && !scsi_sense_valid(scmd)'
> instead of a new flag?
> After all, if we have a valid sense code we _have_ been able to communica=
te
> with the device. And as we did so it's questionable whether it should cou=
nt
> as a command time out ...

Hello Hannes,

Thanks a lot for helping out reviewing this series!

Unfortunately, your suggestion won't work.


Let me explain:

When you get a FIS, the ACT register will have a bit set for each
command that finished, however, all the commands will share a single
STATUS value (since there is just a shared STATUS field in the FIS).

So let's say that tags 0-3 got finished (i.e. bits 0-3 are set in the
ACT field) and the STATUS field has the "Sense Data Available" bit set.

This just tells us that at least one of tags 0-3 has sense data.


In order to know which of these tags that actually has sense data,
we need to read the "Sense Data for Successful NCQ Commands log",
which contains a sense_valid bitmask (which contains one bit for
each of the 32 tags).

So reading the "Sense Data for Successful NCQ Commands log" might
tell us that just tag 0-1 have sense data.

So, libata calls ata_qc_schedule_eh() on tags 0-3, wait until SCSI calls
libata .eh_strategy_handler(). libata .eh_strategy_handler() will read the
"Sense Data for Successful NCQ Commands log", which will see that there is
sense data for tags 0-1, and will add sense data for those commands, and
call scsi_check_sense() for tags 0-1.

ata_eh_finish() will finally be called, to determine what to do with the
commands that belonged to EH.

The code looks like this:
if (qc->flags & ATA_QCFLAG_SENSE_VALID ||
    qc->flags & ATA_QCFLAG_EH_SUCCESS_CMD) {
	ata_eh_qc_complete(qc);
}

So it will call complete for all 4 tags, regardless is they had sense data
or not.


scsi_eh_flush_done_q() will soon be called, and since ata_eh_qc_complete()
sets scmd->retries =3D=3D scmd->allowed, none of the four commands will be =
retired.

if (!scmd->result &&
    !(scmd->flags & SCMD_EH_SUCCESS_CMD))
	scmd->result |=3D (DID_TIME_OUT << 16);

The 2 commands with sense data will not get DID_TIMEOUT,
because scmd->result has the SCSI ML byte set
(which is set by scsi_check_sense()).

The 2 commands without sense data will have scmd->result =3D=3D 0,
so they will get DID_TIME_OUT set if we don't have the extra
!(scmd->flags & SCMD_EH_SUCCESS_CMD)) condition.


SCSI could add an additional check for:

if (!scmd->result && !scsi_sense_valid(scmd) &&
    !(scmd->flags & SCMD_EH_SUCCESS_CMD))
	scmd->result |=3D (DID_TIME_OUT << 16);

so that a command with does have sense data, but scsi_check_sense()
did not set any SCSI ML byte, does not get DID_TIME_OUT set.

However, for CDL policy 0xD, which this patch cares about,
we would still need the "&& !(scmd->flags & SCMD_EH_SUCCESS_CMD))",
so at least from a CDL perspective, I don't see how any benefit of
also adding a check for "&& !scsi_sense_valid(scmd)".


Kind regards,
Niklas=
