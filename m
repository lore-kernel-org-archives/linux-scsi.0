From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 0/2] be2iscsi: Logging neatening
Date: Sun, 14 Aug 2016 17:09:41 +0000
Message-ID: <SN1PR0201MB187015BE4FF2DEF46741A2A481110@SN1PR0201MB1870.namprd02.prod.outlook.com>
References: <1471107782.3467.28.camel@perches.com>
 <cover.1471119911.git.joe@perches.com>
 <BY2PR0201MB18626C631DE6E5D09121608181110@BY2PR0201MB1862.namprd02.prod.outlook.com>
 <1471191843.4075.39.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0085.outbound.protection.outlook.com ([104.47.33.85]:57726
	"EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751497AbcHNRJq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Aug 2016 13:09:46 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>, Ketan Mukadam <ketan.mukadam@avagotech.com>, John Soni Jose <sony.john@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 08/14/16 09:24, Joe Perches wrote:
> On Sun, 2016-08-14 at 14:34 +0000, Bart Van Assche wrote:
>> As one can see in be_main.h the "level" argument of macro beiscsi_log()
>> is ignored for log levels KERN_EMERG, KERN_ALERT, KERN_CRIT and
>> KERN_ERR. So for these log levels beiscsi_log() is a synonym of
>> shost_printk(). Have you considered to replace beiscsi_log() with
>> shost_printk() for these log levels and additionally to change
>> beiscsi_log() for the other log levels into pr_debug()? pr_debug()
>> statements namely already can be enabled and disabled at runtime. If the
>> BEISCSI_LOG_* log category would be embedded in the log text that would
>> allow to eliminate the phba->attr_log_enable structure member.
>> Additionally, pr_debug() has a facility for displaying the source file
>> name and the line number. That would allow to leave out __LINE__ from
>> be2iscsi log statements. I don't think it is useful to have that line
>> number in non-debug be2iscsi log statements.
>
> My main consideration for submitting a patch at all
> was removing the apparent format/argument mismatches.
>
> As far as I can grep, only KERN_ERR, KERN_WARNING and
> KERN_INFO are actually used by be2iscsi today.
>
> I agree with the removal of __LINE__ from the macros
> as its utility is generally pretty low.
>
> Besides, using stringify(__LINE__) is almost always
> smaller object code than a format with "%d", __LINE__.
>
> Prefixes like "BC" and "BS" are __FILE__ equivalents,
> and could be removed as well with something like
> "%s, kbasename(__FILE__)" used if _really_ desired.
>
> I have no issue with defining and using beiscsi_<level>
> equivalents to shost_printks.
>
> I think the test inside beiscsi_log is better removed
> with multiple specific beiscsi_<level> calls used.
>
> I don't know why any KERN_ERR should ever be masked,
> but perhaps something like:
>
> #define beiscsi_printk(level, phba, mask, fmt, ...)		\
> do {								\
> 	if ((mask) & (phba)->attr_log_enable)			\
> 		shost_printk(level, phba->shost, fmt, ##__VA_ARGS__); \
> } while (0)
>
> #define beiscsi_err(phba, mask, fmt, ...)			\
> 	beiscsi_printk(KERN_ERR, phba, mask, fmt, ##__VA_ARGS__)
> #define beiscsi_warn(phba, mask, fmt, ...)			\
> 	beiscsi_printk(KERN_WARNING, phba, mask, fmt, ##__VA_ARGS__)
> #define beiscsi_info(phba, mask, fmt, ...)			\
> 	beiscsi_printk(KERN_INFO, phba, mask, fmt, ##__VA_ARGS__)
>
> with a sed of the .c files:
>
> $ sed -i 's/beiscsi_log(phba, KERN_ERR/beiscsi_err(phba/g' drivers/scsi/be2iscsi/*.c
> $ sed -i 's/beiscsi_log(phba, KERN_WARNING/beiscsi_warn(phba/g' drivers/scsi/be2iscsi/*.c
> $ sed -i 's/beiscsi_log(phba, KERN_INFO/beiscsi_info(phba/g' drivers/scsi/be2iscsi/*.c
>
> with argument realignment of those lines.
>
> All of these are of course up to the actual maintainers of be2iscsi.

Hello Joe,

My primary concern is how to enable and disable log messages from user 
space. Many drivers define their own logging macros and export a bitmask 
that allows to enable and disable logging messages per category. These 
bitmask control mechanisms are annoying because figuring out what bit 
controls which message category requires a search through the driver 
source code. I'd like to see all these custom logging macros disappear 
and being replaced by a single mechanism. The "dynamic debug" mechanism 
e.g. is in my opinion much easier to use than the different custom 
logging mechanisms.

Bart.

Bart.
