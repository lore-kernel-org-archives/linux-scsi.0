From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/4] scsi_dh: Make scsi_dh_activate
	asynchronous
Date: Tue, 06 Oct 2009 10:08:21 +0200
Message-ID: <4ACAFAF5.5000805@suse.de>
References: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>	
	<4AC9EE1B.7030702@suse.de>
	<1254785154.15826.18.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1254785154.15826.18.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, dm-devel@redhat.com, Benoit_Arthur@emc.com, Eddie.Williams@steeleye.com
List-Id: linux-scsi@vger.kernel.org

Chandra Seetharaman wrote:
> On Mon, 2009-10-05 at 15:01 +0200, Hannes Reinecke wrote:
>=20
> Thanks for the comment and the patch. I will try the patch.
>=20
>> Hmm. IIRC we added the synchronous mode by request of LSI/IBM, as the =
RDAC
>> handler could only support on MODE SELECT command at a time.
>> If LSI checked this, okay, no objections.
>=20
> The original patch (for rdac) came from LSI (Moger Babu), I made change=
s
> to the infrastructure and to the code to fit them together.
>=20
>> However: The main reason why we're getting flooded with MODE SELECT co=
mmands
>> is that the RDAC handler switches _each LUN_, not the entire controlle=
r.
>> Seeing that the controller simply cannot cope with the resulting MODE =
SELECT
>> flood wouldn't it be more sensible to switch the entire controller her=
e?
>=20
> I see your point of view.... but here is the rationale...
>=20
> When we originally added the rdac support (as dm_rdac), we decided this
> way consciously for the following reasons:
>  1. we do not know which link is broken (hba-ctlr or ctlr-lun).
>     The way it is currently implemented, both these cases are handled.
Quite. But if the ctlr-lun link is broken, we really should receive
and appropriate error code, which then could be handled in dm-rdac
appropriately. After all, the controller is still accessible and
so we don't have to guess what happened (which is all what multipath
is about). So I doubt we need to worry about this.

>  2. multipath layer to decide what to do and this module to just do
>     what it was told.
Yep.

>  3. since multipath sends pg_init only if there is any IO sent to the
>     lun, (with the current implementation) we don't have to change
>     ownership (back and forth) of all the luns if the user is using onl=
y
>     a handful.
Well, yes. But if the implementation is such that changing ownership
for all LUNs is about as efficient as changing an individual LUN (or,
as the case might be, as _inefficient_ :-), surely it's better to
save us some coding here.

>  4. to be consistent with LSI's original driver (which does one lun at =
a
>     time).
:-/ That's unfair.
But it still has the drawback that it doesn't scale; given enough LUNs an=
d
access patterns you _inevitably_ have to send MODE SELECT commands for
each LUN, ie you only delay this issue.
Only by switching all LUNs you can avoid this.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
