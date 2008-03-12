From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] isd200: Use scsi_get_cmnd for the extra translation command
Date: Wed, 12 Mar 2008 19:27:41 +0200
Message-ID: <47D8128D.3050405@panasas.com>
References: <47D7F397.4070903@panasas.com> <1205341209.2941.116.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:44228 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbYCLR2u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2008 13:28:50 -0400
In-Reply-To: <1205341209.2941.116.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, linux-scsi <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Wed, Mar 12 2008 at 19:00 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Wed, 2008-03-12 at 17:15 +0200, Boaz Harrosh wrote:
>> James
>> please comment on the use of DID_REQUEUE as return status for 
>> the command in case of failure to allocate the extra command the first
>> time.
> 
> I'm afraid it won't work.  If you get a NULL return from
> scsi_get_command, it means that the command you already have was likely
> taken from the host free_list.  If that command is in the memory
> clearing writeout path and we don't have any returning commands to
> replace the free_list, the system is now deadlocked.
> 
> James
> 

I'm not sure you are right. Please bear in mind that for isd200 an host
has exactly one device. Now this *very first command* is some kind of
INQUIRY in the discovery process, so it cannot be mounted for SWAP as yet.
so it cannot be in the "clearing writeout path". Any kind of error on this
first command will just result in an "empty" device, No? 

I guess a newly mounted device on a memory starved system has lots of places 
to fail before and after this point in time.

Boaz
