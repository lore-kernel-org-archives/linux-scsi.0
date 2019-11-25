Return-Path: <SRS0=IzRR=ZR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4261C432C3
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 10:11:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 975FA2075C
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 10:11:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="vSvVHULp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbfKYKLE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Nov 2019 05:11:04 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:39359 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbfKYKLD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Nov 2019 05:11:03 -0500
Received: by mail-wm1-f43.google.com with SMTP id t26so15218652wmi.4
        for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2019 02:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Bwpubt5kO9MpF6+DhDd9tFXMqNxMMg0/sf7IorDXQyk=;
        b=vSvVHULp7DD7lYRvr2dnS4yvZFxgC2sHfS0hqs1sHp7uGdaRTaNLgh0nB15KXx49yI
         d9ndwlfx2sBiMePPGdCUiqrUVJmYbHkrbYzXF1vesYOZZldXSUjTo0a2hTmF9sjR9QyD
         6dxBUB1R7IAurqg4iAsu2obFxdeuVcAGHjc2J6u/3AGjCcEp8zpO6q7DjhE7qiu26MJN
         n9Yw/S1l3/MMIS/hPH2Wb1cTFITadmvYybyppnsA7vXNq8pdC/rO5U2rhFgsastbCupJ
         wdlwv5oVuAWFt07xWyzgcbt/Y0Hi1PQsGRAp1XBC1tThcm+in8vhIenirOlQClvvhFD9
         3BDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Bwpubt5kO9MpF6+DhDd9tFXMqNxMMg0/sf7IorDXQyk=;
        b=W/p9P0e2B+7VZvsOVSnvTRZLhxoKsgyQkjzpVnSL5tS1Wp++vABHA2cyrsWJx4k2E4
         0tRhVq+HezGdl33OadJ5dP8eHVVJz4TUJZi6YPuVqI3w+J6FM47ra6JeMIfbc0j1Ngmp
         lcDUkIIiATk7qk6HDI7/4MVAr/xyAW99U1l5LGoxBg3pjFFn39kAEY3tSmqWdCDFWC+R
         1P4jQs9VHVs5sUtdBWhhbxbRc3clMGpudjgUKdqWgyFwtswDei5ZoYnikBmWa0js+8Ni
         w4mJ84EJTslehGLGVPGXn1Zw9Mj9OPPVTfI2jt65k6VQX1YTll3PjFKiV9xh4s71cJv1
         y1kQ==
X-Gm-Message-State: APjAAAV6nKxH6NVs5ITkMxmD45Ak2S1jFwgPvc2zLtxVpbNdFer4pzvV
        QUpDxaf1GsIFEsfhubnpECIQjA==
X-Google-Smtp-Source: APXvYqxYaE+TwA2dYd5tAr202DSVevWFDYjL18tBGvRXf25h/jnPJLpvFlNOJvKfFSjgx+2nhWTsXg==
X-Received: by 2002:a05:600c:2257:: with SMTP id a23mr29322180wmm.143.1574676662350;
        Mon, 25 Nov 2019 02:11:02 -0800 (PST)
Received: from angus.unipv.it (angus.unipv.it. [193.206.67.163])
        by smtp.gmail.com with ESMTPSA id 4sm8142393wmd.33.2019.11.25.02.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 02:11:01 -0800 (PST)
Message-ID: <bf47a6c620b847fa9e27f8542eb761529f3e0381.camel@unipv.it>
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
Date:   Mon, 25 Nov 2019 11:11:00 +0100
In-Reply-To: <20191125035437.GA3806@ming.t460p>
References: <Pine.LNX.4.44L0.1911061044070.1694-100000@iolanthe.rowland.org>
         <BYAPR04MB5816640CEF40CB52430BBD3AE7790@BYAPR04MB5816.namprd04.prod.outlook.com>
         <b22c1dd95e6a262cf2667bee3913b412c1436746.camel@unipv.it>
         <BYAPR04MB58167B95AF6B7CDB39D24C52E7780@BYAPR04MB5816.namprd04.prod.outlook.com>
         <CAOsYWL3NkDw6iK3q81=5L-02w=VgPF_+tYvfgnTihgCcwKgA+g@mail.gmail.com>
         <20191109222828.GA30568@ming.t460p>
         <fa3b0cf1f88e42e1200101bccbc797e4e7778d58.camel@unipv.it>
         <20191123072726.GC25356@ming.t460p>
         <a9ffcca93657cbbb56819fd883c474a702423b41.camel@unipv.it>
         <20191125035437.GA3806@ming.t460p>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Il giorno lun, 25/11/2019 alle 11.54 +0800, Ming Lei ha scritto:
> On Sat, Nov 23, 2019 at 04:44:55PM +0100, Andrea Vai wrote:
> > Il giorno sab, 23/11/2019 alle 15.28 +0800, Ming Lei ha scritto:
> > > 
> > > Please post the log of 'lsusb -v', and I will try to make a
> patch
> > > for
> > > addressing the issue.
> > 
> > attached,
> 
> Please apply the attached patch, and re-build & install & reboot
> kernel.
> 
> This time, please don't switch io scheduler.

# patch -p1 < usb.patch outputs:

(Stripping trailing CRs from patch; use --binary to disable.)
patching file block/blk-mq.c
Hunk #1 succeeded at 1465 (offset 29 lines).
Hunk #2 succeeded at 3061 (offset 13 lines).
(Stripping trailing CRs from patch; use --binary to disable.)
patching file drivers/scsi/scsi_lib.c
Hunk #1 succeeded at 1902 (offset -37 lines).
(Stripping trailing CRs from patch; use --binary to disable.)
patching file drivers/usb/storage/scsiglue.c
Hunk #1 succeeded at 651 (offset -10 lines).
(Stripping trailing CRs from patch; use --binary to disable.)
patching file include/linux/blk-mq.h
Hunk #1 succeeded at 226 (offset -162 lines).
(Stripping trailing CRs from patch; use --binary to disable.)
patching file include/scsi/scsi_host.h
patch unexpectedly ends in middle of line
patch unexpectedly ends in middle of line

Just to be sure I have to go on, is this correct? Sounds like an error
but I don't know if it is important.

Thanks,
Andrea

