From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mpath: always return reservation conflict
Date: Mon, 15 Aug 2016 09:08:29 -0400
Message-ID: <20160815130829.GA14829@redhat.com>
References: <1470141392-25479-1-git-send-email-hch@lst.de>
 <1470141392-25479-2-git-send-email-hch@lst.de>
 <20160811183832.GA27144@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbcHONIb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2016 09:08:31 -0400
Content-Disposition: inline
In-Reply-To: <20160811183832.GA27144@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, hare@suse.de

Not sure how Hannes' original patch was overlooked but...

One issue I see with the patch is it will return -EBADE regardless of
whether 'queue_if_no_path' is set.  That's fine (since path isn't being
failed for this case any more).  But why not just return error
immediately?

But taking a step back, shouldn't all paths be tried once before
returning an error?  Obviously that'd impose the use of a new
'conflict_seen' (or whatever) flag at the end of 'struct pgpath'.  And
then only return error if the flag is set.

I threw together the following RFC patch to illustrate what I'm
thinking, but thinking about this further it is tough to know all paths
have seen the reservation conflict (my patch assumes if 'conflict_seen'
is set then the conflict iterated through all paths.. but if paths
aren't being failed there isn't a guarantee that the path selector
didn't just hand us back the same path that just experienced the
conflict).  So this is throw-away for now (and I'll get Hannes' patch
applied for 4.8-rc3, with the tweak of returning -EBADE immediately): 

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index ac734e5..c3d92db 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -41,6 +41,7 @@ struct pgpath {
 	struct delayed_work activate_path;
 
 	bool is_active:1;		/* Path status */
+	bool conflict_seen:1;
 };
 
 #define path_to_pgpath(__pgp) container_of((__pgp), struct pgpath, path)
@@ -1569,6 +1570,33 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	if (noretry_error(error))
 		return error;
 
+	if (error == -EBADE) {
+		/*
+		 * EBADE signals a reservation conflict.
+		 * We shouldn't fail the path here as we can communicate with
+		 * the target. We should failover to the next path, but in
+		 * doing so we might be causing a ping-pong between paths.
+		 * Avoid this by only returning the reservation conflict error
+		 * if a conflict has been seen on all paths.
+		 */
+		if (!mpio->pgpath || mpio->pgpath->conflict_seen) {
+			struct priority_group *pg;
+			struct pgpath *p;
+
+			/* clear 'conflict_seen' for all pgpaths */
+			list_for_each_entry(pg, &m->priority_groups, list) {
+				list_for_each_entry(p, &pg->pgpaths, list) {
+					p->conflict_seen = false;
+				}
+			}
+			return error;
+		}
+		else if (mpio->pgpath) {
+			mpio->pgpath->conflict_seen = true;
+			return r;
+		}
+	}
+
 	if (mpio->pgpath)
 		fail_path(mpio->pgpath);
 
@@ -1576,9 +1604,6 @@ static int do_end_io(struct multipath *m, struct request *clone,
 		if (!test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
 			if (!must_push_back_rq(m))
 				r = -EIO;
-		} else {
-			if (error == -EBADE)
-				r = error;
 		}
 	}
 
