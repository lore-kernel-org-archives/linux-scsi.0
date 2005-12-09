From: Jeff Garzik <jgarzik-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Fri, 9 Dec 2005 06:49:44 -0500
Message-ID: <20051209114944.GA1068@havoc.gtf.org>
References: <20051208091542.GA9538@infradead.org> <20051208132657.GA21529@srcf.ucam.org> <20051208133308.GA13267@infradead.org> <20051208133945.GA21633@srcf.ucam.org> <1134050498.17102.2.camel@localhost.localdomain> <20051208141811.GB21715@srcf.ucam.org> <1134052433.17102.17.camel@localhost.localdomain> <20051208145257.GB21946@srcf.ucam.org> <20051208171901.GA22451@srcf.ucam.org> <20051209114246.GB16945@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <acpi-devel-admin-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20051209114246.GB16945-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: acpi-devel-admin-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Errors-To: acpi-devel-admin-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/acpi-devel>,
	<mailto:acpi-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Post: <mailto:acpi-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:acpi-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/acpi-devel>,
	<mailto:acpi-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=acpi-devel>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, randy_d_dunlap-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, acpi-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 09, 2005 at 11:42:46AM +0000, Christoph Hellwig wrote:
> On Thu, Dec 08, 2005 at 05:19:01PM +0000, Matthew Garrett wrote:
> > This turns out to be quite difficult, and I can't see a clean way of 
> > doing it without touching scsi or rewriting chunks of the ACPI glue 
> > code.
> > 
> > The basic flow of code required here is:
> > 
> > 1) scsi layer registers a new device
> > 2) platform_notify is called, which is (in this case) 
> > acpi_platform_notify
> > 3) acpi_platform_notify checks whether it knows dev->bus. If so, it 
> > calls appropriate callbacks.
> > 
> > Without touching scsi, there doesn't seem to be any way for (3) to work 
> > if scsi is a module. Would a simple
> > 
> > #ifdef CONFIG_ACPI
> > acpi_scsi_init(&scsi_bus_type)
> > #endif
> > 
> > in the scsi code be acceptable? If not, then we have some difficulty. 
> > The acpi glue code has to be statically linked in, so it can't rely on 
> > anything that directly references the scsi code.
> 
> As a concept it's _much_ better.  Although it should be platform_scsi_init
> and every architecture would provide an, in most cases noop, implementation.

If this is just for libata, it's still at the wrong level.

libata will eventually make the SCSI simulator optional, which means
any acpi_scsi_init() or whatnot won't work for libata.

	Jeff





-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
