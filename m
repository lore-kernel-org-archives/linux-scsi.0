From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: aic7xxx woes in 2.5
Date: Sun, 15 Dec 2002 13:09:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <23290000.1039982976@aslan.btc.adaptec.com>
References: <3DFC059A.9AA3F75F@digeo.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3DFC059A.9AA3F75F@digeo.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>, linux-scsi@vger.kernel.org

> For about six months in the 2.5 series, using aic7xxx, about every fourth
> boot one of my disks tends to get:
> 
> (scsi1:A:4:0): parity-error detected in Data-in phase: SEQADDR(0x1ae)
> SCSIRATE(0x88) scsi1:0:4:0: Attempting to queue an ABORT message
> 
> This is invariably fatal.

...

> This never happens in 2.4 kernels.
> 
> It seems to happen a little more frequently on uniprocessor builds.
> 
> So relevant questions would be:
> 
> 1) Why does only 2.5 get the parity error?

Most likely different loads on your SCSI bus.  The driver can't "make up"
SCSI bus parity errors.

> 2) Why does the recovery lock up?

I would actually have to know the sequencer instruction that we
are blocked on in the clear_critical_sections code to be able to
say.  Several recovery bugs have been fixed in later driver versions.

> 3) Does anyone have a diff for Justin's new driver?

Just populate the scsi/aic7xxx directory with the files found
here:

http://people.FreeBSD.org/~gibbs/linux/SRC/

You will need to merge in the Kconfig and Makefile for the scsi
directory, but if you are running a fairly recent kernel, you
can just overwrite those files with those supplied in the linux-2.5
archive supplied at the above URL.

--
Justin
