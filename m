From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] fix session release module reference
Date: Wed, 05 Jul 2006 13:52:21 -0500
Message-ID: <44AC0A65.6000101@cs.wisc.edu>
References: <D4F8F0B3820E754C887699BEF26A89404A72ED@taurus.voltaire.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070701030201010002060501"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:27090 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S964914AbWGESwL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2006 14:52:11 -0400
In-Reply-To: <D4F8F0B3820E754C887699BEF26A89404A72ED@taurus.voltaire.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com, linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070701030201010002060501
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

James,

Attached is a mail and patch from the iser maintainer that fixes a bug
in the patchset we just sent where we free a struct then try to
reference it later. The patch was made over scsi-misc. If it is not too
late it could go into rc1. If it is too late then I will resend it with
my other bugfixe patches we had queued up and are testing.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


Or Gerlitz wrote:
> Mike said he might be busy these days, so i need some help from people on this list
> to validate that indeed the patches pushed to Linus break iscsi in session_destroy
> so we can send upstream a fixing patch (eg in the spirit of  the attached).
> 


--------------070701030201010002060501
Content-Type: text/x-patch;
 name="session_teardown2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="session_teardown2.patch"

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 7e6e031..ca590cd 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1322,6 +1322,7 @@ void iscsi_session_teardown(struct iscsi
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
+	struct module *owner = cls_session->transport->owner;
 
 	scsi_remove_host(shost);
 
@@ -1330,7 +1331,7 @@ void iscsi_session_teardown(struct iscsi
 
 	iscsi_destroy_session(cls_session);
 	scsi_host_put(shost);
-	module_put(cls_session->transport->owner);
+	module_put(owner);
 }
 EXPORT_SYMBOL_GPL(iscsi_session_teardown);
 

--------------070701030201010002060501--
