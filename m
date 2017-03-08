From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] block: Allow bdi re-registration
Date: Wed,  8 Mar 2017 17:48:31 +0100
Message-ID: <20170308164834.14302-2-jack@suse.cz>
References: <20170308164834.14302-1-jack@suse.cz>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170308164834.14302-1-jack@suse.cz>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, linux-block@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Omar Sandoval <osandov@osandov.com>, Arthur Marsh <arthur.marsh@internode.on.net>, linux-scsi@vger.kernel.org, Jan Kara <jack@suse.cz>
List-Id: linux-scsi@vger.kernel.org

SCSI can call device_add_disk() several times for one request queue when
a device in unbound and bound, creating new gendisk each time. This will
lead to bdi being repeatedly registered and unregistered. This was not a
big problem until commit 165a5e22fafb "block: Move bdi_unregister() to
del_gendisk()" since bdi was only registered repeatedly (bdi_register()
handles repeated calls fine, only we ended up leaking reference to
gendisk due to overwriting bdi->owner) but unregistered only in
blk_cleanup_queue() which didn't get called repeatedly. After
165a5e22fafb we were doing correct bdi_register() - bdi_unregister()
cycles however bdi_unregister() is not prepared for it. So make sure
bdi_unregister() cleans up bdi in such a way that it is prepared for
a possible following bdi_register() call.

An easy way to provoke this behavior is to enable
CONFIG_DEBUG_TEST_DRIVER_REMOVE and use scsi_debug driver to create a
scsi disk which immediately hangs without this fix.

Fixes: 165a5e22fafb127ecb5914e12e8c32a1f0d3f820
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/backing-dev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 6d861d090e9f..6ac932210f56 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -710,6 +710,11 @@ static void cgwb_bdi_destroy(struct backing_dev_info *bdi)
 	 */
 	atomic_dec(&bdi->usage_cnt);
 	wait_event(cgwb_release_wait, !atomic_read(&bdi->usage_cnt));
+	/*
+	 * Grab back our reference so that we hold it when @bdi gets
+	 * re-registered.
+	 */
+	atomic_inc(&bdi->usage_cnt);
 }
 
 /**
@@ -857,6 +862,8 @@ int bdi_register_owner(struct backing_dev_info *bdi, struct device *owner)
 			MINOR(owner->devt));
 	if (rc)
 		return rc;
+	/* Leaking owner reference... */
+	WARN_ON(bdi->owner);
 	bdi->owner = owner;
 	get_device(owner);
 	return 0;
-- 
2.10.2
