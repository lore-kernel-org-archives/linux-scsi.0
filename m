Return-Path: <SRS0=ks1E=5A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35318C10F29
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Mar 2020 19:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00EAA206EB
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Mar 2020 19:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584299136;
	bh=AROhWcVtzfvvJB4CmqG3BffPRTtIFHTnvTYp7D8oZWI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=DvwQtSw1zqa3zsnL32RGLriO71dfCw33w2HqXVxsi8qyAdi6zKsQKI+4EZPRDisBd
	 1JlYIOk1Rj/wXZZmG/hLtNE0Ob8gbS/eZqGVh7VIzrfkBdRM6NnbHkLM6yskBKZTNY
	 N60wV0qO7bcsTpHUCj3GEPDzcSifj1vd9M0ygyv8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbgCOTFf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Mar 2020 15:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728608AbgCOTFe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 15 Mar 2020 15:05:34 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC79320578;
        Sun, 15 Mar 2020 19:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584299134;
        bh=AROhWcVtzfvvJB4CmqG3BffPRTtIFHTnvTYp7D8oZWI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CWG1DXIIbJFn0UI3IHBzXhaCpia54a34w1SspqZ/cD2E1DVYbR468krQv4D2xwpE9
         Gx3pXmsE8+Zkj36nuZbY9f9a3EntRie4npqs4j9e36G2n+mksxL/yEVqyFLjEajxjC
         RI4kj2kKGG/PxJKcmds1gsrgaQmNQtLl7jRvTtuQ=
Date:   Sun, 15 Mar 2020 12:05:32 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v8 08/11] fs: introduce SB_INLINECRYPT
Message-ID: <20200315190532.GF1055@sol.localdomain>
References: <20200312080253.3667-1-satyat@google.com>
 <20200312080253.3667-9-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312080253.3667-9-satyat@google.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 12, 2020 at 01:02:50AM -0700, Satya Tangirala wrote:
> Introduce SB_INLINECRYPT, which is set by filesystems that wish to use
> blk-crypto for file content en/decryption.
> 
> Signed-off-by: Satya Tangirala <satyat@google.com>
> ---
>  fs/proc_namespace.c | 1 +
>  include/linux/fs.h  | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
> index 273ee82d8aa9..8bf195d3bda6 100644
> --- a/fs/proc_namespace.c
> +++ b/fs/proc_namespace.c
> @@ -49,6 +49,7 @@ static int show_sb_opts(struct seq_file *m, struct super_block *sb)
>  		{ SB_DIRSYNC, ",dirsync" },
>  		{ SB_MANDLOCK, ",mand" },
>  		{ SB_LAZYTIME, ",lazytime" },
> +		{ SB_INLINECRYPT, ",inlinecrypt" },
>  		{ 0, NULL }
>  	};
>  	const struct proc_fs_info *fs_infop;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 3cd4fe6b845e..08a0395674dd 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1370,6 +1370,7 @@ extern int send_sigurg(struct fown_struct *fown);
>  #define SB_NODIRATIME	2048	/* Do not update directory access times */
>  #define SB_SILENT	32768
>  #define SB_POSIXACL	(1<<16)	/* VFS does not apply the umask */
> +#define SB_INLINECRYPT	(1<<17)	/* inodes in SB use blk-crypto */

"inodes use blk-crypto" isn't very clear.  It could be misunderstand as meaning
something like "does the filesystem contain any encrypted files".  I think the
following would be a bit clearer:

	/* Use blk-crypto for encrypted files */

(And these flags are obviously per-sb, so there's no need to write "in SB".)
