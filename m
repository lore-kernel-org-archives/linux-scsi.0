From: Mark Hounschell <dmarkh@cfl.rr.com>
Subject: Re: [Bug 16058] [BUG] Cannot boot any kernel from 2.6.27 on if a
 256 byte sector SCSI disk is attached
Date: Mon, 31 May 2010 11:17:57 -0400
Message-ID: <4C03D325.5060909@cfl.rr.com>
References: <bug-16058-11613@https.bugzilla.kernel.org/>	 <201005281634.o4SGYU6M015956@demeter.kernel.org>	 <4C001999.1010703@cfl.rr.com> <1275078334.4479.31.camel@mulgrave.site>	 <4C025132.3000502@cfl.rr.com>  <4C039CC0.2050502@cfl.rr.com> <1275314561.2823.6.camel@mulgrave.site>
Reply-To: dmarkh@cfl.rr.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:40158 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab0EaPSA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2010 11:18:00 -0400
In-Reply-To: <1275314561.2823.6.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On 05/31/2010 10:02 AM, James Bottomley wrote:
> On Mon, 2010-05-31 at 07:25 -0400, Mark Hounschell wrote:
>   
>> On 05/30/2010 07:51 AM, Mark Hounschell wrote:
>>     
>>> On 05/28/2010 04:25 PM, James Bottomley wrote:
>>>   
>>>       
>>>> On Fri, 2010-05-28 at 15:29 -0400, Mark Hounschell wrote:
>>>>   
>>>>     
>>>>         
>>>>> On 05/28/2010 12:34 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
>>>>>     
>>>>>       
>>>>>           
>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=16058
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> --- Comment #6 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-05-28 16:34:28 ---
>>>>>> Reply-To: James.Bottomley@suse.de
>>>>>>
>>>>>> On Fri, 2010-05-28 at 10:58 -0400, Alan Stern wrote:
>>>>>>   
>>>>>>       
>>>>>>         
>>>>>>             
>>>>>>> On Fri, 28 May 2010, Mark Hounschell wrote:
>>>>>>>
>>>>>>>     
>>>>>>>         
>>>>>>>           
>>>>>>>               
>>>>>>>> First READ(10):
>>>>>>>>
>>>>>>>>  sde:
>>>>>>>> ahc_calc_residual: Entered
>>>>>>>> ahc_calc_residual: return Case 5-1 resid = 0x800
>>>>>>>> ahc_calc_residual: return Case 5-2 resid = 0x800
>>>>>>>>
>>>>>>>> scsi_finish_command: Entered for cmd(10):0x28 0x00 0x00 0x00 0x00 0x00
>>>>>>>> 0x00 0x00 0x08 0x00
>>>>>>>> cmd->result = 0x00000000
>>>>>>>> good_bytes == old_good_bytes = 0x800  scsi_get_resid(cmd) = 0x800
>>>>>>>> New good_bytes = 0x0
>>>>>>>> scsi_finish_command: Complete
>>>>>>>>
>>>>>>>> From here it just keeps repeating this read of 8 blocks. (2048 bytes) so
>>>>>>>> it looks like the machine is hung.
>>>>>>>>       
>>>>>>>>           
>>>>>>>>             
>>>>>>>>                 
>>>>>>> Probably not hung, just doing a lot of retries.  It should time out 
>>>>>>> eventually, but it might take a long time (perhaps as long as 15 
>>>>>>> minutes).  The combination of the block layer and the SCSI layer isn't 
>>>>>>> very good at knowing when to give up.
>>>>>>>     
>>>>>>>         
>>>>>>>           
>>>>>>>               
>>>>>> Actually, I think this is a partition read.  Each partition manager
>>>>>> tends to read a page through the page cache.  If we get an error, we
>>>>>> seem to re-read to fill the cache.
>>>>>>
>>>>>>   
>>>>>>       
>>>>>>         
>>>>>>             
>>>>>>>> Now, I know for a fact that _if_ this read CDB is actually being sent to
>>>>>>>> the drive, it's actual residual count will be zero. These are working
>>>>>>>> disks and that read CDB is valid.
>>>>>>>>
>>>>>>>> Why is ahc_calc_residual saying that the residual count is as though the
>>>>>>>> read never took place? I noticed that the first read on all the SATA
>>>>>>>> drives was for 4096 bytes, why is this one only 2048? Should it have
>>>>>>>> been 4096 and ahc_calc_residual assume that?
>>>>>>>>       
>>>>>>>>           
>>>>>>>>             
>>>>>>>>                 
>>>>>>> I don't know the answer to any of these questions.  They could well be
>>>>>>> due to bugs in the driver, and I know nothing about how the aic7xxx
>>>>>>> driver works.  You should talk to someone who does.
>>>>>>>     
>>>>>>>         
>>>>>>>           
>>>>>>>               
>>>>>> I'll take this one ... although we're a bit lacking in documentation for
>>>>>> this driver.
>>>>>>
>>>>>> I think the 2048 is because something is hardcoded to think 8 sectors is
>>>>>> a page.
>>>>>>
>>>>>> James
>>>>>>
>>>>>>   
>>>>>>       
>>>>>>         
>>>>>>             
>>>>> Your probably right. But is a 256 byte sector really a supported sector
>>>>> size for a linux fs on a SCSI disk?
>>>>>     
>>>>>       
>>>>>           
>>>> In theory the block layer can support any power of two sector size (or
>>>> really any sector size which is a divisor of the page size).  We had a
>>>> use for 256 byte sectors once, so they're in SCSI.  In practice, since
>>>> they're so rare, the code paths are never tested (as you found out) and
>>>> there's a more annoying problem which is since the linux base sector
>>>> size is 512, you have to multiply to get from 256 to 512 ... for all
>>>> other sector sizes you have to divide, so any conversion routine that
>>>> only right shifts would get this wrong.
>>>>
>>>>   
>>>>     
>>>>         
>>> from the fdisk man page:
>>>
>>>        -b sectorsize   Specify  the  sector  size  of the disk. Valid
>>> values are 512, 1024, 2048 or 4096.  (Recent kernels know the sector
>>> size. Use this only on old kernels or to override the kernel's ideas.)
>>>
>>> So how does one create a linux fs on a 256 byte sectored disk?
>>>
>>>   
>>>       
>>>>>  When it sees a 768 byte sector disk,
>>>>> it says it's an unsupported size and goes on with the boot process
>>>>> without even doing a read for a partition table.
>>>>>     
>>>>>       
>>>>>           
>>>> that's because 768 isn't a power of 2, so it's completely unsupportable.
>>>>
>>>>   
>>>>     
>>>>         
>>>>>  Should maybe it be
>>>>> doing the same for a 256 byte sector disk???
>>>>>     
>>>>>       
>>>>>           
>>>> Possibly ... I don't know what the 256 byte sector support was for ...
>>>> all I know is that whatever it was, I don't have one.
>>>>
>>>>   
>>>>     
>>>>         
>>> Back in the old days, almost any scsi disk could be formatted with a 256
>>> byte sector. At one time it probably made since to support it. But try
>>> to find one that supports that sector size today.
>>>
>>> In any case, if you can't even partition a 256 byte sector scsi disk in
>>> linux, why would the kernel still claim it supports that format?
>>>
>>>   
>>>       
>> In fact, the attached patch works for me. However, if you wish to pursue
>> functional 256 byte sector support, I have plenty of these disks and
>> will be happy to test what ever you come up with.
>>     
> Um, well, since you've got a lot of them that does rather argue against
> their being obsolete ...
>
>   

Except I would  _never_  attempt to use any of them for an actual Linux
fs. If I did, and again I wouldn't, it would be after formatting them
with a 512 byte sector.  Way too slow and small. We only provide support
for them in an emulation of an old RTOS called MPX-32 using the sg_io
interface.

>>  Not a lot I can really
>> do without fdisk support though. Even so, I'm all ears???
>>     
> fdisk is only the dos label ... there's a lot you can't do with a dos
> label.  I think parted will allow you to write a label that will work.
>
> I've got scsi_debug patched to work with 256 byte sectors.  It actually
> looks like this has nothing to do with the residue.  What I see is a
> hang because block is trying to do a zero sized read.  I suspect
> something is trying to do a single sector read, which is impossible
> since the linux native sector size is 512 and it's getting rounded down.
>
> This might, of course, argue that block cannot now support 256 sector
> devices and so they need to be deprecated ... I'll see.
>
> James
>
>
>
>   

