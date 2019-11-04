Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B0ACA9ED3
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 16:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E78D920842
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 16:00:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="dxFaqn32"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbfKDQA6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 11:00:58 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36557 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfKDQA6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 11:00:58 -0500
Received: by mail-wm1-f67.google.com with SMTP id c22so16644289wmd.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 08:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=6ilGxiuyygbgJ91BJLPjx/F0PdqLRxqiJ4GF3dV8ihU=;
        b=dxFaqn32bPE40sYACqfPVi5uAANE8q8D/rMKn8aj1ddfeRX/eDvzkZCGJfrxg/474h
         XryK5LbJhbCZJ6tnTtzN5Wp2lMeP5D453UA5cxlqiCK3P/cv5htVRlVQwAC3GA54Bgpr
         1cMOymEQKNtHhCD6t5xquqAiHET5BqwxToQpzIsugHhkg6BMTPDJS5AX3+zjtSgs4WD7
         r6XiLJTKslMFR6GPZg1U31TPMuwD45N4Tnmqi6mHR6T7N+nPP8cdqppvXQmRCQEaZLAs
         zSkPn73uVIpaamxWGLsCmSSaSa0GbZ0riDAhZr3fYNXt8mtee/zHS46uW4wODFUe2fsb
         cYmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=6ilGxiuyygbgJ91BJLPjx/F0PdqLRxqiJ4GF3dV8ihU=;
        b=BWe4fuFbnzMekXuaX09wnUhd135yrqVMfP4qbo8JCqWxt9ZWf+Hwejoz4IjPFieC7T
         97ljZ33CDVrtJvsOVWRzIYB/hZ8aJrkIA7wMnnaSC86xOCIhu/PwRwLdNwCP9yFtoucb
         rIXJndAjkdzBQUu4qLD2VIqsB/RUb4oTn3XRmTDth5R4fUV1Jmdcy9zzwZf86vAbCPu2
         pcwJXaAmfd0t3qeRvqBw5LNb91iIusjOy3Ig5oWwzZlsf3w1DC3b4+H3kFCYGoPSTZ7U
         oYthO1T55uEG67UuHzndL+7JVwkrDwDjQ4KoBCNH43F3vma2vMMRWPdUv8/6q2ko8yFq
         1YMw==
X-Gm-Message-State: APjAAAW2WN8F00lROrBUlvsTGAPbFMZaubFFRPGQZcCTa94kYVxxAC83
        XCI1MfvGO4v7BnPVBiG6s4ucgA==
X-Google-Smtp-Source: APXvYqz9QniqmUkTnlQX6SGFL0FdOohcr7i6mkkhTi68CjJaUsuQP1yRsXVaxVkld0s7KvD9ZwZ4OA==
X-Received: by 2002:a1c:6282:: with SMTP id w124mr23112566wmb.172.1572883254524;
        Mon, 04 Nov 2019 08:00:54 -0800 (PST)
Received: from angus.unipv.it (angus.unipv.it. [193.206.67.163])
        by smtp.gmail.com with ESMTPSA id y78sm10176394wmd.32.2019.11.04.08.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 08:00:53 -0800 (PST)
Message-ID: <38f1974fad3a98ca578fcf808a843cbd28325e44.camel@unipv.it>
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
Date:   Mon, 04 Nov 2019 17:00:52 +0100
In-Reply-To: <237f37abfe8a6985f7ff26d5f199a33c18685f90.camel@unipv.it>
References: <Pine.LNX.4.44L0.1909251524520.6072-300000@netrider.rowland.org>
         <c304abca-3ac2-fb19-1328-340ca4f18f80@kernel.dk>
         <237f37abfe8a6985f7ff26d5f199a33c18685f90.camel@unipv.it>
Content-Type: multipart/mixed; boundary="=-/eumaMO/ShtWP2soswYE"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--=-/eumaMO/ShtWP2soswYE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Il giorno ven, 27/09/2019 alle 17.47 +0200, Andrea Vai ha scritto:
> Il giorno mer, 25/09/2019 alle 21.36 +0200, Jens Axboe ha scritto:
> > On 9/25/19 9:30 PM, Alan Stern wrote:
> > [...]
> > > 
> > > I have attached the two patches to this email.  You should start
> > with a
> > > recent kernel source tree and apply the patches by doing:
> > > 
> > > 	git apply patch1 patch2
> > > 
> > > or something similar.  Then build a kernel from the new source
> > code and
> > > test it.
> > > 
> > > Ultimately, if nobody can find a way to restore the sequential
> I/O
> > > behavior we had prior to commit f664a3cc17b7, that commit may
> have
> > to
> > > be reverted.
> > 
> > Don't use patch1, it's buggy. patch2 should be enough to test the
> > theory.

As I didn't have any answer, I am quoting my last reply here:

> 
> Sorry, but if I cd into the "linux" directory and run the command
> 
> # git apply -v patch2
> 
> the result is that the patch cannot be applied correctly:
> 
> --------------------------------------------------------------------
> ----------
> Controllo della patch block/blk-mq.c in corso...
> error: durante la ricerca per:
> ?
> static blk_qc_t blk_mq_make_request(struct request_queue *q, struct
> bio *bio)?
> {?
> 	const int is_sync = op_is_sync(bio->bi_opf);?
> 	const int is_flush_fua = op_is_flush(bio->bi_opf);?
> 	struct blk_mq_alloc_data data = { .flags = 0};?
> 	struct request *rq;?
> 
> error: patch non riuscita: block/blk-mq.c:1931
> error: block/blk-mq.c: la patch non si applica correttamente
> --------------------------------------------------------------------
> ----------
> 
> The "linux" directory is the one generated by a fresh git clone:
> 
> git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> 
> What am I doing wrong?
> 

Meanwhile, Alan tried to help me and gave me another patch (attached),
which doesn't work too, but gives a different error: "The git diff
header does not contain information about the file once removed 1
initial component of the path (row 14)" (actually, this is my
translation from the original message in Italian: "error:
l'intestazione git diff non riporta le informazioni sul file una volta
rimosso 1 componente iniziale del percorso (riga 14)")

I tested the two patches after a fresh git clone today, a few minutes
ago.

What can I do?

Thank you,
Bye
Andrea

--=-/eumaMO/ShtWP2soswYE
Content-Type: message/rfc822; name="patch2_alan"
Content-Disposition: attachment; filename="patch2_alan"

From: Hannes Reinecke <hare@suse.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
Index: usb-devel/block/blk-mq.c
Date: Mon, 04 Nov 2019 16:58:21 +0100
Subject: No Subject
Message-ID: <fe072bc69e13435573d824133c3981f8841cf2c7.camel@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


--=-/eumaMO/ShtWP2soswYE--

