From: Alexey Dobriyan <adobriyan@mail.ru>
Subject: Re: [ANNOUNCE 2/6] Open-iSCSI High-Performance Initiator for Linux
Date: Mon, 7 Mar 2005 12:08:02 +0200
Message-ID: <200503071208.02285.adobriyan@mail.ru>
References: <422BFEC6.70305@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Received: from mx2.mail.ru ([194.67.23.122]:57411 "EHLO mx2.mail.ru")
	by vger.kernel.org with ESMTP id S261716AbVCGJHg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2005 04:07:36 -0500
In-Reply-To: <422BFEC6.70305@yahoo.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex Aizman <itn780@yahoo.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Monday 07 March 2005 09:12, Alex Aizman wrote:
>           Common header files:
>           - iscsi_ifev.h (user/kernel events).
>           - iscsi_if.h (iSCSI open interface over netlink);
>           - iscsi_proto.h (RFC3720 #defines and types);

> --- linux-2.6.11.orig/include/scsi/iscsi_if.h
> +++ linux-2.6.11.dima/include/scsi/iscsi_if.h

> +/**
> + * struct iscsi_transport - down calls
> + *
> + * @name: transport name
> + * @caps: iSCSI Data-Path capabilities
> + * @create_snx: create new iSCSI session object
> + * @destroy_snx: destroy existing iSCSI session object
> + * @create_cnx: create new iSCSI connection
> + * @bind_cnx: associate this connection with existing iSCSI session and
> + *            specified transport descriptor
> + * @destroy_cnx: destroy inactive iSCSI connection
> + * @set_param: set iSCSI Data-Path operational parameter
> + * @start_cnx: set connection to be operational
> + * @stop_cnx: suspend connection
> + * @send_pdu: send iSCSI PDU, Login, Logout, NOP-Out, Reject, Text.
> + *
> + * API provided by generic iSCSI Data Path module
> + */
> +struct iscsi_transport {
> +	char            *name;
> +	unsigned int    caps;
> +	unsigned int    max_cnx;
> +	iscsi_snx_h (*create_session) (iscsi_snx_h cp_snx,
> +			uint32_t initial_cmdsn, uint32_t *sid);
> +	void (*destroy_session) (iscsi_snx_h dp_snx);
> +	iscsi_cnx_h (*create_cnx) (iscsi_snx_h dp_snx, iscsi_cnx_h cp_cnx,
> +			uint32_t cid);
> +	int (*bind_cnx) (iscsi_snx_h dp_snx, iscsi_cnx_h dp_cnx,
> +			uint32_t transport_fd, int is_leading);
> +	int (*start_cnx) (iscsi_cnx_h dp_cnx);
> +	void (*stop_cnx) (iscsi_cnx_h dp_cnx);
> +	void (*destroy_cnx) (iscsi_cnx_h dp_cnx);
> +	int (*set_param) (iscsi_cnx_h dp_cnx, iscsi_param_e param,
> +			  uint32_t value);
> +	int (*send_pdu) (iscsi_cnx_h dp_cnx, struct iscsi_hdr *hdr,
> +			 char *data, uint32_t data_size);
> +};

create_snx		in comment but not in structure
destroy_snx		in comment but not in structure

destroy_session		in structure but not in comment
create_session		in structure but not in comment
max_cnx			in structure but not in comment

	Alexey
