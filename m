From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] sg descriptor sense cleanup lk 2.6.11-rc1-bk1
Date: Fri, 21 Jan 2005 09:35:03 +1000
Message-ID: <41F04027.9040606@torque.net>
References: <41EBA3F9.8030305@torque.net> <20050120111526.GD32550@infradead.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:61901 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261427AbVATXe5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2005 18:34:57 -0500
In-Reply-To: <20050120111526.GD32550@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James.Bottomley@SteelEye.com

Christoph Hellwig wrote:
> On Mon, Jan 17, 2005 at 09:39:37PM +1000, Douglas Gilbert wrote:
> 
>>Continuation of descriptor sense data expansion to
>>sg driver.
>>
>>Next will be the sd driver which awaits a
>>new utility function in constants.c to read the
>>sense data information field for medium/hardware
>>errors.
>>
>>Changelog:
>>  - expand sense data handling to descriptor format
>>  - make module parameters visible in
>>      /sys/modules/sg/parameters
>>  - add "readable" SCSI commands: READ(16), REPORT LUNS,
>>    SERVICE_ACTION_IN, RECEIVE_DIAGNOSTIC, READ_LONG
>>    and MAINTENANCE_IN_CMD to list
>>
>>Signed-off-by: Douglas Gilbert <dougg@torque.net>
> 
> 
> +#ifndef MAINTENANCE_IN_CMD
> +#define MAINTENANCE_IN_CMD 0xa3
> +#endif
> 
> Shouldn't we put it into <scsi/scsi.h> ?

Yes it should. For a larger list of missing "byte 0"
opcodes see the top of constants.c

The opcodes with a "in" suffix retrieve data from the
device so are generally safe to use when the device
is opened O_RDONLY.

So the various SCSI command sets are not limited
in number to 256, more use is being made of
service actions. Maintanance In contains these
commands (or at least they are documented separately
in SPC-3):
   Report device identifier [a3/5]
   Report target port groups [a3/a]
   Report aliases [a3/b]
   Report supported operation codes [a3/c]
   Report supported task management functions [a3/d]
   Report priority [a3/e]

And sooner or later we will need to support variable
length commands.

Doug Gilbert

