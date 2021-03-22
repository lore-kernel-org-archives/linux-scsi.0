Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4546C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 21:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EC15619A7
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 21:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhCVVDK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 17:03:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32774 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229879AbhCVVC6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 17:02:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616446978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cg+ix9U+S3p+Ww+UesUjcp7HVf7bSkuCffgs0exlDCY=;
        b=QT8xw6Lgje0VBIuH4ijQuJ47qt2spCwR+bj7fTy1DjDtcDwhdXAGHgw+IkGYfav4uJfbIr
        GJuOTYFp5LOQtCovVSicTMq28kq1vNQYamhp+ififP2LucnDrxSaad1MgYJtNcaj/zhlRK
        DV5yYsJjBJla+fEwurP6iMEZTZ6+TF0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-60O5xZZ0NOqG8snGG1Ue9Q-1; Mon, 22 Mar 2021 17:02:56 -0400
X-MC-Unique: 60O5xZZ0NOqG8snGG1Ue9Q-1
Received: by mail-qv1-f72.google.com with SMTP id x20so261058qvd.21
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 14:02:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=cg+ix9U+S3p+Ww+UesUjcp7HVf7bSkuCffgs0exlDCY=;
        b=fpvzmkcTzZ+hOAQnQ1yUQKi1gqlPdGaYwFsIX4POOOIUQfppRhWl585i/VrWB/oQOu
         +X7obLNeOzvRSAgFrExByPQOr0yEN+GkWSoYRtDEPF9Hm4E9nz1E+QLwXzC40FR9qQji
         +Zw+vgStbblmH9yXBgDJ8JCBSWWfMLoe4JpnJe8mY8OMeilGjEDkw224ZtxiSvsPWn16
         S+IA/Z4fi4MH2jTJbBmikBgb5vonadgcEDFTZ7lryEfCzhWDSAyiv2FvdM0LORMAyiX6
         fjsX+pRCxxMghyNflEwYUAtiJquk/I3Pg7KxeWGheZ5iW0VYn/vAqIrKneF1M5BkxiIO
         nikw==
X-Gm-Message-State: AOAM530iAw2N9Gj544pedIfFLUV6UtWP0BhWjQaiKbtt26IbfvkRWtKe
        pLINniTOyVrhdcPDXW21ei7iWTd8qoLUKHF7DP5MNj47zZgJN49cmEDuI9eht1ci9KLZ0TP6Hq2
        hydmu9ICf6x0VSxxqJzLwZRO/t+1hvZxorxpsoMvsQtzelGfDdT1Bh6WryOc1pCoVy9RmDm6Ykg
        ==
X-Received: by 2002:a05:620a:e10:: with SMTP id y16mr2054954qkm.375.1616446975991;
        Mon, 22 Mar 2021 14:02:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxo72WHqvXUA6PrDoRXAWuoY6aRq2Tbe59ZQ+cASZOrVdfqPriCIMCn49zMDSjeMyHVJgJh7Q==
X-Received: by 2002:a05:620a:e10:: with SMTP id y16mr2054922qkm.375.1616446975663;
        Mon, 22 Mar 2021 14:02:55 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e7f:cee0:ccad:a4ca:9a69:d8bc])
        by smtp.gmail.com with ESMTPSA id y1sm11560861qki.9.2021.03.22.14.02.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Mar 2021 14:02:54 -0700 (PDT)
Message-ID: <fa08c1edd1aeede6d5c8109b8a473120cca5e35b.camel@redhat.com>
Subject: Isssues with very large LUN count servers and booting becoming more
 and more of a problem
From:   Laurence Oberman <loberman@redhat.com>
To:     linux-scsi <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>, Ewan Milne <emilne@redhat.com>,
        "Van Assche, Bart" <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>
Date:   Mon, 22 Mar 2021 17:02:54 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello
We have been struggling with this for years.
Systems are getting so large now that a system with multi-terabyte
memory and 1000's of device paths is becoming common.

For example, customers are seeing 16 paths and with a 1000 LUNS thats
16000 multiline console log discovery etc.

We land up in Emergency mode and various incatanations of "cant boot"
due to console putput slowdown that (while worse on serial consoles) is
still huge overhead that can even require us to use watchdog_thresh on
the kernel line to prevent the NMI's

I started thinking about a new parameter for scsi_mod that could be
used by sd and the scsi_dh_alua probing / discovery messaging (that is
so noisy), to quieten it down.

Before I even put efort into this, I wanted to see if you folks have an
appetite for this.

We have been blacklisting HBA drivers and using verious printk masks
etc to overcome this but a way to mask this within sd.c and
scsi_dh_alua.c I think could work better.
It would not be the default of course but an option to be added for
these huge customers.
I would look do do the minimal logging for a device discovery, just so
some messaging is there for debug etc and I think it will help.

If this is a crazy idea, let me know and I wont pursue it, but I
decided to just put it out there.

Best Regards
Laurence Oberman

