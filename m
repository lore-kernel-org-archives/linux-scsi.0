From: Luben Tuikov <tluben@rogers.com>
Subject: Re: Patch: change the serial_number for error-handler commands
Date: Wed, 21 May 2003 17:11:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ECBEB8D.4030008@rogers.com>
References: <3ECA9D46.7010301@rogers.com> <Pine.LNX.4.44L0.0305202110520.4914-100000@netrider.rowland.org> <20030521180308.GD1116@beaverton.ibm.com> <3ECBD122.3090702@rogers.com> <20030521202809.GA1791@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-mail.bloor.is.net.cable.rogers.com ([66.185.86.72]:47148
	"EHLO fep02-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S262341AbTEUU6t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2003 16:58:49 -0400
In-Reply-To: <20030521202809.GA1791@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org

Mike Anderson wrote:
> Luben Tuikov [tluben@rogers.com] wrote:
> 
>> Mike Anderson wrote:
^^^^^^^^^^^^^^
>>>+static inline unsigned long scsi_get_next_serial(struct Scsi_Host *shost)
>>>+{
>>>+        return (++shost->serial_number) ? shost->serial_number : 1;
>>>+}
>>>+
>>
> 
> There is a bug in the above line it should be 
> return (++shost->serial_number) ? shost->serial_number : ++shost->serial_number;

I did NOT write the above mentioned function -- this was part of _your_
patch -- next time _please_ remove ``Luben wrote:'' in the reply, so
that there's no confusion!

I'd appreciate that very much.

>>How about something like this:
>>
>>static inline unsigned long scsi_get_cmdsn(struct Scsi_Host, *shost)
>>{
>>	static const typeof(shost->serial_number) MAX_SN = 
>>		~((typeof(shost->serial_number) 0);
>>	return  shost->serial_number++ == MAX_SN ?
>>		++shost->serial_number : shost->serial_number;
>>}
>>
> 
> 
> Why compare with MAX_SN and not just let the value role over and check
> for false. 

First, zero is reserved, and I was trying to keep the _next_ sn in
the ``session'' cmdsn variable, but there's a little _bug_ up there too,
so here's a corrected version:

static inline unsigned long scsi_get_cmdsn(struct Scsi_Host *shost)
{
	static const typeof(shost->serial_number) MAX_SN =
		~((typeof(shost->serial_number) 0);
	return  shost->serial_number == MAX_SN ?
		(shost->serial_number += 2)++  :
		shost->serial_number++;
}

-- 
Luben



