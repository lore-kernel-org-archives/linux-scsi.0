From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 0/2] be2iscsi: Logging neatening
Date: Tue, 16 Aug 2016 20:39:02 -0700
Message-ID: <1471405142.4075.197.camel@perches.com>
References: <1471107782.3467.28.camel@perches.com>
	 <cover.1471119911.git.joe@perches.com>
	 <BY2PR0201MB18626C631DE6E5D09121608181110@BY2PR0201MB1862.namprd02.prod.outlook.com>
	 <1471191843.4075.39.camel@perches.com>
	 <SN1PR0201MB187015BE4FF2DEF46741A2A481110@SN1PR0201MB1870.namprd02.prod.outlook.com>
	 <1471195790.4075.45.camel@perches.com>
	 <SN1PR0201MB18700901B51BE24AE75EC18D81140@SN1PR0201MB1870.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <SN1PR0201MB18700901B51BE24AE75EC18D81140@SN1PR0201MB1870.namprd02.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>, Ketan Mukadam <ketan.mukadam@avagotech.com>, John Soni Jose <sony.john@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-08-17 at 01:19 +0000, Bart Van Assche wrote:
> On 08/14/16 10:29, Joe Perches wrote:
> > On Sun, 2016-08-14 at 17:09 +0000, Bart Van Assche wrote:
> > > My primary concern is how to enable and disable log messages from user
> > > space.
[]
> > I think you are looking for a system wide equivalent
> > for the ethtool/netif_ mechanism.
> > 
> > Nothing like that exists currently.
> > 
> > Some code uses a bitmask/and, other code uses a
> > level/comparison.
[]
> As far as I can see all that the ethtool msglevel API implements is a 
> mechanism to query and set the log level from user space. What various 
> SCSI drivers implement is not a log level but a log mask mechanism. How 
> about the following approach to associate a name with each bit in a log 
> mask, to export these names to user space and to make it possible to 
> enable/disable messages per log category:
> * Introduce a variant of pr_debug() that allows to specify a textual
>    representation of the log category (a short string without spaces).
> * Make the log category names available in
>    /sys/kernel/debug/dynamic_debug/...
> * Today dynamic debug allows to enable/disable log messages by
>    specifying the source file name, function name, line number, module
>    name and/or format string. My proposal is to make it also possible to
>    enable/disable log messages based on the log category name.

Many of these logging mechanisms are not just debug
facilities.

Perhaps a dynamic_debug control would be inappropriate.

There have also been various custom scsi log level
facilities like the blogic_msg for the very old
BusLogic blogic_msg.

These functions also sometimes write into some
device-specific buffer.

Perhaps the largest problem, if this is to be scsi only
rather than system wide, is finding out what and how
the various bits in a mask should be used.
