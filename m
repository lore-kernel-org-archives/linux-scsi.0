From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] normalize fixed and descriptor sense data
Date: Fri, 27 Aug 2004 11:45:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412F571A.8040607@adaptec.com>
References: <412EF74A.1070106@torque.net> <20040827161800.A32040@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:57320 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S266273AbUH0Ppg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Aug 2004 11:45:36 -0400
In-Reply-To: <20040827161800.A32040@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> 
> +struct scsi_sense_hd {     /* See SPC-3 section 4.5 */
> 
> maybe scsi_sense_desc insted?

Why, when it's neither in descriptor format nor in fixed
format?

It is just a header of the _consolidated_ format
of the sense data, thus the name used makes sense.
 
> +    uint8_t response_code; /* permit: 0x0, 0x70, 0x71, 0x72, 0x73 */
> +    uint8_t sense_key;
> +    uint8_t asc;
> +    uint8_t ascq;
> +    uint8_t byte4;
> +    uint8_t byte5;
> +    uint8_t byte6;
> +    uint8_t additional_length; /* always 0 for fixed sense format */
> 
> We use u8 elsewhere in the scsi code, please stay consistant.
> 
> +static inline int scsi_sense_is_deferred(struct scsi_sense_hd * sshd)
> +{
> +       return (sshd && (sshd->response_code >= 0x70) &&
> +               (sshd->response_code & 1)) ? 1 : 0;
> +}
> 
> I don't think we need the NULL check for sshd here, do we?
> 
> +/**
> + *     scsi_normalize_sense - normalize main elements from either fixed
> + *             or descriptor sense data format into a common format.
> + *     @sense_buffer:  byte array containing sense data returned by
> + *                     device
> + *     @sb_len:        number of valid bytes in sense_buffer
> + *     @sshd:          pointer to instance of structure that common
> + *                     elements are written to. Ignored if NULL.
> + *
> + *     The "main elements" from sense data are: response_code, sense_key,
> + *     asc, ascq and additional_length (only for descriptor format).
> + *     Typically this function can be called after a device has
> + *     responded to a SCSI command with the CHECK_CONDITION status.
> + *
> + *     Returns 1 if valid sense data information found, else 0;
> + **/
> +int scsi_normalize_sense(const uint8_t * sense_buffer, int sb_len,
> +                         struct scsi_sense_hd * sshd)
> +{
> +       if (sshd)
> +               memset(sshd, 0, sizeof(struct scsi_sense_hd));
> 
> Again, checking for a NULL sshd here doesn't make much sense.
> 
> Also I think this function should get a __ prefix and we should
> add two small helpers that take a scsi_cmnd/scsi_request and use
> the sense_buffer and len from it.

But it should be exported nevertheless, as LLDDs may like
to use it.

		Luben

 
> +       if ((NULL == sense_buffer) || (0 == sb_len) ||
> +           (0x70 != (0x70 & sense_buffer[0])))
> +               return 0;
> +       if (NULL == sshd)
> +               return 1;
> 
> Wrong way around vs normal scsi style.  Should be more like:
> 
>         if (!sense_buffer || !sb_len || (0x70 & sense_buffer[0]) != 0x70)
>                 return 0;
> 
> (and the sshd check gone again)
> (same issues come up below again a few times)
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

