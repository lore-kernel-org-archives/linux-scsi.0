From: Mark Lord <kernel@start.ca>
Subject: Re: [PATCH 1/3] sd: don't bother spinning up disks on resume
Date: Wed, 20 Nov 2013 09:23:04 -0500
Message-ID: <528CC5C8.6080700@start.ca>
References: <527AF287.7020700@ubuntu.com>		 <927e15641f27b46f206f8ae8110201c8fd77b7e1.1383789225.git.psusi@ubuntu.com>		 <527BDA11.6060603@interlog.com> <527C0349.5010301@ubuntu.com>	 <1384626031.3614.7.camel@dabdike.int.hansenpartnership.com>	 <52883CE9.9040102@ubuntu.com> <1384670620.3614.24.camel@dabdike.int.hansenpartnership.com> <5288EBA6.3070609@ubuntu.com> <5289573A.9070307@interlog.com> <52896806.4040907@ubuntu.com> <528A382E.10400@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mouse.start.ca ([64.140.120.56]:48620 "EHLO mouse.start.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab3KTOXN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Nov 2013 09:23:13 -0500
In-Reply-To: <528A382E.10400@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, dgilbert@interlog.com, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: todd.e.brandt@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, tj@kernel.org

On 13-11-18 10:54 AM, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 11/17/2013 8:06 PM, Phillip Susi wrote:
>> I don't see anything particularly inefficient about issuing the
>> command in the eh path ( in fact, libata always uses the eh path to
>> handle power management ).  You can of course, use the
>> manage_start_stop flag to have the disk start on resume if you
>> really want.
> 
> Yikes, I think I see now why scsi eh is so bad: the entire host, not
> just the device is quiesced.
> 
> I suppose now the question is how to issue the START STOP UNIT from
> sd_prep_fn()?  I gather you can't just call scsi_execute_req() from
> there?  Is there maybe a way to insert a START STOP UNIT request into
> the queue ahead of the current request being prepped?  Can
> sd_prep_fn() be called concurrently on multiple cpus?  Hrm.. what
> about TCQ?  Would it be bad if the original request were queued ( to
> the drive ) before the START STOP UNIT command completed?

Yeah, solve that, and you're golden.
I totally understand the motivation for this patch,
and would love to have it working on my machines here too.

But it may have to be some kind of sysfs optional setting,
defaulting to current behaviour, to keep the server keepers happy.

Cheers


