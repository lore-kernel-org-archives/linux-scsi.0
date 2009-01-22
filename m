From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: qla2xxx 0000:03:0c.0: Firmware image unavailable
Date: Thu, 22 Jan 2009 08:20:48 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF45CEAB586@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF45CEAB550@cosmail01.lsi.com>
 <D4B83214B57CAC4499F1114D069E451A01A7D6FA@bunker.inside.abhaisystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:53825 "EHLO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbZAVPUy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jan 2009 10:20:54 -0500
In-Reply-To: <D4B83214B57CAC4499F1114D069E451A01A7D6FA@bunker.inside.abhaisystems.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sudhakar Pannerselvam <sudhakarp@inmage.net>, Seokmann Ju <seokmann.ju@qlogic.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>


You are right. Looks like qlogic driver loads even before udev hotplug is functional.  Driver loads successfully when I re-load the driver after the system in up.  Is there any solution or work-around for this problem?

Thanks
Babu Moger 

-----Original Message-----
From: Sudhakar Pannerselvam [mailto:sudhakarp@inmage.net] 
Sent: Thursday, January 22, 2009 8:40 AM
To: Moger, Babu; Seokmann Ju
Cc: linux-scsi@vger.kernel.org; device-mapper development
Subject: RE: qla2xxx 0000:03:0c.0: Firmware image unavailable

Firmware is loaded through udev hotplug interface i.e using
request_firmware(). Can you verify if udev hotplug is functional in your
setup.

To reproduce this in my local setup, I have kill'ed udevd daemon and
loaded qlogic module which failed with firmware unavailable message. 

Regards,
Sudhakar

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Moger, Babu
> Sent: Thursday, January 22, 2009 7:44 PM
> To: Seokmann Ju
> Cc: linux-scsi@vger.kernel.org; device-mapper development
> Subject: RE: qla2xxx 0000:03:0c.0: Firmware image unavailable
> 
> Yes, the naming conventions look good. Here is the output of ls
> 
> -rw-r--r-- 1 root root  76802 Jan 21 16:41 ql2100_fw.bin
> -rw-r--r-- 1 root root  84566 Jan 21 16:41 ql2200_fw.bin
> -rw-r--r-- 1 root root 125088 Jan 21 16:41 ql2300_fw.bin
> -rw-r--r-- 1 root root 135896 Jan 21 16:41 ql2322_fw.bin
> -rw-r--r-- 1 root root 228056 Jan 21 16:41 ql2400_fw.bin
> -rw-r--r-- 1 root root 239052 Jan 21 16:41 ql2400_fw.bin_mid
> -rw-r--r-- 1 root root 200064 Jan 21 16:41 ql2500_fw.bin
> -rw-r--r-- 1 root root 219924 Jan 21 16:41 ql2500_fw.bin_mid
> 
> Thanks
> Babu Moger 
> 
> -----Original Message-----
> From: Seokmann Ju [mailto:seokmann.ju@qlogic.com]
> Sent: Wednesday, January 21, 2009 6:26 PM
> To: Moger, Babu
> Cc: linux-scsi@vger.kernel.org; device-mapper development
> Subject: Re: qla2xxx 0000:03:0c.0: Firmware image unavailable
> 
> 
> On Jan 21, 2009, at 4:00 PM, Moger, Babu wrote:
> 
> > Hi All,
> > Have you guys seen this following error?
> >
> > Jan 21 16:30:44 txmpp2 kernel: qla2xxx 0000:03:0c.0: 
> Firmware image  
> > unavailable.
> > Jan 21 16:30:44 txmpp2 kernel: qla2xxx 0000:03:0c.0: 
> Firmware images  
> > can be retrieved from: 
> ftp://ftp.qlogic.com/outgoing/linux/firmware/.
> >
> > After this error, qlogic driver fails to detect the LUNs attached.
> >
> > I am running 2.6.29-rc2 kernel on x86_64 machine.
> >
> > I tried couple of things without any success. I downloaded all the  
> > qlogic firmwares available and kept it in /lib/firmware. Tried  
> > rebuilding the kernel. Did not help. Thanks in advance.
> Could you double check that those firmware binaries under /lib/ 
> firmware have correct naming convention as defined in qla_os.c:  
> FW_FILE_ISP2XXX?
> 
> >
> >
> >
> > Thanks
> > Babu Moger
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux- 
> > scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
