Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C33ECC2BB1D
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 14:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AC2B2067C
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 14:09:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gtOzBx6D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgCMOJY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 10:09:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42095 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726834AbgCMOJY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 10:09:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584108562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SyBWs2D8ZsvLIbJdEvSBy1Tbf6OOzkkCw3fplg+1KMc=;
        b=gtOzBx6DR3Ny2/lIG4gNobG3pOr22iu5R+1Kha1Pz1fq+WtPWhoChbGuWT1OALGZfJ47kb
        caGVQ8DlGxPBORHuOxoexyZl0ljDrXeYOr48ve7gcqWExeBXYPwzKnzGY9rxY7mrVJtJUv
        pZu8VEYwCSBDx7OGvmTbjEThAYPdCtM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-UpLD2FVeNoC8PnwKyuN_LQ-1; Fri, 13 Mar 2020 10:09:19 -0400
X-MC-Unique: UpLD2FVeNoC8PnwKyuN_LQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E29B100550D;
        Fri, 13 Mar 2020 14:09:18 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C419388;
        Fri, 13 Mar 2020 14:09:17 +0000 (UTC)
Message-ID: <6240fa5ec0069c7695ba763f371036e526efff77.camel@redhat.com>
Subject: Re: [PATCH] qla2xxx: Fix I/Os being passed down when FC device is
 being deleted.
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Date:   Fri, 13 Mar 2020 10:09:16 -0400
In-Reply-To: <20200313085001.3781-1-njavali@marvell.com>
References: <20200313085001.3781-1-njavali@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-03-13 at 01:50 -0700, Nilesh Javali wrote:
> From: Arun Easi <aeasi@marvell.com>
> 
> I/Os could be passed down while the device FC SCSI device is being deleted.
> This would result in unnecessary delay of I/O and driver messages (when
> extended logging is set).
> 
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index b520a98..7a94e11 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -864,7 +864,7 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
>  		goto qc24_fail_command;
>  	}
>  
> -	if (atomic_read(&fcport->state) != FCS_ONLINE) {
> +	if (atomic_read(&fcport->state) != FCS_ONLINE || fcport->deleted) {
>  		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
>  			atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
>  			ql_dbg(ql_dbg_io, vha, 0x3005,
> @@ -946,7 +946,7 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
>  		goto qc24_fail_command;
>  	}
>  
> -	if (atomic_read(&fcport->state) != FCS_ONLINE) {
> +	if (atomic_read(&fcport->state) != FCS_ONLINE || fcport->deleted) {
>  		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
>  			atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
>  			ql_dbg(ql_dbg_io, vha, 0x3077,

This fixes an easily reproducible problem and should
be considered for -stable.  It generally happens with
extended driver logging enabled though.

Fixes: a8a12eb1920c ("scsi: qla2xxx: Remove defer flag to indicate immeadiate port loss")
Reviewed-by: Ewan D. Milne <emilne@redhat.com>


