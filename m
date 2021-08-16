Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D310C4320A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 22:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2128960ED5
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 22:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbhHPWsj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 18:48:39 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:57362 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbhHPWsh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2021 18:48:37 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3464D21F2C;
        Mon, 16 Aug 2021 22:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629154084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iUDoSjD21Wo46dLqKEtbrIGFQxELmntK3ngcczK6cnM=;
        b=XoPZs16Oc2XomAQxwMLRMl8hL1bCeluimdE+KGp/qTpeQSrwMCPWf/1YXZqg1PQclegtKw
        bGLkJIINBqNAGFM+lOgOP1v8VpfA1B9rJZmVlSGZs/b8gc5bgaQreXywdcRhzkxhHuKwkb
        NE0qt+iPZK37MXFY+BdT20ij4+6d45M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629154084;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iUDoSjD21Wo46dLqKEtbrIGFQxELmntK3ngcczK6cnM=;
        b=WAkYtzv0sIkcFH0+t1+1g/kDvYJtUKRqWMhXwuYa0XedkEk7EAtIZzG7BsNzz6KuSODYlt
        zX4k8VNzdkrLD8DQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id C984513BD1;
        Mon, 16 Aug 2021 22:48:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id SuQqLyPrGmGdHwAAGKfGzw
        (envelope-from <ddiss@suse.de>); Mon, 16 Aug 2021 22:48:03 +0000
Date:   Tue, 17 Aug 2021 00:48:02 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     Sergey Samoylenko <s.samoylenko@yadro.com>
Cc:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        "Konstantin Shelekhin" <k.shelekhin@yadro.com>,
        Dmitriy Bogdanov <d.bogdanov@yadro.com>,
        Anastasia Kovaleva <a.kovaleva@yadro.com>
Subject: Re: [PATCH 1/1] scsi: target: core: Add 8Fh VPD page
Message-ID: <20210817004802.17af2832@suse.de>
In-Reply-To: <741b4c6f78484591a57cbdb3bd64c924@yadro.com>
References: <20210729201943.40222-1-s.samoylenko@yadro.com>
        <20210729201943.40222-2-s.samoylenko@yadro.com>
        <20210813165255.650257ce@suse.de>
        <741b4c6f78484591a57cbdb3bd64c924@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 16 Aug 2021 18:16:45 +0000, Sergey Samoylenko wrote:

> Hi David,
> 
> > Hi Sergey,
> >
> > On Thu, 29 Jul 2021 23:19:43 +0300, Sergey Samoylenko wrote:
> >  
> >> The 8Fh VPD page announces the capabilities supported by
> >> the TCM XCOPY manager. It helps to expand the coverage of
> >> the third-party copy manager with SCSI testing utilities.  
> >
> > Please list which initiators use this VPD page, if you know of any.  
> I know that the ESXi 7.0 requests the 8Fh VPD page.

Thanks. Please put this in the commit message.

> ESXi is one of
> a few initiators who is using the XCOPY commands (vmkfstools tool).
> 
> > Also, is there any test coverage for this? I don't see anything in
> > libiscsi...  
> After activating XCOPY in a target we got an error from
> the SCSI.ReceiveCopyResults.CopyStatus test in the libiscsi.
> Discussing with Bart, we decided to implement the 8Fh VPD page
> for announcing TCM XCOPY features.
> It is here: https://github.com/sahlberg/libiscsi/pull/353
> 
> The libiscsi has an initial version for parsing 8Fh VPD. This is used
> in the SCSI.ReceiveCopyResults.CopyStatus test. It is a good idea
> to add test coverage for 8Fh VPD in libiscsi. I should do this.
> 
> >  
> >> Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
> >> Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> >> Reviewed-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
> >> Signed-off-by: Sergey Samoylenko <s.samoylenko@yadro.com>
> >> ---
> >>  drivers/target/target_core_spc.c | 230 ++++++++++++++++++++++++++++++-
> >>  1 file changed, 226 insertions(+), 4 deletions(-)
> >> 
> >> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> >> index 22703a0dbd07..169341712b10 100644
> >> --- a/drivers/target/target_core_spc.c
> >> +++ b/drivers/target/target_core_spc.c  
> > ...  
> >> +/* Third-party Copy VPD page */
> >> +static sense_reason_t
> >> +spc_emulate_evpd_8f(struct se_cmd *cmd, unsigned char *buf)
> >> +{
> >> +	struct se_device *dev = cmd->se_dev;
> >> +	int off;
> >> +	u16 page_len;
> >> +
> >> +	if (!dev->dev_attrib.emulate_3pc)
> >> +		return TCM_INVALID_CDB_FIELD;
> >> +
> >> +	/*
> >> +	 * Since the Third-party copy manager in TCM is quite simple
> >> +	 * and supports only two commands, the function sets
> >> +	 * many descriptor parameters as constants.
> >> +	 *
> >> +	 * As the Copy manager supports the EXTENDED COPY(LID1) command,
> >> +	 * the Third-party Copy VPD page should include five mandatory
> >> +	 * Third-party copy descriptors. Its are:
> >> +	 *   0001h - Supported Commands
> >> +	 *   0004h - Parameter Data
> >> +	 *   0008h - Supported Descriptors
> >> +	 *   000Ch - Supported CSCD Descriptor IDs
> >> +	 *   8001h - General Copy Operations
> >> +	 *
> >> +	 * See spc4 section 7.8.17
> >> +	 */
> >> +
> >> +	off = 4;
> >> +
> >> +	/* fill descriptors */
> >> +	off += spc_evpd_8f_encode_supp_cmds(&buf[off]);
> >> +	off += spc_evpd_8f_encode_param_data(&buf[off]);
> >> +	off += spc_evpd_8f_encode_supp_descrs(&buf[off]);
> >> +	off += spc_evpd_8f_encode_supp_cscd_descr_id(&buf[off]);
> >> +	off += spc_evpd_8f_encode_general_copy_ops(&buf[off]);  
> >
> > This looks risky in terms of buf overrun. I think it'd be good to pass
> > a @remaining or @buf_end param to these helper functions.  
> 
> I thought about it, but spc_emulate_evpd_XX functions have a prototype:
> 	sense_reason_t	(*emulate)(struct se_cmd *, unsigned char *);
> and they don't know anything about buffer length. I can use the
> "SE_INQUIRY_BUF" definition, but I don't like this solution.
> 	
> We can change the prototype of spc_emulate_evpd_XX functions, like:
> 	static struct {
> 		uint8_t page;
> 		sense_reason_t	(*emulate)(struct se_cmd *, unsigned char *buf, size_t len);
> 	} evpd_handlers[] = {
> 		...
> 	};
> and return the TCM_OUT_OF_RESOURCES if we try to overrun buffer
> in spc_emulate_evpd_XX. But this will require changing all "emulate_evpd" functions.
> 
> David, what do you think of this?

Ideally inquiry and mode sense handlers, not to mention the configfs
callbacks, would all carry explicit bounds checks. As a start I'd be
fine with buflen=SE_INQUIRY_BUF at the top of spc_emulate_evpd_8f(), but
any further steps towards doing it properly would be helpful IMO.

Cheers, David
