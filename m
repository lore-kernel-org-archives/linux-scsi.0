From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [GIT PATCH v4 0/2] libsas: eh reworks (ata-eh vs discovery,
 races, ...)
Date: Thu, 12 Jan 2012 17:21:42 -0800
Message-ID: <CABE8wwvovD1n8U6DLxKYSGMAJ2RwLb=gxF=xCy98Bci_aEvNCQ@mail.gmail.com>
References: <20120110073647.4563.7504.stgit@localhost6.localdomain6>
	<9095644D6BEB42D8ADE7EB255D282AE8@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <9095644D6BEB42D8ADE7EB255D282AE8@usish.com.cn>
Sender: linux-ide-owner@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 12, 2012 at 4:57 PM, Jack Wang <jack_wang@usish.com> wrote:
> Hi Dan,
>
> Thanks for your fix, I do test this with new patchset, this works goo=
d for
> me.
> Only one thing confuse me, kernel sometimes print cmd timed out when =
disk
> attached.
> Like :
> "
> [ =A0312.732468] sd 4:0:11:0: [sdl] command ffff88032c6eaa00 timed ou=
t
> [ =A0312.753114] sd 4:0:13:0: [sdn] command ffff88032c6eb000 timed ou=
t
> [ =A0312.753257] sd 4:0:4:0: [sde] command ffff88032903e800 timed out
> [ =A0312.753266] sd 4:0:14:0: [sdo] command ffff880329284c00 timed ou=
t
> [ =A0312.755304] sd 4:0:1:0: [sdb] command ffff8801b4b80600 timed out
> [ =A0312.797458] sd 4:0:15:0: [sdp] command ffff880329285900 timed ou=
t
> "
> Although, this is no harm.

These were probably timeouts that were happening before but did not
get reported by the old sas_scsi_timed_out().

So, I'm still trying to figure out what to do about the "failure to
transmit signature-fis" case that you sent a patch to address.  I'm
wondering if we need to schedule rediscovery after a longer timeout?
I agree with skipping sas_set_ex_phy(), but for initial discovery it
would be nice to know that we have a device out there that is trying
to connect and hold off ->scan_finished() until libsas has given up on
waiting for that phy to settle.

=46or example libata will reset 3 times with increasing wait times (10s=
,
10s, 35s).  On the last attempt it will slow down the phy to give the
ata device a better chance of connecting.  libsas is just doing 3
500ms tries at full speed and then giving up.

Wouldn't mind someone from libata land commenting on how libsas can be
more helpful to struggling sata devices.

"Let libata do it" would be my first choice, but at the point where we
are discovering this condition we don't yet have an ata_port, and
libsas only creates an ata_port *after* receiving a signature-fis.
Maybe we could create an unattached ata_port (i.e. with a stand-in
domain_device), but libsas would need to learn how to attach and probe
the domain_device after the fact.

--
Dan
