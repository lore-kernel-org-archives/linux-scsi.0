From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: Enterprise workload testing for storage and filesystems
Date: Fri, 21 Nov 2008 11:18:43 -0500
Message-ID: <4926DF63.1030107@hp.com>
References: <1226962063.3403.13.camel@localhost.localdomain> <x49y6zegjum.fsf@segfault.boston.devel.redhat.com> <4926DAFC.5070006@fnis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:23349 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbYKUQTU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Nov 2008 11:19:20 -0500
In-Reply-To: <4926DAFC.5070006@fnis.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K.S. Bhaskar" <ks.bhaskar@fnis.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org

K.S. Bhaskar wrote:
> On 11/20/2008 04:37 PM, Jeff Moyer wrote:
>> James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> [KSB] <...snip...>
> 
>>  > Let's see how our storage and filesystem tuning measures up to this.
>>
>> This is indeed great news!  The tool is very flexible, so I'd like to
>> know if we can get some sane configuration options to start testing.
>> I'm sure I can cook something up, but I'd like to be confident that what
>> I'm testing does indeed reflect a real-world workload.
> 
> [KSB] Here are numbers for some tests that we ran recently:
> 
> io_thrash -o 4 4 testdb 4000000 100000 12 8192 512 1000 90 90 10 512
> io_thrash -o 4 4 testdb 4000000 100000 12 8192 512 10000 90 90 10 512
> io_thrash -o 4 4 testdb 4000000 100000 12 8192 512 100000 90 90 10 512
> io_thrash -o 4 4 testdb 4000000 100000 12 8192 512 200000 90 90 10 512
> 
> Note that these are relatively modest tests (4x32GB database files, all
> on one file system, 12 processes).  To simulate bigger loads, allow the
> journal file sizes to grow to 4GB, use a configuration file to spread
> the database and journal files on different file systems, take the
> number of processes up into the hundreds and database sizes into the
> hundreds of GB.  To keep test times reasonable, use the smallest numbers
> that give insightful results (after a point, making things bigger adds
> more time, but does not yield additional insights into system behavior,
> which is what we are trying to achieve).
> 
> Regards
> -- Bhaskar

Thanks for additional feedback Bhaskar - I've been playing with this
on-and-off the last couple of days trying to stress one testbed (16 way
AMD, 128GB RAM, two P800 Smart Arrays (48 disks total put into a single
LVM2/DM volume)). I've been able to get the I/O subsystem 100% utilized,
but in so doing really didn't stress the system (something like 80-90%
idle).

In order to stress the whole system, it sounds like it _may_ be better
to use 48 separate file systems on 48 separate platters (each with its
own DB)? Or are there other knobs to play with to get more of the system
involved besides the I/O? Is it a good idea to separate the journals
from the DB (separate FS/platter)?

Regards,
Alan
