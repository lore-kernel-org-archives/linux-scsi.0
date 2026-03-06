Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527C0334685
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2026 07:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772783426; cv=none; b=A6KmU7DaVKK//wh+RTx/LfvqewGgNWoZgbFd1W5qvPcLznK2GfWP/21UW44tdewuC6tt4MxLsUDZzCEqQmsyqgv4Xu3X7bhP1E6mWEcWZsKmf/9GYbdy20yz/N4OTZkX/AP9YgLre1cn6sv+LhhqElEtZK1j0XcbsjPo9IbSDcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772783426; c=relaxed/simple;
	bh=qPr9f8wJUBbpM15AItJrT80CkT+e6Ooho6OS2EGPne8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LwVOOnGeyaDfLe/DA0Fs0s5KqJCdtsN7dTYgs5P1T19g070wukrFb3rkWvSigJAUqWDjt9zlGltp1wly6BhBsRcbsQyhlYS3ix6YiVIKOkAovm5nG/gvPwfCSajhy3OA+8smlKWp6mxA9laMIq405khCTxzSKfhnz6zADEOtjlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-56a8ebde349so7329621e0c.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Mar 2026 23:50:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772783424; x=1773388224;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bdmJ/A9wGP7kK4ayvP1Zz7mkwsDpagK6Z7kLIkIirWg=;
        b=WFCFaaRpxomBZJYu3HudJYX3UI556pzAhEnXEWxyIAEW73yScmyyN27jp7R6pQwCWF
         ij/wU3I31pbFXQKBhRCskOqchbUCN8gqeCOGx3B2qqdHKTzPI0QcG/tw3HlNQhXzD7DS
         jMuc2H1VWhjbLqjT6UZVvfc0geh+nnWb+8n3aaIdiNmZcJTAlG4+U6mDiN39yBuZifoq
         LzLw+SN4upYiIDLyZSRDvEIDuBEHc67ChxDu5kNDUIUzAkZq6Acmn0wbgQAk0IitkjnY
         aDr+TARVpPB6JX8kz7J+El2qiMaCSXDSYtm4YY3c/RlZ4/RshDBXjcOhlQT9jxJEMBeg
         afww==
X-Forwarded-Encrypted: i=1; AJvYcCXBoEdPKYdohsontibghCaSdY/cnGbjY6WOzEBNYiY6Lel97ExE0MSx4Qvzxhf21ePkNgq1wh8Kq90V@vger.kernel.org
X-Gm-Message-State: AOJu0YyllZmJ9qgPpYIlDzhlYdE1eaPYDAOTN7uwPiNyp2i7WVFt/EVq
	Wnah6wmNqMhL8o5kc2CzRy3GFdgYs4nbXrTe1CTD0p3zxMdaipzO0jR1KW7knSgLZmA=
X-Gm-Gg: ATEYQzwvxI1f75qsa6o5AFXVyQ+d7rH0d247A0gHjAIL29yU43gl4tUIC/9a3CZsTVW
	/m7AbkAKK4lVnUWDeXbDK78X7U5xEoz/GEIpn78+llR05qkavrTeHeaWAEZeCLkHk62WqzMS12p
	bdqLFcAiXKMptnwl8iCk0uUctF8segJKwVTP9lfXfJnzPwxTNCkn+oSz/zaBk77VksCCHtEJ23I
	7AzK428SooIT5DfRvYyUSVXTEoVfThExECXU33JSFzGjQ8ev+7NRKsIP8c4kB+4oF3/0rHwdrF5
	J+L8SoTW75/g7zcpo+ME5lqg3qq9pS8mMDJVC0OXeVjQ89qS7PDqqZanrj/QPzWvuRpB9uZIgyr
	EL3KE1cW4fyCf89teeBXts1trGwUnvoaxAnaIxvgneiqnA9FoIJW8MK0pieA5PfGSHWO+1gL0Z7
	+hYuYbBiLLkW11MHtJxadZ+lKw1yuKDGiAn3tRqGroKqZfdg5tmRvPg9Uv399t
X-Received: by 2002:a05:6122:65a0:b0:56a:f5d2:286b with SMTP id 71dfb90a1353d-56b07d482e8mr438124e0c.5.1772783424207;
        Thu, 05 Mar 2026 23:50:24 -0800 (PST)
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com. [209.85.222.51])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56b09b4bdb8sm649438e0c.17.2026.03.05.23.50.22
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2026 23:50:23 -0800 (PST)
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-94de88e52e5so5727620241.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Mar 2026 23:50:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXISJmZQ5sqOAzAWpTBWKfKRkwguJYGQsXyQ1PpjxYf3BdgJdIW6Ta0ktoyLF9hkaeryCJteltSbP7V@vger.kernel.org
X-Received: by 2002:a05:6102:3e93:b0:5f5:320c:4d36 with SMTP id
 ada2fe7eead31-5ffe639be56mr466977137.40.1772783422016; Thu, 05 Mar 2026
 23:50:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <550e7d7bb8c2620ca4f6c9e809a4f853bdfa4c67.1772751689.git.fthain@linux-m68k.org>
