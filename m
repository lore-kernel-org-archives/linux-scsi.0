From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/3] firewire-sbp2: Take into account Unit_Unique_ID
Date: Sat, 11 Feb 2012 12:12:50 +0100
Message-ID: <20120211121250.5e2fe781@stein>
References: <EE1CAC85-DF0C-4C21-B2BD-446C481C938F@bootc.net>
	<1328881314-26544-1-git-send-email-bootc@bootc.net>
	<1328881314-26544-2-git-send-email-bootc@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1328881314-26544-2-git-send-email-bootc@bootc.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Feb 10 Chris Boot wrote:
> If the target's unit directory contains a Unit_Unique_ID entry, we
> should use that as the target's GUID for identification purposes. The
> SBP-2 standards document says:
> 
> "Although the node unique ID (EUI-64) present in the bus information
> block is sufficient to uniquely identify nodes attached to Serial Bus,
> it is insufficient to identify a target when a vendor implements a
> device with multiple Serial Bus node connections. In this case initiator
> software requires information by which a particular target may be
> uniquely identified, regardless of the Serial Bus access path used."
> 
> [ IEEE T10 P1155D Revision 4, Section 7.6 (page 51) ] and
> [ IEEE T10 P1467D Revision 5, Section 7.9 (page 74) ]
> 
> Signed-off-by: Chris Boot <bootc@bootc.net>
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/firewire/sbp2.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
> index 80e95aa..ed5bbbf 100644
> --- a/drivers/firewire/sbp2.c
> +++ b/drivers/firewire/sbp2.c
> @@ -211,6 +211,7 @@ static struct fw_device *target_device(struct sbp2_target *tgt)
>  #define SBP2_CSR_UNIT_CHARACTERISTICS	0x3a
>  #define SBP2_CSR_FIRMWARE_REVISION	0x3c
>  #define SBP2_CSR_LOGICAL_UNIT_NUMBER	0x14
> +#define SBP2_CSR_UNIT_UNIQUE_ID		0x8d
>  #define SBP2_CSR_LOGICAL_UNIT_DIRECTORY	0xd4
>  
>  /* Management orb opcodes */
> @@ -997,6 +998,17 @@ static int sbp2_add_logical_unit(struct sbp2_target *tgt, int lun_entry)
>  	return 0;
>  }
>  
> +static int sbp2_get_unit_unique_id(struct sbp2_target *tgt,
> +				    const u32 *leaf)
> +{
> +	if ((leaf[0] & 0xffff0000) != 0x00020000)
> +		return -EINVAL;

This could be relaxed to "if (leaf[0] < 0x00020000)", but the stricter
check is fine too.

> +
> +	tgt->guid = (u64)leaf[1] << 32 | leaf[2];
> +
> +	return 0;
> +}
> +
>  static int sbp2_scan_logical_unit_dir(struct sbp2_target *tgt,
>  				      const u32 *directory)
>  {
> @@ -1048,6 +1060,11 @@ static int sbp2_scan_unit_dir(struct sbp2_target *tgt, const u32 *directory,
>  				return -ENOMEM;
>  			break;
>  
> +		case SBP2_CSR_UNIT_UNIQUE_ID:
> +			if (sbp2_get_unit_unique_id(tgt, ci.p - 1 + value) < 0)
> +				return -EINVAL;
> +			break;
> +
>  		case SBP2_CSR_LOGICAL_UNIT_DIRECTORY:
>  			/* Adjust for the increment in the iterator */
>  			if (sbp2_scan_logical_unit_dir(tgt, ci.p - 1 + value) < 0)

The error return here is wrong.  Garbage in a non-essential part of the
Config ROM is no reason to refuse to work with a device.  It is too common
for firmware to have various bogus values in there.  For instance, we
never check the CRC of a Config ROM block because wrongly calculated CRCs
or even zero CRC is quite commonly seen with otherwise correct Config ROMs.

And there is another problem with the patch:  In fringe cases, we might
now create more than one scsi_device instances with the same ieee1394_id
sysfs attribute value.  Those cases are:
 1. There are two targets present which expose the same, hence non-unique
    and thus standards-violating Unit_Unique_ID. Or
 2. There is a single target connected through more than one link, it has
    got a Unit_Unique_ID, and either
     2.a  it accepts concurrent login despite firewire-sbp2 demanding an
          exclusive login (which is its default mode), or
     2.b  firewire-sbp2 is configured to work in concurrent login mode and
          the target grants concurrent logins.

We do not need to care for case 1.  It cannot be distinguished from case
2, and we already do not care for the case that there are two or more
nodes with a non-unique Node_Unique_ID.  Devices with the latter bug exist
but are rare, judging from historical discussion on linux1394-devel.

Case 2.a is highly unlikely, and I think we should not worry about that
either.

Should we do something about case 2.b?  Where in the Linux SCSI
initiator stack is multipathing handled --- in transport layer drivers or
higher up?  (Cc'ing LSML for this question.)
-- 
Stefan Richter
-=====-===-- --=- -=-==
http://arcgraph.de/sr/

------------------------------------------------------------------------------
Virtualization & Cloud Management Using Capacity Planning
Cloud computing makes use of virtualization - but cloud computing 
also focuses on allowing computing to be delivered as a service.
http://www.accelacomm.com/jaw/sfnl/114/51521223/
