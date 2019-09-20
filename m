Return-Path: <SRS0=xi/P=XP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10EE7C4CEC9
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Sep 2019 07:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB8362086A
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Sep 2019 07:25:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="07uEuJnV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395005AbfITHZV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Sep 2019 03:25:21 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38446 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395001AbfITHZV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Sep 2019 03:25:21 -0400
Received: by mail-wr1-f66.google.com with SMTP id l11so5636098wrx.5
        for <linux-scsi@vger.kernel.org>; Fri, 20 Sep 2019 00:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=pL77aWsxmY9zRkCk9IsPculrofm/E1zYHzAWnSm2f9Q=;
        b=07uEuJnVhW+Z5KMcd9ZnVju6su0nIq/Mwaf+wx/rHNyfGniOPy8Ga6LYPO4C1CT3pb
         OfBTyH4HitWfD0P2yAE3X9c9qZNb7m9jKARKS5Trt+KH23VlPf7iZ3VcRWQcMTpGyuk+
         bGCcfrMO0Z6m4z1MUsPF4FtYKFjgLUbyrqmu+hXjTHfc/uV7E+5WDLvY4NLmqxje1dGM
         1VE7qp6T4potssJT1EWADvjOfmZYJewqOwnhGssIeTjqVWR/dg2ijjFDrp9Ov9o+3A7+
         Co9DpQrJ/+0zpXJEtgpCEVPh+OwyuwpNlvWpPeLgCyhXBNwXHQ56eUegxo3Rfrbvungi
         SJXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=pL77aWsxmY9zRkCk9IsPculrofm/E1zYHzAWnSm2f9Q=;
        b=E3DWRKfFRRINbm5qieEI8TCWzxjbC4gR8PNnBx1WlWO7w+bfvhk8H9QIQrV1CxJTL7
         B+U0JHoufJfS5AYR+aEB6IOFGL3oW7LEb0I4Jp8rU8rqUYd3gMFm+bpI2o7feLDE9jUk
         cu7/rsEiyu1ab6AYNP85S8o6A4hDvOfSE2rc1P9XIJgrJ3xZGtyiyWFXb7QEeDBaBZ0a
         X1zAMa/RMqgFtQPMZVD2RWuo39KuIiuFN+Lq2Oxs+y24HUHSHLOd0kPudrO0HSx+rvaV
         CzoQoJk0Z9v8zj4NBMO+hjVImGRCwFZTH6gwhTZjZFc6HfM0Q0REUuhjrZwx7nq1eeZj
         vSJQ==
X-Gm-Message-State: APjAAAWFCV2EvGwOEhCIaEWD4+UGiVjwEQ3vmJvyAD0bQcxAZbWeOHqd
        56Q/sC3vmaAWmu/PNbwp4/TDSg==
X-Google-Smtp-Source: APXvYqx75HjAsmDJgjLl1E3x6d59uqVGsx2Jn9lY5MfY/4VDWSiN7ieSZL8pWjJD3s2KDoZqv1yZjA==
X-Received: by 2002:adf:fb8e:: with SMTP id a14mr11254352wrr.304.1568964319087;
        Fri, 20 Sep 2019 00:25:19 -0700 (PDT)
Received: from angus.unipv.it (angus.unipv.it. [193.206.67.163])
        by smtp.gmail.com with ESMTPSA id f143sm1227111wme.40.2019.09.20.00.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 00:25:18 -0700 (PDT)
Message-ID: <3d9bf0023e01e6b29c85c2099b7466e94d06a090.camel@unipv.it>
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
Date:   Fri, 20 Sep 2019 09:25:17 +0200
In-Reply-To: <Pine.LNX.4.44L0.1909191353400.1962-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1909191353400.1962-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Il giorno gio, 19/09/2019 alle 13.54 -0400, Alan Stern ha scritto:
> 
> In general, USB flash drives should not be expected to work as well
> as 
> an actual disk drive connected over USB.

Ok, so I think I'll buy some different hardware. Would an SSD drive
(connected over USB) behave like a flash drive or like an "actual disk
drive" from this point of view?

Many thanks, and bye
Andrea