In-Reply-To: <550e7d7bb8c2620ca4f6c9e809a4f853bdfa4c67.1772751689.git.fthain@linux-m68k.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 6 Mar 2026 08:50:11 +0100
X-Gmail-Original-Message-ID: <CAMuHMdV4=t5G8fz1ARO7oKA86RwZP6T6yNXm5D7JgVtdaq5Rqg@mail.gmail.com>
X-Gm-Features: AaiRm51Eai65t4yiWUxPJcGlzdgEeeKTw8A1C1uhETq0DlB2V8HcDd0zczrBKe4
Message-ID: <CAMuHMdV4=t5G8fz1ARO7oKA86RwZP6T6yNXm5D7JgVtdaq5Rqg@mail.gmail.com>
Subject: Re: [PATCH] scsi: qla2xxx: Remove problematic BUILD_BUG_ON() assertion
To: Finn Thain <fthain@linux-m68k.org>
Cc: Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Tony Battersby <tonyb@cybernetics.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, 
	linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Finn,

On Fri, 6 Mar 2026 at 00:03, Finn Thain <fthain@linux-m68k.org> wrote:
> The LKP bot reported a build failure with CONFIG_COLDFIRE=y together with
> CONFIG_SCSI_QLA_FC=y, that's attributable to the BUILD_BUG_ON() in
> qlt_queue_unknown_atio().
>
> That function uses kzalloc() to obtain memory for the following struct,
> plus some extra bytes at the end.
>
> struct qla_tgt_sess_op {
>         struct scsi_qla_host *vha;
>         uint32_t chip_reset;
>         struct work_struct work;
>         struct list_head cmd_list;
>         bool aborted;
>         struct rsp_que *rsp;
>
>         struct atio_from_isp atio;
>         /* DO NOT ADD ANYTHING ELSE HERE - atio must be last member */
> };
>
> The location of the 'atio' member is subsequently used as the destination
> for a memcpy() that's expected to fill in the extra bytes beyond the end
> of the struct.
>
> That explains the loud warning in the comment above, which ought to be
> sufficient to prevent some newly-added member from accidentally getting
> clobbered. But, in case that warning was missed somehow, we also have the
> failing assertion,
>
> BUILD_BUG_ON(offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
>              sizeof(*u));
>
> Unfortunately, this size assertion doesn't guarantee that 'atio' is the
> last member. Indeed, adding a zero-length array member at the end does
> not increase the struct size.
>
> Moreover, this assertion can fail even when 'atio' really is the last
> member, and that's what happened with commit e428b013d9df ("atomic:
> specify alignment for atomic_t and atomic64_t"), which added 2 bytes of
> harmless padding to the end of the struct.
>
> Remove the problematic assertion. The comments alone should be enough to
> prevent mistakes.
>
> Cc: Tony Battersby <tonyb@cybernetics.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-m68k@lists.linux-m68k.org
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202603030747.VX0v4otS-lkp@intel.com/
> Signed-off-by: Finn Thain <fthain@linux-m68k.org>

Thanks for your patch!

> ---
> I don't know of a good way to encode an invariant like "the last member of
> struct qla_tgt_sess_op is named atio" such that it might be statically
> checked. But perhaps there is a good way to do that (?)

Keeping the BUILD_BUG_ON(), but adding "__aligned(8);" to
the ratio member, as suggested by Arnd, would do that?

> There's no Fixes tag here because there's no need to backport.
> The BUILD_BUG_ON() comes from commit 091719c21d5a ("scsi: qla2xxx: target:
> Fix invalid memory access with big CDBs") which appeared in v6.19-rc1.
> The build failure first appeared in v7.0-rc1 with commit e428b013d9df
> ("atomic: specify alignment for atomic_t and atomic64_t").

I would add both in Fixes, just in case anyone ever wants to backport
e428b013d9df (which looks like a valid bugfix to me).

> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -213,7 +213,6 @@ static void qlt_queue_unknown_atio(scsi_qla_host_t *vha,
>         unsigned int add_cdb_len = 0;
>
>         /* atio must be the last member of qla_tgt_sess_op for add_cdb_len */
> -       BUILD_BUG_ON(offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) != sizeof(*u));

Iff you remove the BUILD_BUG_ON(), you should remove the comment, too.

>
>         if (tgt->tgt_stop) {
>                 ql_dbg(ql_dbg_async, vha, 0x502c,

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
