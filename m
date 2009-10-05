From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 0/4] scsi_dh: Make scsi_dh_activate
	asynchronous
Date: Mon, 05 Oct 2009 16:25:54 -0700
Message-ID: <1254785154.15826.18.camel@chandra-ubuntu>
References: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>
	<4AC9EE1B.7030702@suse.de>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AC9EE1B.7030702@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, dm-devel@redhat.com, Benoit_Arthur@emc.com, Eddie.Williams@steeleye.com
List-Id: linux-scsi@vger.kernel.org


On Mon, 2009-10-05 at 15:01 +0200, Hannes Reinecke wrote:

Thanks for the comment and the patch. I will try the patch.

> Hmm. IIRC we added the synchronous mode by request of LSI/IBM, as the RDAC
> handler could only support on MODE SELECT command at a time.
> If LSI checked this, okay, no objections.

The original patch (for rdac) came from LSI (Moger Babu), I made changes
to the infrastructure and to the code to fit them together.

> 
> However: The main reason why we're getting flooded with MODE SELECT commands
> is that the RDAC handler switches _each LUN_, not the entire controller.
> Seeing that the controller simply cannot cope with the resulting MODE SELECT
> flood wouldn't it be more sensible to switch the entire controller here?

I see your point of view.... but here is the rationale...

When we originally added the rdac support (as dm_rdac), we decided this
way consciously for the following reasons:
 1. we do not know which link is broken (hba-ctlr or ctlr-lun).
    The way it is currently implemented, both these cases are handled.
 2. multipath layer to decide what to do and this module to just do
    what it was told.
 3. since multipath sends pg_init only if there is any IO sent to the
    lun, (with the current implementation) we don't have to change
    ownership (back and forth) of all the luns if the user is using only
    a handful.
 4. to be consistent with LSI's original driver (which does one lun at a
    time).

Let me know what do you think. 

Babu, What is LSI's opinion in this issue ?

regards,

chandra

> 
> After all, we're trying to address a communication failure between the
> HBA and the controller, not a failure between the controller and the LUN.
> And by that reasoning switching individual LUNs is quite pointless as we
> have to switch _all_ LUNs handled by this controller eventually.
> 
> So I would suggest to first issue a MODE SENSE command to check which LUNs
> are currently handled by this controller and then switch those LUNs in
> one go. This way we would be sending quite a few MODE SENSE commands,
> but I was under the impression that those do not have any restriction.
> 
> I will see to draw up a patch.
> 
> Cheers,
> 
> Hannes
