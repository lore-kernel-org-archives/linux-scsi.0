Return-Path: <SRS0=MIBM=WR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 626B9C3A59E
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Aug 2019 12:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 312CD2089E
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Aug 2019 12:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566391117;
	bh=sCxkjrOqV57cy9uehYLVUiLv2/5xf/s9hWA1KgEO/zY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=uoh/U30IPLKcOfxyPUKJWCxxTv1iWFGXS6N0TTQZMjIYPVo3Gg57HvnP6AN4Jz/Nm
	 tFHUhMIRRPcY5LPXWuYRF/iXGmWDC0cIQSBZ/ynEg/Z5zVOSJVewQkT8bvQ+6xOurQ
	 L/FSJJsZLzAdGGCo/lOqnVrtI4kJd9WdydLkeu68=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbfHUMi3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Aug 2019 08:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728085AbfHUMi3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Aug 2019 08:38:29 -0400
Received: from localhost (unknown [12.166.174.13])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0FC32089E;
        Wed, 21 Aug 2019 12:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566391107;
        bh=sCxkjrOqV57cy9uehYLVUiLv2/5xf/s9hWA1KgEO/zY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YvNB0DEXeJX0C4y6pAs/Ikxe+iWbn0NYX1w9XyUVftx7+QxTbsd0JlCLeJVVgSO1w
         OdqIKdXLdNwBsLfdb4sDjC6Fk0IsUhVwpLJ6FfnQVXKLy8OFfUM7HH4F7aw8BFuLGH
         zhddpjzYMXmInjG+3pqc4UVgZK9d0Tx0q8w83Dio=
Date:   Wed, 21 Aug 2019 05:38:27 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Matthias Maennich <maennich@google.com>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        arnd@arndb.de, geert@linux-m68k.org, hpa@zytor.com,
        jeyu@kernel.org, joel@joelfernandes.org,
        kstewart@linuxfoundation.org, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-modules@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, lucas.de.marchi@gmail.com,
        maco@android.com, maco@google.com, michal.lkml@markovi.net,
        mingo@redhat.com, oneukum@suse.com, pombredanne@nexb.com,
        sam@ravnborg.org, sspatil@google.com, stern@rowland.harvard.edu,
        tglx@linutronix.de, usb-storage@lists.one-eyed-alien.net,
        x86@kernel.org, yamada.masahiro@socionext.com
Subject: Re: [PATCH v3 10/11] RFC: usb-storage: export symbols in USB_STORAGE
 namespace
Message-ID: <20190821123827.GB4059@kroah.com>
References: <20190813121733.52480-1-maennich@google.com>
 <20190821114955.12788-1-maennich@google.com>
 <20190821114955.12788-11-maennich@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821114955.12788-11-maennich@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 21, 2019 at 12:49:25PM +0100, Matthias Maennich wrote:
> Modules using these symbols are required to explicitly import the
> namespace. This patch was generated with the following steps and serves
> as a reference to use the symbol namespace feature:
> 
>  1) Define DEFAULT_SYMBOL_NAMESPACE in the corresponding Makefile
>  2) make  (see warnings during modpost about missing imports)
>  3) make nsdeps
> 
> Instead of a DEFAULT_SYMBOL_NAMESPACE definition, the EXPORT_SYMBOL_NS
> variants can be used to explicitly specify the namespace. The advantage
> of the method used here is that newly added symbols are automatically
> exported and existing ones are exported without touching their
> respective EXPORT_SYMBOL macro expansion.
> 
> Signed-off-by: Matthias Maennich <maennich@google.com>

This looks good to me.  This can be included with the rest of this
series when/if it goes through the kbuild or module tree:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Actually, which tree will this be going through?

thanks,

greg k-h
