Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB706C64ED6
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Feb 2023 07:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjB1HSn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Feb 2023 02:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjB1HSm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2023 02:18:42 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0E6168AA
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2023 23:18:38 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 706CA21A3F;
        Tue, 28 Feb 2023 07:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677568717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZlB1ZLoNxigGco+j8Bx1XGmlqO++OQrzRzfgIoxFA3s=;
        b=yChXoXwTF5ZOOImQbt9SuOh2GNliqIU+p1q8DeEaKcxjLpG+qVjCeVCd0yrcXQnHrJyTsa
        6sx03afCkyDQncYnnBI7Eb2RhWWyNPa9OwLeMZ12DnO0ZerXr+h6jjAgbwGxDZnsBctTPN
        +Mvo/Le1omvjY74gI2XYjdjBTNvtxTA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677568717;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZlB1ZLoNxigGco+j8Bx1XGmlqO++OQrzRzfgIoxFA3s=;
        b=RuWGgAZc8anA0vn56/dRCtmtnrSmw2wwGLDhwWwJnWyP+vuzJXI7jvVY5AGSuOmhdbacdD
        WxrIX61z6bEsexDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 620FC1333C;
        Tue, 28 Feb 2023 07:18:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id T7/nF82q/WM7eQAAMHmgww
        (envelope-from <dwagner@suse.de>); Tue, 28 Feb 2023 07:18:37 +0000
Date:   Tue, 28 Feb 2023 08:18:36 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH] qla2xxx: Add option to disable FC2 Target support
Message-ID: <20230228071836.uiexirp6yxqrknwk@carbon.lan>
References: <20230208152014.109214-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208152014.109214-1-dwagner@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 08, 2023 at 04:20:14PM +0100, Daniel Wagner wrote:
> 44c57f205876 ("scsi: qla2xxx: Changes to support FCP2 Target") added
> support for FC2 Targets. Unfortunately, there are older setups which
> break with this new feature enabled.
> 
> Allow to disable it via module option.
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
> 
> We got two bug reports, one which dependend on revert of the above mentioned
> commit to fix their setup and one which depended on this commit to present to
> fix their setup. The only way I see how we can help out here is to make the
> feature optional.

ping
