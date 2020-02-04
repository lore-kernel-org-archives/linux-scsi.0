Return-Path: <SRS0=WdRn=3Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55272C35247
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 21:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 250992166E
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 21:54:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UdbqxJiF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbgBDVyW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Feb 2020 16:54:22 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53699 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727445AbgBDVyW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Feb 2020 16:54:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580853261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5CGuK6de7SvfrPQGZi9TzjbDs8J5q4lJn/GNUR3tnhw=;
        b=UdbqxJiFYoeehZPguIyUkk3gVNh1mhxawJqjEKR/OY/jIYBuupPG2ZIgPQwXvpe0SK8N1t
        g0njC4NVMJ3nFydP5Pf5LKoDtZB09XRE/QDX5KxEc04M0yBk+FRwQNX7lVPLA4jUvy8OKg
        qGY6I5t2ew0lz05bF3TafebRE7GbcR0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-PT4awvMhML6b4fmrJ0uJsA-1; Tue, 04 Feb 2020 16:54:05 -0500
X-MC-Unique: PT4awvMhML6b4fmrJ0uJsA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA4578010FA;
        Tue,  4 Feb 2020 21:54:03 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B80325DA84;
        Tue,  4 Feb 2020 21:54:02 +0000 (UTC)
Message-ID: <688f38379efc25fb8adde2d5834b150e8db89c38.camel@redhat.com>
Subject: Re: [PATCH] scsi: return correct status in
 scsi_host_eh_past_deadline()
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Date:   Tue, 04 Feb 2020 16:54:02 -0500
In-Reply-To: <20200204102316.39000-1-hare@suse.de>
References: <20200204102316.39000-1-hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-02-04 at 11:23 +0100, Hannes Reinecke wrote:
> If the user changed the 'eh_deadline' setting to 'off' while evaluating
> the time_before() call we will return 'true', which is inconsistent
> with the first conditional, where we return 'false' if 'eh_deadline'
> is set to 'off'.
> 
> Reported-by: Martin Wilck <martin.wilck@suse.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_error.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index ae2fa170f6ad..ae29a9b4af56 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -113,7 +113,7 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
>  	    shost->eh_deadline > -1)
>  		return 0;
>  
> -	return 1;
> +	return shost->eh_deadline == -1 ? 0 : 1;
>  }
>  
>  /**

Hmm.  4 accesses to shost->eh_deadline in the function?
Why don't we just copy it to a local variable and use that.

-Ewan




