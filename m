From: Dan Finn <dhrider@gmail.com>
Subject: PE 2450 with flashing health light and PERC Raid utility says Raid status is critical
Date: Tue, 23 Nov 2004 14:07:08 -0800
Message-ID: <89ceee704112314072631ecd8@mail.gmail.com>
Reply-To: Dan Finn <dhrider@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.197]:28570 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261367AbUKWWHI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2004 17:07:08 -0500
Received: by rproxy.gmail.com with SMTP id a36so23245rnf
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2004 14:07:08 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have a PE 2450 here that has had a flashing orange health light for
a couple of months now. I scheduled some downtime for it last night to
investigate. The raid utility says that RAID0 (a raid 5 array with 3
18G drives, the only raid array on the system and the only drives in
the system) is critical, but it does not tell me why or what is wrong.
It lists all 3 disks and it doesn't show any errors for them at all.

This server is running redhat 6.2 and kernel 2.2.14-6.1.1smp, loading
the percraid kernel module. It has been running fine now for quite
some time but I would like to figure out if there is really a problem
or not.

After rebooting it the health light on the front of the server is now
solid green, which I think is how it should be if there are no
problems. But, during bootup I still see the error from the scsi card
saying that the raid is critical.

I came accross this site:
http://www.redflag-linux.com/ppd/product_files/2003-AP001-01-01/base_doc/Dell_AACRAID.htm

And installed the Dell command line interface software from:
http://www.domsch.com/linux/aacraid/afaapps-2.6-0.tar.gz

I then can use the software and get the following for output:
FASTCMD> controller list
Executing: controller list

Adapter Name Adapter Type Availability Clustering
------------ ------------ ------------ ------------
afa0 PERC 3/Si read/write No
_controller show > open afa0
Executing: open "afa0"

_controller show > controller show channels
Executing: controller show channels

Ch# Host ID Targets Type Max Usage
--- ------- ------- --------- ---------
0 7 15 Ultra160 NoInfo

_controller firmware > disk list
Executing: disk list

B:ID:L Device Type Blocks Bytes/Block Usage Shared Rate
------ -------------- --------- ----------- ---------------- ------ ----
0:00:0 Disk 35566478 512 Initialized NO 160
0:01:0 Disk 35566478 512 Initialized NO 160
0:02:0 Disk 35566478 512 Initialized NO 160

AFA0> disk show defects 0
Executing: disk show defects (ID=0)

Number of PRIMARY defects on drive: 951

Number of GROWN defects on drive: 0

AFA0> disk show defects 1
Executing: disk show defects (ID=1)

Number of PRIMARY defects on drive: 641

Number of GROWN defects on drive: 0

AFA0> disk show defects 2
Executing: disk show defects (ID=2)

Number of PRIMARY defects on drive: 168

Number of GROWN defects on drive: 0

_enclosure identify > enclosure list
Executing: enclosure list

Enclosure
ID (B:ID:L) Fan Power Slot Sensor Door Speaker Standard Diagnostic
----------- --- ----- ---- ------ ---- -------- -------- ----------
0 0:06:0 0 0 4 2 0 No SAF-TE PASSED


_enclosure identify > enclosure show status
Executing: enclosure show status

Enclosure
ID (B:ID:L) UpTime D:H:M PowerCycle Interval Door Alarm
----------- -------------- ---------- -------- -------- -----
0 0:06:0 0:00:00 0 10 UNLOCKED OFF

Enclosure
ID (B:ID:L) Fan Status
----------- --- -------------

Enclosure
ID (B:ID:L) Power State Status
----------- ----- ------------ -------

Enclosure
ID (B:ID:L) Slot scsiId Insert Status
----------- ---- ------ ------- ------------------------------------------
0 0:06:0 0 0:00:0 1 OK FAILED CRITICAL ACTIVATE
0 0:06:0 1 0:01:0 1 OK FAILED CRITICAL ACTIVATE
0 0:06:0 2 0:02:0 1 OK FAILED CRITICAL ACTIVATE
0 0:06:0 3 0:255:0 0 OK UNCONFIG EMPTY I/R READY NOTACTIVATE

Enclosure
ID (B:ID:L) Sensor Temperature Threshold Status
----------- ------ ----------- --------- --------
0 0:06:0 0 73 F 120 NORMAL
0 0:06:0 1 86 F 120 NORMAL

Pretty cool software but it's still not telling where the problem is.
Could it be flaky software on the PERC controller, and there really
isn't a problem?

Any help would be really appreciated.

Thanks
Dan
