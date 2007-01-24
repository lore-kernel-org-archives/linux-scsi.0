From: Aboo Valappil <aboo@aboo.org>
Subject: Re: Linux Virtual SCSI HBAs and Virtual disks
Date: Wed, 24 Jan 2007 20:40:33 +1100
Message-ID: <45B72991.40403@aboo.org>
References: <1e157f74d8578f24c762571c1016aab3@aboo.org> <b43c8fc9882e65d397a6465e6cb7c998@aboo.org> <45B4EAAC.5000008@s5r6.in-berlin.de> <45B60993.9070508@aboo.org> <45B6D18A.8000607@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppp245-155.static.internode.on.net ([59.167.245.155]:42867 "EHLO
	goobu.aboo.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750723AbXAXJk5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jan 2007 04:40:57 -0500
In-Reply-To: <45B6D18A.8000607@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Aboo Valappil wrote:
>   
>> Hi Stefan Richter,
>>
>> Thanks everyone for their advice on this. As per your advice, I did the
>> following when the last user space target serving the scsi_host quits,
>> the queue command will do the following on the new commands coming through.
>>
>>                sc->result = DID_NO_CONNECT << 16;
>>                sc->resid = sc->request_bufflen;
>>                set_sensedata_commfailure(sc);  ---------------------
>> This sets the sense buffer with Device Not ready/Logical Unit
>> Commincation failure.
>>                done(sc);
>>
>> The scsi_host will remain in the kernel. Let the EH thread handle the
>> queued commands (If any). If the user target wants to reconnects to the
>> same scsi_host, it can do so (Just re-run the user space target again
>> with same command line paramters).  This connection from newly started
>> target will make the HBA healthy again and start serving IO.
>>
>> I implemented a new IOCTL to remove  this  scsi_host  if the user
>> process really needs to.  This removal  will first  finish all the SCSI
>> commands (With the above status results) queued on the scsi_host  (If at
>> all) and then remove the scsi_host.  Also the module unload will delete
>> all the scsi_hosts created after finishing all the commands queued with
>> the above status and sense information.
>>
>> I also implemented passing of sense code information from user space to
>> sense_buffer. A little more work needs to be done on this.
>> Also, I need to make sure that all the locking used inside is correctly
>> implemented to prevent dead locks and improve efficiency.
>>
>> The new version is available http://vscsihba.aboo.org/vscsihbav204.gz
>>     
>
> A few observations from testing this version:
>
> # ./start_target.sh id=3 -files ../../zz_lun0 -v
> # lsscsi
> [0:0:0:0]    disk    Linux    scsi_debug       0004  /dev/sda
> [1:0:0:0]    disk    VirtualH VHD              0     /dev/sdb
>
> So "id=3" doesn't look the target identifier. If not, what
> is it?
>   

This is just an identification for the scsi_host created inside the 
kernel. If you re-run the same command again with same id, the new 
process would attach to the same scsi_host. This can be seen as two user 
process serving the same virtual host bus adapter.  If use a different 
id with the same lun file, It will create a new scsi_host and it would 
appear as the same LUN on a different host bus adapter.
.
It is not the target.
> Here is an attempt to fetch the Read Write Error Recovery
> mode page:
> # sdparm -p rw -vv /dev/sg1
>     inquiry cdb: 12 00 00 00 24 00
>     /dev/sg1: VirtualH  VHD               0
>     mode sense (10) cdb: 5a 00 01 00 00 00 00 00 08 00
> mode sense (10): Probably uninitialized data.
>   Try to view as SCSI-1 non-extended sense:
>   AdValid=0  Error class=0  Error code=0
>
>   
>>> Read write error recovery mode page [0x1] failed
>>>       
>
>
> That implies a sense buffer full of zeroes. The debug
> output from start_target.sh associated with that attempt:
>
> SCSI cmd Lun=00 id=2D CDB=12 00 00 00 24 00 00 00 08 00 00 00 00 00 00 00
> SCSI cmd Lun=00 id=2D completed, status=0
> SCSI cmd Lun=00 id=2E CDB=5A 00 01 00 00 00 00 00 08 00 00 00 00 00 00 00
> SCSI cmd Lun=00 id=2E completed, status=2
> SCSI cmd Lun=00 id=2F CDB=03 00 00 00 FC 00 00 00 08 00 00 00 00 00 00 00
> SCSI cmd Lun=00 id=2F completed, status=0
> SCSI cmd Lun=00 id=30 CDB=00 00 00 00 00 00 00 00 08 00 00 00 00 00 00 00
> SCSI cmd Lun=00 id=30 completed, status=0
>
> So that is an INQUIRY [expected], MODE SENSE(10) [expected],
> REQUEST SENSE [what, no autosense??] and TEST UNIT READY
> [ah oh, error recovery??] sequence.
>
> Perhaps you could examine the way scsi_debug (or most
> other LLDs) does autosense. This modern technique (used
> for about the last 12 years) relieves the scsi midlevel
> of having to send a follow up REQUEST SENSE.
>   
I shall look in the sdebug and see how it handles the Auto sense. What 
is the scsi target does not give any sense informationx with a non zero 
SCSI response?
Can I just make one up? I have modified it to give a sense of  SK=06 
(Illegal request), ASC=20(Invalid command Op code). May be looking at 
the sdebug may give an idea.
> It would be easier to read those SCSI commands in the
> debug output if they were trimmed to their actual lengths
> (e.g. the INQUIRY is 12 00 00 00 24 00).
>   
I will make it look better.
> Doug Gilbert
>   

