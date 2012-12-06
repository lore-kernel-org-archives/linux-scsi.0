From: Chris Friesen <chris.friesen@genband.com>
Subject: Re: getting I/O errors in super_written()...any ideas what would
 cause this?
Date: Thu, 06 Dec 2012 12:15:32 -0600
Message-ID: <50C0E0C4.9050400@genband.com>
References: <8134827.27.1354128708501.JavaMail.root@zimbra>		<50B67230.4080602@genband.com>	 <CADNH=7Hv2RgBv=0Xia=yMyzKmgAOgvxJSAKn2arcE7k1x_T4FQ@mail.gmail.com>	 <50B67417.2020606@genband.com> <50BD09EC.5060705@redhat.com>	 <50BD0F44.7010808@genband.com> <50BD1127.6090304@redhat.com>	 <50BD14B1.7000203@genband.com> <50BD1F45.1040802@redhat.com>	 <50BE7293.8060200@genband.com> <1354699254.2243.5.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1354699254.2243.5.camel@dabdike.int.hansenpartnership.com>
Sender: linux-raid-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Neil Brown <neilb@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 12/05/2012 03:20 AM, James Bottomley wrote:
> On Tue, 2012-12-04 at 16:00 -0600, Chris Friesen wrote:
>> As another data point, it looks like we may be doing a SEND DIAGNOSTIC
>> command specifying the default self-test in addition to the background
>> short self-test.  This seems a bit risky and excessive to me, but
>> apparently the guy that wrote it is no longer with the company.
>
> This is a really bad idea.  A lot of disks go out to lunch until the
> diagnostics complete (the same goes for SMART diagnostics).  This means
> that if you do diagnostics on a running device, the drivers start to get
> timeouts on commands which are queued waiting for diagnostics to
> complete ... if those go over the standard SCSI timeouts, we'll start to
> try error recovery and likely have the disaster you see above.

So it turns out that our problems are intermittently triggered when 
running the default self test.  This agrees with the statement in 
sg_senddiag to not do foreground self-tests on disks with mounted 
filesystems.

We seem to be able to do background short self-tests (ie, SEND 
DIAGNOSTIC command with self-test code of 001b and ST code of 0b) 
without causing any problems.  Is this pushing our luck or is this 
something that should work according to the spec and the linux stack? 
The scsi spec indicates that in this case for most commands the test 
will be paused and the command executed within 2 seconds, but I don't 
know what the normal scsi timeouts are.

Thanks for the input, this is very useful.

Chris
