From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Fri, 09 Jan 2015 13:39:08 +0200
Message-ID: <54AFBDDC.1000107@dev.mellanox.co.il>
References: <54AD5DDD.2090808@dev.mellanox.co.il> <54AD6563.4040603@suse.de> <54ADA777.6090801@cs.wisc.edu> <54AE36CE.8020509@acm.org> <54AE8A02.1030100@dev.mellanox.co.il> <54AE9010.5080609@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:44212 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbbAILjQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2015 06:39:16 -0500
Received: by mail-wg0-f45.google.com with SMTP id b13so7612401wgh.4
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jan 2015 03:39:14 -0800 (PST)
In-Reply-To: <54AE9010.5080609@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, open-iscsi@googlegroups.com, Hannes Reinecke <hare@suse.de>, lsf-pc@lists.linux-foundation.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Oren Duer <oren@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>

On 1/8/2015 4:11 PM, Bart Van Assche wrote:
> On 01/08/15 14:45, Sagi Grimberg wrote:
>> Actually I started with that approach, but the independent connections
>> under a single session (I-T-Nexus) violates the command ordering
>> requirement. Plus, such a solution is specific to iSER...
>
> Hello Sagi,
>
> Which command ordering requirement are you referring to ? The Linux
> storage stack does not guarantee that block layer or SCSI commands will
> be processed in the same order as these commands have been submitted.
>

I was referring to the iSCSI session requirement. I initially thought of
an approach to maintain multiple iSER connections under a single session
but pretty soon I realized that preserving commands ordering this way
is not feasible. So independent iSER connections means independent
iSCSI sessions (each with a single connection). This is indeed another
choice, which we are clearly debating on...

I'm just wandering if we are not trying to force-fit this model. How
would this model look like? We will need to define another entity to
track and maintain the sessions and to allocate the scsi_host. Will that
be communicated to user-space? How will error recovery look like?

Sagi.
