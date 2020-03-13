Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FEFAC10DCE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 18:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CC33206E7
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 18:46:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T1+DafU3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgCMSqE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 14:46:04 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52332 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726475AbgCMSqE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Mar 2020 14:46:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584125162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VMxeG/kQ8TlgSQWoSbArcwHbXaUwkQ4y57ZJY8gnNp4=;
        b=T1+DafU3DY+riGxkRQG0D1EehzFNmvbPrA3s3UsQnSYE8YTOIB+nll4HNywLzqmaOFG8Zt
        QNWwwyyovPlZMxBDUKOMwkKa69MhmgUD6scDGB3BQCD0LtDm7hLQPaniNH85dJ5717J0cJ
        eR4BnQV8Wr/nbl9R6/iPcu4L7co+rB0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-tLlyxrlMOGmZwjZnqTK_Cg-1; Fri, 13 Mar 2020 14:46:00 -0400
X-MC-Unique: tLlyxrlMOGmZwjZnqTK_Cg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B0411B2C980;
        Fri, 13 Mar 2020 18:45:57 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B27105C1BB;
        Fri, 13 Mar 2020 18:45:56 +0000 (UTC)
Message-ID: <4fb572e90972a3256326ae898643a05d375395cf.camel@redhat.com>
Subject: Re: [PATCH] qla2xxx: Fix I/Os being passed down when FC device is
 being deleted.
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Date:   Fri, 13 Mar 2020 14:45:56 -0400
In-Reply-To: <65771e71-f461-98b1-5cd6-9663bf607b07@acm.org>
References: <20200313085001.3781-1-njavali@marvell.com>
         <6240fa5ec0069c7695ba763f371036e526efff77.camel@redhat.com>
         <65771e71-f461-98b1-5cd6-9663bf607b07@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-03-13 at 07:44 -0700, Bart Van Assche wrote:
> On 2020-03-13 07:09, Ewan D. Milne wrote:
> > On Fri, 2020-03-13 at 01:50 -0700, Nilesh Javali wrote:
> > > From: Arun Easi <aeasi@marvell.com>
> > > 
> > > I/Os could be passed down while the device FC SCSI device is being deleted.
> > > This would result in unnecessary delay of I/O and driver messages (when
> > > extended logging is set).
> > > 
> > > Signed-off-by: Arun Easi <aeasi@marvell.com>
> > > ---
> > >  drivers/scsi/qla2xxx/qla_os.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> > > index b520a98..7a94e11 100644
> > > --- a/drivers/scsi/qla2xxx/qla_os.c
> > > +++ b/drivers/scsi/qla2xxx/qla_os.c
> > > @@ -864,7 +864,7 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
> > >  		goto qc24_fail_command;
> > >  	}
> > >  
> > > -	if (atomic_read(&fcport->state) != FCS_ONLINE) {
> > > +	if (atomic_read(&fcport->state) != FCS_ONLINE || fcport->deleted) {
> > >  		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
> > >  			atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
> > >  			ql_dbg(ql_dbg_io, vha, 0x3005,
> > > @@ -946,7 +946,7 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
> > >  		goto qc24_fail_command;
> > >  	}
> > >  
> > > -	if (atomic_read(&fcport->state) != FCS_ONLINE) {
> > > +	if (atomic_read(&fcport->state) != FCS_ONLINE || fcport->deleted) {
> > >  		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
> > >  			atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
> > >  			ql_dbg(ql_dbg_io, vha, 0x3077,
> > 
> > This fixes an easily reproducible problem and should
> > be considered for -stable.  It generally happens with
> > extended driver logging enabled though.
> > 
> > Fixes: a8a12eb1920c ("scsi: qla2xxx: Remove defer flag to indicate immeadiate port loss")
> > Reviewed-by: Ewan D. Milne <emilne@redhat.com>
> 
> Hi Ewan,
> 
> That commit ID does not exist. Did you perhaps want to refer to
> 3c75ad1d87c7 ("scsi: qla2xxx: Remove defer flag to indicate immeadiate
> port loss") # v5.6-rc1?
> 
> Thanks,
> 
> Bart.

Yes, that's the one.  Sorry, I can't figure out how I managed
to copy that ID.  It's not a commit in any tree I use.  Thanks.

-Ewan



