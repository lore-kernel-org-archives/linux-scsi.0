From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 1/7] qla4xxx: Allow removal of failed session using
 logout.
Date: Fri, 23 Aug 2013 19:32:49 +0000
Message-ID: <1377279317.4147.53.camel@dabdike>
References: <1373286791-29659-1-git-send-email-adheer.chandravanshi@qlogic.com>
	 <1373286791-29659-2-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:47225 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab3HWTcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Aug 2013 15:32:53 -0400
In-Reply-To: <1373286791-29659-2-git-send-email-adheer.chandravanshi@qlogic.com>
Content-Language: en-US
Content-ID: <EA9EDFE2E9C6524C9CCCC63730D0642A@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "adheer.chandravanshi@qlogic.com" <adheer.chandravanshi@qlogic.com>
Cc: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "vikas.chaudhary@qlogic.com" <vikas.chaudhary@qlogic.com>, "lalit.chandivade@qlogic.com" <lalit.chandivade@qlogic.com>

On Mon, 2013-07-08 at 08:33 -0400, adheer.chandravanshi@qlogic.com
wrote:
> +       /* wait until next relogin is triggered using DF_RELOGIN and
> +        * clear DF_RELOGIN to avoid invocation of further relogin
> +        */
> +       wtime = jiffies + (HZ * RELOGIN_TOV);
> +       do {
> +               if (test_and_clear_bit(DF_RELOGIN, &ddb_entry->flags))
> +                       goto ddb_logout_init;
> +
> +               schedule_timeout_uninterruptible(HZ);
> +       } while ((time_after(wtime, jiffies)));

This looks a bit like a hand rolled wait_event_timeout() couldn't you
use the linux primitives?

James

