From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 4/5] libata: Report zeroed read after Trim and max discard
 size
Date: Thu, 26 Nov 2009 20:55:18 -0500
Message-ID: <4B0F3186.6000903@teksavvy.com>
References: <1259254843-8326-1-git-send-email-martin.petersen@oracle.com> <1259254843-8326-5-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1259254843-8326-5-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, hch@infradead.org, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
..
> If a storage device supports Trim and the DRAT and RZAT bits are set,
> report TPRZ=1 in Read Capacity(16).
..
> +static inline int ata_id_has_zero_after_trim(const u16 *id)
> +{
> +	/* DSM supported, deterministic read, and read zero after trim set */
> +	if (ata_id_has_trim(id) && id[ATA_ID_ADDITIONAL_SUPP] & 0x4020)
> +		return 1;
..

Is that correct, or should it be this:

        if (ata_id_has_trim(id) && (id[ATA_ID_ADDITIONAL_SUPP] & 0x4020) == 0x4020)

??
