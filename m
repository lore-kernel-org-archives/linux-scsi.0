From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] CDC_WR_OVER
Date: 18 Nov 2003 17:00:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069200002.2912.8.camel@patrh9>
References: <1068851585.2851.17.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:17027 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263837AbTKSAAa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 19:00:30 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 610351899
	for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2003 17:00:29 -0700 (MST)
In-Reply-To: <1068851585.2851.17.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> we can begin to move forward now by accepting or
> revising the patch of this e-mail?

As yet revising, Not accepting.

In fact somehow we have moved this profile/ features/ writability patch
of too many names from sr_mod.ko into cdrom.ko without actually
achieving writability for devices other than DVD-RAM connected via
ide-cd.ko.

> -	if (ide_cdrom_get_capabilities(drive, &cap))
> +	if (ide_cdrom_get_capabilities(drive, &cap)) {
> +		; /* FIXME: mask CDC_WR */
>  		return 0;
> +	}
>  
>  	if (cap.lock == 0)
>  		CDROM_CONFIG_FLAGS(drive)->no_doorlock = 1;
> @@ -3211,6 +3214,7 @@
>  
>  	nslots = ide_cdrom_probe_capabilities (drive);
>  
> +	; /* FIXME: also not ro if CDC_WR */
>  	if (CDROM_CONFIG_FLAGS(drive)->dvd_ram)
>  		set_disk_ro(drive->disk, 0);

Possibly some of those conjectured ide-cd FIXME are necessary.

Now substituting ATAPI for USB, even with the patch applied to
2.6.0-test9, still we see:

$ sudo sg_scan -i
/dev/sg0: scsi0 channel=0 id=0 lun=0 [em]  type=5
    Iomega    RRD               40.D [wide=0 sync=0 cmdq=0 sftre=0 pq=0x0]
$
$ sudo sg_dd of=/dev/sg0 if=/dev/zero bs=2k count=1
1+0 records in
1+0 records out
$
$ sudo sg_inq /dev/hdd | egrep 'id'
 Vendor identification: Iomega
 Product identification: RRD
$
$ sudo dd of=/dev/hdd if=/dev/zero bs=2k count=1
dd: writing `/dev/hdd': Operation not permitted
1+0 records in
0+0 records out
$
$ grep -i permitted /usr/include/asm/errno.h
#define EPERM            1      /* Operation not permitted */
$ grep EPERM drivers/ide/ide-cd.c
$ grep EPERM drivers/cdrom/cdrom.c
$

Pat LaVarre


