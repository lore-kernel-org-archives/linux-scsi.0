From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 0/2] be2iscsi: Logging neatening
Date: Sun, 14 Aug 2016 09:24:03 -0700
Message-ID: <1471191843.4075.39.camel@perches.com>
References: <1471107782.3467.28.camel@perches.com>
	 <cover.1471119911.git.joe@perches.com>
	 <BY2PR0201MB18626C631DE6E5D09121608181110@BY2PR0201MB1862.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BY2PR0201MB18626C631DE6E5D09121608181110@BY2PR0201MB1862.namprd02.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>, Ketan Mukadam <ketan.mukadam@avagotech.com>, John Soni Jose <sony.john@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2016-08-14 at 14:34 +0000, Bart Van Assche wrote:
> On 08/13/16 13:42, Joe Perches wrote:
> > Joe Perches (2):
> >   be2iscsi: Coalesce split strings and formats
> >   be2iscsi: Use a standard logging style
> Hello Joe,

Hello Bart.

> As one can see in be_main.h the "level" argument of macro beiscsi_log() 
> is ignored for log levels KERN_EMERG, KERN_ALERT, KERN_CRIT and
> KERN_ERR. So for these log levels beiscsi_log() is a synonym of 
> shost_printk(). Have you considered to replace beiscsi_log() with 
> shost_printk() for these log levels and additionally to change 
> beiscsi_log() for the other log levels into pr_debug()? pr_debug() 
> statements namely already can be enabled and disabled at runtime. If the 
> BEISCSI_LOG_* log category would be embedded in the log text that would 
> allow to eliminate the phba->attr_log_enable structure member. 
> Additionally, pr_debug() has a facility for displaying the source file 
> name and the line number. That would allow to leave out __LINE__ from 
> be2iscsi log statements. I don't think it is useful to have that line 
> number in non-debug be2iscsi log statements.

My main consideration for submitting a patch at all
was removing the apparent format/argument mismatches.

As far as I can grep, only KERN_ERR, KERN_WARNING and
KERN_INFO are actually used by be2iscsi today.

I agree with the removal of __LINE__ from the macros
as its utility is generally pretty low.

Besides, using stringify(__LINE__) is almost always
smaller object code than a format with "%d", __LINE__.

Prefixes like "BC" and "BS" are __FILE__ equivalents,
and could be removed as well with something like
"%s, kbasename(__FILE__)" used if _really_ desired.

I have no issue with defining and using beiscsi_<level>
equivalents to shost_printks.

I think the test inside beiscsi_log is better removed
with multiple specific beiscsi_<level> calls used.

I don't know why any KERN_ERR should ever be masked,
but perhaps something like:

#define beiscsi_printk(level, phba, mask, fmt, ...)		\
do {								\
	if ((mask) & (phba)->attr_log_enable)			\
		shost_printk(level, phba->shost, fmt, ##__VA_ARGS__); \
} while (0)

#define beiscsi_err(phba, mask, fmt, ...)			\
	beiscsi_printk(KERN_ERR, phba, mask, fmt, ##__VA_ARGS__)
#define beiscsi_warn(phba, mask, fmt, ...)			\
	beiscsi_printk(KERN_WARNING, phba, mask, fmt, ##__VA_ARGS__)
#define beiscsi_info(phba, mask, fmt, ...)			\
	beiscsi_printk(KERN_INFO, phba, mask, fmt, ##__VA_ARGS__)

with a sed of the .c files:

$ sed -i 's/beiscsi_log(phba, KERN_ERR/beiscsi_err(phba/g' drivers/scsi/be2iscsi/*.c
$ sed -i 's/beiscsi_log(phba, KERN_WARNING/beiscsi_warn(phba/g' drivers/scsi/be2iscsi/*.c
$ sed -i 's/beiscsi_log(phba, KERN_INFO/beiscsi_info(phba/g' drivers/scsi/be2iscsi/*.c

with argument realignment of those lines.

All of these are of course up to the actual maintainers of be2iscsi.
