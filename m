Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BDBC4320A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 22:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 593B6601FA
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 22:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbhHPWBK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 18:01:10 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:54250 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbhHPWBJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2021 18:01:09 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A881B21F27;
        Mon, 16 Aug 2021 22:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629151236; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Vxbun15x51wYaRLadmm9SobnNAu7hXYmM21vcMA3us=;
        b=gO0btI5CHcpIUeepD3I9S9fQTPgZEdjfPBJxX43GxbbbNZi/wo02chgpSUCc1a4XRDYxaD
        jaext7ygWu7W6+eIPVwUa1p0MiZ8l3iGg5BZw1qvMcUoMVuxduPnhEGSKCGkI/o3WdJ9Vw
        hRLy3QjFU+ih1qrMmgEjmzYa85iA8Fs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629151236;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Vxbun15x51wYaRLadmm9SobnNAu7hXYmM21vcMA3us=;
        b=adlpBXKNVNylqqVpfqF+rV0Ho8T10p+RSrFAt9g0FVIomYwuGDxmXiaYr4ixFRkFBTcGB7
        /VGzXh6tDxaQKLAA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 4139813B95;
        Mon, 16 Aug 2021 22:00:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id JzPWDQTgGmF+GQAAGKfGzw
        (envelope-from <ddiss@suse.de>); Mon, 16 Aug 2021 22:00:36 +0000
Date:   Tue, 17 Aug 2021 00:00:35 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     Sergey Samoylenko <s.samoylenko@yadro.com>,
        <martin.petersen@oracle.com>, <michael.christie@oracle.com>,
        <bvanassche@acm.org>, <target-devel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Anastasia Kovaleva <a.kovaleva@yadro.com>
Subject: Re: [PATCH 1/1] scsi: target: core: Add 8Fh VPD page
Message-ID: <20210817000035.7a514c50@suse.de>
In-Reply-To: <YRqq50h81kYFFHki@SPB-NB-133.local>
References: <20210729201943.40222-1-s.samoylenko@yadro.com>
        <20210729201943.40222-2-s.samoylenko@yadro.com>
        <20210813165255.650257ce@suse.de>
        <YRqq50h81kYFFHki@SPB-NB-133.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 16 Aug 2021 21:13:59 +0300, Roman Bolshakov wrote:

> On Fri, Aug 13, 2021 at 04:52:55PM +0200, David Disseldorp wrote:
> > Hi Sergey,
> > 
> > On Thu, 29 Jul 2021 23:19:43 +0300, Sergey Samoylenko wrote:
> >   
> > > The 8Fh VPD page announces the capabilities supported by
> > > the TCM XCOPY manager. It helps to expand the coverage of
> > > the third-party copy manager with SCSI testing utilities.  
> > 
> > Please list which initiators use this VPD page, if you know of any.
> > Also, is there any test coverage for this? I don't see anything in
> > libiscsi...
> >   
> 
> Hi David,
> 
> ESXi is one of the hosts that inspects Third Party Copy VPD Page.
> Windows detects ODX support using the page [1][2].

Thanks for the links. I haven't seen ESXi attempt to use it, but also
haven't checked for some time. It'd be good to get some of this
information in the commit message.

> The page is also used by libiscsi to detect presence and features of
> copy manager as was agreed with Bart in the PR [3]:

I'm probably missing something, but why wasn't the 3PC flag in the
standard inquiry page an option for this check?

> "Implementing REPORT SUPPORTED OPERATION CODES in LIO would require more
> work than implementing the third-party copy VPD page.
> 
> I'm fine with relying on the third-party copy VPD page, or in other
> words, to skip the copy offloading tests if that page is not supported.
> 
> There are plans to implement XCOPY support in the Linux kernel sd
> driver. If nobody else volunteers I plan to work on this myself. I'm
> considering to only support SCSI targets that support the third-party
> copy VPD page. Or in other words, we will need support for that VPD page
> anyway."

Okay, fair enough.

> 
> 1. https://www.slideshare.net/CalvinChen5/a-joint-effort-of-the-storage-industry
> 2. http://sg.danny.cz/sg/ddpt_xcopy_odx.html
> 3. https://github.com/sahlberg/libiscsi/pull/353
> 
> > > Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
> > > Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> > > Reviewed-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
> > > Signed-off-by: Sergey Samoylenko <s.samoylenko@yadro.com>
> > > ---
> > >  drivers/target/target_core_spc.c | 230 ++++++++++++++++++++++++++++++-
> > >  1 file changed, 226 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> > > index 22703a0dbd07..169341712b10 100644
> > > --- a/drivers/target/target_core_spc.c
> > > +++ b/drivers/target/target_core_spc.c  
> > ...  
> > > +/* Third-party Copy VPD page */
> > > +static sense_reason_t
> > > +spc_emulate_evpd_8f(struct se_cmd *cmd, unsigned char *buf)
> > > +{
> > > +	struct se_device *dev = cmd->se_dev;
> > > +	int off;
> > > +	u16 page_len;
> > > +
> > > +	if (!dev->dev_attrib.emulate_3pc)
> > > +		return TCM_INVALID_CDB_FIELD;
> > > +
> > > +	/*
> > > +	 * Since the Third-party copy manager in TCM is quite simple
> > > +	 * and supports only two commands, the function sets
> > > +	 * many descriptor parameters as constants.
> > > +	 *
> > > +	 * As the Copy manager supports the EXTENDED COPY(LID1) command,
> > > +	 * the Third-party Copy VPD page should include five mandatory
> > > +	 * Third-party copy descriptors. Its are:
> > > +	 *   0001h - Supported Commands
> > > +	 *   0004h - Parameter Data
> > > +	 *   0008h - Supported Descriptors
> > > +	 *   000Ch - Supported CSCD Descriptor IDs
> > > +	 *   8001h - General Copy Operations
> > > +	 *
> > > +	 * See spc4 section 7.8.17
> > > +	 */
> > > +
> > > +	off = 4;
> > > +
> > > +	/* fill descriptors */
> > > +	off += spc_evpd_8f_encode_supp_cmds(&buf[off]);
> > > +	off += spc_evpd_8f_encode_param_data(&buf[off]);
> > > +	off += spc_evpd_8f_encode_supp_descrs(&buf[off]);
> > > +	off += spc_evpd_8f_encode_supp_cscd_descr_id(&buf[off]);
> > > +	off += spc_evpd_8f_encode_general_copy_ops(&buf[off]);  
> > 
> > This looks risky in terms of buf overrun. I think it'd be good to pass
> > a @remaining or @buf_end param to these helper functions.
> >   
> 
> It's doable but would require to change the signature of all existing
> VPD handlers. SE_INQUIRY_BUF is hardcoded to 1kb but it's also capped by
> EDTL to avoid buffer overruns:
> 
>   memcpy(rbuf, buf, min_t(u32, SE_INQUIRY_BUF, cmd->data_length));

That's checking the amount copied into the response buffer. My concern
is the prior writes to the staging buf.

Cheers, David
