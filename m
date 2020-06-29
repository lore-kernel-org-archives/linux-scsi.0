Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B47C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 20:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D8E420786
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 20:51:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ara8FOJJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389789AbgF2Uvp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 16:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731378AbgF2TN1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 15:13:27 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8697C014A47;
        Mon, 29 Jun 2020 01:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uAiRDghuOCMpDAFAHvQM5BdGNUMLZuFGW1APRakoSus=; b=ara8FOJJmyGTsZZYwrSNPjWLqN
        qQal0ttJBdaZfhpLC0Z/0FVu0TGsBscGI7gHKZlxfygbnCKljVmd6EliGkUjiCeua5Lqlw+SqUGri
        YDF/uUjkMqsGFUIUIlu6dP/HMLfagIiCfP7CnCNO/HR3E0DtZg3r6JVkQbErGPJrBmWjpHJNnZqFi
        dvaPuTG2pAlmYGYVTzI+Iei0zvDBYbJVhGbqE40iWteYnODY0StwXQAzxsjKFuSER8akZL6L3IWxR
        XnPxi6siVqTpD8pKccFNJr5E7a4Iutb0TtgFybcU7WiUAYpmFodShSUWbg4RziXqhwwdibXeVKeVq
        /ShvQPnw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jporL-0007T7-3F; Mon, 29 Jun 2020 08:09:47 +0000
Date:   Mon, 29 Jun 2020 09:09:47 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Simon Arlott <simon@octiron.net>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@infradead.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Pavel Machek <pavel@ucw.cz>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH (v2)] scsi: sd: add parameter to stop disks before reboot
Message-ID: <20200629080947.GA28551@infradead.org>
References: <e726ffd8-8897-4a79-c3d6-6271eda8aebb@0882a8b5-c6c3-11e9-b005-00805fc181fe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e726ffd8-8897-4a79-c3d6-6271eda8aebb@0882a8b5-c6c3-11e9-b005-00805fc181fe>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jun 28, 2020 at 07:32:51PM +0100, Simon Arlott wrote:
> I need to use "reboot=p" on my desktop because one of the PCIe devices
> does not appear after a warm boot. This results in a very cold boot
> because the BIOS turns the PSU off and on.
> 
> The scsi sd shutdown process does not send a stop command to disks
> before the reboot happens (stop commands are only sent for a shutdown).
> 
> The result is that all of my SSDs experience a sudden power loss on
> every reboot, which is undesirable behaviour because it could cause data
> to be corrupted. These events are recorded in the SMART attributes.
> 
> Add a "stop_before_reboot" module parameter that can be used to control
> the shutdown behaviour of disks before a reboot. The default will be
> the existing behaviour (disks are not stopped).
> 
>   sd_mod.stop_before_reboot=<integer>
>     0 = disabled (default)
>     1 = enabled
> 
> The behaviour on shutdown is unchanged: all disks are unconditionally
> stopped.

What happened to the suggestion to treat reboot=p like a poweroff
instead?  That seems to be fundamentally the right thing to do.
