From: "Ravi Anand" <ravi.anand@qlogic.com>
Subject: RE: fast detection of  loss of FC connectivity?
Date: Thu, 3 Apr 2003 11:33:58 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3679966B84813344B908D418BA3F6A4AA84114@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:41360 "EHLO AVEXCH01.qlogic.org")
	by vger.kernel.org with ESMTP id S263515AbTDCTWI convert rfc822-to-8bit
	(for <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2003 14:22:08 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: devnetfs <devnetfs@yahoo.com>, linux-scsi@vger.kernel.org

Hi,

 I dont know which driver version you are using,but in v6.x driver there is a command line parm  qlport_down_retry parm which you can pass to the driver at load time.Set this param to one, for ex:

# insmod qla2300.o qlport_down_retry=1  

The net effect of this will be that as soon as the LOOP goes DOWN on any HBA your tur command will be returned immediately with error instaed of waiting for long.

Hope this helps.

Ravi

-----Original Message-----
From: devnetfs [mailto:devnetfs@yahoo.com]
Sent: Thursday, April 03, 2003 9:16 AM
To: linux-scsi@vger.kernel.org
Subject: fast detection of loss of FC connectivity?


Hi,

In a SAN setup is it possible to quickly detect that a FC cable
has been plugged out of the card? Presently the way I do is send
a SCSI-2 TUR cmd to the device (periodically) and check if the 
device is reachable.

When the cable is pulled out, TUR fails indicating some problem. But
TUR command takes a LONG time to complete before returning an error.
This time is more than 8-10secs :( Thats too slow. 

I noticed that as soon as I pull the cable I get a LOOP DOWN message
on the console (its a qlogic card, qla2x00 driver). Is there a 
generic flag in the scsi-midlayer (part of Scsi_Host) that would
let me know that has happend -- hence quickly determine loss of
connectivity. 

I looked at the qlogic source and they have a loop_state field in 
scsi_qla_host, but then thats specific to a particular card.

Is there a generic way to QUICKLY detect such loss of connectivity,
in a FC setup?

Any ideas/suggestions are welcome :)

Thanks
A.


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
