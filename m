From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/4] fdomain: Resurrect driver (core)
Date: Mon, 29 Apr 2019 04:51:02 -0700
Message-ID: <20190429115102.GB25365@infradead.org>
References: <20190422173323.15365-1-linux@zary.sk>
 <20190422173323.15365-2-linux@zary.sk>
 <20190424060212.GA5506@infradead.org>
 <201904282152.32077.linux@zary.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201904282152.32077.linux@zary.sk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@zary.sk>
Cc: Christoph Hellwig <hch@infradead.org>, Rik Faith <faith@cs.unc.edu>, "David A . Hinds" <dahinds@users.sourceforge.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Apr 28, 2019 at 09:52:31PM +0200, Ondrej Zary wrote:
> On Wednesday 24 April 2019 08:02:12 Christoph Hellwig wrote:
> > > +static void fdomain_work(struct work_struct *work)
> > > +{
> > > +	struct fdomain *fd = container_of(work, struct fdomain, work);
> > > +	struct Scsi_Host *sh = container_of((void *)fd, struct Scsi_Host,
> > > +					    hostdata);
> > 
> > This looks odd.  We should never need a void cast for container_of.
> 
> This cast is present in all drivers involving container_of, struct Scsi_Host and hostdata. hostdata in struct Scsi_Host is defined as "unsigned long hostdata[0]"...

Oh, right - it is the hostdata mess.  Sorry for the noise!
