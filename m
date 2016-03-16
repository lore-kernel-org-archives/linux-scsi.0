From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: fc: use get/put_unaligned64 for wwn access
Date: Wed, 16 Mar 2016 13:44:42 -0400
Message-ID: <1458150282.17965.14.camel@localhost.localdomain>
References: <1458146385-278589-1-git-send-email-arnd@arndb.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458146385-278589-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <JBottomley@Odin.com>, Hannes Reinecke <hare@suse.de>, James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-03-16 at 17:39 +0100, Arnd Bergmann wrote:
> A bug in the gcc-6.0 prerelease version caused at least one
> driver (lpfc) to have excessive stack usage when dealing with
> wwn data, on the ARM architecture.
> 
> lpfc_scsi.c: In function 'lpfc_find_next_oas_lun':
> lpfc_scsi.c:117:1: warning: the frame size of 1152 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> 
> I have reported this as a gcc regression in
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70232
> 
> However, using a better implementation of wwn_to_u64() not only
> helps with the particular gcc problem but also leads to better
> object code for any version or architecture.
> 
> The kernel already provides get_unaligned_be64() and
> put_unaligned_be64() helper functions that provide an
> optimized implementation with the desired semantics.
> 
> The lpfc_find_next_oas_lun() function in the example that
> grew from 1146 bytes to 5144 bytes when moving from gcc-5.3
> to gcc-6.0 is now 804 bytes, as the optimized
> get_unaligned_be64() load can be done in three instructions.
> The stack usage is now down to 28 bytes from 128 bytes with
> gcc-5.3 before.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/scsi/scsi_transport_fc.h | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
> index 784bc2c0929f..bf66ea6bed2b 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -28,6 +28,7 @@
>  #define SCSI_TRANSPORT_FC_H
>  
>  #include <linux/sched.h>
> +#include <asm/unaligned.h>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_netlink.h>
>  
> @@ -797,22 +798,12 @@ fc_remote_port_chkready(struct fc_rport *rport)
>  
>  static inline u64 wwn_to_u64(u8 *wwn)
>  {
> -	return (u64)wwn[0] << 56 | (u64)wwn[1] << 48 |
> -	    (u64)wwn[2] << 40 | (u64)wwn[3] << 32 |
> -	    (u64)wwn[4] << 24 | (u64)wwn[5] << 16 |
> -	    (u64)wwn[6] <<  8 | (u64)wwn[7];
> +	return get_unaligned_be64(wwn);
>  }
>  
>  static inline void u64_to_wwn(u64 inm, u8 *wwn)
>  {
> -	wwn[0] = (inm >> 56) & 0xff;
> -	wwn[1] = (inm >> 48) & 0xff;
> -	wwn[2] = (inm >> 40) & 0xff;
> -	wwn[3] = (inm >> 32) & 0xff;
> -	wwn[4] = (inm >> 24) & 0xff;
> -	wwn[5] = (inm >> 16) & 0xff;
> -	wwn[6] = (inm >> 8) & 0xff;
> -	wwn[7] = inm & 0xff;
> +	put_unaligned_be64(inm, wwn);
>  }
>  
>  /**

It would be nice to get rid of these functions completely and just
change the callers to use get/put_unaligned_be64() directly, like libfc
does, but that involves changing 7 drivers and scsi_transport_fc.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
