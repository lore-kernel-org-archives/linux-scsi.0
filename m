From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Blacklist entry for HP dat changer
Date: Tue, 16 May 2006 08:59:32 -0500
Message-ID: <1147787972.3505.7.camel@mulgrave.il.steeleye.com>
References: <20060516043829.GA13482@alpha.franken.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:35510 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751102AbWEPN7g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 09:59:36 -0400
In-Reply-To: <20060516043829.GA13482@alpha.franken.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-scsi@vger.kernel.org

On Tue, 2006-05-16 at 06:38 +0200, Thomas Bogendoerfer wrote:
> scsi: host 1 channel 0 id 5 lun16777216 has a LUN larger than allowed by
> the host adapter

This is a classic symptom of a device incorrectly executing report luns,
yes.

> Looking at the misdetected LUN number I'm still thinking there might
> be an endianess problem (16777216 = 0x01000000 -> little endian 0x01).
> Is this possible ?

It's possible, but if so it would have to be inside the device.  SCSI is
big endian explicitly in the protocol documents.

> +	{"HP", "C5713A", NULL, BLIST_NOREPORTLUN},

This looks to be the correct fix ... I'll add it.

James


