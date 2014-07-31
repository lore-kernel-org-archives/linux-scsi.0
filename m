From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: scsi_debug: support scsi-mq, queues and locks
Date: Thu, 31 Jul 2014 12:10:28 +0300
Message-ID: <20140731091028.GA29976@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38030 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253AbaGaJML (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2014 05:12:11 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

[ This is not really a new bug, it's just that renaming the function
  made it show up as a new bug and I figured maybe you know what's going
  on since you are working with related code.  -dan ]

Hello Douglas Gilbert,

This is a semi-automatic email about new static checker warnings.

The patch cbf67842c3d9: "scsi_debug: support scsi-mq, queues and 
locks" from Jul 26, 2014, leads to the following Smatch complaint:

drivers/scsi/scsi_debug.c:4153 scsi_debug_queuecommand()
	 error: we previously assumed 'cmd' could be null (see line 4106)

drivers/scsi/scsi_debug.c
  4105		if ((SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) &&
  4106		    !(SCSI_DEBUG_OPT_NO_CDB_NOISE & scsi_debug_opts) && cmd) {
                                                                        ^^^
Check.

  4107			char b[120];
  4108			int n;
  4109	
  4110			len = SCpnt->cmd_len;
  4111			if (len > 32)
  4112				strcpy(b, "too long, over 32 bytes");
  4113			else {
  4114				for (k = 0, n = 0; k < len; ++k)
  4115					n += scnprintf(b + n, sizeof(b) - n, "%02x ",
  4116						       (unsigned int)cmd[k]);
  4117			}
  4118			sdev_printk(KERN_INFO, SCpnt->device, "%s: cmd %s\n", my_name,
  4119				    b);
  4120		}
  4121	
  4122		if ((SCpnt->device->lun >= scsi_debug_max_luns) &&
  4123		    (SCpnt->device->lun != SAM2_WLUN_REPORT_LUNS))
  4124			return schedule_resp(SCpnt, NULL, DID_NO_CONNECT << 16, 0);
  4125		devip = devInfoReg(SCpnt->device);
  4126		if (NULL == devip)
  4127			return schedule_resp(SCpnt, NULL, DID_NO_CONNECT << 16, 0);
  4128	
  4129		if ((scsi_debug_every_nth != 0) &&
  4130		    (atomic_inc_return(&sdebug_cmnd_count) >=
  4131		     abs(scsi_debug_every_nth))) {
  4132			atomic_set(&sdebug_cmnd_count, 0);
  4133			if (scsi_debug_every_nth < -1)
  4134				scsi_debug_every_nth = -1;
  4135			if (SCSI_DEBUG_OPT_TIMEOUT & scsi_debug_opts)
  4136				return 0; /* ignore command causing timeout */
  4137			else if (SCSI_DEBUG_OPT_MAC_TIMEOUT & scsi_debug_opts &&
  4138				 scsi_medium_access_command(SCpnt))
  4139				return 0; /* time out reads and writes */
  4140			else if (SCSI_DEBUG_OPT_RECOVERED_ERR & scsi_debug_opts)
  4141				inj_recovered = 1; /* to reads and writes below */
  4142			else if (SCSI_DEBUG_OPT_TRANSPORT_ERR & scsi_debug_opts)
  4143				inj_transport = 1; /* to reads and writes below */
  4144			else if (SCSI_DEBUG_OPT_DIF_ERR & scsi_debug_opts)
  4145				inj_dif = 1; /* to reads and writes below */
  4146			else if (SCSI_DEBUG_OPT_DIX_ERR & scsi_debug_opts)
  4147				inj_dix = 1; /* to reads and writes below */
  4148			else if (SCSI_DEBUG_OPT_SHORT_TRANSFER & scsi_debug_opts)
  4149				inj_short = 1;
  4150		}
  4151	
  4152		if (devip->wlun) {
  4153			switch (*cmd) {
                                ^^^^
Unchecked dereference.

  4154			case INQUIRY:
  4155			case REQUEST_SENSE:

regards,
dan carpenter
