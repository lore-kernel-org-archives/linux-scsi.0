From: R.E.Wolff@BitWizard.nl (Rogier Wolff)
Subject: Re: st.c block limits
Date: Thu, 1 Aug 2002 17:49:46 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200208011549.RAA05274@cave.bitwizard.nl>
References: <002001c2395d$6e842150$e0019d89@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <002001c2395d$6e842150$e0019d89@cybernetics.com> from Tony Battersby
 at "Aug 1, 2002 09:14:55 am"
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: 'ael' <law_ence.dev@ntlworld.com>, linux-scsi@vger.kernel.org

Tony Battersby wrote:
[Charset iso-8859-1 unsupported, filtering to ASCII...]
> > >># tar -cf /dev/ntape blah_home.tar.bz2; mt  tell
> 
> > The tape has a real 10GB capacity. (I believe.)  The 20BG
> > blocks is correct
> > for the default block size of 512. So compression is not an
> > issue here. And
> > the report above is actually 17.8/2 = 8.9 GB :-(
> 
> Some compression algorithms will actually expand data by a significant
> amount.  For example, many implementations of ALDC compression will give a
> compression ratio of 0.8 on random data.  In your example above you are
> writing a .bz2 file (which is already compressed), so it would probably
> expand if compressed again.  Try turning drive internal compression off:

It's easy to prevent this from costing too much: Simply prepend a
block of data with a "1" compressed or "0" uncompressed bit. 

Max expansion is then 1 bit per block. (At a cost of one extra bit per
block).

This technique was maybe unacceptable in the old days when you
couldn't afford to buffe a WHOLE block in RAM while you were
compressing to see if it would expand...... 

Nowadays you can easily buffer the data, and still get acceptable
speed, at an acceptable cost in the form of a little higher RAM usage. 

			Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
*-- BitWizard writes Linux device drivers for any device you may have! --*
* There are old pilots, and there are bold pilots. 
* There are also old, bald pilots. 
