Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F8CC11F65
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Jun 2021 16:54:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42E796146D
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Jun 2021 16:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhF3Q4n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Jun 2021 12:56:43 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:46840 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhF3Q4m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jun 2021 12:56:42 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 80A451FEBD;
        Wed, 30 Jun 2021 16:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625072052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/KUaq0ltUmNBv7uOOmYps7lBebvPZNmKRBZzexdbfwU=;
        b=HqgO1/lkwfvufSDtEKOscafMX0d8XJtIP6OHRzMpoSBnZ4DK5HOlvsBETDhzFqMG3GIcPP
        JoUQJTKWCeo3h5/lVSHD4HMqnv0+RAhT5kmqBjWKgViDnPxTWMQdacz3Q35R6RR/oxB7T/
        lYrHEEEFfeln519Vhm3wp4MyGSZnHFI=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 134FA118DD;
        Wed, 30 Jun 2021 16:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625072052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/KUaq0ltUmNBv7uOOmYps7lBebvPZNmKRBZzexdbfwU=;
        b=HqgO1/lkwfvufSDtEKOscafMX0d8XJtIP6OHRzMpoSBnZ4DK5HOlvsBETDhzFqMG3GIcPP
        JoUQJTKWCeo3h5/lVSHD4HMqnv0+RAhT5kmqBjWKgViDnPxTWMQdacz3Q35R6RR/oxB7T/
        lYrHEEEFfeln519Vhm3wp4MyGSZnHFI=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id nTDiArSh3GA0cgAALh3uQQ
        (envelope-from <mwilck@suse.com>); Wed, 30 Jun 2021 16:54:12 +0000
Message-ID: <da3039c75c892f7d4031161f7c8719e50de36057.camel@suse.com>
Subject: Re: [PATCH v4 1/3] scsi: scsi_ioctl: export
 __scsi_result_to_blk_status()
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Snitzer <snitzer@gmail.com>,
        Bart Van Assche <bart.vanassche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>, nkoenig@redhat.com,
        emilne@redhat.com
Date:   Wed, 30 Jun 2021 18:54:11 +0200
In-Reply-To: <YNyVafnX09cOIZPe@redhat.com>
References: <20210628095210.26249-1-mwilck@suse.com>
         <20210628095210.26249-2-mwilck@suse.com> <20210628095341.GA4105@lst.de>
         <4fb99309463052355bb8fefe034a320085acab1b.camel@suse.com>
         <20210629125909.GB14372@lst.de>
         <2b5fd35d95668a8cba9151941c058cb8aee3e37c.camel@suse.com>
         <20210629212316.GA3367857@dhcp-10-100-145-180.wdc.com>
         <1aa1f875e7a85f9a331e88e4f8482588176bdb3a.camel@suse.com>
         <YNyVafnX09cOIZPe@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mi, 2021-06-30 at 12:01 -0400, Mike Snitzer wrote:
> On Wed, Jun 30 2021 at  4:12P -0400,
> Martin Wilck <mwilck@suse.com> wrote:
> > 
> > Thanks for your suggestion. I'd be lucky if this was true. But the
> > most
> > important users of scsi_result_to_blk_status() are in scsi_lib.c
> > (scsi_io_completion_action(), scsi_io_completion_nz_result()).
> > 
> > If I move scsi_result_to_blk_status() to vmlinux without exporting
> > it,
> > it won't be available in the SCSI core any more, at least not with
> > CONFIG_SCSI=m.
> 
> For what you're trying to accomplish with this patchset, you only
> need
> sg_io_to_blk_status() exported.
> 
> So check with Martin and/or Bart on the best way to give
> sg_io_to_blk_status() access to the equivalent of your
> __scsi_result_to_blk_status() without exporting it.
> 
> I'd start by just folding patches 1 and 2, fixing up the logic Dan
> Carpenter pointed ouit, and only exporting sg_io_to_blk_status().

Thank you! FTR, the issue Dan Carpenter reported was already fixed in
v5 of this patch set.

@Martin, @Bart, do you have a suggestion for me?

Thanks,
Martin


