From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH v1 0/3] Include protection information in iscsi header
Date: Tue, 10 Jun 2014 01:10:48 -0700
Message-ID: <1402387848.5774.61.camel@haakon3.risingtidesystems.com>
References: <1402223228-23768-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402223228-23768-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi MKP + Mike + Roland,

On Sun, 2014-06-08 at 13:27 +0300, Sagi Grimberg wrote:
> At the SCSI transport level, there is no distinction between
> user data and protection information. Thus, iscsi header field
> "expected data transfer length" should include protection
> information.
> 
> Patch #1 introduces scsi helpers scsi_transfer_length (compute
> wire transfer byte count) and scsi_prot_len (compute protection
> information byte count).
> 
> Patch #2 modifies iscsi initiator to set correct wire transfer length
> in iscsi header data_length field (and modifies iser accordingly).
> 
> Patch #3 modifies target core to expect protection information included
> in the wire transfer length (and modifies loopback transport to do so).
> 
> I have 2 patches that convert lpfc/qla2xxx drivers to use scsi helpers
> but these are completely untested at the moment. Once we get this set
> to land upstream, I can queue them up as RFCs.
> 
> Changes from v0:
> - Introduce scsi helpers to compute correct transfer length in the
>   presence of protection information (instead of having each transport
>   doing the same computation).
> - Modify iscsi to set correct transfer length using scsi helpers
> - Modify loopback transport to set correct transfer length using
>   scsi helpers
> 
> Sagi Grimberg (3):
>   scsi_cmnd: Introduce scsi_transfer_length helper
>   libiscsi, iser: Adjust data_length to include protection information
>   TARGET/sbc,loopback: Adjust command data length in case pi exists on
>     the wire
> 
>  drivers/infiniband/ulp/iser/iser_initiator.c |   34 ++++++----------------
>  drivers/scsi/libiscsi.c                      |   18 ++++++------
>  drivers/target/loopback/tcm_loop.c           |   15 ++++++++--
>  drivers/target/target_core_sbc.c             |   15 ++++++++-
>  include/scsi/scsi_cmnd.h                     |   39 ++++++++++++++++++++++++++
>  5 files changed, 83 insertions(+), 38 deletions(-)
> 

Please review + ACK this series.

Also, given the nature of the changes, they will need to be included
into v3.15.y code to avoid any potential wire protocol compatibility
issues.

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
