From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 2/6] libata: Report supported TRIM payload size
Date: Thu, 19 Aug 2010 13:27:21 -0400
Message-ID: <AANLkTike+4Z2Z7eHEN=NHY=N72cO5bGJUwJbXzgJAKUx@mail.gmail.com>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
	<1282232941-9910-3-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1282232941-9910-3-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 19, 2010 at 11:48 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
> ATA IDENTIFY DEVICE word 105 contains the number of 512-byte blocks o=
f
> TRIM payload information the device can accept in one command. =A0Use=
 this
> value to enable payloads > 512 bytes.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
> =A0drivers/ata/libata-scsi.c | =A0 =A07 ++++++-
> =A0include/linux/ata.h =A0 =A0 =A0 | =A0 =A09 +++++++++
> =A02 files changed, 15 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index e280ae6..145f099 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2152,7 +2152,12 @@ static unsigned int ata_scsiop_inq_b0(struct a=
ta_scsi_args *args, u8 *rbuf)
> =A0 =A0 =A0 =A0 * with the unmap bit set.
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0if (ata_id_has_trim(args->id)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_unaligned_be32(65535 * 512 / 8, &rb=
uf[20]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int blocks;

since blocks is nebulous, a comment would be nice, maybe:

                 unsigned int blocks;    /* the ATA spec specifies
512-byte blocks for trim payload */

> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Default to 1 if unspecified in word =
105. =A0Cap at 1 page. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 blocks =3D clamp(ata_id_trim_range_bloc=
ks(args->id), 1U, 8U);


Should there at least be a todo comment about raising that cap?

Or is there a fundamental reason for it.  ie. I don't think the ATA
spec calls for it, so this is a kernel restriction I assume.

> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_unaligned_be32(65535 * 512 / 8 * bl=
ocks, &rbuf[20]);

Is this patch actually enabling the block layer to initiate ATA
multi-sector trim payloads, or is this only allowing the max payloads
sectors to be queried?

Are there plans (or existing code) to accumulate trim ranges in the
block layer and create trim commands with multiple sectors?

AFAIK, the only block layer feature exported to the file system layer
only accepts one range.

I'd like to see multiple trim ranges accumulated either by the
filesystem prior to calling into the block layer, of have the block
layer accumulate them.  (I suspect its easier for the filesystem to do
it via the proposed fitrim() ioctl that is on the ext4 list recently.

ie. the current proposed fitrim() ioctl calls into the block layer for
each trim range, but it could easily have the ability to accumulate a
vector of trim ranges and call the block layer only once per trim
vector if the block layer had a interface for that.

Greg
