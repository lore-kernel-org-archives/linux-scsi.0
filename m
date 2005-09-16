From: James.Smart@Emulex.Com
Subject: RE: [PATCH] change port speed definitions for scsi_transport_fc
Date: Fri, 16 Sep 2005 09:32:31 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A9B@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:60917 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932090AbVIPNco convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2005 09:32:44 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aherrman@de.ibm.com, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Andreas,

The change is fine. To be honest, there's no reason for the implementation to
follow any definition/standard at all - it can be whatever makes sense for
the actual code. The sysfs abstraction to text is really nice in this respect
as:
- Text is human readable (I don't have to know about a standard to decode
  the value).
- The implementation within the kernel/driver/transport is ultimately
  hidden from user space.
- If there's a library which must present a particular definition, it
  generically converts the sysfs response.

However, I agree with your sentiment. If we're picking a definition for a
transport, the choice should be made based on the following order:
- There is an overriding implementation gain by an alternate definition
- Follow any transport standard definition
- Follow any management standard definition
- <doesn't matter>

-- james


> -----Original Message-----
> From: Andreas Herrmann [mailto:aherrman@de.ibm.com]
> Sent: Friday, September 16, 2005 5:01 AM
> To: James Bottomley; Smart, James
> Cc: Linux SCSI
> Subject: [PATCH] change port speed definitions for scsi_transport_fc
> 
> 
> Hi,
> 
> obviously FC Port Speeds in scsi_transport_fc.h are defined according
> to FC-HBA:
> 
> #define FC_PORTSPEED_1GBIT              1
> #define FC_PORTSPEED_2GBIT              2
> #define FC_PORTSPEED_10GBIT             4
> #define FC_PORTSPEED_4GBIT              8
> 
> Problem is, whoever invented FC-HBA did not care about FC-FS or
> FC-GS-x. Following FC-FS/FC-GS-x defintions of port speeds would look
> like:
> 
> 1 GBit: 0x0001
> 2 GBit: 0x0002
> 4 GBit: 0x0004
> 10GBit: 0x0008
> 
> (and new in FC-LS:
> 8 Gbit: 0x0010
> 16GBit: 0x0020)
> 
> I really appreciate if scsi_transport_fc.h would define port speeds
> according to FC-GS-x/FC-FS. Thus mapping of port speed capabilities to
> values defined in scsi_transport_fc.h can be avoided in the LLDD.
> 
> Attached is a patch to change the definitions.
> 
> 
> Regards,
> 
> Andreas
> 
> --- linux-2.6.14-rcx/include/scsi/scsi_transport_fc.h.orig	
> 2005-09-16 10:49:44.000000000 +0200
> +++ linux-2.6.14-rcx/include/scsi/scsi_transport_fc.h	
> 2005-09-16 10:50:03.000000000 +0200
> @@ -103,8 +103,8 @@ enum fc_port_state {
>  					     incapable of reporting */
>  #define FC_PORTSPEED_1GBIT		1
>  #define FC_PORTSPEED_2GBIT		2
> -#define FC_PORTSPEED_10GBIT		4
> -#define FC_PORTSPEED_4GBIT		8
> +#define FC_PORTSPEED_4GBIT		4
> +#define FC_PORTSPEED_10GBIT		8
>  #define FC_PORTSPEED_NOT_NEGOTIATED	(1 << 15) /* Speed not 
> established */
>  
>  /*
> 
