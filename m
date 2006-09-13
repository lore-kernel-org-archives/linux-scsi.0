From: Douglas Gilbert <dougg@torque.net>
Subject: Re: lp8000 and 2.6.18-rc6
Date: Wed, 13 Sep 2006 10:44:06 -0400
Message-ID: <45081936.4040209@torque.net>
References: <20060909210856.GC21263@stat.unipd.it>	 <20060910135631.GD29775@parisc-linux.org>	 <20060910210444.GC22873@stat.unipd.it> <4504B6AF.3080909@torque.net>	 <20060911064008.GA26293@stat.unipd.it>	 <1157994026.3470.3.camel@mulgrave.il.steeleye.com>	 <20060912064514.GA28121@stat.unipd.it> <1158156671.3462.7.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36845 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750895AbWIMOoV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Sep 2006 10:44:21 -0400
In-Reply-To: <1158156671.3462.7.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alberto Cammozzo <mmzz@stat.unipd.it>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Tue, 2006-09-12 at 08:45 +0200, Alberto Cammozzo wrote:
>> novantatre:~# dmesg
>> [...]
>> st 0:0:5:0: Attached scsi generic sg0 type 1
>> ch 0:0:5:1: Attached scsi generic sg1 type 8
>> sd 1:0:0:0: Attached scsi generic sg2 type 0
>> scsi 1:0:15:0: Attached scsi generic sg3 type 3
>> scsi 1:1:9:0: Attached scsi generic sg4 type 3
>> scsi 1:2:8:0: Attached scsi generic sg5 type 3
>> scsi 2:0:0:0: Attached scsi generic sg6 type 0
>> scsi 2:0:1:0: Attached scsi generic sg7 type 0
>> scsi 2:0:2:0: Attached scsi generic sg8 type 0
>> scsi 2:0:3:0: Attached scsi generic sg9 type 0
> 
> This shows it found LUNS 0 1 2 3

Wouldn't that be target identifiers 0, 1, 2 and 3
all with luns 0 (the fourth element in the scsi tuple)?

>> sd 3:0:0:0: Attached scsi generic sg10 type 0
>>
>> novantatre:~# sg_luns -v sg6
>> sg_luns: open error: sg6: No such file or directory
>> novantatre:~# sg_luns -v /dev/sg6
>>     report luns cdb: a0 00 00 00 00 00 00 00 04 00 00 00 
>>     report luns: requested 1024 bytes but got 32 bytes
>> Lun list length = 24 which imples 3 lun entries
>>
>> Output response in hex
>>  00     00 00 00 18 00 00 00 00  00 01 00 00 00 00 00 00                    
>>  10     00 03 00 00 00 00 00 00  00 04 00 00 00 00 00 00                    
>> Report luns [select_report=0]:
>>     0001000000000000
>>     0003000000000000
>>     0004000000000000
> 
> This says the system only has three luns: 1 3 4 (i.e. no 2)

No lun 0 either hence the PQual=1 for the inquiry
response for /dev/sg6 ('sg_inq /dev/sg6'). I suspect
'sg_inq /dev/sg7', sg8 and sg9 also have PQual=1.
There may be a similar pattern to 'sg_luns /dev/sg7',
sg8 and sg9 as was reported for 'sg_luns /dev/sg6'.

> So something really strange is going on here ... The linux code should
> have executed a probe and add luns for the contents of report lun, which
> should have found the correct set, unless something went wrong during
> the reporting.
> 
> Can you post the full dmesg from the time the Emulex is detected to the
> time sg attaches?  report luns is supposed to issue a failure message if
> something goes wrong (additionally, using the latest -mm would be
> helpful since that prints enhanced inquiry information from scsi-misc).

Yes dmesg would be useful. Is there something stopping
the mid level scanning luns where lun>0 (perhaps something
in the black list)?

Doug Gilbert
