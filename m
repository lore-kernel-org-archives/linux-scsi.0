From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iscsi-target: Make buf param of
 iscsit_do_crypto_hash_buf() const void *
Date: Fri, 03 May 2013 16:54:33 -0700
Message-ID: <1367625273.21785.4.camel@haakon3.risingtidesystems.com>
References: <1367615757-1447-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:46274 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762313Ab3ECXv7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 May 2013 19:51:59 -0400
In-Reply-To: <1367615757-1447-1-git-send-email-geert@linux-m68k.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2013-05-03 at 23:15 +0200, Geert Uytterhoeven wrote:
> Make the "buf" input param of iscsit_do_crypto_hash_buf() "const void *".
> This allows to remove lots of casts in its callers.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---

Applied to target-pending/queue.

Thanks Geert!

--nab

>  drivers/target/iscsi/iscsi_target.c |   57 ++++++++++++++---------------------
>  1 files changed, 23 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index ffbc6a9..721ecc5 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1250,7 +1250,7 @@ static u32 iscsit_do_crypto_hash_sg(
>  
>  static void iscsit_do_crypto_hash_buf(
>  	struct hash_desc *hash,
> -	unsigned char *buf,
> +	const void *buf,
>  	u32 payload_length,
>  	u32 padding,
>  	u8 *pad_bytes,
> @@ -2524,9 +2524,8 @@ static int iscsit_send_conn_drop_async_message(
>  	if (conn->conn_ops->HeaderDigest) {
>  		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
>  
> -		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
> -				(unsigned char *)hdr, ISCSI_HDR_LEN,
> -				0, NULL, (u8 *)header_digest);
> +		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash, hdr,
> +				ISCSI_HDR_LEN, 0, NULL, (u8 *)header_digest);
>  
>  		cmd->tx_size += ISCSI_CRC_LEN;
>  		pr_debug("Attaching CRC32C HeaderDigest to"
> @@ -2662,9 +2661,8 @@ static int iscsit_send_datain(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
>  	if (conn->conn_ops->HeaderDigest) {
>  		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
>  
> -		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
> -				(unsigned char *)cmd->pdu, ISCSI_HDR_LEN,
> -				0, NULL, (u8 *)header_digest);
> +		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash, cmd->pdu,
> +				ISCSI_HDR_LEN, 0, NULL, (u8 *)header_digest);
>  
>  		iov[0].iov_len += ISCSI_CRC_LEN;
>  		tx_size += ISCSI_CRC_LEN;
> @@ -2841,9 +2839,8 @@ iscsit_send_logout(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
>  	if (conn->conn_ops->HeaderDigest) {
>  		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
>  
> -		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
> -				(unsigned char *)&cmd->pdu[0], ISCSI_HDR_LEN,
> -				0, NULL, (u8 *)header_digest);
> +		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash, &cmd->pdu[0],
> +				ISCSI_HDR_LEN, 0, NULL, (u8 *)header_digest);
>  
>  		iov[0].iov_len += ISCSI_CRC_LEN;
>  		tx_size += ISCSI_CRC_LEN;
> @@ -2900,9 +2897,8 @@ static int iscsit_send_unsolicited_nopin(
>  	if (conn->conn_ops->HeaderDigest) {
>  		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
>  
> -		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
> -				(unsigned char *)hdr, ISCSI_HDR_LEN,
> -				0, NULL, (u8 *)header_digest);
> +		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash, hdr,
> +				ISCSI_HDR_LEN, 0, NULL, (u8 *)header_digest);
>  
>  		tx_size += ISCSI_CRC_LEN;
>  		pr_debug("Attaching CRC32C HeaderDigest to"
> @@ -2949,9 +2945,8 @@ iscsit_send_nopin(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
>  	if (conn->conn_ops->HeaderDigest) {
>  		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
>  
> -		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
> -				(unsigned char *)hdr, ISCSI_HDR_LEN,
> -				0, NULL, (u8 *)header_digest);
> +		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash, hdr,
> +				ISCSI_HDR_LEN, 0, NULL, (u8 *)header_digest);
>  
>  		iov[0].iov_len += ISCSI_CRC_LEN;
>  		tx_size += ISCSI_CRC_LEN;
> @@ -3040,9 +3035,8 @@ static int iscsit_send_r2t(
>  	if (conn->conn_ops->HeaderDigest) {
>  		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
>  
> -		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
> -				(unsigned char *)hdr, ISCSI_HDR_LEN,
> -				0, NULL, (u8 *)header_digest);
> +		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash, hdr,
> +				ISCSI_HDR_LEN, 0, NULL, (u8 *)header_digest);
>  
>  		cmd->iov_misc[0].iov_len += ISCSI_CRC_LEN;
>  		tx_size += ISCSI_CRC_LEN;
> @@ -3256,9 +3250,8 @@ static int iscsit_send_response(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
>  	if (conn->conn_ops->HeaderDigest) {
>  		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
>  
> -		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
> -				(unsigned char *)cmd->pdu, ISCSI_HDR_LEN,
> -				0, NULL, (u8 *)header_digest);
> +		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash, cmd->pdu,
> +				ISCSI_HDR_LEN, 0, NULL, (u8 *)header_digest);
>  
>  		iov[0].iov_len += ISCSI_CRC_LEN;
>  		tx_size += ISCSI_CRC_LEN;
> @@ -3329,9 +3322,8 @@ iscsit_send_task_mgt_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
>  	if (conn->conn_ops->HeaderDigest) {
>  		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
>  
> -		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
> -				(unsigned char *)hdr, ISCSI_HDR_LEN,
> -				0, NULL, (u8 *)header_digest);
> +		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash, hdr,
> +				ISCSI_HDR_LEN, 0, NULL, (u8 *)header_digest);
>  
>  		cmd->iov_misc[0].iov_len += ISCSI_CRC_LEN;
>  		tx_size += ISCSI_CRC_LEN;
> @@ -3504,9 +3496,8 @@ static int iscsit_send_text_rsp(
>  	if (conn->conn_ops->HeaderDigest) {
>  		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
>  
> -		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
> -				(unsigned char *)hdr, ISCSI_HDR_LEN,
> -				0, NULL, (u8 *)header_digest);
> +		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash, hdr,
> +				ISCSI_HDR_LEN, 0, NULL, (u8 *)header_digest);
>  
>  		iov[0].iov_len += ISCSI_CRC_LEN;
>  		tx_size += ISCSI_CRC_LEN;
> @@ -3574,9 +3565,8 @@ static int iscsit_send_reject(
>  	if (conn->conn_ops->HeaderDigest) {
>  		u32 *header_digest = (u32 *)&cmd->pdu[ISCSI_HDR_LEN];
>  
> -		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
> -				(unsigned char *)hdr, ISCSI_HDR_LEN,
> -				0, NULL, (u8 *)header_digest);
> +		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash, hdr,
> +				ISCSI_HDR_LEN, 0, NULL, (u8 *)header_digest);
>  
>  		iov[0].iov_len += ISCSI_CRC_LEN;
>  		tx_size += ISCSI_CRC_LEN;
> @@ -3585,9 +3575,8 @@ static int iscsit_send_reject(
>  	}
>  
>  	if (conn->conn_ops->DataDigest) {
> -		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
> -				(unsigned char *)cmd->buf_ptr, ISCSI_HDR_LEN,
> -				0, NULL, (u8 *)&cmd->data_crc);
> +		iscsit_do_crypto_hash_buf(&conn->conn_tx_hash, cmd->buf_ptr,
> +				ISCSI_HDR_LEN, 0, NULL, (u8 *)&cmd->data_crc);
>  
>  		iov[iov_count].iov_base = &cmd->data_crc;
>  		iov[iov_count++].iov_len  = ISCSI_CRC_LEN;


