From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [patch 08/10]  scsi/dpt_i2o: replace 	schedule_timeout() with
	msleep_interruptible()
Date: 21 Oct 2004 08:50:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098363038.1776.4.camel@mulgrave>
References: <60807403EABEB443939A5A7AA8A7458B40B5B1@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:34733 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269088AbUJUMuu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 08:50:50 -0400
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B40B5B1@otce2k01.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: janitor@sternwelten.at, SCSI Mailing List <linux-scsi@vger.kernel.org>, nacc@us.ibm.com

On Thu, 2004-10-21 at 07:44, Salyzyn, Mark wrote:
> The timeout granularity of 1 second should be the first clue that this
> is not important. Commands complete and wake up the task under normal
> operation; the timeout is to deal with an errant controller.

Erm, yes, but what you're doing is clearly incorrect, and the reason we
went to msleep variants anyway.  Your code forgets to set the current
state, so you stand a good chance of returning immediately from the
schedule_timeout() without even yielding the processor.

James


