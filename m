From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/2] RFC: The be2iscsi driver support for bsg
Date: Thu, 18 Mar 2010 22:58:37 +0900
Message-ID: <20100318225808Z.fujita.tomonori@lab.ntt.co.jp>
References: <20100317180647.GA25863@serverengines.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:56185 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690Ab0CRN7D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Mar 2010 09:59:03 -0400
In-Reply-To: <20100317180647.GA25863@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jayamohank@serverengines.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, michaelc@cs.wisc.edu, open-iscsi@googlegroups.com

On Wed, 17 Mar 2010 23:37:07 +0530
Jayamohan Kallickal <jayamohank@serverengines.com> wrote:

>   This patch contains the necessary changes to support
> the bsg interface
> 
> Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
> ---
>  drivers/scsi/be2iscsi/be_cmds.h  |  137 ++++++++++++++++++++---
>  drivers/scsi/be2iscsi/be_iscsi.c |    3 +-
>  drivers/scsi/be2iscsi/be_main.c  |   99 ++++++++++++++--
>  drivers/scsi/be2iscsi/be_main.h  |    6 +-
>  drivers/scsi/be2iscsi/be_mgmt.c  |  230 +++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/be2iscsi/be_mgmt.h  |  107 ++++++++++++++++++
>  include/scsi/scsi_bsg_iscsi.h    |    1 +
>  7 files changed, 547 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
> index 49fcc78..d5c14cf 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.h
> +++ b/drivers/scsi/be2iscsi/be_cmds.h
> @@ -18,6 +18,7 @@
>  #ifndef BEISCSI_CMDS_H
>  #define BEISCSI_CMDS_H
>  
> +#include <scsi/scsi_bsg_iscsi.h>
>  /**
>   * The driver sends configuration and managements command requests to the
>   * firmware in the BE. These requests are communicated to the processor
> @@ -162,6 +163,13 @@ struct be_mcc_mailbox {
>  #define OPCODE_COMMON_ISCSI_CFG_POST_SGL_PAGES		2
>  #define OPCODE_COMMON_ISCSI_CFG_REMOVE_SGL_PAGES        3
>  #define OPCODE_COMMON_ISCSI_NTWK_GET_NIC_CONFIG		7
> +#define OPCODE_COMMON_ISCSI_NTWK_SET_VLAN		14
> +#define OPCODE_COMMON_ISCSI_NTWK_CONFIGURE_STATELESS_IP_ADDR	17
> +#define OPCODE_COMMON_ISCSI_NTWK_MODIFY_IP_ADDR		21
> +#define OPCODE_COMMON_ISCSI_NTWK_GET_DEFAULT_GATEWAY	22
> +#define OPCODE_COMMON_ISCSI_NTWK_MODIFY_DEFAULT_GATEWAY 23
> +#define OPCODE_COMMON_ISCSI_NTWK_GET_ALL_IF_ID		24
> +#define OPCODE_COMMON_ISCSI_NTWK_GET_IF_INFO		25

So this patchset adds the user-kernel space interface for management
via bsg, right?

Then I have two questions.

- open-iscsi already has the user-kernel space interface for
  management via netlink. Why do you need another via bsg? IOW, why
  can't you do this via the existing netlink interface?

- You invent your hardware specific data structure for the simplest
  operation such as setting IP address. It means that every vendor
  invents their hardware specific data structure for management. Users
  have to use the vendor specific management software or open-iscsi
  management tool (iscsiadm) needs all the vendor specific code to
  build the vendor specific data structure (and parse the response). I
  think that it is exactly what open-iscsi tries to avoid. iscsiadm
  builds the generic management data structure and
  scsi_transport_iscsi.c passes it to the drivers. Then the drivers
  have to handle it. That's the way open-iscsi works now.
