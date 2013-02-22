From: Darren Lavender <dcl@hppine99.uksr.hp.com>
Subject: Re: [Patch][RFC] st: provide tape statistics via sysfs
Date: Fri, 22 Feb 2013 11:47:24 +0000
Message-ID: <51275ACC.4060207@hppine99.uksr.hp.com>
References: <DDB9C85B850785449757F9914A034FCB34340D6F@G4W3219.americas.hpqcorp.net> <1361530259.2372.28.camel@dabdike.int.hansenpartnership.com> <512756AB.2040504@hppine99.uksr.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:19298 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab3BVLre (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Feb 2013 06:47:34 -0500
In-Reply-To: <512756AB.2040504@hppine99.uksr.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Seymour, Shane M" <shane.seymour@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



......
>> I'm afraid we can't do it the way you're proposing.  files in sysfs must
>> conform to the one value per file rule (so we avoid the ABI nastiness
>> that plagues /proc).  You can create a stat directory with a bunch of
>> files, but not a single file that gives all values.
>
> That was initially my understanding, but when I looked at this the precedent had already been set, see for example the block subsys:
>
> [root@darwin ~]# grep . /sys/block/sd*/stat
> /sys/block/sda/stat:   27351     6890   609272   228129    36810   920727  7660304  1333950        0   556889  1562009
> /sys/block/sdb/stat:    2369     6762    18890    39003        0        0        0        0        0     4059    39002
> [root@darwin ~]#
>
> I can only assume it was implemented this way for the sake of
> efficiency, eg avoid a huge amount of file open/read/close calls in
> sar/iostat. It's not unusual for us to see a thousand block devices
> on enterprise servers, multiply that by the number of above entries
> and you would be talking about 11 x block-dev-count per iostat read
> iteration. Okay for tapes we typically don't see anything like this
> number but the patch just follows the precedent set with the block
> device. Nevertheless, if opinion is really strong against this we
> could split each stat out in to a single file.


Actually, to be a little more thorough I checked the kernel Docs:


[root@darwin Documentation]# less ./filesystems/sysfs.txt

....
Attributes
~~~~~~~~~~

Attributes can be exported for kobjects in the form of regular files in
the filesystem. Sysfs forwards file I/O operations to methods defined
for the attributes, providing a means to read and write kernel
attributes.

Attributes should be ASCII text files, preferably with only one value
per file. It is noted that it may not be efficient to contain only one
value per file, so it is socially acceptable to express an array of
values of the same type.
....


Technically speaking we are not providing an array of the same types, so again I'd say if opinion is really strong then we can break this out. It's really then a question of file-io efficiency. The biggest tape library I've seen has 2700 drives installed, however I think devices of that number are few and far between....


Regards

Darren
