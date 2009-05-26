From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH -tip][SCSI] scsi: scsi_transport_iscsi.c initialize the
 variable before it get used
Date: Tue, 26 May 2009 16:36:40 -0500
Message-ID: <4A1C60E8.1070004@cs.wisc.edu>
References: <1243351161.31783.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060500030205030504050102"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59148 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758717AbZEZVmd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 May 2009 17:42:33 -0400
In-Reply-To: <1243351161.31783.5.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>

This is a multi-part message in MIME format.
--------------060500030205030504050102
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Jaswinder Singh Rajput wrote:
> I am watching this problem from long time in -tip.
> 
> Subject: [PATCH] scsi: scsi_transport_iscsi.c initialize the variable before it get used
> 
> In some cases, err will be used uninitialized.
> 

As you guys already discussed it will not get used uninitialized.

> Also fixed compilation warning :
> 
>  CC      drivers/scsi/scsi_transport_iscsi.o
> drivers/scsi/scsi_transport_iscsi.c: In function ‘iscsi_add_session’:
> drivers/scsi/scsi_transport_iscsi.c:678: warning: ‘err’ may be used uninitialized in this function
> 

I did the attached patch to silence the compile warning. I goofed and 
forgot to send it before, because I had change my compiler and was not 
seeing the error message. I was planning on sending the attached with 
some other changes for the next feature window. I am going to fix up the 
patch to use UINT_MAX like James mentioned in the thread.

--------------060500030205030504050102
Content-Type: text/x-patch;
 name="0001-iscsi-class-quiet-iscsi_add_session-compilation-war.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-iscsi-class-quiet-iscsi_add_session-compilation-war.pat";
 filename*1="ch"

>From 32ffa5248bf11f4df76ebf3c4a023958a9131f9c Mon Sep 17 00:00:00 2001
From: Mike Christie <michaelc@cs.wisc.edu>
Date: Mon, 18 May 2009 11:54:37 -0500
Subject: [PATCH] iscsi class: quiet iscsi_add_session compilation warning.

If ISCSI_MAX_TARGET was zero then iscsi_add_session could return
success when it had failed. This will currently not happen because
ISCSI_MAX_TARGET is a macro and not a variable. But gcc likes to
complain about it and people keep reporting it. This patch
just initializes err to be -EINVAL so if we ever defined
ISCSI_MAX_TARGET incorrectly we would fail gracefully.
---
 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 0a2ce7b..f508567 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -675,7 +675,7 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 	struct iscsi_cls_host *ihost;
 	unsigned long flags;
 	unsigned int id = target_id;
-	int err;
+	int err = -EINVAL;
 
 	ihost = shost->shost_data;
 	session->sid = atomic_add_return(1, &iscsi_session_nr);
-- 
1.6.0.6


--------------060500030205030504050102--
