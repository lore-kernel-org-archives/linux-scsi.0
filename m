From: Mark Haverkamp <markh@osdl.org>
Subject: Re: how to use scsi_remove_device
Date: Fri, 17 Mar 2006 13:11:48 -0800
Message-ID: <1142629908.15834.15.camel@markh3.pdx.osdl.net>
References: <1142598225.25906.256865850@webmail.messagingengine.com>
	 <441B1388.20704@s5r6.in-berlin.de>  <441B1C7F.2090605@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:28634 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932788AbWCQVL6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Mar 2006 16:11:58 -0500
In-Reply-To: <441B1C7F.2090605@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi@vger.kernel.org, Eric Moore <Eric.Moore@lsil.com>, Leon Woestenberg <leonw@mailcan.com>

On Fri, 2006-03-17 at 21:30 +0100, Stefan Richter wrote:
> Hi all,
> 
> the following drivers use [__]scsi_add_device/ scsi_remove_device:
> 
> drivers/ieee1394/sbp2.c
> drivers/message/i2o/i2o_scsi.c
> drivers/message/fusion/mptsas.c
> drivers/scsi/aacraid/commsup.c
> drivers/scsi/ipr.c
> 
> Sbp2 calls scsi_add_device + scsi_remove_device.
> I2o_scsi calls __scsi_add_device + scsi_remove_device + scsi_device_put.
> Ipr calls scsi_add_device + scsi_device_get + scsi_remove_device + 
> scsi_device_put.
> 
> But aacraid and mptsas call scsi_add_device + scsi_remove_device + 
> scsi_device_put. AFAICS this is either one scsi_device_put too many or 
> one scsi_device_get too few.

I copied Mark Salyzyn since he is the aacraid driver writer.

Looking at commsup.c, though, I think that the scsi_device_put is done
after the scsi_device_lookup only if the scsi_device_remove is not done.

Mark.

> 
> (I am looking at Linus' tree.)
-- 
Mark Haverkamp <markh@osdl.org>

