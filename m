From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] add extra inquiry byte 56 data to struct scsi_device
Date: Sat, 21 Aug 2004 23:03:16 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41274814.4090903@torque.net>
References: <1093053368.3318.569.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:18093 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S264884AbUHUNDy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 09:03:54 -0400
In-Reply-To: <1093053368.3318.569.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> The idea here is to get a full range of device capabilites in the
> scsi_device structure so there's absolutely no need at all for drivers
> to snoop the inquiry data.
> 
> The missing parameters were:
> 
> dt_only - means the device only supports DT transfers (not ST)
> ius - means the device supports information unit (IU) transfers
> qas - means the device supports the Quick Arbitration and Selection
> protocol
> 
> Our rather misnamed ones are:
> 
> ppr - means the device does DT (DT negotiation may only be done via PPR)
> wdtr - means the device does wide
> sdtr - means the device does sync

James,
What you are proposing is only relevant for the SPI
transport. Maybe the accessors should be placed in
scsi_tranport_spi.c and struct scsi_device get a
a transport dependent "hang on". Then some of that older
SPI stuff could get migrated out of struct scsi_device
so it stops growing.

Doug Gilbert
