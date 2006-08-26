From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Open for adoption: orphan sbp2_target
Date: Sat, 26 Aug 2006 13:48:08 +0900
Message-ID: <200608260448.k7Q4m8rq019092@r-dd.iij4u.or.jp>
References: <5b45756a0608141057s6c00d7cfu388d9d342c5e936d@mail.gmail.com>
	<44ED996A.4010009@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <44ED996A.4010009@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: stefanr@s5r6.in-berlin.de
Cc: michaelc@cs.wisc.edu, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, hani.mustafa@gmail.com, tomof@acm.org
List-Id: linux-scsi@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Open for adoption: orphan sbp2_target
Date: Thu, 24 Aug 2006 14:19:54 +0200

> Hani Mustafa wrote to linux1394-devel on 2006-08-14:
> > I had finished writing an sbp2_target implementation in the linux
> > kernel a year or so ago and was hoping I could get the time to polish
> > it, but it got stuck in a vicious procrastination loop.
> > 
> > The implementation worked fine with a usb-storage device (as it
> > appears as a SCSI device) against windows/linux/mac, but otherwise
> > panics the kernel when it is a real SCSI controller. Probably
> > something wrong with the way I acquire and post CDB's to the SCSI
> > device.
> > 
> > In anycase, if anyone has the motivation to toss this project from the
> > ears into a working module, you are more than welcome to contact me
> > directly.
> 
> Perhaps you are aware of Manish Singh's SBP-2 target implementation
> called Endpoint, http://oss.oracle.com/projects/endpoint/. I haven't
> tested it myself yet. AFAIU it runs completely in userspace on top of
> libraw1394 and implements (only?) RBC. It is available under GPL.
> 
> An alternative in-kernel implementation might be interesting
> nevertheless because /a/ performance optimization might be easier and
> /b/ it could perhaps be adapted to the upcoming generic SCSI target
> framework,
> http://kernel.org/git/?p=linux/kernel/git/jejb/scsi-target-2.6.git .
> This framework pushes parts of the required functionality into userspace
> though. I didn't look into the particular goals and features of this
> framework yet. Maybe I am wrong and the SBP-2 specific parts to add to
> the SCSI target framework would rather end up in userspace, I don't know.
> 
> Could someone of the SCSI target folks give a rough outline of a SCSI
> target's building blocks when using this framework?

Our OLS's paper and slides have good pictures.

http://stgt.berlios.de/

I guess that SBP target stuff works well with the target
framework. All you need to do is to take care of SBP protocol. The
framework does the rest, that is, SCSI protocol processing, I/O,
logical unit management, configuration, etc.

For example, your driver receives a SCSI command from an initiator,
tell the framework to perform it. Then the framework sends back the
result and buffer containing data you send to the initiator if
necessary.

I don't know where your driver is implemented, in kernel space or user
space. The framework was designed for the former, however, it works
with both models now. You can find an example of the latter (though
it's just experiment):

svn co http://svn.berlios.de/svnroot/repos/stgt/branches/user-iscsi


BTW, we've prepared a new git tree:

http://www.kernel.org/git/?p=linux/kernel/git/mnc/linux-2.6-target.git;a=summary

-------------------------------------------------------------------------
Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
