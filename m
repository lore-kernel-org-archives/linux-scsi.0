From: Karen Xie <kxie@chelsio.com>
Subject: RE: linux-next: Tree for December 29 (cxgb3i)
Date: Mon, 29 Dec 2008 22:00:47 -0800
Message-ID: <20081230060047.GA20917@qatest2a.asicdesigners.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="fUYQa+Pmc3FrFX/N"
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-next-owner@vger.kernel.org
To: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-next@vger.kernel.org, sfr@canb.auug.org.au, kxie@chelsio.com
List-Id: linux-scsi@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi, Randy & James,

The cxgb3i driver was using the skb->sp for some internal stuff. I have just submitted a patch to remove the usage of it since it is not really related to the secure path.

The patch is submitted to the list (http://marc.info/?l=linux-scsi&m=123061555414193&w=2) and is also attached here.

Sorry for the late response, I am traveling this week.

Thanks,
Karen

-----Original Message-----
From: Randy Dunlap [mailto:randy.dunlap@oracle.com]
Sent: Mon 12/29/2008 2:10 PM
To: James Bottomley
Cc: Stephen Rothwell; scsi; linux-next@vger.kernel.org; LKML; Karen Xie
Subject: Re: linux-next: Tree for December 29 (cxgb3i)
 
James Bottomley wrote:
> On Mon, 2008-12-29 at 12:35 -0800, Randy Dunlap wrote:
>> On Tue, 30 Dec 2008 03:16:21 +1100 Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20081219:
>>>
>>> Undropped tree:
>>> 	scci
>>> 	mtd
>>>
>>> Dropped trees (temporarily):
>>> 	nfs (akpm request due to 2.6.30 features)
>>> 	kvm (build problem)
>>> 	rr (build poblem)
>>> 	semaphore-removal (due to unfixed conflicts against Linus' tree)
>>> 	cpu_alloc (build problem)
>>> 	audit (difficult conflicts)
>>>
>>> Linus' tree had three build failures requiring patches and one requiring
>>> a revert.
>>
>> linux-next-20081229/drivers/scsi/cxgb3i/cxgb3i_offload.c:499: error: 'struct sk_buff' has no member named 'sp'
>> linux-next-20081229/drivers/scsi/cxgb3i/cxgb3i_offload.c:512: error: 'struct sk_buff' has no member named 'sp'
>> linux-next-20081229/drivers/scsi/cxgb3i/cxgb3i_offload.c:532: error: 'struct sk_buff' has no member named 'sp'
>> linux-next-20081229/drivers/scsi/cxgb3i/cxgb3i_offload.c:533: error: 'struct sk_buff' has no member named 'sp'
> 
> In the config 20 questions, my guess for this is CONFIG_XFRM=n

That's correct.  config file is now attached.

> I'm not at all sure why this driver is playing with the secure path ...
> I suspect the use needs to be enclosed in #ifdef CONFIG_XFRM pairs, but
> I'd like the maintainers to verify.

-- 
andy


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="122908-cxgb3i-no-wr-sp.patch"

[PATCH 1/1] cxgb3i - remove use of skb->sp

From: Karen Xie <kxie@chelsio.com>

The cxgb3i was using skb->sp pointer for some internal book-keeping which is not related to the secure path. Changed it to use skb->cb[] instead.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---

 drivers/scsi/cxgb3i/cxgb3i_offload.c |    8 ++++----
 drivers/scsi/cxgb3i/cxgb3i_offload.h |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)


diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index 5f16081..a865f1f 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -496,7 +496,7 @@ static inline void reset_wr_list(struct s3_conn *c3cn)
 static inline void enqueue_wr(struct s3_conn *c3cn,
 			      struct sk_buff *skb)
 {
-	skb->sp = NULL;
+	skb_wr_data(skb) = NULL;
 
 	/*
 	 * We want to take an extra reference since both us and the driver
@@ -509,7 +509,7 @@ static inline void enqueue_wr(struct s3_conn *c3cn,
 	if (!c3cn->wr_pending_head)
 		c3cn->wr_pending_head = skb;
 	else
-		c3cn->wr_pending_tail->sp = (void *)skb;
+		skb_wr_data(skb) = skb;
 	c3cn->wr_pending_tail = skb;
 }
 
@@ -529,8 +529,8 @@ static inline struct sk_buff *dequeue_wr(struct s3_conn *c3cn)
 
 	if (likely(skb)) {
 		/* Don't bother clearing the tail */
-		c3cn->wr_pending_head = (struct sk_buff *)skb->sp;
-		skb->sp = NULL;
+		c3cn->wr_pending_head = skb_wr_data(skb);
+		skb_wr_data(skb) = NULL;
 	}
 	return skb;
 }
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.h b/drivers/scsi/cxgb3i/cxgb3i_offload.h
index 5b93d62..d231569 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.h
@@ -180,7 +180,7 @@ void cxgb3i_c3cn_release(struct s3_conn *);
  * @seq:	tcp sequence number
  * @ddigest:	pdu data digest
  * @pdulen:	recovered pdu length
- * @ulp_data:	scratch area for ULP
+ * @wr_data:	scratch area for tx wr
  */
 struct cxgb3_skb_cb {
 	__u8 flags;
@@ -188,7 +188,7 @@ struct cxgb3_skb_cb {
 	__u32 seq;
 	__u32 ddigest;
 	__u32 pdulen;
-	__u8 ulp_data[16];
+	struct sk_buff *wr_data;
 };
 
 #define CXGB3_SKB_CB(skb)	((struct cxgb3_skb_cb *)&((skb)->cb[0]))
@@ -196,7 +196,7 @@ struct cxgb3_skb_cb {
 #define skb_ulp_mode(skb)	(CXGB3_SKB_CB(skb)->ulp_mode)
 #define skb_ulp_ddigest(skb)	(CXGB3_SKB_CB(skb)->ddigest)
 #define skb_ulp_pdulen(skb)	(CXGB3_SKB_CB(skb)->pdulen)
-#define skb_ulp_data(skb)	(CXGB3_SKB_CB(skb)->ulp_data)
+#define skb_wr_data(skb)	(CXGB3_SKB_CB(skb)->wr_data)
 
 enum c3cb_flags {
 	C3CB_FLAG_NEED_HDR = 1 << 0,	/* packet needs a TX_DATA_WR header */

--fUYQa+Pmc3FrFX/N--
