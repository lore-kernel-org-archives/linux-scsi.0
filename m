Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71105C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 05:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FDA222DBF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 05:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbhAGFwW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 00:52:22 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2396 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725763AbhAGFwU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 00:52:20 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1075jlGS013692
        for <linux-scsi@vger.kernel.org>; Wed, 6 Jan 2021 21:51:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=jWkd0VeKRJ4OTHleNQzdmmEVxaF2qBZyhr5wFBYqvOA=;
 b=G1vsQx6kyVanyBala43jcBYy4l/Ntvnh83sPg5rp0Q4lRrwxUvNsu4Z7CKRihzWiTJbA
 7KhjxcDyzd3z9AB+MZR/kqswq/5mAT4k22aZXtMt00gxsZIvr2uUG6xR+lpbufwBT89E
 arz0VoQvp53LQ6wDEf29nWF5LL1nNzfgOd+6k1D4ndUQeZzkJbG8w6D/vaItLzjwFnyb
 Fi1GqABna5BHMVjIKqvF1/NnWjCig+rJtOXt/ASItra8OeGAzA1lFhB2mbAV9EkjdWaC
 ep0C6h7BHavjM3HXoLnul8gDqyUUJiMqLClc7Tbc+ZkDhA5oCe4Q77e3l3EjjxuSV9kh Qg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 35wqq78kxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jan 2021 21:51:38 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 6 Jan
 2021 21:51:37 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 6 Jan
 2021 21:51:36 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 6 Jan 2021 21:51:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GzKiWgRoYzWTiMl+sNc4mmLJHKUlrzOmtHN1bu9vqb4znXnuWB9O85y2+5NqYNVNl4rGGW4rZm4Nix3GYPS+DY4H/CeCwl9P+jYbB0FIzVuR1FcpenNyToPITXrjRule8l+pHPjhXIAD0jXmXPhGh9oV2rXtEmzry4n7g+h5J8CgeF1vFypD352JJckyrxsQl+xJl452aqpSlQ3o4nWhmxiqphSemuIXFQUUwwCNHGK7HbsRpheDwu93Oo4ifXKj3PZl/mzdcNQwp+FjY0azuSaXwhVDPmoycRUtMiTXTlfJ8eMp9hJBmg/G6rbJ8Tjxe0eHibCgvfpvjH/EcHgL1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWkd0VeKRJ4OTHleNQzdmmEVxaF2qBZyhr5wFBYqvOA=;
 b=KR6jpIAfX4Jg8IYTtUqNTygAcbIcpy3H9ZkpBngtvyRdrZYIkNXexJ4oiX37HA3qLkLvB64cdDe4fOTeTCSEJwUKxeVCQ64Ei8xhB34VNRWlyJDa1nAfzQ11tOEWMvanWaq3yCTR50TudaFeV28CoieDCq/g5P4KbqNkJS9QNgyKozYIeyZzAO87liQAL6n6w+1FQYkLJ1SLPWaEZxdQ+D4FOx7++sRAiDjV52PI7FKiOVWIi7MLuj9ZOnRmPbogEC3g9bn5ULTcPAWUobpA1UUWZQ8UZ4stn32cQHu1WzCaqg0U6a68hyiDO8XCp3qvtBZ/+TsAJwDRlgcAKu/pow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWkd0VeKRJ4OTHleNQzdmmEVxaF2qBZyhr5wFBYqvOA=;
 b=dzF6wosPuwrI27os463kkG6sDCw2FbJPw8c2wUWxYKvQamCaRzbqkM1oVLTAKuKkeGwuSHjG7hRY7fnn4SsTg6FQskl8RRJTBagOChudxVpUtb9LNVqCroI7YbtcaofTwoJuMrX8hDqg1t32AS7hHRU9S72bo1fMMBJ/uRzrGY4=
