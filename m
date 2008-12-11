From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH][RFC 2/23]: SCST core
Date: Thu, 11 Dec 2008 20:28:30 +0300
Message-ID: <49414DBE.6070801@vlnb.net>
References: <494009D7.4020602@vlnb.net> <49400ACD.3070502@vlnb.net> <20081210191213.GA15273@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:62918 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548AbYLKR21 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Dec 2008 12:28:27 -0500
In-Reply-To: <20081210191213.GA15273@uranus.ravnborg.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

Sam Ravnborg wrote:
> On Wed, Dec 10, 2008 at 09:30:37PM +0300, Vladislav Bolkhovitin wrote:
>> This patch contains SCST core code.
>>
>> Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
>> ---
>>   drivers/scst/Kconfig         |  256 ++
> 
> Do not use "default n" - this is already the default value.

OK

>>   drivers/scst/Makefile        |   12
> EXTRA_CFLAGS are deprecated in favour of ccflags-y

OK

>>   drivers/scst/scst_cdbprobe.h |  519 +++++
> static const struct scst_sdbops scst_scsi_op_table[] 
> 
> This does not belong to a header file.

OK

>>   drivers/scst/scst_lib.c      | 3689 +++++++++++++++++++++++++++++++++++++
>>   drivers/scst/scst_main.c     | 1919 +++++++++++++++++++
>>   drivers/scst/scst_module.c   |   69
>>   drivers/scst/scst_priv.h     |  513 +++++
>>   drivers/scst/scst_targ.c     | 5458 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   8 files changed, 12435 insertions(+)
> 
> There was a lot af TRACE_ENTRY() / TRACE_EXIT() noise.
> We should have proper tools for that by now (I hope).

Sorry, I don't see such tools with, for instance, a possibility to be 
compiled out in non-debug builds.

 From one side, I can agree, those TRACE_ENTRY()/TRACE_EXIT() statements 
*may* look like a noise (I personally don't notice them), but, from 
other side, in past times they have proved how usable they are. If an 
SCST user has a problem, I simply ask him to make a debug build, then 
enable entry_exit and some other logging levels, then reproduce the 
problem and send me the logs. Then in most cases I can see what's wrong 
and provide a fix without additional actions and questions.

> We often ask for exported symbols to be documented - so one has
> a slight idea of their purpose.

They are documented, near their prototypes in the public header files, 
particularly, scst.h. It was done so, because it was supposed that one, 
writing a target driver or dev handler will have on hands the header 
files, not source code.

Should we move those comments from the functions prototypes to the 
functions definitions?

> CONFIG_SCST_STRICT_SERIALIZING has bad impact on readability.
> Could this be abstracted better?

We will try.

Thanks,
Vlad
