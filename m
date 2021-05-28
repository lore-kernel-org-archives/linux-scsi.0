Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEFF7C4708C
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 18:36:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABD4D613C9
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 18:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbhE1SiG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 May 2021 14:38:06 -0400
Received: from smtprelay0056.hostedemail.com ([216.40.44.56]:53302 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229463AbhE1SiF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 May 2021 14:38:05 -0400
X-Greylist: delayed 448 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 May 2021 14:38:05 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave06.hostedemail.com (Postfix) with ESMTP id 400C58023692;
        Fri, 28 May 2021 18:29:03 +0000 (UTC)
Received: from omf04.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 08960837F27E;
        Fri, 28 May 2021 18:29:02 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf04.hostedemail.com (Postfix) with ESMTPA id 6721AD1515;
        Fri, 28 May 2021 18:29:00 +0000 (UTC)
Message-ID: <8a64b62949477b85576ab47e4705ca13fb555a9c.camel@perches.com>
Subject: Re: [PATCH 1/3] scsi: fcoe: Statically initialize flogi_maddr
From:   Joe Perches <joe@perches.com>
To:     Kees Cook <keescook@chromium.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org
Date:   Fri, 28 May 2021 11:28:59 -0700
In-Reply-To: <20210528181337.792268-2-keescook@chromium.org>
References: <20210528181337.792268-1-keescook@chromium.org>
         <20210528181337.792268-2-keescook@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 6721AD1515
X-Stat-Signature: uwk3xpe6uybxkt53prb6c4u4z74zby8t
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18UiZQA79XyUyFUgPVxG5YCbfS14BoxNgY=
X-HE-Tag: 1622226540-104772
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-05-28 at 11:13 -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy() using memcpy() with an inline const
> buffer and instead just statically initialize the destination array
> directly.
[]
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
[]
> @@ -293,7 +293,7 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
>  	struct fcoe_ctlr *fip = fcoe_to_ctlr(fcoe);
>  	struct netdev_hw_addr *ha;
>  	struct net_device *real_dev;
> -	u8 flogi_maddr[ETH_ALEN];
> +	u8 flogi_maddr[ETH_ALEN] = FC_FCOE_FLOGI_MAC;

static const

> @@ -442,7 +441,7 @@ static void fcoe_interface_remove(struct fcoe_interface *fcoe)
>  {
>  	struct net_device *netdev = fcoe->netdev;
>  	struct fcoe_ctlr *fip = fcoe_to_ctlr(fcoe);
> -	u8 flogi_maddr[ETH_ALEN];
> +	u8 flogi_maddr[ETH_ALEN] = FC_FCOE_FLOGI_MAC;

etc...


