Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79971C19F21
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 13:47:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiG1Nr6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 09:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiG1Nr6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 09:47:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F819624B6
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 06:47:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C3F682098B;
        Thu, 28 Jul 2022 13:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659016075; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KRS7TcA65Mz8ClHRFBNTYbsFAzbyAe7wFzUjHvmrAC8=;
        b=FMwAeQkacdjqsSQn94yEy/rAV5Fp7dwvPGevRfp/uKdcXhfJ9wiCQp2u7k+lA3hXey06iJ
        v5ss0TkSFJLFEKXXrHO4/3hfmF+zwWj19ZvRoz5d6PCUCI7SD2yWQa+OZFY2yPpmBSgN+j
        2tkhL063mjw0LQ6GkFNg0FqyIWkFjy4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659016075;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KRS7TcA65Mz8ClHRFBNTYbsFAzbyAe7wFzUjHvmrAC8=;
        b=goLacDQXNy2LXPw8dzMk5HLkPu8cF1YU/CN2IZdipkbnZbPQ2NZtWDNF4FmTWk3ytthO/8
        MoPyVqhlwXUvEoBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B54C013427;
        Thu, 28 Jul 2022 13:47:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id P9E0LIuT4mLMTgAAMHmgww
        (envelope-from <dwagner@suse.de>); Thu, 28 Jul 2022 13:47:55 +0000
Date:   Thu, 28 Jul 2022 15:47:55 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: Re: [PATCH v1] qla2xxx: Allow nvme report port registration
Message-ID: <20220728134755.fnc4ttqjwwzbm5dl@carbon.lan>
References: <20220728115007.4376-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728115007.4376-1-dwagner@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 28, 2022 at 01:50:07PM +0200, Daniel Wagner wrote:
> Move the both ONLINE state check into qla2x00_update_fcport and call
> both register port register functions.
> 
> Currently, qla2x00_reg_remote_port and qla_nvme_register_remote check
> the state if it is ONLINE. If it not, the state is set to ONLINE and
> the function is executed.
> 
> qla2x00_reg_remote_port is called before qla_nvme_register_remote and
> hence qla_nvme_register_remote will always bail out and never register
> a nvme remote port.
> 
> Fixes: 6a45c8e137d4 ("scsi: qla2xxx: Fix disk failure to rediscover")
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Signed-off-by: Daniel Wagner <dwagner@suse.de>

I see the offending patch got reverted. FWIW, this patch works for me
fine.
