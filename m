From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] enclosure: fix error path - actually return ERR_PTR()
 on error
Date: Fri, 12 Mar 2010 16:14:42 -0600
Message-ID: <1268432082.2802.401.camel@mulgrave.site>
References: <1268401858-9213-1-git-send-email-ext-jani.1.nikula@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933475Ab0CLXYv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 18:24:51 -0500
In-Reply-To: <1268401858-9213-1-git-send-email-ext-jani.1.nikula@nokia.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2010-03-12 at 15:50 +0200, Jani Nikula wrote:
> Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
> 
> ---
> 
> NOTE: I'm afraid I'm unable to test this; please consider this more a
> bug report than a complete patch.

It's a good bug report, thanks.  It looks like there's an unreleased
cdev pointer along that path too, so this should be the final fix.

James

---

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 1eac626..68e4cd7 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -284,8 +284,11 @@ enclosure_component_register(struct enclosure_device *edev,
 	cdev->groups = enclosure_groups;
 
 	err = device_register(cdev);
-	if (err)
-		ERR_PTR(err);
+	if (err) {
+		ecomp->number = -1;
+		put_device(cdev);
+		return ERR_PTR(err);
+	}
 
 	return ecomp;
 }



