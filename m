Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F762CDB482
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 15:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbjJQPNG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234808AbjJQPNF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 11:13:05 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F38E92
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 08:13:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AC4481F88C;
        Tue, 17 Oct 2023 15:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1697555582; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XxPMFQcv1ubK5VbD9uIyT1StmlBky0xLsiobbxqCjZ0=;
        b=tVImC0/z2c+ak60wTXlpxZuhaAKkZoc5j9oS2EXfLazsk2M/nXcY+NHHZODpcbN8MLUiv0
        SJ9Ijye6Xae7c604V0xgev4gsrc+2yWWUzL7jlOHzD5lpSaXnW6DqdgdEKdys0e7+PLSeM
        bdoTQWQswRvM+Fp3iNWRmR3xX3NOpkM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1697555582;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XxPMFQcv1ubK5VbD9uIyT1StmlBky0xLsiobbxqCjZ0=;
        b=I94rCA3DjZUuJLOe3mowQDzcN/M2AbS4XuNqpcasPOV8KRbGa8aSu1NbkjRDQGV4D2qayd
        wgVSvSnx3h4RKKAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8E5F413597;
        Tue, 17 Oct 2023 15:13:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hnoEIn6kLmWJMQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 17 Oct 2023 15:13:02 +0000
Message-ID: <d3fe813b-eec7-4ef9-8ca0-49e656e65a6c@suse.de>
Date:   Tue, 17 Oct 2023 17:12:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] scsi: message: fusion: Open-code
 mptfc_block_error_handler() for bus reset
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
References: <b684093c-7c05-49cc-b6f7-e3322fecbbfc@moroto.mountain>
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <b684093c-7c05-49cc-b6f7-e3322fecbbfc@moroto.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp-out2.suse.de;
        none
X-Spamd-Result: default: False [-6.91 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         XM_UA_NO_VERSION(0.01)[];
         FROM_HAS_DN(0.00)[];
         RCPT_COUNT_THREE(0.00)[3];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         BAYES_HAM(-2.82)[99.24%];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/17/23 15:18, Dan Carpenter wrote:
> Hello Hannes Reinecke,
> 
> The patch 17865dc2eccc: "scsi: message: fusion: Open-code
> mptfc_block_error_handler() for bus reset" from Oct 2, 2023
> (linux-next), leads to the following Smatch static checker warning:
> 
> 	drivers/message/fusion/mptfc.c:281 mptfc_bus_reset()
> 	error: uninitialized symbol 'rtn'.
> 
> drivers/message/fusion/mptfc.c
>      261 static int
>      262 mptfc_bus_reset(struct scsi_cmnd *SCpnt)
>      263 {
>      264         struct Scsi_Host *shost = SCpnt->device->host;
>      265         MPT_SCSI_HOST __maybe_unused *hd = shost_priv(shost);
>      266         int channel = SCpnt->device->channel;
>      267         struct mptfc_rport_info *ri;
>      268         int rtn;
>      269
>      270         list_for_each_entry(ri, &hd->ioc->fc_rports, list) {
>      271                 if (ri->flags & MPT_RPORT_INFO_FLAGS_REGISTERED) {
>      272                         VirtTarget *vtarget = ri->starget->hostdata;
>      273
>      274                         if (!vtarget || vtarget->channel != channel)
>      275                                 continue;
>      276                         rtn = fc_block_rport(ri->rport);
> 
> Are we always going to hit this assignment?
> 
I _think_, but it'll be good to initialize anyway.
Thanks for the report.

Cheers,

Hannes

