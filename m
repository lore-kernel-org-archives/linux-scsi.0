From: Jeremy Linton <jli@greshamstorage.com>
Subject: Bad emulex/linux FC behavior
Date: Wed, 27 May 2009 16:10:54 -0500
Message-ID: <4A1DAC5E.2070709@greshamstorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gatekeeper.greshamstorage.com ([12.166.178.178]:31959 "EHLO
	AUSEXCH1.greshamstorage.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758400AbZE0VZz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 May 2009 17:25:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi <linux-scsi@vger.kernel.org>, james.smart@emulex.com

While hunting for a data integrity problem, I discovered that the emulex lpfc driver sends target resets to all attached 
devices on a SAN in the lpfc_reset_bus_handler() routine. That routine is exported in the host template and is 
indirectly called by scsi_eh_ready_devs() when any device attached to the current HBA fails (more on this later).

I believe this is fundamentally the wrong thing to be doing. It makes sense for a parallel SCSI bus but not on a SAN. 
SAN attached devices are completely independent, and a single target failure should not result in anyone zoned together 
with the failed device being reset.

This is not an unusual configuration. Our product runs in an environment where the customers regularly have a pool of 
tape drives shared among a mix of server platforms/applications. Having our machine spuriously sending resets to devices 
currently in use by other servers is a serious problem.

Lun resets are defined by the T10 specifications to drop reservations, clear soft write protect flags, clear medium 
removal preventions, etc. I can't find anywhere that describes the behaviors of write back buffers during resets, but I 
believe I've found one device which dumps the write back buffer without flushing it to the media when it receives a 
reset. Either way, any application or application that depends on system drivers using reservations as a method of 
device arbitration between machines/application instances is going to have serious problems. Should an attached Linux 
machine clear those reservations it will result in a data integrity problems.

As such, I suggest that the emulex driver simply return from the eh_bus_reset_handler. I've been running like that for a 
few days and it doesn't adversely affect anything. I've also looked at the qlogic driver and it has a similar piece of 
code but the functionality can be enabled/disabled by the enable_target_reset flag (from nvram) in qla2x00_loop_reset(). 
Frankly, I can't really imagine a scenario where its valid to reset an attached device on a SAN if a completely 
different device fails. Personally, I would remove the code there too.

Our machines are running fairly old kernels, but the latest RC kernels appear to still have the same code.









