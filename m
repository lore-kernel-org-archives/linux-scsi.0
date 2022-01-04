Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5294AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Jan 2022 12:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiADMcH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Jan 2022 07:32:07 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:57636 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiADMcF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2022 07:32:05 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 905E8210F4;
        Tue,  4 Jan 2022 12:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1641299524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=63PgnDy0vksVcPjH47T2ppO8gcC9J5ZqGLrn6SMb7HY=;
        b=xxeMQ2PUbKPMtJvGeq5CyirVPnG1mTSTFYLgqeVCHx8KErhazeqz/ff8KTDWmQOi/4LB+9
        DVLMDEGFdj+aKpJzjO/LwfnXoMlHWmC4c0qTUWUkLR0nWLg3J+EyvixZNTEcKamhX/inOL
        naphBYMvHwd6LJybI14vFEFhFqnyX4E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1641299524;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=63PgnDy0vksVcPjH47T2ppO8gcC9J5ZqGLrn6SMb7HY=;
        b=OS1Ymnec3YmcKFTd2CBJ3l1RNJ+ljP9FZtcBIPniU8xlbG6Mwd1uJ2UpDp9pIb7HVs+VfR
        ZiiBpP/RPHM/GjCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7F99213B08;
        Tue,  4 Jan 2022 12:32:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wnQPH0Q+1GFPVwAAMHmgww
        (envelope-from <dwagner@suse.de>); Tue, 04 Jan 2022 12:32:04 +0000
Date:   Tue, 4 Jan 2022 13:32:04 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 02/16] qla2xxx: Implement ref count for srb
Message-ID: <20220104123204.tkfn5jfknhns67i3@carbon.lan>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-3-njavali@marvell.com>
 <02990604-CC38-42ED-B3D6-11CCA0C5D43E@oracle.com>
 <DM6PR18MB30347380BBCF7EAF7EDA92C1D2499@DM6PR18MB3034.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR18MB30347380BBCF7EAF7EDA92C1D2499@DM6PR18MB3034.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 03, 2022 at 03:56:06AM +0000, Saurav Kashyap wrote:
> > > -	sp->free(sp);
> > > +	/* ref: INIT */
> > 
> > IMO, There is no need for this comment spread in this patch. Please explain If
> > you think there is need for comment.
> 
> <SK> Thanks for the review. The sp reference can be taken and released on various paths. These comments make 
> life simpler during some ref issue and also make code more understandable. For various scenarios, this comments
> helps in determining final reference count and check if its released properly or not.

I think the better way to address is to get Sebastian's patch working:

https://lore.kernel.org/all/20131103193308.GA20998@linutronix.de/

Daniel
