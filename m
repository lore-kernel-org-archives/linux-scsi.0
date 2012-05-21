From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/4] notify userspace of offline->running transitions
 (v2)
Date: Mon, 21 May 2012 10:35:30 -0500
Message-ID: <4FBA60C2.20007@cs.wisc.edu>
References: <1337317019-12001-1-git-send-email-michaelc@cs.wisc.edu> <4FBA2BF7.7070500@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48501 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971Ab2EUPfj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 May 2012 11:35:39 -0400
In-Reply-To: <4FBA2BF7.7070500@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, kay.sievers@vrfy.org

On 05/21/2012 06:50 AM, Hannes Reinecke wrote:
> On 05/18/2012 06:56 AM, michaelc@cs.wisc.edu wrote:
>> The following patches were made over the misc branch of the scsi tree.
>>
>> The patches fix a issue where if the device is offlined or IO is
>> failed due to fast_io_fail (fc) /recovery_tmo (iscsi) then comes
>> back, apps do not have a way a nice way to figure out the state
>> has transitioned to running. Apps have to either poll the sysfs state
>> file or send a SG IO to figure it out. With the patch apps can listen
>> for the KOBJ CHANGE event like some of them (at least udev does) do
>> already.
>>
>> v2:
>> - Rebased to misc.
>>
> In principle, yes.
> 

ccing Kay.

> However, when doing this, we're now sending 'CHANGE' uevents from
> SCSI devices. With the potential of putting _quite_ some strain on udev.
> Kay explicitely debarred me from using uevents for my SCSI sense

Kay told me to do it this way :) In this case udev was the app we
discovered the issue with, so maybe that is the diff.
