From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: Disk wakeup on resume
Date: Tue, 05 Nov 2013 17:05:31 +0800
Message-ID: <5278B4DB.7080302@intel.com>
References: <527859D9.3030607@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10497 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab3KEJEq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Nov 2013 04:04:46 -0500
In-Reply-To: <527859D9.3030607@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>

On 11/05/2013 10:37 AM, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> I can not figure out what is waking up disks on resume from suspend.
> I thought it was sd.c, and setting manage_start_stop = 0 should stop
> that.  It does stop the message printed saying it is being started,
> yet the disk is still started, and this makes the resume take nearly
> 10 seconds.  So it seems sd_resume()'s attempt to start the disk is
> pointless and redundant, and something else is starting up the disk.

Are you using an ATA drive?
Last time I checked, the spin up actually happened while the ata port is
resumed(when it will be reset):
https://lkml.org/lkml/2013/2/4/361

-Aaron

> Oddly, if I unbind the sd driver ( echo 1 >
> /sys/block/sdx/device/delete ), then after a resume the disk remains
> off ( and spins up again on rescan ).
> 
> I don't see why the kernel needs to delay completing the resume until
> after the disks have spun up when they will automatically spin up when
> accessed, which may be never ( thus they should be left spun down ),
> but I can not find the culprit causing this.
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.14 (GNU/Linux)
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
> 
> iQEcBAEBCgAGBQJSeFnWAAoJEJrBOlT6nu758QwIAJAhlQ5o6qDG9fm98w0j7MY9
> OYp/NTd/nO4LGPGaTob/JCyuMDPMtXCOdueLxStlqnBLnPgfANZWD+VSSbsm/uae
> pzvjihe6uU+mTCbPW0MNPEiFpH2mfVY8NMhrAEI/n0j9fjgd7E33NI2fedymEDPk
> LcgdOtdQP3VSMMs6pjPRpkpVBJG1g3Y6XPLV8IFj8RPz6lUj3k5qj45lsgf//Am8
> 5vD8SRoZZd7bZghqOCeUU2I/1kntKI5qz4cDUQq6wTVwqAuhLbpjFMOk5lX3gg/h
> Q25FGU6Rc8nMyLw4eLbRA8Tvh2aLX5anPkdJqkb132ulbmqP7b8hjUZ4qtNQ/wA=
> =JmIT
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

