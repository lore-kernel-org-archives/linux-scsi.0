Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73AA7C432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 03:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A6F62240E
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 03:14:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GXW98XVj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfKTDOg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 22:14:36 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39574 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727336AbfKTDOf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 22:14:35 -0500
Received: by mail-qt1-f194.google.com with SMTP id t8so27370212qtc.6
        for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2019 19:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=uqv0n7teV+8uiBGUahK/8aEv92QulElxaU8iWe6hVQo=;
        b=GXW98XVjKUJopIBOTfZEoojs9IYmgeCvlLYU+jEaStRVhWQmhfqKWpxTiyehgoESC7
         WKBqRcdMAR7wYD+iprYQBtqwHEznpr9EVVFB95ogrsmRnXiqT+o080Gfs13rb7elKHNl
         jiRCyxUKLhmFq6wW/NRHspAx1iFB5NMmhS8EDPxbGz28UkBYtlV4T1nMd+PaCWo2LZeU
         5lWvjXalrjRxj7V5PjsS+/OiL+CdN4NsaR6siEAmVtLac9bHVxxmONdGfGjmyfGwoLUY
         x57wlo6m1Yta2dSV5R0IFjQmiGj944gIlo2nj9lx8eRf8CeN+DA8tZJKC8+6Pee4mF6a
         azVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=uqv0n7teV+8uiBGUahK/8aEv92QulElxaU8iWe6hVQo=;
        b=RrKmM/JKULUU3LrHjNtdV7xxkQ2AOft0nFDeWTsqQtLT+pK7Z3yUexNgbuQM+jGDJh
         jWOjzYWYyHLvJqJKFmfxeZdCBxM5UJKWiufTTvVEvgPL5M4nrs+iXbqcRxRHtOFAVvMy
         C2zsk+jSFrieZBYBBGNvw5nHm6L5GR4pwFZygYrVP6bzho/OFLPUuHycXDUPjiuCAHut
         oq5ULnb5whzHh/36eycUlR3mb2BBKZ6vfQ+IfywExLqni6kNkynYxLv56PAcBzTxTmqa
         PeQADrzYlhSLIpQTSKALoOnl9YzAevx6j8orFMs8uizm1lu0HL8DxHBECO4MdMpkPmxg
         +OXA==
X-Gm-Message-State: APjAAAUiuLKW6VU4xLW4vG6set5HqMrk2BXuMoTprGmWOzrPqNQeKkQR
        RADAcomQuFLYHlwpMMOl5F8=
X-Google-Smtp-Source: APXvYqwdTy3hs0zJuvQbg2Iu/RO6sDGGAREz2LoxHVoyoc1QYLuArx+oCYzcv6wFpWNl8iG2ffPmlg==
X-Received: by 2002:aed:37c6:: with SMTP id j64mr609109qtb.364.1574219674613;
        Tue, 19 Nov 2019 19:14:34 -0800 (PST)
Received: from chad-VirtualBox (pool-96-230-166-208.prvdri.fios.verizon.net. [96.230.166.208])
        by smtp.gmail.com with ESMTPSA id p85sm11068783qke.79.2019.11.19.19.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 19:14:33 -0800 (PST)
Message-ID: <4542ba273577056dbe530714f43af29ce5258814.camel@gmail.com>
Subject: Re: [PATCH] bnx2fc: timeout calculation invalid for
 bnx2fc_eh_abort()
From:   cdupuis1@gmail.com
To:     Laurence Oberman <loberman@redhat.com>,
        QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org,
        djeffery@redhat.com, jpittman@redhat.com
Date:   Tue, 19 Nov 2019 22:14:32 -0500
In-Reply-To: <1574178394-16635-1-git-send-email-loberman@redhat.com>
References: <1574178394-16635-1-git-send-email-loberman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks like the original calculation assumed that rp->r_a_tov was
specified in seconds hence the HZ multiplier.  Converting using
msecs_to_jiffies() would seem to be the correct way to do it.

Reviewed-by: Chad Dupuis <cdupuis1@gmail.com>

On Tue, 2019-11-19 at 10:46 -0500, Laurence Oberman wrote:
> In the bnx2fc_eh_abort() function there is a calculation for
> wait_for_completion that uses a HZ multiplier.
> This is incorrect, it scales the timeout by 1000 seconds
> instead of converting the ms value to jiffies.
> Therefore change the calculation.
> 
> Reported-by: David Jeffery <djeffery@redhat.com>
> Reviewed-by: John Pittman .jpittman@redhat.com>
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c
> b/drivers/scsi/bnx2fc/bnx2fc_io.c
> index 401743e..d8ae6d0 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -1242,7 +1242,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
>  
>  	/* Wait 2 * RA_TOV + 1 to be sure timeout function hasn't fired
> */
>  	time_left = wait_for_completion_timeout(&io_req->abts_done,
> -						(2 * rp->r_a_tov + 1) *
> HZ);
> +					msecs_to_jiffies(2 * rp-
> >r_a_tov + 1));
>  	if (time_left)
>  		BNX2FC_IO_DBG(io_req,
>  			      "Timed out in eh_abort waiting for
> abts_done");

