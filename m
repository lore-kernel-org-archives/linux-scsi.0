From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH scsi-misc-2.6 00/03] scsi: misc timer fixes (again)
Date: Sat, 14 May 2005 09:46:03 +0900 (KST)
Message-ID: <20050514004601.783910E3@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.203]:37542 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262640AbVENAqI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2005 20:46:08 -0400
Received: by rproxy.gmail.com with SMTP id i8so283404rne
        for <linux-scsi@vger.kernel.org>; Fri, 13 May 2005 17:46:08 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

 Hello, James.

 It's been a while, but I'm finally settled with git. :-)

 This is repost of the previous scsi timer patchset.  After thinking
about it a while, the first patch seemed unnecessary as you told, so
it's dropped and the others are regenerated.

 aic79xx_osm.c DV still uses eh_timeout.  Is it gonna be updated like
aic7xxx_osm.c is updated?  If not, I have a patch to fix the eh timer
part.  I have a patcheset waiting for it to be clared - unexporting
SCSI timer as the semantics is very specific and nothing good can come
from tempering with it.  Once aic79xx_osm.c is cleared, I'll post the
patches.

[ Start of patch descriptions ]

01_scsi_timer_dispatch_race_fix.patch
	: remove a timer race in scsi_queue_insert()

	scsi_queue_insert() has four callers.  Three callers call with
	timer disabled and one (the second invocation in
	scsi_dispatch_cmd()) calls with timer activated.
	scsi_queue_insert() used to always call scsi_delete_timer()
	and ignore the return value.  This results in race with timer
	expiration.  Remove scsi_delete_timer() call from
	scsi_queue_insert() and make the caller delete timer and check
	the return value.

02_scsi_timer_remove_delete_timer_from_reset_provider.patch
	: remove unnecessary scsi_delete_timer() call in scsi_reset_provider()

	scsi_reset_provider() calls scsi_delete_timer() on exit which
	isn't necessary.  Remove it.

03_scsi_timer_eh_timer_remove_spurious_if.patch
	: remove spurious if tests from scsi_eh_{times_out|done}

	'if' tests which check if eh_action isn't NULL in both
	functions are always true.  Remove the redundant if's as it
	can give wrong impressions.

[ End of patch descriptions ]

 Thanks.

