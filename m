From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2.6.12.5 1/2] lib: allow idr to be used in irq context
Date: Sun, 21 Aug 2005 11:06:26 -0500
Message-ID: <1124640387.5068.2.camel@mulgrave>
References: <20050821154919.91440.qmail@web51609.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:31654 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751072AbVHUQGk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Aug 2005 12:06:40 -0400
In-Reply-To: <20050821154919.91440.qmail@web51609.mail.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: luben_tuikov@adaptec.com
Cc: Andrew Morton <akpm@osdl.org>, Jim Houston <jim.houston@ccur.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Dave Jones <davej@redhat.com>, Jeff Garzik <jgarzik@pobox.com>

On Sun, 2005-08-21 at 08:49 -0700, Luben Tuikov wrote:
> The caller is the aic94xx SAS LLDD.  It uses IDR to generate unique
> task tag for each SCSI task being submitted.  It is then used to lookup
> the task given the task tag, in effect using IDR as a fast lookup table.
> 
> Yes, I'm also not aware of any other users of IDR from mixed process/IRQ
> context or for SCSI Task tag purposes.

Just a minute, that's not what idr was designed for.  It was really
designed for enumerations (like disk) presented to the user.  That's why
using it in IRQ context hasn't been considered.

However, there is an infrastructure in the block layer called the
generic tag infrastructure which was designed precisely for this purpose
and which is designed to operate in IRQ context.

James


