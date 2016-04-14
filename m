From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] scsi_dh_alua: uninitialized variable in alua_rtpg()
Date: Thu, 14 Apr 2016 12:39:17 +0300
Message-ID: <20160414093917.GA16891@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Johannes Thumshirn <jthumshirn@suse.de>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

It's possible to use "err" without initializing it.  If it happens to be
a 2 which is SCSI_DH_RETRY then that could cause a bug.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 8eaed05..f3c994f 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -513,7 +513,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	struct alua_port_group *tmp_pg;
 	int len, k, off, valid_states = 0, bufflen = ALUA_RTPG_SIZE;
 	unsigned char *desc, *buff;
-	unsigned err, retval;
+	unsigned int err = 0;
+	unsigned int retval;
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
 	unsigned long flags;
