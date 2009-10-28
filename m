From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v2 1/7] scsi-ml: modify change_queue_depth
 to take in reason why it is being called
Date: Wed, 28 Oct 2009 22:48:38 +0000
Message-ID: <1256770118.2989.24.camel@localhost.localdomain>
References: <20091016004639.22451.76363.stgit@vifc.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <20091016004639.22451.76363.stgit-M4Lc0Xp98oKtqXYlAKuG4QC/G2K4zDHf@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: christof.schmitt-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2009-10-15 at 17:46 -0700, Vasu Dev wrote:
> From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
> 
> This patch modifies scsi_host_tematepl->change_queue_depth so that
> it takes an argument indicating why it is being called. This will be
> used so that if a LLD needs to do some extra processing when
> handling queue fulls or later ramp ups, it can do so.
> 
> This is a simple port of the drivers setting a change_queue_depth
> callback. In the patch I just have these LLDs adjust the queue depth
> if the user was requesting it.
> 
> Signed-off-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
> 
> -v2
> 	Also converted pmcraid_change_queue_depth and then verified
> all modules compile  using "make allmodconfig" for any new build
> warnings on X86_64.
> 
> 	Updated original description after combing two original
> patches from Mike to make this patch git bisectable.
> 
> Signed-off-by: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This still doesn't build:

drivers/scsi/53c700.c: In function 'NCR_700_detect':
drivers/scsi/53c700.c:331: warning: assignment from incompatible pointer type
drivers/scsi/53c700.c: At top level:
drivers/scsi/53c700.c:2085: error: conflicting types for 'NCR_700_change_queue_depth'
drivers/scsi/53c700.c:178: error: previous declaration of 'NCR_700_change_queue_depth' was here

It looks like just an unconverted function prototype, so the patch below fixes it.

James

---

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index a5a493d..6c60a80 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -175,7 +175,7 @@ STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
 STATIC int NCR_700_slave_alloc(struct scsi_device *SDpnt);
 STATIC int NCR_700_slave_configure(struct scsi_device *SDpnt);
 STATIC void NCR_700_slave_destroy(struct scsi_device *SDpnt);
-static int NCR_700_change_queue_depth(struct scsi_device *SDpnt, int depth);
+static int NCR_700_change_queue_depth(struct scsi_device *SDpnt, int depth, int reason);
 static int NCR_700_change_queue_type(struct scsi_device *SDpnt, int depth);
 
 STATIC struct device_attribute *NCR_700_dev_attrs[];
