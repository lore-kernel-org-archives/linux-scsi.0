Return-Path: <SRS0=J5Rw=3S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39FAFC33CB2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jan 2020 09:55:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BBDF20720
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jan 2020 09:55:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e83f3GFI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgA2Jz2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jan 2020 04:55:28 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48086 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726091AbgA2Jz1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jan 2020 04:55:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580291726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=//b8tVDnnd8rv4rIFalh7eN8NQIfxCydpO1mcGze3C4=;
        b=e83f3GFIcNCINiPmPkw1JMt2D2iMG+tqlcCFsSHvfXRwD2XMyN8lad25vVzsMWmVqjDFBX
        t00IEUeo8NhCDMjDuJPmWl6DMjumLh8/xK2fmHbzh2hwQUEtQy6sf9jXl0gf3SvgL/k9U/
        gg0J/hqE/9nD76F6KXtDCp46OB3+9vc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-f1tzj-sxNWKURdsi6oBqRQ-1; Wed, 29 Jan 2020 04:55:24 -0500
X-MC-Unique: f1tzj-sxNWKURdsi6oBqRQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E22B0801E76;
        Wed, 29 Jan 2020 09:55:22 +0000 (UTC)
Received: from localhost.localdomain (ovpn-204-198.brq.redhat.com [10.40.204.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74747104C52A;
        Wed, 29 Jan 2020 09:55:20 +0000 (UTC)
Subject: Re: [PATCH RESEND] iscsi: Add support for asynchronous iSCSI session
 destruction
To:     Gabriel Krisman Bertazi <krisman@collabora.com>, lduncan@suse.com
Cc:     martin.petersen@oracle.com, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, padovan@collabora.com,
        Frank Mayhar <fmayhar@google.com>, kernel@collabora.com,
        Khazhismel Kumykov <khazhy@google.com>
References: <20200127032450.924711-1-krisman@collabora.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Message-ID: <6a879f56-a86f-b26d-aa0d-e166e42bb549@redhat.com>
Date:   Wed, 29 Jan 2020 10:55:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20200127032450.924711-1-krisman@collabora.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

Dne 27.1.2020 v 04:24 Gabriel Krisman Bertazi napsal(a):
> From: Frank Mayhar <fmayhar@google.com>
> 
> iSCSI session destruction can be arbitrarily slow, since it might
> require network operations and serialization inside the scsi layer.
> This patch adds a new user event to trigger the destruction work
> asynchronously, releasing the rx_queue_mutex as soon as the operation is
> queued and before it is performed.  This change allow other operations
> to run in other sessions in the meantime, removing one of the major
> iSCSI bottlenecks for us.
> 
> To prevent the session from being used after the destruction request, we
> remove it immediately from the sesslist. This simplifies the locking
> required during the asynchronous removal.
> 
> Co-developed-by: Khazhismel Kumykov <khazhy@google.com>
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> Signed-off-by: Frank Mayhar <fmayhar@google.com>
> Co-developed-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>

[...]

> +	iscsi_destroy_workq = create_singlethread_workqueue("iscsi_destroy");
> +	if (!iscsi_destroy_workq)
> +		goto destroy_wq;
> +
>  	return 0;

I think you should set err to -ENOMEM before the goto instruction.


Maurizio Lombardi

