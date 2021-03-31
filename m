Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C528C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 18:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3DA561029
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 18:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbhCaSRZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 14:17:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20725 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234932AbhCaSRE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Mar 2021 14:17:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617214624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=lIZzc8ZQurVPn2Ph3lR/wsP8/a7vK3JqsZ63HSYRdwc=;
        b=cTYx8Papv//cXOe0W+Xp2fe2aFNo4yGdCuAVCOAprRDEJrrcfr23oju36dOa7lqA1E44VE
        BjFXZld7enoUyrZ6qulxFE9Ec+iwA3xYrfBf+gqtyKI4z1ezcZuscWjzvS2Dx/T+EY/kZm
        PID8JJp15mH8H/ddUKh66rlZZjlJYq0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-anBMTqUKNtSX7i3kzZ7YDw-1; Wed, 31 Mar 2021 14:17:02 -0400
X-MC-Unique: anBMTqUKNtSX7i3kzZ7YDw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10269801814;
        Wed, 31 Mar 2021 18:17:01 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-141.rdu2.redhat.com [10.10.116.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DAEE65D720;
        Wed, 31 Mar 2021 18:16:59 +0000 (UTC)
From:   John Pittman <jpittman@redhat.com>
To:     martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, hare@suse.de, emilne@redhat.com,
        loberman@redhat.com, djeffery@redhat.com,
        linux-scsi@vger.kernel.org, John Pittman <jpittman@redhat.com>
Subject: [PATCH] scsi: scsi_dh_alua: prevent duplicate pg info print in alua_rtpg()
Date:   Wed, 31 Mar 2021 14:16:56 -0400
Message-Id: <20210331181656.5046-1-jpittman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Due to the frequency that alua_rtpg() is called, the path group
info print within can print the same info multiple times in the
logs, subsequent prints adding no new information or value.

To reproduce:

    # modprobe scsi_debug vpd_use_hostno=0
    # systemctl start multipathd.service

To fix, check stored values, only printing at alua attach/activate
and if any of the values change.

Signed-off-by: John Pittman <jpittman@redhat.com>
Reviewed-by: David Jeffery <djeffery@redhat.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 30 ++++++++++++++--------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index ea436a14087f..7438ed491681 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -515,6 +515,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	struct scsi_sense_hdr sense_hdr;
 	struct alua_port_group *tmp_pg;
 	int len, k, off, bufflen = ALUA_RTPG_SIZE;
+	int group_id_old, state_old, pref_old, valid_states_old;
 	unsigned char *desc, *buff;
 	unsigned err, retval;
 	unsigned int tpg_desc_tbl_off;
@@ -522,6 +523,11 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	unsigned long flags;
 	bool transitioning_sense = false;
 
+	group_id_old = pg->group_id;
+	state_old = pg->state;
+	pref_old = pg->pref;
+	valid_states_old = pg->valid_states;
+
 	if (!pg->expiry) {
 		unsigned long transition_tmo = ALUA_FAILOVER_TIMEOUT * HZ;
 
@@ -686,17 +692,19 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	if (transitioning_sense)
 		pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
 
-	sdev_printk(KERN_INFO, sdev,
-		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
-		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
-		    pg->pref ? "preferred" : "non-preferred",
-		    pg->valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
-		    pg->valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
-		    pg->valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
-		    pg->valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
-		    pg->valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
-		    pg->valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
-		    pg->valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
+	if (group_id_old != pg->group_id || state_old != pg->state ||
+		pref_old != pg->pref || valid_states_old != pg->valid_states)
+		sdev_printk(KERN_INFO, sdev,
+			"%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
+			ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
+			pg->pref ? "preferred" : "non-preferred",
+			pg->valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
+			pg->valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
+			pg->valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
+			pg->valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
+			pg->valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
+			pg->valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
+			pg->valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
 
 	switch (pg->state) {
 	case SCSI_ACCESS_STATE_TRANSITIONING:
-- 
2.17.2

