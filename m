From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len (resend)
Date: Fri, 28 Apr 2006 13:19:42 -0500
Message-ID: <44525CBE.1030409@us.ibm.com>
References: <200604172240.k3HMes2V010154@d01av01.pok.ibm.com>	 <44522672.5010607@us.ibm.com> <1146237433.5251.7.camel@mulgrave.il.steeleye.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1146237433.5251.7.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, jgarzik@pobox.com, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Fri, 2006-04-28 at 09:28 -0500, Brian King wrote:
>> Any comments on the patch below?
> 
> The mechanistic comment is that the max_cmd_len parameter should be per
> target not per device.

I don't have a problem with that. It could go in the target as well.

> However, since this is SATA only, and SATA is supposed to be moving out
> of the SCSI subsystem, I'm a bit loath to add things we'll have to
> attempt to extract later.  What would be the consequence of simply
> lowering the host max_cmd_len by the result returned from IDENTIFY?

That is what is done today, which works fine if you only have one
device per host, but when you have multiple devices per host, there is
no *good* value to put in the host max_cmd_len, hence the patch. This
could also be completely contained in libata as my previous post suggests,
if Jeff is OK with that.


Brian


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
