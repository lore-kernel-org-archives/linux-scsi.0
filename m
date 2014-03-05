From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v5 0/3] Accelerate Storage Resume (2x or more)
Date: Wed, 05 Mar 2014 12:17:24 -0800
Message-ID: <20140305201443.20088.85361.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, JBottomley@Parallels.com
Cc: Len Brown <len.brown@intel.com>, linux-scsi@vger.kernel.org, Phillip Susi <psusi@ubuntu.com>, linux-ide@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Todd Brandt <todd.e.brandt@linux.intel.com>, Todd Brandt <todd.e.brandt@intel.com>
List-Id: linux-scsi@vger.kernel.org

It is not everyday that a kernel operation gets 2x faster.  Nice find
by Todd and his AnalyzeSuspend tool [1].

Todd is on vacation so I am taking care of these patches to make sure
they get in the queue for 3.15.

The significant changes from Todd's last submission [2]:

1/ Split out the pure cleanup into its own patch, and expand it to clean
   up libsas as well

2/ Move the entirety of scsi_device resume to an async context.  As
   written, v4 of the patchset overlapped the scsi-start-stop command
   with the scsi_device_resume().  Now in v5 the queue restart is
   properly ordered with the completion of the scsi-start-stop command.

Resume completion time as reported by:

"echo devices > /sys/power/pm_test && echo mem > /sys/power/state"

BEFORE: PM: resume of devices complete after 2271.097 msecs
AFTER:  PM: resume of devices complete after 1057.404 msecs

On a system with two SSDs attached via AHCI.

--
Dan


[1]: Todd's testing showing up to 12x resume latency improvement in some
cases:
https://01.org/suspendresume/blogs/tebrandt/2013/hard-disk-resume-optimization-simpler-approach

[2]: Todd's v4 patchset:
[PATCH v4 0/2] http://marc.info/?l=linux-ide&m=138984698103487&w=2
[PATCH v4 1/2] http://marc.info/?l=linux-ide&m=138984713203515&w=2
[PATCH v4 2/2] http://marc.info/?l=linux-ide&m=138984722003539&w=2

---

Dan Williams (2):
      libata, libsas: kill pm_result and related cleanup
      scsi: async sd resume

Todd Brandt (1):
      libata: async resume


 drivers/ata/libata-core.c     |   75 ++++++++++-----------------
 drivers/ata/libata-eh.c       |   13 +----
 drivers/scsi/libsas/sas_ata.c |   35 ++----------
 drivers/scsi/scsi.c           |    3 +
 drivers/scsi/scsi_pm.c        |  115 ++++++++++++++++++++++++++++++++---------
 drivers/scsi/scsi_priv.h      |    1 
 drivers/scsi/sd.c             |    1 
 include/linux/libata.h        |    9 +--
 include/scsi/libsas.h         |    1 
 9 files changed, 134 insertions(+), 119 deletions(-)
