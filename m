Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A99AC32771
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Sep 2022 17:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiIZRJu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 13:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiIZRJ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 13:09:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1480B43331
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 09:17:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A411860F6A
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 16:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B807DC433D7;
        Mon, 26 Sep 2022 16:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664209049;
        bh=m48pdNyU2JjpdUQGMzDilDnMtcQenf+EfdfAWQK8Z/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gQfvyLY5smJ/Hxg0CEDPSbmYr0KIdFqFfnlcG1/pKJW0Ic0+vLeaSbhM4gfpdZ9AN
         pjUjumcO19QxWsAYtcwt/3dS0+wyIKhv8eTHuoCuOve4C0xqMGCsJVvV02Znwlb2pE
         P16gFEKQ7rnq3v+EccTtkWOpkTAJ6XPpZkWaSvZg=
Date:   Mon, 26 Sep 2022 18:17:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lee Duncan <lduncan@suse.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi@vger.kernel.org, hdthky <hdthky0@gmail.com>,
        stable <stable@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2] scsi: stex: properly zero out the passthrough command
 structure
Message-ID: <YzHQllbrv5zxexYD@kroah.com>
References: <20220908145154.2284098-1-gregkh@linuxfoundation.org>
 <YxrjN3OOw2HHl9tx@kroah.com>
 <fd6a94cd-6d71-f241-fc7b-d8613c1c2616@acm.org>
 <6ee86af6-6a0d-4c8d-439d-0ea58dc7c743@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6ee86af6-6a0d-4c8d-439d-0ea58dc7c743@suse.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 26, 2022 at 08:54:24AM -0700, Lee Duncan wrote:
> On 9/9/22 09:24, Bart Van Assche wrote:
> > On 9/8/22 23:54, Greg Kroah-Hartman wrote:
> > > From: Linus Torvalds <torvalds@linux-foundation.org>
> > > 
> > > The passthrough structure is declared off of the stack, so it needs to
> > > be set to zero before copied back to userspace to prevent any
> > > unintentional data leakage.  Switch things to be statically allocated
> > > which will fill the unused fields with 0 automatically.
> > > 
> > > Reported-by: hdthky <hdthky0@gmail.com>
> > > Cc: stable <stable@kernel.org>
> > > Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> > > Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> > > Cc: Dan Carpenter <dan.carpenter@oracle.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >   v2: Linus's updated version that moves the initialization to be
> > >       statically defined and changes the function prototype and structure
> > >       to be const.
> > > 
> > >   drivers/scsi/stex.c      | 17 +++++++++--------
> > >   include/scsi/scsi_cmnd.h |  2 +-
> > >   2 files changed, 10 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> > > index e6420f2127ce..8def242675ef 100644
> > > --- a/drivers/scsi/stex.c
> > > +++ b/drivers/scsi/stex.c
> > > @@ -665,16 +665,17 @@ static int stex_queuecommand_lck(struct
> > > scsi_cmnd *cmd)
> > >           return 0;
> > >       case PASSTHRU_CMD:
> > >           if (cmd->cmnd[1] == PASSTHRU_GET_DRVVER) {
> > > -            struct st_drvver ver;
> > > +            const struct st_drvver ver = {
> > > +                .major = ST_VER_MAJOR,
> > > +                .minor = ST_VER_MINOR,
> > > +                .oem = ST_OEM,
> > > +                .build = ST_BUILD_VER,
> > > +                .signature[0] = PASSTHRU_SIGNATURE,
> > > +                .console_id = host->max_id - 1,
> > > +                .host_no = hba->host->host_no,
> > > +            };
> > >               size_t cp_len = sizeof(ver);
> > > -            ver.major = ST_VER_MAJOR;
> > > -            ver.minor = ST_VER_MINOR;
> > > -            ver.oem = ST_OEM;
> > > -            ver.build = ST_BUILD_VER;
> > > -            ver.signature[0] = PASSTHRU_SIGNATURE;
> > > -            ver.console_id = host->max_id - 1;
> > > -            ver.host_no = hba->host->host_no;
> > >               cp_len = scsi_sg_copy_from_buffer(cmd, &ver, cp_len);
> > >               if (sizeof(ver) == cp_len)
> > >                   cmd->result = DID_OK << 16;
> > > diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> > > index bac55decf900..7d3622db38ed 100644
> > > --- a/include/scsi/scsi_cmnd.h
> > > +++ b/include/scsi/scsi_cmnd.h
> > > @@ -201,7 +201,7 @@ static inline unsigned int scsi_get_resid(struct
> > > scsi_cmnd *cmd)
> > >       for_each_sg(scsi_sglist(cmd), sg, nseg, __i)
> > >   static inline int scsi_sg_copy_from_buffer(struct scsi_cmnd *cmd,
> > > -                       void *buf, int buflen)
> > > +                       const void *buf, int buflen)
> > >   {
> > >       return sg_copy_from_buffer(scsi_sglist(cmd), scsi_sg_count(cmd),
> > >                      buf, buflen);
> > 
> > Please split this patch into one patch for the SCSI core and another patch
> > for the STEX driver.
> > 
> > Thanks,
> > 
> > Bart.
> 
> Ping? Is this patch going to stand as is, or are we going to get a V3 that
> addresses Bart's request?

I'll try to do a v3 when I get a chance later this week.

thanks,

greg k-h
