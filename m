Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07423C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 08:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD9BB21841
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 08:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594714673;
	bh=nKnSg22CPcnQVI12S7+deTddw0rpP4aIXgukl5B6K8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=urRFagzTApEWFDc8rnwHqkHkKxU5kpAeNwo8ieXHNfqZ7Puae3hHqJdhH5sAKNysZ
	 NdgeiKqX4vf9DJ1ZsJcI2eBkUxz0SZVDJ93pC/pr/tOPOc/a/ydhwKjEcHC5LSwSho
	 /hAW24+n+hvYoFUdrTCbLnY+HBA/Ejv8W/ug5Pmg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbgGNIRx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 04:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgGNIRw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 04:17:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CCE9217D9;
        Tue, 14 Jul 2020 08:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594714672;
        bh=nKnSg22CPcnQVI12S7+deTddw0rpP4aIXgukl5B6K8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=neXZydRlXLz7DfZ8j/UJVAIIskDRuG7kJMLKPa0EYkaGKPubLxQe+dQBcID3DGO71
         3It0lqY3c9Wnh5tSKKizV6le0JpE3C5QW4M9+iN/0N23WtQdVIt3PtI921hwKT3ejb
         w9wmqQicGyMWWU+f2EudgKvyQCOZJQ8bt1ebCLgs=
Date:   Tue, 14 Jul 2020 10:17:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc:     tasleson@redhat.com, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [RFC PATCH v3 5/8] ata_dev_printk: Use dev_printk
Message-ID: <20200714081750.GB862637@kroah.com>
References: <20200623191749.115200-1-tasleson@redhat.com>
 <20200623191749.115200-6-tasleson@redhat.com>
 <CGME20200624103532eucas1p2c0988207e4dfc2f992d309b75deac3ee@eucas1p2.samsung.com>
 <d817c9dd-6852-9233-5f61-1c0bc0f65ca4@samsung.com>
 <7ed08b94-755f-baab-0555-b4e454405729@redhat.com>
 <cfff719b-dc12-a06a-d0ee-4165323171de@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfff719b-dc12-a06a-d0ee-4165323171de@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 14, 2020 at 10:06:05AM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi Tony,
> 
> On 7/9/20 11:18 PM, Tony Asleson wrote:
> > Hi Bartlomiej,
> > 
> > On 6/24/20 5:35 AM, Bartlomiej Zolnierkiewicz wrote:
> >> The root source of problem is that libata transport uses different
> >> naming scheme for ->tdev devices (please see dev_set_name() in
> >> ata_t{dev,link,port}_add()) than libata core for its logging
> >> functionality (ata_{dev,link,port}_printk()).
> >>
> >> Since libata transport is part of sysfs ABI we should be careful
> >> to not break it so one idea for solving the issue is to convert
> >> ata_t{dev,link,port}_add() to use libata logging naming scheme and
> >> at the same time add sysfs symlinks for the old libata transport
> >> naming scheme.

Given the age of the current implementation, what suddenly broke that
requires this to change at this point in time?

> > 
> > I tried doing as you suggested.  I've included what I've done so far.  I
> > haven't been able to get all the needed parts for the symlinks to
> > maintain compatibility.
> > 
> > The /sys/class/.. seems OK, eg.
> > 
> > $  ls -x -w 70 /sys/class/ata_[dl]*
> > /sys/class/ata_device:
> > ata1.00  ata2.00  ata3.00  ata4.00  ata5.00  ata6.00  ata7.00
> > ata7.01  ata8.00  ata8.01  dev1.0   dev2.0   dev3.0   dev4.0
> > dev5.0   dev6.0   dev7.0   dev7.1   dev8.0   dev8.1
> > 
> > /sys/class/ata_link:
> > ata1   ata2   ata3   ata4   ata5   ata6   ata7  ata8  link1  link2
> > link3  link4  link5  link6  link7  link8

A link class?  Ick ick ick.

> > but the implementation is a hack, see device.h, core.c changes.  There
> > must be a better way?
> > 
> > Also I'm missing part of the full path, eg.
> > 
> > /sys/devices/pci0000:00/0000:00:01.1/ata7/link7/dev7.0/ata_device/dev7.0/gscr
> > 
> > becomes
> > 
> > /sys/devices/pci0000:00/0000:00:01.1/ata7/ata7/ata7.01/ata_device/ata7.01/gscr
> > 
> > but the compatibility symlinks added only get me to
> > 
> > /sys/devices/pci0000:00/0000:00:01.1/ata7/link7/dev7.0/ata_device/
> > 
> > I haven't found the right spot to get the last symlink included.
> > 
> > If you or anyone else has suggestions to correct the incomplete symlink
> > and/or correct the implementation to set the
> > /sys/class/ata_device it would be greatly appreciated.

I can't understand what you are trying to do here.

What do you want to represent in sysfs with a symlink that you can't
just have in a single sysfs file like "name" or "new_name" or
"name_because_we_didnt_think_about_this_10_years_ago" that shows you the
other "name" that you are trying to look up here?

Why abuse symlinks like this at all?

And no, the device.h and core.c changes aren't ok :)

thanks,

greg k-h
