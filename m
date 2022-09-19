Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51CFAC54EE9
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Sep 2022 07:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiISHRZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Sep 2022 03:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiISHRY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2022 03:17:24 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203D213F79;
        Mon, 19 Sep 2022 00:17:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D24F01F88B;
        Mon, 19 Sep 2022 07:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663571841; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fA7npP5z7rFFxTvYsv/Mfbqal+4K1ZZ4Ee0H7eQXkyo=;
        b=xH1eScaphBpRPR3BOlaAqxFofYzSr6kIa7depl5KhucZXLf58DOpSHs+uB8JvD3DjPsfvQ
        +PYxu2LxfV+g1wJIIlERBR3OhfNF+n1qQvZt7HU6nWSsswq4g+nTghwXWVe2oOm/0pfF84
        50RQWZlOrHO9vDqe/0Oa5S7fpzA1ZlA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663571841;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fA7npP5z7rFFxTvYsv/Mfbqal+4K1ZZ4Ee0H7eQXkyo=;
        b=FLCKaSEGbFJk8yVJXYq2R2mv5f3Jh7p0Ne8KiJSrJPEYWjPMQf09RwEfF12vm3hmUBSkTy
        zNpmrdLbRcUbiWAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C3FF613A96;
        Mon, 19 Sep 2022 07:17:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id aiDRL4EXKGN/HAAAMHmgww
        (envelope-from <dwagner@suse.de>); Mon, 19 Sep 2022 07:17:21 +0000
Date:   Mon, 19 Sep 2022 09:17:21 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Ren Zhijie <renzhijie2@huawei.com>
Cc:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com, aeasi@marvell.com,
        himanshu.madhani@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] scsi: qla2xxx: Fix build error
 implicit-function-declaration
Message-ID: <20220919071721.upsccdkhzp3zanui@carbon.lan>
References: <20220919030810.1626-1-renzhijie2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919030810.1626-1-renzhijie2@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 19, 2022 at 11:08:10AM +0800, Ren Zhijie wrote:
> +#ifdef CONFIG_TRACING
>  static void
>  qla_trace_init(void)
>  {
> @@ -2868,7 +2871,7 @@ qla_trace_uninit(void)
>  		return;
>  	trace_array_put(qla_trc_array);
>  }
> -
> +#endif

FWIW, the qla2xxx driver uses a different pattern for ifdefs

	static void
	qla_trace_init(void)
	{
	#ifdef CONFIG_TRACING
	[...]
        #endif
        }

This avoid to updated the callside with ifdefs.
