From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: [PATCH] mptsas: fixed hot-removal processing
Date: Wed, 07 Apr 2010 19:17:24 +0900
Message-ID: <4BBC5BB4.2050805@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49380 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388Ab0DGKSH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Apr 2010 06:18:07 -0400
Received: from m6.gw.fujitsu.co.jp ([10.0.50.76])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o37AI4JR029993
	for <linux-scsi@vger.kernel.org> (envelope-from tokunaga.keiich@jp.fujitsu.com);
	Wed, 7 Apr 2010 19:18:04 +0900
Received: from smail (m6 [127.0.0.1])
	by outgoing.m6.gw.fujitsu.co.jp (Postfix) with ESMTP id EDF1645DE50
	for <linux-scsi@vger.kernel.org>; Wed,  7 Apr 2010 19:18:03 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (s6.gw.fujitsu.co.jp [10.0.50.96])
	by m6.gw.fujitsu.co.jp (Postfix) with ESMTP id D01D945DE4F
	for <linux-scsi@vger.kernel.org>; Wed,  7 Apr 2010 19:18:03 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id B7AB71DB8014
	for <linux-scsi@vger.kernel.org>; Wed,  7 Apr 2010 19:18:03 +0900 (JST)
Received: from m024.s.css.fujitsu.com (m024.s.css.fujitsu.com [10.0.81.64])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 754941DB8013
	for <linux-scsi@vger.kernel.org>; Wed,  7 Apr 2010 19:18:03 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Desai Kashyap <kashyap.desai@lsi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>

Hi Kashyap,

This patch fixes mptsas disk hot-removal processing.  The
hot-removal processing doesn't complete because of this condition.

  drivers/message/fusion/mptsas.c:
  mptsas_taskmgmt_complete()

  if ((mptsas_find_vtarget(ioc, channel, id)) && !ioc->fw_events_off)
    mptsas_queue_device_delete(...);

mptsas_queue_device_delete(), which must be called for
hot-removal, never gets called because mptsas_find_vtarget()
always returns 0 here.  At that time, the vtarget has already
been freed in mptsas_target_destroy(), and also the scsi_device
has been marked as SDEV_DEL.

As a result of the issue, port deletion functions won't get
called and the device ends up being in an incomplete state.
(Some data structures and sysfs entries, which should be
removed in hot-removal, remain.)  One side effect of this is
that a hot-addition of the device (bringing the device back
on) fails.

This patch just removes mptsas_find_vtarget() from the if-state
condition.

This applies to 2.6.34-rc3.

Thanks,
Kei


Signed-off-by: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
---

 linux-2.6.34-rc3-kei/drivers/message/fusion/mptsas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/message/fusion/mptsas.c~fix-mptsas_hot_removal drivers/message/fusion/mptsas.c
--- linux-2.6.34-rc3/drivers/message/fusion/mptsas.c~fix-mptsas_hot_removal	2010-04-07 16:47:36.000000000 +0900
+++ linux-2.6.34-rc3-kei/drivers/message/fusion/mptsas.c	2010-04-07 16:48:17.000000000 +0900
@@ -1221,7 +1221,7 @@ mptsas_taskmgmt_complete(MPT_ADAPTER *io
 	 * enable work queue to remove device from upper layers
 	 */
 	list_del(&target_reset_list->list);
-	if ((mptsas_find_vtarget(ioc, channel, id)) && !ioc->fw_events_off)
+	if (!ioc->fw_events_off)
 		mptsas_queue_device_delete(ioc,
 			&target_reset_list->sas_event_data);
 

_



