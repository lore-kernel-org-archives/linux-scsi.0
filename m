From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/2] some block and scsi layer additions for ULD scatterlist
 code
Date: Tue, 06 Dec 2005 20:03:16 -0600
Message-ID: <439642E4.8060508@cs.wisc.edu>
References: <1133771825.23619.16.camel@max> <ee0ae26a0512061717q49dcb6c3h@mail.gmail.com> <43963FAF.7090304@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50826 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S964852AbVLGCDa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2005 21:03:30 -0500
In-Reply-To: <43963FAF.7090304@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yanggun <yang.geum.seok@gmail.com>
Cc: axboe@suse.de, Linux SCSI list <linux-scsi@vger.kernel.org>

Mike Christie wrote:
> Yanggun wrote:
> 
>> Hi,
>>
>> i am currently using linux kernel version 2.6.15-rc5 on x86 with Promise
>> SATAII150 TX2Plus(250G SATA HDD Disk x 2).
>>
>> But, SATA HDD disk does not become. program execute result of "fdisk
>> /dev/sda" is  "Unable to read /dev/sda".
>>
>> Work well in linux kernel version 2.6.13.2.
>>
>> Do not act below since change as result that do debugging.
>>       "[SCSI] use scatter lists for all block pc requests and
>> simplify hw handlers"
>>       -  
>> http://kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=392160335c798bbe94ab3aae6ea0c85d32b81bbc 
>>
>>
>>
>> Test and tried your bug patch,  but, result is same.
> 
> 
> I do not think my patch was meant to address your issue :(
> 
>>
>> By result that I do debugging, if queuecommand () of LLD layer returns
>> result properly, but execute scsi_probe_lun () -> scsi_execute_req ()
>> -> blk_execute_rq ()  by thing which is not realized to proc/scsi/scsi
>> come out . after execute blk_execute_rq(), then cmd->buffer,
>> cmd->request_buffer is NULL. so, "Model:"  in scsi_add_lun() ->
>> print_inquiry() comes out NULL.
> 
> 
> I am not sure I understand correctly, but I do not think the analysis 
> above is completely correct. scsi_execute_req gets a buffer passed to it 
> so it should not matter if those fields are set to NULL when 
> scsi_execute_req completes as long as something has been copied to the 
> buffer passed into scsi_execute_req.
> 
>> --------------
>> Kernel version: 2.6.15-rc5
>> SATA Controller: Promise SATAII150 TX2Plus
>> SATA HDD: Western Digital 250G x 2
>> SATA Driver: 
>> http://www.promise.com/support/download/download2_eng.asp?productID=126&category=all&os=100# 
>>
>>
> 
> I am not too familar with SATA. Is this driver in mainline and does it 
> use libata? Which module is it?

I downloaded SATAII150_300_Series_Linux_src of that site and it looks 
like it should not assume some commands are scatterlist based and some 
are use_sg=0. The driver needs to be updated.
