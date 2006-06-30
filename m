From: "Keith Baker" <krbaker@metacarta.com>
Subject: Re: MegaSAS Hang on Smart Query
Date: Fri, 30 Jun 2006 14:49:11 -0400 (EDT)
Message-ID: <2422.10.0.0.113.1151693351.squirrel@webmail.metacarta.com>
References: <3541.10.0.0.113.1151627385.squirrel@webmail.metacarta.com>
    <44A4947E.2090802@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from silene.metacarta.com ([65.77.47.18]:481 "EHLO
	silene.metacarta.com") by vger.kernel.org with ESMTP
	id S933021AbWF3StO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jun 2006 14:49:14 -0400
In-Reply-To: <44A4947E.2090802@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Ok, turns out the exact command being run was smartctl -H so I did this:

localhost:~# smartctl -H -r ioctl,3 /dev/sda
smartctl version 5.34 [i686-pc-linux-gnu] Copyright (C) 2002-5 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

 [inquiry: 12 00 00 00 24 00 ]
  scsi_status=0x0, host_status=0x0, driver_status=0x0
  info=0x0  duration=0 milliseconds
  Incoming data, len=36:
 00     00 00 05 02 5b 00 00 02  44 45 4c 4c 20 20 20 20
 10     50 45 52 43 20 35 2f 69  20 20 20 20 20 20 20 20
 20     31 2e 30 30
  status=0x0
 [log sense: 4d 00 40 00 00 00 00 00 04 00 ]
  scsi_status=0x2, host_status=0x0, driver_status=0x8
  info=0x1  duration=0 milliseconds
  Incoming data, len=4:
 00     00 00 05 02
  >>> Sense buffer, len=19:
 00     70 00 05 00 00 00 00 0b  00 00 00 00 20 00 00 00
 10     00 00 00
  status=2: sense_key=5 asc=20 ascq=0
Log Sense for supported pages failed [unsupported scsi opcode]
 [request sense: 03 00 00 00 12 00 ]
  scsi_status=0x0, host_status=0x0, driver_status=0x0
  info=0x0  duration=0 milliseconds
  Incoming data, len=18:
 00     70 00 00 00 00 00 00 0b  00 00 00 00 00 00 00 00
 10     00 00
  status=0x0
SMART Health Status: OK
localhost:~#


note that this command returned fine!

Then I try it again and it hangs at the inquery:
localhost:~# smartctl -H -r ioctl,3 /dev/sda
smartctl version 5.34 [i686-pc-linux-gnu] Copyright (C) 2002-5 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

 [inquiry: 12 00 00 00 24 00 ]

After a minute or so I then get this from dmesg:
sd 0:2:0:0: megasas: RESET -26412 cmd=12
megasas: [ 0]waiting for 7 commands to complete
megasas: [ 5]waiting for 7 commands to complete
megasas: [10]waiting for 7 commands to complete
MESSAGE REPEATED up to [175]
megasas: failed to do reset
sd 0:2:0:0: megasas: RESET -26412 cmd=12
megasas: cannot recover from previous reset failures
sd 0:2:0:0: megasas: RESET -26412 cmd=12
megasas: cannot recover from previous reset failures
sd 0:2:0:0: scsi: Device offlined - not ready after error recovery
sd 0:2:0:0: scsi: Device offlined - not ready after error recovery
sd 0:2:0:0: scsi: Device offlined - not ready after error recovery
sd 0:2:0:0: scsi: Device offlined - not ready after error recovery
sd 0:2:0:0: scsi: Device offlined - not ready after error recovery
sd 0:2:0:0: scsi: Device offlined - not ready after error recovery
sd 0:2:0:0: scsi: Device offlined - not ready after error recovery
sd 0:2:0:0: SCSI error: return code = 0x6000000
end_request: I/O error, dev sda, sector 32224045
Buffer I/O error on device sda3, logical block 3487820
lost page write due to I/O error on sda3
sd 0:2:0:0: SCSI error: return code = 0x6000000
end_request: I/O error, dev sda, sector 1063841686
Buffer I/O error on device sda7, logical block 76433411
lost page write due to I/O error on sda7
sd 0:2:0:0: SCSI error: return code = 0x6000000
end_request: I/O error, dev sda, sector 376122118
Buffer I/O error on device sda6, logical block 38470685
lost page write due to I/O error on sda6
sd 0:2:0:0: SCSI error: return code = 0x6000000
end_request: I/O error, dev sda, sector 376293934
Buffer I/O error on device sda6, logical block 38492162
lost page write due to I/O error on sda6
sd 0:2:0:0: SCSI error: return code = 0x6000000
end_request: I/O error, dev sda, sector 1063841694
Buffer I/O error on device sda7, logical block 76433412
lost page write due to I/O error on sda7
sd 0:2:0:0: SCSI error: return code = 0x6000000
end_request: I/O error, dev sda, sector 32420053
Buffer I/O error on device sda3, logical block 3512321
lost page write due to I/O error on sda3
sd 0:2:0:0: rejecting I/O to offline device
Buffer I/O error on device sda6, logical block 38487730
lost page write due to I/O error on sda6
sd 0:2:0:0: rejecting I/O to offline device
Buffer I/O error on device sda3, logical block 2950192
lost page write due to I/O error on sda3
sd 0:2:0:0: rejecting I/O to offline device
Buffer I/O error on device sda6, logical block 38487679
lost page write due to I/O error on sda6
sd 0:2:0:0: rejecting I/O to offline device
Buffer I/O error on device sda6, logical block 38487688
lost page write due to I/O error on sda6
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
Aborting journal on device sda3.
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
Aborting journal on device sda7.
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
__journal_remove_journal_head: freeing b_committed_data
__journal_remove_journal_head: freeing b_committed_data
ext3_abort called.
EXT3-fs error (device sda7): ext3_journal_start_sb: Detected aborted journal
Remounting filesystem read-only
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
Aborting journal on device sda6.
sd 0:2:0:0: rejecting I/O to offline device
__journal_remove_journal_head: freeing b_committed_data
journal commit I/O error
ext3_abort called.
EXT3-fs error (device sda6): ext3_journal_start_sb: Detected aborted journal
Remounting filesystem read-only
ext3_abort called.
EXT3-fs error (device sda3): ext3_journal_start_sb: Detected aborted journal
Remounting filesystem read-only
sd 0:2:0:0: rejecting I/O to offline device
printk: 11 messages suppressed.
Buffer I/O error on device sda3, logical block 0
lost page write due to I/O error on sda3
Buffer I/O error on device sda3, logical block 1
lost page write due to I/O error on sda3
sd 0:2:0:0: rejecting I/O to offline device
Buffer I/O error on device sda3, logical block 5
lost page write due to I/O error on sda3
sd 0:2:0:0: rejecting I/O to offline device
Buffer I/O error on device sda3, logical block 426021
lost page write due to I/O error on sda3
Buffer I/O error on device sda3, logical block 426022
lost page write due to I/O error on sda3
sd 0:2:0:0: rejecting I/O to offline device
Buffer I/O error on device sda3, logical block 426090
lost page write due to I/O error on sda3
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
REPEATED a few hundred times
printk: 128 messages suppressed.
Buffer I/O error on device sda6, logical block 38469634
lost page write due to I/O error on sda6
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device

Then I get this from smartctl:
  scsi_status=0x0, host_status=0x0, driver_status=0x6
  info=0x1  duration=234328 milliseconds
  Incoming data, len=36:
 00     50 05 a5 f5 80 a1 42 c0  00 00 00 00 00 00 00 00
 10     00 00 00 00 00 00 00 00  00 00 00 c0 0f a4 12 c0
 20     00 00 00 00
 [inquiry: 12 00 00 00 24 00 ]
  SCSI_IOCTL_SEND_COMMAND ioctl failed, errno=19 [No such device]
Standard Inquiry (36 bytes) failed [No such device]
Retrying with a 64 byte Standard Inquiry
 [inquiry: 12 00 00 00 40 00 ]
  SCSI_IOCTL_SEND_COMMAND ioctl failed, errno=19 [No such device]
Standard Inquiry (64 bytes) failed [No such device]
A mandatory SMART command failed: exiting. To continue, add one or more
'-T permissive' options.

then the kernel gets really unhappy and I get:
Message from syslogd@localhost at Fri Jun 30 14:37:31 2006 ...
localhost kernel: journal commit I/O error




> Keith Baker wrote:
>> I've been having a hang with 2.6.16.22 and the megasas driver.  I'm
>> pretty
>> sure it has to do with a smartctl -a <logical drive>.  The SCSI layer
>> gets
>> all sorts of in a twist.
>
> Keith,
> Could you add '-r ioctl,3' to the smartctl command line
> to get a full debug output. Then we can see which SCSI
> commands the megasas driver or hardware doesn't like.
>
>> megasas: waiting for 2 commands to complete
>> - repeats a bunch of times then -
>> sd 0:2:0:0: rejecting I/O to offline device
>>
>> Given a bit of wisdom in a driver distributed by dell which mentioned
>> the
>> controller not responding to a cache inqury...  isn't the correct thing
>> to
>> do respond with some sort of unsupported response?  not just ignore the
>> query?
>
> Correct. I'm sure the vendor knows what should be done.
>
>> I've hunted around for patches around this problem but haven't found
>> any,
>> of course "don't use smart against a logical drive" works, but I'm not
>> the
>> only one using these boxes and it does cause the system to go down.
>
> Doug Gilbert
>
>
>
>


-- 
Keith Baker

Systems Administrator

MetaCarta, Inc

350 Massachusetts Ave, 4th Floor

Cambridge, MA 02139 USA


Office: (617) 661-6382, ext. 527

email: keith.baker@metacarta.com

PGP Key: 0190570B


www.metacarta.com <http://www.metacarta.com>

