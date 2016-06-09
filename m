From: Olaf Hering <olaf@aepfle.de>
Subject: [PATCH v3] storvsc: use small sg_tablesize on x86
Date: Thu,  9 Jun 2016 18:25:53 +0200
Message-ID: <20160609162553.10290-1-olaf@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: devel@linuxdriverproject.org, Olaf Hering <olaf@aepfle.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Reducing the sg_tablesize allows booting of 32bit kernels in VMs, after
commit be0cf6ca301c61458dc4aa1a37acf4f58d2ed3d6 ("scsi: storvsc: Set the
tablesize based on the information given by the host")

[    5.567138] hv_storvsc vmbus_1: adjusting sg_tablesize 0x800 -> 0x20

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---

As requested, use CONFIG_<bitsize>. For some reason IS_ENABLED(64_BIT)
does not work.

 drivers/scsi/storvsc_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 3ddcabb..ae42324 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1673,11 +1673,15 @@ static int storvsc_probe(struct hv_device *device,
 	/* max cmd length */
 	host->max_cmd_len = STORVSC_MAX_CMD_LEN;
 
+#ifdef CONFIG_64BIT
 	/*
 	 * set the table size based on the info we got
 	 * from the host.
 	 */
 	host->sg_tablesize = (stor_device->max_transfer_bytes >> PAGE_SHIFT);
+#else
+	host->sg_tablesize = MAX_MULTIPAGE_BUFFER_COUNT;
+#endif
 
 	/* Register the HBA and start the scsi bus scan */
 	ret = scsi_add_host(host, &device->device);
