Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C44FDC010C6
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 11:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98A6B21D6C
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 11:48:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="KI9+aUbc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388155AbfKELsr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 06:48:47 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38876 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730816AbfKELsr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 06:48:47 -0500
Received: by mail-wm1-f68.google.com with SMTP id z19so15607247wmk.3
        for <linux-scsi@vger.kernel.org>; Tue, 05 Nov 2019 03:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=LpNq9BZEzcBsPjl2fwGhxUI4p8CxhaTMp7/DMtc0Tzw=;
        b=KI9+aUbcov74z4OaAXNWUWbeLzdg8DbG3S2miuQLMt3Uml7yDXyPmnBaJDTbk0eUef
         9wiZ7OlgVcK3aYQCtsAnJBZwLGI5ogA7nDHzAyDVvfwxe6YbctPHYwocPHyS/bycuxgI
         g2uQJ0c4jvgU//F3SyBAddI9l83920U/bo1QcaBmBLgSCeouEBPFpii3p+64ndRAxG97
         IHGnjUZb4ehLb+agNJlsusvEEaR7EFxQ2gAIFckLDhyOR4WZkhRay33ZVG7y0cBGBAeb
         Ld3gqMYS9GyNYJmzKdpHsh+whHAjT8yJAGOHzRrU1aG98bKQeLWAMmX5PaKZignuVoD1
         SNNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=LpNq9BZEzcBsPjl2fwGhxUI4p8CxhaTMp7/DMtc0Tzw=;
        b=YlLQ5WRK85cff9/8JXhTfsGYX0fH59yWuGolcLDfGR/yio+Xe+X9jAEKCJL0xOOdDP
         AZbnCfF6XfXsy4WzpUPXi3cET3q1FcqgVgULEawgb4d2pJrstE7kp7XvNZVdxE4Fmrcv
         cE8w/9l7i4+CgUcG39agiQ6Ig9NWDKdZz61W5DRxmSoEGxSL7sczPyGkp+ZhpYisXFFd
         FlSHvNuRIles+RkyLwuT9KLVUhbd+6ELKQz4YG32py47PqDsafWtzbMgclbm5zuHcOq2
         AMnE9l8lVjMeFXrhLGHuB9VVjzQph1jZq9+dUW3Tcn5vO6FCgTtPgB2FQKeTEQdcOb/k
         oPUw==
X-Gm-Message-State: APjAAAXbXyuGcqbR3+QPuCXl5o5NsHyGHovDQXfyrRBLxiZZZwzSIeQu
        egSst2mYxKiu7p/v2pMs0b+xLQ==
X-Google-Smtp-Source: APXvYqweS3le3W871Mi2XCp7mQy9hB83kcFi9F1QrG1nG+PCkN1aNHbQ6+Gba2cPfasng8QNYKKYHw==
X-Received: by 2002:a7b:ca51:: with SMTP id m17mr3567639wml.110.1572954524617;
        Tue, 05 Nov 2019 03:48:44 -0800 (PST)
Received: from angus.unipv.it (angus.unipv.it. [193.206.67.163])
        by smtp.gmail.com with ESMTPSA id v128sm26856481wmb.14.2019.11.05.03.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 03:48:43 -0800 (PST)
Message-ID: <0cd6ac36b7ab644576fc0f3f5bd4a880c33855d1.camel@unipv.it>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
From:   Andrea Vai <andrea.vai@unipv.it>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>
Date:   Tue, 05 Nov 2019 12:48:42 +0100
In-Reply-To: <Pine.LNX.4.44L0.1911041316390.1689-200000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1911041316390.1689-200000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Il giorno lun, 04/11/2019 alle 13.20 -0500, Alan Stern ha scritto:
> On Mon, 4 Nov 2019, Andrea Vai wrote:
> 
> > > The "linux" directory is the one generated by a fresh git clone:
> > > 
> > > git clone
> > > git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> > > 
> > > What am I doing wrong?
> > > 
> > 
> > Meanwhile, Alan tried to help me and gave me another patch
> (attached),
> > which doesn't work too, but gives a different error: "The git diff
> > header does not contain information about the file once removed 1
> > initial component of the path (row 14)" (actually, this is my
> > translation from the original message in Italian: "error:
> > l'intestazione git diff non riporta le informazioni sul file una
> volta
> > rimosso 1 componente iniziale del percorso (riga 14)")
> > 
> > I tested the two patches after a fresh git clone today, a few
> minutes
> > ago.
> > 
> > What can I do?
> 
> You should be able to do something like this:
> 
>         cd linux
>         patch -p1 </path/to/patch2
> 
> and that should work with no errors.  You don't need to use git to 
> apply a patch.
> 
> In case that patch2 file was mangled somewhere along the way, I
> have 
> attached a copy to this message.

Ok, so the "patch" command worked, the kernel compiled and ran, but
the test still failed (273, 108, 104, 260, 177, 236, 179, 1123, 289,
873 seconds to copy a 500MB file, vs. ~30 seconds with the "good"
kernel).

Let me know what else could I do,

Thanks, and bye
Andrea

