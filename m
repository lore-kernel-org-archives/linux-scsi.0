Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C80A24BBE4
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 21:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753480493; cv=none; b=gMPwkWACneL6yUn3jcJwi5laKxfUaf07PCKFGqdSpqJF+BtD9mihXDOHzso9AV4kNsEB3RHerdV787wgPO1NJ+vMZUVemRKgX1xU3+z4wVTduX1n8FlTX+MFo0nzcORf2vytH2BBpdcCrX3iQi9LaXfIZVlxeZLxGeEQECf8Euw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753480493; c=relaxed/simple;
	bh=Jj4thAT3rKI+hQiCFysInR9WmUyn8EPwQ9gN/rJCNok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KpA15CfHz8afxoEn6E5YGBlqWsonIimYZ12e/jZwExLeMEmKO0WTlg2q1gPMfQBbcUy+VbkgmSVMoI6xe4DVRhYnCvOx/h5VM8GwyCKcfd5MTplPmdAlY5+O+bqOfYvrBbWDW6fLHhKMNzC7z4iGLS2HCcELPeGEmexZctGgMjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TuXofK70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TuXofK70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9E2C4CEE7;
	Fri, 25 Jul 2025 21:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753480492;
	bh=Jj4thAT3rKI+hQiCFysInR9WmUyn8EPwQ9gN/rJCNok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TuXofK70NEKKG4dDs/1Y1kbQm/YIo1qUo3kGR7kh7W7mNYXFsOwZGkuNyAbcNOjcy
	 g/Df/mcnXCFn/jX+zFAj1z6Qk5GP5/gMoXtmX3fbO9+uQoLb+cMrkdujDxxFD5UWL7
	 bRNMreJm5138cMwZnlLoOQvcDXaTgGwlDJIkBcHs+r4DVXInClW00Og09oW9FDR9UE
	 4Mcqgk/0F2PnfmXnEQi4qbuR3oDzUCFx/eEJoYm4u8IGqnknAGCdv/sn1hlsqC4LrV
	 PCaAE15ZVjDf2KC3nLgnRUi61f4a6QmiQr1UfCIxmqCx7WYbQLch/fAjTP0/ECuEC3
	 CRRipIfz8R9zA==
Date: Fri, 25 Jul 2025 14:54:51 -0700
From: Kees Cook <kees@kernel.org>
To: Chris Leech <cleech@redhat.com>
Cc: linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Bryan Gurney <bgurney@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>
Subject: Re: [PATCH 1/2] scsi: qla2xxx: replace non-standard flexible array
 purex_item.iocb
Message-ID: <202507251433.948F1E0@keescook>
References: <20250725212732.2038027-1-cleech@redhat.com>
 <20250725212732.2038027-2-cleech@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250725212732.2038027-2-cleech@redhat.com>

On Fri, Jul 25, 2025 at 02:27:31PM -0700, Chris Leech wrote:
> This is defined as a 64-element u8 array, but 64 is the minimum size and
> it can be allocated larger. I don't know why the array was wrapped as a
> single element struct of the same name.
> 
> Replace with a union around DECLARE_FLEX_ARRAY and padding to maintain
> sizeof(struct purex_item) and associated use.
> 
> This was triggering a field-spanning write warning during FPIN testing
> https://lore.kernel.org/linux-nvme/20250709211919.49100-1-bgurney@redhat.com/
> 
>   >  kernel: memcpy: detected field-spanning write (size 60) of single field
>   >  "((uint8_t *)fpin_pkt + buffer_copy_offset)"
>   >  at drivers/scsi/qla2xxx/qla_isr.c:1221 (size 44)

I think this is:

                                memcpy(((uint8_t *)fpin_pkt +
                                    buffer_copy_offset), new_pkt->data,
                                    no_bytes);

I was briefly confused since fpin_pkt is "void *", but I see the
bounds information comes from this assignment: 

        item = qla24xx_alloc_purex_item(vha, total_bytes);
        if (!item)
                return item;

        fpin_pkt = &item->iocb;

> Tested-by: Bryan Gurney <bgurney@redhat.com>
> Signed-off-by: Chris Leech <cleech@redhat.com>
> ---
>  drivers/scsi/qla2xxx/qla_def.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index cb95b7b12051d..6237fefeca149 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -4890,8 +4890,9 @@ struct purex_item {
>  			     struct purex_item *pkt);
>  	atomic_t in_use;
>  	uint16_t size;
> -	struct {
> -		uint8_t iocb[64];
> +	union {
> +		uint8_t __padding[QLA_DEFAULT_PAYLOAD_SIZE];
> +		DECLARE_FLEX_ARRAY(uint8_t, iocb);
>  	} iocb;
>  };

This won't work, unfortunately, as it seems struct purex_item
is embedded into struct scsi_qla_host. (i.e. try building with
KCFLAGS="-Wflex-array-member-not-at-end" and you should see a warning.)

Maybe qla24xx_alloc_purex_item() could return a union type like:

union purex_item_payload
{
	struct purex_item item;
	struct {
		uint8_t __padding[sizeof(struct purex_item) - 64];
		DECLARE_FLEX_ARRAY(uint8_t, iocb);
	};
};

And refactor the handful of callers? In this particular case:


diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index fe98c76e9be3..1b3d96d623c1 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1158,7 +1158,7 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 	uint16_t no_bytes = 0, total_bytes = 0, pending_bytes = 0;
 	uint16_t buffer_copy_offset = 0;
 	uint16_t entry_count, entry_count_remaining;
-	struct purex_item *item;
+	struct purex_item_blob *blob;
 	void *fpin_pkt = NULL;
 
 	total_bytes = (le16_to_cpu(purex->frame_size) & 0x0FFF)
@@ -1171,11 +1171,11 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 	       "FPIN ELS, frame_size 0x%x, entry count %d\n",
 	       total_bytes, entry_count);
 
-	item = qla24xx_alloc_purex_item(vha, total_bytes);
-	if (!item)
-		return item;
+	blob = qla24xx_alloc_purex_item(vha, total_bytes);
+	if (!blob)
+		return NULL;
 
-	fpin_pkt = &item->iocb;
+	fpin_pkt = blob->iocb;
 
 	memcpy(fpin_pkt, &purex->els_frame_payload[0], no_bytes);
 	buffer_copy_offset += no_bytes;
@@ -1238,12 +1238,12 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 			ql_log(ql_log_fatal, vha, 0x508b,
 			       "Dropping partial FPIN, underrun bytes = 0x%x, entry cnts 0x%x\n",
 			       total_bytes, entry_count_remaining);
-			qla24xx_free_purex_item(item);
+			qla24xx_free_purex_item(blob->item);
 			return NULL;
 		}
 	} while (entry_count_remaining > 0);
-	host_to_fcp_swap((uint8_t *)&item->iocb, total_bytes);
-	return item;
+	host_to_fcp_swap((uint8_t *)&blob->iocb, total_bytes);
+	return blob->item;
 }
 
 /**




-- 
Kees Cook
