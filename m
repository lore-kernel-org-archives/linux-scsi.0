Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB1A5C433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 13:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 602FC64DD6
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 13:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhA1NmI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 08:42:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41629 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231948AbhA1NmG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Jan 2021 08:42:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611841239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xeXt/3GD1lqhnzmzfzzeknEhxPUiBt6dMOrPZLESt+0=;
        b=gk2BexUwdYDE6RDY6oQYEHi+gdyOzZ5YjpF7NY/09DS5J3k6ZL2X+8Vvburnft3leL5lTy
        kXlpohX22a8QRXZCVR4LaiKilo5l7SY+TavBlKjInwuybZYlvxnyqnwG5BFQJTg4PP82Q/
        3UEMTtqn31VkqoXFkBALA8EzzVqZSyQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29--goOE2lmOu-0ptGBjxMhbA-1; Thu, 28 Jan 2021 08:40:35 -0500
X-MC-Unique: -goOE2lmOu-0ptGBjxMhbA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10A2A9CC01;
        Thu, 28 Jan 2021 13:40:34 +0000 (UTC)
Received: from ovpn-113-224.phx2.redhat.com (ovpn-113-224.phx2.redhat.com [10.3.113.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CF3160C13;
        Thu, 28 Jan 2021 13:40:33 +0000 (UTC)
Message-ID: <0650909876af42f1b7e8f2ec16445e4cb4f8d4d4.camel@redhat.com>
Subject: Re: [PATCH] scsi: do not retry FAILFAST commands on
 DID_TRANSPORT_DISRUPTED
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Hannes Reinecke <hare@suse.de>, michael.christie@oracle.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>,
        Hannes Reinecke <hare@suse.com>
Date:   Thu, 28 Jan 2021 08:40:32 -0500
In-Reply-To: <fa31a242-bed7-6466-2ac5-e69a5d71b8ef@suse.de>
References: <20210126130212.47998-1-hare@suse.de>
         <e5c71e73-f36b-8ff8-ef4e-d424304431a6@oracle.com>
         <fa31a242-bed7-6466-2ac5-e69a5d71b8ef@suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-01-28 at 07:57 +0100, Hannes Reinecke wrote:
> On 1/28/21 1:51 AM, michael.christie@oracle.com wrote:
> > On 1/26/21 7:02 AM, Hannes Reinecke wrote:
> > > When a command is return with DID_TRANSPORT_DISRUPTED we should
> > > be looking at the REQ_FAILFAST_TRANSPORT flag and do not retry
> > > the command if set.
> > > Otherwise multipath will be requeuing a command on the failed
> > > path and not fail it over to one of the working paths.
> > > 
> > > Cc: Martin Wilck <martin.wilck@suse.com>
> > > Signed-off-by: Hannes Reinecke <hare@suse.com>
> > > ---
> > >   drivers/scsi/scsi_error.c | 1 +
> > >   1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/drivers/scsi/scsi_error.c
> > > b/drivers/scsi/scsi_error.c
> > > index a52665eaf288..005118385b70 100644
> > > --- a/drivers/scsi/scsi_error.c
> > > +++ b/drivers/scsi/scsi_error.c
> > > @@ -1753,6 +1753,7 @@ int scsi_noretry_cmd(struct scsi_cmnd
> > > *scmd)
> > >       case DID_TIME_OUT:
> > >           goto check_type;
> > >       case DID_BUS_BUSY:
> > > +    case DID_TRANSPORT_DISRUPTED:
> > >           return (scmd->request->cmd_flags &
> > > REQ_FAILFAST_TRANSPORT);
> > >       case DID_PARITY:
> > >           return (scmd->request->cmd_flags & REQ_FAILFAST_DEV);
> > 
> > We don't fast fail for that error code to avoid churn for
> > transient 
> > transport problems. The FC and iscsi drivers block the
> > rport/session, 
> > return that code and then it's up the fast_io_fail/replacement
> > timeout.
> > 
> 
> _But_ if prevents that command to be failed over to another path, so 
> essentially we're blocking execution until fast_io_fail tmo.
> 
> For no good reason as we have other paths available.

And if we don't?  Not everybody sets queue_if_no_path, right?

-Ewan
 
> 
> Cheers,
> 
> Hannes

