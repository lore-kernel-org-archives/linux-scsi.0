From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [patch 6/8] mptfusion: fc transport
Date: Wed, 1 Dec 2004 12:46:06 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C667C7D@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:4791 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261425AbULATqP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Dec 2004 14:46:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thursday, November 25, 2004 1:55 PM, James Bottomley wrote:
> On Fri, 2004-11-19 at 09:39, Moore, Eric Dean wrote:
> > This provides fc_transport support, exporting
> > port_id, port_name, node_name.
> 
> This:
> 
> @@ -4,6 +4,7 @@
>  config FUSION
>         tristate "Fusion MPT (base + ScsiHost) drivers"
>         depends on PCI && SCSI
> +        select SCSI_FC_ATTRS
>         ---help---
> 
> Doesn't look correct.  It will force the FC attrs to be built even if
> you're only building for a purely SPI device.  Worse, module
> dependencies will force the FC transport to load even if you're only
> attaching to a SCSI device.  This isn't really optimal, especially as
> the FC transport class is growing in size now.
> 
> How difficult would it be to separate out the scsi and FC 
> pieces of the
> fusion driver, so we could allow more fined grained control of this?
> 

 
This driver is four separate driver modules { mptbase, mptscsih, mptlan,
mptctl },
with FC and SCSI spread through out, and SAS waiting in the wings.
In this current design, separating FC is not going to be an easy task,
as well as dealing with SAS because I'm sure people would want that
separated as well.  
Device recognization done from mptbase, as well as unique
configuration/initialization
for respective bus type, and messaging interface from the other drivers
(mptscsih,
mptlan, and mptctl) to the firmware.  The scsi interface layer is in
mptscsih, 
and is where this fc transports and our spi domain validation is done
currently. 

What do you have in mind in seperating this code for each (3) different bus
classes from 
each these (4) drivers?  

Eric


