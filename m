From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v5 3/3] scsi: async sd resume
Date: Sun, 16 Mar 2014 11:21:30 -0700
Message-ID: <1394994090.2167.15.camel@dabdike.int.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1403101658490.5966-100000@netrider.rowland.org>
	 <1394511589.2142.5.camel@dabdike.int.hansenpartnership.com>
	 <CAPcyv4gJssEE7hADEDXmi4ao031uSVjMenKk9AFcbTukm1MKNg@mail.gmail.com>
	 <1394515014.2142.11.camel@dabdike.int.hansenpartnership.com>
	 <CAPcyv4gLEQ9-e2GJpfbQQ+DN+nsv-90oFwXxh-_K_hU0z4U5YQ@mail.gmail.com>
	 <1394519379.2142.13.camel@dabdike.int.hansenpartnership.com>
	 <CAPcyv4iVMss=Vj8O9RR2GGCw-4uesw1MKj-qFuaXZqtTz1Cqdg@mail.gmail.com>
	 <1394920072.2166.29.camel@dabdike.int.hansenpartnership.com>
	 <CAPcyv4hQXf=u8WZyRfCBz=y_nVAuTredCBu2T=Rk9R1N1U6k5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4hQXf=u8WZyRfCBz=y_nVAuTredCBu2T=Rk9R1N1U6k5Q@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Len Brown <len.brown@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, Phillip Susi <psusi@ubuntu.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, Todd Brandt <todd.e.brandt@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2014-03-15 at 16:35 -0700, Dan Williams wrote:
> On Sat, Mar 15, 2014 at 2:47 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Fri, 2014-03-14 at 13:11 -0700, Dan Williams wrote:
> >> On Mon, Mar 10, 2014 at 11:29 PM, James Bottomley
> >> <James.Bottomley@hansenpartnership.com> wrote:
> >> >> > In the long game, though this whole debate is moot: setups with hard
> >> >> > wired start times adhere to them regardless of what the system does, so
> >> >> > they ignore start unit commands.  Systems without hard wired start times
> >> >> > can usually be started at once, so us introducing a delay is unnecessary
> >> >> > in either case.
> >> >>
> >> >> Ok, then I'll let the patch stand as is.
> >> >
> >> > Sounds good.
> >> >
> >> > James
> >> >
> >> >
> >>
> >> Well, one more chirp about this.  If the user has disabled async
> >> scanning by CONFIG_SCSI_SCAN_ASYNC=n or scsi_mod.scan != "async" then
> >> resume should follow suit.  I'll include this in the next rev.
> >
> > Hm, OK, if this is tied at the hip to async scanning, why do you need
> > another async domain for it?  Why not just use the current async
> > scanning domain ... it will actually probably resolve a few nasty (but
> > wholly manufactured) races where scanning races with suspend.
> 
> I considered that initially, but it ends up destroying most/all of the
> benefit of doing it asynchronously.  This is due to the fact that
> scsi_sd_probe_domain is flushed by the async_synchronize_full()
> performed in dpm_resume().  We want userspace to resume while the disk
> may still be starting.

OK, finally got it, the new domain doesn't participate in
async_synchronize_full() but scsi_sd_probe_domain does (and has to
because of the device and module operations).  That might actually be
worth a comment somewhere.

James



