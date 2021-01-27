Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 755D6C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 23:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B3B764DD0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 23:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbhA0XCl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 18:02:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57412 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233487AbhA0XA1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Jan 2021 18:00:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611788341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=vBHFNuNd0sGZfvZTnew2a8X7tuzzNGLciFYmtwH/6J4=;
        b=Fq9azxCery2z4Grul9Nn5neZFeqG2xow8JQZPa98pu9rcv5UNtHd/dxSSTMNHe864o4ada
        tdX6qK7gRp1ecRzDJyKSI6Lognkc3LpcjujrmMg99psVLW/XAfQh1Ez+TicklJn0/w5zVB
        g/xjLMFaTWwsTCaSkpiu6PdpCx4hpGU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-qVCjZU2-MbiTZ32aYvi-Hg-1; Wed, 27 Jan 2021 17:38:52 -0500
X-MC-Unique: qVCjZU2-MbiTZ32aYvi-Hg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A21BB190A7A0;
        Wed, 27 Jan 2021 22:38:50 +0000 (UTC)
Received: from T590 (ovpn-12-152.pek2.redhat.com [10.72.12.152])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C02CF19726;
        Wed, 27 Jan 2021 22:38:44 +0000 (UTC)
Date:   Thu, 28 Jan 2021 06:38:40 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [MPT3SAS bug] wrong queue setting for HDD. drive
Message-ID: <20210127223840.GB1350451@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Guys,

The commit[1] is supposed for NVMe device only, but we found the change is
actually done on the following mpt3sas HDD. drive:

	#sginfo /dev/sdc
	INQUIRY response (cmd: 0x12)
	----------------------------
	Device Type                        0
	Vendor:                    SEAGATE
	Product:                   ST16000NM002G
	Revision level:            E003)

So NOMERGES is enabled, and virt boundary limit is applied on this HDD.
device, and performance drop is observed, can you take a look at the
issue?


[1] commit d1b01d14b7baa8a4bb4c11305c8cca73456b2f7c
Author: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Date:   Tue Oct 31 18:02:33 2017 +0530

    scsi: mpt3sas: Set NVMe device queue depth as 128

    Sets nvme device queue depth, name and displays device capabilities



Thanks,
Ming

