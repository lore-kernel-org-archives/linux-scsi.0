From: =?UTF-8?Q?Michael_Dr=C3=BCing?= <michael@drueing.de>
Subject: Aborted sg_format; how to recover?
Date: Mon, 8 Mar 2010 21:40:13 +0100
Message-ID: <7D05ACFE637E4AE08F92B348397AC586@aeris>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41404 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755193Ab0CHUwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2010 15:52:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I recently tried to re-format a couple of 520byte/sector SCSI harddisks to 512bytes/sector. Most of them worked fine; however, two formats have been aborted halfway through. One of them always reported "medium format corrupted", and I was able to fix this one by re-formatting the disk which worked on the 3rd try or so.

The other disk keeps reporting "not ready" and I can't seem to re-start the format on this disk. Here's the output of sg_format for this disk:

-------------------------------------------------------------------
lavie:~# sg_format --format -vvv --count=-1 --size=512 /dev/sg1
open /dev/sg1 with flags=0x802
    inquiry cdb: 12 00 00 00 24 00
      duration=4 ms
    SEAGATE   ST314680 CLAR146  7A10   peripheral_type: disk [0x0]
      PROTECT=0
    mode sense (10) cdb: 5a 00 01 00 00 00 00 00 fc 00
      duration=0 ms
mode sense (10):  Fixed format, current;  Sense key: Not Ready
 Additional sense: Logical unit not ready, cause not reportable
  Field replaceable unit code: 2
 Raw sense data (in hex):
        70 00 02 00 00 00 00 0a  00 00 00 00 04 00 02 00
        00 00
    requested 252 bytes but got 0 bytes
MODE SENSE (10) command, device not ready
-------------------------------------------------------------------

Test Unit Ready also reports "not ready":

-------------------------------------------------------------------
lavie:~# sg_turs -vvv /dev/sg1
open /dev/sg1 with flags=0x800
    test unit ready cdb: 00 00 00 00 00 00
      duration=0 ms
test unit ready:  Fixed format, current;  Sense key: Not Ready
 Additional sense: Logical unit not ready, cause not reportable
  Field replaceable unit code: 2
 Raw sense data (in hex):
        70 00 02 00 00 00 00 0a  00 00 00 00 04 00 02 00
        00 00
device not ready
-------------------------------------------------------------------

And "start unit" doesn't work either:

-------------------------------------------------------------------
lavie:~# sg_start -vvv /dev/sg1
open /dev/sg1 with flags=0x802
    Start stop unit command: 1b 00 00 00 01 00
      duration=0 ms
start stop unit:  Fixed format, current;  Sense key: Not Ready
 Additional sense: Logical unit not ready, cause not reportable
  Field replaceable unit code: 2
 Raw sense data (in hex):
        70 00 02 00 00 00 00 0a  00 00 00 00 04 00 02 00
        00 00
START STOP UNIT command failed
-------------------------------------------------------------------

(The controller is an MPT FC card, /proc/scsi/mptfc/* says "LSIFC919 B0", just in case it matters)

Anyone know of any other method I could try to recover from this condition? Or is the disk eternally broken?

Thanks,
-Michael

