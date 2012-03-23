From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [libsas PATCH v12 04/11] sysfs: handle 'parent deleted before
 child added'
Date: Fri, 23 Mar 2012 11:43:28 -0700
Message-ID: <1332528209.23830.4.camel@ultramagnus.opencreations.com>
References: <20120322063127.22036.23206.stgit@dwillia2-linux.jf.intel.com>
	 <20120322063214.22036.77957.stgit@dwillia2-linux.jf.intel.com>
	 <20120322143959.GF19835@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120322143959.GF19835@kroah.com>
Sender: linux-ide-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-03-22 at 07:39 -0700, Greg Kroah-Hartman wrote:
> And note, I hate pr_err(), what's wrong with printk() in this instance?

So how about an end run around the conversion to pr_err() and just make
these proper WARN()s since we end up calling dump_stack in both cases?

Something like:

diff --git a/lib/kobject.c b/lib/kobject.c
index e5f86c0..1bd0893 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -192,15 +192,14 @@ static int kobject_add_internal(struct kobject *kobj)
 
 		/* be noisy on error issues */
 		if (error == -EEXIST)
-			pr_err("%s failed for %s with "
-			       "-EEXIST, don't try to register things with "
-			       "the same name in the same directory.\n",
-			       __func__, kobject_name(kobj));
+			WARN(1, "%s failed for %s with "
+			     "-EEXIST, don't try to register things with "
+			     "the same name in the same directory.\n",
+			     __func__, kobject_name(kobj));
 		else
-			pr_err("%s failed for %s (error: %d parent: %s)\n",
-			       __func__, kobject_name(kobj), error,
-			       parent ? kobject_name(parent) : "'none'");
-		dump_stack();
+			WARN(1, "%s failed for %s (error: %d parent: %s)\n",
+			     __func__, kobject_name(kobj), error,
+			     parent ? kobject_name(parent) : "'none'");
 	} else
 		kobj->state_in_sysfs = 1;
 


