From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len (resend)
Date: Fri, 28 Apr 2006 14:03:30 -0500
Message-ID: <44526702.1010400@us.ibm.com>
References: <200604172240.k3HMes2V010154@d01av01.pok.ibm.com>	 <44522672.5010607@us.ibm.com>	 <1146237433.5251.7.camel@mulgrave.il.steeleye.com>	 <44525CBE.1030409@us.ibm.com> <1146249006.5251.64.camel@mulgrave.il.steeleye.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1146249006.5251.64.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, jgarzik@pobox.com, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Fri, 2006-04-28 at 13:19 -0500, Brian King wrote:
>> That is what is done today, which works fine if you only have one
>> device per host, but when you have multiple devices per host, there is
>> no *good* value to put in the host max_cmd_len, hence the patch. This
>> could also be completely contained in libata as my previous post suggests,
>> if Jeff is OK with that.
> 
> The value should be the minimum of the currently supported lengths.  I
> presume we have 10, 12 and 16 for SATA?  In which case the only problem
> is not doing 16 and then only if you want to go beyond 2TB ... 

Which is what libata is doing today. This doesn't work as well for SAS
adapters which support SATA drives and also support > 2TB disk arrays.

> Perhaps you could tell me what the actual failure case is?  

I don't have any data on how ATA/ATAPI devices respond if they receive
too large of a CDB, but my guess is they probably don't react nicely.
Today libata uses the hosts's max_cmd_len for some protection against
this, I was merely trying to continue with a similar level of
protection in my new usage of libata.

The reason for this patch is so that libata no longer has to overload
scsi_host->max_cmd_len for what is really a device attribute for SATA.
I can go back down the path of containing this in libata, if we don't
see any use for such an attribute outside of SATA.

Thanks

Brian


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
