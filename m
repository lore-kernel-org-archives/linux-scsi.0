From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 3/7] scsi: storvsc: Always send on the selected outgoing
 channel
Date: Fri, 27 Mar 2015 00:27:16 -0700
Message-ID: <1427441240-29314-3-git-send-email-kys@microsoft.com>
References: <1427441219-29275-1-git-send-email-kys@microsoft.com>
 <1427441240-29314-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1427441240-29314-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
List-Id: linux-scsi@vger.kernel.org

The current code always sent packets without data on the primary channel.
Properly distribute sending of packets with no data amongst all available
channels. I would like to thank Long Li for noticing this problem.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 7f569f9..0ba7f2c 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1362,7 +1362,7 @@ static int storvsc_do_io(struct hv_device *device,
 				vmscsi_size_delta),
 				(unsigned long)request);
 	} else {
-		ret = vmbus_sendpacket(device->channel, vstor_packet,
+		ret = vmbus_sendpacket(outgoing_channel, vstor_packet,
 			       (sizeof(struct vstor_packet) -
 				vmscsi_size_delta),
 			       (unsigned long)request,
-- 
1.7.4.1
