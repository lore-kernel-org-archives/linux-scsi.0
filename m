From: Douglas Gilbert <dougg@torque.net>
Subject: Re: setting maximum queue depth to 255 with sg driver
Date: Fri, 30 May 2003 19:24:41 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ED72359.9020202@torque.net>
References: <4.3.2.7.2.20030529235329.029e0740@andiamo.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:62218 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263461AbTE3JMg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 May 2003 05:12:36 -0400
In-Reply-To: <4.3.2.7.2.20030529235329.029e0740@andiamo.com>
List-Id: linux-scsi@vger.kernel.org
To: Tameen Khan <tameen@andiamo.com>
Cc: linux-scsi@vger.kernel.org

Tameen Khan wrote:
> goal is to achieve a max queue depth of 255 using qlogic hba qla2342 on 
> a linux host (2.4.18)
> I am using scsi generic driver to do IO. The queue depth bottleneck is 
> SG_MAX_QUEUE as indicated in the documentation.
> The SG_MAX_QUEUE value is 16
> I've tried one way to bypass this limit (as suggested in 
> http://tldp.org/HOWTO/SCSI-Generic-HOWTO/)
> That is to do multiple open() to the same device, SG driver should allow 
> queueing of 16
> commands per device.

... commands per open file descriptor.

> This does not work for me and I still see a maximum queue depth of 16.

Tameen,
In what sense doesn't it work; something wrong with the
sg driver or doesn't fit your code?

> What could be the reason and what could be a workaround ?
> What could be other ways to increase the queue depth beyond 16 ?

You can of course change SG_MAX_QUEUE to 255 and recompile
the sg driver. At the time that code was written (early lk 2.2
series) there was often a shortage of RAM so the idea was
to predefine resources at open() and if that succeeded reasonable
guarantees could be given that subsequent operations would not
fail with ENOMEM. This was (and still is) important to applications
like cdrecord and its predecessor cdwrite.

Doug Gilbert


