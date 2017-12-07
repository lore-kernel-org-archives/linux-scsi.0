From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] scsi: bfa: fix type conversion warning
Date: Thu, 7 Dec 2017 10:19:43 +0100
Message-ID: <20171207101943.7e01248c@pentland.suse.de>
References: <20171206141444.634681-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171206141444.634681-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed,  6 Dec 2017 15:14:18 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> A regression fix introduced a harmless type mismatch warning:
> 
> drivers/scsi/bfa/bfad_bsg.c: In function 'bfad_im_bsg_vendor_request':
> drivers/scsi/bfa/bfad_bsg.c:3137:35: error: initialization of 'struct
> bfad_im_port_s *' from 'long unsigned int' makes pointer from integer
> without a cast [-Werror=int-conversion] struct bfad_im_port_s
> *im_port = shost->hostdata[0]; ^~~~~ drivers/scsi/bfa/bfad_bsg.c: In
> function 'bfad_im_bsg_els_ct_request':
> drivers/scsi/bfa/bfad_bsg.c:3353:35: error: initialization of 'struct
> bfad_im_port_s *' from 'long unsigned int' makes pointer from integer
> without a cast [-Werror=int-conversion] struct bfad_im_port_s
> *im_port = shost->hostdata[0];
> 
> This changes the code back to shost_priv() once more, but encapsulates
> it in an inline function to document the rather unusual way of
> using the private data only as a pointer to the previously allocated
> structure.
> 
> I did not try to get rid of the extra indirection level entirely,
> which would have been rather invasive and required reworking the
> entire initialization sequence.
> 
> Fixes: 45349821ab3a ("scsi: bfa: fix access to bfad_im_port_s")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/scsi/bfa/bfad_bsg.c |  4 ++--
>  drivers/scsi/bfa/bfad_im.c  |  6 ++++--
>  drivers/scsi/bfa/bfad_im.h  | 10 ++++++++++
>  3 files changed, 16 insertions(+), 4 deletions(-)
> 

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
