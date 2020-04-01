Return-Path: <SRS0=ctNG=5R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457DCC43331
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 03:55:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1028020776
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 03:55:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FMDF55aX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731630AbgDADzP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Mar 2020 23:55:15 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34576 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731589AbgDADzP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Mar 2020 23:55:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585713314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=GxAhQCqWWIsxaoEl0O4KG8frOqua5c6sKdRCg2gvyAE=;
        b=FMDF55aXimTqcJ3xwse0TFNj/4b42yBUkPHndb4vAtw6amVTV2b76vZDkyruGPkq5warYa
        QfQBCW7yj0m/5Hhu4bM7hhcv32BCTK8S0WN261o/QsSEKUyxUybhbPxTRzPLIgC/shQ+Ud
        sK1qRUNC14198Kflbfw22QLXI5EnuYA=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-EA4jF5KOO3a8Xo0jnp1-4w-1; Tue, 31 Mar 2020 23:55:12 -0400
X-MC-Unique: EA4jF5KOO3a8Xo0jnp1-4w-1
Received: by mail-vs1-f72.google.com with SMTP id w2so5060485vsf.7
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2020 20:55:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=GxAhQCqWWIsxaoEl0O4KG8frOqua5c6sKdRCg2gvyAE=;
        b=EDoVNBofDsJiud6gtm7r9MmprJanSHmDkDLVBFq+mZXqWUmqj1ckDHnVJM1T21Qxih
         sC+APEK2P8Krl6Ddta0dP242PdoOdhcd7ggiFDT0K5IyTCaK+579720ypyhytRsa2mGg
         U9+R/D/bh7KqY6vYJh9h5KmBmVHe3rdthLHXARMIjTIKQ5MImsgVUuR5j3F38JwyWgsY
         xEMND567geJvpF8xehQliXZ0Z3kj6DFBmbws/wqy7ALPBQNYxkq7fTgmeaCSFkhWZ1bh
         pZULGrcNeY1mrwNCOOo9jT0/NCKQe50FgmnB1Z2RsybWEd8vP+gCAa7B1Go5xSxa1+1a
         xLMg==
X-Gm-Message-State: AGi0PubFPOukwNbD1BjCXCurcLEnpGnDheKODjuZAnNHmIWydcs/Khn2
        cx79tDNjWk4jVubk7CAzQS5ag/CdHcOhKYyNlUbgUDrRswp1UKi82G5eMO8XDREz9oIC7o03CUl
        DYIv7hEJbF1HpNnoCkkPdY3BXGDLfZ/qOhnnBTw==
X-Received: by 2002:a1f:32cf:: with SMTP id y198mr14321047vky.96.1585713312263;
        Tue, 31 Mar 2020 20:55:12 -0700 (PDT)
X-Google-Smtp-Source: APiQypKpix2r6FQ6laqoyCqm/gmzLL+3B/jHz8qXknI2TYoO8OyFOEf9NIJoW3ZgapG9MgblCNBhO1dn+IbqdhIUOCk=
X-Received: by 2002:a1f:32cf:: with SMTP id y198mr14321033vky.96.1585713311901;
 Tue, 31 Mar 2020 20:55:11 -0700 (PDT)
MIME-Version: 1.0
From:   Nikhil Kshirsagar <nkshirsa@redhat.com>
Date:   Wed, 1 Apr 2020 09:25:00 +0530
Message-ID: <CAMNNMLFtQOHsjWUMs+q_+z9XqQYZmR34ewoB-5LrCpzGp1Ppkw@mail.gmail.com>
Subject: [PATCH] scsi: core: Add DID_ALLOC_FAILURE and DID_MEDIUM_ERROR to hostbyte_table
To:     martin.petersen@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since DID_ALLOC_FAILURE and DID_MEDIUM_ERROR are missing from the
hostbyte_table, scsi debug logging prints their numeric values only.
Adding them to the hostbyte_table to allow the scsi debug log to print
those as strings.

Signed-off-by: Nikhil Kshirsagar <nkshirsa@redhat.com>
---
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index d4c2a2e4c5d4..84d73f57292b 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -404,7 +404,7 @@ static const char * const hostbyte_table[]={
 "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
 "DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY", "DID_REQUEUE",
 "DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST", "DID_TARGET_FAILURE",
-"DID_NEXUS_FAILURE" };
+"DID_NEXUS_FAILURE", "DID_ALLOC_FAILURE", "DID_MEDIUM_ERROR" };

 static const char * const driverbyte_table[]={
 "DRIVER_OK", "DRIVER_BUSY", "DRIVER_SOFT",  "DRIVER_MEDIA", "DRIVER_ERROR",

