From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/3 ver2] block layer extended-cdb support
Date: Sun, 13 Apr 2008 09:07:55 -0500
Message-ID: <1208095676.4707.6.camel@localhost.localdomain>
References: <47F522A6.3080806@panasas.com>
	 <20080404114614.GJ29686@kernel.dk> <47F89948.9060503@panasas.com>
	 <20080412145152C.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37803 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757447AbYDMOIF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Apr 2008 10:08:05 -0400
In-Reply-To: <20080412145152C.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bharrosh@panasas.com, jens.axboe@oracle.com, hch@infradead.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org

On Sat, 2008-04-12 at 14:52 +0900, FUJITA Tomonori wrote:
> bsg are created only for scsi devices (and scsi objects like sas host)
> now. Are there other means to send commands except for ioctl?

Right now they are ... but the design was to allow for arbitrary packet
commands (like the frame in/frame out type that SMP needs), so the
anticipation is that it will be usable by arbitrary packet commands for
any block conforming device, examples of which would be ide taskfiles,
raid firmware commands and any other weirder native protocols.  On the
other hand, this is future work and won't depend on the legacy 16 byte
cmd size.

The only block device I know that implements SG_IO is cciss, so perhaps
there's no need to support a legacy mode at all for large packet
commands.

James


