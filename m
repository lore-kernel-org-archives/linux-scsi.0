From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 04/15] qla2xxx: Use msleep() as delay during ISP polling.
Date: Sat, 14 Jan 2006 06:40:49 -0800
Message-ID: <20060114144049.GE13373@andrew-vasquezs-powerbook-g4-15.local>
References: <11372007004181-git-send-email-andrew.vasquez@qlogic.com> <1137232084.3014.5.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:11640 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1750934AbWANOkv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Jan 2006 09:40:51 -0500
Content-Disposition: inline
In-Reply-To: <1137232084.3014.5.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Sat, 14 Jan 2006, Arjan van de Ven wrote:

> > -			udelay(10); /* v4.27 */
> > +			msleep(10);
> 
> this goes from a 10 microsecond delay to a 10 milisecond delay. Was that
> intentional?

the original (original) code was:

	...
	set_current_state(TASK_UNINTERRUPTIBLE);
	schedule_timeout(10);

during upstream development it was changed (incorrectly) to:

	udelay(10);


again, the qla2xxx driver only uses this poll-for-completion mechanism
during init-time.  There really is (was) no reason to bang on the chip
in such a tight-loop.

Thanks,
Andrew
