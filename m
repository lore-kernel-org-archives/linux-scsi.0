Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11602C4727C
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 15:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C587B20878
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 15:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601046839;
	bh=8haPYMN6i4R8L0rBRDB+RFTRiwwmhl0O2ZTgf2GjGgs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:List-ID:From;
	b=q4NR89Ugni6Z87MNCvIZWA4F47Du+4Jy+ka7JuMXvEbt/iNxhExUubtg+Y95CYfxX
	 G4RPk2p0o4xH/AKG463yawqdeDNMo18OLuhTG1E6vSYeNi2sAAoOk60zl7X61ASYge
	 mCs1mDYNyK8XzcwcIe7NDGsAjBTn/K0hstMsrwDI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbgIYPN4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 11:13:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728858AbgIYPNz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Sep 2020 11:13:55 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AACF0208B6;
        Fri, 25 Sep 2020 15:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601046835;
        bh=8haPYMN6i4R8L0rBRDB+RFTRiwwmhl0O2ZTgf2GjGgs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PYP9Lvc+6VpK6zDfYTXAvOODiQyNe45LDl14372p88r2vjqI0Q0pVVj/uOIhNLXRe
         MOObG21yv2R16u9QGAyn4b7MMY1qecLWzvLxq+120CigHpgpMO4nijXRMB7Y0yoTFo
         Ras3xD5JtcMdTtzOri8qm/zU75p/qRv0mJJwUPAk=
Message-ID: <955efe40d1df7ba78cd0e0f27ba13ae7650ea927.camel@kernel.org>
Subject: Re: [PATCH v8 7/7] libceph: use sendpage_ok() in ceph_tcp_sendpage()
From:   Jeff Layton <jlayton@kernel.org>
To:     Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        ceph-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 25 Sep 2020 11:13:53 -0400
In-Reply-To: <20200925150119.112016-8-colyli@suse.de>
References: <20200925150119.112016-1-colyli@suse.de>
         <20200925150119.112016-8-colyli@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-09-25 at 23:01 +0800, Coly Li wrote:
> In libceph, ceph_tcp_sendpage() does the following checks before handle
> the page by network layer's zero copy sendpage method,
> 	if (page_count(page) >= 1 && !PageSlab(page))
> 
> This check is exactly what sendpage_ok() does. This patch replace the
> open coded checks by sendpage_ok() as a code cleanup.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Ilya Dryomov <idryomov@gmail.com>
> Cc: Jeff Layton <jlayton@kernel.org>
> ---
>  net/ceph/messenger.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index bdfd66ba3843..d4d7a0e52491 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -575,7 +575,7 @@ static int ceph_tcp_sendpage(struct socket *sock, struct page *page,
>  	 * coalescing neighboring slab objects into a single frag which
>  	 * triggers one of hardened usercopy checks.
>  	 */
> -	if (page_count(page) >= 1 && !PageSlab(page))
> +	if (sendpage_ok(page))
>  		sendpage = sock->ops->sendpage;
>  	else
>  		sendpage = sock_no_sendpage;

Looks like a reasonable change to make. Assuming that there is no
objection to the new helper:

Acked-by: Jeff Layton <jlayton@kernel.org>

