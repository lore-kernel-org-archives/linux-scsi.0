Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE00C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 14:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DED05611AC
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 14:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235875AbhDPODW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 10:03:22 -0400
Received: from smtprelay0216.hostedemail.com ([216.40.44.216]:52770 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235824AbhDPODP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Apr 2021 10:03:15 -0400
Received: from omf19.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 356B6182CCCA1;
        Fri, 16 Apr 2021 14:02:50 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf19.hostedemail.com (Postfix) with ESMTPA id D5D6120D76C;
        Fri, 16 Apr 2021 14:02:48 +0000 (UTC)
Message-ID: <86c10671ff86f96004a6d6c3c08aed3e27d58d0a.camel@perches.com>
Subject: Re: [PATCH 1/5] scsi: BusLogic: Fix missing `pr_cont' use
From:   Joe Perches <joe@perches.com>
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Fri, 16 Apr 2021 07:02:47 -0700
In-Reply-To: <alpine.DEB.2.21.2104161224300.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
         <alpine.DEB.2.21.2104141419040.44318@angie.orcam.me.uk>
         <787aae5540612555a8bf92de2083c8fa74e52ce9.camel@perches.com>
         <alpine.DEB.2.21.2104161224300.44318@angie.orcam.me.uk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D5D6120D76C
X-Stat-Signature: s5wmbjk659h7mg5jhu5mqrfpt8wgj5fh
X-Rspamd-Server: rspamout01
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+mUWFAJ6U9If9DlEQENf8WjP/qF4VZsrM=
X-HE-Tag: 1618581768-795146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-04-16 at 12:48 +0200, Maciej W. Rozycki wrote:
> I'm not sure if that complex message 
> routing via `blogic_msg' is worth having even, rather than calling 
> `printk' or suitable variants directly.

It's to allow the message content to be added to the internal
	&adapter->msgbuf[adapter->msgbuflen]
with strcpy for later use with blogic_show_info()/seq_write.



