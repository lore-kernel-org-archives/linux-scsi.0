From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [for 4.1 PATCH resend] libsas: fix "sysfs group not found"
 warnings at port teardown time
Date: Mon, 27 Jul 2015 13:52:06 -0700
Message-ID: <CAPcyv4hBWUp+fWz75t9HKJrfmUD051HcLgCo2N0GF9Hs-u8s4w@mail.gmail.com>
References: <20150618032204.29990.87007.stgit@dwillia2-desk3.amr.corp.intel.com>
	<1437589687.2171.44.camel@HansenPartnership.com>
	<CAPcyv4hTVCKU+SVAPPrne_EKuGdzuZjhpgpte26FVcCYT6_8wQ@mail.gmail.com>
	<1438010252.5441.21.camel@HansenPartnership.com>
	<CAPcyv4irtD_JgXEVkvhNak3s61kJCVzKADJ2s=nOsrT0qtzjXA@mail.gmail.com>
	<1438017069.5441.42.camel@HansenPartnership.com>
	<CAPcyv4je3AgKWaoHS9sECyDGeithmZdXX8dKgB9NwYu0donjdQ@mail.gmail.com>
	<1438022295.5441.63.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1438022295.5441.63.camel@HansenPartnership.com>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Praveen Murali <pmurali@logicube.com>, linux-scsi <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 27, 2015 at 11:38 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> No, that seems to be the intent of the prior code.  The reason port
> visibility goes immediately (along with all associated phys), is that
> the port is ready for reuse as soon as sas_deform_port() returns.
> Destroying the subtree is left to DISCE_DESTRUCT, but since the subtree
> is not visible, a new port can form even as the elements associated with
> the old port are being destroyed.  the DISCE_DISCOVER that populates it
> will queue behind the destruct, so everything just works today (modulo
> the new warning).
>
> It would be ideal if we could detect in the destruct queue that the
> visibility is already gone and make use of it, but we can't.  The patch
> that causes this warning induces a mismatch between the state of the
> kernfs tree and the kobjects ... we still have to call device_del which
> leads to kobject_del (which triggers the warning) to bring this state
> back into alignment.  So the disconnected subtree we originally used to
> make all this work is what's suddenly been rendered invalid.
>

Looking at the original report this seemed new for the 3.16 kernel.
However, looking closer, that warning in sysfs_remove_group() has been
present for a long time before that.  I don't recall seeing it back
when we were doing focused hotplug testing with the isci driver for
the 3.5 / 3.6 kernels, so I believe it is newly uncovered since then.
