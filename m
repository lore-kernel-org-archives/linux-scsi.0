From: "Eric Raskin" <eraskin@paslists.com>
Subject: RE: How to disconnect a SCSI device without crashing SLES8?
Date: Fri, 4 Feb 2005 16:26:44 -0500
Message-ID: <15be01c50b00$3cb7c830$650aa8c0@ehrpc>
References: <267988DEACEC5A4D86D5FCD780313FBB041F82F3@exch-03.noida.hcltech.com>
Reply-To: <eraskin@paslists.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from paslists.com ([12.170.105.210]:1223 "EHLO fw.paslists.com")
	by vger.kernel.org with ESMTP id S264135AbVBDVZF convert rfc822-to-8bit
	(ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2005 16:25:05 -0500
Received: from ehrpc (ehrpc.paslists.com [192.168.10.101])
	by fw.paslists.com (8.12.8/8.12.8) with ESMTP id j14LOuo8002886
	for <Linux-scsi@vger.kernel.org>; Fri, 4 Feb 2005 16:25:05 -0500
In-Reply-To: <267988DEACEC5A4D86D5FCD780313FBB041F82F3@exch-03.noida.hcltech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-scsi@vger.kernel.org

Yes, that's true.  I went ahead and used the commands on 2.4.  They worked
just fine this time. :-)

The question about 2.6 was just for my own education -- for when I actually
get around to installing SLES9 on my production server.

Thanks to everyone for their help.

----------------------------------------------------------------------------
Eric H. Raskin                                          Voice: 914-765-0500
Professional Advertising Systems Inc.                   Fax:   914-765-0503
200 Business Park Dr Suite 107                          eraskin@paslists.com
Armonk, NY 10504


-----Original Message-----
From: Rajat Jain, Noida [mailto:rajatj@noida.hcltech.com] 
Sent: Friday, February 04, 2005 3:57 PM
To: eraskin@paslists.com; Linux-scsi@vger.kernel.org
Subject: RE: How to disconnect a SCSI device without crashing SLES8?



Linux 2.6 ????? Uhh .... I thought you did not wanted to REBOOT the
system???? 


The command syntax is same. Devices can be removed using the following
command:

echo "scsi remove-single-device <h> <b> <t> <l>" > /proc/scsi/scsi

where the variables are host, bus (channel), target (scsi id) and lun. 

But the removal will fail if the device is busy (e.g. if a file system on
the device is mounted). 


Rajat Jain 
HCL Technologies, 
A-11, Sector 16, Noida-201301. 
Ph: +91-120-2510701/702/813 Extn.3019 
rajatj@noida.hcltech.com 
http://www.hcltech.com/
	"...one of the main causes of the fall of the Roman Empire was that,
lacking zero, they had no way to indicate successful termination of their C
programs."
	Robert Firth 




-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Eric Raskin
Sent: Saturday, February 05, 2005 2:07 AM
To: Linux-scsi@vger.kernel.org
Subject: RE: How to disconnect a SCSI device without crashing SLES8?

Thanks, Christoph.  Would we use the same commands on 2.6?

----------------------------------------------------------------------------
Eric H. Raskin                                          Voice: 914-765-0500
Professional Advertising Systems Inc.                   Fax:   914-765-0503
200 Business Park Dr Suite 107                          eraskin@paslists.com
Armonk, NY 10504


-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org]
Sent: Friday, February 04, 2005 3:25 PM
To: Eric Raskin
Cc: Linux-scsi@vger.kernel.org
Subject: Re: How to disconnect a SCSI device without crashing SLES8?

On Fri, Feb 04, 2005 at 02:12:13PM -0500, Eric Raskin wrote:
> In searching the web, I've found the "remove-scsi-device" and 
> "add-scsi-device" commands that can be sent to /proc/scsi/scsi.
> 
> Does anybody know if the system will stay up if I use these commands 
> to remove all my tape library devices before shutting it down?  Is 
> this the proper way to repair my library without having to shut the system
off?

remove-scsi-device could work, but in Linux 2.4 it's racy.

If you want to remove and add devices at runtime safely you'll have to
update to Linux 2.6.


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html


