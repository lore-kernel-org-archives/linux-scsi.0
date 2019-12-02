Return-Path: <SRS0=lopX=ZY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E08C432C0
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 07:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3198215E5
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 07:01:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="N0aMOxI3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfLBHBo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Dec 2019 02:01:44 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44645 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbfLBHBo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2019 02:01:44 -0500
Received: by mail-wr1-f66.google.com with SMTP id q10so6576250wrm.11
        for <linux-scsi@vger.kernel.org>; Sun, 01 Dec 2019 23:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OIeJzPkfZfkQW+lmWkeb7QT4hklfgkIqwhLk0IajLpI=;
        b=N0aMOxI3Jdo7KPnUkFwlOU6WRz95oOUare7m7+UEZEH1gf0oxUY2Sg6BwmHMnmqsxA
         16sb6a2cCJGC6N9a5Z8MFlD6SRdnSa3brpX3oIbIX6dwHxxVrJLoNemalxtDUjRfi7hd
         B3+FaHjMo5z29AI7l8M6we/KAb458Hf2uVKk2fUC905zKCOK0bMfgi/cIOrgBp9nDmES
         u1FdhoQaIs3KeZp6rld6IjQJ2r1kugusvB8awjLaI/lXY4lxX8wTJejXHVuhseopbF2F
         lgTWq6l9iGr61CHvvTtWwcC5ZnjgxQTnPK4qL6Ka329egpWKhyXa6h3IUARfOIxTZKIf
         iwYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OIeJzPkfZfkQW+lmWkeb7QT4hklfgkIqwhLk0IajLpI=;
        b=ENe0VXX3XyQLLRI8DrrRJYjJsHpCglywE/IY1gmgJqg+BMWzNN4Og62M+wG62rODo3
         0QLlDNM8bE2donPhChiLq2y0vqO041HujK4Pc4bRR39h3TpylqiSjmiGVfRvoUnVxVKR
         /qFqAcc+izA/x2LQnxmfAaLv4avl0gUInxFzdNMrFX5YinrHZxqjLxfpw/UBUqbG8cOj
         jec732h42/lG8YYJQjTXl+ZrRa82OdoQnk9ysUF3iu/tRUhhzbfnojZXkKCW3RJiungs
         0bj5E/xj650lZSjIZJErGe4r3iDg3HRCkXWI1vCuWycIpasCEuTNW9hkPE30x7WPCLNI
         GISw==
X-Gm-Message-State: APjAAAV8+wnjkcNN/1P6nVn8a+exrqa6DnSq+4B6+1GwXvnQytWpksZP
        CNeyB37ur/sBZI8F+opgFTX4cw==
X-Google-Smtp-Source: APXvYqyl7g6ZdPSB/hceL6L6wfDEpdQFMZPEbs1pMw1w54KtldT/IG0NSVgZ9wWB3C2j/9a6/78T0g==
X-Received: by 2002:adf:eb08:: with SMTP id s8mr24816066wrn.5.1575270102144;
        Sun, 01 Dec 2019 23:01:42 -0800 (PST)
Received: from brian.unipv.it ([37.163.132.5])
        by smtp.gmail.com with ESMTPSA id y139sm18984178wmd.24.2019.12.01.23.01.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Dec 2019 23:01:41 -0800 (PST)
Date:   Mon, 2 Dec 2019 08:01:35 +0100
From:   Andrea Vai <andrea.vai@unipv.it>
To:     Bernd Schubert <bs_lists@aakef.fastmail.fm>
Cc:     Ming Lei <ming.lei@redhat.com>,
        "Schmid, Carsten" <Carsten_Schmid@mentor.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: AW: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
Message-ID: <20191202070135.GA4634@brian.unipv.it>
References: <0876e232feace900735ac90d27136288b54dafe1.camel@unipv.it>
 <20191126023253.GA24501@ming.t460p>
 <0598fe2754bf0717d81f7e72d3e9b3230c608cc6.camel@unipv.it>
 <alpine.LNX.2.21.1.1911271055200.8@nippy.intranet>
 <cb6e84781c4542229a3f31572cef19ab@SVR-IES-MBX-03.mgc.mentorg.com>
 <c1358b840b3a4971aa35a25d8495c2c8953403ea.camel@unipv.it>
 <20191128091712.GD15549@ming.t460p>
 <f82fd5129e3dcacae703a689be60b20a7fedadf6.camel@unipv.it>
 <20191129005734.GB1829@ming.t460p>
 <3c57bba1-831b-fc97-d5f7-e670f43fbbdc@aakef.fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c57bba1-831b-fc97-d5f7-e670f43fbbdc@aakef.fastmail.fm>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29/11/19 12:44:53, Bernd Schubert wrote:
> >> Trace attached. Produced by: start the trace script
> >> (with the pendrive already plugged), wait some seconds, run the test
> >> (1 trial, 1 GB), wait for the test to finish, stop the trace.
> >>
> >> The copy took 73 seconds, roughly as already seen before with the fast
> >> old kernel.
> > 
> > This trace shows a good write IO order because the writeback IOs are
> > queued to block layer serially from the 'cp' task and writeback wq.
> > 
> > However, writeback IO order is changed in current linus tree because
> > the IOs are queued to block layer concurrently from the 'cp' task
> > and writeback wq. It might be related with killing queue_congestion
> > by blk-mq.
> 
> What about using direct-io to ensure order is guaranteed? Pity that 'cp'
> doesn't seem to have an option for it. But dd should do the trick.
> Andrea, can you replace cp with a dd command (on the slow kernel)?
> 
> dd if=<path-to-src-file> of=<path-to-copy-on-flash-device> bs=1M
> oflag=direct

On the "new bad patched" kernel, this command take 68 seconds to complete (mean on 100 trials, with a narrow standard deviation), so perfectly
aligned with the cp command on the old fast good kernel.

Thanks, and bye
Andrea
