From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Question / Request about timeouts of SATA harddisks
Date: Thu, 03 Jun 2010 08:32:45 +0200
Message-ID: <4C074C8D.509@stud.tu-ilmenau.de>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wega.rz.tu-ilmenau.de ([141.24.4.159]:33257 "EHLO
	wega.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab0FCGlo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2010 02:41:44 -0400
Received: from [192.168.178.35] (erft-4db7cd7b.pool.mediaWays.net [77.183.205.123])
	(authenticated bits=0)
	by wega.rz.tu-ilmenau.de (8.12.11/8.12.11/Debian-3) with ESMTP id o536YSJT006108
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 3 Jun 2010 08:34:29 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear list,

concerning RAIDs with Desktop class drives it'd be good to know if there
is any kernel-timeout-value which states, how long a diskdrive may take
to process a command.  If it doesn't respond in-time I've seen in my
logs and with many disks that the sg-eh becomes active resetting the
bus.  So somewhere there needs to be such a timeout.

The question is: can this timeout-value be found somewhere in the sysfs?
 If "yes" where?  If "no", can it be exported?

Suggestions for the maximum of this timeout-value:
I've read in multiple places that the internal error correction of
desktop-class drives can even take more than 2 minutes to complete.  But
another much bigger value can be taken directly out of the
IDENTIFY_DEVICE_STRUCTURE, word 89, which states how long a
SECURITY_ERASE_UNIT command takes approximately (in minutes-see
ATA8-ACS, table 32 for the exact meaning of the value).  A in some cases
even longer time can be found in word 90 (time estimate for enhanced
security erase unit, table 33).

I know for sure that this command should not be issued from linux - at
least not at this state of libata.  I've done it twice on two different
Samsung HD103UJ drives to "securely erase customer data".  While
executing the command libata made the PassThru command fail within a
minute and according to syslog it unsuccessfully tried to reset the
drive.  The results were (after letting the drives run for about the
indicated 3 hours): one drive broke completely, it was never again
recognized on any computer, the other drive was recognized though, but
did not operate properly anymore.

Any comments and hints are very welcome.  All the best,
Stefan
