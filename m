From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/10] mptfusion : Transport Layer Retry support
Date: Wed, 12 Jul 2006 11:32:29 -0400
Message-ID: <1152718349.3728.18.camel@mulgrave.il.steeleye.com>
References: <20060711232109.GA12249@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:18335 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750996AbWGLPcd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jul 2006 11:32:33 -0400
In-Reply-To: <20060711232109.GA12249@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2006-07-11 at 17:21 -0600, Eric Moore wrote:
> Transport Layer Retry support for SAS Tapes.
> Detects whether firmware supports TLR, then
> issues special scsi opcode to enable TLR in

If I understand what this does correctly, you snoop the inquiry field in
slave configure and then send a vendor specific opcode that the tape
understands (in the event that it reports TLR in its PSLU page)?

Really, no, this isn't appropriate for code in a driver, since I assume
enabling TLR via this command on these things should be independent of
the particular SAS HBA, so it should probably be a transport specific
blacklist.

The next thing ... since TLR is a per port setting in the protocol
specific LU page is that we should probe it and keep its setting within
the transport class as well.

James


