From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Date: Fri, 18 Jul 2014 17:41:05 +0000
Message-ID: <1405705265.30262.6.camel@dabdike.int.hansenpartnership.com>
References: <1401899623-24194-1-git-send-email-kys@microsoft.com>
 <1401901323.17510.23.camel@dabdike>
 <d61f4b87a72544e4b0c1e1872a76f97b@BY2PR03MB299.namprd03.prod.outlook.com>
 <53911A35.7010805@cs.wisc.edu>
 <d9854e6ff97f4b0087dbe835a2a57c8f@BY2PR03MB299.namprd03.prod.outlook.com>
 <5391F801.4010107@cs.wisc.edu>
 <1402077167.2207.89.camel@dabdike.int.hansenpartnership.com>
 <539206FA.1020001@kernel.dk>
 <5b926a0a9f264edda91c7c2ab0acb7d1@BY2PR03MB299.namprd03.prod.outlook.com>
 <13807d2cc8744ae1bc374f20d8f9caec@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <94D0CD8314A33A4D9D801C0FE68B402958BAC6DC@G9W0745.americas.hpqcorp.net>
 <1405697964.605.27.camel@jarvis.lan>
 <94D0CD8314A33A4D9D801C0FE68B402958BB2E3D@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958BB2E3D@G9W0745.americas.hpqcorp.net>
Content-Language: en-US
Content-ID: <DC7C435926D54140964D7B31731A79EC@sw.swsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "Elliott@hp.com" <Elliott@hp.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-07-18 at 17:17 +0000, Elliott, Robert (Server Storage)
wrote:
> 
> 
> > From: James Bottomley [mailto:jbottomley@parallels.com]
> > 
> > On Fri, 2014-07-18 at 00:51 +0000, Elliott, Robert (Server Storage)
> > wrote:
> ...
> > >
> > > Also, in both sd_setup_flush_cmnd and sd_sync_cache:
> > >       cmd->cmnd[0] = SYNCHRONIZE_CACHE;
> > >       cmd->cmd_len = 10;
> > >
> > > SYNCHRONIZE CACHE (16) should be favored over SYNCHRONIZE
> > > CACHE (10) unless SYNCHRONIZE CACHE (10) is not supported.
> 
> (sorry - meant "unless ... 16 is not supported")

Yes, I guessed that?

> > For what reason.  We usually go for the safe alternatives, which is 10
> > byte commands because they have the widest testing and greatest level of
> > support.  We don't do range flushes currently, so there doesn't seem to
> > be a practical different.  If we did support range flushes, we'd likely
> > only use SC(16) on >2TB devices.
> > 
> > James
> 
> A goal of the simplified SCSI feature set idea is to drop all the
> short CDBs that have larger, more capable equivalents - don't carry
> READ 6/10/12/16 and SYNCHRONIZE CACHE 10/16, just keep the 16-byte 
> versions.  With modern serial IU-based protocols, short CDBs don't 
> save any transfer time.  This will simplify design and testing on
> both initiator and target sides. Competing command sets like NVMe 
> rightly point out that SCSI has too much legacy baggage - all you 
> need for IO is one READ, one WRITE, and one FLUSH command.

But that's not relevant to us.  This is the problem of practical vs
standards approaches.  We have to support older and buggy devices.  Most
small USB storage sticks die if they see 16 byte CDB commands because
their interpreters.  The more "legacy baggage" the standards committee
dumps, the greater the number of heuristics OSs have to have to cope
with the plethora of odd devices.

> That's why SBC-3 ended up with these warning notes for all the
> non-16 byte CDBs:
> 
> 	NOTE 15 - Migration from the SYNCHRONIZE CACHE (10) command to
> 	the SYNCHRONIZE CACHE (16) command is recommended for all
> 	implementations.
> 
> If the LBA field in SYNCHRONIZE CACHE went obsolete, then maybe
> SYNCHRONIZE CACHE (10) would be kept instead of (16), but that
> field is still present.  So, (16) is the likely survivor.

OK, but look at it from our point of view:  The reply above justifies
why we prefer 10 byte CDBs over 16.  If the standards body ever did
remove SC(10) completely, then we'd have to have yet another heuristic
to recognise devices that don't support SC(10), but until that day,
using SC(10) alone works in all cases, so is the better path for the OS.

If you could, please get the standards body to recognise that the more
command churn they introduce (in the name of rationalisation or
whatever), the more problems they introduce for Operating Systems and
the more likelihood (because of different people reading different
revisions of standards) that we end up with compliance bugs in devices.

James
