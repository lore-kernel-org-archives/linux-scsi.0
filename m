From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] scsi: fcoe: sanity check string size for store_ctrl_mode
 option
Date: Thu, 23 Mar 2017 14:45:50 +0300
Message-ID: <20170323114549.GN32449@mwanda>
References: <20170322140137.28485-1-colin.king@canonical.com>
 <20170322193945.GK32449@mwanda>
 <1b8384a7-9efe-7b93-e418-0f377bb84a73@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1b8384a7-9efe-7b93-e418-0f377bb84a73@canonical.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Colin Ian King <colin.king@canonical.com>
Cc: Johannes Thumshirn <jth@kernel.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 22, 2017 at 07:42:08PM +0000, Colin Ian King wrote:
> On 22/03/17 19:39, Dan Carpenter wrote:
> > On Wed, Mar 22, 2017 at 02:01:37PM +0000, Colin King wrote:
> >> From: Colin Ian King <colin.king@canonical.com>
> >>
> >> Reading and writing to mode[count - 1] implies the count should not
> >> be less than 1 so add a sanity check for this.
> >>
> >> Detected with CoverityScan, CID#1357345 ("Overflowed array index write")
> >>
> >> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > 
> > This is harmless, of course, but count can't be zero.  This is a sysfs
> > file so we test for zero size writes in sysfs_kf_write() and return
> > early.
> 
> Ah, thanks for pointing out that. I overlooked that detail.
> 

The only reason I know this stuff is because it's annotated in Smatch.
So I do this:

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 9cf3d56296ab..c491ad8fb0a8 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -281,6 +281,7 @@ static ssize_t show_ctlr_mode(struct device *dev,
 			"%s\n", name);
 }
 
+#include "/home/dcarpenter/progs/smatch/devel/check_debug.h"
 static ssize_t store_ctlr_mode(struct device *dev,
 			       struct device_attribute *attr,
 			       const char *buf, size_t count)
@@ -288,6 +289,7 @@ static ssize_t store_ctlr_mode(struct device *dev,
 	struct fcoe_ctlr_device *ctlr = dev_to_ctlr(dev);
 	char mode[FCOE_MAX_MODENAME_LEN + 1];
 
+	__smatch_implied(count);
 	if (count > FCOE_MAX_MODENAME_LEN)
 		return -EINVAL;
 

Then when I run kchecker drivers/scsi/fcoe/fcoe_sysfs.c, it tells me:

drivers/scsi/fcoe/fcoe_sysfs.c:292 store_ctlr_mode() implied: count = '1-1000000000,2147479552'

Which is sort of surprising...  The 1000000000 value is a hack I made so
that it would never complain that "off + count" will wrap.  But
apparently something has changed so it's also picking up the true limit
of count which is 2147479552.

Then I run the following commands to view the call tree:
    smdb.py store_ctlr_mode
    smdb.py dev_attr_store
    smdb.py sysfs_kf_write
I have some vim macros so I can look these up really quickly.

regards,
dan carpenter
