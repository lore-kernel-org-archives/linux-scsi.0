From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] sym53c500_cs PCMCIA SCSI driver (round 3 - the charm?)
Date: Sun, 25 Apr 2004 08:36:11 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040425083611.B18033@flint.arm.linux.org.uk>
References: <20040420172447.A27454@infradead.org> <20040425030154.52120DBDB@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([212.18.232.186]:52489 "EHLO
	caramon.arm.linux.org.uk") by vger.kernel.org with ESMTP
	id S262864AbUDYHgT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Apr 2004 03:36:19 -0400
Content-Disposition: inline
In-Reply-To: <20040425030154.52120DBDB@gherkin.frus.com>; from rct@gherkin.frus.com on Sat, Apr 24, 2004 at 10:01:54PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Bob Tracy <rct@gherkin.frus.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, Apr 24, 2004 at 10:01:54PM -0500, Bob Tracy wrote:
> In addition to all the concerns Christoph raised in response to the
> previous two submissions, there was an issue with the code for handling
> a CS_EVENT_CARD_RESET event: the event handler was calling the bus_reset
> function with a NULL scsi_cmnd argument.

Hmm, so what happens if you're in the middle of a transaction, and
you receive a CS_EVENT_CARD_RESET.  What happens to the command in
progress ?

Sure, the hardware is reset to a sane state, but what about the
software state in the driver?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:  2.6 PCMCIA      - http://pcmcia.arm.linux.org.uk/
                 2.6 Serial core
