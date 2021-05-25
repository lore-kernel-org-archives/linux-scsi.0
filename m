Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F5DC47086
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 20:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDF74613B6
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 20:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbhEYUEO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 16:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbhEYUEO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 16:04:14 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46A0C061574;
        Tue, 25 May 2021 13:02:42 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id a25so37707585edr.12;
        Tue, 25 May 2021 13:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=8r1mrIIk64B+SAd8wevbFNxggoZWe91osY2VjD0S0GE=;
        b=bzdDymZy4Ds/OEvdG5BQs8mBcsZ2J0IPsHB662SvTMx3dIcUMnFhBLxBBAFDfT8/ra
         +r3NkTeJvrcVybA03T0EB6mXUw5gYn2cGKNZkL66FhM8N345qSIdsIiIQj+79Z1p4FVe
         fJZy6TmhBdgzFGhdOEbu4EcgLEdb4XXYLK5Tis5J13vzVo4xmMOtcUDsgkM7JeKhIUHg
         71HHQTb4Ofk3D8OSsVHFjhZw38pN8Ky4su+OCGNWoagIfn7lo5vXAkiO1T+lt8GDBqzH
         YOn8/prBqYhzphavjZMgO8/uZmq9fIX1kDiznbdcpykS6hEMuE5HKuSq4YEGFklvDm25
         sYbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8r1mrIIk64B+SAd8wevbFNxggoZWe91osY2VjD0S0GE=;
        b=feCRHPSzZv56fglvnj+tUJ4eNX9FspSdzvVVxGCSv9jKXqEHU7XQhwK2xyVIRty4Tz
         kkmVw0L9bwD5IQXR+FpqE1eiiX1J/19CXLi5oeQgowifi8bAPpaAkiZv/7W9I4HeztVQ
         kCLXvCIHKEY1JzghdIUy7NA4wGj+r/uP8RCT4EwvuWDimMgPOMKCJlYHHnOHMaggXmY7
         Gqh7MJfsDIFP3eeKWZzuk39VqP2eQZV3nWWrePAPelAIXn6EBZDSt1BYJd3mSinLDqpg
         pOMkjSOy5tTyKpp9x82sMRgR/RJ3qxV24lSHrQExCprgdoWOIRLUo9+Ln1YxpdyxMIuj
         6BWg==
X-Gm-Message-State: AOAM533OXaZBwYQ0OwHihc3ho40KGaqa79TM7LKUC3dQYZK0+ll2+a7z
        GxjJPra0vsCX5cGT5edAKco=
X-Google-Smtp-Source: ABdhPJxc/Nz3551ilTTCSrimm90QZ7Gn4CKn3HZ0y3asKE3MTvXJyjbDwJtS9pGI0Ooio1m4G7aPSw==
X-Received: by 2002:aa7:d65a:: with SMTP id v26mr33424639edr.185.1621972961537;
        Tue, 25 May 2021 13:02:41 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id w14sm11589795edj.6.2021.05.25.13.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 13:02:41 -0700 (PDT)
Message-ID: <bd0c18c8ca48fedde3c273796c58307138cd4bd1.camel@gmail.com>
Subject: Re: [PATCH v1 2/3] scsi: ufs: Let command trace only for the cmd !=
 null case
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 25 May 2021 22:02:39 +0200
In-Reply-To: <1d06cc01-a642-e8e0-a251-1b392e4935c7@acm.org>
References: <20210523211409.210304-1-huobean@gmail.com>
         <20210523211409.210304-3-huobean@gmail.com>
         <1d06cc01-a642-e8e0-a251-1b392e4935c7@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bart,
Thanks for your review, appreciated it.

On Sun, 2021-05-23 at 18:32 -0700, Bart Van Assche wrote:
> On 5/23/21 2:14 PM, Bean Huo wrote:
> > +	opcode = cmd->cmnd[0];
> > +	if ((opcode == READ_10) || (opcode == WRITE_10)) {
> > +		/*
> > +		 * Currently we only fully trace read(10) and write(10)
> > +		 * commands
> > +		 */
> > +		if (cmd->request && cmd->request->bio)
> > +			lba = cmd->request->bio->bi_iter.bi_sector;
> 
> Why does the lba assignment occur inside the if-statement for the
> READ_10 and WRITE_10 cases? Has it been considered to move that
> assignment before this if-statement?

yes, this lba assignment can be moved before if-statement:


      if (cmd->request && cmd->request->bio)
                        lba
= cmd->request->bio->bi_iter.bi_sector;

       if ((opcode == READ_10) || (opcode == WRITE_10)) {
                /*
                 * Currently we only fully trace read(10) and write(10)
                 * commands
                 */
          


> 
> Does 'lba' represent an offset in units of 512 bytes (sector_t) or an
> LBA (logical block address)? In the former case, please rename the
> variable 'lba' into 'sector' or 'start_sector'. In the latter case,
> please use sectors_to_logical().

apparently it is in 512 bytes. ok, sector is more readable.
> 
> Why are READ_16 and WRITE_16 ignored?

READ_16 and WRITE_16 are optimal for the UFS. not mandatory.
> 
> Please remove the 'if (cmd->request)' checks since these are not
> necessary.
> 
> > +	} else if (opcode == UNMAP) {
> > +		if (cmd->request) {
> > +			lba = scsi_get_lba(cmd);
> > +			transfer_len = blk_rq_bytes(cmd->request);
> >  		}
> >  	}
> 
> The name of the variable 'transfer_len' is wrong since blk_rq_bytes()
> returns the number of bytes affected on the storage medium instead of
> the number of bytes transferred from the host to the storage
> controller.
> 
ok, I will remove them, and they will be a additional cleanup patch.

> >  /**
> > - * Describes the ufs rpmb wlun.
> > - * Used only to send uac.
> > + * Describes the ufs rpmb wlun. Used only to send uac.
> >   */
> 
> Is this change related to the rest of this patch?
> 

It might be a cleanup.


Bean

> Thanks,
> 
> Bart.

