From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 5224] New: Panic upon rmmod of aic7xxx module
 (pcmcia)
Date: Sun, 11 Sep 2005 12:50:40 -0700
Message-ID: <20050911125040.5bab6c30.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:22667 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750776AbVIKTvT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Sep 2005 15:51:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@kernel-bugs.osdl.org>



Begin forwarded message:

Date: Sun, 11 Sep 2005 12:28:56 -0700
From: bugme-daemon@kernel-bugs.osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 5224] New: Panic upon rmmod of aic7xxx module (pcmcia)


http://bugzilla.kernel.org/show_bug.cgi?id=5224

           Summary: Panic upon rmmod of aic7xxx module (pcmcia)
    Kernel Version: 2.6.13
            Status: NEW
          Severity: normal
             Owner: andmike@us.ibm.com
         Submitter: kasper.peeters@aei.mpg.de


Most recent kernel where this bug did not occur: early 2.6.x
Distribution: Red Hat
Hardware Environment: Fujitsu-Siemens E7110, Adaptec 1480A, HP 9200 CDwriter
Software Environment: pcmcia-tools 3.2.8
Problem Description: Upon rmmod of the aic7xxx module, a kernel panic follows
after a few seconds. Ditto when the pcmcia card is removed by hand. The 
console still spits out

  [...]
  Sequencer Free SCB List 0 1 2
  Sequencer SCB Info
    0 SCB_CONTROL[0x0]:SCB_SCSIID[0x67]:SCB_LOW[0x0]:SCB_TAG[0xff]
    1 SCB_CONTROL[0x0]:SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TIB)SCB_LUN[0xff]:\
(SCB_XFERLEN_ODD|LID)SCB_TAG[0xff]
    2 SCB_CONTROL[0x0]:SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TIB)SCB_LUN[0xff]:\
(SCB_XFERLEN_ODD|LID)SCB_TAG[0xff]
  Pending List:
    2 SCB_CONTROL[0x40]:(DISCENB)SCB_SCSIID[0x47]:SCB_LUN[0x0]
  Kernel Free SCB List: 1 0
  Untagged Q(4):2

  <<< Dump Card State End >>>
  qindex = 0, SCB index=0
  Kernel Panic - not syncing: Loop 1

Steps to reproduce: boot machine, insert pcmcia card which loads the 
aic7xxx module, wait until scsi device has been recognised and the
module usecount returns to '0', then 'rmmod aic7xxx'.

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
