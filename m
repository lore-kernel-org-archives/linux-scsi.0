Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB30EB64D7
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jun 2023 21:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjFUV1R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jun 2023 17:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjFUV1Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jun 2023 17:27:16 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5231C1BC
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2023 14:27:15 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-6686a05bc66so3077173b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2023 14:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687382835; x=1689974835;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rTuIqYcfgKZv7QSK0ovHDNEK7QMFVmXAOC03AKV5k1Y=;
        b=lDc0ADffPTMYgrAgqhsG2RHOz8keNLf7QKfYlBJrheSHsBNpPcqqE1v++Kx9BUzGQt
         0hhpJ//377VwOH4P98a8IiUkbjKsT+DPIvXwgOTK5HHQjnLyI60VlJSNeWnNyII4P32a
         gnJ5zqjdhv7iSh4eF2brhTRwoPjJNuRhXcgng=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687382835; x=1689974835;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rTuIqYcfgKZv7QSK0ovHDNEK7QMFVmXAOC03AKV5k1Y=;
        b=H8jYR3GFBYz1JHCmtjQ6GtuMem1JKos1I5yNWPZjNbGjSqP1gbnJCuLMdP0mL+UANQ
         KB1voCUYo44Ke4x00OIdektGXgQpnwxZbwwEQ/CdvOYBmUCAxmuj5zI/hVF4e+CX+a7P
         BwqY1m8ejzGUmlcAoLhDsqpRotKXrr7ZvFlFuwfP49EBIb0WeeJxsLC76cq8cRnRuoqk
         OHXkKARTfvrsvtOFfPm/JVl6Pq4NW8wQGOaL5/Job14ETsmQGwnDKXkV8VswXlGoWzjX
         uy2rM+fJqokm39Ajd3CklczOOCOTffPeoZDtlfaIZyaJEPUkS2SaYtGn46fmLTDxTK94
         JRhQ==
X-Gm-Message-State: AC+VfDxAAhizwnvNPofTRP0SRgFxQ/QagtYtQnlgDbKb0WITCoqpKQh6
        5fKO0/LntTBv02Gc/zxvJRx2KQ==
X-Google-Smtp-Source: ACHHUZ7hDwL12K7vy21uD1u7QqOEq0vUvhx2DIvZ4gXF2e4I/pT4S2SYmti4bg81HlhOwI6Wry3TXA==
X-Received: by 2002:a05:6a00:23c8:b0:64b:43d8:a57d with SMTP id g8-20020a056a0023c800b0064b43d8a57dmr16791010pfc.13.1687382834771;
        Wed, 21 Jun 2023 14:27:14 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id e6-20020aa78c46000000b0065ecdefa57fsm3349261pfd.0.2023.06.21.14.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 14:27:14 -0700 (PDT)
Date:   Wed, 21 Jun 2023 14:27:13 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: smartpqi: Replace one-element arrays with
 flexible-array members
Message-ID: <202306211427.B13420A395@keescook>
References: <ZJNdKDkuRbFZpASS@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJNdKDkuRbFZpASS@work>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 21, 2023 at 02:27:20PM -0600, Gustavo A. R. Silva wrote:
> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element arrays with flexible-array
> members in a couple of structures, and refactor the rest of the code,
> accordingly.
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy().
> 
> This results in no differences in binary output.
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/204
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
