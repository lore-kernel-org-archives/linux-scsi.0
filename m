From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: PATCH [0/8]  qla2xxx: Summary of changes...
Date: 07 Sep 2004 10:09:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094566150.1716.11.camel@mulgrave>
References: <20040907042603.GA29557@praka.san.rr.com>
	<1094536856.2801.3.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:3462 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268073AbUIGOJe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 10:09:34 -0400
In-Reply-To: <1094536856.2801.3.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-09-07 at 02:00, Arjan van de Ven wrote:
> I found a "funky" bug the other day with this driver; I was testing on a
> RAID device of which I won't mention the vendor, but it had the habit of
> returning QUEUE FULL when it's internal queue was full, with multiple
> luns active that could even be on a lun which had exactly zero
> outstanding IO already. The qlogic driver happily takes the number of
> outstanding commands (0) and subtracts 1 from it to guestimate the
> max... needless to say that didn't go down to well :-) Sounds like a
> bound check would make sense here...

Actually, this isn't at all unusual.  RAID devices often have a single
memory pool for all the LUN queues.  Heavy activity on a set of LUNs can
lead to no resources for a command on others.

Although we have queue full tracking, predicting the behaviour on
devices with coupled queues like this is impossible.

However, I thought the qlogic driver used the mid-layer queue full
tracking, which takes all of this into account and won't adjust the
depth below a certain number (8 I think).

James


