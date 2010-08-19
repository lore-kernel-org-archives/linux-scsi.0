From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 2/6] libata: Report supported TRIM payload size
Date: Thu, 19 Aug 2010 17:08:22 -0400
Message-ID: <AANLkTi=AxFBdv-k+q5cDRu5dgRzgm-58KUH5Jbxpsiqc@mail.gmail.com>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
	<1282232941-9910-3-git-send-email-martin.petersen@oracle.com>
	<AANLkTike+4Z2Z7eHEN=NHY=N72cO5bGJUwJbXzgJAKUx@mail.gmail.com>
	<yq1fwyamq9s.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <yq1fwyamq9s.fsf@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 19, 2010 at 2:05 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Greg" =3D=3D Greg Freemyer <greg.freemyer@gmail.com> writes:
>
>>> + /* Default to 1 if unspecified in word 105. Cap at 1 page. */
>
> Greg> Should there at least be a todo comment about raising that cap?
>
> We don't currently plan to. =A0The payload is a single page which we =
can
> allocate fairly easily. =A0A bigger payload would be more problematic=
=2E
>
> With the 4KB payload you can adress 16GB with one command.
>
>
> Greg> Or is there a fundamental reason for it. =A0ie. I don't think t=
he
> Greg> ATA spec calls for it, so this is a kernel restriction I assume=
=2E
>
> Yes, this is part of the internal SCSI-ATA translation mechanism in
> Linux. =A0But fwiw, there I'm only aware of one drive that currently
> supports more than 512 bytes of payload and it also caps at 4KB.
>

If you're curious about harware support for larger payloads, you might
ask Mark Lord.  I understand the way he implemented it in hdparm
accepts many more 512 byte payload blocks than one page worth.  And
the only SSD hardware he's reported problems with are Intel which
apparently only supports one 512 byte payload.

ie. I believe hdparm will typically use up to 1MB of payload.  And the
ranges he collects via his script and dispatches via hdparm are
typically not contiguous.

But I believe he is bypassing much of the kernel stack.  To be honest,
I have not traced a hdparm created trim command through the kernel, so
I don't know the details, and he may be breaking that 1 MB payload
that is coming from userspace into smaller payloads.

The fundamental problem with hdparm is that because it bypasses most
of the kernel i/o stack, it is not compatible with DM/LVM, but I think
its a great prototype of what the kernel could do eventually.

=3D=3D> from man hdparm

       --trim-sector-ranges
              For Solid State Drives (SSDs).  EXCEPTIONALLY DANGEROUS.
DO NOT USE THIS FLAG!!  Tells the drive firmware to discard unneeded
data sectors, destroying any data that may have been
              present  within  them.   This makes those sectors
available for immediate use by the firmware's garbage collection
mechanism, to improve scheduling for wear-leveling of the flash
              media.  This option expects one or more sector range
pairs immediately after the flag: an LBA starting address, a colon,
and a sector count, with no intervening  spaces.   EXCEP-
              TIONALLY DANGEROUS. DO NOT USE THIS FLAG!!

              Eg.  hdparm --trim-sector-ranges 1000:4 7894:16 /dev/sdz

       --trim-sector-ranges-stdin
              Identical  to  --trim-sector-ranges above, except the
list of lba:count pairs is read from stdin rather than being specified
on the command line.  This can be used to avoid prob-
              lems with excessively long command lines.  It also
permits batching of many more sector ranges into single commands to
the drive, up to the currently  configured  transfer  limit
              (max_sectors_kb).
=3D=3D>


>
> Greg> Is this patch actually enabling the block layer to initiate ATA
> Greg> multi-sector trim payloads, or is this only allowing the max
> Greg> payloads sectors to be queried?
>
> TRIM only takes 65535 blocks per entry. =A0So we need many entries to
> decribe a single, contiguous space being freed. =A0That's what's bein=
g
> bumped here.
>

Thanks, I did not appreciate that restriction and thus my confusion
about the patch

>
> Greg> Are there plans (or existing code) to accumulate trim ranges in
> Greg> the block layer and create trim commands with multiple sectors?
>
> I have worked on this on and off. =A0It's not trivial for several rea=
sons.
> We discussed the issues at the storage workshop last week and there w=
as
> concensus that the changes were too intrusive. =A0So we're holding of=
f
> until we see what's happening with:
>
> =A0 =A0 =A0a) the SSD market. Win 7 also issues lots of small, indivi=
dual
> =A0 =A0 =A0 =A0 trims like we do
>
> =A0 =A0 =A0b) the TRIM TNG command that's being worked on in T13
>
> This doesn't mean that TRIM coalescing is impossible and that it will
> never happen. =A0But right now it appears to be more hassle than it's
> worth...

I believe it's almost trivial to coalesce non-contiguous ranges into a
single vector of ranges in the proposed fitrim() ioctl because it is
walking the filesystem structures looking for free ranges.  I assume
its just a matter of maintaining the locks long enough to ensure the
blocks being trimmed are not used by other filesystem code while the
ranges are being collected.

The bigger problem for now is that the block layer does not export a
way to pass in a vectorized list of ranges to discard.

> --
> Martin K. Petersen =A0 =A0 =A0Oracle Linux Engineering
>

Greg
