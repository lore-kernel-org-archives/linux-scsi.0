Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF012C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 07:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A6EF613B0
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 07:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240393AbhDWHoy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 03:44:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60220 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229456AbhDWHoy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Apr 2021 03:44:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619163858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hsPkpS1m6l5NaAFWC732jzt94dSGFqjqMv/H4RefG5A=;
        b=A3Ye50IPx0gIXDgKTZmZbgJ8NBctuBR88nN3sLcmK2J17qmcFN58BL9kyUYEkSYn3c8tzA
        WdvPf/hTC4juiBd71vNVZTiRIb48EQKRkc/oysdkD+7TsLhyhAd9cAJgJ/Sw/8jT5lAHRe
        dh7dr37ynhC8bTzbGhDecSnAsfVaxZY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-1jwu45wLNXGHRAACY_LPWQ-1; Fri, 23 Apr 2021 03:44:15 -0400
X-MC-Unique: 1jwu45wLNXGHRAACY_LPWQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63DF11898296;
        Fri, 23 Apr 2021 07:44:14 +0000 (UTC)
Received: from localhost (ovpn-13-161.pek2.redhat.com [10.72.13.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DC806E703;
        Fri, 23 Apr 2021 07:43:55 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 0/5] scsi: fnic: use scsi_host_busy_iter to walk scsi commands
Date:   Fri, 23 Apr 2021 15:43:43 +0800
Message-Id: <20210423074348.2255671-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Guys,

fnic uses the following way to walk scsi commands in failure handling,
which is obvious wrong, because caller of scsi_host_find_tag has to
guarantee that the tag is active.

        for (tag = 0; tag < fnic->fnic_max_tag_id; tag++) {
				...
                sc = scsi_host_find_tag(fnic->lport->host, tag);
				...
		}

Fix the issue by using scsi_host_busy_iter() to walk request/scsi_command.

Hannes has posted similar patch[1] before, however which depends on the scsi
reserved command patchset, so post them out in one standalone patchset,
another difference is that this one is splited to 5 single patches for
easy review.

[1] https://marc.info/?l=linux-scsi&m=161400059528859&w=2 


V2:
	- use scsi_host_busy_iter

Ming Lei (5):
  scsi: fnic: use scsi_host_busy_iter in fnic_terminate_rport_io
  scsi: fnic: use scsi_host_busy_iter in fnic_clean_pending_aborts
  scsi: fnic: use scsi_host_busy_iter in fnic_cleanup_io
  scsi: fnic: use scsi_host_busy_iter in fnic_rport_exch_reset
  scsi: fnic: use scsi_host_busy_iter in fnic_is_abts_pending

 drivers/scsi/fnic/fnic_scsi.c | 924 ++++++++++++++++++----------------
 1 file changed, 484 insertions(+), 440 deletions(-)

-- 
2.29.2

