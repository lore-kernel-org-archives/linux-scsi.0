From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Please help if u can.
Date: Wed, 21 Feb 2007 00:21:19 -0500
Message-ID: <45DBD6CF.7010309@torque.net>
References: <45DB9D89.7030804@tlchosting.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33423 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030186AbXBUFVZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Feb 2007 00:21:25 -0500
In-Reply-To: <45DB9D89.7030804@tlchosting.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Scarpa <john@tlchosting.com>
Cc: linux-scsi@vger.kernel.org

John Scarpa wrote:
> Dear Luben,
> 
> I am trying to compile the aic94xx for my aic9410 directly into my
> kernel (fc5_64bit-2.6.20)...  Is this possible or must it be loaded as a
> module?  I am really not wanting to add modular support to my nice neat
> monolithic kernel.. :-(  I've been searching for ever now and tried
> everything i could to no avail..
> 
> --->Log
> aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.2 loaded
> aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:04:02.0
> scsi0 : aic94xx
> aic94xx: Failed to load sequencer firmware file aic94xx-seq.fw, error -2
> aic94xx: couldn't init seqs for 0000:04:02.0
> aic94xx: couldn't init the chip
> 
> --->Specs
> FC5_64bit 2.6.20
> Supermicro 6025B-3 Server Model
> 
> 
> 
> Thank you for any help!  btw this is the first time i ever wrote a
> maintainer for help... my pride is definitely hurting right now...

John,
You have touched a rather sore point. The source files
in the aic94xx driver found in lk 2.6.20 start like this:

/*
 * Aic94xx SAS/SATA driver header file.
 *
 * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
 * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
 *
 * This file is licensed under GPLv2.


It would be reasonable to assume that Luben is the maintainer
of this code although the MAINTAINERS file has no entry
for the aic94xx driver.

This code was effectively removed from Luben's control
about 18 months ago and has passed through several sets
of hands since then. None of the people concerned want
to identify themselves in the source or explain
what has been done in writing. Why?

The existing copyright notices should remain but what
about the massive changes to that driver in 2006?
Where is the indication of whom John should contact?
Perhaps something like:
 "For maintenance of this driver contact
  linux-scsi@vger.kernel.org"


FYI John, Luben maintains his own version of the
aic94xx and that version holds the sequencer firmware
in a binary blob within the driver. Due to kernel policy,
that blob was moved to separate file by someone else. The
error that you are reporting suggests that the firmware
file for the aic94xx cannot be found. On my system
the file that you may be missing looks like this:
# ls -l /lib/firmware/aic94xx-seq.fw
-rw-rw-r-- 1 root root 22622 Aug 29 17:36 /lib/firmware/aic94xx-seq.fw


Doug Gilbert
