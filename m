From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V3 02/16] scsi: balance out autopm get/put calls in scsi_sysfs_add_sdev()
Date: Wed, 10 Sep 2014 14:54:09 +0300
Message-ID: <1410350063-23267-3-git-send-email-draviv@codeaurora.org>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

SCSI Well-known logical units generally don't have any scsi driver
associated with it which means no one will call scsi_autopm_put_device()
on these wlun scsi devices and this would result in keeping the
corresponding scsi device always active (hence LLD can't be suspended as
well). Same exact problem can be seen for other scsi device representing
normal logical unit whose driver is yet to be loaded. This patch fixes
the above problem with this approach:

- make the scsi_autopm_put_device call at the end of scsi_sysfs_add_sdev
  to make it balance out the get earlier in the function.
- let drivers do paired get/put calls in their probe methods.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 8b4105a..3524b68 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1044,10 +1044,6 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	pm_runtime_enable(&sdev->sdev_gendev);
 	scsi_autopm_put_target(starget);
 
-	/* The following call will keep sdev active indefinitely, until
-	 * its driver does a corresponding scsi_autopm_pm_device().  Only
-	 * drivers supporting autosuspend will do this.
-	 */
 	scsi_autopm_get_device(sdev);
 
 	error = device_add(&sdev->sdev_gendev);
@@ -1085,6 +1081,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 		}
 	}
 
+	scsi_autopm_put_device(sdev);
 	return error;
 }
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index aa43496..0cb5c9f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2965,6 +2965,7 @@ static int sd_probe(struct device *dev)
 	int index;
 	int error;
 
+	scsi_autopm_get_device(sdp);
 	error = -ENODEV;
 	if (sdp->type != TYPE_DISK && sdp->type != TYPE_MOD && sdp->type != TYPE_RBC)
 		goto out;
@@ -3041,6 +3042,7 @@ static int sd_probe(struct device *dev)
  out_free:
 	kfree(sdkp);
  out:
+	scsi_autopm_put_device(sdp);
 	return error;
 }
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7eeb936..2de44cc 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -657,6 +657,7 @@ static int sr_probe(struct device *dev)
 	struct scsi_cd *cd;
 	int minor, error;
 
+	scsi_autopm_get_device(sdev);
 	error = -ENODEV;
 	if (sdev->type != TYPE_ROM && sdev->type != TYPE_WORM)
 		goto fail;
@@ -744,6 +745,7 @@ fail_put:
 fail_free:
 	kfree(cd);
 fail:
+	scsi_autopm_put_device(sdev);
 	return error;
 }
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index aff9689..d3fd6e8 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4105,6 +4105,7 @@ static int st_probe(struct device *dev)
 		return -ENODEV;
 	}
 
+	scsi_autopm_get_device(SDp);
 	i = queue_max_segments(SDp->request_queue);
 	if (st_max_sg_segs < i)
 		i = st_max_sg_segs;
@@ -4244,6 +4245,7 @@ out_put_disk:
 out_buffer_free:
 	kfree(buffer);
 out:
+	scsi_autopm_put_device(SDp);
 	return -ENODEV;
 };
 
-- 
1.8.5.2
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
