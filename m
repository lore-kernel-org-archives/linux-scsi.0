Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E3FC433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 15:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AF6422C9C
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 15:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgGTPT5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 11:19:57 -0400
Received: from smtprelay0212.hostedemail.com ([216.40.44.212]:35042 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725815AbgGTPT5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jul 2020 11:19:57 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 5B7E11847A0C0;
        Mon, 20 Jul 2020 15:19:56 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: wound04_440fc9526f25
X-Filterd-Recvd-Size: 2452
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Mon, 20 Jul 2020 15:19:54 +0000 (UTC)
Message-ID: <de4b0ef6b1b7b58acc184d1d7e80456f6c3b56c0.camel@perches.com>
Subject: Re: [PATCH v2 net-next 01/14] qed: convert link mode from u32 to
 bitmap
From:   Joe Perches <joe@perches.com>
To:     Alexander Lobakin <alobakin@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        GR-everest-linux-l2@marvell.com,
        QLogic-Storage-Upstream@marvell.com, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 20 Jul 2020 08:19:52 -0700
In-Reply-To: <20200720092306.355-1-alobakin@marvell.com>
References: <20200719212100.GM1383417@lunn.ch>
         <20200719201453.3648-1-alobakin@marvell.com>
         <20200719201453.3648-2-alobakin@marvell.com>
         <20200720092306.355-1-alobakin@marvell.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-07-20 at 12:23 +0300, Alexander Lobakin wrote:
> Date: Sun, 19 Jul 2020 23:21:00 +0200 From: Andrew Lunn <andrew@lunn.ch>
> > On Sun, Jul 19, 2020 at 11:14:40PM +0300, Alexander Lobakin wrote:
> > > Currently qed driver already ran out of 32 bits to store link modes,
> > > and this doesn't allow to add and support more speeds.
> > > Convert link mode to bitmap that will always have enough space for
> > > any number of speeds and modes.
[]
> > Why not just throw away all these QED_LM_ defines and use the kernel
> > link modes? The fact you are changing the u32 to a bitmap suggests the
> > hardware does not use them.
> 
> I've just double-checked, and you're right, management firmware operates
> with NVM_* definitions, while QED_LM_* are used only in QED and QEDE to
> fill Ethtool link settings.
> I didn't notice this while working on the series, but it would be really
> a lot better to just use generic definitions.
> So I'll send v3 soon.

While you're at it, why are you using __set_bit and not set_bit?


