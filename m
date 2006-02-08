From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Regarding ordered-tag support.
Date: Wed, 08 Feb 2006 11:27:17 -0600
Message-ID: <1139419637.3003.43.camel@mulgrave.il.steeleye.com>
References: <43E99248.7090505@gmail.com>
	 <1139413766.3003.19.camel@mulgrave.il.steeleye.com>
	 <43EA17E6.4000800@gmail.com> <43EA1B75.40008@emulex.com>
	 <43EA2313.9030506@gmail.com>
	 <1139418451.3003.37.camel@mulgrave.il.steeleye.com>
	 <43EA27E4.9080105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:63192 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030367AbWBHR1X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 12:27:23 -0500
In-Reply-To: <43EA27E4.9080105@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun <htejun@gmail.com>
Cc: James.Smart@Emulex.Com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2006-02-09 at 02:18 +0900, Tejun wrote:
> Yeah, I kind of doubt whether hardware vendors would implement and test
> all the options and features whene I read SCSI specs.  Considering how
> many ATA drives have faulty firmware...
> 
> Anyways, it seems ordered-tag support should be left alone for the time
> being.  Sad.  :-(

Well ... I've always maintained that ordered queueing is not really a
good method of implementing barriers in TCQ environments ... primarily
because no-one else really does it, so we'd be uncovering all of the
bugs.

I suppose I'm a broken record, but I really think linked tasks are the
better way to enforce the required ordering guarantees for SCSI TCQ.
The problem being that this would present a slightly different API at
the block level (you have individual writes that are now ordered, not
wholesale barriers).

James


