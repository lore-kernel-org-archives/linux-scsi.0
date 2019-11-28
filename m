Return-Path: <SRS0=EtEA=ZU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DBEC43141
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 17:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF9D821787
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 17:11:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="qTjL2qO1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfK1RK5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Nov 2019 12:10:57 -0500
Received: from mail-wm1-f46.google.com ([209.85.128.46]:37602 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfK1RK5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Nov 2019 12:10:57 -0500
Received: by mail-wm1-f46.google.com with SMTP id f129so12427673wmf.2
        for <linux-scsi@vger.kernel.org>; Thu, 28 Nov 2019 09:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=kIU/4r5tg86qVELVsVrOVWZTmy5x4DTAtzCcw+A5vjQ=;
        b=qTjL2qO1zywbtMgr9UGj+wX8baVWMvVpO/1UovbX8ti+3yalBXG08d4wzgS7i5jcdw
         yV9lDxG48HYflHQ/f6NCpUMWV8BJniSDhiMRjqK9d4hmwN3uf44msWPJZbvjploujGh7
         oixsWiaDTR2H4VPehEs3a70TdNYu9NhQKH4on643UKNFwOD7fxErivTUax1QEUlbPYR+
         KjumCrMvG4H6r03U01JGkTCuXlQscbrGS1/25bGX3oJijKav6cDwazG3C4meui8jMXR9
         qSom6G37FXqXxjpmAP+YTrOsgksXbOKAGv28oibk9lmktyvVovxgp1QhYvtWY3JFykY3
         Rk/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=kIU/4r5tg86qVELVsVrOVWZTmy5x4DTAtzCcw+A5vjQ=;
        b=FAaoJi5sh3ga1f4BKWoJC6kgMrOe16DW54pH9fMogXRZx4WUyeZrsv2IsoEAO0y3BB
         RPdz2Ui3CRxSPb0cZZ8HNevw5obf2Lk8Gca2LzJV2wM6qdrSZHo28WfGqG95cJg3cVEw
         63WniKsJTv3XOcD+E+iYq0oRKJLimyxZv4YjX8JR/5ypBmfFiQ6lB9deA+ZxverGUQkK
         wM0BK/CdORB+B9HqpHje4CJm1ZKLckfEf8iVo457yp9GMVRJxtPuFyrhOL7K/a9/4q7/
         ZP8vrqI/+xRIajeVNM7MOa7kaCP1WSHV1kn//jzKo20ZQaAgp5OqMPQygqmhz11LRyHF
         QlqA==
X-Gm-Message-State: APjAAAWwKGkxtJ67IEESrz8KUN1ezlcLyM47/fWPZtkHR3sm7yxETySe
        qZMG+LEy38wO06pHtw5N2hJi7g==
X-Google-Smtp-Source: APXvYqyUO703ljkdm3t8cCiMOnzpUNZCOJtpRfQAphxjyipXLWTcDVfzJUQk7mhGZHQBsiAo8texHw==
X-Received: by 2002:a1c:f317:: with SMTP id q23mr10064265wmq.97.1574961055084;
        Thu, 28 Nov 2019 09:10:55 -0800 (PST)
Received: from angus.unipv.it (angus.unipv.it. [193.206.67.163])
        by smtp.gmail.com with ESMTPSA id r6sm10484372wrq.92.2019.11.28.09.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 09:10:54 -0800 (PST)
Message-ID: <776d0c5f1d9f7787f353f97ed38597b05412529a.camel@unipv.it>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
From:   Andrea Vai <andrea.vai@unipv.it>
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     Ming Lei <ming.lei@redhat.com>,
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
Date:   Thu, 28 Nov 2019 18:10:53 +0100
In-Reply-To: <alpine.LNX.2.21.1.1911271055200.8@nippy.intranet>
References: <20191109222828.GA30568@ming.t460p>
                 <fa3b0cf1f88e42e1200101bccbc797e4e7778d58.camel@unipv.it>
                 <20191123072726.GC25356@ming.t460p>
                 <a9ffcca93657cbbb56819fd883c474a702423b41.camel@unipv.it>
                 <20191125035437.GA3806@ming.t460p>
         <bf47a6c620b847fa9e27f8542eb761529f3e0381.camel@unipv.it>
                 <20191125102928.GA20489@ming.t460p>
                 <e5093535c60fd5dff8f92b76dcd52a1030938f62.camel@unipv.it>
                 <20191125151535.GA8044@ming.t460p>
                 <0876e232feace900735ac90d27136288b54dafe1.camel@unipv.it>
                 <20191126023253.GA24501@ming.t460p>
         <0598fe2754bf0717d81f7e72d3e9b3230c608cc6.camel@unipv.it>
         <alpine.LNX.2.21.1.1911271055200.8@nippy.intranet>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Il giorno mer, 27/11/2019 alle 11.21 +1100, Finn Thain ha scritto:
> On Tue, 26 Nov 2019, Andrea Vai wrote:
> 
> > Then I started another set of 100 trials and let them run tonight,
> and 
> > the first 10 trials were around 1000s, then gradually decreased
> to 
> > ~300s, and finally settled around 200s with some trials below 70-
> 80s. 
> > This to say, times are extremely variable and for the first time
> I 
> > noticed a sort of "performance increase" with time.
> > 
> 
> The sheer volume of testing (probably some terabytes by now) would 
> exercise the wear leveling algorithm in the FTL.
> 
> This in itself seems unlikely to improve performance significantly.
> But if 
> the flash memory came from a bad batch, perhaps it would have that
> effect.
> 
> To find out, someone may need to source another (genuine) Kingston 
> DataTraveller device.

I own another device (let's refer to it as "black odd"), identical to
the "slow" one (call it "black even"), and used it as well  to do the
tests, especially in the beginning of this story, because I suspected
the problem could be related to a faulty pen drive. At a certain time
I realized that the tests I performed didn't show any difference
between the two flash drives, so since that time I kept using just the
"black even". They were bought together, so of course both of them
probably belong to the same "maybe-bad batch".

But I have another Kingston DataTraveler ("White"), externally
slightly different from the other twos (it's white instead of black,
and labeled G4 instead of G3), though lsusb shows the same IDs:
0951:1666. It had been purchased some months after the other twos
(well, actually, it may be the result of an RMA exchange).

I have just ran one test on this White one, with the new (patched)
kernel, and it took an average of 200seconds (st.dev=46s), which is
not "good", but less "bad" than the real "bad" case of the "black"
ones (>1000 seconds).

I have also tried the "WHITE" one with the old fast kernel, and the
behavior is almost the same as with the new kernel, though a little
bit better (mean=173; st.dev.=11).

Feel free to let me know if I should do other tries,

thanks,
Andrea

