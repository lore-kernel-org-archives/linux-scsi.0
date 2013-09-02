From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 4/7] Disallow changing the device state via sysfs into
 "deleted"
Date: Mon, 02 Sep 2013 21:12:15 +0200
Message-ID: <5224E30F.9090605@acm.org>
References: <52135B99.2000102@acm.org> <52135C47.4090106@acm.org> <20130901164929.GD4344@infradead.org> <5224E012.6030907@acm.org> <20130902190645.GA18957@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:40534 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611Ab3IBTMf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Sep 2013 15:12:35 -0400
In-Reply-To: <20130902190645.GA18957@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 09/02/13 21:06, Christoph Hellwig wrote:
> On Mon, Sep 02, 2013 at 08:59:30PM +0200, Bart Van Assche wrote:
>> Do you agree with changing switch (state) into switch ((int)state) ?
>> Without that additional change gcc reports the following warning:
>>
>> drivers/scsi/scsi_sysfs.c: In function ?store_state_field?:
>> drivers/scsi/scsi_sysfs.c:640:2: warning: case value ?0? not in
>> enumerated type ?enum scsi_device_state? [-Wswitch]
>
> Either that, or add a SDEV_INVALID_STATE = 0 value to the enum.  That
> variant seems a little more elegant.

Hmm ... I think the second option would require to add an additional 
case in sdev_set_state() to avoid a compiler warning. This is something 
James objected against (on June 24, see also 
http://thread.gmane.org/gmane.linux.scsi/82572/focus=82576).

Bart.

