From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH net-next] qed*: Utilize FW 8.33.11.0
Date: Mon, 26 Mar 2018 15:18:27 -0600
Message-ID: <20180326211827.GG15554@ziepe.ca>
References: <1522083732-26560-1-git-send-email-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1522083732-26560-1-git-send-email-Michal.Kalderon@cavium.com>
Sender: netdev-owner@vger.kernel.org
To: Michal Kalderon <Michal.Kalderon@cavium.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, Tomer Tayar <Tomer.Tayar@cavium.com>, Manish Rangankar <Manish.Rangankar@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 26, 2018 at 08:02:12PM +0300, Michal Kalderon wrote:
> This FW contains several fixes and features
> 
> RDMA Features
> - SRQ support
> - XRC support
> - Memory window support
> - RDMA low latency queue support
> - RDMA bonding support
> 
> RDMA bug fixes
> - RDMA remote invalidate during retransmit fix
> - iWARP MPA connect interop issue with RTR fix
> - iWARP Legacy DPM support
> - Fix MPA reject flow
> - iWARP error handling
> - RQ WQE validation checks
> 
> MISC
> - Fix some HSI types endianity
> - New Restriction: vlan insertion in core_tx_bd_data can't be set
>   for LB packets
> 
> ETH
> - HW QoS offload support
> - Fix vlan, dcb and sriov flow of VF sending a packet with
>   inband VLAN tag instead of default VLAN
> - Allow GRE version 1 offloads in RX flow
> - Allow VXLAN steering
> 
> iSCSI / FcoE
> - Fix bd availability checking flow
> - Support 256th sge proerly in iscsi/fcoe retransmit
> - Performance improvement
> - Fix handle iSCSI command arrival with AHS and with immediate
> - Fix ipv6 traffic class configuration
> 
> DEBUG
> - Update debug utilities
> 
> Advance version number
> 
> Signed-off-by: Michal Kalderon <Michal.Kalderon@cavium.com>
> Signed-off-by: Tomer Tayar <Tomer.Tayar@cavium.com>
> Signed-off-by: Manish Rangankar <Manish.Rangankar@cavium.com>
> Signed-off-by: Ariel Elior <Ariel.Elior@cavium.com>
>  drivers/infiniband/hw/qedr/main.c                  |    1 +
>  drivers/infiniband/hw/qedr/qedr.h                  |    2 +
>  drivers/infiniband/hw/qedr/qedr_hsi_rdma.h         |    4 +-
>  drivers/infiniband/hw/qedr/verbs.c                 |    4 +-
>  drivers/net/ethernet/qlogic/qed/qed.h              |    2 +-
>  drivers/net/ethernet/qlogic/qed/qed_debug.c        |  415 +++--
>  drivers/net/ethernet/qlogic/qed/qed_dev.c          |    4 +-
>  drivers/net/ethernet/qlogic/qed/qed_hsi.h          | 1892 ++++++++++----------
>  .../net/ethernet/qlogic/qed/qed_init_fw_funcs.c    |  103 +-
>  drivers/net/ethernet/qlogic/qed/qed_iwarp.c        |    7 -
>  drivers/net/ethernet/qlogic/qed/qed_l2.c           |    2 +-
>  drivers/net/ethernet/qlogic/qed/qed_ll2.c          |   13 -
>  drivers/net/ethernet/qlogic/qede/qede.h            |    2 +-
>  drivers/scsi/qedf/qedf_version.h                   |    4 +-
>  drivers/scsi/qedi/qedi_version.h                   |    4 +-
>  include/linux/qed/common_hsi.h                     |    2 +-
>  include/linux/qed/eth_common.h                     |    2 +-
>  include/linux/qed/iscsi_common.h                   |    4 +-
>  include/linux/qed/rdma_common.h                    |    2 +
>  include/linux/qed/roce_common.h                    |    3 +
>  20 files changed, 1319 insertions(+), 1153 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
> index db4bf97..7dbbe6d 100644
> +++ b/drivers/infiniband/hw/qedr/main.c
> @@ -51,6 +51,7 @@
>  MODULE_DESCRIPTION("QLogic 40G/100G ROCE Driver");
>  MODULE_AUTHOR("QLogic Corporation");
>  MODULE_LICENSE("Dual BSD/GPL");
> +MODULE_VERSION(QEDR_MODULE_VERSION);
>  
>  #define QEDR_WQ_MULTIPLIER_DFT	(3)
>  
> diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
> index 86d4511..ab0d411 100644
> +++ b/drivers/infiniband/hw/qedr/qedr.h
> @@ -43,6 +43,8 @@
>  #include "qedr_hsi_rdma.h"
>  
>  #define QEDR_NODE_DESC "QLogic 579xx RoCE HCA"
> +#define QEDR_MODULE_VERSION "8.33.11.20"
> +

I thought we had a general prohibition against versions like this in
mainline drivers? And what does this hunk have to do with supporting
new firmware?

Jason
