From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [patch 08/10]  scsi/dpt_i2o: replace 	schedule_timeout() withmsleep_interruptible()
Date: Thu, 21 Oct 2004 09:17:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <60807403EABEB443939A5A7AA8A7458B40B5E9@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:63660 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S269083AbUJUNSB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 09:18:01 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: janitor@sternwelten.at, SCSI Mailing List <linux-scsi@vger.kernel.org>, nacc@us.ibm.com

The driver does set the state to TASK_INTERRUPTIBLE a handful of lines
above, is there some other state that the driver should have set?

We should remove the set_current_state(TASK_INTERRUPTIBLE) line when
replacing with the msleep_interruptible(timeout * 1000) line.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Thursday, October 21, 2004 8:51 AM
To: Salyzyn, Mark
Cc: janitor@sternwelten.at; SCSI Mailing List; nacc@us.ibm.com
Subject: RE: [patch 08/10] scsi/dpt_i2o: replace schedule_timeout()
withmsleep_interruptible()

On Thu, 2004-10-21 at 07:44, Salyzyn, Mark wrote:
> The timeout granularity of 1 second should be the first clue that this
> is not important. Commands complete and wake up the task under normal
> operation; the timeout is to deal with an errant controller.

Erm, yes, but what you're doing is clearly incorrect, and the reason we
went to msleep variants anyway.  Your code forgets to set the current
state, so you stand a good chance of returning immediately from the
schedule_timeout() without even yielding the processor.

James


