From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [ANNOUNCE] sdparm 0.90
Date: Tue, 19 Apr 2005 10:42:16 +1000
Message-ID: <426453E8.4040009@torque.net>
References: <4263B56B.2010905@torque.net> <20050418195245.GV30729@vanheusden.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:39377 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261393AbVDSILx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 04:11:53 -0400
In-Reply-To: <20050418195245.GV30729@vanheusden.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: folkert@vanheusden.com
Cc: linux-scsi@vger.kernel.org

folkert@vanheusden.com wrote:
> oh wait, 2.6 yes?

In lk 2.4 you get to use sg device nodes as noted in
the man page ;-) sg_map (in sg3_utils) will show the
mapping.

If sdparm is popular I could add a SCSI_IOCTL_SEND_COMMAND
interface for lk 2.4 as a fall back. Alternatively sdparm
could internally iterate like sginfo does (in sg3_utils)
to find the mapping to a sg device node.

Doug Gilbert

> then forget my bugreport (running 2.4.26-NANO)
> 
> On Mon, Apr 18, 2005 at 11:26:03PM +1000, Douglas Gilbert wrote:
> 
>>sdparm is a new command line utility designed to get and set
>>SCSI disk parameters (cf hdparm for ATA disks). More generally
>>it gets and sets mode page information on SCSI devices or devices
>>that use a SCSI command set (e.g. CD/DVD drives (any transport)
>>and SCSI tape drives).
>>
>>The elements within mode pages are addressed via acronyms
>>(e.g. "WCE" for "write cache enable" in the caching mode
>>page). There is also numeric addressing of the form:
>><start_byte>:<start_bit>:<num_bits>
>>This symbolic or numeric addressing should be more
>>convenient for changing parameters than the techniques used
>>by scsiinfo, sginfo and sg_wr_mode.
>>
>>A GUI wrapping sdparm would be a useful extension.
>>It could show the mode page as found in the standard or
>>the vendor's product manual with attributes such as
>>"changeable" represented by colour or shading.
>>
>>I hope to add VPD pages in the future. sdparm shares some
>>code with sg3_utils but is currently independent; they may
>>share a library (libsgutils) in the future.
>>
>>A tarball, rpms and a "deb" can be found on
>>http://www.torque.net/sg .
>>Currently, the most complete documentation is in the
>>man page.
>>
>>
>>Examples (taken from the man page):
>>To list the common (mode) parameters of a disk:
>>
>>    sdparm /dev/sda
>>
>>To see all parameters for the caching control mode page:
>>
>>    sdparm --page=ca /dev/sda
>>
>>To get the WCE values (current changeable default and
>>saved) in hex:
>>
>>    sdparm -g WCE -H /dev/sda
>>  0x01 0x00 0x01 0x01
>>
>>To get the WCE current value in hex:
>>
>>    sdparm -g WCE=1 -H /dev/sda
>>  0x01
>>
>>To set the "write cache enable" bit in the current page:
>>
>>    sdparm --set=WCE /dev/sda
>>
>>To set the "write cache enable" bit in the current and
>>saved page:
>>
>>    sdparm --set=WCE --save /dev/sda
>>
>>To set the "write cache enable" and clear "read cache
>>disable":
>>
>>    sdparm --set=WCE --clear=RCD --save /dev/sda
>>
>>The previous example can also by written as:
>>
>>    sdparm -s WCE=1,RCD=0 -S /dev/sda
>>
>>To re-establish the manufacturer?s defaults in the
>>current and saved caching control mode page:
>>
>>    sdparm --page=ca --defaults -save /dev/sda
>>
>>If an ATAPI cd/dvd player is at /dev/hdc then its common
>>(mode) parameters could be listed with:
>>
>>          sdparm /dev/hdc
>>
>>
>>Comments, suggestions and patches welcome.
>>
>>
>>Doug Gilbert
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> Folkert van Heusden
> 

