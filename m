Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6266EC54EE9
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Sep 2022 14:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiISOLs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Sep 2022 10:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiISOLr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2022 10:11:47 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9243136D;
        Mon, 19 Sep 2022 07:11:45 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A64CA1F8F1;
        Mon, 19 Sep 2022 14:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663596704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e6jSNGpl22UihrSVGdfwL4XCFmdk1CRaeZx03G6VvDw=;
        b=mi++xQf2IMvnO7tVXg8ZdrZCJG8o9WnzMX3ODVhH7qIQAG0JJbxWP+iv3M6XRTa6VoTIu/
        /bgt7tVr3ld5s36pNmxtbrh34Jmk7H+uWhyUtMJDvu6ycYwO5zOb5Jv79taISG1+aSvvBe
        8Xa9jtx7l8D+LNpLXPSmfBEIfzmLWzU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663596704;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e6jSNGpl22UihrSVGdfwL4XCFmdk1CRaeZx03G6VvDw=;
        b=ofAowOSMq9XCaF37++HSumkP9gkjGyoL4Ac3NhrB9LQyRjwZR6hZNNFZy7m+ArExdpDfcr
        Ws28jpuFOxZcxRBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 99DFF13ABD;
        Mon, 19 Sep 2022 14:11:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WqSDJaB4KGNQWgAAMHmgww
        (envelope-from <dwagner@suse.de>); Mon, 19 Sep 2022 14:11:44 +0000
Date:   Mon, 19 Sep 2022 16:11:44 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Ren Zhijie <renzhijie2@huawei.com>
Cc:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com, aeasi@marvell.com,
        himanshu.madhani@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 -next] scsi: qla2xxx: Fix build error
 implicit-function-declaration
Message-ID: <20220919141144.h2dw57cmjs2egwep@carbon.lan>
References: <20220919133404.85425-1-renzhijie2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220919133404.85425-1-renzhijie2@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 19, 2022 at 09:34:04PM +0800, Ren Zhijie wrote:
> If CONFIG_TRACING is not set,
> make ARCH=x86_64 CROSS_COMPILE=x86_64-linux-gnu-,
> will be failed, like this:
> 
> drivers/scsi/qla2xxx/qla_os.c: In function ‘qla_trace_init’:
> drivers/scsi/qla2xxx/qla_os.c:2854:18: error: implicit declaration of function ‘trace_array_get_by_name’; did you mean ‘trace_array_set_clr_event’? [-Werror=implicit-function-declaration]
>   qla_trc_array = trace_array_get_by_name("qla2xxx");
>                   ^~~~~~~~~~~~~~~~~~~~~~~
>                   trace_array_set_clr_event
> drivers/scsi/qla2xxx/qla_os.c:2854:16: error: assignment makes pointer from integer without a cast [-Werror=int-conversion]
>   qla_trc_array = trace_array_get_by_name("qla2xxx");
>                 ^
> drivers/scsi/qla2xxx/qla_os.c: In function ‘qla_trace_uninit’:
> drivers/scsi/qla2xxx/qla_os.c:2869:2: error: implicit declaration of function ‘trace_array_put’; did you mean ‘trace_seq_putc’? [-Werror=implicit-function-declaration]
>   trace_array_put(qla_trc_array);
>   ^~~~~~~~~~~~~~~
>   trace_seq_putc
> cc1: all warnings being treated as errors
> 
> To fix this error, wrap up all the relevant code with CONFIG_TRACING.
> 
> Fixes: 8bfc149ba24c ("scsi: qla2xxx: Enhance driver tracing with separate tunable and more")
> Signed-off-by: Ren Zhijie <renzhijie2@huawei.com>

Reviewed-by: Daniel Wagner <dwagner@suse.de>
