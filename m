From: Robert Love <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] fcoe: Remove redundant 'less than zero' check
Date: Thu, 05 Jul 2012 07:52:25 -0700
Message-ID: <20120705145225.21808.62255.stgit@fritz>
References: <20120703152739.ea7df9e6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <20120703152739.ea7df9e6.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Unsubscribe: <https://lists.open-fcoe.org/mailman/options/devel>,
 <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.open-fcoe.org/mailman/listinfo/devel>,
 <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

strtoul returns an 'unsigned long' so there is no
reason to check if the value is less than zero.

strtoul already checks for the '-' character deep
in its bowels. It will return an error if the user
has provided a negative value and fcoe_str_to_dev_loss
will return that error to its caller.

This patch fixes the following Coverity reported warning:

CID 703581 -  NO_EFFECT Unsigned compared against 0 - This
less-than-zero comparison of an unsigned value is never true. "*val < 0UL".
drivers/scsi/fcoe/fcoe_sysfs.c:105

Signed-off-by: Robert Love <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/scsi/fcoe/fcoe_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 2bc1631..5e75168 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -102,7 +102,7 @@ static int fcoe_str_to_dev_loss(const char *buf, unsigned long *val)
 	int ret;
 
 	ret = kstrtoul(buf, 0, val);
-	if (ret || *val < 0)
+	if (ret)
 		return -EINVAL;
 	/*
 	 * Check for overflow; dev_loss_tmo is u32
