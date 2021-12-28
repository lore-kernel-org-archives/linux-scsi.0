Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D0E8C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Dec 2021 11:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236437AbhL1LM2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Dec 2021 06:12:28 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:43054 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbhL1LM1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Dec 2021 06:12:27 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 943511F37E;
        Tue, 28 Dec 2021 11:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1640689946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Me8PwT87ZT4HduQtyAPyKOCI9n8/1dqdX+rgnD28J5M=;
        b=X/QAinrTrW2N/9w/eEgJC7duYG/Y9XqNQNKrIZTpyuVtNQuXQ8h9n9iu31S0KKahfy7FYb
        dlEer01BH5ePA3upREP9IT4nIxHWE+ZjHmajFl5lyS+RGxd8WlIM4X8YOKFYqx/f7DDbTQ
        IyEmH0hPCiXFSz5hh39JmbQJiE5Ni/g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1640689946;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Me8PwT87ZT4HduQtyAPyKOCI9n8/1dqdX+rgnD28J5M=;
        b=6yc5QWXK6R0LGixZtTm9mR6OH7bU3sRBy+IYN2P2Qfec4tdIWzc+2f/f6AqdjDFj0Ha7Q8
        S7nlz1guCzOWHNAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7D8BE13ADE;
        Tue, 28 Dec 2021 11:12:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id QQ4vHhrxymHyegAAMHmgww
        (envelope-from <dwagner@suse.de>); Tue, 28 Dec 2021 11:12:26 +0000
Date:   Tue, 28 Dec 2021 12:12:26 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH 02/16] qla2xxx: Implement ref count for srb
Message-ID: <20211228111226.vga3wudmnq27czrl@carbon.lan>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-3-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211224070712.17905-3-njavali@marvell.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Saurav

On Thu, Dec 23, 2021 at 11:06:58PM -0800, Nilesh Javali wrote:
> From: Saurav Kashyap <skashyap@marvell.com>
> 
> Fix race between timeout handler and completion handler by introducing
> a reference counter. One reference is taken for the normal code path
> (the 'good case') and one for the timeout path.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>

Thanks picking the patch up and getting it into shape.  Highly
appreciated!

FWIW,

Reviewed-by: Daniel Wagner <dwagner@suse.de>

Daniel
