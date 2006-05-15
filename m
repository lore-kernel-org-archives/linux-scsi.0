From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Hotplug does not work with Fusion MPT
Date: Mon, 15 May 2006 07:44:20 -0600
Message-ID: <20060515134420.GW12272@parisc-linux.org>
References: <1147694894.9689.15.camel@c64.dd.xiranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:50381 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S964903AbWEONoV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 May 2006 09:44:21 -0400
Content-Disposition: inline
In-Reply-To: <1147694894.9689.15.camel@c64.dd.xiranet.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maik Hampel <Maik.Hampel@xiranet.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, May 15, 2006 at 02:08:14PM +0200, Maik Hampel wrote:
> I recognized, that removing a scsi-drive (connected with SCA) did not
> remove it from linux scsi subsystem. The physically removed drive was
> still listed in /proc/scsi/scsi:
> 
> Host: scsi0 Channel: 00 Id: 04 Lun: 00
>   Vendor: FUJITSU  Model: MAP3367NC        Rev: 0108
>   Type:   Direct-Access                    ANSI SCSI revision: 03

Did you tell Linux you removed it?  Try:

echo scsi remove-single-device 0 0 4 0 > /proc/scsi/scsi

Parallel SCSI doesn't have a way to notify the OS that a device is gone,
so the user has to say.

You can also use tools like scsiadd for this kind of task, which has a
more agreeable user interface.
