From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Some NCQ numbers...
Date: Wed, 04 Jul 2007 13:43:51 +0400
Message-ID: <468B6BD7.9010108@msgid.tls.msk.ru>
References: <468392CE.6010206@msgid.tls.msk.ru> <468A06A0.1020802@gmail.com> <468AB1A7.9010201@msgid.tls.msk.ru> <468AF5BB.10005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <468AF5BB.10005@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> Michael Tokarev wrote:
>> Well.  It looks like the results does not depend on the
>> elevator.  Originally I tried with deadline, and just
>> re-ran the test with noop (hence the long delay with
>> the answer) - changing linux elevator changes almost
>> nothing in the results - modulo some random "fluctuations".
> 
> I see.  Thanks for testing.

Here are actual results - the tests were still running when
I replied yesterday.

Again, this is Seagate ST3250620AS "desktop" drive, 7200RPM,
16Mb cache, 250Gb capacity.  The tests were performed with
queue depth = 64 (on mptsas), drive write cache is turned
off.

noop scheduler:

BlkSz Trd linRd rndRd linWr rndWr  rndR/W
   4k   1  12.8   0.3   0.4   0.3   0.1/ 0.1
        4         0.3         0.3   0.1/ 0.1
       32         0.3         0.3   0.1/ 0.1
   8k   1  24.6   0.6   0.9   0.6   0.3/ 0.3
        4         0.6         0.6   0.3/ 0.3
       32         0.6         0.6   0.3/ 0.3
  16k   1  41.3   1.2   1.8   1.1   0.6/ 0.6
        4         1.2         1.1   0.6/ 0.6
       32         1.2         1.1   0.6/ 0.6
  32k   1  58.4   2.2   3.5   2.1   1.1/ 1.1
        4         2.3         2.1   1.1/ 1.1
       32         2.3         2.1   1.1/ 1.1
 128k   1  80.4   8.1  12.5   7.2   3.8/ 3.8
        4         8.1         7.2   3.8/ 3.8
       32         8.1         7.2   3.8/ 3.8
1024k   1  80.5  33.9  33.8  24.5  14.3/14.3
        4        34.1        24.6  14.3/14.2
       32        34.2        24.6  14.4/14.2

deadline scheduler:

BlkSz Trd linRd rndRd linWr rndWr  rndR/W
   4k   1  12.8   0.3   0.4   0.3   0.1/ 0.1
        4         0.3         0.3   0.1/ 0.1
       32         0.3         0.3   0.1/ 0.1
   8k   1  24.5   0.6   0.9   0.6   0.3/ 0.3
        4         0.6         0.6   0.3/ 0.3
       32         0.6         0.6   0.3/ 0.3
  16k   1  41.3   1.2   1.8   1.1   0.6/ 0.6
        4         1.2         1.1   0.6/ 0.6
       32         1.2         1.1   0.6/ 0.6
  32k   1  57.7   2.3   3.4   2.1   1.1/ 1.1
        4         2.3         2.1   1.1/ 1.1
       32         2.3         2.1   1.1/ 1.1
 128k   1  79.4   8.1  12.5   7.2   3.8/ 3.8
        4         8.1         7.3   3.8/ 3.8
       32         8.2         7.3   3.9/ 3.8
1024k   1  79.4  33.7  33.8  24.5  14.2/14.2
        4        33.9        24.6  14.3/14.2
       32        33.4        24.4  17.0/10.5

[]
>> By the way, Seagate announced Barracuda ES 2 series
>> (in range 500..1200Gb if memory serves) - maybe with
>> those, NCQ will work better?
> 
> No one would know without testing.

Sure thing.  I guess I'll set up a web page with all
the results so far, in a hope someday it will be more
complete (we don't have many different drives to test,
but others do).

By the way.  Both SATA drives we have are single-platter
ones (with 500Gb models they've 2 platters, and 750Gb
ones are with 3 platters), while all SCSI drives I
tested have more than one platters.  Maybe this is
yet another reason for NCQ failing.

And another note.  I heard somewhere that Seagate for
one prohibits publishing of tests like this, however
I haven't signed any NDAs and somesuch when purchased
their drives in a nearest computer store... ;)

>> Or maybe it's libata which does not implement NCQ
>> "properly"?  (As I shown before, with almost all
>> ol'good SCSI drives TCQ helps alot - up to 2x the
>> difference and more - with multiple I/O threads)
> 
> Well, what the driver does is minimal.  It just passes through all the
> commands to the harddrive.  After all, NCQ/TCQ gives the harddrive more
> responsibility regarding request scheduling.

Oh well, I see.... :(

/mjt
