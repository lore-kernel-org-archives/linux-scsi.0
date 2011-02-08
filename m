From: Jon Bendtsen <jonbendtsen@jbit.dk>
Subject: Re: understanding the sg_ses --raw output? so I can turn on the faulty
 light
Date: Tue, 08 Feb 2011 13:55:00 +0100
Message-ID: <4D513D24.800@jbit.dk>
References: <4D500EFC.1040801@jbit.dk> <1297093255.3012.30.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:35272 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781Ab1BHNNa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Feb 2011 08:13:30 -0500
Received: from localhost (localhost [127.0.0.1])
	by mgw2.diku.dk (Postfix) with ESMTP id 1314019BCDF
	for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2011 14:13:29 +0100 (CET)
Received: from mgw2.diku.dk ([127.0.0.1])
 by localhost (mgw2.diku.dk [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 16346-04 for <linux-scsi@vger.kernel.org>;
 Tue,  8 Feb 2011 14:13:26 +0100 (CET)
Received: from nhugin.diku.dk (nhugin.diku.dk [130.225.96.140])
	by mgw2.diku.dk (Postfix) with ESMTP id 9055319BDB8
	for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2011 13:55:05 +0100 (CET)
Received: from imap.diku.dk (imap.diku.dk [130.225.96.139])
	by nhugin.diku.dk (Postfix) with ESMTP id 6FB5A6DF89F
	for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2011 13:49:10 +0100 (CET)
Received: from dkjonb.laerdal.global (212-60-115-150.ip.cust.zensystems.net [212.60.115.150])
	by imap.diku.dk (Postfix) with ESMTP id 6BDD161DCD
	for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2011 13:55:05 +0100 (CET)
In-Reply-To: <1297093255.3012.30.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 07/02/11 16.40, James Bottomley wrote:
> On Mon, 2011-02-07 at 16:25 +0100, Jon Bendtsen wrote:
>> Hi
>>
>> There has earlier been 2 threads on sg_ses 21 may 2007 and 10 june 2010,
>> but unfortunately neither seemed to include information about how to
>> understand the --raw output from sg_ses.
> 
> It's a hex dump of the diagnostic mode page.

I know that. What I meant was which segments in the hex dump correlate
to which segments in the text version of the dianostic mode page?

How long are the segments? 8 bytes? The way it is formatted something
could hint that? Or is it just 4 bytes which another formatting suggests?


>> When I run this command
>> 	sg_ses --page=2 /dev/sg30 --raw
>>
>> I get output that looks like:
>>         00 00 00 00 00 00 00 00  01 00 00 00 01 00 00 00
>>         01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
>>         01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
>>         01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
>>         01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
>>         01 00 00 00 01 00 00 00  01 00 00 00 01 00 00 00
>>         01 00 00 00 01 00 00 00  00 00 01 00 01 00 01 00
>>         00 00 00 40 06 00 00 47  06 00 00 47 06 00 00 47
>>         00 00 00 00 01 00 2c 00  06 00 00 00 06 00 00 00
>>         06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
>>         06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
>>         06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
>>         06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
>>         06 00 00 00 06 00 00 00  06 00 00 00 06 00 00 00
>>         06 00 00 00 06 00 00 00
>>
>> There are 26 segments starting with 01 00 00 00, and 27 with 06. I think
>> i have to use the 01 segments, but the number 26 does not fit with my
>> number of disks unless they count like this: controller, backplane + 24
>> disks or enclosure port A + port B + 24 disks.
>>
>> At first i figured i had to set 20 in the last field, but that did not
>> work. So i tried modifying a 01 00 00 00 to 01 00 02 20 based on this
>> webpage:
>> http://storagesecrets.org/2008/12/scsi-enclosure-services-ses-ses-2-management/
>>
>> I also tried with 06 00 00 00 to 06 00 02 20, still nothing.
>>
>> I set the data using
>> 	sg_ses --control --page=2 -d - /dev/sg30 < raw.test
> 
> So I don't really plan to parse a huge hex dump, but my instinct would
> be you got something wrong.

I probably do that, which is why I asked how to understand the hex dump.


> I'd firstly validate that your lights can be flashed with the ses
> driver ... if they can, then look for a mistake in the hex dump.

How can I validate that my lights can be flashed with the SES driver?



JonB
