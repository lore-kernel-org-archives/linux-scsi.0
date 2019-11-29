Return-Path: <SRS0=Uo2m=ZV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	ZIPFILE autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19CE2C432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Nov 2019 14:41:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE8F421736
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Nov 2019 14:41:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="oQRm0AlH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfK2OlI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Nov 2019 09:41:08 -0500
Received: from mail-wm1-f44.google.com ([209.85.128.44]:35204 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfK2OlH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Nov 2019 09:41:07 -0500
Received: by mail-wm1-f44.google.com with SMTP id n5so15346376wmc.0
        for <linux-scsi@vger.kernel.org>; Fri, 29 Nov 2019 06:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=ZfM3GovPXzN4SKlLoN9sS3h6HAqKDeCW7nRc1sCilh8=;
        b=oQRm0AlHFMiZ4UNhJ4OAPY98dzpKCaf4jdTuY1b92ZKXEWbO82fDgPns6BFK7Krhcw
         fULlRHHrnz9uFT+hFnHyA6P/DK0ygLE+PkiAVUs+3xa4/fI6FX8s130Q1zCOI4BSE96A
         82Ynb8noyaBtEtrlmIPFwlhqHHcrtOF6u/vayy3R87MxP9FTWk1AUMtXhXDxhC+TOtgD
         DJJ0NkMV4PukiW5FjU5hK2N6AdDAwYmvBw7doeAiAXWNkPdP5EZVSbEDNQZkLGO3zV6/
         0b2ZYqTBOV1dUSP0j95vDto7+IGAD0NwmUhlG31vYeddvQw95f9gggcqb2cMRJcMIDme
         U8XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=ZfM3GovPXzN4SKlLoN9sS3h6HAqKDeCW7nRc1sCilh8=;
        b=iYCEDJj6n0ArxtNpHiAtBEN+fqLGti8jxNdrRPkwa9/hhCSOJqWnIKaJcl/5sVPjMS
         JRfDCDkjjqH9Xt7XQHVsZCtcOPpqHqtFRJYwLzLIYDKk3h5uX7q+/TpAdlFh41abkr4Y
         swLwKMtnCRCeeSvWdm7+3RVpi8qrN2B2zots8XblmvzjnPk6ci93uZPg1kFsjRlB8+gk
         I56RLAUi6LXkm7liqgnVbVhgHZ4wrHOUWusaPeD560tNE6AkR/MQpkg0IHT25xbEmCOr
         BMdZpmoDVjPbw5vqSM/vpFGUj3w80/782Y5OQMk5nARtUHMYYr4LSBlnxnUHPv23MEus
         J4tg==
X-Gm-Message-State: APjAAAUAGhu7Ji++3vVnwz7c2IeGIoEsm0+U0UEqvPygdXc3vVDVQ1ju
        Y7gOrfdtDuMJWQcqxICxk1qB4w==
X-Google-Smtp-Source: APXvYqzHd7/v31vJYF6fqLZilk5NEJtU4jsvxvMsbZLpASuasxWvkHojZ7vYtZ5TtWmMa+5eTc4TPg==
X-Received: by 2002:a7b:cb59:: with SMTP id v25mr14908984wmj.159.1575038463923;
        Fri, 29 Nov 2019 06:41:03 -0800 (PST)
Received: from angus.unipv.it (angus.unipv.it. [193.206.67.163])
        by smtp.gmail.com with ESMTPSA id n188sm9216845wme.14.2019.11.29.06.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 06:41:02 -0800 (PST)
Message-ID: <320b315b9c87543d4fb919ecbdf841596c8fbcea.camel@unipv.it>
Subject: Re: AW: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
From:   Andrea Vai <andrea.vai@unipv.it>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Schmid, Carsten" <Carsten_Schmid@mentor.com>,
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
Date:   Fri, 29 Nov 2019 15:41:01 +0100
In-Reply-To: <20191129023555.GA8620@ming.t460p>
References: <20191125151535.GA8044@ming.t460p>
         <0876e232feace900735ac90d27136288b54dafe1.camel@unipv.it>
         <20191126023253.GA24501@ming.t460p>
         <0598fe2754bf0717d81f7e72d3e9b3230c608cc6.camel@unipv.it>
         <alpine.LNX.2.21.1.1911271055200.8@nippy.intranet>
         <cb6e84781c4542229a3f31572cef19ab@SVR-IES-MBX-03.mgc.mentorg.com>
         <c1358b840b3a4971aa35a25d8495c2c8953403ea.camel@unipv.it>
         <20191128091712.GD15549@ming.t460p>
         <f82fd5129e3dcacae703a689be60b20a7fedadf6.camel@unipv.it>
         <20191129005734.GB1829@ming.t460p> <20191129023555.GA8620@ming.t460p>
Content-Type: multipart/mixed; boundary="=-HIAul2oAsNr1EC1inCjc"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--=-HIAul2oAsNr1EC1inCjc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Il giorno ven, 29/11/2019 alle 10.35 +0800, Ming Lei ha scritto:
> On Fri, Nov 29, 2019 at 08:57:34AM +0800, Ming Lei wrote:
> 
> > [...]
> 
> > Andrea, can you collect the following log when running the test
> > on current new(bad) kernel?
> > 
> > 	/usr/share/bcc/tools/stackcount  -K blk_mq_make_request
> 
> Instead, please run the following trace, given insert may be
> called from other paths, such as flush plug:
> 
> 	/usr/share/bcc/tools/stackcount -K t:block:block_rq_insert

Attached, for new (patched) bad kernel.

Produced by: start the trace script (with the pendrive already
plugged), wait some seconds, run the test (1 trial, 1 GB), wait for
the test to finish, stop the trace.

The copy took ~1700 seconds.

Thanks,
Andrea

--=-HIAul2oAsNr1EC1inCjc
Content-Type: application/zip; name="log_ming_20191129_150609.zip"
Content-Disposition: attachment; filename="log_ming_20191129_150609.zip"
Content-Transfer-Encoding: base64

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


--=-HIAul2oAsNr1EC1inCjc--

