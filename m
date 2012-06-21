From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 3/3] Fix device detection issues with mvsas driver
Date: Thu, 21 Jun 2012 09:05:56 -0700
Message-ID: <CAA9_cmeo=2Jjyp2DSwBDM=toTydMbLHJ+J7h2UXQYb2YmV+tzg@mail.gmail.com>
References: <1340044537.3712.23.camel@praveen-debian.lg.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45103 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab2FUQF5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jun 2012 12:05:57 -0400
Received: by obbuo13 with SMTP id uo13so1116764obb.19
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jun 2012 09:05:56 -0700 (PDT)
In-Reply-To: <1340044537.3712.23.camel@praveen-debian.lg.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pmurali@logicube.com
Cc: linux-scsi@vger.kernel.org

On Mon, Jun 18, 2012 at 11:35 AM, Praveen Murali <pmurali@logicube.com>=
 wrote:
> =A0I am using the Marvell SAS HBA (MV64460/64461/64462 System Control=
ler,
> Revision B (rev 01)), on a system running Ubuntu 12.04 stock kernel. =
And
> i am seeing some drive detection issues with SATA drives, mostly duri=
ng
> hotplugging the drives; the issue gets exaggerated when we keep remov=
ing
> and plugging in drives.
>
> From dmesg, after starting the LibATA debugs, it looks like the
> ata_eh_revalidate_and_attach fails because ata_dev_read_id fails to g=
et
> the IDENTIFY command response. I see "both IDENTIFYs aborted, assumin=
g
> NODEV" for all these drives that go undetected. At this point, if I
> unload and reload the mvsas driver, these drives detect fine. So, I
> hooked up a SATA analyzer between the HBA and one of the drives, and
> restarted the test. From what I can see, even though the drive respon=
ds
> to the IDENTIFY command, the upper layer detects an error and discard=
s
> the response. On further debugging it was evident that the error was
> being detected in the FIS.
>
> =A0After going thru the mvsas driver, I see that the driver allocates=
 a
> DMA area for an FIS pool (for as many as 33 FIS's) and initializes it=
 to
> 0. And each ATA command is allocated a FIS area from this pool during
> the command prep; but its never cleared.
>
> This change initializes the FIS area before using it and it fixes the
> drive detection issue. I have tested it with kernel 3.2.0.
>
> ---
> =A0drivers/scsi/mvsas/mv_sas.c | =A0 14 ++++++++++++++
> =A01 file changed, 14 insertions(+)
>
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.=
c
> index a4884a5..31bfd4e 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -21,6 +21,16 @@
> =A0* along with this program; if not, write to the Free Software
> =A0* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1=
307
> =A0* USA
> + *
> + * Changelog:
> + * =A0 =A0 Praveen Murali <pmurali@logicube.com> =A0 May 15, 2012
> + * =A0 =A0 =A0 =A0 =A0 =A0 Cleanup and prepare the FIS index before =
issuing the
> + * =A0 =A0 =A0 =A0 =A0 =A0 ATA command (during prep: mvs_task_prep_a=
ta). This is
> + * =A0 =A0 =A0 =A0 =A0 =A0 to overcome the drive detection issue whe=
re the SATA drives
> + * =A0 =A0 =A0 =A0 =A0 =A0 fail to get detected during hotplug since=
 the ATA module
> + * =A0 =A0 =A0 =A0 =A0 =A0 (libATA) detects errors set in the FIS ev=
enthough the SATA
> + * =A0 =A0 =A0 =A0 =A0 =A0 analyzer shows that the IDENTIFY command =
was successfull.
> + *
> =A0*/

Hi,

The changelog will exist in the git history, no need to also append it
to the file.  I think this should also be tagged for the -stable tree.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
