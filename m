From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [patch 08/10]  scsi/dpt_i2o:
	replace	schedule_timeout()withmsleep_interruptible()
Date: 25 Oct 2004 10:19:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098713947.2023.13.camel@mulgrave>
References: <60807403EABEB443939A5A7AA8A7458B40B9B3@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:14248 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261748AbUJYOTS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2004 10:19:18 -0400
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B40B9B3@otce2k01.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: maximilian attems <janitor@sternwelten.at>, Nishanth Aravamudan <nacc@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-10-25 at 07:30, Salyzyn, Mark wrote:
> Not quite ... The value of 0 is meant to trigger never timing out on the
> request (#define FOREVER (0) in dpti.h). The code change you have will
> mean that the code will immediately timeout, not the intent.
> 
> There is a wakeup to the thread issued by the interrupt via a WAIT
> QUEUE, if the sequence of TASK_INTERRUPTIBLE/schedule() did not work, it
> would not explain the successful operation of the driver during
> initialization time.

So this is basically an open coded interruptible_sleep_on_timeout()? 
Why not replace it with this? (although this will excite the janitors
since sleep_on is deprecated in all its forms).

Also, if you define your FOREVER to be MAX_SCHEDULE_TIMEOUT, you don't
need to special case this.

James




