From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 12195] "dd" make kernel panic
Date: Mon, 15 Dec 2008 14:13:27 -0600
Message-ID: <1229372007.3293.84.camel@localhost.localdomain>
References: <20081215103958.4801D108042@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35641 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752700AbYLOUNS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2008 15:13:18 -0500
In-Reply-To: <20081215103958.4801D108042@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Mon, 2008-12-15 at 02:39 -0800, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12195
> 
> 
> 
> 
> 
> ------- Comment #12 from ming.m.lin@intel.com  2008-12-15 02:39 -------
> (In reply to comment #7)
> > If you have time for another re-create it would be good to set some scsi
> > logging.
> > sysctl -w dev.scsi.logging_level=4100 # mlcomplete 1 and error 4
> > echo "1" > /proc/sys/kernel/sysrq # If needed
> > echo 9 > /proc/sysrq-trigger # Raise console log level
> > 
> 
> mptscsih: ioc0: attempting task abort! (sc=e000000037a36980)
> sd 0:0:1:0: [sdb] CDB: cdb[0]=0x28: 28 00 01 3b 4e a0 00 01 00 00
> mptbase: ioc0: WARNING - IOC is in FAULT state (000eh)!!!
> mptbase: ioc0: WARNING - Issuing HardReset from mpt_fault_reset_work!!
> mptbase: ioc0: Initiating recovery
> mptbase: ioc0: WARNING - IOC is in FAULT state!!!
> mptbase: ioc0: WARNING -            FAULT code = 000eh
> mptscsih: ioc0: Issue of TaskMgmt failed!
> mptscsih: ioc0: task abort: FAILED (sc=e000000037a36980)
> mptscsih: ioc0: attempting task abort! (sc=e000000037a35f80)
> sd 0:0:1:0: [sdb] CDB: cdb[0]=0x28: 28 00 01 3b 4f a0 00 01 00 00
> mptscsih: ioc0: task abort: FAILED (sc=e000000037a35f80)
> mptscsih: ioc0: attempting target reset! (sc=e000000037a36980)
> sd 0:0:1:0: [sdb] CDB: cdb[0]=0x28: 28 00 01 3b 4e a0 00 01 00 00
> mptscsih: ioc0: target reset: FAILED (sc=e000000037a36980)
> mptscsih: ioc0: attempting bus reset! (sc=e000000037a36980)
> sd 0:0:1:0: [sdb] CDB: cdb[0]=0x28: 28 00 01 3b 4e a0 00 01 00 00
> mptscsih: ioc0: bus reset: FAILED (sc=e000000037a36980)
> mptscsih: ioc0: attempting host reset! (sc=e000000037a36980)
> mptscsih: ioc0: host reset: SUCCESS (sc=e000000037a36980)
> sd 0:0:1:0: Device offlined - not ready after error recovery
> sd 0:0:1:0: Device offlined - not ready after error recovery
> sd 0:0:1:0: [sdb] Result: hostbyte=0x00 driverbyte=0x06
> end_request: I/O error, dev sdb, sector 20663968
> Buffer I/O error on device sdb, logical block 5165992
> Buffer I/O error on device sdb, logical block 5165993
> Buffer I/O error on device sdb, logical block 5165994
> Buffer I/O error on device sdb, logical block 5165995
> Buffer I/O error on device sdb, logical block 5165996
> Buffer I/O error on device sdb, logical block 5165997
> Buffer I/O error on device sdb, logical block 5165998
> Buffer I/O error on device sdb, logical block 5165999
> Buffer I/O error on device sdb, logical block 5166000
> Buffer I/O error on device sdb, logical block 5166001
> sd 0:0:1:0: rejecting I/O to offline device
> sd 0:0:1:0: [sdb] Result: hostbyte=0x00 driverbyte=0x06
> end_request: I/O error, dev sdb, sector 20664224
> mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000000!
> sd 0:0:1:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 1,
> sc=e000000037a36980, mf = e0000000406847e0, idx=55
> sd 0:0:1:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 1,
> sc=e000000037a35f80, mf = e0000000406883e0, idx=f5
> Unable to handle kernel NULL pointer dereference (address 0000000000000044)
> mpt_poll_0[378]: Oops 8813272891392 [1]

Oh ... this is actually a fusion problem, then.  It looks like the
fusion is relying on the old done behaviour.  Does this work?  It
flushes the fusion internal queue if we go into host reset.  This should
prevent the commands turning up later after the device has been
offlined.

James

---

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index d62fd4f..ee09041 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2008,6 +2008,9 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 		return FAILED;
 	}
 
+	/* make sure we have no outstanding commands at this stage */
+	mptscsih_flush_running_cmds(hd);
+
 	ioc = hd->ioc;
 	printk(MYIOC_s_INFO_FMT "attempting host reset! (sc=%p)\n",
 	    ioc->name, SCpnt);


