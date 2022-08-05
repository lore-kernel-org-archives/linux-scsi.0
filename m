Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D28C00140
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Aug 2022 12:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240670AbiHEMJ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Aug 2022 08:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240671AbiHEMJ4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2022 08:09:56 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FF277577
        for <linux-scsi@vger.kernel.org>; Fri,  5 Aug 2022 05:09:55 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 921DE372BA;
        Fri,  5 Aug 2022 12:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659701391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yNiPqdRWh2f9GKcvqC68FZH1NM0M2wha9esUGUeLjF8=;
        b=FJhOquq7jtDWgqpQ412tJRCBI1VFapi4IvxoIkcbXzsCV5ukpoxy+36ZdCNaPON6yaivHs
        hVfso/dzBzYelbIEXFW14I5IzxfP+v78A0OdHVJvJcOn+fvVWHsrkYbwJTYNwqSIvClJcO
        j634zjVUIXg4K04RNaYmYzErYlEbxpI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659701391;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yNiPqdRWh2f9GKcvqC68FZH1NM0M2wha9esUGUeLjF8=;
        b=52rE2VbAkLdmnsobkJKVt6PkGB/v8+kUDyi77q9/TaoauYiClCsqCCIsrXw8Lh2Ma8MbQt
        UQyqyZRe4VGrSTDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8394F133B5;
        Fri,  5 Aug 2022 12:09:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IMsdII8I7WIIEgAAMHmgww
        (envelope-from <dwagner@suse.de>); Fri, 05 Aug 2022 12:09:51 +0000
Date:   Fri, 5 Aug 2022 14:09:50 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: Re: [PATCH v1] qla2xxx: Allow nvme report port registration
Message-ID: <20220805120950.jfcc3rlljpjabsps@carbon.lan>
References: <20220728115007.4376-1-dwagner@suse.de>
 <20220728134755.fnc4ttqjwwzbm5dl@carbon.lan>
 <76E241FF-6DFC-4CD5-8271-658A1A504577@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76E241FF-6DFC-4CD5-8271-658A1A504577@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 03, 2022 at 05:30:24PM +0000, Himanshu Madhani wrote:
> Do you see issue with reverted patch?

No, all is good again with 6a45c8e137d4 ("scsi: qla2xxx: Fix disk
failure to rediscover") reverted.

> I see no issues with the code change per say, just want to understand if
> you were seeing issue with the offending patch reverted as well?

I didn't see the revert in time hence I started to fix the code because
I understood the patch actually fixes a race.
