From: Grant Grundler <iod00d@hp.com>
Subject: Re: convert 520 byte sector disk to 512 byte sector?
Date: Tue, 10 Jun 2003 13:54:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030610205410.GI6384@cup.hp.com>
References: <20030609174647.GB29808@cup.hp.com> <20030609122907.A16169@beaverton.ibm.com> <20030609223905.GH29808@cup.hp.com> <3EE53A34.7070503@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel13.hp.com ([156.153.255.238]:8348 "EHLO palrel13.hp.com")
	by vger.kernel.org with ESMTP id S264029AbTFJUkb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2003 16:40:31 -0400
Content-Disposition: inline
In-Reply-To: <3EE53A34.7070503@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

On Tue, Jun 10, 2003 at 11:53:56AM +1000, Douglas Gilbert wrote:
> www.seagate.com have a tool called "seatool" that may do the trick for you.

	http://seatool.seagate.com/

It in fact did for at least one of the mechs (ST318304FC).
I'll iterate through the others.

But "st" can not query the status of the format it kicks off...
and thus it will never terminate properly on an ia64-linux machine:

...
read_capacity (SG_IO) error: Bad address
        FORMAT on drive /dev/sg24 is 0 % complete . . .
...

I ^C 'd the program after 2 hours and all was well.
I suspect the format doesn't take the long though
(40 minutes for 9G 10K rpm was previous experience).

I'll run "strace -o st.out st -B 512 ..." on the next round and see
what magic the program is doing. That might give me enough clues to
get my own code working.

thanks,
grant
