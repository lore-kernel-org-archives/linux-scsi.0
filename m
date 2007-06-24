From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: sdparm: change_mode_page: failed setting page: Caching (SBC)
Date: Sun, 24 Jun 2007 23:27:09 +0400
Message-ID: <467EC58D.4010404@msgid.tls.msk.ru>
References: <467E5798.8030100@msgid.tls.msk.ru> <467EA866.4070008@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hobbit.corpit.ru ([81.13.94.6]:24561 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701AbXFXT1N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Jun 2007 15:27:13 -0400
In-Reply-To: <467EA866.4070008@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Douglas Gilbert wrote:
> Michael Tokarev wrote:
>> We've got a bunch of SATA Seagate Barracuda ES drives,
>> namely, ST3250620NS -- "enterprize" class.  And now I
>> wonder what's wrong with - either those drives, or
>> sdparm, or kernel.
>>
>> In particular, sdparm can't change WCE bit, like this:
>> change_mode_page: failed setting page: Caching (SBC)
>> # _
[]
>> What I also observed is that `sdparm -a' output is a bit different
>> for the two.  For the NS series, it looks like this:
>>
>>   WCE         1
>>
>> While for the AS series, it is like:
>>
>>   WCE         1  [cha: y]
>>
>> The difference is that for the AS drives, sdparm displays
>> whenever the parameter is changeable, while for the NS
>> ("enterprise") disk, it does not.
[]
> Michael,
> My information may be out of date, but last time I
> looked libata didn't support MODE SELECT which is
> the SCSI command to change mode page settings.
> [I have sent patches several times to add support
> for this in libata but ...]

Ahhha!!!

That looks exactly the case.

I tested the two drives (AS and NS ones) on different
machines, and currently, NS (where things doesn't work)
is connected to AHCI controller, while the AS one is
behind mptsas.  So it just looks like mptsas is doing
the right thing in the first place, while ahci (or
libata, whatever) is failing.

> So, if /dev/sda is connected directly via libata, and
> libata hasn't been fixed (as per the SAT standard)
> then exactly the error message you have shown above
> will be reported by libata. [BTW the error message
> is wrong too ... it should be 20h,0h not 24h,0h ...
> sent a patch for that too.]
> 
> hdparm should do the trick for you. sdparm (or a very
> recent version of hdparm) may be needed if the SATA
> disk is behind a SAS (USB or 1394) interconnect that
> implements a decent SAT layer somewhere.

Well, even not-so-recent (tried 0.98) works just fine
with a drive connected to mptsas controller.  And indeed,
hdparm did the trick with the NS drive on AHCI controller.

Hooray!

Thank you!

/mjt

(the only (unrelated) prob left with those drives is to
figure out why NCQ doesn't seem to work even if all 3 --
drive, controller and kernel - claims it's enabled with
queue depth = 31/32...  But that's entirely different
story... ;)
