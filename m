From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: SCSI's heuristics for enabling WRITE SAME still need work [was:
 dm mpath: disable WRITE SAME if it fails]
Date: Wed, 25 Sep 2013 18:12:37 -0400
Message-ID: <52435FD5.6060308@interlog.com>
References: <20130919161043.GA27081@redhat.com> <20130920212142.GA17898@redhat.com> <yq1eh8jf8wq.fsf@sermon.lab.mkp.net> <1379960325.4010.32.camel@localhost.localdomain> <52412581.2010909@suse.de> <20130924123449.GA16083@redhat.com> <yq1hadaba87.fsf@sermon.lab.mkp.net> <52434D0C.1090008@fastmail.fm>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:52311 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab3IYWNE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Sep 2013 18:13:04 -0400
In-Reply-To: <52434D0C.1090008@fastmail.fm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, emilne@redhat.com, device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org

On 13-09-25 04:52 PM, Bernd Schubert wrote:
> On 09/24/2013 03:49 PM, Martin K. Petersen wrote:
>>>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
>>
>> Mike> So are there drives like this?:
>> Mike> 1) don't support RSOC
>> Mike> 2) do support WRITE SAME
>> Mike> 3) do populate VPD page with either WRITE SAME w/ discard bit set
>> Mike>    or UNMAP?
>>
>> Yes.
>>
>> But again, the fundamental issue here is not the drives. It's the
>> controller firmware. I am not aware of a single SPI/SAS/FC drive that
>> does not support at least WRITE SAME(10).
>>
>> For DIX and T10 PI I have a capabilities mask that each HBA driver fills
>> out that tells the sd driver what the controller can do. And this is
>> combined with whatever the drive reports to figure out whether integrity
>> protection can be enabled.
>>
>> I have been contemplating doing something similar for "fancy" SCSI
>> commands. We could have a flag in the scsi host template that controls
>> whether the device supports WRITE SAME, EXTENDED COPY, etc. The
>> advantage being that we do the matching at discovery time instead of
>> once a WRITE SAME is issued.
>>
>> This would also permit HBA drivers to toggle the feature on a per
>> instance basis. I.e. if "RAID controller firmware rev is lower than XYZ,
>> do not support WRITE SAME".
>>
>> I'll do a PoC later today...
>>
>
> Martin,
>
> I'm afraid we have another problem. I'm currently working on to get
> discard working for our LSI2008 HBAs with attached sata-SSDs and the
> heuristics in sd_read_write_same with based on VPD page 0x89 is not
> correct for this HBA - its SATL supports write-same (although it does
> "Logical block address out of range" at the end of the device, I'm going
> to look into this tomorrow).
>
> So allow LSI SATL or remove this check at all?

LSI implement their SATL in firmware inside their HBAs. Given
their latest firmware release name (*Package_P17_IR_IT_Firmware*
dated 9 August 2013) for their SAS-2 family *** you have 17
versions of that firmware potentially out there in the field.
Updating that firmware is a fiddly process; I use a USB stick
with DOS on it! LSI do fix things in their SATL when flaws are
pointed out.

Generally speaking LSI's SATL is pretty good, at least compared
to another SATL I can think of. They are both moving targets,
and move independently.

Doug Gilbert


*** LSI's SAS-3 HBAs are still at "P1" which I assume is the
     first publically released version.


