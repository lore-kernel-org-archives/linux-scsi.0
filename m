From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [patch 6/8] mptfusion: fc transport
Date: 01 Dec 2004 15:49:53 -0500
Message-ID: <1101934199.1930.236.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C667C7D@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:37785 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261444AbULAUuF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Dec 2004 15:50:05 -0500
In-Reply-To: <91888D455306F94EBD4D168954A9457C667C7D@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-12-01 at 14:46, Moore, Eric Dean wrote:
> On Thursday, November 25, 2004 1:55 PM, James Bottomley wrote:
> > How difficult would it be to separate out the scsi and FC 
> > pieces of the
> > fusion driver, so we could allow more fined grained control of this?
>  
> This driver is four separate driver modules { mptbase, mptscsih, mptlan,
> mptctl },
> with FC and SCSI spread through out, and SAS waiting in the wings.
> In this current design, separating FC is not going to be an easy task,
> as well as dealing with SAS because I'm sure people would want that
> separated as well.  
> Device recognization done from mptbase, as well as unique
> configuration/initialization
> for respective bus type, and messaging interface from the other drivers
> (mptscsih,
> mptlan, and mptctl) to the firmware.  The scsi interface layer is in
> mptscsih, 
> and is where this fc transports and our spi domain validation is done
> currently. 
> 
> What do you have in mind in seperating this code for each (3) different bus
> classes from 
> each these (4) drivers?  

Nothing complex.  How about just a simple module wrapper for the PCI
attachment, so you have the FC devices in one, the SPI in another etc. 
Then you could attach and initialise the FC transport only if the user
modprobes the FC driver.

I just don't see it being tenable to drag in the whole of the fc
transport class in a SCSI only configuration for fusion.

James

