Return-Path: <SRS0=IzRR=ZR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A84B9C43215
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 18:51:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 870A320748
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 18:51:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="0q6Imda0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfKYSvi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Nov 2019 13:51:38 -0500
Received: from mail-wr1-f47.google.com ([209.85.221.47]:43570 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfKYSvh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Nov 2019 13:51:37 -0500
Received: by mail-wr1-f47.google.com with SMTP id n1so19473988wra.10
        for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2019 10:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=DXGmbfWdvrXuzWAE8BTOxQjhRPkzvMn2ZsCmjYzmHWg=;
        b=0q6Imda0TKBHEocYjyoSHIc0I6FRCKxOhTi8Zqg1IED3XejYap3FokRHDhuJkUBpnb
         atX5/nUhOZTRxVZIP1RBj3prnNo01hrBVS6/9h0boB3cdpGd00MMjbQCuLPjWH8ghS/2
         +I7CIIR5VYVN05/X8cDCLajhxNC8mZOygCIivvDQACae+/BoQ05kpCrwiwRZmeC5COsV
         u3w3eepWApVFgdKhrR/eoGIvXNDkiie9xbIQ4X6qU9KSVkFQTwpT0TxkZpG/mWyAVeh0
         G5GBxo08sw/78ZQXGSuYqCLvOF57i1C8rYVF88v7Ey+S8sdCcCta/JyT+Ls4CRFyzMfh
         uBjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=DXGmbfWdvrXuzWAE8BTOxQjhRPkzvMn2ZsCmjYzmHWg=;
        b=bMUAae7YPShKQ8gWMU5dp/0dqlJAyH4iXk/dh5tHNhEU3A/ite0EHwyKydxUT3JFpO
         doX1jCjELe6DjtiBNux7OEnN1fbGP9FCioqnz9o+ybsqsrzlq1IWFl78ERbdpHv/Lv4w
         nKzmrmMJCJpyi3p1xN6YaT4KpdK4xbMZgrmtQVag/yRiWZbT+halNSmtUMhAxZT5JN9I
         SO04OnPRYnfVveuNkPMk2PEmvAEEtr+hYP60/JW5X/0oPsQtTXHlTjJ/FxK3w2Cn95+A
         dFODRAv/488xLWnFO2e1neRedyoqdrpBdXbKwxKDLGA54GsuTIs9SjpSD5dQGQpwCoS8
         C/Qg==
X-Gm-Message-State: APjAAAV8SVPRCNnZuy/VkgkcRFUMDo8joxmHbZChWhZvz3vfwf8pCs9r
        uoFXNTreFFTm4VPx4IbjEzszvA==
X-Google-Smtp-Source: APXvYqxhi6d9VcJssE3tE++11y8WGzYUwhsoFvGeh2gwaSz6FwkiZLQXnVXysYm4T3TJTd+4v1/gyQ==
X-Received: by 2002:adf:e94e:: with SMTP id m14mr34093476wrn.233.1574707895385;
        Mon, 25 Nov 2019 10:51:35 -0800 (PST)
Received: from angus.unipv.it (angus.unipv.it. [193.206.67.163])
        by smtp.gmail.com with ESMTPSA id b186sm197328wmb.21.2019.11.25.10.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 10:51:34 -0800 (PST)
Message-ID: <0876e232feace900735ac90d27136288b54dafe1.camel@unipv.it>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
From:   Andrea Vai <andrea.vai@unipv.it>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
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
Date:   Mon, 25 Nov 2019 19:51:33 +0100
In-Reply-To: <20191125151535.GA8044@ming.t460p>
References: <BYAPR04MB58167B95AF6B7CDB39D24C52E7780@BYAPR04MB5816.namprd04.prod.outlook.com>
         <CAOsYWL3NkDw6iK3q81=5L-02w=VgPF_+tYvfgnTihgCcwKgA+g@mail.gmail.com>
         <20191109222828.GA30568@ming.t460p>
         <fa3b0cf1f88e42e1200101bccbc797e4e7778d58.camel@unipv.it>
         <20191123072726.GC25356@ming.t460p>
         <a9ffcca93657cbbb56819fd883c474a702423b41.camel@unipv.it>
         <20191125035437.GA3806@ming.t460p>
         <bf47a6c620b847fa9e27f8542eb761529f3e0381.camel@unipv.it>
         <20191125102928.GA20489@ming.t460p>
         <e5093535c60fd5dff8f92b76dcd52a1030938f62.camel@unipv.it>
         <20191125151535.GA8044@ming.t460p>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Il giorno lun, 25/11/2019 alle 23.15 +0800, Ming Lei ha scritto:
> On Mon, Nov 25, 2019 at 03:58:34PM +0100, Andrea Vai wrote:
> 
> [...]
> 
> > What to try next?
> 
> 1) cat /sys/kernel/debug/block/$DISK/hctx0/flags
result:

alloc_policy=FIFO SHOULD_MERGE|2

> 
> 
> 2) echo 128 > /sys/block/$DISK/queue/nr_requests and run your copy
> 1GB
> test again.

done, and still fails. What to try next?

Thanks,
Andrea

