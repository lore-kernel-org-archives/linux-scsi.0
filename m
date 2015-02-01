From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH v2] scsi: NCR5380: use msecs_to_jiffies for conversions
Date: Sun, 1 Feb 2015 08:14:12 +0100
Message-ID: <20150201071412.GA21711@opentech.at>
References: <1422692020-6607-1-git-send-email-der.herr@hofr.at> <alpine.LNX.2.00.1502010957150.30584@nippy.intranet> <d0a6819903df0864d2785bc209409cef@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hofr.at ([212.69.189.236]:46030 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbbBAHOO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Feb 2015 02:14:14 -0500
Content-Disposition: inline
In-Reply-To: <d0a6819903df0864d2785bc209409cef@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On Sun, 01 Feb 2015, Michael Schmitz wrote:

> Finn, Nicholas,
>
>> On Sat, 31 Jan 2015, Nicholas Mc Guire wrote:
>>
>>> This is only an API consolidation to make things more readable.
>>>
>>> Instances of  var * HZ / 1000  are replaced by  msecs_to_jiffies(var).
>>
>> ... and some instances of "value" are replaced by  
>> "msecs_to_jiffies(value)"
>> which seems to be completely wrong.
>
> The values for USLEEP_* are taken to be in units jiffies, according to  
> comments in NCR5380.c. Replacing them by the msecs_to_jiffies conversion 
> is in fact wrong.
>
> Please drop the changes to g_NCR5380.c for that reason.
>

right the comment indicates it should be jiffies - my interpretation
of that was that in NCR5380.c 
were  jiffies + (250 * HZ / 1000); constructs would be correctly
converted to e.g. jiffies + msecs_to_jiffies(250)

And defines like USLEEP_POLL are noted to be in jiffies:
* USLEEP_SLEEP - amount of time, in jiffies, to sleep

and then defined correctly as HZ indepenedent values:
#define USLEEP_SLEEP (20*HZ/1000)

and thus should be the same as msecs_to_jiffies(20)

now g_NCR5380.c defines
#define USLEEP_POLL     1
#define USLEEP_SLEEP    20
#define USLEEP_WAITLONG 500

for the DTC3181E card - but without the conversion to ms
from the use in the code though (e.g NCR5380_set_timer) it 
seemed to me that it actually should be jiffeis equivalent ms and
the intent was only to change the USLEEP_POLL and USLEEP_WAITLONG 
settings for the specific device but not the unit and thus it 
shuld have been converted by msecs_to_jiffies(1) resp. 
msecs_to_jiffies(500). The problem with this if it is left in its 
current form is that the timeouts would actually depend on the HZ
setting of the system which is probably not the intent.

Pleas do give this one more look if the argument above is
not sound I appologize for the noise.

thx!
hofrat
