From: support@arkeia.com
Subject: [Incident 020905-000011] Re: blocksize limitations in scsi tape driver (st) when used withDLT1 tape drive
Date: Fri, 6 Sep 2002 01:44:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D786AEC.000001.22911@websc06.int.rightnowtech.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from websc06.int.rightnowtech.com (websc06.int.rightnowtech.com [192.168.100.146])
	by mailsc01.rightnowtech.com (8.9.3/8.9.3) with ESMTP id BAA21483
	for <linux-scsi@vger.kernel.org>; Fri, 6 Sep 2002 01:44:29 -0700
Received: from rntca01 (localhost.localdomain [127.0.0.1])
	by websc06.int.rightnowtech.com (8.9.3/8.9.3) with SMTP id BAA22915
	for <linux-scsi@vger.kernel.org>; Fri, 6 Sep 2002 01:44:29 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Recently you requested personal assistance from our on-line support
center. Below is a summary of your request and our response.
We will assume your issue has been resolved if we do not hear from you
within 7 days.
Thank you for allowing us to be of service to you.


Subject
---------------------------------------------------------------
Re: blocksize limitations in scsi tape driver (st) when used withDLT1 tape drive


Discussion Thread
---------------------------------------------------------------
Response (Richard) - 09/06/2002 01:44 AM
Hi,

is this mail really supposed to be for the Arkeia support team? I understand that this is about Arkeia but what is your exact problem?
As far as block size are concerned, you should set Arkeia to use 1024 bytes block size to use with LTO drives and use variable block size for others (eventually force the variable block size with AIT drives). If you use greater block size, it may seem to work in backups, but you'll eventually run into problems in restoration.

I hope it helps.

Best regards,

Customer (Linux-SCSI Mailingliste) - 09/05/2002 03:19 PM
Kai Makisara wrote:
> On Thu, 5 Sep 2002, Friedrich Lobenstock wrote:
> 
> 
>>Hi!
>>
>>I'm having an odd problem here. I use SuSE Linux 8.0 with kernel
>>2.4.18-64GB-SMP, arkeia as backup software and a Tandberg
>>VS80 (DLT1) streamer.
>>
>>After some trial and error I found out that I have to use a fixed block
>>size for DLT streamers (same applies to LTO ones). This document,
>>found at HP, tells you in details about which blocksize to use:
>>   http://www.hp.com/cposupport/information_storage/support_doc/lpg50167.html
>>
>>Now I told arkeia to use a blocksize of 65536, 32768 and 16384 and it
>>could not write to the tape. All I got in the log was:
>>
>>Sep  4 22:04:50 filesrv kernel: st: Unloaded.
>>Sep  4 22:08:40 filesrv kernel: st: Version 20020205, bufsize 32768, wrt 30720, max init. bufs 4, s/g segs 16
>>Sep  4 22:08:40 filesrv kernel: st0: Block limits 2 - 16777214 bytes.
>>Sep  4 22:08:41 filesrv kernel: st0: Incorrect block size.
>>Sep  4 22:08:45 filesrv kernel: st0: Write not multiple of tape block size.
> 
>                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> The write() byte count from Arkeia is not a multiple of the tape block
> size. If you use fixed block size, you must take care that this constraint
> is not violated. When you set the block size to 8192 or something that
> multiplies to 8192, this constraint is obeyed. If Arkeia sets the block
> size, I don't know why it does not obey the constraint. Seems to be an
> application problem.
> 
> In most cases, it is best to use variable block mode
> (i.e., mt setblk 0) and let the application to decide the tape block size.
> In order to have good efficiency, you should make sure that the
> application uses large enough byte counts in its write() calls, i.e., set
> the Arkeia block size to 65536.

Hmmm...I whish I could, but LTO and as it seems DLT drives too do not
cope well with variable block sizes.

All blocksizes greater than 8192 do make troubles. At and below this
value all is fine.


-- 
MfG / Regards
Friedrich Lobenstock


Question Reference #020905-000011
---------------------------------------------------------------
            Product: Arkeia
            Section: Drive
Contact Information: linux-scsi@vger.kernel.org
       Date Created: 09/05/2002 03:19 PM
       Last Updated: 09/06/2002 01:44 AM
             Status: Waiting
                 OS: 


If your issue remains unresolved, please update this question at
http://support.arkeia.com/cgi-bin/arkeia.cfg/php/enduser/acct_login.php?p_userid=linux-scsi@vger.kernel.org&p_next_page=myq_upd.php&p_refno=020905-000011&p_created=1031264393


You may also update this question by replying to this message. Because
your reply will be automatically processed, you MUST enter your reply
in the space below. Text entered into any other part of this message
will be discarded.
[===> Please enter your reply below this line <===]

[===> Please enter your reply above this line <===]


---------------------------------------------------------------


Richard VAN DEN BOOM
Knox Software Europe
"Publisher of Arkeia, Enterprise Network Backup"

