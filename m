From: Jeremy Linton <jlinton@greshamstorage.com>
Subject: Re: Bad emulex/linux FC error handing behavior
Date: Thu, 28 May 2009 04:36:58 -0500
Message-ID: <4A1E5B3A.1070202@greshamstorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gatekeeper.greshamstorage.com ([12.166.178.178]:37781 "EHLO
	AUSEXCH1.greshamstorage.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751477AbZE1Jgx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 May 2009 05:36:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi <linux-scsi@vger.kernel.org>, james.smart@emulex.com

James Smart wrote:
 > However, the question in my mind is - why did you get to bus reset ?
	Because the device is having intermittent problems? The whole error handler sequence fails (tur failures, etc), and it 
ends up marking the device off-line. In the process it shoots everything else in the head. This is the behavior i'm 
having a problem with. I don't really care about the state of the failing device, it is having a physical problem. My 
problem is the remainder of the shared devices which are having their activities interrupted. In many cases, those other 
machines/devices many not even have visibility to the failing device. It becomes a serious error isolation problem. From 
the perspective of other hosts, the only way to track the error down is to actually have an analyzer attached to the 
interrupted devices. Assuming it reproduces, the analyzer can then detect the reset and identify the source port it 
originated from. That machine may then be removed from the SAN. This whole process can be nearly impossible to perform 
at a customer's site.


 >The reason for the behavior is to replicate the parallel scsi behavior,
 >which is expected/required by many people.

	I'm confused by this. For parallel SCSI, there were device dependencies due to the physical bus. The bus reset was 
standard error handing because a bad/failing SCSI device often put the bus in a unrecoverable state for the remainder of 
the devices. SPI also rarely had multiple initiators sharing devices.
	I was unaware of how big the "hammer" lpfc tends to use against the SAN when a device fails. I suspect that I'm not the 
only one. Is there are way to simulate the SPI behavior(?), short of actually resetting all attached devices? For that 
matter, I'm a little confused what exactly the intended behavior is. Can you enlighten me? I could understand if it was 
just resetting all luns on a particular device, but its resetting all attached devices.


 > We can certainly discuss adding a parameter that
 > controls the behavior, but this should be on a transport basis, not on
 > an adapter-specific manner.

	Thats a great plan. To me it makes sense that this behavior should be transport dependent, I would want it for SPI, but 
not for FC or iSCSI. How likely is that to be accepted? The SCSI error hander seem to be completely transport 
independent. Initially, I targeted the emulex driver because the qlogic already has a way to disable the behavior, and 
the LSI driver doesn't appear to support this behavior at all.


