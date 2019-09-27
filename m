Return-Path: <SRS0=gVs6=XW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A38C4360C
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 15:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E90E217D9
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 15:48:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="F8Vqnjtp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbfI0PsF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Sep 2019 11:48:05 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43791 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbfI0PsE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Sep 2019 11:48:04 -0400
Received: by mail-wr1-f65.google.com with SMTP id q17so3560426wrx.10
        for <linux-scsi@vger.kernel.org>; Fri, 27 Sep 2019 08:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=zNygO4nZbG8/YUnKqk0A4+s04ZnimyIFx8+zQJsWWR4=;
        b=F8VqnjtpiQva2+8AhZMoRXjcWPOver4Ozp+Fmt9VtUyPEWb/LpHpJtDk98njMH4c1b
         JAnXTsRwPfq/nAFMr+GMFYrVh9Jlg7Eexywbr79iG+uhaD33bni+cL5e1DIphP5SFfkX
         m7Ov0oTJHe/5ytGcZz+Zs7V6VSfTN5LgbHyZ4G0oo3/4N2o2ulnI77qF4HGFcBcUtGaO
         g+GG4TGLoc1b2ztrkFCIDX5gAESCBtn83CdIDsxqJpJtrkSCjrzLpvo0q2Lcqf8NPz+z
         xDAgwZDqFCzhuq7ZseYRGkscyeVF+/7TAtr5xkRggHhyeROYeP7DKXEjNzYacZcu9vBN
         GGxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=zNygO4nZbG8/YUnKqk0A4+s04ZnimyIFx8+zQJsWWR4=;
        b=VhSUi7RjGeanrn93T6ZMzrFF7glC5Pfr/zf9I/8XJAlrTIQkZyE8sTGcWRzidQQHSJ
         zxHE/sPffOpnC9LG+gkMRL2iVZPshV++/Imiq7iubLb5ZwBXyn0XWOOgdpWRW82iMVm7
         Zop3B5An3ObWm0pOEkkYWky09HU71nqT+itnKgrN6z9XfEnhEthFuvPpEzlA0viDYB8X
         yElTwKewqe4HXauDV/Imak9W0Ics58zzQSkl1LTNVHBpSIDQ8YyCQMEKWt3E0HvNwK1K
         nutExtdBOqvMEUgO6CNoD25Ud6a3Z//3tMmFkisrWm09Sinu4SBLiyI1pDjYcyoAKAj2
         1oXA==
X-Gm-Message-State: APjAAAW2nkUDsmLd04Bb6pSYlnOp5ak7kIH8qK+TNcVSGy9nqUYvLWL3
        v2tSpDg5kWroYGRFwpRL1laZvA==
X-Google-Smtp-Source: APXvYqxuA47datR0fG5sqPH/xVEdbMeYEzLdcJBN/sv+dgRVDt75FvmhFNkEeny4Wq/b0dGjWdt3Ug==
X-Received: by 2002:a05:600c:290c:: with SMTP id i12mr8057771wmd.77.1569599281150;
        Fri, 27 Sep 2019 08:48:01 -0700 (PDT)
Received: from angus.unipv.it (angus.unipv.it. [193.206.67.163])
        by smtp.gmail.com with ESMTPSA id x6sm11316605wmf.38.2019.09.27.08.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 08:48:00 -0700 (PDT)
Message-ID: <237f37abfe8a6985f7ff26d5f199a33c18685f90.camel@unipv.it>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
From:   Andrea Vai <andrea.vai@unipv.it>
To:     Jens Axboe <axboe@kernel.dk>,
        Alan Stern <stern@rowland.harvard.edu>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>
Date:   Fri, 27 Sep 2019 17:47:59 +0200
In-Reply-To: <c304abca-3ac2-fb19-1328-340ca4f18f80@kernel.dk>
References: <Pine.LNX.4.44L0.1909251524520.6072-300000@netrider.rowland.org>
         <c304abca-3ac2-fb19-1328-340ca4f18f80@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Il giorno mer, 25/09/2019 alle 21.36 +0200, Jens Axboe ha scritto:
> On 9/25/19 9:30 PM, Alan Stern wrote:
> [...]
> > 
> > I have attached the two patches to this email.  You should start
> with a
> > recent kernel source tree and apply the patches by doing:
> > 
> > 	git apply patch1 patch2
> > 
> > or something similar.  Then build a kernel from the new source
> code and
> > test it.
> > 
> > Ultimately, if nobody can find a way to restore the sequential I/O
> > behavior we had prior to commit f664a3cc17b7, that commit may have
> to
> > be reverted.
> 
> Don't use patch1, it's buggy. patch2 should be enough to test the
> theory.

Sorry, but if I cd into the "linux" directory and run the command

# git apply -v patch2

the result is that the patch cannot be applied correctly:

------------------------------------------------------------------------------
Controllo della patch block/blk-mq.c in corso...
error: durante la ricerca per:
?
static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)?
{?
	const int is_sync = op_is_sync(bio->bi_opf);?
	const int is_flush_fua = op_is_flush(bio->bi_opf);?
	struct blk_mq_alloc_data data = { .flags = 0};?
	struct request *rq;?

error: patch non riuscita: block/blk-mq.c:1931
error: block/blk-mq.c: la patch non si applica correttamente
------------------------------------------------------------------------------

The "linux" directory is the one generated by a fresh git clone:

git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

What am I doing wrong?

Thanks, and bye
Andrea

