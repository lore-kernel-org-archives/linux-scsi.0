From: Mark Vitnell <marklv@swiftdsl.com.au>
Subject: Re: sym-2.1.18j Phase Change 6-7
Date: Sun, 13 Mar 2005 10:35:34 +1100
Message-ID: <a3bdf67ec1c88c470fa8712fba3b2d33@swiftdsl.com.au>
References: <423337AA.2000200@ad2u.ath.cx>
Mime-Version: 1.0 (Apple Message framework v619.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Received: from smtp.syd.swiftdsl.com.au ([218.214.224.138]:32464 "HELO
	smtp.syd.swiftdsl.com.au") by vger.kernel.org with SMTP
	id S262393AbVCLXfs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Mar 2005 18:35:48 -0500
In-Reply-To: <423337AA.2000200@ad2u.ath.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jackie Ferrera <jf@ad2u.ath.cx>
Cc: linux-scsi@vger.kernel.org


On 13/03/2005, at 5:40, Jackie Ferrera wrote:

> I didn't find anyone else reporting this issue on linux-scsi.

I reported this problem back on  November 17, 2004,  but got no 
interest from the list.

> Actually, i have only found some fedora core users experiencing the 
> same problem and reporting it (see 
> https://bugzilla.redhat.com/bugzilla/long_list.cgi?buglist=139949), 
> although the problem doesnt appear to be redhat-specific (i 've tried 
> it with slackware). Pardon me if this is a known bug, i am first-time 
> poster on this list.
> I have been giving it a shot with vanilla kernel sources (straight 
> from kernel.org 2.6.9, 2.6.10, 2.6.11), and the error persists. 
> 2.6.11.1 and 2.6.11.2 dont have any changes in SCSI that would affect 
> the sym driver in their tiny changelog, so i havent tried them yet.

> The box is a dual i386, but i 've also been running non-SMP kernels 
> for my tests, producing the same results.
>
> My controller shows up like this in `lspci -v`:
> 01:05.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 
> Ultra3 SCSI Adapter (rev 01)
>        Flags: bus master, medium devsel, latency 72, IRQ 24
>        I/O ports at e400 [size=256]
>        Memory at febfe000 (64-bit, non-prefetchable) [size=1K]
>        Memory at febfa000 (64-bit, non-prefetchable) [size=8K]
>        Capabilities: [40] Power Management version 2
>
>
> When i run 2.6.9, 2.6.10 or 2.6.11, the sym kernel module produces 
> massive amounts of syslog traffic and logs. The message in syslog 
> looks like this:
>
> kernel: sym0:0:0:phase change 6-7 11 2e37a784 resid=6.
>
> As a temporary solution to overcome this and do my performance tests, 
> i just adjusted syslogd on that server not to log any kern messages 
> from syslog.conf.
>
> Still, performance degrades on my 10K rpm harddrives at 3mb/sec.
> In my humble opinion(i am not a kernel developer or expert), it 
> appears that some changes done in the code for scsi (API?) in the 
> linux kernel tree, were not correctly implemented in the sym driver.

The problems with the phase change errors seemed to have been fixed for 
me when I patched the 2.6.10 kernel with the sym_2.1.18n patch released 
by Mathew Wilcox on December 30. Though this was incorporated in the 
2.6.11 kernel, so your issues may be different. All my tests were with 
kernel.org sources without any distribution specific patches.


>
> The controller works fine with 2.6.8.1(vanilla). Anything later than 
> 2.6.8.1 in my tests, was prone to these errors and the performance 
> degrade.
>
> Has anyone else experienced this issue? Are there any steps i can 
> take(hopefully a patch?) that would fix it?
>

Try patching 2.6.11.2 with sym2_2.2.0 released yesterday,  perhaps?

Good luck

Mark Vitnell

