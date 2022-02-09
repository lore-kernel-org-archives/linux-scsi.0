Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C6BEC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 11:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiBILSi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 06:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiBILSi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 06:18:38 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A43E1156A3
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 02:13:16 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E117F210DB;
        Wed,  9 Feb 2022 10:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644401483; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g1syps9O/yzJIdSRfSMN0zCXHglx4mH1D7eGaduYa0M=;
        b=H8xnDuoJ451gPs3C4vdl4af7dybZ4nzNc6PThmJYgyapDKWPGVlRPUhlyqpMJ55sVmfMMs
        2iF6bNnUNU6kwwgMVHH32Z+WatnhOR7Bo4/VyhiPanUYn0NsKuIVKds5amH7J0IKYgkBUv
        OUACjT1ejcdAczhhMoftKCdJfssdV4o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644401483;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g1syps9O/yzJIdSRfSMN0zCXHglx4mH1D7eGaduYa0M=;
        b=cQ1B+FV6fzEL2s1TwZxoCDNJT5hUQMEVkRGpsGzhBSWGGab5jPMmumVwjlR5qGxk3bRvTl
        d5DPSbWuZAL7ahAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CE23713A7C;
        Wed,  9 Feb 2022 10:11:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jYQ3MkuTA2KpWAAAMHmgww
        (envelope-from <dwagner@suse.de>); Wed, 09 Feb 2022 10:11:23 +0000
Date:   Wed, 9 Feb 2022 11:11:23 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 37/44] qla2xxx: Stop using the SCSI pointer
Message-ID: <20220209101123.bxrpmjcjr3qzheya@carbon.lan>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-38-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208172514.3481-38-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 08, 2022 at 09:25:07AM -0800, Bart Van Assche wrote:
> Instead of using the SCp.ptr field to track whether or not a command is
> in flight, use the sp->type field to track this information. sp->type
> must be set for proper operation of the qla2xxx driver. See e.g. the
> switch (sp->type) statement in qla2x00_ct_entry().
> 
> This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Daniel Wagner <dwagner@suse.de>
