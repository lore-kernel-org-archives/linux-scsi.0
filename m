From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 2.6.39 and Powerfile c200
Date: Sat, 28 May 2011 20:26:46 +0200
Message-ID: <20110528202646.02280a95@stein>
References: <BANLkTikkCOML4aNv_wSrk9VRSofjVwtVAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45037 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab1E1S1D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 May 2011 14:27:03 -0400
In-Reply-To: <BANLkTikkCOML4aNv_wSrk9VRSofjVwtVAw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Isom <jeisom@gmail.com>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

(Cc: lsml)

On May 27 Jonathan Isom wrote to linux1394-user:
> After upgrading to 2.6.39,  I'm getting "rejecting I/O to offline
> device" repeatedly in dmesg.  Full log is attached.
> I can load disks into the DVD drives, however the drives a not usable.
>  The Powerfile C200 is a 200 Disk DVD
> Changer with 2 drives. I didn't turn on the Changer till 249508.718311.

Which is:

[249508.718311] firewire_core: phy config: card 0, new root=ffc1, gap_count=5
[249509.320382] firewire_core: created device fw1: GUID 003060f200002759, S400
[249509.458787] scsi8 : SBP-2 IEEE-1394
[249509.659575] firewire_sbp2: fw1.0: logged in to LUN 0000 (0 retries)
[249509.661749] scsi 8:0:0:0: CD-ROM            TOSHIBA  DVD-ROM SD-M1212 1032 PQ: 0 ANSI: 0 CCS
[249509.666218] sr1: scsi3-mmc drive: 32x/32x cd/rw xa/form2 cdda tray
[249509.666479] sr 8:0:0:0: Attached scsi CD-ROM sr1
[249509.666611] sr 8:0:0:0: Attached scsi generic sg5 type 5
[249509.668791] firewire_sbp2: fw1.0: logged in to LUN 0001 (0 retries)
[249509.671056] scsi 8:0:0:1: CD-ROM            TOSHIBA  DVD-ROM SD-M1212 1032 PQ: 0 ANSI: 0 CCS
[249509.676162] sr2: scsi3-mmc drive: 32x/32x cd/rw xa/form2 cdda tray
[249509.676385] sr 8:0:0:1: Attached scsi CD-ROM sr2
[249509.676514] sr 8:0:0:1: Attached scsi generic sg6 type 5
[249509.678677] firewire_sbp2: fw1.0: logged in to LUN 0002 (0 retries)
[249509.683634] scsi 8:0:0:2: Medium Changer    Escient  Powerfile C200   04A  PQ: 0 ANSI: 3

OK.

[249509.685951] ch0: reading element address assigment page failed!

Don't know if this is bad or not.

[249509.685962] ch0: INITIALIZE ELEMENT STATUS, may take some time ...
[249509.686719] ch0: ... finished
[249509.686729] ch 8:0:0:2: Attached scsi changer ch0
[249509.686948] ch 8:0:0:2: Attached scsi generic sg7 type 8

OK.

[249539.712075] firewire_sbp2: fw1.0: sbp2_scsi_abort
[249549.712062] firewire_sbp2: fw1.0: sbp2_scsi_abort
[249549.712287] sr 8:0:0:0: Device offlined - not ready after error recovery
[249549.712393] sr 8:0:0:0: rejecting I/O to offline device
[249583.704061] firewire_sbp2: fw1.0: sbp2_scsi_abort
[249593.704070] firewire_sbp2: fw1.0: sbp2_scsi_abort
[249593.704307] sr 8:0:0:1: Device offlined - not ready after error recovery
[249593.704423] sr 8:0:0:1: rejecting I/O to offline device
[249593.706254] sr 8:0:0:0: rejecting I/O to offline device
[249593.706276] sr 8:0:0:0: rejecting I/O to offline device
[249593.706948] sr 8:0:0:0: rejecting I/O to offline device
[249593.706976] sr 8:0:0:0: rejecting I/O to offline device
[249593.709258] sr 8:0:0:1: rejecting I/O to offline device
[...repeated almost 2000 times...]
[250542.004258] sr 8:0:0:0: rejecting I/O to offline device
[250542.004269] sr 8:0:0:0: rejecting I/O to offline device
[250542.004340] sr 8:0:0:1: rejecting I/O to offline device
[250542.004350] sr 8:0:0:1: rejecting I/O to offline device

All three SCSI units were probed and attached successfully.  This involves
successful execution of a few basic SCSI commands.

30 seconds after that, and again after additional 10 seconds and further
34 seconds + additional 10 seconds, firewire-sbp2 logs that in total four
SCSI commands timed out.  The kernel's SCSI subsystem decides to take the
two DVD-ROM logical units offline.

Why the time-outs happened is is not clear.  Also, I have no idea what
could be done with the kernel's SCSI subsystem so that it logs *which*
commands timed out.

Was the 2.6.39 kernel update the only change that you did on your system,
or were there userland updates too?  If yes, maybe you have a program now
that sends weird commands that crash the Powerfile's firmware.
-- 
Stefan Richter
-=====-==-== -=-= ===--
http://arcgraph.de/sr/
