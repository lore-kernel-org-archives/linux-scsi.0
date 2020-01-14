Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD64C33C9E
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 18:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65682214AF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 18:13:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TWyJei7H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgANSNM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 13:13:12 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20091 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726450AbgANSNL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jan 2020 13:13:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579025590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=llgkamWBgOzQ4okqqZYQrjZITNl9Tjy/xx/bhr3JEbs=;
        b=TWyJei7HtXtrNLGJVu6fMf4jW4tCoNwq8fu4DzfwGcVuJ2T6oiTsOBTxJo0tBWrefUHmN5
        Tz4hZpo9jpw/ZtAywJsDf7wdZm27Yymwf62RWk0GGhrqVd3COZrUz58HaVGGKijLS+Tbdx
        5lnzJHNVjeHf/w+TToaWm6eS5gpxEOI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-Hd3T0vvIPZODXrwJw5X9uw-1; Tue, 14 Jan 2020 13:13:06 -0500
X-MC-Unique: Hd3T0vvIPZODXrwJw5X9uw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56916801E72;
        Tue, 14 Jan 2020 18:13:05 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6116160BF4;
        Tue, 14 Jan 2020 18:13:04 +0000 (UTC)
Message-ID: <c2baf21f60daf91593bc4a7088427257434e2040.camel@redhat.com>
Subject: Re: [PATCH] qla2xxx: Fix a NULL pointer dereference in an error path
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Date:   Tue, 14 Jan 2020 13:13:03 -0500
In-Reply-To: <086f02b8-b8d8-5336-bf2c-031293d95890@acm.org>
References: <20200112210846.13421-1-bvanassche@acm.org>
         <0e0883b1a887cbd7b67f85be61aca270107441ef.camel@redhat.com>
         <086f02b8-b8d8-5336-bf2c-031293d95890@acm.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-01-13 at 08:11 -0800, Bart Van Assche wrote:
> On 1/13/20 7:29 AM, Ewan D. Milne wrote:
> > On Sun, 2020-01-12 at 13:08 -0800, Bart Van Assche wrote:
> > > diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> > > index c4e087217484..6560908ed50e 100644
> > > --- a/drivers/scsi/qla2xxx/qla_init.c
> > > +++ b/drivers/scsi/qla2xxx/qla_init.c
> > > @@ -4895,6 +4895,8 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
> > >   void
> > >   qla2x00_free_fcport(fc_port_t *fcport)
> > >   {
> > > +	if (!fcport)
> > > +		return;
> > >   	if (fcport->ct_desc.ct_sns) {
> > >   		dma_free_coherent(&fcport->vha->hw->pdev->dev,
> > >   			sizeof(struct ct_sns_pkt), fcport->ct_desc.ct_sns,
> > > 
> > 
> > I would have fixed this by moving the label to be after the qla2x00_free_fcport()
> > call in qla2x00_configure_local_loop(), which Coverity complained about.  And
> > called it something different.  (The code could probably be simplified by only
> > making a call to qla2x00_alloc_fcport() in one place, something to think about...)
> 
> Hi Ewan,
> 
> I have considered the solution that you proposed. The solution shown 
> above was chosen because I did not want to introduce any memory leaks in 
> qla2x00_configure_local_loop(). There is a "goto cleanup_allocation" 
> statement in that function that occurs after the "new_fcport = 
> qla2x00_alloc_fcport(vha, GFP_KERNEL)" assignment. That is hard to 
> notice because the qla2x00_configure_local_loop() function is so long.
> 

Yes, but isn't that after "if (new_fcport == NULL)" where the code has
put the previously allocated fcport into the &vha->vp_fcports list and
was unable to allocate another one?

-Ewan

