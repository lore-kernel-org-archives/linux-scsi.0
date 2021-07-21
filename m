Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C64A8C6377A
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 21:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C4386121F
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 21:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhGUVEc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 17:04:32 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:50058 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhGUVEc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 17:04:32 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 733E01FD4E;
        Wed, 21 Jul 2021 21:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626903907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bOiHP9mMLpMPpcqhfQcN2pq2TnPamSrqtIA8gsEBOYQ=;
        b=yjQ/OX7q5JDfMlxcDe0quHTh21u5ukvqED4/6SWrAbQZIqqWFEQDZkD873mU8m3fznO1Mt
        GHrUowDZFlPRjquy6Z3PMmAymMkA9q3lZ7UYybl1wU6fR59nC1aQS74vGyDWbYkCiHrMjb
        SW2oeRtp8aiIP92LbVrkytiwrdG2Whc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626903907;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bOiHP9mMLpMPpcqhfQcN2pq2TnPamSrqtIA8gsEBOYQ=;
        b=rchz6kRVkuKR7qjYp8QnpJxHIIOtS8lsguzaaIDT0PXtXKY3cNtOSs6EsvgOgIWG4b9vBu
        AlECh6BS3CI/G5Bw==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 2BAF613C19;
        Wed, 21 Jul 2021 21:45:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id LeaQCGOV+GBVCwAAGKfGzw
        (envelope-from <ddiss@suse.de>); Wed, 21 Jul 2021 21:45:07 +0000
Date:   Wed, 21 Jul 2021 23:45:05 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     Sergey Samoylenko <s.samoylenko@yadro.com>
Cc:     <martin.petersen@oracle.com>, <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH 0/1] scsi: target: core: Fix sense key for invalid XCOPY
 request
Message-ID: <20210721234505.45c93a48@suse.de>
In-Reply-To: <20210624111926.63176-1-s.samoylenko@yadro.com>
References: <20210624111926.63176-1-s.samoylenko@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Sergey,

On Thu, 24 Jun 2021 14:19:25 +0300, Sergey Samoylenko wrote:

> EXTENDED COPY tests in libiscsi [1] show that TCM doesn't
> follow SPC4 when detects invalid parameters in a XCOPY
> command or IO errors. The replies from TCM contain wrong sense
> key or ASCQ for incorrect request.
> 
> The series fixes the following tests from libiscsi:

We've hit this too. The incorrect sense reporting appears to also affect
VMware XCOPY fallback to initiator driven READ/WRITE. I'm pretty sure
this is a regression from d877d7275be34ad70ce92bcbb4bb36cec77ed004, so
should probably be marked as such via a Fixes tag.

Cheers, David
