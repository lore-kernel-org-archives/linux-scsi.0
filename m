From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len (resend)
Date: Fri, 28 Apr 2006 16:11:36 -0500
Message-ID: <44528508.3060003@us.ibm.com>
References: <200604172240.k3HMes2V010154@d01av01.pok.ibm.com>	 <44522672.5010607@us.ibm.com>	 <1146237433.5251.7.camel@mulgrave.il.steeleye.com>	 <44525CBE.1030409@us.ibm.com>	 <1146249006.5251.64.camel@mulgrave.il.steeleye.com>	 <44526702.1010400@us.ibm.com> <1146257803.5251.82.camel@mulgrave.il.steeleye.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:10669 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751458AbWD1VLn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 17:11:43 -0400
In-Reply-To: <1146257803.5251.82.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, jgarzik@pobox.com, linux-ide@vger.kernel.org

James Bottomley wrote:
> On Fri, 2006-04-28 at 14:03 -0500, Brian King wrote:
>>> Perhaps you could tell me what the actual failure case is?  
>> I don't have any data on how ATA/ATAPI devices respond if they receive
>> too large of a CDB, but my guess is they probably don't react nicely.
>> Today libata uses the hosts's max_cmd_len for some protection against
>> this, I was merely trying to continue with a similar level of
>> protection in my new usage of libata.
> 
> But how would they receive too large a CDB?  

I suppose the only real exposure then would be someone doing passthru
commands in which we could argue that userspace should be smart enough
not to do things like this.

Going along with that argument, there's really no good reason for
libata to be playing games with scsi_host->max_cmd_len based on
the attached devices.

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
