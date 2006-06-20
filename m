From: "adam radford" <aradford@gmail.com>
Subject: Re: Controller failing, driver not behaving nicely
Date: Tue, 20 Jun 2006 15:47:49 -0700
Message-ID: <b1bc6a000606201547r11916e86g814d006c99ce386e@mail.gmail.com>
References: <200606202302.19858.chrivers@iversen-net.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:42692 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1751457AbWFTWrw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jun 2006 18:47:52 -0400
Received: by nf-out-0910.google.com with SMTP id l35so14087nfa
        for <linux-scsi@vger.kernel.org>; Tue, 20 Jun 2006 15:47:51 -0700 (PDT)
In-Reply-To: <200606202302.19858.chrivers@iversen-net.dk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christian Iversen <chrivers@iversen-net.dk>
Cc: linux-scsi@vger.kernel.org

Christian,

0x28 is the scsi opcode for READ_10, which means the command that
failed was a read command.

The driver is trying to reset the card, however it is failing the reset.

"AEN drain failed, retrying." means your card is not responding.  I would
suggest reseating your card if you have moved it recently, or the card
could be dying in which case you should contact 3ware/AMCC support.

-Adam

On 6/20/06, Christian Iversen <chrivers@iversen-net.dk> wrote:
>
> Hello all.
>
> I have a 3Ware 5800 8-port ATA controller running on the 3w-xxxx driver, which
> works nicely for the most part.
>
> However, recently the controller has been flaky - it keeps losing all sync
> with the machine, then coughs and dies. After a hard reset it works for some
> time again.
>
> I was hoping you could tell me if there is anything I should check? Also, I'm
> wondering is the driver is behaving correctly? Shouldn't it try to reset the
> card?
>
> Anyway, here are the details:
>
> Kernel: anything from 2.6.10-custom to 2.6.15-debian-sarge-stock
> Arch: tested on AMD x86 SMP and UP, with and without highmem
>
> Here's the log output just before the thing goes "boink":
>
> <LOG>
> Jun 20 07:34:00 [kernel] 3w-xxxx: scsi2: WARNING: Unit #4: Command (0x28)
> timed out, resetting card.
> Jun 20 07:34:30 [kernel] 3w-xxxx: scsi2: AEN drain failed, retrying.
>                 - Last output repeated 2 times -
> Jun 20 07:35:30 [kernel] RAID5 conf printout:
>                 - Last output repeated 7 times -
> Jun 20 07:35:30 [kernel] Buffer I/O error on device md1, logical block
> 56274327
> Jun 20 07:35:35 [kernel] Buffer I/O error on device md1, logical block
> 56859486
> Jun 20 07:35:37 [kernel] Buffer I/O error on device md1, logical block
> 117796200
> Jun 20 07:35:42 [kernel] printk: 1 messages suppressed.
> Jun 20 07:35:46 [kernel] printk: 7 messages suppressed.
> Jun 20 08:41:37 [kernel] ReiserFS: md1: warning: vs-13070:
> reiserfs_read_locked_inode: i/o failure occurred trying to find stat data of
> [2 84475 0x0 SD]
> Jun 20 08:41:38 [kernel] ReiserFS: md1: warning: vs-13070:
> reiserfs_read_locked_inode: i/o failure occurred trying to find stat data of
> [25743 118119 0x0 SD]
> [lots of reiserfs faileurs]
> </LOG>
>
> Does anybody know what command 0x28 is? Maybe it's one of the 8 drives that is
> broken, and the controller is not telling me?
>
> Here's /proc/scsi/scsi
> Attached devices:
> Host: scsi0 Channel: 00 Id: 03 Lun: 00
>   Vendor: SEAGATE  Model: ST336607LW       Rev: 0007
>   Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 04 Lun: 00
>   Vendor: SEAGATE  Model: ST336607LW       Rev: 0007
>   Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi2 Channel: 00 Id: 00 Lun: 00
>   Vendor: 3ware    Model: Logical Disk 0   Rev: 1.2
>   Type:   Direct-Access                    ANSI SCSI revision: ffffffff
> Host: scsi2 Channel: 00 Id: 01 Lun: 00
>   Vendor: 3ware    Model: Logical Disk 1   Rev: 1.2
>   Type:   Direct-Access                    ANSI SCSI revision: ffffffff
> Host: scsi2 Channel: 00 Id: 02 Lun: 00
>   Vendor: 3ware    Model: Logical Disk 2   Rev: 1.2
>   Type:   Direct-Access                    ANSI SCSI revision: ffffffff
> Host: scsi2 Channel: 00 Id: 03 Lun: 00
>   Vendor: 3ware    Model: Logical Disk 3   Rev: 1.2
>   Type:   Direct-Access                    ANSI SCSI revision: ffffffff
> Host: scsi2 Channel: 00 Id: 04 Lun: 00
>   Vendor: 3ware    Model: Logical Disk 4   Rev: 1.2
>   Type:   Direct-Access                    ANSI SCSI revision: ffffffff
> Host: scsi2 Channel: 00 Id: 05 Lun: 00
>   Vendor: 3ware    Model: Logical Disk 5   Rev: 1.2
>   Type:   Direct-Access                    ANSI SCSI revision: ffffffff
> Host: scsi2 Channel: 00 Id: 06 Lun: 00
>   Vendor: 3ware    Model: Logical Disk 6   Rev: 1.2
>   Type:   Direct-Access                    ANSI SCSI revision: ffffffff
> Host: scsi2 Channel: 00 Id: 07 Lun: 00
>   Vendor: 3ware    Model: Logical Disk 7   Rev: 1.2
>   Type:   Direct-Access                    ANSI SCSI revision: ffffffff
>
> The two first entries are real SCSI-disks. the last 8 are the 3ware-controlled
> disks, of course. The SCSI subsystem still seems to think they're connected?
> I've tried the scsi-rescan-bus.sh-script, but it just agrees with /proc/scsi,
> in that it thinks the drives are still connected - and so it does nothing. Is
> there a utility that can kick && reconnect a scsi-device?
>
> I'd be really interested in _any_ comments. I've ordered a couple of cheap
> 2-port ATA133 controllers in the meantime, which I'm going to have to use in
> master-slave configuration. Oh the horror :-/
>
> I'd be willing to test almost anything that doesn't involve erasing data on
> the drives.
>
>
> P.S: (recently), things often fail with this card. But not always with command
> 0x28:
>
>
> zcat /var/log/kernel/* | grep 3w
> Jun  8 08:53:42 [kernel] 3w-xxxx: scsi2: WARNING: Unit #2: Command (0x28)
> timed out, resetting card.
> Jun  8 08:54:12 [kernel] 3w-xxxx: scsi2: AEN drain failed, retrying.
> Jun  8 08:55:42 [kernel] 3w-xxxx: scsi2: WARNING: Unit #7: Command (0x2a)
> timed out, resetting card.
> Jun  8 08:56:12 [kernel] 3w-xxxx: scsi2: AEN drain failed, retrying.
> Jun  8 08:57:12 [kernel] 3w-xxxx: scsi2: Controller errors, card not
> responding, check all cabling.
> Jun  8 21:15:13 [kernel] 3w-xxxx: scsi2: WARNING: Unit #0: Command (0x12)
> timed out, resetting card.
> Jun  8 21:15:43 [kernel] 3w-xxxx: scsi2: AEN drain failed, retrying.
> Jun 17 23:09:22 [kernel] 3w-xxxx: scsi2: AEN drain failed, retrying.
> Jun 18 17:33:03 [kernel] 3w-xxxx: scsi2: AEN drain failed, retrying.
> Jun 19 21:16:51 [kernel] 3w-xxxx: scsi2: AEN drain failed, retrying.
> Jun 20 00:29:29 [kernel] 3w-xxxx: scsi2: AEN drain failed, retrying.
> Jun 20 07:34:00 [kernel] 3w-xxxx: scsi2: WARNING: Unit #4: Command (0x28)
> timed out, resetting card.
> Jun 20 07:34:30 [kernel] 3w-xxxx: scsi2: AEN drain failed, retrying.
>
> --
> Regards,
> Christian Iversen
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
