From: "K.S. Bhaskar" <ks.bhaskar@fnis.com>
Subject: Re: Enterprise workload testing for storage and filesystems
Date: Fri, 21 Nov 2008 10:59:56 -0500
Message-ID: <4926DAFC.5070006@fnis.com>
References: <1226962063.3403.13.camel@localhost.localdomain> <x49y6zegjum.fsf@segfault.boston.devel.redhat.com>
Reply-To: "K.S. Bhaskar" <ks.bhaskar@fnis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <x49y6zegjum.fsf@segfault.boston.devel.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/20/2008 04:37 PM, Jeff Moyer wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> writes:

[KSB] <...snip...>

>  > Let's see how our storage and filesystem tuning measures up to this.
> 
> This is indeed great news!  The tool is very flexible, so I'd like to
> know if we can get some sane configuration options to start testing.
> I'm sure I can cook something up, but I'd like to be confident that what
> I'm testing does indeed reflect a real-world workload.

[KSB] Here are numbers for some tests that we ran recently:

io_thrash -o 4 4 testdb 4000000 100000 12 8192 512 1000 90 90 10 512
io_thrash -o 4 4 testdb 4000000 100000 12 8192 512 10000 90 90 10 512
io_thrash -o 4 4 testdb 4000000 100000 12 8192 512 100000 90 90 10 512
io_thrash -o 4 4 testdb 4000000 100000 12 8192 512 200000 90 90 10 512

Note that these are relatively modest tests (4x32GB database files, all 
on one file system, 12 processes).  To simulate bigger loads, allow the 
journal file sizes to grow to 4GB, use a configuration file to spread 
the database and journal files on different file systems, take the 
number of processes up into the hundreds and database sizes into the 
hundreds of GB.  To keep test times reasonable, use the smallest numbers 
that give insightful results (after a point, making things bigger adds 
more time, but does not yield additional insights into system behavior, 
which is what we are trying to achieve).

Regards
-- Bhaskar

_____________

The information contained in this message is proprietary and/or confidential. If you are not the 
intended recipient, please: (i) delete the message and all copies; (ii) do not disclose, 
distribute or use the message in any manner; and (iii) notify the sender immediately. In addition, 
please be aware that any message addressed to our domain is subject to archiving and review by 
persons other than the intended recipient. Thank you.
_____________
