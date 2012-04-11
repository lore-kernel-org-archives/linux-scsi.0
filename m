From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Cannot detect SATA disk's FUA/DPO feature
Date: Wed, 11 Apr 2012 10:08:57 +0800
Message-ID: <20120411020857.GC18945@gmail.com>
References: <20120409083412.GA4927@gmail.com>
 <4F8486BB.2000701@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F8486BB.2000701@stud.tu-ilmenau.de>
Sender: linux-ide-owner@vger.kernel.org
To: Stefan /*St0fF*/ =?utf-8?Q?H=C3=BCbner?= <stefan.huebner@stud.tu-ilmenau.de>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 10, 2012 at 09:15:07PM +0200, Stefan /*St0fF*/ H=C3=BCbner =
wrote:
> Am 09.04.2012 10:34, schrieb Zheng Liu:
> > Hi list,
> >=20
> > Recently I meet a problem in upstream kernel, which the problem is =
that
> > disk driver can not detect FUA/DPO feature of SATA disk.  This mach=
ine
> > has two SATA disks, one is C400-MTFDDAK256M and another is WDC
> > WD1002FAEX-0, both of them are plugged into mainboard.  I read the =
data
> > sheet and both of them support FUA feature.  I am not sure whether =
this
> > is a bug or not in kernel.  Meanwhile, I have tested in SAS disk an=
d
> > kernel displays that the disk supports FUA feature in dmesg.
> >=20
> > When we detect FUA feature for SAS disk in kernel, we will use SCSI
> > command set to detect FUA feature.  Namely, in current kernel, we u=
se
> > FUA bit to check whether this SAS disk supports FUA feature or not.
> > However, SATA disk uses ATA command set.  So in current kernel, thi=
s
> > method doesn't detect whether or not SATA disk supports FUA feature=
=2E  Am
> > I missing something?
> >=20
> > I put dmesg file in attachment.  Hopefully it is useful.
> >=20
> > Regards,
> > Zheng
>=20
> Hi Zheng,
>=20
> as far as I read specs, libata should translate FUA stuff as describe=
d
> in the SAT spec:
> --------snip-->
> 9.17.2 WRITE commands with FUA
> This subclause applies to the translation of the WRITE (10) command,
> WRITE (12) command, and WRITE (16) command.
> If the FUA bit is set to zero in the SCSI write command CDB, then the
> SATL shall process this command as described in 9.17.1.
> If the FUA bit is set to one in the SCSI write command CDB, then the
> SATL shall send the following, in accordance with the constraints
> described in 9.1:
> a) the following ATA commands:
> 1) an ATA write command (see 3.1.26) excluding WRITE DMA FUA EXT, WRI=
TE
> DMA QUEUED
> FUA EXT, WRITE MULTIPLE FUA EXT, and WRITE FPDMA QUEUE; and
> 2) an ATA verify command (see 3.1.24);
> b) one of the following ATA commands (see ATA8-ACS):
> A) WRITE DMA FUA EXT;
> B) WRITE DMA QUEUED FUA EXT; or
> C) WRITE MULTIPLE FUA EXT;
> or
> c) an ATA WRITE FPDMA QUEUED command (see SATA-2.6) with the FUA bit =
in
> the Device field set to
> one.
> <--snap-----------
>=20
> so if the disks supported FUA according to their ATA_IDENTIFY_DEVICE
> data, I'd guess someone wanted to care about that part of the SATL in
> the near future ;)
>=20
> Greets,
> Stefan

Hi Stefan,

Cc to linux-ide mailing list for finding more suggestions.

Thank you for your reply.  I use sa_sat_identity command to read disk
information.  The result shows that SATA disk supports WRITE DMA FUA
EXT, WRITE DMA QUEUE FUA EXT, WRITE MULTIPLE FUA EXT and WRITE FPDMA
QUEUE commands in my machine.  So, IMHO, maybe there is a defect in
upstream kernel.  I read the stuff of scsi disk driver and the calling
stack is as following:

sd_probe()
|
->sd_probe_async()
  |
  ->sd_revalidate_disk()
    |
    ->sd_read_cache_type()
      |
      ->sd_do_mode_sense()
        |
        ->scsi_mode_sense()
          |
          ->scsi_execute_req()
            |
            ->blk_execute_rq()
              |
              ->blk_execute_rq_nowait()
                |
                ->ata_scsi_queuecmd()
                  |
                  ->ata_scsi_simulate()

Until now, I don't have a conclusion about whether it is a defect in
kernel.  I will go on tracing this problem.  Have you some suggestions?
Please let me know.  Thank you.

Regards,
Zheng
