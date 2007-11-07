From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: usage of max_sectors in scsi_host_template
Date: Wed, 07 Nov 2007 14:24:04 -0600
Message-ID: <47321EE4.5000400@cs.wisc.edu>
References: <47304E70.9090005@Voltaire.COM> <4730B359.8020806@s5r6.in-berlin.de> <4731CFE1.1070904@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46275 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbXKGUYY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Nov 2007 15:24:24 -0500
In-Reply-To: <4731CFE1.1070904@Voltaire.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org

Erez Zilber wrote:
> Stefan Richter wrote:
>> Erez Zilber wrote:
>>> I'm not sure that I understand the meaning of max_sectors in
>>> scsi_host_template.
>> Did you have a look at scsi_mid_low_api.txt?
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/scsi/scsi_mid_low_api.txt;h=6f70f2b9327e1f0db7bc05bdbf2d6ce3b2fcbdcf#l1232
>>
> 
> I will go over it. Thanks for the link.
> 
>>> Is it the maximum data length of a single SCSI command?
>> Yes.
>>
>>> Is it in bytes?
>> No, it is in units of 512 bytes.
>>
>>> What's the size of a sector?
>> "Usually" 512 bytes according to above doc.  Always 512 bytes from the
>> point of view of block/ll_rw_blk.c::blk_queue_max_sectors().
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=block/ll_rw_blk.c;h=75c98d58f4ddf7252e2717e0924b9d6a8925b4e5#l590
>>
> 
> So, ll_rw_blk actually uses the max_sectors value to chop requests 

Well, there is q->max_sectors and q->max_hw_sectors. In current kernels 
q->max_hw_sectors is scsi_host_template->max_sectors. And q->max_sectors 
is sort of a block layer limit to make sure commands to not get too big.


> larger than max_sectors. Am I right? If yes, I have a problem:
> 
> I'm running sgp_dd (on RHAS 4 up4 - kernel version is 2.6.9), so it 
> calls scsi-ml directly (without going through ll_rw_blk). I ran it with 
> the following parameters:

RHEL4's sg.c does not take into account q->max_sectors or q->max_hw_sectors.

In later kernels like in RHEL5 (probably upstream 2.6.16+), sg.c and 
st.c goes through llw_rw_blkc and obeys the sector limit. For pass 
through like sg and block layer sg, the scsi command is limited by 
q->max_hw_sectors which like I said above is 
scsi_host_template->max_sectors. And normal FS commands are limited by 
min(q->max_hw_sectors, q->max_sectors).
