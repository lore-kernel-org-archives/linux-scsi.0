From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [0/18]  qla2xxx: summary of changes...
Date: Mon, 21 Jun 2004 22:48:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622054816.GA8375@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:34975 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266381AbUFVFod (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 01:44:33 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

James,

Please apply the following patches I'm about to send to update the
qla2xxx driver.  A summary of the patches can be found towards the end
of this message.

With the exception of the rather large firmware image update
(direct pointer to bzip'd patch listed), subsequent messages will
contain inlined patches.

All patches can be found at the following URL:

	ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b14k/

Regards,
Andrew Vasquez
QLogic Corporation


ChangeSet@1.1837, 2004-06-03 15:00:49-07:00, andrew.vasquez@apc.qlogic.com
  Add memory barriers to ensure that all load operations have
  completed before the (MMIO) write to the ISP's registers.



ChangeSet@1.1838, 2004-06-03 15:24:43-07:00, andrew.vasquez@apc.qlogic.com
  Problem reported/corrected by Tony Battersby [tonyb@cybernetics.com]:
  
  o The qla2xxx driver calculates data transfer residuals
    for some but not all circumstances.  The patch below
    adds data transfer residual calculations for the
    remaining cases.
  
  o Interrogate the proper cmnd[] array when determining
    the transfer direction.



ChangeSet@1.1839, 2004-06-03 15:44:26-07:00, andrew.vasquez@apc.qlogic.com
  Restructure qla2x00_start_scsi() so that PCI mappings are
  done after we've verified command list and request queue
  resource availability.



ChangeSet@1.1840, 2004-06-03 15:59:16-07:00, andrew.vasquez@apc.qlogic.com
  Problem reported/corrected by Michael Reed [mdr@sgi.com]:
  
  We have a 2312 that puts the 8.00.00b12-k qla2xxx driver
  into an infinite loop with a solid interrupt, 0x8008,
  hcsr = 0x7430, risc status register 0x40008110,
  immediately after enabling parity on the board.
  
  It looks as though the early out test in
  qla_isr.c:qla2x00_intr_handler() against stat is broken.
  HSR_RISC_PAUSED is set.  Also, there's a stale mailbox
  completion flagged (stat&0xff) which will short circuit
  the default case in the switch if it got that far.



ChangeSet@1.1841, 2004-06-03 16:29:07-07:00, andrew.vasquez@apc.qlogic.com
  Add permissions to the driver's module_params.



ChangeSet@1.1842, 2004-06-03 17:02:04-07:00, andrew.vasquez@apc.qlogic.com
  Small initialization fixes:
  
  	o 'point-to-point preferred, else loop' is not a safe
  	  connection mode setting for ISP2200 boards.  Use 
  	  'loop preferred, else point-to-point.'
  
  	o Add modules parameter to enable ZIO -- Support mode
  	  5 only.
  
  	o No point in doing a PRLI (process login) to the SNS
  	  port.
  
  	o Fix problem where the driver would incorrectly skip
  	  ports with the same domain and area of the HBA.



ChangeSet@1.1843, 2004-06-04 08:09:21-07:00, andrew.vasquez@apc.qlogic.com
  Fix several tape handling issue:
  
  1) When the firmware receives the LOGO from the device, any
  active exchanges will be returned with a completion status
  of 0x29 -- this will cause the port to be marked as lost and
  request made to the DPC routine to begin a relogin attempt.
  The problem is, since we've never actually logged out of the
  device and cannot do so in interrupt context, we must be
  sure to perform the logout before the qla2x00_fabric_login()
  in the RELOGIN_NEEDED code.
  
  2) Sets the Get Port Database options to ZERO when issuing
  the call to qla2x00_get_port_database().  This consolidates
  actuall login handling in the place it should be, in the
  previous qla2x00_fabric_login() call rather than depending
  on any 'hidden' behaviour of the firmware.  If a device did
  a LOGO after the login, then any subsequent exachanges will
  be returned with an 0x29 completion status and the
  RELOGIN_NEEDED code will handle the login.
  
  3) Finally, if the master and slave state do not indicate a
  logged-in state from the Get Port Database call, then one
  cannot depend on the information returned from the firmware
  -- the firmware typically wipes out the PCB information for
  a given loopID when logged out.  So, return immediately with
  a failed status.



ChangeSet@1.1844, 2004-06-04 08:20:44-07:00, andrew.vasquez@apc.qlogic.com
  Remove several unused failover variables and functions from
  the embedded driver.



ChangeSet@1.1845, 2004-06-04 08:58:01-07:00, andrew.vasquez@apc.qlogic.com
  Address several outstanding problem within the various
  eh_*() functions:
  
  	o Fixup nested spinlock usage in error-hanlding
  	  functions.
  
  	o Set the Loop down timer during abort isp if loop
  	  was already down for the driver to detect cable
  	  is unplugged at min time.



ChangeSet@1.1846, 2004-06-16 11:40:12-07:00, andrew.vasquez@apc.qlogic.com
  Issue a big-hammer after link-down-timeout expires in order
  properly return tape commands to the mid-layer.



ChangeSet@1.1847, 2004-06-16 13:55:20-07:00, andrew.vasquez@apc.qlogic.com
  Small fixes:
  
  o Remove incorrect and unused ISP2100 #define
    SS_RESIDUAL_LEN_VALID.
  
  o Fix problem where an incorrect status would be returned
    for qla2x00_configure_fabric() if the driver was unable to
    log into a fabric's SNS.
  
  o Check for the additional WAIT_FOR_AL_PA state in
    qla2x00_fw_ready() since switch vendors may push NOS/OLS
    primitives during a 'port disabled' state.



ChangeSet@1.1848, 2004-06-16 14:28:08-07:00, andrew.vasquez@apc.qlogic.com
  Add firmware dump support for ISPs with memory chips larger than
  128KB (512/1024KB).



ChangeSet@1.1849, 2004-06-17 10:04:59-07:00, andrew.vasquez@apc.qlogic.com
  Christoph Hellwig <hch () lst !de>:
  
  o Remove TRUE/FALSE #define usage within the driver.



ChangeSet@1.1850, 2004-06-17 13:52:06-07:00, andrew.vasquez@apc.qlogic.com
  Use the standard include/scsi/* headers rather than those in
  drivers/scsi/.  Slightly modified variant from initial patch sent by
  Christoph Hellwig <hch () lst !de>.



ChangeSet@1.1851, 2004-06-18 10:01:28-07:00, andrew.vasquez@apc.qlogic.com
  Cleanup qla2x00_eh_wait_on_command() srb_t handling.



ChangeSet@1.1852, 2004-06-18 10:03:35-07:00, andrew.vasquez@apc.qlogic.com
  Resync with latest released firmware -- 3.02.30.



ChangeSet@1.1853, 2004-06-21 15:34:37-07:00, andrew.vasquez@apc.qlogic.com
  Fix incorrect return-code check in bus-reset error handler.



ChangeSet@1.1854, 2004-06-21 15:35:33-07:00, andrew.vasquez@apc.qlogic.com
  Update version number to 8.00.00b14-k.
