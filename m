From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic79xx blowups in 2.6.8-1.521smp (RHAT)
Date: 04 Oct 2004 09:00:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096898453.1748.9.camel@mulgrave>
References: <E1CERtQ-0001CV-9T@www.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:1924 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267624AbUJDOBI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Oct 2004 10:01:08 -0400
In-Reply-To: <E1CERtQ-0001CV-9T@www.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Bryce as root <root@www.linux.org.uk>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-10-04 at 07:24, Bryce as root wrote:
> kernel dmesg dump :
> Reseting Channel for LQI Phase error

This is clearly the cause of all the trouble.  The driver is a bit
opaque at this point, but it looks like an LQI phase error occurs
because of a phase mismatch during L_Q Information Units (These are a
requirement for fast-160 data transfers).

I think this is a strong indicator of bus instability ... could you try
falling back to fast-80 and turning off IU transfers (You'll probably
either have to use the card bios or dig around in the aic79xx driver for
the options).

James


