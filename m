From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] Move scsi_print_msg to SPI code
Date: Tue, 13 Dec 2005 13:32:45 -0500
Message-ID: <439F13CD.8040602@pobox.com>
References: <20051213165342.GM9286@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:61132 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932325AbVLMScx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Dec 2005 13:32:53 -0500
In-Reply-To: <20051213165342.GM9286@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> scsi_print_msg got the transfer period translation to nanoseconds wrong.
> We have the right code to do this in scsi_transport_spi.c, but we can't
> guarantee that'll be linked in.  scsi_print_msg is a bit of a misnomer
> anyway, since these messages are actually SPI messages, not SAM.
> 
> So I've moved scsi_print_msg to scsi_transport_spi.c and renamed it to
> spi_print_msg.  All drivers that use scsi_print_msg() got converted,
> and the Kconfig was adjusted to link in the SPI transport code for
> those drivers.  Note that those drivers haven't been converted to use
> the SPI transport code ... but surely it's just a matter of time.

Strong ACK, though I think your change here should be split up:  the 
patch to link against SPI should be separated from the scsi_print_msg() 
change.

This change will make it easier to start marginalizing SPI.  Eventually 
all SPI drivers will link against the SPI transport class, and this is 
the necessary first step.

	Jeff


