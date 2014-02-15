From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 0/2] target: Simplify lu_gp handling code
Date: Fri, 14 Feb 2014 16:11:15 -0800
Message-ID: <1392423077-15760-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbaBOALS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Feb 2014 19:11:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

This set changes the behavior added here:

https://lkml.org/lkml/2009/2/12/22

We can simplify code paths dealing with lu_gp if we just have to handle
(default_lu_gp vs explicit lu_gp), instead of (default_lu_gp vs
explicit lu_gp vs NULL). The only consequence would be that showing
logical unit group identifier (target_core_spc.c:358) in vpd83 info
couldn't be disabled, and there didn't seem to be a reason I could come
up with for why anyone would ever want to disable it - if you don't
care, just don't look at it.

Andy Grover (2):
  target: Ensure lu_gp_mem->lu_gp is never NULL
  target: Simplify target_core_store_alua_lu_gp

 drivers/target/target_core_alua.c     |  6 ++---
 drivers/target/target_core_configfs.c | 47 +++++++++++------------------------
 2 files changed, 16 insertions(+), 37 deletions(-)

-- 
1.8.5.3

