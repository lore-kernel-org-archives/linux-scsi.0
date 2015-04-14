From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] csiostor: fix an error code in csio_hw_init()
Date: Tue, 14 Apr 2015 17:32:19 +0300
Message-ID: <20150414143219.GA30421@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "David S. Miller" <davem@davemloft.net>, Hariprasad Shenai <hariprasad@chelsio.com>, Praveen Madhavan <praveenm@chelsio.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We should return -ENOMEM if kzalloc() fails here instead of returning
success.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index 2e66f34..622bdab 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -3928,6 +3928,7 @@ csio_hw_init(struct csio_hw *hw)
 
 		evt_entry = kzalloc(sizeof(struct csio_evt_msg), GFP_KERNEL);
 		if (!evt_entry) {
+			rv = -ENOMEM;
 			csio_err(hw, "Failed to initialize eventq");
 			goto err_evtq_cleanup;
 		}
