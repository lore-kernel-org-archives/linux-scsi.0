From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] Transport classes, SAS, discovery
Date: Fri, 11 Mar 2005 17:14:57 +0000
Message-ID: <20050311171457.GO21986@parcelfarce.linux.theplanet.co.uk>
References: <4231C874.7060800@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:14473 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261215AbVCKRPD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 12:15:03 -0500
Content-Disposition: inline
In-Reply-To: <4231C874.7060800@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Mar 11, 2005 at 11:33:56AM -0500, Luben Tuikov wrote:
> Q: I've been wondering how exactly does the transport class work?
> Can anyone give an intro on attribute container, attribute group,
> transport class template, etc.  I've been looking at those but not
> 100% sure I understand it all.  It looks similar to the old
> scsi detect "discovery" but not 100% sure.

I can talk pretty clearly about the SPI transport ... the SAS transport
ought to work similarly.  Any chance of getting aic7[9x]xx to use the
SPI transport class?

Each SCSI target has a transport template.  There's various macros
in <scsi/scsi_transport*.h> that make its members easy to access for
the drivers.  The obvious way to get some benefit from it is to
make useful information (period, offset, width, IU, QAS, DT, etc)
appear in sysfs.

There's two ways to make useful information appear in
/sys/class/spi_transport/.  First you have to define a
spi_function_template structure and register it by using
spi_attach_transport().  You can either keep all the information in
your driver's internal structures and implement the ->get_* functions,
or you can keep the information in the target's transport structures.
Hopefully the first way will go away soon as I've modified the only two
drivers using that method to use the second method.

There's also a /sys/class/spi_host directory that has the 'signalling'
attribute (SE/HVD/LVD).

Now, there are some nice optional features you can use.  You can
ask the SPI layer to do domain validation for you, and benefit from
all the debugging I've done on it ... maybe you'll find some more bugs,
and then I'll benefit from your testing too.  There's also the new
spi_display_xfer_agreement() which does a nice one-line display of
what SPI contract we have with each device.

> Q: Also I'd like to ask if domain discovery would be performed
> by the mid layer?  I assume yes, so that "there is no code duplication".

That would make a lot of sense.

> Q: In this case would it be safe to assume that we need a
> sas_phy, sas_port and sas_ha? A la:
> 
> sas_ha 1<---* sas_port 1<---128 sas_phy  *
>   ^                               |
>   | 1                         128 |
>   +-------------------------------+
> 
> With the appropriate linked lists and properties as defined
> in the SAS 1.1 spec ch 4? (undoubtedly more properties would
> be added as drivers come along)
> 
> Now, I can see that there exist scsi_target and scsi_host
> which appear to be the underlying objects for the transport
> classes of sorts, host and target.
> 
> Q: Since a SAS mid layer discovery core would manipulate ports
> and phys, do we need to represent those with scsi core
> objects, or would struct device plus the SAS specific
> object class suffice?
> 
> Q: Also, how exactly would a LLDD register the objects with
> the class?  Would the answer to this be the trivial answer,
> or is there some kind of "it will detect it itself".
> 
> On top of this we would have scsi targets in this picture
> which would depend on phys/ports/ha.  (And LUs depend on
> targets.)
> 
> So basically, would scsi core need to have an internal SAS
> domain topology representation (how about expanders...).
> That is, it would help multipathing a great deal.
> 
> Thanks,
> 	Luben
> 
> * Where,
> 	objA N<---M objB,  means
> objA depends on objB* and objA can associate M number of objB
> and objB can associate N objA, where an association is 
> a relationship defined appropriate for the object tuple, which
> need not necessarily be homogeneous.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
