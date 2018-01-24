From: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>
Subject: [PATCH 1/1] scsi: storvsc: Spread interrupts when picking a channel
 for I/O requests
Date: Wed, 24 Jan 2018 22:14:08 +0000
Message-ID: <1516831913-26013-1-git-send-email-mikelley@ntdev.microsoft.com>
Reply-To: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "longi@microsoft.com" <longi@microsoft.com>, "JBottomley@odin.com" <JBottomley@odin.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Update the algorithm in storvsc_do_io to look for a channel
starting with the current CPU + 1 and wrap around (within the
current NUMA node). This spreads VMbus interrupts more evenly
across CPUs. Previous code always started with first CPU in
the current NUMA node, skewing the interrupt load to that CPU.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index e07907d..f3264c4 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1310,7 +1310,8 @@ static int storvsc_do_io(struct hv_device *device,
 			 */
 			cpumask_and(&alloced_mask, &stor_device->alloced_cpus,
 				    cpumask_of_node(cpu_to_node(q_num)));
-			for_each_cpu(tgt_cpu, &alloced_mask) {
+			for_each_cpu_wrap(tgt_cpu, &alloced_mask,
+					outgoing_channel->target_cpu + 1) {
 				if (tgt_cpu !=3D outgoing_channel->target_cpu) {
 					outgoing_channel =3D
 					stor_device->stor_chns[tgt_cpu];
--=20
1.8.3.1
