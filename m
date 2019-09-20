Return-Path: <SRS0=xi/P=XP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 795B3C49ED7
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Sep 2019 07:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B82920820
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Sep 2019 07:03:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="vXH5kAAX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394949AbfITHDh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Sep 2019 03:03:37 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:44555 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394932AbfITHDh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Sep 2019 03:03:37 -0400
Received: by mail-wr1-f46.google.com with SMTP id i18so5535113wru.11
        for <linux-scsi@vger.kernel.org>; Fri, 20 Sep 2019 00:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=iPb11oBM4mXymFs4UUGvQ+4qCrRBdbOKjtlw3sgl95E=;
        b=vXH5kAAX82UGTz+MibXvrnLawKTxDfMWSdnpdfZBHXooZKTd9IPmuU6vDFC99SCQzf
         XJv/8sA6CkmKXBt0DcK1pq/NinQJfQdjXrmaTGlDsIlnOQgMdOykNegVIQZrvLBRSs3G
         HAWanLAYYDUlrVGm1MooqH1Vqig3yYYVvbPmlIzpb77lM62Fp4+IZ3ACuUab7Ws4lTti
         X3j3RAZ+L1jceTG2oasvZCGZljm+RnG5hLJWIrudPUr1VXqLWGoSHhUahmH7FMsG1f7k
         FjjqQBEVaiBAvZaPqJTfLHhDarGdwJA2N+VeMxT6n8cvnp2r3De+D6WuXLSoxvds8clv
         qtZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=iPb11oBM4mXymFs4UUGvQ+4qCrRBdbOKjtlw3sgl95E=;
        b=Ev1TuP3g/1BB1oqPW3WhiSg4MZDBSqSBCmdORCA/5hmJKKJxNpNfmaSoIbywFal6se
         Z5qo7CCOxpIrSAqI1M2o7jc7uPZl1pvK+BPEkYyGtsqF4/x0wqzVJ3NVawrgFOzdywZO
         ixhBEAvOxE8GLbyZVLGnGhyfy5ZIGkji/cOySGF24YxIj266DNEUqxd0iaeO+gFKSUN+
         o+7NPKpvQEzdC1vD+t1fgmOgtea30XNtOmNyLnfDTBNJpwq7jyELJPWYugK+FByQg7Ay
         K4Nwx2pgTNwT8M8HCKNpkfLpXKIn2ka7rknSlMafmP4q7PhUBa0nq5I5MrTDjZ9Pcb3v
         f7rQ==
X-Gm-Message-State: APjAAAWlpgDx+bEfFe0KHl6rLHgaitM+G1XGcryQbLfxJE0HghzErINR
        xbuE6+vJrAfWTaGG9Qz+tWbi6A==
X-Google-Smtp-Source: APXvYqxECgCqPApWMHtyOa4f71NdXx5G1agL/X1wWGLsI39s8kKDaXojKuC8fWTB1X4KO8/r+o+unQ==
X-Received: by 2002:adf:e4ce:: with SMTP id v14mr10751214wrm.15.1568963015062;
        Fri, 20 Sep 2019 00:03:35 -0700 (PDT)
Received: from angus.unipv.it (angus.unipv.it. [193.206.67.163])
        by smtp.gmail.com with ESMTPSA id v7sm1093401wru.87.2019.09.20.00.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 00:03:33 -0700 (PDT)
Message-ID: <981fc98a9995eaee5f65709cacc46f13a2c603ad.camel@unipv.it>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
From:   Andrea Vai <andrea.vai@unipv.it>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc:     Johannes Thumshirn <jthumshirn@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>
Date:   Fri, 20 Sep 2019 09:03:28 +0200
In-Reply-To: <BYAPR04MB581603F036943752D799AD5CE7890@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <Pine.LNX.4.44L0.1909190958140.1585-100000@iolanthe.rowland.org>
         <BYAPR04MB581603F036943752D799AD5CE7890@BYAPR04MB5816.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Il giorno gio, 19/09/2019 alle 14.14 +0000, Damien Le Moal ha scritto:
> On 2019/09/19 16:01, Alan Stern wrote:
> [...]
> > No doubt Andrea will be happy to test your fix when it's ready.

Yes, of course.

> 
> Hannes posted an RFC series:
> 
> https://www.spinics.net/lists/linux-scsi/msg133848.html
> 
> Andrea can try it.

Ok, but I would need some instructions please, because I am not able
to understand how to "try it". Sorry for that.

> Andrea,
> 
> What is the device in question ? Is it a USB external HDD ? SSD ?
> Flash key ?

It is a USB flash key (a.k.a. pendrive, flash drive, etc.):

ID 0951:1666 Kingston Technology DataTraveler 100 G3/G4/SE9 G2

Thanks, and bye
Andrea

