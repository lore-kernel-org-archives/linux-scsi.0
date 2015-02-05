From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] storvsc: assign wait_for_completion_timeout to appropriately
 typed var
Date: Thu,  5 Feb 2015 01:47:22 -0500
Message-ID: <1423118842-25233-1-git-send-email-hofrat@osadl.org>
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
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Nicholas Mc Guire <hofrat@osadl.org>, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

wait_for_completion_timeout() returns unsigned long not int. This assigns
the return value to an appropriately typed variable.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

As a suitable typed and named variable "timeout" is available and there is
no conflict in this case no new variable is needed rather the declaration
is simply updated.

Patch was only compile tested for x86_64_defconfig + CONFIG_X86_VSMP=y
CONFIG_HYPERV=m, SCSI_LOWLEVEL=y, CONFIG_HYPERV_STORAGE=m

Patch is against 3.19.0-rc7 (localversion-next is -next-20150204)

 drivers/scsi/storvsc_drv.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index efc6e44..a993d12 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -796,7 +796,8 @@ static void  handle_multichannel_storage(struct hv_device *device, int max_chns)
 	int num_sc;
 	struct storvsc_cmd_request *request;
 	struct vstor_packet *vstor_packet;
-	int ret, t;
+	int ret;
+	unsigned long t;
 
 	num_sc = ((max_chns > num_cpus) ? num_cpus : max_chns);
 	stor_device = get_out_stor_device(device);
@@ -861,7 +862,8 @@ static int storvsc_channel_init(struct hv_device *device)
 	struct storvsc_device *stor_device;
 	struct storvsc_cmd_request *request;
 	struct vstor_packet *vstor_packet;
-	int ret, t;
+	int ret;
+	unsigned long t;
 	int max_chns;
 	bool process_sub_channels = false;
 
-- 
1.7.10.4
