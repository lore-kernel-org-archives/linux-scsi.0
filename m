From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V3 2/4] scsi: storvsc: Properly support Fibre Channel
 devices
Date: Fri, 18 Dec 2015 09:13:40 -0800
Message-ID: <1450458820.2439.12.camel@HansenPartnership.com>
References: <1450038486-19211-1-git-send-email-kys@microsoft.com>
 <1450038512-19252-1-git-send-email-kys@microsoft.com>
 <1450038512-19252-2-git-send-email-kys@microsoft.com>
 <5673C893.6020204@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <5673C893.6020204@suse.de>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Hannes Reinecke <hare@suse.de>, "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-12-18 at 09:49 +0100, Hannes Reinecke wrote:
> What I would like to see is a clear separation here:
> - Disable FC disk handling if FC attributes are not configured
> - Add a module parameter allowing to disable FC attributes even if 
> they are compiled in. Remember: this is a virtualized guest, and 
> people might want so save kernel memory wherever they can. So always 
> attaching to the fc transport template will make them very unhappy.
> Alternatively you could split out FC device handling into a separate 
> driver, but seeing the diff that's probably overkill.

I don't quite see how this can be a module parameter: the
fc_transport_class is pulled in by symbol references.  They won't go
away whether a module parameter is zero or one.  The only way to get
the module not to link with a transport class is to have it not use the
symbols at compile time (either because they're surrounded by an #ifdef
or with an if() which the compiler evaluates at compile time to zero). 
 In userspace you get around this with introspection and dlopen, but I
don't think we have that functionality in the kernel.

James
