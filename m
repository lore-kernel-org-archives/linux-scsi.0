From: James Smart <James.Smart-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: Re: FC bus questions
Date: Mon, 16 Nov 2009 16:11:53 -0500
Message-ID: <4B01C019.4080101@emulex.com>
References: <1258397053.3331.10149.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1258397053.3331.10149.camel@fritz>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: Robert Love <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "devel-s9riP+hp16TNLxjTenLetw@public.gmane.org" <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org



Robert Love wrote:
> Hi James (and everyone else),
> 
>    I wanted to continue the discussion on FCoE statistics and a possible
> device tree reorganization. The original thread has been expired from my
> mail system, so I have to start this new thread. The main theme was that
> we might want to convert FC to be a bus.
> 
>    For reference here is your proposed sysfs layout-
> 
> /sys/.../fcportX/fcfportY/fcfabricZ/fcvportA/fcrportB
>                                             /fcpinitC/hostD/target<H:C:T>/<H:C:T>
> 
>    I can see a benefit to extending the FC device tree. Assuming that
> each of these devices is created as they're discovered by the FC HBA
> then it's giving a more accurate description of the system's state. For
> example, in FCoE if you were to succeed with FIP and discover a FCF, but
> the FLOGI failed then user space could clearly see that devices were
> only created up to the fcfabric. I also think that it simply makes more
> room for new attributes. With FCFs and FCoE attributes it would be nice
> to have them better organized instead of just grouping them all under
> the fc_host.
> 
>    Aside from a sysfs reorganization, which could be done without making
> FC a bus, the main benefit seems to be that other FC4 protocols could
> use a FC HBA. Is there other goodness that I'm overlooking?

The 2 main gripes I hoped it would solve are:

- Right now, FC things always have a scsi_host "hostD" object that binds to 
the physical parent (usually the pci adapter object), then the fc objects 
appear under it. This relationship is very odd - especially if the fc-thing 
isn't acting as an fcp initiator, or if the sub-objects are scsi-hosts in 
their own right. And the fact its the location of driver-specific attributes 
makes it further odd  (why is one scsi_host different from another - why 
aren't the driver-specific attributes on the pci adapter object instead).

- As you point out - much better clarity and organization of attributes and a 
better representation of bus/connectivity heirarchy.


> 
>    Also, buses usually have devices and drivers. I'm not sure what the
> FC drivers would be since SCSI would ultimately provide the drivers for
> SCSI-FCP. Would a FC bus only have devices and no drivers?

I probably took too much latitude with the word "bus", as I was thinking more 
toward the sysfs object tree rather than the linux bus/device/driver 
relationships.  Yes, it probably means no drivers as it should be as light as 
possible. I think of this as a fancy "driver" that creates it's own 
sub-objects, using the transport to do all the "fancy" work for the driver and 
in a single manner for all drivers. Fundamentally moves the scsi_host binding 
to a different place, and the correlations to class objects as well.

Thinking about the recent DMA issues with scsi - scsi should make every 
scsi_host convert over to the specifying a physical dma parent when it does 
scsi_add_host().

-- james s
