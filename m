From: Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Medium errors
Date: Sat, 12 Apr 2003 18:09:29 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200304121809.29289.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sojef.skynet.be ([195.238.2.127]:64726 "EHLO sojef.skynet.be")
	by vger.kernel.org with ESMTP id S263324AbTDLP5g (for <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Apr 2003 11:57:36 -0400
Received: from 11.210-136-217.adsl.skynet.be (11.210-136-217.adsl.skynet.be [217.136.210.11])
        by sojef.skynet.be (8.12.9/8.12.9/Skynet-OUT-2.21) with ESMTP id h3CG9GcG020666
        for <linux-scsi@vger.kernel.org>; Sat, 12 Apr 2003 18:09:16 +0200
        (envelope-from <laurent.pinchart@skynet.be>)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi everybody,

I'm trying to read data from an audio CD. Some sectors are damaged and can't 
be read. The CIRC layer is not able to correct the errors. The CD unit 
reports a Medium Error / Unrecoved Read Error. This results in small cracks 
in the audio data, which are quite annoying.

To fix the problem, I tried to set the TB (Transfer Block) bit in the Error 
Recovery Parameters page (0x01), so that the unit would transfer the date 
before returning the CHECK CONDITION status.

Unfortunately, I don't get the data back. I had a look at cdrom_do_cmd in 
drivers/cdrom/cdrom.c, and found that the data is not copied back to 
userspace when an error occurs. I fixed that, but the data I get are random, 
and come from the host memory (content of recently opened files, ...).

I would like to know if the SCSI implementation (I'm using ide-scsi) has 
similar checks implemented that prevents returned data to be sent back to 
userspace when an error occurs. If so, could anyone point me to the place 
where those checks are implemented ?

Thanks in advance for your help.

Laurent Pinchart

