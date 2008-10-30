From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 13/17] scsi: remove private implementation of
	get_unaligned_be32
Date: Thu, 30 Oct 2008 09:17:22 -0500
Message-ID: <1225376242.3250.19.camel@localhost.localdomain>
References: <200810292124.m9TLOjl1021276@imap1.linux-foundation.org>
	 <1225316894.3257.19.camel@localhost.localdomain>
	 <20081029150702.1a20310a.akpm@linux-foundation.org>
	 <1225318393.3257.24.camel@localhost.localdomain>
	 <1225319368.5496.3.camel@brick>  <1225328584.5496.7.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59428 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753852AbYJ3OR0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2008 10:17:26 -0400
In-Reply-To: <1225328584.5496.7.camel@brick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

On Wed, 2008-10-29 at 18:03 -0700, Harvey Harrison wrote: 
> +/*
> + * Opcode 0x28
> + */
> +struct scsi_read10 {
> +	u8 op;
> +	u8 flags;
> +	__be32 lba;
> +	u8 pad; /* reserved */
> +	__be16 length;
> +	u8 control;
> +} __packed;
> +
> +/*
> + * Opcode 0xa8
> + */
> +struct scsi_read12 {
> +	u8 op;
> +	u8 flags;
> +	__be32 lba;
> +	__be32 length;
> +	u8 pad; /* reserved */
> +	u8 control;
> +} __packed;
> +
> +/*
> + * Opcode 0x88
> + */
> +struct scsi_read16 {
> +	u8 op;
> +	u8 flags;
> +	__be64 lba;
> +	__be32 length;
> +	u8 pad; /* MMC4, reserved, group number */
> +	u8 control;
> +} __packed;

OK, so this is wrong: the commands, unfortunately, have several meanings
for the bits depending on the version of the spec.  Also, it's not
really the way the mid-layer thinks about commands.  We tend to use the
generic groupings there.  Finally, this looks pretty ugly and it would
get really horrible if we had to do unions for the bits as they changed
meanings through the standards.

So all in all, to try to solve a problem which doesn't really exist, I
don't really think its a good idea.  There's no evidence of any
confusion caused by the SCSI bus being BE in any of the drivers.

James


