Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AB9C2BA19
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 17:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2A4D2076D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 17:43:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="VfYRkUJP";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="VfYRkUJP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411436AbgDORna (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 13:43:30 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35376 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2411346AbgDORn2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Apr 2020 13:43:28 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 6DD808EE26A;
        Wed, 15 Apr 2020 10:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1586972606;
        bh=0QxFiZ5twG/dSc4Ii3V8lBH0HDxMQU8fqaa9G/yTk9w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VfYRkUJPlMpADp5LJZ2U0RwnWXjLbVM1ir+J3VVQ007VOZNKyK0EjCARquMwM3E86
         YYwPFyFtcPzOJfyAkNEDwKyPuKAbgIdFWpqlVNgjsh1hxaUgEjKlaN0o0iddqnYmfs
         0R+WMKH7G/Lgnk1mtPN/pLun2DtOL1jRtmXodeCw=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Ul6wlkJEAiFs; Wed, 15 Apr 2020 10:43:26 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 95F398EE0CF;
        Wed, 15 Apr 2020 10:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1586972606;
        bh=0QxFiZ5twG/dSc4Ii3V8lBH0HDxMQU8fqaa9G/yTk9w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VfYRkUJPlMpADp5LJZ2U0RwnWXjLbVM1ir+J3VVQ007VOZNKyK0EjCARquMwM3E86
         YYwPFyFtcPzOJfyAkNEDwKyPuKAbgIdFWpqlVNgjsh1hxaUgEjKlaN0o0iddqnYmfs
         0R+WMKH7G/Lgnk1mtPN/pLun2DtOL1jRtmXodeCw=
Message-ID: <1586972604.3931.5.camel@HansenPartnership.com>
Subject: Re: [PATCH v3 02/31] elx: libefc_sli: SLI Descriptors and Queue
 entries
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Hannes Reinecke <hare@suse.de>, James Smart <jsmart2021@gmail.com>,
        linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
Date:   Wed, 15 Apr 2020 10:43:24 -0700
In-Reply-To: <e02f4879-9d7e-e37d-b1ea-db6305ac6308@suse.de>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
         <20200412033303.29574-3-jsmart2021@gmail.com>
         <e02f4879-9d7e-e37d-b1ea-db6305ac6308@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-04-15 at 14:14 +0200, Hannes Reinecke wrote:
> On 4/12/20 5:32 AM, James Smart wrote:
[...]
> > +struct sli4_queue {
> > +	/* Common to all queue types */
> > +	struct efc_dma	dma;
> > +	spinlock_t	lock;	/* protect the queue
> > operations */
> > +	u32	index;		/* current host entry
> > index */
> > +	u16	size;		/* entry size */
> > +	u16	length;		/* number of entries */
> > +	u16	n_posted;	/* number entries posted */
> > +	u16	id;		/* Port assigned xQ_ID */
> > +	u16	ulp;		/* ULP assigned to this
> > queue */
> > +	void __iomem    *db_regaddr;	/* register address
> > for the doorbell */
> > +	u8		type;		/* queue type ie
> > EQ, CQ, ... */
> 
> Alignment?
> Having an u8 following a pointer is a guaranteed misalignment for
> the remaining entries.

Only for a packed structure, which this isn't.

In an ordinary structure, everything is padded to the required
aligment, so you're going to waste 3 bytes here but it isn't going to
be misaligned.

James

