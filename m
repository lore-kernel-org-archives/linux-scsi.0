From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 8/12] drivers/scsi: Correct size given to memset
Date: Wed, 9 Dec 2009 20:24:48 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0912092024300.1870@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757472AbZLITYw@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Memset should be given the size of the structure, not the size of the pointer.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T *x;
expression E;
@@

memset(x, E, sizeof(
+ *
 x))
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/fcoe/libfcoe.c              |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_transport.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -444,7 +444,7 @@ static int fcoe_ctlr_encaps(struct fcoe_
 	cap->encaps.fd_desc.fip_dlen = dlen / FIP_BPW;
 
 	mac = (struct fip_mac_desc *)skb_put(skb, sizeof(*mac));
-	memset(mac, 0, sizeof(mac));
+	memset(mac, 0, sizeof(*mac));
 	mac->fd_desc.fip_dtype = FIP_DT_MAC;
 	mac->fd_desc.fip_dlen = sizeof(*mac) / FIP_BPW;
 	if (dtype != FIP_DT_FLOGI && dtype != FIP_DT_FDISC)
diff -u -p a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -162,7 +162,7 @@ _transport_set_identify(struct MPT2SAS_A
 		return -EIO;
 	}
 
-	memset(identify, 0, sizeof(identify));
+	memset(identify, 0, sizeof(*identify));
 	device_info = le32_to_cpu(sas_device_pg0.DeviceInfo);
 
 	/* sas_address */
