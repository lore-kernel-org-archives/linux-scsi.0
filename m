From: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Subject: Re: Performance
Date: Sun, 4 Aug 2002 01:01:58 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <10208040101.ZM1331778@classic.engr.sgi.com>
References: <20020804073922.39115.qmail@web14008.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Mukul Kotwani <mkotwani@yahoo.com>
        "Re: Performance" (Aug  4, 12:39am)
List-Id: linux-scsi@vger.kernel.org
To: Mukul Kotwani <mkotwani@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Aug 4, 12:39am, Mukul Kotwani wrote:
> 
> Thanks for the reply Jeremy!
> 
> Can you point me to the proper test which I can use to
> test it? I think I have pretty good servers and
> storage. What did u guys use..and was there any tuning
> of the OS required?
> 
> For the IOPs, I guess it must have been the Windows
> cache then, because ths storage used was the same in
> both cases.
> 
> Mukul


Well, a later post from you indicated you were using 13 luns
(I presume that means 13 of these 15K drives).  That would
be 538 IOPS per drive, which sounds a little high (2ms per
I/O would account for 1/2 rotation and no seek/settle time).

The tests we've run were not using stock Linux SCSI, so it
might be hard for you to duplicate.  Have you tried using
the raw driver interface to sd (/dev/raw), or the sg
benchmark tools?  I believe the raw interface should give
your the IOPS and the sg interface would give you the MB/s
(and also the IOPS perhaps).

A couple of years ago, we had some patches to the raw interface
and block layer that allowed kiobufs to be passed directly to
the SCSI interface.  That was nice because we avoided the
CPU overhead of deconstruction and reconstruction of large
I/O requests.  However, it was messy.  I believe that the
2.5 changes with bio should help a lot in this area, without
the mess.

jeremy
