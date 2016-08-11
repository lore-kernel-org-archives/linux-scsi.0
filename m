From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/10] zfcp: fix ELS/GS request&response length for
 hardware data router
Date: Thu, 11 Aug 2016 13:20:23 +0200
Message-ID: <486ac2fb-b54c-f007-603c-ad0b7f099b09@suse.de>
References: <1470846653-90691-1-git-send-email-maier@linux.vnet.ibm.com>
 <1470846653-90691-3-git-send-email-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1470846653-90691-3-git-send-email-maier@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, "# 3 . 2+" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/10/2016 06:30 PM, Steffen Maier wrote:
> In the hardware data router case, introduced with kernel 3.2
> commit 86a9668a8d29 ("[SCSI] zfcp: support for hardware data router")
> the ELS/GS request&response length needs to be initialized
> as in the chained SBAL case.
> 
> Otherwise, the FCP channel rejects ELS requests with
> FSF_REQUEST_SIZE_TOO_LARGE.
> 
> Such ELS requests can be issued by user space through BSG / HBA API,
> or zfcp itself uses ADISC ELS for remote port link test on RSCN.
> The latter can cause a short path outage due to
> unnecessary remote target port recovery because the always
> failing ADISC cannot detect extremely short path interruptions
> beyond the local FCP channel.
> 
> Below example is decoded with zfcpdbf from s390-tools:
> 
> Timestamp      : ...
> Area           : SAN
> Subarea        : 00
> Level          : 1
> Exception      : -
> CPU id         : ..
> Caller         : zfcp_dbf_san_req+0408
> Record id      : 1
> Tag            : fssels1
> Request id     : 0x<reqid>
> Destination ID : 0x00<target d_id>
> Payload info   : 52000000 00000000 <our wwpn       >           [ADISC]
>                  <our wwnn       > 00<s_id> 00000000
>                  00000000 00000000 00000000 00000000
> 
> Timestamp      : ...
> Area           : HBA
> Subarea        : 00
> Level          : 1
> Exception      : -
> CPU id         : ..
> Caller         : zfcp_dbf_hba_fsf_res+0740
> Record id      : 1
> Tag            : fs_ferr
> Request id     : 0x<reqid>
> Request status : 0x00000010
> FSF cmnd       : 0x0000000b               [FSF_QTCB_SEND_ELS]
> FSF sequence no: 0x...
> FSF issued     : ...
> FSF stat       : 0x00000061		  [FSF_REQUEST_SIZE_TOO_LARGE]
> FSF stat qual  : 00000000 00000000 00000000 00000000
> Prot stat      : 0x00000100
> Prot stat qual : 00000000 00000000 00000000 00000000
> 
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> Fixes: 86a9668a8d29 ("[SCSI] zfcp: support for hardware data router")
> Cc: <stable@vger.kernel.org> # 3.2+
> Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
> ---
>  drivers/s390/scsi/zfcp_fsf.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
