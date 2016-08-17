From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 0/2] be2iscsi: Logging neatening
Date: Wed, 17 Aug 2016 01:19:39 +0000
Message-ID: <SN1PR0201MB18700901B51BE24AE75EC18D81140@SN1PR0201MB1870.namprd02.prod.outlook.com>
References: <1471107782.3467.28.camel@perches.com>
 <cover.1471119911.git.joe@perches.com>
 <BY2PR0201MB18626C631DE6E5D09121608181110@BY2PR0201MB1862.namprd02.prod.outlook.com>
 <1471191843.4075.39.camel@perches.com>
 <SN1PR0201MB187015BE4FF2DEF46741A2A481110@SN1PR0201MB1870.namprd02.prod.outlook.com>
 <1471195790.4075.45.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0084.outbound.protection.outlook.com ([104.47.36.84]:27587
	"EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753071AbcHQBTz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Aug 2016 21:19:55 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>, Ketan Mukadam <ketan.mukadam@avagotech.com>, John Soni Jose <sony.john@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 08/14/16 10:29, Joe Perches wrote:=0A=
> On Sun, 2016-08-14 at 17:09 +0000, Bart Van Assche wrote:=0A=
>> My primary concern is how to enable and disable log messages from user=
=0A=
>> space. Many drivers define their own logging macros and export a bitmask=
=0A=
>> that allows to enable and disable logging messages per category. These=
=0A=
>> bitmask control mechanisms are annoying because figuring out what bit=0A=
>> controls which message category requires a search through the driver=0A=
>> source code. I'd like to see all these custom logging macros disappear=
=0A=
>> and being replaced by a single mechanism. The "dynamic debug" mechanism=
=0A=
>> e.g. is in my opinion much easier to use than the different custom=0A=
>> logging mechanisms.=0A=
>=0A=
> Dynamic debug doesn't have a bitmask function and=0A=
> still requires looking through the code for lines=0A=
> and format strings.=0A=
>=0A=
> I think you are looking for a system wide equivalent=0A=
> for the ethtool/netif_<level> mechanism.=0A=
>=0A=
> Nothing like that exists currently.=0A=
>=0A=
> Some code uses a bitmask/and, other code uses a=0A=
> level/comparison.=0A=
>=0A=
> Care to propose something?=0A=
=0A=
Hello Joe,=0A=
=0A=
As far as I can see all that the ethtool msglevel API implements is a =0A=
mechanism to query and set the log level from user space. What various =0A=
SCSI drivers implement is not a log level but a log mask mechanism. How =0A=
about the following approach to associate a name with each bit in a log =0A=
mask, to export these names to user space and to make it possible to =0A=
enable/disable messages per log category:=0A=
* Introduce a variant of pr_debug() that allows to specify a textual=0A=
   representation of the log category (a short string without spaces).=0A=
* Make the log category names available in=0A=
   /sys/kernel/debug/dynamic_debug/...=0A=
* Today dynamic debug allows to enable/disable log messages by=0A=
   specifying the source file name, function name, line number, module=0A=
   name and/or format string. My proposal is to make it also possible to=0A=
   enable/disable log messages based on the log category name.=0A=
=0A=
Anyway, this is just a proposal. Anyone is welcome to come up with an =0A=
alternative proposal.=0A=
=0A=
Bart.=0A=
