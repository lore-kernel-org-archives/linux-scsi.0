From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Linux Virtual SCSI HBAs and Virtual disks
Date: Tue, 23 Jan 2007 18:16:56 +0100
Message-ID: <45B64308.1060703@s5r6.in-berlin.de>
References: <1e157f74d8578f24c762571c1016aab3@aboo.org> <b43c8fc9882e65d397a6465e6cb7c998@aboo.org> <45B4EAAC.5000008@s5r6.in-berlin.de> <45B60993.9070508@aboo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:37372 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100AbXAWRQ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2007 12:16:58 -0500
In-Reply-To: <45B60993.9070508@aboo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aboo Valappil <aboo@aboo.org>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

Aboo Valappil wrote:
> I implemented a new IOCTL to remove  this  scsi_host  if the user 
> process really needs to.  This removal  will first  finish all the SCSI 
> commands (With the above status results) queued on the scsi_host  (If at 
> all) and then remove the scsi_host.  Also the module unload will delete 
> all the scsi_hosts created after finishing all the commands queued with 
> the above status and sense information.

This is a valid approach, but probably more useful would be something like:
  - userspace device server or "modprobe -r" or procfs/sysfs magic or
    whatever else requests removal of a Scsi_Host (or merely of a single
    scsi_device),
  - vscsihba enters scsi_remove_host() or scsi_remove_device(),
  - SCSI core and upper layers do whatever it takes to withdraw from
    the respective I-T(-L) nexus gracefully (e.g. synchronize cache,
    unlock drive door...),
  - userspace device server handles any previously remaining commands
    and the new shutdown commands like intended,
  - SCSI core and upper layers are finished with their business,
    the respective Scsi_Host or scsi_device does not exist anymore now,
    vscsihba leaves scsi_remove_host() or scsi_remove_device(),
  - vscsihba tells userspace device server somehow that there will be
    no further requests, ever.

That way, your "virtual" device server is exposed to everything which a
"real" device server would be too when a Linux initiator shuts the
connection down. Could be interesting to testbed device servers as well
as to userspace bridges to "real" device servers.

When implemented, the "graceful shutdown" path should look almost
exactly like the opposite of the start-up path. The "hot-unplug" path
looks a little different because vscsihba has to go through that path
without assistance of the userspace server. Ideally, the "hot-unplug"
path would actually be the "graceful shutdown" path plus a few little
extra measures to account for premature absence of the device server.

[Of course, I'm saying all this without ever having designed a Linux
SCSI LLD myself, only from the background of maintaining an LLD written
by other people...]
-- 
Stefan Richter
-=====-=-=== ---= =-===
http://arcgraph.de/sr/
