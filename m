From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] Flexible timout intfrastructure take II
Date: Mon, 21 Jun 2004 13:08:50 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <169D72C18DA396EBF5479B10@aslan.scsiguy.com>
References: <1087421869.2796.80.camel@mulgrave> 	<380DAEE648059C0AEE63E91D@aslan.scsiguy.com> <1087841470.1797.71.camel@mulgrave>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.scsiguy.com ([63.229.232.106]:57873 "EHLO
	aslan.scsiguy.com") by vger.kernel.org with ESMTP id S266412AbUFUTI5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 15:08:57 -0400
In-Reply-To: <1087841470.1797.71.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

> On Mon, 2004-06-21 at 12:24, Justin T. Gibbs wrote:
>> You also need an:
>> 
>> EH_NOT_FOUND:		The HBA knows nothing about this command and
>> 			has probably already completed it, but has no
>> 			state to confirm this.
>> 
>> or do you propose that the drivers just blindly return EH_HANDLED?
>> 
>> Since scsi_done() has no return value, the LLD cannot know if the
>> attempted completion was ignored due to losing the race with the timer.
>> So it cannot keep state to ensure that it provides the correct response
>> (EH_HANDLED) in this case.
> 
> How is this case different from EH_HANDLED?  If the command has been
> completed after the timer fired then it still needs to be completed when
> the driver is notified of the timeout.

I was just seeking clarification of the sematics, since this particular
race was not explicitly covered.

It would seem more in line with your "do it in the mid-layer" approach to
fix this race condition there instead of in each driver.  Either way, the
documentation and/or code should address this case.

--
Justin

