Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A303EB64DC
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jul 2023 05:53:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjGJFxM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jul 2023 01:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjGJFxM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jul 2023 01:53:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D3DFB
        for <linux-scsi@vger.kernel.org>; Sun,  9 Jul 2023 22:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688968345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2K52jyfMXQ896NNNb2VdJ1cCkY7IZeKXb4JhCxLXus4=;
        b=SNxSiZnnUfquI0gvJPH3WE9Bv8henUDhK+INhI+6JyRuH9I+ylGxn0l23PVsJ1CSKGdE8R
        wUyGs/T/ECTWFoeBjoJxTVJW9E4aDMf7ZLfV6ot8FT7OFikdlS75S/qbmFiCrPvnh8tN/p
        vYY1XBdtGPbaFhsIvK0PLlGdTjoXpbk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-168-Q_lcSqv9NhKBkjg5obHSMw-1; Mon, 10 Jul 2023 01:52:24 -0400
X-MC-Unique: Q_lcSqv9NhKBkjg5obHSMw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3fa979d0c32so24124765e9.2
        for <linux-scsi@vger.kernel.org>; Sun, 09 Jul 2023 22:52:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688968343; x=1691560343;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2K52jyfMXQ896NNNb2VdJ1cCkY7IZeKXb4JhCxLXus4=;
        b=K8HUtMPTcXE5y5NoTWUxI/MQNWDE3+4A9N8rCD4bv8++pbrGhPYp50uAA/7SCJ0S2x
         2dRNuAAnA5pbv6n28SYn6fDb7k9tU51tH77YzgImhGluj5+vAV0WQpdziqmeEULI5vtH
         1yd8vvCe5eenagN0msbf2iGOjfJEUUZzRcXvGH+6Ey/jvZaoOnEZDY/HhTAy9MeLwCDj
         0m7r+XYyzEZcRwGO6IFG5B/omvpeGe8DsJsLaMEnH4Dkmsu55czsrgpyHXWpbHoWPlfS
         aLIiQ0kDwqYPLJjcgw8ZmklA7OUh5D7peM/QYwL3kk2E7+6B7lgh/LnsD7feT4AZmIQv
         7mkA==
X-Gm-Message-State: ABy/qLYNfJ5P/8UNwlp3GgssJ6nCoJCBAWvCDT3UjIR1IXghChsU5gg0
        yzACsxUrKTMz85fuuk+epCYytiU+tPiPr9czQ0JWN3LW1NKI73U+igxTpNB8wlNWisr2EoddCGs
        yGUC44/qOpLTfm27n8RVwHEAFXiVQtQ==
X-Received: by 2002:a05:600c:2313:b0:3fc:521:8492 with SMTP id 19-20020a05600c231300b003fc05218492mr5262416wmo.5.1688968342928;
        Sun, 09 Jul 2023 22:52:22 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEX0MBIPIVZb0Ml0+vup7VUgMycj1blZD7PFdfB9Im1EaU1Fa8yaiSZY7CKGQPrbwAQn1eEsQ==
X-Received: by 2002:a05:600c:2313:b0:3fc:521:8492 with SMTP id 19-20020a05600c231300b003fc05218492mr5262405wmo.5.1688968342576;
        Sun, 09 Jul 2023 22:52:22 -0700 (PDT)
Received: from redhat.com ([2.52.3.112])
        by smtp.gmail.com with ESMTPSA id i8-20020a5d5588000000b0030fa3567541sm10646951wrv.48.2023.07.09.22.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jul 2023 22:52:22 -0700 (PDT)
Date:   Mon, 10 Jul 2023 01:52:19 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 0/2] vhost-scsi: Fix IO hangs when using windows
Message-ID: <20230710015042-mutt-send-email-mst@kernel.org>
References: <20230709202859.138387-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230709202859.138387-1-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jul 09, 2023 at 03:28:57PM -0500, Mike Christie wrote:
> The following patches were made over Linus's tree and fix an issue
> where windows guests will send iovecs with offset/lengths that result
> in IOs that are not aligned to 512. The LIO layer will then send them
> to Linux's FS/block layer but it requires 512 byte alignment, so
> depending on the FS/block driver being used we will get IO errors or
> hung IO.
> 
> The following patches have vhost-scsi detect when windows sends these
> IOs and copy them to a bounce buffer. It then does some cleanup in
> the related code.


Thanks, tagged!
Mike, you are the main developer on vhost/scsi recently.
Do you want to be listed in MAINTAINERS too?
This implies you will be expected to review patches/bug reports
though.

Thanks,
-- 
MST

