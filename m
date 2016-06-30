From: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] libfc: sanity check cpu number extracted
	from xid
Date: Thu, 30 Jun 2016 08:32:36 -0700
Message-ID: <1467300756-7949-1-git-send-email-cleech@redhat.com>
References: <20160630070925.ptbgkeq57txs55gf@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <20160630070925.ptbgkeq57txs55gf-3LAbnSA0sDC4fIQPS+WK3rNAH6kLmebB@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Johannes Thumshirn <jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

In the receive path libfc extracts a cpu number from the ox_id in the
fiber channel header and uses that to do a per_cpu_ptr conversion.
If, for some reason, a frame is received with an invalid ox_id,
per_cpu_ptr will return an invalid pointer and the libfc receive path
will panic the system trying to use it.

I'm currently looking at such a case, and I don't yet know why a
cpu number > nr_cpu_ids is appearing in an exchange id.  But adding a
sanity check in libfc prevents a system panic, and seems like good idea
when dealing with frames coming in from the network.

Signed-off-by: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/libfc/fc_exch.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 30f9ef0..e72673b 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -908,9 +908,17 @@ static struct fc_exch *fc_exch_find(struct fc_exch_mgr *mp, u16 xid)
 {
 	struct fc_exch_pool *pool;
 	struct fc_exch *ep = NULL;
+	u16 cpu = xid & fc_cpu_mask;
+
+	if (cpu >= nr_cpu_ids || !cpu_possible(cpu)) {
+		printk_ratelimited(KERN_ERR
+			"libfc: lookup request for XID = %d, "
+			"indicates invalid CPU %d\n", xid, cpu);
+		return NULL;
+	}
 
 	if ((xid >= mp->min_xid) && (xid <= mp->max_xid)) {
-		pool = per_cpu_ptr(mp->pool, xid & fc_cpu_mask);
+		pool = per_cpu_ptr(mp->pool, cpu);
 		spin_lock_bh(&pool->lock);
 		ep = fc_exch_ptr_get(pool, (xid - mp->min_xid) >> fc_cpu_order);
 		if (ep) {
-- 
2.5.5
