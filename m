From: Bernd Schubert <bs@q-leap.de>
Subject: fusion problem (was Re: [PATCH] scsi device recovery)
Date: Fri, 14 Dec 2007 12:26:08 +0100
Message-ID: <200712141226.09467.bs@q-leap.de>
References: <200712121354.14474.bs@q-leap.de> <200712121854.42669.bs@q-leap.de> <1197555513.3154.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:39142 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759269AbXLNL0L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Dec 2007 06:26:11 -0500
In-Reply-To: <1197555513.3154.30.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>

On Thursday 13 December 2007 15:18:33 James Bottomley wrote:
> On Wed, 2007-12-12 at 18:54 +0100, Bernd Schubert wrote:
> > [Hmm, resending since mail after more than 30min still not on the ML,
> > maybe the attachment was too large? I have uploaded the log to
> > http://www.pci.uni-heidelberg.de/tc/usr/bernd/downloads/scsi/kern.log.1]
> >
> > On Wednesday 12 December 2007 16:59:36 James Bottomley wrote:
> > > On Wed, 2007-12-12 at 15:36 +0100, Bernd Schubert wrote:
> > > > On Wednesday 12 December 2007 14:39:27 Matthew Wilcox wrote:
> > > > > On Wed, Dec 12, 2007 at 01:54:14PM +0100, Bernd Schubert wrote:
> > > > > > below is a patch introducing device recovery, trying to prevent
> > > > > > i/o errors when a DID_NO_CONNECT or SOFT_ERROR does happen.
> > > > >
> > > > > Why doesn't the regular scsi_eh do what you need?
> > > >
> > > > First of all, it is presently simply not called when the two errors
> > > > above do happen. This could be changed, of course.
> > >
> > > Erm, I think you'll find the error handler does activate on
> > > DID_SOFT_ERROR.  It causes a retry via the eh.  DID_NO_CONNECT is an
> >
> > Dec  7 23:48:45 beo-96 kernel: [94605.297924] sd 2:0:5:0: [sdd] Result:
> > hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
> > Dec  7 23:48:45 beo-96 kernel: [94605.297932] end_request: I/O error, dev
> > sdd, sector 7706802052
> > Dec  7 23:48:45 beo-96 kernel: [94605.297937] raid5:md5: read error not
> > correctable (sector 871932472 on sdd3).
>
> This is some type of ioc internal error.  What we do on DID_SOFT_ERROR
> is retry for the usual number of times up to the timeout limit.
> Unfortunately, the retries are fixed at SD_MAX_RETRIES in sd.c.  Without
> diagnosing what's going wrong in the fusion, it's impossible to say if
> this is reasonable, but your fusion is signalling ioc errors (firmware
> errors).

Yes, I also think this is a fusion problem, if I'm not entirely mistaken, 
it does a DV for the wrong host.

Dec  6 22:32:33 beo-96 kernel: [  106.478866] ioc0: 53C1030: Capabilities={Initiator}
Dec  6 22:32:33 beo-96 kernel: [  106.923643] scsi2 : ioc0: LSI53C1030, FwRev=01033010h, Ports=1, MaxQ=222, IRQ=16
Dec  6 22:32:33 beo-96 kernel: [  107.939374] scsi 2:0:4:0: Direct-Access     IFT      A16U-G2430       348E PQ: 0 ANSI: 5
Dec  6 22:32:33 beo-96 kernel: [  107.947632]  target2:0:4: Beginning Domain Validation
[...]
Dec  6 22:32:33 beo-96 kernel: [  108.157159] scsi 2:0:5:0: Direct-Access     IFT      A16U-G2430       348E PQ: 0 ANSI: 5
Dec  6 22:32:33 beo-96 kernel: [  108.165396]  target2:0:5: Beginning Domain Validation
[...]
Dec  6 22:32:33 beo-96 kernel: [  110.625321] mptbase: Initiating ioc1 bringup
Dec  6 22:32:33 beo-96 kernel: [  111.117987] ioc1: 53C1030: Capabilities={Initiator}
Dec  6 22:32:33 beo-96 kernel: [  111.562771] scsi3 : ioc1: LSI53C1030, FwRev=01033010h, Ports=1, MaxQ=222, IRQ=17
Dec  6 22:32:33 beo-96 kernel: [  113.829617] scsi 3:0:10:0: Direct-Access     IFT      A16U-G2430       348E PQ: 0 ANSI: 5
Dec  6 22:32:33 beo-96 kernel: [  113.837929]  target3:0:10: Beginning Domain Validation
[...]
Dec  6 22:32:33 beo-96 kernel: [  114.083750] scsi 3:0:11:0: Direct-Access     IFT      A16U-G2430       348E PQ: 0 ANSI: 5
Dec  6 22:32:33 beo-96 kernel: [  114.092085]  target3:0:11: Beginning Domain Validation

[...]

So ioc0 is target2 with id 4 and 5. Ioc1 is target3 with id 10 and 11. 

As you can see from the logs I posted before and for completeness 
below again, the troublesome Infortrend box was on ioc1 (target3), 
but sometimes there have been domain validations for target2. 
For me the syslog suggests it simply did the DV to the wrong host.

Dec  7 23:45:14 beo-96 kernel: [94142.892782] mptbase: Initiating ioc1 recovery
Dec  7 23:45:14 beo-96 kernel: [94156.622334] mptscsih: ioc1: Issue of TaskMgmt failed!
Dec  7 23:45:14 beo-96 kernel: [94156.627458] mptscsih: ioc1: target reset: FAILED (sc=ffff8100aff2fcc0)
Dec  7 23:45:14 beo-96 kernel: [94156.634059] scsi_eh_ready_devs: !scsi_eh_bus_device_reset(), sleeping 10s
Dec  7 23:45:14 beo-96 kernel: [94156.640999]  target2:0:4: Beginning Domain Validation
Dec  7 23:45:14 beo-96 kernel: [94156.646242] 0/3 read DV
Dec  7 23:45:14 beo-96 kernel: [94156.648954]  target2:0:4: Domain Validation Initial Inquiry Failed
Dec  7 23:45:14 beo-96 kernel: [94156.655191]  target2:0:4: Ending Domain Validation


Best,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH
