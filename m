From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi sysfs update (upper 2/3)
Date: Fri, 08 Nov 2002 14:34:20 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DCB30BC.7040703@torque.net>
References: <20021107073619.GA1390@beaverton.ibm.com> <20021107073943.GB1390@beaverton.ibm.com> <20021107182947.B15350@sgi.com> <20021107164152.GD1292@beaverton.ibm.com> <20021108012047.A17391@infradead.org> <20021108022158.GD1292@beaverton.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Mike Anderson wrote:
> Christoph Hellwig [hch@infradead.org] wrote:
> 
>>On Thu, Nov 07, 2002 at 08:41:52AM -0800, Mike Anderson wrote:
>>
>>>>>-	rc = scsi_register_device(&sd_template);
>>>>>+	rc = scsi_bus_driver_register(&sd_template);
>>>>
>>>>Umm, no.  We don't register a bus.  Just leave the name unchanged until
>>>>we there is some commonly agreed upon upper layer terminology.
>>>
>>>Well we are registering a driver with the device model scsi_bus (i.e a
>>>driver_register on scsi_bus_type).
>>
>>We register a scsi upperlayer driver with the midlayer, we don't care
>>about the implementation, and it's certainly not a bus.  I do btw
>>disagree strongly with using the device model bus type for upper level
>>drivers.  We have a bus in scsi, and that's the connection between the
>>HBA and the devices.  To make any sense out of the device model these
>>devices must be childs of the HBA.
>>
> 
> 
> Is the disagreement the function name, bus name, or the concept of
> registering these drivers with sysfs?
> 
> I know the model is not an exact fit, but if we want to use the sysfs
> infrastructure all drivers must be associated with a bus. HBAs belong to
> there parent bus. They can have associations which I added in this patch
> to create a scsi-host class. We cannot create a bus under the HBA. All
> buses are default set to a parent of bus_subsys.
> 
> The /bus/scsi is a logical bus (an aggregation of all scsi buses). The
> upperlayer drivers are the only drivers that should show up under
> /bus/scsi/drivers and the only drivers that can bind with scsi_devices.  

Mike,
I have put scsi_debug's parameters under /bus/scsi/drivers
and scsi_debug obviously isn't an upper layer driver. Also
I would be tempted to put mid level parameters there (if
there were any). Where else should driver parameters be
placed for drivers that have no association with any
other bus?

There is also the conundrum of driver parameters for
something like advansys that has one host on ISA, another
on PCMCIA and a third on PCI (unlikely but possible).

<snip/>

Doug Gilbert

