Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C485C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Dec 2021 10:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbhLIK3e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Dec 2021 05:29:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35323 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234244AbhLIK3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2021 05:29:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639045560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=djo5w39hzvmsmLTRlcNNGUsrakIPn6Rzj+cyvME5wxQ=;
        b=P/MTkzD9cooEjmPzgYNfnKvxpo1hQ24R8rGsavXD4rP2LoUxaveajy5DuYXx8Y0eZ6oHmp
        APmr/vZRJJNLB+Sj3d9aRhq/OrRoNjacqwbi3Hs9HVnEdcGACokibhs0RyqJGfPzGAPFds
        +x1AXMOo+zhtv2kGr6J17yQo2Q66Yhg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-DgU0XWMIPKC_k8rDHwLr2w-1; Thu, 09 Dec 2021 05:25:59 -0500
X-MC-Unique: DgU0XWMIPKC_k8rDHwLr2w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0099101AFC1;
        Thu,  9 Dec 2021 10:25:57 +0000 (UTC)
Received: from raketa (unknown [10.40.192.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 81E9619729;
        Thu,  9 Dec 2021 10:25:56 +0000 (UTC)
Date:   Thu, 9 Dec 2021 11:25:53 +0100
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, bostroesser@gmail.com,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        k.shelekhin@yadro.com
Subject: Re: [PATCH V2] target: iscsi: simplify the connection closing
 mechanism
Message-ID: <20211209102553.GB127963@raketa>
References: <20211111133752.159379-1-mlombard@redhat.com>
 <49f99a54-88a6-7d46-4169-c37e1f00b2ae@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49f99a54-88a6-7d46-4169-c37e1f00b2ae@oracle.com>
User-Agent: Mutt/1.14.7 (f34d0909) (2020-08-29)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 07, 2021 at 01:59:08PM -0600, Mike Christie wrote:
> On 11/11/21 7:37 AM, Maurizio Lombardi wrote:
> > When the connection reinstatement is performed, the target driver
> > executes a complex scheme of complete()/wait_for_completion() that is not
> > really needed.
> > 
> > Considering that:
> > 
> > 1) The callers of iscsit_connection_reinstatement_rcfr() and
> >    iscsit_cause_connection_reinstatement() hold a reference
> >    to the conn structure.> > 2) iscsit_close_connection() will sleep when calling
> >    iscsit_check_conn_usage_count() until the conn structure's refcount
> >    reaches zero.
> > 
> > we can optimize the driver the following way:
> > 
> > * The threads that must sleep until the connection is closed
> >   will all wait for the "conn_wait_comp" completion,
> >   iscsit_close_connection() will then call complete_all() to wake them up.
> >   No need to have multiple completion structures.
> > 
> > * The conn_post_wait_comp completion is not necessary and can be removed
> >   because iscsit_close_connection() sleeps until all the other threads
> >   release the conn structure.
> >   (see the iscsit_check_conn_usage_count() function)
> > 
> > V2: do not set connection_reinstatement to 1 in iscsit_close_connection(),
> >     leave iscsit_cause_connection_reinstatement() deal with reentrancy.
> > 
> 
> What was the issue with setting it to 1?
>

At first I thought that setting it to 1 could introduce a race condition,
then I realized that it's not the case, setting it to 1 simply has no effect
and therefore the assignment can be removed.

Maurizio

