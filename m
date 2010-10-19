From: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] libfc: fix mem leak in fc_exch_recv_seq_resp()
Date: Tue, 19 Oct 2010 22:02:01 +0800
Message-ID: <AANLkTinfFm7J40LexHWjR90N4pCO2F58PhGaCxkFoBB9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

There seems that ep should get released, or it will no longer get freed.

Signed-off-by: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---

--- a/drivers/scsi/libfc/fc_exch.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/libfc/fc_exch.c	2010-10-19 21:36:16.000000000 +0800
@@ -1343,7 +1343,7 @@ static void fc_exch_recv_seq_resp(struct
 	}
 	if (ep->esb_stat & ESB_ST_COMPLETE) {
 		atomic_inc(&mp->stats.xid_not_found);
-		goto out;
+		goto rel;
 	}
 	if (ep->rxid == FC_XID_UNKNOWN)
 		ep->rxid = ntohs(fh->fh_rx_id);
