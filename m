From: James Bottomley <jbottomley@parallels.com>
Subject: Re: Drivers: scsi: FLUSH timeout
Date: Thu, 3 Oct 2013 14:01:45 +0000
Message-ID: <1380808905.2109.7.camel@dabdike.int.hansenpartnership.com>
References: <1379705547-15028-1-git-send-email-kys@microsoft.com>
	 <20130920203222.GA14306@kroah.com>
	 <a97d266e2c284d688d2dd7ad43f179b8@SN2PR03MB061.namprd03.prod.outlook.com>
	 <524180B7.7090307@gmail.com>
	 <3413dbd7fa254fd380a84fe6d9cd87e1@SN2PR03MB061.namprd03.prod.outlook.com>
	 <5241C9E7.2000404@cs.wisc.edu>
	 <bf168ab724a140f989ab3dfe877b750f@SN2PR03MB061.namprd03.prod.outlook.com>
	 <CAMuHMdV-BsKc-c1YhzqFrUGJhw+jMZEXXTcT2xyDLnw-JQuVaQ@mail.gmail.com>
	 <ff6a93ed5d234c14874d03415812a3ec@SN2PR03MB061.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ff6a93ed5d234c14874d03415812a3ec@SN2PR03MB061.namprd03.prod.outlook.com>
Content-Language: en-US
Content-ID: <BA0BDADA39C16F4BBE2303AE28A8C7FC@sw.swsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Mike Christie <michaelc@cs.wisc.edu>, Jack Wang <xjtuwjp@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-10-02 at 18:29 +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: geert.uytterhoeven@gmail.com [mailto:geert.uytterhoeven@gmail.com]
> > On Behalf Of Geert Uytterhoeven
> > Sent: Wednesday, September 25, 2013 1:40 AM
> > To: KY Srinivasan
> > Cc: Mike Christie; Jack Wang; Greg KH; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; ohering@suse.com; jbottomley@parallels.com;
> > hch@infradead.org; linux-scsi@vger.kernel.org
> > Subject: Re: Drivers: scsi: FLUSH timeout
> > 
> > On Tue, Sep 24, 2013 at 11:53 PM, KY Srinivasan <kys@microsoft.com> wrote:
> > > I am not sure how that magic number was arrived at (the 60HZ number). We
> > want this to be little higher -
> > 
> > "60 * HZ" means "60 seconds".
> > 
> > > would there be any issues raising this to say  180 seconds. This is the value we
> > currently have for I/O
> > > timeout.
> > 
> > So you want to replace it by "180 * HZ", which is ... another magic number?
> 
> Ideally, I want this to be adjustable like the way we can change the I/O timeout.
> Since that has been attempted earlier and rejected (not clear what the reasons were),
> I was suggesting that we pick a larger number. James, let me know how I should proceed here.

It's only one problem device with its own driver, right?  how about a
per target value you set in target_configure?  That way there's no
damage to the rest of the system even in a mixed device environment.  I
don't see a particular need to expose this via sysfs unless someone else
has a use case.

James
