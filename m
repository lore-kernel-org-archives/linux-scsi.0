Return-Path: <SRS0=EtEA=ZU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A856C432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 11:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E4E521787
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 11:40:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="WExpWIl8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfK1LkR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Nov 2019 06:40:17 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:45044 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfK1LkR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Nov 2019 06:40:17 -0500
Received: by mail-wr1-f48.google.com with SMTP id i12so30623001wrn.11
        for <linux-scsi@vger.kernel.org>; Thu, 28 Nov 2019 03:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=GcaV7TSgPi16GI1scwVAVOuBQ2pZxQwhgEx6hTrOkns=;
        b=WExpWIl8B8mTd7QDNWiNnXNoTCMETcR94FWgcoGbGKbcGVIEioeu6sorw0ZZwkEiCX
         JVeAuKrT4RA+TX/KomUnci2tzbFQLHobalFPZyYMN3wXLEKOFDJ+/iHE4StbMGKorpPp
         GLzuCcNiK18hAB8AOYGF3JxRuq4p+9DsyEz6Cn2VeC1l/p/R6mD6QiSsxJib9Bem3/2o
         jRV1/OJIRlnUp5pldlPZLRAMVLeHQ1nvx5P7UnXfjGv34mmXEKc7fi2Un6BQUQrIeboM
         HEsZieuixSP6Od0SKNAd7Z+AXyktouVnMwhQgWsu/aZSobFdEzKJT2qq80jXDDEJCYe2
         zcIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=GcaV7TSgPi16GI1scwVAVOuBQ2pZxQwhgEx6hTrOkns=;
        b=GXUvnfZMD9IAVupMVOwq1rTGTLHH9iaBiopfhX/mIqDrnb+DxmfDio1xInIFdPI9It
         c79hNPFzZ7+Gr2FRD5ZjxXFr/PAkeMIotd+CYuOBLsY+l4BDhPrC35cwNKYRSdNb9oH1
         sUN0UgoxTZQKebZHL6O5y0IXXJtlV9q+mxnYASqYoXY0tY1tVoKEgNc3nkLlcEZJgymP
         9AN5ZSfhWm62/fRRXgKIpPgOIM/pd5hilMKV7A6P6ufzoCNuMSgNFtb2cN/xVfubQXRP
         cTjdRD9EUW+2Js7Aee/vJISqYPPZlCD3KN1TqwBtoQu/uMHh3RCNfCdN5BYwiq+elYfE
         1iXg==
X-Gm-Message-State: APjAAAVMgxAwI7AJt3nYXx5PnxABM5+MSBkFy5A4j4DpsgtcyA80SOze
        D9oPVW1OveELEh4VjS/b3NInNA==
X-Google-Smtp-Source: APXvYqzJoJ36WVXfKX0byebk+wUH2f5FUSX/9U7e2SD/NjLo+igkMeM0znDoPQjo8YplBf0zzGssHA==
X-Received: by 2002:adf:fa08:: with SMTP id m8mr50371389wrr.276.1574941215165;
        Thu, 28 Nov 2019 03:40:15 -0800 (PST)
Received: from angus.unipv.it (angus.unipv.it. [193.206.67.163])
        by smtp.gmail.com with ESMTPSA id l7sm3963426wrq.61.2019.11.28.03.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 03:40:14 -0800 (PST)
Message-ID: <d12d516dea813f8c603b6fcd43afb3aeec1957f5.camel@unipv.it>
Subject: Re: AW: AW: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
From:   Andrea Vai <andrea.vai@unipv.it>
To:     "Schmid, Carsten" <Carsten_Schmid@mentor.com>,
        Finn Thain <fthain@telegraphics.com.au>
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
Date:   Thu, 28 Nov 2019 12:40:11 +0100
In-Reply-To: <fa9566db62474d7aa5473cf7a1f0da8d@SVR-IES-MBX-03.mgc.mentorg.com>
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
         <cb6e84781c4542229a3f31572cef19ab@SVR-IES-MBX-03.mgc.mentorg.com>
         <c1358b840b3a4971aa35a25d8495c2c8953403ea.camel@unipv.it>
         <fa9566db62474d7aa5473cf7a1f0da8d@SVR-IES-MBX-03.mgc.mentorg.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Il giorno gio, 28/11/2019 alle 08.12 +0000, Schmid, Carsten ha
scritto:
> 
> [...]
> 
> I assume the only thing that you change between the benchmarks
> is the kernel (and the modules, of course), right, Andrea?
> 

It's my production machine, so apart from the changes involved in a
"normal use of a PC" I can say that there are no changes I am aware of
(apart from the kernel, and other changes you told me to do, such as
changing the IO scheduler, etc)... but please remember I am not an
expert, so feel free to ask me what other kind of changes I can tell
you about.

Thanks,
Andrea

