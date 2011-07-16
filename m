From: ersatz splatt <ersatzsplatt@gmail.com>
Subject: Re: rq_affinity doesn't seem to work?
Date: Fri, 15 Jul 2011 19:12:32 -0700
Message-ID: <CAHQAjVFTVf91Pk9rJQfsAkiuP896cfK7t9Pt2_ZOiLNq0FxYbg@mail.gmail.com>
References: <D010E79907AF0D4E90B603DE907837D504CA6365D6@azsmsx504.amr.corp.intel.com>
	<4E1CAEEB.8050506@kernel.dk>
	<20110713171011.GA11864@parisc-linux.org>
	<CAL1RGDUDbEG4ypr0GJLLi_0PTjZK0HshMVwTs=aY+=hhFdjK5g@mail.gmail.com>
	<CAHQAjVGK97KU0dB700WSTS1bH0YkW1_MCVaAtjR9aFQRJTcsbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHQAjVGK97KU0dB700WSTS1bH0YkW1_MCVaAtjR9aFQRJTcsbA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Jens Axboe <axboe@kernel.dk>, "Jiang, Dave" <dave.jiang@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Foong, Annie" <annie.foong@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>
List-Id: linux-scsi@vger.kernel.org

With the quickest and easiest fix (the first suggestion from Jens
Axboe), I was able to get another 20%+ in IOPS.  Thank you.

(Pardon the previous ugly wrap on the data.  I'm not sure how to stop
that with my e-mail vendor)

Driving more IOPS on the same system looks like this for me:
CPU %usr  %nice  %sys %iowait %irq   %soft  %steal  %guest  %idle
  all    2.85    0.00   31.37   12.05    0.00   14.84    0.00    0.00   38.90
  0    2.44    0.00    0.00    0.00    0.00    4.39    0.00    0.00   93.17
  1    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
  2    1.51    0.00   23.12   70.85    0.00    4.52    0.00    0.00    0.00
  3    5.05    0.00   51.01   19.70    0.00   24.24    0.00    0.00    0.00
  4    5.47    0.00   62.19    1.00    0.00   31.34    0.00    0.00    0.00
  5    4.00    0.00   50.00   22.50    0.00   23.50    0.00    0.00    0.00
  6    0.00    0.00    0.00    0.00    0.00    0.47    0.00    0.00   99.53
  7    0.00    0.00    0.22    0.00    0.00    0.00    0.00    0.00   99.78
  8    4.48    0.00   53.23   16.92    0.00   25.37    0.00    0.00    0.00
  9    4.48    0.00   50.25   19.40    0.00   25.87    0.00    0.00    0.00
10    5.53    0.00   63.82    0.50    0.00   30.15    0.00    0.00    0.00
11    3.50    0.00   52.00   20.50    0.00   24.00    0.00    0.00    0.00
12    0.50    0.00    1.00    1.49    0.00    0.00    0.00    0.00   97.01
13    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
14    3.50    0.00   43.50   35.50    0.00   17.50    0.00    0.00    0.00
15    4.02    0.00   51.26   20.60    0.00   24.12    0.00    0.00    0.00
16    6.03    0.00   57.29    8.54    0.00   28.14    0.00    0.00    0.00
17    4.50    0.00   49.00   25.00    0.00   21.50    0.00    0.00    0.00
18    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
19    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
20    4.98    0.00   57.21   11.44    0.00   26.37    0.00    0.00    0.00
21    4.50    0.00   54.00   16.00    0.00   25.50    0.00    0.00    0.00
22    5.50    0.00   58.00    7.00    0.00   29.50    0.00    0.00    0.00
23    4.00    0.00   49.50   22.50    0.00   24.00    0.00    0.00    0.00

I'm happy to have the performance improvement, but I would like to
know how I could do much better.  The storage hardware is all capable
of about twice the IOPS I'm getting now.

I see that "sys" is eating most of the CPU time at this point.  What
do I need to fix?  Is fio too heavy in implementation?  ... or is this
a scsi midlayer bottleneck?

I would be happy to get advice on what I should do to better
illuminate the bottleneck.
