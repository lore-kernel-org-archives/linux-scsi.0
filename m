From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [LSF/MM TOPIC] atomic block device
Date: Sat, 15 Feb 2014 12:25:02 -0800
Message-ID: <1392495902.2178.27.camel@dabdike.int.hansenpartnership.com>
References: <CAA9_cmf7Y1TL8XqR7dYUn=Pv-En2e0X0FM0zdpkiBkUuNBGKfQ@mail.gmail.com>
	 <1392487335.2178.5.camel@dabdike.int.hansenpartnership.com>
	 <CABBL8E+dQPi=N108+z97F54o=xg7vYk5T1JCBGY+9UetiC6qTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CABBL8E+dQPi=N108+z97F54o=xg7vYk5T1JCBGY+9UetiC6qTg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andy Rudoff <andy@rudoff.com>
Cc: Dan Williams <dan.j.williams@intel.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, jmoyer@redhat.com, david@fromorbit.com, Chris Mason <clm@fb.com>, Jens Axboe <axboe@kernel.dk>, Bryan E Veal <bryan.e.veal@intel.com>, Annie Foong <annie.foong@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Lameter <christoph@lameter.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2014-02-15 at 11:15 -0700, Andy Rudoff wrote:
> > OK, I'm prepared to look through it, but I should warn you that after
> > the SNIA HBAAPI cluster fuck I'm not well disposed towards any APIs that
> > come out of SNIA.  I've read the first 30 pages and they don't inspire
> > confidence; it's basically going the same way as HBA API.  The failure
> > there was trying to define universal interfaces for every OS regardless
> > of the existing interfaces they currently had.  this NVM model seems to
> > define a lot of existing stuff in block and VFS but slightly
> > differently.  Why do you think it's a good idea?
> 
> Note that the NVMP workgroup did not define any APIs.  Instead, we
> concentrated on defining the actions that we see applications needing
> (or being able to use) and defining some common terminology.  We leave
> the API defintion to the operating system authors so they can create
> them in the way that makes the most sense for their environment (much
> like you are suggesting above, I think).

Well, the actions had define input and output properties ... we can
argue about what level of semantics you have to define before an action
becomes an API, but the real question 

> > I'll further add  what we really need are use cases, not an API
> > chocolate box.  I think some DB people will be coming to LSF, so we
> > should really talk use cases with them.
> 
> Totally agree.

OK, so what the Database people are currently fretting about is how the
Linux cache fights with the WAL.  Pretty much all DBs sit on filesystems
these days, so the first question is are block operations even relevant
and do the (rather scant) file operations fit their need.  The basic
problem with the file mode is the granularity.  What does a DB do with
transactions which go over the limits?  It also looks like the NVM file
actions need to work over DIO, so the question is how. (And the other
problem is that only a few DBs seem to use DIO).

James


