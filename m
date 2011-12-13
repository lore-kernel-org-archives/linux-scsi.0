From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v5 5/6] ata: add ata port system PM callbacks
Date: Tue, 13 Dec 2011 22:20:40 +0800
Message-ID: <1323786040.3769.24.camel@hp6530s>
References: <1323048028-10421-1-git-send-email-ming.m.lin@intel.com>
	 <1323048028-10421-6-git-send-email-ming.m.lin@intel.com>
	 <CAF1ivSbRejpSEVfHAhOUxaqAedkCQVHWOgsJGFLM2yt2QaxtuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSbRejpSEVfHAhOUxaqAedkCQVHWOgsJGFLM2yt2QaxtuQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <JBottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-12-13 at 21:56 +0800, Lin Ming wrote:
> +
> +static int ata_port_resume(struct device *dev)
> +{
> +       struct ata_port *ap = to_ata_port(dev);
> +       int rc;
> +
> +       rc = ata_port_request_pm(ap, PMSG_ON, ATA_EH_RESET,
> +               ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 1);
> +       return rc;
> +}

I just realized that the ata port runtime PM status need to be updated
after system resume.

I tried below patch.
Unfortunately, it causes a problem that sd can't resume correctly.

During system resume, ata port is resumed first and then sd resumed.

When ata port resumed, device_resume(...) calls pm_runtime_put_sync(..),
which causes ata port to be runtime suspended immediately.

So sd resume fails because it requires ata port to be active to handle
start device command.

This seems a PM core's bug.

device_resume(...) should not runtime suspend the parent device, because
its children have not resumed yet.

Alan, 

What do you think?

---
 drivers/ata/libata-core.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 15a3d4d..8996758 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5298,7 +5298,7 @@ static int ata_port_suspend(struct device *dev)
 	return ata_port_suspend_common(dev);
 }
 
-static int ata_port_resume(struct device *dev)
+static int ata_port_resume_common(struct device *dev)
 {
 	struct ata_port *ap = to_ata_port(dev);
 	int rc;
@@ -5308,6 +5308,20 @@ static int ata_port_resume(struct device *dev)
 	return rc;
 }
 
+static int ata_port_resume(struct device *dev)
+{
+	int rc;
+
+	rc = ata_port_resume_common(dev);
+	if (!rc) {
+		pm_runtime_disable(dev);
+		pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
+	}
+
+	return rc;
+}
+
 static int ata_port_runtime_idle(struct device *dev)
 {
 	return pm_runtime_suspend(dev);
@@ -5318,7 +5332,7 @@ static const struct dev_pm_ops ata_port_pm_ops = {
 	.resume = ata_port_resume,
 
 	.runtime_suspend = ata_port_suspend_common,
-	.runtime_resume = ata_port_resume,
+	.runtime_resume = ata_port_resume_common,
 	.runtime_idle = ata_port_runtime_idle,
 };
 






