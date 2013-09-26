From: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Subject: RE: SCSI's heuristics for enabling WRITE SAME still need work [was:
 dm mpath: disable WRITE SAME if it fails]
Date: Fri, 27 Sep 2013 00:12:34 +0530
Message-ID: <088E451FE1854947BD9145EF8C016FF413A0271B26@inbmail01.lsi.com>
References: <20130919161043.GA27081@redhat.com>
	<20130920212142.GA17898@redhat.com>	<yq1eh8jf8wq.fsf@sermon.lab.mkp.net>
	<1379960325.4010.32.camel@localhost.localdomain>	<52412581.2010909@suse.de>
 <20130924123449.GA16083@redhat.com>	<yq1hadaba87.fsf@sermon.lab.mkp.net>
 <52434D0C.1090008@fastmail.fm>	<yq1vc1o9ztd.fsf@sermon.lab.mkp.net>
 <5243C880.6050609@interlog.com>	<52443992.4040806@fastmail.fm>
 <yq1r4cbablz.fsf@sermon.lab.mkp.net> <52445709.4080104@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:19407
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753913Ab3IZSmo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Sep 2013 14:42:44 -0400
In-Reply-To: <52445709.4080104@interlog.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, "emilne@redhat.com" <emilne@redhat.com>, device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Rajamani, Thibash" <Thibash.Rajamani@lsi.com>



>-----Original Message-----
>From: Douglas Gilbert [mailto:dgilbert@interlog.com]
>Sent: Thursday, September 26, 2013 9:17 PM
>To: Martin K. Petersen; Bernd Schubert
>Cc: Mike Snitzer; Hannes Reinecke; emilne@redhat.com; device-mapper
>development; linux-scsi@vger.kernel.org; Saxena, Sumit
>Subject: Re: SCSI's heuristics for enabling WRITE SAME still need work
>[was: dm mpath: disable WRITE SAME if it fails]
>
>On 13-09-26 10:42 AM, Martin K. Petersen wrote:
>>>>>>> "Bernd" == Bernd Schubert <bernd.schubert@fastmail.fm> writes:
>>
>> Bernd,
>>
>> Bernd> Both types of systems we have in-house neither block limits vpd
>> Bernd> nor READ_CAP16 return anything that would indicate discard is
>> Bernd> supported. But UNMAP and WRITE SAME unmap(*) just work fine.
>>
>> I have a collection of different SSDs in a tray connected to an LSI
>> SAS2008 ASIC. The 510 is the only drive that does not have LBPME=1.
>> Chances are it's because DRAT and RZAT are not set but it could also
>> be that the 510 is blacklisted.
>>
>>
>> Bernd> I certainly don't want to cause any more write-same trouble,
>> Bernd> but as all layers initially have to assume write same is
>> Bernd> supported anyway and need to dynamically disable it if it
>> Bernd> fails, can't we also enable discard by default with WRITE
>SAME16 unmap?
>>
>> No thanks :)
>>
>> But you can force discards on by doing a:
>>
>>   # echo -n unmap > /sys/class/scsi_disk/x:y:z:n/provisioning_mode
>>
>> or
>>
>>   # echo -n writesame_16 >
>> /sys/class/scsi_disk/x:y:z:n/provisioning_mode
>>
>> Create a udev rule if you like.
>>
>> In any case I wouldn't recommend using TRIM on that drive...
>>
>>
>> Bernd> PS: LSI SATL with FWv17 seems to have an unmap bug - I cannot
>> Bernd> unmap the last sector:
>>
>> Yes, it appears there's an off-by-one bug in the UNMAP translation.
>> Sumit, is this something you guys can look into?
>
>Hi Sumit,
>While you are looking at the HBA firmware could you fix this minor
>annoyance:
>

Thibash, Can you please look at this?

Sumit 

># lsscsi -H -t
>.....
>[6]    mpt3sas       sas:0x500605b006d3b510
>
># smp_rep_general /dev/mpt3ctl -s 0x500605b006d3b510 Report general
>response:
>   expander change count: 0
>   expander route indexes: 0
>   long response: 0
>   number of phys: 0
>   zone configuring: 0
>   self configuring: 0
>   externally configurable route table: 0
>   initiates SSP close: 0
>   enclosure logical identifier (hex): b005065010b5d306
>
>So that is a SMP REPORT GENERAL (RG) directed at the HBA itself.
>So either my code is incorrectly decoding the "enclosure logical
>identifier" or ... . That field was defined in SAS 1.1 so no excuses on
>that front. 0x0 would be better than a shuffled version of the HBA's own
>SAS address.
>
>Same bug/feature in all versions of SAS-2 and now SAS-3 firmware that I
>have tried.
>
>Doug Gilbert
>
>
>BTW The bsg driver can send a RG to the HBA like this:
>          smp_rep_general /dev/bsg/sas_host6
>     So the intent is clearer and the response is the same.
>
>
>
>


