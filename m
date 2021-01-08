Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D970C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 00:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E54742368A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 00:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbhAHAPJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 19:15:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:59394 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729376AbhAHAPJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 19:15:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610064861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7iGL8P0Kgrb8br3+5Nk9lN4sAlTPsgAC3o2/C6VATPU=;
        b=FOL2ssrNHZHd6Xv4oNJQUXBB/kKmnZi+IpgMOLysQVL5VdXMz8bWj1x+I0kkrJmIWqTzAS
        gVZJDsGxysBrCh6NGUfs+RJjrrpE+93SwL0UhdCw/uNXiJaJzKeFsthuNueWLL92+Bfq8k
        rQHkK59fyue0vHRihhmT6R8X98juOYU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B39E5B797;
        Fri,  8 Jan 2021 00:14:21 +0000 (UTC)
Message-ID: <bfede3537d824380d9d61172d58643116b7f56dd.camel@suse.com>
Subject: Re: [PATCH V3 17/25] smartpqi: change timing of release of QRM
 memory during OFA
From:   Martin Wilck <mwilck@suse.com>
To:     Don Brace <don.brace@microchip.com>, Kevin.Barnett@microchip.com,
        scott.teel@microchip.com, Justin.Lindley@microchip.com,
        scott.benesh@microchip.com, gerry.morong@microchip.com,
        mahesh.rajashekhara@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com
Cc:     linux-scsi@vger.kernel.org
Date:   Fri, 08 Jan 2021 01:14:20 +0100
In-Reply-To: <160763255925.26927.7798016026983421676.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763255925.26927.7798016026983421676.stgit@brunhilda>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-12-10 at 14:35 -0600, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microchip.com>
> 
> * Release QRM memory (OFA buffer) on OFA error conditions.
> * Controller is left in a bad state which can cause a kernel panic
>     upon reboot after an unsuccessful OFA.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>

I don't understand how the patch description relates to the actual
change. With the patch, the buffers are released just like before,
only some instructions later. So apparently, without this patch, the
OFA memory had been released prematurely?

Anyway,

Reviewed-by: Martin Wilck <mwilck@suse.com>



