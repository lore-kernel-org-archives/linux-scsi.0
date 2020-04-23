Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0D8C2BA19
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 07:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B56A20781
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 07:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgDWHtP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 03:49:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:36728 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbgDWHtP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Apr 2020 03:49:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D19A8AF48;
        Thu, 23 Apr 2020 07:49:13 +0000 (UTC)
Date:   Thu, 23 Apr 2020 09:49:13 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com,
        bvanassche@acm.org, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v3 12/31] elx: libefc: Remote node state machine
 interfaces
Message-ID: <20200423074913.izb2hdqmamopnrg2@beryllium.lan>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-13-jsmart2021@gmail.com>
 <20200415181904.3v5efamjwjcvs53i@carbon>
 <21b21290-2a46-9326-83a2-bf35aad477b5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21b21290-2a46-9326-83a2-bf35aad477b5@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

On Wed, Apr 22, 2020 at 06:32:09PM -0700, James Smart wrote:
> On 4/15/2020 11:19 AM, Daniel Wagner wrote:
> > > +void
> > > +efc_node_transition(struct efc_node *node,
> > > +		    void *(*state)(struct efc_sm_ctx *,
> > > +				   enum efc_sm_event, void *), void *data)
> > > +{
> > > +	struct efc_sm_ctx *ctx = &node->sm;
> > > +
> > > +	if (ctx->current_state == state) {
> > > +		efc_node_post_event(node, EFC_EVT_REENTER, data);
> > > +	} else {
> > > +		efc_node_post_event(node, EFC_EVT_EXIT, data);
> > > +		ctx->current_state = state;
> > > +		efc_node_post_event(node, EFC_EVT_ENTER, data);
> > > +	}
> > 
> > Why does efc_node_transition not need to take the efc->lock as in
> > efc_remote_node_cb? How are the state machine state transitions
> > serialized?
> 
> efc_remote_node_cb is a callback called from outside the statemachine, so it
> needs to take the lock.   efc_node_transition is called from within the
> statemachine, after the lock is taken. In general the lock is taken upon
> entering the statemachine and released before exiting. There isn't granular
> locking within the statemachine.

Thanks for explaining. I find such short explanation extremly helpful
when looking at code. It might be obvious but not for everyone :)

Could you add this as comment somehwere?

Thanks,
Daniel
