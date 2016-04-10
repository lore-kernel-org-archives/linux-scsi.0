From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 03/16] iscsi-target: add int
 (*iscsit_xmit_datain_pdu)()
Date: Sun, 10 Apr 2016 20:38:03 +0300
Message-ID: <570A8F7B.30701@grimberg.me>
References: <cover.1460204441.git.varun@chelsio.com>
 <9cf062fac7d7501001cd9cdf6b29db59314dc086.1460204441.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <9cf062fac7d7501001cd9cdf6b29db59314dc086.1460204441.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com
List-Id: linux-scsi@vger.kernel.org



On 09/04/16 16:11, Varun Prakash wrote:
> Add int (*iscsit_xmit_datain_pdu)() to
> struct iscsit_transport, iscsi-target
> uses this callback to transmit a DATAIN
> iSCSI PDU.
>
> Signed-off-by: Varun Prakash <varun@chelsio.com>
> ---
>   drivers/target/iscsi/iscsi_target.c    | 143 +++++++++++++++++++--------------
>   include/target/iscsi/iscsi_transport.h |   3 +
>   2 files changed, 86 insertions(+), 60 deletions(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 0e7a481..9e65e5d 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -577,6 +577,84 @@ static int iscsit_xmit_pdu(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
>   	return 0;
>   }
>
> +static int iscsit_map_iovec(struct iscsi_cmd *, struct kvec *, u32, u32);
> +static void iscsit_unmap_iovec(struct iscsi_cmd *);
> +static u32 iscsit_do_crypto_hash_sg(struct ahash_request *, struct iscsi_cmd *,
> +				    u32, u32, u32, u8 *);
> +static int
> +iscsit_xmit_datain_pdu(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
> +		       struct iscsi_datain_req *dr, struct iscsi_datain *datain)

Looks very similar to xmit_pdu(), if we add a datain pointer that
can be null for normal pdus would that reduce code duplication?
