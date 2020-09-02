Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39172C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1705720829
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:16:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FsD+G+l7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgIBPQu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:16:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48098 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBPPQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 11:15:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082FEtmV056149;
        Wed, 2 Sep 2020 15:15:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : sender : to : cc : subject : references :
 in-reply-to : content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=gYMWuaYNXg+rjqjQKWcbvCaqzN+3Nom7q57z5YBU6sM=;
 b=FsD+G+l71itn02BQ151GYD5PxhUuMTTIf2Id+DOvxobxTQfbOL9im9aujzQ+nqfOR1lW
 tXm7B1xNMWAyBlY8On5VgRbU00VtjDZQBgKeBxPPtHE+frCxOdvIUTAaOKL1UVGlpTE1
 cW+GZhiSy9H0A/kSdEaD4hJq93vmlfFlxGe1i1yoaVNQ6W6f5d/GJIxyPErRqwWeA/Qx
 lVjBYNgWuUpKFiWvhwhWTlArC2HSvFxnTuI4rSdxDRfeWWyTfvY7MCddTg8DfBtrhufT
 seJb0DGNcRwg85UWu4eLDDxuDDyn1sYKrC6AWji0isa/bqB5+gE5rPwI4Mazxkj2ldXj kQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 337eer37ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 15:15:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082F5EIa028797;
        Wed, 2 Sep 2020 15:14:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3380kq5kf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 15:14:59 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 082FExGd000395;
        Wed, 2 Sep 2020 15:14:59 GMT
MIME-Version: 1.0
Message-ID: <dcc05e5d-5b8f-4ae1-991d-b8d454eff3f0@default>
Date:   Wed, 2 Sep 2020 08:14:57 -0700 (PDT)
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     Martin Wilck <mwilck@suse.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        Michael Christie <michael.christie@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Shirley Ma <shirley.ma@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Arun Easi <aeasi@marvell.com>
Subject: RE: [PATCH v4 2/4] target: initialize LUN in transport_init_se_cmd().
References: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
 <1591559913-8388-3-git-send-email-sudhakar.panneerselvam@oracle.com>
 <cbbd368e6e33af6e22c850192e69b27edd043efd.camel@suse.com>
In-Reply-To: <cbbd368e6e33af6e22c850192e69b27edd043efd.camel@suse.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.9.1  (1003210) [OL
 15.0.5267.0 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020146
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

> -----Original Message-----
> From: Martin Wilck [mailto:mwilck@suse.com]
> Sent: Wednesday, September 2, 2020 7:50 AM
> To: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>; Martin
> Petersen <martin.petersen@oracle.com>; Michael Christie
> <michael.christie@oracle.com>; target-devel@vger.kernel.org; linux-
> scsi@vger.kernel.org
> Cc: Shirley Ma <shirley.ma@oracle.com>; Hannes Reinecke <hare@suse.com>;
> Daniel Wagner <daniel.wagner@suse.com>; Arun Easi <aeasi@marvell.com>
> Subject: Re: [PATCH v4 2/4] target: initialize LUN in transport_init_se_c=
md().
>=20
> Hello Sudhakar,
>=20
> On Sun, 2020-06-07 at 19:58 +0000, Sudhakar Panneerselvam wrote:
> > Initialization of orig_fe_lun is moved to transport_init_se_cmd()
> > from
> > transport_lookup_cmd_lun(). This helps for the cases where the scsi
> > request
> > fails before the call to transport_lookup_cmd_lun() so that
> > trace_target_cmd_complete() can print the LUN information to the
> > trace
> > buffer. Due to this change, the lun parameter is removed from
> > transport_lookup_cmd_lun() and transport_lookup_tmr_lun().
> >
> > Signed-off-by: Sudhakar Panneerselvam <
> > sudhakar.panneerselvam@oracle.com>
> > ---
> >  drivers/target/iscsi/iscsi_target.c    | 11 +++++------
> >  drivers/target/target_core_device.c    | 19 ++++++++-----------
> >  drivers/target/target_core_tmr.c       |  4 ++--
> >  drivers/target/target_core_transport.c | 12 +++++++-----
> >  drivers/target/target_core_xcopy.c     |  4 ++--
> >  drivers/usb/gadget/function/f_tcm.c    |  6 ++++--
> >  include/target/target_core_fabric.h    |  6 +++---
> >  7 files changed, 31 insertions(+), 31 deletions(-)
> >
> > [...]
> > diff --git a/drivers/target/target_core_transport.c
> > b/drivers/target/target_core_transport.c
> > index f2f7c5b818cc..7ea77933e64d 100644
> > --- a/drivers/target/target_core_transport.c
> > +++ b/drivers/target/target_core_transport.c
> > [...]
> > @@ -1790,7 +1792,7 @@ int target_submit_tmr(struct se_cmd *se_cmd,
> > struct se_session *se_sess,
> >  =09BUG_ON(!se_tpg);
> >
> >  =09transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
> > -=09=09=09      0, DMA_NONE, TCM_SIMPLE_TAG, sense);
> > +=09=09=09      0, DMA_NONE, TCM_SIMPLE_TAG, sense,
> > unpacked_lun);
> >  =09/*
> >  =09 * FIXME: Currently expect caller to handle se_cmd->se_tmr_req
> >  =09 * allocation failure.
>=20
> Between this hunk and the next one in target_submit_tmr(), there
> is this code:
>=20
>         /*
>          * If this is ABORT_TASK with no explicit fabric provided LUN,
>          * go ahead and search active session tags for a match to figure
>          * out unpacked_lun for the original se_cmd.
>          */
>         if (tm_type =3D=3D TMR_ABORT_TASK && (flags &
> TARGET_SCF_LOOKUP_LUN_FROM_TAG)) {
>                 if (!target_lookup_lun_from_tag(se_sess, tag, &unpacked_l=
un))
>                         goto failure;
>         }
>=20
> > @@ -1818,7 +1820,7 @@ int target_submit_tmr(struct se_cmd *se_cmd,
> > struct se_session *se_sess,
> >  =09=09=09goto failure;
> >  =09}
> >
> > -=09ret =3D transport_lookup_tmr_lun(se_cmd, unpacked_lun);
> > +=09ret =3D transport_lookup_tmr_lun(se_cmd);
> >  =09if (ret)
> >  =09=09goto failure;
> >
>=20
> AFAICS, your patch breaks the case where the above code is executed to
> derive unpacked_lun from the tag. The updated value of unpacked_lun is
> never used. That would break aborts for the qla2xxx target.
>=20
> Am I overlooking something? Can you please explain?
>=20

You are right. This change breaks the qlogic abort task code path, since it=
 is the only transport that sets the TARGET_SCF_LOOKUP_LUN_FROM_TAG flag ma=
king that condition true. My apologies. I can send out a patch if you have =
not written one already. Please let me know.

Thanks
Sudhakar

> Regards
> Martin
>=20
>=20
