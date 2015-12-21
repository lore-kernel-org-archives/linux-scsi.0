From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH V3 2/4] scsi: storvsc: Properly support Fibre Channel
 devices
Date: Mon, 21 Dec 2015 16:02:37 +0000
Message-ID: <BY2PR0301MB16545E8967AA1D206D101754A0E40@BY2PR0301MB1654.namprd03.prod.outlook.com>
References: <1450038486-19211-1-git-send-email-kys@microsoft.com>
 <1450038512-19252-1-git-send-email-kys@microsoft.com>
 <1450038512-19252-2-git-send-email-kys@microsoft.com>
 <5673C893.6020204@suse.de> <1450458820.2439.12.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1450458820.2439.12.camel@HansenPartnership.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Friday, December 18, 2015 9:14 AM
> To: Hannes Reinecke <hare@suse.de>; KY Srinivasan <kys@microsoft.com>;
> gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> martin.petersen@oracle.com
> Subject: Re: [PATCH V3 2/4] scsi: storvsc: Properly support Fibre Channel
> devices
> 
> On Fri, 2015-12-18 at 09:49 +0100, Hannes Reinecke wrote:
> > What I would like to see is a clear separation here:
> > - Disable FC disk handling if FC attributes are not configured
> > - Add a module parameter allowing to disable FC attributes even if
> > they are compiled in. Remember: this is a virtualized guest, and
> > people might want so save kernel memory wherever they can. So always
> > attaching to the fc transport template will make them very unhappy.
> > Alternatively you could split out FC device handling into a separate
> > driver, but seeing the diff that's probably overkill.
> 
> I don't quite see how this can be a module parameter: the
> fc_transport_class is pulled in by symbol references.  They won't go
> away whether a module parameter is zero or one.  The only way to get
> the module not to link with a transport class is to have it not use the
> symbols at compile time (either because they're surrounded by an #ifdef
> or with an if() which the compiler evaluates at compile time to zero).
>  In userspace you get around this with introspection and dlopen, but I
> don't think we have that functionality in the kernel.

Hannes,
Perhaps I misunderstood your comment when I first responded to this suggestion
from you - I thought you were concerned about unconditionally allocating FC transport
template and I had proposed a work around that. Now looking at James comment, it looks
like you were concerned about FC transport module dependency on the storvsc module.
Do you still want me to work on my proposal.

Thanks,

K. Y
> 
> James
