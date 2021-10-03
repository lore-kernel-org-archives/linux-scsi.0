Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55767C433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Oct 2021 21:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C2C16135A
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Oct 2021 21:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhJCVMX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Oct 2021 17:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbhJCVMV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Oct 2021 17:12:21 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F725C0613EC
        for <linux-scsi@vger.kernel.org>; Sun,  3 Oct 2021 14:10:32 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id z2so11794091wmc.3
        for <linux-scsi@vger.kernel.org>; Sun, 03 Oct 2021 14:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=rDqU9u2i63GWk/0t1KQooyI45+43cwhYPuWn6nUU7Mw=;
        b=UY9SG74yxRnkmEH65d1qarNnh2Jnnf/khUki8SCLqdH6QgWE1LrneSl9MQqTjMV9Qs
         URmJk1QEm5eO2gvflg2jcO2treyIYLgQrXdL3jWO2Nn3TDwNws+XnxahUzSR9K0pspj0
         JFcudp1JbHvwCY8eQ4nbFPIU/dr9wPkYm2aybLOyAn9RNji4psElyEf4I9v0SzT0BYLN
         dN3burY1Wv4Sd+fNe00JQEFESPPafy3kWlKK+rVdWT9A5BYDoyuS7GNJMqiahj95vEYX
         As62OP3LwqWG2oTjJMoy77n+LbNQ5zRsFOERJ/6B/htZiVnGJpOTvZeQi9ey92vi33Dn
         ljMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=rDqU9u2i63GWk/0t1KQooyI45+43cwhYPuWn6nUU7Mw=;
        b=WM8RqcAt8JKHAqJYeYo9JeHrzo/8S0h0pJkyNN0o/EQfRak+sUkWhdXrxqzykc+yc0
         qPWncLkyVcEl0w9XnofqKa5xx8vsl6qGGudcG29TC208qaOzeNiolQ3ZtCPjT0r+Rcu8
         sGBH8TG86SsTK24gf7sUF3ASfHpiO04uCPTxnVEV3LzAbX1WCUHN0jkVVTCBt4nv6ODu
         slnud6DjUq6TWM7ca/dMICH8etRZExJYMbPnyTE2N7hOD5y3GsTWKJQu/H+oTQ2S15yn
         EUbhF1jRflk84eP8VA+/qDK9UXLDKFMyH+0fgRqcAtJNf29N3zbhzWHJmRK66x6K0hi+
         I3uQ==
X-Gm-Message-State: AOAM533XQTTTMR71P7hGKlT1bu1BhU5ZlJ/YF1YxLhrxIsQEg9swx+hh
        MxN0lDB6CSTo8aHhF62lkF0=
X-Google-Smtp-Source: ABdhPJxC9ridShb1nQyYNs4q2ogGJl6On95zBGj6NPt7JyXYja+qP2s/WE9Lv9KQNEzRyhPRTeFoEA==
X-Received: by 2002:a05:600c:4f95:: with SMTP id n21mr15695065wmq.22.1633295430857;
        Sun, 03 Oct 2021 14:10:30 -0700 (PDT)
Received: from p200300e94717cf648712b27b14e4a39f.dip0.t-ipconnect.de (p200300e94717cf648712b27b14e4a39f.dip0.t-ipconnect.de. [2003:e9:4717:cf64:8712:b27b:14e4:a39f])
        by smtp.googlemail.com with ESMTPSA id f8sm12161384wrx.15.2021.10.03.14.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 14:10:30 -0700 (PDT)
Message-ID: <7b43a5c7a8f0b3d81e4d940e88c0e93b14c66ca3.camel@gmail.com>
Subject: Re: [PATCH v2 02/84] scsi: core: Rename scsi_mq_done() into
 scsi_done() and export it
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Date:   Sun, 03 Oct 2021 23:10:29 +0200
In-Reply-To: <20210929220600.3509089-3-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
         <20210929220600.3509089-3-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-09-29 at 15:04 -0700, Bart Van Assche wrote:
> Since the removal of the legacy block layer there is only one
> completion
> 
> function left in the SCSI core, namely scsi_mq_done(). Rename it into
> 
> scsi_done(). Export that function to allow SCSI LLDs to call it
> directly.
> 
> 
> 
> Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>

