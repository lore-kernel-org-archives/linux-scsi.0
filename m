From: Simon Arlott <simon@fire.lp0.eu>
Subject: [PATCH (v2)] cdrom: support devices that have check_events but not
 media_changed
Date: Mon, 31 Jan 2011 18:26:38 +0000
Message-ID: <4D46FEDE.7060909@simon.arlott.org.uk>
References: <1291838262-21274-1-git-send-email-tj@kernel.org> <1291838262-21274-8-git-send-email-tj@kernel.org> <4D44BE3E.5080107@simon.arlott.org.uk> <4D44BF64.4060205@simon.arlott.org.uk> <20110131101244.GA7459@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20110131101244.GA7459@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, jack@suse.cz, James.Bottomley@HansenPartnership.com, sshtylyov@mvista.com
List-Id: linux-scsi@vger.kernel.org

Commit 93aae17af1172c40c6f74b7294e93a90c3cfaa5d ("sr: implement
sr_check_events()") replaced the media_changed op with the
check_events op in drivers/scsi/sr.c

All users that check for the CDC_MEDIA_CHANGED capbility try both
the check_events op and the media_changed op, but register_cdrom()
was requiring media_changed.

This patch fixes the capability checking.

The cdrom_select_disc ioctl is also using the two operations, so
they should be required for CDC_SELECT_DISC too.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/cdrom/cdrom.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 14033a3..e2c48a7 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -409,7 +409,8 @@ int register_cdrom(struct cdrom_device_info *cdi)
 	}
 
 	ENSURE(drive_status, CDC_DRIVE_STATUS );
-	ENSURE(media_changed, CDC_MEDIA_CHANGED);
+	if (cdo->check_events == NULL && cdo->media_changed == NULL)
+		*change_capability = ~(CDC_MEDIA_CHANGED | CDC_SELECT_DISC);
 	ENSURE(tray_move, CDC_CLOSE_TRAY | CDC_OPEN_TRAY);
 	ENSURE(lock_door, CDC_LOCK);
 	ENSURE(select_speed, CDC_SELECT_SPEED);
-- 
1.7.0.4

-- 
Simon Arlott
