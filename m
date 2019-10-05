Return-Path: <SRS0=qHo0=X6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 539F2C47404
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Oct 2019 16:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B8FB222C8
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Oct 2019 16:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570291618;
	bh=T1nHprUQcw7db03Tr0L1cjg240dgz2UCviMisD8YUjw=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:List-ID:
	 From;
	b=MERV0l71xeo+NcZZvwIUE252l30SD77nI4Dg2Gh+eZUOwOCb77j2UgimSZR/CfZ9V
	 Gc9CxHaOOP3s6jyreKhKOd8fProjtlo9HtYf+Ym+p0CA4WKwpHNbk99HzkHgYT9bb2
	 6ca3kWIz2exxTxeDWrdKLTQXOFvJzhFG/3n8LZYw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfJEQGz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Oct 2019 12:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbfJEQGz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 5 Oct 2019 12:06:55 -0400
Received: from paulmck-ThinkPad-P72 (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 839AE222C0;
        Sat,  5 Oct 2019 16:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570291614;
        bh=T1nHprUQcw7db03Tr0L1cjg240dgz2UCviMisD8YUjw=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=IFgvwm+xrX1y8pkbT8yzUzzxbE/USHRjLeyngP1jR71Q2c51v8M8WroTrDKXxYnDq
         oa+LJZ9trhGoGTbPTsrNL3EbnZcxVv/imfMXl5GWfAZCrrN3vBLx/wFYgUzCCUkNiU
         f6D8XBi0UcYYyouK3opx+XrEfbljTQyyDyCU94lM=
Date:   Sat, 5 Oct 2019 09:06:53 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH tip/core/rcu 4/9] drivers/scsi: Replace
 rcu_swap_protected() with rcu_replace()
Message-ID: <20191005160653.GD2689@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20191003014153.GA13156@paulmck-ThinkPad-P72>
 <20191003014310.13262-4-paulmck@kernel.org>
 <yq1zhihqn1g.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1zhihqn1g.fsf@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 03, 2019 at 10:09:31PM -0400, Martin K. Petersen wrote:
> 
> Paul,
> 
> No objections from me.

Thank you, Martin!  I have applied your Acked-by, but please let me
know if that over-interprets your "No objections" above.

> > +	vpd_pg80 = rcu_replace(sdev->vpd_pg80, vpd_pg80,
> > +			       lockdep_is_held(&sdev->inquiry_mutex));
> > +	vpd_pg83 = rcu_replace(sdev->vpd_pg83, vpd_pg83,
> > +			       lockdep_is_held(&sdev->inquiry_mutex));
> 
> Just a heads-up that we have added a couple of additional VPD pages so
> my 5.5 tree will need additional calls to be updated to rcu_replace().

I do not intend to actually remove rcu_swap_protected() until 5.6 for
exactly this sort of thing.  My plan is to take another pass through
the tree after 5.5 comes out, and these will be caught at that time.

Does that work for you?

							Thanx, Paul
