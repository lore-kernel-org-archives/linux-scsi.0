Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21592C54EBD
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 04:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbjALEaY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 23:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236652AbjALE3n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 23:29:43 -0500
Received: from msg-1.mailo.com (msg-1.mailo.com [213.182.54.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EEE4F104;
        Wed, 11 Jan 2023 20:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailo.com; s=mailo;
        t=1673497614; bh=bFAvtmB3dm9JYeOLKg4yDvn2sbN5iX4OjCscOt3R1o0=;
        h=X-EA-Auth:Date:From:To:Cc:Subject:Message-ID:References:
         MIME-Version:Content-Type:In-Reply-To;
        b=FzNdPeX5kHsNdQKultJfPsnI7GWlIQMXp210Qljrc2BE5TuGQiXd1+Xl6/XXaFnCH
         zi7Hjh8qljLvW5xE/ZXKV7EcpEJm9VDiEEWlCVpfrntTHvtZULuXO7Ppg2zifUc960
         y2XXHofEkpbzKN0lgC1Yw8BPaYKjukQV0VyAu1Pk=
Received: by b-1.in.mailobj.net [192.168.90.11] with ESMTP
        via ip-206.mailobj.net [213.182.55.206]
        Thu, 12 Jan 2023 05:26:54 +0100 (CET)
X-EA-Auth: mDbFDqFFDIsqZQVZiRFz2edvD4favDP2fyuN6KCszu4cUCcPnVpvsGe+TViSc/oT2ITQSab/EP8Wz1JxY2uY9bmPhENxQ3K+
Date:   Thu, 12 Jan 2023 09:56:49 +0530
From:   Deepak R Varma <drv@mailo.com>
To:     Lee Duncan <lduncan@suse.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saurabh Singh Sengar <ssengar@microsoft.com>,
        Praveen Kumar <kumarpraveen@linux.microsoft.com>
Subject: Re: [PATCH] scsi: qla2xxx: Simplify if condition evaluation
Message-ID: <Y7+MCWQm1xoFiw9S@ubun2204.myguest.virtualbox.org>
References: <Y78HoiOWkc3RrEgN@ubun2204.myguest.virtualbox.org>
 <54c45867-e9a5-fb6b-d242-0a02305e70d4@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54c45867-e9a5-fb6b-d242-0a02305e70d4@suse.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 11, 2023 at 07:26:32PM -0800, Lee Duncan wrote:
> On 1/11/23 11:01, Deepak R Varma wrote:
> > A logical evaluation of type (!A || A && B) can be simplified as
> > (!A || B).
> > Improvement by suggested by excluded_middle.cocci Coccinelel semantic
> > patch.
> > 
> > Signed-off-by: Deepak R Varma <drv@mailo.com>
> > ---
> > Please note: Change is compile tested only.
> > 
> >   drivers/scsi/qla2xxx/qla_target.c | 3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> > index 548f22705ddc..bf6aacf4dbd1 100644
> > --- a/drivers/scsi/qla2xxx/qla_target.c
> > +++ b/drivers/scsi/qla2xxx/qla_target.c
> > @@ -1028,8 +1028,7 @@ void qlt_free_session_done(struct work_struct *work)
> >   		}
> >   		if (ha->flags.edif_enabled &&
> > -		    (!own || (own &&
> > -			      own->iocb.u.isp24.status_subcode == ELS_PLOGI))) {
> > +				(own && own->iocb.u.isp24.status_subcode == ELS_PLOGI)) {
> >   			sess->edif.authok = 0;
> >   			if (!ha->flags.host_shutting_down) {
> >   				ql_dbg(ql_dbg_edif, vha, 0x911e,
> 
> It seems like you missed something in the translation. You left of the
> "!own" in your replacement. You are translating (!A || A && B) as (A && B).

Thanks for catching that. My bad. I will correct and send in v2.

Regards,
./drv

> 
> --
> Lee Duncan
> 


