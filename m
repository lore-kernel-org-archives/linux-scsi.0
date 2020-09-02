Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B15F6C433E7
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 21:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72F2020758
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 21:14:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XgM/WqNJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgIBVOo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 17:14:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42273 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726269AbgIBVOo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 17:14:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599081283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=lu+nIwMrjptr+xdJQ6hcSANg/e8W1qmDwO2Jt3FXkMk=;
        b=XgM/WqNJYGmilkp01XdO2HVoY7dFtNCl3DTI/nTfADwQGMQlnO3K5G1AEVk/PI3vuiaqwy
        UJorifE2f/l/OoAvbLTzbyInbHtKjh1vRop97kpwI6iSKpc65Hkh5bTV9YP4mNwkx+PF1W
        j4GHgXUWUkmUisnNtc8+4gYDv03KkDQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-cdHSsZWWN8O_XKwAJUObdA-1; Wed, 02 Sep 2020 17:14:41 -0400
X-MC-Unique: cdHSsZWWN8O_XKwAJUObdA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5059801AE6;
        Wed,  2 Sep 2020 21:14:39 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-115-53.rdu2.redhat.com [10.10.115.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 447665C22D;
        Wed,  2 Sep 2020 21:14:38 +0000 (UTC)
From:   John Pittman <jpittman@redhat.com>
To:     martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, dgilbert@interlog.com, djeffery@redhat.com,
        loberman@redhat.com, linux-scsi@vger.kernel.org
Subject: [PATCH v2 0/3] scsi_debug: improve num_parts usage
Date:   Wed,  2 Sep 2020 17:14:32 -0400
Message-Id: <20200902211434.9979-1-jpittman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hello,

The 1st patch sets all partitions to the same size when using the
num_parts parameter.

The 2nd patch allows virtual_gb to be respected when it is passed at
the same time as num_parts.

v1 -> v2
1. Fix multiple variable assignments on one line (style issue)

John Pittman (2):
 scsi: scsi_debug: adjust num_parts to create equally sized partitions
 scsi: scsi_debug: sdebug_build_parts() respect virtual_gb

 scsi_debug.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Cc: James Bottomley <jejb@linux.ibm.com>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: David Jeffery <djeffery@redhat.com>
Cc: Laurence Oberman <loberman@redhat.com>

