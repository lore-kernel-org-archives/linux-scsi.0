From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: 100% repeatable way to send firewire out to lunch permanently
	on 2.6.8.1
Date: 24 Oct 2004 10:53:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098629588.10908.23.camel@mulgrave>
References: <Pine.LNX.4.44.0409050434540.8779-100000@sasami.anime.net>
	<20041024144236.GA21793@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:3739 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261507AbUJXOxW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2004 10:53:22 -0400
In-Reply-To: <20041024144236.GA21793@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: Dan Hollis <goemon@anime.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, bcollins@debian.org, linux1394-devel@lists.sourceforge.net

On Sun, 2004-10-24 at 10:42, Olaf Hering wrote:
> This is the backtrace:
> 
> knodemgrd_0   D 00000000     0   296      1           307   293 (L-TLB)
> Call trace:
>  [c000a228] __switch_to+0x48/0x70
>  [c017736c] schedule+0x2b8/0x5e0
>  [c0177914] wait_for_completion+0x7c/0xec
>  [c5d2fb94] scsi_wait_req+0x64/0xac [scsi_mod]
>  [c54f7598] sr_do_ioctl+0x70/0x240 [sr_mod]
>  [c54f6a00] sr_packet+0x5c/0x9c [sr_mod]
>  [c5d11a34] cdrom_get_disc_info+0x60/0xc4 [cdrom]
>  [c5d121e4] cdrom_mrw_exit+0x1c/0x104 [cdrom]
>  [c5d10b6c] unregister_cdrom+0xd0/0x104 [cdrom]
>  [c54f61a8] sr_kref_release+0x54/0x80 [sr_mod]
>  [c00ad96c] kref_put+0x60/0x70
>  [c54f6924] sr_remove+0x50/0xd0 [sr_mod]
>  [c00eb100] device_release_driver+0x1b8/0x1bc
>  [c00eb2f0] bus_remove_device+0xc0/0x12c
>  [c00e9620] device_del+0xa4/0x114
> 
> 
> The trouble starts in register_cdrom(), it sets the ->exit() function if
> the CD can do CDC_MRW_W.
> On unregister, it tries to send a packet to the device which is already
> gone.

There's something else going on here.  The CD should hold a reference to
the device so is entitled to send it a command.  If the device isn't
there (and the firewire driver doesn't reject it immediately) it should
go into error handling and eventually offline the device ... what do the
kernel messages say is going on?

James

