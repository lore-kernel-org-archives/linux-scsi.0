From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Date: Fri, 18 Jul 2014 17:05:45 +0000
Message-ID: <7c46a791325a40fd82572fd3a09726d9@BY2PR0301MB0711.namprd03.prod.outlook.com>
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
 <20140718151039.GA7425@infradead.org>
 <2d43adebbc47441084d8e1284507a427@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <1405702633.30262.3.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1405702633.30262.3.camel@dabdike.int.hansenpartnership.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:jbottomley@parallels.com]
> Sent: Friday, July 18, 2014 9:57 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; hch@infradead.org; apw@canonical.com;
> devel@linuxdriverproject.org; michaelc@cs.wisc.edu; axboe@kernel.dk;
> linux-scsi@vger.kernel.org; ohering@suse.com;
> gregkh@linuxfoundation.org; jasowang@redhat.com
> Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT
> from the basic I/O timeout
> 
> On Fri, 2014-07-18 at 16:44 +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: Christoph Hellwig (hch@infradead.org)
> > > [mailto:hch@infradead.org]
> > > Sent: Friday, July 18, 2014 8:11 AM
> > > To: KY Srinivasan
> > > Cc: Jens Axboe; James Bottomley; michaelc@cs.wisc.edu; Christoph
> > > Hellwig (hch@infradead.org); linux-scsi@vger.kernel.org;
> > > gregkh@linuxfoundation.org; jasowang@redhat.com; linux-
> > > kernel@vger.kernel.org; ohering@suse.com; apw@canonical.com;
> > > devel@linuxdriverproject.org
> > > Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the
> > > FLUSH_TIMEOUT from the basic I/O timeout
> > >
> > > On Thu, Jul 17, 2014 at 11:53:33PM +0000, KY Srinivasan wrote:
> > > > I still see this problem. There was talk of fixing it elsewhere.
> > >
> > > Well, what we have right not is entirely broken, given that the
> > > block layer doesn't initialize ->timeout on TYPE_FS requeuests.
> > >
> > > We either need to revert that initial commit or apply something like
> > > the attached patch as a quick fix.
> > I had sent this exact patch sometime back:
> >
> > http://www.spinics.net/lists/linux-scsi/msg75385.html
> 
> Actually, no you didn't.  The difference is in the derivation of the timeout.
> Christoph's patch is absolute in terms of SD_TIMEOUT; yours is relative to the
> queue timeout setting ... I thought there was a reason for preferring the
> relative version.

You are right; sorry about that. I think my version is better since we do want to base the
flush timeout relative to the basic timeout.

K. Y
> 
> James
