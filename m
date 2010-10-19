From: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] libfc: fix handling of fc frame in
	fc_exch_recv_bls()
Date: Tue, 19 Oct 2010 21:55:20 +0800
Message-ID: <AANLkTikQYBNsV2vbAfG+xe+ruJq+vfFTvJPOMUXAApXT@mail.gmail.com>
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

There seems that fp should get freed if exch is unavailable.

Signed-off-by: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---

--- a/drivers/scsi/libfc/fc_exch.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/libfc/fc_exch.c	2010-10-19 21:35:08.000000000 +0800
@@ -1564,8 +1564,11 @@ static void fc_exch_recv_bls(struct fc_e
 				fc_frame_free(fp);
 			break;
 		case FC_RCTL_BA_ABTS:
-			fc_exch_recv_abts(ep, fp);
-			break;
+			if (ep) {
+				fc_exch_recv_abts(ep, fp);
+				break;
+			}
+			/* fall thru */
 		default:			/* ignore junk */
 			fc_frame_free(fp);
 			break;
