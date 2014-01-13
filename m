From: Todd E Brandt <todd.e.brandt@linux.intel.com>
Subject: Re: [PATCH/RESEND v2 1/2] Hard disk S3 resume time optimization
Date: Mon, 13 Jan 2014 12:06:48 -0800
Message-ID: <20140113200648.GB13900@linux.intel.com>
References: <20140108005607.GB29556@linux.intel.com>
 <52CED67E.7080706@ubuntu.com>
 <11E08D716F0541429B7042699DD5C1A17073C362@FMSMSX103.amr.corp.intel.com>
 <52D0A8B4.90905@ubuntu.com>
 <CAA9_cmdkNNfE8-b60x4ULw6OA+zxrVZoJhEX3a5XZOQKnsqfHg@mail.gmail.com>
Reply-To: todd.e.brandt@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAA9_cmdkNNfE8-b60x4ULw6OA+zxrVZoJhEX3a5XZOQKnsqfHg@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: tj@kernel.org, James.Bottomley@hansenpartnership.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, psusi@ubuntu.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 10, 2014 at 07:13:11PM -0800, Dan Williams wrote:
> On Fri, Jan 10, 2014 at 6:13 PM, Phillip Susi <psusi@ubuntu.com> wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA512
> >
> > On 01/10/2014 06:11 PM, Brandt, Todd E wrote:
> >> Yes yours is simpler, but it also opens a potential memory issue
> >> by passing a static int as the return location for the error value.
> >> I think it's just safer to tell the callback to attempt no return
> >> value at all, and for that you need to expand it into two
> >> arguments, one for selection, the other for the output address.
> >
> > What sort of memory issue?  Also isn't there a system NULL page
> > somewhere that could be used?
> >
> 
> I think the static variable is ok.  We can be sure that all eh threads
> are torn down before libata.ko is unloaded.

Actually there's one other reason. In the ata_port_request_pm function it
checks to see if there's a previous resume operation pending, and if so
it calls ata_port_wait_eh in order to wait for it to complete before 
issuing the new suspend. If you just use the (int*)async parameter it
will return immediately and defer to the caller to try again, like is does
with SAS. But in our case we *don't* try again, so it would result in the
resume being skipped. There needs to be a new case where the caller wants 
the call to be asynchronous, and it wants ata_port_request_pm to do its 
own waiting, but doesn't care about the return value. Thus the additional
parameter.
