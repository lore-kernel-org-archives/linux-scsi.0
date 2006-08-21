From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] [REPOST] SCSI and FC Transport: add netlink support for
 posting of transport events
Date: Sun, 20 Aug 2006 20:03:02 -0400
Message-ID: <44E8F836.6010108@cs.wisc.edu>
References: <1155936609.12933.5.camel@localhost.localdomain> <44E68F65.2000701@cs.wisc.edu> <44E6FC57.5050502@emulex.com> <44E7C86E.1030302@cs.wisc.edu> <44E8605B.1070102@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:22430 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932495AbWHUBDL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Aug 2006 21:03:11 -0400
In-Reply-To: <44E8605B.1070102@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
>> This is because for
>> software iscsi and iser we do not know the pci device that will be used.
>> For software iscsi it could be a bonded device or multiple devices
>> depending on tables getting updated. What would we use for the vendor id
>> in this case?
> 
> Well - in this case, it's not a vendor-specific event being generated.
> It's an event by the iscsi/iser layer. This should fit the "well-known
> to the iscsi/iser transport" event definition and not require a vendor id.
> 
> If we expected to have multiple iscsi/iser stacks present (vs the 1 and
> only
> 1 implementation we have for the other transports), then either that gets
> built into the event message (as a stack identifier) or you could munge the
> same thing into the vendor id (e.g. define a "type" that indicates s/w
> assigned - and the vendor id is the stack identifier (but this method seems
> hoaky)).
> 

Oh yeah, I guess where we missed each other on this is that for iscsi:
software iscsi, software iser, iscsi cards like qlogic which hide most
iscsi details and iscsi cards like broadcom which partially hook into
the software stack all use the same transport class interface, but
sometimes events need to be handled differently in userspace depending
on what card is being used if any. So if you count the iscsi stack
running or partially running in FW/HW in something like a broadcom or
qlogic card and the software stack (iscsi_tcp or iscsi_iser) then we can
and do have multiple iscsi stacks loaded at one time, but have one
transport class that handles common tasks for all stacks.

As a result of doing software iscsi first then software iser, we do not
think in terms of vendors since they do not have one and instead do it
per driver. And we may need to perform a driver specific action in
userspace to handle a common transport class event. We thought this
might be the case for all transports and so we were hoping that common
id could be used, but if not I do not care anymore.
