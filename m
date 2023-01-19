Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA333C678D4
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Jan 2023 21:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbjASV0f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Jan 2023 16:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbjASVYh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2023 16:24:37 -0500
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB19783D7
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jan 2023 13:20:04 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 6E5152C0;
        Thu, 19 Jan 2023 21:20:04 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 6E5152C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1674163204; bh=bwJ8EaHnQJNTxU8cdm67Qd0Ex0YLDXztdVnkHzGC0dM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=KZhBHBSYoplpG5b7ZUE8sZQkftfWubHImSH8tuglQV4FZvCKItlEtVNQTFaiHE77a
         nbFMXOdT/7flIS+IM0zx+XLjGeIY3zGPWVM+hSnYXYmgWxJcc35iyYfgmlyOMtrrLm
         S/vrLil27HZ/9H4cgWoUf6Gn2mggR9oEZL9vIyNOjPKo4Aqcw4dGgY+2rhuySdIq4O
         8s59MCAL7IgmERlv7BIOIUSouo6lAvS1N3iqIxY0Ks4Mby8bq7BNYiaaa5gV/3g0od
         gZFLWlAit9+/GLvCS/5e9eVXpssrca0wwqCZ4+PQKJOwhEjhcDW/G2oJ7wT4eb3gx0
         Do3EpA9pAfe0g==
From:   Jonathan Corbet <Corbet@lwn.net>
To:     shijm <junming@nfschina.com>
Cc:     linux-scsi@vger.kernel.org, shijm <junming@nfschina.com>
Subject: Re: [PATCH] Documentation: add exception capture function
In-Reply-To: <20230115110535.5597-1-junming@nfschina.com>
References: <20230115110535.5597-1-junming@nfschina.com>
Date:   Thu, 19 Jan 2023 14:20:03 -0700
Message-ID: <87zgae6x30.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

shijm <junming@nfschina.com> writes:

> Add exception capture function
>
> Signed-off-by: shijm <junming@nfschina.com>

This says what you are doing but not why; nobody has felt the need to
mess with this script for a while; why do we need to change it now?

>  Documentation/target/tcm_mod_builder.py | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
> index 54492aa813b9..5b28d50ed80f 100755
> --- a/Documentation/target/tcm_mod_builder.py
> +++ b/Documentation/target/tcm_mod_builder.py
> @@ -29,8 +29,9 @@ def tcm_mod_create_module_subdir(fabric_mod_dir_var):
>  		return 1
>  
>  	print "Creating fabric_mod_dir: " + fabric_mod_dir_var
> -	ret = os.mkdir(fabric_mod_dir_var)
> -	if ret:
> +    try:
> +	    ret = os.mkdir(fabric_mod_dir_var)
> +	except:
>  		tcm_mod_err("Unable to mkdir " + fabric_mod_dir_var)

Bare "except" clauses are generally a bad idea in my exception; I assume
you want to catch IOError here?

Assuming that this script is still useful, we should consider moving it
to tools/.

Thanks,

jon
