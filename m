From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC PATCH v2 1/8] ACPI: Introduce ACPI D3_COLD state support
Date: Mon, 12 Mar 2012 10:43:43 +0800
Message-ID: <1331520223.3436.8.camel@minggr>
References: <1330592577-16546-1-git-send-email-ming.m.lin@intel.com>
	 <1330592577-16546-2-git-send-email-ming.m.lin@intel.com>
	 <20120312020016.GB2820@ladygaga>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120312020016.GB2820@ladygaga>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@amd.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-03-12 at 10:00 +0800, Aaron Lu wrote:
> Hi,
> 
> On Thu, Mar 01, 2012 at 05:02:50PM +0800, Lin Ming wrote:
> > From: Zhang Rui <rui.zhang@intel.com>
> > 
> > If a device has _PR3, it means the device supports D3_COLD.
> 
> This confused me...So this means if a device is put to D3, instead of
> turning up the power resources referenced in _PR3, turning them all off
> will make the device in D3 cold. This is understandable, but what about
> _PR0? What power state this device is in when I turned off all the power
> resources referenced in _PR0? Undefined?

I understand your confusion...and even more confused because _PR0 and
_PR3 usually share the same power resource.

We are still contacting with the ACPI spec authors to get a clear
understanding of the D3/D3Hot/D3Cold definition.

> 
> I'm also confused with _PS3, what power state the device is in after its
> _PS3 is executed? The spec said it will be in D3 cold or D3 hot, so I
> guess there is no way to tell, right?

Yes,

The spec says,

"This control method is used to put the specific device into its D3hot
or D3 state"

I'm not sure what "D3 state" here means.
Probably not "D3 cold".

Lin Ming 

> 
> Thanks,
> Aaron
> 
> > Add the ability to validate and enter D3_COLD state in ACPI.
> > 
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > ---
> >  drivers/acpi/power.c |    4 ++--
> >  drivers/acpi/scan.c  |    7 +++++++
> >  2 files changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> > index 9ac2a9f..0d681fb 100644
> > --- a/drivers/acpi/power.c
> > +++ b/drivers/acpi/power.c
> > @@ -500,14 +500,14 @@ int acpi_power_transition(struct acpi_device *device, int state)
> >  {
> >  	int result;
> >  
> > -	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3))
> > +	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
> >  		return -EINVAL;
> >  
> >  	if (device->power.state == state)
> >  		return 0;
> >  
> >  	if ((device->power.state < ACPI_STATE_D0)
> > -	    || (device->power.state > ACPI_STATE_D3))
> > +	    || (device->power.state > ACPI_STATE_D3_COLD))
> >  		return -ENODEV;
> >  
> >  	/* TBD: Resources must be ordered. */
> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > index 8ab80ba..571396c 100644
> > --- a/drivers/acpi/scan.c
> > +++ b/drivers/acpi/scan.c
> > @@ -885,6 +885,13 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
> >  				acpi_bus_add_power_resource(ps->resources.handles[j]);
> >  		}
> >  
> > +		/* The exist of _PR3 indicates D3Cold support */
> > +		if (i == ACPI_STATE_D3) {
> > +			status = acpi_get_handle(device->handle, object_name, &handle);
> > +			if (ACPI_SUCCESS(status))
> > +				device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
> > +		}
> > +
> >  		/* Evaluate "_PSx" to see if we can do explicit sets */
> >  		object_name[2] = 'S';
> >  		status = acpi_get_handle(device->handle, object_name, &handle);
> > -- 
> > 1.7.2.5
> > 
> > 
> 


