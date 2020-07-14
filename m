Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8902C433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 07:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC585208FE
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 07:53:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qfb2C0sd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgGNHxl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 03:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgGNHxk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 03:53:40 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D007C061794
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2020 00:53:40 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id o11so20180732wrv.9
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2020 00:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=CkqZPlj61ah7xjZ/9xP5LZTgLtyHaYvcc0sKoNZrcnk=;
        b=qfb2C0sdEhIxpGnb0IPQ2mnsaDiyM65qorjCXzs1CUlCv9ZBXXe8yfUdiE+Ii5q0lW
         d6CmhfKoUiTSaGRJZ7pFP6Cv8VnjWijuH5hevqltqQOyI2QT4FIQsW0GeYLOwGMb3Saw
         1B0BTWOrNUYL9dWV3hV6i2B1ij68ApO5wRcdEhGzsX1/WHE6tAQCS4LhIAWFNKARUp9Z
         d8jfyP5wDifgUeY0IaHQb5u5N1CrfCmMB3I2rNgjypsG3oJdoKNY5cBPg9fgA2vnmKM7
         jI6zoY0C13jzO8PqfPZlKWPkgYCSflMTzt62D6U7GxzVpMUTLDhIcf1U5SVXu9hq146W
         v2kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=CkqZPlj61ah7xjZ/9xP5LZTgLtyHaYvcc0sKoNZrcnk=;
        b=TJqf2vuOFpVE9Z1bYob1febcumo6HQoP+mgWrcjX02LaBQbvgbVKk7C+k+BjzAgK9A
         cynl9YLaOiKa8qmvYJPQXpbku2r38YqvEy5ZtKdnax/jvmT0hch/BTfAOscyEhGsqjje
         8xHFL4l3jJLJ3Q/ZsYzfLja2GysU2lvHHDKQVvVLjbq4qAaXDH50PBN6L2/Hb81S77wO
         XpCrsc57AqUjjNT1kodR4z9bMjb9scKrZOkSb4b7lJdsf3gy2ugxg/pvAoCdeZk730m4
         0Jp9KhObaYjvdPeqEHA4ebDKFsMADVhBYXMfhchiVLqWvf7I7R2Loz32GvQnparxPvz7
         Ev4Q==
X-Gm-Message-State: AOAM5313XMjHK73MMcnwdF0HKOTSgXuk/RS+SPuiMH7BaXUnvFXHuiv2
        k2r5GOzOnnwq7vXzLoOaFW0Rpg==
X-Google-Smtp-Source: ABdhPJwueUUQpbwYp7wZ5rVMiFAn8/9F0eTI+50kkesgB+aVQ4+u4gsdoBWNvLZvZLjPXmHla+NV7g==
X-Received: by 2002:adf:f0c5:: with SMTP id x5mr3705836wro.396.1594713218918;
        Tue, 14 Jul 2020 00:53:38 -0700 (PDT)
Received: from dell ([2.31.163.61])
        by smtp.gmail.com with ESMTPSA id p29sm3171600wmi.43.2020.07.14.00.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 00:53:38 -0700 (PDT)
Date:   Tue, 14 Jul 2020 08:53:36 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Hannes Reinecke <mail@hannes-reinecke.de>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 05/29] scsi: fcoe: fcoe_ctlr: Fix a myriad of
 documentation issues
Message-ID: <20200714075336.GH3500@dell>
References: <20200713074645.126138-1-lee.jones@linaro.org>
 <20200713074645.126138-6-lee.jones@linaro.org>
 <975ab8d4-eedc-c763-c2c6-436344395fb8@hannes-reinecke.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <975ab8d4-eedc-c763-c2c6-436344395fb8@hannes-reinecke.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 14 Jul 2020, Hannes Reinecke wrote:

