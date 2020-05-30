Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB88C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 09:43:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C77EC207F9
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 09:43:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="QY0CoQpt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgE3Jnz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 May 2020 05:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728304AbgE3Jny (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 May 2020 05:43:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89DDC03E969;
        Sat, 30 May 2020 02:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=73MMfueoWp3O9MARH/BR3+rDia4lZUeJmAGiQu0hBYs=; b=QY0CoQptM3vcN8m7QNDn4q6uK
        gIPUOe6k+M3redoEf1Eg+mEiVYU9XhMNrsqV8EkLD6Z8fFGvlrL4GPacHBmMdxpDU74F+k2kcgvYY
        E3bGXzsQ7FHq4yBDcTFzR68k3Vk0WDkRfza2j52e9m1EacfgSVrL4dnGdedYVcLcKpLN90JspKkDA
        gX82xXcAYQ6Zo6DXBWf4ATMQWzUfyJMKPcUEA7tyZnqsFfrmmj3TPEoQDWjFB3jZbP/m8jzMsBq0X
        rn865YQdWjw81vwxMoCOc8h+VYni2zQcn0Ig/skNsBdWGlrY/et/7wKy3ttK/IKFddLBXO2vVqQHJ
        /fCMoFRNQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:36466)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jey1k-0001rf-IR; Sat, 30 May 2020 10:43:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jey1i-0000yO-AE; Sat, 30 May 2020 10:43:38 +0100
Date:   Sat, 30 May 2020 10:43:38 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: cumana_2: Fix different dev_id between
 'request_irq()' and 'free_irq()'
Message-ID: <20200530094338.GE1551@shell.armlinux.org.uk>
References: <20200530073555.577414-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200530073555.577414-1-christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, May 30, 2020 at 09:35:55AM +0200, Christophe JAILLET wrote:
> The dev_id used in 'request_irq()' and 'free_irq()' should match.
> So use 'host' in both cases.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

This is itself wrong.  cumanascsi_2_intr() requires "info" as the devid.
Either cumanascsi_2_intr() needs changing to use shost_priv(host) along
with this change, or free_irq() needs changing to use "info".

Likely the same for the other patches, I haven't looked.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
