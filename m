Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F77C47069
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 17:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39ACC613DD
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 17:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234877AbhDARpt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:45:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55568 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234608AbhDARiW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 13:38:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617298702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yca0kxerzJI0XjjV2uA9g5GMtSi2AHRJaLJF8A2epeI=;
        b=c7P+bC5iJBog1FA4UbBT2vBgFip8BYD+HVasD+UsCVZw2yqHWPq7ic53CMuYOwiQ9F+t2Y
        2q+GcFhdDpu7BlGyEAxbebexsuieijIur1B/LfQVPcOTs2I/HFBqyRb/VZNF6fP0KNd63N
        wnIbRWjV9xoReKNze8mHdx69+goTNnc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55--ocCDsbiP8WkTl6TbEr-Bw-1; Thu, 01 Apr 2021 08:21:48 -0400
X-MC-Unique: -ocCDsbiP8WkTl6TbEr-Bw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 476C8817469;
        Thu,  1 Apr 2021 12:21:47 +0000 (UTC)
Received: from ovpn-112-207.phx2.redhat.com (ovpn-112-207.phx2.redhat.com [10.3.112.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D366351C3E;
        Thu,  1 Apr 2021 12:21:46 +0000 (UTC)
Message-ID: <8470762d5f9840f7d80389be3f89f7f53989a400.camel@redhat.com>
Subject: Re: [PATCH] scsi_dh_alua: remove check for ASC 24h when
 ILLEGAL_REQUEST returned on RTPG w/extended header
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     dgilbert@interlog.com, linux-scsi@vger.kernel.org
Cc:     hare@suse.de
Date:   Thu, 01 Apr 2021 08:21:46 -0400
In-Reply-To: <2c505c60-9ba0-9ce6-46a6-e6edea2ada03@interlog.com>
References: <20210331201154.20348-1-emilne@redhat.com>
         <2c505c60-9ba0-9ce6-46a6-e6edea2ada03@interlog.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-04-01 at 00:24 -0400, Douglas Gilbert wrote:
> On 2021-03-31 4:11 p.m., Ewan D. Milne wrote:
> > Some arrays return ILLEGAL_REQUEST with ASC 00h if they don't
> > support the
> > extended header, so remove the check for INVALID FIELD IN CDB.
> 
> Wow. Referring to the 18 byte sense buffer as an extended header
> sounds
> like it comes from the transition of SCSI-1 to SCSI-2, about 30 years
> ago.
> Those arrays need to be named and shamed.

Sorry, I was referring to the RTPG command, not the sense header.

        cdb[0] = MAINTENANCE_IN;
        if (!(flags & ALUA_RTPG_EXT_HDR_UNSUPP))
                cdb[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
        else
                cdb[1] = MI_REPORT_TARGET_PGS;

The array returned an error when the MI_EXT_HDR_PARAM_FMT bit was set
but worked fine without it.

It was an older array, it worked with older kernels until we removed
the ability to detach the device handler.  So RTPG needs to work.

-Ewan

> 
> Doug Gilbert
> Hmm, it is April first ...
> 
> > Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> > ---
> >   drivers/scsi/device_handler/scsi_dh_alua.c | 5 +++--
> >   1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> > b/drivers/scsi/device_handler/scsi_dh_alua.c
> > index e42390333c6e..c4c2f23cf79f 100644
> > --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> > +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> > @@ -587,10 +587,11 @@ static int alua_rtpg(struct scsi_device
> > *sdev, struct alua_port_group *pg)
> >   		 * even though it shouldn't according to T10.
> >   		 * The retry without rtpg_ext_hdr_req set
> >   		 * handles this.
> > +		 * Note:  some arrays return a sense key of
> > ILLEGAL_REQUEST
> > +		 * with ASC 00h if they don't support the extended
> > header.
> >   		 */
> >   		if (!(pg->flags & ALUA_RTPG_EXT_HDR_UNSUPP) &&
> > -		    sense_hdr.sense_key == ILLEGAL_REQUEST &&
> > -		    sense_hdr.asc == 0x24 && sense_hdr.ascq == 0) {
> > +		    sense_hdr.sense_key == ILLEGAL_REQUEST) {
> >   			pg->flags |= ALUA_RTPG_EXT_HDR_UNSUPP;
> >   			goto retry;
> >   		}
> > 
> 
> 

