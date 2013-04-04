From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [RFC-v3 9/9] iser-target: Add iSCSI Extensions for RDMA (iSER)
 target driver
Date: Thu, 4 Apr 2013 12:45:57 +0300
Message-ID: <515D4BD5.7020107@mellanox.com>
References: <1365060256-21506-1-git-send-email-nab@linux-iscsi.org> <1365060256-21506-10-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1365060256-21506-10-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Alexander Nezhinsky <alexandern@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On 04/04/2013 10:24, Nicholas A. Bellinger wrote:

> +#define ISER_RECV_DATA_SEG_LEN  8192
> +#define ISER_RX_PAYLOAD_SIZE    (ISER_HEADERS_LEN + ISER_RECV_DATA_SEG_LEN)
> [...]
> +#define ISER_RX_PAD_SIZE	(16384 - (ISER_RX_PAYLOAD_SIZE + \
> +					sizeof(u64) + sizeof(struct ib_sge)))

We're eating here too much ram for the pad, you need 8K + something, so 
the pad can count down
from 12K and not 16K which means each such element will consume three 
pages and not four.

> +struct iser_rx_desc {
> +	struct iser_hdr iser_header;
> +	struct iscsi_hdr iscsi_header;
> +	char		data[ISER_RECV_DATA_SEG_LEN];
> +	u64		dma_addr;
> +	struct ib_sge	rx_sg;
> +	char		pad[ISER_RX_PAD_SIZE];
> +} __packed;
> +
> +struct isert_rx_desc {
> +	struct isert_conn	*desc_conn;
> +	struct work_struct	desc_work;
> +	struct iser_rx_desc	desc;
> +} __packed;

You have way enough room in the pad field of struct iser_rx_desc to 
place there the two fields
added by struct isert_rx_desc (and you only use struct iser_rx_desc from 
within isert_rx_desc) --> any reason
not to unify  them?



Or.
