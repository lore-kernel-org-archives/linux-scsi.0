Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15337C4CEC4
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 07:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFA4421848
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 07:33:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="oAPLCnUv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387831AbfISHdM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 03:33:12 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:33682 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728850AbfISHdM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Sep 2019 03:33:12 -0400
Received: by mail-wr1-f53.google.com with SMTP id b9so1965788wrs.0
        for <linux-scsi@vger.kernel.org>; Thu, 19 Sep 2019 00:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=s5uEbgPExVBChyzqNC67yVPJbV4//87tMpw3BUINnI8=;
        b=oAPLCnUv3TXHX1wxIbCDLoMyrFFC5MDgbELmO04CVod7cJWw7jiunGONHRAkd/WcEF
         Lh06r7C4CULiYjwM4FKL1LHmrD49WnKk8slvCAepPWnDtzbFqbvDQLrv5nuBoJSJpMEF
         4/Z/VklVT8dYWFEqkGSY+Fo7Pui6iz6z0g1lXlVutzjNAl9hkM8xv+UqelSWd3Q9qjTC
         QpjXjYgGiO3HFaJpVj4Um2nwn8fKzFHHZkVOrxXbaINj2tGJVt1EnzAY6wF8aiKI0QZc
         WKH9VfGBSx4Wt7HYqf3WVabjQoRQoVF2nMdsBUX/ECnsCi4WgnmVgOTnTNh7yU6dG2ls
         nVVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=s5uEbgPExVBChyzqNC67yVPJbV4//87tMpw3BUINnI8=;
        b=jBc/Vq7me5wqTjrlM4/Km6lOHlFni6Vz4O9rxGAET/wy4vKGJY00vgV4swPh1onKIk
         zEBqKAUGvR8isy/TKl9gAryPj/VaxvqpqUWZW+TsRERIJIoSoeUUwupAAvyc6+CxoTPF
         sn5QRxy4i3hdZbKtPrjvWOT3cC9mM4Z59jyTVEpiJzIImO5yhPL5ShKcClVdqf6+RvVH
         llW6JwtxXWhwXgINP5mROq+7zXuxkdUo48FHUX0hT31yevdBP8exxXQjG1Zh2JrMAYhT
         hZ7fbOAc9XO3fQDp+gIQ0LVpJxB2J2L6/UrRQk1WkEWg3t1kqQ7LsP7kx5kcVnPLnRJc
         wmeQ==
X-Gm-Message-State: APjAAAWVdXwQ1iysVDFONFNnZHzYIxTPyrj1YXCOjvfil0v8dP4YnfO2
        M2LbHBe/MvKIi2CWd7GR4Jgr4A==
X-Google-Smtp-Source: APXvYqxRq+llXOmONT/aJROch3Yq3MyYDtMvPry9advFESvYl1nKqvuj+bSxdS3D4R8NwBRmjQwBUA==
X-Received: by 2002:a05:6000:12c9:: with SMTP id l9mr5868260wrx.163.1568878388315;
        Thu, 19 Sep 2019 00:33:08 -0700 (PDT)
Received: from angus.unipv.it (angus.unipv.it. [193.206.67.163])
        by smtp.gmail.com with ESMTPSA id 207sm8957158wme.17.2019.09.19.00.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 00:33:07 -0700 (PDT)
Message-ID: <7db7c96626121e614320a87cc5ec4f48996211c5.camel@unipv.it>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
From:   Andrea Vai <andrea.vai@unipv.it>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Johannes Thumshirn <jthumshirn@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
Date:   Thu, 19 Sep 2019 09:33:02 +0200
In-Reply-To: <Pine.LNX.4.44L0.1909181213141.1507-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1909181213141.1507-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Il giorno mer, 18/09/2019 alle 12.30 -0400, Alan Stern ha scritto:
> On Wed, 18 Sep 2019, Andrea Vai wrote:
> [...]
> > BAD:
> >   Logs: log_10trials_50MB_BAD_NonCanc_64.txt,
> > log_10trials_50MB_BAD_NonCanc_non64.txt
> >   64: 34, 34, 35, 39, 37, 32, 42, 44, 43, 40
> >   not64: 61, 71, 59, 71, 62, 75, 62, 70, 62, 68
> > GOOD:
> >   Logs: log_10trials_50MB_GOOD_NonCanc_64.txt,
> > log_10trials_50MB_GOOD_NonCanc_non64.txt
> >   64: 34, 32, 35, 34, 35, 33, 34, 33, 33, 33
> >   not64: 32, 30, 32, 31, 31, 30, 32, 30, 32, 31
> 
> The improvement from using "64" with the bad kernel is quite
> large.  
> That alone would be a big help for you.

Well, not so much, actually, because the backup would take twice the
time, that is quite annoying for me. But, apart from that, and from
the efforts of Alan and other people following this issue (thanks), I
would like to point out what I am not sure to have ever made clear
about my support request: I have understood that my problem is quite
specific, and don't want anyone to waste their time to help
specifically *me* (I can buy another media, use the "64" tweak, or
find any other workaround). But since we have identified the problem
as kernel-related, I am worried for other users, maybe new to linux,
that can have the same problem, and the evidence for them would be
that linux is extremely slow to copy file over some USB media. So,
among all the technical comments, I would like to make clear (if it's
not already clear) that in my opinion it would be important to solve
the problem without the need of user workarounds. Does it make sense?
Are we moving towards that goal?

BTW, another question: Alan refers to the slow media as a "consumer-
grade USB storage device". What could I do to identify and buy a "good
media"? Are there any features to look for?

Many thanks, and sorry if I ask anything obvious.
Bye,
Andrea

