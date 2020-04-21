Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9433EC55183
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 14:13:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7461720724
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 14:13:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W7aPJ3I4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgDUONP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 10:13:15 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53687 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726018AbgDUONO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 10:13:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587478393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eCasCSXyuw3cZD5Bgdqi0OZxWkZ8ndQkJgxLYujMGkA=;
        b=W7aPJ3I4CGtgWqaF4740BfCAyF3v8UlREvKOCh/RTjEpT9qnBS30afyWdIsV4jZU5DDJ37
        xc1ZF9U99yI8PIPEqZ9Jh2/jV/SMpD+eCqrOrG5+nL3OT4lW6RQ8wNxEhUzLwj0RLuHHPK
        DTVBe0VblNtP4GSRdmO1MuMSPezE00U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-Qefmna4FPgWhB5T2c_9g4g-1; Tue, 21 Apr 2020 10:13:11 -0400
X-MC-Unique: Qefmna4FPgWhB5T2c_9g4g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7937A8017FD;
        Tue, 21 Apr 2020 14:13:10 +0000 (UTC)
Received: from ovpn-114-228.phx2.redhat.com (ovpn-114-228.phx2.redhat.com [10.3.114.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28D085C1B2;
        Tue, 21 Apr 2020 14:13:10 +0000 (UTC)
Message-ID: <4939f52dd4b2335da7878034436584d0045e32df.camel@redhat.com>
Subject: Re: [PATCH] scsi: core: Allow the state change from SDEV_QUIESCE to
 SDEV_BLOCK
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     decui@microsoft.com, linux-scsi@vger.kernel.org
Date:   Tue, 21 Apr 2020 10:13:09 -0400
In-Reply-To: <1587170445-50013-1-git-send-email-decui@microsoft.com>
References: <1587170445-50013-1-git-send-email-decui@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-04-17 at 17:40 -0700, Dexuan Cui wrote:
> The APIs scsi_host_block()/scsi_host_unblock() are recently added by:
> 2bb955840c1d ("scsi: core: add scsi_host_(block,unblock) helper
> function")
> and so far the APIs are only used by:
> 3d3ca53b1639 ("scsi: aacraid: use scsi_host_(block,unblock) to block
> I/O")
> 
> However, from reading the code, I think the APIs don't really work
> for
> aacraid, because, in the resume path of hibernation, when
> aac_suspend() ->
> scsi_host_block() is called, scsi_device_quiesce() has set the state
> to
> SDEV_QUIESCE, so aac_suspend() -> scsi_host_block() returns -EINVAL.
> 
> Fix the issue by allowing the state change.
> 
> Fixes: 2bb955840c1d ("scsi: core: add scsi_host_(block,unblock)
> helper function")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  drivers/scsi/scsi_lib.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 47835c4b4ee0..06c260f6cdae 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2284,6 +2284,7 @@ scsi_device_set_state(struct scsi_device *sdev,
> enum scsi_device_state state)
>  		switch (oldstate) {
>  		case SDEV_RUNNING:
>  		case SDEV_CREATED_BLOCK:
> +		case SDEV_QUIESCE:
>  		case SDEV_OFFLINE:
>  			break;
>  		default:

I think this should be OK.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