Received: from BN8PR18MB3025.namprd18.prod.outlook.com (2603:10b6:408:6d::30)
 by BN6PR18MB1618.namprd18.prod.outlook.com (2603:10b6:404:12c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Thu, 7 Jan
 2021 05:51:32 +0000
Received: from BN8PR18MB3025.namprd18.prod.outlook.com
 ([fe80::4d8c:abd5:a8c8:43aa]) by BN8PR18MB3025.namprd18.prod.outlook.com
 ([fe80::4d8c:abd5:a8c8:43aa%4]) with mapi id 15.20.3742.006; Thu, 7 Jan 2021
 05:51:32 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [EXT] Re: [PATCH v3 3/7] qla2xxx: Move some messages from debug
 to normal log level
Thread-Topic: [EXT] Re: [PATCH v3 3/7] qla2xxx: Move some messages from debug
 to normal log level
Thread-Index: AQHW408xQa17aQDnqEabnGqULAdR3qoatHsAgAD0CPA=
Date:   Thu, 7 Jan 2021 05:51:32 +0000
Message-ID: <BN8PR18MB30258A9BFBC37C8C9CB9E80DD2AF9@BN8PR18MB3025.namprd18.prod.outlook.com>
References: <20210105103847.25041-1-njavali@marvell.com>
 <20210105103847.25041-4-njavali@marvell.com>
 <DABC7D0B-6734-4229-9812-DB573235246F@oracle.com>
In-Reply-To: <DABC7D0B-6734-4229-9812-DB573235246F@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.103.215.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cedfb1e0-27a3-4e15-a527-08d8b2d04961
x-ms-traffictypediagnostic: BN6PR18MB1618:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR18MB1618496BFB0F456B2A275F2ED2AF9@BN6PR18MB1618.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H/p9dvCTQ1/hi3I6cAAmKN4HJ9+W+DAFCh1+4JrKQWtmtLHUjM2C53wFGLKA9+rOiTC3zTDLTWwwuWyEYJzGAZ244dreE2U5C7FNrNhrLZCr1Vby09OLUCFOczxd+v7Cw2BEzvmlyWBIWMySnDpOzSHJcGLXf3AUPEoGB2zujHdbX4Gn4SKIWaOhkyhN+256XQ2Jbl76KKbHgxpPpUE5JMZYVWDQN9TWqiF7mCs9o+eR/1sPDi/WH0J0DwV1K4y0LCoQAjgpuZy4YxMeo7w90519E1L5hwdAE7Ocm51IpUmEbXR2wZpnBpiGiCG+Yw+c3JonuUZmuTe9rlU/xiwDFHRhd9aXKqkpj0tukili8uT5pklFn5yDGUuJiEjYz5MziaHWGFxEYyv/q75GEh93ag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR18MB3025.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(15650500001)(33656002)(2906002)(8936002)(6506007)(53546011)(26005)(5660300002)(186003)(52536014)(71200400001)(8676002)(76116006)(66946007)(6636002)(66556008)(66476007)(64756008)(316002)(4326008)(66446008)(478600001)(86362001)(7696005)(107886003)(55016002)(110136005)(9686003)(54906003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?js4MLx3DekSeecbThmjtGrz+0Rq/SQzvs/w2m7yCeMAG0eKkkRH80mGQuay0?=
 =?us-ascii?Q?9fwxscGTsmHEsmaTV/reLnLsielRnVD2smcbxyTXMls26SlZKus0+bwT9Esd?=
 =?us-ascii?Q?y3dMAJJnLpXSOwoibGZJH4aAJoksBUtm0QMNYYO+uwuciqB3YvwfnL7gCQaN?=
 =?us-ascii?Q?kelvL/Bq9/5SE2OKHpKCgBWDusYo09SzzTN/c63bj65OWsA6XPQmkxeO3nGn?=
 =?us-ascii?Q?a7gFiDgFi8kH4QOI8r2nP/bi+Js3o1AogH1Pd1wkEe3gFRCWPVehPBP09xXx?=
 =?us-ascii?Q?4EWjOLjeHCJnjZhmYsCCrS59eNaiIdxZXCGDrvLuvCWvanMIt1XmHLJfYJsF?=
 =?us-ascii?Q?J9wVgfP0LiQPXMVnaQc0a4UL3/xnN5UnHr7Vx9dWNHoAfYOTuvN9QYX2qOkh?=
 =?us-ascii?Q?1nNMlSrt3nBCg1/BYiC6qe9/axUozQEF0YJLWhurtMsyjjWxKPJV2rEXTfps?=
 =?us-ascii?Q?8M5+kFlNULi1120tg5fqlxNk3/5G2B5NEGhjVDM4D1woEo0Yk1wW3X7YwjyH?=
 =?us-ascii?Q?oecnIzjAd5i/inPpn9wLtLMAbdQzLRqqDkeoyy8EFe+5sbph/ljxlqn1uuCp?=
 =?us-ascii?Q?KzTtGhrLUHHnKCEoJc1nWIrw69vP8sA38IxeIoCm3iINAZlu4KKIiUjKrTHS?=
 =?us-ascii?Q?q81HFq6ZBZ93sjP+p6ErxumAd7kczX55W6E5CqU1etFk3Zx0r4ePJO8XXd2u?=
 =?us-ascii?Q?XhFOfShJxcWPS40K/4GScIsz91OSiRYpVRXozsEWn0aouuNjccv1P8FEsimc?=
 =?us-ascii?Q?dOTeAhTKbahLRsoxWK9xl9cqQoNnTJ3fWXZ8NQVUkbsEBGwvwlo4+qnC/OHg?=
 =?us-ascii?Q?ONkP5//VgnA1gNN9VRuRxzHIHxZqrEmNeR/GrH7+M7Kqt1/ZdNexpTIOrvBI?=
 =?us-ascii?Q?eXfzZvB/5bhaBP31HFEkbQuGKiNAKU4ovVDbCFhRodTjlKm0Osx7AEn5kKaJ?=
 =?us-ascii?Q?ocySJHGimkyFtixkg/PZE0H5mHEz09TZpX83ks3RXZA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR18MB3025.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cedfb1e0-27a3-4e15-a527-08d8b2d04961
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2021 05:51:32.6163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rAeCb2qw+v0nnCy9yD6EFjv/jIfNmAHZ26WqipM72p0x4ySZl0gZlnQj6IEXceAYjOzFA/XfVmdSTpBvoMJb8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR18MB1618
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-07_02:2021-01-06,2021-01-07 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Himanshu,
Thanks for the review, comments inline..

> -----Original Message-----
> From: Himanshu Madhani <himanshu.madhani@oracle.com>
> Sent: Wednesday, January 6, 2021 8:37 PM
> To: Nilesh Javali <njavali@marvell.com>; Saurav Kashyap
> <skashyap@marvell.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>; linux-
> scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> Upstream@marvell.com>
> Subject: [EXT] Re: [PATCH v3 3/7] qla2xxx: Move some messages from debug =
to
> normal log level
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Hi Saurav,
>=20
> > On Jan 5, 2021, at 4:38 AM, Nilesh Javali <njavali@marvell.com> wrote:
> >
> > From: Saurav Kashyap <skashyap@marvell.com>
> >
> > This change will aid in debugging issues where debug level is not set.
> >
> > Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> > Signed-off-by: Nilesh Javali <njavali@marvell.com>
> > ---
> > drivers/scsi/qla2xxx/qla_init.c | 10 +++----
> > drivers/scsi/qla2xxx/qla_isr.c  | 52 ++++++++++++++++-----------------
> > 2 files changed, 30 insertions(+), 32 deletions(-)
> >
> > diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla=
_init.c
> > index 410ff5534a59..221369cdf71f 100644
> > --- a/drivers/scsi/qla2xxx/qla_init.c
> > +++ b/drivers/scsi/qla2xxx/qla_init.c
> > @@ -347,11 +347,11 @@ qla2x00_async_login(struct scsi_qla_host *vha,
> fc_port_t *fcport,
> > 	if (NVME_TARGET(vha->hw, fcport))
> > 		lio->u.logio.flags |=3D SRB_LOGIN_SKIP_PRLI;
> >
> > -	ql_dbg(ql_dbg_disc, vha, 0x2072,
> > -	    "Async-login - %8phC hdl=3D%x, loopid=3D%x portid=3D%02x%02x%02x =
"
> > -		"retries=3D%d.\n", fcport->port_name, sp->handle, fcport-
> >loop_id,
> > -	    fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_pa,
> > -	    fcport->login_retry);
> > +	ql_log(ql_log_warn, vha, 0x2072,
> > +	       "Async-login - %8phC hdl=3D%x, loopid=3D%x portid=3D%02x%02x%0=
2x
> retries=3D%d.\n",
> > +	       fcport->port_name, sp->handle, fcport->loop_id,
> > +	       fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_=
pa,
> > +	       fcport->login_retry);
> >
> > 	rval =3D qla2x00_start_sp(sp);
> > 	if (rval !=3D QLA_SUCCESS) {
> > diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_=
isr.c
> > index 9cf8326ab9fc..bfc8bbaeea46 100644
> > --- a/drivers/scsi/qla2xxx/qla_isr.c
> > +++ b/drivers/scsi/qla2xxx/qla_isr.c
> > @@ -1455,9 +1455,9 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct
> rsp_que *rsp, uint16_t *mb)
> > 		if (ha->flags.npiv_supported && vha->vp_idx !=3D (mb[3] & 0xff))
> > 			break;
> >
> > -		ql_dbg(ql_dbg_async, vha, 0x5013,
> > -		    "RSCN database changed -- %04x %04x %04x.\n",
> > -		    mb[1], mb[2], mb[3]);
> > +		ql_log(ql_log_warn, vha, 0x5013,
> > +		       "RSCN database changed -- %04x %04x %04x.\n",
> > +		       mb[1], mb[2], mb[3]);
> >
> > 		rscn_entry =3D ((mb[1] & 0xff) << 16) | mb[2];
> > 		host_pid =3D (vha->d_id.b.domain << 16) | (vha->d_id.b.area <<
> 8)
> > @@ -2221,12 +2221,12 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struc=
t
> req_que *req,
> > 		break;
> > 	}
> >
> > -	ql_dbg(ql_dbg_async, sp->vha, 0x5037,
> > -	    "Async-%s failed: handle=3D%x pid=3D%06x wwpn=3D%8phC
> comp_status=3D%x iop0=3D%x iop1=3D%x\n",
> > -	    type, sp->handle, fcport->d_id.b24, fcport->port_name,
> > -	    le16_to_cpu(logio->comp_status),
> > -	    le32_to_cpu(logio->io_parameter[0]),
> > -	    le32_to_cpu(logio->io_parameter[1]));
> > +	ql_log(ql_log_warn, sp->vha, 0x5037,
> > +	       "Async-%s failed: handle=3D%x pid=3D%06x wwpn=3D%8phC
> comp_status=3D%x iop0=3D%x iop1=3D%x\n",
> > +	       type, sp->handle, fcport->d_id.b24, fcport->port_name,
> > +	       le16_to_cpu(logio->comp_status),
> > +	       le32_to_cpu(logio->io_parameter[0]),
> > +	       le32_to_cpu(logio->io_parameter[1]));
> >
> > logio_done:
> > 	sp->done(sp, 0);
> > @@ -2389,9 +2389,9 @@ static void
> qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
> >
> > 		tgt_xfer_len =3D be32_to_cpu(rsp_iu->xfrd_len);
> > 		if (fd->transferred_length !=3D tgt_xfer_len) {
> > -			ql_dbg(ql_dbg_io, fcport->vha, 0x3079,
> > -				"Dropped frame(s) detected
> (sent/rcvd=3D%u/%u).\n",
> > -				tgt_xfer_len, fd->transferred_length);
> > +			ql_log(ql_log_warn, fcport->vha, 0x3079,
> > +			       "Dropped frame(s) detected
> (sent/rcvd=3D%u/%u).\n",
> > +			       tgt_xfer_len, fd->transferred_length);
> > 			logit =3D 1;
> > 		} else if (le16_to_cpu(comp_status) =3D=3D CS_DATA_UNDERRUN) {
> > 			/*
> > @@ -3112,9 +3112,9 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct
> rsp_que *rsp, void *pkt)
> > 		scsi_set_resid(cp, resid);
> > 		if (scsi_status & SS_RESIDUAL_UNDER) {
> > 			if (IS_FWI2_CAPABLE(ha) && fw_resid_len !=3D
> resid_len) {
> > -				ql_dbg(ql_dbg_io, fcport->vha, 0x301d,
> > -				    "Dropped frame(s) detected (0x%x of 0x%x
> bytes).\n",
> > -				    resid, scsi_bufflen(cp));
> > +				ql_log(ql_log_warn, fcport->vha, 0x301d,
> > +				       "Dropped frame(s) detected (0x%x of 0x%x
> bytes).\n",
> > +				       resid, scsi_bufflen(cp));
> >
> > 				vha->interface_err_cnt++;
> >
> > @@ -3139,9 +3139,9 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct
> rsp_que *rsp, void *pkt)
> > 			 * task not completed.
> > 			 */
> >
> > -			ql_dbg(ql_dbg_io, fcport->vha, 0x301f,
> > -			    "Dropped frame(s) detected (0x%x of 0x%x
> bytes).\n",
> > -			    resid, scsi_bufflen(cp));
> > +			ql_log(ql_log_warn, fcport->vha, 0x301f,
> > +			       "Dropped frame(s) detected (0x%x of 0x%x
> bytes).\n",
> > +			       resid, scsi_bufflen(cp));
> >
> > 			vha->interface_err_cnt++;
> >
> > @@ -3257,15 +3257,13 @@ qla2x00_status_entry(scsi_qla_host_t *vha,
> struct rsp_que *rsp, void *pkt)
> >
> > out:
> > 	if (logit)
> > -		ql_dbg(ql_dbg_io, fcport->vha, 0x3022,
> > -		    "FCP command status: 0x%x-0x%x (0x%x) nexus=3D%ld:%d:%llu
> "
> > -		    "portid=3D%02x%02x%02x oxid=3D0x%x cdb=3D%10phN len=3D0x%x "
> > -		    "rsp_info=3D0x%x resid=3D0x%x fw_resid=3D0x%x sp=3D%p cp=3D%p.\n=
",
> > -		    comp_status, scsi_status, res, vha->host_no,
> > -		    cp->device->id, cp->device->lun, fcport->d_id.b.domain,
> > -		    fcport->d_id.b.area, fcport->d_id.b.al_pa, ox_id,
> > -		    cp->cmnd, scsi_bufflen(cp), rsp_info_len,
> > -		    resid_len, fw_resid_len, sp, cp);
> > +		ql_log(ql_log_warn, fcport->vha, 0x3022,
> > +		       "FCP command status: 0x%x-0x%x (0x%x)
> nexus=3D%ld:%d:%llu portid=3D%02x%02x%02x oxid=3D0x%x cdb=3D%10phN len=3D=
0x%x
> rsp_info=3D0x%x resid=3D0x%x fw_resid=3D0x%x sp=3D%p cp=3D%p.\n",
> > +		       comp_status, scsi_status, res, vha->host_no,
> > +		       cp->device->id, cp->device->lun, fcport->d_id.b.domain,
> > +		       fcport->d_id.b.area, fcport->d_id.b.al_pa, ox_id,
> > +		       cp->cmnd, scsi_bufflen(cp), rsp_info_len,
> > +		       resid_len, fw_resid_len, sp, cp);
> >
> > 	if (rsp->status_srb =3D=3D NULL)
> > 		sp->done(sp, res);
> > --
> > 2.19.0.rc0
> >
>=20
> I like the direction of this patch.
>=20
> Can you consider removing "logit" variable. Since logit was designed to p=
rint
> messages only when a specific debug (IO bits in this case) was set.
<SK> logit is set under certain IO error conditions not based on any debug.=
 If logit is removed,
this print will be come for each and every IO.=20

Thanks,
~Saurav
>=20
> --
> Himanshu Madhani	 Oracle Linux Engineering

