Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 415A9C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 01:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 065C0207D8
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 01:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589939329;
	bh=5b3m5wFU4hh9Yv7TMddahce+qOkkHM0MuT6Fti2iXIs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=2Eiki5pFrvrdc8D1v56O5u5NbUKjXspuLg37bc8On9SL9nV5/d3z3Zi/VJXn3adkN
	 4tcujdRW27LuIx8JiYYuKf46gy1zuFqEOpieJkcOFaKAqy4RtyaGVEVN5k+ne9FOUe
	 SvCkfiO1EtA3HGP82LBXe3dm8j8tBNhfC9TY4jAE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgETBss (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 21:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbgETBss (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 May 2020 21:48:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B589C2075F;
        Wed, 20 May 2020 01:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589939328;
        bh=5b3m5wFU4hh9Yv7TMddahce+qOkkHM0MuT6Fti2iXIs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nwLV5Rqwvc8jicA632QYsFEE2NijiwSig33QJZW92YQP8EcAPtyVF8Nk31RJv0D4m
         aDxKLuYLlmmJlg2PyRbB1Bz8ob+JRDhdtkDFETlLS9WHESNn+bT6ID+DRDzrsw65E2
         4t9jJKjfV6ZA/8Qq8kdBFTpBGZFkSTeKpXnYxBgs=
Date:   Tue, 19 May 2020 18:48:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Daniel Axtens <dja@axtens.net>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [hnaz-linux-mm:master 156/523] include/linux/string.h:307:9:
 note: in expansion of macro '__underlying_strncpy'
Message-Id: <20200519184847.5affb9238b7358ac0d18c98e@linux-foundation.org>
In-Reply-To: <87blmkhtpy.fsf@dja-thinkpad.axtens.net>
References: <202005191736.t1JQZSrV%lkp@intel.com>
        <87blmkhtpy.fsf@dja-thinkpad.axtens.net>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 20 May 2020 00:42:17 +1000 Daniel Axtens <dja@axtens.net> wrote:

> This looks like a SCSI issue that this has just happened to expose?
> + scsi list

Maybe.

static void arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,
		struct scsi_cmnd *cmd)
{
	switch (cmd->cmnd[0]) {
	case INQUIRY: {
		unsigned char inqdata[36];
		char *buffer;
		struct scatterlist *sg;

		if (cmd->device->lun) {
			cmd->result = (DID_TIME_OUT << 16);
			cmd->scsi_done(cmd);
			return;
		}
		inqdata[0] = TYPE_PROCESSOR;
		/* Periph Qualifier & Periph Dev Type */
		inqdata[1] = 0;
		/* rem media bit & Dev Type Modifier */
		inqdata[2] = 0;
		/* ISO, ECMA, & ANSI versions */
		inqdata[4] = 31;
		/* length of additional data */
		strncpy(&inqdata[8], "Areca   ", 8);
		/* Vendor Identification */
>>>		strncpy(&inqdata[16], "RAID controller ", 16);
		/* Product Identification */
		strncpy(&inqdata[32], "R001", 4); /* Product Revision */

		sg = scsi_sglist(cmd);
		buffer = kmap_atomic(sg_page(sg)) + sg->offset;

		memcpy(buffer, inqdata, sizeof(inqdata));
		sg = scsi_sglist(cmd);
		kunmap_atomic(buffer - sg->offset);

		cmd->scsi_done(cmd);
	}
	break;

That strncpy() will indeed fail to copy the trailing null, but it looks
like that null isn't appropriate in the inquiry data.

So I suspect this is a valid usage of strncpy() and the checking is
just too strict.

otoh if this is the only place where we hit this issue then perhaps we
can switch to memcpy() and get on with life ;)

