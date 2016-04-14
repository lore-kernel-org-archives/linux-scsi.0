From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch v2] scsi_dh_alua: uninitialized variable in alua_rtpg()
Date: Thu, 14 Apr 2016 21:20:34 +0300
Message-ID: <20160414182034.GA32469@mwanda>
References: <570FBB0E.9030902@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <570FBB0E.9030902@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Johannes Thumshirn <jthumshirn@suse.de>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

It's possible to use "err" without initializing it.  If it happens to be
a 2 which is SCSI_DH_RETRY then that could cause a bug.  Bart Van Assche
pointed out that we should probably re-initialize it for every iteration
through the retry loop.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: The first version just initialized it at the start of the function.

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 8eaed05..a655cf2 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -532,6 +532,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		return SCSI_DH_DEV_TEMP_BUSY;
 
  retry:
+	err = 0;
 	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr, pg->flags);
 
 	if (retval) {
