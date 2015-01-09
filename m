From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Fri, 9 Jan 2015 13:31:29 +0000
Message-ID: <5EE87F5E6631894E80EB1A63198F964D040A6A8F@SACMBXIP03.sdcorp.global.sandisk.com>
References: <54AD5DDD.2090808@dev.mellanox.co.il> <54AD6563.4040603@suse.de>
 <54ADA777.6090801@cs.wisc.edu> <54AE36CE.8020509@acm.org>
 <54AE8A02.1030100@dev.mellanox.co.il> <54AE9010.5080609@acm.org>
 <54AFBDDC.1000107@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0072.outbound.protection.outlook.com ([157.56.110.72]:56123
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752669AbbAINbe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2015 08:31:34 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, Hannes Reinecke <hare@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Oren Duer <oren@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>

On 01/09/15 12:39, Sagi Grimberg wrote:
> On 1/8/2015 4:11 PM, Bart Van Assche wrote:
>> On 01/08/15 14:45, Sagi Grimberg wrote:
>>> Actually I started with that approach, but the independent connections
>>> under a single session (I-T-Nexus) violates the command ordering
>>> requirement. Plus, such a solution is specific to iSER...
>>
>> Which command ordering requirement are you referring to ? The Linux
>> storage stack does not guarantee that block layer or SCSI commands will
>> be processed in the same order as these commands have been submitted.
>
> I was referring to the iSCSI session requirement. I initially thought of
> an approach to maintain multiple iSER connections under a single session
> but pretty soon I realized that preserving commands ordering this way
> is not feasible. So independent iSER connections means independent
> iSCSI sessions (each with a single connection). This is indeed another
> choice, which we are clearly debating on...
>
> I'm just wandering if we are not trying to force-fit this model. How
> would this model look like? We will need to define another entity to
> track and maintain the sessions and to allocate the scsi_host. Will that
> be communicated to user-space? How will error recovery look like?

Hello Sagi,

As you probably remember scsi-mq support was added in the SRP initiator
by changing the 1:1 relationship between scsi_host and RDMA connection
into a 1:n relationship. I don't know how much work it would take to
implement a similar transformation in the SCSI initiator. Maybe we
should wait until Mike's workday starts such that Mike has a chance to
comment on this.

Bart.


________________________________

PLEASE NOTE: The information contained in this electronic mail message is intended only for the use of the designated recipient(s) named above. If the reader of this message is not the intended recipient, you are hereby notified that you have received this message in error and that any review, dissemination, distribution, or copying of this message is strictly prohibited. If you have received this communication in error, please notify the sender by telephone or e-mail (as shown above) immediately and destroy any and all copies of this message in your possession (whether hard copies or electronically stored copies).

