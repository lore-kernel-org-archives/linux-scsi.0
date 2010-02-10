From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] mid-layer unblocks blocked sdev leaving queue stopped
Date: Wed, 10 Feb 2010 16:57:11 -0600
Message-ID: <4B7339C7.10403@cs.wisc.edu>
References: <4B29628D.9090208@sgi.com> <4B73322F.2000001@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59992 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab0BJW5b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Feb 2010 17:57:31 -0500
In-Reply-To: <4B73322F.2000001@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Smart <James.Smart@Emulex.Com>, James Bottomley <James.Bottomley@suse.de>

On 02/10/2010 04:24 PM, Michael Reed wrote:
>> +	/*
>> +	 * If device is blocked, leave state alone and let blocker
>> +	 * unblock when appropriate.  Otherwise, set the device
>> +	 * running here so that slave configure may perform i/o.
>> +	 */
>> +	if (sdev->sdev_state != SDEV_BLOCK) {
>> +		ret = scsi_device_set_state(sdev, SDEV_RUNNING);

Do we need locking here? Is it possible that right after we check the 
sdev_state for being blocked, it could be be set to blocked?
