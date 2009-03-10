From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] unnecessary SCSI module
Date: Tue, 10 Mar 2009 18:24:35 +0100
Message-ID: <49B6A253.8040004@s5r6.in-berlin.de>
References: <49b5689f@wupperonline.de> <1236633029.6029.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:57245 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZCJRZv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2009 13:25:51 -0400
In-Reply-To: <1236633029.6029.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Brueckl <ib@wupperonline.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Mon, 2009-03-09 at 20:06 +0100, Ingo Brueckl wrote:
>> When configuring MODULES with the kernel to be able to load external drivers
>> coming as modules, but not using anything as module in the kernel itself, one
>> would expect to end up in a module-free kernel. Currently, you don't if you
>> use SCSI. You'll get one unnecessary module.
>> 
>> Please consider the attached patch.
>> 
>> Signed-off-by: Ingo Brueckl <ib@wupperonline.de>
>> 
>> --- linux-2.6.28/drivers/scsi/Kconfig.orig	2008-12-25 00:26:37.000000000 +0100
>> +++ linux-2.6.28/drivers/scsi/Kconfig	2009-03-06 22:49:40.000000000 +0100
>> @@ -259,7 +259,7 @@ config SCSI_SCAN_ASYNC
>>  config SCSI_WAIT_SCAN
>>  	tristate
>>  	default m
>> -	depends on SCSI
>> +	depends on SCSI = m || SCSI_SCAN_ASYNC = y
> 
> This isn't right because SCSI_SCAN_ASYNC only sets the *default*
> behaviour of the kernel.  Even if it's n the user can still boot up with
> async scans by setting the kernel parameter.

Indeed.  Also, the issue is not with /how/ SCSI_WAIT_SCAN is switched
on, it is perhaps with /that/ SCSI_WAIT_SCAN is switched on.

SCSI_WAIT_SCAN is a Kconfig variable which does not have a prompt ---
like a large number of other Kconfig variables.  Like most of these
other hidden Kconfig variables, SCSI_WAIT_SCAN controls a very compact
part of kernel functionality.  Its only difference to most if not all of
these variables is that it is a tristate variable which controls
building of a .ko.

> It also keeps coming up regularly:
> 
> http://marc.info/?t=122658550300002
> 
> James

And it will keep coming up because the reasons for these choices
(default to m instead of n, no prompt) are not at all obvious.  Perhaps
you should add a comment to drivers/scsi/Kconfig.

Actually while I superficially searched the archive right now I did not
find the reason for not prompting for this variable, other than "it
doesn't hurt to build this module".  Could be that there is an
assumption that people who want the wait scan module in their initrd
were unable to find a respective Kconfig prompt.
-- 
Stefan Richter
-=====-==--= --== -=-=-
http://arcgraph.de/sr/
