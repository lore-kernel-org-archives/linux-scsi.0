From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] scsi: ch.c fix sparse shadowed variable warnings
Date: Tue, 01 Apr 2008 18:16:07 +0300
Message-ID: <47F251B7.1010203@panasas.com>
References: <200803282148.m2SLmdA5012246@imap1.linux-foundation.org>	 <1206897715.4224.55.camel@localhost.localdomain>	 <1206902620.6543.32.camel@brick>	 <1206903356.4224.87.camel@localhost.localdomain>	 <1206903583.6543.38.camel@brick>	 <1207019451.3192.92.camel@localhost.localdomain>	 <1207026330.12466.12.camel@brick> <1207061497.3100.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:55844 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbYDAPQn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2008 11:16:43 -0400
In-Reply-To: <1207061497.3100.14.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org

On Tue, Apr 01 2008 at 17:51 +0300, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Mon, 2008-03-31 at 22:05 -0700, Harvey Harrison wrote:
>> Replace the global err array with ch_err.
>> drivers/scsi/ch.c:271:6: warning: symbol 'err' shadows an earlier one
>> drivers/scsi/ch.c:116:3: originally declared here
>>
>> Replace the temporary cmd buffer with ch_err to avoid shadowing the cmd
>> function parameter.
>> drivers/scsi/ch.c:724:11: warning: symbol 'cmd' shadows an earlier one
>> drivers/scsi/ch.c:596:20: originally declared here
>>
>> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
>> ---
>> James, incorporated your comments.
> 
> Yes, that looks fine, thanks.
> 
> I have a challenge for you:  It looks like this driver has three
> incorrect unconditional uses of GFP_DMA.  It gets a 512 byte bufer and
> then only uses 256 bytes of it on several occasions and the routine with
> the shadowed cmd variable looks like it should be calling
> ch_read_element_status() rather than duplicating it.
> 
> James
> 
I have the GFP_DMA and allocation stuff covered for this driver.

Boaz

