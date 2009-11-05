From: John Hughes <john@Calva.COM>
Subject: Re: ses enclosure stuff not working with Promise Vtrak J610S JBOD
Date: Thu, 05 Nov 2009 10:41:22 +0100
Message-ID: <4AF29DC2.2070803@Calva.COM>
References: <4AF17AD3.6060909@Calva.COM>	 <1257348128.2697.29.camel@mulgrave.site>  <4AF1A38E.3000009@Calva.COM>	 <1257350834.2697.52.camel@mulgrave.site>  <4AF1A7E7.7070307@Calva.COM> <1257351654.2697.55.camel@mulgrave.site> <4AF1C172.6080509@Calva.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oceanic.CalvaEDI.COM ([81.252.197.184]:47977 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZKEJlX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2009 04:41:23 -0500
In-Reply-To: <4AF1C172.6080509@Calva.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Hughes <john@Calva.COM>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

John Hughes wrote:
> With the following patch I get the "device" directories in the 
> enclosure bay directories, even for the SATA drive.  (Maybe this is 
> because the SATA drive is behind a so-called "aamux" device).
>
> I also find the "enclosure_device:xxx" link in the 
> /sys/block/sdxx/device directory
One problem with the patch is that, since I don't have a page 7 (bay 
names) it's using the "enclosure component index" as the name, and that 
(at least for me) seems to be an index starting from zero, where my bays 
are numbered from one.

sg_ses shows a "bay number", I think I'll try to make the patch look for 
the bay number and make the name something like "bay-nn" if there is a 
bay number.


# sg_ses -p 10 /dev/sg32
 PROMISE   3U-SAS-16-D BP    0107
    enclosure services device
Additional (device) element status diagnostic page:
  generation code: 0x0
  Element type: Array device, subenclosure id: 0
    element index: 0 [0x0]
    Transport protocol: SAS
    number of phys: 1, not all phys: 1, bay number: 1
[...]


