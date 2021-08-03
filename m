Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEAFAC4320A
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 12:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C034A60F8F
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 12:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235944AbhHCMeJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Aug 2021 08:34:09 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:59642 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234524AbhHCMeI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Aug 2021 08:34:08 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4359321F4A;
        Tue,  3 Aug 2021 12:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627994036; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ILvRLSGrZOEoPnmyG64iMyrfxj5roTegANRYKOleDQ=;
        b=bjMrHhXjFDBars3W0vs/v4FgzplucByR1y/CmdWGVLJrJjIdkJMGxtynPPYfvOqmpcBDeC
        XsNGijr2hq/2xgisag3uBrylIAWRG3Pb8pElTzlIsHfYNPKiBoBfNSL3XSHJyRhpgYrEUJ
        kCH4aeVEWAwtFbNerYe7wzsnvtsiqbQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627994036;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ILvRLSGrZOEoPnmyG64iMyrfxj5roTegANRYKOleDQ=;
        b=w/hecoom9PjVEZjriQUREuc7QzXZTChUogjaxdhlmgPdRZVrBdfc+2udobdEDbM2u+GV0S
        YAQ+W2XJn/9kc3CQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id F1858137B8;
        Tue,  3 Aug 2021 12:33:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id GzWIObM3CWF5QAAAGKfGzw
        (envelope-from <ddiss@suse.de>); Tue, 03 Aug 2021 12:33:55 +0000
Date:   Tue, 3 Aug 2021 14:33:54 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     Sergey Samoylenko <s.samoylenko@yadro.com>
Cc:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>
Subject: Re: [v2 1/2] target: allows backend drivers to fail with specific
 sense codes
Message-ID: <20210803143354.29604db8@suse.de>
In-Reply-To: <54db7e6756e945b7abd3b368d52600db@yadro.com>
References: <20210726151646.32631-1-s.samoylenko@yadro.com>
        <20210726151646.32631-2-s.samoylenko@yadro.com>
        <20210730183758.6efb3f95@suse.de>
        <54db7e6756e945b7abd3b368d52600db@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Sergey,

On Mon, 2 Aug 2021 18:31:06 +0000, Sergey Samoylenko wrote:

> David, am I getting the idea right?
> 
> We want to get something like this:
[trimmed]

Yes, this is my preference (with the corresponding .h changes).
Please send it as a git-send-email patchset and feel free to add my
reviewed-by tag.

Cheers, David
