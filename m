From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: device settings past a bus reset
Date: Tue, 17 Oct 2006 11:02:22 -0500
Message-ID: <1161100942.3720.3.camel@mulgrave.il.steeleye.com>
References: <yq0k62z9f1t.fsf@jaguar.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:40584 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751130AbWJQQC3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Oct 2006 12:02:29 -0400
In-Reply-To: <yq0k62z9f1t.fsf@jaguar.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@sgi.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2006-10-17 at 10:45 -0400, Jes Sorensen wrote:
> I have a bug report about the qla1280 driver dropping the per device
> negotiated settings past a bus reset. I could in principle try and
> keep a list of configured devices in the driver, but it seems to me
> that it would be reasonable that the SCSI layer should call
> ->slave_configure() again for each configured device after a bus
> reset?

Really, no.  A lot of drivers allocate resources in slave_configure() on
the assumption that it is just called once before the device begins to
be used in earnest, so this routine isn't idempotent.

> Anyone else seeing this in other drivers and have any oppinion on it?

What most SPI drivers do is to call spi_schedule_dv() from the reset
detection routines.  This schedules domain validation to run after the
reset processing has completed.  Unfortunately, you actually have to
attach to the transport class for this to work ... which the qla1280
doesn't.

James


