Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E261C3F6B0
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Aug 2022 23:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiHGXaY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Aug 2022 19:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiHGXaX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Aug 2022 19:30:23 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB9E2622
        for <linux-scsi@vger.kernel.org>; Sun,  7 Aug 2022 16:30:17 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id d7so7138757pgc.13
        for <linux-scsi@vger.kernel.org>; Sun, 07 Aug 2022 16:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc;
        bh=qbL2Ymxz5e7KekDdLOCsw8SbD8/sAmLdT/zwTpI/iMs=;
        b=R5iWcoAJGfltcXw8d6iMH8EJQIedF26xa3nF2pmcTBWV6ZAtwiGpdJkc3ESIMqS+r6
         tYPg8LqY9DG4M3pRYvgfAvNGX5cvpMSLvMlnyoTTbAd1toInkrjCfGwuWSvDbmgmRjSE
         fL4+HzBnyQUMI44qpxiPIx/42OSGfnvkxEyG0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc;
        bh=qbL2Ymxz5e7KekDdLOCsw8SbD8/sAmLdT/zwTpI/iMs=;
        b=B137kg0UGmj1YLLofEWpNn1Ffb+tvA9kCgIaLe93Thqi94/xrzxt+xKpd4G1KWqnV2
         YtPaOjTSSsmQRPL+p21V1/XWxizM3+GRQW2qv1AecZdqyTSGuWMlzpIKuL5q0Y78ETQQ
         vEUuiHApUdwNX6AlXbzTklwxE9/o74ai9tF87nm7Km7LHnsgrFHvm+D06lBOv304pqSk
         h+ZY0TgJmQowAsNpLH5tsEuLyb9cksDLlltLOXpWlE+iNybkRQMWTPO4dlZAs4Pv5cYT
         4nFKP8P1CMeomH0xsftSuu2rbsfk2X7OVz1I9YgJzgf5QgqxGEB/NzASl4GXTGZW5+hC
         BcGg==
X-Gm-Message-State: ACgBeo3myrAPw3I3e6Bknk3HLskNoC6g4bt1Vbx0Ta7CNzQrFNVP+lU+
        3L0fpWuj7h7NYXZSddjIPy9q/g==
X-Google-Smtp-Source: AA6agR6sadHb5Wxix/DeyrpnxhLihE5ZhtxH5f6V2cbNJj5GTJgIb+1mvG9rSxRjJPfew0QXv55+NQ==
X-Received: by 2002:a65:6949:0:b0:41c:cb9d:3d1f with SMTP id w9-20020a656949000000b0041ccb9d3d1fmr13462189pgq.334.1659915016477;
        Sun, 07 Aug 2022 16:30:16 -0700 (PDT)
Received: from google.com (n122-107-196-14.sbr2.nsw.optusnet.com.au. [122.107.196.14])
        by smtp.gmail.com with ESMTPSA id d6-20020a170903230600b0016efc27ca98sm7127955plh.169.2022.08.07.16.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Aug 2022 16:30:15 -0700 (PDT)
From:   Daniil Lunev <dlunev@chromium.org>
X-Google-Original-From: Daniil Lunev <dlunev@google.com>
Date:   Mon, 8 Aug 2022 09:30:07 +1000
To:     Arthur Simchaev <Arthur.Simchaev@wdc.com>
Cc:     James@vger.kernel.org, E.J.Bottomley@vger.kernel.org,
        jejb@linux.vnet.ibm.com, Martin@vger.kernel.org,
        K.Petersen@vger.kernel.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bean@vger.kernel.org, Huo@vger.kernel.org, beanhuo@micron.com
Subject: Re: [PATCH] scsi: ufs-bsg: Remove ufs_bsg_get_query_desc_size
 function
Message-ID: <YvBK/8yeohLhu2Za@google.com>
References: <1655727966-31584-1-git-send-email-Arthur.Simchaev@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1655727966-31584-1-git-send-email-Arthur.Simchaev@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 20, 2022 at 03:26:06PM +0300, Arthur Simchaev wrote:
> The bsg driver allows user space to send device management commands.
> As such, it is often used by field application engineers to debug various problems,
> and as a test bed for new features as well.
> 
> Let's not bound ourself to hard coded descriptor sizes, as the new
> Descriptors that supports new features are not defined yet.
Can you clarify what you mean "hard-coded"? The descriptor size is initialized
as QUERY_DESC_MAX_SIZE, and updated in `ufshcd_update_desc_length`, which is
called with the actual size upon finishing `ufshcd_read_desc_param`.

The function you are removing - `ufs_bsg_get_query_desc_size` - doesn't seem to
reject requests on incompatible size, only to restrict the size of the query.
The way the code is written - if I read it right - will lead to truncation of
the response if the size of the requested response is less than the actual
descriptor size, but otherwise you should get full descriptor back.

Can you provide a specific example where you see the problem to arise?

Thanks,
Daniil