> On 7/13/20 9:46 AM, Lee Jones wrote:
> > Mostly missing or incorrect (bitrotted) function parameters.
> > 
> > Fixes the following W=1 kernel build warning(s):
> > 
> >   drivers/scsi/fcoe/fcoe_ctlr.c:139: warning: Function parameter or member 'mode' not described in 'fcoe_ctlr_init'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:604: warning: Function parameter or member 'lport' not described in 'fcoe_ctlr_encaps'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:1312: warning: Function parameter or member 'skb' not described in 'fcoe_ctlr_recv_clr_vlink'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:1312: warning: Excess function parameter 'fh' description in 'fcoe_ctlr_recv_clr_vlink'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:1781: warning: Function parameter or member 't' not described in 'fcoe_ctlr_timeout'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:1781: warning: Excess function parameter 'arg' description in 'fcoe_ctlr_timeout'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:1904: warning: Function parameter or member 'lport' not described in 'fcoe_ctlr_recv_flogi'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:2166: warning: Function parameter or member 'lport' not described in 'fcoe_ctlr_disc_stop_locked'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:2166: warning: Excess function parameter 'fip' description in 'fcoe_ctlr_disc_stop_locked'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:2188: warning: Function parameter or member 'lport' not described in 'fcoe_ctlr_disc_stop'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:2188: warning: Excess function parameter 'fip' description in 'fcoe_ctlr_disc_stop'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:2204: warning: Function parameter or member 'lport' not described in 'fcoe_ctlr_disc_stop_final'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:2204: warning: Excess function parameter 'fip' description in 'fcoe_ctlr_disc_stop_final'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:2273: warning: Function parameter or member 'frport' not described in 'fcoe_ctlr_vn_parse'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:2273: warning: Excess function parameter 'rdata' description in 'fcoe_ctlr_vn_parse'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:2804: warning: Function parameter or member 'frport' not described in 'fcoe_ctlr_vlan_parse'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:2804: warning: Excess function parameter 'rdata' description in 'fcoe_ctlr_vlan_parse'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:2900: warning: Excess function parameter 'min_len' description in 'fcoe_ctlr_vlan_send'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:2977: warning: Function parameter or member 'fip' not described in 'fcoe_ctlr_vlan_recv'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:2977: warning: Function parameter or member 'skb' not described in 'fcoe_ctlr_vlan_recv'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:2977: warning: Excess function parameter 'lport' description in 'fcoe_ctlr_vlan_recv'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:2977: warning: Excess function parameter 'fp' description in 'fcoe_ctlr_vlan_recv'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:3033: warning: Function parameter or member 'callback' not described in 'fcoe_ctlr_disc_start'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:3033: warning: Function parameter or member 'lport' not described in 'fcoe_ctlr_disc_start'
> >   drivers/scsi/fcoe/fcoe_ctlr.c:3033: warning: Excess function parameter 'fip' description in 'fcoe_ctlr_disc_start'
> > 
> > Cc: Hannes Reinecke <hare@suse.de>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >   drivers/scsi/fcoe/fcoe_ctlr.c | 26 +++++++++++++-------------
> >   1 file changed, 13 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
> > index 1791a393795da..99242f9856708 100644
> > --- a/drivers/scsi/fcoe/fcoe_ctlr.c
> > +++ b/drivers/scsi/fcoe/fcoe_ctlr.c
> > @@ -134,6 +134,7 @@ static void fcoe_ctlr_map_dest(struct fcoe_ctlr *fip)
> >   /**
> >    * fcoe_ctlr_init() - Initialize the FCoE Controller instance
> >    * @fip: The FCoE controller to initialize
> > + * @mode: FIP mode to set
> >    */
> >   void fcoe_ctlr_init(struct fcoe_ctlr *fip, enum fip_mode mode)
> >   {
> > @@ -587,6 +588,7 @@ static void fcoe_ctlr_send_keep_alive(struct fcoe_ctlr *fip,
> >   /**
> >    * fcoe_ctlr_encaps() - Encapsulate an ELS frame for FIP, without sending it
> >    * @fip:   The FCoE controller for the ELS frame
> > + * @lport: The local port
> >    * @dtype: The FIP descriptor type for the frame
> >    * @skb:   The FCoE ELS frame including FC header but no FCoE headers
> >    * @d_id:  The destination port ID.
> > @@ -1302,7 +1304,7 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
> >   /**
> >    * fcoe_ctlr_recv_els() - Handle an incoming link reset frame
> >    * @fip: The FCoE controller that received the frame
> > - * @fh:	 The received FIP header
> > + * @skb: The received FIP packet
> >    *
> >    * There may be multiple VN_Port descriptors.
> >    * The overall length has already been checked.
> > @@ -1775,7 +1777,7 @@ static void fcoe_ctlr_flogi_send(struct fcoe_ctlr *fip)
> >   /**
> >    * fcoe_ctlr_timeout() - FIP timeout handler
> > - * @arg: The FCoE controller that timed out
> > + * @t: Timer context use to obtain the controller reference
> >    */
> >   static void fcoe_ctlr_timeout(struct timer_list *t)
> >   {
> > @@ -1887,6 +1889,7 @@ static void fcoe_ctlr_recv_work(struct work_struct *recv_work)
> >   /**
> >    * fcoe_ctlr_recv_flogi() - Snoop pre-FIP receipt of FLOGI response
> >    * @fip: The FCoE controller
> > + * @lport: The local port
> >    * @fp:	 The FC frame to snoop
> >    *
> >    * Snoop potential response to FLOGI or even incoming FLOGI.
> > @@ -2158,7 +2161,7 @@ static struct fc_rport_operations fcoe_ctlr_vn_rport_ops = {
> >   /**
> >    * fcoe_ctlr_disc_stop_locked() - stop discovery in VN2VN mode
> > - * @fip: The FCoE controller
> > + * @lport: The local port
> >    *
> >    * Called with ctlr_mutex held.
> >    */
> > @@ -2179,7 +2182,7 @@ static void fcoe_ctlr_disc_stop_locked(struct fc_lport *lport)
> >   /**
> >    * fcoe_ctlr_disc_stop() - stop discovery in VN2VN mode
> > - * @fip: The FCoE controller
> > + * @lport: The local port
> >    *
> >    * Called through the local port template for discovery.
> >    * Called without the ctlr_mutex held.
> > @@ -2195,7 +2198,7 @@ static void fcoe_ctlr_disc_stop(struct fc_lport *lport)
> >   /**
> >    * fcoe_ctlr_disc_stop_final() - stop discovery for shutdown in VN2VN mode
> > - * @fip: The FCoE controller
> > + * @lport: The local port
> >    *
> >    * Called through the local port template for discovery.
> >    * Called without the ctlr_mutex held.
> > @@ -2262,7 +2265,7 @@ static void fcoe_ctlr_vn_start(struct fcoe_ctlr *fip)
> >    * fcoe_ctlr_vn_parse - parse probe request or response
> >    * @fip: The FCoE controller
> >    * @skb: incoming packet
> > - * @rdata: buffer for resulting parsed VN entry plus fcoe_rport
> > + * @frport: parsed FCoE rport from the probe request
> >    *
> >    * Returns non-zero error number on error.
> >    * Does not consume the packet.
> > @@ -2793,7 +2796,7 @@ static int fcoe_ctlr_vn_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
> >    * fcoe_ctlr_vlan_parse - parse vlan discovery request or response
> >    * @fip: The FCoE controller
> >    * @skb: incoming packet
> > - * @rdata: buffer for resulting parsed VLAN entry plus fcoe_rport
> > + * @frport: parsed FCoE rport from the probe request
> >    *
> >    * Returns non-zero error number on error.
> >    * Does not consume the packet.
> > @@ -2892,7 +2895,6 @@ static int fcoe_ctlr_vlan_parse(struct fcoe_ctlr *fip,
> >    * @fip: The FCoE controller
> >    * @sub: sub-opcode for vlan notification or vn2vn vlan notification
> >    * @dest: The destination Ethernet MAC address
> > - * @min_len: minimum size of the Ethernet payload to be sent
> >    */
> >   static void fcoe_ctlr_vlan_send(struct fcoe_ctlr *fip,
> >   			      enum fip_vlan_subcode sub,
> > @@ -2969,9 +2971,8 @@ static void fcoe_ctlr_vlan_disc_reply(struct fcoe_ctlr *fip,
> >   /**
> >    * fcoe_ctlr_vlan_recv - vlan request receive handler for VN2VN mode.
> > - * @lport: The local port
> > - * @fp: The received frame
> > - *
> > + * @fip: The FCoE controller
> > + * @skb: The received FIP packet
> >    */
> >   static int fcoe_ctlr_vlan_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
> >   {
> > @@ -3015,9 +3016,8 @@ static void fcoe_ctlr_disc_recv(struct fc_lport *lport, struct fc_frame *fp)
> >   	fc_frame_free(fp);
> >   }
> > -/**
> > +/*
> >    * fcoe_ctlr_disc_recv - start discovery for VN2VN mode.
> > - * @fip: The FCoE controller
> >    *
> >    * This sets a flag indicating that remote ports should be created
> >    * and started for the peers we discover.  We use the disc_callback
> > 
> Please, this should continue to be a kernel-doc comment; my copy still has
> this header:
> 
> /**
>  * fcoe_ctlr_disc_recv - discovery receive handler for VN2VN mode.
>  * @lport: The local port
>  * @fp: The received frame
>  *
> 
> What happened to it?

Look at the function below it (in your local copy). ;)

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
