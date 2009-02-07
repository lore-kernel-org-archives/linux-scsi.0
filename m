From: Ric Wheeler <rwheeler@redhat.com>
Subject: TRIM vs UNMAP vs WRITE SAME and thin devices
Date: Sat, 07 Feb 2009 09:53:06 -0500
Message-ID: <498DA052.6090605@redhat.com>
References: <20090123041558.GC24652@parisc-linux.org>	 <4979AF62.7070409@redhat.com> <1232721777.4430.7.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1232721777.4430.7.camel@macbook.infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <mkp@mkp.net>
Cc: Matthew Wilcox <matthew@wil.cx>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


I have been poked at by some vendors about the status of our support for 
the virtually/thinly provisioned luns since they are getting close to 
being able to test with real devices.

My quick summary is that we most of the work so far has been done 
without any real hardware to play with - in 2.6.29-rc3, I don't see any 
low level ATA or SCSI bits that turn requests tagged with REQ_DISCARD 
into the specific ATA or SCSI commands. Did I miss something & if not, 
do we have plans to push anything upstream soonish?

One note on the SCSI devices, there was a T10 proposal to add an "UNMAP" 
bit to the "WRITE SAME" command for SCSI. The details of the proposed 
interface are at:

http://www.t11.org/t10/document.08/08-356r4.pdf

The up side of using WRITE SAME with unmap is that there are no fuzzy 
semantics about what the unmapped sectors will be - they will all be 
whatever the WRITE SAME command would have set (usually zeroes I assume).

The summary of write same is that you send down one sector (say 512 
bytes of zeroes) and a count so you can do a zeroing of the target 
without having to send all of the data over the wire. Very useful for 
initializing members of a RAID device for example to a known pattern.

The down side would be that if we incorrectly send down a WRITE SAME 
command to a non-thin device, I think that we would kick off a potential 
extremely long IO. For example, imagine doing a write same of a full TB 
- that could take an hour which might be an issue :-)  Of course, we 
should not be doing that if we get the code right.

I don't see another of the PDF's claims of advantages for file systems 
to be really all that useful.

With either the write same and its proposed unmap bit or with the 
original T10 unmap, do we have a short list of infrastructure that needs 
fleshed out? Anything we can do to help get peoples patches to test with 
their non-GA thin enabled devices?

Is there a similar short list of things to be done for T13 devices with 
TRIM? Anyone have a chance to test on real hardware yet?

Thanks!

Ric

