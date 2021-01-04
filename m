Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBFF9C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 16:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F341221F1
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 16:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbhADQSm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 11:18:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:43994 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727986AbhADQSl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Jan 2021 11:18:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0A7B4ADD6;
        Mon,  4 Jan 2021 16:18:00 +0000 (UTC)
Date:   Mon, 4 Jan 2021 17:17:59 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 14/31] elx: libefc: FC node ELS and state handling
Message-ID: <20210104161759.hxnhiyhyzos5pr2i@beryllium.lan>
References: <20210103171134.39878-1-jsmart2021@gmail.com>
 <20210103171134.39878-15-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210103171134.39878-15-jsmart2021@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jan 03, 2021 at 09:11:17AM -0800, James Smart wrote:
> This patch continues the libefc library population.
> 
> This patch adds library interface definitions for:
> - FC node PRLI handling and state management
> 
> Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Reviewed-by: Daniel Wagner <dwagner@suse.de>

> ---
> v5:
>  Topology naming changes.


BTW, I've just grepped for TOPO and found

libefc_sli/sli4.h:      SLI4_READTOPO_ATTEN_TYPE        = 0xff,
libefc_sli/sli4.h:      SLI4_READTOPO_FLAG_IL           = 0x100,
libefc_sli/sli4.h:      SLI4_READTOPO_FLAG_PB_RECVD     = 0x200,
libefc_sli/sli4.h:      SLI4_READTOPO_LINKSTATE_RECV    = 0x3,
libefc_sli/sli4.h:      SLI4_READTOPO_LINKSTATE_TRANS   = 0xc,
libefc_sli/sli4.h:      SLI4_READTOPO_LINKSTATE_MACHINE = 0xf0,
libefc_sli/sli4.h:      SLI4_READTOPO_LINKSTATE_SPEED   = 0xff00,
libefc_sli/sli4.h:      SLI4_READTOPO_LINKSTATE_TF      = 0x40000000,
libefc_sli/sli4.h:      SLI4_READTOPO_LINKSTATE_LU      = 0x80000000,
libefc_sli/sli4.h:      SLI4_READTOPO_SCN_BBSCN         = 0xf,
libefc_sli/sli4.h:      SLI4_READTOPO_SCN_CBBSCN        = 0xf0,
libefc_sli/sli4.h:      SLI4_READTOPO_R_T_TOV           = 0x1ff,
libefc_sli/sli4.h:      SLI4_READTOPO_AL_TOV            = 0xf000,
libefc_sli/sli4.h:      SLI4_READTOPO_PB_FLAG           = 0x80,
libefc_sli/sli4.h:      SLI4_READTOPO_INIT_N_PORTID     = 0xffffff,
libefc_sli/sli4.h:      SLI4_READ_TOPOLOGY_LINK_UP      = 0x1,
libefc_sli/sli4.h:      SLI4_READ_TOPOLOGY_LINK_DOWN,
libefc_sli/sli4.h:      SLI4_READ_TOPOLOGY_LINK_NO_ALPA,
libefc_sli/sli4.h:      SLI4_READ_TOPO_UNKNOWN          = 0x0,
libefc_sli/sli4.h:      SLI4_READ_TOPO_NON_FC_AL,
libefc_sli/sli4.h:      SLI4_READ_TOPO_FC_AL,
libefc_sli/sli4.h:      SLI4_READ_TOPOLOGY_SPEED_NONE   = 0x00,
libefc_sli/sli4.h:      SLI4_READ_TOPOLOGY_SPEED_1G     = 0x04,
libefc_sli/sli4.h:      SLI4_READ_TOPOLOGY_SPEED_2G     = 0x08,
libefc_sli/sli4.h:      SLI4_READ_TOPOLOGY_SPEED_4G     = 0x10,
libefc_sli/sli4.h:      SLI4_READ_TOPOLOGY_SPEED_8G     = 0x20,
libefc_sli/sli4.h:      SLI4_READ_TOPOLOGY_SPEED_10G    = 0x40,
libefc_sli/sli4.h:      SLI4_READ_TOPOLOGY_SPEED_16G    = 0x80,
libefc_sli/sli4.h:      SLI4_READ_TOPOLOGY_SPEED_32G    = 0x90,
libefc_sli/sli4.h:      SLI4_READ_TOPOLOGY_SPEED_64G    = 0xa0,
libefc_sli/sli4.h:      SLI4_READ_TOPOLOGY_SPEED_128G   = 0xb0,

It's a bit confusing the SLI4_READTOPO vs SLI4_READ_TOPOLOGY_* vs
SLI4_READ_TOPO_* naming. But I don't have any idea to make it a bit more
readable.
