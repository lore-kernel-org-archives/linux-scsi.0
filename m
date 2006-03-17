From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: how to use scsi_remove_device
Date: Fri, 17 Mar 2006 15:39:23 -0600
Message-ID: <1142631563.3270.35.camel@mulgrave.il.steeleye.com>
References: <1142598225.25906.256865850@webmail.messagingengine.com>
	 <441B1388.20704@s5r6.in-berlin.de>  <441B1C7F.2090605@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:16040 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932795AbWCQVj3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Mar 2006 16:39:29 -0500
In-Reply-To: <441B1C7F.2090605@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, Mark Haverkamp <markh@osdl.org>, Eric Moore <Eric.Moore@lsil.com>, Leon Woestenberg <leonw@mailcan.com>

On Fri, 2006-03-17 at 21:30 +0100, Stefan Richter wrote:
> the following drivers use [__]scsi_add_device/ scsi_remove_device:

The rule is that scsi_add_device() doesn't leave you with a reference,
but __scsi_add_device() does.

scsi_remove_device() does just that, but it doesn't put any references
you might have taken separately.

> But aacraid and mptsas call scsi_add_device + scsi_remove_device + 
> scsi_device_put. AFAICS this is either one scsi_device_put too many or 
> one scsi_device_get too few.

These all look correct.  The scsi_device_puts are paired with
scsi_device_lookup() which does indeed get a reference which needs
putting.

James


