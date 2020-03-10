Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FCCDC10F27
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CECC822525
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:44:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YdDIZOmY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgCJQoz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:44:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21356 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726437AbgCJQoz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 12:44:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583858694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a7Hz0EXsjWMtukQM1WcjhozadgcoPb+GAh9MInaoNV0=;
        b=YdDIZOmYiat2J/HVJgtRIEbK1kdSDKSvx496xz2+XfKtsMR9M+y/8Psj3v1IegfQPpKh6P
        BByoBEtwm4y8C1mAUhlZEPSBEm+7FSKFf/QAc1H37RN3fctBPvTQmQwhptIyg4hY+3FoKY
        olVJbbGcDBUkv+d7NlW2LV+KaJy8Fw4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-YrsiMVDCOx-vrwnGNZKrHw-1; Tue, 10 Mar 2020 12:44:52 -0400
X-MC-Unique: YrsiMVDCOx-vrwnGNZKrHw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 600A5107ACC7;
        Tue, 10 Mar 2020 16:44:51 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11C1E19C6A;
        Tue, 10 Mar 2020 16:44:50 +0000 (UTC)
Message-ID: <e13d0e51e83fd2fc5d653633a9cfb74e2b24b5a6.camel@redhat.com>
Subject: Re: [PATCH] scsi: avoid repetitive logging of device offline
 messages
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Date:   Tue, 10 Mar 2020 12:44:50 -0400
In-Reply-To: <ccbaa97a-c946-f235-c7c3-3d9d6bf319c0@acm.org>
References: <20200309181416.10665-1-emilne@redhat.com>
         <b7f3c0d1-0f08-83e2-6df5-8b6a02201ba6@acm.org>
         <c9ebe5ecaff898c848402413d9404b23dfe999e6.camel@redhat.com>
         <ccbaa97a-c946-f235-c7c3-3d9d6bf319c0@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-03-09 at 19:02 -0700, Bart Van Assche wrote:
> On 2020-03-09 13:54, Ewan D. Milne wrote:
> > The only purpose of the flag is to try to suppress duplicate messages,
> > in the common case it is a single thread submitting the queued I/O which
> > is going to get rejected.  If multiple threads submit I/O there might
> > be duplicated messages but that is not all that critical.  Hence the
> > lack of locking on the flag.
> 
> Hi Ewan,
> 
> My concern is that scsi_prep_state_check() may be called from more than
> one thread at the same time and that bitfield changes are not thread-safe.
> 
> Thanks,
> 
> Bart.

Yes, I agree that the flag is not thread-safe, but I don't think that
is a concern.  Because if we get multiple rejecting I/O messages until
the other threads see the flag change we are no worse off than before,
and once the sdev state changes back to SDEV_RUNNING we won't call
scsi_prep_state_check() and examine the flag.

-Ewan

